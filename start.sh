#!/bin/bash
set -e

if [ -z "$SS_PASSWORD" ]; then
    export SS_PASSWORD=$(head -c 16 /dev/urandom | base64 | tr -d '/+=' | head -c 16)
fi

# Railway sets PORT for HTTP/HTTPS services
LISTEN_PORT=${PORT:-8388}
SS_METHOD=${SS_METHOD:-aes-256-gcm}

echo "========================================="
echo "  Shadowsocks + v2ray-plugin (WSS)"
echo "  Port: $LISTEN_PORT"
echo "  Method: $SS_METHOD"
echo "  Password: $SS_PASSWORD"
echo "========================================="

# ss-server listens on internal port, v2ray-plugin handles external
printf '{"server":"127.0.0.1","server_port":18388,"password":"%s","method":"%s","mode":"tcp_only"}' \
  "$SS_PASSWORD" "$SS_METHOD" > /tmp/config.json

exec ssserver -c /tmp/config.json \
  --plugin v2ray-plugin \
  --plugin-opts "server;path=/ws;loglevel=none;host=0.0.0.0;port=$LISTEN_PORT"
