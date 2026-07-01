#!/bin/bash
set -e

# Generate a random password if not set
if [ -z "$SS_PASSWORD" ]; then
    export SS_PASSWORD=$(head -c 16 /dev/urandom | base64 | tr -d '/+=' | head -c 16)
    echo "========================================="
    echo "  Generated Password: $SS_PASSWORD"
    echo "========================================="
fi

# Default port
SS_PORT=${SS_PORT:-8388}
SS_METHOD=${SS_METHOD:-aes-256-gcm}

echo "========================================="
echo "  Shadowsocks Server"
echo "  Port: $SS_PORT"
echo "  Method: $SS_METHOD"
echo "  Password: $SS_PASSWORD"
echo "========================================="

# Generate client connection URI (ss://)
URI=$(echo -n "${SS_METHOD}:${SS_PASSWORD}@$(hostname -i 2>/dev/null || echo '0.0.0.0'):${SS_PORT}" | base64 -w0 2>/dev/null || echo "")
echo "  Connection URI: ss://${URI}"
echo "========================================="

# Start Shadowsocks
exec ss-server \
    -s 0.0.0.0 \
    -p "$SS_PORT" \
    -k "$SS_PASSWORD" \
    -m "$SS_METHOD" \
    -t 600 \
    --reuse-port \
    -d 8.8.8.8,8.8.4.4 \
    -u \
    -v
