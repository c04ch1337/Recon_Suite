# Recon_Suite

## Description
Recon_Suite is an intelligent, automated reconnaissance toolkit built for rapid and structured enumeration of network targets. It supports both standalone and Docker-based usage. Ideal for Penetration Testers, Red Teamers, and Security Analysts.

## Features
- Target-aware scanning
- Fast port discovery via `masscan`
- Service enumeration with `nmap`
- Web service analysis using `whatweb`, `nikto`, `dirb`
- Generates Markdown + PDF reports with `pandoc`
- Optional email delivery of results
- Docker & standalone script compatible

## Requirements
### Standalone
Install the following:
```
sudo apt install -y nmap masscan jq xsltproc nikto dirb smbclient snmp git curl wget pandoc python3 whatweb mailutils
```

### Docker
Build and run:
```bash
docker build -t recon_suite .
docker run --rm -it recon_suite
```

## Output
All results are saved in a `logs/TARGET__DATE/` directory with:
- Nmap logs (normal, XML, grepable, HTML)
- Masscan output
- Web scan outputs
- `report.md` and `report.pdf`

## Email Notification
Set `EMAIL_NOTIFICATIONS=true` and `EMAIL_RECIPIENT=you@example.com` at the top of the script to enable.

## License
MIT

## Contributing
PRs welcome. Report issues or feature requests via GitHub.

## Author
Jamey Milner

