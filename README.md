# 🛡️ Recon_Suite

![License](https://img.shields.io/badge/license-MIT-green) ![Build](https://img.shields.io/badge/build-passing-brightgreen) ![Docker](https://img.shields.io/badge/docker-ready-blue) ![Bash](https://img.shields.io/badge/language-bash-yellow)

## 🔍 Overview

**Recon_Suite** is an intelligent, modular bash-based reconnaissance and enumeration tool designed to quickly identify and profile devices on a network. It supports various target types (web servers, routers, workstations, etc.) and adapts its scanning methods accordingly.

Recon_Suite can run in two modes:
- 💻 **Standalone mode** (directly from your Linux/macOS machine)
- 🐳 **Docker mode** (fully containerized for portability and consistency)

---

## ⚙️ Features

- 📡 Smart target input: IP address, hostname, network (CIDR), or URL
- 🔗 Toolchain integration:
  - `nmap` (w/ JSON/XML output)
  - `masscan` for ultra-fast port scanning
  - `whatweb`, `nikto`, `dirb` for web servers
  - `enum4linux`, `smbclient` for SMB shares
  - `snmpwalk`, `snmpget` for SNMP
- 📁 Structured output in a per-target folder
- 📜 Converts output logs to:
  - JSON (for SIEMs)
  - DOCX/PDF (via `pandoc`)
- ✉️ Optional email alerts on completion
- 📊 Dashboard-ready logs
- 🧠 Intelligent logic to scan based on device type
- 🐞 Error-handling and dependency verification

---

## 🚀 Quick Start

### 🔧 Standalone Use

```bash
chmod +x Recon_Suite.sh
./Recon_Suite.sh

### 🐳 Docker Use
## Build the Docker Image:
docker build -t recon_suite .

## Run the Container:
docker run --rm -it recon_suite

---

## 📥 Input Prompts
When the script starts, you'll be prompted to enter:

#### IP Address or Network (CIDR)
#### Hostname or URL

---

## 📦 Output Structure

A directory is created per scan with this format:

TARGET__YYYYMMDD_HHMMSS/
├── masscan.txt
├── nmap.xml
├── nmap.json
├── enum4linux.txt
├── whatweb.txt
├── nikto.txt
├── smbclient.txt
├── snmpwalk.txt
├── combined_log.json
├── report.docx
└── report.pdf

---

## 📬 Email Notifications
To receive email notifications, configure your mail setup (e.g., postfix or msmtp) and update the email in the script's config section.

---

## 📈 Optional Dashboard/Log Support

* Exported .json logs are compatible with SIEM ingestion (ELK stack, Graylog, etc.)
* Web scanner output integrates easily into threat modeling dashboards

---

## 📦 Dependencies
The following tools must be installed for full functionality (handled automatically in Docker):

    nmap, masscan, jq, xsltproc, nikto, dirb, smbclient

    enum4linux-ng, snmp, git, curl, wget, pandoc, python3-pip, mailutils, whatweb

Install them manually with:

sudo apt update && sudo apt install -y \
  nmap masscan jq xsltproc nikto dirb smbclient \
  snmp snmp-mibs-downloader git curl wget pandoc \
  python3-pip mailutils whatweb

---

## 🧪 Example Usage

# Local
./Recon_Suite.sh

# Docker
docker run --rm -it recon_suite

---

## 📜 License
This project is licensed under the MIT License.

---

## 🤝 Contributing
PRs and ideas welcome! Submit issues or suggestions via GitHub.

---

## 👨‍💻 Author
Created with 🔧 by [YourNameHere]

---
