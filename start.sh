#!/bin/bash
set -ex

if [ -z "$VLESS_UUID" ]; then
    VLESS_UUID="c1413fc0-716d-47d0-9b33-cfc9d0999a8d"
fi

LISTEN_PORT=${PORT:-8080}

echo "========================================="
echo "  Xray VLESS + WebSocket (nginx)"
echo "  External Port: $LISTEN_PORT"
echo "  Xray Port: 10080"
echo "  UUID: $VLESS_UUID"
echo "========================================="

# Update nginx to listen on Railway's PORT
sed -i "s/listen 8080;/listen $LISTEN_PORT;/" /etc/nginx/nginx.conf

cat > /tmp/config.json << EOF
{
    "log": {
        "loglevel": "warning"
    },
    "inbounds": [
        {
            "listen": "127.0.0.1",
            "port": 10080,
            "protocol": "vless",
            "settings": {
                "clients": [
                    {
                        "id": "$VLESS_UUID",
                        "flow": ""
                    }
                ],
                "decryption": "none"
            },
            "streamSettings": {
                "network": "ws",
                "wsSettings": {
                    "path": "/ws"
                }
            }
        }
    ],
    "outbounds": [
        {
            "protocol": "freedom"
        }
    ]
}
EOF

echo "Config:"
cat /tmp/config.json

# Start nginx
nginx -t
nginx

# Start Xray
exec xray run -c /tmp/config.json
