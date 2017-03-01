FROM alpine:latest

ENV SS_VER=3.0.3 KCP_VER=20170301
ENV SS_PORT=443 SS_PASSWORD=123456 SS_METHOD=chacha20 SS_TIMEOUT=600 KCP_PORT=9443 KCP_MODE=fast MTU=1400 SNDWND=1024 RCVWND=1024 DATASHARD=10 PARITYSHARD=0
EXPOSE $SS_PORT/tcp $SS_PORT/udp $KCP_PORT/udp

ARG SS_URL=https://github.com/shadowsocks/shadowsocks-libev/releases/download/v$SS_VER/shadowsocks-libev-$SS_VER.tar.gz
ARG KCP_URL=https://github.com/xtaci/kcptun/releases/download/v$KCP_VER/kcptun-linux-amd64-$KCP_VER.tar.gz

RUN set -ex \
    && apk add --no-cache --virtual .build-deps \
        asciidoc \
        autoconf \
        build-base \
        curl \
        libtool \
        linux-headers \
        openssl-dev \
        pcre-dev \
        tar \
        xmlto \
        mbedtls-dev \
        libsodium-dev \
        udns-dev \
        libev-dev \
    && cd /tmp \
    && curl -sSL $SS_URL | tar xz --strip 1 \
    && ./configure --prefix=/usr --disable-documentation \
    && make install \
    && runDeps="$( \
        scanelf --needed --nobanner /usr/bin/ss-* \
            | awk '{ gsub(/,/, "\nso:", $2); print "so:" $2 }' \
            | xargs -r apk info --installed \
            | sort -u \
    )" \
    && apk add --no-cache --virtual .run-deps $runDeps \
    && apk add --no-cache supervisor \
    && mkdir -p /opt/kcptun \
    && curl -fSL $KCP_URL | tar xz \
    && mv server_linux_amd64 /opt/kcptun/ \
    && cd ~ \
    && apk del .build-deps \
    && rm -rf /tmp/*

COPY supervisord.conf /etc/supervisord.conf

ENTRYPOINT ["/usr/bin/supervisord"]
