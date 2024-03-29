<% @LCID = 1034 %>
<!--#include file="../sesion.asp"-->
<!--#include file="../arch_utils.asp"-->
<!--#include file="../../lib/comunes/rutinas/funciones.inc" -->
<!--#include file="../../lib/comunes/rutinas/TraeCampo.inc" -->
<!--#include file="../asp/comunes/general/rutinasSCG.inc" -->

<script language="JavaScript" src="../../lib/cal2.js"></script>
<script language="JavaScript" src="../../lib/cal_conf2.js"></script>
<script language="JavaScript" src="../../lib/validaciones.js"></script>
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

	usuario=Session("intCodUsuario")

	AbrirSCG()

	intNroBoleta = request("TX_BOLETA")
	intCompIngreso = request("TX_COMPINGRESO")
	intCantDoc = request("TX_CANTDOC")
	intMontoCliente = request("TX_MONTOCLIENTE")
	intFormaPagoCliente = request("CB_FPAGO_CLIENTE")
	intMontoEMP = request("TX_MONTOEMP")
	intFormaPagoEMP = request("CB_FPAGO_CLIENTE")
	intTipoPago = request("CB_TIPOPAGO")


	strBancoDepEmp = request("CB_BEMP")
	strBancoDepCliente = request("CB_BCLIENTE")

	strNroDepositoCliente = request("TX_NRODEPCLIENTE")
	strNroDepositoEMP = request("TX_NRODEPEMP")


	strClaveDeudor = request("TX_CLAVEDOC")
	strNroLiquidacion = request("TX_NROLIQUIDACION")
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
	intDescuento = ValNulo(request("TX_DESCUENTO"),"N")

	intNroBoleta = ValNulo(intNroBoleta,"N")
	intCompIngreso = ValNulo(intCompIngreso,"C")
	intCantDoc = ValNulo(intCantDoc,"N")
	intMontoCliente = Trim(intMontoCliente)
	intFormaPagoCliente = Trim(intFormaPagoCliente)
	intMontoEMP = Trim(intMontoEMP)
	intFormaPagoEMP = Trim(intFormaPagoEMP)
	intTipoPago = Trim(intTipoPago)
	strNroDepositoCliente = Trim(strNroDepositoCliente)
	strNroDepositoEMP = Trim(strNroDepositoEMP)
	strClaveDeudor = Trim(strClaveDeudor)
	strNroLiquidacion = Trim(strNroLiquidacion)
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


	strSql="SELECT FECHA_CIERRE FROM CAJA_WEB_EMP_CIERRE "
	strSql= strSql & "WHERE CONVERT(VARCHAR(10),FECHA_CIERRE,103) = CONVERT(VARCHAR(10),GETDATE(),103)"
	'Response.write strSql

	set rsCierre=Conn.execute(strSql)
	If Not rsCierre.Eof Then
		%>
		<SCRIPT>
			alert('Caja Cerrada, No puede ingresar pagos para el d�a de hoy')
		</SCRIPT>
		<%
		strCierre = "DISABLED READONLY"
	End If


	If Trim(intTipoPago) =  "CO" Then
		strSql="SELECT ID_CONVENIO FROM CONVENIO_ENC "
		'strSql= strSql & "WHERE RUTDEUDOR = '" & strRutDeudor & "' AND COD_CLIENTE = '" & strCodCliente & "'"
		strSql= strSql & "WHERE ID_CONVENIO = " & id_convenio
		strTitCol = "CONVENIO"
		set rsConvenio=Conn.execute(strSql)
		If Not rsConvenio.Eof Then
			id_convenio = rsConvenio("ID_CONVENIO")
		End If
	ElseIf Trim(intTipoPago) =  "RP" Then
		strSql="SELECT ID_CONVENIO FROM REPACTACION_ENC "
		'strSql= strSql & "WHERE RUTDEUDOR = '" & strRutDeudor & "' AND COD_CLIENTE = '" & strCodCliente & "'"
		strSql= strSql & "WHERE ID_CONVENIO = " & id_convenio
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


	'response.write(rut)
	'Response.write "<br>strGraba=" & strGraba
	'Response.write "<br>intSeq=" & intSeq

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
		intTotalEmpresa = ValNulo(intMontoEMP,"N") + ValNulo(intHonorarios,"N") + intOtros

		strSql = "INSERT INTO CAJA_WEB_EMP (ID_PAGO, FECHA_PAGO, COD_CLIENTE, RUTDEUDOR, COMP_INGRESO, NRO_BOLETA, MONTO_CAPITAL, TIPO_PAGO, INDEM_COMP, MONTO_EMP, GASTOSJUDICIALES, GASTOSOTROS, INTERES_PLAZO, TOTAL_CLIENTE, TOTAL_EMP, USRINGRESO, FECHAINGRESO, DESC_CLIENTE, ID_CONVENIO, OBSERVACIONES) "
		strSql = strSql & " VALUES (" & intSeq & ", getdate(),'" & strCodCliente & "','" & strRutDeudor & "'," & intCompIngreso & "," & intNroBoleta & "," & intTotalCapital & ",'" & intTipoPago & "'," & intIndemComp & "," & intHonorarios & "," & intGastosJud & "," & intOtros & "," & intIntereses & "," & intTotalCliente & "," & intTotalEmpresa & "," & session("session_idusuario") & ",getdate()," & intDescuento & "," & ValNulo(id_convenio,"N") & ",'" & strObservaciones & "')"
		'Response.write strSql
		'Response.End
		set rsInsertaEnc=Conn.execute(strSql)

		If Trim(intTipoPago) <> "CO" AND Trim(intTipoPago) <> "RP" Then

			strSql = "SELECT NRODOC, CUENTA, FECHAVENC FROM CUOTA WHERE RUTDEUDOR='" & rut & "' AND CODCLIENTE='" & strCodCliente & "' AND SALDO > 0"
			set rsTemp= Conn.execute(strSql)

			intCorrelativo = 1
			Do until rsTemp.eof
				strObjeto = "CH_" & rsTemp("NRODOC")
				strObjeto1 = "TX_SALDO_" & rsTemp("NRODOC")
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
			%>


			<%
			rsTemp.movenext
			intCorrelativo = intCorrelativo + 1
			loop
			rsTemp.close
			set rsTemp=nothing

		Else
			If Trim(intTipoPago)="CO" Then
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

					If Trim(intTipoPago)="CO" Then
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
		intPlazaCli = request("TXPLAZACLIENTE")
		intNroCheCli = request("TXNROCHEQUECLI")
		intNroCtaCli = request("TXNROCTACTECLI")

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
		estado="A"


		vTipo = split(sTipo,"*")
		vRut = split(sRut,"*")
		vForma = split(sForma,"*")

		vMonto = split(sMonto,"*")
		vFecha = split(sFecha,"*")
		vBanco = split(sBanco,"*")
		vPlaza = split(sPlaza,"*")
		vNroChe = split(sNroChe,"*")
		vNroCta = split(sNroCta,"*")
		x=0
		if vTipo(0) <> "" and vTipo(0) <> "NULL" then
		for each doc in vTipo

			'Response.write "<br>x=" & vMonto(x)
			'Response.write "<br>FEcha=" & IsNull(vFecha)
			'Response.write "<br>FEchaeee1=" & Trim(UBOUND(vFecha))
			'Response.write "<br>FEchaeee2=" & IsNull(UBOUND(vFecha))
			'Response.write "<br>FEchaeee3=" & vForma(x)
			'Response.End


			If Trim(vTipo(x)) = "0" Then
				strBancoDep = strBancoDepCliente
				strNroDep = strNroDepositoCliente
			ElseIf Trim(vTipo(x)) = "1" Then
				strBancoDep = strBancoDepEmp
				strNroDep = strNroDepositoEMP
			Else
				strBancoDep = ""
				strNroDep = ""
			End if

			If (Trim(vForma(x))="EF" OR Trim(vForma(x))="DP" OR Trim(vForma(x))="TR") Then
				SQL = "INSERT INTO CAJA_WEB_EMP_DOC_PAGO (ID_PAGO, CORRELATIVO, MONTO, COD_BANCO, NRO_DEPOSITO, TIPO_PAGO, FORMA_PAGO)"
				SQL = SQL & " VALUES (" & intSeq & "," & x + 1 & "," & vMonto(x) & ",'" & strBancoDep & "','" & strNroDep & "','" & vTipo(x) & "','" & vForma(x) & "')"
			Elseif vFecha(x) = "NULL" then
				SQL = "INSERT INTO CAJA_WEB_EMP_DOC_PAGO (ID_PAGO, CORRELATIVO, MONTO, COD_BANCO, NRO_CHEQUE, NRO_CTACTE, CODIGO_PLAZA, tipo_pago, forma_pago,RUT_CHEQUE)"
				SQL = SQL & " VALUES (" & intSeq & "," & x + 1 & "," & vMonto(x) & ",'" & vBanco(x) & "','" & vNroChe(x) & "','" & vNroCta(x) & "','" & vPlaza(x) & "','" & vTipo(x) & "','" & vForma(x) & "','" & vRut(x) & "')"
			Else
				SQL = "INSERT INTO CAJA_WEB_EMP_DOC_PAGO (ID_PAGO, CORRELATIVO, MONTO, VENCIMIENTO, COD_BANCO, NRO_CHEQUE, NRO_CTACTE, CODIGO_PLAZA, tipo_pago, forma_pago,RUT_CHEQUE)"
				SQL = SQL & " VALUES (" & intSeq & "," & x + 1 & "," & vMonto(x) & ",'" & vFecha(x) & "','" & vBanco(x) & "','" & vNroChe(x) & "','" & vNroCta(x) & "','" & vPlaza(x) & "','" & vTipo(x) & "','" & vForma(x) & "','" & vRut(X) & "')"
			end if
			'Response.write "<BR>SQL=" & SQL
			'Response.end
			set rsInser=Conn.execute(SQL)


			'response.write "<BR>"
			'response.write "<BR>"
			x = x + 1
		next
		end if


	End If

	'RESPONSE.WRITE "intSeq = " & intSeq


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

