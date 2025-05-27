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
