<%@ LANGUAGE="VBScript" %>
<!--#include file="sesion.asp"-->
<!--#include file="arch_utils.asp"-->
<!--#include file="../lib/comunes/rutinas/funciones.inc" -->
<!--#include file="asp/comunes/general/rutinasBooleano.inc" -->
<%
	strCliente=Request("strCliente")
	''strCliente=session("ses_codcli")

	intEjecutivo=Request("CB_EJECUTIVO")
	intRemesa=Request("CB_REMESA")

	If Trim(strCliente) = "" Then strCliente = session("ses_codcli")
	If Trim(intRemesa) = "" Then intRemesa = ""
%>

<HTML>

<HEAD><TITLE>Menú</TITLE>
<LINK rel="stylesheet" TYPE="text/css" HREF="isk_style.css">
<style type="text/css">
<!--
.Estilo1 {
	color: #0000FF;
	font-size: 16px;
	font-weight: bold;
}
.Estilo2 {
	font-size: 12px;
	color: #0000FF;
}
.Estilo4 {font-size: 9px}
.Estilo5 {color: #FFFFFF; font-weight: bold; font-size: 9px; }
-->
</style>
</HEAD>

<BODY>

<TABLE ALIGN="CENTER" BORDER=1 CELLSPACING=0 CELLPADDING=0 WIDTH="720">
	<TR HEIGHT="20">
		<TD>
			<TABLE ALIGN="CENTER" BORDER=0 CELLSPACING=0 CELLPADDING=0 WIDTH="720">
				<TR HEIGHT="20">
					<TD align="CENTER">
					<span class="Estilo1">ESTATUS GENERAL CLIENTES</span></TD>
				</TR>
				<TR HEIGHT="15">
					<TD align="CENTER">
					<span class="Estilo2">(Montos Expresado en $ MM.)</span></TD>
				</TR>
			</TABLE>
			<br>

			<table width="720 height="175" border="0" align="center">
			<%

			abrirscg()

			intTRutAsignados = 0
			intTMontoAsignados = 0
			intTPagos = 0
			intTConvenios = 0
			intTRetiros = 0
			intTSaldo = 0

			ssql="SELECT CODCLIENTE, NOMBRE_FANTASIA, ISNULL(COD_MONEDA,0) AS COD_MONEDA FROM CLIENTE WHERE CODCLIENTE <> '999' AND ACTIVO = 1 AND CODCLIENTE IN (SELECT CODCLIENTE FROM USUARIO_CLIENTE WHERE ID_USUARIO = " & session("session_idusuario") & ")"
			set rsClientes= Conn.execute(ssql)
			If not rsClientes.eof then
				Do until rsClientes.eof

				strCodMoneda = rsClientes("COD_MONEDA")

				If Trim(strCodMoneda) <> 2 Then
					intValorMoneda = 1
				Else
					intValorMoneda = session("valor_moneda")
				End If

				strSql="SELECT COUNT(DISTINCT RUTDEUDOR) as RA, CAST(ISNULL(SUM(SALDO),0) AS BIGINT) as SALDO, CAST(ISNULL(SUM(VALORCUOTA),0) AS BIGINT) AS ASIGNADO FROM CUOTA WHERE CODCLIENTE = '" & rsClientes("CODCLIENTE") & "'"
				set rsCuota= Conn.execute(strSql)
				If not rsCuota.eof then
					intRutAsignados = Cdbl(rsCuota("RA"))
					intMontoAsignados =  Round(intValorMoneda * ValNulo(rsCuota("ASIGNADO"),"N"),0)
					intSaldo = Cdbl(rsCuota("SALDO"))
				End if

				strSql="SELECT CAST(ISNULL(SUM(VALORCUOTA-SALDO),0) AS BIGINT) AS CONVENIOS FROM CUOTA WHERE CODCLIENTE = '" & rsClientes("CODCLIENTE") & "' AND ESTADO_DEUDA IN (10,11)"
				set rsCuota= Conn.execute(strSql)
				If not rsCuota.eof then
					intConvenios = Round(intValorMoneda * ValNulo(rsCuota("CONVENIOS"),"N"),0)
				Else
					intConvenios = 0
				End If

				strSql="SELECT CAST(ISNULL(SUM(VALORCUOTA-SALDO),0) AS BIGINT) AS RETIROS FROM CUOTA WHERE CODCLIENTE = '" & rsClientes("CODCLIENTE") & "' AND ESTADO_DEUDA IN (2,6)"
				set rsCuota= Conn.execute(strSql)
				If not rsCuota.eof then
					intRetiros = Round(intValorMoneda * ValNulo(rsCuota("RETIROS"),"N"),0)
				Else
					intRetiros = 0
				End If


				strSql="SELECT CAST(ISNULL(SUM(VALORCUOTA-SALDO),0) AS BIGINT) AS PAGOS FROM CUOTA WHERE CODCLIENTE = '" & rsClientes("CODCLIENTE") & "' AND ESTADO_DEUDA IN (3,4,7,8,1)"
				set rsCuota= Conn.execute(strSql)
				If not rsCuota.eof then
					intPagos = Round(intValorMoneda * ValNulo(rsCuota("PAGOS"),"N"),0)
				Else
					intPagos = 0
				End If

				'intRetiros = 0
				'intPagos = 0


			%>
			  	<tr height="35">
					<td width="20" align="center">&nbsp;</td>
					<td width="80" align="center"><b>
					<a href="EstatusClienteAsignacion.asp?strCliente=<%=rsClientes("CODCLIENTE")%>&strNomCliente=<%=rsClientes("NOMBRE_FANTASIA")%>&intGestion=15&intEjecutivo=<%=intEjecutivo%>&intDePPal=1&intRemesa=<%=intRemesa%>"><%=rsClientes("NOMBRE_FANTASIA")%></a>
					</b></td>
					<td width="20" align="center">&nbsp;</td>
					<td width="80" bgcolor="#0000FF" align="center"><span class="Estilo5"><%=FN(intRutAsignados,0)%></span></td>
					<td width="20" align="center">&nbsp;</td>
					<td width="80" bgcolor="#0000FF" align="center"><span class="Estilo5"><%=FN(intMontoAsignados/1000000,0)%></span></td>
					<td width="20" align="center">&nbsp;</td>
					<td width="80" bgcolor="#0000FF" align="center"><span class="Estilo5"><%=FN(intPagos/1000000,0)%></span></td>
					<td width="20" align="center">&nbsp;</td>
					<td width="80" bgcolor="#0000FF" align="center"><span class="Estilo5"><%=FN(intConvenios/1000000,0)%></span></td>
					<td width="20" align="center">&nbsp;</td>
					<td width="80" bgcolor="#0000FF" align="center"><span class="Estilo5"><%=FN(intRetiros/1000000,0)%></span></td>
					<td width="20" align="center">&nbsp;</td>
					<td width="80" bgcolor="#0000FF" align="center"><span class="Estilo5"><%=FN(intSaldo/1000000,0)%></span></td>
				</tr>
				<tr height="35">
					<td align="center"><span class="Estilo4">&nbsp</span></td>
					<td align="center"><span class="Estilo4">&nbsp</span></td>
					<td align="center"><span class="Estilo4">&nbsp</span></td>
					<td align="center"><span class="Estilo4">
						<a href="cartera_clientes.asp?strCliente=<%=rsClientes("CODCLIENTE")%>&intGestion=15&intEjecutivo=<%=intEjecutivo%>&intDePPal=1&intRemesa=<%=intRemesa%>">Rut Asignados</a>
					</td>
					<td align="center"><span class="Estilo4">&nbsp</span></td>
					<td align="center"><span class="Estilo4">
						<a href="cartera_clientes.asp?strCliente=<%=rsClientes("CODCLIENTE")%>&intGestion=15&intEjecutivo=<%=intEjecutivo%>&intDePPal=1&intRemesa=<%=intRemesa%>">Monto Asignado</a>
					</td>

					<td align="center"><span class="Estilo4">&nbsp</span></td>
					<td align="center"><span class="Estilo4">
						Pagos / Abonos
					</td>
					<td align="center"><span class="Estilo4">&nbsp</span></td>
					<td align="center"><span class="Estilo4">
						Convenios
					</td>
					<td align="center"><span class="Estilo4">&nbsp</span></td>
					<td align="center"><span class="Estilo4">
						Retiros / Castigos
					</td>
					<td align="center"><span class="Estilo4">&nbsp</span></td>
						<td align="center"><span class="Estilo4">
						Saldo Activo
					</td>
					<td align="center"><span class="Estilo4">&nbsp</span></td>
				</tr>
			<%

					intTRutAsignados = intTRutAsignados + intRutAsignados
					intTMontoAsignados = intTMontoAsignados + intMontoAsignados
					intTPagos = intTPagos + intPagos
					intTConvenios = intTConvenios + intConvenios
					intTRetiros = intTRetiros + intRetiros
					intTSaldo = intTSaldo + intSaldo


					rsClientes.movenext
				loop
			End if

			rsClientes.close
			set rsClientes=nothing
			%>

			  	<tr height="35">
					<td width="20" align="center">&nbsp;</td>
					<td width="80" align="center"><b>Totales :</b></td>
					<td width="20" align="center">&nbsp;</td>
					<td width="80" bgcolor="#808080" align="center"><span class="Estilo5"><%=FN(intTRutAsignados,0)%></span></td>
					<td width="20" align="center">&nbsp;</td>
					<td width="80" bgcolor="#808080" align="center"><span class="Estilo5"><%=FN(intTMontoAsignados/1000000,0)%></span></td>
					<td width="20" align="center">&nbsp;</td>
					<td width="80" bgcolor="#808080" align="center"><span class="Estilo5"><%=FN(intTPagos/1000000,0)%></span></td>
					<td width="20" align="center">&nbsp;</td>
					<td width="80" bgcolor="#808080" align="center"><span class="Estilo5"><%=FN(intTConvenios/1000000,0)%></span></td>
					<td width="20" align="center">&nbsp;</td>
					<td width="80" bgcolor="#808080" align="center"><span class="Estilo5"><%=FN(intTRetiros/1000000,0)%></span></td>
					<td width="20" align="center">&nbsp;</td>
					<td width="80" bgcolor="#808080" align="center"><span class="Estilo5"><%=FN(intTSaldo/1000000,0)%></span></td>
				</tr>
				<tr height="35">
					<td align="center"><span class="Estilo4">&nbsp</span></td>
					<td align="center"><span class="Estilo4">&nbsp</span></td>
					<td align="center"><span class="Estilo4">&nbsp</span></td>
					<td align="center"><span class="Estilo4">
						Rut Asignados
					</td>
					<td align="center"><span class="Estilo4">&nbsp</span></td>
					<td align="center"><span class="Estilo4">
						Monto Asignado
					</td>
					<td align="center"><span class="Estilo4">&nbsp</span></td>
					<td align="center"><span class="Estilo4">
						Pagos / Abonos
					</td>
					<td align="center"><span class="Estilo4">&nbsp</span></td>
					<td align="center"><span class="Estilo4">
						Convenios
					</td>
					<td align="center"><span class="Estilo4">&nbsp</span></td>
					<td align="center"><span class="Estilo4">
						Retiros / Castigos
					</td>
					<td align="center"><span class="Estilo4">&nbsp</span></td>
					<td align="center"><span class="Estilo4">
						Saldo Activo
					</td>
					<td align="center"><span class="Estilo4">&nbsp</span></td>
				</tr>
			</table>
		</TD>
	</TR>
</TABLE>
<br>

<%

	If Trim(strGrafico)= "" Then strGrafico = "FC2Pie3D"

	ssql="SELECT CODCLIENTE, NOMBRE_FANTASIA, COD_MONEDA FROM CLIENTE WHERE CODCLIENTE <> '999' AND ACTIVO = 1 AND CODCLIENTE IN (SELECT CODCLIENTE FROM USUARIO_CLIENTE WHERE ID_USUARIO = " & session("session_idusuario") & ")"



	set rsClientes= Conn.execute(ssql)
	If not rsClientes.eof then
	Do until rsClientes.eof

		strSql="SELECT COUNT(DISTINCT RUTDEUDOR) as RA, CAST(ISNULL(SUM(SALDO),0) AS BIGINT) as SALDO, CAST(ISNULL(SUM(VALORCUOTA),0) AS BIGINT) AS ASIGNADO FROM CUOTA WHERE CODCLIENTE = '" & rsClientes("CODCLIENTE") & "'"
		set rsCuota= Conn.execute(strSql)
		If not rsCuota.eof then
			intRutAsignados = Cdbl(rsCuota("RA"))
			intMontoAsignados = Cdbl(rsCuota("ASIGNADO"))
			intSaldo = Cdbl(rsCuota("SALDO"))
		End if

		strSql="SELECT CAST(ISNULL(SUM(VALORCUOTA-SALDO),0) AS BIGINT) AS CONVENIOS FROM CUOTA WHERE CODCLIENTE = '" & rsClientes("CODCLIENTE") & "' AND ESTADO_DEUDA IN (10,11)"
		set rsCuota= Conn.execute(strSql)
		If not rsCuota.eof then
			intConvenios = Cdbl(rsCuota("CONVENIOS"))
		Else
			intConvenios = 0
		End If

		strSql="SELECT CAST(ISNULL(SUM(VALORCUOTA-SALDO),0) AS BIGINT) AS RETIROS FROM CUOTA WHERE CODCLIENTE = '" & rsClientes("CODCLIENTE") & "' AND ESTADO_DEUDA IN (2,6)"
		set rsCuota= Conn.execute(strSql)
		If not rsCuota.eof then
			intRetiros = Cdbl(rsCuota("RETIROS"))
		Else
			intRetiros = 0
		End If


		strSql="SELECT CAST(ISNULL(SUM(VALORCUOTA-SALDO),0) AS BIGINT) AS PAGOS FROM CUOTA WHERE CODCLIENTE = '" & rsClientes("CODCLIENTE") & "' AND ESTADO_DEUDA IN (3,4,7,8,1)"
		set rsCuota= Conn.execute(strSql)
		If not rsCuota.eof then
			intPagos = Cdbl(rsCuota("PAGOS"))
		Else
			intPagos = 0
		End If


%>

<TABLE ALIGN="CENTER" BORDER=1 CELLSPACING=0 CELLPADDING=0 WIDTH="720">
		<TR ALIGN="CENTER" VALIGN=middle">
			<TD>
				<OBJECT classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000" codebase="http://download.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=6,0,0,0"WIDTH="750" HEIGHT="450" id=ShockwaveFlash1 VIEWASTEXT>
					<PARAM NAME="FlashVars" value="&dataXML=<graph caption='ESTATUS CLIENTE <%=rsClientes("NOMBRE_FANTASIA")%>' bgColor='FFFFFF' decimalPrecision='2' showPercentageValues='0' showNames='1' numberPrefix='' showValues='1' showPercentageInLabel='1' pieYScale='60' pieBorderAlpha='40' pieFillAlpha='70' pieSliceDepth='20' pieRadius='110' >
					<set value='<%=intPagos%>' name='Pagos' color='#008000'/>
					<set value='<%=intConvenios%>' name='Convenios' color='FFFF00'/>
					<set value='<%=intRetiros%>' name='Retiros - Castigos' color='#0000FF'/>
					<set value='<%=intSaldo%>' name='Deuda Activa' color='#FF0000'/>
					</graph> ">
					<PARAM NAME=movie VALUE="../Graficos/<%=strGrafico%>.swf?chartWidth=750&ChartHeight=525">
					<PARAM NAME=quality VALUE=high>
				</OBJECT>
			</TD>
		</TR>
</TABLE>
<br>


<%
		rsClientes.movenext
		loop
	End If

	cerrarscg()

%>

</BODY>
<script language="JavaScript1.2">
function envia()	{
	if (datos.CB_CLIENTE.value=='0'){
		alert('DEBE SELECCIONAR UN CLIENTE');
	}else{
		datos.action='EstatusClientes.asp';
		datos.submit();
	}
}
</script>
