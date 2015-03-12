Public Class ProgramMemory

    Private pvtMemory() As Byte

    Public Sub New(ByVal size As UInt32)
        pvtMemory = New Byte(size - 1) {}
        Me.Clear()
    End Sub

    Public Property Memory As Byte()
        Get
            Return pvtMemory
        End Get
        Set(ByVal value As Byte())
            pvtMemory = value
        End Set
    End Property

    Public Sub Clear()
        For i As UInt32 = 0 To pvtMemory.Length - 1
            pvtMemory(i) = &HFF
        Next
    End Sub

    Public Function ImportFromFile(ByVal filePath As String) As Boolean
        If Not My.Computer.FileSystem.FileExists(filePath) Then Return False
        Dim fileText As String

        Try
            fileText = My.Computer.FileSystem.ReadAllText(filePath)
        Catch ex As Exception
            Return False
        End Try

        Dim lines = fileText.Split({vbCr, vbLf}, StringSplitOptions.RemoveEmptyEntries)
        Dim hline As HexLine

        Dim upAddress As UInt32 = 0
        Dim totAddress As UInt32 = 0

        For Each line In lines
            hline = New HexLine(line)
            If Not hline.IsValid Then Return False

            ' Process hex line
            Select Case hline.RecordType
                Case RecordTypes.SegmentAddress
                    ' Unknown action
                    Return False

                Case RecordTypes.EOF
                    ' End of file!
                    ' nothing to do

                Case RecordTypes.LinearAddress
                    ' 2 data bytes sets the 2 MSBytes of address
                    upAddress = hline.LinearAddressArg * &H10000
                    If Not hline.IsValid Then Return False

                Case RecordTypes.Data
                    totAddress = upAddress + hline.Address
                    For Each b As Byte In hline.DataBytes
                        Me.pvtMemory(totAddress) = b
                        totAddress += 1
                    Next

            End Select
        Next

        Return True
    End Function

End Class
