FROM alpine:latest

ENV SS_VER=3.0.5 KCP_VER=20170329
ENV SS_PORT=443 SS_PASSWORD=123456 SS_METHOD=chacha20 SS_TIMEOUT=600 KCP_PORT=9443 KCP_MODE=fast MTU=1400 SNDWND=1024 RCVWND=1024 DATASHARD=10 PARITYSHARD=0
EXPOSE $SS_PORT/tcp $SS_PORT/udp $KCP_PORT/udp
ENV SS_DIR shadowsocks-libev-$SS_VER

ARG SS_URL=https://github.com/shadowsocks/shadowsocks-libev/archive/v$SS_VER.tar.gz
ARG KCP_URL=https://github.com/xtaci/kcptun/releases/download/v$KCP_VER/kcptun-linux-amd64-$KCP_VER.tar.gz

RUN set -ex \
    && apk add --no-cache libcrypto1.0 \
        libev \
        libsodium \
        mbedtls \
        pcre \
        udns \
        supervisor \
    && apk add --no-cache --virtual tmp \
        autoconf \
        automake \
        build-base \
        curl \
        gettext-dev \
        libev-dev \
        libsodium-dev \
        libtool \
        linux-headers \
        mbedtls-dev \
        openssl-dev \
        pcre-dev \
        tar \
        udns-dev \
    && cd /tmp \
    && curl -sSL $SS_URL | tar xz --strip 1 \
        && curl -sSL https://github.com/shadowsocks/ipset/archive/shadowsocks.tar.gz | tar xz --strip 1 -C libipset \
        && curl -sSL https://github.com/shadowsocks/libcork/archive/shadowsocks.tar.gz | tar xz --strip 1 -C libcork \
        && curl -sSL https://github.com/shadowsocks/libbloom/archive/master.tar.gz | tar xz --strip 1 -C libbloom \
        && ./autogen.sh \
        && ./configure --disable-documentation \
        && make install \
    && mkdir -p /opt/kcptun \
    && curl -fSL $KCP_URL | tar xz \
    && mv server_linux_amd64 /opt/kcptun/ \
    && cd / \
    && apk del tmp \
    && rm -rf /tmp/*

COPY supervisord.conf /etc/supervisord.conf
ENTRYPOINT ["/usr/bin/supervisord"]