<SCRIPT LANGUAGE="VBScript" RUNAT="Server">
Sub insert_Abogado( Conn, dicAbogado)
    If Request("strFormMode") = "Nuevo" Then
        strSQLQuery = "INSERT INTO ABOGADO (NOMABOGADO, ACTIVO)"
        strSQLQuery = strSQLQuery & " VALUES ('" & dicAbogado("NOMABOGADO") & "','" & dicAbogado("ACTIVO") & "')"
        'Response.write strSQLQuery
        'Response.End
        set RS = Conn.execute(strSQLQuery)
    Else
    	strSql="SELECT NOMABOGADO, ACTIVO FROM ABOGADO WHERE IDABOGADO = " + Cstr(dicAbogado.Item("IDABOGADO"))
        InsertUpdate Conn, dicAbogado, strSql
    End If
End Sub
</SCRIPT>



		 
		 
