# Tailscale + pfSense Rollout (cbd3.xyz)

## Goal
- Every important host on `10.1.2.0/24` is inventoried.
- Core hosts run Tailscale directly.
- pfSense advertises `10.1.2.0/24` as a subnet route for anything without Tailscale.
- DNS works from tailnet clients so `*.cbd3.xyz` resolves to your internal machines.

## Recommended naming
- Keep hostnames short and stable: `tcb`, `bachelor`, `rainier`, `jefferson`, `hood`, `baker`.
- Use `cbd3.xyz` as an internal-only split DNS zone in pfSense.
- Create records like `tcb.cbd3.xyz`, `bachelor.cbd3.xyz`, etc.

## Inventory workflow
1. Run LAN discovery from one machine on your LAN:
   - `bash /Users/chadd/dev/depue-home/scripts/discover-lan.sh 10.1.2.0/24`
2. Run host facts collection on each computer:
   - `bash /Users/chadd/dev/depue-home/scripts/collect-host-facts.sh`
3. Merge findings into:
   - `/Users/chadd/dev/depue-home/inventory.yaml`

## pfSense configuration checklist

### 1) DHCP static mappings (LAN)
- Navigate: `Services -> DHCP Server -> LAN`
- For each known machine, add static mapping:
  - `MAC address`
  - `IP address` in `10.1.2.0/24`
  - `Hostname` matching inventory
- Reserve a clean range, for example:
  - Infra/servers: `10.1.2.10-10.1.2.49`
  - User computers: `10.1.2.50-10.1.2.119`
  - DHCP dynamic pool: `10.1.2.150-10.1.2.249`

### 2) DNS Resolver host overrides
- Navigate: `Services -> DNS Resolver -> Host Overrides`
- Add one record per host:
  - Host: `tcb`
  - Domain: `cbd3.xyz`
  - IP: (static LAN IP)
- Repeat for each host.

Optional:
- Also add the same names under `home.arpa` (for pure-local naming).

### 3) Tailscale on pfSense (subnet router)
- In pfSense Tailscale settings:
  - Ensure pfSense node is connected.
  - Advertise route: `10.1.2.0/24`
- In Tailscale admin console:
  - Approve the advertised subnet route.

This ensures remote tailnet devices can reach all LAN nodes, even if a node itself does not run Tailscale.

### 4) Make pfSense DNS reachable over tailnet
- DNS Resolver should listen on interface(s) that include Tailscale (or `All`).
- Add pfSense firewall rule on Tailscale interface:
  - Allow TCP/UDP 53 from tailnet to pfSense.
- Note pfSense Tailscale IP (`100.x.y.z`).

## Tailscale DNS setup

In Tailscale Admin -> DNS:
- Keep MagicDNS enabled.
- Add split DNS:
  - Domain: `cbd3.xyz`
  - Nameserver: pfSense Tailscale IP (for example `100.x.y.z`)

Result:
- From any tailnet client, `tcb.cbd3.xyz` resolves via pfSense.
- MagicDNS names (`hostname.<tailnet>.ts.net`) continue to work.

## Security defaults (recommended)

Use a restrictive ACL policy as a baseline and then open what you need:
- Members can always reach their own devices.
- Only admin group can reach everything.
- Servers are tagged and only exposed on required ports.

Use `/Users/chadd/dev/depue-home/docs/tailscale-acl.example.json` as a starting point.

## Suggested rollout order
1. Fill `inventory.yaml` with MAC + static LAN IP for each known host.
2. Add DHCP reservations in pfSense.
3. Ensure Tailscale installed/running on each host.
4. Enable/approve subnet route on pfSense.
5. Configure split DNS for `cbd3.xyz`.
6. Validate from an off-LAN tailnet client:
   - `ping tcb.cbd3.xyz`
   - `tailscale ping tcb`
   - `ssh <user>@bachelor.cbd3.xyz`

## Validation commands
- Check local tailscale status:
  - `tailscale status`
- Check DNS path:
  - `dig +short tcb.cbd3.xyz`
- Check route visibility:
  - `tailscale status --json | jq '.Peer[]?.PrimaryRoutes'`

