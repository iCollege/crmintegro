<SCRIPT LANGUAGE="VBScript" RUNAT="Server">
Sub recordset_EstadoDemanda ( OBJdbConnection, rsRecordSet, IntId )
    If Trim( IntId ) = "" Then
        odbc_ObtenerRecordSet OBJdbConnection, rsRecordSet, " SELECT * FROM ESTADODEMANDA"
    Else
        odbc_ObtenerRecordSet OBJdbConnection, rsRecordSet, " SELECT * FROM ESTADODEMANDA WHERE IDESTADODEMANDA = " & IntId
    End If
End Sub
</SCRIPT>