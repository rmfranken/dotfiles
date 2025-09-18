#!/usr/bin/env bash
set -euo pipefail

echo "=== Updating package lists ==="
sudo apt update

# Helper function to check if a package is installed
is_installed() {
    dpkg -s "$1" &> /dev/null
}

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
if ! is_installed steam; then
    echo "=== Installing Steam ==="
    # Download the Steam .deb package
    curl -o ~/Downloads/steam.deb https://cdn.fastly.steamstatic.com/client/installer/steam.deb

    # Install the downloaded .deb package
    sudo dpkg -i ~/Downloads/steam.deb
    sudo apt-get install -f -y  # Fix dependencies if needed
else
    echo "Steam already installed, skipping."
fi

# ----------------------------
# Jellyfin Media Player (build from source)
# ----------------------------



# JMP_DIR="$HOME/jmp"
# JMP_REPO="https://github.com/jellyfin/jellyfin-media-player.git"
# JMP_BUILD="$JMP_DIR/jellyfin-media-player/build"

# if ! command -v jellyfin-media-player >/dev/null 2>&1; then
#     echo "=== Installing Jellyfin Media Player ==="

#     sudo apt install -y mpv libmpv-dev    
#     export PKG_CONFIG_PATH=/usr/local/lib/pkgconfig:$PKG_CONFIG_PATH               
#     export LD_LIBRARY_PATH=/usr/local/lib:$LD_LIBRARY_PATH
    
#     mkdir ~/jmp; cd ~/jmp                                                          
#     git clone https://github.com/mpv-player/mpv-build.git
#     cd mpv-build
#     ./use-mpv-release
#     ./update
#     echo -Dlibmpv=true > mpv_options
#     ./rebuild -j`nproc`
#     sudo ./install
#     sudo ln -s /usr/local/lib/x86_64-linux-gnu/libmpv.so /usr/local/lib/x86_64-linux-gnu/libmpv.so.1
#     sudo ln -sf /usr/local/lib/x86_64-linux-gnu/libmpv.so /usr/local/lib/libmpv.so.2
#     sudo ldconfig
#     cd ~/jmp/
#     git clone https://github.com/jellyfin/jellyfin-media-player.git
#     cd jellyfin-media-player
#     mkdir build
#     cd build
#     cmake -DCMAKE_BUILD_TYPE=Debug -DCMAKE_INSTALL_PREFIX=/usr/local/ -G Ninja ..
#     ninja
#     sudo ninja install
#     rm -rf ~/jmp/

# else
#     echo "Jellyfin Media Player already installed, skipping."
# fi

# ----------------------------
#tailscale
# ----------------------------

if ! is_installed tailscale; then
    echo "=== Installing Tailscale ==="
    curl -fsSL https://tailscale.com/install.sh | sh
    sudo tailscale up
else
    echo "Tailscale already installed, skipping."
fi

echo "=== All programs installed successfully! ==="
