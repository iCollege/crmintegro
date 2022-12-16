<% @LCID = 1034 %>
<!--#include file="arch_utils.asp"-->
<!--#include file="lib.asp"-->
<!--#include file="sesion.asp"-->
<!--#include file="../lib/comunes/rutinas/funciones.inc" -->
<!--#include file="asp/comunes/general/rutinasSCG.inc" -->
<!--#include file="asp/comunes/general/rutinasBooleano.inc"-->
<%



	rut = request("rut")
	'response.write(rut)
	strRutDeudor=rut
	id_convenio=request("id_convenio")
	strProceso=request("strProceso")
	strObsEstado=request("TX_OBSERVACION")
	AbrirScg()
	If Trim(strProceso) <> "" Then
		strSql = "UPDATE CONVENIO_ENC SET COD_ESTADO_FOLIO = " & strProceso & ", OBS_ESTADO = '" & strObsEstado & "' WHERE ID_CONVENIO = " & id_convenio
		set rsPago=Conn.execute(strSql)
	End If
	CerrarScg()



%>
<title>Empresa</title>
<style type="text/css">
<!--
.Estilo13 {color: #FFFFFF}
.Estilo27 {color: #FFFFFF}
.Estilo28 {color: #FF0000}
-->
</style>

<script language="JavaScript " type="text/JavaScript">

function Grabar(intIdConvenio,intIdEstado)
{
	//alert(intIdEstado);
	if ( intIdEstado == '3' )
	{
		if (confirm("¿ Está seguro de confirmar el <%=session("NOMBRE_CONV_PAGARE")%> ?"))
			{
				datos.action = "det_convenio.asp?strProceso=" + intIdEstado + " &id_convenio=" + intIdConvenio;
				datos.submit();
			}
	}

	if (intIdEstado == '4' )
	{
		if(datos.TX_OBSERVACION.value=='')
			{
				alert('Debe ingresar en observación el motivo de la anulación');
				datos.TX_OBSERVACION.focus();
				return;
			}
		if (confirm("¿ Está seguro de anular el <%=session("NOMBRE_CONV_PAGARE")%>, este proceso reversará el <%=session("NOMBRE_CONV_PAGARE")%> y volverá la deuda a su estado original ?"))
			{
				datos.action = "det_convenio.asp?strProceso=" + intIdEstado + " &id_convenio=" + intIdConvenio;
				datos.submit();
			}
	}
}
</script>

<script language="JavaScript" src="../../comunes/lib/cal2.js"></script>
<script language="JavaScript" src="../../comunes/lib/cal_conf2.js"></script>
<script language="JavaScript" src="../../comunes/lib/validaciones.js"></script>
<script src="../../comunes/general/SelCombox.js"></script>
<script src="../../comunes/general/OpenWindow.js"></script>


  <%
	  	AbrirScg()
		strSql = "SELECT FOLIO,NOM_ESTADO_FOLIO,CWC.ID_CONVENIO, CC.CODCLIENTE, CC.DESCRIPCION, CONVERT(VARCHAR(10),CWC.FECHAINGRESO, 103) AS FECHAINGRESO,CWC.RUTDEUDOR, ISNULL(CWC.TOTAL_CONVENIO,0) AS TOTAL_CONVENIO,ISNULL(CWC.CAPITAL,0) AS CAPITAL,ISNULL(CWC.INTERESES,0) AS INTERESES,ISNULL(CWC.GASTOS,0) AS GASTOS, ISNULL(CWC.HONORARIOS,0) AS HONORARIOS "
		strSql = strSql & ", ISNULL(CWC.DESC_CAPITAL,0) AS DESC_CAPITAL, ISNULL(CWC.DESC_INTERESES,0) AS DESC_INTERESES,ISNULL(CWC.DESC_GASTOS,0) AS DESC_GASTOS, ISNULL(CWC.DESC_HONORARIOS,0) AS DESC_HONORARIOS, PIE, CUOTAS, DIA_PAGO, OBSERVACIONES, OBS_ESTADO "
		strSql = strSql & " FROM CONVENIO_ENC CWC, CLIENTE CC , ESTADO_FOLIO EF WHERE CC.CODCLIENTE =CWC.COD_CLIENTE AND CWC.COD_ESTADO_FOLIO = EF.COD_ESTADO_FOLIO AND ID_CONVENIO=" & id_convenio & ""
		''Response.write "strSql = " & strSql

		set rsDet=Conn.execute(strSql)
		if not rsDet.eof then
			strFecha = rsDet("FECHAINGRESO")
			strNomCliente = rsDet("DESCRIPCION")
			strRutDeudor = rsDet("RUTDEUDOR")
			cliente = rsDet("CODCLIENTE")
			intTotalConvenio = ValNulo(rsDet("TOTAL_CONVENIO"),"N")
			intCapital = ValNulo(rsDet("CAPITAL"),"N")
			intIndemComp = ValNulo(rsDet("INTERESES"),"N")
			intGastos = ValNulo(rsDet("GASTOS"),"N")
			intHonorarios = ValNulo(rsDet("HONORARIOS"),"N")

			intTotalDeuda = intCapital + intIndemComp + intGastos + intHonorarios

			intDescCapital = ValNulo(rsDet("DESC_CAPITAL"),"N")
			intDescIndemComp = ValNulo(rsDet("DESC_INTERESES"),"N")
			intDescGastos = ValNulo(rsDet("DESC_GASTOS"),"N")
			intDescHonorarios = ValNulo(rsDet("DESC_HONORARIOS"),"N")

			intTotalDescuentos = intDescCapital + intDescIndemComp + intDescGastos + intDescHonorarios

			intPie = ValNulo(rsDet("PIE"),"C")

			strEstadoConvenio = ValNulo(rsDet("NOM_ESTADO_FOLIO"),"C")
			strObservacionEstado = ValNulo(rsDet("OBS_ESTADO"),"C")


			observaciones = rsDet("observaciones")

		end if


	 if strRutDeudor <> "" then

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
		<td height="20" bordercolor="#999999"  bgcolor="#<%=session("COLTABBG")%>" class="Estilo13" align="center">DETALLE DE <%=UCASE(session("NOMBRE_CONV_PAGARE"))%> NRO. <%=id_convenio%></td>
	</tr>
	<tr>
		<td height="20" bordercolor="#999999"  bgcolor="#<%=session("COLTABBG")%>" class="Estilo27"><strong>Antecedentes de Ubicabilidad</strong></td>
	</tr>
	<tr>
		<td valign="top">
			<table width="100%" border="0" bordercolor="#FFFFFF">
				<tr bgcolor="#<%=session("COLTABBG2")%>" class="Estilo8">
					<td ALIGN="LEFT">RUT : <%=strRutDeudor%></td>
					<td ALIGN="LEFT">NOMBRE : <%=strNombreDeudor%></td>
					<td ALIGN="LEFT">FECHA: <%=date%></td>
					<td ALIGN="LEFT">USUARIO : <%=session("nombre_user")%></td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td bordercolor="#999999"  bgcolor="#<%=session("COLTABBG")%>">
			<font class="Estilo27"><strong>&nbsp;Resumen <%=session("NOMBRE_CONV_PAGARE")%></strong></font>
		</td>
	</tr>
	<form name="datos" method="post">
	<tr>
		<td>
			<table width="100%" border="0">
				<tr bordercolor="#999999"  bgcolor="#<%=session("COLTABBG")%>">
					<td><span class="Estilo27">MANDANTE</span></td>
					<td><span class="Estilo27">FECHA <%=UCASE(session("NOMBRE_CONV_PAGARE"))%></span></td>
					<td><span class="Estilo27">N° <%=UCASE(session("NOMBRE_CONV_PAGARE"))%></span></td>
					<td><span class="Estilo27">ESTADO</span></td>
					<td><span class="Estilo27">&nbsp;</span></td>
				</tr>
				<tr bgcolor="#<%=session("COLTABBG2")%>" class="Estilo8">
					<td><%=strNomCliente%></td>
					<td><%=strFecha%></td>
					<td><%=id_convenio%></td>
					<td><%=strEstadoConvenio%></td>
					<td class="Estilo28" align="CENTER"
						<acronym title="Modificar estado convenio">
							<input name="BT_GRABAR" type="button" onClick="Grabar(<%=id_convenio%>,3);" value="Confirmar">
						</acronym>
						<acronym title="Modificar estado convenio">
							<input name="BT_GRABAR" type="button" onClick="Grabar(<%=id_convenio%>,4);" value="Anular">
						</acronym>
					</td>
				</tr>
				<tr bgcolor="#<%=session("COLTABBG2")%>" class="Estilo8">
					<td>Observacion</td>
					<td colspan="4"><INPUT TYPE="text" NAME="TX_OBSERVACION" size="126" value="<%=strObservacionEstado%>"></td>
				</tr>
			</table>
		</td>
	</tr>
	<form>
	<tr>
		<td>
			<TABLE WIDTH="100%" ALIGN="CENTER" BORDER=1 CELLSPACING=0 CELLPADDING=0 bordercolor="#000000">
				<TR>
					<TD>
						<TABLE ALIGN="CENTER" WIDTH="300" BORDER="0">
							<TR HEIGHT=30>
								<TD COLSPAN=2 ALIGN="CENTER" class="Estilo38">
									MONTO DE DEUDA
								</TD>
							</TR>
							<TR HEIGHT=30>
								<TD ALIGN="RIGHT" class="Estilo38">Capital: </TD>
								<TD align="right" class="Estilo38"><strong><span class=Estilo1><strong>$ <%=FN(intCapital,0)%></strong></span></strong></TD>
							</TR>
							<TR HEIGHT=30>
								<TD align="right" class="Estilo38"> IndemComp: </TD>
								<TD align="right" class="Estilo38"><strong><span class=Estilo1><strong>$ <%=FN(intIndemComp,0)%></strong></span></strong></TD>
							</TR>
							<TR HEIGHT=30>
								<TD align="right" class="Estilo38">Gastos: </TD>
								<TD align="right" class="Estilo38"><strong><span class=Estilo1><strong>$ <%=FN(intGastos,0)%></strong></span></strong></TD>
							</TR>
							<TR HEIGHT=30>
								<TD align="right" class="Estilo38">Otros: </TD>
								<TD align="right" class="Estilo38"><strong><span class=Estilo1><strong>$ <%=FN(intHonorarios,0)%></strong></span></strong></TD>
							</TR>
							<TR HEIGHT=30>
								<TD>&nbsp</TD>
								<TD align="right">______________</TD>
							</TR>
							<TR HEIGHT=30>
								<TD align="right" class="Estilo38"><b>Total Deuda:</b></TD>
								<TD align="right" class="Estilo38"><strong><span class=Estilo1><strong>$ <%=FN(intTotalDeuda,0)%></strong></span></strong></TD>
							</TR>
							<TR HEIGHT=30>
								<TD>&nbsp</TD>
								<TD>&nbsp</TD>
							</TR>
						</TABLE>

					</TD>
					<TD>
						<TABLE ALIGN="CENTER" WIDTH="300" BORDER="0">
							<TR HEIGHT=30>
								<TD COLSPAN=2 ALIGN="CENTER" class="Estilo38">DESCUENTOS</TD>
							</TR>
							<TR HEIGHT=30>
								<TD ALIGN="RIGHT" class="Estilo38">Capital:</TD>
								<TD align="right" class="Estilo38"><strong><span class=Estilo1><strong>$ <%=FN(intDescCapital,0)%></strong></span></strong></TD>
							</TR>
							<TR HEIGHT=30>
								<TD ALIGN="RIGHT" class="Estilo38"> Indemnizacion:</TD>
								<TD align="right" class="Estilo38"><strong><span class=Estilo1><strong>$ <%=FN(intDescIndemComp,0)%></strong></span></strong></TD>
							</TR>
							<TR HEIGHT=30>
								<TD align="right" class="Estilo38"> Gastos:</TD>
								<TD align="right" class="Estilo38"><strong><span class=Estilo1><strong>$ <%=FN(intDescGastos,0)%></strong></span></strong></TD>
							</TR>
							<TR HEIGHT=30>
								<TD align="right" class="Estilo38"> Otros:</TD>
								<TD align="right" class="Estilo38"><strong><span class=Estilo1><strong>$ <%=FN(intDescHonorarios,0)%></strong></span></strong></TD>
							</TR>
							<TR HEIGHT=30>
								<TD>&nbsp</TD>
								<TD align="right">______________</TD>
							</TR>
							<TR HEIGHT=30>
								<TD align="right" class="Estilo38"><b>Total Descuentos: <b></TD>
								<TD align="right" class="Estilo38"><strong><span class=Estilo1><strong>$ <%=FN(intTotalDescuentos,0)%></strong></span></strong></TD>
							</TR>
							<TR HEIGHT=30>
								<TD align="right" class="Estilo38"><b>Total <%=session("NOMBRE_CONV_PAGARE")%>: <b></TD>
								<TD align="right" class="Estilo38"><strong><span class=Estilo1><strong>$ <%=FN(intTotalConvenio,0)%></strong></span></strong></TD>
							</TR>
						</TABLE>
					</TD>
				</TR>
			</TABLE>
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
			<font class="Estilo27"><strong>&nbsp;Detalle Cuotas <%=session("NOMBRE_CONV_PAGARE")%></strong></font>
		</td>
	</tr>
	<tr>
		<td>
		 <table width="100%" border="0">
			<tr bordercolor="#999999"  bgcolor="#<%=session("COLTABBG")%>">
				<td><span class="Estilo27">Nro. Cuota</span></td>
				<td><span class="Estilo27">Monto Cuota</span></td>
				<td><span class="Estilo27">Fecha Venc.</span></td>
				<td><span class="Estilo27">Fecha Pago</span></td>
				<td><span class="Estilo27">Pagada</span></td>
				<td><span class="Estilo27">Tipo Aseg.</span></td>
				<td><span class="Estilo27">&nbsp;</span></td>
			</tr>
			<!--tr bgcolor="#<%=session("COLTABBG2")%>" class="Estilo8">
				<td align="RIGHT">PIE</td>
				<td align="RIGHT"><%=fn(intPie,0)%></td>
				<td align="RIGHT"><%=strFecha%></td>
			</tr-->

			<%
			'sql="SELECT CUOTA,TOTAL_CUOTA,CONVERT(VARCHAR(10),FECHA_DEL_PAGO,103) as FECHA_DEL_PAGO,CONVERT(VARCHAR(10),FECHA_PAGO,103) as FECHA_PAGO,ISNULL(PAGADA,'N') as PAGADA FROM CONVENIO_DET WHERE ID_CONVENIO = " & id_convenio & " ORDER BY CUOTA"
			sql="SELECT D.CUOTA,D.TOTAL_CUOTA,CONVERT(VARCHAR(10),D.FECHA_DEL_PAGO,103) as FECHA_DEL_PAGO,CONVERT(VARCHAR(10),D.FECHA_PAGO,103) as FECHA_PAGO,ISNULL(D.PAGADA,'N') as PAGADA, D.ID_TIPOASEG FROM CONVENIO_DET D WHERE D.ID_CONVENIO = " & id_convenio & " ORDER BY CUOTA"
			'Response.write sql
			'Response.End
			set rsDetConv=Conn.execute(SQL)
			if not rsDetConv.eof then
				do while not rsDetConv.eof
					intNroCuota = rsDetConv("CUOTA")
					intMontoCuota = rsDetConv("TOTAL_CUOTA")
					dtmFechaPago = rsDetConv("FECHA_PAGO")
					dtmFechaEnQuePago = rsDetConv("FECHA_DEL_PAGO")
					idTipoAseg = rsDetConv("ID_TIPOASEG")
					'strNomTipoAseg = rsDetConv("DESCRIPCION")


					If Trim(intNroCuota) = "0" Then
						intNroCuota = "PIE"
					End If
					strPagada = rsDetConv("PAGADA")
					%>
					<tr bgcolor="#<%=session("COLTABBG2")%>" class="Estilo8">
						<td align="RIGHT"><%=intNroCuota%></td>
						<td align="RIGHT"><%=fn(intMontoCuota,0)%></td>
						<td align="RIGHT"><%=dtmFechaPago%></td>
						<td align="RIGHT"><%=dtmFechaEnQuePago%></td>
						<td align="RIGHT"><%=strPagada%></td>
						<td align="RIGHT"><%=idTipoAseg%></td>
						<td align="RIGHT">
						<%If Trim(strPagada) =  "N" AND TraeSiNo(session("perfil_emp")) <> "Si" AND TraeSiNo(session("perfil_caja")) = "Si" Then %>

						<A HREF="caja_web.asp?CB_TIPOPAGO=CO&id_convenio=<%=rsDet("ID_CONVENIO")%>&rut=<%=rsDet("RUTDEUDOR")%>"><acronym title="PAGO DE CUOTAS DEL CONVENIO">Pagar Cuota</acronym></A>
						<%End If%>
						</td>
					</tr>
					<%
					rsDetConv.movenext
				loop
			end if
			%>
			<tr>
			</tr>
		</table>
		</td>
	</tr>
	<% CerrarScg()%>
  </table>


