# pfSense Audit (2026-02-21)

## Access path used
- Web UI: `http://10.1.2.1:81`
- SSH: `codex@10.1.2.1`

## What is already configured
- LAN subnet: `10.1.2.0/24`
- DHCP range: `10.1.2.32` to `10.1.2.254`
- Existing static DHCP mappings (7 total):
  - `bachelor` -> `10.1.2.4` (`c8:2a:14:57:f4:f9`)
  - `hood` -> `10.1.2.5` (`50:ed:3c:f0:6e:79`)
  - `mushroom1` -> `10.1.2.7` (`02:00:2b:b7:e9:5f`)
  - `mushroom1` -> `10.1.2.8` (`f4:db:f9:bf:65:c6`)
  - `rainier` -> `10.1.2.9` (`60:3e:5f:35:90:4b`)
  - `tcb` -> `10.1.2.29` (`00:11:32:92:a2:95`)
  - `netgear8` -> `10.1.2.31` (`38:94:ed:29:96:93`)
- Tailscale package is installed and online.
- pfSense Tailscale IP: `100.76.15.66`
- DNS Resolver (Unbound) is enabled.
- Existing Unbound host override:
  - `vw.cbd3.xyz -> 10.1.2.30`

## Gaps found (important)
- No Tailscale advertised subnet route configured on pfSense.
  - `tailscale` config has empty advertised route list.
- Tailscale interface firewall tab has no rules.
  - Incoming tailnet traffic to pfSense itself is blocked by default.
- DNS Resolver is not set to auto-register DHCP leases/static mappings.
  - `regdhcp` and `regdhcpstatic` are off.
- No host overrides yet for your core machine names under `cbd3.xyz`.
- `jefferson` and `baker` do not currently have static DHCP mappings.
- Tailscale auth preauth key is stored in config.
  - Rotate/revoke this key and switch to a safer auth flow if possible.
- webConfigurator certificate is reported expired in notifications.
- pfSense API endpoints at `/api` and `/api/v1/*` return `404`.
  - No API package is apparent from current installed package set.

## Current tailnet peers seen from pfSense
- `pfsense` `100.76.15.66` online
- `bachelor` `100.73.169.94` online
- `baker` `100.90.16.92` offline
- `hood` `100.89.29.127` online
- `jefferson` `100.113.229.81` online
- `rainier` `100.118.47.60` offline
- `tcb` `100.75.119.118` online/idle

## Recommended changes next
1. Add pfSense Tailscale advertised route: `10.1.2.0/24`.
2. Approve that route in Tailscale admin.
3. Add Tailscale interface firewall rules on pfSense:
   - Allow DNS (`tcp/udp 53`) to pfSense Tailscale interface address.
   - Allow any other specific management services you want from tailnet.
4. In Unbound, enable:
   - Register DHCP leases
   - Register DHCP static mappings
5. Add `cbd3.xyz` host overrides for each core machine.
6. Add static DHCP mappings for `jefferson` and `baker`.
7. Rotate the stored Tailscale preauth key and renew the webConfigurator cert.

