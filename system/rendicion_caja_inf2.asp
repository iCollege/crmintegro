<% @LCID = 1034 %>
<!--#include file="arch_utils.asp"-->
<!--#include file="sesion.asp"-->
<!--#include file="../lib/comunes/rutinas/funciones.inc" -->
<!--#include file="../lib/comunes/rutinas/rutinasFecha.inc" -->
<!--#include file="lib.asp"-->
<!--#include file="asp/comunes/general/RutinasVarias.inc" -->

<style type="text/css">
	H1.SaltoDePagina {PAGE-BREAK-AFTER: always}
	.transpa {
	background-color: transparent;
	border: 1px solid #FFFFFF;
	text-align:center
	}

</style>

<script language="JavaScript">
function ventanaSecundaria (URL){
	window.open(URL,"DETALLE","width=200, height=200, scrollbars=no, menubar=no, location=no, resizable=no")
}

</script>
<%
inicio= request("inicio")
termino= request("termino")

strInicio=Mid(inicio,7,4) & Mid(inicio,4,2) & Mid(inicio,1,2)
strTermino=Mid(termino,7,4) & Mid(termino,4,2) & Mid(termino,1,2)

abrirscg()
	If Trim(termino) = "" Then
		termino = TraeFechaActual(Conn)
	End If
	If Trim(inicio) = "" Then
		'inicio = TraeFechaActual(Conn)
		'inicio = "01/" & Mid(TraeFechaActual(Conn),4,10)
		inicio = termino
	End If
cerrarscg()

intCliente = request("CB_CLIENTE")

intCliente = session("ses_codcli")

intCodRemesa = request("CB_REMESA")
intCodUsuario = request("CB_COBRADOR")

If Trim(intCliente) = "" Then intCliente = "1000"

%>
<title>INFORME RECUPERACIÓN</title>

