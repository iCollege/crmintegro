<% @LCID = 1034 %>
<!--#include file="arch_utils.asp"-->
<!--#include file="../lib/comunes/rutinas/funciones.inc" -->
<!--#include file="sesion.asp"-->
<!--#include file="../lib/comunes/rutinas/TraeCampo.inc" -->
<!--#include file="asp/comunes/general/rutinasSCG.inc" -->
<!--#include file="asp/comunes/general/RutinasVarias.inc" -->
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
	intOrigen=Trim(Request("intOrigen"))

	If Trim(intOrigen)="CO" Then
		strPagina = "generar_convenio.asp"
	Else
		strPagina = "plan_pago_convenio.asp"
	End If


	AbrirSCG()
%>
<html>
<style type="text/css">
<!--
@import url("../css/style1.css");
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
	strSql="SELECT PIE_PORC_CAPITAL, HON_PORC_CAPITAL, IC_PORC_CAPITAL, TASA_MAX_CONV, DESCRIPCION, RAZON_SOCIAL,INTERES_MORA FROM CLIENTE WHERE CODCLIENTE ='" & intCodCliente & "'"
	set rsTasa=Conn.execute(strSql)
	if not rsTasa.eof then
		intTasaMax = ValNulo(rsTasa("TASA_MAX_CONV"),"N")/100
		intPorcPie = ValNulo(rsTasa("PIE_PORC_CAPITAL"),"N")/100
		intPorcHon = ValNulo(rsTasa("HON_PORC_CAPITAL"),"N")/100
		intPorcIc = ValNulo(rsTasa("IC_PORC_CAPITAL"),"N")/100
		strDescripcion = rsTasa("RAZON_SOCIAL")
		strMandante = strDescripcion
		intTasaMensual = ValNulo(rsTasa("INTERES_MORA"),"C")

		If intTasaMensual = "" Then
			%>
				<SCRIPT>alert('No se ha definido tasa de interes de mora, se ocupara una tasa del 2%, favor parametrizar')</SCRIPT>
			<%
			intTasaMensual = "2"
		End If


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
			intTotDeudaCapital = intTotDeudaCapital + Round(session("valor_moneda") * ValNulo(clng(rsDET(7)),"N"),0)

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
		strConDemanda="S"
		intMontoDemandaD=rsDemanda("MONTO")
		intIndemCompensatoriaD=rsDemanda("INDEM_COMPENSATORIA")
		intHonorariosD=rsDemanda("HONORARIOS")
		intInteresesD=rsDemanda("INTERESES")
		intGastosJudicialesD=rsDemanda("GASTOS_JUDICIALES")
		intOtrosD=intHonorariosD
		'Response.write "<BR>intIndemCompensatoriaD=" & intIndemCompensatoriaD

		AbrirSCG1()
			strSql = "SELECT NOMBRE_IC, IC_GO_SC, IC_GO_CC FROM GESTIONES_JUDICIAL_GESTION WHERE CAST(CODCATEGORIA AS VARCHAR(2))+ '-' + CAST(CODSUBCATEGORIA AS VARCHAR(2)) + '-' + CAST(CODGESTION AS VARCHAR(2)) IN ( SELECT TOP 1 CAST(CODCATEGORIA AS VARCHAR(2))+ '-' + CAST(CODSUBCATEGORIA AS VARCHAR(2)) + '-' + CAST(CODGESTION AS VARCHAR(2)) "
			strSql = strSql & " FROM GESTIONES_NUEVAS_JUDICIAL WHERE CODCLIENTE = '" & intCodCliente & "' AND RUTDEUDOR = '" & strRutDeudor & "' ORDER BY IDGESTION DESC )"
			'rESPONSE.WRITE "strSql=" & strSql
			set rsUltGJud= Conn.execute(strSql)
			If Not rsUltGJud.Eof Then
				strNombreIC = rsUltGJud("NOMBRE_IC")
				strICGO_SC = rsUltGJud("IC_GO_SC")
				strICGO_CC = rsUltGJud("IC_GO_CC")
				'Response.write "intMontoDemandaD=" & intMontoDemandaD
				'Response.write "strICGO_SC=" & strICGO_SC
				intIndemCompensatoriaD = intMontoDemandaD * (strICGO_CC / 100)
				intIndemCompensatoriaD = intIndemCompensatoriaD + (intIndemCompensatoriaD * 9/100)
				intIndemCompensatoriaD = Round(intIndemCompensatoriaD,0)
			End If

		CerrarSCG1()


	Else
		%>

		<script>
			//alert('Deudor no posee demanda, no puede ingresar <%=session("NOMBRE_CONV_PAGARE")%>');
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
	intTotalCostas = VALNULO(intTotIndemComp,"N") + VALNULO(intTotGastos,"N")

	cerrarSCG()

	'Response.write "CH_PARAM = " & UCASE(Request("CH_PARAM"))

	'If UCASE(Request("CH_PARAM")) = "ON" Then strCheckParam = "checked"  Else strCheckParam = ""

	%>

