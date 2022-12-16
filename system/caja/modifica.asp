<% @LCID = 1034 %>
<!--#include file="../arch_utils.asp"-->
<!--#include file="../../lib/comunes/rutinas/funciones.inc" -->
<!--#include file="../../lib/comunes/rutinas/TraeCampo.inc" -->
<!--#include file="../asp/comunes/general/rutinasSCG.inc" -->
<!--#include file="../lib.asp"-->
<!--#include file="../../lib/comunes/rutinas/GrabaAuditoria.inc" -->

<%

	intIdPago = request("intIdPago")
	intMaxCorr = request("intMaxCorr")
	strOrigen = request("strOrigen")

	intMaxCorrMas1 = request("intMaxCorrMas1")

	intNroBoleta = Trim(request("TX_BOLETA"))
	dtmFecPago = Trim(request("TX_FECHAPAGO"))
	intTipoPago = Trim(request("CB_TIPOPAGO"))

	strObservaciones = Trim(request("TX_OBSERVACION"))

	strNroDepositoEmp = Trim(request("TX_NRODEPEMP"))
	strBancoEmpresa = Trim(request("CB_BEMP"))

	strNroDepositoCliente = Trim(request("TX_NRODEPCLIENTE"))
	strBancoCliente = Trim(request("CB_BCLIENTE"))

intHonorarios = Trim(request("TX_MONTOEMP"))
intIntereses = Trim(request("TX_IPCLIENTE"))
intIndemnizacion = Trim(request("TX_INDEM_COMP"))
intGastosJud = Trim(request("TX_GASTOSJUDICIALES"))





	intCodUSuario = session("session_idusuario")

	AbrirScg()


		strSql = "UPDATE CAJA_WEB_EMP SET NRO_BOLETA=" & intNroBoleta & ", FECHA_PAGO='" & dtmFecPago & "',TIPO_PAGO='" & intTipoPago & "',NRO_DEPOSITO_CLIENTE='" & strNroDepositoCliente & "',NRO_DEPOSITO_EMP='" & strNroDepositoEmp & "',BCO_DEPOSITO_CLIENTE='" & strBancoCliente & "',BCO_DEPOSITO_EMP = '" & strBancoEmpresa & "',USRMODIF=" & intCodUSuario & ", FECHA_MODIF = getdate() , MONTO_EMP=" & intHonorarios & ", GASTOSJUDICIALES=" & intGastosJud & ", INTERES_PLAZO =" & intIntereses & ", INDEM_COMP=" & intIndemnizacion
		strSql = strSql & ",OBSERVACIONES_MODIF = OBSERVACIONES_MODIF + ' - ' + '" & strObservaciones & "'"
		strSql = strSql & " WHERE ID_PAGO = " & intIdPago & ""


		set rsUpdate = Conn.execute(strSql)

		aa = GrabaAuditoria("MODIFICAR", "ID_PAGO=" & intIdPago, "modifica.asp", "CAJA_WEB_EMP")


