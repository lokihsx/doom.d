#!/usr/bin/env bash
set -euo pipefail

User=loki
Addr=192.168.222.201

if [ $# -eq 1 ]; then
    ssh $User@$Addr "/usr/local/bin/fcitx-remote $1"
else
    ssh $User@$Addr "/usr/local/bin/fcitx-remote"
fi
