<SCRIPT LANGUAGE=VBScript RUNAT=Server>
' --------------------------------------------------------------------------------------------
' Funci?n    : DesConectar
' Descripci?n: Se desconecta de la base de datos.
' Argumentos : No tiene
' Retorna    : El objeto Conectado

 Function odbc_DesConectar( objDbConnection )
	objDbConnection.Close()
	Set objDbConnection = Nothing
 End Function
</SCRIPT>
