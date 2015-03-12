Public Class Form1

#Region "Device"

    Private WithEvents device As HidLibrary.HidDevice = Nothing
    Private pvtDeviceReady As Boolean = False
    Private pvtEnumeratingLock As New Object()

    Private Delegate Sub OnReportDelegate(ByVal report As HidLibrary.HidReport)
    Private OnReportDelegateHandle As New OnReportDelegate(AddressOf OnReportMyDelegate)

    Private Delegate Sub OnDeviceConnectedChangedDelegate(ByVal action As Integer)
    Private OnDeviceConnectedChangedHandle As New OnDeviceConnectedChangedDelegate(AddressOf OnDeviceConnChangedMyDelegate)

    Const TIME_BETWEEN_BUFFER_WRITE As Integer = 5
    Const TIME_BETWEEN_FLASH_WRITE As Integer = 15
    Const MAX_RETRIES As Integer = 100

    Public ReadOnly Property DeviceReady As Boolean
        Get
            Return (device IsNot Nothing) AndAlso (device.IsOpen) AndAlso (device.MonitorDeviceEvents) AndAlso pvtDeviceReady
        End Get
    End Property

    Private Sub ConnectButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles ConnectButton.Click
        TryConnect()
    End Sub

    Private Function TryConnect() As Boolean
        If DeviceReady Then
            AddDeviceLog("già connesso")
            Return True
        End If

        SyncLock pvtEnumeratingLock
            device = HidLibrary.HidDevices.Enumerate(VendorID, ProductID).FirstOrDefault()
        End SyncLock

        If device Is Nothing Then
            SetConnected(False)
            AddDeviceLog("impossibile connettersi")
            Return False
        End If

        SetConnected(True)
        AddDeviceLog("dispositivo connesso")

        StartUsingDevice()
        Return True
    End Function

    Private Sub AddDeviceLog(ByVal text As String)
        Static lastPreamble As String = ""
        Dim nowPreamble As String = FormatDateTime(Now(), DateFormat.LongTime) & " - "
        If nowPreamble <> lastPreamble Then
            lastPreamble = nowPreamble
        Else
            nowPreamble = "           "
        End If

        DeviceTextBox.AppendText(nowPreamble & text)
        DeviceTextBox.AppendText(vbCrLf)
        Label1.Text = text
    End Sub

    Private Sub StartUsingDevice()
        device.OpenDevice()
        device.MonitorDeviceEvents = True
        device.ReadReport(AddressOf OnReport)
    End Sub

    Private Sub DeviceInserted() Handles device.Inserted
        StartUsingDevice()
        BeginInvoke(OnDeviceConnectedChangedHandle, 1)
    End Sub

    Private Sub DeviceRemoved() Handles device.Removed
        device.CloseDevice()
        BeginInvoke(OnDeviceConnectedChangedHandle, 2)
    End Sub

    Private Sub OnDeviceConnChangedMyDelegate(ByVal action As Integer)
        Select Case action
            Case 0
                TryConnect()
            Case 1
                AddDeviceLog("connessione stabilita")
                SetConnected(True)
            Case 2
                AddDeviceLog("connessione persa")
                SetConnected(False)
        End Select

    End Sub

    Private Sub OnReportMyDelegate(ByVal report As HidLibrary.HidReport)
        If Not device.IsConnected Then Return

        Dim rxPack As New ProtocolPacket()
        If Not rxPack.GetFromPacket(report.Data) Then
            AddDeviceLog("pacchetto errato")
        Else
            If rxPack.CmdId = CmdIds.ReportMessage Then
                AddDeviceLog("-> " & System.Text.Encoding.ASCII.GetString(rxPack.Data))
            Else
                If rxPack.CmdId <> CmdIds.ReportOk Then
                    AddDeviceLog(rxPack.CmdId.ToString() & " " & rxPack.PacketId.ToString())
                End If
                AddPacketConfirm(rxPack)
            End If
        End If
    End Sub

    Private Sub OnReport(ByVal report As HidLibrary.HidReport)
        If (Not device.IsConnected) Then Return
        BeginInvoke(OnReportDelegateHandle, report)
        device.ReadReport(AddressOf OnReport)
    End Sub

    Public Sub SetConnected(ByVal connected As Boolean)
        ConnectButton.Enabled = Not connected

        If connected Then
            PictureBox1.Image = My.Resources.connected
        Else
            PictureBox1.Image = My.Resources.disconnected
        End If

        pvtDeviceReady = connected
    End Sub

