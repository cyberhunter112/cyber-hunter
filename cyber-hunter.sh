#!/bin/bash
# Cyber-Hunter v4.1 ULTIMATE - FIXED
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'
STEALTH=false
FAST=false
HTML_REPORT="report.html"
for arg in "$@"; do
if [ "$arg" = "--stealth" ]; then STEALTH=true; fi
if [ "$arg" = "--fast" ]; then FAST=true; fi
done
TARGET=$1
if [ -z "$TARGET" ] || [[ "$TARGET" == --* ]]; then
echo -e "${YELLOW}Usage: ./cyber-hunter.sh [--fast] [--stealth]${NC}"
exit 1
fi
echo -e "${GREEN}"
cat << "EOF"
____ _ _ _ _
/ ___| _| |__ ___ _ __| | | |_ _ _ __ |_ ___ _ __
| | | | | | '_ \ / _ \ '__| |_| | | | | '_ \| __/ _ \ '__|
| |__| |_| | |_) | __/ | | _ | |_| | | | | || __/ |
\____\__, |_.__/ \___|_| |_| |_|\__,_|_| |_|\__\___|_|
|___/ v4.1 ULTIMATE - VERSION
EOF
echo -e "${NC}"
> alive.txt
echo "<html><body><h1><report for $target - $(date)<h1><pre>" > $HTML_REPORT
scan_port() {
local ip=$1
local port=$2
timeout 1 bash -c "echo > /dev/tcp/$ip/$port" 2>/dev/null
if [ $? -eq 0 ]; then
banner=$(timeout 1 bash -c "exec 3<>/dev/tcp/$ip/$port; cat <&3" 2>/dev/null | head -n 1 | tr -d '\r' | cut -c1-50)
if [ -z "$banner" ]; then banner="OPEN"; fi
http_info=""
if [ "$port" = "80" ] || [ "$port" = "8080" ]; then
title=$(curl -s --connect-timeout 2 http://$ip:$port 2>/dev/null | grep -o "" | head -n 1)
if [ ! -z "$title" ]; then http_info=" $title"; fi
fi
echo -e "${GREEN}[OPEN] $ip:$port - $banner $http_info${NC}"
echo "$ip:$port OPEN - $banner $http_info" >> alive.txt
echo "[OPEN] $ip:$port - $banner" >> $HTML_REPORT

if [ "$port" -eq 445 ]; then
echo -e "${CYAN} -> [SMB] Checking...${NC}"
nmap --script smb2-security-mode -p 445 $ip 2>/dev/null | grep signing
fi
else
if [ "$STEALTH" = false ]; then
echo -e "${RED}[CLOSED] $ip:$port${NC}"
fi
fi
}

echo -e "${YELLOW}[*] Target: $TARGET FAST=$FAST STEALTH=$STEALTH${NC}"
PORTS="21 22 25 53 80 139 443 445 3306 3389 8080 8443"
if [ "$FAST" = true ]; then
for port in $PORTS; do
scan_port $TARGET $port &
done
wait
else
for port in $PORTS; do
scan_port $TARGET $port
done
fi
echo "</pre></body></html>" >> $HTML_REPORT
echo -e "${GREEN}[+] Done! alive.txt + $HTML_REPORT${NC}"
cat alive.txt
