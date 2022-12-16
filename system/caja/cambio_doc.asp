<% @LCID = 1034 %>
<!--#include file="../../comunes/bdatos/ControlDeAcceso.inc"-->
<!--#include file="../../comunes/bdatos/ConectarSCG.inc"-->
<!--#include file="../../comunes/rutinas/funciones.inc" -->
<!--#include file="../../comunes/rutinas/rutinasSCG.inc" -->
<!--#include file="../../comunes/bdatos/ConectarINTRACPS.inc"-->

<%
	rut = request("TX_RUT")
	'response.write(rut)
	'response.end
	strRutDeudor=rut
	'intSeq = request("intSeq")
	'strGraba = request("strGraba")
	cod_pago = request("cod_pago")
	'response.write(cod_pago)
	'response.end
	fecha=request("fecha_pago")
	'usuario=110
	usuario=Session("intCodUsuario")
	sql="select * from usuario where cod_usuario = " & usuario & ""
	set rsUsu=Conn.execute(sql)
	if not rsUsu.eof then
		intSucursal=rsUsu("sucursal")
	end if

	'calle=UCASE(LTRIM(RTRIM(request.Form("txt_calle"))))
	'numero=LTRIM(RTRIM(request.form("txt_numero")))
	'resto=UCASE(LTRIM(RTRIM(request.Form("txt_resto"))))
	'if resto="" then
	'	resto="NULL"
	'end if
	'comuna=request.Form("cmb_comuna")

	'codarea1=UCASE(LTRIM(RTRIM(request.Form("cmb_area1"))))
	'numero1=LTRIM(RTRIM(request.form("txt_fono1")))
	'codarea2=UCASE(LTRIM(RTRIM(request.Form("cmb_area2"))))
	'numero2=LTRIM(RTRIM(request.form("txt_fono2")))
	'if numero2="" then
'		numero2=0
'	end if
	'mail = ltrim(rtrim(request("txt_mail")))
	'if mail="" then