#End Region

#Region "DeviceBackgroundWorker"

    Private Sub LaunchAction(ByVal job As Job)
        If Not CanLaunchNewAction Then
            MsgBox("Il dispositivo non è pronto.", MsgBoxStyle.Critical)
            Return
        End If

        Dim st As String = "Avvio dell'operazione [" & job.JobCode.ToString() & "]"
        For Each arg In job.Args
            st &= " -" & arg.ToString() & " "
        Next

        AddDeviceLog(st)

        DeviceBackgroundWorker.RunWorkerAsync(job)
    End Sub

    Private Sub DBW_AddLog(ByVal str As String)
        DeviceBackgroundWorker.ReportProgress(-1, str)
    End Sub

    Private Sub DeviceBackgroundWorker_DoWork(ByVal sender As System.Object, ByVal e As System.ComponentModel.DoWorkEventArgs) _
        Handles DeviceBackgroundWorker.DoWork

        If (device Is Nothing) OrElse (Not device.IsConnected) Then Return

        Dim job As Job = DirectCast(e.Argument, Job)
        e.Result = "success"

        Select Case job.JobCode

            Case JobCodes.WriteFlash
                If Not DBW_WriteFlash(job.Args(0)) Then
                    e.Result = "failed"
                End If

            Case JobCodes.ClearFlash
                If Not DBW_ClearFlash() Then
                    e.Result = "failed"
                End If

            Case JobCodes.Reboot
                If Not DBW_Reboot() Then
                    e.Result = "failed"
                End If
                ' Occorre reimpostare la connessione
                DeviceRemoved()

            Case JobCodes.RunUserApp
                If Not DBW_RunUserApp() Then
                    e.Result = "failed"
                End If
                ' Occorre reimpostare la connessione
                DeviceRemoved()

            Case JobCodes.WriteFlashAndRun
                If Not DBW_WriteFlash(job.Args(0)) Then
                    e.Result = "failed"
                End If
                If Not DBW_RunUserApp() Then
                    e.Result = "failed"
                End If
                ' Occorre reimpostare la connessione
                DeviceRemoved()

            Case Else
                ' Niente da fare
        End Select

    End Sub

    Private Function DBW_RunUserApp() As Boolean
        Dim p As ProtocolPacket = PacketBuilder.BuildStartUserAppPacket()
        PacketInterface.SendPacket(p, device)

        Return True
    End Function

    Private Function DBW_Reboot() As Boolean
        Dim p As ProtocolPacket = PacketBuilder.BuildRebootPacket()
        PacketInterface.SendPacket(p, device)

        Return True
    End Function

    Private Function DBW_ClearFlash() As Boolean
        Dim p As ProtocolPacket = PacketBuilder.BuildFlashErasePacket()
        DBW_AddLog("clearing flash ...")

        PacketInterface.SendPacketAndWaitForConfirm(p, device)
        System.Threading.Thread.Sleep(10 * 1000)
        Return p.Accepted
    End Function

    Private Function DBW_VerifyFlashBlock(ByVal pm As ProgramMemory, ByVal startingAddr As UInt32) As Boolean
        Return True
    End Function


    Private Function DBW_Retry(packet As ProtocolPacket, max_retries As Integer, base_delay As Integer) As Boolean
        DBW_AddLog("sending " & packet.CmdId.ToString())

        For retry_count As Integer = 0 To max_retries
            PacketInterface.SendPacketAndWaitForConfirm(packet, device)
            System.Threading.Thread.Sleep(base_delay * (1 + retry_count))
            If packet.Accepted Then Return True
            'packet.PacketId = PacketBuilder.GetPacketNumber()
        Next

        Return False
    End Function

    Private Function DBW_WriteFlashBlock(ByVal pm As ProgramMemory, ByVal startingAddr As UInt32) As Boolean
        Dim i As Integer

        Dim p As ProtocolPacket
        Dim byteBuffer(DataBytesPerBuffer - 1) As Byte

        ' Send 16 bytes at a time
        For i = 0 To DataBytesPerBuffer - 1
            byteBuffer(i) = pm.Memory(startingAddr + i)
        Next
        If Not DBW_Retry(PacketBuilder.BuildWriteBufferPacket(byteBuffer), MAX_RETRIES, TIME_BETWEEN_BUFFER_WRITE) Then Return False

        For i = 0 To DataBytesPerBuffer - 1
            byteBuffer(i) = pm.Memory(startingAddr + 16 + i)
        Next
        If Not DBW_Retry(PacketBuilder.BuildWriteBufferPacket(byteBuffer), MAX_RETRIES, TIME_BETWEEN_BUFFER_WRITE) Then Return False

        For i = 0 To DataBytesPerBuffer - 1
            byteBuffer(i) = pm.Memory(startingAddr + 32 + i)
        Next
        If Not DBW_Retry(PacketBuilder.BuildWriteBufferPacket(byteBuffer), MAX_RETRIES, TIME_BETWEEN_BUFFER_WRITE) Then Return False

        For i = 0 To DataBytesPerBuffer - 1
            byteBuffer(i) = pm.Memory(startingAddr + 48 + i)
        Next
        If Not DBW_Retry(PacketBuilder.BuildWriteBufferPacket(byteBuffer), MAX_RETRIES, TIME_BETWEEN_BUFFER_WRITE) Then Return False

        ' Send write packet
        p = PacketBuilder.BuildFlashWritePacket(startingAddr)
        If Not DBW_Retry(p, MAX_RETRIES, TIME_BETWEEN_FLASH_WRITE) Then Return False

        System.Threading.Thread.Sleep(10)
        Return True
    End Function

    Private Function DBW_WriteFlash(ByVal path As String) As Boolean
        ' Import hex file
        If Not My.Computer.FileSystem.FileExists(path) Then
            DBW_AddLog("import error: file is missing")
            Return False
        End If

        Dim pm As New ProgramMemory(DeviceTotalFlashSize)
        Dim needed As Boolean
        Dim i As Long

        If Not pm.ImportFromFile(path) Then
            DBW_AddLog("hex import ERROR")
            Return False
        End If

        ' Start writing blocks
        DBW_AddLog("Writing ...")
        Dim addrToWrite As UInt32 = DeviceUserFlashEntryPoint
        While addrToWrite < DeviceLastUsefulFlashPageFirstAddr
            If (addrToWrite Mod 1024) = 0 Then
                DeviceBackgroundWorker.ReportProgress(CInt(100.0 * (addrToWrite - DeviceUserFlashEntryPoint) / _
                                                      (DeviceLastUsefulFlashPageFirstAddr - DeviceUserFlashEntryPoint)))
            End If

            ' Check if blank
            needed = False
            For i = addrToWrite To addrToWrite + DataBytesInWriteBuffer - 1
                If pm.Memory(i) <> 255 Then
                    needed = True
                    Exit For
                End If
            Next

            If needed Then
                ' Send write command with verify option
                If Not DBW_WriteFlashBlock(pm, addrToWrite) Then
                    DBW_AddLog("write error")
                    Return False
                End If
            Else
                DBW_AddLog("skip " & addrToWrite)
            End If

            addrToWrite += DataBytesInWriteBuffer
        End While

        ' Check align
        If (addrToWrite <> DeviceLastUsefulFlashPageFirstAddr) Then
            DBW_AddLog("align error (" & addrToWrite & " vs " & DeviceLastUsefulFlashPageFirstAddr & ")")
            Return False
        End If

        ' Send clearing data
        For i = 0 To 15
            SendDummy()
        Next

        Return True
    End Function

    Private Sub DeviceBackgroundWorker_ProgressChanged(ByVal sender As Object, ByVal e As System.ComponentModel.ProgressChangedEventArgs) Handles DeviceBackgroundWorker.ProgressChanged
        If e.ProgressPercentage = -1 Then
            AddDeviceLog(e.UserState.ToString())
        Else
            ProgressBar1.Value = e.ProgressPercentage
            If Not ProgressBar1.Visible Then ProgressBar1.Show()
        End If
    End Sub

    Private Sub DeviceBackgroundWorker_RunWorkerCompleted(ByVal sender As Object, ByVal e As System.ComponentModel.RunWorkerCompletedEventArgs) Handles DeviceBackgroundWorker.RunWorkerCompleted
        ProgressBar1.Value = 100
        ProgressBar1.Hide()

        If e.Result IsNot Nothing Then
            AddDeviceLog("operation completed: " & e.Result.ToString())
        Else
            AddDeviceLog("operation completed [unknown result]")
        End If
    End Sub

