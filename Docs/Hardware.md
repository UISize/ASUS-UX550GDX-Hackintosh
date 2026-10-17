# Test hardware

The test laptop identifies itself as **ASUS ZenBookPro15 UX550GDX_UX580GD**, with a UX550GDX board and firmware UX550GDX.312. macOS sees it as a MacBookPro16,1 through SMBIOS emulation.

| Device | Identifiers / details | Notes |
|---|---|---|
| CPU | Core i7-8750H, Coffee Lake, 6 cores / 12 threads | OEM first processor is `\_SB.PR00`; X86PlatformPlugin active |
| Memory | 2 × 8 GB Samsung DDR4-2400 | No custom memory injection required by the documented baseline |
| iGPU | Intel UHD 630, 8086:3E9B | Platform ID data `0900A53E` |
| dGPU | GTX 1050, 10DE:1C8D | Excluded from the macOS graphics configuration |
| Panel | CMN15E8, N156HCE-EN1, Full HD | Backlight uses root PNLF UID 19 and the documented WEG settings |
| Audio | ALC295; HDA 8086:A348 | Modified VoodooHDA_BL personality matches the actual HDA controller |
| Wi-Fi | Intel Wireless-AC 9560, 8086:A370 | Native AirportItlwm Tahoe development build |
| Bluetooth | 8087:0AAA, internal USB port 14 | Intel firmware/persistence fixes; map connector type 255 |
| Trackpad | Goodix GDX1515, 27C6:01F4 | I2C1/ETPD, VoodooI2C/HID |
| Card reader | Intel 8086:A375, subsystem 8086:7270, revision 10 | PCI `PciRoot(0x0)/Pci(0x14,0x5)` |
| Webcam | AzureWave 13D3:5755 UVC | Internal USB port 9 |
| Main USB controller | Intel 8086:A36D | ACPI XHC; eight selected ports |
| Secondary USB controller | Intel 8086:15D4 | Thunderbolt-related XHCI; no ports enabled in the current map |
| Storage | SN730 512 GB, firmware 11110000 | PCIe x4 at 8 GT/s, TRIM enabled; SMART status verified in the system report |

## Ethernet

The laptop has no built-in Ethernet port. USB Ethernet adapters and Recovery downloads over them are not tested. Compatibility depends on the chipset, USB path and operating environment.

## Display routing

Windows display-path queries show the internal Full-HD panel on Intel and the ScreenPad on NVIDIA. According to the board-family schematic, HDMI goes through NVIDIA, while Intel DisplayPort signals go toward the Alpine Ridge USB-C/Thunderbolt path. USB-C DisplayPort output and Thunderbolt are not tested.

Sources: [ASUS UX580GD support](https://www.asus.com/us/supportonly/ux580gd/helpdesk_download/), [ASUS product guide](https://www.asus.com/event/2018/productguide/th/ASUS-Product-Guide-Q4-2018.pdf), [board-family schematic reference](https://www.scribd.com/document/757185255/Asus-Ux550gd-Ux550ge-Rev2-1).
