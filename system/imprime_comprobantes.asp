<% @LCID = 1034 %>
<!--#include file="arch_utils.asp"-->
<!--#include file="../lib/comunes/rutinas/funciones.inc" -->
<!--#include file="../lib/comunes/rutinas/rutinasFecha.inc" -->
<!--#include file="lib.asp"-->
<!--#include file="asp/comunes/general/RutinasVarias.inc" -->
<!--#include file="../lib/comunes/rutinas/TraeCampo.inc" -->

<%

intIdPagoR=request("intNroComp")
intCliente=session("ses_codcli")
If Trim(intCliente) = "" Then intCliente = "1000"

%>
<title></title>

<style type="text/css">
<!--
.Estilo37 {color: #FFFFFF}
.Estilo370 {color: #000000}

H1.SaltoDePagina {PAGE-BREAK-AFTER: always}
	.transpa {
	background-color: transparent;
	border: 1px solid #FFFFFF;
	text-align:center
	}
-->
</style>





<%
'Response.write "hd=" & Request("HD_COMP")
'Response.End



varrComp = split(request("HD_COMP"), ",")



n=0
For Each XX in varrComp


strObjeto = "CH_" & Trim(varrComp(n))

'response.write "<br>-" & strObjeto & "- = " & Request(strObjeto)

'response.write "<br>CH_9400" & Request("CH_9400")

'response.write "<br>CH_9399" & Request("CH_9399")

If UCASE(Trim(Request(strObjeto))) = "ON" Then

%>

<table width="600" align="CENTER" border="0">

<tr>
    <td valign="top">


		<%

		intIdPagoR = varrComp(n)

		If Trim(intCliente) <> "" then
		abrirscg()

		strSql = "SELECT COMP_INGRESO FROM CAJA_WEB_EMP WHERE ID_PAGO = " & intIdPagoR
		'Response.write "" & strSql
		'Response.End
		set rsPago=Conn.execute(strSql)
		If Not rsPago.eof Then
			intNroComp = rsPago("COMP_INGRESO")
		Else
			intNroComp = 0
		End If


		strSql = "SELECT ID_PAGO, COMP_INGRESO, USRINGRESO, TIPO_PAGO, COD_CLIENTE, NRO_BOLETA, RUTDEUDOR , MONTO_CAPITAL, INTERES_PLAZO, GASTOSJUDICIALES, INDEM_COMP, MONTO_EMP, GASTOSADMINISTRATIVOS, GASTOSOTROS, CONVERT(VARCHAR(10),FECHA_PAGO,103) as FECHA_PAGO "
		strSql = strSql & " FROM CAJA_WEB_EMP WHERE COMP_INGRESO = " & intNroComp

		set rsCaja=Conn.execute(strSql)
		If Not rsCaja.eof Then

			intIdPago = rsCaja("ID_PAGO")
			intCliente = rsCaja("COD_CLIENTE")
			intUsrIngreso = rsCaja("USRINGRESO")
			strTipoPago = rsCaja("TIPO_PAGO")
			strBoleta = rsCaja("NRO_BOLETA")


			strRut = rsCaja("RUTDEUDOR")
			strFechaPago = rsCaja("FECHA_PAGO")
			strMostrarRut = strRut
			intMontoCapital = ValNulo(rsCaja("MONTO_CAPITAL"),"N")
			intIntereses = ValNulo(rsCaja("INTERES_PLAZO"),"N")
			intGastosJudiciales = ValNulo(rsCaja("GASTOSJUDICIALES"),"N")
			intIndemnizacion = ValNulo(rsCaja("INDEM_COMP"),"N")
			intHonorarios = ValNulo(rsCaja("MONTO_EMP"),"N")
			intGastosOperacionales = ValNulo(rsCaja("GASTOSOTROS"),"N")
			intGastosAdministrativos = ValNulo(rsCaja("GASTOSADMINISTRATIVOS"),"N")
			intTotalPago = intMontoCapital + intIntereses + intGastosJudiciales + intIndemnizacion + intHonorarios + intGastosOperacionales + intGastosAdministrativos

			ssql="SELECT NOMBREDEUDOR FROM DEUDOR WHERE RUTDEUDOR='" & strRut & "' AND CODCLIENTE = '" & intCliente & "'"
			set RsDeudor=Conn.execute(ssql)
			if not RsDeudor.eof then
				strNombreDeudor = RsDeudor("NOMBREDEUDOR")
			end if
			RsDeudor.close
			set RsDeudor=nothing

			ssql=""
			ssql="SELECT TOP 1 Calle,Numero,Comuna,Resto,Correlativo,Estado FROM DEUDOR_DIRECCION WHERE RUTDEUDOR='"&strRut&"' and ESTADO<>'2' ORDER BY Correlativo DESC"
			set rsDIR=Conn.execute(ssql)
			if not rsDIR.eof then
				calle_deudor=rsDIR("Calle")
				numero_deudor=rsDIR("Numero")
				comuna_deudor=rsDIR("Comuna")
				resto_deudor=rsDIR("Resto")
				strDirDeudor = calle_deudor & " " & numero_deudor & " " & resto_deudor & " " & comuna_deudor
			end if
			rsDIR.close
			set rsDIR=nothing

			ssql=""
			ssql="SELECT TOP 1 CODAREA,TELEFONO,CORRELATIVO,ESTADO FROM DEUDOR_TELEFONO WHERE  RUTDEUDOR='"&strRut&"' and ESTADO<>'2' ORDER BY Correlativo DESC"
			set rsFON=Conn.execute(ssql)
			if not rsFON.eof then
				codarea_deudor = rsFON("CodArea")
				Telefono_deudor = rsFON("Telefono")
				strFono = codarea_deudor & "-" & Telefono_deudor
			end if
			rsFON.close
			set rsFON=nothing


			ssql=""
			ssql="SELECT TOP 1 RUTDEUDOR,CORRELATIVO,FECHAINGRESO,EMAIL,ESTADO FROM DEUDOR_EMAIL WHERE  RUTDEUDOR='"&strRut&"' and ESTADO<>'2' ORDER BY Correlativo DESC"
			set rsMAIL=Conn.execute(ssql)
			if not rsMAIL.eof then
				strEmail = rsMAIL("EMAIL")
			end if
			rsMAIL.close
			set rsMAIL=nothing

			strNomCliente = TraeCampoId(Conn, "DESCRIPCION", intCliente, "CLIENTE", "CODCLIENTE")
			strUsrIngreso = TraeCampoId(Conn, "NOMBRES_USUARIO", intUsrIngreso, "USUARIO", "ID_USUARIO") & " " & TraeCampoId(Conn, "APELLIDOS_USUARIO", intUsrIngreso, "USUARIO", "ID_USUARIO")
			strDescTipoPago = TraeCampoId2(Conn, "DESC_TIPO_PAGO", strTipoPago, "CAJA_TIPO_PAGO", "ID_TIPO_PAGO")

			strFormaPago=""
			strSql = "SELECT DISTINCT IsNull(FORMA_PAGO,'') AS FORMA_PAGO FROM CAJA_WEB_EMP_DOC_PAGO WHERE ID_PAGO = " & intIdPago
			set rsFPago=Conn.execute(strSql)
			Do While Not rsFPago.eof
				strFormaPago = strFormaPago & " - " & TRIM(TraeCampoId2(Conn, "DESC_FORMA_PAGO", rsFPago("FORMA_PAGO"), "CAJA_FORMA_PAGO", "ID_FORMA_PAGO"))
				rsFPago.movenext
			Loop
			rsFPago.close
			set rsFPago=nothing

			If Trim(strFormaPago) <> "" Then strFormaPago = Mid(strFormaPago, 3, LEN(strFormaPago))




			strSql = "SELECT DISTINCT IsNull(CODREMESA,0) AS CODREMESA FROM CUOTA WHERE RUTDEUDOR = '" & strRut & "' AND CODCLIENTE = '" & intCliente & "'"
			strSql = strSql & " AND NRODOC IN (SELECT NRODOC FROM CAJA_WEB_EMP_DETALLE WHERE ID_PAGO = " & intIdPago & ")"
			'REsponse.write "strSql=" & strSql
			'REsponse.End
			strAsignacion = ""
			set rsAsign=Conn.execute(strSql)
			Do While Not rsAsign.eof
				strAsignacion = strAsignacion & " - " & TRIM(rsAsign("CODREMESA"))
				rsAsign.movenext
			Loop
			rsAsign.close
			set rsAsign=nothing
			If Trim(strAsignacion) <> "" Then strAsignacion = Mid(strAsignacion, 3, LEN(strAsignacion))

			%>

		<table width="600" border="0">
			<tr>
				<td><img src="reintegra.jpg" width="154" height="50"></td>
				<td><span class="Estilo370"><B>COMPROBANTE DE PAGO</B></td>
				<td width="154">
					<table border="0">
						<tr>
							<td><span class="Estilo370">Nro.Comprob. :</td>
							<td align="RIGHT"><span class="Estilo370"><%=rsCaja("COMP_INGRESO")%></td>
						</tr>
						<tr>
							<td><span class="Estilo370">Boleta :</td>
							<td align="RIGHT"><span class="Estilo370"><%=strBoleta%></td>
						</tr>
						<tr>
							<td><span class="Estilo370">Fecha :</td>
							<td align="RIGHT"><span class="Estilo370"><%=rsCaja("FECHA_PAGO")%></td>
						</tr>
					</table>
				</td>
			</tr>
		</table>
		<table width="600" border="0">
			<tr>
				<td colspan=4>&nbsp</td>
			</tr>
			<tr>
				<td colspan=4><span class="Estilo370"><b>Datos Deudor</b></td>
			</tr>
			<tr>
				<td width="100"><span class="Estilo370">Nombre :</td>
				<td width="300"><span class="Estilo370"><%=strNombreDeudor%></td>
				<td width="100"><span class="Estilo370">Rut :</td>
				<td width="100"><span class="Estilo370"><%=strRut%></td>
			</tr>
			<tr>
				<td><span class="Estilo370">Direccion :</td>
				<td><span class="Estilo370"><%=strDirDeudor%></td>
				<td><span class="Estilo370">Telefono red fija :</td>
				<td><span class="Estilo370"><%=strFono%></td>
			</tr>
			<tr>
				<td><span class="Estilo370">Telefono celular :</td>
				<td><span class="Estilo370"><%=strFonoCelular%></td>
				<td><span class="Estilo370">Email :</td>
				<td><span class="Estilo370"><%=strEmail%></td>
			</tr>
		</table>


		<table width="600" border="0">
			<tr>
				<td colspan=4>&nbsp</td>
			</tr>
			<tr>
				<td colspan=4><span class="Estilo370"><b>Datos Deuda</b></td>
			</tr>
			<tr>
				<td width="100"><span class="Estilo370">Cedente :</td>
				<td width="300"><span class="Estilo370"><%=strNomCliente%></td>
				<td width="100"><span class="Estilo370">Asignación :</td>
				<td width="100"><span class="Estilo370"><%=strAsignacion%></td>
			</tr>
		</table>

		<table width="600" border="0">
			<tr>
				<td>&nbsp</td>
			</tr>
			<tr>
				<td colspan=4><span class="Estilo370"><b>Detalle Pago</b></td>
			</tr>
			<tr>
				<td width="100"><span class="Estilo370">Forma de Pago :</td>
				<td width="300"><span class="Estilo370"><%=strFormaPago%></td>
				<td width="100"><span class="Estilo370">Tipo de Pago :</td>
				<td width="100"><span class="Estilo370"><%=strDescTipoPago%></td>
			</tr>
			<tr>
				<td>&nbsp</td>
			</tr>
		</table>


<table width="600" border="1" bordercolor = "#000000" cellSpacing=0 cellPadding=1>
	<tr>
		<td><span class="Estilo370">TIPO</span></td>
		<td><span class="Estilo370">BANCO</span></td>
		<td><span class="Estilo370">CTA CTE NRO.</span></td>
		<td><span class="Estilo370">CHEQUE/DEP</span></td>
		<td><span class="Estilo370">MONTO</span></td>
		<td><span class="Estilo370">FECHA.</span></td>
	</tr>

	<%
		strSql = "SELECT NOMBRE_B , IsNull(NRO_CTACTE,'') as NRO_CTACTE, IsNull(NRO_CHEQUE,'') as NRO_CHEQUE, IsNull(NRO_DEPOSITO,'') as NRO_DEPOSITO, MONTO,  IsNull(VENCIMIENTO,'') as VENCIMIENTO , FORMA_PAGO FROM CAJA_WEB_EMP_DOC_PAGO, BANCOS WHERE BANCOS.CODIGO = IsNull(CAJA_WEB_EMP_DOC_PAGO.COD_BANCO,0) AND ID_PAGO = " & rsCaja("ID_PAGO") & " ORDER BY FORMA_PAGO, VENCIMIENTO, NRO_CTACTE, NRO_CHEQUE"
		'rESPONSE.WRITE strSql
		set rsDocPago=Conn.execute(strSql)
		If Not rsDocPago.eof Then
			strBanco = 0
			intSumaCapital = 0

		Do While not rsDocPago.Eof
			strBanco = rsDocPago("NOMBRE_B")
			'Response.write "<br>FORMA_PAGO = " & Trim(rsDocPago("FORMA_PAGO"))
			'Response.write "<br>strBanco = " & strBanco

			strTipoPag=Trim(rsDocPago("FORMA_PAGO"))

			If Trim(rsDocPago("FORMA_PAGO")) = "EF" Then strBanco  = "PAGO EN EFECTIVO"
			If Trim(rsDocPago("FORMA_PAGO")) = "CU" Then strBanco  = "CUOTA"
			If Trim(rsDocPago("FORMA_PAGO")) = "AB" Then strBanco  = "ABONO"

			If Trim(rsDocPago("FORMA_PAGO")) = "DP" Then
				strNroCheque = rsDocPago("NRO_DEPOSITO")
			Else
				strNroCheque = rsDocPago("NRO_CHEQUE")
			End If

			'Response.write "<br>strBanco = " & strBanco


			strCtaCte = rsDocPago("NRO_CTACTE")
			If trim(strCtaCte) = "" Then strCtaCte = "&nbsp;"

			If trim(strNroCheque) = "" Then strNroCheque = "&nbsp;"
			strMonto = rsDocPago("MONTO")
			strVencimiento = Saca1900(rsDocPago("VENCIMIENTO"))
			If trim(strVencimiento) = "" Then strVencimiento = "&nbsp;"
	%>

		<tr>
			<td><%=strTipoPag%></td>
			<td><%=strBanco%></td>
			<td><%=strCtaCte%></td>
			<td><%=strNroCheque%></td>
			<td ALIGN="RIGHT"><%=FN(strMonto,0)%></td>
			<td><%=strVencimiento%></td>
		</tr>

	<%
			rsDocPago.movenext
		Loop
		End If

		If Trim(strTipoPago) = "CO" Then
			strGlosaTotal = "TOTAL DEUDA"
		Else
			strGlosaTotal = "TOTAL PAGO"
		End if
	%>
</table>

<table width="600">
	<tr>
		<td>&nbsp</td>
	</tr>
</table>

<table width="400" border="1" bordercolor = "#000000" cellSpacing=0 cellPadding=1>
	<tr>
		<td colspan=2><span class="Estilo370"><b>Detalle Deuda</b></td>
	</tr>
	<tr>
		<td><span class="Estilo370" width="125">CAPITAL</span></td>
		<td ALIGN="RIGHT" width="125"><%=FN(intMontoCapital,0)%></td>
	</tr>
	<tr>
		<td><span class="Estilo370">INDEMNIZACION</span></td>
		<td ALIGN="RIGHT"><%=FN(intIndemnizacion,0)%></td>
	</tr>
	<tr>
		<td><span class="Estilo370">INTERESES</span></td>
		<td ALIGN="RIGHT"><%=FN(intIntereses,0)%></td>
	</tr>
	<tr>
		<td><span class="Estilo370">GASTOS JUDICIALES</span></td>
		<td ALIGN="RIGHT"><%=FN(intGastosJudiciales,0)%></td>
	</tr>
	<tr>
		<td><span class="Estilo370">HONORARIOS</span></td>
		<td ALIGN="RIGHT"><%=FN(intHonorarios,0)%></td>
	</tr>
	<tr>
		<td><span class="Estilo370">GASTOS OPERACIONALES</span></td>
		<td ALIGN="RIGHT"><%=FN(intGastosOperacionales,0)%></td>
	</tr>
	<tr>
		<td><span class="Estilo370">GASTOS ADMINISTRATIVOS</span></td>
		<td ALIGN="RIGHT"><%=FN(intGastosAdministrativos,0)%></td>
	</tr>



	<tr>
		<td><span class="Estilo370"><%=strGlosaTotal%></span></td>
		<td ALIGN="RIGHT"><%=FN(intTotalPago,0)%></td>
	</tr>
</table>

<%

				strSql = "SELECT * FROM CAJA_WEB_EMP_DETALLE WHERE ID_PAGO = " & rsCaja("ID_PAGO")
				set rsDetCaja=Conn.execute(strSql)
				If Not rsDetCaja.eof Then
					intNroDoc = 0
					intSumaCapital = 0
					strFacturas=""
					Do While not rsDetCaja.Eof

						strFacturas = strFacturas & ", " & rsDetCaja("NRODOC")
						intCapital = rsDetCaja("CAPITAL")
						strSql="SELECT CUENTA,FECHAVENC FROM CUOTA WHERE RUTDEUDOR = '" & strRut & "' AND CODCLIENTE = '" & intCliente & "' AND NRODOC = '" & strNroDoc & "'"
						set RsCuota=Conn.execute(strSql)
						If not RsCuota.eof then
							strCuenta = RsCuota("CUENTA")
							strFechaVenc = RsCuota("FECHAVENC")
						End if
						RsCuota.close
						set RsCuota=nothing
			%>

			<%
					strNombreDeudor=""
					strMostrarRut=""
					rsDetCaja.movenext
					intNroDoc = intNroDoc + 1
					Loop
				End If
				strFacturas=Mid(strFacturas,2,len(strFacturas))

				strCajaNro="Santiago"
			%>


<table width="600">
	<tr>
		<td>&nbsp</td>
	</tr>
</table>


<table width="600" border="0">
	<tr>
		<TD VALIGN = "TOP">

			<TABLE VALIGN = "TOP" width="400" border="1" bordercolor = "#000000" cellSpacing=0 cellPadding=1>
				<tr>
					<td><span class="Estilo370"><b>Facturas en pago</b></td>
				</tr>
				<tr>
					<td><span class="Estilo370" width="125"><%=strFacturas%></td>
				</tr>
			</table>

		</td>
		<td VALIGN = "TOP">

			<TABLE width="200" border="1" bordercolor = "#000000" cellSpacing=0 cellPadding=1>
				<tr>
					<td width="100"><span class="Estilo370"><b>Caja:</b></td>
					<td width="100"><span class="Estilo370" width="125"><%=strCajaNro%></td>
				</tr>
				<tr>
					<td><span class="Estilo370"><b>Ejecutivo :</b></td>
					<td><span class="Estilo370" width="125"><%=strUsrIngreso%></td>
				</tr>
			</table>



		</td>
	</tr>
</table>


<%If Trim(strTipoPago) = "CO" Then%>
<br>
<br>
<TABLE WIDTH="600" border="0">
	<TR>
		<TD VALIGN = "TOP"><b>
			En caso de incumpliento o simple atraso en el pago de cualquiera de las
			cuotas  establecidas, LLACRUZ  y/o nuestro  Mandante  quedan  facultadas  para  continuar el
			ejercicio  de las acciones legales de  cobro, devengandose como interes, el maximo convencional
			estipulado por la Ley.
			</b>
		</TD>
	</TR>
</TABLE>
<br>
<%End If%>




<table width="600">
	<tr>
		<td>&nbsp</td>
	</tr>
</table>

<table width="600" border="1" bordercolor = "#000000" cellSpacing=0 cellPadding=1>
		<tr>
		<td class="Estilo370" ALIGN="CENTER">

		Huelen 164 Of.301 Providencia<br>
		Telefonos 697-1562 672-6629 672-9490 672-4070<br>
		www.llacruz.cl
		</td>
	</tr>
</table>

		<%

		End If
		rsCaja.close
		set rsCaja=nothing
		''Response.End
		%>


		<%	cerrarscg()
		end if %>

	</td>
	</tr>
	</table>


	</td>



</table>

<BR>
   	<H1 class=SaltoDePagina> </H1>
<BR>



<%

		End If
	  n=n+1
	Next

%>
