<% @LCID = 1034 %>
<!--#include file="../arch_utils.asp"-->
<!--#include file="../lib.asp"-->
<!--#include file="../sesion.asp"-->
<!--#include file="../../lib/comunes/rutinas/funciones.inc" -->
<%
	rut = request("rut")
	'response.write(rut)
	strRutDeudor=rut
	'response.write(strRutDeudor)
	intSeq = request("intSeq")
	strGraba = request("strGraba")
	txt_FechaIni = request("txt_FechaIni")
	intSucursal="1"
	'hoy=now
	'fecha= date
	cod_pago=request.querystring("cod_pago")

	intNroBoleta = request("TX_BOLETA")
	intCompIngreso = request("TX_COMPINGRESO")
	intCantDoc = request("TX_CANTDOC")
	intMontoCliente = request("TX_MONTOCLIENTE")
	intFormaPagoCliente = request("CB_FPAGO_CLIENTE")
	intMontoEmp = request("TX_MONTOEMP")
	intFormaPagoEMP = request("CB_FPAGO_CLIENTE")
	intTipoPago = request("CB_TIPOPAGO")
	strNroDepositoCliente = request("TX_NRODEPCLIENTE")
	strNroDepositoEMP = request("TX_NRODEPEMP")
	strNRODOC = request("TX_CLAVEDOC")
	strNroLiquidacion = request("TX_NROLIQUIDACION")
	intPeriodoPagado = request("TX_PERIODO")
	intCapital = request("TX_CAPITAL")
	intReajuste = request("TX_REAJUSTE")
	intInteres = request("TX_INTERES")
	intGravamenes = request("TX_GRAVAMENES")
	intMulta = request("TX_MULTAS")
	intCargos = request("TX_CARGOS")
	intCostas = request("TX_COSTAS")
	intOtros = request("TX_OTROS")
	strDocCancelados = request("TX_DOCCANCELADOS")
	strObservaciones = request("TX_OBSERVACIONES")


	intNroBoleta = Trim(intNroBoleta)
	intCompIngreso = Trim(intCompIngreso)
	intCantDoc = Trim(intCantDoc)
	intMontoCliente = Trim(intMontoCliente)
	intFormaPagoCliente = Trim(intFormaPagoCliente)
	intMontoEmp = Trim(intMontoEmp)
	intFormaPagoEMP = Trim(intFormaPagoEMP)
	intTipoPago = Trim(intTipoPago)
	strNroDepositoCliente = Trim(strNroDepositoCliente)
	strNroDepositoEMP = Trim(strNroDepositoEMP)
	strNRODOC = Trim(strNRODOC)
	strNroLiquidacion = Trim(strNroLiquidacion)
	intPeriodoPagado = Trim(intPeriodoPagado)
	intCapital = Trim(intCapital)
	intReajuste = Trim(intReajuste)
	intInteres = Trim(intInteres)
	intGravamenes = Trim(intGravamenes)
	intMulta = Trim(intMulta)
	intCargos = Trim(intCargos)
	intCostas = Trim(intCostas)
	intOtros = Trim(intOtros)
	strDocCancelados = Trim(strDocCancelados)
	strObservaciones = Trim(strObservaciones)

