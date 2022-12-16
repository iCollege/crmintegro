<% @LCID = 1034 %>
<!--#include file="arch_utils.asp"-->
<!--#include file="../lib/comunes/rutinas/funciones.inc" -->
<!--#include file="../lib/comunes/rutinas/rutinasFecha.inc" -->
<!--#include file="lib.asp"-->
<!--#include file="asp/comunes/general/RutinasVarias.inc" -->

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

<tr>
    <td valign="top">

		<table width="600" border="0">
		<%

		If Trim(intCliente) <> "" then
		abrirscg()

		strSql = "SELECT ID_PAGO, COMP_INGRESO, NRO_BOLETA, RUTDEUDOR , MONTO_CAPITAL, INTERES_PLAZO, GASTOSJUDICIALES, INDEM_COMP, MONTO_EMP, CONVERT(VARCHAR(10),FECHA_PAGO,103) as FECHA_PAGO FROM CAJA_WEB_EMP WHERE COD_CLIENTE = '" & intCliente & "'"
		strSql = strSql & " AND FECHA_PAGO >= '" & inicio & " 00:00" & "' AND FECHA_PAGO <= '" & termino & " 23:59" & "'"
		'strSql = strSql & " AND RUTDEUDOR = '78750020-k'"

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

			Do While not rsCaja.Eof

			%>

			<tr>
				<td colspan="3">&nbsp</td>
				<td><span class="Estilo370">Nro.Comp</span></td>
				<td><span class="Estilo370"><A HREF="comp_pago.asp?strImprime=S&intNroComp=<%=rsCaja("COMP_INGRESO")%>"><acronym title="Imprimir Comprobante"><%=rsCaja("COMP_INGRESO")%></acronym></A></td>
				<td><span class="Estilo370">Nro.Bole</span></td>
				<td><span class="Estilo370"><%=rsCaja("NRO_BOLETA")%></span></td>
			</tr>

			<tr bgcolor="#<%=session("COLTABBG")%>">
				<td><span class="Estilo37">NOMBRE</span></td>
				<td><span class="Estilo37 Estilo37">RUT</span></td>
				<td><span class="Estilo37">CUENTA</span></td>
				<td><span class="Estilo37">NRODOC</span></td>
				<td><span class="Estilo37">F.VENC.</span></td>
				<td><span class="Estilo37">DEUDA ORIG.</span></td>
				<td><span class="Estilo37">F.PAGO</span></td>
			</tr>
			<%


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
				<TD ALIGN="LEFT"><%=strNombreDeudor%></td>
				<TD ALIGN="RIGHT"><A HREF="principal.asp?rut=<%=strMostrarRut%>"><acronym title="Llevar a pantalla de selección"><%=strMostrarRut%></acronym></A></td>
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
					<TD ALIGN="LEFT">&nbsp;</td>
					<TD ALIGN="RIGHT">&nbsp;</td>
					<TD ALIGN="RIGHT">Docs <%=intNroDoc%></td>
					<TD ALIGN="RIGHT">&nbsp;</td>
					<TD ALIGN="RIGHT">&nbsp;</td>
					<TD ALIGN="RIGHT"><%=FN(intSumaCapital,0)%></td>
					<TD ALIGN="RIGHT">&nbsp;</td>
				</tr>
				<tr>
					<TD colspan=7>&nbsp;</td>
				</tr>

				<tr>
					<TD colspan=7>
					<table width="600" border="0">
						<tr>
							<td valign="TOP">
								<table width="250" border="0">

									<tr>
										<td bgcolor="#<%=session("COLTABBG")%>"><span class="Estilo37" width="125">CAPITAL</span></td>
										<td ALIGN="RIGHT" width="125"><%=FN(intMontoCapital,0)%></td>
									</tr>
									<tr>
										<td bgcolor="#<%=session("COLTABBG")%>"><span class="Estilo37">INTERESES</span></td>
										<td ALIGN="RIGHT"><%=FN(intIntereses,0)%></td>
									</tr>
									<tr>
										<td bgcolor="#<%=session("COLTABBG")%>"><span class="Estilo37">GASTOS JUDICIALES</span></td>
										<td ALIGN="RIGHT"><%=FN(intGastosJudiciales,0)%></td>
									</tr>
									<tr>
										<td bgcolor="#<%=session("COLTABBG")%>"><span class="Estilo37">INDEMNIZACION</span></td>
										<td ALIGN="RIGHT"><%=FN(intIndemnizacion,0)%></td>
									</tr>
									<tr>
										<td bgcolor="#<%=session("COLTABBG")%>"><span class="Estilo37">HONORARIOS</span></td>
										<td ALIGN="RIGHT"><%=FN(intHonorarios,0)%></td>
									</tr>
									<tr>
										<td bgcolor="#<%=session("COLTABBG")%>"><span class="Estilo37">TOTAL PAGO</span></td>
										<td ALIGN="RIGHT"><%=FN(intTotalPago,0)%></td>
									</tr>
								</table>

							</td>
							<td valign="TOP">
								<table width="350" border="0">
									<tr>
										<td bgcolor="#<%=session("COLTABBG")%>"><span class="Estilo37">BANCO</span></td>
										<td bgcolor="#<%=session("COLTABBG")%>"><span class="Estilo37">CTA CTE NRO.</span></td>
										<td bgcolor="#<%=session("COLTABBG")%>"><span class="Estilo37">CHEQUE</span></td>
										<td bgcolor="#<%=session("COLTABBG")%>"><span class="Estilo37">MONTO</span></td>
										<td bgcolor="#<%=session("COLTABBG")%>"><span class="Estilo37">VENC.</span></td>
									</tr>
								<%
									strSql = "SELECT NOMBRE_B , NRO_CTACTE , NRO_CHEQUE, MONTO, VENCIMIENTO , FORMA_PAGO FROM CAJA_WEB_EMP_DOC_PAGO, BANCOS "
									strSql = strSql & " WHERE BANCOS.CODIGO = IsNull(CAJA_WEB_EMP_DOC_PAGO.COD_BANCO,0) AND ID_PAGO = " & rsCaja("ID_PAGO") & " ORDER BY FORMA_PAGO, NOMBRE_B, VENCIMIENTO"
									set rsDocPago=Conn.execute(strSql)
									If Not rsDocPago.eof Then
										strBanco = 0
										intSumaCapital = 0

									Do While not rsDocPago.Eof
										strBanco = rsDocPago("NOMBRE_B")

										strCtaCte = rsDocPago("NRO_CTACTE")
										strNroCheque = rsDocPago("NRO_CHEQUE")
										strMonto = rsDocPago("MONTO")
										strVencimiento = rsDocPago("VENCIMIENTO")

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
								%>

									<tr>
										<td><%=strBanco%></td>
										<td><%=strCtaCte%></td>
										<td><%=strNroCheque%></td>
										<td ALIGN="RIGHT"><%=FN(strMonto,0)%></td>
										<td><%=Saca1900(strVencimiento)%></td>
									</tr>

								<%
										rsDocPago.movenext
									Loop
									End If
								%>
								</table>

							</td>
						</tr>
					</table>

					</td>
				</tr>
				<tr>
					<TD colspan=7>&nbsp;</td>
				</tr>

			<%
			rsCaja.movenext
			Loop
		End If
		rsCaja.close
		set rsCaja=nothing
		''Response.End
		cerrarscg()
		end if %>

	</td>
	</tr>
	</table>
	</td>
</table>




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
		<a href="generar_rendicion_vne.asp?intTipoDeudor=I&inicio=<%=inicio%>&termino=<%=termino%>&intCliente=<%=intCliente%>"><%=strTermino%>01_11302042-0011302042.txt</a></td>
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
		datos.action='rendicion_caja.asp';
		datos.submit();
	}
}


function enviaexcel(){
if (datos.CB_CLIENTE.value=='0'){
	alert('DEBE SELECCIONAR UN CLIENTE');
		}else if(datos.inicio.value==''){
			alert('DEBE SELECCIONAR FECHA DE INICIO');
			}else if(datos.termino.value==''){
				alert('DEBES SELECCIONAR FECHA DE TERMINO');
			}else{
		datos.action='rendicion_caja_xls.asp';
		datos.submit();
	}
}



</script>