<FORM onSubmit="return validardatos(this);" name="datos" method="post" action="<%=strPagina%>">

<TABLE ALIGN="CENTER">
	<TR>
		<TD>

			<table width="800" border="0" id="principal-b">
					<tr>
						<TH>RUT</TH>
						<TH>NOMBRE O RAZON SOCIAL:</TH>
						<TH>USUARIO</TH>
						<TH>FECHA</TH>
						<TH>SEDE</TH>
						<TH>&nbsp;</TH>
					</TR>
					  <tr>
						<td ALIGN="LEFT"><input name="TX_RUT" type="text" size="10" maxlength="10" onChange="Valida_Rut(this.value);Refrescar(this.value)" value="<%=strRutDeudor%>"></TD>
						<TD><%=strNombreDeudor%>
						<INPUT TYPE="hidden" NAME="strRutDeudor" value="<%=strRutDeudor%>">
						<INPUT TYPE="hidden" NAME="intOrigen" value="<%=intOrigen%>">
						</TD>
						<TD ALIGN="LEFT"><%=session("session_login")%></TD>

						<TD><%=DATE%></TD>
						<TD>
							<select name="CB_SEDE">
								<option value="">TODAS</option>
								<%
								AbrirSCG()
									strSql="SELECT * FROM SEDE WHERE CODCLIENTE = '" & intCodCliente & "'"

									set rsSede=Conn.execute(strSql)
									Do While not rsSede.eof
									%>
									<option value="<%=rsSede("SEDE")%>" SELECTED> <%=rsSede("SEDE")%></option>
									<%
									rsSede.movenext
									Loop
									rsSede.close
									set rsSede=nothing
								CerrarSCG()
								%>
							</select>
						</TD>
						<TD>
							<acronym title="BUSCAR RUT">
								<input name="bu_" type="button" onClick="window.location.href = 'simulacion_convenio.asp?TX_RUT=' + TX_RUT.value + '&intOrigen=<%=intOrigen%>'" value="Buscar">


							</acronym>
							<acronym title="LIMPIAR FORMULARIO">
								<input name="li_" type="button" onClick="window.location.href = 'simulacion_convenio.asp?Limpiar=1'" value="Limpiar">


							</acronym>
						</TD>
					  </TR>
			</table>

		</TD>
	</TR>
</TABLE>

<BR>

<TABLE ALIGN="CENTER" id="principal-b">

		<TH colspan=4 align="center"><span class="Estilo28"><span class="Estilo29 Estilo33">
			  RECONOCIMIENTO DE DEUDA Y <%=UCASE(session("NOMBRE_CONV_PAGARE"))%> </span></TH>
		</TR>
		<TR>
			<td colspan=4><div align="center"><b><%=strMandante%></b></div></TD>
		</TR>
		<TR>
			<TD>Nombre :</TD>
			<TD><%=strNombreDeudor%></TD>
			<TD>Rut :</TD>
			<TD><%=strRutDeudor%></TD>
		</TR>
 </TABLE>

