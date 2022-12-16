	<% @LCID = 1034 %>
<!--#include file="arch_utils.asp"-->
<!--#include file="sesion.asp"-->
<!--#include file="../lib/comunes/rutinas/funciones.inc" -->
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

	intCliente = session("ses_codcli")

	intPorcDescCapital = ValNulo(Request("capital"),"N")
	intPorcDescIndemComp = ValNulo(Request("indemComp"),"N")
	intPorcDescHonorarios = ValNulo(Request("honorarios"),"N")
	intPorcDescGastos = ValNulo(Request("gastos"),"N")

	intPie = Request("pie")
	intCuotas = Request("cuotas")
	intDiaDePago = Request("TX_DIAPAGO")

	id_convenio = Request("id_convenio")


	intCuota1 = Trim(Request("TX_CUOTA1"))
	intCuota2 = Trim(Request("TX_CUOTA2"))
	intCuota3 = Trim(Request("TX_CUOTA3"))
	intCuota4 = Trim(Request("TX_CUOTA4"))
	intCuota5 = Trim(Request("TX_CUOTA5"))
	intCuota6 = Trim(Request("TX_CUOTA6"))
	intCuota7 = Trim(Request("TX_CUOTA7"))
	intCuota8 = Trim(Request("TX_CUOTA8"))


	''intTotDeudaCapital = Round(ValNulo(Request("hdintCapital"),"N"),0)
	intTotDeudaCapital = Round(ValNulo(Request("TX_CAPITAL"),"N"),0)
	intTotComision = Round(ValNulo(Request("TX_COMISION"),"N"),0)
	intTotIntCuotas = Round(ValNulo(Request("TX_INTERESCUOTA"),"N"),0)
	intTotGastos = Round(ValNulo(Request("TX_GASTOSOPE"),"N"),0)

	intTotalDeuda = intTotDeudaCapital + intTotComision + intTotIntCuotas + intTotGastos

	'intTotalDeuda = intTotDeudaCapital + intTotGastos

	'intDescCapital = Round(intTotDeudaCapital * intPorcDescCapital / 100,0)
	'intDescIndemComp = Round(intTotComision * intPorcDescIndemComp / 100,0)
	'intDescHonorarios = Round(intTotIntCuotas * intPorcDescHonorarios / 100,0)
	'intDescGastos = Round(intTotGastos * intPorcDescGastos / 100,0)

	intDescCapital = Round(intPorcDescCapital,0)
	intDescIndemComp = Round(intPorcDescIndemComp,0)
	intDescHonorarios = Round(intPorcDescHonorarios,0)
	intDescGastos = Round(intPorcDescGastos,0)

	intTotalDescuentos = intDescCapital + intDescIndemComp + intDescHonorarios + intDescGastos
	'intTotalDescuentos = intDescCapital + intDescGastos

	intTotalConvenio = intTotalDeuda - intTotalDescuentos

	'intTotDeudaCapital = Round(intTotDeudaCapital - intDescCapital,0)
	'intTotComision = Round(intTotComision - intDescIndemComp,0)
	'intTotIntCuotas = Round(intTotIntCuotas - intDescHonorarios,0)
	'intTotGastos = Round(intTotGastos - intDescGastos,0)


	AbrirSCG()

	strSql=""
	strSql="SELECT TASA_MAX_CONV, DESCRIPCION FROM CLIENTE WHERE CODCLIENTE ='" & intCliente & "'"
	set rsTasa=Conn.execute(strSql)
	if not rsTasa.eof then
		intTasaMax = rsTasa("TASA_MAX_CONV")
		strDescripcion = rsTasa("DESCRIPCION")
	Else
		intTasaMax = 1
		strDescripcion = ""
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
			datos.action = "grabar_repactacion.asp";
			datos.submit();
		}
}
</script>


<BODY>
<FORM NAME="datos" METHOD="POST" ACTION="grabar_repactacion.asp">

