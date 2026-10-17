# Configuration

`EFI/OC/config.template.plist` derives from the installed configuration. The template uses empty/zero SMBIOS identifiers and includes only the active entries from the working installation.

## Identity and system scope

- SMBIOS: MacBookPro16,1.
- Supply a unique private SystemSerialNumber, MLB, SystemUUID, and six-byte ROM.
- The public template contains empty/zero identifiers and is not intended to boot unchanged.
- The installed macOS build is 26.7.1/25G241, Darwin 25.6.0. Explicit Darwin 25 ranges in specialist entries must not be widened blindly.

## Important quirks

| Area / setting | Value | Why |
|---|---|---|
| Booter EnableWriteUnprotector | true | Used in the working runtime setup; firmware logs report MAT support 0 |
| Booter RebuildAppleMemoryMap / SyncRuntimePermissions | false / false | Works with EnableWriteUnprotector; MAT support alone does not determine every quirk |
| Booter AvoidRuntimeDefrag / SetupVirtualMap | true / true | Used in the working memory-map configuration |
| Booter DiscardHibernateMap | true | Part of the working S4 setup; did not fix the freeze by itself |
| ACPI ResetHwSig | true | FACS-signature workaround in the working setup; did not fix the freeze by itself |
| Kernel AppleXcpmCfgLock | true | Enabled as a precaution. The firmware has no CFG Lock option; the actual MSR lock state is unknown |
| Kernel DisableIoMapper | true | VT-d remains enabled |
| Kernel DisableLinkeditJettison | true | Lilu-related kernel symbol retention |
| Kernel XhciPortLimit | false | Explicit USB map |
| Kernel SetApfsTrimTimeout | -1 | No custom TRIM timeout |
| Kernel PowerTimeoutKernelPanic | false | Timeout-panic suppression was disabled during hibernation diagnosis and is still disabled in the working setup |
| Kernel PanicNoKextDump | true | Enabled; may be disabled temporarily for a specific panic investigation |
| Kernel DisableRtcChecksum | false | RTC checksum workaround disabled |
| ACPI FadtEnableReset | false | Shutdown/restart works with the documented PMC setup |
| UEFI ReleaseUsbOwnership | true | Used in the working setup |
| UEFI RequestBootVarRouting | true | OpenCore boot-variable routing |

The template contains the complete settings; the table highlights hardware-specific choices.

## Hibernation configuration

The template includes HibernationFixup 1.5.4 RELEASE immediately after Lilu, HibernateMode=Auto, HibernateSkipsPicker=true and PollAppleHotKeys=true. UEFI/ReservedMemory contains the laptop-specific 0x8B000 / 4096-byte RuntimeCode reservation. A table-restricted ACPI patch limits four shared-GPE 0x6D wake declarations from S4 to S3. These are firmware-specific workarounds, not generic Coffee Lake defaults.

The macOS energy policy is separate and is not applied by the EFI. See [Hibernation](Hibernation.md) for implementation details, power settings and test scope.

## DeviceProperties

| PCI path | Property | Value |
|---|---|---|
| PciRoot(0x0)/Pci(0x2,0x0) | AAPL,ig-platform-id | Data 0900A53E, little-endian 0x3EA50009 |
| PciRoot(0x0)/Pci(0x14,0x5) | compatible | String pci14e4,16bc |
| Same SD path | IOName | String pci14e4,16bc |

The SD properties provide matching behavior. The physical controller is Intel 8086:A375; no device-id/vendor-id spoof is configured.

## Boot arguments

| Argument | Purpose / limitation |
|---|---|
| -wegnoegpu | Exclude non-iGPU graphics through WhateverGreen |
| revpatch=sbvmm | RestrictEvents compatibility strategy |
| applbkl=1 | Used in the working backlight setup |
| -igfxblr | Intel backlight-register repair setting used in the working setup |
| unfairgva=4 | Used for the tested Apple Music playback configuration |
| hbfx-ahbm=1 | Enable the HBFX auto-hibernation bit used for the confirmed timed S3-to-S4 transition; not a percentage watcher |

The working backlight setup combines these arguments with one root PNLF table and its rename; individual argument removal has not been tested separately.

## Picker and recovery entries

