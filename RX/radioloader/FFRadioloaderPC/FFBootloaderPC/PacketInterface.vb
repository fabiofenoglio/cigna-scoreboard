Module PacketInterface

    Private pvtSentPacketList As New System.Collections.ObjectModel.Collection(Of ProtocolPacket)
    Private pvtSentPacketListLockObject As New Object()

    Public ReadOnly Property PacketsConfirmPending As Boolean
        Get
            SyncLock pvtSentPacketListLockObject
                Return (pvtSentPacketList.Count > 0)
            End SyncLock
        End Get
    End Property

    Public Function AddPacketConfirm(ByVal packet As ProtocolPacket) As Boolean
        SyncLock pvtSentPacketListLockObject
            Dim pos As Integer = -1
            For i As Integer = 0 To pvtSentPacketList.Count - 1
                If pvtSentPacketList(i).PacketId = packet.PacketId Then
                    pvtSentPacketList(i).ResponsePacket = packet
                    pos = i
                    Exit For
                End If
            Next

            If pos = -1 Then Return False
            pvtSentPacketList.RemoveAt(pos)
        End SyncLock

        Return True
    End Function

    Public Sub SendPacket(ByVal packet As ProtocolPacket, ByVal device As HidLibrary.HidDevice)
        Dim rToWrite As New HidLibrary.HidReport(DeviceProtocol.BytesPerPacket)
        rToWrite.Data = packet.DataBuffer
        device.WriteReport(rToWrite)

        SyncLock pvtSentPacketListLockObject
            pvtSentPacketList.Add(packet)
        End SyncLock
    End Sub

    Public Function SendPacketAndWaitForConfirm(ByVal packet As ProtocolPacket, ByVal device As HidLibrary.HidDevice) As Boolean
        SendPacket(packet, device)
        Return packet.WaitForAnswer()
    End Function

End Module
