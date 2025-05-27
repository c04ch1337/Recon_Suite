
FROM kalilinux/kali-rolling

RUN apt-get update && \
    apt-get install -y \
    nmap \
    masscan \
    enum4linux \
    nuclei \
    jq \
    xsltproc \
    nikto \
    dirb \
    smbclient \
    snmp \
    git \
    pandoc \
    curl \
    unzip && \
    apt-get clean

COPY recon_suite.sh /recon_suite.sh
RUN chmod +x /recon_suite.sh

ENTRYPOINT ["/recon_suite.sh"]
