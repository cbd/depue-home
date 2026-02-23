#!/usr/bin/env bash
set -euo pipefail

host_name="$(hostname -s 2>/dev/null || hostname)"
os_name="$(uname -s)"

default_iface() {
  if command -v ip >/dev/null 2>&1; then
    ip route 2>/dev/null | awk '/^default/ {print $5; exit}'
    return
  fi
  if [[ "$os_name" == "Darwin" ]]; then
    route -n get default 2>/dev/null | awk '/interface:/{print $2; exit}'
    return
  fi
  echo ""
}

iface="$(default_iface || true)"

lan_ip() {
  if [[ -z "$iface" ]]; then
    echo ""
    return 0
  fi
  if command -v ip >/dev/null 2>&1; then
    ip -4 addr show dev "$iface" 2>/dev/null | awk '/inet / {print $2}' | cut -d/ -f1 | head -n1
    return
  fi
  if [[ "$os_name" == "Darwin" ]]; then
    ipconfig getifaddr "$iface" 2>/dev/null || true
    return
  fi
  ifconfig "$iface" 2>/dev/null | awk '/inet / {print $2; exit}'
}

mac_addr() {
  if [[ -z "$iface" ]]; then
    echo ""
    return 0
  fi
  if command -v ip >/dev/null 2>&1; then
    ip link show "$iface" 2>/dev/null | awk '/link\/ether/ {print $2; exit}'
    return
  fi
  ifconfig "$iface" 2>/dev/null | awk '/ether / {print $2; exit}'
}

ts_installed="false"
ts_up="false"
ts_ip=""
ts_name=""

if command -v tailscale >/dev/null 2>&1; then
  ts_installed="true"
  if tailscale status >/dev/null 2>&1; then
    ts_up="true"
  fi
  ts_ip="$(tailscale ip -4 2>/dev/null | head -n1 || true)"
  ts_name="$(tailscale status --self --json 2>/dev/null | jq -r '.Self.DNSName // empty' || true)"
fi

printf "hostname: %s\n" "$host_name"
printf "os: %s\n" "$os_name"
printf "interface: %s\n" "$iface"
printf "lan_ip: %s\n" "$(lan_ip)"
printf "mac: %s\n" "$(mac_addr)"
printf "tailscale_installed: %s\n" "$ts_installed"
printf "tailscale_up: %s\n" "$ts_up"
printf "tailscale_ip: %s\n" "$ts_ip"
printf "tailscale_dns_name: %s\n" "$ts_name"
