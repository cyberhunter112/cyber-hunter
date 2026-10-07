#!/bin/bash
# CYBER-HUNTER v3.0
# Author: Ahmad Mustapha Aliyu - github.com/cyberhunter112
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'
print_banner() {
echo -e "${CYAN}"
cat << "BANNER"
____ ____ _ _ _ _ _ _ _____ _____ ____
/ ___|| __ ) | | | | | | | \ | |_ _| ____| _ \
| | | _ \ | |_| | | | | \| | | | | _| | |_) |
| |___ | |_) | | _ | |_| | |\ | | | | |___| _ <
\____||____/ |_| |_|\___/|_| \_| |_| |_____|_| \_\
v3.0 by Ahmad Mustapha Aliyu | github.com/cyberhunter112
BANNER
echo -e "${NC}"
}
show_help() {
print_banner
echo -e "${YELLOW}Usage:${NC}"
echo -e "./cyber-hunter.sh [IP] [options]"
echo -e "./cyber-hunter.sh 192.168.177.2"
echo -e "./cyber-hunter.sh --help"
echo -e "\n${YELLOW}Options:${NC}"
echo -e " --help Show this help menu"
echo -e " --quick Quick ping sweep only"
echo -e " --full Full nmap scan"
}
scan_ports() {
local ip=$1
echo -e "${YELLOW}[*] Scanning common ports on $ip...${NC}"
for port in 22 80 443 445 8080; do
timeout 1 bash -c "echo > /dev/tcp/$ip/$port" 2>/dev/null && \
echo -e "${GREEN}[OPEN] $ip:$port${NC}" || \
echo -e "${RED}[CLOSED] $ip:$port${NC}"
done
}
print_banner
if [[ "$1" == "--help" || "$1" == "-h" ]]; then
show_help
exit 0
fi
TARGET=${1:-"192.168.177.0/24"}
MODE=${2:-"quick"}
echo -e "${CYAN}[*] Target: $TARGET | Mode: $MODE${NC}"
> alive.txt
if [[ $TARGET =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
echo -e "${YELLOW}[*] Single IP mode: $TARGET${NC}"
ping -c 1 -W 1 $TARGET &>/dev/null && {
echo -e "${GREEN}[ALIVE] $TARGET${NC}"
echo "$TARGET" >> alive.txt
scan_ports $TARGET
if [[ $MODE == "--full" && $(command -v nmap &>/dev/null; echo $?) -eq 0 ]]; then
nmap -F $TARGET
fi
} || echo -e "${RED}[DEAD] $TARGET${NC}"
else
BASE=$(echo $TARGET | cut -d'/' -f1 | cut -d'.' -f1-3)
for i in {1..254}; do
IP="$BASE.$i"
ping -c 1 -W 1 $IP &>/dev/null && {
echo -e "${GREEN}[ALIVE] $IP${NC}"
echo "$IP" >> alive.txt
scan_ports $IP
}&
if [[ $(jobs -r | wc -l) -ge 20 ]]; then wait -n; fi
done
wait
fi
echo -e "\n${GREEN}[+] Scan complete! Saved to alive.txt${NC}"
echo -e "${CYAN}Built by Ahmad Mustapha Aliyu${NC}"
