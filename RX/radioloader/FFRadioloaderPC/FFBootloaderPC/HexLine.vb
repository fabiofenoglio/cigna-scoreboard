Public Class HexLine
    ':BBAAAATT[HHHH....HHH]CC where:
    'BB A two digit hexadecimal byte count representing the number of data bytes that will appear on the line.
    'AAAA A four digit hexadecimal address representing the starting address of the data record.
    'TT A two digit record type:
    '00 – Data record
    '01 – End of File record
    '02 – Segment Address record
    '04 – Linear Address record
    'HH A two digit hexadecimal data byte, presented in low byte/high byte combinations.
    'CC A two digit hexadecimal checksum that is the two's complement of the sum of all preceding bytes in the record.

    Public Property ByteCount As Byte
    Public Property Address As UInt32
    Public Property RecordType As RecordTypes
    Private pvtDataBytes As Byte()
    Public Property Checksum As Byte
    Public Property DataBytesCount As Integer

    Public Property IsValid As Boolean

    Public ReadOnly Property DataBytes As Byte()
        Get
            Return pvtDataBytes
        End Get
    End Property

    Public Sub New(ByVal line As String)
        Me.ImportLine(line)
    End Sub

    Public ReadOnly Property LinearAddressArg As UInt32
        Get
            If Me.RecordType <> RecordTypes.LinearAddress Then
                IsValid = False
                Return 0
            End If

            If Me.DataBytesCount <> 2 Then
                IsValid = False
                Return 0
            End If

            Return Me.DataBytes(0) * 256 + Me.DataBytes(1)
        End Get
    End Property

    Public Function ImportLine(ByVal line As String) As Boolean
        Me.Clear()
        If line.Length < 11 Then Return False
        If line(0) <> ":" Then Return False

        Me.DataBytesCount = UInteger.Parse(line.Substring(1, 2), Globalization.NumberStyles.HexNumber)

        If line.Length <> 11 + Me.DataBytesCount * 2 Then Return False

        Me.Address = UInteger.Parse(line.Substring(3, 4), Globalization.NumberStyles.HexNumber)
        Me.RecordType = UInteger.Parse(line.Substring(7, 2), Globalization.NumberStyles.HexNumber)

        If Me.DataBytesCount > 0 Then
            pvtDataBytes = New Byte(Me.DataBytesCount - 1) {}
            For dbc As Integer = 1 To Me.DataBytesCount
                pvtDataBytes(dbc - 1) = UInteger.Parse(line.Substring(7 + 2 * dbc, 2), Globalization.NumberStyles.HexNumber)
            Next
        End If

        Me.Checksum = UInteger.Parse(line.Substring(9 + 2 * Me.DataBytesCount, 2), Globalization.NumberStyles.HexNumber)

        IsValid = True
        Return True
    End Function

    Public Sub Clear()
        pvtDataBytes = Nothing
        IsValid = False
    End Sub

End Class

<Flags()>
Public Enum RecordTypes
    Data = 0
    EOF = 1
    SegmentAddress = 2
    LinearAddress = 4
End Enum
