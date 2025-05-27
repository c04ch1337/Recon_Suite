# 🔎 Recon_Suite

**Intelligent Host & Network Reconnaissance Tool**

Recon_Suite automates and streamlines asset discovery, enumeration, and web recon across a network. Built for red teamers, pentesters, and network defenders.

---

## 💻 Features

- 🔍 Prompts for IP, Hostname, or URL
- 🚀 Fast scanning using `masscan` & `nmap`
- 🧠 Conditional logic (e.g., run `enum4linux` if SMB detected)
- 🌐 Web recon with `nikto`, `dirb`, `nuclei`, `httpx`, `whatweb`
- 📄 Output in JSON (for SIEMs) and DOCX (for reporting)
- 🐳 Dockerized for plug-and-play usage

---

## 🚀 Usage

### 🔧 Standalone (Linux)

```bash
chmod +x Recon_Suite.sh
./Recon_Suite.sh
