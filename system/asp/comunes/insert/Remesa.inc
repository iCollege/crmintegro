<SCRIPT LANGUAGE="VBScript" RUNAT="Server">
Sub insert_Remesa( Conn, dicRemesa)
    If Request("strFormMode") = "Nuevo" Then
        strSQLQuery = "INSERT INTO REMESA (CODREMESA, CODCLIENTE, NOMBRE, DESCRIPCION, FECHA_LLEGADA,FECHA_CARGA, ACTIVO)"
        strSQLQuery = strSQLQuery & " VALUES (" & dicRemesa("CODREMESA") & ",'" & dicRemesa("CODCLIENTE") & "','" & dicRemesa("NOMBRE") & "','" & dicRemesa("DESCRIPCION") & "','" & dicRemesa("FECHA_LLEGADA") & "','" & dicRemesa("FECHA_CARGA") & "'," & dicRemesa("ACTIVO")  & ")"
        'Response.write "strSQLQuery=" & strSQLQuery
        'Response.End
        set RS = Conn.execute(strSQLQuery)
    Else
    	strSql="SELECT NOMBRE, DESCRIPCION,FECHA_LLEGADA,FECHA_CARGA, ACTIVO FROM REMESA WHERE CODREMESA = " + Cstr(dicRemesa.Item("CODREMESA")) & " AND CODCLIENTE = '" + Cstr(dicRemesa.Item("CODCLIENTE")) & "'"
    	InsertUpdate Conn, dicRemesa, strSql
    End If
End Sub
</SCRIPT>