<style type="text/css">
<!--
.Estilo37 {color: #FFFFFF}
.Estilo370 {color: #000000}
-->
</style>


<table width="100%" border="1" bordercolor="#FFFFFF">
	<tr>
		<TD height="20" ALIGN=LEFT class="pasos2_i">
			<B>RENDICION DE PAGOS</B>
		</TD>
	</tr>
</table>

<table width="800" align="CENTER" border="0">
  <tr>
    <td valign="top">
	<form name="datos" method="post">
	<table width="100%" border="0">
		<tr bgcolor="#<%=session("COLTABBG")%>" class="Estilo13">
			<td width="18%">MANDANTE</td>
			<td width="18%">EJECUTIVO</td>
			<td width="18%">F.INICIO</td>
			<td width="18%">F.TERMINO</td>
			<td width="10%">&nbsp</td>
		</tr>
		<tr>
			<td>
			<select name="CB_CLIENTE">
				<%
				abrirscg()
				ssql="SELECT CODCLIENTE,DESCRIPCION FROM CLIENTE WHERE CODCLIENTE = '" & intCliente & "' ORDER BY RAZON_SOCIAL"

				set rsCLI= Conn.execute(ssql)
				if not rsCLI.eof then
					Do until rsCLI.eof%>
					<option value="<%=rsCLI("CODCLIENTE")%>"<%if Trim(intCliente)=rsCLI("CODCLIENTE") then response.Write("Selected") End If%>><%=rsCLI("descripcion")%></option>
				<%
					rsCLI.movenext
					Loop
					end if
					rsCLI.close
					set rsCLI=nothing
					cerrarscg()
				%>
			</select>
			</td>
			<td>
				<select name="CB_COBRADOR">
					<option value="">TODOS</option>
					<%
					abrirscg()
					ssql="SELECT ID_USUARIO,LOGIN FROM USUARIO WHERE PERFIL_CAJA = 1"
					set rsTemp= Conn.execute(ssql)
					if not rsTemp.eof then
						do until rsTemp.eof%>
						<option value="<%=rsTemp("ID_USUARIO")%>"<%if Trim(intCodUsuario)=Trim(rsTemp("ID_USUARIO")) then response.Write("Selected") End If%>><%=rsTemp("LOGIN")%></option>
						<%
						rsTemp.movenext
						loop
					end if
					rsTemp.close
					set rsTemp=nothing
					cerrarscg()
					%>
				</select>
			</td>
			<td>
				<input name="inicio" type="text" id="inicio" value="<%=inicio%>" size="10" maxlength="10">
			 	<a href="javascript:showCal('Calendar7');"><img src="../lib/calendario.gif" border="0">
			 </td>
			<td>
				<input name="termino" type="text" id="termino" value="<%=termino%>" size="10" maxlength="10">
				<a href="javascript:showCal('Calendar6');"><img src="../lib/calendario.gif" border="0"></a>
			 </td>
			<td>
				<input type="button" name="Submit" value="Aceptar" onClick="envia();">
			</td>
		</tr>
    </table>
	</form>
    </td>
  </tr>

   </table>

   <BR>
   	<H1 class=SaltoDePagina> </H1>
   	<BR>
   	<%
   		' *********************************************************
   		' * C O N V E N I O S									  *
   		' *********************************************************

   		If Trim(intCliente) <> "" then
   		abrirscg()

   		strSql = "SELECT ID_CONVENIO, COD_CLIENTE, RUTDEUDOR, USRINGRESO, CONVERT(VARCHAR(10),FECHAINGRESO,103) as FECHAINGRESO, TOTAL_CONVENIO, CAPITAL, INTERESES AS INDEMCOMP, GASTOS, HONORARIOS, DESC_CAPITAL, DESC_INTERESES as DESC_INDEMCOMP, DESC_GASTOS, DESC_HONORARIOS, PIE, CUOTAS, DIA_PAGO, OBSERVACIONES FROM CONVENIO_ENC WHERE COD_CLIENTE = '" & intCliente & "'"
   		strSql = strSql & " AND FECHAINGRESO >= '" & inicio & " 00:00" & "' AND FECHAINGRESO <= '" & termino & " 23:59" & "'"

   		If Trim(intCodUsuario) <> "" Then
   			strSql = strSql & " AND USRINGRESO = " & intCodUsuario
   		End if

   		set rsCaja=Conn.execute(strSql)
   		If Not rsCaja.eof Then

   		%>
			<B>TIPO DE PAGO : CONVENIO</B>
			<BR><BR>
		<%

   			intTotalMontoCapital = 0
   			intTotalIntereses = 0
   			intTotalGastosJudiciales = 0
   			intTotalHonorarios = 0
   			intTotalTotalPago = 0
   			intPie = 0


   			intTotalEfectivo = 0
   			intTotalCheque = 0
   			intCantTotalEfectivo = 0
   			intCantTotalCheque = 0



   			strTipoPago = ""

   			Do While not rsCaja.Eof


   			strRut = rsCaja("RUTDEUDOR")
   			strFechaPago = rsCaja("FECHAINGRESO")
   			strMostrarRut = strRut



   			intMontoCapital = ValNulo(rsCaja("CAPITAL"),"N")

   			''intIntereses = ValNulo(rsCaja("INTERESES"),"N") - ValNulo(rsCaja("DESC_INTERESES"),"N")
   			intGastosJudiciales = ValNulo(rsCaja("GASTOS"),"N") - ValNulo(rsCaja("DESC_GASTOS"),"N")
   			intIndemnizacion = ValNulo(rsCaja("INDEMCOMP"),"N") - ValNulo(rsCaja("DESC_INDEMCOMP"),"N")

   			intHonorarios = ValNulo(rsCaja("HONORARIOS"),"N") - ValNulo(rsCaja("DESC_HONORARIOS"),"N")
   			intPie = ValNulo(rsCaja("PIE"),"N")

   			intAbonoDeuda = intPie - intGastosJudiciales


   			intTotalPago = intMontoCapital + intGastosJudiciales + intIndemnizacion ''+ intHonorarios

   			intTotalMontoCapital = intTotalMontoCapital + intMontoCapital
   			''intTotalIntereses = intTotalIntereses + intIntereses
   			intTotalGastosJudiciales = intTotalGastosJudiciales + intGastosJudiciales
   			intTotalIndemnizacion = intTotalIndemnizacion + intIndemnizacion
   			intTotalHonorarios = intTotalHonorarios + intHonorarios
   			intTotalTotalPago = intTotalTotalPago + intTotalPago

   			ssql="SELECT NOMBREDEUDOR FROM DEUDOR WHERE RUTDEUDOR='" & strRut & "' AND CODCLIENTE = '" & intCliente & "'"
   			set RsDeudor=Conn.execute(ssql)
   			if not RsDeudor.eof then
   				strNombreDeudor = RsDeudor("NOMBREDEUDOR")
   			end if
   			RsDeudor.close
   			set RsDeudor=nothing

   			intTotalANegociar = intMontoCapital + intIndemnizacion + intGastosJudiciales + intHonorarios
   			'intTotalAvenimiento = intMontoCapital + intIndemnizacion + intIntConvenio
   			intTotalAvenimiento = intMontoCapital + intIntConvenio

   			%>
   			<table width="100%" border="1" bordercolor = "#<%=session("COLTABBG")%>" cellSpacing=0 cellPadding=2>

   			<!--tr>
   				<td><span class="Estilo370">Nro.Comp</span></td>
   				<td><span class="Estilo370"><A HREF="comp_pago.asp?strImprime=S&intNroComp=<%=strCompIng%>"><acronym title="Imprimir Comprobante"><%=strCompIng%></acronym></A></td>
   				<td><span class="Estilo370">Nro.Bole</span></td>
   				<td><span class="Estilo370"><%=strBoleta%></span></td>
   			</tr--->
   			</table>
   			<br>
   			<table width="100%" border="1" bordercolor = "#<%=session("COLTABBG")%>" cellSpacing=0 cellPadding=2>

			<tr>
				<td>NUMERO CONVENIO</td>
				<TD ALIGN="LEFT"><%=rsCaja("ID_CONVENIO")%></td>
			</tr>

			<tr>
				<TD COSLSPAN=2>&nbsp;</td>
   			</tr>

   			<tr>
   				<td>NOMBRE</td>
   				<td>RUT</td>
   			</tr>

   			<tr>
   				<TD ALIGN="LEFT"><%=strNombreDeudor%></td>
   				<TD ALIGN="RIGHT"><A HREF="principal.asp?rut=<%=strMostrarRut%>"><acronym title="Llevar a pantalla de selección"><%=strMostrarRut%></acronym></A></td>
   			</tr>
   			</table>
   			<br>
   			<table width="100%" border="1" bordercolor = "#<%=session("COLTABBG")%>" cellSpacing=0 cellPadding=2>

   			<tr>
   				<td>CUENTA</td>
   				<td>NRODOC</td>
   				<td>F.VENC.</td>
   				<td>DEUDA ORIG.</td>
   				<td>F.PAGO</td>
   			</tr>
   			<%

   				strSql = "SELECT NRODOC, CUENTA, VALORCUOTA AS CAPITAL, FECHAVENC FROM CONVENIO_CUOTA WHERE ID_CONVENIO = " & rsCaja("ID_CONVENIO") & " ORDER BY CUENTA ASC, FECHAVENC DESC"
   				set rsDetCaja=Conn.execute(strSql)
   				If Not rsDetCaja.eof Then
   					intNroDoc = 0
   					intSumaCapital = 0

   					Do While not rsDetCaja.Eof

   						strNroDoc = rsDetCaja("NRODOC")
   						intCapital = rsDetCaja("CAPITAL")
   						intSumaCapital = intSumaCapital + intCapital
   						strCuenta = rsDetCaja("CUENTA")
   						strFechaVenc = rsDetCaja("FECHAVENC")
   			%>

   			<tr>
   				<TD ALIGN="RIGHT"><%=strCuenta%></td>
   				<TD ALIGN="RIGHT"><%=strNroDoc%></td>
   				<TD ALIGN="RIGHT"><%=strFechaVenc%></td>
   				<TD ALIGN="RIGHT"><%=FN(intCapital,0)%></td>
   				<TD ALIGN="RIGHT"><%=strFechaPago%></td>
   			</tr>
   			<%
   					strNombreDeudor=""
   					strMostrarRut=""
   					rsDetCaja.movenext
   					intNroDoc = intNroDoc + 1
   					Loop
   				End If

   				strSql = "SELECT SUM(TOTAL_CUOTA) as INTTOTALCUOTAS FROM CONVENIO_DET "
				strSql = strSql & " WHERE ID_CONVENIO = " & rsCaja("ID_CONVENIO") & " AND CUOTA <> 0"
				set rsTotalCuotas=Conn.execute(strSql)
				If Not rsTotalCuotas.eof Then
					intTotalCuotas = rsTotalCuotas("INTTOTALCUOTAS")
				Else
					intTotalCuotas = 0
				End If

   				intIntConvenio = (intTotalCuotas + intPie + intHonorarios + intIndemnizacion) - intTotalANegociar
   			%>
   				<tr>
   					<TD ALIGN="RIGHT">Docs <%=intNroDoc%></td>
   					<TD ALIGN="RIGHT">&nbsp;</td>
   					<TD ALIGN="RIGHT">&nbsp;</td>
   					<TD ALIGN="RIGHT"><%=FN(intSumaCapital,0)%></td>
   					<TD ALIGN="RIGHT">&nbsp;</td>
   				</tr>
   				<tr>
   					<TD colspan=5>&nbsp;</td>
   				</tr>
   				</table>

   				<br>



   				<table width="100%" border="0">

					<tr>
						<td valign="TOP" width="33%">
							<table width="100%" border="1" bordercolor = "#<%=session("COLTABBG")%>" cellSpacing=0 cellPadding=2>
								<tr>
									<td><b>FECHA CONVENIO</b></td>
									<td ALIGN="RIGHT" width="125"><%=strFechaPago%></td>
								</tr>
							</table>
						</td>
						<td valign="TOP" width="66%" COLSPAN="2">
							&nbsp;
						</td>
					</tr>

					<tr>
						<td valign="TOP" width="33%" >
							<table width="100%" border="1" bordercolor = "#<%=session("COLTABBG")%>" cellSpacing=0 cellPadding=2>
								<tr>
									<td COLSPAN="2"><b>SITUACION CLIENTE</b></td>
								</tr>
								<tr>
									<td> CAPITAL (DEUDA)</td>
									<td ALIGN="RIGHT" width="125"><%=FN(intMontoCapital,0)%></td>
								</tr>
								<tr>
									<td>INDEMNIZACION</span></td>
									<td ALIGN="RIGHT"><%=FN(intIndemnizacion,0)%></td>
								</tr>
								<tr>
									<td>GASTOS JUDICIALES</span></td>
									<td ALIGN="RIGHT"><%=FN(intGastosJudiciales,0)%></td>
								</tr>
								<tr>
									<td>HONORARIOS</span></td>
									<td ALIGN="RIGHT"><%=FN(intHonorarios,0)%></td>
								</tr>
								<tr>
									<td>INTERES CONVENIO</span></td>
									<td ALIGN="RIGHT"><%=FN(intIntConvenio,0)%></td>
								</tr>
								<tr>
									<td>TOTAL A NEGOCIAR</span></td>
									<td ALIGN="RIGHT"><%=FN(intTotalANegociar + intIntConvenio,0)%></td>
								</tr>
							</table>
						</td>
						<td valign="TOP" width="33%" >
							<table width="100%" border="1" bordercolor = "#<%=session("COLTABBG")%>" cellSpacing=0 cellPadding=2>
								<tr>
									<td COLSPAN="2"><b>PAGO PIE O ABONO</b></td>
								</tr>
								<tr>
									<td>ABONO DEUDA</td>
									<td ALIGN="RIGHT" width="125"><%=FN(intAbonoDeuda,0)%></td>
								</tr>
								<tr>
									<td>GASTOS JUDICIALES</td>
									<td ALIGN="RIGHT"><%=FN(intGastosJudiciales,0)%></td>
								</tr>
								<tr>
									<td>TOTAL ABONO</td>
									<td ALIGN="RIGHT"><%=FN(intPie,0)%></td>
								</tr>
							</table>
						</td>
						<td valign="TOP" width="33%" >

							<table width="100%" border="1" bordercolor = "#<%=session("COLTABBG")%>" cellSpacing=0 cellPadding=2>
								<tr>
									<td COLSPAN="2"><b>AVENIMIENTO (CONVENIO)</b></td>
								</tr>
								<tr>
									<td>DEUDA</td>
									<td ALIGN="RIGHT" width="125"><%=FN(intMontoCapital,0)%></td>
								</tr>
								<!--tr>
									<td>INTERES</span></td>
									<td ALIGN="RIGHT"><%=FN(intIntConvenio,0)%></td>
								</tr-->

								<tr>
									<td>TOTAL AVENIMIENTO</td>
									<td ALIGN="RIGHT"><%=FN(intTotalAvenimiento,0)%></td>
								</tr>
							</table>

							<br>

							<table width="100%" border="1" bordercolor = "#<%=session("COLTABBG")%>" cellSpacing=0 cellPadding=2>
								<tr>
									<td colspan="4"><b>CUOTAS CONVENIO</b></td>
								</tr>
								<tr>
									<td>TIPO</td>
									<td>CUOTA</td>
									<td>MONTO</td>
									<td>VENC.</td>
								</tr>

								<tr>
									<TD ALIGN="LEFT">ABONO</td>
									<TD ALIGN="RIGHT">&nbsp;</td>
									<TD ALIGN="RIGHT"><%=FN(intPie,0)%></td>
									<TD ALIGN="RIGHT">&nbsp;</td>
   								</tr>
							<%
								strMontoTotal = 0

								strSql = "SELECT CUOTA, TOTAL_CUOTA, FECHA_PAGO AS VENCIMIENTO FROM CONVENIO_DET "
								strSql = strSql & " WHERE ID_CONVENIO = " & rsCaja("ID_CONVENIO") & " AND CUOTA <> 0 ORDER BY CUOTA"
								set rsDocPago=Conn.execute(strSql)
								If Not rsDocPago.eof Then
									intSumaCapital = 0
									strMontoTotal = 0
									strMonto=0
								Do While not rsDocPago.Eof
									strNroCheque = rsDocPago("CUOTA")
									strMonto = rsDocPago("TOTAL_CUOTA")
									strVencimiento = rsDocPago("VENCIMIENTO")

									If strNroCheque = 0 Then
										strBanco  = "PIE"
									Else
										strBanco  = "CUOTA"
									End if

									intTotalCuota = intTotalCuota + strMonto
									intCantTotalCuota = intCantTotalCuota + 1

									strFechaVenc=Saca1900(strVencimiento)
									If trim(strBanco) = "" Then strBanco = "&nbsp"
									If trim(strCtaCte) = "" Then strCtaCte = "&nbsp"
									If trim(strNroCheque) = "" Then strNroCheque = "&nbsp"
									If trim(strFechaVenc) = "" Then strFechaVenc = "&nbsp"
									strMontoTotal = strMontoTotal + strMonto

							%>

								<tr>
									<td><%=strBanco%></td>
									<td><%=strNroCheque%></td>
									<td ALIGN="RIGHT"><%=FN(strMonto,0)%></td>
									<td><%=strFechaVenc%></td>
								</tr>

							<%
									rsDocPago.movenext
								Loop
								End If
							%>

								<tr>
									<TD ALIGN="LEFT">HONORARIOS</td>
									<TD ALIGN="RIGHT">&nbsp;</td>
									<TD ALIGN="RIGHT"><%=FN(intHonorarios,0)%></td>
									<TD ALIGN="RIGHT">&nbsp;</td>
   								</tr>
   								<tr>
									<td>INDEMNIZACION</span></td>
									<TD ALIGN="RIGHT">&nbsp;</td>
									<td ALIGN="RIGHT"><%=FN(intIndemnizacion,0)%></td>
									<TD ALIGN="RIGHT">&nbsp;</td>
								</tr>
								<tr>
									<td>TOTAL</td>
									<td>&nbsp</td>
									<td ALIGN="RIGHT"><%=FN(strMontoTotal + intPie + intHonorarios + intIndemnizacion,0)%></td>
									<td>&nbsp</td>
								</tr>
						</table>

				</td>
			</tr>
			</table>





	<% '---------------------------------------------- %>




   				<br>


   			<BR>
   			<H1 class=SaltoDePagina> </H1>
   			<BR>
   			<%
   			rsCaja.movenext
   			Loop
   		End If
   		rsCaja.close
   		set rsCaja=nothing
   		''Response.End
   		cerrarscg()
   		end if %>



   	<BR>
	<H1 class=SaltoDePagina> </H1>
	<BR>
	<%

		' *********************************************************
	   	' * OTROS PAGOS     									  *
	   	' *********************************************************


		If Trim(intCliente) <> "" then
		abrirscg()

		strSql = "SELECT DESC_TIPO_PAGO, ID_PAGO, COMP_INGRESO, NRO_BOLETA, RUTDEUDOR , MONTO_CAPITAL, INTERES_PLAZO, GASTOSJUDICIALES, INDEM_COMP, MONTO_EMP, CONVERT(VARCHAR(10),FECHA_PAGO,103) as FECHA_PAGO FROM CAJA_WEB_EMP, CAJA_TIPO_PAGO WHERE COD_CLIENTE = '" & intCliente & "' AND CAJA_WEB_EMP.TIPO_PAGO = CAJA_TIPO_PAGO.ID_TIPO_PAGO"
		strSql = strSql & " AND FECHA_PAGO >= '" & inicio & " 00:00" & "' AND FECHA_PAGO <= '" & termino & " 23:59" & "' AND CAJA_WEB_EMP.TIPO_PAGO NOT IN ('CO','AB','PH')"

		If Trim(intCodUsuario) <> "" Then
			strSql = strSql & " AND USRINGRESO = " & intCodUsuario
		End if
		strSql = strSql & " ORDER BY TIPO_PAGO"

		set rsCaja=Conn.execute(strSql)
		If Not rsCaja.eof Then

			intTotalMontoCapital = 0
			intTotalIntereses = 0
			intTotalGastosJudiciales = 0
			intTotalHonorarios = 0
			intTotalTotalPago = 0


			intTotalEfectivo = 0
			intTotalCheque = 0
			intCantTotalEfectivo = 0
			intCantTotalCheque = 0


			strTipoPago = ""

			Do While not rsCaja.Eof


			strRut = rsCaja("RUTDEUDOR")
			strFechaPago = rsCaja("FECHA_PAGO")
			strMostrarRut = strRut



			intMontoCapital = ValNulo(rsCaja("MONTO_CAPITAL"),"N")

			intIntereses = ValNulo(rsCaja("INTERES_PLAZO"),"N")
			intGastosJudiciales = ValNulo(rsCaja("GASTOSJUDICIALES"),"N")
			intIndemnizacion = ValNulo(rsCaja("INDEM_COMP"),"N")
			intHonorarios = ValNulo(rsCaja("MONTO_EMP"),"N")
			intTotalPago = intMontoCapital + intIntereses + intGastosJudiciales + intIndemnizacion + intHonorarios

			intTotalMontoCapital = intTotalMontoCapital + intMontoCapital
			intTotalIntereses = intTotalIntereses + intIntereses
			intTotalGastosJudiciales = intTotalGastosJudiciales + intGastosJudiciales
			intTotalIndemnizacion = intTotalIndemnizacion + intIndemnizacion
			intTotalHonorarios = intTotalHonorarios + intHonorarios
			intTotalTotalPago = intTotalTotalPago + intTotalPago

			ssql="SELECT NOMBREDEUDOR FROM DEUDOR WHERE RUTDEUDOR='" & strRut & "' AND CODCLIENTE = '" & intCliente & "'"
			set RsDeudor=Conn.execute(ssql)
			if not RsDeudor.eof then
				strNombreDeudor = RsDeudor("NOMBREDEUDOR")
			end if
			RsDeudor.close
			set RsDeudor=nothing

			If Trim(strTipoPago) <> Trim(rsCaja("DESC_TIPO_PAGO")) Then
			%>
				<B>TIPO DE PAGO : <%=rsCaja("DESC_TIPO_PAGO")%></B>
				<BR><BR>

			<%
			End IF
			strTipoPago = rsCaja("DESC_TIPO_PAGO")

			%>
			<table width="100%" border="1" bordercolor = "#<%=session("COLTABBG")%>" cellSpacing=0 cellPadding=2>

			<tr>
				<td><span class="Estilo370">Nro.Comp</span></td>
				<td><span class="Estilo370"><A HREF="comp_pago.asp?strImprime=S&intNroComp=<%=rsCaja("COMP_INGRESO")%>"><acronym title="Imprimir Comprobante"><%=rsCaja("COMP_INGRESO")%></acronym></A></td>
				<td><span class="Estilo370">Nro.Bole</span></td>
				<td><span class="Estilo370"><%=rsCaja("NRO_BOLETA")%></span></td>
			</tr>
			</table>
			<br>
			<table width="100%" border="1" bordercolor = "#<%=session("COLTABBG")%>" cellSpacing=0 cellPadding=2>

			<tr>
				<td>NOMBRE</td>
				<td>RUT</td>
			</tr>

			<tr>
				<TD ALIGN="LEFT"><%=strNombreDeudor%></td>
				<TD ALIGN="RIGHT"><A HREF="principal.asp?rut=<%=strMostrarRut%>"><acronym title="Llevar a pantalla de selección"><%=strMostrarRut%></acronym></A></td>
			</tr>
			</table>
			<br>
			<table width="100%" border="1" bordercolor = "#<%=session("COLTABBG")%>" cellSpacing=0 cellPadding=2>

			<tr>
				<td>CUENTA</td>
				<td>NRODOC</td>
				<td>F.VENC.</td>
				<td>DEUDA ORIG.</td>
				<td>F.PAGO</td>
			</tr>
			<%




				strSql = "SELECT * FROM CAJA_WEB_EMP_DETALLE WHERE ID_PAGO = " & rsCaja("ID_PAGO") & " ORDER BY CUENTA ASC, FECHAVENC DESC"
				set rsDetCaja=Conn.execute(strSql)
				If Not rsDetCaja.eof Then
					intNroDoc = 0
					intSumaCapital = 0

					Do While not rsDetCaja.Eof

						strNroDoc = rsDetCaja("NRODOC")
						intCapital = rsDetCaja("CAPITAL")
						intSumaCapital = intSumaCapital + intCapital
						strSql="SELECT CUENTA,FECHAVENC FROM CUOTA WHERE RUTDEUDOR = '" & strRut & "' AND CODCLIENTE = '" & intCliente & "' AND NRODOC = '" & strNroDoc & "'"
						set RsCuota=Conn.execute(strSql)
						If not RsCuota.eof then
							strCuenta = RsCuota("CUENTA")
							strFechaVenc = RsCuota("FECHAVENC")
						End if
						RsCuota.close
						set RsCuota=nothing
			%>

			<tr>
				<TD ALIGN="RIGHT"><%=strCuenta%></td>
				<TD ALIGN="RIGHT"><%=strNroDoc%></td>
				<TD ALIGN="RIGHT"><%=strFechaVenc%></td>
				<TD ALIGN="RIGHT"><%=FN(intCapital,0)%></td>
				<TD ALIGN="RIGHT"><%=strFechaPago%></td>
			</tr>
			<%
					strNombreDeudor=""
					strMostrarRut=""
					rsDetCaja.movenext
					intNroDoc = intNroDoc + 1
					Loop
				End If
			%>
				<tr>
					<TD ALIGN="RIGHT">Docs <%=intNroDoc%></td>
					<TD ALIGN="RIGHT">&nbsp;</td>
					<TD ALIGN="RIGHT">&nbsp;</td>
					<TD ALIGN="RIGHT"><%=FN(intSumaCapital,0)%></td>
					<TD ALIGN="RIGHT">&nbsp;</td>
				</tr>
				<tr>
					<TD colspan=5>&nbsp;</td>
				</tr>
				</table>

				<br>
				<table width="100%" border="0">

						<tr>
							<td valign="TOP" width="50%" >
								<table width="100%" border="1" bordercolor = "#<%=session("COLTABBG")%>" cellSpacing=0 cellPadding=2>


									<tr>
										<td>CAPITAL</td>
										<td ALIGN="RIGHT" width="125"><%=FN(intMontoCapital,0)%></td>
									</tr>
									<tr>
										<td>INTERESES</span></td>
										<td ALIGN="RIGHT"><%=FN(intIntereses,0)%></td>
									</tr>
									<tr>
										<td>GASTOS JUDICIALES</span></td>
										<td ALIGN="RIGHT"><%=FN(intGastosJudiciales,0)%></td>
									</tr>
									<tr>
										<td>INDEMNIZACION</span></td>
										<td ALIGN="RIGHT"><%=FN(intIndemnizacion,0)%></td>
									</tr>
									<tr>
										<td>HONORARIOS</span></td>
										<td ALIGN="RIGHT"><%=FN(intHonorarios,0)%></td>
									</tr>
									<tr>
										<td>TOTAL PAGO</span></td>
										<td ALIGN="RIGHT"><%=FN(intTotalPago,0)%></td>
									</tr>
								</table>

							</td>
							<td valign="TOP" width="50%" >
								<table width="100%" border="1" bordercolor = "#<%=session("COLTABBG")%>" cellSpacing=0 cellPadding=2>

									<tr>
										<td> BANCO</td>
										<td>CTA CTE NRO.</td>
										<td>CHEQUE</td>
										<td>MONTO</td>
										<td>VENC.</td>
									</tr>
								<%
									strMontoTotal = 0
									strSql = "SELECT NOMBRE_B , NRO_CTACTE , NRO_CHEQUE, MONTO, VENCIMIENTO , FORMA_PAGO FROM CAJA_WEB_EMP_DOC_PAGO, BANCOS "
									strSql = strSql & " WHERE BANCOS.CODIGO =* CAJA_WEB_EMP_DOC_PAGO.COD_BANCO AND ID_PAGO = " & rsCaja("ID_PAGO") & " ORDER BY FORMA_PAGO, NOMBRE_B, VENCIMIENTO"
									''Response.write strSql
									set rsDocPago=Conn.execute(strSql)
									If Not rsDocPago.eof Then
										strBanco = 0
										intSumaCapital = 0
										strMontoTotal = 0
									strMonto=0
									Do While not rsDocPago.Eof
										strBanco = rsDocPago("NOMBRE_B")

										strCtaCte = ValNulo(rsDocPago("NRO_CTACTE"),"C")
										strNroCheque = ValNulo(rsDocPago("NRO_CHEQUE"),"C")
										strMonto = ValNulo(rsDocPago("MONTO"),"N")
										strVencimiento = ValNulo(rsDocPago("VENCIMIENTO"),"C")

										If Trim(rsDocPago("FORMA_PAGO")) = "EF" Then
											strBanco  = "EFECTIVO"
											intTotalEfectivo = intTotalEfectivo + strMonto
											intCantTotalEfectivo = intCantTotalEfectivo + 1
										ElseIf Trim(rsDocPago("FORMA_PAGO")) = "AB" Then
											strBanco  = "ABONO"
											intTotalAbono = intTotalAbono + strMonto
											intCantTotalAbono = intCantTotalAbono + 1
										ElseIf Trim(rsDocPago("FORMA_PAGO")) = "CU" Then
											strBanco  = "CUOTA"
											intTotalCuota = intTotalCuota + strMonto
											intCantTotalCuota = intCantTotalCuota + 1
										Else
											intTotalCheque = intTotalCheque + strMonto
											intCantTotalCheque = intCantTotalCheque + 1
										End If

										strFechaVenc=Saca1900(strVencimiento)
										If trim(strBanco) = "" Then strBanco = "&nbsp"
										If trim(strCtaCte) = "" Then strCtaCte = "&nbsp"
										If trim(strNroCheque) = "" Then strNroCheque = "&nbsp"
										If trim(strFechaVenc) = "" Then strFechaVenc = "&nbsp"
										strMontoTotal = strMontoTotal + strMonto

								%>

									<tr>
										<td><%=strBanco%></td>
										<td><%=strCtaCte%></td>
										<td><%=strNroCheque%></td>
										<td ALIGN="RIGHT"><%=FN(strMonto,0)%></td>
										<td><%=strFechaVenc%></td>
									</tr>

								<%
										rsDocPago.movenext
									Loop
									End If
								%>
									<tr>
										<td>&nbsp</td>
										<td>&nbsp</td>
										<td>&nbsp</td>
										<td ALIGN="RIGHT"><%=FN(strMontoTotal,0)%></td>
										<td>&nbsp</td>
									</tr>
							</table>

					</td>
				</tr>
				</table>


			<BR>
			<H1 class=SaltoDePagina> </H1>
			<BR>
			<%
			rsCaja.movenext
			Loop
		End If
		rsCaja.close
		set rsCaja=nothing
		''Response.End
		cerrarscg()
		end if %>





<table width="800" align="CENTER" border="0">
	<tr>
		<td>
			<table width="300" border="1" bordercolor = "#<%=session("COLTABBG")%>" cellSpacing=0 cellPadding=2>

				<tr>
					<td colspan=2>TOTALES</td>
				</tr>

				<tr>
					<td width="150">CAPITAL</td>
					<td ALIGN="RIGHT" width="125"><%=FN(intTotalMontoCapital,0)%></td>
				</tr>
				<tr>
					<td>INTERESES</td>
					<td ALIGN="RIGHT"><%=FN(intTotalIntereses,0)%></td>
				</tr>
				<tr>
					<td>GASTOS JUDICIALES</td>
					<td ALIGN="RIGHT"><%=FN(intTotalGastosJudiciales,0)%></td>
				</tr>
				<tr>
					<td>INDEMNIZACION</td>
					<td ALIGN="RIGHT"><%=FN(intTotalIndemnizacion,0)%></td>
				</tr>
				<tr>
					<td>HONORARIOS</td>
					<td ALIGN="RIGHT"><%=FN(intTotalHonorarios,0)%></td>
				</tr>
				<tr>
					<td>TOTAL PAGO</td>
					<td ALIGN="RIGHT"><%=FN(intTotalTotalPago,0)%></td>
				</tr>
			</table>
		</td>
		<td>
			<table width="300" border="1" bordercolor = "#<%=session("COLTABBG")%>" cellSpacing=0 cellPadding=2>

				<tr>
					<td colspan=2>TOTALES</td>
				</tr>

				<tr>
					<td width="150">Total Cant. Pagos Efectivo</td>
					<td ALIGN="RIGHT"><%=FN(intCantTotalEfectivo,0)%></td>
				</tr>
				<tr>
					<td>Total Efectivo</td>
					<td ALIGN="RIGHT"><%=FN(intTotalEfectivo,0)%></td>
				</tr>
				<tr>
					<td width="150">Total Cant. Abonos</td>
					<td ALIGN="RIGHT"><%=FN(intCantTotalAbono,0)%></td>
				</tr>
				<tr>
					<td>Total Abonos</td>
					<td ALIGN="RIGHT"><%=FN(intTotalAbono,0)%></td>
				</tr>
				<tr>
					<td>Total Cant. Pagos Cheques</td>
					<td ALIGN="RIGHT"><%=FN(intCantTotalCheque,0)%></td>
				</tr>
				<tr>
					<td>Total Cheque</td>
					<td ALIGN="RIGHT"><%=FN(intTotalCheque,0)%></td>
				</tr>
				<tr>
					<td>Total Cant. Pagos</td>
					<td ALIGN="RIGHT"><%=FN(intCantTotalEfectivo + intCantTotalCheque + intCantTotalAbono,0)%></td>
				</tr>
				<tr>
					<td>Total Monto</td>
					<td ALIGN="RIGHT"><%=FN(intTotalEfectivo + intTotalCheque + intTotalAbono,0)%></td>
				</tr>
			</table>



		</td>
	</tr>
</table>

<table width="800" align="CENTER" border="0">
  	<tr>
		<td valign="top">
			&nbsp;
		</td>
	</tr>
</table>



<%If Trim(intCliente) = "1000" Then%>

	<table width="800" align="CENTER" border="0">
		<tr>
			<td valign="top">
				<a href="generar_ato.asp?intTipoDeudor=D&inicio=<%=inicio%>&termino=<%=termino%>&intCliente=<%=intCliente%>">REIN_RENDJUD_<%=strTermino%>.txt</a>
			</td>
		</tr>
	</table>
	<table width="800" align="CENTER" border="0">
		<tr>
		<td valign="top">
		<a href="generar_ato.asp?intTipoDeudor=I&inicio=<%=inicio%>&termino=<%=termino%>&intCliente=<%=intCliente%>">REIN_RENDINF_<%=strTermino%>.txt</a></td>
		</tr>
		</td>
	</table>

<% End If%>


<%If Trim(intCliente) = "1001" Then%>

	<table width="800" align="CENTER" border="0">
		<tr>
		<td valign="top">
		<a href="generar_rendicion_vne.asp?intTipoDeudor=I&inicio=<%=inicio%>&termino=<%=termino%>&intCliente=<%=intCliente%>"><%=strTermino%>01_11302042-0011302042.txt</a><br>
		<a href="generar_rendicion_gjudiciales.asp?intTipoDeudor=I&inicio=<%=inicio%>&termino=<%=termino%>&intCliente=<%=intCliente%>">Gastos Judiciales</a></td>
		</tr>
		</td>
	</table>

<% End If%>



<script language="JavaScript1.2">
function envia(){
		if (datos.CB_CLIENTE.value=='0'){
			alert('DEBE SELECCIONAR UN CLIENTE');
		}else if(datos.inicio.value==''){
			alert('DEBE SELECCIONAR FECHA DE INICIO');
		}else if(datos.termino.value==''){
			alert('DEBES SELECCIONAR FECHA DE TERMINO');
		}else{
		//datos.action='cargando.asp';
		datos.action='rendicion_caja_inf2.asp';
		datos.submit();
	}
}
</script>
