<% @LCID = 1034 %>
<!--#include file="arch_utils.asp"-->
<!--#include file="sesion.asp"-->
<!--#include file="../lib/comunes/rutinas/funciones.inc" -->
<!--#include file="../lib/comunes/rutinas/TraeCampo.inc" -->
<!--#include file="asp/comunes/general/rutinasSCG.inc" -->

<%

	intIdConvenio = Request("intIdConvenio")

	If Trim(Request("TX_RUT")) = "" Then
		strRutDeudor = session("session_rutdeudor")
	Else
		strRutDeudor = Trim(Request("TX_RUT"))
		session("session_rutdeudor") = strRutDeudor
	End If

	intCliente = session("ses_codcli")

	intPorcDescCapital = ValNulo(Request("capital"),"N")
	intPorcDescIndemComp = ValNulo(Request("indemComp"),"N")
	intPorcDescHonorarios = ValNulo(Request("honorarios"),"N")
	intPorcDescGastos = ValNulo(Request("gastos"),"N")

	intPie = Request("pie")
	intCuotas = Request("cuotas")
	intDiaDePago = Request("TX_DIAPAGO")

	''intTotDeudaCapital = Round(ValNulo(Request("hdintCapital"),"N"),0)
	intTotDeudaCapital = Round(ValNulo(Request("TX_CAPITAL"),"N"),0)
	intTotIndemComp = Round(ValNulo(Request("hdintIndemComp"),"N"),0)
	intTotHonorarios = Round(ValNulo(Request("hdintHonorarios"),"N"),0)
	intTotGastos = Round(ValNulo(Request("hdintGastos"),"N"),0)

	'intTotalDeuda = intTotDeudaCapital + intTotIndemComp + intTotHonorarios + intTotGastos

	intTotalDeuda = intTotDeudaCapital + intTotGastos

	'intDescCapital = Round(intTotDeudaCapital * intPorcDescCapital / 100,0)
	'intDescIndemComp = Round(intTotIndemComp * intPorcDescIndemComp / 100,0)
	'intDescHonorarios = Round(intTotHonorarios * intPorcDescHonorarios / 100,0)
	'intDescGastos = Round(intTotGastos * intPorcDescGastos / 100,0)

	intDescCapital = Round(intPorcDescCapital,0)
	intDescIndemComp = Round(intPorcDescIndemComp,0)
	intDescHonorarios = Round(intPorcDescHonorarios,0)
	intDescGastos = Round(intPorcDescGastos,0)

	intTotalDescuentos = intDescCapital + intDescIndemComp + intDescHonorarios + intDescGastos
	'intTotalDescuentos = intDescCapital + intDescGastos

	intTotalConvenio = intTotalDeuda - intTotalDescuentos

	'intTotDeudaCapital = Round(intTotDeudaCapital - intDescCapital,0)
	'intTotIndemComp = Round(intTotIndemComp - intDescIndemComp,0)
	'intTotHonorarios = Round(intTotHonorarios - intDescHonorarios,0)
	'intTotGastos = Round(intTotGastos - intDescGastos,0)


	AbrirSCG()

	strSql=""
	strSql="SELECT TASA_MAX_CONV, DESCRIPCION, TIPO_INTERES FROM CLIENTE WHERE CODCLIENTE ='" & intCliente & "'"
	set rsTasa=Conn.execute(strSql)
	if not rsTasa.eof then
		intTasaMax = rsTasa("TASA_MAX_CONV")
		strDescripcion = rsTasa("DESCRIPCION")
		strTipoInteres = rsTasa("TIPO_INTERES")
	Else
		intTasaMax = 1
		strDescripcion = ""
		strTipoInteres = ""
	end if
	rsTasa.close
	set rsTasa=nothing


