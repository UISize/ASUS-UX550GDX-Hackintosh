# ACPI tables and patches

## Active tables

| Table | Origin and purpose | Notes |
|---|---|---|
| SSDT-PNLF | SSDTTime / Acidanthera pattern; root PNLF, APP0002, UID 19, Darwin-only | Working backlight and AppleBacklightDisplay; requires PNLF rename |
| SSDT-PLUG | Dortania/SSDTTime pattern adapted to OEM processor PR00 | plugin-type 1 and active X86PlatformPlugin |
| SSDT-EC-USBX | Laptop EC/USBX pattern adapted to LPCB | Preserve OEM EC0; provide Darwin EC compatibility device and USB power properties |
| SSDT-PMC | Acidanthera PMC sample used on this laptop | Shutdown/restart works with this table and failed without it in testing. Not a general Coffee Lake laptop requirement |
| SSDT-ASUS-SMC-NATIVE | Laptop-specific wrappers based on OEM methods and AsusSMC interface | Four DSDT renames, correct OEM namespace, working four-state keyboard light |

Readable sources are in `ACPI/Sources`; the AML files are the installed tables. The recorded compiler version is ACPICA 20251212.

### CPU and EC namespace

PLUG injects plugin-type through `_DSM` at `\_SB.PR00`. EC-USBX adds a Darwin-visible EC compatibility device under `\_SB.PCI0.LPCB`; it does not rename or disable the OEM EC0. USBX supplies sleep/wake power properties. ECEnabler and SMCBatteryManager have separate roles and must not be confused with a replacement OEM EC.

### PMC

PMCR is added below `\_SB.PCI0.LPCB`, with APP9876 and MMIO resource 0xFE000000/0x10000. Shutdown and restart work with SSDT-PMC. They failed after it was removed and NVRAM was reset, then worked again after it was put back. The reason is unknown.

### ASUS keyboard backlight

The wrapper depends on ATKD, ATKP, KBLC, KBLV, and OEM EC0 methods WRAM, ST9E, SLKB. KBLU advances the native level modulo 4 and calls SLKB with the apply bit. Existing OEM methods are renamed and called on non-Darwin paths. SKBV supplies the interface used by AsusSMC.

## ACPI renames

| Find bytes | Replace bytes | Scope / count |
|---|---|---|
| 504E4C46, PNLF | 584E4C46, XNLF | Any table; Count 0 |
| 5F51304500, _Q0E definition | 5851304500, XQ0E | DSDT; Count 1 |
| 5F51304600, _Q0F definition | 5851304600, XQ0F | DSDT; Count 1 |
| 4B424C4400, KBLD definition | 58424C4400, XBLD | DSDT; Count 1 |
| 4B424C5500, KBLU definition | 58424C5500, XBLU | DSDT; Count 1 |

Count 0 is unbounded, not zero replacements. The ASUS patterns include the definition suffix 00 and are not unrestricted name replacements. Recheck definition matches when adapting to a different firmware. OpenCore applies changes to firmware tables before adding replacement SSDTs; do not accidentally rename the replacement methods in the new table.

ACPI/Delete is empty; the five tables above are the active set.

## SD controller workaround

Physical hardware remains Intel 8086:A375 at `PciRoot(0x0)/Pci(0x14,0x5)`. Matching uses compatible/IOName `pci14e4,16bc` plus the CtlnaSDXC personality restricted to `0xa3758086`. The native AppleSDXC entry is blocked with StrategyDisable for Darwin 25.

The version-specific Kernel/Patch is:

| Field | Value |
|---|---|
| Identifier | com.apple.driver.CtlnaSDXC |
| Base | __ZN9CtlnaSDXC5startEP9IOService |
| Architecture | x86_64 |
| Kernel range | 25.0.0–25.99.99 |
| Limit / Count / Skip | 1024 /1 /0 |
| Find | 488BBB88000000488B07488D3539D6000031D2FF9078020000 |
| Replace | 488BBB88000000488B07488D3539D60000B201FF9078020000 |

The changed boolean requests PCI configuration preservation/restoration. Runtime IORegistry shows IOPMPCIConfigSpaceVolatile=true. Reference testing confirmed post-sleep eject/reinsert after the change. The patch is specific to CtlnaSDXC 1.9.0 and the stated kernel range.

The exact package source is listed in [Dependencies](Dependencies.md).

## Shared-GPE S4 wake restriction

The firmware-specific patch limits four OEM `GPRW(0x6D, 4)` return expressions to `GPRW(0x6D, 3)`, while XHC keeps its existing S3 declaration. It prevents immediate S4 wake with AC power and a USB mouse on this laptop.

The patch targets the DSDT (`Notebook`, 275425 bytes) and also affects Windows booted through OpenCore. Keep its table restrictions and use the power button to resume from S4. Exact fields and tests: [Hibernation](Hibernation.md).
