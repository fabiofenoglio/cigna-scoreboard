Namespace My

    ' I seguenti eventi sono disponibili per MyApplication:
    ' 
    ' Startup: generato all'avvio dell'applicazione, prima della creazione del form di avvio.
    ' Shutdown: generato dopo la chiusura di tutti i form dell'applicazione. L'evento non è generato se l'applicazione termina in modo anormale.
    ' UnhandledException: generato se l'applicazione rileva un'eccezione non gestita.
    ' StartupNextInstance: generato quando si avvia un'applicazione istanza singola e l'applicazione è già attiva. 
    ' NetworkAvailabilityChanged: generato quando la connessione di rete è connessa o disconnessa.

    Partial Friend Class MyApplication

        Public Sub StartupEventHandler() Handles Me.Startup
            If My.Application.IsNetworkDeployed AndAlso My.Application.Deployment.IsFirstRun Then My.Settings.Upgrade()
        End Sub

        Private Sub MyApplication_NetworkAvailabilityChanged(sender As Object, e As Microsoft.VisualBasic.Devices.NetworkAvailableEventArgs) Handles Me.NetworkAvailabilityChanged

        End Sub

        Private Sub MyApplication_Shutdown(sender As Object, e As System.EventArgs) Handles Me.Shutdown
            My.Settings.Save()
        End Sub

        Public Sub UnHandledExceptionEventHandler(ByVal sender As System.Object, _
                                      ByVal e As Microsoft.VisualBasic.ApplicationServices.UnhandledExceptionEventArgs) _
                                      Handles Me.UnhandledException
            MsgBox("Unhandled exception:" & vbCrLf & e.Exception.Message & vbCrLf & e.Exception.StackTrace, MsgBoxStyle.Critical)
        End Sub

        Public Sub StartupNextInstanceEventHandler(ByVal sender As Object, _
                                                    ByVal e As Microsoft.VisualBasic.ApplicationServices.StartupNextInstanceEventArgs) _
                                                    Handles Me.StartupNextInstance
        End Sub

    End Class


End Namespace