<script language="JavaScript" src="../../comunes/lib/cal2.js"></script>
<script language="JavaScript" src="../../comunes/lib/cal_conf2.js"></script>
<script language="JavaScript" src="../../comunes/lib/validaciones.js"></script>
<script src="../../comunes/general/SelCombox.js"></script>
<script src="../../comunes/general/OpenWindow.js"></script>


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
		<td height="20"  bordercolor="#999999"  bgcolor="#<%=session("COLTABBG")%>" class="Estilo27" align="center"><strong>M�dulo de Ingreso de Pagos Empresa</strong></td>
	</tr>
	<tr>
		<td height="20" bordercolor="#999999"  bgcolor="#<%=session("COLTABBG")%>" class="Estilo27"><strong>Antecedentes de Ubicabilidad</strong></td>
	</tr>
  <tr>
    <td valign="top">
	  <%

	If rut <> "" then

		strNombreDeudor = TraeNombreDeudor(Conn,strRutDeudor)
		strFonoArea = TraeUltimoFonoDeudor(Conn,strRutDeudor,"CODAREA")
		strFonoFono = TraeUltimoFonoDeudor(Conn,strRutDeudor,"TELEFONO")
		strDirCalle= TraeUltimaDirDeudorSCG(Conn,strRutDeudor,"CALLE")
		strDirNum = TraeUltimaDirDeudorSCG(Conn,strRutDeudor,"NUMERO")
		strDirComuna = TraeUltimaDirDeudorSCG(Conn,strRutDeudor,"COMUNA")
		strDirResto = TraeUltimaDirDeudorSCG(Conn,strRutDeudor,"RESTO")
		strEmail = TraeUltimoEmailDeudorSCG(Conn,strRutDeudor,"EMAIL")

		strTelefonoDeudor = TraeUltimoFonoDeudorSCG(Conn,strRutDeudor,"CODAREA") & "-" & TraeUltimoFonoDeudorSCG(Conn,strRutDeudor,"TELEFONO")
		If Trim(strTelefonoDeudor) = "-" Then strTelefonoDeudor = "S/F"



		If Trim(intTipoPago) <> "CO" AND Trim(intTipoPago) <> "RP" Then
			strSql = "SELECT TOP 1 INDEM_COMPENSATORIA, HONORARIOS, INTERESES, GASTOS_JUDICIALES FROM DEMANDA WHERE CODCLIENTE = '" & strCodCliente & "' AND RUTDEUDOR = '" & strRutDeudor & "'"
			''rESPONSE.WRITE strSql

			set rsDemanda= Conn.execute(strSql)
			if not rsDemanda.eof then
				intIndemCompensatoriaD=rsDemanda("INDEM_COMPENSATORIA")
				intHonorariosD=rsDemanda("HONORARIOS")
				intInteresesD=rsDemanda("INTERESES")

				If Trim(strTieneConvenio) = "SI" Then
					intGastosJudicialesD=rsDemanda("GASTOS_JUDICIALES")
				Else
					intGastosJudicialesD=0
				End If

				intOtrosD=0
				'rESPONSE.WRITE "<BR>hola" & intIndemCompensatoriaD

			Else
				intIndemCompensatoriaD=0
				intHonorariosD=0
				intInteresesD=0
				intGastosJudicialesD=0
				intOtrosD=0
			end if

			If Trim(strCodCliente)= "1000" Then
				If intIndemCompensatoriaD  > 35000 Then
					'intIndemCompensatoriaD = intIndemCompensatoriaD - 35000
					'intOtrosD = 35000
				End If
			End If
		End If


		strSql=""
		strSql="SELECT PIE_PORC_CAPITAL, HON_PORC_CAPITAL, IC_PORC_CAPITAL, TASA_MAX_CONV, DESCRIPCION, TIPO_INTERES FROM CLIENTE WHERE CODCLIENTE ='" & strCodCliente & "'"
		set rsTasa=Conn.execute(strSql)
		if not rsTasa.eof then
			intTasaMax = ValNulo(rsTasa("TASA_MAX_CONV"),"N")/100
			intPorcPie = ValNulo(rsTasa("PIE_PORC_CAPITAL"),"N")/100
			intPorcHon = ValNulo(rsTasa("HON_PORC_CAPITAL"),"N")/100
			intPorcIc = ValNulo(rsTasa("IC_PORC_CAPITAL"),"N")/100
			strDescripcion = rsTasa("DESCRIPCION")
			strTipoInteres = rsTasa("TIPO_INTERES")
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

		intMaximaAnual = intTasaMax * 12

		''rESPONSE.WRITE "intMaximaAnual= " & intMaximaAnual




	Else
		strNombreDeudor=""
		strFonoArea = ""
		strFonoFono = ""
		strDirCalle = ""
		strDirNum = ""
		strDirComuna = ""
		strDirResto = ""
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
					<input name="li_" type="button" onClick="window.navigate('caja_web.asp?Limpiar=1');" value="Limpiar">
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
        <td><span class="Estilo27">Nro. Liq.</span></td>
        <td><span class="Estilo27">N� Comprobante</span></td>
		<td><span class="Estilo27">N� Boleta</span></td>
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
				ssql="SELECT * FROM sucursal where cod_suc > 0 order by cod_suc"
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
		<td><input name="TX_NROLIQUIDACION" type="text" value="" size="10" maxlength="10"></td>
	    <td><input name="TX_COMPINGRESO" type="text" READONLY value="<%=intNroComp%>" size="10" maxlength="10"></td>
		<td><input name="TX_BOLETA" type="text" value="" size="10" maxlength="10"></td>
		<td>
			<select name="CB_TIPOPAGO" onChange="Refrescar2()">
				<%
				ssql="SELECT * FROM CAJA_TIPO_PAGO"


				If Trim(intTipoPago)="CO" Then
					ssql = ssql & " WHERE ID_TIPO_PAGO = 'CO'"
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
			strSql="SELECT RUTDEUDOR, IsNull(FECHAVENC,'01/01/1900') as FECHAVENC, IsNull(datediff(d,fechavenc,getdate()),0) as ANTIGUEDAD, NRODOC,IsNull(VIGENTE,0) as VIGENTE, IsNull(VALORCUOTA,0) as VALORCUOTA,IsNull(SALDO,0) as SALDO,isnull(GASTOSCOBRANZAS,0) as GASTOSCOBRANZAS,IsNull(USUARIO_ASIG,0) as USUARIO_ASIG,NROCUOTA, VIGENTE, IsNull(MORA,0) as MORA, IsNull(VENCIDA,0) as VENCIDA, IsNull(CASTIGO,0) as CASTIGO, CENTRO_COSTO, SUCURSAL , ESTADO_DEUDA, CODREMESA, CUENTA, NRODOC, TIPODOCUMENTO FROM CUOTA WHERE RUTDEUDOR='"& rut &"' AND CODCLIENTE='"& strCodCliente &"' AND SALDO > 0 AND ESTADO_DEUDA = 1 ORDER BY CUENTA, FECHAVENC DESC"
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
				intSaldo = ValNulo(rsDET("SALDO"),"N")
				intValorCuota = ValNulo(rsDET("VALORCUOTA"),"N")
				strNroDoc = Trim(rsDET("NRODOC"))
				strNroCuota = Trim(rsDET("NROCUOTA"))
				strSucursal = Trim(rsDET("SUCURSAL"))
				strEstadoDeuda = Trim(rsDET("ESTADO_DEUDA"))
				strCodRemesa = Trim(rsDET("CODREMESA"))



				%>
		        <tr bordercolor="#999999" >
		          <TD><INPUT TYPE=checkbox NAME="CH_<%=rsDET("NRODOC")%>" onClick="suma_capital(this,TX_SALDO_<%=rsDET("NRODOC")%>.value);suma_total_general(0);";></TD>
		          <td><div align="right"><%=rsDET("CUENTA")%></div></td>
		          <td><div align="right"><%=rsDET("NRODOC")%></div></td>
		          <td><div align="right"><%=rsDET("FECHAVENC")%></div></td>
		          <td><div align="right"><%=rsDET("ANTIGUEDAD")%></div></td>
		          <td><div align="right"><%=rsDET("TIPODOCUMENTO")%></div></td>
		          <td><div align="center"><%=rsDET("CODREMESA")%></div></td>
		          <!--td align="right" >$ <%=FN((intValorCuota),0)%></td-->
		          <td align="right" ><input name="TX_SALDO_<%=rsDET("NRODOC")%>" type="text" value="<%=intSaldo%>" size="10" maxlength="10" align="RIGHT"></td>
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
					If Trim(intTipoPago)="CO" Then
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
							<TD><INPUT TYPE=checkbox NAME="CH_<%=rsDetConvenio("CUOTA")%>" onClick="suma_capital_2(this,TX_SALDO_<%=rsDetConvenio("CUOTA")%>.value,TX_INTERESES_<%=rsDetConvenio("CUOTA")%>.value,TX_GASTOS_<%=rsDetConvenio("CUOTA")%>.value,TX_HONORARIOS_<%=rsDetConvenio("CUOTA")%>.value);suma_total_general(1);";></TD>
							<td><div align="right"><%=rsDetConvenio("ID_CONVENIO")%></div></td>
							<td><div align="right"><%=rsDetConvenio("CUOTA")%></div></td>
							<td><div align="right"><%=intDiasMora%></div></td>
							<td><div align="right"><%=rsDetConvenio("FECHA_PAGO")%></div></td>
							<td align="right" ><input READONLY name="TX_SALDO_<%=rsDetConvenio("CUOTA")%>" type="text" value="<%=intSaldo%>" size="8" maxlength="8" align="RIGHT"></td>
							<td align="right" ><input READONLY name="TX_INTERESES_<%=rsDetConvenio("CUOTA")%>" type="text" value="<%=intInteresCuota%>" size="8" maxlength="8" align="RIGHT"></td>
							<td align="right" ><input READONLY name="TX_GASTOS_<%=rsDetConvenio("CUOTA")%>" type="text" value="<%=intGastosDoc%>" size="8" maxlength="8" align="RIGHT"></td>
							<td align="right" ><input READONLY name="TX_HONORARIOS_<%=rsDetConvenio("CUOTA")%>" type="text" value="<%=intHonorariosDoc%>" size="8" maxlength="8" align="RIGHT"></td>

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
		<td><span class="Estilo27">Indem. Compensat.</span></td>
		<td><span class="Estilo27">Intereses</span></td>
		<td><span class="Estilo27">Gastos</span></td>
		<td><span class="Estilo27">Otros Emp.</span></td>
		<td><span class="Estilo27">Honorarios</span></td>
		<td><span class="Estilo27">Descuentos</span></td>
		<td><span class="Estilo27">Total General</span></td>
    </tr>
	<tr>
		<td><input name="TX_DEUDACAPITAL" type="text" value="" size="10" maxlength="10" onchange="solonumero(TX_DEUDACAPITAL);suma_total_general(0);" ></td>
		<td><input name="TX_INDCOM" type="text" value="<%=intIndemCompensatoriaD%>" size="10" maxlength="10" onchange="solonumero(TX_INDCOM);suma_total_general(1);"></td>
		<td><input name="TX_INTERESES" type="text" value="<%=intInteresesD%>" size="10" maxlength="10" onchange="solonumero(TX_INTERESES);suma_total_general(1);"></td>
		<td><input name="TX_GASTOSJUD" type="text" value="<%=intGastosJudicialesD%>" size="10" maxlength="10" onchange="solonumero(TX_GASTOSJUD);suma_total_general(1);"></td>
		<td><input name="TX_OTROS" type="text" value="<%=intOtrosD%>" size="10" maxlength="10" onchange="solonumero(TX_OTROS);suma_total_general(1);"></td>
		<td><input name="TX_HONORARIOS" type="text" value="<%=intHonorariosD%>" size="10" maxlength="10" onchange="solonumero(TX_HONORARIOS);suma_total_general(2);"></td>
		<td><input name="TX_DESCUENTO" type="text" value="" size="10" maxlength="10" onchange="solonumero(TX_DESCUENTO);suma_total_general(1);"></td>
		<td><input name="TX_TOTALGRAL" type="text" value="" size="10" maxlength="10" onchange="solonumero(TX_TOTALGRAL);suma_total_general(0);"></td>
	  </tr>

	</table>
	<table><tr><td>OBSERVACIONES: </td><td><INPUT TYPE="text" NAME="TX_OBSERVACIONES" size="110"></td></tr></table>
