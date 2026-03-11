# WiFi Configuration - 2026-03-11

## Overview

5 Ubiquiti access points (4 active + 1 disabled AC Mesh).
1 managed PoE switch (USW-Lite-16-PoE).
Controller: UniFi OS Server on hood (10.1.2.5).
SSID: CBD (WPA2 Personal, 802.11r fast roaming, 802.11v BSS transition).

## Physical Layout

```
┌──────────────────────┐
│       Patio           │  (future: AC Mesh here)
├──────────┬───────────┤
│ ① Living │   Kitchen │  ① AC Pro (Living Room)
│   Room   │           │
├──────────┴───────────┤
│ ② Guest Bedroom      │  ② U7 Pro (Guest Bedroom) ★ NEW
├──────────┬───────────┤
│ ③ Office │ ④ Main    │  ③ AC Pro (Office)
│          │   Bed     │  ④ AC Pro (Main Bedroom)
└──────────┴───────────┘

Switch: USW-Lite-16-PoE in laundry room (star topology to all APs)
```

## Active AP Configuration

| AP | Model | IP | 2.4GHz Ch | 5GHz Ch | 6GHz Ch | HT 2.4 | HT 5 | HT 6 | TX Power | Min RSSI |
|---|---|---|---|---|---|---|---|---|---|---|
| AC Pro (Living Room) | U7PG2 | 10.1.2.77 | 1 | 149 | - | 20 MHz | 80 MHz | - | medium | -67 dBm |
| U7 Pro (Guest Bedroom) | U7PRO | 10.1.2.82 | 6 | 48 | 117 (auto) | 20 MHz | 80 MHz | 160 MHz | medium | -67 dBm |
| AC Pro (Office) | U7PG2 | 10.1.2.87 | 11 | 36 | - | 20 MHz | 80 MHz | - | medium | -67 dBm |
| AC Pro (Main Bedroom) | U7PG2 | 10.1.2.76 | 1 | 140 | - | 20 MHz | 80 MHz | - | medium | -67 dBm |

## Disabled Devices

| AP | Model | IP | Reason |
|---|---|---|---|
| AC Mesh (Kitchen) | U7MSH | 10.1.2.115 | Planned for patio; needs ethernet through wall or wireless mesh to a non-bottlenecked AP |

## Switch

| Device | Model | IP | Ports | PoE |
|---|---|---|---|---|
| USW-Lite-16-PoE (Laundry) | USL16LPB | 10.1.2.84 | 16 GbE | 8 PoE ports, 45W budget |

## Wired Topology

All APs are star-wired back to the USW-Lite-16-PoE in the laundry room via in-wall ethernet. No daisy-chaining — each AP uses only Port 1 to its wall jack.

```
pfSense Gateway (10.1.2.1)
  └── USW-Lite-16-PoE (Laundry) ── 10.1.2.84
        ├── U7 Pro (Guest Bedroom) ── GbE
        ├── AC Pro (Main Bedroom) ── GbE
        ├── AC Pro (Office) ── GbE
        ├── AC Pro (Living Room) ── GbE
        └── (other wired devices)
```

Note: UniFi may display an inferred daisy-chain topology because the switch was previously unmanaged. With the USW-Lite-16-PoE now adopted, the controller should show the correct star topology.

## SSID Settings

- SSID: CBD
- Security: WPA2 Personal
- Fast Roaming (802.11r): enabled
- BSS Transition (802.11v): enabled

## Channel Plan

### 2.4 GHz (20 MHz width)
Channels 1, 6, 11 — the only non-overlapping 2.4 GHz channels.
Assigned by physical location to minimize co-channel interference:

- **Ch 1**: Living Room (top-left) + Main Bedroom (bottom-right) — maximally separated
- **Ch 6**: Guest Bedroom (center)
- **Ch 11**: Office (bottom-left)

### 5 GHz (80 MHz width)
All on non-overlapping channels:

- **Ch 36**: Office (UNII-1, non-DFS)
- **Ch 48**: Guest Bedroom (UNII-1, non-DFS)
- **Ch 140**: Main Bedroom (UNII-3, DFS — stable, low error rate)
- **Ch 149**: Living Room (UNII-3, non-DFS)

### 6 GHz (160 MHz width) — U7 Pro only
- **Ch 117 (auto)**: Guest Bedroom — WiFi 7, uncongested band for newer devices (iPhone 15+, M-series Macs)

## Roaming Configuration

- **Min RSSI**: -67 dBm on all APs (most aggressive allowed; kicks clients when signal degrades)
- **TX Power**: medium on all APs (tighter cells reduce overlap, force faster roaming)
- **802.11r**: enabled (fast BSS transition for seamless roaming)
- **802.11v**: enabled (AP-assisted roaming suggestions)

## Known Issues

### AC Mesh (Kitchen) — Disabled
Planned to be relocated to patio after drilling through wall.
When re-enabled, should be wired (ethernet through wall) not wireless mesh.
Re-enable temporarily for parties to split load with Living Room AP.

### Living Room 100 Mbps Uplink (Resolved)
Previously negotiated at Fast Ethernet (100 Mbps) intermittently. Resolved itself after AP reprovision — likely an intermittent PHY negotiation flap on aging AC Pro hardware. Monitor for recurrence.

## Change History

### 2026-03-11
1. Replaced dead AC Pro (Guest Bedroom) with U7 Pro (WiFi 7, tri-band)
2. Replaced Netgear GS116 unmanaged switch with USW-Lite-16-PoE (managed, PoE)
3. Adopted and configured both new devices
4. Removed dead AC Pro (Guest Bedroom) from controller
5. Restored Office and Main Bedroom to normal settings (were temporarily at high TX power to cover Guest Bedroom gap)

### 2026-02-24
1. Disabled Kitchen Mesh (was causing ch 149 co-channel interference with Living Room)
2. Moved Guest Bedroom 5GHz from DFS ch 100 → ch 48 (was generating ~74K tx_errors/day)
3. Enabled 802.11r fast roaming on CBD SSID
4. Set min RSSI to -67 dBm on all APs (most aggressive allowed)
5. Reduced TX power to medium on all APs (tighter cells for better roaming)
6. Spread 2.4GHz across channels 1, 6, 11 (was all on ch 6)

## Backup Files

- `unifi-device-backup-2026-03-11.json` — full device config after U7 Pro and switch install
- `unifi-wlan-backup-2026-03-11.json` — WLAN/SSID config
- `unifi-device-backup-2026-02-24.json` — device config from initial tuning session
- `unifi-wlan-backup-2026-02-24.json` — WLAN config from initial tuning session
