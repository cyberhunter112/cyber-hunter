#!/bin/bash
# ===== COLORS =====
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color
show_banner() {
echo -e "${CYAN}=============================${NC}"
echo -e "${CYAN} CYBER-HUNTER v2.0${NC}"
echo -e "${CYAN} By AHMAD MUSTAPHA ALIYU${NC}"
echo -e "${CYAN}=============================${NC}"
echo -e "${YELLOW}1)${NC} Ping a single host"
echo -e "${YELLOW}2)${NC} Ping sweep 1-254"
echo -e "${YELLOW}3)${NC} Quick Port Scan"
echo -e "${YELLOW}4)${NC} View alive hosts log"
echo -e "${YELLOW}5)${NC} Exit"
echo ""
}
single_ping() {
read -p "Enter IP: " ip
echo -e "${YELLOW}[*] Scanning $ip...${NC}"
ping -c 1 -W 1 $ip &> /dev/null
if [ $? -eq 0 ]; then
echo -e "${GREEN}[+] $ip is ALIVE${NC} - saved"
echo "$(date) - $ip ALIVE" >> alive.txt
else
echo -e "${RED}[-] $ip is DEAD${NC}"
fi
}
sweep() {
read -p "Enter network prefix (e.g., 192.168.177.): " net
read -p "How many hosts to scan [default 20]: " count
count=${count:-20}
> alive.txt
echo -e "${YELLOW}[*] Sweeping ${net}1-${count}...${NC}"
for i in $(seq 1 $count); do
ip=${net}${i}
ping -c 1 -W 1 $ip &> /dev/null
if [ $? -eq 0 ]; then
echo -e "${GREEN}[+] $ip is ALIVE${NC}"
echo "$(date) - $ip ALIVE" >> alive.txt
else
echo -e "${RED}[-] $ip is DOWN${NC}"
fi
done
echo -e "${CYAN}Done! Results saved in alive.txt${NC}"
}
port_scan() {
read -p "Enter target IP: " ip
echo -e "${YELLOW}[*] Quick port scan on $ip (22,80,443,445)${NC}"
for port in 22 80 443 445 8080; do
timeout 1 bash -c "echo > /dev/tcp/$ip/$port" 2>/dev/null
if [ $? -eq 0 ]; then
echo -e "${GREEN}[+] Port $port OPEN on $ip${NC}"
else
echo -e "${RED}[-] Port $port CLOSED${NC}"
fi
done
}
# ===== ARGUMENT MODE =====
# Allows: ./cyber-hunter-v1.sh 192.168.177.2
if [ ! -z $1 ]; then
target=$1
echo -e "${YELLOW}[*] Quick scan mode for $target${NC}"
ping -c 1 -W 1 $target &> /dev/null
if [ $? -eq 0 ]; then
echo -e "${GREEN}[+] $target ALIVE${NC}"
port_scan_auto() {
for port in 22 80 443; do
(echo > /dev/tcp/$target/$port) &>/dev/null
if [ $? -eq 0 ]; then
 echo -e "${GREEN}Port $port OPEN${NC}"
else
echo -e "${RED}Port $port CLOSED${NC}"
fi
done
}
port_scan_auto
else
echo -e "${RED}[-] $target DEAD${NC}"
fi
exit 0
fi
# ===== MAIN LOOP =====
while true; do
show_banner
read -p "Choose [1-5]: " choice
case $choice in
1) single_ping ;;
2) sweep ;;
3) port_scan ;;
4) echo -e "${CYAN}--- alive.txt ---${NC}"; cat alive.txt 2>/dev/null || echo "No log yet" ;;
5) echo -e "${GREEN}Happy Hacking, Ahmad!${NC}"; break ;;
*) echo -e "${RED}Invalid!${NC}" ;;
esac
echo ""
read -p "Press Enter to continue..."
clear
done
