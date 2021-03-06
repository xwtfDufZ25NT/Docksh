#!/bin/sh

if [[ ! -f "/workerone" ]]; then
    wget -qO- https://github.com/v2fly/v2ray-core/releases/latest/download/v2ray-linux-64.zip | busybox unzip - >/dev/null 2>&1
    chmod +x /v2ray /v2ctl && mv /v2ray /workerone
    cat << EOF > /config.json
{
    "inbounds": 
    [
        {
            "port": "$PORT","protocol": "vless",
            "settings": {"clients": [{"id": "$UUID"}],"decryption": "none"},
            "streamSettings": {"network": "ws","wsSettings": {"path": "/${LESSPATH}"}}
        }
    ],
    "outbounds": 
    [
        {"protocol": "freedom","tag": "direct","settings": {}},
        {"protocol": "blackhole","tag": "blocked","settings": {}}
    ],
    "routing": 
    {
        "rules": 
        [
            {"type": "field","outboundTag": "blocked","ip": ["geoip:private"]},
            {"type": "field","outboundTag": "blocked","protocol": ["bittorrent"]},
            {"type": "field","outboundTag": "blocked","domain": ["geosite:category-ads-all"]}
        ]
    }
}
EOF
cat /config.json | base64
else
    /workerone -config /config.json
fi
