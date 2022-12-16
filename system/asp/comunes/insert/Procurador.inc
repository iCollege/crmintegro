<SCRIPT LANGUAGE="VBScript" RUNAT="Server">
Sub insert_Procurador( Conn, dicProcurador)
    If Request("strFormMode") = "Nuevo" Then
        strSQLQuery = "INSERT INTO PROCURADOR (NOMPROCURADOR, ACTIVO)"
        strSQLQuery = strSQLQuery & " VALUES ('" & dicProcurador("NOMPROCURADOR") & "','" & dicProcurador("ACTIVO") & "')"
        'Response.write strSQLQuery
        'Response.End
        set RS = Conn.execute(strSQLQuery)
    Else
    	strSql="SELECT NOMPROCURADOR, ACTIVO FROM PROCURADOR WHERE IDPROCURADOR = " + Cstr(dicProcurador.Item("IDPROCURADOR"))
        InsertUpdate Conn, dicProcurador, strSql
    End If
End Sub
</SCRIPT>



		 
		 
