FROM debian:stable-slim

ARG VER=1.5.4
ARG BUILDVER=2
ARG TARGETARCH
ARG ARCH
ENV configfile="/opt/config.yaml"
ENV log_dir="/log"
ENV TZ=Asia/Shanghai


COPY ./entrypoint.sh /root/
COPY ./arch.sh  /tmp/

RUN apt-get -qq update \
    && apt-get -qq install -y --no-install-recommends ca-certificates wget unzip \
    && chmod +x  /tmp/arch.sh /root/entrypoint.sh \
    && /tmp/arch.sh ${VER} v${VER}-${BUILDVER} && ls /tmp/linux -ahl\
    && rm /tmp/linux/hpool-miner-chia.zip \
    && mv /tmp/linux/* /opt \
    && cd /opt && mv hpool-* hpool-chia-miner \
    && chmod +x /opt/hpool-chia-miner \
    && cp /usr/share/zoneinfo/$TZ /etc/localtime \
    && echo $TZ > /etc/timezone \
    && cat /etc/timezone \
    && rm -rf /tmp/* \
    && ls -al /opt 

WORKDIR /opt

ENTRYPOINT ["/bin/sh", "/root/entrypoint.sh"]
