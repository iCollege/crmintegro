<SCRIPT LANGUAGE="VBScript" RUNAT="Server">
Sub insert_Cliente( Conn, dicCliente)
    If Request("strFormMode") = "Nuevo" Then
        strSql = "INSERT INTO CLIENTE (CODCLIENTE, DESCRIPCION, NOMBRE_FANTASIA, RAZON_SOCIAL,RUT,DIRECCION,COMUNA,FONO1,FONO2,NOM_CONTACTO,EMAIL_CONTACTO,TASA_MAX_CONV,IC_PORC_CAPITAL,HON_PORC_CAPITAL,PIE_PORC_CAPITAL,TIPO_INTERES, ACTIVO, GASTOS_OPERACIONALES, GASTOS_ADMINISTRATIVOS, GASTOS_OPERACIONALES_CD, GASTOS_ADMINISTRATIVOS_CD,"
        strSql = strSql & " ADIC1, ADIC2, ADIC3, ADIC4, ADIC5, ADIC91, ADIC92, ADIC93, ADIC94, ADIC95, USA_CUSTODIO, COLOR_CUSTODIO, INTERES_MORA, TIPO_CLIENTE, EXPIRACION_CONVENIO, EXPIRACION_ANULACION, COD_MONEDA,COD_TIPODOCUMENTO_HON, NOMBRE_CONV_PAGARE)"
        strSql = strSql & " VALUES ('" & dicCliente("CODCLIENTE") & "','" & dicCliente("DESCRIPCION") & "','" & dicCliente("NOMBRE_FANTASIA") & "','" & dicCliente("RAZON_SOCIAL") & "','" & dicCliente("RUT") & "','" & dicCliente("DIRECCION") & "','" & dicCliente("COMUNA") & "','" & dicCliente("FONO1") & "','" & dicCliente("FONO2") & "','" & dicCliente("NOM_CONTACTO") & "','" & dicCliente("EMAIL_CONTACTO") & "'," & dicCliente("IC_PORC_CAPITAL") & "," & dicCliente("IC_PORC_CAPITAL") & "," & dicCliente("HON_PORC_CAPITAL") & "," & dicCliente("PIE_PORC_CAPITAL") & ",'" & dicCliente("TIPO_INTERES") & "'," & dicCliente("ACTIVO") & "," & dicCliente("GASTOS_OPERACIONALES") & "," & dicCliente("GASTOS_ADMINISTRATIVOS") & "," & dicCliente("GASTOS_OPERACIONALES_CD") & "," & dicCliente("GASTOS_ADMINISTRATIVOS_CD") 
        strSql = strSql & ",'" & dicCliente("ADIC1") & "','" & dicCliente("ADIC2") & "','" & dicCliente("ADIC3") & "','" & dicCliente("ADIC4") & "','" & dicCliente("ADIC5") & "','" & dicCliente("ADIC91") & "','" & dicCliente("ADIC92") & "','" & dicCliente("ADIC93") & "','" & dicCliente("ADIC94")  & "','" & dicCliente("ADIC95") & "','" & dicCliente("USA_CUSTODIO") & "','" & dicCliente("COLOR_CUSTODIO") & "'," & dicCliente("INTERES_MORA") & ",'" & dicCliente("TIPO_CLIENTE") & "'," & dicCliente("EXPIRACION_CONVENIO") & "," & dicCliente("EXPIRACION_ANULACION") & ",'" & dicCliente("COD_MONEDA") & "','" & dicCliente("COD_TIPODOCUMENTO_HON") & "','" & dicCliente("NOMBRE_CONV_PAGARE") & "')"
        'Response.write "strSql=" & strSql
        'Response.End
        set RS = Conn.execute(strSql)
    Else
    	strSql="SELECT DESCRIPCION, NOMBRE_FANTASIA, RAZON_SOCIAL,RUT,DIRECCION,COMUNA,FONO1,FONO2,NOM_CONTACTO,EMAIL_CONTACTO,TASA_MAX_CONV,IC_PORC_CAPITAL,HON_PORC_CAPITAL,PIE_PORC_CAPITAL,TIPO_INTERES, ACTIVO, GASTOS_OPERACIONALES, GASTOS_ADMINISTRATIVOS , GASTOS_OPERACIONALES_CD, GASTOS_ADMINISTRATIVOS_CD, ADIC1, ADIC2, ADIC3, ADIC4, ADIC5, ADIC91, ADIC92, ADIC93, ADIC94, ADIC95, USA_CUSTODIO,COLOR_CUSTODIO, INTERES_MORA, TIPO_CLIENTE, EXPIRACION_CONVENIO, EXPIRACION_ANULACION,COD_MONEDA, COD_TIPODOCUMENTO_HON , NOMBRE_CONV_PAGARE FROM CLIENTE WHERE CODCLIENTE = '" & Cstr(dicCliente.Item("CODCLIENTE")) & "'"
    	InsertUpdate Conn, dicCliente, strSql
    End If
End Sub
</SCRIPT>



		 
		 
