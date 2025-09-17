#!/bin/bash
set -euo pipefail

echo "[chezmoi] Configuring GNOME keybindings and CapsLock remap..."

# CapsLock → Escape, Shift+CapsLock → real CapsLock
gsettings set org.gnome.desktop.input-sources xkb-options "['caps:escape_shifted_capslock']"

# Define custom keybinding paths (must match the schema)
path0='/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/'
path1='/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/'

# Register the custom keybindings list
gsettings set org.gnome.settings-daemon.plugins.media-keys custom-keybindings "['$path0','$path1']"

# Super+E → Files
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:$path0 name 'Open File Manager'
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:$path0 command 'nautilus --new-window'
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:$path0 binding '<Super>e'

# Ctrl+` → Terminal
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:$path1 name 'Open Terminal'
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:$path1 command 'gnome-terminal --window'
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:$path1 binding '<Control>grave'

echo "[chezmoi] Keybindings configured successfully."
