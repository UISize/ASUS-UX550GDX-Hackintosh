# Changelog

## v0.1.0 — Preliminary public release (17 October 2026)

- Publish the reviewed configuration and documentation with a fresh repository history.
- Distribute the complete, USB-tested EFI as a GitHub Release asset.
- Include the macOS desktop screenshot in the README.

Note: the EFI archive needs your own SMBIOS values before use.

## 17 October 2026

- Added the laptop-specific hibernation configuration and a dedicated Hibernation guide.
- Added official HibernationFixup 1.5.4 RELEASE after Lilu, including its auto-hibernation option.
- Added the original HibernationFixup BSD-3-Clause notice.
- Included the tested 4 KiB low-memory reservation and firmware-restricted shared-GPE S4 wake patch. Normal S3 mouse wake still works in the reported tests.
- Updated the sanitized template and replaced the download with the dated 20261017 EFI package. No private identifiers, full OEM tables or diagnostic logs were included.
- Documented the macOS energy policy separately from the EFI settings in the Hibernation guide.
- Confirmed a successful USB boot test of this exact package on the test laptop with the owner's four SMBIOS identity values.

## 15 October 2026

- Added the complete sanitized EFI for macOS Tahoe 26.7.1 and OpenCore 1.0.8.
- Limited the download archive to the runtime EFI with one config.plist; documentation and sources remain in the repository.
- Documented working hardware, known limitations and laptop-specific ACPI/audio/SD configuration.
- Confirmed Secure Boot disabled, DVMT 64 MB, AHCI, Fn+F6 trackpad toggle, Bluetooth headphone playback and practical UHD 630 3D operation.
- Simplified setup and maintenance instructions; consolidated component versions and load order into Dependencies.md.
- Removed optional picker visibility markers from the distributed EFI.
