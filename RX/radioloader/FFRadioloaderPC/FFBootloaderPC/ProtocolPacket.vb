Public Class ProtocolPacket

    ' Packet format:
    ' 0       cmd (1 byte)
    ' 1 - 4   memory address (4 bytes)
    ' 5 - 8   packet ID (4 bytes)
    ' 9 - 24  data (16 bytes)
    ' bit order is MSB - LSB

    Private pvtCmdId As CmdIds
    Private pvtAddress As UInt32
    Private pvtPacketId As UInt32
    Private pvtData(DeviceProtocol.DataBytesPerPacket - 1) As Byte

    Private pvtDataBuffer(DeviceProtocol.BytesPerPacket - 1) As Byte
    Private pvtNeedsRebuild As Boolean
    Private pvtResponsePacket As ProtocolPacket

#Region "Costruttori"

    Public Sub New()
        Me.Clear()
    End Sub

    Public Sub New(ByVal num As UInt32)
        Me.Clear()
        pvtPacketId = num
    End Sub

    Public Sub New(ByVal num As UShort, ByVal cmd As CmdIds)
        Me.Clear()
        pvtPacketId = num
        pvtCmdId = cmd
    End Sub

#End Region

    Public Sub Clear()
        Dim i As Integer

        pvtCmdId = CmdIds.None
        pvtAddress = 0
        pvtPacketId = 0

        For i = 0 To DeviceProtocol.DataBytesPerPacket - 1
            pvtData(i) = &H0
        Next

        pvtNeedsRebuild = True
        pvtResponsePacket = Nothing
    End Sub

    Public Sub BuildPacket()
        Dim i As Integer

        Dim addrFormingBytes As Byte() = BitConverter.GetBytes(pvtAddress)
        Dim pidFormingBytes As Byte() = BitConverter.GetBytes(pvtPacketId)

        If BitConverter.IsLittleEndian Then
            Array.Reverse(addrFormingBytes)
            Array.Reverse(pidFormingBytes)
        End If

        pvtDataBuffer(0) = pvtCmdId
        pvtDataBuffer(1) = addrFormingBytes(0)
        pvtDataBuffer(2) = addrFormingBytes(1)
        pvtDataBuffer(3) = addrFormingBytes(2)
        pvtDataBuffer(4) = addrFormingBytes(3)
        pvtDataBuffer(5) = pidFormingBytes(0)
        pvtDataBuffer(6) = pidFormingBytes(1)
        pvtDataBuffer(7) = pidFormingBytes(2)
        pvtDataBuffer(8) = pidFormingBytes(3)

        For i = 0 To DeviceProtocol.DataBytesPerPacket - 1
            pvtDataBuffer(DeviceProtocol.BytesBeforeData + i) = pvtData(i)
        Next

        pvtNeedsRebuild = False
    End Sub

    Public Function GetFromPacket(ByVal inBuffer As Byte()) As Boolean
        If inBuffer Is Nothing Then Return False
        Dim i As Integer

        pvtNeedsRebuild = True

        Dim addrBytes4(3) As Byte
        Dim pidBytes4(3) As Byte

        If BitConverter.IsLittleEndian Then
            addrBytes4(0) = inBuffer(4)
            addrBytes4(1) = inBuffer(3)
            addrBytes4(2) = inBuffer(2)
            addrBytes4(3) = inBuffer(1)
            pidBytes4(0) = inBuffer(8)
            pidBytes4(1) = inBuffer(7)
            pidBytes4(2) = inBuffer(6)
            pidBytes4(3) = inBuffer(5)
        Else
            addrBytes4(0) = inBuffer(1)
            addrBytes4(1) = inBuffer(2)
            addrBytes4(2) = inBuffer(3)
            addrBytes4(3) = inBuffer(4)
            pidBytes4(0) = inBuffer(5)
            pidBytes4(1) = inBuffer(6)
            pidBytes4(2) = inBuffer(7)
            pidBytes4(3) = inBuffer(8)
        End If

        pvtCmdId = inBuffer(0)
        pvtAddress = BitConverter.ToUInt32(addrBytes4, 0)
        pvtPacketId = BitConverter.ToUInt32(pidBytes4, 0)

        ' Import data
        For i = 0 To DeviceProtocol.DataBytesPerPacket - 1
            pvtData(i) = inBuffer(DeviceProtocol.BytesBeforeData + i)
        Next

        Return True
    End Function

    Public Function WaitForAnswer() As Boolean
        While Not Me.HasAnAnswer
            System.Threading.Thread.Sleep(1)
        End While

        Return True
    End Function

    Public ReadOnly Property NeedsRebuild As Boolean
        Get
            Return pvtNeedsRebuild
        End Get
    End Property

    Public ReadOnly Property HasAnAnswer As Boolean
        Get
            Return (pvtResponsePacket IsNot Nothing)
        End Get
    End Property

    Public ReadOnly Property Accepted As Boolean
        Get
            Return (Me.HasAnAnswer) AndAlso (Me.ResponsePacket.CmdId = CmdIds.ReportOk)
        End Get
    End Property

    Public Property ResponsePacket As ProtocolPacket
        Get
            Return pvtResponsePacket
        End Get
        Set(ByVal value As ProtocolPacket)
            pvtResponsePacket = value
        End Set
    End Property


    Public Property CmdId As CmdIds
        Get
            Return pvtCmdId
        End Get
        Set(ByVal value As CmdIds)
            pvtNeedsRebuild = True
            pvtCmdId = value
        End Set
    End Property

    Public Property Address As UInt32
        Get
            Return pvtAddress
        End Get
        Set(ByVal value As UInt32)
            pvtNeedsRebuild = True
            pvtAddress = value
        End Set
    End Property

    Public Property PacketId As UInt32
        Get
            Return pvtPacketId
        End Get
        Set(ByVal value As UInt32)
            pvtNeedsRebuild = True
            pvtPacketId = value
        End Set
    End Property

    Public Property Data As Byte()
        Get
            pvtNeedsRebuild = True
            Return pvtData
        End Get
        Set(ByVal value As Byte())
            pvtNeedsRebuild = True
            pvtData = value
        End Set
    End Property

    Public ReadOnly Property DataBuffer As Byte()
        Get
            If NeedsRebuild Then BuildPacket()
            Return pvtDataBuffer
        End Get
    End Property

    Public Shared Function getByteStr(ByVal toConvert As Byte) As String
        Dim rs As String

        If (toConvert < 16) Then
            rs = " " & Hex(toConvert)
        Else
            rs = Hex(toConvert)
        End If

        Return rs & " "
    End Function

    Public ReadOnly Property Description As String
        Get
            Dim rs As String = "/_______________________________________________________________" & _
                "___________________________________________" & vbCrLf
            rs &= "|  CmdID: " & pvtCmdId.ToString() & vbCrLf
            rs &= "|  Addr: " & pvtAddress.ToString() & vbCrLf
            rs &= "|  PackNum: " & pvtPacketId.ToString(System.Globalization.CultureInfo.CurrentCulture) & vbCrLf

            rs &= "|  Data: " & vbCrLf & "|  "
            Dim i As Integer = 0
            For Each b As Byte In pvtData
                rs &= getByteStr(b)
                i += 1
                If (i Mod 16) = 0 Then rs &= vbCrLf & "|  "
            Next
            rs &= vbCrLf

            If pvtNeedsRebuild Then BuildPacket()
            rs &= "|  Full Built Packet: " & vbCrLf & "|  "
            i = 0
            For Each b As Byte In pvtDataBuffer
                rs &= getByteStr(b)
                i += 1
                If (i Mod 16) = 0 Then rs &= vbCrLf & "|  "
            Next
            rs &= vbCrLf & "|_______________________________________________________________" & _
                "___________________________________________" & vbCrLf

            Return rs
        End Get
    End Property
End Class
