FROM alpine:3.20

RUN apk add --no-cache bash curl unzip nginx && \
    curl -sL "https://github.com/XTLS/Xray-core/releases/download/v1.8.24/Xray-linux-64.zip" -o /tmp/xray.zip && \
    cd /tmp && unzip xray.zip && mv xray /usr/local/bin/xray && chmod +x /usr/local/bin/xray && \
    rm -rf /tmp/xray* && \
    mkdir -p /var/www /run/nginx && \
    echo "OK" > /var/www/index.html && \
    apk del curl unzip

COPY nginx.conf /etc/nginx/http.d/default.conf
COPY start.sh /start.sh
RUN chmod +x /start.sh

EXPOSE 8080

CMD ["/start.sh"]
