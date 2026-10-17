// ASUS single-key native 4-state backlight cycle based on this laptop's OEM SLKB/PWKB.
// Original methods: _Q0E/_Q0F/KBLD/KBLU -> XQ0E/XQ0F/XBLD/XBLU.
// Only original DSDT method definitions are renamed, not their call sites.
DefinitionBlock ("", "SSDT", 2, "ASUS", "SMCFN", 0x00000001)
{
    External (\_SB.ATKD, DeviceObj)
    External (\_SB.ATKD.IANE, MethodObj)
    External (\_SB.ATKP, IntObj)
    External (\_SB.KBLC, FieldUnitObj)
    External (\_SB.KBLV, FieldUnitObj)
    External (\_SB.PCI0.LPCB.EC0, DeviceObj)
    External (\_SB.PCI0.LPCB.EC0.WRAM, MethodObj)
    External (\_SB.PCI0.LPCB.EC0.ST9E, MethodObj)
    External (\_SB.PCI0.LPCB.EC0.SLKB, MethodObj)
    External (\_SB.PCI0.LPCB.EC0.XQ0E, MethodObj)
    External (\_SB.PCI0.LPCB.EC0.XQ0F, MethodObj)
    External (\_SB.PCI0.LPCB.EC0.XBLD, MethodObj)
    External (\_SB.PCI0.LPCB.EC0.XBLU, MethodObj)

    Scope (\_SB.ATKD)
    {
        Method (SKBV, 1, Serialized)
        {
            If (!_OSI ("Darwin")) { Return (Ones) }
            \_SB.PCI0.LPCB.EC0.WRAM (0xBA, 0xC9F0, \_SB.KBLV)
            \_SB.PCI0.LPCB.EC0.ST9E (0x1F, 0xFF, Arg0)
            Return (Arg0)
        }
    }
    Scope (\_SB.PCI0.LPCB.EC0)
    {
        Method (_Q0E, 0, NotSerialized)
        {
            If (_OSI ("Darwin"))
            {
                If (\_SB.ATKP) { \_SB.ATKD.IANE (0x20) }
                Return ()
            }
            XQ0E ()
        }
        Method (_Q0F, 0, NotSerialized)
        {
            If (_OSI ("Darwin"))
            {
                If (\_SB.ATKP) { \_SB.ATKD.IANE (0x10) }
                Return ()
            }
            XQ0F ()
        }
        Method (KBLD, 0, NotSerialized)
        {
            If (_OSI ("Darwin"))
            {
                If (\_SB.ATKP && (\_SB.KBLC & 0x80)) { \_SB.ATKD.IANE (0xC5) }
            }
            Else { XBLD () }
        }
        Method (KBLU, 0, Serialized)
        {
            If (_OSI ("Darwin"))
            {
                If (\_SB.ATKP && (\_SB.KBLC & 0x80))
                {
                    // OEM SLKB stores KBLV and uses PWKB[0..3] = 00/55/AA/FF.
                    // Bit 7 enables application of that level; level zero is off.
                    Local0 = ((\_SB.KBLV + One) & 0x03)
                    SLKB (0x80 | Local0)
                }
            }
            Else { XBLU () }
        }
    }
}
