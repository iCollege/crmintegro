<SCRIPT LANGUAGE="VBScript" RUNAT="Server">
Sub select_ClienteQry ( OBJdbConnection, strWhere, arrResultado, intNumRegistros)
    strQuery= " SELECT * FROM CLIENTE " & strWhere & " ORDER BY CODCLIENTE DESC"
    'Response.Write strQuery
    odbc_ObtenerRegistros OBJdbConnection, arrResultado, intNumRegistros, strQuery
End Sub
</SCRIPT>