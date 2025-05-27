FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y \
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
        python3-pip \
        whatweb && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*
