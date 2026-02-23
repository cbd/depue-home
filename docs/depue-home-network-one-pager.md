# Depue Home Network One-Pager
**Last verified:** 2026-02-21  
**LAN:** `10.1.2.0/24`  
**Primary domain:** `cbd3.xyz`  
**Router / DNS / DHCP:** `pfsense` (`10.1.2.1`)  
**Tailscale subnet router + exit node:** `pfsense` (`100.99.236.93`)

## Devices
| Host | LAN IP | Tailscale IP | DHCP Reserved | Notes |
|---|---|---|---|---|
| `pfsense` | `10.1.2.1` | `100.99.236.93` | No | Firewall, DNS, DHCP |
| `tcb` | `10.1.2.29` | `100.75.119.118` | Yes | Synology |
| `bachelor` | `10.1.2.4` | `100.73.169.94` | Yes | Ubuntu Mac mini |
| `hood` | `10.1.2.5` | `100.89.29.127` | Yes | iMac |
| `jefferson` | `10.1.2.6` | `100.113.229.81` | Yes | MacBook Pro |
| `rainier` | `10.1.2.9` | `100.118.47.60` | Yes | MacBook Pro |
| `baker` | `10.1.2.10` | `100.90.16.92` | Yes | System76 laptop |
| `vw` | `10.1.2.30` | Unknown | Unknown | Existing DNS record |

## DNS Design
- MagicDNS ON for tailnet names (`*.tail487793.ts.net`)
- Split DNS for `cbd3.xyz` via pfSense resolver
- Unbound ACL allows Tailscale client ranges (`100.64.0.0/10`, `fd7a:115c:a1e0::/48`)
- DNS host overrides on pfSense:
  `baker`, `bachelor`, `hood`, `jefferson`, `pfsense`, `rainier`, `tcb`, `vw` under `cbd3.xyz`

## How To Reach Things
- Use LAN-domain names for local addressing: `host.cbd3.xyz` (example: `baker.cbd3.xyz`)
- Bare name `host` may resolve to Tailscale name first when MagicDNS has the same hostname
- Tailscale subnet route advertised by pfSense: `10.1.2.0/24`

## Quick Checks (on any machine)
```bash
nslookup pfsense.cbd3.xyz
nslookup baker.cbd3.xyz
ping -c 1 pfsense.cbd3.xyz
tailscale status
```

## If Something Breaks
1. Check `Tailscale Admin -> DNS`: split DNS `cbd3.xyz` -> `100.99.236.93`.
2. On pfSense, confirm DNS Resolver Access List `tailscale` exists and action is `Allow`.
3. Renew DHCP lease on device if IP does not match reservation.
4. Re-check in pfSense:
   `Services -> DHCP Server -> LAN` and `Services -> DNS Resolver`.
