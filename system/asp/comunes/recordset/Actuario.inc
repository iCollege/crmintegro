<SCRIPT LANGUAGE="VBScript" RUNAT="Server">
Sub recordset_Actuario ( OBJdbConnection, rsRecordSet, IntId )
    If Trim( IntId ) = "" Then
        odbc_ObtenerRecordSet OBJdbConnection, rsRecordSet, " SELECT * FROM ACTUARIO"
    Else
        odbc_ObtenerRecordSet OBJdbConnection, rsRecordSet, " SELECT * FROM ACTUARIO WHERE IDACTUARIO = " & IntId
    End If
End Sub
</SCRIPT>