<% @LCID = 1034 %>
<!--#include file="sesion.asp"-->
<!--#include file="arch_utils.asp"-->
<!--#include file="../lib/comunes/rutinas/funciones.inc" -->
<!--#include file="../lib/comunes/rutinas/TraeCampo.inc" -->
<!--#include file="asp/comunes/general/rutinasSCG.inc" -->

<script language="JavaScript" src="../lib/cal2.js"></script>
<script language="JavaScript" src="../lib/cal_conf2.js"></script>
<script language="JavaScript" src="../lib/validaciones.js"></script>
<link href="style.css" rel="stylesheet" type="text/css">

<%
	If Trim(Request("Limpiar"))="1" Then
		session("session_rutdeudor") = ""
		rut = ""
	End if

	rut = request("rut")
	id_convenio = request("id_convenio")

	if trim(rut) <> "" Then
		session("session_rutdeudor") = rut
	Else
		rut = session("session_rutdeudor")
	End if

	strRutDeudor=rut

	intSeq = request("intSeq")
	strGraba = request("strGraba")
	txt_FechaIni = request("txt_FechaIni")
	intSucursal="1"
	fecha= date
	strCodCliente = request("CB_CLIENTE")
	strCodCliente = session("ses_codcli")

	usuario=session("session_idusuario")

	AbrirSCG()

	intNroBoleta = request("TX_BOLETA")
	intCompIngreso = request("TX_COMPINGRESO")
	intCantDoc = request("TX_CANTDOC")
	intMontoCliente = request("TX_MONTOCLIENTE")
	intFormaPagoCliente = request("CB_FPAGO_CLIENTE")
	intFormaPagoEMP = request("CB_FPAGO_CLIENTE")
	intTipoPago = request("CB_TIPOPAGO")

	strBcoDepEmpresa = request("CB_BEMP")
	strBcoDepCliente = request("CB_BCLIENTE")

	strNroDepCliente = request("TX_NRODEPCLIENTE")
	strNroDepEmpresa = request("TX_NRODEPEMP")

	strClaveDeudor = request("TX_CLAVEDOC")
	dtmFechaPago = request("TX_FECHA_PAGO")
	intPeriodoPagado = request("TX_PERIODO")
	intCapital = request("TX_CAPITAL")
	intReajuste = request("TX_REAJUSTE")
	intInteres = request("TX_INTERES")
	intGravamenes = request("TX_GRAVAMENES")
	intMulta = request("TX_MULTAS")
	intCargos = request("TX_CARGOS")
	intCostas = request("TX_COSTAS")

	strDocCancelados = request("TX_DOCCANCELADOS")
	strObservaciones = request("TX_OBSERVACIONES")

	intTotalCapital = ValNulo(request("TX_DEUDACAPITAL"),"N")
	intIndemComp = ValNulo(request("TX_INDCOM"),"N")
	intHonorarios = ValNulo(request("TX_HONORARIOS"),"N")
	intOtros = ValNulo(request("TX_OTROS"),"N")
	intIntereses = ValNulo(request("TX_INTERESES"),"N")
	intGastosJud = ValNulo(request("TX_GASTOSJUD"),"N")


	intGastosAdmin = ValNulo(request("TX_GASTOSADMIN"),"N")



	intDescuento = ValNulo(request("TX_DESCUENTO"),"N")

	intNroBoleta = ValNulo(intNroBoleta,"N")
	intCompIngreso = ValNulo(intCompIngreso,"C")
	intCantDoc = ValNulo(intCantDoc,"N")
	intMontoCliente = Trim(intMontoCliente)
	intFormaPagoCliente = Trim(intFormaPagoCliente)
	intFormaPagoEMP = Trim(intFormaPagoEMP)
	intTipoPago = Trim(intTipoPago)
	If Trim(intTipoPago) =  "RP" Then intTipoPago =  "RP1"
	strNroDepCliente = Trim(strNroDepCliente)
	strNroDepEmpresa = Trim(strNroDepEmpresa)
	strClaveDeudor = Trim(strClaveDeudor)
	dtmFechaPago = Trim(dtmFechaPago)
	intPeriodoPagado = Trim(intPeriodoPagado)
	intCapital = Trim(intCapital)
	intReajuste = ValNulo(intReajuste,"N")
	intInteres = ValNulo(intInteres,"N")
	intGravamenes = Trim(intGravamenes)
	intMulta = Trim(intMulta)
	intCargos = Trim(intCargos)
	intCostas = Trim(intCostas)
	intOtros = Trim(intOtros)
	strDocCancelados = Trim(strDocCancelados)
	strObservaciones = Trim(strObservaciones)

	strSql="SELECT ISNULL(FECHA_APERTURA,'') AS FECHA_APERTURA, ISNULL(FECHA_CIERRE,'') AS FECHA_CIERRE FROM CAJA_WEB_EMP_CIERRE WHERE COD_USUARIO = " & usuario
	strSql= strSql & " AND CONVERT(VARCHAR(10),FECHA_APERTURA,103) = CONVERT(VARCHAR(10),GETDATE(),103)"
	'Response.write "<br>strSql=" & strSql

	set rsApertura=Conn.execute(strSql)
	If Not rsApertura.Eof Then
		strApertura="OK"
		dtmFechaCaja = rsApertura("FECHA_APERTURA")
	Else
		strSql1="SELECT ISNULL(FECHA_APERTURA,'') AS FECHA_APERTURA, ISNULL(FECHA_CIERRE,'') AS FECHA_CIERRE FROM CAJA_WEB_EMP_CIERRE WHERE COD_USUARIO = " & usuario
		strSql1= strSql1 & " AND CONVERT(VARCHAR(10),FECHA_APERTURA,103) = CONVERT(VARCHAR(10),DATEADD(DAY,1,GETDATE()),103)"
		'Response.write "strSql1=" & strSql1
		'Response.End
		set rsAperturaDS=Conn.execute(strSql1)
		If Not rsAperturaDS.Eof Then
			strApertura="OK"
			dtmFechaCaja = rsAperturaDS("FECHA_APERTURA")
		Else
			strApertura="NOK"
			strCierreHab = "NO"
			dtmFechaCaja = ""
		End If
	End if


	strSql="SELECT ISNULL(FECHA_APERTURA,'') AS FECHA_APERTURA, ISNULL(FECHA_CIERRE,'') AS FECHA_CIERRE FROM CAJA_WEB_EMP_CIERRE WHERE COD_USUARIO = " & usuario
	strSql= strSql & " AND CONVERT(VARCHAR(10),FECHA_CIERRE,103) = CONVERT(VARCHAR(10),GETDATE(),103)"
	'Response.write "<br>strSql=" & strSql
	set rsCierre=Conn.execute(strSql)
	If Not rsCierre.Eof Then
		strSql1="SELECT ISNULL(FECHA_APERTURA,'') AS FECHA_APERTURA, ISNULL(FECHA_CIERRE,'') AS FECHA_CIERRE FROM CAJA_WEB_EMP_CIERRE WHERE COD_USUARIO = " & usuario
		strSql1= strSql1 & " AND CONVERT(VARCHAR(10),FECHA_APERTURA,103) = CONVERT(VARCHAR(10),DATEADD(DAY,1,GETDATE()),103)"
		'Response.End
		set rsAperturaDS=Conn.execute(strSql1)
		If Not rsAperturaDS.Eof Then
			strApertura="OK"
			dtmFechaCaja = rsAperturaDS("FECHA_APERTURA")
		Else
			strApertura="NOK"
			strCierreHab = "NO"
			dtmFechaCaja = ""
		End If
		strSql1="SELECT ISNULL(FECHA_APERTURA,'') AS FECHA_APERTURA, ISNULL(FECHA_CIERRE,'') AS FECHA_CIERRE FROM CAJA_WEB_EMP_CIERRE WHERE COD_USUARIO = " & usuario
		strSql1= strSql & " AND CONVERT(VARCHAR(10),FECHA_CIERRE,103) = CONVERT(VARCHAR(10),DATEADD(DAY,1,GETDATE()),103)"
		set strCierreDS=Conn.execute(strSql1)
		If Not strCierreDS.Eof Then
			strCierre="OK"
		Else
			strCierre=""
		End If
	Else

		'strCierre="NOK"
		'strCierreHab = "NO"

		strCierre="OK"
		strCierreHab = ""
	End if


	'Response.write "strCierreHab=" & strCierreHab
	'Response.write strSql
	'Response.End

	If strApertura="NOK" Then
		strCierreHab = "NO"
		%>
		<SCRIPT>
			alert('Caja no ha sido abierta para el día de hoy. Debe abrir la caja para el día de hoy para poder ingresar pagos.')
		</SCRIPT>
		<%
	End If

	If strCierre="NOK" Then
		strCierreHab = "NO"
		%>
		<SCRIPT>
			alert('Caja Cerrada para el día de hoy, No puede ingresar pagos para este día.')
		</SCRIPT>
		<%
	End If

	Response.write id_convenio
	
	If Trim(intTipoPago) =  "CO" OR Trim(intTipoPago) =  "CC" Then
		strSql="SELECT ID_CONVENIO FROM CONVENIO_ENC "
		'strSql= strSql & "WHERE RUTDEUDOR = '" & strRutDeudor & "' AND COD_CLIENTE = '" & strCodCliente & "'"
		strSql= strSql & "WHERE ID_CONVENIO = '" & id_convenio & "'"
		strTitCol = "CONVENIO"
		set rsConvenio=Conn.execute(strSql)
		If Not rsConvenio.Eof Then
			id_convenio = rsConvenio("ID_CONVENIO")
		End If
	ElseIf Trim(intTipoPago) =  "RP" Then
		strSql="SELECT ID_CONVENIO FROM REPACTACION_ENC "
		'strSql= strSql & "WHERE RUTDEUDOR = '" & strRutDeudor & "' AND COD_CLIENTE = '" & strCodCliente & "'"
		strSql= strSql & "WHERE ID_CONVENIO = " & id_convenio & "'"
		strTitCol = "REPACTACION"
		set rsConvenio=Conn.execute(strSql)
		If Not rsConvenio.Eof Then
			id_convenio = rsConvenio("ID_CONVENIO")
		End If
	Else
		strSql="SELECT ID_CONVENIO FROM CONVENIO_ENC "
		strSql= strSql & "WHERE RUTDEUDOR = '" & strRutDeudor & "' AND COD_CLIENTE = '" & strCodCliente & "'"

		set rsConvenio=Conn.execute(strSql)
		If Not rsConvenio.Eof Then
			strTieneConvenio = "SI"
		End If

	End if

	strSql = "SELECT * FROM CAJA_WEB_EMP_DOC_PAGO WHERE FORMA_PAGO = 'CU'"
	strSql = strSql & " AND ID_PAGO IN (SELECT ID_PAGO FROM CAJA_WEB_EMP WHERE COD_CLIENTE = '" & strCodCliente & "' AND RUTDEUDOR = '" & strRutDeudor & "')"

	set rsIC=Conn.execute(strSql)

	If Not rsIC.Eof Then
		strPosibIc = "SI"
	Else
		strPosibIc = "NO"
	End If

	If Trim(request("strGraba")) = "SI" Then
		''Response.write "GRABANDO"

		strSql = "EXEC UPD_SEC 'NRO_COMP'"
		set rsNroComp=Conn.execute(strSql)
		If not rsNroComp.Eof then
			intCompIngreso = rsNroComp("SEQ")
		Else
			intCompIngreso = "1"
		End if

		strSql = "EXEC UPD_SEC 'CAJA_WEB_EMP'"

		set rsPago=Conn.execute(strSql)
		If not rsPago.Eof then
			intSeq = rsPago("SEQ")
		End if

		intTotalCliente = intTotalCapital + intIndemComp + intGastosJud + intIntereses '''+ intOtros
		intTotalEmpresa = ValNulo(intHonorarios,"N") + ValNulo(intOtros,"N") + ValNulo(intGastosAdmin,"N")

		If Trim(intTipoPago) =  "RP1" Then intTipoPago =  "RP"

		strSql = "INSERT INTO CAJA_WEB_EMP (ID_PAGO, FECHA_PAGO, COD_CLIENTE, RUTDEUDOR, COMP_INGRESO, NRO_BOLETA, MONTO_CAPITAL, TIPO_PAGO, INDEM_COMP, MONTO_EMP, GASTOSJUDICIALES, GASTOSOTROS, INTERES_PLAZO, TOTAL_CLIENTE, TOTAL_EMP, USRINGRESO, FECHAINGRESO, DESC_CLIENTE, ID_CONVENIO, OBSERVACIONES, GASTOSADMINISTRATIVOS) "
		strSql = strSql & " VALUES (" & intSeq & ", '" & dtmFechaCaja & "','" & strCodCliente & "','" & strRutDeudor & "'," & intCompIngreso & "," & intNroBoleta & "," & intTotalCapital & ",'" & intTipoPago & "'," & intIndemComp & "," & intHonorarios & "," & intGastosJud & "," & intOtros & "," & intIntereses & "," & intTotalCliente & "," & intTotalEmpresa & "," & session("session_idusuario") & ",getdate()," & intDescuento & "," & ValNulo(id_convenio,"N") & ",'" & strObservaciones & "'," & intGastosAdmin & ")"

		Response.write strSql

		If Trim(intTipoPago) =  "RP" Then intTipoPago =  "RP1"
		'Response.write strSql
		''Response.End
		set rsInsertaEnc=Conn.execute(strSql)

		If Trim(intTipoPago) <> "CO" AND Trim(intTipoPago) <> "CC" AND Trim(intTipoPago) <> "RP" Then

			strSql = "SELECT NRODOC, CUENTA, FECHAVENC FROM CUOTA WHERE RUTDEUDOR='" & rut & "' AND CODCLIENTE='" & strCodCliente & "' AND SALDO > 0"
			set rsTemp= Conn.execute(strSql)

			intCorrelativo = 1
			Do until rsTemp.eof
				strObjeto = "CH_" & Replace(Trim(rsTemp("NRODOC")),"-","_")
				strObjeto1 = "TX_SALDO_" & Replace(Trim(rsTemp("NRODOC")),"-","_")
				If UCASE(Request(strObjeto)) = "ON" Then

					intSaldo = Request(strObjeto1)
					strNroDoc = rsTemp("NRODOC")
					strCuenta = rsTemp("CUENTA")
					strFechaVenc = rsTemp("FECHAVENC")

					strSql = "INSERT INTO CAJA_WEB_EMP_DETALLE (ID_PAGO, CORRELATIVO, NRODOC, CUENTA, FECHAVENC, CAPITAL, REAJUSTE, INTERESES) "
					strSql = strSql & " VALUES (" & intSeq & ", " & intCorrelativo & ",'" & strNroDoc & "','" & strCuenta & "','" & strFechaVenc & "'," & intSaldo & "," & intReajuste & "," & intInteres & ")"
					'Response.write strSql
					'Response.End
					set rsInsertaDet=Conn.execute(strSql)

					strSql = "UPDATE CUOTA SET IDPAGO = " & intSeq & ", IDPAGOCORR = " & intCorrelativo & ", SALDO = 0, ESTADO_DEUDA = '4', FECHA_ESTADO = GETDATE() WHERE RUTDEUDOR = '" & rut & "' AND CODCLIENTE = '" & strCodCliente & "' AND NRODOC = '" & strNroDoc & "'"
					'Response.write strSql
					'Response.End
					set rsUpdate=Conn.execute(strSql)

				End if
			rsTemp.movenext
			intCorrelativo = intCorrelativo + 1
			loop
			rsTemp.close
			set rsTemp=nothing

		Else
			If Trim(intTipoPago)="CO" or Trim(intTipoPago) = "CC"  Then
				strSql = "SELECT ID_CONVENIO, CUOTA, TOTAL_CUOTA, FECHA_PAGO AS FECHAVENC FROM CONVENIO_DET WHERE ID_CONVENIO = " & id_convenio & " AND ID_CONVENIO IN (SELECT ID_CONVENIO FROM CONVENIO_ENC WHERE COD_CLIENTE = '" & strCodCliente & "')"
			Else
				strSql = "SELECT ID_CONVENIO, CUOTA, TOTAL_CUOTA, FECHA_PAGO AS FECHAVENC FROM REPACTACION_DET WHERE ID_CONVENIO = " & id_convenio & " AND ID_CONVENIO IN (SELECT ID_CONVENIO FROM REPACTACION_ENC WHERE COD_CLIENTE = '" & strCodCliente & "')"
			End If
			set rsTemp= Conn.execute(strSql)
			intCorrelativo = 1
			Do until rsTemp.eof
				strObjeto = "CH_" & rsTemp("CUOTA")
				strObjeto1 = "TX_SALDO_" & rsTemp("CUOTA")
				If UCASE(Request(strObjeto)) = "ON" Then

					intSaldo = Request(strObjeto1)
					intNroCuota = rsTemp("CUOTA")
					strFechaVenc = rsTemp("FECHAVENC")

					strSql = "INSERT INTO CAJA_WEB_EMP_DETALLE (ID_PAGO, CORRELATIVO, NRODOC, FECHAVENC, CAPITAL, REAJUSTE, INTERESES) "
					strSql = strSql & " VALUES (" & intSeq & ", " & intCorrelativo & ",'" & intNroCuota & "','" & strFechaVenc & "'," & intSaldo & "," & intReajuste & "," & intInteres & ")"
					'Response.write strSql
					'Response.End
					set rsInsertaDet=Conn.execute(strSql)

					If Trim(intTipoPago)="CO" or Trim(intTipoPago) = "CC" Then
						strSql = "UPDATE CONVENIO_DET SET IDPAGO = " & intSeq & ", IDPAGOCORR = " & intCorrelativo & ",PAGADA = 'S', FECHA_DEL_PAGO = GETDATE() WHERE ID_CONVENIO = " & id_convenio & " AND CUOTA = " & intNroCuota
					Else
						strSql = "UPDATE REPACTACION_DET SET IDPAGO = " & intSeq & ", IDPAGOCORR = " & intCorrelativo & ",PAGADA = 'S', FECHA_DEL_PAGO = GETDATE() WHERE ID_CONVENIO = " & id_convenio & " AND CUOTA = " & intNroCuota
					End if
					'Response.write strSql
					'Response.End
					set rsUpdate=Conn.execute(strSql)
					intCorrelativo = Cdbl(intCorrelativo) + 1

				End if
				rsTemp.movenext
			loop
			rsTemp.close
			set rsTemp=nothing
		End If

		strTipo = request("TXDESTINO")
		strRutCli = request("TXRUTCLI")
		strFormaPago = request("TXFPAGO")
		strcuotas = request("TXCUOTA")
		intMontoCli = request("TXMONTOCLI")
		intFechaCli = request("TXFECVENCLI")
		intBancoCli = request("TXBANCOCLIENTE")
		//intPlazaCli = request("TXPLAZACLIENTE")
		intNroCheCli = request("TXNROCHEQUECLI")
		intNroCtaCli = request("TXNROCTACTECLI")
		strDivide = request("TXDIVIDE")

		sTipo = Trim(strTipo)
		sRut = Trim(strRutCli)
		sForma = Trim(strFormaPago)
		sCuota = Trim(strcuotas)
		sMonto = Trim(intMontoCli)
		sFecha = Trim(intFechaCli)
		sBanco = Trim(intBancoCli)
		sPlaza = Trim(intPlazaCli)
		sNroChe = Trim(intNroCheCli)
		sNroCta = Trim(intNroCtaCli)
		sDivide = Trim(strDivide)

		estado="A"


		vTipo = split(sTipo,"*")
		vRut = split(sRut,"*")
		vForma = split(sForma,"*")

		vMonto = split(sMonto,"*")
		vFecha = split(sFecha,"*")
		vBanco = split(sBanco,"*")
		vDivide = split(sDivide,"*")

		vPlaza = split(sPlaza,"*")
		vNroChe = split(sNroChe,"*")
		vNroCta = split(sNroCta,"*")
		x=0
		if vTipo(0) <> "" and vTipo(0) <> "NULL" then
		for each doc in vTipo

			'Response.write "<br>x=" & vMonto(x)
			'Response.write "<br>FEcha=" & IsNull(vFecha)
			'Response.write "<br>vForma=" & vForma(x)
			'Response.write "<br>vFecha=" & vFecha(x)

			If Trim(vTipo(x)) = "0" Then
				strBancoDep = strBcoDepCliente
				strNroDep = strNroDepCliente
			ElseIf Trim(vTipo(x)) = "1" Then
				strBancoDep = strBcoDepEmpresa
				strNroDep = strNroDepEmpresa
			Else
				strBancoDep = ""
				strNroDep = ""
			End if

			'Response.write "<BR>SQL=" & SQL
			'Response.end

			If (Trim(vForma(x))="EF" OR Trim(vForma(x))="OC") Then
				SQL = "INSERT INTO CAJA_WEB_EMP_DOC_PAGO (ID_PAGO, CORRELATIVO, MONTO, COD_BANCO, NRO_DEPOSITO, TIPO_PAGO, FORMA_PAGO)"
				SQL = SQL & " VALUES (" & intSeq & "," & x + 1 & "," & vMonto(x) & ",'" & strBancoDep & "','" & strNroDep & "','" & vTipo(x) & "','" & vForma(x) & "')"
			ElseIf (Trim(vForma(x))="DP") Then
				SQL = "INSERT INTO CAJA_WEB_EMP_DOC_PAGO (ID_PAGO, CORRELATIVO, MONTO, COD_BANCO, NRO_DEPOSITO, TIPO_PAGO, FORMA_PAGO)"
				SQL = SQL & " VALUES (" & intSeq & "," & x + 1 & "," & vMonto(x) & ",'" & vBanco(x) & "','" & vNroChe(x) & "','" & vTipo(x) & "','" & vForma(x) & "')"
			ElseIf (Trim(vForma(x))="CD" or Trim(vForma(x))="CF") Then
				SQL = "INSERT INTO CAJA_WEB_EMP_DOC_PAGO (ID_PAGO, CORRELATIVO, MONTO, VENCIMIENTO, COD_BANCO, NRO_CHEQUE, NRO_CTACTE, CODIGO_PLAZA, tipo_pago, forma_pago,RUT_CHEQUE,DIVIDE)"
				SQL = SQL & " VALUES (" & intSeq & "," & x + 1 & "," & vMonto(x) & ",'" & vFecha(x) & "','" & vBanco(x) & "','" & vNroChe(x) & "','" & vNroCta(x) & "','" & vPlaza11 & "','" & vTipo(x) & "','" & vForma(x) & "','" & vRut(x) & "','" &vDivide(x) & "')"
			Else
				SQL = "INSERT INTO CAJA_WEB_EMP_DOC_PAGO (ID_PAGO, CORRELATIVO, MONTO, COD_BANCO, NRO_CHEQUE, NRO_CTACTE, CODIGO_PLAZA, tipo_pago, forma_pago,RUT_CHEQUE,DIVIDE)"
				SQL = SQL & " VALUES (" & intSeq & "," & x + 1 & "," & vMonto(x) & ",'" & vBanco(x) & "','" & vNroChe(x) & "','" & vNroCta(x) & "','" & vPlaza11 & "','" & vTipo(x) & "','" & vForma(x) & "','" & vRut(x) & "','" &vDivide(x) & "')"
			end if

			set rsInser=Conn.execute(SQL)

			x = x + 1
		next
		end if

		If Trim(intTipoPago)="CO" or Trim(intTipoPago) = "CC" Then
			strTipoCompArch = "comp_pago_convenio.asp"
		ElseIf Trim(intTipoPago)="RP" Then
			strTipoCompArch = "comp_pago_repactacion.asp"
		Else
			strTipoCompArch = "comp_pago.asp"
		End If


		strSql = "SELECT COMP_INGRESO FROM CAJA_WEB_EMP WHERE ID_PAGO = " & intSeq
		'Response.write "strSql=" & strSql
		'Response.End
		set rsCompPago = Conn.execute(strSql)
		If Not rsCompPago.Eof Then
			intCompPago = rsCompPago("COMP_INGRESO")
		Else
			intCompPago = 0
		End If





		strEnlaceImprime = strTipoCompArch & "?strImprime=S&intNroComp=" & intCompPago
		%>
		<SCRIPT>
			window.open("<%=strEnlaceImprime%>","INFORMACION","width=800, height=600, scrollbars=yes, menubar=no, location=no, resizable=yes");
		</SCRIPT>
		<%

	End If

%>
<title>Empresa</title>
<style type="text/css">
<!--
.Estilo13 {color: #FFFFFF}
.Estilo27 {color: #FFFFFF}
.Estilo1 {
	color: #FF0000;
	font-weight: bold;
	font-family: Arial, Helvetica, sans-serif;
-->
</style>

<!--
<script language="JavaScript" src="../comunes/lib/cal2.js"></script>
<script language="JavaScript" src="../comunes/lib/cal_conf2.js"></script>
<script language="JavaScript" src="../comunes/lib/validaciones.js"></script>
<script src="../comunes/general/SelCombox.js"></script>
<script src="../comunes/general/OpenWindow.js"></script>
-->
<script language="JavaScript" src="../lib/cal2.js"></script>
<script language="JavaScript" src="../lib/cal_conf2.js"></script>
<script language="JavaScript" src="../lib/validaciones.js"></script>
<script src="../lib/comunes/general/SelCombox.js"></script>
<script src="../lib/comunes/general/OpenWindow.js"></script>

<script language="JavaScript " type="text/JavaScript">

function Refrescar(rut)
{
	if(rut == '')
	{
		return
	}
			datos.action = "caja_web.asp?rut=" + rut + "&tipo=1";
			datos.submit();

}

function Refrescar1(rut)
{
	if(rut == '')
	{
		return
	}
			datos.action = "caja_web.asp?nomas=1&rut=" + rut + "&tipo=1";
			datos.submit();

}

</script>


<link href="style.css" rel="Stylesheet">

<form name="datos" method="post">
<table width="840" border="1" bordercolor="#999999" cellpadding="2" cellspacing="5">
	<tr>
		<td height="20"  bordercolor="#999999"  bgcolor="#<%=session("COLTABBG")%>" class="Estilo27" align="center"><strong>Módulo de Ingreso de Pagos</strong></td>
	</tr>
  <tr>
    <td valign="top">
	  <%

	If rut <> "" then

		strNombreDeudor = TraeNombreDeudor(Conn,strRutDeudor)



		strSql=""
		strSql="SELECT PIE_PORC_CAPITAL, HON_PORC_CAPITAL, IC_PORC_CAPITAL, TASA_MAX_CONV, DESCRIPCION, TIPO_INTERES, GASTOS_OPERACIONALES, GASTOS_ADMINISTRATIVOS, GASTOS_OPERACIONALES_CD, GASTOS_ADMINISTRATIVOS_CD FROM CLIENTE WHERE CODCLIENTE ='" & strCodCliente & "'"
		set rsTasa=Conn.execute(strSql)
		if not rsTasa.eof then
			intTasaMax = ValNulo(rsTasa("TASA_MAX_CONV"),"N")/100
			intPorcPie = ValNulo(rsTasa("PIE_PORC_CAPITAL"),"N")/100
			intPorcHon = ValNulo(rsTasa("HON_PORC_CAPITAL"),"N")/100
			intPorcIc = ValNulo(rsTasa("IC_PORC_CAPITAL"),"N")/100
			strDescripcion = rsTasa("DESCRIPCION")
			strTipoInteres = rsTasa("TIPO_INTERES")
			intGOpeSD1=ValNulo(rsTasa("GASTOS_OPERACIONALES"),"N")
			intGOpeCD1=ValNulo(rsTasa("GASTOS_OPERACIONALES_CD"),"N")
			intGAdmSD1=ValNulo(rsTasa("GASTOS_ADMINISTRATIVOS"),"N")
			intGAdmCD1=ValNulo(rsTasa("GASTOS_ADMINISTRATIVOS_CD"),"N")


		Else
			intTasaMax = 1
			intPorcPie = 1
			intPorcHon = 1
			intPorcIc = 1
			strDescripcion = ""
			strTipoInteres = "S"
		end if
		strTipoInteres = "S"
		rsTasa.close
		set rsTasa=nothing


	'rESPONSE.WRITE "intTipoPago=" & intTipoPago
		If Trim(intTipoPago) <> "CO" AND Trim(intTipoPago) <> "RP" Then
			strSql = "SELECT TOP 1 INDEM_COMPENSATORIA, HONORARIOS, INTERESES, GASTOS_JUDICIALES, MONTO FROM DEMANDA WHERE CODCLIENTE = '" & strCodCliente & "' AND RUTDEUDOR = '" & strRutDeudor & "'"
			'rESPONSE.WRITE strSql

			set rsDemanda= Conn.execute(strSql)
			if not rsDemanda.eof then
				intIndemCompensatoriaD=rsDemanda("INDEM_COMPENSATORIA")
				intHonorariosD=rsDemanda("HONORARIOS")
				intInteresesD=rsDemanda("INTERESES")
				intMontoDemandaD=rsDemanda("MONTO")

				'If Trim(strTieneConvenio) = "SI" Then
					intGastosJudicialesD=rsDemanda("GASTOS_JUDICIALES")
				'Else
				'	intGastosJudicialesD=0
				'End If
				intOtrosD=0
				intOtrosD = intGOpeCD1
				intGastosAdminD = 0
				intGastosAdminD = intGAdmCD1

				AbrirSCG1()
				strSql = "SELECT NOMBRE_IC, IC_GO_SC, IC_GO_CC FROM GESTIONES_JUDICIAL_GESTION WHERE CAST(CODCATEGORIA AS VARCHAR(2))+ '-' + CAST(CODSUBCATEGORIA AS VARCHAR(2)) + '-' + CAST(CODGESTION AS VARCHAR(2)) IN ( SELECT TOP 1 CAST(CODCATEGORIA AS VARCHAR(2))+ '-' + CAST(CODSUBCATEGORIA AS VARCHAR(2)) + '-' + CAST(CODGESTION AS VARCHAR(2)) "
				strSql = strSql & " FROM GESTIONES_NUEVAS_JUDICIAL WHERE CODCLIENTE = '" & strCodCliente & "' AND RUTDEUDOR = '" & strRutDeudor & "' ORDER BY IDGESTION DESC )"
				''rESPONSE.WRITE "strSql=" & strSql
				set rsUltGJud= Conn.execute(strSql)
				If Not rsUltGJud.Eof Then
					strNombreIC = rsUltGJud("NOMBRE_IC")
					strICGO_SC = rsUltGJud("IC_GO_SC")
					strICGO_CC = rsUltGJud("IC_GO_CC")
					'Response.write "intMontoDemandaD=" & intMontoDemandaD
					'Response.write "strICGO_SC=" & strICGO_SC
					intIndemCompensatoriaD = intMontoDemandaD * (strICGO_SC / 100)
					intIndemCompensatoriaD = Round(intIndemCompensatoriaD,0)
				End If
				CerrarSCG1()

			Else
				intIndemCompensatoriaD=0
				intHonorariosD=0
				intInteresesD=0
				intGastosJudicialesD=0
				intOtrosD=0
				intOtrosD = intGOpeSD1
				intGastosAdminD = 0
				intGastosAdminD = intGAdmSD1
			end if

			If Trim(intGastosAdminD) = "" Then
				intGastosAdminD = 0
			End If
		End If




		intMaximaAnual = intTasaMax * 12

		''rESPONSE.WRITE "intMaximaAnual= " & intMaximaAnual

	Else
		strNombreDeudor=""
	End if

	%>

	<table width="840" border="0" bordercolor="#FFFFFF">
		<tr bordercolor="#999999"  bgcolor="#<%=session("COLTABBG")%>" class="Estilo13">
			<td>MANDANTE</td>
			<td>RUT</td>
			<td>NOMBRE O RAZON SOCIAL:</td>
			<td>USUARIO</td>
			<td>SUCURSAL</td>
			<td>FECHA</td>
			<td>&nbsp;</td>
		</tr>
	      <tr bgcolor="#FFFFFF" class="Estilo8">
	      <td>
	      	<select name="CB_CLIENTE">
				<%
					ssql="SELECT CODCLIENTE,RAZON_SOCIAL FROM CLIENTE WHERE CODCLIENTE = '" & strCodCliente & "' ORDER BY RAZON_SOCIAL"
					set rsTemp= Conn.execute(ssql)
					if not rsTemp.eof then
						do until rsTemp.eof%>
						<option value="<%=rsTemp("CODCLIENTE")%>"<%if Trim(strCodCliente)=rsTemp("CODCLIENTE") then response.Write("Selected") End If%>><%=rsTemp("RAZON_SOCIAL")%></option>
						<%
						rsTemp.movenext
						loop
					end if
					rsTemp.close
					set rsTemp=nothing
				%>
			</select>
			</td>

			<td ALIGN="LEFT"><input name="TX_RUT" type="text" size="10" maxlength="10" onChange="Refrescar(this.value)" value="<%=rut%>"></td>
			<td><%=strNombreDeudor%><INPUT TYPE="hidden" NAME="rut" value="<%=rut%>"> </td>
	        <td ALIGN="RIGHT"><%=session("nombre_user")	%></td>

	        <td><%=nom_sucursal%></td>
	        <td><%=DATE%></td>
	        <td>
				<acronym title="LIMPIAR FORMULARIO">
					<input name="li_" type="button" onClick="window.navigate('caja_web.asp?Limpiar=1&id_convenio=<%=id_convenio%>');" value="Limpiar">
				</acronym>
			</td>
	      </tr>
    </table>
	</td>
	</tr>
</table>



<table width="840" border="1" bordercolor="#999999" cellpadding="2" cellspacing="5">
	<tr>
	<td  bordercolor="#999999"  bgcolor="#<%=session("COLTABBG")%>">
	<font class="Estilo27"><strong>&nbsp;Resumen Pago</strong></font>
	</td>
	</tr>
	<tr>
	<td>
	<table width="840" border="0">
      <tr  bordercolor="#999999"  bgcolor="#<%=session("COLTABBG")%>">
		<%if perfil = "caja_modif" then%>
		<td><span class="Estilo27">SUCURSAL</span></td>
		<%end if%>
        <td><span class="Estilo27">Fecha Pago</span></td>
        <td><span class="Estilo27">N° Comprobante</span></td>
		<td><span class="Estilo27">N° Boleta</span></td>
		<td><span class="Estilo27">Tipo Pago</span></td>
		<td>
			&nbsp;
		</td>
       </tr>
      <tr class="Estilo8">
        <%if perfil = "caja_modif" then%>
		<td><SELECT NAME="cmb_sucursal" id="cmb_sucursal">
				<option value="">SELECCIONAR</option>
				<%
				ssql="SELECT * FROM SUCURSAL WHERE COD_SUC > 0 ORDER BY COD_SUC"
				set rsSuc=Conn.execute(ssql)
				if not rsSuc.eof then
					do until rsSuc.eof
					%>
					<option value="<%=rsSuc("cod_suc")%>"
					<%if Trim(sucursal)=Trim(rsSuc("cod_suc")) then
						response.Write("Selected")
					end if%>
					><%=ucase(rsSuc("cod_suc") & " - " & rsSuc("DES_suc"))%></option>

					<%rsSuc.movenext
					loop
				end if
				rsSuc.close
				set rsSuc=nothing
				%>
				</SELECT></td>
		<%end if%>
		<td><input name="TX_FECHA_PAGO" type="text" READONLY value="<%=dtmFechaCaja%>" size="10" maxlength="10"></td>
	    <td><input name="TX_COMPINGRESO" type="text" READONLY value="<%=intNroComp%>" size="10" maxlength="10"></td>
		<td><input name="TX_BOLETA" type="text" value="" size="10" maxlength="10"></td>
		<td>
			<select name="CB_TIPOPAGO">
				<%
				ssql="SELECT * FROM CAJA_TIPO_PAGO"

				If Trim(intTipoPago)="CO" or Trim(intTipoPago)="CC" Then
					ssql = ssql & " WHERE ID_TIPO_PAGO IN ('CO','CC')"
				ElseIf Trim(intTipoPago)="RP" Then
					ssql = ssql & " WHERE ID_TIPO_PAGO = 'RP'"
				Else
					If Trim(strCodCliente) = "1000" Then
						ssql = ssql & " WHERE ID_TIPO_PAGO <> 'CO' AND ID_TIPO_PAGO <> 'AB'"
					Else
						ssql = ssql & " WHERE ID_TIPO_PAGO <> 'CO'"
					End If

				%>
					<option value="">SELECCIONAR</option>
				<%
				End If
				rESPONSE.WRITE ssql
				set rsCLI=Conn.execute(ssql)
				if not rsCLI.eof then
					do until rsCLI.eof
					%>
					<option value="<%=rsCLI("ID_TIPO_PAGO")%>"
					<%if Trim(intTipoPago)=Trim(rsCLI("ID_TIPO_PAGO")) then Response.Write("SELECTED") end if%> WIDTH="10"
					><%=ucase(rsCLI("ID_TIPO_PAGO") & " - " & rsCLI("DESC_TIPO_PAGO"))%></option>

					<%rsCLI.movenext
					loop
				end if
				rsCLI.close
				set rsCLI=nothing
				%>
			</select>
		</td>
		<td>
		<% If strPosibIc = "SI" Then%>
			<span class="Estilo1">REVISAR CUOTAS IC</span>
		<% End If%>
		</td>
        </tr>
    </table>
	</td>
	</tr>

	<tr>
	<td>

	<table width="840" border="0" ALIGN="CENTER">
	 <tr>
	 	<td  bordercolor="#999999"  bgcolor="#<%=session("COLTABBG")%>">
	 	<font class="Estilo27"><strong>&nbsp;Detalle de Deuda</strong></font>
	 	</td>
	</tr>
	</table>


	<% If Trim(id_convenio) = "" Then %>

	<table width="840" border="0" ALIGN="CENTER">
	  <tr>
	    <td valign="top">
		<%
		If Trim(rut) <> "" then
		abrirscg()
			strSql="SELECT RUTDEUDOR, IsNull(FECHAVENC,'01/01/1900') as FECHAVENC, IsNull(datediff(d,fechavenc,getdate()),0) as ANTIGUEDAD, NRODOC,IsNull(VIGENTE,0) as VIGENTE, IsNull(VALORCUOTA,0) as VALORCUOTA,IsNull(SALDO,0) as SALDO,isnull(GASTOSCOBRANZAS,0) as GASTOSCOBRANZAS,IsNull(USUARIO_ASIG,0) as USUARIO_ASIG,NROCUOTA, VIGENTE, IsNull(MORA,0) as MORA, IsNull(VENCIDA,0) as VENCIDA, IsNull(CASTIGO,0) as CASTIGO, CENTRO_COSTO, SUCURSAL , ESTADO_DEUDA, CODREMESA, CUENTA, NRODOC, TIPODOCUMENTO FROM CUOTA WHERE RUTDEUDOR='"& rut &"' AND CODCLIENTE='"& strCodCliente &"' AND SALDO > 0 AND ESTADO_DEUDA IN ('1','6') ORDER BY CUENTA, FECHAVENC DESC"
			'response.Write(strSql)
			'response.End()
			set rsDET=Conn.execute(strSql)
			if not rsDET.eof then
			%>
			  <table width="840" border="0" bordercolor="#FFFFFF">
		        <tr bordercolor="#999999" bgcolor="#<%=session("COLTABBG")%>" class="Estilo13">
		          <td width="8%">&nbsp</td>
		          <td width="8%">CUENTA</td>
		          <td width="8%">NRO. DOC</td>
		          <td width="8%">F.VENCIM.</td>
		          <td width="8%">ANTIG.</td>
		          <td width="10%">TIPO DOC</td>
		          <td width="8%">ASIG.</td>
		          <!--td width="10%">DEUDA ORIG.</td-->
		          <td width="10%">SALDO</td>
		          <td width="10%">EJECUTIVO</td>
		          <td width="12%">ESTADO</td>

		        </tr>

				<%
				intSaldo = 0
				intValorCuota = 0
				total_ValorCuota = 0
				do until rsDET.eof







				'intSaldo = ValNulo(rsDET("SALDO"),"N")
				'intValorCuota = ValNulo(rsDET("VALORCUOTA"),"N")


				intSaldo = Round(session("valor_moneda") * ValNulo(rsDET("SALDO"),"N"),0)
				intSaldo = Round(session("valor_moneda") * ValNulo(rsDET("VALORCUOTA"),"N"),0)

				strNroDoc = Trim(rsDET("NRODOC"))
				strNroCuota = Trim(rsDET("NROCUOTA"))
				strSucursal = Trim(rsDET("SUCURSAL"))
				strEstadoDeuda = Trim(rsDET("ESTADO_DEUDA"))
				strCodRemesa = Trim(rsDET("CODREMESA"))


				strCuenta = rsDET("CUENTA")
				intLargo = Len(strCuenta)
				If intLargo >= 10 Then strInfractora = "S"


				%>
		        <tr bordercolor="#999999" >
		          <TD><INPUT TYPE=checkbox NAME="CH_<%=Replace(rsDET("NRODOC"),"-","_")%>" onClick="suma_capital(this,TX_SALDO_<%=Replace(rsDET("NRODOC"),"-","_")%>.value);suma_total_general(0);"></TD>
		          <td><div align="right"><%=strCuenta%></div></td>
		          <td><div align="right"><%=rsDET("NRODOC")%></div></td>
		          <td><div align="right"><%=rsDET("FECHAVENC")%></div></td>
		          <td><div align="right"><%=rsDET("ANTIGUEDAD")%></div></td>
		          <td><div align="right"><%=rsDET("TIPODOCUMENTO")%></div></td>
		          <td><div align="center"><%=rsDET("CODREMESA")%></div></td>
		          <!--td align="right" >$ <%=FN((intValorCuota),0)%></td-->
		          <td align="right" ><input name="TX_SALDO_<%=Replace(rsDET("NRODOC"),"-","_")%>" type="text" value="<%=intSaldo%>" size="10" maxlength="10" align="RIGHT"></td>
		          <td align="right" >
		          <%If Not rsDET("USUARIO_ASIG")="0" Then %>
				  	<%=TraeCampoId(Conn, "LOGIN", rsDET("USUARIO_ASIG"), "USUARIO", "ID_USUARIO")%>
				  <%else%>
				  	<%="SIN ASIG."%>
				  <%End If%>
				  </td>
				  <td align="center"><%=TraeCampoId(Conn, "DESCRIPCION", strEstadoDeuda, "ESTADO_DEUDA", "CODIGO")%></td>

				 <%
					total_ValorCuota = total_ValorCuota + intValorCuota
					total_gc = total_gc + clng(rsDET("GASTOSCOBRANZAS"))
					total_docs = total_docs + 1
				 %>
				 </tr>
				 <%rsDET.movenext
				 loop
				 %>

		      </table>
			  <%end if
			  rsDET.close
			  set rsDET=nothing
		  Else
		  %>
			<table width="840" border="0" bordercolor="#FFFFFF">
			<tr bordercolor="#999999" class="Estilo8">
			<td align="center">

			Deudor no posee documentos pendientes
			</td>
			</tr>
			</table>
		  <%end if%>
	    </td>
	  </tr>

	</table>

		<% Else %>

			<table width="840" border="0" ALIGN="CENTER">
			  <tr>
			    <td valign="top">
				<%
				If Trim(rut) <> "" then
				abrirscg()
					If Trim(intTipoPago)="CO" OR Trim(intTipoPago)="CC" Then
						strSql="SELECT ID_CONVENIO, CUOTA, TOTAL_CUOTA, CONVERT(VARCHAR(10),getdate(),103) as FECHAACTUAL ,  CONVERT(VARCHAR(10),FECHA_PAGO,103) as FECHA_PAGO, IsNull(datediff(d,FECHA_PAGO,getdate()),0) as ANTIGUEDAD FROM CONVENIO_DET WHERE ID_CONVENIO = " & id_convenio & " AND PAGADA IS NULL AND ID_CONVENIO IN (SELECT ID_CONVENIO FROM CONVENIO_ENC WHERE COD_CLIENTE = '" & strCodCliente & "')"
					Else
						strSql="SELECT ID_CONVENIO, CUOTA, TOTAL_CUOTA, CONVERT(VARCHAR(10),getdate(),103) as FECHAACTUAL ,  CONVERT(VARCHAR(10),FECHA_PAGO,103) as FECHA_PAGO, IsNull(datediff(d,FECHA_PAGO,getdate()),0) as ANTIGUEDAD FROM REPACTACION_DET WHERE ID_CONVENIO = " & id_convenio & " AND PAGADA IS NULL AND ID_CONVENIO IN (SELECT ID_CONVENIO FROM REPACTACION_ENC WHERE COD_CLIENTE = '" & strCodCliente & "')"
					End If
					'response.Write(strSql)
					'response.End()
					set rsDetConvenio=Conn.execute(strSql)
					if not rsDetConvenio.eof then
					%>
					  <table width="840" border="0" bordercolor="#FFFFFF">
				        <tr bordercolor="#999999" bgcolor="#<%=session("COLTABBG")%>" class="Estilo13">
							<td>&nbsp</td>
							<td><%=strTitCol%></td>
							<td>CUOTA</td>
							<td>ANTIG.</td>
							<td>F.VENCIM.</td>
							<td>VALOR CUOTA</td>
							<td>INTERESES</td>
							<td>GASTOS</td>
							<td>HONORARIOS</td>
							<td>GASTOS ADM</td>
				        </tr>

						<%
						intSaldo = 0
						intValorCuota = 0
						total_ValorCuota = 0
						do until rsDetConvenio.eof
						intSaldo = ValNulo(rsDetConvenio("TOTAL_CUOTA"),"N")


						strFechaVencim = rsDetConvenio("FECHA_PAGO")
						strFechaActual = rsDetConvenio("FECHAACTUAL")

						intDiasMora = rsDetConvenio("ANTIGUEDAD")


						strFechaVencim = Mid(strFechaVencim,7,4) & "/" & Mid(strFechaVencim,1,2)  & "/" & Mid(strFechaVencim,4,2)
						strFechaActual = Mid(strFechaActual,7,4) & "/" & Mid(strFechaActual,1,2)  & "/" & Mid(strFechaActual,4,2)

						intInteresesDoc = 0

						intHonorariosDoc = 0

						intGastosDoc = 0

						intInteresCuota = InteresCuota(intDiasMora,intMaximaAnual,intSaldo)

						If intInteresCuota < 0 Then
							intInteresCuota = 0
						End If


						%>
				        <tr bordercolor="#999999" >
							<TD><INPUT TYPE=checkbox NAME="CH_<%=rsDetConvenio("CUOTA")%>" onClick="suma_capital_2(this,TX_SALDO_<%=rsDetConvenio("CUOTA")%>.value,TX_INTERESES_<%=rsDetConvenio("CUOTA")%>.value,TX_GASTOS_<%=rsDetConvenio("CUOTA")%>.value,TX_HONORARIOS_<%=rsDetConvenio("CUOTA")%>.value, TX_GASTOS_ADMIN_<%=rsDetConvenio("CUOTA")%>.value);suma_total_general(1);";></TD>
							<td><div align="right"><%=rsDetConvenio("ID_CONVENIO")%></div></td>
							<td><div align="right"><%=rsDetConvenio("CUOTA")%></div></td>
							<td><div align="right"><%=intDiasMora%></div></td>
							<td><div align="right"><%=rsDetConvenio("FECHA_PAGO")%></div></td>
							<td align="right" ><input name="TX_SALDO_<%=rsDetConvenio("CUOTA")%>" type="text" value="<%=intSaldo%>" size="8" maxlength="8" align="RIGHT"></td>
							<td align="right" ><input name="TX_INTERESES_<%=rsDetConvenio("CUOTA")%>" type="text" value="<%=intInteresCuota%>" size="8" maxlength="8" align="RIGHT"></td>
							<td align="right" ><input name="TX_GASTOS_<%=rsDetConvenio("CUOTA")%>" type="text" value="<%=intGastosDoc%>" size="8" maxlength="8" align="RIGHT"></td>
							<td align="right" ><input name="TX_HONORARIOS_<%=rsDetConvenio("CUOTA")%>" type="text" value="<%=intHonorariosDoc%>" size="8" maxlength="8" align="RIGHT"></td>
							<td align="right" ><input name="TX_GASTOS_ADMIN_<%=rsDetConvenio("CUOTA")%>" type="text" value="<%=intHonorariosDoc%>" size="8" maxlength="8" align="RIGHT"></td>

				         <%
							total_ValorCuota = total_ValorCuota + intValorCuota
							''total_gc = total_gc + clng(rsDetConvenio("TOTAL_CUOTA"))
							total_gc = total_gc + 0
							total_docs = total_docs + 1
						 %>
						 </tr>
						 <%rsDetConvenio.movenext
						 loop
						 %>

				      </table>
					  <%end if
					  rsDetConvenio.close
					  set rsDetConvenio=nothing
				  Else
				  %>
					<table width="840" border="0" bordercolor="#FFFFFF">
					<tr bordercolor="#999999" class="Estilo8">
					<td align="center">

					Deudor no posee cuotas de convenio pendientes
					</td>
					</tr>
					</table>
				  <%end if%>
			    </td>
			  </tr>

		</table>


		<% End if %>

	</td>
	</tr>
<tr>
	<td>
	<table width="840" border="0">
	<tr  bordercolor="#999999"  bgcolor="#<%=session("COLTABBG")%>">
		<td><span class="Estilo27">Deuda Capital</span></td>
		<td><span class="Estilo27">I.Comp./ G.Op.</span></td>
		<td><span class="Estilo27">Intereses</span></td>
		<td><span class="Estilo27">Gastos Jud.</span></td>
		<td><span class="Estilo27">Honorarios</span></td>
		<td><span class="Estilo27">Gastos Ope.</span></td>
		<td><span class="Estilo27">Gastos Adm.</span></td>
		<td><span class="Estilo27">Descuentos</span></td>
		<td><span class="Estilo27">Total General</span></td>
    </tr>
	<tr>
		<td><input name="TX_DEUDACAPITAL" type="text" value="" size="10" maxlength="10" onchange="solonumero(TX_DEUDACAPITAL);suma_total_general(0);" ></td>
		<td><input name="TX_INDCOM" type="text" value="<%=intIndemCompensatoriaD%>" size="10" maxlength="10" onchange="solonumero(TX_INDCOM);suma_total_general(1);"></td>
		<td><input name="TX_INTERESES" type="text" value="<%=intInteresesD%>" size="10" maxlength="10" onchange="solonumero(TX_INTERESES);suma_total_general(1);"></td>
		<td><input name="TX_GASTOSJUD" type="text" value="<%=intGastosJudicialesD%>" size="10" maxlength="10" onchange="solonumero(TX_GASTOSJUD);suma_total_general(1);"></td>
		<td><input name="TX_HONORARIOS" type="text" value="<%=intHonorariosD%>" size="10" maxlength="10" onchange="solonumero(TX_HONORARIOS);suma_total_general(2);"></td>
		<td><input name="TX_OTROS" type="text" value="<%=intOtrosD%>" size="10" maxlength="10" onchange="solonumero(TX_OTROS);suma_total_general(1);"></td>
		<td><input name="TX_GASTOSADMIN" type="text" value="<%=intGastosAdminD%>" size="10" maxlength="10" onchange="solonumero(TX_GASTOSADMIN);suma_total_general(1);"></td>
		<td><input name="TX_DESCUENTO" type="text" value="" size="10" maxlength="10" onchange="solonumero(TX_DESCUENTO);suma_total_general(1);"></td>
		<td><input name="TX_TOTALGRAL" type="text" value="" size="10" maxlength="10" onchange="solonumero(TX_TOTALGRAL);suma_total_general(0);"></td>
	  </tr>

	</table>
	<table>
	<tr>
	<td>OBSERVACIONES: </td>
	<td>
	<INPUT TYPE="TEXT" NAME="TX_OBSERVACIONES" size="100">
	</td>
	<%If trim(strCierreHab) <> "NO" then %>
	<TD <%=strCierreHab%>>
		<INPUT TYPE="BUTTON" <%=strCierreHab%> NAME="Guardar" value="Guardar" onClick="envia('<%=perfil%>');" class="Estilo8">
	</TD>
	<%End if%>
	</tr>

	<tr>
		<td colspan=3>
		<b>Monto Empresa</b> (18% Capital) + (9%-18% IC-GP) + G.Jud + G.Adm: <input name="TX_MONTO_EMPRESA" type="text" value="" size="10" maxlength="10" onchange="ver_monto_empresa();" >
		<b>Monto Cliente</b> : <input name="TX_MONTO_CLIENTE" type="text" value="" size="10" maxlength="10" onchange="ver_monto_empresa();" >
		</td>
	</tr>
	</table>
</td>
</tr>
<tr>
<td>

<tr  bordercolor="#999999"  bgcolor="#<%=session("COLTABBG")%>">
<td>
	<font class="Estilo27"><strong>&nbsp;Detalle de Documentos</strong></font>

</td>

</tr>
<tr>
<td>
	<table width="840" border="0">
	<tr  bordercolor="#999999"  bgcolor="#<%=session("COLTABBG")%>">
		<td><span class="Estilo27">Dest.Pago</span></td>
		<td><span class="Estilo27">Forma Pago</span></td>

        <td class="Estilo27">Rut Cheque</td>
        <td><span class="Estilo27">Monto</span></td>
        <td><span class="Estilo27">Fecha Venc</span></td>
		<td><span class="Estilo27">Banco</span></td>
		<!--td><span class="Estilo27">Plaza</span></td-->
		<td><span class="Estilo27">N°Cheque o Dep</span></td>
		<td><span class="Estilo27">Cta. Cte.</span></td>
		<td><span class="Estilo27">Div.</span></td>
		<TD></TD>
       </tr>
      <tr>
		<td><select name="CB_DESTINO" class="Estilo8">
		<option value="">SELECCIONE</option>
		<option value="0">CLIENTE</option>
		<option value="1">EMPRESA</option>
		</select></td>
		<td>
		<select name="CB_FPAGO" width="10" maxlength="10" class="Estilo8" onchange="FormaPago();">
		<option value="">SELECCIONAR</option>
		<%
		ssql="SELECT * FROM CAJA_FORMA_PAGO WHERE ID_FORMA_PAGO NOT IN ('AB')"
		set rsCLI=Conn.execute(ssql)
		if not rsCLI.eof then
			do until rsCLI.eof
			%>
			<option value="<%=rsCLI("ID_FORMA_PAGO")%>"
			<%if Trim(cliente)=Trim(rsCLI("ID_FORMA_PAGO")) then
				response.Write("Selected")
			end if%>
			><%=ucase(rsCLI("DESC_FORMA_PAGO"))%></option>

			<%rsCLI.movenext
			loop
		end if
		rsCLI.close
		set rsCLI=nothing
		%>
		</select>
        </td>

        <td><input name="TX_RUTCLI" type="text" value="" size="10" maxlength="10" class="Estilo8" onchange="Valida_Rut(this.value)"></td>
		<td><input name="TX_MONTOCLI" type="text" value="" size="8" maxlength="10" class="Estilo8" onchange="solonumero(TX_MONTOCLI);"></td>
	    <td><input name="inicio" type="text" id="inicio" value="" size="8" maxlength="10" class="Estilo8" onBlur="muestra_dia()"><a href="javascript:showCal('Calendar7');"><img src="../images/calendario.gif" border="0"></a></td>
		<TD><SELECT name="CB_BANCO_CLIENTE" class="Estilo8">
		<option value="">SELECCIONAR</option>
		<%
		ssql="SELECT * FROM BANCOS"
		set rsBANC=Conn.execute(ssql)
		if not rsBANC.eof then
			do until rsBANC.eof
			%>
			<option value="<%=rsBANC("CODIGO")%>"
			<%if Trim(banco)=Trim(rsBANC("CODIGO")) then
				response.Write("Selected")
			end if%>
			><%=ucase(rsBANC("CODIGO") & " - " & Mid(rsBANC("NOMBRE_B"),1,12))%></option>

			<%rsBANC.movenext
			loop
		end if
		rsBANC.close
		set rsBANC=nothing
		%>
		</SELECT></TD>
		<!--td><select name="CB_PLAZA_CLIENTE" class="Estilo8">
		<option value="">SELECCIONAR</option>
		<%
		ssql="SELECT * FROM BANCO_PLAZA"
		set rsPLA=Conn.execute(ssql)
		if not rsPLA.eof then
			do until rsPLA.eof
			%>
			<option value="<%=rsPLA("CODIGO")%>"
			<%if Trim(plaza)=Trim(rsPLA("CODIGO")) then
				response.Write("Selected")
			end if%>
			><%=ucase(rsPLA("CODIGO") & " - " & Mid(rsPLA("NOMBRE"),1,15))%></option>

			<%rsPLA.movenext
			loop
		end if
		rsPLA.close
		set rsPLA=nothing
		%>
		</select>
		</td-->
		<td><input name="TX_NROCHEQUECLI" type="text" value="" size="15" maxlength="20" class="Estilo8"></td>
		<td><input name="TX_NROCTACTECLI" type="text" value="" size="12" maxlength="20" class="Estilo8"></td>

		<TD>
			<SELECT name="CB_DIVIDE" class="Estilo8">
			<option value="NO">NO</option>
			<option value="SI">SI</option>
			</SELECT>
		</TD>



		<td><input type="button" name="ingdoc" value="OK" onClick="metedoccli();" class="Estilo8"></td>
        </tr>
	   <tr>

			<td><select name="DESTINO" size="10" id="DESTINO"  ondblClick=" borra_combos_cli(this.selectedIndex);" onChange="select_combos_cli(this.selectedIndex);" class="Estilo8"></select></td>
			<td><select name="FPAGO" size="10" id="FPAGO"  ondblClick=" borra_combos_cli(this.selectedIndex);" onChange="select_combos_cli(this.selectedIndex);" class="Estilo8"></select></td>
			<td><select name="RUTCLI" size="10" id="RUTCLI"  ondblClick=" borra_combos_cli(this.selectedIndex);" onChange="select_combos_cli(this.selectedIndex);" class="Estilo8"></select></td>
			<td><select name="MONTOCLI" size="10" id="MONTOCLI"  ondblClick=" borra_combos_cli(this.selectedIndex);" onChange="select_combos_cli(this.selectedIndex);" class="Estilo8"></select></td>
			<td><select name="FECHACLI" size="10" id="FECHACLI"  ondblClick=" borra_combos_cli(this.selectedIndex);" onChange="select_combos_cli(this.selectedIndex);" class="Estilo8"></select></td>
			<td><select name="BANCOCLI" size="10" id="BANCOCLI"  ondblClick=" borra_combos_cli(this.selectedIndex);" onChange="select_combos_cli(this.selectedIndex);" class="Estilo8"></select></td>
			<!--td><select name="PLAZACLI" size="10" id="PLAZACLI"  ondblClick=" borra_combos_cli(this.selectedIndex);" onChange="select_combos_cli(this.selectedIndex);" class="Estilo8"></select></td-->
			<td><select name="NROCHECLI" size="10" id="NROCHECLI"  ondblClick=" borra_combos_cli(this.selectedIndex);" onChange="select_combos_cli(this.selectedIndex);" class="Estilo8"></select></td>
			<td><select name="NRCTACTECLI" size="10" id="NRCTACTECLI"  ondblClick=" borra_combos_cli(this.selectedIndex);" onChange="select_combos_cli(this.selectedIndex);" class="Estilo8"></select></td>
			<td><select name="LS_DIVIDE" size="10" ondblClick=" borra_combos_cli(this.selectedIndex);" onChange="select_combos_cli(this.selectedIndex);" class="Estilo8"></select></td>

			<td></td>
		</tr>
		<tr>
			<td>
			<INPUT TYPE="hidden" NAME="TXPERIODO">
			<INPUT TYPE="hidden" NAME="TXCAPITAL">
			<INPUT TYPE="hidden" NAME="TXREAJUSTE">
			<INPUT TYPE="hidden" NAME="TXINTERES">
			<INPUT TYPE="hidden" NAME="TXGRAVAMENES">
			<INPUT TYPE="hidden" NAME="TXMULTAS">
			<INPUT TYPE="hidden" NAME="TXCARGOS">

			<INPUT TYPE="hidden" NAME="TXFPAGO">
			<INPUT TYPE="hidden" NAME="TXDESTINO">
			<INPUT TYPE="hidden" NAME="TXCUOTA">
			<INPUT TYPE="hidden" NAME="TXRUTCLI">
			<INPUT TYPE="hidden" NAME="TXMONTOCLI">
			<INPUT TYPE="hidden" NAME="TXFECVENCLI">
			<INPUT TYPE="hidden" NAME="TXBANCOCLIENTE">
			<INPUT TYPE="hidden" NAME="TXDIVIDE">



			<!--INPUT TYPE="hidden" NAME="TXPLAZACLIENTE"-->
			<INPUT TYPE="hidden" NAME="TXNROCHEQUECLI">
			<INPUT TYPE="hidden" NAME="TXNROCTACTECLI">
			<%hoy=date%>
			<INPUT TYPE="hidden" NAME="TXFECHAACTUAL" value="<%=hoy%>">
			<INPUT TYPE="hidden" NAME="dtmFechaCaja" value="<%=dtmFechaCaja%>">

			<INPUT TYPE="hidden" NAME="strGraba" value="">
			</td>
		</tr>
	</table>
</td>
</tr>
</table>

</form>
<script language="JavaScript" type="text/JavaScript">

function FormaPago(){
	if (datos.CB_FPAGO.value=='EF')
	{
		datos.inicio.value='';
		datos.inicio.disabled = true;
		datos.TX_RUTCLI.value = '';
		datos.TX_RUTCLI.disabled = true;
		datos.CB_BANCO_CLIENTE.disabled = true;
		datos.CB_DIVIDE.disabled = true;
		//datos.CB_PLAZA_CLIENTE.disabled = true;
		datos.TX_NROCHEQUECLI.value='';
		datos.TX_NROCHEQUECLI.disabled = true;
		datos.TX_NROCTACTECLI.value='';
		datos.TX_NROCTACTECLI.disabled = true;
	}else if((datos.CB_FPAGO.value=='AB')||(datos.CB_FPAGO.value=='CU')){
		datos.inicio.value=''
		datos.inicio.disabled = false;
		datos.TX_RUTCLI.value = '';
		datos.TX_RUTCLI.disabled = true;
		datos.CB_BANCO_CLIENTE.disabled = true;
		datos.CB_DIVIDE.disabled = true;
		//datos.CB_PLAZA_CLIENTE.disabled = true;
			datos.TX_NROCHEQUECLI.disabled = false;
		datos.TX_NROCTACTECLI.value='';
		datos.TX_NROCTACTECLI.disabled = true;
	}else if (datos.CB_FPAGO.value=='DP'){
		datos.TX_RUTCLI.disabled = true;
		datos.inicio.disabled = true;
		datos.CB_BANCO_CLIENTE.disabled = false;
		datos.CB_DIVIDE.disabled = true;
		//datos.CB_PLAZA_CLIENTE.disabled = false;
		datos.TX_NROCHEQUECLI.disabled = false;
		datos.TX_NROCTACTECLI.disabled = false;
		datos.inicio.value=''
	}
	else {
		datos.TX_RUTCLI.disabled = false;
		datos.inicio.disabled = false;
		datos.CB_BANCO_CLIENTE.disabled = false;
		datos.CB_DIVIDE.disabled = false;
		//datos.CB_PLAZA_CLIENTE.disabled = false;
		datos.TX_NROCHEQUECLI.disabled = false;
		datos.TX_NROCTACTECLI.disabled = false;
		if (datos.CB_FPAGO.value=='CD'){
			datos.inicio.value=datos.TXFECHAACTUAL.value
		}else{
			datos.inicio.value=''
		}
	}
}

function solonumero(valor){
     //Compruebo si es un valor numérico

 if (valor.value.length >0){
      if (isNaN(valor.value)) {
            //entonces (no es numero) devuelvo el valor cadena vacia
            valor.value="0";
			//alert(valor.value)
			//valor.focus();
			return ""
      }else{
            //En caso contrario (Si era un número) devuelvo el valor
			valor.value
			return valor.value
      }
	  }
}

function borra_combos_cli(indice){
	borra_opcion(datos.DESTINO,indice);
	borra_opcion(datos.FPAGO,indice);
	borra_opcion(datos.RUTCLI,indice);
	borra_opcion(datos.MONTOCLI,indice);
	borra_opcion(datos.FECHACLI,indice);
	borra_opcion(datos.BANCOCLI,indice);
	//borra_opcion(datos.PLAZACLI,indice);
	borra_opcion(datos.NROCHECLI,indice);
	borra_opcion(datos.NRCTACTECLI,indice);

}

function borra_opcion(combo,indice){
	if (combo.options.length>0){
	//	combo.options[indice]=null;
		for (var e=indice; e< combo.options.length-1; e++) {
			//alert(e);
			combo.options[e].text=combo.options[e+1].text;
			combo.options[e].value=combo.options[e+1].value;
		}
		combo.options[combo.options.length-1]=null;
	}
}

function select_combos_cli(indice){
	datos.DESTINO.selectedIndex=indice;
	datos.FPAGO.selectedIndex=indice;
	datos.RUTCLI.selectedIndex=indice;
	datos.MONTOCLI.selectedIndex=indice;
	datos.FECHACLI.selectedIndex=indice;
	datos.BANCOCLI.selectedIndex=indice;
	//datos.PLAZACLI.selectedIndex=indice;
	datos.NROCHECLI.selectedIndex=indice;
	datos.NRCTACTECLI.selectedIndex=indice;
}

//-------------------------------

function metedoccli(){
	if (datos.CB_DESTINO.value==''){
		alert("Debe seleccionar el destino del pago");
		datos.CB_DESTINO.focus();
	}else if (datos.CB_FPAGO.value==''){
		alert("Debe seleccionar la forma de pago");
		datos.CB_FPAGO.focus();
	}else if(((datos.CB_FPAGO.value=='CD')||(datos.CB_FPAGO.value=='CF'))&&((datos.TX_RUTCLI.value==''))){
		alert("Debe ingresar el Rut");
		datos.TX_RUTCLI.focus();
	}else if (datos.TX_MONTOCLI.value==''){
		alert("Debe ingresar el Monto");
		datos.TX_MONTOCLI.focus();
	}else if(((datos.CB_FPAGO.value=='CD')||(datos.CB_FPAGO.value=='CF'))&&((datos.inicio.value==''))){
		alert("Debe ingresar la fecha de vencimiento");
		datos.inicio.focus();
	}else if(((datos.CB_FPAGO.value=='DP')||(datos.CB_FPAGO.value=='CF')||(datos.CB_FPAGO.value=='DP'))&&((datos.CB_BANCO_CLIENTE.value==''))){
		alert("Debe ingresar el Banco al que pretenece el cheque o deposito");
		datos.CB_BANCO_CLIENTE.focus();
	//}else if(((datos.CB_FPAGO.value=='CD')||(datos.CB_FPAGO.value=='CF'))&&((datos.CB_PLAZA_CLIENTE.value==''))){
	//	alert("Debe ingresar la plaza")
	//	datos.CB_PLAZA_CLIENTE.focus();
	}else if(((datos.CB_FPAGO.value=='CD')||(datos.CB_FPAGO.value=='CF'))&&((datos.TX_NROCHEQUECLI.value==''))){
		alert("Debe ingresar el número del cheque")
		datos.TX_NROCHEQUECLI.focus();
	}else if(((datos.CB_FPAGO.value=='CD')||(datos.CB_FPAGO.value=='CF'))&&((datos.TX_NROCTACTECLI.value==''))){
		alert("Debe ingresar el número de la cuenta corriente")
		datos.TX_NROCTACTECLI.focus();
	}else{

		datos.TX_RUTCLI.disabled = false;
		datos.TX_MONTOCLI.disabled = false;
		datos.inicio.disabled = false;
		datos.CB_BANCO_CLIENTE.disabled = false;
		datos.CB_DIVIDE.disabled = false;
		//datos.CB_PLAZA_CLIENTE.disabled = false;
		datos.TX_NROCHEQUECLI.disabled = false;
		datos.TX_NROCTACTECLI.disabled = false;
		apilar_combo_combo(datos.CB_DESTINO, datos.DESTINO);
		apilar_combo_combo(datos.CB_FPAGO, datos.FPAGO);
		apilar_textbox_combo(datos.TX_RUTCLI, datos.RUTCLI);
		apilar_textbox_combo(datos.TX_MONTOCLI, datos.MONTOCLI);
		apilar_textbox_combo(datos.inicio, datos.FECHACLI);
		apilar_combo_combo(datos.CB_BANCO_CLIENTE, datos.BANCOCLI);
		//apilar_combo_combo(datos.CB_PLAZA_CLIENTE, datos.PLAZACLI);
		apilar_textbox_combo(datos.TX_NROCHEQUECLI, datos.NROCHECLI);
		apilar_textbox_combo(datos.TX_NROCTACTECLI, datos.NRCTACTECLI);
		apilar_combo_combo(datos.CB_DIVIDE, datos.LS_DIVIDE);



		if((datos.CB_FPAGO.value != 'CD') && (datos.CB_FPAGO.value  != 'CF')) {
			datos.CB_FPAGO.value="";
			datos.TX_RUTCLI.value="";
			datos.inicio.value="";
			datos.CB_BANCO_CLIENTE.value="";
			//datos.CB_DIVIDE.value="";
			datos.TX_NROCHEQUECLI.value="";
			datos.TX_NROCTACTECLI.value="";
		}

		datos.TX_MONTOCLI.value="";
		datos.CB_DESTINO.value="";
		//datos.CB_PLAZA_CLIENTE.value="";

		datos.CB_DESTINO.focus();
	}
}

function suma_capital(objeto , intValorSaldoCapital){
	//alert(objeto.checked);
	if (objeto.checked == true) {
		datos.TX_DEUDACAPITAL.value = eval(datos.TX_DEUDACAPITAL.value) + eval(intValorSaldoCapital);
	}
	else
	{
		datos.TX_DEUDACAPITAL.value = eval(datos.TX_DEUDACAPITAL.value) - eval(intValorSaldoCapital);
	}
}

function suma_capital_2(objeto , intValorSaldoCapital, intValorIntereses, intValorGastos, intValorHonorarios, intValorGastosAdmin){

	//alert(objeto.checked);
	//alert(intValorGastosAdmin);

	if (objeto.checked == true) {
		datos.TX_DEUDACAPITAL.value = eval(datos.TX_DEUDACAPITAL.value) + eval(intValorSaldoCapital);
		datos.TX_INTERESES.value = eval(datos.TX_INTERESES.value) + eval(intValorIntereses);
		datos.TX_GASTOSJUD.value = eval(datos.TX_GASTOSJUD.value) + eval(intValorGastos);
		datos.TX_GASTOSADMIN.value = eval(datos.TX_GASTOSADMIN.value) + eval(intValorGastosAdmin);
		//datos.TX_HONORARIOS.value = eval(datos.TX_HONORARIOS.value) + eval(intValorHonorarios);
	}
	else
	{
		datos.TX_DEUDACAPITAL.value = eval(datos.TX_DEUDACAPITAL.value) - eval(intValorSaldoCapital);
		datos.TX_INTERESES.value = eval(datos.TX_INTERESES.value) - eval(intValorIntereses);
		datos.TX_GASTOSJUD.value = eval(datos.TX_GASTOSJUD.value) - eval(intValorGastos);
		datos.TX_GASTOSADMIN.value = eval(datos.TX_GASTOSADMIN.value) - eval(intValorGastosAdmin);
		//datos.TX_HONORARIOS.value = eval(datos.TX_HONORARIOS.value) - eval(intValorHonorarios);
	}
}





function suma_total_general (origen){
	if (origen == 1) {

		datos.TX_HONORARIOS.value = Math.round(datos.TX_HONORARIOS.value)
		datos.TX_TOTALGRAL.value = eval(datos.TX_DEUDACAPITAL.value) + eval(datos.TX_HONORARIOS.value) + eval(datos.TX_INDCOM.value) + eval(datos.TX_OTROS.value) + eval(datos.TX_INTERESES.value) + eval(datos.TX_GASTOSJUD.value) + eval(datos.TX_GASTOSADMIN.value) - eval(datos.TX_DESCUENTO.value);
		//datos.TX_HONORARIOS.value = (eval(datos.TX_DEUDACAPITAL.value) + eval(datos.TX_INDCOM.value)) * 0.15;

	}
	else if (origen == 2) {
		//var aaaa = datos.TX_HONORARIOS.value;
		datos.TX_TOTALGRAL.value = eval(datos.TX_DEUDACAPITAL.value) + eval(datos.TX_HONORARIOS.value) + eval(datos.TX_INDCOM.value) + eval(datos.TX_OTROS.value) + eval(datos.TX_INTERESES.value) + eval(datos.TX_GASTOSJUD.value) + eval(datos.TX_GASTOSADMIN.value) - eval(datos.TX_DESCUENTO.value);
		//datos.TX_HONORARIOS.value = aaaa
		datos.TX_TOTALGRAL.value = eval(datos.TX_DEUDACAPITAL.value) + eval(datos.TX_HONORARIOS.value) + eval(datos.TX_INDCOM.value) + eval(datos.TX_OTROS.value) + eval(datos.TX_INTERESES.value) + eval(datos.TX_GASTOSJUD.value) + eval(datos.TX_GASTOSADMIN.value) - eval(datos.TX_DESCUENTO.value);
	}
	else
	{
		//datos.TX_HONORARIOS.value = Math.round(datos.TX_DEUDACAPITAL.value * <%=Replace(intPorcHon,",",".")%>)
		datos.TX_TOTALGRAL.value = eval(datos.TX_DEUDACAPITAL.value) + eval(datos.TX_HONORARIOS.value) + eval(datos.TX_INDCOM.value) + eval(datos.TX_OTROS.value) + eval(datos.TX_INTERESES.value) + eval(datos.TX_GASTOSJUD.value) + eval(datos.TX_GASTOSADMIN.value) - eval(datos.TX_DESCUENTO.value);
	}

	ver_monto_empresa();
}


function ver_monto_empresa()
{
	datos.TX_MONTO_EMPRESA.value = 0.18 * eval(datos.TX_DEUDACAPITAL.value) + 0.09 * eval(datos.TX_INDCOM.value) + eval(datos.TX_GASTOSJUD.value) + eval(datos.TX_GASTOSADMIN.value) ;
	datos.TX_MONTO_EMPRESA.value = Math.round(datos.TX_MONTO_EMPRESA.value);
	datos.TX_MONTO_CLIENTE.value = eval(datos.TX_TOTALGRAL.value) - eval(datos.TX_MONTO_EMPRESA.value);
}
function apilar_textbox_combo(origen, destino){
//addNew(document.myForm.proceso.options[document.myForm.proceso.selectedIndex].value)
	// Add a new option.
	var ok=false;
	i=destino.length;
	//valor = datos.txt_clavedoc.value.length;
	//alert(valor);
	valor=origen.value.length ;
	valor2=origen.value;
	if (valor>=0){
		texto=origen.value;
		if (texto==''){
		texto='';
		valor2 = '';
		}
	}else{
	texto='';
	valor2='';
	}
	var el = new Option(texto,valor2);
			destino.options[i] = el;
		//alert("ingrese un valor para agregar.");
}
//------------------------------------------------------------------
function apilar_combo_combo(origen, destino){
	// Add a new option.
	var ok=false;
	i=destino.length;
	valor=origen.selectedIndex ;
	valor2=origen.options[valor].value;
	if (valor>=0){
		texto=origen.options[valor].text;
		if (texto=='SELECCIONAR' || texto=='0'){
			texto='';
			valor2='';
		}
	}else{
	texto='';
	valor2='';
	}
	var el = new Option(texto,valor2);
	destino.options[i] = el;
		//alert("Seleccione un valor para agregar.");
}
//////--------------------------------------------------------------------
function disa(){
		datos.Guardar.disabled = true;
}
function habilita(){
		datos.Guardar.disabled = false;
}
function envia(perfilusuario){
	disa()
	if(datos.TX_RUT.value==''){
		alert("Debe ingresar el rut")
		datos.TX_RUT.focus();
		habilita();
	}else if (perfilusuario=='caja_modif' && datos.cmb_sucursal.value==''){
		alert("Debe seleccionar la sucursal que corresponde");
		habilita();
	}else if(datos.CB_CLIENTE.value == '0'){
		alert("Debe seleccionar el Cliente");
		habilita();
	}else if (datos.TX_BOLETA.value == ''){
		alert("Debe ingresar Número de Boleta");
		habilita();
	}else if (datos.CB_TIPOPAGO.value == ''){
		alert("Debe seleccionar el Tipo de Pago");
		habilita();
	}else{
		i=datos.DESTINO.length;
		montcli=0
		montemp=0
		monttotal=0
		cli=0
		emp=0
		for (var e=0; e<i;e++){
			if(datos.DESTINO.options[e].value=='0'){
					montcli= eval(montcli) + eval(datos.MONTOCLI.options[e].value);
			}else{
					montemp = eval(montemp) + eval(datos.MONTOCLI.options[e].value);
			}
			monttotal = eval(monttotal) + eval(datos.MONTOCLI.options[e].value);

		}
		if (eval(datos.TX_TOTALGRAL.value) != eval(monttotal)) {
			alert("Los montos ingresados en el detalle de documentos no son correctos : Total General :" + eval(datos.TX_TOTALGRAL.value) + " , Total Detalle = " + eval(monttotal));
			habilita();
		}else{
			JuntaDetalleCliente();
			datos.strGraba.value='SI';
			disa();
			datos.submit();

		}

	}

}

function chkFecha(f) {
  str = f.value
  if (str.length<10){
  	alert("Error - Ingresó una fecha no válida");
  	f.value=''
	f.focus();
  //	f.select();
  }else{
	if ( !formatoFecha(str) ) {
		alert("Debe indicar la Fecha en formato DD/MM/AAAA. Ejemplo: 'Para 20 de Diciembre de 2009 se debe ingresar 20/12/2009'");
    //f.select()
		f.value=''
		f.focus()
		return false
	}
	if ( !validarFecha(str) ) {
    // Los mensajes de error están dentro de validarFecha.
    //f.select()
   f.value=''
	f.focus()
    return false
  }
  }

  // validacion de la fecha


  return true
}

//-----------------------------------------------------------
  function validarFecha(str_fecha){

  var sl1=str_fecha.indexOf("/")
  var sl2=str_fecha.lastIndexOf("/")
  var inday = parseFloat(str_fecha.substring(0,sl1))
  var inmonth = parseFloat(str_fecha.substring(sl1+1,sl2))
  var inyear = parseFloat(str_fecha.substring(sl2+1,str_fecha.length))

  //alert("day:" + inday + ", mes:" + inmonth + ", agno: " + inyear)

  if (inmonth < 1 || inmonth > 12) {
    alert("Mes inválido en la fecha");
    return false;
  }
  if (inday < 1 || inday > diasEnMes(inmonth, inyear)) {
    alert("Día inválido en la fecha");
    return false;
  }

  return true
}


//------------------------------------------------------------------

function formatoFecha(str) {
  var sl1, sl2, ui, ddstr, mmstr, aaaastr;

  // El formato debe ser d/m/aaaa, d/mm/aaaa, dd/m/aaaa, dd/mm/aaaa,
  // Las posiciones son a partir de 0
  if (str.length < 8 &&  str.length > 10)    // el tamagno es fijo de 8, 9 o 10
    return false


  sl1=str.indexOf("/")
  if (sl1 < 1 && sl1 > 2 )    // el primer slash debe estar en la 1 o 2
    return false

  sl2=str.lastIndexOf("/")
  if (sl2 < 3 &&  sl2 > 5)    // el último slash debe estar en la 3, 4 o 5
    return false

  ddstr = str.substring(0,sl1)
  mmstr = str.substring(sl1+1,sl2)
  aaaastr = str.substring(sl2+1,str.length)

  if ( !sonDigitos(ddstr) || !sonDigitos(mmstr) || !sonDigitos(aaaastr) )
    return false

  return true
}
function sonDigitos(str) {
  var l, car

  l = str.length
  if ( l<1 )
    return false

  for ( i=0; i<l; i++) {
    car = str.substring(i,i+1)
    if ( "0" <= car &&  car <= "9" )
      continue
    else
      return false
  }
  return true
}

function diasEnMes (month, year)
{
  if (month == 1 || month == 3 || month == 5 || month == 7 || month == 8 || month == 10 || month == 12)
    return 31;
  else if (month == 2)
    // February has 29 days in any year evenly divisible by four,
      // EXCEPT for centurial years which are not also divisible by 400.
      return (  ((year % 4 == 0) && ( (!(year % 100 == 0)) || (year % 400 == 0) ) ) ? 29 : 28 );
  else if (month == 4 || month == 6 || month == 9 || month == 11)
    return 30;
  // En caso contrario:
  alert("diasEnMes: Mes inválido");
  return -1;
}
function Valida_Rut(Vrut)
{
	var dig
	Vrut = Vrut.split("-");

	if (!isNaN(Vrut[0]))
	{
		largo_rut = Vrut[0].length;
		if ((largo_rut >= 7 ) && (largo_rut <= 8))
		{
			if (largo_rut > 7)
			{
				multiplicador = 3;
			}
			else
			{
				multiplicador = 2;
			}
			suma = 0;
			contador = 0;
				do
				{
					digito = Vrut[0].charAt(contador);
					digito = Number(digito);
						if (multiplicador == 1)
						{
							multiplicador = 7;
						}

					suma = suma + (digito * multiplicador);
					multiplicador --;
					contador ++;
				}
				while (contador < largo_rut);
			resto = suma % 11
			dig_verificador = 11 - resto;

				if (dig_verificador == 10)
				{
					dig = "k";
				}
				else if (dig_verificador == 11)
				{
					dig = 0
				}
				else
				{
					dig = dig_verificador;
				}

				if (dig != Vrut[1])
				{
					alert ("El Rut es invalido !");
					datos.TX_RUTCLI.value="";
					datos.TX_RUTCLI.focus();
					//return 0;
				}
		}
		else
		{
			datos.TX_RUTCLI.value="";
			datos.TX_RUTCLI.focus();
			alert("El Rut es invalido ! ");

			//return 0;
		}
	}
	else
	{
		alert("El Rut es invalido ! ");
		datos.TX_RUTCLI.value="";
		datos.TX_RUTCLI.focus();
		//return 0;
	}
		//return 1;
}


function muestra_dia(){
//alert(getCurrentDate())
//alert("hola")
	var diferencia=DiferenciaFechas(datos.inicio.value)
	//alert(diferencia)
	if(datos.inicio.value!=''){
		if ((diferencia>=-30)) {
			//alert('Ok')
		}else{
			alert('la fecha de compromiso debe ser mayor a la \nfecha actual')
			datos.inicio.value=''
			datos.inicio.focus()
		}
	}
}


function DiferenciaFechas (CadenaFecha1) {
   var fecha_hoy = getCurrentDate() //hoy


   //Obtiene dia, mes y año
   var fecha1 = new fecha( CadenaFecha1 )
   var fecha2 = new fecha(fecha_hoy)

   //Obtiene objetos Date
   var miFecha1 = new Date( fecha1.anio, fecha1.mes, fecha1.dia )
   var miFecha2 = new Date( fecha2.anio, fecha2.mes, fecha2.dia )

   //Resta fechas y redondea
   var diferencia = miFecha1.getTime() - miFecha2.getTime()
   var dias = Math.floor(diferencia / (1000 * 60 * 60 * 24))
   var segundos = Math.floor(diferencia / 1000)
   //alert ('La diferencia es de ' + dias + ' dias,\no ' + segundos + ' segundos.')

   return dias //false
}
//---------------------------------------------------------------------
function fecha( cadena ) {

   //Separador para la introduccion de las fechas
   var separador = "/"

   //Separa por dia, mes y año
   if ( cadena.indexOf( separador ) != -1 ) {
        var posi1 = 0
        var posi2 = cadena.indexOf( separador, posi1 + 1 )
        var posi3 = cadena.indexOf( separador, posi2 + 1 )
        this.dia = cadena.substring( posi1, posi2 )
        this.mes = cadena.substring( posi2 + 1, posi3 )
        this.anio = cadena.substring( posi3 + 1, cadena.length )
   } else {
        this.dia = 0
        this.mes = 0
        this.anio = 0
   }
}
///----------------------------------------


function JuntaDetalleCliente(){
	datos.TXDESTINO.value = ""
	datos.TXFPAGO.value = ""
	datos.TXRUTCLI.value=""
	datos.TXMONTOCLI.value=""
	datos.TXFECVENCLI.value	=""
	datos.TXBANCOCLIENTE.value=""
	datos.TXDIVIDE.value=""

	//datos.TXPLAZACLIENTE.value=""
	datos.TXNROCHEQUECLI.value=""
	datos.TXNROCTACTECLI.value=""
	for (var e=0; e<datos.DESTINO.options.length;e++){
		if (e!=0) {
		//poner la coma
			datos.TXDESTINO.value=datos.TXDESTINO.value+"*";
			datos.TXFPAGO.value=datos.TXFPAGO.value+"*";
			datos.TXRUTCLI.value=datos.TXRUTCLI.value+"*"	;
			datos.TXMONTOCLI.value=datos.TXMONTOCLI.value+"*";
			datos.TXFECVENCLI.value	=datos.TXFECVENCLI.value+"*";
			datos.TXBANCOCLIENTE.value=datos.TXBANCOCLIENTE.value+"*";
			datos.TXDIVIDE.value=datos.TXDIVIDE.value+"*";
			//datos.TXPLAZACLIENTE.value=datos.TXPLAZACLIENTE.value+"*";
			datos.TXNROCHEQUECLI.value=datos.TXNROCHEQUECLI.value+"*";
			datos.TXNROCTACTECLI.value=datos.TXNROCTACTECLI.value+"*";
		}
		//concatenar
		datos.TXDESTINO.value=datos.TXDESTINO.value+datos.DESTINO.options[e].value;
		datos.TXFPAGO.value=datos.TXFPAGO.value+datos.FPAGO.options[e].value;
		datos.TXRUTCLI.value=datos.TXRUTCLI.value+datos.RUTCLI.options[e].value;
		datos.TXMONTOCLI.value=datos.TXMONTOCLI.value+datos.MONTOCLI.options[e].value;
		datos.TXFECVENCLI.value=datos.TXFECVENCLI.value+datos.FECHACLI.options[e].value;
		datos.TXBANCOCLIENTE.value=datos.TXBANCOCLIENTE.value+datos.BANCOCLI.options[e].value;
		datos.TXDIVIDE.value=datos.TXDIVIDE.value+datos.LS_DIVIDE.options[e].value;


		//datos.TXPLAZACLIENTE.value=datos.TXPLAZACLIENTE.value+datos.PLAZACLI.options[e].value;
		datos.TXNROCHEQUECLI.value=datos.TXNROCHEQUECLI.value+datos.NROCHECLI.options[e].value;
		datos.TXNROCTACTECLI.value=datos.TXNROCTACTECLI.value+datos.NRCTACTECLI.options[e].value;
	}
}

if (datos.TX_DEUDACAPITAL.value == '') datos.TX_DEUDACAPITAL.value = 0;
if (datos.TX_INDCOM.value == '') datos.TX_INDCOM.value = 0;
if (datos.TX_HONORARIOS.value == '') datos.TX_HONORARIOS.value = 0;
if (datos.TX_TOTALGRAL.value == '') datos.TX_TOTALGRAL.value = 0;
if (datos.TX_OTROS.value == '') datos.TX_OTROS.value = 0;
if (datos.TX_INTERESES.value == '') datos.TX_INTERESES.value = 0;
if (datos.TX_GASTOSJUD.value == '') datos.TX_GASTOSJUD.value = 0;
if (datos.TX_GASTOSADMIN.value == '') datos.TX_GASTOSADMIN.value = 0;
if (datos.TX_DESCUENTO.value == '') datos.TX_DESCUENTO.value = 0;
habilita();

</script>


















