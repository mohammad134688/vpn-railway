#!/bin/bash
set -e

[ -z "$VLESS_UUID" ] && VLESS_UUID="c1413fc0-716d-47d0-9b33-cfc9d0999a8d"
LISTEN_PORT=${PORT:-8080}
XRAY_PORT=10080

cat > /tmp/config.json << XEOF
{
  "log": { "loglevel": "warning" },
  "inbounds": [
    {
      "listen": "127.0.0.1",
      "port": ${XRAY_PORT},
      "protocol": "vless",
      "settings": {
        "clients": [{"id": "${VLESS_UUID}"}],
        "decryption": "none"
      },
      "streamSettings": {
        "network": "ws",
        "wsSettings": { "path": "/ws" }
      }
    }
  ],
  "outbounds": [{"protocol": "freedom"}]
}
XEOF

# Fix nginx port
sed -i "s/listen 8080;/listen ${LISTEN_PORT};/" /etc/nginx/http.d/default.conf

nginx -t
nginx

exec xray run -c /tmp/config.json
