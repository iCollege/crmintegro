<% @LCID = 1034 %>
<!--#include file="arch_utils.asp"-->
<!--#include file="../lib/comunes/rutinas/funciones.inc" -->
<!--#include file="../lib/comunes/rutinas/rutinasFecha.inc" -->
<!--#include file="lib.asp"-->
<!--#include file="asp/comunes/general/RutinasVarias.inc" -->
<!--#include file="../lib/comunes/rutinas/TraeCampo.inc" -->

<%

intNroComp=request("intNroComp")
strImprime=request("strImprime")
strRemesar=request("strRemesar")

intCodRemesa = request("CB_REMESA")
intCodUsuario = request("CB_COBRADOR")

intCliente=session("ses_codcli")

If Trim(intCliente) = "" Then intCliente = "1000"



AbrirSCG()
		strSql="SELECT * FROM PARAMETROS"
		set rsParam = Conn.execute(strSql)
		If not rsParam.eof then
			strNomLogo = Trim(rsParam("NOMBRE_LOGO_TOP_IZQ"))
			strNomSistema = Trim(rsParam("NOMBRE_SISTEMA"))
			strNomEmpresa = Trim(rsParam("NOMBRE_EMPRESA"))
			strDirEmpresa = Trim(rsParam("DIRECCION_EMPRESA"))
			strTelEmpresa = Trim(rsParam("TELEFONOS_EMPRESA"))
			strSitioWebEmpresa = Trim(rsParam("SITIO_WEB_EMPRESA"))
		End if
	CerrarSCG()

%>
<title></title>

