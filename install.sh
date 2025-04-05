#!/bin/bash

echo "Installing required packages..."
pkg install -y figlet lolcat

# Installing Ngrok if not installed
if ! command -v ngrok &>/dev/null; then
    echo "Installing Ngrok..."
    curl -s https://bin.equinox.io/c/4VmDzA7iaHb/ngrok-stable-linux-arm.zip -o ngrok.zip
    unzip ngrok.zip
    chmod +x ngrok
    mv ngrok $PREFIX/bin/
    rm ngrok.zip
fi

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

echo "All required packages are installed!"