'		mail="NULL"
	'end if

	strCodCliente = request("CB_CLIENTE")
	strNroLiquidacion = request("TX_NROLIQUIDACION")
	if strNroLiquidacion = "" then strNroLiquidacion=0
	intCompIngreso = request("TX_COMPINGRESO")
	intNroBoleta = request("TX_BOLETA")
	'response.write(intNroBoleta)
	if intNroBoleta="" then intNroBoleta=0
	intTipoPago = request("CB_TIPOPAGO")
	intMontoCliente = request("TX_MONTOCLIENTE")
	strNroDepositoCliente = request("TX_NRODEPCLIENTE")
	strDescCliente = request("TX_DESCLIENTE")
	if strDescCliente="" then strDescCliente=0
	strTotalCliente = request("TX_TOTALCLIENTE")
	if strTotalCliente="" then strTotalCliente=0
	intMontoCps = request("TX_MONTOCPS")
	if intMontoCps="" then intMontoCps=0
	strNroDepositoCPS = request("TX_NRODEPCPS")
	intDescuento = request("TX_DESCUENTO")
	if intDescuento="" then intDescuento=0
	strTotalCps = request("TX_TOTALCPS")
	if strTotalCps="" then strTotalCps=0
	intTotal = request("TX_TOTAL")
	if intTotal="" then intTotal=0
	observaciones=request("tx_observacion")
	ipcliente=request("TX_IPCLIENTE")
	if ipcliente="" then ipcliente=0
	ccps = request("TX_CCPS")
	if ccps="" then ccps=0

	strClaveDeudor = request("TXCLAVEDOC")
	intPeriodoPagado = request("TXPERIODO")
	intCapital = request("TXCAPITAL")
	intReajuste = request("TXREAJUSTE")
	intInteres = request("TXINTERES")
	intGravamenes = request("TXGRAVAMENES")
	intMulta = request("TXMULTAS")
	intCargos = request("TXCARGOS")
	intCostas = request("TXCOSTAS")
	intOtros = request("TXOTROS")

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

	intCompIngreso = PN(intCompIngreso)
	intNroBoleta = PN(intNroBoleta)
	intTipoPago = PN(intTipoPago)
	intMontoCliente = PN(intMontoCliente)
	intFormaPagoCliente = PN(intFormaPagoCliente)
	strNroDepositoCliente = PN(strNroDepositoCliente)
	intMontoCps = PN(intMontoCps)
	intFormaPagoCPS = PN(intFormaPagoCPS)
	strNroDepositoCPS = PN(strNroDepositoCPS)
	intDescuento = PN(intDescuento)
	intTotal = PN(intTotal)

	strClaveDeudor = PN(strClaveDeudor)
	strNroLiquidacion = PN(strNroLiquidacion)
	intPeriodoPagado = PN(intPeriodoPagado)
	intCapital = PN(intCapital)
	intReajuste = PN(intReajuste)
	intInteres = PN(intInteres)
	intGravamenes = PN(intGravamenes)
	intMulta = PN(intMulta)
	intCargos = PN(intCargos)
	intCostas = PN(intCostas)
	intOtros = PN(intOtros)

	'IF strRutCps = "" OR ISNULL(strRutCps) THEN
	sTipo = PN(strTipo)
	sRut = PN(strRutCli)
	sForma = PN(strFormaPago)
	sCuota = PN(strcuotas)
	sMonto = PN(intMontoCli)
	sFecha = PN(intFechaCli)
	sBanco = PN(intBancoCli)
	sPlaza = PN(intPlazaCli)
	sNroChe = PN(intNroCheCli)
	sNroCta = PN(intNroCtaCli)
	estado="N"
	'END IF
	'response.write(sfecha)
	'strSql = "EXEC UPD_SEC 'CAJA_WEB_CPS'"
	'set rsPago=ConexionSCG.execute(strSql)
	'If not rsPago.Eof then
	'	intSeq = rsPago("SEQ")
	'End if




	'response.write "<BR>"
	'response.write "<BR>"

	VstrClaveDeudor = split(strClaveDeudor,"*")
	VintPeriodoPagado = split(intPeriodoPagado,"*")
	vCuota = split(sCuota,"*")
	VintCapital = split(intCapital,"*")
	VintReajuste = split(intReajuste,"*")
	VintInteres = split(intInteres,"*")
	VintGravamenes = split(intGravamenes,"*")
	VintMulta = split(intMulta,"*")
	VintCargos = split(intCargos,"*")
	VintCostas = split(intCostas,"*")
	VintOtros = split(intOtros,"*")
	n=0
	'if VstrClaveDeudor(0) <> "" and VstrClaveDeudor(0)<> "NULL"then
		strSql = "update CAJA_WEB_CPS set ESTADO_CAJA='" & estado & "' where id_pago = " & cod_pago & ""
		'response.write(strSql)
		set rsInserta=ConexionSCG.execute(strSql)
		sSql = "EXEC UPD_SEC 'CAJA_WEB_CPS'"
		set rsPago=ConexionSCG.execute(sSql)
		If not rsPago.Eof then
			intSeq = rsPago("SEQ")
		End if
		estado="A"
		Sql = "INSERT INTO CAJA_WEB_CPS (ID_PAGO,RENDIDO,fecha_pago,PERIODO,SUCURSAL,COD_CLIENTE,RUTDEUDOR,COMP_INGRESO,NRO_BOLETA,MONTO_CAPITAL,MONTO_CPS,TIPO_PAGO,NRO_DEPOSITO_CLIENTE,NRO_DEPOSITO_CPS,USRINGRESO,DESC_CLIENTE,DESC_CPS,TOTAL_CLIENTE,TOTAL_CPS,BCO_DEPOSITO_CLIENTE,BCO_DEPOSITO_CPS,OBSERVACIONES,INTERES_PLAZO,COSTAS_CPS,ESTADO_CAJA) "

		Sql = Sql & "VALUES (" & intSeq & ",'" & fecha & "','" & fecha & "',YEAR(getdate()),'" & intSucursal & "','" & strCodCliente & "','" &  strRutDeudor & "'," & intCompIngreso  & "," & intNroBoleta & "," & intMontoCliente & "," & intMontoCps & ",'" & intTipoPago & "','" & strNroDepositoCliente & "','" & strNroDepositoCPS & "'," & usuario & "," & strDescCliente & "," & intDescuento & "," & strTotalCliente & "," & strTotalCps & ",'" & bancocliente & "','" & bancocps & "','" & observaciones & "'," & ipcliente & "," & ccps & ",'" & estado & "')"

		'Response.write "Sql=" & Sql
			'response.end
		set rsInserta=ConexionSCG.execute(Sql)
	for each det in VstrClaveDeudor
		if VintPeriodoPagado(n) = "" then VintPeriodoPagado(n)=0
		if VstrClaveDeudor(n)="" then VstrClaveDeudor(n)=0
		if VintReajuste(n) = "" then VintReajuste(n)=0
		if VintInteres(n) = "" then VintInteres(n)=0
		if VintGravamenes(n) = "" then VintGravamenes(n)=0
		if VintMulta(n) = "" then VintMulta(n)=0
		if VintCargos(n) = "" then VintCargos(n)=0
		if VintCostas(n) = "" then VintCostas(n)=0
		if VintOtros(n) = "" then VintOtros(n)=0
		if vCuota(n) = "" then vCuota(n)=0
		SQL = "INSERT INTO CAJA_WEB_CPS_DETALLE (ID_PAGO, CORRELATIVO, CLAVEDEUDOR, NRO_LIQUIDACION, PERIODO_PAGADO, CAPITAL, REAJUSTE, INTERESES, GRAVAMENES,MULTA, CARGOS, COSTAS, OTROS,DOC_CANCELADOS)"

		SQL = SQL & "VALUES (" & intSeq & "," & n + 1 & ",'" & VstrClaveDeudor(n) & "'," & strNroLiquidacion & "," & VintPeriodoPagado(n) & "," & VintCapital(n) & "," & VintReajuste(n) & "," & VintInteres(n) & "," & VintGravamenes(n) & "," & VintMulta(n) & "," & VintCargos(n) & "," & VintCostas(n) & "," & VintOtros(n) & "," & vCuota(n) & ")"
		'RESPONSE.WRITE(SQL)
		'RESPONSE.END
		set rsIns=ConexionSCG.execute(Sql)
		n = n + 1
	next


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
	if vTipo(0) <> "" and vTipo(0)<> "NULL" then

	'sql="delete CAJA_WEB_cps_DOC_PAGO where id_pago=" & cod_pago & ""
	'set rsInser=ConexionSCG.execute(SQL)

	for each doc in vTipo
		if vFecha(x)="0" or vFecha(x)="NULL" then
			SQL = "INSERT INTO CAJA_WEB_cps_DOC_PAGO (ID_PAGO, CORRELATIVO, MONTO, COD_BANCO, NRO_CHEQUE, NRO_CTACTE, CODIGO_PLAZA, tipo_pago, forma_pago,RUT_CHEQUE)"

			SQL = SQL & "VALUES (" & intSeq & "," & x + 1 & "," & vMonto(x) & ",'" & vBanco(x) & "','" & vNroChe(x) & "','" & vNroCta(x) & "','" & vPlaza(x) & "','" & vTipo(x) & "','" & vForma(x) & "','" & vRut(x) & "')"
		else
			SQL = "INSERT INTO CAJA_WEB_cps_DOC_PAGO (ID_PAGO, CORRELATIVO, MONTO, VENCIMIENTO, COD_BANCO, NRO_CHEQUE, NRO_CTACTE, CODIGO_PLAZA, tipo_pago, forma_pago,RUT_CHEQUE)"

			SQL = SQL & "VALUES (" & intSeq & "," & x + 1 & "," & vMonto(x) & ",'" & vFecha(x) & "','" & vBanco(x) & "','" & vNroChe(x) & "','" & vNroCta(x) & "','" & vPlaza(x) & "','" & vTipo(x) & "','" & vForma(x) & "','" & vRut(x) & "')"
		end if
		'response.write(sql)
		'response.end
		set rsInser=ConexionSCG.execute(SQL)
		x = x + 1
	next
	end if

	'SQLL="insert into caja_web_ubicabilidad(id_pago,calle,numero,resto,comuna,fono1codpais,fono1codarea,fono1telefono,fono2codpais,fono2codarea,fono2telefono,email)values(" & intSeq & ",'" & calle & "','" & numero & "','" & resto & "','" & comuna & "',56," & codarea1 & ",'" & numero1 &"',56," & codarea2 & ",'" & numero2 &"','" & mail & "')"
	'response.write(SQLL)
	'response.end
	'set rsInser=ConexionSCG.execute(SQLL)
	'else
		%>
	<!-- <script>alert("No ingreso correctamente el detalle del pago")</script> -->
	<%
	'	Response.Write ("<script language = ""Javascript"">" & vbCrlf)
	'Response.Write (vbTab & "history.back();" & vbCrlf)
	'Response.Write ("</script>")
	'end if
	%>
	<script>alert("El cambio de cheque se realizo correctamente")</script>
	<%
	Response.Write ("<script language = ""Javascript"">" & vbCrlf)
	Response.Write (vbTab & "location.href='detalle_cambio_caja.asp'" & vbCrlf)
	Response.Write ("</script>")
%>
