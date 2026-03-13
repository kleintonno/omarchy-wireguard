# WireGuard TUI for Omarchy

A terminal user interface for managing WireGuard VPN connections on [Omarchy](https://github.com/nichochar/omarchy). Built with [Textual](https://github.com/Textualize/textual), integrates natively with Omarchy's keybindings and launcher system.

## Features

- Browse and switch between WireGuard profiles
- Auto-detects configs from `/etc/wireguard/`
- Live connection status with endpoint, handshake, and transfer stats
- Auto-refresh every 2 seconds
- Passwordless operation (no sudo prompts)
- Hyprland keybinding (`Super+Ctrl+G`)
- Single-instance window management (like Omarchy's Wi-Fi TUI)

## Prerequisites

- [Omarchy](https://github.com/nichochar/omarchy) installed and running
- WireGuard `.conf` files in `/etc/wireguard/`

## Install

```bash
git clone https://github.com/kleintonno/omarchy-wireguard.git
cd omarchy-wireguard
./install.sh
```

The installer handles everything:
- Installs `wireguard-tools` and `python-textual` if missing
- Copies the TUI scripts to `~/.local/share/omarchy/bin/`
- Sets up passwordless sudo for `wg` and `wg-quick`
- Adds the `Super+Ctrl+G` keybinding
- Reloads Hyprland

## Uninstall

```bash
./uninstall.sh
```

## Usage

Press `Super+Ctrl+G` or run from terminal:

```bash
omarchy-wireguard
```

### Keybindings

| Key | Action |
|-----|--------|
| `c` | Connect to selected profile |
| `d` | Disconnect active tunnel |
| `s` | Refresh status |
| `r` | Refresh profile list |
| `q` | Quit |
| `Enter` | Quick connect |

## Adding VPN Profiles

```bash
sudo cp your-vpn.conf /etc/wireguard/
sudo chmod 600 /etc/wireguard/your-vpn.conf
```

The TUI picks them up automatically.

## License

MIT
