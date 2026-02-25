#!/usr/bin/env bash
set -euo pipefail

# Usage:
#   export BRIDGE_URL="http://100.66.211.57:6061/chat"
#   export BRIDGE_TOKEN="..."
#   ./scripts/bridge-chat.sh "what's my next event?"

URL="${BRIDGE_URL:-http://100.66.211.57:6061/chat}"
TOKEN="${BRIDGE_TOKEN:-}"
SOURCE="${BRIDGE_SOURCE:-claude-laptop}"
TEXT="${*:-status}"

if [[ -z "$TOKEN" ]]; then
  echo "error: set BRIDGE_TOKEN"
  exit 1
fi

curl -sS -X POST "$URL" \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  -d "{\"text\":\"$TEXT\",\"source\":\"$SOURCE\"}"
echo
