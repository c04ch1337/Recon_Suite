FROM ubuntu:22.04

RUN apt-get update && apt-get install -y \
    nmap \
    masscan \
    jq \
    xsltproc \
    nikto \
    dirb \
    smbclient \
    enum4linux \
    snmp \
    git \
    curl \
    wget \
    pandoc \
    python3 \
    python3-pip \
    whatweb \
    && apt-get clean

# Optional tools (if available)
RUN go install -v github.com/projectdiscovery/nuclei/v2/cmd/nuclei@latest && \
    go install -v github.com/projectdiscovery/httpx/cmd/httpx@latest

ENV PATH="/root/go/bin:$PATH"

WORKDIR /recon
COPY Recon_Suite.sh /recon
RUN chmod +x Recon_Suite.sh

ENTRYPOINT ["./Recon_Suite.sh"]
