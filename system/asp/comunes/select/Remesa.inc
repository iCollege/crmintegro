<SCRIPT LANGUAGE="VBScript" RUNAT="Server">
Sub select_Remesa ( OBJdbConnection, arrResultado, intNumRegistros)
    strQuery= " SELECT * FROM REMESA ORDER BY CODREMESA DESC"
    'Response.Write strQuery
    odbc_ObtenerRegistros OBJdbConnection, arrResultado, intNumRegistros, strQuery
End Sub
</SCRIPT>