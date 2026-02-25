#!/usr/bin/env bash
set -euo pipefail

# Usage:
#   export BRIDGE_TOKEN="..."
#   ./scripts/bridge-debug.sh "ping"

TOKEN="${BRIDGE_TOKEN:-}"
MSG="${*:-ping}"
SRC="${BRIDGE_SOURCE:-claude-laptop-debug}"

if [[ -z "$TOKEN" ]]; then
  echo "error: set BRIDGE_TOKEN"
  exit 1
fi

curl -sS "http://100.66.211.57:6061/claude-debug-channel?token=${TOKEN}&m=$(python3 -c 'import urllib.parse,sys; print(urllib.parse.quote(sys.argv[1]))' "$MSG")&s=$(python3 -c 'import urllib.parse,sys; print(urllib.parse.quote(sys.argv[1]))' "$SRC")"
echo
