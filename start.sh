#!/bin/bash
set -e

if [ -z "$SS_PASSWORD" ]; then
    export SS_PASSWORD=$(head -c 16 /dev/urandom | base64 | tr -d '/+=' | head -c 16)
fi

LISTEN_PORT=${PORT:-8388}
SS_METHOD=${SS_METHOD:-aes-256-gcm}

echo "========================================="
echo "  Shadowsocks + v2ray-plugin (WSS)"
echo "  Port: $LISTEN_PORT"
echo "  Method: $SS_METHOD"
echo "  Password: $SS_PASSWORD"
echo "========================================="

exec ssserver \
  --server-addr "0.0.0.0:$LISTEN_PORT" \
  --encrypt-method "$SS_METHOD" \
  --password "$SS_PASSWORD" \
  --plugin v2ray-plugin \
  --plugin-opts "server;path=/ws;loglevel=none"
