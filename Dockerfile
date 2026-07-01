FROM alpine:3.20

RUN apk add --no-cache bash curl xz && \
    curl -sL "https://github.com/shadowsocks/shadowsocks-rust/releases/download/v1.21.2/shadowsocks-v1.21.2.x86_64-unknown-linux-musl.tar.xz" \
      | tar xJ -C /usr/local/bin/ && \
    chmod +x /usr/local/bin/ssserver && \
    apk del curl xz

EXPOSE 8388/tcp
EXPOSE 8388/udp

COPY start.sh /start.sh
RUN chmod +x /start.sh

CMD ["/start.sh"]
