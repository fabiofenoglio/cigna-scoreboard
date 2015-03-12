Public Class DeviceJobResult

    Public Property Description As String
    Public Property Success As Boolean

    Public Sub New()
        Me.Clear()
    End Sub

    Public Sub Clear()
        Me.Description = ""
        Me.Success = False
    End Sub

End Class
