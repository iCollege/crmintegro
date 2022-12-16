<% @LCID = 1034 %>
<!--#include file="arch_utils.asp"-->
<!--#include file="sesion.asp"-->
<!--#include file="../lib/comunes/rutinas/funciones.inc" -->
<!--#include file="asp/comunes/general/RutinasVarias.inc" -->
<!--#include file="../lib/comunes/rutinas/TraeCampo.inc" -->
<!--#include file="asp/comunes/general/rutinasSCG.inc" -->

<%
	If Trim(Request("Limpiar"))="1" Then
		session("session_rutdeudor") = ""
		rut = ""
	End if

	If Trim(Request("TX_RUT")) = "" Then
		strRutDeudor = session("session_rutdeudor")
	Else
		strRutDeudor = Trim(Request("TX_RUT"))
		session("session_rutdeudor") = strRutDeudor
	End If

	intOrigen = Request("intOrigen")

	intCliente = session("ses_codcli")

	strSede = Request("CB_SEDE")
	strCiudadSede = strSede

	intPorcDescCapital = ValNulo(Request("desc_capital"),"N")
	intPorcDescIndemComp = ValNulo(Request("desc_indemComp"),"N")
	intPorcDescHonorarios = ValNulo(Request("desc_honorarios"),"N")
	intPorcDescGastos = ValNulo(Request("desc_gastos"),"N")
	intPorcDescInteres = ValNulo(Request("desc_interes"),"N")
	intPorcDescProtestos = ValNulo(Request("desc_protestos"),"N")


	intPie = Request("pie")
	intCuotas = Request("cuotas")
	intDiaDePago = Request("TX_DIAPAGO")

	intOriginalCapital = Round(ValNulo(Request("TX_CAPITAL"),"N"),0)
	intOriginalIndemComp = Round(ValNulo(Request("hdintIndemComp"),"N"),0)
	intOriginalIntereses = Round(ValNulo(Request("TX_INTERES"),"N"),0)
	intOriginalProtestos = Round(ValNulo(Request("TX_GASTOSPROTESTOS"),"N"),0)
	intOriginalHonorarios = Round(ValNulo(Request("TX_HONORARIOS"),"N"),0)

	intOriginalGastos = Round(ValNulo(Request("hdintGastos"),"N"),0)

	intTotalDeuda = intOriginalCapital + intOriginalIntereses + intOriginalProtestos + intOriginalHonorarios

	intDescCapital = Round(intPorcDescCapital,0)
	intDescIndemComp = Round(intPorcDescIndemComp,0)
	intDescHonorarios = Round(intPorcDescHonorarios,0)
	intDescGastos = Round(intPorcDescGastos,0)
	intDescInteres = Round(intPorcDescInteres,0)
	intDescProtestos = Round(intPorcDescProtestos,0)

	intTotalDescuentos = intDescCapital + intDescIndemComp + intDescHonorarios + intDescGastos + intDescInteres
	'intTotalDescuentos = intDescCapital + intDescGastos

	intTotalConvenio = intTotalDeuda - intTotalDescuentos

	intTotDeudaCapital = Round(intOriginalCapital - intDescCapital,0)
	intTotIndemComp = Round(intOriginalIndemComp - intDescIndemComp,0)
	intTotHonorarios = Round(intOriginalHonorarios - intDescHonorarios,0)
	intTotGastos = Round(intOriginalGastos - intDescGastos,0)
	intTotIntereses = Round(intOriginalIntereses - intDescInteres,0)

	intTotProtestos = Round(intOriginalProtestos - intDescProtestos,0)

	AbrirSCG()

	strSql = "SELECT * FROM SEDE S, CONVENIO_CORRELATIVO C WHERE S.CODCLIENTE = '" & intCliente & "' AND S.SEDE = '" & strSede & "'"
	strSql = strSql & " AND S.RUT = C.RUT AND S.CODCLIENTE = C.CODCLIENTE"
	'Response.write "strSql=" & strSql
	set rsSede = Conn.execute(strSql)
	if not rsSede.eof then
		strRazonSocialSede=rsSede("RAZON_SOCIAL")
		strDireccionSede=rsSede("DIRECCION")
		strRutSede=rsSede("RUT")
		strTelefonoSede=rsSede("TELEFONO")
		strNroFolio=rsSede("FOLIO_ACTUAL")
	Else
		%>
		<SCRIPT>
			alert('Parámetros del convenio no han sido configurados, revise configuración.');
			history.back();
		</SCRIPT>
		<%
		Response.End
	End If



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


			intMontoTotal = 0
			intKapitalInicial = intTotalConvenio-intPie

			'strTipoInteres SIMPLE
			'M= C ( 1+i*n ) M= 3,250(1 + (0.025)(1.5/12)= 3,351.56

			'strTipoInteres COMPUESTO
			'M= C ( 1+i)^n ) M= 3,250(1 + (0.025)(1.5/12)= 3,351.56

			'Response.write "EXPO=" & calcula_base_exponente(3, 4)
			'Response.write "strTipoInteres=" & strTipoInteres

			'Response.write "<br>intTasaMax=" & intTasaMax
			'Response.write "<br>intKapitalInicial=" & intKapitalInicial
			'Response.write "<br>intCuotas=" & intCuotas


			If Trim(strTipoInteres)="C" Then
				intMontoConInteres = intKapitalInicial * calcula_base_exponente((1 + intTasaMax/100),intCuotas)
				'Response.write "<br>intMontoConInteres=" & intMontoConInteres
				intValorCuota=intKapitalInicial*((intTasaMax/100*calcula_base_exponente((1 + intTasaMax/100),intCuotas))/(calcula_base_exponente((1 + intTasaMax/100),intCuotas)-1))
				intValorCuota = Round(intValorCuota,0)
				'Response.write "<br>sss=" & sss
				''C36*((0,02*(1,02)^C39)/((1,02)^C39-1))

			Else
				intMontoConInteres = intKapitalInicial * (1 + ((intTasaMax/100)*intCuotas))
			End If

			intMonto = intValorCuota

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
			strFonoDeudor = codarea_deudor & "-" & Telefono_deudor
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



				intMesDePago = Month(date)
				intAnoDePago = Year(date)

				intKapitalInicial = intTotalConvenio-intPie
				'M= C ( 1+it ) M= 3,250(1 + (0.25)(1.5/12)= 3,351.56

				'strTipoInteres = "C"

				If Trim(strTipoInteres)="C" Then
					intMontoConInteres = intKapitalInicial * calcula_base_exponente((1 + intTasaMax/100),intCuotas)
					intValorCuota=intKapitalInicial*((intTasaMax/100*calcula_base_exponente((1 + intTasaMax/100),intCuotas))/(calcula_base_exponente((1 + intTasaMax/100),intCuotas)-1))
					intValorCuota = Round(intValorCuota,0)
				Else
					intMontoConInteres = intKapitalInicial * (1 + ((intTasaMax/100)*intCuotas))
				End If

				'intValorCuota = intMonto


				intMontoTotal = 0
				For i=1 to intCuotas

					intTotalGastos=0
					intCont=1

					intMesDePago = intMesDePago + 1
					If intMesDePago = 13 Then
						intMesDePago = 1
						intAnoDePago = intAnoDePago + 1
					End if
					intCont = intCont + 1

					dtmFechaPago = PoneIzq(intDiaDePago,"0") & "/" & PoneIzq(intMesDePago,"0") & "/" & intAnoDePago
					intNroCuota = i

					If i=1 Then
						dtmFechaCuota1 = dtmFechaPago
					End If

					If Not Isnull(intMontoConInteres/intCuotas) Then
						intMonto = Round(intMontoConInteres/intCuotas,0)
						intMonto= intValorCuota
					End if


					If Mid(dtmFechaPago,4,2) = "02" and Cdbl(intDiaDePago) > 28 Then
						dtmFechaPago = "28/02/" & Mid(dtmFechaPago,7,4)
					End if

					If Cdbl(intDiaDePago) > 30 Then
						dtmFechaPago = "30/" & Mid(dtmFechaPago,4,2) & "/" & Mid(dtmFechaPago,7,4)
					End if
					intMontoTotal = intMontoTotal + intMonto

				Next

				dtmFechaCuotaFin = dtmFechaPago










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
	if (confirm("¿ Está seguro de grabar el <%=session("NOMBRE_CONV_PAGARE")%> ? Si aun no lo ha imprimido, presione cancelar y luego el botón imprimir."))
		{
			datos.action = "grabar_convenio.asp";
			datos.submit();
		}
}
</script>


