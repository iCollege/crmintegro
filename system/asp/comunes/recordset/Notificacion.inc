<SCRIPT LANGUAGE="VBScript" RUNAT="Server">
Sub recordset_Notificacion ( OBJdbConnection, rsRecordSet, IntIdDemanda, IntIdNotificacion )
    If Trim( IntIdDemanda ) = "" or Trim( IntIdNotificacion ) = ""  Then
        odbc_ObtenerRecordSet OBJdbConnection, rsRecordSet, " SELECT * FROM DEMANDA_NOTIF"
    Else
        odbc_ObtenerRecordSet OBJdbConnection, rsRecordSet, " SELECT * FROM DEMANDA_NOTIF WHERE IDDEMANDA = " & IntIdDemanda & " AND IDNOTIFICACION = " & IntIdNotificacion
    End If
End Sub
</SCRIPT>