<table width="800" id="principal" align="center">
		<tr>
			<TH colspan=10 valign="top" align="left">
				<a href="#" onClick= "marcar_boxes(true);">Marcar todos</a>&nbsp;&nbsp;&nbsp;
				<a href="#" onClick="desmarcar_boxes(true);">Desmarcar todos</a>
			</TH>
	    </tr>


	  <tr>
	    <td valign="top">
		<%
		If Trim(strRutDeudor) <> "" then
		abrirscg()
			strSql="SELECT IDCUOTA, RUTDEUDOR, CUSTODIO, IsNull(FECHAVENC,'01/01/1900') as FECHAVENC, IsNull(datediff(d,fechavenc,getdate()),0) as ANTIGUEDAD, NRODOC,IsNull(VIGENTE,0) as VIGENTE, IsNull(VALORCUOTA,0) as VALORCUOTA,IsNull(SALDO,0) as SALDO,isnull(GASTOSCOBRANZAS,0) as GASTOSCOBRANZAS,IsNull(USUARIO_ASIG,0) as USUARIO_ASIG,NROCUOTA, VIGENTE, IsNull(MORA,0) as MORA, IsNull(VENCIDA,0) as VENCIDA, IsNull(CASTIGO,0) as CASTIGO, CENTRO_COSTO, SUCURSAL , ESTADO_DEUDA, CODREMESA, CUENTA, NRODOC, TIPODOCUMENTO, GASTOSPROTESTOS FROM CUOTA WHERE RUTDEUDOR='"& strRutDeudor &"' AND CODCLIENTE='" & intCodCliente & "' AND SALDO > 0 AND ESTADO_DEUDA = 1 ORDER BY FECHAVENC DESC"
			'response.Write(strSql)
			'response.End()
			set rsDET=Conn.execute(strSql)
			if not rsDET.eof then
			%>
			     <tr>
		          <TH>&nbsp</TH>
		          <TH>NRO. DOC</TH>
		          <TH>F.VENCIM.</TH>
		          <TH>ANTIG.</TH>
		          <TH>TIPO DOC</TH>
		          <TH >ASIG.</TH>
		          <TH ALIGN="CENTER">SALDO</TH>
		          <TH ALIGN="CENTER">INTERES</TH>
		          <TH ALIGN="CENTER">HONORARIOS</TH>
		          <TH ALIGN="CENTER">PROTESTOS</TH>
                </tr>

				<%
				intSaldo = 0
				intValorCuota = 0
				total_ValorCuota = 0
				strArrConcepto = ""
				strArrIdCuota = ""

				intTasaMensual = intTasaMensual/100
				intTasaDiaria = intTasaMensual/30


				Do until rsDET.eof
					strCustodio = ValNulo(rsDET("CUSTODIO"),"C")
					If Trim(strCustodio) <> "" Then
						strCustodio="(C)"
					End If

					intSaldo = Round(session("valor_moneda") * ValNulo(rsDET("SALDO"),"N"),0)
					intProtesto = Round(session("valor_moneda") * ValNulo(rsDET("GASTOSPROTESTOS"),"N"),0)
					intValorCuota = Round(session("valor_moneda") * ValNulo(rsDET("VALORCUOTA"),"N"),0)

					strNroDoc = Trim(rsDET("NRODOC"))
					strNroCuota = Trim(rsDET("NROCUOTA"))
					strSucursal = Trim(rsDET("SUCURSAL"))
					strEstadoDeuda = Trim(rsDET("ESTADO_DEUDA"))
					strCodRemesa = Trim(rsDET("CODREMESA"))

					strArrConcepto = strArrConcepto & ";" & "CH_" & rsDET("IDCUOTA")
					strArrIdCuota = strArrIdCuota & ";" & rsDET("IDCUOTA")

					intAntiguedad = ValNulo(rsDET("ANTIGUEDAD"),"N")

					If intAntiguedad > 0 Then
						intIntereses = intTasaDiaria * intAntiguedad * intSaldo
						intHonorarios = GastosCobranzas(intSaldo)
					Else
						intIntereses = 0
						intHonorarios = 0
					End If


					If Trim(strCustodio)  <> "" Then
						intHonorarios = 0
					End if

					''intTotHonorarios = intTotHonorarios + intHonorarios
					intTotIntereses = intTotIntereses + intIntereses
					intTotProtesto = intTotProtesto + intProtesto





				%>
		        <tr bordercolor="#999999" >
		          <TD><INPUT TYPE=checkbox NAME="CH_<%=rsDET("IDCUOTA")%>" onClick="suma_capital(this,TX_SALDO_<%=rsDET("IDCUOTA")%>.value,<%=Round(intHonorarios,0)%>,<%=Round(intIntereses,0)%>,<%=Round(intProtesto,0)%>);";></TD>
		          <td><div align="LEFT"><%=rsDET("NRODOC")&" "&strCustodio%></div></td>
		          <td><div align="LEFT"><%=rsDET("FECHAVENC")%></div></td>
		          <td><div align="right"><%=rsDET("ANTIGUEDAD")%></div></td>
		          <td><div align="LEFT"><%=rsDET("TIPODOCUMENTO")%></div></td>
		          <td><div align="CENTER"><%=rsDET("CODREMESA")%></div></td>
		          <td align="right"><input name="TX_SALDO_<%=rsDET("IDCUOTA")%>" type="text" value="<%=intSaldo%>" size="10" maxlength="10" align="RIGHT"></td>
		          <td align="right"><%=Round(intIntereses,0)%><INPUT TYPE="hidden" name="HD_INTERES_<%=rsDET("IDCUOTA")%>" value="<%=Round(intIntereses,0)%>"></td>
		          <td align="right"><%=Round(intHonorarios,0)%><INPUT TYPE="hidden" name="HD_HONORARIOS_<%=rsDET("IDCUOTA")%>" value="<%=Round(intHonorarios,0)%>"></td>
		          <td align="right"><%=Round(intProtesto,0)%><INPUT TYPE="hidden" name="HD_PROTESTOS_<%=rsDET("IDCUOTA")%>" value="<%=Round(intProtesto,0)%>"></td>
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


			  <%end if
			  rsDET.close
			  set rsDET=nothing
		  Else
		  %>
			<tr>
			<TH colspan=10 align="center">
				Deudor no posee documentos pendientes
			</td>
			</TH>
		 <%end if%>
	    </td>
	  </tr>

	</table>

	<% If Trim(strConDemanda="S") Then %>

