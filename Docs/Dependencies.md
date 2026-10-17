# Components and versions

These are the versions in the working installation and EFI archive; use the exact builds for the Tahoe Wi-Fi, Bluetooth, audio and SD workarounds.

| Component | Baseline | Upstream / acquisition |
|---|---|---|
| OpenCore, BOOTx64, OpenRuntime, OpenCanopy, ResetNvramEntry, OpenShell | 1.0.8 RELEASE | [OpenCorePkg release](https://github.com/acidanthera/OpenCorePkg/releases/tag/1.0.8) |
| HfsPlus.efi | Version unknown; binary from the existing installation | [OcBinaryData](https://github.com/acidanthera/OcBinaryData) |
| Lilu | 1.7.2 RELEASE | [acidanthera/Lilu](https://github.com/acidanthera/Lilu/releases/tag/1.7.2) |
| HibernationFixup | 1.5.4 RELEASE | [Official release](https://github.com/acidanthera/HibernationFixup/releases/tag/1.5.4), [source and BSD-3-Clause notice](https://github.com/acidanthera/HibernationFixup/tree/1.5.4); requires Lilu |
| VirtualSMC, SMCBatteryManager, SMCProcessor | 1.3.8 RELEASE | [acidanthera/VirtualSMC](https://github.com/acidanthera/VirtualSMC/releases/tag/1.3.8) |
| ECEnabler | 1.0.6 | [1Revenger1/ECEnabler](https://github.com/1Revenger1/ECEnabler) |
| AsusSMC | 1.4.1 RELEASE | [hieplpvip/AsusSMC](https://github.com/hieplpvip/AsusSMC/releases/tag/1.4.1) |
| WhateverGreen | 1.7.1 RELEASE | [acidanthera/WhateverGreen](https://github.com/acidanthera/WhateverGreen/releases/tag/1.7.1) |
| NVMeFix | 1.1.3 RELEASE | [acidanthera/NVMeFix](https://github.com/acidanthera/NVMeFix/releases/tag/1.1.3) |
| RestrictEvents | 1.1.6 RELEASE | [acidanthera/RestrictEvents](https://github.com/acidanthera/RestrictEvents/releases/tag/1.1.6) |
| VoodooI2C | 2.9.1 RELEASE | [VoodooI2C/VoodooI2C](https://github.com/VoodooI2C/VoodooI2C/releases/tag/2.9.1) |
| VoodooInput / GPIO / I2CServices / I2CHID | 1.1.6 / 1.1 / 1 / 1 | Use the components from the selected VoodooI2C package; load order is listed below |
| VoodooPS2Controller / Keyboard | 2.3.7 RELEASE | [acidanthera/VoodooPS2](https://github.com/acidanthera/VoodooPS2/releases/tag/2.3.7) |
| USBToolBox | 1.2.0 | [USBToolBox/kext](https://github.com/USBToolBox/kext) |
| UTBMap | 1.1 generated map | Included laptop-specific map; see USB.md |
| VoodooHDA_BL | 3.7.0-alpha | [CloverHackyColor/VoodooHDA](https://github.com/CloverHackyColor/VoodooHDA/releases/tag/v3.7.0-alpha), target commit 88f1f24143ca267e97cab6fd5e3b3326fb8c4f0c; apply the personality change below |
| AirportItlwm Tahoe | 2.4.0-alpha RELEASE d695c97 | [laobamac/itlwm alpha release](https://github.com/laobamac/itlwm/releases/tag/v2.4.0-alpha), asset `AirportItlwm-Tahoe-v2.4.0-RELEASE-alpha-d695c97.zip` |
| IntelBluetoothFirmware / IntelBTPatcher | 2.5.0 RELEASE development build | [Dortania build](https://github.com/dortania/build-repo/releases/tag/IntelBluetoothFirmware-a414375), upstream commit a414375505fa3b014be32f8fca31b5bbfdf9f10f |
| BlueToolFixup | 2.7.2 RELEASE | [acidanthera/BrcmPatchRAM](https://github.com/acidanthera/BrcmPatchRAM/releases/tag/2.7.2); use BlueToolFixup only, not Broadcom firmware loaders |
| CtlnaSDXC | 1.9.0 | [Baio1977/Intel-NUC8i7HN](https://github.com/Baio1977/Intel-NUC8i7HN/tree/516da10d3508e4af1993b97a8a4d3561a846f0f6); pinned supplied binary, plus personality and Kernel/Patch |
| Flavours-OSX26 | Theme archive used on this laptop; no pinned upstream commit | [chris1111 theme collection](https://chris1111.github.io/My-Simple-OC-Themes/) |
| Required extra theme resources | FirmwareSettings/NetworkBoot labels and matching fonts | [OcBinaryData pinned tree](https://github.com/acidanthera/OcBinaryData/tree/32500d5e3313f11cad00351ba1c6f9a4aa6cb0f7) |

## Kext load order

The following 25-entry order matches Kernel/Add in config.plist. Nested entries refer to plugins inside the parent bundle.

| Order | Bundle path | Bundle version | Configured kernel range |
|---|---|---|---|
| 1 | `Lilu.kext` | 1.7.2 | Any |
| 2 | `HibernationFixup.kext` | 1.5.4 RELEASE | 25.0.0 - 25.99.99 |
| 3 | `VirtualSMC.kext` | 1.3.8 | Any |
| 4 | `ECEnabler.kext` | 1.0.6 | Any |
| 5 | `SMCBatteryManager.kext` | 1.3.8 | Any |
| 6 | `SMCProcessor.kext` | 1.3.8 | Any |
| 7 | `AsusSMC.kext` | 1.4.1 | Any |
| 8 | `WhateverGreen.kext` | 1.7.1 | Any |
| 9 | `NVMeFix.kext` | 1.1.3 | Any |
| 10 | `RestrictEvents.kext` | 1.1.6 | Any |
| 11 | `VoodooI2C.kext/Contents/PlugIns/VoodooInput.kext` | 1.1.6 | Any |
| 12 | `VoodooI2C.kext/Contents/PlugIns/VoodooGPIO.kext` | 1.1 | Any |
| 13 | `VoodooI2C.kext/Contents/PlugIns/VoodooI2CServices.kext` | 1 | Any |
| 14 | `VoodooI2C.kext` | 2.9.1 | Any |
| 15 | `VoodooI2CHID.kext` | 1 | Any |
| 16 | `VoodooPS2Controller.kext` | 2.3.7 | Any |
| 17 | `VoodooPS2Controller.kext/Contents/PlugIns/VoodooPS2Keyboard.kext` | 2.3.7 | Any |
| 18 | `USBToolBox.kext` | 1.2.0 | Any |
| 19 | `UTBMap.kext` | 1.1 | Any |
| 20 | `VoodooHDA_BL.kext` | 3.7.0 | >=25.0.0 |
| 21 | `AirportItlwm.kext` | 2.4.0 | 25.0.0 - 25.99.99 |
| 22 | `IntelBluetoothFirmware.kext` | 2.5.0 | >=25.0.0 |
| 23 | `IntelBTPatcher.kext` | 2.5.0 | >=25.0.0 |
| 24 | `BlueToolFixup.kext` | 2.7.2 | >=25.0.0 |
| 25 | `CtlnaSDXC.kext` | 1.9.0 | 25.0.0 - 25.99.99 |

AirportItlwm uses asset `AirportItlwm-Tahoe-v2.4.0-RELEASE-alpha-d695c97.zip`; release tags can move. IntelBluetoothFirmware/IntelBTPatcher use commit a414375505fa3b014be32f8fca31b5bbfdf9f10f. The Wi-Fi asset's bundle version is 2.4.0, while its release label is 2.4.0-alpha.

HibernationFixup uses bundle identifier `as.lvs1974.HibernationFixup`. Its `hbfx-ahbm=1` option and laptop-specific companion fixes are described in [Hibernation](Hibernation.md). Use the RELEASE bundle; no HBFX debug or NVRAM-dump argument is enabled.

## Included personality edits

VoodooHDA_BL 3.7.0 uses these keys under `IOKitPersonalities -> VoodooHDA`:

| Key | Type | Value |
|---|---|---|
| NodesToPatch | Array | Empty |
| IOPCIPrimaryMatch | String | 0xa3488086 |
| IOProbeScore | Integer | 99000 |

CtlnaSDXC 1.9.0 uses `IOKitPersonalities -> CtlnaSDXC -> IOPCIPrimaryMatch` (String) = `0xa3758086`, together with the matching properties, native-driver block and runtime patch in [ACPI and patches](ACPI-and-Patches.md).

## OpenCanopy resources

The archive contains the Flavours-OSX26 theme with the required FirmwareSettings/NetworkBoot labels and matching resource set. Category label images use the generic [OcBinaryData labels](https://github.com/acidanthera/OcBinaryData/tree/32500d5e3313f11cad00351ba1c6f9a4aa6cb0f7/Resources/Label). The HfsPlus version is unknown; the export includes the binary from the existing installation.

Component license/provenance details are listed in [Third-party notices](Third-Party-Notices.md) and [License scope](../NOTICE.md).
