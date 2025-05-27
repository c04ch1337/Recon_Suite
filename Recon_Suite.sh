# ===========================
# Recon_Suite.sh
# ===========================

#!/bin/bash

set -e

# ========== Global Vars ==========
LOG_BASE_DIR="$(pwd)/logs"
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
EMAIL_NOTIFICATIONS=false
EMAIL_RECIPIENT=""

# ========== Functions ==========
function banner() {
  echo -e "\n\033[1;34m[*] Recon_Suite: Automated Network Recon Toolkit\033[0m"
}

function check_dependencies() {
  echo "[+] Checking dependencies..."
  local dependencies=(nmap masscan jq xsltproc nikto dirb smbclient snmp git curl wget pandoc python3)
  for dep in "${dependencies[@]}"; do
    if ! command -v "$dep" &>/dev/null; then
      echo "[-] $dep not found. Please install it before continuing."
      exit 1
    fi
  done
}

function prompt_target() {
  read -rp "Enter target IP/Network/Hostname/URL: " TARGET
  TARGET_DIR="${LOG_BASE_DIR}/${TARGET//\//_}__${TIMESTAMP}"
  mkdir -p "$TARGET_DIR"
}

function scan_ports() {
  echo "[+] Running masscan for fast port discovery..."
  masscan -p1-65535 "$TARGET" --rate=10000 -oL "$TARGET_DIR/masscan.txt" || true

  if ! grep -q open "$TARGET_DIR/masscan.txt"; then
    echo "⚠️ No open ports found. Exiting."
    exit 1
  fi

  PORTS=$(grep -oP 'port \K[0-9]+' "$TARGET_DIR/masscan.txt" | paste -sd, -)
  echo "[+] Ports identified: $PORTS"
}

function run_nmap() {
  echo "[+] Running Nmap SYN scan..."
  nmap -sS -p"$PORTS" -T4 -A "$TARGET" -oA "$TARGET_DIR/nmap_scan"
  nmap -oX "$TARGET_DIR/nmap.xml" -p"$PORTS" "$TARGET"
  xsltproc "$TARGET_DIR/nmap.xml" -o "$TARGET_DIR/nmap.html"
  nmap -oG "$TARGET_DIR/nmap.gnmap" -p"$PORTS" "$TARGET"
  nmap -p"$PORTS" -sV --script=banner "$TARGET" -oN "$TARGET_DIR/nmap_banner.txt"
}

function identify_and_scan_web() {
  echo "[+] Checking for web services..."
  if grep -E ':80|:443' "$TARGET_DIR/nmap.gnmap"; then
    echo "[+] Web server detected. Running nikto, dirb, whatweb..."
    whatweb "$TARGET" > "$TARGET_DIR/whatweb.txt" &
    nikto -host "$TARGET" -output "$TARGET_DIR/nikto.txt" &
    dirb "http://$TARGET" > "$TARGET_DIR/dirb.txt" &
    wait
  fi
}

function generate_reports() {
  echo "[+] Generating report..."
  echo "Recon Report for $TARGET ($TIMESTAMP)" > "$TARGET_DIR/report.md"
  for f in "$TARGET_DIR"/*.txt; do
    echo -e "\n### $(basename "$f")\n" >> "$TARGET_DIR/report.md"
    cat "$f" >> "$TARGET_DIR/report.md"
  done
  pandoc "$TARGET_DIR/report.md" -o "$TARGET_DIR/report.pdf"
}

function email_report() {
  if [ "$EMAIL_NOTIFICATIONS" = true ]; then
    echo "[+] Sending report to $EMAIL_RECIPIENT..."
    echo "Recon Report for $TARGET" | mail -s "Recon Report: $TARGET" -A "$TARGET_DIR/report.pdf" "$EMAIL_RECIPIENT"
  fi
}

# ========== Main ==========

banner
check_dependencies
prompt_target
scan_ports
run_nmap
identify_and_scan_web
generate_reports
email_report

echo "[+] Recon complete. Output stored in: $TARGET_DIR"

exit 0
