# ===========================
# Dockerfile
# ===========================

FROM debian:latest

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    nmap \
    masscan \
    jq \
    xsltproc \
    nikto \
    dirb \
    smbclient \
    snmp \
    git \
    curl \
    wget \
    pandoc \
    python3 \
    whatweb \
    mailutils \
    && apt-get clean

COPY Recon_Suite.sh /usr/local/bin/Recon_Suite.sh
RUN chmod +x /usr/local/bin/Recon_Suite.sh

ENTRYPOINT ["/usr/local/bin/Recon_Suite.sh"]
