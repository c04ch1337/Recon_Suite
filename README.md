# Recon_Suite

**Recon_Suite** is a modular, intelligent Bash-based reconnaissance framework designed for penetration testers, red teamers, system administrators, and security researchers. It performs fast and thorough enumeration of hosts, services, and web servers on a target IP, hostname, network, or URL. It can run either natively or inside a Docker container.

## 🚀 Key Features

- Intelligent workflow: identifies if the target is a host, server, workstation, or networking device
- Automatically detects and chains tools based on services discovered
- Fast scanning using optimized tools like `masscan`, `nmap`, `nuclei`, `dirb`, `enum4linux`, and more
- Logs results in structured JSON and DOC format, ideal for SIEM ingestion and reporting
- Self-checks and installs all required dependencies (or gracefully skips optional ones)
- Supports running in **standalone mode** or **Docker container**

---

## 🧠 Intelligent Workflow

1. **Input Prompt**: Accepts IP address, hostname, URL, or CIDR block
2. **Pre-check**: Pings or sweeps target for availability
3. **Initial Scan**: Performs fast port scan using `nmap -sS` or `masscan`
4. **Fingerprinting**: Determines system type and active services
5. **Service-Specific Scans**:
    - **Web**: Uses `nikto`, `dirb`, and `nuclei`
    - **SMB**: Uses `enum4linux`, `smbclient`
    - **SNMP**: Uses `snmpwalk`
    - **Linux hosts**: Uses `ssh`, `enum4linux`
    - **Windows hosts**: Suggests alternatives or uses SMB
6. **Structured Output**: Saves to a folder named after the target, in JSON/DOC/log format
7. **Optional Export**: Converts Nmap XML to JSON for SIEM/log parsing

---

## 🖥️ Standalone Script Usage

```bash
chmod +x Recon_Suite.sh
./Recon_Suite.sh
```

You will be prompted to enter:

- IP address
- Hostname
- CIDR block (e.g. `192.168.1.0/24`)
- URL (e.g. `http://example.com`)

**Example:**
```bash
./Recon_Suite.sh
# Enter IP or Hostname: 10.0.0.1
```

---

## 🐳 Docker Usage

### Build the Docker image

```bash
docker build -t recon_suite .
```

### Run the container

```bash
docker run --rm -it recon_suite
```

You will be prompted to enter a target the same way as the script.

---

## 📦 Output

All outputs are saved in a folder named after the target (e.g. `10.0.0.1/`):

- `scan.log` - Human-readable log
- `scan.json` - Structured JSON output (for SIEM)
- `scan.doc` - DOC-style report (optional)

---

## ✅ Dependencies

Required:
- `bash`, `nmap`, `jq`, `xsltproc`

Optional (gracefully skipped if unavailable):
- `masscan`, `nikto`, `dirb`, `smbclient`, `enum4linux`, `snmpwalk`, `git`, `nuclei`

Dependencies are automatically checked and reported at runtime.

---

## 🧪 GitHub Actions

This repository includes a workflow that:
- Builds the Docker image
- Tests the script on localhost (`127.0.0.1`) to verify functionality

---

## 📜 License

MIT License © 2025 Jamey Milner

---

## 🤝 Contributions

PRs, feature requests, and bug reports are welcome!