#End Region

#Region "GUI"

    Private Sub Form1_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load
        TryConnect()
    End Sub

    Private Sub Form1_Shown(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Shown
        CheckParams()
    End Sub

    Private Sub Button2_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles Button2.Click
        ' Select hex file
        Dim toImportPath As String = GetHexFileToOpen()
        If toImportPath Is Nothing Then
            AddDeviceLog("operation cancelled by user")
            Return
        End If

        LaunchAction(New Job(JobCodes.WriteFlash, toImportPath))
    End Sub

    Private Sub Button3_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles Button3.Click
        LaunchAction(New Job(JobCodes.ClearFlash))
    End Sub

    Private Sub Button4_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles Button4.Click
        LaunchAction(New Job(JobCodes.Reboot))
    End Sub

    Private Sub Button6_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles Button6.Click
        LaunchAction(New Job(JobCodes.RunUserApp))
    End Sub

#End Region

    Public Sub CheckParams()
        For Each p As String In My.Application.CommandLineArgs
            If p.StartsWith("hex=") Then
                LaunchAction(New Job(JobCodes.WriteFlashAndRun, p.Substring(4)))
            End If
        Next
    End Sub

    Public ReadOnly Property CanLaunchNewAction As Boolean
        Get
            Return (DeviceReady) And (Not DeviceBackgroundWorker.IsBusy) And (Not PacketInterface.PacketsConfirmPending)
        End Get
    End Property

    Public Function GetHexFileToOpen() As String
        Dim openDialog As New OpenFileDialog()
        With openDialog
            .CheckFileExists = True
            .CheckPathExists = True
            .DefaultExt = ".hex"
            .Multiselect = False
            .Title = "Seleziona il file da programmare"
        End With

        If openDialog.ShowDialog() = DialogResult.OK Then
            Return openDialog.FileName
        Else
            Return Nothing
        End If
    End Function

    Public Shared Function getFixedLen(ByVal str As String, ByVal len As Integer) As String
        While str.Length < len
            str = " " & str
        End While
        Return str
    End Function

    Private Sub ButtonHook_Click(sender As Object, e As EventArgs) Handles Button1.Click
        SendDummy()
    End Sub

    Private Sub SendDummy()
        Dim p = PacketBuilder.BuildFlashErasePacket()
        p.CmdId = CmdIds.Dummy
        PacketInterface.SendPacket(p, device)
        System.Threading.Thread.Sleep(100)
    End Sub
End Class
