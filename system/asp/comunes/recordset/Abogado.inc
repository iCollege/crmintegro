<SCRIPT LANGUAGE="VBScript" RUNAT="Server">
Sub recordset_Abogado ( OBJdbConnection, rsRecordSet, IntId )
    If Trim( IntId ) = "" Then
        odbc_ObtenerRecordSet OBJdbConnection, rsRecordSet, " SELECT * FROM ABOGADO"
    Else
        odbc_ObtenerRecordSet OBJdbConnection, rsRecordSet, " SELECT * FROM ABOGADO WHERE IDABOGADO = " & IntId
    End If
End Sub
</SCRIPT>