%>
<title>Empresa</title>
<style type="text/css">
<!--
.Estilo13 {color: #FFFFFF}
.Estilo27 {color: #FFFFFF}
-->
</style>

<script language="JavaScript" src="../../comunes/lib/cal2.js"></script>
<script language="JavaScript" src="../../comunes/lib/cal_conf2.js"></script>
<script language="JavaScript" src="../../comunes/lib/validaciones.js"></script>
<script src="../../comunes/general/SelCombox.js"></script>
<script src="../../comunes/general/OpenWindow.js"></script>


  <%
	  	AbrirScg()
		strSql = "SELECT CWC.ID_PAGO, CONVERT(VARCHAR(10),CWC.FECHA_PAGO, 103) AS FECHA_PAGO,CWC.RUTDEUDOR,CWC.COMP_INGRESO,CWC.NRO_BOLETA,ISNULL(CWC.MONTO_CAPITAL,0) AS MONTO_CAPITAL,ISNULL(CWC.MONTO_EMP,0) AS MONTO_EMP,CTP.DESC_TIPO_PAGO,ISNULL(CWC.NRO_DEPOSITO_CLIENTE,'') AS NRO_DEPOSITO_CLIENTE,ISNULL(CWC.NRO_DEPOSITO_EMP,'')AS NRO_DEPOSITO_EMP ,CC.DESCRIPCION AS NOMBRE,CWC.COD_CLIENTE,CWC.DESC_CLIENTE,CWC.DESC_EMP,CWC.TOTAL_CLIENTE,CWC.TOTAL_EMP,CWC.BCO_DEPOSITO_CLIENTE,CWC.BCO_DEPOSITO_EMP,CWC.OBSERVACIONES,CWC.INTERES_PLAZO,CWC.INDEM_COMP "
		strSql = strSql & " FROM CAJA_WEB_EMP CWC,CAJA_TIPO_PAGO CTP,CLIENTE CC WHERE CWC.TIPO_PAGO=CTP.ID_TIPO_PAGO AND CC.CODCLIENTE =CWC.COD_CLIENTE AND ID_PAGO=" & cod_pago & ""
		''Response.write "strSql = " & strSql

		set rsDet=Conn.execute(strSql)
		if not rsDet.eof then
			sql2="select nro_liquidacion from caja_web_emp_detalle where id_pago=" & cod_pago & ""
			set rsLiq=Conn.execute(SQL2)
			if not rsLiq.eof then
				if rsLiq("nro_liquidacion")=0 then
					nroliquidacion=""
				else
					nroliquidacion=rsLiq("nro_liquidacion")
				end if
			end if
			fecha = rsDet("fecha_pago")
			strNomCliente = rsDet("nombre")
			rutdeudor = rsDet("rutdeudor")
			cliente = rsDet("cod_cliente")
			nrocomp = rsDet("comp_ingreso")
			nrobolt = rsDet("nro_boleta")
			tipago = rsDet("desc_tipo_pago")
			mcli = rsDet("monto_capital")
			nrodepcli = rsDet("nro_deposito_cliente")
			mint = rsDet("monto_emp")
			nrodepint = rsDet("nro_deposito_emp")
			desccliente = rsDet("desc_cliente")
			descemp = rsDet("desc_emp")
			ttcliente = rsDet("total_cliente")
			ttemp = rsDet("total_emp")
			bancocliente=rsDet("bco_deposito_cliente")
			sql="select * from bancos where codigo='" & bancocliente & "'"
			set rsBC=Conn.execute(SQL)
			if not rsBC.eof then
				badescripcli=rsBC("NOMBRE_B")
			else
				badescripcli=""
			end if

			bancoemp=rsDet("bco_deposito_emp")
			sql="select * from bancos where codigo='" & bancoemp & "'"
			set rsBEmp=Conn.execute(SQL)
			if not rsBEmp.eof then
				badescripemp=rsBEmp("NOMBRE_B")
			else
				badescripemp=""
			end if

			'total = rsDet("cod_cliente")
			if nrodepcli="NULL" then
				nrodepcli=""
			end if
			if nrodepint="NULL" then
				nrodepint=""
			end if
			observaciones = rsDet("observaciones")
			ipcliente = rsDet("interes_plazo")
			cemp = rsDet("INDEM_COMP")
		end if
	  if rut <> "" then

		strNombreDeudor = TraeNombreDeudor(Conn,strRutDeudor)
		strFonoArea = TraeUltimoFonoDeudorSCG(Conn,strRutDeudor,"CODAREA")
		strFonoFono = TraeUltimoFonoDeudorSCG(Conn,strRutDeudor,"TELEFONO")

		strDirCalle= TraeUltimaDirDeudorSCG(Conn,strRutDeudor,"CALLE")
		strDirNum = TraeUltimaDirDeudorSCG(Conn,strRutDeudor,"NUMERO")
		strDirComuna = TraeUltimaDirDeudorSCG(Conn,strRutDeudor,"COMUNA")
		strDirResto = TraeUltimaDirDeudorSCG(Conn,strRutDeudor,"RESTO")

		strTelefonoDeudor = TraeUltimoFonoDeudorSCG(Conn,strRutDeudor,"CODAREA") & "-" & TraeUltimoFonoDeudorSCG(Conn,strRutDeudor,"TELEFONO")
		If Trim(strTelefonoDeudor) = "-" Then strTelefonoDeudor = "S/F"
	else
		strNombreDeudor=""
		strFonoArea = ""
		strFonoFono = ""
		strDirCalle = ""
		strDirNum = ""
		strDirComuna = ""
		strDirResto = ""
	end if

	%>


<link href="style.css" rel="Stylesheet">

<table width="700" height="500" border="0">
	<tr>
		<td height="20" bordercolor="#999999"  bgcolor="#<%=session("COLTABBG")%>" class="Estilo13" align="center">DETALLE DE PAGOS EMPRESA </td>
	</tr>
	<tr>
		<td height="20" bordercolor="#999999"  bgcolor="#<%=session("COLTABBG")%>" class="Estilo27"><strong>Antecedentes de Ubicabilidad</strong></td>
	</tr>
	<tr>
		<td valign="top">
			<table width="100%" border="0" bordercolor="#FFFFFF">
				<tr bgcolor="#<%=session("COLTABBG2")%>" class="Estilo8">
					<td ALIGN="LEFT">RUT : <%=rutdeudor%></td>  <td><INPUT TYPE="hidden" NAME="rut" value="<%=rut%>"> </td>
					<td ALIGN="RIGHT">FECHA: <%=fecha%></td><td>USUARIO : <%=session("nombre_user")%></td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td bordercolor="#999999"  bgcolor="#<%=session("COLTABBG")%>">
			<font class="Estilo27"><strong>&nbsp;Resumen Pago</strong></font>
		</td>
	</tr>
	<tr>
		<td>
			<table width="100%" border="0">
				<tr bordercolor="#999999"  bgcolor="#<%=session("COLTABBG")%>">
					<td><span class="Estilo27">CLIENTE</span></td>
					<td><span class="Estilo27">Nro. Liq.</span></td>
					<td><span class="Estilo27">N° Comprobante</span></td>
					<td><span class="Estilo27">N° Boleta</span></td>
					<td><span class="Estilo27">Tipo Pago</span></td>
				</tr>
				<tr bgcolor="#<%=session("COLTABBG2")%>" class="Estilo8">
					<td><%=strNomCliente%></td>
					<td><%=nroliquidacion%></td>
					<td><%=nrocomp%></td>
					<td><%=nrobolt%></td>
					<td><%=tipago%></td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td>
			<table width="100%" border="0">
				<tr bordercolor="#999999"  bgcolor="#<%=session("COLTABBG")%>">
					<td><span class="Estilo27">Monto Cliente</span></td>
					<td><span class="Estilo27">Nro.Dep.Cliente</span></td>
					<td><span class="Estilo27">Banco</span></td>
					<td><span class="Estilo27">Intereses</span></td>
					<td><span class="Estilo27">Descuento Cliente</span></td>
					<td><span class="Estilo27">Total Cliente</span></td>
					<td><span class="Estilo27"></span></td>
				</tr>
				<tr bgcolor="#<%=session("COLTABBG2")%>" class="Estilo8">
					<td align="RIGHT"><%=fn(mcli,0)%></td>
					<td><%=nrodepcli%></td>
					<td><%=badescripcli%></td>
					<td align="RIGHT"><%=fn(ipcliente,0)%></td>
					<td align="RIGHT"><%=fn(desccliente,0)%></td>
					<td align="RIGHT"><%=fn(ttcliente,0)%></td>
					<TD></TD>
				</tr>
				<tr bordercolor="#999999"  bgcolor="#<%=session("COLTABBG")%>">
					<td><span class="Estilo27">Monto Empresa</span></td>
					<td><span class="Estilo27">Nro.Dep. Empresa</span></td>
					<td><span class="Estilo27">Banco</span></td>
					<td align="RIGHT"><span class="Estilo27">Indem.Compensat</span></td>
					<td align="RIGHT"><span class="Estilo27">Descuento Empresa</span></td>
					<td align="RIGHT"><span class="Estilo27">Total Empresa</span></td>
					<td align="RIGHT"><span class="Estilo27">Total General</span></td>
				</tr>
				<tr bgcolor="#<%=session("COLTABBG2")%>" class="Estilo8">
					<td align="RIGHT"><%=fn(mint,0)%></td>
					<td><%=nrodepint%></td>
					<td><%=badescripemp%></td>
					<td align="RIGHT"><%=fn(cemp,0)%></td>
					<td align="RIGHT"><%=fn(descemp,0)%></td>
					<td align="RIGHT"><%=fn(ttemp,0)%></td>
					<td align="RIGHT"><%=fn(ttcliente + ttemp,0)%></td>
				</tr>
			</table>
			<table width="100%" border="0">
				<tr >
					<td bgcolor="#<%=session("COLTABBG2")%>"><span class="Estilo8">OBSERVACIONES: </span></td>
					<td bgcolor="#<%=session("COLTABBG2")%>"><%=observaciones%></td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td bordercolor="#999999"  bgcolor="#<%=session("COLTABBG")%>">
			<font class="Estilo27"><strong>&nbsp;Detalle Pago Mandante</strong></font>
		</td>
	</tr>
	<tr>
		<td>
		 <table width="100%" border="0">
			<tr bordercolor="#999999"  bgcolor="#<%=session("COLTABBG")%>">
				<td><span class="Estilo27">Clave / Nro Doc</span></td>
				<td><span class="Estilo27">Cuotas</span></td>
				<td><span class="Estilo27">Capital</span></td>
				<td><span class="Estilo27">Reajuste</span></td>
				<td><span class="Estilo27">Interes</span></td>
				<td><span class="Estilo27">Gravámenes</span></td>
				<td><span class="Estilo27">Multas</span></td>
				<td><span class="Estilo27">Cargos</span></td>
				<td><span class="Estilo27">Costas</span></td>
				<td><span class="Estilo27">Otros</span></td>
			</tr>
			<%
			sql="SELECT NRODOC,PERIODO_PAGADO,OBSERVACIONES,CAPITAL,REAJUSTE,INTERESES,GRAVAMENES,MULTA,CARGOS,COSTAS,OTROS FROM CAJA_WEB_EMP_DETALLE WHERE ID_PAGO = " & cod_pago & ""
			set rsDetPago=Conn.execute(SQL)
			if not rsDetPago.eof then
				do while not rsDetPago.eof
					nrodoc = rsDetPago("NRODOC")
					if nrodoc="NULL" then nrodoc=""
					periodo = rsDetPago("periodo_pagado")
					cuotas = rsDetPago("OBSERVACIONES")
					capital = rsDetPago("capital")
					reajuste = rsDetPago("reajuste")
					interes = rsDetPago("intereses")
					gravamenes = rsDetPago("gravamenes")
					multas = rsDetPago("multa")
					cargos = rsDetPago("cargos")
					costas = rsDetPago("costas")
					Otros = rsDetPago("otros")
					%>
					<tr bgcolor="#<%=session("COLTABBG2")%>" class="Estilo8">
						<td align="RIGHT"><%=nrodoc%></td>
						<td><%=cuotas%></td>
						<td align="RIGHT"><%=fn(capital,0)%></td>
						<td align="RIGHT"><%=fn(reajuste,0)%></td>
						<td align="RIGHT"><%=fn(interes,0)%></td>
						<td align="RIGHT"><%=fn(gravamenes,0)%></td>
						<td align="RIGHT"><%=fn(multas,0)%></td>
						<td align="RIGHT"><%=fn(cargos,0)%></td>
						<td align="RIGHT"><%=fn(costas,0)%></td>
						<td align="RIGHT"><%=fn(Otros,0)%></td>
					</tr>
					<%
					rsDetPago.movenext
				loop
			end if
			%>
			<tr>
			</tr>
		</table>
		</td>
	</tr>
	<tr bordercolor="#999999"  bgcolor="#<%=session("COLTABBG")%>">
		<td>
			<font class="Estilo27"><strong>&nbsp;Detalle de Documentos</strong></font>
		</td>
	</tr>
	<tr>
		<td>
			<table width="100%" border="0">
			  <tr bordercolor="#999999"  bgcolor="#<%=session("COLTABBG")%>">
				<td><span class="Estilo27">Destino Pago</span></td>
				<td><span class="Estilo27">Forma Pago</span></td>
				<td><span class="Estilo27">Monto</span></td>
				<td><span class="Estilo27">Fecha Venc</span></td>
				<td><span class="Estilo27">Banco</span></td>
				<td><span class="Estilo27">Plaza</span></td>
				<td><span class="Estilo27">N° Cheque</span></td>
				<td><span class="Estilo27">Cta. Cte.</span></td>
			  </tr>
				<%
					sql = "SELECT MONTO,VENCIMIENTO,COD_BANCO,NRO_CHEQUE,NRO_CTACTE,CODIGO_PLAZA,TIPO_PAGO,DESC_FORMA_PAGO "
					sql = sql & " FROM CAJA_WEB_EMP_DOC_PAGO,CAJA_FORMA_PAGO WHERE CAJA_FORMA_PAGO.ID_FORMA_PAGO=CAJA_WEB_EMP_DOC_PAGO.FORMA_PAGO AND ID_PAGO = " & cod_pago & ""
					set rsDetDocPago=Conn.execute(SQL)
					if not rsDetDocPago.eof then
						do while not rsDetDocPago.eof
							if rsDetDocPago("tipo_pago") = 0 then
								destino = strNomCliente
							end if
							if rsDetDocPago("tipo_pago") = 1 then
								destino = "Empresa Gastos"
							end if
							if rsDetDocPago("tipo_pago") = 2 then
								destino = "Empresa Costas"
							end if
							if rsDetDocPago("vencimiento") = "NULL" or rsDetDocPago("vencimiento")="01/01/1900" then
								venc=""
							else
								venc=rsDetDocPago("vencimiento")
							end if
							if rsDetDocPago("COD_BANCO") > "0" then
								strSql="SELECT * FROM BANCOS WHERE CODIGO='" & rsDetDocPago("COD_BANCO") & "'"
								set rsBanco=Conn.execute(strSql)
								if not rsBanco.eof then
									banco=rsBanco("NOMBRE_B")
								end if
							end if
							if rsDetDocPago("codigo_plaza") > "0" then
								sq="SELECT * FROM BANCO_PLAZA WHERE CODIGO=" & rsDetDocPago("codigo_plaza")
								set rsPlaza=Conn.execute(sq)
								if not rsPlaza.eof then
									plaza=rsPlaza("NOMBRE")
								end if
							end if
							if rsDetDocPago("nro_cheque")="NULL" then
								nrocheque=""
							else
								nrocheque=rsDetDocPago("nro_cheque")
							end if
							if rsDetDocPago("nro_ctacte") = "NULL" then
								nroctacte=""
							else
								nroctacte=rsDetDocPago("nro_ctacte")
							end if
							%>
							<tr bgcolor="#<%=session("COLTABBG2")%>" class="Estilo8">
							<td><%=destino%></td>
							<td><%=rsDetDocPago("desc_forma_pago")%></td>
							<td align="RIGHT"><%=FN(rsDetDocPago("monto"),0)%></td>
							<td><%=venc%></td>
							<td><%=banco%></td>
							<td><%=plaza%></td>
							<td><%=nrocheque%></td>
							<td><%=nroctacte%></td>
						</tr>
							<%
							destino=""
							venc=""
							banco=""
							plaza=""
							nrocheque=""
							nroctacte=""
							rsDetDocPago.movenext
						loop
					end if
				%>
				<tr>
					<td><A HREF="detalle_caja.asp">Volver</A></td>
				</tr>
			</table>
		</td>
	</tr>

	<% CerrarScg()%>
  </table>


