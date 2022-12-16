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

	intIdDemanda=Trim(Request("intIdDemanda"))

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
	strSql="SELECT PIE_PORC_CAPITAL, HON_PORC_CAPITAL, IC_PORC_CAPITAL, TASA_MAX_CONV, DESCRIPCION FROM CLIENTE WHERE CODCLIENTE ='" & intCodCliente & "'"
	set rsTasa=Conn.execute(strSql)
	if not rsTasa.eof then
		intTasaMax = ValNulo(rsTasa("TASA_MAX_CONV"),"N")/100
		intPorcPie = ValNulo(rsTasa("PIE_PORC_CAPITAL"),"N")/100
		intPorcHon = ValNulo(rsTasa("HON_PORC_CAPITAL"),"N")/100
		intPorcIc = ValNulo(rsTasa("IC_PORC_CAPITAL"),"N")/100
		strDescripcion = rsTasa("DESCRIPCION")
	Else
		intTasaMax = 1
		intPorcPie = 1
		intPorcHon = 1
		intPorcIc = 1
		strDescripcion = ""
	end if
	rsTasa.close
	set rsTasa=nothing


	If Trim(intCodCliente)="1001" Then intAdicHonorarios = "8400" Else intAdicHonorarios = "0"


	strSql="SELECT CUENTA, NRODOC, IsNull(FECHAVENC,'01/01/1900'), IsNull(datediff(d,fechavenc,getdate()),0) , TIPODOCUMENTO, CODREMESA , VALORCUOTA, SALDO, USUARIO.LOGIN , ESTADO_DEUDA.DESCRIPCION"
	strSql=strSql & " FROM CUOTA , USUARIO , ESTADO_DEUDA WHERE RUTDEUDOR = '" & strRutDeudor & "' AND CODCLIENTE = '" & intCodCliente & "'"
	strSql=strSql & " AND CUOTA.USUARIO_ASIG *= USUARIO.ID_USUARIO AND CUOTA.ESTADO_DEUDA *= ESTADO_DEUDA.CODIGO"

	'response.write "<br>strSql=" & strSql
	'Response.End
	set rsDET=Conn.execute(strSql)
	intTotHonorarios=0
	intTotIndemComp=0
	intTotDeudaCapital = 0
	if not rsDET.eof then
		intColumnas = rsDET.Fields.Count - 1
		intSaldo = 0
		intValorCuota = 0
		total_ValorCuota = 0
		''rsDET.movenext
		Do until rsDET.eof
			'Response.write "7=" & (rsDET(7))
			'Response.write "8=" & (rsDET(8))
			'Response.write "9=" & (rsDET(9))
			'Response.End
			'intTotIndemComp = intTotIndemComp + clng(rsDET(7))
			'intTotHonorarios = intTotHonorarios + clng(rsDET(8))
			intTotDeudaCapital = intTotDeudaCapital + clng(rsDET(7))
			rsDET.movenext
		Loop
	end if
	rsDET.close
	set rsDET=nothing


	if Trim(intIdDemanda) = "" Then
		strSql = "SELECT TOP 1 MONTO, INDEM_COMPENSATORIA, HONORARIOS, INTERESES, GASTOS_JUDICIALES FROM DEMANDA WHERE CODCLIENTE = '" & intCodCliente & "' AND RUTDEUDOR = '" & strRutDeudor & "' ORDER BY FECHA_INGRESO DESC"
	Else
		strSql = "SELECT TOP 1 MONTO, INDEM_COMPENSATORIA, HONORARIOS, INTERESES, GASTOS_JUDICIALES FROM DEMANDA WHERE IDDEMANDA = " & intIdDemanda
	End if
	''rESPONSE.WRITE strSql

	set rsDemanda= Conn.execute(strSql)
	if not rsDemanda.eof then
		intMontoDemandaD=rsDemanda("MONTO")
		intIndemCompensatoriaD=rsDemanda("INDEM_COMPENSATORIA")
		intHonorariosD=rsDemanda("HONORARIOS")
		intInteresesD=rsDemanda("INTERESES")
		intGastosJudicialesD=rsDemanda("GASTOS_JUDICIALES")
		intOtrosD=intHonorariosD
		'rESPONSE.WRITE "<BR>hola" & intIndemCompensatoriaD

	Else
		%>

		<script>
			//alert('Deudor no posee demanda, no puede ingresar convenio');
			//history.back();
		</script>
		<%
		''Response.End
		intMontoDemandaD=0
		intIndemCompensatoriaD=0
		intHonorariosD=0
		intInteresesD=0
		intGastosJudicialesD=0
		intOtrosD=0
	end if

	If Trim(intCodCliente)= "1000" Then
		If intIndemCompensatoriaD  > 35000 Then
			'intIndemCompensatoriaD = intIndemCompensatoriaD - 35000
			'intOtrosD = 35000
		End If
	End If

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
	''intTotalCostas = VALNULO(intTotIndemComp,"N") + VALNULO(intTotGastos,"N") + VALNULO(intTotHonorarios,"N")

	intTotalCostas = VALNULO(intTotIndemComp,"N") + VALNULO(intTotGastos,"N")

	cerrarSCG()

	'Response.write "CH_PARAM = " & UCASE(Request("CH_PARAM"))

	'If UCASE(Request("CH_PARAM")) = "ON" Then strCheckParam = "checked"  Else strCheckParam = ""

	%>