<INPUT TYPE="hidden" NAME="strCodCliente" value="<%=intCliente%>">
<INPUT TYPE="hidden" NAME="strRutDeudor" value="<%=strRutDeudor%>">
<INPUT TYPE="hidden" NAME="intTotalConvenio" value="<%=intTotalConvenio%>">
<INPUT TYPE="hidden" NAME="intTotalCapital" value="<%=intTotDeudaCapital%>">
<INPUT TYPE="hidden" NAME="intIndemComp" value="<%=intTotComision%>">
<INPUT TYPE="hidden" NAME="intGastos" value="<%=intTotGastos%>">
<INPUT TYPE="hidden" NAME="intHonorarios" value="<%=intTotIntCuotas%>">
<INPUT TYPE="hidden" NAME="intDescTotalCapital" value="<%=intDescCapital%>">
<INPUT TYPE="hidden" NAME="intDescIndemComp" value="<%=intDescIndemComp%>">
<INPUT TYPE="hidden" NAME="intDescGastos" value="<%=intDescGastos%>">
<INPUT TYPE="hidden" NAME="intDescHonorarios" value="<%=intDescHonorarios%>">
<INPUT TYPE="hidden" NAME="intPie" value="<%=intPie%>">
<INPUT TYPE="hidden" NAME="intCuotas" value="<%=intCuotas%>">
<INPUT TYPE="hidden" NAME="intDiaPago" value="<%=intDiaDePago%>">
<INPUT TYPE="hidden" NAME="strObservaciones" value="<%=strObservaciones%>">
<INPUT TYPE="hidden" NAME="id_convenio" value="<%=id_convenio%>">

<INPUT TYPE="hidden" NAME="TX_CUOTA1" value="<%=intCuota1%>">
<INPUT TYPE="hidden" NAME="TX_CUOTA2" value="<%=intCuota2%>">
<INPUT TYPE="hidden" NAME="TX_CUOTA3" value="<%=intCuota3%>">
<INPUT TYPE="hidden" NAME="TX_CUOTA4" value="<%=intCuota4%>">
<INPUT TYPE="hidden" NAME="TX_CUOTA5" value="<%=intCuota5%>">
<INPUT TYPE="hidden" NAME="TX_CUOTA6" value="<%=intCuota6%>">
<INPUT TYPE="hidden" NAME="TX_CUOTA7" value="<%=intCuota7%>">
<INPUT TYPE="hidden" NAME="TX_CUOTA8" value="<%=intCuota8%>">


