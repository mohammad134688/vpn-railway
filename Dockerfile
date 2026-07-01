FROM ghcr.io/shadowsocks/shadowsocks-rust:v1.22.3

EXPOSE 8388/tcp
EXPOSE 8388/udp

COPY start.sh /start.sh
RUN chmod +x /start.sh

CMD ["/start.sh"]
