# Firmware settings

These settings apply to the test laptop running **UX550GDX.312**.

| Setting | Value |
|---|---|
| Boot mode | UEFI; no CSM option is exposed |
| Secure Boot | Disabled |
| Fast Boot | Disabled |
| DVMT Pre-Allocated | 64 MB |
| Storage mode | AHCI |
| VT-d | Enabled; OpenCore uses DisableIoMapper=true |
| CFG Lock | Option not available in the firmware menu; OpenCore uses AppleXcpmCfgLock=true |

The configuration does not require modified firmware or unlocking hidden UEFI variables. Firmware Secure Boot and OpenCore SecureBootModel are separate settings; SecureBootModel is Disabled in the supplied configuration.

## Windows and macOS clock

This dual boot uses a UTC hardware clock:

1. In Windows, set `RealTimeIsUniversal` (DWORD, value 1) under `HKLM\SYSTEM\CurrentControlSet\Control\TimeZoneInformation`.
2. Set the correct local time zone and network time synchronization in each operating system.

The UEFI clock can show UTC while Windows and macOS show local time. Region, language and time zone are separate settings. The selected AirportItlwm build supports automatic time-zone detection through Wi-Fi location services.
