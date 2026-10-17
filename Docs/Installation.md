# Installation

## 1. Prepare

Compare [Hardware](Hardware.md) with your machine, review [Compatibility](Compatibility.md) and apply the [firmware settings](Firmware.md). Keep a working boot medium and a way to boot Windows independently.

Download [the complete EFI](https://github.com/UISize/ASUS-UX550GDX-Hackintosh/releases/download/v0.1.0/EFI-UX550GDX-Tahoe-20261017.zip) and extract it into a private working directory. The archive contains only the runtime `EFI` directory, with one `EFI/OC/config.plist`. Readable ACPI sources and documentation are provided separately in this repository. Apple installation files are obtained separately. Prepare recovery-based media or a full installer using [Dortania's installer guide](https://dortania.github.io/OpenCore-Install-Guide/installer-guide/). The EFI archive contains the bootloader, not the macOS Recovery image or installer.

## 2. Personalize SMBIOS

Generate identifiers for **MacBookPro16,1**, for example with [GenSMBIOS](https://github.com/corpnewt/GenSMBIOS). Edit `EFI/OC/config.plist` under `PlatformInfo -> Generic`:

| Key | Type | Value |
|---|---|---|
| SystemSerialNumber | String | Your generated serial |
| MLB | String | Your generated board serial |
| SystemUUID | String | Your generated UUID |
| ROM | Data | Your own six-byte value |

The distributed values are empty/zero placeholders. Keep the personalized configuration private.

## 3. Validate and test from removable media

Get **ocvalidate from OpenCore 1.0.8**, in `Utilities/ocvalidate` inside the OpenCorePkg release archive linked in [Dependencies](Dependencies.md). Run it against the personalized file:

```sh
ocvalidate /path/to/EFI/OC/config.plist
```

Place the `EFI` folder at the root of a suitable FAT32 boot medium. The resulting paths must include `EFI/BOOT/BOOTx64.efi` and `EFI/OC/OpenCore.efi`. Keep existing boot data. Double-check the target drive by model and capacity before writing to it.

Select that medium's UEFI entry from the firmware boot menu. Test cold boot, restart/shutdown, display brightness, keyboard/trackpad, audio, Wi-Fi and sleep. Retain the working internal EFI until the new copy works.

## 4. Start macOS

For an existing installation, select its macOS volume in OpenCore. Press Space to show auxiliary entries such as Recovery.

### Online installation from Recovery

Boot the prepared macOS Recovery media through OpenCore. With a working network connection in Recovery, the macOS installation option downloads the required files from Apple. **UnPlugged is not required.** See [Dortania: online versus offline installers](https://dortania.github.io/OpenCore-Install-Guide/installer-guide/#online-vs-offline-installer).

The laptop has no Ethernet port. A USB-C Ethernet adapter may work if its chipset and USB path are supported by the exact Recovery version, but USB Ethernet has not been tested here. Prefer an adapter with a driver already included in Recovery; a desktop app or DriverKit extension cannot be assumed to work there. [Dortania's prerequisites](https://dortania.github.io/OpenCore-Install-Guide/prerequisites.html) explain that support is adapter-dependent.

The supplied USB-C map enables USB 2 only. An adapter recognized in USB 2 mode may provide the download connection at reduced speed; one requiring SuperSpeed needs more port mapping. Thunderbolt Ethernet depends on the separate, untested Thunderbolt path. See [USB mapping](USB.md).

Connect the adapter and Ethernet cable, then check for a network interface, an IP address and internet access in Recovery. A USB-C connector alone does not guarantee compatibility.

### Offline installation

A full macOS installer prepared in macOS is another installation route. [UnPlugged](https://github.com/corpnewt/UnPlugged) is an **optional** workflow for locally available Apple installer/cache files, as used during development of this configuration. Match its cache paths and volume names to your own setup.

### Select the installation target

In Recovery, select the intended macOS target by model, capacity and partition purpose. Do not touch the Windows partitions or the Windows EFI System Partition. Format only the intended macOS target as **APFS**. Preserve the existing GUID partition layout on a disk shared with Windows; do not erase the whole disk. This installation uses a separate 300 MiB OpenCore ESP.

After each installation restart, select the macOS installer entry while it exists, then the installed macOS volume. If an entry disappears unexpectedly, use the steps in [Troubleshooting](Troubleshooting.md) before modifying partitions.

## 5. Install to the internal EFI

Once the removable copy works, preserve your current EFI and copy the tested OpenCore files to the intended ESP. Keep Windows boot files intact. Firmware boot entries and partition locations vary by machine. There is no disk-formatting or deployment script; copy the files manually.

For package replacement or reconstruction, use the versions, load order and personality edits in [Dependencies](Dependencies.md). ACPI sources are included for adaptation; the supplied AML files already contain the installed tables.

## 6. Choose the sleep/hibernation policy

The supplied EFI includes the laptop-specific hibernation fixes. macOS energy settings are separate and are not applied by copying the EFI. Follow [Hibernation](Hibernation.md) to select a policy, preserving your existing energy settings first.
