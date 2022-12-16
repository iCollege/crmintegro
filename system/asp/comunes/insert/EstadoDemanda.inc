<SCRIPT LANGUAGE="VBScript" RUNAT="Server">
Sub insert_EstadoDemanda( Conn, dicEstadoDemanda)
    If Request("strFormMode") = "Nuevo" Then
        strSQLQuery = "INSERT INTO ESTADODEMANDA (NOMESTADODEMANDA, ACTIVO)"
        strSQLQuery = strSQLQuery & " VALUES ('" & dicEstadoDemanda("NOMESTADODEMANDA") & "','" & dicEstadoDemanda("ACTIVO") & "')"
        'Response.write strSQLQuery
        'Response.End
        set RS = Conn.execute(strSQLQuery)
    Else
    	strSql="SELECT NOMESTADODEMANDA, ACTIVO FROM ESTADODEMANDA WHERE IDESTADODEMANDA = " + Cstr(dicEstadoDemanda.Item("IDESTADODEMANDA"))
        InsertUpdate Conn, dicEstadoDemanda, strSql
    End If
End Sub
</SCRIPT>



		 
		 
