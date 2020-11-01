#!/bin/sh

if [[ ! -f "/workerone" ]]; then
    # install and rename
    wget -qO- https://github.com/v2fly/v2ray-core/releases/latest/download/v2ray-linux-64.zip | busybox unzip - >/dev/null 2>&1
    chmod +x /v2ray /v2ctl && mv /v2ray /workerone
    cat << EOF >/config.json
{
    "inbounds": 
    [
        {
            "listen": "0.0.0.0","port": $PORT,"protocol": "vmess",
            "settings": {"clients": [{"id": "$UUID","alterId": 128}],
            "disableInsecureEncryption": true},
            "streamSettings": {"network": "ws","wsSettings": {"path": "/${MESSPATH}"}}
        }
    ],
    "outbounds": [
        {
            "protocol": "freedom",
            "tag": "direct"
        },
        {
            "protocol": "blackhole",
            "tag": "block"
        }
    ]
}
cat /config.json | base64
EOF
else
    # start 
    /workerone -config /config.json > /dev/null 2>&1
fi