<FORM onSubmit="return validardatos(this);" name="datos" method="post" action="generar_convenio.asp">

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
						<TD ALIGN="LEFT"><%=session("session_login")	%></TD>

						<TD><%=DATE%></TD>
						<TD>
							<acronym title="BUSCAR RUT">
								<input name="bu_" type="button" onClick="window.navigate('simulacion_convenio.asp?TX_RUT=' + TX_RUT.value);" value="Buscar">
							</acronym>
							<acronym title="LIMPIAR FORMULARIO">
								<input name="li_" type="button" onClick="window.navigate('simulacion_convenio.asp?Limpiar=1');" value="Limpiar">
							</acronym>
						</TD>
					  </TR>
			</table>

		</TD>
	</TR>
</TABLE>

<BR>

<TABLE ALIGN="CENTER" WIDTH="600" BORDER="1" BORDERCOLOR = "#000000" CELLSPACING=0 CELLPADDING=1>

 		<TR>
		 	<TD>

		 		<TABLE ALIGN="CENTER" WIDTH="600" BORDER="0" BORDERCOLOR = "#000000" CELLSPACING=0 CELLPADDING=1>

				 		<tr class="Estilo1">
						 	<TD colspan=4 align="center"><span class="Estilo28"><span class="Estilo29 Estilo33">
					 		  RECONOCIMIENTO DE DEUDA Y CONVENIO DE PAGO					 		</span></TD>
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

