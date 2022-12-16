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
	CB_TIPOPROCESO = request("CB_TIPOPROCESO")

	if Trim(inicio) = "" Then
		inicio = TraeFechaMesActual(Conn,-1)
		inicio = "01" & Mid(inicio,3,10)
		inicio = TraeFechaActual(Conn)
	End If
	if Trim(termino) = "" Then
		termino = TraeFechaActual(Conn)
	End If %>

<html xmlns="http://www.w3.org/1999/xhtml">
<body leftmargin="0" rightmargin="0" marginwidth="0" topmargin="0" marginheight="0">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<LINK rel="stylesheet" TYPE="text/css" HREF="../css/isk_style.css">
<title>CRM RSA</title>
<style type="text/css">
<!--
.Estilo13 {color: #FFFFFF}
.Estilo27 {color: #FFFFFF}
-->
</style>
<script language="JavaScript" src="../lib/comunes/lib/cal_conf2.js"></script>
<script language="JavaScript" src="../lib/comunes/lib/validaciones.js"></script>
<script src="../comunes/general/SelCombox.js"></script>
<script src="../comunes/general/OpenWindow.js"></script>
<script language="JavaScript " type="text/JavaScript">

function buscar()
{
	resp='si'
	document.datos.action = "mi_exportes.asp?resp="+ resp +"";
	document.datos.submit();
}
</script>
</head>
<%

if Request("CB_ASIGNACION") <> "" then
	strAsignacion=Trim(Request("CB_ASIGNACION"))
End if

strTipoProceso=Request("CB_TIPOPROCESO")

if Request("Asignacion")<>"" then
	strAsignacion=Request("Asignacion")
End if

if Request("archivo")<>"" then
	archivo=Request("archivo")
End if

'Response.write "<br>strTipoProceso=" & strTipoProceso
'Response.write "<br>CB_TIPOPROCESO=" & Request("CB_TIPOPROCESO")

	If archivo = "1" Then
			If Trim(strTipoProceso) = "INFORME_DIARIO_CASTIGOS" Then
				Response.Redirect "exp_EstatusCartera.asp?CB_CLIENTE=" + strCliente +"&strTipoProceso=" + strTipoProceso +"&Fecha=" + Fecha +"&CB_ASIGNACION=" + strAsignacion +"&archivo=" + archivo +"&opAc=" + iOpAc
		  	End If
			If Trim(strTipoProceso) = "INFORME_PAGOS_EN_CLIENTE" Then
				Response.Redirect "exp_EstatusCartera_act_extj.asp?CB_CLIENTE=" + strCliente +"&strTipoProceso=" + strTipoProceso +"&Fecha=" + Fecha +"&CB_ASIGNACION=" + strAsignacion +"&archivo=" + archivo +"&opAc=" + iOpAc
		  	End If
	End If %>

<table width="100%" border="0">
	<tr>
		<TD height="20" ALIGN="LEFT" bordercolor="#999999"  bgcolor="#<%=session("COLTABBG")%>" class="Estilo13">
			&nbsp;<B>MODULO INFORMES - REPORTES ESPECIFICOS</B>
		</TD>
	</tr>
	<tr>
		<td valign="top">
			<!-- <form name="frmSend" id="frmSend" onSubmit="return enviar(this)"  method="POST" action="mi_Exportes.asp"> -->
			<form name="datos" id="datos" method="post" action="mi_Exportes.asp">
			<TABLE border="0" cellspacing="0" cellPadding="0">
				<TR>
					<TD>
						<table width="800" border="0" bordercolor = "#<%=session("COLTABBG")%>" align="center" cellpadding="0" cellspacing="0">
							<tr>
								<td valign="top">
									<table width="100%" border="0">
										<tr height="50">
											<td>Tipo Reporte</td>
											<td><select name="CB_TIPOPROCESO">
													<option value="Seleccionar">Seleccionar</option>
													<option value="INFORME_DIARIO_CASTIGOS" <% If CB_TIPOPROCESO = "INFORME_DIARIO_CASTIGOS" Then response.write "Selected"%>>INFORME DIARIO CASTIGOS</option>
													<option value="INFORME_PAGOS_EN_CLIENTE" <% If CB_TIPOPROCESO = "INFORME_PAGOS_EN_CLIENTE" Then response.write "Selected"%>>INFORME PAGOS EN CLIENTE</option>
													<option value="INFORME_RETIROS_EN_CLIENTE" <% If CB_TIPOPROCESO = "INFORME_RETIROS_EN_CLIENTE" Then response.write "Selected"%>>INFORME RETIROS EN CLIENTE</option>
													<!--option value="INFORME_PAGOS_EN_CLIENTE_FORMATO_2" <% If CB_TIPOPROCESO = "INFORME_PAGOS_EN_CLIENTE_FORMATO_2" Then response.write "Selected"%>>INFORME PAGOS EN CLIENTE FORMATO 2</option-->
												</select></td>
											<td>Desde <input name="inicio" type="text" id="inicio" value="<%=inicio%>" size="10" maxlength="10">
											<a href="javascript:showCal('Calendar7');"><img src="../images/calendario.gif" border="0"></a></td>
											<td>Hasta <input name="termino" type="text" id="termino" value="<%=termino%>" size="10" maxlength="10">
											<a href="javascript:showCal('Calendar6');"><img src="../images/calendario.gif" border="0"></a></td>
										</tr>
										<tr height="50">
											<td colspan="4" align="CENTER"><input Name="SubmitButtonBuscar" Value="Buscar" Type="BUTTON" onClick="buscar();">
											<input Name="SubmitButton" Value="Exportar" Type="BUTTON" onClick="enviar();"></td>
										</tr>
									</table>
								</td>
							</tr>
						</table>
					</TD>
				</TR>

				<%	If CB_TIPOPROCESO="INFORME_DIARIO_CASTIGOS" Then %>

				<TR>
					<TD>
						<table width="100%" border="0" bordercolor="#999999" cellpadding="2">
							<tr height="20" bordercolor="#999999"  bgcolor="#<%=session("COLTABBG")%>" class="Estilo13" ALIGN="CENTER">
								<td colspan="6"><B>INFORME DIARIO CASTIGOS</B></td>
							 </tr>
							<tr height="20" bordercolor="#999999"  bgcolor="#<%=session("COLTABBG")%>" class="Estilo13" ALIGN="CENTER">
								<td>RUT</td>
								<td>CUENTA</td>
								<td>CAPITAL</td>
								<td>FECHA PAGO</td>
								<td>COMP. INGRESO</td>
								<td>RUT REBAJA</td>
							 </tr>

							 <%	strSql = " select c.Rutdeudor, d.cuenta, cast(sum(d.capital) as numeric) as capital, convert(char(10),c.fecha_pago,103) as fecha_pago, c.comp_ingreso, '' as Rut_rebaja from dbo.CAJA_WEB_EMP C, dbo.CAJA_WEB_EMP_DETALLE d where c.fecha_pago >= '" & inicio & " 00:00:00' and c.fecha_pago <= '" & termino & " 23:59:59' and tipo_pago = 'CA' and d.id_pago = c.id_pago group by c.Rutdeudor, d.cuenta, c.fecha_pago, c.comp_ingreso order by c.fecha_pago desc, c.Rutdeudor, d.cuenta "

							 'response.write strSql

							 if strSql <> "" Then

								set rsDet=Conn.execute(strSql)

								intSumCapital = 0
								if not rsDet.eof Then

									do while not rsDet.eof

									strRutdeudor = rsDet("Rutdeudor")
									strCuenta = rsDet("cuenta")
									intCapital = rsDet("capital")
									strFechaPago = rsDet("fecha_pago")
									strCompIngreso = rsDet("comp_ingreso")
									strRutRebaja = rsDet("Rut_rebaja")%>

									 <tr bgcolor="#<%=session("COLTABBG2")%>" class="Estilo8">
										<td align="right"><a href="principal.asp?rut=<%=strRutdeudor%>"><%=UCase(strRutdeudor)%></a></td>
										<td align="right"><%=strCuenta%></td>
										<td align="right">$ <%=FormatNumber(intCapital,0)%></td>
										<td align="right"><%=strFechaPago%></td>
										<td align="right"><%=strCompIngreso%></td>
										<td align="right"><%=strRutRebaja%></td>
									 </tr>

								<%	intSumCapital = CLng(intSumCapital) + CLng(intCapital)
									rsDet.movenext
									Loop
									rsDet.close()
								end If
							end If %>

									<tr bgcolor="#<%=session("COLTABBG2")%>" class="Estilo8">
										<td colspan="2">&nbsp;TOTAL</td>
										<td align="right">$ <%=FormatNumber(intSumCapital,0)%></td>
										<td colspan="3">&nbsp;</td>
									</tr>
						</table>
					</TD>
				</TR>

				<% End If

				If CB_TIPOPROCESO="INFORME_PAGOS_EN_CLIENTE" Then %>

				<TR>
					<TD>
						<table width="100%" border="0" bordercolor="#999999" cellpadding="2">
							<tr height="20" bordercolor="#999999"  bgcolor="#<%=session("COLTABBG")%>" class="Estilo13" ALIGN="CENTER">
								<td colspan="6"><B>INFORME PAGOS EN CLIENTE</B></td>
							 </tr>
							<tr height="20" bordercolor="#999999"  bgcolor="#<%=session("COLTABBG")%>" class="Estilo13" ALIGN="CENTER">
								<td>RUT</td>
								<td>ROL</td>
								<td>JPL</td>
								<td>ESTADO ANTIGUO</td>
								<td>ESTADO NUEVO</td>
								<td>CAPITAL</td>
							 </tr>

							 <%	strSql = "select distinct c.rutdeudor, d.rolano, t.nomtribunal, '' as ESTADO_ANTIGUO, dbo.fun_trae_ultestjud_cliente('1000',c.rutdeudor,'GESTION') as ESTADO_NUEVO, cast(sum(c.valorcuota) as numeric) as capital from cuota C left join dbo.DEMANDA d on d.codcliente = 1000 and c.rutdeudor = d.rutdeudor left join dbo.TRIBUNAL t on t.idtribunal = d.idtribunal where c.codcliente = '1000' and c.fecha_estado >= '" & inicio & " 00:00:00' and c.fecha_estado <= '" & termino & " 23:59:59' and c.estado_deuda = '3' GROUP BY c.rutdeudor, d.rolano, t.nomtribunal order by c.rutdeudor "

							 'RESPONSE.WRITE "strSql= " & strSql

							 if strSql <> "" Then

								set rsDet=Conn.execute(strSql)

								intSumCapital = 0
								if not rsDet.eof Then

									do while not rsDet.eof

									strRutdeudor = rsDet("rutdeudor")
									strRol = rsDet("rolano")
									strJPL = rsDet("nomtribunal")
									strEstadoAntiguo = rsDet("ESTADO_ANTIGUO")
									strEstadoNuevo = rsDet("ESTADO_NUEVO")
									intCapital = rsDet("capital") %>

									 <tr bgcolor="#<%=session("COLTABBG2")%>" class="Estilo8">
										<td align="right"><a href="principal.asp?rut=<%=strRutdeudor%>"><%=UCase(strRutdeudor)%></a></td>
										<td align="right"><%=strRol%></td>
										<td><%=strJPL%></td>
										<td><%=strEstadoAntiguo%></td>
										<td><%=strEstadoNuevo%></td>
										<td align="right">$ <%=FormatNumber(intCapital,0)%></td>
									 </tr>

								<%	intSumCapital = CLng(intSumCapital) + CLng(intCapital)
									rsDet.movenext
									Loop
									rsDet.close() %>

									<tr bgcolor="#<%=session("COLTABBG2")%>" class="Estilo8">
										<td colspan="5">&nbsp;TOTAL</td>
										<td align="right">$ <%=FormatNumber(intSumCapital,0)%></td>
									</tr>

							<%	Else %>

									<tr bgcolor="#<%=session("COLTABBG2")%>" class="Estilo8">
										<td colspan="6" align="center"><B>NO SE ENCONTRARON REGISTRO PARA SU CONSULTA</B></td>
									</tr>

							<%	end If
							end If %>

						</table>
					</TD>
				</TR>

				<% End If

				If CB_TIPOPROCESO="INFORME_RETIROS_EN_CLIENTE" Then %>

				<TR>
					<TD>
						<table width="100%" border="0" bordercolor="#999999" cellpadding="2">
							<tr height="20" bordercolor="#999999"  bgcolor="#<%=session("COLTABBG")%>" class="Estilo13" ALIGN="CENTER">
								<td colspan="6"><B>INFORME RETIROS EN CLIENTE</B></td>
							 </tr>
							<tr height="20" bordercolor="#999999"  bgcolor="#<%=session("COLTABBG")%>" class="Estilo13" ALIGN="CENTER">
								<td>RUT</td>
								<td>ROL</td>
								<td>JPL</td>
								<td>ESTADO ANTIGUO</td>
								<td>ESTADO NUEVO</td>
								<td>CAPITAL</td>
							 </tr>

							 <%

							 strSql = " select distinct c.rutdeudor, d.rolano, t.nomtribunal, '' as ESTADO_ANTIGUO, dbo.fun_trae_ultestjud_cliente('1000',c.rutdeudor,'GESTION') as ESTADO_NUEVO, cast(sum(c.valorcuota) as numeric) as capital from cuota C left join dbo.DEMANDA d on d.codcliente = 1000 and c.rutdeudor = d.rutdeudor left join dbo.TRIBUNAL t on t.idtribunal = d.idtribunal where c.codcliente = '1000' and c.fecha_estado >= '" & inicio & " 00:00:00' and c.fecha_estado <= '" & termino & " 23:59:59' and c.estado_deuda = '2' GROUP BY c.rutdeudor, d.rolano, t.nomtribunal order by c.rutdeudor "

							 'RESPONSE.WRITE "strSql= " & strSql

							 if strSql <> "" Then

								set rsDet=Conn.execute(strSql)

								intSumCapital = 0
								if not rsDet.eof Then

									do while not rsDet.eof

									strRutdeudor = rsDet("rutdeudor")
									strRol = rsDet("rolano")
									strJPL = rsDet("nomtribunal")
									strEstadoAntiguo = rsDet("ESTADO_ANTIGUO")
									strEstadoNuevo = rsDet("ESTADO_NUEVO")
									intCapital = rsDet("capital") %>

									 <tr bgcolor="#<%=session("COLTABBG2")%>" class="Estilo8">
										<td align="right"><a href="principal.asp?rut=<%=strRutdeudor%>"><%=UCase(strRutdeudor)%></a></td>
										<td align="right"><%=strRol%></td>
										<td><%=strJPL%></td>
										<td><%=strEstadoAntiguo%></td>
										<td><%=strEstadoNuevo%></td>
										<td align="right">$ <%=FormatNumber(intCapital,0)%></td>
									 </tr>

								<%	intSumCapital = CLng(intSumCapital) + CLng(intCapital)
									rsDet.movenext
									Loop
									rsDet.close() %>

									<!-- <tr bgcolor="#<%=session("COLTABBG2")%>" class="Estilo8">
										<td colspan="5">&nbsp;TOTAL</td>
										<td align="right">$ <%=FormatNumber(intSumCapital,0)%></td>
									</tr> -->

							<%	Else %>

									<tr bgcolor="#<%=session("COLTABBG2")%>" class="Estilo8">
										<td colspan="6" align="center"><B>NO SE ENCONTRARON REGISTRO PARA SU CONSULTA</B></td>
									</tr>

							<%	end If
							end If %>

						</table>
					</TD>
				</TR>

				<% End If%>
				<TR>
					<TD>&nbsp;</TD>
				</TR>
			</table>
			</FORM>
		</td>
	</tr>
</table>

<script language="JavaScript1.2">

function buscar(){
		if(document.datos.CB_TIPOPROCESO.value =='Seleccionar'){
			alert('Debe Seleccionar el Tipo de Reporte');
			return false;
		}
		else{
			datos.action = "mi_Exportes.asp?archivo=0&CB_TIPOPROCESO=" + document.datos.CB_TIPOPROCESO.value;
			datos.submit();
		}
}

function enviar(){
		if(document.datos.CB_TIPOPROCESO.value =='Seleccionar'){
			alert('Debe Seleccionar el Tipo de Reporte');
			return false;
		}
		else if(document.datos.CB_TIPOPROCESO.value =='INFORME_DIARIO_CASTIGOS'){
			alert('Reporte en Desarrollo');
			return false;
		}
		else if(document.datos.CB_TIPOPROCESO.value =='INFORME_PAGOS_EN_CLIENTE'){
			alert('Reporte en Desarrollo');
			return false;
		}
		else if(document.datos.CB_TIPOPROCESO.value =='INFORME_RETIROS_EN_CLIENTE'){
			alert('Reporte en Desarrollo');
			return false;
		}else if(document.datos.CB_TIPOPROCESO.value =='INFORME_PAGOS_EN_CLIENTE_FORMATO_2'){
			alert('Reporte en Desarrollo');
			return false;
		}else{
			datos.action = "mi_Exportes.asp?archivo=1&CB_TIPOPROCESO=" + document.datos.CB_TIPOPROCESO.value;
			datos.submit();
		}
}
</script>
</body>
</html>
