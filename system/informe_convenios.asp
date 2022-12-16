<% @LCID = 1034 %>

<!--#include file="arch_utils.asp"-->
<!--#include file="sesion.asp"-->
<!--#include file="../lib/comunes/rutinas/funciones.inc" -->
<!--#include file="../lib/comunes/rutinas/TraeCampo.inc" -->
<!--#include file="asp/comunes/general/rutinasSCG.inc" -->
<!--#include file="asp/comunes/general/rutinasBooleano.inc"-->

<!--#include file="lib.asp"-->

<!--#include file="../lib/comunes/rutinas/chkFecha.inc"-->
<!--#include file="../lib/comunes/rutinas/sondigitos.inc"-->
<!--#include file="../lib/comunes/rutinas/formatoFecha.inc"-->
<!--#include file="../lib/comunes/rutinas/validarFecha.inc"-->
<!--#include file="../lib/comunes/rutinas/diasEnMes.inc"-->
<!--#include file="asp/comunes/general/rutinasBooleano.inc"-->


<%	AbrirSCG()
	termino = request("termino")
	inicio = request("inicio")
	resp = request("resp")

	if Trim(inicio) = "" Then
		inicio = TraeFechaMesActual(Conn,-1)
		inicio = "01" & Mid(inicio,3,10)
		inicio = TraeFechaActual(Conn)
	End If
	if Trim(termino) = "" Then
		termino = TraeFechaActual(Conn)
	End If %>

