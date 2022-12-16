<% @LCID = 1034 %>
<!--#include file="arch_utils.asp"-->
<!--#include file="sesion.asp"-->
<!--#include file="../lib/comunes/rutinas/funciones.inc" -->
<!--#include file="../lib/comunes/rutinas/TraeCampo.inc" -->
<!--#include file="asp/comunes/general/rutinasSCG.inc" -->
<!--#include file="asp/comunes/general/RutinasVarias.inc" -->
<!--#include file="asp/comunes/general/Rutinas.inc" -->

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

	strSede = Request("CB_SEDE")
	strCiudadSede = strSede

	strIC = Trim(UCASE(Request("CH_IC")))

	intCliente = session("ses_codcli")

	intPorcDescCapital = ValNulo(Request("capital"),"N")
	intPorcDescIndemComp = ValNulo(Request("indemComp"),"N")
	intPorcDescHonorarios = ValNulo(Request("honorarios"),"N")
	intPorcDescGastos = ValNulo(Request("gastos"),"N")

	intPie = Request("pie")
	intCuotas = Request("cuotas")
	intDiaDePago = Request("TX_DIAPAGO")


	intCuota1 = Trim(Request("TX_CUOTA1"))
	intCuota2 = Trim(Request("TX_CUOTA2"))
	intCuota3 = Trim(Request("TX_CUOTA3"))
	intCuota4 = Trim(Request("TX_CUOTA4"))
	intCuota5 = Trim(Request("TX_CUOTA5"))
	intCuota6 = Trim(Request("TX_CUOTA6"))
	intCuota7 = Trim(Request("TX_CUOTA7"))
	intCuota8 = Trim(Request("TX_CUOTA8"))





	strNombreIC = Request("strNombreIC")

		If Trim(strNombreIC)="" Then strNombreIC = "Gastos Operacionales"


		intInteresConvenio = ValNulo(Request("TX_INTERES_CONV"),"N")

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
		''intOriginalIndemComp = Round(ValNulo(Request("hdintIndemComp"),"N"),0)
		intOriginalIntereses = Round(ValNulo(Request("TX_INTERES"),"N"),0)
		intOriginalProtestos = Round(ValNulo(Request("TX_GASTOSPROTESTOS"),"N"),0)
		intOriginalGastos = Round(ValNulo(Request("TX_GASTOS"),"N"),0)
		intOriginalHonorarios = Round(ValNulo(Request("TX_HONORARIOS"),"N"),0)
		intOriginalIndemComp = Round(ValNulo(Request("TX_INDEM_COMP"),"N"),0)




		''intOriginalGastos = Round(ValNulo(Request("hdintGastos"),"N"),0)

		intTotalDeuda = intOriginalCapital + intOriginalIntereses + intOriginalProtestos + intOriginalHonorarios + intOriginalIndemComp + intOriginalGastos

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


				intKapitalInicial = intTotalConvenio-intPie
				intValorCuota = Round(intValorCuota,0)

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
				strDirDeudor = calle_deudor & " " & numero_deudor & " " & resto_deudor
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

					intValorCuota = Round(intValorCuota,0)




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

						intMonto= intValorCuota


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
<INPUT TYPE="hidden" NAME="intIntereses" value="<%=intTotIntereses%>">
<INPUT TYPE="hidden" NAME="intInteresConvenio" value="<%=intInteresConvenio%>">


<INPUT TYPE="hidden" NAME="intProtestos" value="<%=intTotProtestos%>">

<INPUT TYPE="hidden" NAME="strTipoConv" value="M">
<INPUT TYPE="hidden" NAME="intCuota1" value="<%=intCuota1%>">
<INPUT TYPE="hidden" NAME="intCuota2" value="<%=intCuota2%>">
<INPUT TYPE="hidden" NAME="intCuota3" value="<%=intCuota3%>">
<INPUT TYPE="hidden" NAME="intCuota4" value="<%=intCuota4%>">
<INPUT TYPE="hidden" NAME="intCuota5" value="<%=intCuota5%>">
<INPUT TYPE="hidden" NAME="intCuota6" value="<%=intCuota6%>">
<INPUT TYPE="hidden" NAME="intCuota7" value="<%=intCuota7%>">
<INPUT TYPE="hidden" NAME="intCuota8" value="<%=intCuota8%>">



