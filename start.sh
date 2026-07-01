#!/bin/bash
set -e

# Generate a random password if not set
if [ -z "$SS_PASSWORD" ]; then
    export SS_PASSWORD=$(head -c 16 /dev/urandom | base64 | tr -d '/+=' | head -c 16)
fi

SS_PORT=${SS_PORT:-8388}
SS_METHOD=${SS_METHOD:-aes-256-gcm}

echo "========================================="
echo "  Shadowsocks Server (Rust)"
echo "  Port: $SS_PORT"
echo "  Method: $SS_METHOD"
echo "  Password: $SS_PASSWORD"
echo "========================================="

printf '{"server":"0.0.0.0","server_port":%s,"password":"%s","method":"%s","mode":"tcp_and_udp","fast_open":false}' \
  "$SS_PORT" "$SS_PASSWORD" "$SS_METHOD" > /tmp/config.json

exec ssserver -c /tmp/config.json