<title>CRM Cobros</title>
<style type="text/css">
<!--
.Estilo13 {color: #FFFFFF}
.Estilo27 {color: #FFFFFF}
-->
</style>

<script language="JavaScript" src="../comunes/lib/cal2.js"></script>
<script language="JavaScript" src="../comunes/lib/cal_conf2.js"></script>
<script language="JavaScript" src="../comunes/lib/validaciones.js"></script>
<script src="../comunes/general/SelCombox.js"></script>
<script src="../comunes/general/OpenWindow.js"></script>

<script language="JavaScript " type="text/JavaScript">

function envia()
{
	resp='si'
	document.datos.action = "informe_convenios.asp?resp="+ resp +"";
	document.datos.submit();
}

</script>

<link href="style.css" rel="Stylesheet">
<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<form name="datos" method="post">
<table width="900" border="1" valign="top">
  <tr>
    <td height="20" bordercolor="#999999"  bgcolor="#<%=session("COLTABBG")%>" class="Estilo13" ALIGN="CENTER">INFORME DE CONVENIOS AVS</td>
  </tr>
  <tr>
		<td valign="top">
			<table width="100%" border="0" bordercolor="#999999">
				  <tr height="20" bordercolor="#999999"  bgcolor="#<%=session("COLTABBG")%>" class="Estilo13">
					<td>&nbsp;DESDE</td>
					<td>&nbsp;HASTA</td>
					<td>&nbsp;TIPO BUSQUEDA</td>
					<td>&nbsp;</td>
				  </tr>
				  <tr bordercolor="#999999" class="Estilo8">
					<td><input name="inicio" type="text" id="inicio" value="<%=inicio%>" size="10" maxlength="10">
							<a href="javascript:showCal('Calendar7');"><img src="../images/calendario.gif" border="0"></a>
					</td>
					<td><input name="termino" type="text" id="termino" value="<%=termino%>" size="10" maxlength="10">
						<a href="javascript:showCal('Calendar6');"><img src="../images/calendario.gif" border="0"></a>

					</td>
					<td>
						<input name="radiobuscar" type="radio" value="1" <%If request("radiobuscar") = "1" Or request("radiobuscar") = ""  Then response.write "checked"%>> TODO
						<input name="radiobuscar" type="radio" value="2" <%If request("radiobuscar") = "2" Then response.write "checked"%>> ULTIMA CUOTA
					</td>
					<td><input type="Button" name="Submit" value="Buscar" onClick="envia();"></td>
				  </tr>
			</table>
		</td>
	</tr>

	<%	If resp="si" Then %>

	<tr>
		<td height="20" bordercolor="#999999"  bgcolor="#<%=session("COLTABBG")%>" class="Estilo13" ALIGN="CENTER">RESUMEN PAGOS REINTEGRA</td>
	</tr>
	<tr>
		<td valign="top">
	<table width="100%" border="0" bordercolor="#000000" cellpadding="2">
		<tr bordercolor="#999999"  bgcolor="#<%=session("COLTABBG")%>" class="Estilo13" align="center">
			<td>RUT</td>
			<td>NOMBRE</td>
			<td>FECHA PAGO</td>
			<td>FECHA CONVENIO</td>
			<td>CUOTA</td>
			<td>DE</td>
			<td>TOTAL PAGADO</td>
			<td>PEAJE</td>
			<td>GASTO JUDICIAL</td>
			<td>INTERES</td>
			<td>TIPO ASEG.</td>
		</tr>

	<%
		strSql = "SELECT DISTINCT e.id_convenio, c.RUTDEUDOR, CONVERT(VARCHAR(10),c.FECHA_PAGO, 103) AS FECHA_PAGO, CONVERT(VARCHAR(10), e.fechaingreso, 103) as fechaingreso, d.cuota, isnull(e.gastos,0) as gastos , e.cuotas, cast(isnull(d.total_cuota,0) as numeric) as total_cuota, d.pagada, d.idpago, d.idpagocorr, convert(char(10), d.fecha_del_pago,103) as fecha_del_pago, d.id_tipoaseg FROM CAJA_WEB_EMP C, CONVENIO_ENC E, CONVENIO_DET D WHERE  c.cod_cliente = '1000' AND c.TIPO_PAGO = 'CO' AND c.COD_CLIENTE = 1000 and c.fecha_pago between '" & inicio & " 00:00:00' and '" & termino & " 23:59:59' and c.RUTDEUDOR = e.rutdeudor and E.ID_CONVENIO = D.ID_CONVENIO and d.fecha_del_pago between '" & inicio & " 00:00:00' and '" & termino & " 23:59:59' and d.pagada is not null "

		If request("radiobuscar") = "2" Then strSql = strSql & " and d.cuota = e.cuotas "

		strSql = strSql & " order by c.RUTDEUDOR, d.cuota "

		'Response.write "strSql = " & strSql
		'Response.End

	if strSql <> "" Then

		set rsDet=Conn.execute(strSql)

		intSumTotalCuota = 0
		intSumPeaje = 0
		intSumGastos = 0
		intSumIntereses = 0
		if not rsDet.eof then
			do while not rsDet.eof

			intIdConvenio = rsDet("id_convenio")
			strRutDeudor = rsDet("RUTDEUDOR")
			strFechaPago = rsDet("FECHA_PAGO")
			strFechaConvenio = rsDet("fechaingreso")
			strCuota = rsDet("cuota")
			intCuota = rsDet("cuota")
			intTotalCuotas = rsDet("cuotas")
			intTotalCuota = rsDet("total_cuota")
			intGastos = 0
			intTipoAseg = rsDet("id_tipoaseg")

			If intCuota = 0 Then
				strCuota = "PIE"
				intGastos = rsDet("gastos")
			end if

			strcSql = " SELECT TOTAL_CONVENIO, PIE FROM CONVENIO_ENC WHERE ID_CONVENIO = " & intIdConvenio
			set rsClienteC=Conn.execute(strcSql)
			intTotalConvenio = rsClienteC("TOTAL_CONVENIO")
			intPie = rsClienteC("PIE")

			strtSql = " SELECT SUM(TOTAL_CUOTA) AS TOTALCUOTAS FROM CONVENIO_DET WHERE ID_CONVENIO = " & intIdConvenio & " AND CUOTA <> 0 "
			set rsClienteT=Conn.execute(strtSql)
			intSumaCuotas = rsClienteT("TOTALCUOTAS")

			intIntereses = 0
			If intCuota = intTotalCuotas Then intIntereses = (intTotalConvenio - intPie - intSumaCuotas) * -1
			If intIntereses <0 Then intIntereses = 0

			intPeaje = CLng(intTotalCuota) - CLng(intGastos) - CLng(intIntereses)

			ssql = "select top 1 nombredeudor from dbo.DEUDOR where codcliente = 1000 and rutdeudor = '" & strRutDeudor & "'"
			set rsCliente=Conn.execute(ssql)
			strNombreDeudor = rsCliente("nombredeudor")

			%>

			<tr bgcolor="#<%=session("COLTABBG2")%>" class="Estilo8">
				<td align="right"><a href="principal.asp?rut=<%=strRutDeudor%>"><%=UCase(strRutDeudor)%></a></td>
				<td><%=strNombreDeudor%></td>
				<td align="center"><%=strFechaPago%></td>
				<td align="center"><%=strFechaConvenio%></td>
				<td align="center"><%=strCuota%></td>
				<td align="center"><%=intTotalCuotas%></td>
				<td align="right">$ <%=FormatNumber(intTotalCuota,0)%></td>
				<td align="right">$ <%=FormatNumber(intPeaje,0)%></td>
				<td align="right">$ <%=FormatNumber(intGastos,0)%></td>
				<td align="right">$ <%=FormatNumber(intIntereses,0)%></td>
				<td align="right"><%=intTipoAseg%></td>
			</tr>

			<%
			intSumTotalCuota = CLng(intSumTotalCuota) + CLng(intTotalCuota)
			intSumPeaje = CLng(intSumPeaje) + CLng(intPeaje)
			intSumGastos = CLng(intSumGastos) + CLng(intGastos)
			intSumIntereses = CLng(intSumIntereses) + CLng(intIntereses)
			rsDet.movenext
			Loop
			rsDet.close()
		end if

	end if%>
			<tr bgcolor="#<%=session("COLTABBG2")%>" class="Estilo8">
				<td colspan=6>&nbsp;TOTAL</td>
				<td align="right">$ <%=FormatNumber(intSumTotalCuota,0)%></td>
				<td align="right">$ <%=FormatNumber(intSumPeaje,0)%></td>
				<td align="right">$ <%=FormatNumber(intSumGastos,0)%></td>
				<td align="right">$ <%=FormatNumber(intSumIntereses,0)%></td>
				<td> </td>
			</tr>
	</table>
	</td>
   </tr>
	<tr>
		<td height="20" bordercolor="#999999"  bgcolor="#<%=session("COLTABBG")%>" class="Estilo13" ALIGN="CENTER">FOLIOS REPACTACIONES</td>
	</tr>
   <tr>
	<td valign="top">
		<table width="100%" border="0" bordercolor="#999999" cellpadding="2">
		      <tr height="20" bordercolor="#999999"  bgcolor="#<%=session("COLTABBG")%>" class="Estilo13" ALIGN="CENTER">
				<td>RUT</td>
				<td>NOMBRE</td>
				<td>CUENTA</td>
				<td>FOLIO</td>
				<td>EMISION</td>
				<td>VENCIMIENTO</td>
				<td>MONTO</td>
				<td>SALDO DEUDA</td>
				<!-- <td>TIPO ASEG.</td> -->
			  </tr>
			<%
			strdsql = " SELECT CU.RUTDEUDOR, DE.NOMBREDEUDOR, CU.CUENTA, CU.NRODOC, CONVERT(CHAR(10),CU.FECHAVENC,103) AS FECHAVENC, CAST(CU.VALORCUOTA AS NUMERIC) AS VALORCUOTA, CAST(CU.SALDO AS NUMERIC) AS SALDO FROM dbo.CUOTA CU, dbo.DEUDOR DE WHERE CU.CODCLIENTE = 1000 AND DE.CODCLIENTE = CU.CODCLIENTE AND DE.RUTDEUDOR = CU.RUTDEUDOR AND CU.ESTADO_DEUDA = 10 AND CU.RUTDEUDOR IN (SELECT DISTINCT c.RUTDEUDOR FROM CAJA_WEB_EMP C, CONVENIO_ENC E, CONVENIO_DET D WHERE c.cod_cliente = '1000' AND c.TIPO_PAGO = 'CO' AND c.COD_CLIENTE = 1000 and c.fecha_pago between '" & inicio & " 00:00:00' and '" & termino & " 23:59:59' and c.RUTDEUDOR = e.rutdeudor and E.ID_CONVENIO = D.ID_CONVENIO and d.fecha_del_pago between '" & inicio & " 00:00:00' and '" & termino & " 23:59:59' and d.pagada is not null "

			If request("radiobuscar") = "2" Then strdsql = strdsql & " and D.cuota = E.cuotas "

			strdsql = strdsql & ") ORDER BY CU.RUTDEUDOR, CU.CUENTA, CAST(CU.NRODOC AS NUMERIC) DESC "

			'response.write strdsql

			set rsdCliente=Conn.execute(strdsql)

			if not rsdCliente.eof then
				do while not rsdCliente.eof

					strRut = rsdCliente("RUTDEUDOR")
					strNombre = rsdCliente("NOMBREDEUDOR")
					strCuenta = rsdCliente("CUENTA")
					strFolio = rsdCliente("NRODOC")
					strVenc = rsdCliente("FECHAVENC")
					strMonto = rsdCliente("VALORCUOTA")
					strSaldo = rsdCliente("SALDO")
					'intTipoAseg = "" %>

				<tr bgcolor="#<%=session("COLTABBG2")%>" class="Estilo8">
					<td align="right"><a href="principal.asp?rut=<%=strRut%>"><%=UCase(strRut)%></a></td>
					<td><%=strNombre%></td>
					<td align="right"><%=strCuenta%></td>
					<td align="right"><%=strFolio%></td>
					<td align="right">0</td>
					<td align="center"><%=strVenc%></td>
					<td align="right">$ <%=FormatNumber(strMonto,0)%></td>
					<td align="right">$ <%=strSaldo%></td>
					<!-- <td align="right"><%'=intTipoAseg%></td> -->
				  </tr>

			<%	rsdCliente.movenext
				loop
			end If %>
    </table>
	</td>
   </tr>
  </table>
  	<% End If %>
<br><br>
</form>
</body>