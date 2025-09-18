#!/usr/bin/env bash
set -euo pipefail

echo "=== Updating package lists ==="
sudo apt update

# Helper function to check if a package is installed
is_installed() {
    dpkg -s "$1" &> /dev/null
}

# ----------------------------
# Brave
# ----------------------------

curl -fsS https://dl.brave.com/install.sh | sh

# ----------------------------
# Spotify
# ----------------------------
if ! is_installed spotify-client; then
    echo "=== Installing Spotify ==="
    curl -sS https://download.spotify.com/debian/pubkey_C85668DF69375001.gpg | sudo gpg --dearmor --yes -o /etc/apt/trusted.gpg.d/spotify.gpg
    echo "deb https://repository.spotify.com stable non-free" | sudo tee /etc/apt/sources.list.d/spotify.list    
    sudo apt update
    sudo apt install -y spotify-client
else
    echo "Spotify already installed, skipping."
fi

# ----------------------------
# Mullvad VPN
# ----------------------------
if ! is_installed mullvad-vpn; then
    echo "=== Installing Mullvad VPN ==="
    sudo curl -fsSLo /usr/share/keyrings/mullvad-keyring.asc https://repository.mullvad.net/deb/mullvad-keyring.asc
    echo "deb [signed-by=/usr/share/keyrings/mullvad-keyring.asc] https://repository.mullvad.net/deb/stable stable main" | sudo tee /etc/apt/sources.list.d/mullvad.list
    sudo apt update
    sudo apt install -y mullvad-vpn
else
    echo "Mullvad VPN already installed, skipping."
fi

# ----------------------------
# Steam
# ----------------------------


# ----------------------------
# Jellyfin Media Player (build from source)
# ----------------------------

# ----------------------------
# Tailscale
# ----------------------------

if ! is_installed tailscale; then
    echo "=== Installing Tailscale ==="
    curl -fsSL https://tailscale.com/install.sh | sh
    sudo tailscale up
else
    echo "Tailscale already installed, skipping."
fi

echo "=== All programs installed successfully! ==="

# ----------------------------
# Micro
# ----------------------------

(cd ~/.local/bin && curl -s https://getmic.ro | bash)