<TABLE ALIGN="CENTER" WIDTH="600" BORDER="1" BORDERCOLOR = "#000000" CELLSPACING=0 CELLPADDING=1>

		<TR>
		 	<TD>
				<table width="600" border="0">
					<tr>
					  <td width="135" class="Estilo13"><p>Renintegra S.P.A. </p></td>
					  <td width="277" class="Estilo13"><p>Compañia 1390 Oficina 1503, Santiago</p></td>
					  <td width="174" class="Estilo13">Fecha: <%=Now%></td>
					</tr>
					<tr>
					  <td class="Estilo13"><p>Rut 76.000.947-4 </p></td>
					  <td class="Estilo13"><p>Fonos: 56-2-6994706&nbsp; 56-2-6973125</p></td>
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
					 		  RECONOCIMIENTO DE DEUDA Y REPACTACION<BR>
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
							mantiene con  nuestro mandante, debidamente  individualizado precedentemente, de acuerdo a la
							presente Repactación.
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
					<td>NRODOC</td>
					<td>FECHA_VENC</td>
					<td>DIAS_MORA</td>
					<!--td>TIPODOCUMENTO</td>
					<td>ASIGNACION</td-->
					<td>MONTO</td>
				</tr>

				<%

				strSql = "SELECT CUOTA as IDCUOTA, convert(vARCHAR(10),IsNull(FECHA_PAGO,'01/01/1900'),103) as FECHAVENC, IsNull(datediff(d,FECHA_PAGO,getdate()),0) as ANTIGUEDAD, CUOTA as NRODOC, IsNull(TOTAL_CUOTA,0) as SALDO FROM CONVENIO_DET WHERE ID_CONVENIO = " & id_convenio & " AND IsNull(PAGADA,'') <> 'S'"


				set rsTemp= Conn.execute(strSql)

				intCorrelativo = 1
				strArrIdCuota=""
				Do until rsTemp.eof
					strObjeto = "CH_" & rsTemp("IDCUOTA")
					strObjeto1 = "TX_SALDO_" & rsTemp("IDCUOTA")
					If UCASE(Request(strObjeto)) = "ON" Then

						intSaldo = Request(strObjeto1)
						strNroDoc = rsTemp("NRODOC")
						intAntiguedad = rsTemp("ANTIGUEDAD")
						strFechaVenc = rsTemp("FECHAVENC")

						strArrIdCuota = strArrIdCuota & ";" & rsTemp("IDCUOTA")

						%>
						<tr class="Estilo34">
						<td><%=strNroDoc%></td>
						<td><%=strFechaVenc%></td>
						<td><%=intAntiguedad%></td>
						<td ALIGN="RIGHT"><%=FN(intSaldo,0)%></td>
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


			If 2= 3 Then

				strSql="SELECT CLIENTE.DESCRIPCION, CLIENTE.CODCLIENTE,CUOTA.CUENTA, COUNT(CUOTA.NRODOC) as CANT_DOC,SUM(CUOTA.SALDO) as TOTAL, MAX(ISNULL(DATEDIFF(D,FECHAVENC,GETDATE()),0)) as ANTIG, CONVERT(VARCHAR(10),MIN(ISNULL(FECHAVENC,GETDATE())),103) as VENCIM, TIPOCOB, CODREMESA"
				strSql= strSql & " FROM CUOTA,CLIENTE "
				strSql= strSql & " WHERE CUOTA.CODCLIENTE = CLIENTE.CODCLIENTE "
				strSql= strSql & " AND CUOTA.RUTDEUDOR     = '" & strRutDeudor & "'"
				strSql= strSql & " GROUP BY CUOTA.CODCLIENTE   ,CLIENTE.CODCLIENTE, CUOTA.CUENTA,CLIENTE.DESCRIPCION,TIPOCOB, CODREMESA "

				'rESPONSE.WRITE "strSql = " & strSql
				'Response.End

					''strSql= "exec s_Trae_Cabecera_Deuda '" & strRutDeudor & "'"
					set rsDEU=Conn.execute(strSql)
					if not rsDEU.eof then
					monto=0
					%>

					  <table width="100%" border="1" bordercolor = "#000000" cellSpacing=0 cellPadding=1>
						<%If not rsDEU.eof Then	%>

						<tr class="Estilo34">

						<%For col = 0 To rsDEU.Fields.Count-3%>
							<td><%=rsDEU.Fields(col).Name%></td>
						<%next%>
						</tr>

						<%

						intColumnas = rsDEU.Fields.Count - 3


						intTotDeudaCapital = 0
						Do until rsDEU.eof
							intCodCliente=rsDEU(1)
						%>
						<tr class="Estilo34">
						<%For i=0 to intColumnas%>
							<td><%=rsDEU(i)%></td>
						<%next%>

						</tr>
						<%
							intTotDeudaCapital = intTotDeudaCapital + rsDEU(4)
						 rsDEU.movenext
						 Loop
						 %>
						 </table>
						 <%
						End If
					  end if
					rsDEU.close
					set rsDEU=nothing
				%>

				<TABLE ALIGN="CENTER" WIDTH="600" BORDER="0" BORDERCOLOR = "#000000" CELLSPACING=0 CELLPADDING=1>
					<TR><td colspan=4>&nbsp;</TD></TR>
					<TR class="Estilo1">
						<TD colspan=4 align="LEFT" class="Estilo34">
					  	DETALLE DE LA DEUDA
						</TD>
					</TR>
					<TR><TD colspan=4>&nbsp;</TD></TR>
				</TABLE>
			<%

			''strSql="exec s_Trae_Detalle_Deuda '" & strRutDeudor & "'," & intCliente

			strSql="SELECT CUENTA, NRODOC, IsNull(FECHAVENC,'01/01/1900') as FECHA_VENC, IsNull(datediff(d,fechavenc,getdate()),0) DIAS_MORA, TIPODOCUMENTO, CODREMESA AS ASIGNACION, VALORCUOTA, SALDO"
			strSql=strSql & " FROM CUOTA WHERE RUTDEUDOR = '" & strRutDeudor & "' AND CODCLIENTE = '" & intCodCliente & "'"


			set rsDET=Conn.execute(strSql)
			if not rsDET.eof then
			intColumnas = rsDET.Fields.Count - 1

			%>
			<table width="100%" border="1" bordercolor = "#000000" cellSpacing=0 cellPadding=1>
				<tr class="Estilo34">
					<%For col = 0 To rsDET.Fields.Count-2%>
						<td><%=rsDET.Fields(col).Name%></td>
					<%next%>
				</tr>
			<%
			intSaldo = 0
			intValorCuota = 0
			total_ValorCuota = 0
			do until rsDET.eof


				%>
				<tr class="Estilo34">

					<%For i=0 to intColumnas - 1%>
						<td><%=rsDET(i)%></td>
					<%next%>
				</tr>
				 <%rsDET.movenext
			 loop
			 %>
			<!--tr>
				<td bgcolor="#<%=session("COLTABBG")%>">&nbsp</td>
				<td bgcolor="#<%=session("COLTABBG")%>"><span class="Estilo13">Docs : <%=total_docs%></span></td>
				<td bgcolor="#<%=session("COLTABBG2")%>"><div align="right"><span class="Estilo28">&nbsp</span></div></td>
				<td bgcolor="#<%=session("COLTABBG2")%>"><div align="right"><span class="Estilo27">&nbsp</span></div></td>
				<td bgcolor="#<%=session("COLTABBG2")%>"><div align="right"><span class="Estilo27">&nbsp</span></div></td>
				<td bgcolor="#<%=session("COLTABBG2")%>"><div align="right"><span class="Estilo27">&nbsp</span></div></td>
				<td bgcolor="#<%=session("COLTABBG2")%>"><div align="right"><span class="Estilo27">&nbsp</span></div></td>
				<td bgcolor="#<%=session("COLTABBG2")%>"><div align="right"><span class="Estilo28">$ <%=FN(total_ValorCuota,0)%></span></div></td>
				<td bgcolor="#<%=session("COLTABBG2")%>"><div align="right"><span class="Estilo28">$ <%=FN(total_saldo,0)%></span></div></td>
				<td bgcolor="#<%=session("COLTABBG2")%>"><div align="right"><span class="Estilo28"></span></div></td>
				<td bgcolor="#<%=session("COLTABBG2")%>"><div align="right"><span class="Estilo28"></span></div></td>
				<td bgcolor="#<%=session("COLTABBG2")%>"><div align="right"><span class="Estilo28"></span></div></td>
			</tr-->

	      </table>
		  <%
		  end if
		  rsDET.close
		  set rsDET=nothing

		  End If
			%>


	<INPUT TYPE="HIDDEN" NAME="strArrIdCuota" VALUE="<%=strArrIdCuota%>">

			<br>
			<br>
			<table width="600" border="0">
			<br>
				<tr>
					<td class="Estilo34">

				   La presente Repactación no produce la  novacion de la(s) obligacion(es) primitivamente
