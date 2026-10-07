#!/bin/bash
# Cyber-Hunter v4.0 ULTIMATE
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'
STEALTH=false
FAST=false
HTML_REPORT="report.html"
for arg in "$@"; do
[[ $arg == "--stealth" ]] && STEALTH=true
[[ $arg == "--fast" ]] && FAST=true
done
TARGET=$1
if [[ -z "$TARGET" || $TARGET == --* ]]; then
echo -e "${YELLOW}Usage: ./cyber-hunter.sh [--fast] [--stealth]${NC}"
echo "Examples:"
echo " ./cyber-hunter.sh 192.168.169.1"
echo " ./cyber-hunter.sh 192.168.169.1 --fast --stealth"
exit 1
fi
echo -e "${GREEN}"
echo " ____ _ _ _ _ "
echo " | _ \ _ | |__ ___ _ __| | | |_ _ _ __ |_ ___ _ __ "
echo " | | | || | | '_ \ / _ \ '__| |_| | | | | '_ \| __/ _ \ '__|"
echo " | |_| |_| | |_) | __/ | | _ | |_| | | | | || __/ | "
echo " |____\__, |_.__/ \___|_| |_| |_|\__,_|_| |_|\__\___|_| "
echo " |___/ v4.0 ULTIMATE - VERSION "
echo -e "${NC}"
> alive.txt
> $HTML_REPORT
echo "
Report for $TARGET - $(date)
" >> $HTML_REPORT
scan_port() {
local ip=$1
local port=$2
timeout 1 bash -c "echo > /dev/tcp/$ip/$port" 2>/dev/null
if [ $? -eq 0 ]; then
# 2. BANNER GRABBING
banner=$(timeout 2 bash -c "exec 3<>/dev/tcp/$ip/$port; echo -e '\n' >&3; cat <&3" 2>/dev/null | head -n 1 | tr -d '\r\n' | cut -c1-60)
[ -z "$banner" ] && banner="No banner"
# 4. HTTP CHECK
http_info=""
if [[ $port == 80 || $port == 8080 || $port == 8443 || $port == 443 ]]; then
title=$(curl -s --connect-timeout 2 http://$ip:$port 2>/dev/null | grep -i -o "" | sed 's/<[^>]*>//g' | cut -c1-40)
[ ! -z "$title" ] && http_info=" | Title: $title"
fi
echo -e "${GREEN}[OPEN] $ip:$port - $banner$http_info${NC}"
echo "$ip:$port OPEN - $banner$http_info" >> alive.txt
echo "[OPEN] $ip:$port - $banner$http_info" >> $HTML_REPORT
}
# 3. SMB VULN CHECK
if [ $port -eq 445 ]; then
echo -e "${CYAN} -> [SMB] Checking SMB signing...${NC}"
if command -v nmap &> /dev/null; then
smb_check=$(nmap --script smb2-security-mode -p 445 $ip 2>/dev/null | grep -i "signing")
echo -e "${YELLOW}
$smb_check${NC}"
echo "
SMB Check: $smb_check" >> alive.txt
echo "
SMB Check: $smb_check" >> $HTML_REPORT
fi
fi
else
# 6. STEALTH MODE
if [ "$STEALTH" = false ]; then
echo -e "${RED}[CLOSED] $ip:$port${NC}"
fi
fi
echo -e "${YELLOW}[*] Target: $TARGET | FAST=$FAST STEALTH=$STEALTH${NC}"
PORTS="21 22 25 53 80 139 443 445 3306 3389 8080 8443"
if [ "$FAST" = true ]; then
# 1. FAST MODE - parallel
for port in $PORTS; do
scan_port $TARGET $port &
done
wait
else
for port in $PORTS; do
scan_port $TARGET $port
done
fiecho "
Alive Hosts
" >> $HTML_REPORT
cat alive.txt >> $HTML_REPORT
echo "
" >> $HTML_REPORT
echo -e "${GREEN}[+] Done! Text: alive.txt | HTML: $HTML_REPORT${NC}"