<INPUT TYPE="hidden" NAME="intIndemComp" value="<%=intTotIndemComp%>">
<INPUT TYPE="hidden" NAME="intGastos" value="<%=intTotGastos%>">
<INPUT TYPE="hidden" NAME="intHonorarios" value="<%=intTotHonorarios%>">
<INPUT TYPE="hidden" NAME="intDescTotalCapital" value="<%=intDescCapital%>">
<INPUT TYPE="hidden" NAME="intDescIndemComp" value="<%=intDescIndemComp%>">
<INPUT TYPE="hidden" NAME="intDescGastos" value="<%=intDescGastos%>">
<INPUT TYPE="hidden" NAME="intDescHonorarios" value="<%=intDescHonorarios%>">
<INPUT TYPE="hidden" NAME="intDescProtestos" value="<%=intDescProtestos%>">
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
			  <td align="center"><span class="Estilo13"><%=session("NOMBRE_CONV_PAGARE")%> : <%=strNroFolio%></span></td>
			</tr>
		  </table>
		  </TD>
 		</TR>

 		<TR>
		 	<TD>

		 		<TABLE ALIGN="CENTER" WIDTH="600" BORDER="0" BORDERCOLOR = "#000000" CELLSPACING=0 CELLPADDING=1>

				 		<tr class="Estilo1">
						 	<TD colspan=4 align="center" class="Estilo33">
					 		  RECONOCIMIENTO DE DEUDA Y <%=UCASE(session("NOMBRE_CONV_PAGARE"))%><BR>
					 		  (<%=strDescripcion%>)
					 		</TD>
				 		</TR>
				 		<TR>
						 	<td colspan=4><div align="center"><%=strMandante%></div></TD>
				 		</TR>
				 		<TR>
						 	<td colspan=4 class="Estilo33"><div align="center">DATOS DEL DEUDOR O SUSCRIPTOR</div></TD>
				 		</TR>
				</TABLE>

	 		</TD>
 		</TR>
 		<TR>
			<TD>


			<br>
			<table width="650" border="0">
			<br>
				<tr>
					<td class="Estilo34" align="left">





					En <B><%=strCiudadSede%></B> a <B><%=Day(date)%> de <%=NombreMes(Month(date))%> del año <%=Year(date)%></B>, don <B><%=strNombreDeudor%></B>, en adelante el "Deudor o Suscriptor", cédula de identidad Nº <B><%=strRutDeudor%></B>, domiciliado en <%=strDirDeudor%>, Comuna de <%=comuna_deudor%>, teléfono de contacto <%=strFonoDeudor%>, correo electrónico <%=strEmail%>, debidamente representado por __________________________________, Rut  Nº _________. Por el presente acto el  suscriptor de este documento se compromete a pagar la deuda que mantiene con nuestro mandante AUTOPISTA VESPUCIO SUR, de acuerdo al presente Convenio de Pago y declara conocer lo siguiente:
					<br>
					<br>
					1.- El presente Convenio de Pago no produce la novación de la(s) obligación(es) primitivamente contraída(s) con nuestro mandante constituyendo solo una modalidad o facilidad para el pago de dicha(s) obligación(es) vencida(s) y exigible(s). Este instrumento no acredita el pago de las cuotas convenidas.
					<br>2.- El no pago, simple retardo o pago parcial de las cuotas, señaladas en este convenio, <%=strRazonSocialSede%> y/o nuestro Mandante quedarán facultados para continuar el ejercicio de las acciones legales de cobro, exigiendo el total de lo adeudado de esa fecha, en capital e intereses,  como si hubiera vencido todos los plazos, sin trámites y, en este evento, devengándose como interés, el máximo convencional estipulado por la Ley.
					<br>3.- El Suscriptor entiende y acepta que sus datos personales y los relacionados con el, serán  incorporados en el presente instrumento, podrán ser tratados y/o utilizados por <%=strRazonSocialSede%> de conformidad a lo dispuesto en la Ley Nº 19.628, sobre Protección de Datos de Carácter Personal, como asimismo para verificar su identidad en el Servicio de Verificación de Identidad del Servicio de Registro Civil e Identificación u otras y para promociones u otros fines comerciales. El Suscriptor declara que todos los datos contenidos en esta solicitud son fidedignos.
					<br>4.- Todo los gastos, comisiones y otros derivados de este convenio son de cargo del suscriptor, además se informa en este acto que en la próxima facturación de su consumo se hará cobro de los gastos de cobranza que correspondan.

					<br><br><b>ANTECEDENTES ACOMPAÑADOS:</b>
					<br><br>A.- Certificado de residencias          &nbsp;&nbsp;SI&nbsp;&nbsp;&nbsp;&nbsp;NO
					<br>B.- Boleta de suministro                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;SI&nbsp;&nbsp;&nbsp;&nbsp;NO
					<br>C.- Acreditación de renta               &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;SI&nbsp;&nbsp;&nbsp;&nbsp;NO

					<br><br>

					</td>
				</tr>
			</table>
			<br>
			<br>


			</TD>
 		</TR>




 	<TR>
 		<TD>
 		<TABLE ALIGN= "CENTER" WIDTH="70%" BORDER="0" BORDERCOLOR = "#000000" CELLSPACING=0 CELLPADDING=1>

						<tr class="Estilo34">
							<td COLSPAN=3 ALIGN="CENTER"> <B>Vencimiento de las cuotas</B> <BR> <BR></td>
						</tr>
 			<%

						intMesDePago = Month(date)
						intAnoDePago = Year(date)

						intKapitalInicial = intTotalConvenio-intPie
						'M= C ( 1+it ) M= 3,250(1 + (0.25)(1.5/12)= 3,351.56

						intMontoTotalCuotas = 0

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

						If Mid(dtmFechaPago,4,2) = "02" and Cdbl(intDiaDePago) > 28 Then
							dtmFechaPago = "28/02/" & Mid(dtmFechaPago,7,4)
						End if

						If Cdbl(intDiaDePago) > 30 Then
							dtmFechaPago = "30/" & Mid(dtmFechaPago,4,2) & "/" & Mid(dtmFechaPago,7,4)
						End if


						If i=1 Then intMonto = intCuota1
						If i=2 Then intMonto = intCuota2
						If i=3 Then intMonto = intCuota3
						If i=4 Then intMonto = intCuota4
						If i=5 Then intMonto = intCuota5
						If i=6 Then intMonto = intCuota6
						If i=7 Then intMonto = intCuota7
						If i=8 Then intMonto = intCuota8

						intMontoTotalCuotas = intMontoTotalCuotas + intMonto

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
							<td align="right"><b>$ <%=FN(intMontoTotalCuotas,0)%></b></td>
						</tr>
				</TABLE>
			</TD>
 		</TR>





 		<TR>
		 	<TD>
				<TABLE ALIGN= "CENTER" WIDTH="90%" BORDER="0" BORDERCOLOR = "#000000" CELLSPACING=0 CELLPADDING=1>
					<tr class="Estilo34">
						<td colspan=2>&nbsp;</td><td colspan=2>&nbsp;</td>
					</tr>
					<tr class="Estilo34">
						<td>Nombre:</td><td><%=strNombreDeudor%></td><td colspan=2>&nbsp;</td>
					<tr class="Estilo34">
						<td>RUT:</td><td><%=strRutDeudor%></td><td colspan=2 >&nbsp;</td>
					</tr>
					<tr class="Estilo34">
						<td>Domicilio:</td><td><%=strDirDeudor%></td><td colspan=2  align=center>________________________</td>
					</tr>
					<tr class="Estilo34">
						<td>Telefonos:</td><td><%=strFonoDeudor%></td><td colspan=2 align=center>Firma</td>
					</tr>
					<tr class="Estilo34">
						<td colspan=2>&nbsp;</td><td colspan=2>&nbsp;</td>
					</tr>
				</TABLE>
			</TD>
 		</TR>


 		<!--TR class="Estilo34">
			<TD>
				<b>CERTIFICACION NOTARIAL : <br>Firmó ante mi don(ña) <%=strNombreDeudor%> , cédula de identidad Nro : <%=strRutDeudor%></b>
				<BR><b><%=UCASE(strCiudadSede)%> , <%=DATE%></b>
			</TD>
 		</TR-->


 </TABLE>




