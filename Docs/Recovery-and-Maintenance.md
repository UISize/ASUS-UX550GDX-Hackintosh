# Recovery and maintenance

## Recovering from a failed change

Boot a known working OpenCore copy through the firmware boot menu and restore the previous configuration. Record the last change and the stage where startup fails: firmware, picker, bootloader, kernel or the running OS.

For targeted diagnosis, use OpenCore DEBUG files matching the installed OpenCore version. Remove private identifiers from log excerpts before sharing them. An NVRAM reset clears stored NVRAM settings and can change boot selection. Use it only when the specific change requires it; do not reset while a hibernation image is pending. See [Hibernation changes](#hibernation-changes).

Windows boot files remain separate from OpenCore. Press Space to reveal auxiliary entries. Optional `.contentVisibility` markers can hide redundant OpenCore loader entries; see [Configuration](Configuration.md#optional-hide-opencores-own-picker-entries) for setup and removal. The markers are not included in the distributed EFI.

## Updating

Prepare updates on a separate boot medium, retain the working EFI and use ocvalidate matching the new OpenCore version. Use the exact versions in [Dependencies](Dependencies.md) and account for these dependencies:

- AirportItlwm is a Tahoe-specific alpha build; its exact asset is listed in [Dependencies](Dependencies.md).
- IntelBluetoothFirmware and IntelBTPatcher use the paired 2.5.0 build at a414375.
- CtlnaSDXC 1.9.0 and its runtime byte patch are version-specific.
- VoodooHDA_BL contains the legacy audio dependencies used by this configuration.
- Root PNLF requires its matching rename; the ASUS wrapper requires four DSDT renames.
- HibernationFixup 1.5.4 RELEASE, `hbfx-ahbm=1`, the laptop-specific memory reservation and table-restricted S4 wake patch form the documented hibernation combination; see [Hibernation](Hibernation.md).
- The USB map is specific to the test laptop and currently enables only USB 2 on USB-C.

After a change, test cold boot, restart/shutdown, brightness, input, sound, network, sleep and post-sleep SD eject/reinsert. Keep the untested list in [Compatibility](Compatibility.md) up to date after testing a feature.

Keep personalized identifiers and recovery backups outside the repository.

## ACPI changes

The readable sources are in `ACPI/Sources`; the archive includes compiled AML. Compile modified source copies with ACPICA iasl, inspect diagnostics and test the resulting tables from separate media. Update each table together with its required config.plist patches.

## Hibernation changes

Do not reset NVRAM while a hibernation image is pending. Read the current configuration before changing it; restore individual changes rather than overwriting later fixes with an old full EFI. Generate a fresh image after a normal boot with the new settings. See [Hibernation](Hibernation.md) for the reference settings and test scope.
