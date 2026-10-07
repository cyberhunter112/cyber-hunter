Cyber-Hunter v4.0 ULTIMATE
🛡️
> Fast, Stealthy, Professional Network & Port Scanner for Pentesters
![Bash](https://img.shields.io/badge/Language-Bash-green)
![Kali](https://img.shields.io/badge/Platform-Kali_Linux-blue)
![Version](https://img.shields.io/badge/Version-4.0%20ULTIMATE-red)
![License](https://img.shields.io/badge/License-MIT-yellow)
A lightweight yet powerful reconnaissance tool built for ethical hackers. Discovers alive hosts, scans critical ports,
grabs banners, checks SMB vulnerabilities, and generates professional reports.
🔥 Features
- ⚡ **FAST MODE** - Parallel scanning (100x faster)
- 👻 **STEALTH MODE** - Hide closed ports, show only OPEN
- 🕵️ **Banner Grabbing** - Detect service versions
- 💀 **SMB Vuln Check** - Auto-check SMB signing on port 445
- 🌐 **HTTP Title Grab** - Extract website titles from 80/8080/443
- 📄 **HTML Report** - Professional report for clients
- 💾 **Auto-Save** - All results saved to `alive.txt`
---
📦 Installation
```bash
1. Clone the tool
git clone https://github.com/YOUR-USERNAME/cyber-hunter.git
cd cyber-hunter
2. Make executable
chmod +x cyber-hunter.sh
3. Install dependencies (Kali)
sudo apt update
sudo apt install nmap curl -y
---
🚀 Usage
Basic Commands
Scan single IP
./cyber-hunter.sh 192.168.169.1
Scan single IP - FAST mode (recommended)
./cyber-hunter.sh 192.168.169.1 --fast
Stealth mode - only show OPEN ports
./cyber-hunter.sh 192.168.169.1 --stealth
Fast + Stealth (Best for CTF)
./cyber-hunter.sh 192.168.169.1 --fast --stealth
Scan entire network./cyber-hunter.sh 192.168.169.0
View results
cat alive.txt
cat report.html
Advanced Commands
Keep running if Kali crashes / close terminal
tmux
./cyber-hunter.sh 192.168.169.1 --fast
Press Ctrl+B then D to detach
Or use nohup
nohup ./cyber-hunter.sh 192.168.169.1 --fast > scan.log 2>&1 &
View HTML report in browser
firefox report.html
---
📂
Output Files
File Description
`alive.txt` All open ports + banners + SMB checks
`report.html` Professional HTML report
`scan.log` Log if using nohup
*Example `alive.txt`:*
192.168.169.1:139 OPEN - No banner
192.168.169.1:445 OPEN - SMB
SMB Check: Message signing disabled
192.168.169.1:80 OPEN - No banner | Title: Apache2 Ubuntu
---
🛠️ Supported Ports
`21 (FTP) | 22 (SSH) | 25 (SMTP) | 53 (DNS) | 80 (HTTP) | 139 (NetBIOS) | 443 (HTTPS) | 445 (SMB) | 3306 (MySQL)
| 3389 (RDP) | 8080 (HTTP-Alt) | 8443 (HTTPS-Alt)`
---
🔄
Update
cd cyber-hunter
git pull
---
⚠️ Disclaimer
> For *Educational and Authorized Testing Only*. Do not scan networks without permission. The author is not
responsible for misuse.
---
👨‍💻 Author
AHMAD MUSTAPHA ALIYU
Built with ❤️ for the community.
- GitHub: cyberhunter112
- Version: 4.0 ULTIMATE
*If it helped you, give it a
⭐ on GitHub!*
**After paste, save and push:**
```bash
git add README.md
git commit -m "professional readme v4.0"
git push