<BR>
	<TABLE ALIGN="CENTER" id="principal-b">

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
	<%End If%>
<BR>

<INPUT TYPE="hidden" NAME="hdintCapital" value="<%=intTotDeudaCapital%>">
<INPUT TYPE="hidden" NAME="hdintIndemComp" value="<%=intTotIndemComp%>">
<INPUT TYPE="hidden" NAME="hdintGastos" value="<%=intTotGastos%>">
<INPUT TYPE="hidden" NAME="hdintHonorarios" value="<%=intTotHonorarios%>">
<INPUT TYPE="hidden" NAME="strNombreIC" value="<%=strNombreIC%>">



<TABLE ALIGN="CENTER" id="principal-b" BORDER="1">
			<TR>
					<TD valign="TOP" WIDTH="30%" >
						<TABLE ALIGN="CENTER" WIDTH="100%" BORDER="0">
							<TR HEIGHT=30>
								<TH COLSPAN=2 ALIGN="CENTER" class="Estilo22">
									MONTO DE DEUDA
								</TH>
							</TR>
							<TR HEIGHT=30>
								<TD ALIGN="RIGHT" class="Estilo22">Capital: </TD>
								<TD><input name="TX_CAPITAL" type="text" size="10" onChange="func_actualiza_total_deuda();"></TD>
							</TR>
							<TR HEIGHT=30>
								<TD ALIGN="RIGHT" class="Estilo22">Interes: </TD>
								<TD><input name="TX_INTERES" type="text" size="10" onChange="func_actualiza_total_deuda();"></TD>
							</TR>
							<TR HEIGHT=30>
								<TD align="right" class="Estilo22">Gastos Judiciales: </TD>
								<TD><input name="TX_GASTOS" type="text" size="10" value="<%=intTotGastos%>" onChange="func_actualiza_total_deuda();"></TD>
							</TR>
							<TR HEIGHT=30>
								<TD align="right" class="Estilo22">Gastos Protestos: </TD>
								<TD><input name="TX_GASTOSPROTESTOS" type="text" size="10" onChange="func_actualiza_total_deuda();"></TD>
							</TR>
							<TR HEIGHT=30>
								<TD align="right" class="Estilo22">I.Comp./G.Ope: </TD>
								<TD><input name="TX_INDEM_COMP" type="text" size="10" value="<%=intTotIndemComp%>" onChange="func_actualiza_total_deuda();"></TD>
							</TR>

							<TR HEIGHT=30>
								<TD align="right" class="Estilo22">Honorarios : </TD>
								<!--TD align="right"><strong><span class=Estilo1><strong>$ <%=FN(intTotHonorarios,0)%></strong></span></strong></TD-->
								<TD><input name="TX_HONORARIOS" type="text" size="10" value="<%=intTotHonorarios%>" onChange="func_actualiza_total_deuda();"></TD>
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

					<TD valign="TOP" WIDTH="35%" >

						<TABLE ALIGN="CENTER" WIDTH="100%" BORDER="0">
						  <TR HEIGHT=30>
							<TH COLSPAN=2 ALIGN="CENTER" class="Estilo22">
								DESCUENTOS
							</TH>

						  </TR>
						  <TR HEIGHT=30>
							  <TD ALIGN="RIGHT" class="Estilo23">Capital:</TD>
							  <TD>
									%<input name="porc_desc_capital" type="text" size="2" onChange="func_porc_desc_capital();">
									$<input name="desc_capital" type="text" size="8" onChange="func_descuentos(this.value);">
							  </TD>
						  </TR>
						  <TR HEIGHT=30>
							  <TD ALIGN="RIGHT" class="Estilo23">Interes:</TD>
							  <TD>
									%<input name="porc_desc_interes" type="text" size="2" onChange="func_porc_desc_interes();">
									$<input name="desc_interes" type="text" size="8" onChange="func_descuentos();">
							  </TD>
						  </TR>
						  <TR HEIGHT=30>
								<TD ALIGN="RIGHT" class="Estilo23">Gastos Judiciales:</TD>
								<TD>
									%<input DISABLED name="porc_desc_gastos" type="text" size="2" onChange="func_porc_desc_gastos();">
									$<input DISABLED name="desc_gastos" type="text" size="8" onChange="func_descuentos(this.value);">
								</TD>
						  </TR>
						   <TR HEIGHT=30>
								<TD ALIGN="RIGHT" class="Estilo23">Gastos Protestos:</TD>
								<TD>
									%<input DISABLED name="porc_desc_gastosprotestos" type="text" size="2" onChange="func_porc_gastosprotestos();">
									$<input DISABLED name="gastosprotestos" type="text" size="8" onChange="func_descuentos(this.value);"></TD>
						  </TR>

						 <TR HEIGHT=30>
								<TD ALIGN="RIGHT" class="Estilo23">I.Comp/G.Op. :</TD>
								<TD>
									%<input DISABLED name="porc_desc_indemComp" type="text" size="2" onChange="func_porc_indemComp();">
									$<input DISABLED name="desc_indemComp" type="text" size="8" onChange="func_descuentos(this.value);">
								</TD>
						  </TR>

						  <TR HEIGHT=30>
							<td  align="right" class="Estilo23"> Honorarios:</TD>
							<TD>
								%<input name="porc_desc_honorarios" type="text" size="2" onChange="func_porc_desc_honorarios();">
								$<input name="desc_honorarios" type="text" size="10" onChange="func_descuentos(this.value);">
							</TD>
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
					<TD valign="TOP" WIDTH="32%" >

					  <TABLE ALIGN="CENTER" BORDER="0" WIDTH="100%" valign="TOP">
					  <TR HEIGHT=30>
							<TH COLSPAN=2 ALIGN="CENTER" class="Estilo22">
								MODALIDAD DEL PAGO
							</TH>
					  </TR>
						<TR valign="TOP">
							<TD ALIGN="LEFT" class="Estilo23">
							Pie a cancelar:$
							</TD>
						</TR>
						<TR valign="TOP">
							<TD ALIGN="LEFT" class="Estilo23">

							% Capital&nbsp;<input name="porc_capital_pie" type="text" size="2" value="<%=intPorcPie*100%>" onChange="func_porc_capital_pie();">
							$<input name="pie" type="text" size="10" onChange="func_descuentos(this.value);"></TD>
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
<BR>
<BR>
 <TABLE ALIGN="CENTER" WIDTH="800" BORDER="0">
 		<TR>
 			<TD>
  				  <input type="submit" name="Submit" value="Ver <%=session("NOMBRE_CONV_PAGARE")%>">
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

	function suma_capital(objeto , intValorSaldoCapital, intValorHonorarios, intValorIntereses, intValorProtestos){
		//alert(objeto.checked);

		if (datos.TX_CAPITAL.value == '') datos.TX_CAPITAL.value = 0
		if (datos.TX_HONORARIOS.value == '') datos.TX_HONORARIOS.value = 0
		if (datos.TX_INTERES.value == '') datos.TX_INTERES.value = 0
		if (datos.TX_GASTOSPROTESTOS.value == '') datos.TX_GASTOSPROTESTOS.value = 0
		if (datos.desc_honorarios.value == '') datos.desc_honorarios.value = 0
		if (datos.desc_indemComp.value == '') datos.desc_indemComp.value = 0
		if (datos.desc_capital.value == '') datos.desc_capital.value = 0
		if (datos.desc_gastos.value == '') datos.desc_gastos.value = 0
		if (datos.desc_interes.value == '') datos.desc_interes.value = 0


		if (objeto.checked == true) {
			datos.TX_CAPITAL.value = eval(datos.TX_CAPITAL.value) + eval(intValorSaldoCapital);
			//datos.TX_HONORARIOS.value = eval(datos.TX_HONORARIOS.value) + eval(intValorHonorarios);
			datos.TX_INTERES.value = eval(datos.TX_INTERES.value) + eval(intValorIntereses);
			datos.TX_GASTOSPROTESTOS.value = eval(datos.TX_GASTOSPROTESTOS.value) + eval(intValorProtestos);
			datos.TX_TOTALDEUDA.value = eval(datos.TX_CAPITAL.value) + eval(datos.TX_HONORARIOS.value) + eval(datos.TX_INTERES.value) + eval(datos.TX_GASTOSPROTESTOS.value) + eval(datos.TX_INDEM_COMP.value);
			datos.pie.value = (roundNumber((<%=intPorcPie%> * eval(datos.TX_CAPITAL.value)), 0)) + eval(datos.TX_HONORARIOS.value) + eval(datos.TX_INDEM_COMP.value) + eval(datos.TX_GASTOS.value);
			datos.TX_TOTALCONVENIO.value = eval(datos.TX_TOTALDEUDA.value) - eval(datos.pie.value) - eval(datos.desc_gastos.value) - eval(datos.desc_capital.value) - eval(datos.desc_interes.value) - eval(datos.desc_honorarios.value);

		}
		else
		{
			datos.TX_CAPITAL.value = eval(datos.TX_CAPITAL.value) - eval(intValorSaldoCapital);
			//datos.TX_HONORARIOS.value = eval(datos.TX_HONORARIOS.value) - eval(intValorHonorarios);
			datos.TX_INTERES.value = eval(datos.TX_INTERES.value) - eval(intValorIntereses);
			datos.TX_GASTOSPROTESTOS.value = eval(datos.TX_GASTOSPROTESTOS.value) - eval(intValorProtestos);
			datos.TX_TOTALDEUDA.value = eval(datos.TX_CAPITAL.value) + eval(datos.TX_HONORARIOS.value) + eval(datos.TX_INTERES.value) + eval(datos.TX_GASTOSPROTESTOS.value) + eval(datos.TX_INDEM_COMP.value);
			//datos.pie.value = eval(datos.TX_HONORARIOS.value) + eval(datos.TX_INTERES.value) + (roundNumber((<%=intPorcPie%> * eval(datos.TX_CAPITAL.value)), 0));
			datos.pie.value = (roundNumber((<%=intPorcPie%> * eval(datos.TX_TOTALDEUDA.value)), 0))  + eval(datos.TX_HONORARIOS.value) + eval(datos.TX_INDEM_COMP.value) + eval(datos.TX_GASTOS.value);
			datos.TX_TOTALCONVENIO.value = eval(datos.TX_TOTALDEUDA.value) - eval(datos.pie.value) - eval(datos.desc_gastos.value) - eval(datos.desc_capital.value) - eval(datos.desc_interes.value) - eval(datos.desc_honorarios.value);

		}
	}


	function func_descuentos(objeto){
		if (datos.TX_CAPITAL.value == '') datos.TX_CAPITAL.value = 0;
		if (datos.desc_honorarios.value == '') datos.desc_honorarios.value = 0;
		if (datos.desc_indemComp.value == '') datos.desc_indemComp.value = 0;
		if (datos.desc_capital.value == '') datos.desc_capital.value = 0;
		if (datos.desc_gastos.value == '') datos.desc_gastos.value = 0;
		datos.TX_TOTALCONVENIO.value = eval(datos.TX_TOTALDEUDA.value) - eval(datos.pie.value) - eval(datos.desc_gastos.value) - eval(datos.desc_capital.value) - eval(datos.desc_interes.value) - eval(datos.desc_honorarios.value);

	}

	function func_porc_desc_capital(){
		if (datos.desc_capital.value == '') datos.desc_capital.value = 0;
		if (datos.porc_desc_capital.value == '') datos.porc_desc_capital.value = 0;
		datos.desc_capital.value = eval(datos.TX_CAPITAL.value) * eval(datos.porc_desc_capital.value) / 100;
		datos.desc_capital.value = Math.round(datos.desc_capital.value);
		datos.TX_TOTALCONVENIO.value = eval(datos.TX_TOTALDEUDA.value) - eval(datos.pie.value) - eval(datos.desc_gastos.value) - eval(datos.desc_capital.value) - eval(datos.desc_interes.value) - eval(datos.desc_honorarios.value);
	}

	function func_porc_desc_interes(){
		if (datos.desc_interes.value == '') datos.desc_interes.value = 0;
		if (datos.porc_desc_interes.value == '') datos.porc_desc_interes.value = 0;
		datos.desc_interes.value = eval(datos.TX_INTERES.value) * eval(datos.porc_desc_interes.value) / 100
		datos.desc_interes.value = Math.round(datos.desc_interes.value)
		datos.TX_TOTALCONVENIO.value = eval(datos.TX_TOTALDEUDA.value) - eval(datos.pie.value) - eval(datos.desc_gastos.value) - eval(datos.desc_capital.value) - eval(datos.desc_interes.value) - eval(datos.desc_honorarios.value);
	}

	function func_porc_desc_honorarios(){
		if (datos.desc_honorarios.value == '') datos.desc_honorarios.value = 0;
		if (datos.porc_desc_honorarios.value == '') datos.porc_desc_honorarios.value = 0;
		datos.desc_honorarios.value = eval(datos.TX_HONORARIOS.value) * eval(datos.porc_desc_honorarios.value) / 100;
		datos.desc_honorarios.value = Math.round(datos.desc_honorarios.value);
		datos.TX_TOTALCONVENIO.value = eval(datos.TX_TOTALDEUDA.value) - eval(datos.pie.value) - eval(datos.desc_gastos.value) - eval(datos.desc_capital.value) - eval(datos.desc_interes.value) - eval(datos.desc_honorarios.value);

	}

	function func_porc_capital_pie(){
		if (datos.pie.value == '') datos.pie.value = 0;
		if (datos.porc_capital_pie.value == '') datos.porc_capital_pie.value = 0;
		//datos.pie.value = (eval(datos.porc_capital_pie.value) * eval(datos.TX_TOTALDEUDA.value))/ 100;
		datos.pie.value = (roundNumber((<%=intPorcPie%> * eval(datos.TX_CAPITAL.value)), 0)) + eval(datos.TX_HONORARIOS.value) + eval(datos.TX_INDEM_COMP.value) + eval(datos.TX_GASTOS.value);
		//datos.pie.value = eval(datos.pie.value) * eval(datos.porc_capital_pie.value) / 100;
		datos.pie.value = Math.round(datos.pie.value);
		datos.TX_TOTALCONVENIO.value = eval(datos.TX_TOTALDEUDA.value) - eval(datos.pie.value) - eval(datos.desc_gastos.value) - eval(datos.desc_capital.value) - eval(datos.desc_interes.value) - eval(datos.desc_honorarios.value);

	}

	function func_actualiza_total_deuda() {
		datos.TX_TOTALDEUDA.value = eval(datos.TX_CAPITAL.value) + eval(datos.TX_HONORARIOS.value) + eval(datos.TX_INTERES.value) + eval(datos.TX_GASTOSPROTESTOS.value) + eval(datos.TX_INDEM_COMP.value) + eval(datos.TX_GASTOS.value);
		datos.pie.value = (roundNumber((<%=intPorcPie%> * eval(datos.TX_TOTALDEUDA.value)), 0));
		datos.TX_TOTALCONVENIO.value = eval(datos.TX_TOTALDEUDA.value) - eval(datos.pie.value) - eval(datos.desc_gastos.value) - eval(datos.desc_capital.value) - eval(datos.desc_interes.value) - eval(datos.desc_honorarios.value) - eval(datos.desc_indemComp.value);
	}


  function validardatos(formulario)
     {
         var enviardatos=true;
       /* if(formulario.total.value < formulario.pie.value){
			alert("Error de ingreso: El pie es mayor al total");
			formulario.reset();
			return false;
		}*/
		  if(formulario.CB_SEDE.value==""){
			alert("Debe seleccionar una Sede");
			return false;
		  }
		  if(formulario.pie.value==""){
		  	alert("Error de ingreso: Debe Ingresar el pie");
			return false;
		  }
		  if(formulario.desc_capital.value=='-' || formulario.desc_indemComp.value=='-' || formulario.desc_honorarios.value=='-'){
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
		//datos.TX_HONORARIOS.value = 0;
	 	<% For i=1 TO intTamvConcepto %>
			document.forms[0].<%=vArrConcepto(i)%>.checked=true;
			suma_capital(document.forms[0].<%=vArrConcepto(i)%>,document.forms[0].TX_SALDO_<%=vArrIdCuota(i)%>.value,document.forms[0].HD_HONORARIOS_<%=vArrIdCuota(i)%>.value,document.forms[0].HD_INTERES_<%=vArrIdCuota(i)%>.value,document.forms[0].HD_PROTESTOS_<%=vArrIdCuota(i)%>.value);
		<% Next %>
}

function desmarcar_boxes(){
		<% For i=1 TO intTamvConcepto %>
			document.forms[0].<%=vArrConcepto(i)%>.checked=false;
			suma_capital(document.forms[0].<%=vArrConcepto(i)%>,document.forms[0].TX_SALDO_<%=vArrIdCuota(i)%>.value,document.forms[0].HD_HONORARIOS_<%=vArrIdCuota(i)%>.value,document.forms[0].HD_INTERES_<%=vArrIdCuota(i)%>.value,document.forms[0].HD_PROTESTOS_<%=vArrIdCuota(i)%>.value);
		<% Next %>
		datos.TX_CAPITAL.value = 0;
		//datos.TX_HONORARIOS.value = 0;
		datos.pie.value = 0;
		datos.TX_TOTALCONVENIO.value = 0;

}

    </SCRIPT>

</body>
</html>


