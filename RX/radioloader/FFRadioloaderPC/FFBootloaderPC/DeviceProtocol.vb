Module DeviceProtocol

    Public VendorID As Integer = &H7411
    Public ProductID As Integer = &HA

    Public Const BytesPerPacket As Integer = 25
    Public Const BytesBeforeData As Integer = 9
    Public Const DataBytesPerPacket As Integer = BytesPerPacket - BytesBeforeData

    Public Const DataBytesInWriteBuffer = 64
    Public Const DataBytesPerBuffer As Integer = 16

    Public Const MaxPacketNumber As UInt32 = UInt32.MaxValue

    Public Const DeviceUserFlashEntryPoint As UInt32 = &H2C00
    Public Const DeviceUserFlashSize As UInt32 = 122872
    Public Const DeviceLastUsefulFlashAddress As UInt32 = &H1FFF7
    Public Const DeviceTotalFlashSize As UInt32 = &H20000
    Public Const DeviceLastFlashAddress As UInt32 = &H1FFFF
    Public Const DeviceLastUsefulFlashPageFirstAddr = &H1FC00

End Module

Public Enum CmdIds As Byte
    None = 0

    WriteBuffer = &H1
    ClearBuffer = &H2
    WriteFlash = &H3
    EraseFlash = &H4
    Reboot = &H10
    StartUserApp = &H11

    ReportOk = &H20
    ReportError = &H21
    ReportMessage = &H22

    Dummy = &H77

End Enum