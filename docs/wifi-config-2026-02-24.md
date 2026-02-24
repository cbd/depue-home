# WiFi Configuration - 2026-02-24

## Overview

5 Ubiquiti access points (4 active AC Pro + 1 disabled AC Mesh).
Controller: UniFi OS Server on hood (10.1.2.5).
SSID: CBD (WPA2 Personal, 802.11ac).

## Physical Layout

```
┌──────────────────────┐
│       Patio           │  (future: AC Mesh here)
├──────────┬───────────┤
│ ① Living │ ⑤ Kitchen │  ① AC Pro (Living Room)
│   Room   │           │  ⑤ AC Mesh (Kitchen) - DISABLED
├──────────┴───────────┤
│ ② Guest Bedroom      │  ② AC Pro (Guest Bedroom)
├──────────┬───────────┤
│ ③ Office │ ④ Main    │  ③ AC Pro (Office)
│          │   Bed     │  ④ AC Pro (Main Bedroom)
└──────────┴───────────┘
```

## Active AP Configuration

| AP | IP | 2.4GHz Ch | 5GHz Ch | HT 2.4 | HT 5 | TX Power | Min RSSI |
|---|---|---|---|---|---|---|---|
| AC Pro (Living Room) | 10.1.2.77 | 1 | 149 (auto) | 20 MHz | 80 MHz | medium | -67 dBm |
| AC Pro (Guest Bedroom) | 10.1.2.116 | 6 | 48 | 20 MHz | 80 MHz | medium | -67 dBm |
| AC Pro (Office) | 10.1.2.87 | 11 | 36 | 20 MHz | 80 MHz | medium | -67 dBm |
| AC Pro (Main Bedroom) | 10.1.2.76 | 1 | 140 | 20 MHz | 80 MHz | medium | -67 dBm |

## Disabled Devices

| AP | IP | Reason |
|---|---|---|
| AC Mesh (Kitchen) | 10.1.2.115 | Planned for patio; was causing ch 149 interference with Living Room and all traffic bottlenecked through Living Room 100Mbps link |

## Wired Topology

```
Gateway/Switch
  └── AC Pro (Guest Bedroom) ── GbE (root)
        └── AC Pro (Main Bedroom) ── GbE
              ├── AC Pro (Office) ── GbE
              └── AC Pro (Living Room) ── FE (100 Mbps) ⚠️
```

## SSID Settings

- SSID: CBD
- Security: WPA2 Personal
- Fast Roaming (802.11r): enabled
- BSS Transition (802.11v): enabled

## Channel Plan Rationale

### 2.4 GHz (20 MHz width)
Channels 1, 6, 11 are the only non-overlapping 2.4 GHz channels.
Assigned by physical location to minimize co-channel interference:

- **Ch 1**: Living Room (top-left) + Main Bedroom (bottom-right) — maximally separated
- **Ch 6**: Guest Bedroom (center)
- **Ch 11**: Office (bottom-left)

### 5 GHz (80 MHz width)
All on non-overlapping channels, Guest Bedroom moved off DFS ch 100:

- **Ch 36**: Office (UNII-1, non-DFS)
- **Ch 48**: Guest Bedroom (UNII-1, non-DFS)
- **Ch 140**: Main Bedroom (UNII-3, DFS — stable, low error rate)
- **Ch 149**: Living Room (UNII-3, non-DFS)

## Known Issues

### Living Room 100 Mbps Uplink
The Living Room AP negotiates at Fast Ethernet (100 Mbps) instead of GbE.
Cable tests OK with a tester. Possible causes:
- Cable has a fault on pins 4/5/7/8 (GbE needs all 8; FE only needs 4 — basic testers may not catch this)
- Damaged port on the AP
- Try: swap cable, test with a different AP, try the other port

### AC Mesh (Kitchen) — Disabled
Planned to be relocated to patio after drilling through wall.
When re-enabled, should be wired (ethernet through wall) not wireless mesh.
If wired isn't possible, mesh to an AP other than Living Room to avoid the 100 Mbps bottleneck.

## Changes Applied 2026-02-24

1. Disabled Kitchen Mesh (was causing ch 149 co-channel interference with Living Room)
2. Moved Guest Bedroom 5GHz from DFS ch 100 → ch 48 (was generating ~74K tx_errors/day)
3. Enabled 802.11r fast roaming on CBD SSID
4. Set min RSSI to -67 dBm on all APs (most aggressive allowed)
5. Reduced TX power to medium on all APs (tighter cells for better roaming)
6. Spread 2.4GHz across channels 1, 6, 11 (was all on ch 6)

## Backup Files

- `unifi-device-backup-2026-02-24.json` — full device config from `/api/s/default/stat/device`
- `unifi-wlan-backup-2026-02-24.json` — WLAN/SSID config from `/api/s/default/rest/wlanconf`
