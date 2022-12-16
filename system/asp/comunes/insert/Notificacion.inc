<SCRIPT LANGUAGE="VBScript" RUNAT="Server">
Sub insert_notificacion( Conn, dicNotificacion)
    If Request("strFormMode") = "Nuevo" OR strNuevo = "1" Then
        strSQLQuery = "INSERT INTO DEMANDA_NOTIF (IDDEMANDA, IDNOTIFICACION, FECHA, VALOR, IDESTADONOTIF, BOLETA, PATENTE, IDUSUARIO, OBSERVACIONES)"
        strSQLQuery = strSQLQuery & " VALUES (" & dicNotificacion("IDDEMANDA") & "," & dicNotificacion("IDNOTIFICACION") & ",'" & dicNotificacion("FECHA") & "'," & dicNotificacion("VALOR") & "," & dicNotificacion("IDESTADONOTIF") & ",'" & dicNotificacion("BOLETA") & "','" & dicNotificacion("PATENTE") & "'," & dicNotificacion("IDUSUARIO") & ",'" & dicNotificacion("OBSERVACIONES") & "')"
        'Response.write strSQLQuery
        'Response.End
        set RS = Conn.execute(strSQLQuery)
    Else
    	strSql="SELECT FECHA, VALOR, IDESTADONOTIF, BOLETA, PATENTE, IDUSUARIO, OBSERVACIONES FROM DEMANDA_NOTIF WHERE IDDEMANDA = " + Cstr(dicNotificacion.Item("IDDEMANDA")) & " AND IDNOTIFICACION = " + Cstr(dicNotificacion.Item("IDNOTIFICACION"))
        InsertUpdate Conn, dicNotificacion, strSql
    End If
End Sub
</SCRIPT>



		 
		 
