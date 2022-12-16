<% @LCID = 1034 %>
<!--#include file="arch_utils.asp"-->
<!--#include file="../lib/comunes/rutinas/funciones.inc" -->
<!--#include file="sesion.asp"-->
<!--#include file="../lib/comunes/rutinas/TraeCampo.inc" -->
<!--#include file="asp/comunes/general/rutinasSCG.inc" -->
<!--#include file="lib.asp"-->
<%
	If Trim(Request("Limpiar"))="1" Then
			session("session_rutdeudor") = ""
			strRutDeudor = ""
	End if

	If Trim(Request("TX_RUT")) = "" Then
		strRutDeudor = session("session_rutdeudor")
	Else
		strRutDeudor = Trim(Request("TX_RUT"))
		session("session_rutdeudor") = strRutDeudor
	End If

	AbrirSCG()
%>
<html>
<style type="text/css">
<!--
.Estilo29 {font-family: Arial, sans-serif}
-->
</style>
<head>
<title></title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<style type="text/css">
<!--
body,td,th {
	font-family: tahoma;
	font-size: 11px;
	color: #666666;
}
.style1 {color: #ffffff}
a {
	font-size: 12px;
	color: #ffffff;
	font-weight: bold;
}
a:link {
	color: #999999;
	text-decoration: none;
}
a:visited {
	color: #0000FF;
	text-decoration: none;
}
a:active {
	color: #0000FF;
	text-decoration: none;
}
.style2 {color: #005083;}
.style3 {color: #B7B7B7}
.style4 {color: #000000}
.Estilo1 {font-size: 12px}
a:hover {
	text-decoration: underline;
	color: #999999;
}
.Estilo31 {font-size: 14}
.Estilo32 {color: #333333}
.Estilo33 {font-size: 18px}
-->
</style>
</head>

<body>
<%
	If Trim(intCodCliente) = "" Then intCodCliente = session("ses_codcli")
	If Trim(strRutDeudor) <> "" then
		strNombreDeudor = TraeNombreDeudor(Conn,strRutDeudor)
		strFonoArea = TraeUltimoFonoDeudor(Conn,strRutDeudor,"CODAREA")
		strFonoFono = TraeUltimoFonoDeudor(Conn,strRutDeudor,"TELEFONO")
		strDirCalle= TraeUltimaDirDeudorSCG(Conn,strRutDeudor,"CALLE")
		strDirNum = TraeUltimaDirDeudorSCG(Conn,strRutDeudor,"NUMERO")
		strDirComuna = TraeUltimaDirDeudorSCG(Conn,strRutDeudor,"COMUNA")
		strDirResto = TraeUltimaDirDeudorSCG(Conn,strRutDeudor,"RESTO")
		strEmail = TraeUltimoEmailDeudorSCG(Conn,strRutDeudor,"EMAIL")

		strTelefonoDeudor = TraeUltimoFonoDeudorSCG(Conn,strRutDeudor,"CODAREA") & "-" & TraeUltimoFonoDeudorSCG(Conn,strRutDeudor,"TELEFONO")
		If Trim(strTelefonoDeudor) = "-" Then strTelefonoDeudor = "S/F"
	Else
		strNombreDeudor=""
		strFonoArea = ""
		strFonoFono = ""
		strDirCalle = ""
		strDirNum = ""
		strDirComuna = ""
		strDirResto = ""
	End if

	strSql=""
	strSql="SELECT PIE_PORC_CAPITAL, HON_PORC_CAPITAL, IC_PORC_CAPITAL, TASA_MAX_CONV, DESCRIPCION, TIPO_INTERES FROM CLIENTE WHERE CODCLIENTE ='" & intCodCliente & "'"
	set rsTasa=Conn.execute(strSql)
	if not rsTasa.eof then
		intTasaMax = ValNulo(rsTasa("TASA_MAX_CONV"),"N")/100
		intPorcPie = ValNulo(rsTasa("PIE_PORC_CAPITAL"),"N")/100
		intPorcHon = ValNulo(rsTasa("HON_PORC_CAPITAL"),"N")/100
		intPorcIc = ValNulo(rsTasa("IC_PORC_CAPITAL"),"N")/100
		strDescripcion = rsTasa("DESCRIPCION")
		strTipoInteres = rsTasa("TIPO_INTERES")
	Else
		intTasaMax = 1
		intPorcPie = 1
		intPorcHon = 1
		intPorcIc = 1
		strDescripcion = ""
		strTipoInteres = "S"
	end if
	strTipoInteres = "S"
	rsTasa.close
	set rsTasa=nothing

	intMaximaAnual = intTasaMax * 12


	strSql="SELECT ID_CONVENIO FROM CONVENIO_ENC "
	strSql= strSql & "WHERE RUTDEUDOR = '" & strRutDeudor & "' AND COD_CLIENTE = '" & intCodCliente & "'"
	strSql= strSql & " AND ID_CONVENIO NOT IN (SELECT CONVENIO_ANT FROM REPACTACION_ENC WHERE RUTDEUDOR = '" & strRutDeudor & "' AND COD_CLIENTE = '" & intCodCliente & "')"

	''Response.write strSql

	set rsConvenio=Conn.execute(strSql)
	If Not rsConvenio.Eof Then
		id_convenio = rsConvenio("ID_CONVENIO")
	Else
		id_convenio = "-1"
	End If


	strSql="SELECT CUENTA, NRODOC, IsNull(FECHAVENC,'01/01/1900'), IsNull(datediff(d,fechavenc,getdate()),0) , TIPODOCUMENTO, CODREMESA , VALORCUOTA, SALDO, USUARIO.LOGIN , ESTADO_DEUDA.DESCRIPCION"
	strSql=strSql & " FROM CUOTA , USUARIO , ESTADO_DEUDA WHERE RUTDEUDOR = '" & strRutDeudor & "' AND CODCLIENTE = '" & intCodCliente & "'"
	strSql=strSql & " AND CUOTA.USUARIO_ASIG *= USUARIO.ID_USUARIO AND CUOTA.ESTADO_DEUDA *= ESTADO_DEUDA.CODIGO"

	set rsDET=Conn.execute(strSql)
	intTotHonorarios=0
	intTotIndemComp=0
	intTotDeudaCapital = 0
	if not rsDET.eof then
		intColumnas = rsDET.Fields.Count - 1
		intSaldo = 0
		intValorCuota = 0
		total_ValorCuota = 0
		Do until rsDET.eof
			intTotDeudaCapital = intTotDeudaCapital + clng(rsDET(7))
			rsDET.movenext
		Loop
	end if
	rsDET.close
	set rsDET=nothing


	intTotIndemComp = intIndemCompensatoriaD
	intTotHonorarios = intOtrosD
	''intTotHonorarios = 0
	intTotGastos = intGastosJudicialesD


	If Trim(intTotDeudaCapital) = "0" Then
		intTotIndemComp = 0
		intTotHonorarios = 0
		intTotGastos = 0
	End If


	intTotalDeuda = intTotDeudaCapital + intTotIndemComp + intTotHonorarios

	intTotalCostas = VALNULO(intTotIndemComp,"N") + VALNULO(intTotGastos,"N") + VALNULO(intTotHonorarios,"N")

	cerrarSCG()

	%>

<FORM onSubmit="return validardatos(this);" name="datos" method="post" action="generar_repactacion.asp">

<TABLE ALIGN="CENTER" WIDTH="600" BORDER="1" BORDERCOLOR = "#000000" CELLSPACING=0 CELLPADDING=1>
	<TR>
		<TD>

			<table width="600" border="0" bordercolor="#FFFFFF">
					<tr bordercolor="#999999">
						<TD>RUT</TD>
						<TD>NOMBRE O RAZON SOCIAL:</TD>
						<TD>USUARIO</TD>
						<TD>FECHA</TD>
						<TD>&nbsp;</TD>
					</TR>
					  <tr bgcolor="#FFFFFF" class="Estilo8">
						<td ALIGN="LEFT"><input name="TX_RUT" type="text" size="10" maxlength="10" onChange="Valida_Rut(this.value);Refrescar(this.value)" value="<%=strRutDeudor%>"></TD>
						<TD><%=strNombreDeudor%>
						<INPUT TYPE="hidden" NAME="strRutDeudor" value="<%=strRutDeudor%>">
						</TD>
						<TD ALIGN="LEFT"><%=session("nombre_user")	%></TD>

						<TD><%=DATE%></TD>
						<TD>
							<acronym title="BUSCAR RUT">
								<input name="bu_" type="button" onClick="window.navigate('simulacion_repactacion.asp?TX_RUT=' + TX_RUT.value);" value="Buscar">
							</acronym>
							<acronym title="LIMPIAR FORMULARIO">
								<input name="li_" type="button" onClick="window.navigate('simulacion_repactacion.asp?Limpiar=1');" value="Limpiar">
							</acronym>
						</TD>
					  </TR>
			</table>

		</TD>
	</TR>
</TABLE>
<BR>
<BR>


<TABLE ALIGN="CENTER" WIDTH="600" BORDER="1" BORDERCOLOR = "#000000" CELLSPACING=0 CELLPADDING=1>

 		<TR>
		 	<TD>

		 		<TABLE ALIGN="CENTER" WIDTH="600" BORDER="0" BORDERCOLOR = "#000000" CELLSPACING=0 CELLPADDING=1>

				 		<tr class="Estilo1">
						 	<TD colspan=4 align="center"><span class="Estilo28"><span class="Estilo29 Estilo33">
					 		  RECONOCIMIENTO DE DEUDA Y REPACTACION</span></TD>
				 		</TR>
				 		<TR>
						 	<td colspan=4><div align="center"><%=strMandante%></div></TD>
				 		</TR>
				 		<TR>
				 			<td colspan=4>&nbsp</TD>
				 		</TR>
						<TR>
							<TD><span class="Estilo29 Estilo31 Estilo32">Nombre : </span></TD>
							<TD><span class="Estilo29 Estilo31 Estilo32"><%=strNombreDeudor%></span></TD>
							<TD><span class="Estilo29 Estilo31 Estilo32">Rut : </span></TD>
							<TD><span class="Estilo29 Estilo31 Estilo32"><%=strRutDeudor%></span></TD>
						</TR>
 				</TABLE>

	 		</TD>
 		</TR>

 </TABLE>


<BR>
<BR>


<table width="600" ALIGN="CENTER" BORDER="1" BORDERCOLOR = "#000000" CELLSPACING=0 CELLPADDING=1>
	  <tr>
	    <td valign="top">
		<%
		If Trim(strRutDeudor) <> "" then
		abrirscg()
			strSql="SELECT CUOTA as IDCUOTA, convert(VARCHAR(10),IsNull(FECHA_PAGO,'01/01/1900'),103) as FECHAVENC, IsNull(datediff(d,FECHA_PAGO,getdate()),0) as ANTIGUEDAD, CUOTA as NRODOC, IsNull(TOTAL_CUOTA,0) as SALDO FROM CONVENIO_DET WHERE ID_CONVENIO = " & id_convenio & " AND IsNull(PAGADA,'') <> 'S'"
			'response.Write(strSql)
			'response.End()
			set rsDET=Conn.execute(strSql)
			if not rsDET.eof then
			%>
			  <table width="100%" border="0" bordercolor="#FFFFFF">
		        <tr bordercolor="#999999" class="Estilo13">
		          <td >&nbsp</td>
		          <TD ALIGN="RIGHT">CUOTA</td>
		          <TD ALIGN="RIGHT">F.VENCIM.</td>
		          <TD ALIGN="RIGHT">ANTIG.</td>
		          <TD ALIGN="RIGHT">SALDO</td>
		          <TD ALIGN="RIGHT">INTERES</td>
		          <TD ALIGN="RIGHT">SUB TOTAL</td>

		        </tr>

				<%
				intSaldo = 0
				intValorCuota = 0
				total_ValorCuota = 0
				do until rsDET.eof
				intSaldo = ValNulo(rsDET("SALDO"),"N")
				strNroDoc = Trim(rsDET("NRODOC"))
				intDiasMora = rsDET("ANTIGUEDAD")
				If intDiasMora <= 0 Then intDiasMora = 0



				intInteresCuota = InteresCuota(intDiasMora,intMaximaAnual,intSaldo)
				%>
		        <tr bordercolor="#999999" >
		          <TD><INPUT TYPE=checkbox NAME="CH_<%=rsDET("IDCUOTA")%>" onClick="suma_capital(this,TX_SALDO_<%=rsDET("IDCUOTA")%>.value,TX_INTERES_<%=rsDET("IDCUOTA")%>.value);";></TD>
		          <td><div align="right"><%=rsDET("IDCUOTA")%></div></td>
		          <td><div align="right"><%=rsDET("FECHAVENC")%></div></td>
		          <td><div align="right"><%=rsDET("ANTIGUEDAD")%></div></td>
		          <td align="right" ><input name="TX_SALDO_<%=rsDET("IDCUOTA")%>" type="text" value="<%=intSaldo%>" size="10" maxlength="10" align="RIGHT"></td>
		          <td align="right" ><input name="TX_INTERES_<%=rsDET("IDCUOTA")%>" type="text" value="<%=intInteresCuota%>" size="10" maxlength="10" align="RIGHT"></td>
		          <td align="right" ><input name="TX_TOTAL_<%=rsDET("IDCUOTA")%>" type="text" value="<%=intSaldo + intInteresCuota%>" size="10" maxlength="10" align="RIGHT"></td>
		         <%
					total_ValorCuota = total_ValorCuota + intValorCuota
					total_docs = total_docs + 1
				 %>
				 </tr>
				 <%rsDET.movenext
				 loop
				 %>

		      </table>
			  <%end if
			  rsDET.close
			  set rsDET=nothing
		  Else
		  %>
			<table width="100%" border="0" bordercolor="#FFFFFF">
			<tr bordercolor="#999999" class="Estilo8">
			<td align="center">

			Deudor no posee documentos pendientes
			</td>
			</tr>
			</table>
		  <%end if%>
	    </td>
	  </tr>

	</table>

<BR>
<BR>


<TABLE ALIGN="CENTER" WIDTH="600" BORDER="1" BORDERCOLOR = "#000000" CELLSPACING=0 CELLPADDING=1>

		<TR>
			<TD>

				<TABLE ALIGN="CENTER" BORDER=1 CELLSPACING=2 CELLPADDING=2 WIDTH="100%">
				<TR>
					<TD>
						<TABLE ALIGN="CENTER" WIDTH="180" BORDER="0">
							<TR HEIGHT=30>
								<TD COLSPAN=2 ALIGN="CENTER" class="Estilo22">
									MONTO DE DEUDA
								</TD>
							</TR>
							<TR HEIGHT=30>
								<TD ALIGN="RIGHT" class="Estilo22">Capital: </TD>
								<TD><input name="TX_CAPITAL" type="text" size="10" onChange="suma_capital_2();"></TD>
							</TR>
							<TR HEIGHT=30>
								<TD align="right" class="Estilo22">Gastos Operacionales: </TD>
								<TD><input name="TX_GASTOSOPE" type="text" size="10" value="<%=intTotGastos%>" onChange="suma_capital_2();"></TD>
							</TR>
							<TR HEIGHT=30 BGCOLOR="#CCCCFF">
								<TD align="right" class="Estilo22"> Comision : </TD>
								<TD><input name="TX_COMISION" type="text" size="10" value="<%=intTotIndemComp%>" onChange="suma_capital_2();"></TD>
							</TR>
							<TR HEIGHT=30 BGCOLOR="#CCCCFF">
								<TD align="right" class="Estilo22">Interes Cuotas: </TD>
								<TD><input name="TX_INTERESCUOTA" type="text" size="10" value="<%=intTotHonorarios%>" onChange="suma_capital_2();"></TD>
							</TR>
							<TR HEIGHT=30>
								<TD>&nbsp</TD>
								<TD>______________</TD>
							</TR>
								<TR HEIGHT=30>
									<TD align="right" class="Estilo22">Total Deuda: </TD>
									<TD><input name="TX_TOTALDEUDA" type="text" size="10"></TD>
								</TR>
						</TABLE>


					</TD>

					<INPUT TYPE="hidden" NAME="hdintCapital" value="<%=intTotDeudaCapital%>">
					<INPUT TYPE="hidden" NAME="id_convenio" value="<%=id_convenio%>">

					<!--INPUT TYPE="hidden" NAME="TX_COMISION" value="<%=intTotIndemComp%>"-->
					<!--INPUT TYPE="hidden" NAME="TX_GASTOSOPE" value="<%=intTotGastos%>"-->
					<!--INPUT TYPE="hidden" NAME="TX_INTERESCUOTA" value="<%=intTotHonorarios%>"-->


					<TD>

				  <TABLE ALIGN="CENTER" WIDTH="150" BORDER="0" valign="TOP">
				  <TR HEIGHT=30>
						<TD COLSPAN=2 ALIGN="CENTER" class="Estilo22">
							MODALIDAD DEL PAGO
						</TD>
				  </TR>
					<TR valign="TOP">
						<TD ALIGN="LEFT" class="Estilo23">Pie $</TD>
						<TD ALIGN="LEFT" class="Estilo23"></TD>
					</TR>
					<TR valign="TOP">
						<TD><input name="pie" type="text" size="6" onChange="suma_capital_2();"></TD>
						<TD>
							<A HREF="#" onClick="CalculaCuotas2('<%=strTipoInteres%>',TX_TOTALCONVENIO.value, TX_TASA_CONV.value,cuotas.value)";>
								<acronym title="VER CONVENIO">calcular</acronym>
							</A>
						</TD>
					</TR>

								<TR>
									<TD ALIGN="LEFT" class="Estilo23">C.Cuotas: </TD>
									<TD ALIGN="LEFT" class="Estilo23">Dia de Pago: </TD>
								</TR>
								<TR>
									<TD>
										<select name="cuotas" size="1">
											<option value="1">1</option>
											<option value="2">2</option>
											<option value="3">3</option>
											<option value="4">4</option>
											<option value="5">5</option>
											<option value="6">6</option>
											<option value="7">7</option>
											<option value="8">8</option>
											<option value="9">9</option>
											<option value="10">10</option>
											<option value="11">11</option>
											<option value="12">12</option>
										</select>
									</TD>
									<TD>
										<input name="TX_DIAPAGO" type="text" value="5" size="3" maxlength="5">
									</TD>
								</TR>
							</TD>
					</TR>



					<TR valign="TOP">
						<TD ALIGN="LEFT" class="Estilo23">Tasa</TD>
						<TD ALIGN="LEFT" class="Estilo23">Int.Conv:</TD>
					</TR>
					<TR>
						<TD><input name="TX_TASA_CONV" type="text" size="3"></TD>
						<TD><input name="TX_INTERES_CONV" type="text" size="6"></TD>
					</TR>
					<TR>
						<TD COLSPAN=2  align="LEFT" class="Estilo22">Total A Convenir: </TD>
					</TR>
					<TR HEIGHT=30>
						<TD COLSPAN=2 align="LEFT">______________</TD>

					</TR>
					<TR>
						<TD COLSPAN=2 ><input name="TX_TOTALCONVENIO" type="text" size="10" onChange="CalculaCuotas();"></TD>
					</TR>

				  </TABLE>
				 </TD>



					<TD>
						<TABLE ALIGN="CENTER" WIDTH="200" BORDER="0" valign="TOP">
							<TR>
								<TD ALIGN="LEFT" class="Estilo23">Cuota 1: </TD>
								<TD ALIGN="LEFT" class="Estilo23">Cuota 2: </TD>
							</TR>
							<TR>
								<TD><input name="TX_CUOTA1" type="text" size="10" /></TD>
								<TD><input name="TX_CUOTA2" type="text" size="10" /></TD>
							</TR>
							<TR>
								<TD ALIGN="LEFT" class="Estilo23">Cuota 3: </TD>
								<TD ALIGN="LEFT" class="Estilo23">Cuota 4: </TD>
							</TR>
							<TR>
								<TD><input name="TX_CUOTA3" type="text" size="10" /></TD>
								<TD><input name="TX_CUOTA4" type="text" size="10" /></TD>
							</TR>
							<TR>
								<TD ALIGN="LEFT" class="Estilo23">Cuota 5: </TD>
								<TD ALIGN="LEFT" class="Estilo23">Cuota 6: </TD>
							</TR>
							<TR>
								<TD><input name="TX_CUOTA5" type="text" size="10" /></TD>
								<TD><input name="TX_CUOTA6" type="text" size="10" /></TD>
							</TR>
							<TR>
								<TD ALIGN="LEFT" class="Estilo23">Cuota 7: </TD>
								<TD ALIGN="LEFT" class="Estilo23">Cuota 8: </TD>
							</TR>
							<TR>
								<TD><input name="TX_CUOTA7" type="text" size="10" /></TD>
								<TD><input name="TX_CUOTA8" type="text" size="10" /></TD>
							</TR>
						</TABLE>
					</TD>
				</TR>
				</TABLE>





			</TD>
		</TR>

 </TABLE>
<BR>
<BR>
 <TABLE ALIGN="CENTER" WIDTH="600" BORDER="0">
 		<TR>
 			<TD>
  				  <input type="submit" name="Submit" value="Ver Convenio">
 			</TD>
 		</TR>

 </TABLE>

</FORM>

<SCRIPT LANGUAJE=JavaScript>

function roundNumber(rnum, rlength) { // Arguments: number to round, number of decimal places
  //var newnumber = Math.round(rnum*Math.pow(10,rlength))/Math.pow(10,rlength);
  var newnumber = Math.round(rnum/10);
  return (newnumber/10);
}

function roundNumber2(rnum) { // Arguments: number to round, number of decimal places
  var newnumber = Math.round(rnum);
  return (newnumber);
}

function suma_capital(objeto , intValorSaldoCapital, intValorInteresCuota){
	if (datos.TX_CAPITAL.value == '') datos.TX_CAPITAL.value = 0
	if (datos.TX_COMISION.value == '') datos.TX_COMISION.value = 0
	if (datos.TX_GASTOSOPE.value == '') datos.TX_GASTOSOPE.value = 0
	if (datos.TX_INTERESCUOTA.value == '') datos.TX_INTERESCUOTA.value = 0
	if (datos.pie.value == '') datos.pie.value = 0

	if (objeto.checked == true) {
		datos.TX_CAPITAL.value = eval(datos.TX_CAPITAL.value) + eval(intValorSaldoCapital);
		datos.TX_INTERESCUOTA.value = eval(datos.TX_INTERESCUOTA.value) + eval(intValorInteresCuota);
		datos.TX_COMISION.value = roundNumber2((0.1 * eval(datos.TX_CAPITAL.value)), 0);
		datos.TX_GASTOSOPE.value = roundNumber2((0.25 * eval(datos.TX_CAPITAL.value)), 0);
		datos.TX_TOTALDEUDA.value = eval(datos.TX_CAPITAL.value) + eval(datos.TX_GASTOSOPE.value) + eval(datos.TX_COMISION.value) + eval(datos.TX_INTERESCUOTA.value);
		datos.pie.value = roundNumber2((0.4 * eval(datos.TX_TOTALDEUDA.value)), 0);
		datos.TX_TOTALCONVENIO.value = eval(datos.TX_TOTALDEUDA.value) - eval(datos.pie.value);
	}
	else
	{
		datos.TX_CAPITAL.value = eval(datos.TX_CAPITAL.value) - eval(intValorSaldoCapital);
		datos.TX_INTERESCUOTA.value = eval(datos.TX_INTERESCUOTA.value) - eval(intValorInteresCuota);
		//datos.pie.value = eval(<%=intTotGastos%>) + (roundNumber((0.2 * eval(datos.TX_CAPITAL.value)), 0));
		datos.TX_COMISION.value = roundNumber2((0.1 * eval(datos.TX_CAPITAL.value)), 0);
		datos.TX_GASTOSOPE.value = roundNumber2((0.25 * eval(datos.TX_CAPITAL.value)), 0);
		datos.TX_TOTALDEUDA.value = eval(datos.TX_CAPITAL.value) + eval(datos.TX_GASTOSOPE.value) + eval(datos.TX_COMISION.value) + eval(datos.TX_INTERESCUOTA.value);
		datos.pie.value = roundNumber2((0.4 * eval(datos.TX_TOTALDEUDA.value)), 0);
		datos.TX_TOTALCONVENIO.value = eval(datos.TX_TOTALDEUDA.value) - eval(datos.pie.value);

	}
}


function suma_capital_2(){
	if (datos.TX_CAPITAL.value == '') datos.TX_CAPITAL.value = 0
	if (datos.TX_COMISION.value == '') datos.TX_COMISION.value = 0
	if (datos.TX_GASTOSOPE.value == '') datos.TX_GASTOSOPE.value = 0
	if (datos.TX_INTERESCUOTA.value == '') datos.TX_INTERESCUOTA.value = 0

	if (datos.TX_CUOTA1.value == '') datos.TX_CUOTA1.value = 0
	if (datos.TX_CUOTA2.value == '') datos.TX_CUOTA2.value = 0
	if (datos.TX_CUOTA3.value == '') datos.TX_CUOTA3.value = 0
	if (datos.TX_CUOTA4.value == '') datos.TX_CUOTA4.value = 0
	if (datos.TX_CUOTA5.value == '') datos.TX_CUOTA5.value = 0
	if (datos.TX_CUOTA6.value == '') datos.TX_CUOTA6.value = 0
	if (datos.TX_CUOTA7.value == '') datos.TX_CUOTA7.value = 0
	if (datos.TX_CUOTA8.value == '') datos.TX_CUOTA8.value = 0

	datos.TX_TOTALDEUDA.value = eval(datos.TX_CAPITAL.value) + eval(datos.TX_GASTOSOPE.value)+ eval(datos.TX_COMISION.value)+ eval(datos.TX_INTERESCUOTA.value);
	datos.TX_TOTALCONVENIO.value = eval(datos.TX_TOTALDEUDA.value) - eval(datos.pie.value);
}

function CalculaCuotas(){
	//datos.TX_CUOTA1.value = eval(datos.TX_TOTALCONVENIO.value) + eval(datos.TX_COMISION.value) + eval(datos.TX_GASTOSOPE.value) + eval(datos.TX_INTERESCUOTA.value)
	datos.TX_TOTALCONVENIO.value = eval(datos.TX_TOTALDEUDA.value) - eval(datos.pie.value);
}


function CalculaCuotas2(strTipoInteres,intKapitalInicial,intTasaMax,intCuotas){
	var intMontoConInteres=0;
	var intMontoCuota=0;

	if (strTipoInteres =='C') {
		intMontoConInteres = intKapitalInicial * potencia((1 + intTasaMax/100),intCuotas)
	}
	else {
		intMontoConInteres = intKapitalInicial * (1 + ((intTasaMax/100)*intCuotas))
	}

	intMontoCuota = roundNumber2(intMontoConInteres/intCuotas,0)

	for(i=1;i<=intCuotas;i++) {
		if (i == 1) datos.TX_CUOTA1.value = intMontoCuota
		if (i == 2) datos.TX_CUOTA2.value = intMontoCuota
		if (i == 3) datos.TX_CUOTA3.value = intMontoCuota
		if (i == 4) datos.TX_CUOTA4.value = intMontoCuota
		if (i == 5) datos.TX_CUOTA5.value = intMontoCuota
		if (i == 6) datos.TX_CUOTA6.value = intMontoCuota
		if (i == 7) datos.TX_CUOTA7.value = intMontoCuota
		if (i == 8) datos.TX_CUOTA8.value = intMontoCuota
	}

	datos.TX_INTERES_CONV.value = roundNumber2(eval(intMontoConInteres) - eval(datos.TX_TOTALCONVENIO.value),0)
}


function ValidaDatos(){
	if (datos.TX_CUOTA1.value == '') datos.TX_CUOTA1.value = 0
	if (datos.TX_CUOTA2.value == '') datos.TX_CUOTA2.value = 0
	if (datos.TX_CUOTA3.value == '') datos.TX_CUOTA3.value = 0
	if (datos.TX_CUOTA4.value == '') datos.TX_CUOTA4.value = 0
	if (datos.TX_CUOTA5.value == '') datos.TX_CUOTA5.value = 0
	if (datos.TX_CUOTA6.value == '') datos.TX_CUOTA6.value = 0
	if (datos.TX_CUOTA7.value == '') datos.TX_CUOTA7.value = 0
	if (datos.TX_CUOTA8.value == '') datos.TX_CUOTA8.value = 0
	if (datos.TX_INTERES_CONV.value == '') datos.TX_INTERES_CONV.value = 0
	if (datos.TX_TOTALCONVENIO.value == '') datos.TX_TOTALCONVENIO.value = 0

	 if (( eval(datos.TX_INTERES_CONV.value) + eval(datos.TX_TOTALCONVENIO.value) ) != (eval(datos.TX_CUOTA1.value) + eval(datos.TX_CUOTA2.value) + eval(datos.TX_CUOTA3.value) + eval(datos.TX_CUOTA4.value) + eval(datos.TX_CUOTA5.value) + eval(datos.TX_CUOTA6.value) + eval(datos.TX_CUOTA7.value)))
	 {
	 	alert('Datos incorrectos convenio + interes convenio = ' + (eval(datos.TX_INTERES_CONV.value) + eval(datos.TX_TOTALCONVENIO.value)) + ', total cuotas = ' + (eval(datos.TX_CUOTA1.value) + eval(datos.TX_CUOTA2.value) + eval(datos.TX_CUOTA3.value) + eval(datos.TX_CUOTA4.value) + eval(datos.TX_CUOTA5.value) + eval(datos.TX_CUOTA6.value) + eval(datos.TX_CUOTA7.value)));
	 	return false;
	 }
	 else
	 {
		return true;
	 }

}

function validardatos(formulario)
 {
	 var enviardatos=true;
   /* if(formulario.total.value < formulario.pie.value){
		alert("Error de ingreso: El pie es mayor al total");
		formulario.reset();
		return false;
	}*/
	  if(!ValidaDatos()){
	  		return false;
		}
		else
		{
			return true;
		}
	  if(formulario.pie.value==""){
		alert("Error de ingreso: Debe Ingresar el pie");
		return false;
	  }
	  if(formulario.capital.value=='-' || formulario.indemComp.value=='-' || formulario.honorarios.value=='-'){
		alert("Error de ingreso: Debe Ingresar los descuentos");
		return false;
	  }
	  if(formulario.cuotas.value=='-'){
		alert("Error de ingreso: Debe Ingresar cantidad de cuotas");
		return false;
	}

	return true;

}

function potencia(base, elevado){
	var i=0;
	var resul=1;
	if(elevado==0) {
		resul=1;
		}
	else
	{
		resul=base;
		for(i=1;i<elevado;i++)
		resul=resul*base;
	}
	//alert(resul);
	return resul;
}

</SCRIPT>

</body>
</html>


