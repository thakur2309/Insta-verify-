#!/bin/bash

echo -e "\e[92m Installing  packages...\e[0m"
pkg update && pkg upgrade
pkg install -y  php curl

# Installing Cloudflared if not installed
if ! command -v cloudflared &>/dev/null; then
    echo "Installing Cloudflared..."
    pkg install -y cloudflared
fi

# Installing OpenSSH if not installed
if ! command -v ssh &>/dev/null; then
    echo "Installing OpenSSH..."
    pkg install -y openssh
fi

echo -e "\e[92mAll  packages are installed!"

bash instadump.sh