<BODY>
<FORM NAME="datos" METHOD="POST" ACTION="grabar_convenio.asp">

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
<INPUT TYPE="hidden" NAME="strRutSede" value="<%=strRutSede%>">



<TABLE ALIGN="CENTER" WIDTH="650" BORDER="1" BORDERCOLOR = "#000000" CELLSPACING=0 CELLPADDING=1>

		<TR>
		  <TD>
		  <table width="650" border="0" cellspacing=0 cellpadding=0>
			<tr>
			  <td class="Estilo13" width=400><b><%=strRazonSocialSede%></b></td>
			  <td width=100>&nbsp;</td>
			  <td width=150 rowspan="3"  class="Estilo13" align="center"><img border="0" width="150" height="46" src="UploadFolder/<%=session("ses_codcli")%>/logo.jpg"></td>
			</tr>
			<tr>
			  <td class="Estilo13">Dirección :<%=strDireccionSede%></td>
			  <td>&nbsp;</td>
			</tr>
			<tr>
			  <td class="Estilo13">R.U.T: :<%=strRutSede%></td>
			  <td>&nbsp;</td>
			</tr>
			<tr>
			  <td class="Estilo13">Teléfono : <%=strTelefonoSede%></td>
			  <td>&nbsp;</td>
			  <td align="center">&nbsp;</td>
			</tr>
		  </table>
		  </TD>
 		</TR>

 		<TR>
		 	<TD>

		 		<TABLE ALIGN="CENTER" WIDTH="600" BORDER="0" BORDERCOLOR = "#000000" CELLSPACING=0 CELLPADDING=1>

				 		<tr class="Estilo1">
						 	<TD colspan=4 align="center" class="Estilo33">
					 		  PLAN DE PAGO <%=UCASE(session("NOMBRE_CONV_PAGARE"))%><BR>
					 		  (<%=strDescripcion%>) &nbsp; <%=strMandante%>
					 		</TD>
				 		</TR>
				</TABLE>

	 		</TD>
 		</TR>
 	 	<TR>
 		<TD>
 		<TABLE ALIGN= "CENTER" WIDTH="70%" BORDER="0" BORDERCOLOR = "#000000" CELLSPACING=0 CELLPADDING=1>
 							<%

						intMesDePago = Month(date)
						intAnoDePago = Year(date)

						intKapitalInicial = intTotalConvenio-intPie
						'M= C ( 1+it ) M= 3,250(1 + (0.25)(1.5/12)= 3,351.56

						'strTipoInteres = "C"

						If Trim(strTipoInteres)="C" Then
							intMontoConInteres = intKapitalInicial * calcula_base_exponente((1 + intTasaMax/100),intCuotas)
						Else
							intMontoConInteres = intKapitalInicial * (1 + ((intTasaMax/100)*intCuotas))
						End If

						For i=1 to intCuotas

						intTotalGastos=0
						intCont=1


						intMesDePago = intMesDePago + 1
						If intMesDePago = 13 Then
							intMesDePago = 1
							intAnoDePago = intAnoDePago + 1
						End if
						intCont = intCont + 1


						dtmFechaPago = PoneIzq(intDiaDePago,"0") & "/" & PoneIzq(intMesDePago,"0") & "/" & intAnoDePago
						intNroCuota = i

						'intMonto = Round(intKapitalInicial/intCuotas,0)
						If Not Isnull(intMontoConInteres/intCuotas) Then
							intMonto = Round(intMontoConInteres/intCuotas,0)
							intMonto= intValorCuota
						End if

						If Mid(dtmFechaPago,4,2) = "02" and Cdbl(intDiaDePago) > 28 Then
							dtmFechaPago = "28/02/" & Mid(dtmFechaPago,7,4)
						End if

						If Cdbl(intDiaDePago) > 30 Then
							dtmFechaPago = "30/" & Mid(dtmFechaPago,4,2) & "/" & Mid(dtmFechaPago,7,4)
						End if




						%>
						<tr class="Estilo34">
							<td>Vencimiento <%=intNroCuota%></td>
							<td><%=dtmFechaPago%></td>
							<td align="right">$ <%=FN(intMonto,0)%></td>
						</tr>

						<% Next %>
						<tr class="Estilo34">
							<td>&nbsp;</td>
							<td><b>TOTAL</b></td>
							<td align="right"><b>$ <%=FN(intMontoTotal,0)%></b></td>
						</tr>
				</TABLE>
			</TD>
 		</TR>

 		<TR>
			<TD>
				<TABLE ALIGN="CENTER" WIDTH="650" BORDER="0" BORDERCOLOR = "#000000" CELLSPACING=0 CELLPADDING=1>

					<tr class="Estilo1">
						<TD colspan=4 align="LEFT" class="Estilo34">
						  <br>ANTECEDENTES DE LA DEUDA
						</TD>
					</TR>
				</TABLE>


				<table width="100%" border="1" bordercolor = "#000000" cellSpacing=0 cellPadding=1>
				<tr class="Estilo34">
					<td>NRODOC</td>
					<td>FECHA_VENC</td>
					<td>DIAS_MORA</td>
					<td>TIPODOCUMENTO</td>
					<!--td>ASIGNACION</td-->
					<td>CAPITAL</td>
					<td>INTERES</td>
					<td>PROTESTOS</td>
					<td>HONORARIOS</td>
				</tr>

				<%

				strSql = "SELECT IDCUOTA,NRODOC, TIPODOCUMENTO, GASTOSPROTESTOS, CUENTA, FECHAVENC, ISNULL(DATEDIFF(D,FECHAVENC,GETDATE()),0) AS ANTIGUEDAD FROM CUOTA WHERE RUTDEUDOR='" & strRutDeudor & "' AND CODCLIENTE='" & intCliente & "' AND SALDO > 0 ORDER BY FECHAVENC DESC"
				set rsTemp= Conn.execute(strSql)

				intTasaMensual = 2/100
				intTasaDiaria = intTasaMensual/30
				intCorrelativo = 1
				strArrIdCuota=""
				intTotSelSaldo= 0
				intTotSelIntereses= 0
				intTotSelProtestos= 0
				intTotSelHonorarios= 0
				Do until rsTemp.eof
					strObjeto = "CH_" & rsTemp("IDCUOTA")
					strObjeto1 = "TX_SALDO_" & rsTemp("IDCUOTA")
					If UCASE(Request(strObjeto)) = "ON" Then

						intSaldo = Request(strObjeto1)
						strNroDoc = rsTemp("NRODOC")
						strFechaVenc = rsTemp("FECHAVENC")
						strTipoDoc = rsTemp("TIPODOCUMENTO")

						intAntiguedad = ValNulo(rsTemp("ANTIGUEDAD"),"N")
						intIntereses = intTasaDiaria * intAntiguedad * intSaldo
						intHonorarios = GastosCobranzas(intSaldo)
						intProtestos = ValNulo(rsTemp("GASTOSPROTESTOS"),"N")

						strArrIdCuota = strArrIdCuota & ";" & rsTemp("IDCUOTA")

						intTotSelSaldo= intTotSelSaldo+intSaldo
						intTotSelIntereses= intTotSelIntereses+intIntereses
						intTotSelProtestos= intTotSelProtestos+intProtestos
						intTotSelHonorarios= intTotSelHonorarios+intHonorarios

						%>
						<tr class="Estilo34">
						<td><%=strNroDoc%></td>
						<td><%=strFechaVenc%></td>
						<td><%=intAntiguedad%></td>
						<td><%=strTipoDoc%></td>
						<td ALIGN="RIGHT"><%=FN(intSaldo,0)%></td>
						<td ALIGN="RIGHT"><%=FN(intIntereses,0)%></td>
						<td ALIGN="RIGHT"><%=FN(intProtestos,0)%></td>
						<td ALIGN="RIGHT"><%=FN(intHonorarios,0)%></td>
						</tr>
						<%
					End if
				%>


				<%


				rsTemp.movenext
				intCorrelativo = intCorrelativo + 1
				loop
				rsTemp.close
				set rsTemp=nothing

				strArrIdCuota = Mid(strArrIdCuota,2,len(strArrIdCuota))
		%>
			<tr class="Estilo34">
				<td colspan = 4>Totales</td>
				<td ALIGN="RIGHT"><%=FN(intTotSelSaldo,0)%></td>
				<td ALIGN="RIGHT"><%=FN(intTotSelIntereses,0)%></td>
				<td ALIGN="RIGHT"><%=FN(intTotSelProtestos,0)%></td>
				<td ALIGN="RIGHT"><%=FN(intTotSelHonorarios,0)%></td>
			</tr>

			<INPUT TYPE="HIDDEN" NAME="strArrIdCuota" VALUE="<%=strArrIdCuota%>">
			</table>

			<br>
					<TABLE ALIGN="CENTER" WIDTH="600" BORDER="0">
						<TR class="Estilo1">
							<TD colspan=4 align="CENTER" class="Estilo38">
							  DETALLE <%=UCASE(session("NOMBRE_CONV_PAGARE"))%><br><br>
							</TD>
						</TR>
						<TR HEIGHT=15 class="Estilo38">
							<TD ALIGN="RIGHT"><b>Conceptos</b></TD><TD align="right"><b>Monto Original</b></TD>
							<TD align="right"><b>Descuentos</b></TD><TD align="right"><b>Total</b></TD>
						</TR>
						<TR HEIGHT=15 class="Estilo38">
							<TD ALIGN="RIGHT">Capital: </TD><TD align="right">$ <%=FN(intOriginalCapital,0)%></TD>
							<TD align="right">$ <%=FN(intDescCapital,0)%></TD><TD align="right">$ <%=FN(intTotDeudaCapital,0)%></TD>
						</TR>
						<TR HEIGHT=15 class="Estilo38">
							<TD align="right">Intereses: </TD><TD align="right">$ <%=FN(intOriginalIntereses,0)%></TD>
							<TD align="right">$ <%=FN(intDescInteres,0)%></TD><TD align="right">$ <%=FN(intTotIntereses,0)%></TD>
						</TR>
						<TR HEIGHT=15 class="Estilo38">
							<TD align="right">Protestos: </TD><TD align="right">$ <%=FN(intOriginalProtestos,0)%></TD>
							<TD align="right">$ <%=FN(intDescProtestos,0)%></TD><TD align="right">$ <%=FN(intTotProtestos,0)%></TD>
						</TR>
						<TR HEIGHT=15 class="Estilo38">
							<TD align="right">Honorarios: </TD><TD align="right">$ <%=FN(intOriginalHonorarios,0)%></TD>
							<TD align="right">$ <%=FN(intDescHonorarios,0)%></TD><TD align="right">$ <%=FN(intTotHonorarios,0)%></TD>
						</TR>
						<TR HEIGHT=15>
							<TD colspan=3>&nbsp</TD><TD align="right">______________</TD>
						</TR>
						<TR HEIGHT=15 class="Estilo38">
							<TD align="right" colspan=3>Total Deuda:</TD><TD align="right"><strong>$ <%=FN(intTotalConvenio,0)%></strong></TD>
						</TR>
						<!--TR HEIGHT=15 class="Estilo38">
							<TD align="right">Total Descuentos:</TD><TD align="right"><strong>$ <%=FN(intTotalDeuda,0)%></strong></TD>
						</TR-->

						<TR HEIGHT=15 class="Estilo38">
							<TD align="right" colspan=3>Pie <%=session("NOMBRE_CONV_PAGARE")%>:</TD><TD align="right"><strong>-  $ <%=FN(intPie,0)%></strong></TD>
						</TR>
						<TR HEIGHT=15 class="Estilo38">
							<TD colspan=3>&nbsp</TD><TD align="right">______________</TD>
						</TR>
						<TR HEIGHT=15 class="Estilo38">
							<TD align="right" colspan=3>Saldo:</TD><TD align="right"><strong>$ <%=FN((intTotalConvenio -  intPie),0)%></strong></TD>
						</TR>
						<TR HEIGHT=15 class="Estilo38">
							<TD align="right" colspan=3>Intereses <%=session("NOMBRE_CONV_PAGARE")%>.:</TD>	<TD align="right"><strong>$ <%=FN(intMontoTotal - (intTotalConvenio -  intPie),0)%></strong></TD>
						</TR>
						<TR HEIGHT=15 class="Estilo38">
							<TD align="right" colspan=3>&nbsp</TD><TD align="right" class="Estilo38">&nbsp</TD>
						</TR>
						<TR HEIGHT=15 class="Estilo38">
							<TD align="right" colspan=3>&nbsp</TD><TD align="right" class="Estilo38">&nbsp</TD>
						</TR>

						<TR HEIGHT=15 class="Estilo38">
							<TD align="right" colspan=3><b>Saldo <%=session("NOMBRE_CONV_PAGARE")%>: <b></TD>
							<TD align="right"><strong>$ <%=FN(intMontoTotal,0)%></strong></TD>
						</TR>
					</table>
				</tr>
			</TD>
 		</TR>
 </TABLE>
</FORM>

<TABLE ALIGN="CENTER" WIDTH="600" BORDER="0" BORDERCOLOR = "#000000" CELLSPACING=0 CELLPADDING=1>
			<TR class="Estilo1">
				<TD align="RIGHT" class="Estilo34">
					<acronym title="IMPRIMIR <%=UCASE(session("NOMBRE_CONV_PAGARE"))%>">
						<input name="BT_IMPRIMIR" type="button" onClick="window.print();" value="Imprimir">
					</acronym>
				</TD>

			</TR>
	</TABLE>

	<INPUT TYPE="hidden" NAME="intIntConvenio" value="<%=intMontoTotal%>">


&nbsp;&nbsp;
</body>
</html>