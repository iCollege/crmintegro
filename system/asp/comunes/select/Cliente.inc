<SCRIPT LANGUAGE="VBScript" RUNAT="Server">
Sub select_Cliente ( OBJdbConnection, arrResultado, intNumRegistros)
    strQuery= " SELECT * FROM CLIENTE ORDER BY CODCLIENTE DESC"
    'Response.Write strQuery
    odbc_ObtenerRegistros OBJdbConnection, arrResultado, intNumRegistros, strQuery
End Sub
</SCRIPT>