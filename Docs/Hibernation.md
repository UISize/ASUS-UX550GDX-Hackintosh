# Hibernation

Reference: **ASUS UX550GDX / UX580GD, firmware UX550GDX.312, OpenCore 1.0.8 RELEASE, macOS Tahoe 26.7.1**. The supplied EFI already includes these settings; macOS power settings must be applied separately.

## OpenCore settings

| Setting | Value |
|---|---|
| `UEFI/ReservedMemory` | One enabled entry: Address `569344` (`0x8B000`), Size `4096`, Type `RuntimeCode` |
| `Booter/Quirks/DiscardHibernateMap` | `true` |
| `ACPI/Quirks/ResetHwSig` | `true` |
| `Misc/Boot/HibernateMode` | `Auto` |
| `Misc/Boot/HibernateSkipsPicker` | `true` |
| `Misc/Boot/PollAppleHotKeys` | `true` |
| `Kernel/Quirks/PowerTimeoutKernelPanic` | `false` |

Load **HibernationFixup 1.5.4 RELEASE** after Lilu in `Kernel/Add` (x86_64, Darwin 25.0.0–25.99.99). Add `hbfx-ahbm=1` to the existing boot arguments to enable its auto-hibernation support.

On this laptop the reservation fixed a frozen or black screen when resuming from hibernation. What the firmware uses this memory for is unknown. Do not copy it to other hardware just because the page appears free.

## ACPI patch: prevent immediate S4 wake

Four OEM wake declarations share GPE `0x6D` and permit S4 wake. Restricting these to S3 resolved immediate wake on AC with a USB mouse; normal S3 mouse wake remained functional. No additional SSDT is required.

Use this `ACPI/Patch` entry:

| Field | Value |
|---|---|
| TableSignature | Data: `44534454` (DSDT) |
| OemTableId | Data: `4E6F7465626F6F6B` (Notebook) |
| TableLength | Integer: `275425` |
| Find | Data: `A4475052570A6D0A04` |
| Replace | Data: `A4475052570A6D0A03` |
| Count | Integer: `4` |
| Skip / Limit / BaseSkip | Integer: `0` each |
| Base | Empty string |
| Mask / ReplaceMask | Empty data |
| Enabled | Boolean: `true` |

The OEM DSDT contains four matches. Retain the firmware restrictions. This patch applies on battery and to Windows booted through OpenCore too; it is not Darwin-only. Use the power button to resume from S4.

## macOS power policy

Save `pmset -g custom` before changing settings. The policy on this laptop is:

```sh
sudo pmset -a hibernatemode 3 standby 1 standbydelayhigh 1800 standbydelaylow 60 highstandbythreshold 9
sudo pmset -b powernap 0
sudo pmset -c powernap 1 womp 1
```

The high-charge standby delay is 30 minutes; the low-charge delay is 60 seconds, with threshold 9. Assertions and maintenance activity can delay the transition. Do not set the low delay to zero: it caused early hibernation during testing.

## Test scope

**Tested**

- Direct S4 resume and automatic S3-to-S4 resume with accelerated 60-second delays.
- The AC/USB immediate-wake fix, with normal S3 mouse wake still working.

**Not tested**

- The final 30-minute cycle and low-battery behavior.
- The restored AC PowerNap/network-wake combination.
- Overnight reliability and FileVault resume.

A brief graphics artifact appeared during otherwise successful resume. Keep a working recovery EFI and generate a fresh hibernation image after configuration changes.

References: [OpenCore 1.0.8 configuration](https://github.com/acidanthera/OpenCorePkg/blob/1.0.8/Docs/Configuration.tex), [HibernationFixup 1.5.4](https://github.com/acidanthera/HibernationFixup/tree/1.5.4).
