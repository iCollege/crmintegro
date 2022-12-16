<SCRIPT LANGUAGE="VBScript" RUNAT="Server">
Sub insert_Demanda( Conn, dicDemanda)
    If Request("strFormMode") = "Nuevo" Then
        strSQLQuery = "INSERT INTO DEMANDA (RUTDEUDOR,CODCLIENTE,IDTRIBUNAL,ROLANO,FECHA_INGRESO,FECHA_CADUCIDAD,IDPROCURADOR,IDABOGADO,IDACTUARIO,MONTO,FECHA_COMPARENDO,HORA_COMPARENDO,RAZON_TERMINO,GASTOS_JUDICIALES,HONORARIOS,INTERESES,INDEM_COMPENSATORIA,TOTAL_APAGAR,IDESTADO, FECHA_PRES_ESCRITO, TIPO_DEMANDA)"
        strSQLQuery = strSQLQuery & " VALUES ('" & dicDemanda("RUTDEUDOR") & "','" & dicDemanda("CODCLIENTE") & "'," & dicDemanda("IDTRIBUNAL") & " , '" &dicDemanda("ROLANO") & "','" & dicDemanda("FECHA_INGRESO") & "','" & dicDemanda("FECHA_CADUCIDAD") & "'," & dicDemanda("IDPROCURADOR") & "," & dicDemanda("IDABOGADO") & "," & dicDemanda("IDACTUARIO") & "," & dicDemanda("MONTO") & ",'" & dicDemanda("FECHA_COMPARENDO") & "','" & dicDemanda("HORA_COMPARENDO") & "'," & dicDemanda("RAZON_TERMINO") & "," & dicDemanda("GASTOS_JUDICIALES") & "," & dicDemanda("HONORARIOS") & "," & dicDemanda("INTERESES") & "," & dicDemanda("INDEM_COMPENSATORIA") & "," & dicDemanda("TOTAL_APAGAR") & "," & dicDemanda("IDESTADO") & ",'" & dicDemanda("FECHA_PRES_ESCRITO") & "','" & dicDemanda("TIPO_DEMANDA") & "')"
        'Response.write strSQLQuery
        'Response.End
        set RS = Conn.execute(strSQLQuery)
    Else
    	strSql="SELECT RUTDEUDOR,CODCLIENTE,IDTRIBUNAL,ROLANO,FECHA_INGRESO,FECHA_CADUCIDAD,IDPROCURADOR,IDABOGADO,IDACTUARIO, MONTO,FECHA_COMPARENDO,HORA_COMPARENDO,RAZON_TERMINO,GASTOS_JUDICIALES,HONORARIOS,INTERESES,INDEM_COMPENSATORIA,TOTAL_APAGAR,IDESTADO, FECHA_PRES_ESCRITO, TIPO_DEMANDA FROM DEMANDA WHERE IDDEMANDA = " + Cstr(dicDemanda.Item("IDDEMANDA"))
        'Response.write strSql
        'Response.End 
        InsertUpdate Conn, dicDemanda, strSql
    End If
End Sub
</SCRIPT>



		 
		 
