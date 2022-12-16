<SCRIPT LANGUAGE="VBScript" RUNAT="Server">
Sub recordset_Remesa ( OBJdbConnection, rsRecordSet, IntId, IntIdCliente )

    If Trim( IntId ) = "" Then
        odbc_ObtenerRecordSet OBJdbConnection, rsRecordSet, " SELECT * FROM REMESA"
    Else
    	odbc_ObtenerRecordSet OBJdbConnection, rsRecordSet, " SELECT * FROM REMESA WHERE CODREMESA = " & IntId & " AND CODCLIENTE = '" & IntIdCliente & "'" 
     End If
End Sub
</SCRIPT>