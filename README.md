
# Recon_Suite

## Overview
A smart and fast recon tool that identifies hosts and services on a network and performs deep reconnaissance based on OS and role.

## Features
- Masscan for fast port scanning
- Nmap for detailed enumeration
- Nuclei, Enum4linux, Nikto, Dirb for advanced recon
- JSON and DOC outputs for SIEM and human analysis

## Usage

### Standalone
```bash
chmod +x recon_suite.sh
./recon_suite.sh
```

### Docker
```bash
docker build -t recon_suite .
docker run --rm -it --network=host recon_suite
```

## Output
Creates a folder named after the target (with timestamp) containing all logs in multiple formats.