</td>
</tr>



<tr>
<td  bordercolor="#999999"  bgcolor="#<%=session("COLTABBG")%>">
		<table>
			<tr>

				<td bordercolor="#999999"  bgcolor="#<%=session("COLTABBG")%>"><span class="Estilo27">Deposito Cedente</span></td>
				<td>
					<input name="TX_NRODEPCLIENTE" type="text" value="<%=strNroDepositoCliente%>" size="10" maxlength="10">
				</td>
				<td><select name="CB_BCLIENTE" class="Estilo8">
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
							><%=ucase(rsBANC("CODIGO") & " - " & Mid(rsBANC("NOMBRE_B"),1,15))%></option>

							<%rsBANC.movenext
						loop
					end if
					rsBANC.close
					set rsBANC=nothing
					%>
					</select>
				</td>
				<td bordercolor="#999999"  bgcolor="#<%=session("COLTABBG")%>"><span class="Estilo27">Deposito Empresa</span></td>
				<td>
					<input name="TX_NRODEPEMP" type="text" value="<%=strNroDepositoEmpresa%>" size="10" maxlength="10">
				</td>
				<td><select name="CB_BEMP" class="Estilo8">
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
							><%=ucase(rsBANC("CODIGO") & " - " & Mid(rsBANC("NOMBRE_B"),1,15))%></option>

							<%rsBANC.movenext
						loop
					end if
					rsBANC.close
					set rsBANC=nothing
					%>
					</select>
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
		<td><span class="Estilo27">Plaza</span></td>
		<td><span class="Estilo27">N� Cheque</span></td>
		<td><span class="Estilo27">Cta. Cte.</span></td>
		<TD></TD>
       </tr>
      <tr>
		<td><select name="CB_DESTINO" class="Estilo8">
		<option value="">SELECCIONAR</option>
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

        <td><input name="TX_RUTCLI" type="text" value="" size="10" maxlength="10" class="Estilo8" onchange=""></td>
		<td><input name="TX_MONTOCLI" type="text" value="" size="8" maxlength="10" class="Estilo8" onchange="solonumero(TX_MONTOCLI);"></td>
	    <td><input name="inicio" type="text" id="inicio" value="" size="8" maxlength="10" class="Estilo8" onBlur="muestra_dia()"><a href="javascript:showCal('Calendar7');"><img src="../../images/calendario.gif" border="0"></a></td>
		<td><select name="CB_BANCO_CLIENTE" class="Estilo8">
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
		</select></td>
		<td><select name="CB_PLAZA_CLIENTE" class="Estilo8">
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
		</select></td>
		<td><input name="TX_NROCHEQUECLI" type="text" value="" size="8" maxlength="20" class="Estilo8"></td>
		<td><input name="TX_NROCTACTECLI" type="text" value="" size="8" maxlength="20" class="Estilo8"></td>
		<td><input type="button" name="ingdoc" value="Ingresar" onClick="metedoccli();" class="Estilo8"></td>
        </tr>
	   <tr >

			<td><select name="DESTINO" size="10" id="DESTINO"  ondblClick=" borra_combos_cli(this.selectedIndex);" onChange="select_combos_cli(this.selectedIndex);" class="Estilo8"></select></td>
			<td><select name="FPAGO" size="10" id="FPAGO"  ondblClick=" borra_combos_cli(this.selectedIndex);" onChange="select_combos_cli(this.selectedIndex);" class="Estilo8"></select></td>
			<td><select name="RUTCLI" size="10" id="RUTCLI"  ondblClick=" borra_combos_cli(this.selectedIndex);" onChange="select_combos_cli(this.selectedIndex);" class="Estilo8"></select></td>
			<td><select name="MONTOCLI" size="10" id="MONTOCLI"  ondblClick=" borra_combos_cli(this.selectedIndex);" onChange="select_combos_cli(this.selectedIndex);" class="Estilo8"></select></td>
			<td><select name="FECHACLI" size="10" id="FECHACLI"  ondblClick=" borra_combos_cli(this.selectedIndex);" onChange="select_combos_cli(this.selectedIndex);" class="Estilo8"></select></td>
			<td><select name="BANCOCLI" size="10" id="BANCOCLI"  ondblClick=" borra_combos_cli(this.selectedIndex);" onChange="select_combos_cli(this.selectedIndex);" class="Estilo8"></select></td>
			<td><select name="PLAZACLI" size="10" id="PLAZACLI"  ondblClick=" borra_combos_cli(this.selectedIndex);" onChange="select_combos_cli(this.selectedIndex);" class="Estilo8"></select></td>
			<td><select name="NROCHECLI" size="10" id="NROCHECLI"  ondblClick=" borra_combos_cli(this.selectedIndex);" onChange="select_combos_cli(this.selectedIndex);" class="Estilo8"></select></td>
			<td><select name="NRCTACTECLI" size="10" id="NRCTACTECLI"  ondblClick=" borra_combos_cli(this.selectedIndex);" onChange="select_combos_cli(this.selectedIndex);" class="Estilo8"></select></td>
			<td><input type="button" <%=strCierre%>name="Submit" value="Guardar" onClick="envia('<%=perfil%>');" class="Estilo8"></td>
		</tr>
		<tr>
			<td>
			<INPUT TYPE="hidden" NAME="TXCLAVEDOC" id ="TXCLAVEDOC">
			<INPUT TYPE="hidden" NAME="TXPERIODO" id="TXPERIODO">
			<INPUT TYPE="hidden" NAME="TXCAPITAL" id="TXCAPITAL">
			<INPUT TYPE="hidden" NAME="TXREAJUSTE" id="TXREAJUSTE">
			<INPUT TYPE="hidden" NAME="TXINTERES" id="TXINTERES">
			<INPUT TYPE="hidden" NAME="TXGRAVAMENES" id="TXGRAVAMENES">
			<INPUT TYPE="hidden" NAME="TXMULTAS" id="TXMULTAS">
			<INPUT TYPE="hidden" NAME="TXCARGOS" id="TXCARGOS">
			<INPUT TYPE="hidden" NAME="TXCOSTAS" id="TXCOSTAS">

			<INPUT TYPE="hidden" NAME="TXFPAGO" id="TXFPAGO">
			<INPUT TYPE="hidden" NAME="TXDESTINO" id="TXDESTINO">
			<INPUT TYPE="hidden" NAME="TXCUOTA" id="TXCUOTA">
			<INPUT TYPE="hidden" NAME="TXRUTCLI" id="TXRUTCLI">
			<INPUT TYPE="hidden" NAME="TXMONTOCLI" id="TXMONTOCLI">
			<INPUT TYPE="hidden" NAME="TXFECVENCLI" id="TXFECVENCLI">
			<INPUT TYPE="hidden" NAME="TXBANCOCLIENTE" id="TXBANCOCLIENTE">
			<INPUT TYPE="hidden" NAME="TXPLAZACLIENTE" id="TXPLAZACLIENTE">
			<INPUT TYPE="hidden" NAME="TXNROCHEQUECLI" id="TXNROCHEQUECLI">
			<INPUT TYPE="hidden" NAME="TXNROCTACTECLI" id="TXNROCTACTECLI">
			<%hoy=date%>
			<INPUT TYPE="hidden" NAME="TXFECHAACTUAL" id="TXFECHAACTUAL" value="<%=hoy%>">
			<INPUT TYPE="hidden" NAME="TXRUTEMP" id="TXRUTEMP">
			<INPUT TYPE="hidden" NAME="TXMONTOEMP" id="TXMONTOEMP">
			<INPUT TYPE="hidden" NAME="TXFECVENEMP" id="TXFECVENEMP">
			<INPUT TYPE="hidden" NAME="TXBANCOEMP" id="TXBANCOEMP">
			<INPUT TYPE="hidden" NAME="TXPLAZAEMP" id="TXPLAZAEMP">
			<INPUT TYPE="hidden" NAME="TXNROCHEQUEEMP" id="TXNROCHEQUEEMP">
			<INPUT TYPE="hidden" NAME="TXNROCTACTEEMP" id="TXNROCTACTEEMP">

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
	if ((datos.CB_FPAGO.value=='EF')||(datos.CB_FPAGO.value=='DP'))
	{
		datos.inicio.value=''
		datos.TX_RUTCLI.disabled = true;
		datos.inicio.disabled = true;
		datos.CB_BANCO_CLIENTE.disabled = true;
		datos.CB_PLAZA_CLIENTE.disabled = true;
		datos.TX_NROCHEQUECLI.disabled = true;
		datos.TX_NROCTACTECLI.disabled = true;
	}else if((datos.CB_FPAGO.value=='AB')||(datos.CB_FPAGO.value=='CU')){
		datos.inicio.value=''
		datos.TX_RUTCLI.disabled = true;
		datos.inicio.disabled = false;
		datos.CB_BANCO_CLIENTE.disabled = true;
		datos.CB_PLAZA_CLIENTE.disabled = true;
		datos.TX_NROCHEQUECLI.disabled = false;
		datos.TX_NROCTACTECLI.disabled = true;
	}
	else{
		datos.TX_RUTCLI.disabled = false;
		datos.inicio.disabled = false;
		datos.CB_BANCO_CLIENTE.disabled = false;
		datos.CB_PLAZA_CLIENTE.disabled = false;
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
     //Compruebo si es un valor num�rico

 if (valor.value.length >0){
      if (isNaN(valor.value)) {
            //entonces (no es numero) devuelvo el valor cadena vacia
            valor.value="0";
			//alert(valor.value)
			//valor.focus();
			return ""
      }else{
            //En caso contrario (Si era un n�mero) devuelvo el valor
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
	borra_opcion(datos.PLAZACLI,indice);
	borra_opcion(datos.NROCHECLI,indice);
	borra_opcion(datos.NRCTACTECLI,indice);

}

function borra_combos(indice){
	borra_opcion(datos.CLAVEDOC,indice);
	borra_opcion(datos.PERIODO,indice);
	borra_opcion(datos.CUOTA,indice);
	resta_capital(datos.CAPITAL.value);
	borra_opcion(datos.CAPITAL,indice);

	resta_capital(datos.REAJUSTE.value);
	borra_opcion(datos.REAJUSTE,indice);

	resta_capital(datos.INTERES.value);
	borra_opcion(datos.INTERES,indice);

	resta_capital(datos.GRAVAMENES.value);
	borra_opcion(datos.GRAVAMENES,indice);

	resta_capital(datos.MULTAS.value);
	borra_opcion(datos.MULTAS,indice);

	resta_capital(datos.CARGOS.value);
	borra_opcion(datos.CARGOS,indice);

	resta_capital(datos.COSTAS.value);
	borra_opcion(datos.COSTAS,indice);

	//resta_capital(datos.OTROS.value);
	//borra_opcion(datos.OTROS,indice);

}


function resta_capital(valor){
	datos.TX_MONTOCLIENTE.disabled = false;
	datos.TX_TOTAL.disabled = false;
	if (valor==''){
		valor=0;
	}
	datos.TX_MONTOCLIENTE.value = eval(datos.TX_MONTOCLIENTE.value) - eval(valor);
	datos.TX_TOTALCLIENTE.value = (eval(datos.TX_MONTOCLIENTE.value) + eval(datos.TX_IPCLIENTE.value)) - eval(datos.TX_DESCLIENTE.value)
	if (datos.TX_DESCUENTO.value == ""){
		datos.TX_DESCUENTO.value = 0;
	}
	if (datos.TX_MONTOEMP.value == ""){
		datos.TX_MONTOEMP.value = 0;
	}
	datos.TX_TOTALEMP.value = ((eval(datos.TX_MONTOEMP.value) + eval(datos.TX_CEMP.value)) - eval(datos.TX_DESCUENTO.value))
	datos.TX_TOTAL.value = (eval(datos.TX_TOTALCLIENTE.value) + eval(datos.TX_TOTALEMP.value));
	datos.TX_MONTOCLIENTE.disabled = true;
	datos.TX_TOTAL.disabled = true;
	datos.TX_CLAVEDOC.focus();
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
	datos.PLAZACLI.selectedIndex=indice;
	datos.NROCHECLI.selectedIndex=indice;
	datos.NRCTACTECLI.selectedIndex=indice;
}

function select_combos(indice){
	datos.CLAVEDOC.selectedIndex=indice;
	datos.PERIODO.selectedIndex=indice;
	datos.CUOTA.selectedIndex=indice;
	datos.CAPITAL.selectedIndex=indice;
	datos.REAJUSTE.selectedIndex=indice;
	datos.INTERES.selectedIndex=indice;
	datos.GRAVAMENES.selectedIndex=indice;
	datos.MULTAS.selectedIndex=indice;
	datos.CARGOS.selectedIndex=indice;
	datos.COSTAS.selectedIndex=indice;
	//datos.OTROS.selectedIndex=indice;


}
//-------------------------------
function asigna_minimo(campo){
	if (campo.value!=0)	{
		if(campo.value.length==1){
			minimo1=8;
		}else if(campo.value==41 || campo.value==32){
			minimo1=7;
		}else {
			minimo1=6;
		}
	}else{minimo1=0}
	return(minimo1)
}



function valida_largo(campo, minimo){
//alert(datos.fono_aportado_area.value)
	//if (datos.fono_aportado_area.value!="0"){
		if(campo.value.length != minimo) {
			alert("Fono debe tener " + minimo + " digitos");
			campo.select();
			campo.focus();
			return(false);
		}
	//}
	return(true);
}

function metedoccli(){
	if (datos.CB_DESTINO.value==''){
		alert("Debe seleccionar el destino del pago");
		datos.CB_DESTINO.focus();
	}else if (datos.CB_FPAGO.value==''){
		alert("Debe seleccionar la forma de pago");
		datos.CB_FPAGO.focus();
	}else if(((datos.CB_FPAGO.value=='CD')||(datos.CB_FPAGO.value=='CF'))&&((datos.TX_RUTCLI.value==''))){
		alert("Debe ingresar el Rut")
		datos.TX_RUTCLI.focus();
	}else if(datos.CB_FPAGO.value=='DP' && datos.CB_DESTINO.value=='0' && datos.TX_NRODEPCLIENTE.value==''){
		alert("Debe ingresar el n�mero del deposito del Cliente")
		datos.TX_NRODEPCLIENTE.focus();
	}else if(datos.CB_FPAGO.value=='DP' && datos.CB_DESTINO.value=='0' && datos.TX_NRODEPCLIENTE.value!='' && datos.CB_BCLIENTE.value==''){
		alert("Debe seleccionar el banco al que pertenece el deposito del Cliente")
		datos.CB_BCLIENTE.focus();
	}else if(datos.CB_FPAGO.value=='DP' && datos.CB_DESTINO.value=='1' && datos.TX_NRODEPEMP.value!='' && datos.CB_BEMP.value==''){
		alert("Debe seleccionar el banco al que pertenece el deposito de Empresa")
		datos.CB_BEMP.focus();
	}else if (datos.TX_MONTOCLI.value==''){
		alert("Debe ingresar el Monto")
		datos.TX_MONTOCLI.focus();
	}else if(((datos.CB_FPAGO.value=='CD')||(datos.CB_FPAGO.value=='CF'))&&((datos.inicio.value==''))){
		alert("Debe ingresar la fecha de vencimiento")
		datos.inicio.focus();
	}else if(((datos.CB_FPAGO.value=='CD')||(datos.CB_FPAGO.value=='CF'))&&((datos.CB_BANCO_CLIENTE.value==''))){
		alert("Debe ingresar el Banco al que pretenece el cheque")
		datos.CB_BANCO_CLIENTE.focus();
	}else if(((datos.CB_FPAGO.value=='CD')||(datos.CB_FPAGO.value=='CF'))&&((datos.CB_PLAZA_CLIENTE.value==''))){
		alert("Debe ingresar la plaza")
		datos.CB_PLAZA_CLIENTE.focus();
	}else if(((datos.CB_FPAGO.value=='CD')||(datos.CB_FPAGO.value=='CF'))&&((datos.TX_NROCHEQUECLI.value==''))){
		alert("Debe ingresar el n�mero del cheque")
		datos.TX_NROCHEQUECLI.focus();
	}else if(((datos.CB_FPAGO.value=='CD')||(datos.CB_FPAGO.value=='CF'))&&((datos.TX_NROCTACTECLI.value==''))){
		alert("Debe ingresar el n�mero de la cuenta corriente")
		datos.TX_NROCTACTECLI.focus();
	}else{

		datos.TX_RUTCLI.disabled = false;
		datos.TX_MONTOCLI.disabled = false;
		datos.inicio.disabled = false;
		datos.CB_BANCO_CLIENTE.disabled = false;
		datos.CB_PLAZA_CLIENTE.disabled = false;
		datos.TX_NROCHEQUECLI.disabled = false;
		datos.TX_NROCTACTECLI.disabled = false;
		apilar_combo_combo(datos.CB_DESTINO, datos.DESTINO);
		apilar_combo_combo(datos.CB_FPAGO, datos.FPAGO);
		apilar_textbox_combo(datos.TX_RUTCLI, datos.RUTCLI);
		apilar_textbox_combo(datos.TX_MONTOCLI, datos.MONTOCLI);
		apilar_textbox_combo(datos.inicio, datos.FECHACLI);
		apilar_combo_combo(datos.CB_BANCO_CLIENTE, datos.BANCOCLI);
		apilar_combo_combo(datos.CB_PLAZA_CLIENTE, datos.PLAZACLI);
		apilar_textbox_combo(datos.TX_NROCHEQUECLI, datos.NROCHECLI);
		apilar_textbox_combo(datos.TX_NROCTACTECLI, datos.NRCTACTECLI);
		datos.CB_DESTINO.value="";
		datos.CB_FPAGO.value="";
		datos.TX_RUTCLI.value="";
		datos.TX_MONTOCLI.value="";
		datos.inicio.value="";
		datos.CB_BANCO_CLIENTE.value="";
		datos.CB_PLAZA_CLIENTE.value="";
		datos.TX_NROCHEQUECLI.value="";
		datos.TX_NROCTACTECLI.value="";
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

function suma_capital_2(objeto , intValorSaldoCapital, intValorIntereses, intValorGastos, intValorHonorarios){
	//alert(objeto.checked);
	if (objeto.checked == true) {
		datos.TX_DEUDACAPITAL.value = eval(datos.TX_DEUDACAPITAL.value) + eval(intValorSaldoCapital);
		datos.TX_INTERESES.value = eval(datos.TX_INTERESES.value) + eval(intValorIntereses);
		datos.TX_GASTOSJUD.value = eval(datos.TX_GASTOSJUD.value) + eval(intValorGastos);
		datos.TX_HONORARIOS.value = eval(datos.TX_HONORARIOS.value) + eval(intValorHonorarios);
	}
	else
	{
		datos.TX_DEUDACAPITAL.value = eval(datos.TX_DEUDACAPITAL.value) - eval(intValorSaldoCapital);
		datos.TX_INTERESES.value = eval(datos.TX_INTERESES.value) - eval(intValorIntereses);
		datos.TX_GASTOSJUD.value = eval(datos.TX_GASTOSJUD.value) - eval(intValorGastos);
		datos.TX_HONORARIOS.value = eval(datos.TX_HONORARIOS.value) - eval(intValorHonorarios);
	}
}





function suma_total_general (origen){
	if (origen == 1) {
		datos.TX_TOTALGRAL.value = eval(datos.TX_DEUDACAPITAL.value) + eval(datos.TX_HONORARIOS.value) + eval(datos.TX_INDCOM.value) + eval(datos.TX_OTROS.value) + eval(datos.TX_INTERESES.value) + eval(datos.TX_GASTOSJUD.value) - eval(datos.TX_DESCUENTO.value);
		//datos.TX_HONORARIOS.value = (eval(datos.TX_DEUDACAPITAL.value) + eval(datos.TX_INDCOM.value)) * 0.15;
		datos.TX_HONORARIOS.value = Math.round(datos.TX_HONORARIOS.value)
	}
	else if (origen == 2) {
		//var aaaa = datos.TX_HONORARIOS.value;
		datos.TX_TOTALGRAL.value = eval(datos.TX_DEUDACAPITAL.value) + eval(datos.TX_HONORARIOS.value) + eval(datos.TX_INDCOM.value) + eval(datos.TX_OTROS.value) + eval(datos.TX_INTERESES.value) + eval(datos.TX_GASTOSJUD.value) - eval(datos.TX_DESCUENTO.value);
		//datos.TX_HONORARIOS.value = aaaa
		datos.TX_TOTALGRAL.value = eval(datos.TX_DEUDACAPITAL.value) + eval(datos.TX_HONORARIOS.value) + eval(datos.TX_INDCOM.value) + eval(datos.TX_OTROS.value) + eval(datos.TX_INTERESES.value) + eval(datos.TX_GASTOSJUD.value) - eval(datos.TX_DESCUENTO.value);
	}
	else
	{
		datos.TX_TOTALGRAL.value = eval(datos.TX_DEUDACAPITAL.value) + eval(datos.TX_HONORARIOS.value) + eval(datos.TX_INDCOM.value) + eval(datos.TX_OTROS.value) + eval(datos.TX_INTERESES.value) + eval(datos.TX_GASTOSJUD.value) - eval(datos.TX_DESCUENTO.value);
	}
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
//addNew(document.myForm.proceso.options[document.myForm.proceso.selectedIndex].value)
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
//		for (var e=0; e< i; e++) {
//			if (texto==destino.options[e].text){
//				ok=true;
//				break;
//			}else
//				ok=false;
//			}
//		if (!ok){
			//var el = new Option(texto,value);

//		}
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
		//datos.TX_MONTOCLIENTE.disabled = true;
		//datos.TX_TOTAL.disabled = true;
		//datos.TX_TOTALCLIENTE.disabled = true;
		//datos.TX_TOTALEMP.disabled = true;
}
function envia(perfilusuario){
	if(datos.TX_RUT.value==''){
		alert("Debe ingresar el rut")
		disa();
		datos.TX_RUT.focus();
	}else if (perfilusuario=='caja_modif' && datos.cmb_sucursal.value==''){
		alert("Debe seleccionar la sucursal que corresponde")
	}else if(datos.CB_CLIENTE.value == '0'){
		alert("Debe seleccionar el Cliente");
		disa();
	//}else if (datos.TX_COMPINGRESO.value == ''){
	//	alert("Debe ingresar el N�mero del Comprobante de Pago");
	//	disa();
	}else if (datos.TX_BOLETA.value == ''){
		alert("Debe ingresar N�mero de Boleta");
		disa();
	}else if (datos.CB_TIPOPAGO.value == ''){
		alert("Debe seleccionar el Tipo de Pago");
		disa();
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
		//if (eval(datos.TX_TOTALCLIENTE.value) != eval(montcli) || eval(datos.TX_TOTALEMP.value)!= eval(montemp)){
		if (eval(datos.TX_TOTALGRAL.value) != eval(monttotal)) {
			alert("Los montos ingresados en el detalle de documentos no son correctos : Total General :" + eval(datos.TX_TOTALGRAL.value) + " , Total Detalle = " + eval(monttotal));
			disa();
		}else if (datos.TX_NRODEPCLIENTE.value != "" && datos.TX_NRODEPEMP.value != "" && datos.CB_BCLIENTE.value != "" && datos.CB_BEMP.value != "" && datos.TX_NRODEPCLIENTE.value == datos.TX_NRODEPEMP.value && datos.CB_BCLIENTE.value == datos.CB_BEMP.value){
			alert("Ingreso dos n�meros de deposito iguales");
			disa();
			datos.TX_NRODEPCLIENTE.value="";
			datos.TX_NRODEPEMP.value="";
			datos.CB_BCLIENTE.value="";
			datos.CB_BEMP.value="";
		}else{
			JuntaDetalleCliente();
			datos.strGraba.value='SI';
			datos.submit();
		}

	}



}

function ventanaSecundaria (URL){
window.open(URL,"INFORMACION","width=800, height=400, scrollbars=yes, menubar=no, location=no, resizable=yes")
}


function ventanaDetalle (URL){
window.open(URL,"DETALLEGESTION","width=800, height=300, scrollbars=yes, menubar=no, location=no, resizable=yes")
}
function ventanaDetalleTelefonicas (URL){
window.open(URL,"DETALLEGESTION","width=800, height=300, scrollbars=yes, menubar=no, location=no, resizable=yes")
}

function ventanaIngresoG (URL){
window.open(URL,"INFORMACION","width=800, height=400, scrollbars=yes, menubar=no, location=no, resizable=yes")
}

function ventanaMisGestiones (URL){
window.open(URL,"MISGESTIONES","width=800, height=400, scrollbars=yes, menubar=no, location=no, resizable=no")
}

function chkFecha(f) {
  str = f.value
  if (str.length<10){
  	alert("Error - Ingres� una fecha no v�lida");
  	f.value=''
	f.focus();
  //	f.select();
  }else{
	if ( !formatoFecha(str) ) {
		alert("Debe indicar la Fecha en formato DD/MM/AAAA. Ejemplo: 'Para 20 de Diciembre de 1982 se debe ingresar 20/12/1982'");
    //f.select()
		f.value=''
		f.focus()
		return false
	}
	if ( !validarFecha(str) ) {
    // Los mensajes de error est�n dentro de validarFecha.
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
    alert("Mes inv�lido en la fecha");
    return false;
  }
  if (inday < 1 || inday > diasEnMes(inmonth, inyear)) {
    alert("D�a inv�lido en la fecha");
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
  if (sl2 < 3 &&  sl2 > 5)    // el �ltimo slash debe estar en la 3, 4 o 5
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
  alert("diasEnMes: Mes inv�lido");
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


   //Obtiene dia, mes y a�o
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

   //Separa por dia, mes y a�o
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
function ValidarCorreo(strmail){
     var Email = strmail
     var Formato = /^([\w-\.])+@([\w-]+\.)+([a-z]){2,4}$/;
	 var Comparacion = Formato.test(Email);
     if(Comparacion == false){
          alert("CORREO ELECTR�NICO NO VALIDO");
          return false;
     }
}
function asigna_minimo(campo, minimo1){
	if (campo.value!=0)	{

		if(campo.value=='9'){
			minimo1=8;
		}else if(campo.value=='2'){
			minimo1=7;
		}else if(campo.value=='41' || campo.value=='32'){
			minimo1=7;
		}else{
			minimo1=6;
		}
	}else{minimo1=0}
	//alert(minimo1)
	return(minimo1)
}



function valida_largo(campo, minimo){
		if(campo.value.length != minimo) {
			alert("Fono debe tener " + minimo + " digitos")
			campo.value = ""
			//campo.select()
			campo.focus()
			return(true)
		}

	return(false)
}

function asigna_minimo2(campo, minimo2){
	if (campo.value!=0)	{
		if(campo.value==9){
			minimo2=8;
		}else if(campo.value==2){
			minimo2=7;
		}else if(campo.value==41 || campo.value==32){
			minimo2=7;
		}else {
			minimo2=6;
		}
	}else{minimo2=0}
	//alert(minimo2)
	return(minimo2)
}

function JuntaDetalleCliente(){
	datos.TXDESTINO.value = ""
	datos.TXFPAGO.value = ""
	datos.TXRUTCLI.value=""
	datos.TXMONTOCLI.value=""
	datos.TXFECVENCLI.value	=""
	datos.TXBANCOCLIENTE.value=""
	datos.TXPLAZACLIENTE.value=""
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
			datos.TXPLAZACLIENTE.value=datos.TXPLAZACLIENTE.value+"*";
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
		datos.TXPLAZACLIENTE.value=datos.TXPLAZACLIENTE.value+datos.PLAZACLI.options[e].value;
		datos.TXNROCHEQUECLI.value=datos.TXNROCHEQUECLI.value+datos.NROCHECLI.options[e].value;
		datos.TXNROCTACTECLI.value=datos.TXNROCTACTECLI.value+datos.NRCTACTECLI.options[e].value;
	}
}

function valida_largo2(campo, minimo){
		if(campo.value.length != minimo) {
			alert("Fono debe tener " + minimo + " digitos")
			campo.value = ""
			//campo.select()
			campo.focus()
			return(true)
		}

	return(false)
}

if (datos.TX_DEUDACAPITAL.value == '') datos.TX_DEUDACAPITAL.value = 0;
if (datos.TX_INDCOM.value == '') datos.TX_INDCOM.value = 0;
if (datos.TX_HONORARIOS.value == '') datos.TX_HONORARIOS.value = 0;
if (datos.TX_TOTALGRAL.value == '') datos.TX_TOTALGRAL.value = 0;
if (datos.TX_OTROS.value == '') datos.TX_OTROS.value = 0;
if (datos.TX_INTERESES.value == '') datos.TX_INTERESES.value = 0;
if (datos.TX_GASTOSJUD.value == '') datos.TX_GASTOSJUD.value = 0;
if (datos.TX_DESCUENTO.value == '') datos.TX_DESCUENTO.value = 0;

</script>


