contraida(s) con nuestro mandante constituyendo solo una modalidad o facilidad para el pago de
dicha(s) obligacion(es) vencida(s) y exigible(s).
Este instrumento no acredita el pago de las cuotas convenidas.
La falta de pago de cualquiera de las cuotas en que se ha dividido el pago de la deuda, dará derecho al acreedor (Mandante y/o Nuestra Empresa.) para exigir la totalidad de ella,
considerándose ipso facto la obligación comi si fuere de pago vencido, pudiendo cobrar la totalidad de la deuda.
<br>
El domicilio señalado es el que le corresponde actualmente , obligándose a informar a nuestro Mandante y a Reintregea S.P.A. , cualquier cambio de domicilio.
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
		intMontoA = intPie
		intKapitalInicial = intTotalConvenio - intPie
		'M= C ( 1+it ) M= 3,250(1 + (0.25)(1.5/12)= 3,351.56
		intMontoConInteres = intKapitalInicial * (1 + ((intTasaMax/100)*intCuotas))

		For i=1 to intCuotas

			If Not Isnull(intMontoConInteres/intCuotas) Then
				intMonto = Round(intMontoConInteres/intCuotas,0)
			End if

			intMontoA = intMontoA + intMonto

		Next

		intMontoA = intMontoA - intTotalConvenio

		intMontoA = ValNulo(Request("TX_INTERES_CONV"),"N")


		If Trim(intCuota1) <> "" Then

		End If

		If Trim(intCuota2) <> "" Then

		End If

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
												<TD align="right" class="Estilo38">Gastos Operacionales: </TD>
												<TD align="right" class="Estilo38"><strong>$ <%=FN(intTotGastos,0)%></strong></TD>
											</TR>
											<TR HEIGHT=20>
												<TD align="right" class="Estilo38"> Comision: </TD>
												<TD align="right" class="Estilo38"><strong>$ <%=FN(intTotComision,0)%></strong></TD>
											</TR>
											<TR HEIGHT=20>
												<TD align="right" class="Estilo38">Interes Cuotas: </TD>
												<TD align="right" class="Estilo38"><strong>$ <%=FN(intTotIntCuotas,0)%></strong></TD>
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
												<TD align="right" class="Estilo38"><strong>$ <%=FN(intMontoA,0)%></strong></TD>
											</TR>
											<TR HEIGHT=20>
												<TD align="right" class="Estilo38">&nbsp</TD>
												<TD align="right" class="Estilo38">&nbsp</TD>
											</TR>
											<TR HEIGHT=20>
												<TD align="right" class="Estilo38">&nbsp</TD>
												<TD align="right" class="Estilo38">&nbsp</TD>
											</TR>

											<!--TR HEIGHT=20>
												<TD COLSPAN=2 ALIGN="CENTER" class="Estilo38">DESCUENTOS</TD>
											</TR>
											<TR HEIGHT=20>
												<TD ALIGN="RIGHT" class="Estilo38">Capital:</TD>
												<TD align="right" class="Estilo38"><strong>$ <%=FN(intDescCapital,0)%></strong></TD>
											</TR>
											<TR HEIGHT=20>
												<TD align="right" class="Estilo38"> Gastos Judiciales:</TD>
												<TD align="right" class="Estilo38"><strong>$ <%=FN(intDescGastos,0)%></strong></TD>
											</TR-->

											<!--TR HEIGHT=20>
												<TD ALIGN="RIGHT" class="Estilo38"> IndemComp:</TD>
												<TD align="right" class="Estilo38"><strong>$ <%=FN(intDescIndemComp,0)%></strong></TD>
											</TR-->
											<!--TR HEIGHT=20>
												<TD align="right" class="Estilo38"> Honorarios:</TD>
												<TD align="right" class="Estilo38"><strong>$ <%=FN(intDescHonorarios,0)%></strong></TD>
											</TR-->
											<!--TR HEIGHT=20>
												<TD>&nbsp</TD>
												<TD align="right">______________</TD>
											</TR>
											<TR HEIGHT=20>
												<TD align="right" class="Estilo38"><b>Total Descuentos: <b></TD>
												<TD align="right" class="Estilo38"><strong>$ <%=FN(intTotalDescuentos,0)%></strong></TD>
											</TR-->
											<!--TR HEIGHT=20>
												<TD align="right" class="Estilo38"><b>Total Convenio: <b></TD>
												<TD align="right" class="Estilo38"><strong>$ <%=FN(intTotalConvenio,0)%></strong></TD>
											</TR-->
											<TR HEIGHT=20>
												<TD align="right" class="Estilo38"><b>Saldo a Convenir: <b></TD>
												<TD align="right" class="Estilo38"><strong>$ <%=FN((intTotalDeuda - intPie) + intMontoA,0)%></strong></TD>
											</TR>

											<!--TR HEIGHT=20>
												<TD align="right" class="Estilo38"><b>Total a Convenir : <b></TD>
												<TD align="right" class="Estilo38"><strong>$ <%=FN(intTotalConvenio - intPie,0)%></strong></TD>
											</TR-->
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
						<TABLE ALIGN= "CENTER" WIDTH="90%" BORDER="1" BORDERCOLOR = "#000000" CELLSPACING=0 CELLPADDING=1>
							<tr class="Estilo34">
								<td>Nro Cuota</td>
								<td>Fecha de Pago</td>
								<td>Monto Cuota</td>
							</tr>
							<!--tr class="Estilo34">
								<td>Pie</td>
								<td><%=date%></td>
								<td>$ <%=FN(intPie,0)%></td>
							</tr-->

							<%

							intMesDePago = Month(date)
							intAnoDePago = Year(date)

							intKapitalInicial = intTotalConvenio-intPie
							'M= C ( 1+it ) M= 3,250(1 + (0.25)(1.5/12)= 3,351.56

							''REsponse.write "intTasaMax = " & intTasaMax
							intMontoConInteres = intKapitalInicial * (1 + ((intTasaMax/100)*intCuotas))

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

							strObjeto = "TX_CUOTA" & i
							intSaldo = ValNulo(Request(strObjeto),"N")


							If Not Isnull(intMontoConInteres/intCuotas) Then
								''intMonto = Round(intMontoConInteres/intCuotas,0)
								intMonto = Round(intSaldo,0)
							End if

							If Mid(dtmFechaPago,4,2) = "02" and Cdbl(intDiaDePago) > 28 Then
								dtmFechaPago = "28/02/" & Mid(dtmFechaPago,7,4)
							End if

							If Cdbl(intDiaDePago) > 30 Then
								dtmFechaPago = "30/" & Mid(dtmFechaPago,4,2) & "/" & Mid(dtmFechaPago,7,4)
							End if

							%>
							<tr class="Estilo34">
								<td ALIGN="RIGHT"><%=intNroCuota%></td>
								<td ALIGN="RIGHT"><%=dtmFechaPago%></td>
								<td ALIGN="RIGHT">$ <%=FN(intMonto,0)%></td>
							</tr>
							<% Next %>
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
											<TD align="right" class="Estilo38"><b>Pie Convenio:</b></TD>
											<TD align="right" class="Estilo38"><strong>$ <%=FN(intPie,0)%></strong></TD>
										</TR>
										<TR HEIGHT=20>
											<TD>&nbsp</TD>
											<TD align="right">______________</TD>
										</TR>
										<TR HEIGHT=20>
											<TD align="right" class="Estilo38"><b>Total Pago Caja:</b></TD>
											<TD align="right" class="Estilo38"><strong>$ <%=FN(intPie,0)%></strong></TD>
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
				<TD align="LEFT" class="Estilo34">
					<acronym title="GRABAR CONVENIO">
						<input name="BT_GRABAR" type="button" onClick="Grabar();" value="Grabar">
					</acronym>
				</TD>
				<TD align="RIGHT" class="Estilo34">
					<acronym title="IMPRIMIR CONVENIO">
						<input name="BT_IMPRIMIR" type="button" onClick="window.print();" value="Imprimir">
					</acronym>
				</TD>

			</TR>
	</TABLE>

	<INPUT TYPE="hidden" NAME="intIntConvenio" value="<%=intMontoA%>">

</FORM>
&nbsp;&nbsp;
</body>
</html>
