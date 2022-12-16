<%@ LANGUAGE="VBScript" %>
<!--#include file="sesion.asp"-->
<!--#include file="arch_utils.asp"-->
<!--#include file="../lib/comunes/rutinas/funciones.inc" -->
<!--#include file="asp/comunes/general/rutinasBooleano.inc" -->
<%
	strCliente=Request("strCliente")

	intEjecutivo=Request("CB_EJECUTIVO")
	intRemesa=Request("CB_REMESA")
	strNomCliente=Request("strNomCliente")

	If Trim(strCliente) = "" Then strCliente = session("ses_codcli")
	If Trim(intRemesa) = "" Then intRemesa = ""
%>

<HTML>

<HEAD><TITLE>Men�</TITLE>
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

<TABLE ALIGN="CENTER" BORDER=1 CELLSPACING=0 CELLPADDING=0 WIDTH="600">
	<TR HEIGHT="20">
		<TD>
			<TABLE ALIGN="CENTER" BORDER=0 CELLSPACING=0 CELLPADDING=0 WIDTH="600">
				<TR HEIGHT="20">
					<TD align="CENTER">
					<span class="Estilo1">ESTATUS GENERAL POR CARTERAS <%=strNomCliente%></span></TD>
				</TR>
				<TR HEIGHT="15">
					<TD align="CENTER">
					<span class="Estilo2">(Montos Expresado en $ MM.)</span></TD>
				</TR>
			</TABLE>
			<br>

			<table width="600" height="175" border="0" align="center">

			<tr height="25">
				<td align="center"><span class="Estilo4">&nbsp</span></td>
				<td align="center"><span class="Estilo4">&nbsp</span></td>
				<td align="center"><span class="Estilo4">&nbsp</span></td>
				<td align="center"><span class="Estilo4">
					<a href="cartera_clientes.asp?strCliente=<%=strCliente%>&intGestion=15&intEjecutivo=<%=intEjecutivo%>&intDePPal=1&intRemesa=<%=intRemesa%>">Rut Asignados</a>
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
			<%

			abrirscg()

			If Trim(strGrafico)= "" Then strGrafico = "FC2Pie3D"

			intTRutAsignados = 0
			intTMontoAsignados = 0
			intTPagos = 0
			intTConvenios = 0
			intTRetiros = 0
			intTSaldo = 0


			ssql="SELECT CODREMESA, NOMBRE FROM REMESA WHERE CODCLIENTE = '" & strCliente & "' AND CODREMESA > 100"
			''Response.write "<br>ssql=" & ssql
			set rsAsignacion= Conn.execute(ssql)
				Do until rsAsignacion.eof

					intCodRemesa = rsAsignacion("CODREMESA")

					''Response.write "<br>intCodRemesa=" & intCodRemesa

					strSql="SELECT COUNT(DISTINCT RUTDEUDOR) as RA, CAST(ISNULL(SUM(SALDO),0) AS BIGINT) as SALDO, CAST(ISNULL(SUM(VALORCUOTA),0) AS BIGINT) AS ASIGNADO FROM CUOTA WHERE CODCLIENTE = '" & strCliente & "' AND CODREMESA = " & intCodRemesa
					set rsTemp= Conn.execute(strSql)
					If not rsAsignacion.eof then
						intRutAsignados = Cdbl(rsTemp("RA"))
						intMontoAsignados = Cdbl(rsTemp("ASIGNADO"))
						intSaldo = Cdbl(rsTemp("SALDO"))
					End if

					strSql="SELECT CAST(ISNULL(SUM(VALORCUOTA-SALDO),0) AS BIGINT) AS CONVENIOS FROM CUOTA WHERE CODCLIENTE = '" & strCliente & "' AND CODREMESA = " & intCodRemesa & " AND ESTADO_DEUDA IN (10,11)"
					set rsTemp= Conn.execute(strSql)
					If not rsAsignacion.eof then
						intConvenios = Cdbl(rsTemp("CONVENIOS"))
					Else
						intConvenios = 0
					End If

					strSql="SELECT CAST(ISNULL(SUM(VALORCUOTA-SALDO),0) AS BIGINT) AS RETIROS FROM CUOTA WHERE CODCLIENTE = '" & strCliente & "' AND CODREMESA = " & intCodRemesa & " AND ESTADO_DEUDA IN (2,6)"
					set rsTemp= Conn.execute(strSql)
					If not rsAsignacion.eof then
						intRetiros = Cdbl(rsTemp("RETIROS"))
					Else
						intRetiros = 0
					End If


					strSql="SELECT CAST(ISNULL(SUM(VALORCUOTA-SALDO),0) AS BIGINT) AS PAGOS FROM CUOTA WHERE CODCLIENTE = '" & strCliente & "' AND CODREMESA = " & intCodRemesa & " AND ESTADO_DEUDA IN (3,4,7,8,1)"
					set rsTemp= Conn.execute(strSql)
					If not rsAsignacion.eof then
						intPagos = Cdbl(rsTemp("PAGOS"))
					Else
						intPagos = 0
					End If


			%>
			  	<tr height="25">
					<td width="20" align="center">&nbsp;</td>
					<td width="60" align="center"><b>
					<a href="EstatusClienteAsignacion.asp?strCliente=<%=strCliente%>&intGestion=15&intEjecutivo=<%=intEjecutivo%>&intDePPal=1&intRemesa=<%=intRemesa%>"><%=intCodRemesa%></a>
					</b></td>
					<td width="20" align="center">&nbsp;</td>
					<td width="60" bgcolor="#FF00FF" align="center"><span class="Estilo5"><%=FN(intRutAsignados,0)%></span></td>
					<td width="20" align="center">&nbsp;</td>
					<td width="60" bgcolor="#0000FF" align="center"><span class="Estilo5"><%=FN(intMontoAsignados/1000000,0)%></span></td>
					<td width="20" align="center">&nbsp;</td>
					<td width="60" bgcolor="#0000FF" align="center"><span class="Estilo5"><%=FN(intPagos/1000000,0)%></span></td>
					<td width="20" align="center">&nbsp;</td>
					<td width="60" bgcolor="#0000FF" align="center"><span class="Estilo5"><%=FN(intConvenios/1000000,0)%></span></td>
					<td width="20" align="center">&nbsp;</td>
					<td width="60" bgcolor="#0000FF" align="center"><span class="Estilo5"><%=FN(intRetiros/1000000,0)%></span></td>
					<td width="20" align="center">&nbsp;</td>
					<td width="60" bgcolor="#0000FF" align="center"><span class="Estilo5"><%=FN(intSaldo/1000000,0)%></span></td>
				</tr>


				<tr>
					<td colspan=14>
						<TABLE ALIGN="CENTER" BORDER=1 CELLSPACING=0 CELLPADDING=0 WIDTH="600">
								<TR ALIGN="CENTER" VALIGN=middle">
									<TD>
										<OBJECT classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000" codebase="http://download.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=6,0,0,0"WIDTH="600" HEIGHT="450" id=ShockwaveFlash1 VIEWASTEXT>
											<PARAM NAME="FlashVars" value="&dataXML=<graph caption='ESTATUS CARTERA <%=intCodRemesa%>' bgColor='FFFFFF' decimalPrecision='2' showPercentageValues='0' showNames='1' numberPrefix='' showValues='1' showPercentageInLabel='1' pieYScale='60' pieBorderAlpha='40' pieFillAlpha='70' pieSliceDepth='20' pieRadius='110' >
											<set value='<%=intPagos%>' name='Pagos' color='#008000'/>
											<set value='<%=intConvenios%>' name='Convenios' color='FFFF00'/>
											<set value='<%=intRetiros%>' name='Retiros - Castigos' color='#0000FF'/>
											<set value='<%=intSaldo%>' name='Deuda Activa' color='#FF0000'/>
											</graph> ">
											<PARAM NAME=movie VALUE="../Graficos/<%=strGrafico%>.swf?chartWidth=600&ChartHeight=525">
											<PARAM NAME=quality VALUE=high>
										</OBJECT>
									</TD>
								</TR>
						</TABLE>
					</td>
				</tr>
			<%

					intTRutAsignados = intTRutAsignados + intRutAsignados
					intTMontoAsignados = intTMontoAsignados + intMontoAsignados
					intTPagos = intTPagos + intPagos
					intTConvenios = intTConvenios + intConvenios
					intTRetiros = intTRetiros + intRetiros
					intTSaldo = intTSaldo + intSaldo




					''Response.write "<br>CODREMESA=" & rsAsignacion("CODREMESA")
					''Response.write "<br>Eof1=" & rsAsignacion.Eof

					rsAsignacion.movenext

					''Response.write "<br>Eof2=" & rsAsignacion.Eof
				loop

			rsAsignacion.close
			set rsAsignacion=nothing
			%>

		</table>
		</TD>
	</TR>
</TABLE>
<br>

<%
	cerrarscg()

%>

</BODY>
<script language="JavaScript1.2">
function envia()	{
	if (datos.CB_CLIENTE.value=='0'){
		alert('DEBE SELECCIONAR UN CLIENTE');
	}else{
		datos.action='EstatusClienteAsignacion.asp';
		datos.submit();
	}
}
</script>