<style type="text/css">
<!--
.Estilo37 {color: #FFFFFF}
.Estilo370 {color: #000000}
-->
</style>

<table width="600" align="CENTER" border="0">

<tr>
    <td valign="top">


		<%

		If Trim(intCliente) <> "" then
		abrirscg()

		strSql = "SELECT ID_PAGO, COMP_INGRESO, USRINGRESO, TIPO_PAGO, COD_CLIENTE, NRO_BOLETA, RUTDEUDOR , MONTO_CAPITAL, INTERES_PLAZO, GASTOSJUDICIALES, INDEM_COMP, MONTO_EMP, CONVERT(VARCHAR(10),FECHA_PAGO,103) as FECHA_PAGO, ID_CONVENIO, GASTOSOTROS, GASTOSADMINISTRATIVOS "
		strSql = strSql & " FROM CAJA_WEB_EMP WHERE COMP_INGRESO = " & intNroComp

		set rsCaja=Conn.execute(strSql)
		If Not rsCaja.eof Then

			intIdPago = rsCaja("ID_PAGO")
			intCliente = rsCaja("COD_CLIENTE")
			intUsrIngreso = rsCaja("USRINGRESO")
			strTipoPago = rsCaja("TIPO_PAGO")
			strBoleta = rsCaja("NRO_BOLETA")

			intIdConvenio = ValNulo(rsCaja("ID_CONVENIO"),"N")

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


			'strSql = "SELECT DISTINCT IsNull(CODREMESA,0) AS CODREMESA FROM CUOTA WHERE RUTDEUDOR = '" & strRut & "' AND CODCLIENTE = '" & intCliente & "'"
			'strSql = strSql & " AND NRODOC IN (SELECT NRODOC FROM CONVENIO_CUOTA WHERE ID_CONVENIO = " & intIdConvenio & ")"

			strSql = "SELECT DISTINCT IsNull(CODREMESA,0) AS CODREMESA FROM CONVENIO_CUOTA WHERE ID_CONVENIO = " & intIdConvenio
			'REsponse.write "strSql=" & strSql
			'REsponse.End

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
				<td><img src="../images/reintegra.jpg" width="154" height="50"></td>
				<td><span class="Estilo370"><B>COMPROBANTE DE PAGO DE CONVENIO</B></td>
				<td width="154">
					<table border="0">
						<tr>
							<td><span class="Estilo370"><B>NRO.COMPROB. :</B></td>
							<td align="RIGHT"><span class="Estilo370"><B><%=rsCaja("COMP_INGRESO")%></B></td>
						</tr>
						<tr>
							<td><span class="Estilo370">Nro.Convenio :</td>
							<td align="RIGHT"><span class="Estilo370"><%=intIdConvenio%></td>
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
		<td><span class="Estilo370">CHEQUE</span></td>
		<td><span class="Estilo370">MONTO</span></td>
		<td><span class="Estilo370">FECHA.</span></td>
	</tr>

	<%
		strSql = "SELECT ISNULL(NOMBRE_B,'') AS NOMBRE_B, ISNULL(NRO_CTACTE,'') AS NRO_CTACTE, ISNULL(NRO_DEPOSITO,'') AS NRO_DEPOSITO, ISNULL(NRO_CHEQUE,'') AS NRO_CHEQUE, MONTO, ISNULL(VENCIMIENTO,'') AS VENCIMIENTO, FORMA_PAGO FROM CAJA_WEB_EMP_DOC_PAGO, BANCOS WHERE BANCOS.CODIGO =* CAJA_WEB_EMP_DOC_PAGO.COD_BANCO AND ID_PAGO = " & rsCaja("ID_PAGO") & " ORDER BY FORMA_PAGO, VENCIMIENTO, NRO_CTACTE, NRO_CHEQUE"
		''rESPONSE.WRITE strSql
		set rsDocPago=Conn.execute(strSql)
		If Not rsDocPago.eof Then
			strBanco = 0
			intSumaCapital = 0

		Do While not rsDocPago.Eof
			strBanco = rsDocPago("NOMBRE_B")
			strTipoPag=Trim(rsDocPago("FORMA_PAGO"))

			If Trim(rsDocPago("FORMA_PAGO")) = "EF" Then strBanco  = "PAGO EN EFECTIVO"
			If Trim(rsDocPago("FORMA_PAGO")) = "CU" Then strBanco  = "CUOTA"
			If Trim(rsDocPago("FORMA_PAGO")) = "AB" Then strBanco  = "ABONO"

			If Trim(rsDocPago("FORMA_PAGO")) = "DP" Then
				strNroCheque = rsDocPago("NRO_DEPOSITO")
			Else
				strNroCheque = rsDocPago("NRO_CHEQUE")
			End If


			strCtaCte = rsDocPago("NRO_CTACTE")
			If trim(strCtaCte) = "" Then strCtaCte = "&nbsp;"
			strNroCheque = rsDocPago("NRO_CHEQUE")
			If trim(strNroCheque) = "" Then strNroCheque = "&nbsp;"
			strMonto = rsDocPago("MONTO")
			strVencimiento = Saca1900(rsDocPago("VENCIMIENTO"))
			If trim(strVencimiento) = "" Then strVencimiento = "&nbsp;"

			If TrIM(strMonto) <> "0" Then
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
			End If
			rsDocPago.movenext
		Loop
		End If

		If Trim(strTipoPago) = "CO" Then
			strGlosaTotal = "TOTAL PAGO"
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



<%


				strSql = "SELECT COUNT(*) as CANTC FROM CONVENIO_DET WHERE CUOTA <> 0 AND ID_CONVENIO = " & intIdConvenio
				set rsDetConv=Conn.execute(strSql)
				If Not rsDetConv.Eof Then
					intNroCuotas = rsDetConv("CANTC")
				Else
					intNroCuotas = 0
				End If

				strSql = "SELECT * FROM CAJA_WEB_EMP_DETALLE WHERE ID_PAGO = " & rsCaja("ID_PAGO")
				''rESPONSE.WRITE "strSql=" & strSql
				set rsDetCaja=Conn.execute(strSql)
				If Not rsDetCaja.eof Then
					intNroDoc = 0
					intSumaCapital = 0
					strFacturas=""
					strPie=""
					strCuotas=""
					intPagoPie = 0
					intPagoCuota = 0
					strDetalleCuotas = ""
					strInfractora = ""
					Do While not rsDetCaja.Eof

						strCuenta = rsDetCaja("CUENTA")
						intLargo = Len(strCuenta)
						If intLargo >= 10 Then strInfractora = "S"

						If Trim(rsDetCaja("NRODOC")) = "0" Then
							strPie = rsDetCaja("NRODOC")
							intPagoPie = intPagoPie + rsDetCaja("CAPITAL")
						End If
						If Trim(rsDetCaja("NRODOC")) <> "0" Then
							strCuotas = strCuotas & ", " & rsDetCaja("NRODOC")
							intPagoCuota = intPagoCuota + rsDetCaja("CAPITAL")
						End If

						strSql="SELECT CUOTA, FECHA_PAGO FROM CONVENIO_DET WHERE CUOTA <> 0 AND ID_CONVENIO = " & intIdConvenio & " AND CUOTA = " & rsDetCaja("NRODOC")
						set RsCuota=Conn.execute(strSql)
						If not RsCuota.eof then
							strNroCuota = RsCuota("CUOTA")
							strFechaPagoCuota = RsCuota("FECHA_PAGO")
						Else
							strNroCuota = ""
							strFechaPagoCuota = ""

						End if
						RsCuota.close
						set RsCuota=nothing
						strNombreDeudor=""
						strMostrarRut=""

						If Trim(strNroCuota) <> "" Then
							strDetalleCuotas = strDetalleCuotas & "<BR>Cuota " & strNroCuota & ", Vencimiento = " & strFechaPagoCuota
						End if

					rsDetCaja.movenext
					intNroDoc = intNroDoc + 1
					Loop
				End If
				strCuotas=Mid(strCuotas,2,len(strCuotas))

				strCajaNro="Santiago"

				If trim(strPie) <> "" Then
					strPie = "Pago del Pie del convenio"
				End if
				If trim(strCuotas) <> "" Then
					strCuotas = "Pago de las siguientes Cuotas :" & strCuotas & " de " & intNroCuotas
				End if
				If intPagoPie > 0 Then
					intPagoPie = intMontoCapital
				End If
			%>



<table width="600">
	<tr>
		<td>
			<table width="350" border="1" bordercolor = "#000000" cellSpacing=0 cellPadding=1>
				<tr>
					<td colspan=2><span class="Estilo370"><b>Detalle Deuda</b></td>
				</tr>
				<tr>
					<td><span class="Estilo370" width="125">PIE</span></td>
					<td ALIGN="RIGHT" width="125"><%=FN(intPagoPie,0)%></td>
				</tr>
				<tr>
					<td><span class="Estilo370">CUOTAS</span></td>
					<td ALIGN="RIGHT"><%=FN(intPagoCuota,0)%></td>
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
					<td><span class="Estilo370">GASTOS OPERACIONALES</span></td>
					<td ALIGN="RIGHT"><%=FN(intIndemnizacion,0)%></td>
				</tr>
				<tr>
					<td><span class="Estilo370">HONORARIOS</span></td>
					<td ALIGN="RIGHT"><%=FN(intHonorarios,0)%></td>
				</tr>
				<tr>
					<td><span class="Estilo370">GASTOS PROTESTOS</span></td>
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


		</td>

		<td>
			<%
			If Trim(strRemesar)="S" and trim(strPie) <> "" Then
				If Trim(strInfractora) = "S" Then
					intPorcentaje = 18
				Else
					intPorcentaje = 9
				End If
				intPorcentaje = 9
				intICNormal = Round(intIndemnizacion * 100/109,0)
				intICNormal_9 = Round(intICNormal * 9/100,0)
			%>
				<table width="250" border="1" bordercolor = "#000000" cellSpacing=0 cellPadding=1>
					<tr>
						<td><span class="Estilo370"><b>G.Oper. / Indem. Comp.</b></td>
						<TD ALIGN="RIGHT"><span class="Estilo370"><b><%=FN(intIndemnizacion,0)%></b></td>
					</tr>
					<tr>
						<td><span class="Estilo370"><b>G.Oper. / Indem. Comp. Empresa</b></td>
						<TD ALIGN="RIGHT"><span class="Estilo370"><b><%=FN(intICNormal_9,0)%></b></td>
					</tr>
					<tr>
						<td><span class="Estilo370"><b>G.Oper. / Indem. Comp. AVS a remesar</b></td>
						<TD ALIGN="RIGHT"><span class="Estilo370"><b><%=FN(intICNormal,0)%></b></td>
					</tr>
				</table>
			<% Else%>
				&nbsp;
			<% End If%>
		</td>
	</tr>
</table>





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
					<td><span class="Estilo370"><b>Detalle del Pago</b></td>
				</tr>
				<tr>
					<td><span class="Estilo370" width="125"><%=strPie&"<br>"&strCuotas&"<br>"&strDetalleCuotas%></td>
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
			cuotas  establecidas, INTEGROCORP.  y/o nuestro  Mandante  quedan  facultadas  para  continuar el
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
				<%=strNomEmpresa%>&nbsp;&nbsp;Dirección : <%=strDirEmpresa%>&nbsp;&nbsp;Telefono : <%=strTelEmpresa%>
				<BR>			<%=strSitioWebEmpresa%>

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
