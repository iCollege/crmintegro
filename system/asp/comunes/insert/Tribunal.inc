<SCRIPT LANGUAGE="VBScript" RUNAT="Server">
Sub insert_Tribunal( Conn, dicTribunal)
    If Request("strFormMode") = "Nuevo" Then
        strSQLQuery = "INSERT INTO TRIBUNAL (NOMTRIBUNAL,RECEPTOR,DIRECCION, COMUNA, FONO1, FONO2,ACTIVO)"
        strSQLQuery = strSQLQuery & " VALUES ('" & dicTribunal("NOMTRIBUNAL") & "','" & dicTribunal("RECEPTOR") & "','" & dicTribunal("DIRECCION") & "','" & dicTribunal("COMUNA") & "','" & dicTribunal("FONO1") & "','" & dicTribunal("FONO2") & "'," & dicTribunal("ACTIVO") & ")"
        'Response.write strSQLQuery
        'Response.End
        set RS = Conn.execute(strSQLQuery)
    Else
    	strSql="SELECT NOMTRIBUNAL,RECEPTOR,DIRECCION, COMUNA, FONO1, FONO2, ACTIVO FROM TRIBUNAL WHERE IDTRIBUNAL = " + Cstr(dicTribunal.Item("IDTRIBUNAL"))
        InsertUpdate Conn, dicTribunal, strSql
    End If
End Sub
</SCRIPT>



		 
		 