OpenCanopy 1.0.8 RELEASE uses PickerMode=External, variant chris1111/Flavours-OSX26, UIScale=1, HideAuxiliary=true, Timeout=5 and PickerAttributes=148. The complete archive includes the resources.

Press Space to show auxiliary entries.

- AppleDebug=false, ApplePanic=false, SysReport=false.
- Misc/Debug/Target=0, DisplayLevel=0.
- No diagnostic boot arguments or continuous logger are enabled.
- SecureBootModel=Disabled, Vault=Optional, ScanPolicy=0.
- The installed system reports SIP enabled.

## Optional: hide OpenCore's own picker entries

The distributed EFI omits `.contentVisibility` markers. If an additional `EFI Boot` entry in the OpenCore picker simply opens OpenCore again, these optional markers can hide the redundant loader entries.

Create a plain-text file named `.contentVisibility` in each of these OpenCore directories:

- `EFI/BOOT/.contentVisibility`
- `EFI/OC/.contentVisibility`

Each file contains exactly:

```text
Disabled
```

Save without an added `.txt` extension, using ASCII or UTF-8 without a BOM. Place markers only beside your own OpenCore loaders, not at the ESP root or beside Windows/macOS boot files. They affect OpenCore picker discovery; they do not delete a loader or remove the firmware boot-menu entry.

To restore normal discovery, remove the optional marker files. No NVRAM reset is required. See the [OpenCore 1.0.8 reference manual](https://github.com/acidanthera/OpenCorePkg/blob/1.0.8/Docs/Configuration.tex).

## Optional: customize picker names

The supplied configuration uses generic OpenCore category labels. Choose one of the following methods for your own names.

### A separate name for each boot entry

1. Under `Misc -> Boot -> PickerAttributes`, clear `0x0004` (generic label images). For this configuration, change `148` (`0x94`) to `144` (`0x90`); the other enabled flags stay the same.
2. Create a plain ASCII text file named `.contentDetails` next to the actual target bootloader, containing your chosen entry title. OpenCore also supports `.disk_label.contentDetails` in that location. Preserve any existing file before editing.
3. Boot through OpenCore to display the entry title using the picker font.

Typical locations are:

| Entry | Location |
|---|---|
| Windows | The Windows ESP's `EFI/Microsoft/Boot/.contentDetails`, beside `bootmgfw.efi` |
| Installed macOS | The correct APFS Preboot volume/group directory's `System/Library/CoreServices/.contentDetails`, beside its `boot.efi` |
| FAT32 recovery-image media | `com.apple.recovery.boot/.contentDetails` |

Locate the actual bootloader and correct Preboot UUID for your installation; a volume/group UUID is not portable between machines. Use Preboot for the macOS entry rather than changing the sealed system volume. A file beside OpenCore itself labels OpenCore, not the operating system it later starts.

This method changes picker text without renaming a volume. With `PickerAttributes=144`, prerendered per-entry labels are disabled. If you instead enable `0x0002`, an existing `.disk_label` / `.disk_label_2x` image can take precedence over the text. Boot or OS updates may replace target-side naming files.

### One graphical name for an OS category

Keep `PickerAttributes=148` (`0x94`) and supply your own label images under `EFI/OC/Resources/Label`:

| Category | Standard-scale / double-scale files |
|---|---|
| macOS | `Apple.lbl` / `Apple.l2x` |
| macOS Recovery | `AppleRecv.lbl` / `AppleRecv.l2x` |
| Windows | `Windows.lbl` / `Windows.l2x` |

Generate both scales using the **macOS build** of OpenCore's `disklabel` utility, for example in a working directory:

```sh
disklabel -e "My System" Apple.lbl Apple.l2x
```

Copy the resulting pair to the matching Resources/Label location after preserving the original pair. Repeat for other categories as desired. The Windows utility does not support label encoding. These are binary images; a text file renamed to `.lbl` is not a label image. A category image applies to all automatically discovered entries in that category, so the per-entry method is preferable for distinguishing multiple installations.

Restore the generic upstream label pair or the original text file and PickerAttributes value to undo your change. These naming changes require no NVRAM reset.

Reference: [OpenCore 1.0.8 configuration manual](https://github.com/acidanthera/OpenCorePkg/blob/1.0.8/Docs/Configuration.tex) and [disklabel utility](https://github.com/acidanthera/OpenCorePkg/blob/1.0.8/Utilities/disklabel/disklabel.c).
