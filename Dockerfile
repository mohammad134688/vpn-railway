FROM alpine:3.20

RUN apk add --no-cache bash curl unzip && \
    curl -sL "https://github.com/XTLS/Xray-core/releases/download/v1.8.24/Xray-linux-64.zip" -o /tmp/xray.zip && \
    cd /tmp && unzip xray.zip && mv xray /usr/local/bin/xray && chmod +x /usr/local/bin/xray && \
    rm -rf /tmp/xray* && \
    apk del curl unzip

EXPOSE 8080

COPY start.sh /start.sh
RUN chmod +x /start.sh

CMD ["/start.sh"]
