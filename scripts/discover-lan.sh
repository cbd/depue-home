#!/usr/bin/env bash
set -euo pipefail

NET="${1:-10.1.2.0/24}"
OUT_DIR="${2:-.}"
STAMP="$(date +%Y%m%d-%H%M%S)"
OUT_FILE="${OUT_DIR%/}/lan-discovery-${STAMP}.csv"

mkdir -p "$OUT_DIR"

echo "ip,hostname,mac,source" > "$OUT_FILE"

if command -v nmap >/dev/null 2>&1; then
  nmap -sn "$NET" -oG - \
    | awk '
        /^Host: / {
          ip=$2
          host=$3
          mac=""
          if (host == "()") host=""
          if (match($0, /MAC: ([0-9A-Fa-f:]{17})/, m)) mac=m[1]
          gsub(/[()]/, "", host)
          if (ip != "") printf "%s,%s,%s,nmap\n", ip, host, mac
        }
      ' \
    >> "$OUT_FILE"
else
  arp -an \
    | awk '
        /\(10\.1\.2\.[0-9]+\)/ {
          ip=$2
          mac=$4
          gsub(/[()]/, "", ip)
          if (mac == "(incomplete)") mac=""
          printf "%s,,%s,arp\n", ip, mac
        }
      ' \
    >> "$OUT_FILE"
fi

echo "Wrote $OUT_FILE"

