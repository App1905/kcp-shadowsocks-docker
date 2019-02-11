# kcp-shadowsocks-docker

A docker image for [shadowsocks-libev](https://github.com/shadowsocks/shadowsocks-libev) server with [KCPTUN](https://github.com/xtaci/kcptun) support

## Download from Docker Hub 

```bash
docker pull app1905/kcp-shadowsocks-docker:{tag}
```

## Usage

```bash
config with '-e':
# docker run -d --restart=always -e "SS_PORT=8443" -e "SS_PASSWORD=123456" -e "SS_METHOD=chacha20" -e "SS_TIMEOUT=600" -e "KCP_PORT=9443" -e "KCP_MODE=fast" -e "MTU=1350" -e "SNDWND=1024" -e "RCVWND=1024" -p 8443:8443 -p 8443:8443/udp -p 9443:9443/udp --name ssserver app1905/kcp-shadowsocks-docker:{tag}

or just:
# docker run -d --restart=always -p 8443:8443 -p 8443:8443/udp -p 9443:9443/udp --name ssserver app1905/kcp-shadowsocks-docker:{tag}
```

## KCP Parameters for client

--crypt none --mode fast --mtu 1350 --sndwnd 1024 --rcvwnd 1024 --parityshard 10 --nocomp

for mac client: 

crypt=none;mode=fast;mtu=1350;sndwnd=1024;rcvwnd=1024;datashard=10;parityshard=10;nocomp=true;


## Default configuration in environment variables

| ENV         | Value    |
|:------------|:---------|
| SS_PORT     | 8443      |
| SS_PASSWORD | 123456   |
| SS_METHOD   | chacha20 |
| SS_TIMEOUT  | 600      |
| KCP_PORT    | 9443     |
| KCP_MODE    | fast     |
| MTU         | 1350     |
| SNDWND      | 1024     |
| RCVWND      | 1024     |
| DATASHARD   | 10       |
| PARITYSHARD | 10        |
