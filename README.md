# depue-home network ops kit

## Files
- `/Users/chadd/dev/depue-home/inventory.yaml`: source of truth for hosts, LAN IPs, MACs, and Tailscale state.
- `/Users/chadd/dev/depue-home/dhcp-reservations.csv`: proposed static IP mapping for pfSense.
- `/Users/chadd/dev/depue-home/docs/tailscale-pfsense-rollout.md`: end-to-end rollout and DNS/routing/security settings.
- `/Users/chadd/dev/depue-home/docs/tailscale-acl.example.json`: starter Tailscale ACL policy.
- `/Users/chadd/dev/depue-home/docs/pfsense-audit-2026-02-21.md`: captured current pfSense state and concrete gaps.
- `/Users/chadd/dev/depue-home/docs/pfsense-changes-2026-02-21.md`: changes applied in pfSense and remaining blocker.
- `/Users/chadd/dev/depue-home/docs/wifi-config-2026-03-11.md`: current UniFi WiFi config — APs, switch, channel plan, roaming, and known issues.
- `/Users/chadd/dev/depue-home/docs/wifi-config-2026-02-24.md`: initial WiFi tuning session (superseded by 2026-03-11).
- `/Users/chadd/dev/depue-home/unifi-device-backup-2026-03-11.json`: UniFi device config backup (post U7 Pro + switch install).
- `/Users/chadd/dev/depue-home/unifi-wlan-backup-2026-03-11.json`: UniFi WLAN/SSID config backup.
- `/Users/chadd/dev/depue-home/unifi-device-backup-2026-02-24.json`: UniFi device config backup (initial tuning).
- `/Users/chadd/dev/depue-home/unifi-wlan-backup-2026-02-24.json`: UniFi WLAN/SSID config backup (initial tuning).
- `/Users/chadd/dev/depue-home/docs/echo-openclaw-intent-matrix.md`: intent routing plan for Echo ↔ Claude ↔ OpenClaw bridge.

## Scripts
- `/Users/chadd/dev/depue-home/scripts/discover-lan.sh`: discover active devices on `10.1.2.0/24`.
- `/Users/chadd/dev/depue-home/scripts/collect-host-facts.sh`: run on each machine to capture local LAN + Tailscale facts.
- `/Users/chadd/dev/depue-home/scripts/bridge-chat.sh`: call OpenClaw bridge `/chat` endpoint (sync response JSON).
- `/Users/chadd/dev/depue-home/scripts/bridge-debug.sh`: call `/claude-debug-channel` for coordination/debug pings.

## Quick start
1. `bash /Users/chadd/dev/depue-home/scripts/discover-lan.sh 10.1.2.0/24 /Users/chadd/dev/depue-home`
2. Run `/Users/chadd/dev/depue-home/scripts/collect-host-facts.sh` on each host and merge values into `/Users/chadd/dev/depue-home/inventory.yaml`.
3. Add/update pfSense DHCP reservations from `/Users/chadd/dev/depue-home/dhcp-reservations.csv`.
4. Apply DNS + Tailscale settings from `/Users/chadd/dev/depue-home/docs/tailscale-pfsense-rollout.md`.

## Echo/OpenClaw bridge quick usage

Set token once per shell:

```bash
export BRIDGE_TOKEN="<your-bridge-token>"
```

Use Makefile:

```bash
make bridge-chat q="what is my next calendar event?"
make bridge-debug q="ping from claude"
```

Use wrapper:

```bash
./scripts/bridge chat "what's next?"
./scripts/bridge debug "hello"
```
