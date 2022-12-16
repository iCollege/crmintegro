<% @LCID = 1034 %>
<!--#include file="../sesion.asp"-->
<!--#include file="../arch_utils.asp"-->
<!--#include file="../../lib/comunes/rutinas/funciones.inc" -->
<!--#include file="../../lib/comunes/rutinas/TraeCampo.inc" -->
<!--#include file="../asp/comunes/general/rutinasSCG.inc" -->
<!--#include file="../asp/comunes/general/RutinasVarias.inc" -->

<script language="JavaScript" src="../../lib/cal2.js"></script>
<script language="JavaScript" src="../../lib/cal_conf2.js"></script>
<script language="JavaScript" src="../../lib/validaciones.js"></script>
<link href="style.css" rel="stylesheet" type="text/css">

<%
	If Trim(Request("Limpiar"))="1" Then
		session("session_rutdeudor") = ""
		rut = ""
	End if

	rut = request("rut")

	if trim(rut) <> "" Then
		session("session_rutdeudor") = rut
	Else
		rut = session("session_rutdeudor")
	End if

	strRutDeudor=rut

	intSeq = request("intSeq")
	strGraba = request("strGraba")
	txt_FechaIni = request("txt_FechaIni")
	intSucursal="1"
	fecha= date
	strCodCliente = request("CB_CLIENTE")
	strCodCliente = session("ses_codcli")

	usuario=session("session_idusuario")

	AbrirSCG()

	strDocCancelados = request("TX_DOCCANCELADOS")
	strObservaciones = request("TX_OBSERVACIONES")
	strObservaciones = Trim(strObservaciones)


	If Trim(request("strGraba")) = "SI" Then

		intInteres = Request("TX_INTERES")
		intHonorarios = Request("TX_HONORARIOS")
		intProtestos = Request("TX_PROTESTOS")

		strSql = "SELECT NRODOC, SALDO, CUENTA, FECHAVENC FROM CUOTA WHERE RUTDEUDOR='" & rut & "' AND CODCLIENTE='" & strCodCliente & "' AND SALDO > 0"
		set rsTemp= Conn.execute(strSql)
		Do until rsTemp.eof
			strObjeto = "CH_" & Replace(Trim(rsTemp("NRODOC")),"-","_")
			strObjeto2 = "TX_COMPROBANTE_" & Replace(Trim(rsTemp("NRODOC")),"-","_")
			If UCASE(Request(strObjeto)) = "ON" Then

				strComprobante = Request(strObjeto2)
				If Trim(strComprobante) = "" Then
				%>
				<SCRIPT>
					alert('Debe Ingresar Comprobante para todos los documentos seleccionados');
					history.back();
				</SCRIPT>
				<%
					Response.End
				End If
			End if
		rsTemp.movenext
		intCorrelativo = intCorrelativo + 1
		loop
		rsTemp.close
		set rsTemp=nothing



		strSql = "SELECT IDCUOTA, NRODOC, SALDO, CUENTA, FECHAVENC FROM CUOTA WHERE RUTDEUDOR='" & rut & "' AND CODCLIENTE='" & strCodCliente & "' AND SALDO > 0"
		set rsTemp= Conn.execute(strSql)

		intCorrelativo = 1
		intTotalCapital = 0
		strGestionPago=""
		strGestionAbono=""

		Do until rsTemp.eof
			strObjeto = "CH_" & Replace(Trim(rsTemp("IDCUOTA")),"-","_")
			strObjeto1 = "TX_SALDO_" & Replace(Trim(rsTemp("IDCUOTA")),"-","_")
			strObjeto2 = "TX_COMPROBANTE_" & Replace(Trim(rsTemp("IDCUOTA")),"-","_")


			If UCASE(Request(strObjeto)) = "ON" Then

				intSaldoCapital = rsTemp("SALDO")
				intSaldo = Request(strObjeto1)
				strComprobante = Request(strObjeto2)
				strNroDoc = rsTemp("NRODOC")
				intIdCuota = rsTemp("IDCUOTA")
				strCuenta = rsTemp("CUENTA")
				strFechaVenc = rsTemp("FECHAVENC")


				''Response.write "<br>Caso = " & (Cdbl(intSaldo) >= Cdbl(intSaldoCapital))

				If (Cdbl(intSaldo) >= Cdbl(intSaldoCapital)) Then
					strGestionPago="P"
					strObservacion2 = "PAGO EN CLIENTE REALIZADO POR " & session("nombre_user")
					'strSql = "UPDATE CUOTA SET SALDO = SALDO - " & intSaldo & ", ESTADO_DEUDA = '3', FECHA_ESTADO = GETDATE() , ADIC92 = '" & strComprobante & "', OBSERVACION = '" & strObservacion2 & "' WHERE RUTDEUDOR = '" & rut & "' AND CODCLIENTE = '" & strCodCliente & "' AND NRODOC = '" & strNroDoc & "'"
					strSql = "UPDATE CUOTA SET SALDO = SALDO - " & intSaldo & ", ESTADO_DEUDA = '3', FECHA_ESTADO = GETDATE() , ADIC92 = '" & strComprobante & "', OBSERVACION = '" & strObservacion2 & "' WHERE IDCUOTA = " & intIdCuota
					intTotalCapital = intTotalCapital + intSaldo
					strDocumentos = strDocumentos & ","& strNroDoc

				Else
					strGestionAbono="A"
					strObservacion2 = "ABONO EN CLIENTE REALIZADO POR " & session("nombre_user")
					'strSql = "UPDATE CUOTA SET SALDO = SALDO - " & intSaldo & ", ESTADO_DEUDA = '7', FECHA_ESTADO = GETDATE() , ADIC92 = '" & strComprobante & "', OBSERVACION = '" & strObservacion2 & "' WHERE RUTDEUDOR = '" & rut & "' AND CODCLIENTE = '" & strCodCliente & "' AND NRODOC = '" & strNroDoc & "'"
					strSql = "UPDATE CUOTA SET SALDO = SALDO - " & intSaldo & ", ESTADO_DEUDA = '7', FECHA_ESTADO = GETDATE() , ADIC92 = '" & strComprobante & "', OBSERVACION = '" & strObservacion2 & "' WHERE IDCUOTA = " & intIdCuota
					intTotalCapitalA = intTotalCapitalA + intSaldo
					strDocumentosA = strDocumentosA & ","& strNroDoc

				End If


				'Response.write "<br>strGestionAbono=" & strGestionAbono
				'Response.write "<br>" & strSql
				'Response.End
				set rsUpdate=Conn.execute(strSql)

			End if
		rsTemp.movenext
		intCorrelativo = intCorrelativo + 1
		loop
		rsTemp.close
		set rsTemp=nothing








		If Trim(strGestionPago) = "P" or Trim(strGestionAbono) = "A" Then


			strDocumentos = Mid(strDocumentos,2,len(strDocumentos))
			strDocumentosA = Mid(strDocumentosA,2,len(strDocumentosA))



			strSql="SELECT ISNULL(IDCAMPANA,0) as IDCAMPANA FROM DEUDOR WHERE RUTDEUDOR='" & rut & "' AND CODCLIENTE='" & strCodCliente & "'"
			set rsDeudor = Conn.execute(strSql)
			if not rsDeudor.eof then
				intIdCampana=rsDeudor("IDCAMPANA")
			else
				intIdCampana=0
			end if
			rsDeudor.close
			set rsDeudor=nothing

			if Trim(reagen) <> "" and Trim(reagen) <> "NULL" then
				reagen = "'" + reagen + "'"
			else
				reagen="NULL"
			end if

			if Trim(retiro) <> "" then
				retiro="'" + retiro + "'"
			else
				retiro="NULL"
			end if

			if Trim(fechacompromiso) <> "" and Trim(fechacompromiso) <> "NULL" then
				fechacompromiso= "'" & fechacompromiso & "'"
			else
				fechacompromiso="NULL"
			end if

			if Trim(fechacancelo) <> "" and Trim(fechacancelo) <> "NULL" then
				fechacancelo= "'" & fechacancelo & "'"
			else
				fechacancelo="NULL"
			end if

			correlativo2 = 1






			If Trim(strGestionPago) = "P" Then
				categoria = 1
				subcategoria = 1
				gestion = 3

				strObservacionesGestion = "CAPITAL PAGADO : " & intTotalCapital & ", INTERES : " & intInteres & ", HONORARIOS : " & intHonorarios & ", PROTESTOS : " & intProtestos
				strObservacionesGestion = strObservacionesGestion & " DOCUMENTOS : " & strDocumentos & " OBS : " & strObservaciones


				ssql2="SELECT MAX(Correlativo)+1 AS CORRELATIVO FROM GESTIONES WHERE RUTDEUDOR='" & rut & "' AND CODCLIENTE='"& strCodCliente &"'"
				set rsCOR = Conn.execute(ssql2)
				if not rsCOR.eof then
					correlativo=rsCOR("CORRELATIVO")
					if isNULL(rsCOR("CORRELATIVO")) THEN
						correlativo= "1"
					end if
				else
					correlativo= "1"
				end if
				rsCOR.close
				set rsCOR=nothing

				strSql="INSERT INTO GESTIONES ( RUTDEUDOR,CODCLIENTE,NRODOC,CORRELATIVO,CODCATEGORIA,CODSUBCATEGORIA,CODGESTION,FECHAINGRESO,HORAINGRESO,IDUSUARIO,FECHACOMPROMISO,NRODOCPAGO,FECHAPAGO,OBSERVACIONES,CORRELATIVODATO,TELEFONO_ASOCIADO,DIRECCION_ASOCIADA,FECHA_RETIRO,FECHA_AGENDAMIENTO,IDCAMPANA)"
				strSql= strSql & " VALUES ('"& rut & "','"& strCodCliente &"','1','" & correlativo &"','"& categoria &"','"& subcategoria &"','"& gestion &"','" & date & "','"& Mid(time,1,8) &"',"& session("session_idusuario") & "," & fechacompromiso & ",'" & comprobante & "'," & fechacancelo & ",'" & UCASE(strObservacionesGestion) & "','" & Trim(correlativo2) &"','"& telges & "','" & dirges & "'," & retiro & "," & reagen & "," & intIdCampana & ")"

				'Response.write "<br>strSql = " & strSql
				Conn.execute(strSql)


				strSql = "UPDATE DEUDOR SET ULTIMA_GESTION = '" & categoria &"-"& subcategoria & "-" & gestion & "'"
				strSql = strSql & " WHERE RUTDEUDOR = '" & rut & "' AND CODCLIENTE = '" & strCodCliente & "'"
				'Response.write "<br>strSql = " & strSql
				'REsponse.End
				Conn.execute(strSql)




			End If

			If Trim(strGestionAbono) = "A" Then
				categoria = 1
				subcategoria = 1
				gestion = 4

				strObservacionesGestion = "CAPITAL PAGADO : " & intTotalCapitalA & ", INTERES : " & intInteres & ", HONORARIOS : " & intHonorarios & ", PROTESTOS : " & intProtestos
				strObservacionesGestion = strObservacionesGestion & " DOCUMENTOS : " & strDocumentosA & " OBS : " & strObservaciones


				ssql2="SELECT MAX(Correlativo)+1 AS CORRELATIVO FROM GESTIONES WHERE RUTDEUDOR='" & rut & "' AND CODCLIENTE='"& strCodCliente &"'"
				set rsCOR = Conn.execute(ssql2)
				if not rsCOR.eof then
					correlativo=rsCOR("CORRELATIVO")
					if isNULL(rsCOR("CORRELATIVO")) THEN
						correlativo= "1"
					end if
				else
					correlativo= "1"
				end if
				rsCOR.close
				set rsCOR=nothing

				strSql="INSERT INTO GESTIONES ( RUTDEUDOR,CODCLIENTE,NRODOC,CORRELATIVO,CODCATEGORIA,CODSUBCATEGORIA,CODGESTION,FECHAINGRESO,HORAINGRESO,IDUSUARIO,FECHACOMPROMISO,NRODOCPAGO,FECHAPAGO,OBSERVACIONES,CORRELATIVODATO,TELEFONO_ASOCIADO,DIRECCION_ASOCIADA,FECHA_RETIRO,FECHA_AGENDAMIENTO,IDCAMPANA)"
				strSql= strSql & " VALUES ('"& rut & "','"& strCodCliente &"','1','" & correlativo &"','"& categoria &"','"& subcategoria &"','"& gestion &"','" & date & "','"& Mid(time,1,8) &"',"& session("session_idusuario") & "," & fechacompromiso & ",'" & comprobante & "'," & fechacancelo & ",'" & UCASE(strObservacionesGestion) & "','" & Trim(correlativo2) &"','"& telges & "','" & dirges & "'," & retiro & "," & reagen & "," & intIdCampana & ")"

				'Response.write "<br>strSql = " & strSql
				Conn.execute(strSql)


				strSql = "UPDATE DEUDOR SET ULTIMA_GESTION = '" & categoria &"-"& subcategoria & "-" & gestion & "'"
				strSql = strSql & " WHERE RUTDEUDOR = '" & rut & "' AND CODCLIENTE = '" & strCodCliente & "'"
				'Response.write "<br>strSql = " & strSql
				'REsponse.End
				Conn.execute(strSql)


			End If




		End If

	End If

