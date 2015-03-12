Module PacketBuilder

    Private CurrentPacketId As UInt32 = _
        New Random(Now().Ticks Mod 10000).Next() Mod (DeviceProtocol.MaxPacketNumber + 1)

    Public Function GetPacketNumber() As UInt32
        ' if random (header): Private randomizer As New Random(Now().Ticks Mod 10000)
        ' if random (here): Return (randomizer.Next() Mod (DeviceProtocol.MaxPacketNumber + 1))

        If CurrentPacketId = MaxPacketNumber Then
            CurrentPacketId = 1
        Else
            CurrentPacketId += 1
        End If

        If (CurrentPacketId = 0) Then CurrentPacketId = 1

        Return CurrentPacketId
    End Function

    Public Function BuildBasePacket() As ProtocolPacket
        Return New ProtocolPacket(GetPacketNumber())
    End Function

    Public Function BuildFlashErasePacket() As ProtocolPacket
        Dim p As ProtocolPacket = BuildBasePacket()

        With p
            .CmdId = CmdIds.EraseFlash
        End With

        Return p
    End Function

    Public Function BuildWriteBufferPacket(ByVal byteBuffer As Byte()) As ProtocolPacket
        If byteBuffer.Length < DataBytesPerBuffer Then Return Nothing
        Dim p As ProtocolPacket = BuildBasePacket()

        With p
            .CmdId = CmdIds.WriteBuffer
        End With

        For i As Integer = 0 To DataBytesPerBuffer - 1
            p.Data(i) = byteBuffer(i)
        Next

        Return p
    End Function

    Public Function BuildFlashWritePacket(ByVal addr As UInt32) As ProtocolPacket
        Dim p As ProtocolPacket = BuildBasePacket()

        With p
            .CmdId = CmdIds.WriteFlash
            .Address = addr
        End With

        For i As Integer = 0 To DataBytesPerBuffer - 1
            p.Data(i) = 0
        Next

        Return p
    End Function

    Public Function BuildRebootPacket() As ProtocolPacket
        Dim p As ProtocolPacket = BuildBasePacket()

        With p
            .CmdId = CmdIds.Reboot
        End With

        Return p
    End Function

    Public Function BuildStartUserAppPacket() As ProtocolPacket
        Dim p As ProtocolPacket = BuildBasePacket()

        With p
            .CmdId = CmdIds.StartUserApp
        End With

        Return p
    End Function

End Module
