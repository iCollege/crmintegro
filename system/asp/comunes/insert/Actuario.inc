<SCRIPT LANGUAGE="VBScript" RUNAT="Server">
Sub insert_Actuario( Conn, dicActuario)
    If Request("strFormMode") = "Nuevo" Then
        strSQLQuery = "INSERT INTO ACTUARIO (NOMACTUARIO, COD_INTERNO, ACTIVO)"
        strSQLQuery = strSQLQuery & " VALUES ('" & dicActuario("NOMACTUARIO") & "','" &  dicActuario("COD_INTERNO") & "'," & dicActuario("ACTIVO") & ")"
        'Response.write strSQLQuery
        'Response.End
        set RS = Conn.execute(strSQLQuery)
    Else
    	strSql="SELECT NOMACTUARIO, COD_INTERNO, ACTIVO FROM ACTUARIO WHERE IDACTUARIO = " + Cstr(dicActuario.Item("IDACTUARIO"))
        InsertUpdate Conn, dicActuario, strSql
    End If
End Sub
</SCRIPT>
	


		 
		 
