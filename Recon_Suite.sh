### DELETE THIS LINE ###
#!/bin/bash 

# ───────────────────────────────
# Recon_Suite.sh – Network Recon Tool
# Author: C04CH_1337
# Updated: 2025-05-27
# ───────────────────────────────

set -e

# ────── COLORS ──────
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# ────── DEPENDENCY CHECK ──────
REQUIRED_TOOLS=("nmap" "masscan" "jq" "xsltproc" "nikto" "dirb" "smbclient" "snmpwalk" "git" "curl" "wget" "pandoc" "python3" "python3-pip" "whatweb" "enum4linux")

echo -e "${GREEN}🔍 Checking dependencies...${NC}"
for tool in "${REQUIRED_TOOLS[@]}"; do
    if ! command -v "$tool" &>/dev/null; then
        echo -e "${YELLOW}⚠️  $tool not found. Please install it before running this script.${NC}"
    fi
done

# ────── USER INPUT ──────
read -rp "🎯 Enter Target (IP, CIDR, Hostname, or URL): " TARGET

if [[ -z "$TARGET" ]]; then
    echo -e "${RED}❌ No target provided. Exiting.${NC}"
    exit 1
fi

TIMESTAMP=$(date +%Y%m%d_%H%M%S)
OUTPUT_DIR="${TARGET//[\/:]/_}__${TIMESTAMP}"
mkdir -p "$OUTPUT_DIR"

echo -e "${GREEN}📁 Output will be saved in $OUTPUT_DIR${NC}"

# ────── MASSCAN ──────
echo -e "\n🚀 Running masscan..."
masscan -p1-65535 "$TARGET" --rate=10000 -oL "$OUTPUT_DIR/masscan.txt" 2>/dev/null || {
    echo -e "${RED}❌ masscan failed.${NC}"
    exit 1
}

if [ ! -s "$OUTPUT_DIR/masscan.txt" ]; then
    echo -e "${YELLOW}⚠️ No open ports found or masscan failed. Exiting.${NC}"
    exit 1
fi

# ────── PORT EXTRACTION ──────
PORTS=$(grep -Eo 'port [0-9]+' "$OUTPUT_DIR/masscan.txt" | awk '{print $2}' | sort -nu | paste -sd, -)

echo -e "${GREEN}✅ Open Ports: $PORTS${NC}"

# ────── NMAP ──────
echo -e "\n🧠 Running Nmap with service and OS detection..."
nmap -sS -sV -O -p"$PORTS" "$TARGET" -oA "$OUTPUT_DIR/nmap"

# ────── CONVERT NMAP TO JSON ──────
echo -e "\n📄 Converting Nmap XML to JSON..."
xsltproc "$OUTPUT_DIR/nmap.xml" -o "$OUTPUT_DIR/nmap.html"
python3 -m pip install xmltodict &>/dev/null || true
python3 -c "
import xmltodict, json
with open('$OUTPUT_DIR/nmap.xml') as f:
    obj = xmltodict.parse(f.read())
with open('$OUTPUT_DIR/nmap.json', 'w') as out:
    json.dump(obj, out, indent=2)
"

# ────── SMB ENUM ──────
if echo "$PORTS" | grep -q "445\|139"; then
    echo -e "\n📦 Running enum4linux on SMB target..."
    enum4linux "$TARGET" | tee "$OUTPUT_DIR/enum4linux.txt"
fi

# ────── WEB ENUM ──────
if echo "$PORTS" | grep -q "80\|443\|8080"; then
    echo -e "\n🌐 Detected web service. Running dirb and nikto..."
    nikto -h "$TARGET" -o "$OUTPUT_DIR/nikto.txt"
    whatweb "$TARGET" -v > "$OUTPUT_DIR/whatweb.txt"
    dirb "http://$TARGET" -o "$OUTPUT_DIR/dirb_http.txt"
    dirb "https://$TARGET" -o "$OUTPUT_DIR/dirb_https.txt"
fi

# ────── COMPLETE ──────
echo -e "\n${GREEN}✅ Recon Complete. Results stored in $OUTPUT_DIR${NC}"
