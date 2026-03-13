#!/bin/bash

# Install the WireGuard TUI for Omarchy.
# https://github.com/kleintonno/omarchy-wireguard

set -e

REPO_DIR="$(cd "$(dirname "$0")" && pwd)"
BIN_DIR="$HOME/.local/share/omarchy/bin"
BINDINGS_FILE="$HOME/.config/hypr/bindings.conf"
KEYBINDING='bindd = SUPER CTRL, G, WireGuard VPN, exec, omarchy-launch-wireguard'

echo "Installing WireGuard TUI for Omarchy..."
echo ""

# --- Dependencies -----------------------------------------------------------

echo "Checking dependencies..."

if ! command -v wg &>/dev/null; then
  echo "Installing wireguard-tools..."
  sudo pacman -S --noconfirm --needed wireguard-tools
fi

if ! python3 -c "import textual" &>/dev/null; then
  echo "Installing python-textual..."
  sudo pacman -S --noconfirm --needed python-textual
fi

echo "Dependencies OK."
echo ""

# --- Install scripts ---------------------------------------------------------

echo "Installing scripts to $BIN_DIR..."

cp "$REPO_DIR/bin/omarchy-wireguard" "$BIN_DIR/omarchy-wireguard"
cp "$REPO_DIR/bin/omarchy-launch-wireguard" "$BIN_DIR/omarchy-launch-wireguard"
chmod +x "$BIN_DIR/omarchy-wireguard" "$BIN_DIR/omarchy-launch-wireguard"

echo "Scripts installed."
echo ""

# --- Sudoers (passwordless wg/wg-quick) -------------------------------------

if [[ ! -f /etc/sudoers.d/wireguard ]]; then
  echo "Setting up passwordless access for wg and wg-quick..."
  echo "%wheel ALL=(ALL) NOPASSWD: /usr/bin/wg, /usr/bin/wg-quick" | sudo tee /etc/sudoers.d/wireguard >/dev/null
  sudo chmod 440 /etc/sudoers.d/wireguard
  echo "Sudoers rule created."
else
  echo "Sudoers rule already exists, skipping."
fi
echo ""

# --- Make /etc/wireguard listable for wheel ----------------------------------

if [[ -d /etc/wireguard ]]; then
  echo "Making /etc/wireguard listable for wheel group..."
  sudo chgrp wheel /etc/wireguard
  sudo chmod 750 /etc/wireguard
else
  echo "Creating /etc/wireguard..."
  sudo mkdir -p /etc/wireguard
  sudo chgrp wheel /etc/wireguard
  sudo chmod 750 /etc/wireguard
fi
echo ""

# --- Keybinding --------------------------------------------------------------

if [[ -f $BINDINGS_FILE ]]; then
  if ! grep -qF "omarchy-launch-wireguard" "$BINDINGS_FILE"; then
    echo "Adding keybinding (Super+Ctrl+G) to $BINDINGS_FILE..."
    # Insert before the "Add extra bindings" comment if it exists, otherwise append
    if grep -qF "# Add extra bindings" "$BINDINGS_FILE"; then
      sed -i "/# Add extra bindings/a $KEYBINDING" "$BINDINGS_FILE"
    else
      echo "" >> "$BINDINGS_FILE"
      echo "# WireGuard VPN" >> "$BINDINGS_FILE"
      echo "$KEYBINDING" >> "$BINDINGS_FILE"
    fi
    echo "Keybinding added."
  else
    echo "Keybinding already exists, skipping."
  fi
else
  echo "Warning: $BINDINGS_FILE not found. Add this keybinding manually:"
  echo "  $KEYBINDING"
fi
echo ""

# --- Reload Hyprland ---------------------------------------------------------

if command -v hyprctl &>/dev/null; then
  echo "Reloading Hyprland..."
  hyprctl reload >/dev/null 2>&1 || true
fi

# --- Done --------------------------------------------------------------------

echo "Installation complete!"
echo ""
echo "Usage:"
echo "  Super+Ctrl+G    Open WireGuard TUI"
echo "  omarchy-wireguard    Run directly from terminal"
echo ""
echo "Add your VPN configs to /etc/wireguard/:"
echo "  sudo cp your-vpn.conf /etc/wireguard/"
echo "  sudo chmod 600 /etc/wireguard/your-vpn.conf"
