### #!/bin/bash

# Recon_Suite.sh - Intelligent Host & Network Reconnaissance Tool
# Author: C04CH_1337
# License: MIT

# ========================== #
# Dependency & Tool Checking #
# ========================== #

REQUIRED_TOOLS=("nmap" "masscan" "jq" "xsltproc" "nikto" "dirb" "smbclient" "enum4linux" "snmpwalk" "git" "pandoc")
OPTIONAL_TOOLS=("nuclei" "whatweb" "httpx")

MISSING_TOOLS=()

for tool in "${REQUIRED_TOOLS[@]}"; do
    if ! command -v $tool &>/dev/null; then
        MISSING_TOOLS+=("$tool")
    fi
done

if [ ${#MISSING_TOOLS[@]} -ne 0 ]; then
    echo -e "\n❌ Missing Required Tools:"
    for tool in "${MISSING_TOOLS[@]}"; do
        echo "   - $tool"
    done
    echo -e "\nPlease install the missing tools before running the script.\n"
    exit 1
fi

echo "✅ All required tools found."
echo -e "🔍 Optional tools checked separately.\n"

# ================= #
# User Input Prompt #
# ================= #

read -rp "Enter IP, Hostname, URL, or CIDR: " TARGET
if [ -z "$TARGET" ]; then
    echo "No target provided. Exiting."
    exit 1
fi

TIMESTAMP=$(date +%Y%m%d_%H%M%S)
OUTPUT_DIR="${TARGET//[\/:]/_}__${TIMESTAMP}"
mkdir -p "$OUTPUT_DIR"

echo -e "\n🔍 Scanning: $TARGET"
echo -e "📂 Logs will be saved in: $OUTPUT_DIR\n"

# =========================== #
# Step 1: Fast Port Discovery #
# =========================== #

echo "[*] Running masscan..."
sudo masscan -p1-65535 --rate=10000 -oL "$OUTPUT_DIR/masscan.txt" $TARGET

# Extract open ports
PORTS=$(grep -oP "port \K[0-9]+" "$OUTPUT_DIR/masscan.txt" | sort -n | uniq | paste -sd, -)

if [ -z "$PORTS" ]; then
    echo "⚠️ No open ports found. Exiting."
    exit 1
fi

# =============================== #
# Step 2: Nmap for Deep Discovery #
# =============================== #

echo -e "\n[*] Running nmap on discovered ports..."
nmap -sS -sV -O -p$PORTS -oA "$OUTPUT_DIR/nmap_scan" $TARGET

# JSON conversion (for SIEMs)
xsltproc "$OUTPUT_DIR/nmap_scan.xml" > "$OUTPUT_DIR/nmap_scan.html"
cat "$OUTPUT_DIR/nmap_scan.gnmap" | jq -R -s '.' > "$OUTPUT_DIR/nmap_scan.json"

# =============================== #
# Step 3: Conditional Enumeration #
# =============================== #

if grep -q "microsoft-ds" "$OUTPUT_DIR/nmap_scan.nmap"; then
    echo -e "\n[*] SMB Detected - Running enum4linux..."
    enum4linux -a $TARGET > "$OUTPUT_DIR/enum4linux.txt"
fi

# =============================== #
# Step 4: Web Server Recon Check  #
# =============================== #

echo -e "\n[*] Checking for web services..."
if grep -E "Ports:.*(80/open|443/open|8080/open|8443/open)" "$OUTPUT_DIR/nmap_scan.gnmap"; then
    echo -e "🌐 Web server detected - running dirb, nikto, and other tools..."

    # dirb
    dirb http://$TARGET > "$OUTPUT_DIR/dirb_http.txt"
    dirb https://$TARGET > "$OUTPUT_DIR/dirb_https.txt"

    # nikto
    nikto -h $TARGET > "$OUTPUT_DIR/nikto.txt"

    # nuclei
    if command -v nuclei &>/dev/null; then
        nuclei -u $TARGET -o "$OUTPUT_DIR/nuclei.txt"
    else
        echo "⚠️ Nuclei not found. Skipping."
    fi

    # Optional: WhatWeb
    if command -v whatweb &>/dev/null; then
        whatweb $TARGET > "$OUTPUT_DIR/whatweb.txt"
    fi

    # Optional: httpx
    if command -v httpx &>/dev/null; then
        echo $TARGET | httpx -title -tech-detect -status-code -o "$OUTPUT_DIR/httpx.txt"
    fi
fi

# ========================== #
# Step 5: Convert for Docs   #
# ========================== #

echo -e "\n[*] Converting results to DOCX..."
pandoc "$OUTPUT_DIR/nmap_scan.nmap" -o "$OUTPUT_DIR/nmap_scan.docx"
[ -f "$OUTPUT_DIR/enum4linux.txt" ] && pandoc "$OUTPUT_DIR/enum4linux.txt" -o "$OUTPUT_DIR/enum4linux.docx"

echo -e "\n✅ Recon Complete! Results saved in: $OUTPUT_DIR"
