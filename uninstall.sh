#!/bin/bash

# Uninstall the WireGuard TUI for Omarchy.

set -e

BIN_DIR="$HOME/.local/share/omarchy/bin"
BINDINGS_FILE="$HOME/.config/hypr/bindings.conf"

echo "Uninstalling WireGuard TUI for Omarchy..."
echo ""

# --- Remove scripts ----------------------------------------------------------

echo "Removing scripts..."
rm -f "$BIN_DIR/omarchy-wireguard"
rm -f "$BIN_DIR/omarchy-launch-wireguard"
echo "Scripts removed."

# --- Remove keybinding -------------------------------------------------------

if [[ -f $BINDINGS_FILE ]] && grep -qF "omarchy-launch-wireguard" "$BINDINGS_FILE"; then
  echo "Removing keybinding..."
  sed -i '/omarchy-launch-wireguard/d' "$BINDINGS_FILE"
  echo "Keybinding removed."
fi

# --- Remove sudoers rule -----------------------------------------------------

if [[ -f /etc/sudoers.d/wireguard ]]; then
  echo "Removing sudoers rule..."
  sudo rm -f /etc/sudoers.d/wireguard
  echo "Sudoers rule removed."
fi

# --- Reload Hyprland ---------------------------------------------------------

if command -v hyprctl &>/dev/null; then
  echo "Reloading Hyprland..."
  hyprctl reload >/dev/null 2>&1 || true
fi

# --- Done --------------------------------------------------------------------

echo ""
echo "Uninstall complete!"
echo ""
echo "Note: wireguard-tools, python-textual, and your VPN configs"
echo "in /etc/wireguard/ were kept. Remove them manually if needed:"
echo "  sudo pacman -R wireguard-tools python-textual"
echo "  sudo rm /etc/wireguard/*.conf"