%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>Documento sin t&iacute;tulo</title>
<style type="text/css">
<!--
.Estilo1 {font-size: 14px;font-weight: bold;}
.Estilo13 {font-family: Verdana, Arial, Helvetica, sans-serif; font-size: 10px; }
.Estilo2 {font-size: 11px; font-family: Verdana, Arial, Helvetica, sans-serif;}
.Estilo5 {font-size: 11px; font-weight: bold;}
.Estilo8 {font-size: 11px}
.Estilo9 {font-size: 11px; font-family: Verdana, Arial, Helvetica, sans-serif; font-weight: bold; }
.Estilo12 {font-family: Verdana, Arial, Helvetica, sans-serif; font-size: 12px; font-weight: bold; }
.Estilo14 {font-size: 10px}
.Estilo15 {font-family: Verdana, Arial, Helvetica, sans-serif; font-size: 10px; font-weight: bold; }
.Estilo26 {font-size: 12px}
.Estilo28 {font-family: "Courier New", Courier, monospace}
.Estilo32 {font-size: 13px}
.Estilo22 {font-size: 13px; font-family: "Courier New", Courier, monospace;}
.Estilo36 {font-family: Verdana, Arial, Helvetica, sans-serif;font-weight: bold;}
.Estilo37 {font-family: Verdana, Arial, Helvetica, sans-serif; }
.Estilo38 {font-size: 13px; font-family: Verdana, Arial, Helvetica, sans-serif; }
.Estilo40 {	font-family: Verdana, Arial, Helvetica, sans-serif;	color: #FF0000;	font-size: 11px;font-weight: bold;}
.Estilo41 {color: #FFFFFF}
.Estilo33 {font-family: Verdana, Arial, Helvetica, sans-serif;font-size: 14px}
.Estilo34 {font-family: Verdana, Arial, Helvetica, sans-serif;font-size: 11px}

H1.SaltoDePagina {PAGE-BREAK-AFTER: always}
	.transpa {
	background-color: transparent;
	border: 1px solid #FFFFFF;
	text-align:center
	}
-->

</style>

</head>

<script language="JavaScript " type="text/JavaScript">

function Grabar()
{
	if (confirm("¿ Está seguro de grabar el convenio ? Si aun no lo ha imprimido, presione cancelar y luego el botón imprimir."))
		{
			datos.action = "grabar_convenio.asp";
			datos.submit();
		}
}
</script>


<BODY>


<INPUT TYPE="hidden" NAME="strCodCliente" value="<%=intCliente%>">
<INPUT TYPE="hidden" NAME="strRutDeudor" value="<%=strRutDeudor%>">
<INPUT TYPE="hidden" NAME="intTotalConvenio" value="<%=intTotalConvenio%>">
<INPUT TYPE="hidden" NAME="intTotalCapital" value="<%=intTotDeudaCapital%>">
<INPUT TYPE="hidden" NAME="intIndemComp" value="<%=intTotIndemComp%>">
<INPUT TYPE="hidden" NAME="intGastos" value="<%=intTotGastos%>">
<INPUT TYPE="hidden" NAME="intHonorarios" value="<%=intTotHonorarios%>">
<INPUT TYPE="hidden" NAME="intDescTotalCapital" value="<%=intDescCapital%>">
<INPUT TYPE="hidden" NAME="intDescIndemComp" value="<%=intDescIndemComp%>">
<INPUT TYPE="hidden" NAME="intDescGastos" value="<%=intDescGastos%>">
<INPUT TYPE="hidden" NAME="intDescHonorarios" value="<%=intDescHonorarios%>">
<INPUT TYPE="hidden" NAME="intPie" value="<%=intPie%>">
<INPUT TYPE="hidden" NAME="intCuotas" value="<%=intCuotas%>">
<INPUT TYPE="hidden" NAME="intDiaPago" value="<%=intDiaDePago%>">
<INPUT TYPE="hidden" NAME="strObservaciones" value="<%=strObservaciones%>">


<TABLE ALIGN="CENTER" WIDTH="600" BORDER="1" BORDERCOLOR = "#000000" CELLSPACING=0 CELLPADDING=1>

		<TR>
		 	<TD>
				<table width="600" border="0">
					<tr>
					  <td width="135" class="Estilo13"><p>LLACRUZ</p></td>
					  <td width="277" class="Estilo13"><p>Huelen 164 Oficina 301, Providencia</p></td>
					  <td width="174" class="Estilo13">Fecha: <%=Now%></td>
					</tr>
					<tr>
					  <td class="Estilo13"><p>Rut 76.000.947-4 </p></td>
					  <td class="Estilo13"><p>Fonos: (02) 697 15 62&nbsp; (02) 672 66 29</p></td>
					  <td class="Estilo13">&nbsp;</td>
					</tr>
				</table>
  			</TD>
 		</TR>

 		<TR>
		 	<TD>

		 		<TABLE ALIGN="CENTER" WIDTH="600" BORDER="0" BORDERCOLOR = "#000000" CELLSPACING=0 CELLPADDING=1>

				 		<tr class="Estilo1">
						 	<TD colspan=4 align="center" class="Estilo33">
					 		  RECONOCIMIENTO DE DEUDA Y CONVENIO DE PAGO <BR>
					 		  (<%=strDescripcion%>)
					 		</TD>
				 		</TR>
				 		<TR>
						 	<td colspan=4><div align="center"><%=strMandante%></div></TD>
				 		</TR>
				 		<TR>
				 			<td colspan=4>&nbsp</TD>
				 		</TR>
 				</TABLE>

	 		</TD>
 		</TR>
 		<TR>
			<TD>
				<TABLE ALIGN="CENTER" WIDTH="600" BORDER="0" BORDERCOLOR = "#000000" CELLSPACING=0 CELLPADDING=1>

					<tr class="Estilo1">
						<TD colspan=4 align="LEFT" class="Estilo34">
						  IDENTIFICACION DEL DEUDOR Y SUSCRIPTOR
						</TD>
					</TR>
					<TR>
						<td colspan=4><div align="center"><%=strMandante%></div></TD>
					</TR>
				</TABLE>
 				<%
 					strSql="SELECT NOMBREDEUDOR FROM DEUDOR WHERE RUTDEUDOR='" & strRutDeudor & "' AND CODCLIENTE = '" & intCliente & "'"
					set RsDeudor=Conn.execute(strSql)
					if not RsDeudor.eof then
						strNombreDeudor = RsDeudor("NOMBREDEUDOR")
					end if
					RsDeudor.close
					set RsDeudor=nothing

					strSql=""
					strSql="SELECT TOP 1 CALLE,NUMERO,COMUNA,RESTO,CORRELATIVO,ESTADO FROM DEUDOR_DIRECCION WHERE RUTDEUDOR='" & strRutDeudor & "' AND ESTADO <> '2' ORDER BY ESTADO DESC"
					set rsDIR=Conn.execute(strSql)
					if not rsDIR.eof then
						calle_deudor=rsDIR("Calle")
						numero_deudor=rsDIR("Numero")
						comuna_deudor=rsDIR("Comuna")
						resto_deudor=rsDIR("Resto")
						strDirDeudor = calle_deudor & " " & numero_deudor & " " & resto_deudor & " " & comuna_deudor
					end if
					rsDIR.close
					set rsDIR=nothing


					strSql=""
					strSql="SELECT TOP 1 CODAREA,TELEFONO,CORRELATIVO,ESTADO FROM DEUDOR_TELEFONO WHERE  RUTDEUDOR='" & strRutDeudor & "' AND ESTADO <> '2' ORDER BY ESTADO DESC"
					set rsFON=Conn.execute(strSql)
					if not rsFON.eof then
						codarea_deudor = rsFON("CodArea")
						Telefono_deudor = rsFON("Telefono")
						strFono = codarea_deudor & "-" & Telefono_deudor
					end if
					rsFON.close
					set rsFON=nothing


					strSql=""
					strSql="SELECT TOP 1 RUTDEUDOR,CORRELATIVO,FECHAINGRESO,EMAIL,ESTADO FROM DEUDOR_EMAIL WHERE  RUTDEUDOR='" & strRutDeudor & "' AND ESTADO <> '2' ORDER BY ESTADO DESC"
					set rsMAIL=Conn.execute(strSql)
					if not rsMAIL.eof then
						strEmail = rsMAIL("EMAIL")
					end if
					rsMAIL.close
					set rsMAIL=nothing
				%>


				<table width="600" border="0">
					<tr>
						<td>&nbsp</td>
					</tr>
					<tr>
						<td colspan=4><span class="Estilo34"><b>Datos Deudor</b></td>
					</tr>
					<tr>
						<td><span class="Estilo34">Nombre :</td>
						<td><span class="Estilo34"><%=strNombreDeudor%></td>
						<td><span class="Estilo34">Rut :</td>
						<td><span class="Estilo34"><%=strRutDeudor%></td>
					</tr>
					<tr>
						<td><span class="Estilo34">Direccion :</td>
						<td><span class="Estilo34"><%=strDirDeudor%></td>
						<td><span class="Estilo34">Telefono red fija :</td>
						<td><span class="Estilo34"><%=strFono%></td>
					</tr>
					<tr>
						<td><span class="Estilo34">Telefono celular :</td>
						<td><span class="Estilo34"><%=strFonoCelular%></td>
						<td><span class="Estilo34">Email :</td>
						<td><span class="Estilo34"><%=strEmail%></td>
					</tr>
				</table>
				<br>

				<table width="600" border="0">
					<tr>
						<td class="Estilo34">Por el Presente acto, el suscriptor de este documento se compromete a pagar la deuda que
							mantiene con  nuestro mandante, debidamente  individualizado precedentemente, de acuerdo al
							presente Convenio de Pago.
						</td>
					</tr>
				</table>
				<br>
				<TABLE ALIGN="CENTER" WIDTH="600" BORDER="0" BORDERCOLOR = "#000000" CELLSPACING=0 CELLPADDING=1>

					<tr class="Estilo1">
						<TD colspan=4 align="LEFT" class="Estilo34">
						  ANTECEDENTES DE LA DEUDA
						</TD>
					</TR>
					<TR>
						<td colspan=4>&nbsp;</TD>
					</TR>
				</TABLE>


				<table width="100%" border="1" bordercolor = "#000000" cellSpacing=0 cellPadding=1>
				<tr class="Estilo34">
					<td>CUENTA</td>
					<td>NRODOC</td>
					<td>FECHA_VENC</td>
					<!--td>DIAS_MORA</td>
					<td>TIPODOCUMENTO</td>
					<td>ASIGNACION</td-->
					<td>MONTO</td>
				</tr>

				<%

				strSql = "SELECT IDCUOTA,NRODOC, CUENTA, FECHAVENC, VALORCUOTA FROM CONVENIO_CUOTA WHERE ID_CONVENIO = " & intIdConvenio
				set rsTemp= Conn.execute(strSql)

				intCorrelativo = 1
				strArrIdCuota=""
				Do until rsTemp.eof
					intSaldo = rsTemp("VALORCUOTA")
					strNroDoc = rsTemp("NRODOC")
					strCuenta = rsTemp("CUENTA")
					strFechaVenc = rsTemp("FECHAVENC")

					strArrIdCuota = strArrIdCuota & ";" & rsTemp("IDCUOTA")

					%>
					<tr class="Estilo34">
					<td><%=strCuenta%></td>
					<td><%=strNroDoc%></td>
					<td><%=strFechaVenc%></td>
					<td ALIGN="RIGHT"><%=FN(intSaldo,0)%></td>
					</tr>
				<%
				rsTemp.movenext
				intCorrelativo = intCorrelativo + 1
				loop
				rsTemp.close
				set rsTemp=nothing

				strArrIdCuota = Mid(strArrIdCuota,2,len(strArrIdCuota))

			%>
	<INPUT TYPE="HIDDEN" NAME="strArrIdCuota" VALUE="<%=strArrIdCuota%>">

			<br>
			<br>
			<table width="600" border="0">
			<br>
				<tr>
					<td class="Estilo34">

				   El presente Convenio de Pago no produce la  novacion de la(s) obligacion(es) primitivamente
contraida(s) con nuestro mandante constituyendo solo una modalidad o facilidad para el pago de
dicha(s) obligacion(es) vencida(s) y exigible(s). Este instrumento no acredita el pago de las
cuotas convenidas. En caso de incumpliento o simple atraso en el pago de  cualquiera de las
cuotas  establecidas, LLACRUZ  y/o nuestro  Mandante  quedan  facultadas  para  continuar el
ejercicio  de las acciones legales de  cobro, devengandose como interes, el maximo convencional
estipulado por la Ley.
<br>
			<br>
  <pre class="Estilo8">       	_____________________                  ______________________
        Nombre y Firma de Ejecutivo               Firma del Suscriptor</pre>
					</td>
				</tr>
			</table>
			<br>
			<br>


			</TD>
 		</TR>

 </TABLE>


<BR>
   	<H1 class=SaltoDePagina> </H1>
<BR>



<TABLE ALIGN="CENTER" WIDTH="600" BORDER="1" BORDERCOLOR = "#000000" CELLSPACING=0 CELLPADDING=1>

		<TR>
			<TD>
				<TABLE ALIGN="CENTER" WIDTH="600" BORDER="0" BORDERCOLOR = "#000000" CELLSPACING=0 CELLPADDING=1>

					<TR class="Estilo1">
						<TD colspan=4 align="LEFT" class="Estilo34">
						  IDENTIFICACION DEL DEUDOR Y SUSCRIPTOR
						</TD>
					</TR>
					<TR>
						<td colspan=4><div align="center"><%=strMandante%></div></TD>
					</TR>
				</TABLE>
 				<TABLE WIDTH="600" BORDER="0">
					<tr>
						<td>&nbsp</td>
					</tr>
					<tr>
						<td colspan=4><span class="Estilo34"><b>Datos Deudor</b></td>
					</tr>
					<tr>
						<td><span class="Estilo34">Nombre :</td>
						<td><span class="Estilo34"><%=strNombreDeudor%></td>
						<td><span class="Estilo34">Rut :</td>
						<td><span class="Estilo34"><%=strRutDeudor%></td>
					</tr>
					<tr>
						<td><span class="Estilo34">Direccion :</td>
						<td><span class="Estilo34"><%=strDirDeudor%></td>
						<td><span class="Estilo34">Telefono red fija :</td>
						<td><span class="Estilo34"><%=strFono%></td>
					</tr>
					<tr>
						<td><span class="Estilo34">Telefono celular :</td>
						<td><span class="Estilo34"><%=strFonoCelular%></td>
						<td><span class="Estilo34">Email :</td>
						<td><span class="Estilo34"><%=strEmail%></td>
					</tr>
				</TABLE>
				<br>
		</TD>
	</TR>
	<TR>
		<TD>


		<%


		strSql = "SELECT SUM(TOTAL_CUOTA) AS TOTALCUOTAS FROM CONVENIO_DET WHERE ID_CONVENIO = " & intIdConvenio  & " AND CUOTA <> 0"
		set rsDetConv = Conn.execute(strSql)

		If Not rsDetConv.eof Then
			intTotalCuotas = rsDetConv("TOTALCUOTAS")
		Else
			intTotalCuotas = 0
		End if


		strSql = "SELECT * FROM CONVENIO_ENC WHERE ID_CONVENIO = " & intIdConvenio
		set rsConvenio= Conn.execute(strSql)
		If Not rsConvenio.Eof Then

			intTotDeudaCapital = rsConvenio("CAPITAL")
			intTotGastos = rsConvenio("GASTOS")
			intTotHonorarios = rsConvenio("HONORARIOS")
			intTotIndemComp = rsConvenio("INTERESES")
			intTotalDeuda = rsConvenio("TOTAL_CONVENIO")
			intPie = rsConvenio("PIE")
			intInteresConvenio = (intTotalDeuda - intPie - intTotalCuotas) * -1


		End if




		%>

			<TABLE WIDTH="600" ALIGN="CENTER" BORDER="1" BORDERCOLOR = "#000000" CELLSPACING=0 CELLPADDING=1>
				<TR>
					<TD VALIGN="TOP">

						<TABLE WIDTH="100%" ALIGN="CENTER" BORDER=0 CELLSPACING=0 CELLPADDING=1>
								<TR>
									<TD VALIGN="TOP">
										<TABLE ALIGN="CENTER" WIDTH="300" BORDER="0">
											<TR class="Estilo1">
												<TD colspan=4 align="CENTER" class="Estilo38">
												  DETALLE CONVENIO<br><br>
												</TD>
											</TR>
											<TR HEIGHT=20>
												<TD COLSPAN=2 ALIGN="CENTER" class="Estilo38">
													MONTO DE DEUDA
												</TD>
											</TR>
											<TR HEIGHT=20>
												<TD ALIGN="RIGHT" class="Estilo38">Capital: </TD>
												<TD align="right" class="Estilo38"><strong>$ <%=FN(intTotDeudaCapital,0)%></strong></TD>
											</TR>
											<TR HEIGHT=20>
												<TD align="right" class="Estilo38">Gastos Judiciales: </TD>
												<TD align="right" class="Estilo38"><strong>$ <%=FN(intTotGastos,0)%></strong></TD>
											</TR>
											<TR HEIGHT=20>
												<TD>&nbsp</TD>
												<TD align="right">______________</TD>
											</TR>
											<TR HEIGHT=20>
												<TD align="right" class="Estilo38">Total Deuda:</TD>
												<TD align="right" class="Estilo38"><strong>$ <%=FN(intTotalDeuda,0)%></strong></TD>
											</TR>
											<TR HEIGHT=20>
												<TD align="right" class="Estilo38">Pie Convenio:</TD>
												<TD align="right" class="Estilo38"><strong>-  $ <%=FN(intPie,0)%></strong></TD>
											</TR>
											<TR HEIGHT=20>
												<TD>&nbsp</TD>
												<TD align="right">______________</TD>
											</TR>

											<TR HEIGHT=20>
												<TD align="right" class="Estilo38">Saldo en Convenio:</TD>
												<TD align="right" class="Estilo38"><strong>$ <%=FN(intTotalDeuda - intPie,0)%></strong></TD>
											</TR>
											<TR HEIGHT=20>
												<TD align="right" class="Estilo38">Intereses Convenio.:</TD>
												<TD align="right" class="Estilo38"><strong>$ <%=FN(intInteresConvenio,0)%></strong></TD>
											</TR>
											<TR HEIGHT=20>
												<TD align="right" class="Estilo38">&nbsp</TD>
												<TD align="right" class="Estilo38">&nbsp</TD>
											</TR>
											<TR HEIGHT=20>
												<TD align="right" class="Estilo38">&nbsp</TD>
												<TD align="right" class="Estilo38">&nbsp</TD>
											</TR>
											<TR HEIGHT=20>
												<TD align="right" class="Estilo38"><b>Saldo a Convenir: <b></TD>
												<TD align="right" class="Estilo38"><strong>$ <%=FN((intTotalDeuda - intPie) + intInteresConvenio,0)%></strong></TD>
											</TR>

										</TABLE>
									</TD>
								</TR>
							</TABLE>


					</TD>
					<TD VALIGN="TOP" >
						<TABLE ALIGN="CENTER" WIDTH="300" BORDER="0" BORDERCOLOR = "#000000" CELLSPACING=0 CELLPADDING=1>
							<TR class="Estilo1">
								<TD colspan=4 align="CENTER" class="Estilo38">
								  PLAN DE PAGO
								</TD>
							</TR>
							<TR>
								<td colspan=4><div align="center"><%=strMandante%></div></TD>
							</TR>
						</TABLE>
						<BR>
						<TABLE ALIGN= "CENTER" WIDTH="70%" BORDER="1" BORDERCOLOR = "#000000" CELLSPACING=0 CELLPADDING=1>
							<tr class="Estilo34">
								<td>N&uacute;mero de Cuota</td>
								<td>Fecha de Pago</td>
								<td>Monto Cuota</td>
							</tr>
							<%


							strSql = "SELECT CUOTA, FECHA_PAGO, TOTAL_CUOTA FROM CONVENIO_DET WHERE ID_CONVENIO = " & intIdConvenio  & " AND CUOTA <> 0"
							set rsCuotas= Conn.execute(strSql)

							intCorrelativo = 1
							strArrIdCuota=""
							Do until rsCuotas.eof
								intNroCuota = rsCuotas("CUOTA")
								dtmFechaPago = rsCuotas("FECHA_PAGO")
								intMonto = rsCuotas("TOTAL_CUOTA")

								%>
								<tr class="Estilo34">
									<td><%=intNroCuota%></td>
									<td><%=dtmFechaPago%></td>
									<td>$ <%=FN(intMonto,0)%></td>
								</tr>
								<%
								rsCuotas.movenext
							Loop
							%>
	      				</TABLE>

					</TD>
				</TR>
				<TR>
					<TD COLSPAN="2">

						<TABLE WIDTH="100%" ALIGN="CENTER" BORDER=0 CELLSPACING=0 CELLPADDING=1>
							<TR>
								<TD ALIGN="TOP">
									<TABLE ALIGN="RIGHT" WIDTH="100%" BORDER="0">
										<TR class="Estilo1">
											<TD colspan=2 align="CENTER" class="Estilo38">
											  PAGO CONTADO<br><br>
											</TD>
										</TR>

										<TR HEIGHT=20>
											<TD align="right" class="Estilo38"><b>Honorarios + Indem.Compensatoria:</b></TD>
											<!--TD align="right" class="Estilo38"><strong>$ <%=FN(intTotHonorarios,0)%> + $ <%=FN(intTotIndemComp,0)%> = $ <%=FN(intTotHonorarios + intTotIndemComp,0)%></strong></TD-->
											<TD align="right" class="Estilo38"><strong>$ <%=FN(intTotHonorarios + intTotIndemComp,0)%></strong></TD>
										</TR>
										<TR HEIGHT=20>
											<TD align="right" class="Estilo38"><b>Pie Convenio:</b></TD>
											<TD align="right" class="Estilo38"><strong>$ <%=FN(intPie,0)%></strong></TD>
										</TR>
										<TR HEIGHT=20>
											<TD>&nbsp</TD>
											<TD align="right">______________</TD>
										</TR>
										<TR HEIGHT=20>
											<TD align="right" class="Estilo38"><b>Total Pago Caja:</b></TD>
											<TD align="right" class="Estilo38"><strong>$ <%=FN(intTotHonorarios + intTotIndemComp + intPie,0)%></strong></TD>
										</TR>
										<TR HEIGHT=20>
											<TD align="right" class="Estilo38">&nbsp</TD>
											<TD align="right" class="Estilo38">&nbsp</TD>
										</TR>

									</TABLE>

								</TD>
							</TR>
						</TABLE>

					</TD>
				</TR>
			</TABLE>



















		</TD>
	</TR>


	</TABLE>
	<BR>

	<TABLE ALIGN="CENTER" WIDTH="600" BORDER="0" BORDERCOLOR = "#000000" CELLSPACING=0 CELLPADDING=1>
			<TR class="Estilo1">
				<TD align="RIGHT" class="Estilo34">
					<acronym title="IMPRIMIR CONVENIO">
						<input name="BT_IMPRIMIR" type="button" onClick="window.print();" value="Imprimir">
					</acronym>
				</TD>

			</TR>
	</TABLE>




&nbsp;&nbsp;
</body>
</html>