%>
<title>Empresa</title>
<style type="text/css">
<!--
.Estilo13 {color: #FFFFFF}
.Estilo27 {color: #FFFFFF}
.Estilo1 {
	color: #FF0000;
	font-weight: bold;
	font-family: Arial, Helvetica, sans-serif;
-->
</style>

<script language="JavaScript " type="text/JavaScript">

function Refrescar(rut)
{
	if(rut == '')
	{
		return
	}
			datos.action = "ingreso_pagos.asp?rut=" + rut + "&tipo=1";
			datos.submit();

}

</script>


<link href="style.css" rel="Stylesheet">

<form name="datos" method="post">
<table width="840" border="1" bordercolor="#999999" cellpadding="2" cellspacing="5">
	<tr>
		<td height="20"  bordercolor="#999999"  bgcolor="#<%=session("COLTABBG")%>" class="Estilo27" align="center"><strong>Módulo de Ingreso de Pagos</strong></td>
	</tr>
  <tr>
    <td valign="top">
	  <%

	If rut <> "" then
		strNombreDeudor = TraeNombreDeudor(Conn,strRutDeudor)
	Else
		strNombreDeudor=""
	End if


	strSql="SELECT IsNull(ADIC1,'ADIC1') as ADIC1, IsNull(ADIC2,'ADIC2') as ADIC2, IsNull(ADIC3,'ADIC3') as ADIC3, IsNull(ADIC4,'ADIC4') as ADIC4, IsNull(ADIC5,'ADIC5') as ADIC5, IsNull(ADIC91,'ADIC91') as ADIC91, IsNull(ADIC92,'ADIC92') as ADIC92, IsNull(ADIC93,'ADIC93') as ADIC93, IsNull(ADIC94,'ADIC94') as ADIC94, IsNull(ADIC95,'ADIC95') as ADIC95, USA_CUSTODIO, IsNull(COLOR_CUSTODIO,'FFFFFF') as COLOR_CUSTODIO, INTERES_MORA FROM CLIENTE WHERE CODCLIENTE = '" & strCodCliente & "'"
	set rsDET=Conn.execute(strSql)
	if Not rsDET.eof Then
		strUsaCustodio = rsDET("USA_CUSTODIO")
		intTasaMensual = ValNulo(rsDET("INTERES_MORA"),"C")
	end if
	If intTasaMensual = "" Then
		%>
		<SCRIPT>alert('No se ha definido tasa de interes de mora, se ocupara una tasa del 2%, favor parametrizar')</SCRIPT>
		<%
		intTasaMensual = "2"
	End If

	%>

	<table width="840" border="0" bordercolor="#FFFFFF">
		<tr bordercolor="#999999"  bgcolor="#<%=session("COLTABBG")%>" class="Estilo13">
			<td>MANDANTE</td>
			<td>RUT</td>
			<td>NOMBRE O RAZON SOCIAL:</td>
			<td>USUARIO</td>
			<td>SUCURSAL</td>
			<td>FECHA</td>
			<td>&nbsp;</td>
		</tr>
	      <tr bgcolor="#FFFFFF" class="Estilo8">
	      <td>
	      	<select name="CB_CLIENTE">
				<%
					ssql="SELECT CODCLIENTE,RAZON_SOCIAL FROM CLIENTE WHERE CODCLIENTE = '" & strCodCliente & "' ORDER BY RAZON_SOCIAL"
					set rsTemp= Conn.execute(ssql)
					if not rsTemp.eof then
						do until rsTemp.eof%>
						<option value="<%=rsTemp("CODCLIENTE")%>"<%if Trim(strCodCliente)=rsTemp("CODCLIENTE") then response.Write("Selected") End If%>><%=rsTemp("RAZON_SOCIAL")%></option>
						<%
						rsTemp.movenext
						loop
					end if
					rsTemp.close
					set rsTemp=nothing
				%>
			</select>
			</td>

			<td ALIGN="LEFT"><input name="TX_RUT" type="text" size="10" maxlength="10" onChange="Refrescar(this.value)" value="<%=rut%>"></td>
			<td><%=strNombreDeudor%><INPUT TYPE="hidden" NAME="rut" value="<%=rut%>"> </td>
	        <td ALIGN="RIGHT"><%=session("nombre_user")	%></td>

	        <td><%=nom_sucursal%></td>
	        <td><%=DATE%></td>
	        <td>
				<acronym title="LIMPIAR FORMULARIO">
					<input name="li_" type="button" onClick="window.navigate('ingreso_pagos.asp?Limpiar=1');" value="Limpiar">
				</acronym>
			</td>
	      </tr>
    </table>
	</td>
	</tr>
</table>



<table width="840" border="1" bordercolor="#999999" cellpadding="2" cellspacing="5">
		<tr>
	<td>
	</td>
	</tr>

	<tr>
	<td>

	<table width="840" border="0" ALIGN="CENTER">
	 <tr>
	 	<td  bordercolor="#999999"  bgcolor="#<%=session("COLTABBG")%>">
	 	<font class="Estilo27"><strong>&nbsp;Detalle de Deuda</strong></font>
	 	</td>
	</tr>
	</table>

	<table width="840" border="0" ALIGN="CENTER">
	  <tr>
	    <td valign="top">
		<%
		If Trim(rut) <> "" then
		abrirscg()
			strSql="SELECT IDCUOTA, RUTDEUDOR, IsNull(FECHAVENC,'01/01/1900') as FECHAVENC, IsNull(datediff(d,fechavenc,getdate()),0) as ANTIGUEDAD, NRODOC,IsNull(VIGENTE,0) as VIGENTE, IsNull(VALORCUOTA,0) as VALORCUOTA,IsNull(SALDO,0) as SALDO,isnull(GASTOSPROTESTOS,0) as GASTOSPROTESTOS,IsNull(USUARIO_ASIG,0) as USUARIO_ASIG,NROCUOTA, VIGENTE, IsNull(MORA,0) as MORA, IsNull(VENCIDA,0) as VENCIDA, IsNull(CASTIGO,0) as CASTIGO, CENTRO_COSTO, SUCURSAL , ESTADO_DEUDA, CODREMESA, CUENTA, NRODOC, TIPODOCUMENTO FROM CUOTA WHERE RUTDEUDOR='"& rut &"' AND CODCLIENTE='"& strCodCliente &"' AND SALDO > 0 AND ESTADO_DEUDA IN ('1','7','8') ORDER BY CUENTA, FECHAVENC DESC"
			'response.Write(strSql)
			'response.End()
			set rsDET=Conn.execute(strSql)
			if not rsDET.eof then
			%>
			  <table width="840" border="0" bordercolor="#FFFFFF">
		        <tr bordercolor="#999999" bgcolor="#<%=session("COLTABBG")%>" class="Estilo13">
		          <td width="8%" bgcolor="#FFFFFF">
		          	<a href="#" onClick="marcar_boxes(true);">M</a>&nbsp;&nbsp;&nbsp;
	    			<a href="#" onClick="desmarcar_boxes(true);">D</a>
	    		  </td>
		          <!--td width="8%">CUENTA</td-->
		          <td width="8%">NRO. DOC</td>
		          <td width="8%">F.VENCIM.</td>
		          <td width="8%">ANTIG.</td>
		          <td width="10%">TIPO DOC</td>
		          <td width="8%">ASIG.</td>
		          <td width="10%">CAPITAL</td>
		          <td width="10%">PAGO</td>
		          <td width="10%">COMPROBANTE</td>
		          <td width="10%">EJECUTIVO</td>
		          <td width="12%">ESTADO</td>

		        </tr>

				<%
				intSaldo = 0
				intValorCuota = 0
				total_ValorCuota = 0
				strArrConcepto = ""
				strArrIdCuota = ""
				do until rsDET.eof

				strArrConcepto = strArrConcepto & ";" & "CH_" & rsDET("IDCUOTA")
				strArrIdCuota = strArrIdCuota & ";" & rsDET("IDCUOTA")

				intSaldo = ValNulo(rsDET("SALDO"),"N")
				intValorCuota = ValNulo(rsDET("VALORCUOTA"),"N")
				strNroDoc = Trim(rsDET("NRODOC"))
				intIdCuota = Trim(rsDET("IDCUOTA"))
				strNroCuota = Trim(rsDET("NROCUOTA"))
				strSucursal = Trim(rsDET("SUCURSAL"))
				strEstadoDeuda = Trim(rsDET("ESTADO_DEUDA"))
				strCodRemesa = Trim(rsDET("CODREMESA"))
				intProtestoDoc = ValNulo(rsDET("GASTOSPROTESTOS"),"N")

				If Trim(strEstadoDeuda) = "1"  Then
					intTasaMensual = intTasaMensual/100
					intTasaDiaria = intTasaMensual/30
					intAntiguedad = ValNulo(rsDET("ANTIGUEDAD"),"N")
					If intAntiguedad > 0 Then
						intInteresDoc = Round(intTasaDiaria * intAntiguedad * intSaldo,0)
						intHonorariosDoc = Round(GastosCobranzas(intSaldo),0)
					Else
						intInteresDoc = 0
						intHonorariosDoc = 0
						intProtestoDoc = 0
					End If
				ElseIf (Trim(strEstadoDeuda) = "7" or Trim(strEstadoDeuda) = "8") Then
					If intSaldo <> 0 Then
						intProtestoDoc = 0
					End If
					intInteresDoc = 0
					intHonorariosDoc = 0
				Else
					intInteresDoc = 0
					intHonorariosDoc = 0
					intProtestoDoc = 0
					intSaldo = 0
				End If



				%>
		        <tr bordercolor="#999999" >
		          <input TYPE="hidden" name="HD_HONORARIOS_<%=Replace(rsDET("IDCUOTA"),"-","_")%>" type="text" value="<%=intHonorariosDoc%>">
		          <input TYPE="hidden" name="HD_INTERES_<%=Replace(rsDET("IDCUOTA"),"-","_")%>" type="text" value="<%=intInteresDoc%>">
		          <input TYPE="hidden" name="HD_PROTESTOS_<%=Replace(rsDET("IDCUOTA"),"-","_")%>" type="text" value="<%=intProtestoDoc%>">
		          <TD><INPUT TYPE=checkbox NAME="CH_<%=Replace(rsDET("IDCUOTA"),"-","_")%>" onClick="suma_capital(this,TX_SALDO_<%=rsDET("IDCUOTA")%>.value,<%=Round(intHonorariosDoc,0)%>,<%=Round(intInteresDoc,0)%>,<%=Round(intProtestoDoc,0)%>);";></TD>
		          <!--td><div align="right"><%=rsDET("CUENTA")%></div></td-->
		          <td><div align="right"><%=rsDET("NRODOC")%></div></td>
		          <td><div align="right"><%=rsDET("FECHAVENC")%></div></td>
		          <td><div align="right"><%=rsDET("ANTIGUEDAD")%></div></td>
		          <td><div align="right"><%=rsDET("TIPODOCUMENTO")%></div></td>
		          <td><div align="center"><%=rsDET("CODREMESA")%></div></td>
		          <td align="right" >$ <%=FN((intSaldo),0)%></td-->
		          <td align="right" ><input name="TX_SALDO_<%=Replace(rsDET("IDCUOTA"),"-","_")%>" type="text" value="<%=intSaldo%>" size="10" maxlength="10" align="RIGHT"></td>
		          <td align="right" ><input name="TX_COMPROBANTE_<%=Replace(rsDET("IDCUOTA"),"-","_")%>" type="text" value="" size="12" maxlength="20" align="RIGHT"></td>
		          <td align="right" >
		          <%If Not rsDET("USUARIO_ASIG")="0" Then %>
				  	<%=TraeCampoId(Conn, "LOGIN", rsDET("USUARIO_ASIG"), "USUARIO", "ID_USUARIO")%>
				  <%else%>
				  	<%="SIN ASIG."%>
				  <%End If%>
				  </td>
				  <td align="center"><%=TraeCampoId(Conn, "DESCRIPCION", strEstadoDeuda, "ESTADO_DEUDA", "CODIGO")%></td>

				 <%
					total_ValorCuota = total_ValorCuota + intValorCuota
					total_gc = total_gc + clng(rsDET("GASTOSPROTESTOS"))
					total_docs = total_docs + 1
				 %>
				 </tr>
				 <%rsDET.movenext
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
			<table width="840" border="0" bordercolor="#FFFFFF">
			<tr bordercolor="#999999" class="Estilo8">
			<td align="center">

			Deudor no posee documentos pendientes
			</td>
			</tr>
			</table>
		  <%end if%>
	    </td>
	  </tr>


		<tr>
			<td>
				CAPITAL: <INPUT TYPE="TEXT" NAME="TX_CAPITAL" size="10">
				INTERES: <INPUT TYPE="TEXT" NAME="TX_INTERES" size="10">
				HONORARIOS: <INPUT TYPE="TEXT" NAME="TX_HONORARIOS" size="10">
				PROTESTOS: <INPUT TYPE="TEXT" NAME="TX_PROTESTOS" size="10">
			</TD>
		</tr>


		<tr>
			<td>OBSERVACIONES: <INPUT TYPE="TEXT" NAME="TX_OBSERVACIONES" size="100">
				<INPUT TYPE="BUTTON" NAME="Guardar" value="Guardar" onClick="envia();" class="Estilo8">
			</TD>
		</tr>

	</table>


	</td>
	</tr>



<tr>
<td>



</table>
<INPUT TYPE="hidden" NAME="strGraba" value="">
</form>
<script language="JavaScript" type="text/JavaScript">


function envia(){
	if(datos.TX_RUT.value==''){
		alert("Debe ingresar el rut")
		datos.TX_RUT.focus();
	}
	else
	{
		datos.strGraba.value='SI';
		datos.submit();
	}

}

function marcar_boxes(){
		datos.TX_CAPITAL.value = 0;
		datos.TX_HONORARIOS.value = 0;
		datos.TX_INTERES.value = 0;
		datos.TX_PROTESTOS.value = 0;
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
		datos.TX_HONORARIOS.value = 0;
		datos.TX_INTERES.value = 0;
		datos.TX_PROTESTOS.value = 0;

}

function suma_capital(objeto , intValorSaldoCapital, intValorHonorarios, intValorIntereses, intValorProtestos){
		//alert(objeto.checked);

		if (datos.TX_CAPITAL.value == '') datos.TX_CAPITAL.value = 0
		if (datos.TX_HONORARIOS.value == '') datos.TX_HONORARIOS.value = 0
		if (datos.TX_INTERES.value == '') datos.TX_INTERES.value = 0
		if (datos.TX_PROTESTOS.value == '') datos.TX_PROTESTOS.value = 0

		if (objeto.checked == true) {
			datos.TX_CAPITAL.value = eval(datos.TX_CAPITAL.value) + eval(intValorSaldoCapital);
			datos.TX_HONORARIOS.value = eval(datos.TX_HONORARIOS.value) + eval(intValorHonorarios);
			datos.TX_INTERES.value = eval(datos.TX_INTERES.value) + eval(intValorIntereses);
			datos.TX_PROTESTOS.value = eval(datos.TX_PROTESTOS.value) + eval(intValorProtestos);
		}
		else
		{
			datos.TX_CAPITAL.value = eval(datos.TX_CAPITAL.value) - eval(intValorSaldoCapital);
			datos.TX_HONORARIOS.value = eval(datos.TX_HONORARIOS.value) - eval(intValorHonorarios);
			datos.TX_INTERES.value = eval(datos.TX_INTERES.value) - eval(intValorIntereses);
			datos.TX_PROTESTOS.value = eval(datos.TX_PROTESTOS.value) - eval(intValorProtestos);
			}
	}
</script>


