<table width="600" ALIGN="CENTER" BORDER="1" BORDERCOLOR = "#000000" CELLSPACING=0 CELLPADDING=1>
		<tr>
	    <td valign="top">
	    	<a href="#" onClick="marcar_boxes(true);">Marcar todos</a>&nbsp;&nbsp;&nbsp;
	    	<a href="#" onClick="desmarcar_boxes(true);">Desmarcar todos</a>
	    </td>
	    </tr>


	  <tr>
	    <td valign="top">
		<%
		If Trim(strRutDeudor) <> "" then
		abrirscg()
			strSql="SELECT IDCUOTA, RUTDEUDOR, IsNull(FECHAVENC,'01/01/1900') as FECHAVENC, IsNull(datediff(d,fechavenc,getdate()),0) as ANTIGUEDAD, NRODOC,IsNull(VIGENTE,0) as VIGENTE, IsNull(VALORCUOTA,0) as VALORCUOTA,IsNull(SALDO,0) as SALDO,isnull(GASTOSCOBRANZAS,0) as GASTOSCOBRANZAS,IsNull(USUARIO_ASIG,0) as USUARIO_ASIG,NROCUOTA, VIGENTE, IsNull(MORA,0) as MORA, IsNull(VENCIDA,0) as VENCIDA, IsNull(CASTIGO,0) as CASTIGO, CENTRO_COSTO, SUCURSAL , ESTADO_DEUDA, CODREMESA, CUENTA, NRODOC, TIPODOCUMENTO FROM CUOTA WHERE RUTDEUDOR='"& strRutDeudor &"' AND CODCLIENTE='"& intCodCliente &"' AND SALDO > 0 AND ESTADO_DEUDA = 1 ORDER BY FECHAVENC DESC"
			'response.Write(strSql)
			'response.End()
			set rsDET=Conn.execute(strSql)
			if not rsDET.eof then
			%>
			  <table width="100%" border="0" bordercolor="#FFFFFF">
		        <tr bordercolor="#999999" class="Estilo13">
		          <td width="8%">&nbsp</td>
		          <td width="8%">CUENTA</td>
		          <td width="8%">NRO. DOC</td>
		          <td width="8%">F.VENCIM.</td>
		          <td width="8%">ANTIG.</td>
		          <td width="10%">TIPO DOC</td>
		          <td width="8%">ASIG.</td>
		          <td width="10%">SALDO</td>

		        </tr>

				<%
				intSaldo = 0
				intValorCuota = 0
				total_ValorCuota = 0
				strArrConcepto = ""
				strArrIdCuota = ""
				Do until rsDET.eof
					intSaldo = ValNulo(rsDET("SALDO"),"N")
					intValorCuota = ValNulo(rsDET("VALORCUOTA"),"N")
					strNroDoc = Trim(rsDET("NRODOC"))
					strNroCuota = Trim(rsDET("NROCUOTA"))
					strSucursal = Trim(rsDET("SUCURSAL"))
					strEstadoDeuda = Trim(rsDET("ESTADO_DEUDA"))
					strCodRemesa = Trim(rsDET("CODREMESA"))

					strArrConcepto = strArrConcepto & ";" & "CH_" & rsDET("IDCUOTA")
					strArrIdCuota = strArrIdCuota & ";" & rsDET("IDCUOTA")

				%>
		        <tr bordercolor="#999999" >
		          <TD><INPUT TYPE=checkbox NAME="CH_<%=rsDET("IDCUOTA")%>" onClick="suma_capital(this,TX_SALDO_<%=rsDET("IDCUOTA")%>.value);";></TD>
		          <td><div align="right"><%=rsDET("CUENTA")%></div></td>
		          <td><div align="right"><%=rsDET("NRODOC")%></div></td>
		          <td><div align="right"><%=rsDET("FECHAVENC")%></div></td>
		          <td><div align="right"><%=rsDET("ANTIGUEDAD")%></div></td>
		          <td><div align="right"><%=rsDET("TIPODOCUMENTO")%></div></td>
		          <td><div align="center"><%=rsDET("CODREMESA")%></div></td>
		         <td align="right" ><input name="TX_SALDO_<%=rsDET("IDCUOTA")%>" type="text" value="<%=intSaldo%>" size="10" maxlength="10" align="RIGHT"></td>
		         <%
					total_ValorCuota = total_ValorCuota + intValorCuota
					total_gc = total_gc + clng(rsDET("GASTOSCOBRANZAS"))
					total_docs = total_docs + 1
				 %>
				 </tr>
				 <%
				 	rsDET.movenext
				 loop
				 vArrConcepto = split(strArrConcepto,";")
				 vArrIdCuota = split(strArrIdCuota,";")

				 intTamvConcepto = ubound(vArrConcepto)

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
	<TABLE ALIGN="CENTER" WIDTH="600" BORDER="1" BORDERCOLOR = "#000000" CELLSPACING=0 CELLPADDING=1>

 		<TR>
		 	<TD>
		 		Utilizar Demanda :
				<%
				AbrirSCG()
				strSql = "SELECT IDDEMANDA, MONTO, INDEM_COMPENSATORIA, HONORARIOS, INTERESES, GASTOS_JUDICIALES FROM DEMANDA WHERE CODCLIENTE = '" & intCodCliente & "' AND RUTDEUDOR = '" & strRutDeudor & "' ORDER BY FECHA_INGRESO DESC"
				set rsDemanda= Conn.execute(strSql)
				Do While Not rsDemanda.eof
					intIdDemandaD1=rsDemanda("IDDEMANDA")
					intMontoDemandaD1=rsDemanda("MONTO")
					intIndemCompensatoriaD1=rsDemanda("INDEM_COMPENSATORIA")
					intHonorariosD1=rsDemanda("HONORARIOS")
					intInteresesD1=rsDemanda("INTERESES")
					intGastosJudicialesD1=rsDemanda("GASTOS_JUDICIALES")
				%>
					<A HREF="simulacion_convenio.asp?intIdDemanda=<%=intIdDemandaD1%>">
						<acronym title="Utilizar Demanda"><%=intIdDemandaD1%> ($ <%=FN(intMontoDemandaD1,0)%>) </acronym>
					 </A>
					 &nbsp;&nbsp;&nbsp;
				<%
					rsDemanda.movenext
					Loop
				CerrarSCG()
		 		%>

	 		</TD>
 		</TR>

	</TABLE>
