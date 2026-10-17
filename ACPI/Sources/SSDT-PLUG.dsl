// Laptop-specific: ASUS UX550GDX, i7-8750H; first OEM Processor is \_SB.PR00.
// Method pattern: Dortania CPU Power Management / SSDTTime PluginType.
DefinitionBlock ("", "SSDT", 2, "ASUS", "CFLPLUG", 0x00000001)
{
    External (\_SB.PR00, ProcessorObj)
    Scope (\_SB.PR00)
    {
        Method (_DSM, 4, NotSerialized)
        {
            If (_OSI ("Darwin"))
            {
                If (LNot (Arg2))
                {
                    Return (Buffer (One) { 0x03 })
                }
                Return (Package (0x02) { "plugin-type", One })
            }
            Return (Buffer (One) { Zero })
        }
    }
}
