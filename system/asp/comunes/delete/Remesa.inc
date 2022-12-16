<SCRIPT LANGUAGE="VBScript" RUNAT="Server">
Sub delete_Remesa (OBJdbConnection, ByVal Id, ByVal intIdCliente, ByRef Mensaje)

   Mensaje = ""
   odbc_BorrarRegistro OBJdbConnection, "SELECT * FROM REMESA WHERE CODREMESA = " & Cstr(Id) & " AND CODCLIENTE = '" & intIdCliente & "'"
   If Cstr(Err) = "3219" Then Mensaje = "No se puede borrar el registro "

End Sub
</SCRIPT>

