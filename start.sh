#!/bin/bash
set -e

# Generate UUID if not set
if [ -z "$VLESS_UUID" ]; then
    VLESS_UUID=$(cat /proc/sys/kernel/random/uuid)
fi

LISTEN_PORT=${PORT:-8080}

echo "========================================="
echo "  Xray VLESS + WebSocket"
echo "  Port: $LISTEN_PORT"
echo "  UUID: $VLESS_UUID"
echo "========================================="

cat > /tmp/config.json << EOF
{
    "inbounds": [
        {
            "listen": "0.0.0.0",
            "port": $LISTEN_PORT,
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

exec xray run -c /tmp/config.json
