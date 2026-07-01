FROM alpine:3.20

RUN apk add --no-cache bash curl xz && \
    # Install shadowsocks-rust
    curl -sL "https://github.com/shadowsocks/shadowsocks-rust/releases/download/v1.21.2/shadowsocks-v1.21.2.x86_64-unknown-linux-musl.tar.xz" \
      | tar xJ -C /usr/local/bin/ && \
    chmod +x /usr/local/bin/ssserver && \
    # Install v2ray-plugin
    curl -sL "https://github.com/shadowsocks/v2ray-plugin/releases/download/v1.3.1/v2ray-plugin-linux-amd64-v1.3.1.tar.gz" \
      | tar xz -C /usr/local/bin/ && \
    mv /usr/local/bin/v2ray-plugin* /usr/local/bin/v2ray-plugin && \
    chmod +x /usr/local/bin/v2ray-plugin && \
    apk del curl xz

EXPOSE 8388/tcp

COPY start.sh /start.sh
RUN chmod +x /start.sh

CMD ["/start.sh"]