''RESPONSE.WRITE "strSql=" & strSql
''RESPONSE.END


	For intCorr = 1 to  intMaxCorr

		strReq1="CB_BANCO_CLIENTE_" & intCorr
		strCodBanco = Request(strReq1)

		strReq2="TX_NROCHEQUECLI_" & intCorr
		strNroCheque = Request(strReq2)

		strReq3="TX_NROCTACTECLI_" & intCorr
		strNroCtaCte = Request(strReq3)

		strReq4="CB_PLAZA_CLIENTE_" & intCorr
		strCodPlaza = Request(strReq4)

		strReq5="CB_DESTINO_" & intCorr
		strTipoPago = Request(strReq5)

		strReq6="CB_FPAGO_" & intCorr
		strFormaPago = Request(strReq6)

		strReq7="TX_RUTCLI_" & intCorr
		strRutCheque = Request(strReq7)

		strReq8="TX_VENC_" & intCorr
		strFechaCheque = Request(strReq8)

		strReq9="TX_MONTOCLI_" & intCorr
		intMonto = Request(strReq9)


		If Trim(strTipoPago) = "0" AND Trim(strFormaPago) = "DP" Then
			strCodBanco = strBancoCliente
			strNroCheque = ""
			strNroCtaCte = ""
			strCodPlaza = ""
			strRutCheque = ""
			strFechaCheque = ""
		End if
		If Trim(strTipoPago) = "1" AND Trim(strFormaPago) = "DP" Then
			strCodBanco = strBancoEmpresa
			strNroCheque = ""
			strNroCtaCte = ""
			strCodPlaza = ""
			strRutCheque = ""
			strFechaCheque = ""
		End if

		strSql = "UPDATE CAJA_WEB_EMP_DOC_PAGO SET MONTO = " & intMonto & ", COD_BANCO = '" & strCodBanco & "', NRO_CHEQUE = '" & strNroCheque & "', NRO_CTACTE = '" & strNroCtaCte & "', "
		strSql = strSql & " CODIGO_PLAZA = '" & strCodPlaza & "',  TIPO_PAGO = '" & strTipoPago & "', FORMA_PAGO = '" & strFormaPago & "', RUT_CHEQUE = '" & strRutCheque & "', VENCIMIENTO = '" & strFechaCheque & "'"
		strSql = strSql & " WHERE ID_PAGO = " & intIdPago & " AND CORRELATIVO = " & intCorr

		''Response.write "<br>strSql=" & strSql
		set rsUpdate = Conn.execute(strSql)

		aa = GrabaAuditoria("MODIFICAR", "ID_PAGO=" & intIdPago & ", CORRELATIVO=" & intCorr, "modifica.asp", "CAJA_WEB_EMP_DOC_PAGO")

	Next



	strReq1="CB_BANCO_CLIENTE_" & intMaxCorrMas1
	strCodBanco = Request(strReq1)

	strReq2="TX_NROCHEQUECLI_" & intMaxCorrMas1
	strNroCheque = Request(strReq2)

	strReq3="TX_NROCTACTECLI_" & intMaxCorrMas1
	strNroCtaCte = Request(strReq3)

	strReq4="CB_PLAZA_CLIENTE_" & intMaxCorrMas1
	strCodPlaza = Request(strReq4)

	strReq5="CB_DESTINO_" & intMaxCorrMas1
	strTipoPago = Request(strReq5)

	strReq6="CB_FPAGO_" & intMaxCorrMas1
	strFormaPago = Request(strReq6)

	strReq7="TX_RUTCLI_" & intMaxCorrMas1
	strRutCheque = Request(strReq7)

	strReq8="TX_VENC_" & intMaxCorrMas1
	strFechaCheque = Request(strReq8)

	strReq9="TX_MONTOCLI_" & intMaxCorrMas1
	intMonto = Request(strReq9)


	If Trim(strTipoPago) <> "" AND Trim(strFormaPago) <> "" AND Trim(intMonto) <> "" Then

		If Trim(strTipoPago) = "0" AND Trim(strFormaPago) = "DP" Then
			strCodBanco = strBancoCliente
			strNroCheque = ""
			strNroCtaCte = ""
			strCodPlaza = ""
			strRutCheque = ""
			strFechaCheque = ""
		End if
		If Trim(strTipoPago) = "1" AND Trim(strFormaPago) = "DP" Then
			strCodBanco = strBancoEmpresa
			strNroCheque = ""
			strNroCtaCte = ""
			strCodPlaza = ""
			strRutCheque = ""
			strFechaCheque = ""
		End if

		strSql = " INSERT INTO CAJA_WEB_EMP_DOC_PAGO (ID_PAGO, CORRELATIVO,MONTO, COD_BANCO, NRO_CHEQUE, NRO_CTACTE, CODIGO_PLAZA, TIPO_PAGO, FORMA_PAGO, RUT_CHEQUE, VENCIMIENTO) "
		strSql = strSql & " VALUES (" & intIdPago & "," & intMaxCorrMas1 & "," & intMonto & ",'" & strCodBanco & "', '" & strNroCheque & "', '" & strNroCtaCte & "', '" & strCodPlaza & "', '" & strTipoPago & "', '" & strFormaPago & "', '" & strRutCheque & "','" & strFechaCheque & "')"

		''Response.write "<br>strSql=" & strSql
		set rsInsert = Conn.execute(strSql)

		aa = GrabaAuditoria("INSERTAR", "ID_PAGO=" & intIdPago & ", CORRELATIVO=" & intMaxCorrMas1, "modifica.asp", "CAJA_WEB_EMP_DOC_PAGO")

	End If
		CerrarScg()
	%>
	<script>alert("El pago fue modificado correctamente")</script>
	<%
	Response.Write ("<script language = ""Javascript"">" & vbCrlf)
	Response.Write (vbTab & "location.href='" & strOrigen & "?cod_pago=" & Trim(intIdPago) & "'" & vbCrlf)
	Response.Write ("</script>")
%>



