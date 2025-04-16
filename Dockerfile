FROM ubuntu:focal
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
    && apt-get install -y wget unzip dnsutils traceroute \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /tmp

RUN wget https://github.com/KnoxFS/Wallet-5.3.2.0/releases/download/v5.3.3/kfx-5.3.3-x86_64-linux-gnu.zip \
    && unzip kfx-5.3.3-x86_64-linux-gnu.zip -d /usr/sbin \
    && rm kfx-5.3.3-x86_64-linux-gnu.zip

ENTRYPOINT ["/usr/sbin/knoxfsd"]

CMD ["-datadir=/data"]