<BR>


<TABLE ALIGN="CENTER" WIDTH="600" BORDER="1" BORDERCOLOR = "#000000" CELLSPACING=0 CELLPADDING=1>

		<TR>
			<TD>

				<TABLE ALIGN="CENTER" BORDER=0 CELLSPACING=10 CELLPADDING=10 WIDTH="100%">
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
								<!--TD align="right"><strong><span class=Estilo1><strong>$ <%=FN(intTotDeudaCapital,0)%></strong></span></strong></TD-->
								<TD><input name="TX_CAPITAL" type="text" size="10"></TD>
							</TR>
							<TR HEIGHT=30>
								<TD align="right" class="Estilo22">Gastos Judiciales: </TD>
								<TD align="right"><strong><span class=Estilo1><strong>$ <%=FN(intTotGastos,0)%></strong></span></strong></TD>
							</TR>
							<TR HEIGHT=30 BGCOLOR="#CCCCFF">
								<TD align="right" class="Estilo22"> Indem.Comp.: </TD>
								<TD align="right"><strong><span class=Estilo1><strong>$ <%=FN(intTotIndemComp,0)%></strong></span></strong></TD>
							</TR>

							<TR HEIGHT=30 BGCOLOR="#CCCCFF">
								<TD align="right" class="Estilo22">Honorarios : </TD>
								<!--TD align="right"><strong><span class=Estilo1><strong>$ <%=FN(intTotHonorarios,0)%></strong></span></strong></TD-->
								<TD align="right">
									<input name="TX_HONORARIOS" type="text" size="10">
								</TD>
							</TR>
							<TR HEIGHT=30>
								<TD>&nbsp</TD>
								<TD>______________</TD>
							</TR>
								<TR HEIGHT=30>
									<TD align="right" class="Estilo22">Total Deuda: </TD>
									<!---TD align="right"><strong><span class=Estilo1><strong>$ <%=FN(intTotalDeuda,0)%></strong></span></strong></TD--->
									<TD><input name="TX_TOTALDEUDA" type="text" size="10"></TD>
								</TR>
						</TABLE>


					</TD>

					<INPUT TYPE="hidden" NAME="hdintCapital" value="<%=intTotDeudaCapital%>">
					<INPUT TYPE="hidden" NAME="hdintIndemComp" value="<%=intTotIndemComp%>">
					<INPUT TYPE="hidden" NAME="hdintGastos" value="<%=intTotGastos%>">
					<INPUT TYPE="hidden" NAME="hdintHonorarios" value="<%=intTotHonorarios%>">

					<TD>




				<TABLE ALIGN="CENTER" WIDTH="150" BORDER="0">
				  <TR HEIGHT=30>
					<TD COLSPAN=2 ALIGN="CENTER" class="Estilo22">
						DESCUENTOS
					</TD>

				  </TR>
				  <TR HEIGHT=30>
					  <TD ALIGN="RIGHT" class="Estilo23">Capital:</TD>
					  <TD><input DISABLED name="capital" type="text" size="10" onChange="func_descuentos(this.value);"></TD>
				  </TR>
				  <TR HEIGHT=30>
						<TD ALIGN="RIGHT" class="Estilo23">Gastos Judiciales:</TD>
						<TD><input DISABLED name="gastos" type="text" size="10" onChange="func_descuentos(this.value);"></TD>
				  </TR>

				 <TR HEIGHT=30 BGCOLOR="#CCCCFF">
					  <TD ALIGN="RIGHT" class="Estilo23">IndemComp:</TD>
						<TD><input DISABLED name="indemComp" type="text" size="10" onChange="func_descuentos(this.value);"></TD>
				  </TR>



				  <TR HEIGHT=30 BGCOLOR="#CCCCFF">
				  	<td  align="right" class="Estilo23"> Honorarios:</TD>
					<TD><input DISABLED name="honorarios" type="text" size="10" onChange="func_descuentos(this.value);"></TD>
					</TR>
					<TR HEIGHT=30>
						<TD>&nbsp</TD>
						<TD>&nbsp</TD>
					</TR>
					<TR HEIGHT=30>
						<TD>&nbsp</TD>
						<TD>&nbsp</TD>
					</TR>
				  </TABLE>

					</TD>
					<TD>

				  <TABLE ALIGN="CENTER" WIDTH="150" BORDER="0" valign="TOP">
				  <TR HEIGHT=30>
						<TD COLSPAN=2 ALIGN="CENTER" class="Estilo22">
							MODALIDAD DEL PAGO
						</TD>
				  </TR>
					<TR valign="TOP">
						<TD ALIGN="LEFT" class="Estilo23">Pie a cancelar:$</TD>
					</TR>
					<TR>
						<TD><input name="pie" type="text" size="10" /></TD>
					</TR>
				  <TR>
					  <TD ALIGN="LEFT" class="Estilo23">Cantidad de cuotas: </TD>
					</TR>
					<TR>
					  <TD>
						  <select name="cuotas" size="1">
							  <option value="-">-</option>
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
				  </TR>
					<TR>
					<TD ALIGN="LEFT" class="Estilo23">Dia de Pago: </TD>
					</TR>
					<TR>
					<TD><input name="TX_DIAPAGO" type="text" value="5" size="3" maxlength="5"></TD>
					</TR>
					<TR>
						<td>&nbsp</TD>
					</TR>
					<TR>
						<TD align="LEFT" class="Estilo22">Total A Convenir: </TD>
					</TR>
					<TR>
						<TD><input name="TX_TOTALCONVENIO" type="text" size="10"></TD>
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
  return (newnumber);
}

	function suma_capital(objeto , intValorSaldoCapital){
		//alert(objeto.checked);

		if (datos.TX_CAPITAL.value == '') datos.TX_CAPITAL.value = 0
		if (datos.TX_HONORARIOS.value == '') datos.TX_HONORARIOS.value = 0
		if (datos.honorarios.value == '') datos.honorarios.value = 0
		if (datos.indemComp.value == '') datos.indemComp.value = 0
		if (datos.capital.value == '') datos.capital.value = 0
		if (datos.gastos.value == '') datos.gastos.value = 0

		if (objeto.checked == true) {
			datos.TX_CAPITAL.value = eval(datos.TX_CAPITAL.value) + eval(intValorSaldoCapital);
			datos.TX_HONORARIOS.value = Math.round(datos.TX_CAPITAL.value * <%=Replace(intPorcHon,",",".")%>) + <%=intAdicHonorarios%>;

			datos.TX_TOTALDEUDA.value = eval(datos.TX_CAPITAL.value) + eval(<%=intTotalCostas%>) + eval(datos.honorarios.value);
			datos.pie.value = eval(<%=intTotGastos%>) + (roundNumber((<%=intPorcPie%> * eval(datos.TX_CAPITAL.value)), 0));

			//alert(0.2 * eval(datos.TX_CAPITAL.value));
			//alert((roundNumber((<%=intPorcPie%> * eval(datos.TX_CAPITAL.value)), 0)));
			//datos.TX_TOTALCONVENIO.value = eval(datos.TX_TOTALDEUDA.value) - eval(<%=intTotIndemComp%>) - eval(<%=intTotHonorarios%>) - eval(datos.pie.value);
			datos.TX_TOTALCONVENIO.value = eval(datos.TX_TOTALDEUDA.value) - eval(<%=intTotIndemComp%>) - eval(datos.TX_HONORARIOS.value) - eval(datos.pie.value);

			//datos.TX_TOTALCONVENIO.value = datos.TX_TOTALCONVENIO.value - eval(datos.honorarios.value) - eval(datos.indemComp.value) - eval(datos.capital.value) - eval(datos.gastos.value);
		}
		else
		{
			datos.TX_CAPITAL.value = eval(datos.TX_CAPITAL.value) - eval(intValorSaldoCapital);
			//datos.TX_HONORARIOS.value = eval(datos.TX_HONORARIOS.value) - eval(intValorHonorarios);
			datos.TX_HONORARIOS.value = Math.round(datos.TX_CAPITAL.value * <%=Replace(intPorcHon,",",".")%>) + <%=intAdicHonorarios%>;
			datos.TX_TOTALDEUDA.value = eval(datos.TX_CAPITAL.value) + eval(<%=intTotalCostas%>);
			//datos.pie.value = eval(<%=intTotGastos%>) + (roundNumber((0.2 * eval(datos.TX_CAPITAL.value)), 0));
			datos.pie.value = eval(<%=intTotGastos%>) + (roundNumber((<%=intPorcPie%> * eval(datos.TX_CAPITAL.value)), 0));
			datos.TX_TOTALCONVENIO.value = eval(datos.TX_TOTALDEUDA.value) - eval(<%=intTotIndemComp%>) - eval(datos.TX_HONORARIOS.value) - eval(datos.pie.value);

			//datos.TX_TOTALCONVENIO.value = datos.TX_TOTALCONVENIO.value - eval(datos.honorarios.value) - eval(datos.indemComp.value) - eval(datos.capital.value) - eval(datos.gastos.value);
		}
	}


	function func_descuentos(objeto){
			//alert(objeto.checked);

			if (datos.TX_CAPITAL.value == '') datos.TX_CAPITAL.value = 0
			if (datos.honorarios.value == '') datos.honorarios.value = 0
			if (datos.indemComp.value == '') datos.indemComp.value = 0
			if (datos.capital.value == '') datos.capital.value = 0
			if (datos.gastos.value == '') datos.gastos.value = 0

			//datos.TX_TOTALCONVENIO.value = datos.TX_TOTALCONVENIO.value - eval(datos.honorarios.value) - eval(datos.indemComp.value) - eval(datos.capital.value) - eval(datos.gastos.value);

			//datos.TX_TOTALCONVENIO.value = eval(datos.TX_TOTALDEUDA.value) - eval(<%=intTotIndemComp%>) - eval(<%=intTotHonorarios%>) - eval(datos.pie.value) - eval(datos.honorarios.value) - eval(datos.indemComp.value) - eval(datos.capital.value) - eval(datos.gastos.value);

			//alert(datos.TX_TOTALCONVENIO.value);

		}


  function validardatos(formulario)
     {
         var enviardatos=true;
       /* if(formulario.total.value < formulario.pie.value){
			alert("Error de ingreso: El pie es mayor al total");
			formulario.reset();
			return false;
		}*/
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


function marcar_boxes(){
		datos.TX_CAPITAL.value = 0;
		datos.TX_HONORARIOS.value = 0;
	 	<% For i=1 TO intTamvConcepto %>
			document.forms[0].<%=vArrConcepto(i)%>.checked=true;
			suma_capital(document.forms[0].<%=vArrConcepto(i)%>,document.forms[0].TX_SALDO_<%=vArrIdCuota(i)%>.value);
		<% Next %>
}

function desmarcar_boxes(){
		<% For i=1 TO intTamvConcepto %>
			document.forms[0].<%=vArrConcepto(i)%>.checked=false;
			suma_capital(document.forms[0].<%=vArrConcepto(i)%>,document.forms[0].TX_SALDO_<%=vArrIdCuota(i)%>.value);
		<% Next %>
		datos.TX_CAPITAL.value = 0;
		datos.TX_HONORARIOS.value = 0;
		datos.pie.value = 0;
		datos.TX_TOTALCONVENIO.value = 0;

}


    </SCRIPT>

</body>
</html>


