FROM alpine:3.20

RUN apk add --no-cache \
    shadowsocks-libev \
    curl \
    bash

COPY start.sh /start.sh
RUN chmod +x /start.sh

EXPOSE 8388/tcp
EXPOSE 8388/udp

CMD ["/start.sh"]
