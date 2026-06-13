#!/bin/bash

set -e

echo "[+] Cleaning old MOTD files..."

# Remove static MOTD (prevents duplicate warnings)
rm -f /etc/motd

# Disable default Debian kernel banner
chmod -x /etc/update-motd.d/10-uname 2>/dev/null || true

echo "[+] Rebuilding custom MOTD..."

cat > /etc/update-motd.d/99-custom-motd << 'EOF'
#!/bin/bash

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
RESET='\033[0m'

echo ""

# --- BRANDING ---
echo -e "${GREEN}"
cat << "ASCII"
       d8888                                  888    888                   888    d8b
      d88888                                  888    888                   888    Y8P
     d88P888                                  888    888                   888
    d88P 888  .d8888b .d88b.  888d888 .d88b.  8888888888  .d88b.  .d8888b  888888 888 88888b.   .d88b.
   d88P  888 d88P"   d88""88b 888P"  d8P  Y8b 888    888 d88""88b 88K      888    888 888 "88b d88P"88b
  d88P   888 888     888  888 888    88888888 888    888 888  888 "Y8888b. 888    888 888  888 888  888
 d8888888888 Y88b.   Y88..88P 888    Y8b.     888    888 Y88..88P      X88 Y88b.  888 888  888 Y88b 888
d88P     888  "Y8888P "Y88P"  888     "Y8888  888    888  "Y88P"   88888P'  "Y888 888 888  888  "Y88888
                                                                                                    888
                                                                                               Y8b d88P
                                                                                                "Y88P"
ASCII
echo -e "${RESET}"

echo -e "${RED}WARNING:${RESET}"
echo -e "${RED}If you have gained access to this server, you MUST inform acorehosting.com!${RESET}"
echo ""

echo -e "${GREEN}Hostname:${RESET} $(hostname)"
echo -e "${GREEN}OS:${RESET} $(lsb_release -d | cut -f2)"

echo -e "${GREEN}IPv4s:${RESET}"
i=1
for ip in $(hostname -I); do
    echo -e "  ${YELLOW}[$i]${RESET} $ip"
    i=$((i+1))
done

load=$(uptime | awk -F'load average:' '{print $2}')
echo -e "${GREEN}Load:${RESET}${load}"

ram=$(free -h | awk '/Mem:/ {print $3 " / " $2}')
echo -e "${GREEN}RAM:${RESET} $ram"

disk=$(df -h / | awk 'NR==2 {print $3 " / " $2}')
echo -e "${GREEN}Disk:${RESET} $disk"

echo -e "${GREEN}Uptime:${RESET} $(uptime -p)"

echo ""
EOF

echo "[+] Setting permissions..."

chmod +x /etc/update-motd.d/99-custom-motd

echo "[+] Done!"
echo "Logout and login again to see changes."