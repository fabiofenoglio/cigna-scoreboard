Public Enum JobCodes
    None = 0
    WriteFlash
    ClearFlash
    Reboot
    RunUserApp
    WriteFlashAndRun
End Enum

Public Class Job

    Private pvtType As JobCodes
    Private pvtArgs As System.Collections.ObjectModel.Collection(Of Object) '_RO_

    Public Sub New()
        Clear()
    End Sub

    Public Sub New(ByVal tp As JobCodes)
        Clear()
        pvtType = tp
    End Sub

    Public Sub New(ByVal tp As JobCodes, ByVal ParamArray args() As Object)
        Clear()
        pvtType = tp

        If args IsNot Nothing Then
            For Each arg In args
                pvtArgs.Add(arg)
            Next
        End If
    End Sub

    Public Sub Clear()
        pvtType = JobCodes.None
        pvtArgs = New System.Collections.ObjectModel.Collection(Of Object)
    End Sub

    Public Property JobCode As JobCodes
        Get
            Return pvtType
        End Get
        Set(ByVal value As JobCodes)
            pvtType = value
        End Set
    End Property

    Public ReadOnly Property Args As System.Collections.ObjectModel.Collection(Of Object)
        Get
            Return pvtArgs
        End Get
    End Property

End Class