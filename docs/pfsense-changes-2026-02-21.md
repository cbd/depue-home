# pfSense Changes Applied (2026-02-21)

## Applied successfully
- DNS Resolver (`Unbound`)
  - Enabled `Register DHCP leases in DNS Resolver`
  - Enabled `Register DHCP static mappings in DNS Resolver`
  - Applied changes
- DHCP Server (LAN)
  - LAN domain set to `cbd3.xyz`
  - Added static mapping:
    - `jefferson` -> `10.1.2.6` (`66:5c:6e:d7:0c:51`)
    - `baker` -> `10.1.2.10` (`bc:cd:99:88:c1:01`)
- DNS host overrides (centralized on pfSense)
  - `baker.cbd3.xyz` -> `10.1.2.10`
  - `bachelor.cbd3.xyz` -> `10.1.2.4`
  - `hood.cbd3.xyz` -> `10.1.2.5`
  - `jefferson.cbd3.xyz` -> `10.1.2.6`
  - `pfsense.cbd3.xyz` -> `10.1.2.1`
  - `rainier.cbd3.xyz` -> `10.1.2.9`
  - `tcb.cbd3.xyz` -> `10.1.2.29`
  - Existing: `vw.cbd3.xyz` -> `10.1.2.30`
- Tailscale package settings
  - Advertised route set: `10.1.2.0/24`
  - Re-authenticated and online
  - pfSense Tailscale IP: `100.99.236.93`
  - Node currently reports: `offers exit node`
- Firewall rules on `Tailscale` tab
  - `Allow tailnet to LAN`
  - `Allow tailnet DNS to pfSense`
  - Applied firewall changes

## Remaining actions
1. Force/renew DHCP lease on `baker` so it moves from current active lease `10.1.2.40` to reserved `10.1.2.10`.
2. Force/renew DHCP lease on `jefferson` so it moves from current active lease `10.1.2.96` to reserved `10.1.2.6`.
3. In Tailscale Admin Console DNS settings, ensure split DNS:
   - Domain: `cbd3.xyz`
   - Nameserver: `100.99.236.93`