<%

'Capital: $ FN(intTotDeudaCapital,0)
'Intereses: $ FN(intTotIntereses,0)
'Honorarios: FN(intTotHonorarios,0)
'G.Protesto: FN(intTotProtestos,0)
'Total Deuda: FN(intTotalDeuda,0)
'Pie session("NOMBRE_CONV_PAGARE") FN(intPie,0)
'Saldo en session("NOMBRE_CONV_PAGARE") FN(intTotalDeuda -  intPie,0)
'Intereses session("NOMBRE_CONV_PAGARE") FN(intMontoA,0)
'Saldo a Convenir: $ FN((intTotalDeuda -  intPie) + intMontoA,0)
'
'Pie session("NOMBRE_CONV_PAGARE")$ FN(intPie,0)
'Total Pago Caja:FN(intPie,0)

%>



<BR>
   	<H1 class=SaltoDePagina> </H1>
<BR>




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
				  <td align="center"><span class="Estilo13"><%=session("NOMBRE_CONV_PAGARE")%> : <%=strNroFolio%></span></td>
				</tr>
			  </table>
			  </TD>
 		</TR>

		<TR>
		 	<TD>

		 		<TABLE ALIGN="CENTER" WIDTH="600" BORDER="0" BORDERCOLOR = "#000000" CELLSPACING=0 CELLPADDING=1>

				 		<tr class="Estilo1">
						 	<TD colspan=4 align="center" class="Estilo33">
					 		  ANEXO <%=UCASE(session("NOMBRE_CONV_PAGARE"))%><BR>
					 		</TD>
				 		</TR>
				 		<TR>
						 	<td colspan=4><div align="center"><%=strMandante%></div></TD>
				 		</TR>
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
							<TD align="right">Costas Personales: </TD><TD align="right">$ <%=FN(intOriginalHonorarios,0)%></TD>
							<TD align="right">$ <%=FN(intDescHonorarios,0)%></TD><TD align="right">$ <%=FN(intTotHonorarios,0)%></TD>
						</TR>
						<TR HEIGHT=15 class="Estilo38">
							<TD align="right"><%=strNombreIC%>.: </TD><TD align="right">$ <%=FN(intOriginalIndemComp,0)%></TD>
							<TD align="right">$ <%=FN(intDescIndemComp,0)%></TD><TD align="right">$ <%=FN(intTotIndemComp,0)%></TD>
						</TR>
						<TR HEIGHT=15 class="Estilo38">
							<TD align="right">Gastos Judiciales: </TD><TD align="right">$ <%=FN(intOriginalGastos,0)%></TD>
							<TD align="right">$ <%=FN(intDescGastos,0)%></TD><TD align="right">$ <%=FN(intTotGastos,0)%></TD>
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
							<TD align="right" colspan=3>Intereses <%=session("NOMBRE_CONV_PAGARE")%>.:</TD>	<TD align="right"><strong>$ <%=FN(intInteresConvenio,0)%></strong></TD>
						</TR>
						<TR HEIGHT=15 class="Estilo38">
							<TD align="right" colspan=3>&nbsp</TD><TD align="right" class="Estilo38">&nbsp</TD>
						</TR>
						<TR HEIGHT=15 class="Estilo38">
							<TD align="right" colspan=3>&nbsp</TD><TD align="right" class="Estilo38">&nbsp</TD>
						</TR>

						<TR HEIGHT=15 class="Estilo38">
							<TD align="right" colspan=3><b>Saldo <%=session("NOMBRE_CONV_PAGARE")%>: <b></TD>
							<TD align="right"><strong>$ <%=FN(intTotalConvenio + intInteresConvenio -  intPie,0)%></strong></TD>
						</TR>
					</table>
				</tr>
			</TD>
 		</TR>
 </TABLE>
 	<INPUT TYPE="hidden" NAME="intIntConvenio" value="<%=intMontoTotal%>">
	<INPUT TYPE="hidden" NAME="intValorCuota" value="<%=Round(intValorCuota,0)%>">
	<INPUT TYPE="hidden" NAME="strSede" value="<%=strSede%>">

</FORM>

<TABLE ALIGN="CENTER" WIDTH="600" BORDER="0" BORDERCOLOR = "#000000" CELLSPACING=0 CELLPADDING=1>
			<TR class="Estilo1">
				<TD align="LEFT" class="Estilo34">
					<acronym title="GRABAR <%=UCASE(session("NOMBRE_CONV_PAGARE"))%>">
						<input name="BT_GRABAR" type="button" onClick="Grabar();" value="Grabar">
					</acronym>
				</TD>
				<TD align="RIGHT" class="Estilo34">
					<acronym title="IMPRIMIR <%=UCASE(session("NOMBRE_CONV_PAGARE"))%>">
						<input name="BT_IMPRIMIR" type="button" onClick="window.print();" value="Imprimir">
					</acronym>
				</TD>

			</TR>
	</TABLE>





&nbsp;&nbsp;
</body>
</html>