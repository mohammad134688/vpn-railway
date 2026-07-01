FROM ghcr.io/shadowsocks/shadowsocks-rust:v1.23.0

COPY start.sh /start.sh
RUN chmod +x /start.sh

EXPOSE 8388/tcp
EXPOSE 8388/udp

CMD ["/start.sh"]
