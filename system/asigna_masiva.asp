<%@ LANGUAGE="VBScript" %>

<!--#include file="arch_utils.asp"-->
<!--#include file="lib.asp"-->
<!--#include file="sesion.asp"-->
<!--#include file="../lib/comunes/rutinas/funciones.inc" -->
<!--#include file="../lib/comunes/rutinas/TraeCampo.inc" -->
<!--#include file="asp/comunes/general/rutinasBooleano.inc" -->
<!--#include file="../lib/comunes/rutinas/funciones.inc" -->


<html>

<head>
<title>VENTAS WEB</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
</head>

<%

	''strCodCliente=Request("CB_CLIENTE")
	strCodCliente=session("ses_codcli")
	If trim(strCodCliente) = "" Then
		strCodCliente = request("strCodCliente")
	End if

	intRemesa=Request("CB_REMESA")
	intCriterio=Request("CB_CRITERIO")
	intSoloEmpresa=Request("CH_EMPRESA")
	strCampana=Request("CH_CAMPANA")

	strRut = Trim(Request("TA_RUT"))
	strUsuario = Trim(Request("TA_USUARIO"))


	If Trim(strRut) <> "" then
		if ASC(RIGHT(strRut,1)) = 10 then strRut = Mid(strRut,1,len(strRut)-1)
		if ASC(RIGHT(strRut,1)) = 13 then strRut = Mid(strRut,1,len(strRut)-1)
	End if

	If Trim(strUsuario) <> "" then
		if ASC(RIGHT(strUsuario,1)) = 10 then strUsuario = Mid(strUsuario,1,len(strUsuario)-1)
		if ASC(RIGHT(strUsuario,1)) = 13 then strUsuario = Mid(strUsuario,1,len(strUsuario)-1)
	End if

	vRut = split(strRut,CHR(13))
	intTamvRut=ubound(vRut)

	vUsuario = split(strUsuario,CHR(13))
	intTamvUsuario=ubound(vUsuario)

	If UCASE(intSoloEmpresa)="ON" Then strChecked = "checked"

	strTabla=Request("TX_TABLA")


	If Trim(Request("strRutDeudor")) <> "" Then session("IdCliente") = Trim(Request("strRutDeudor"))
	If Trim(strRutDeudor) = "" Then strRutDeudor = Trim(Request("strRutDeudor"))



	If Trim(strCodCliente) = "" Then strCodCliente=session("ses_codcli")
	If Trim(intRemesa) = "" Then intRemesa = "100"


	intUsuarios =  Request("CH_USUARIO")

	VUsuarios = Split(intUsuarios, ",")
	n=0
	For Each XX in VUsuarios
		 n=n+1
	Next

	'Response.write "<br>intRemesa=" & intRemesa
	'Response.End
%>
<%strTitulo="PANTALLA PRINCIPAL DE ASIGNACION"%>
<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<form name="datos" method="post">
<%

	If Trim(Request("Asignar"))="1" Then
		intSel = request("OP_SEL")

		If Trim(intSel) = "3" Then
			AbrirScg()

				strSql = "UPDATE CUOTA SET USUARIO_ASIG = NULL , FECHA_ASIGNACION = getdate(), ASIGNADO_POR = " & session("session_idusuario") & " WHERE CODCLIENTE = '" & strCodCliente & "' AND ESTADO_DEUDA = 1 "


				If UCASE(intSoloEmpresa)="ON" Then
					strSql = strSql & " AND CAST(SUBSTRING(RUTDEUDOR,1,LEN(RUTDEUDOR)-2) AS INT) > 50000000"
				End if

				If Trim(intRemesa) <> "TODAS" Then
					strSql = strSql & " AND CODREMESA = '" & intRemesa & "'"
				End if

				If trim(intUsuarios) <> "" Then
					strSql = strSql & " AND USUARIO_ASIG IN (" & intUsuarios & ")"
				End If
				'Response.write "<br>strSql=" & strSql
				'Response.End
				set rsUpdate = Conn.execute(strSql)

				%>
				<script>
						alert('Asignacion eliminada correctamente');
				</script>
				<%
			CerrarScg()

		End If





			If Trim(strCampana)="1" Then
				strNombreCampana = request("TX_NOMCAMPANA")
				strDescCampana = request("TX_DESCCAMPANA")
				If Trim(intRemesa) = "TODAS" Then
					intRemesa="0"
				End If
				AbrirScg()
					strSql = "INSERT INTO CAMPANA (CODCLIENTE, CODREMESA, FECHA_CREACION, NOMBRE, DESCRIPCION) "
					strSql = strSql & "VALUES ('" & strCodCliente & "'," & intRemesa & ", getdate(), '" & strNombreCampana & "','" & strDescCampana & "')"
					''Response.write "strSql=" & strSql
					set rsInsert = Conn.execute(strSql)

					strSql = "SELECT MAX(IDCAMPANA) as MAXIDCAMPANA FROM CAMPANA "

					set rsCampana = Conn.execute(strSql)
					If Not rsCampana.Eof Then
						intIdCampana = rsCampana("MAXIDCAMPANA")
					End If


					For indice = 0 to intTamvRut
						strIdRut = Trim(Replace(vRut(indice), chr(10),""))
						intCodigo = ucase(Trim(Replace(vUsuario(indice), chr(10),"")))

						intusuario = intCodigo
						strSql = "UPDATE CUOTA SET USUARIO_ASIG = " & intusuario & " , FECHA_ASIGNACION = getdate(), ASIGNADO_POR = " & session("session_idusuario") & " WHERE CODCLIENTE = '" & strCodCliente & "' AND RUTDEUDOR = '" & strIdRut & "' AND ESTADO_DEUDA = 1"
						'RESPONSE.WRITE "<BR>strSql=" & strSql
						set rsUpdate = Conn.execute(strSql)

						strSql = "UPDATE DEUDOR SET IDCAMPANA = " & intIdCampana & " WHERE CODCLIENTE = '" & strCodCliente & "' AND RUTDEUDOR = '" & strIdRut & "'"
						'RESPONSE.WRITE "<BR>strSql=" & strSql
						'RESPONSE.End
						set rsUpdate = Conn.execute(strSql)

						'Response.write "<br>strSql=" & strSql
						set rsUpdate = Conn.execute(strSql)
					Next
				CerrarScg()

			Else
					AbrirScg()
						For indice = 0 to intTamvRut
							strIdRut = Trim(Replace(vRut(indice), chr(10),""))
							intCodigo = ucase(Trim(Replace(vUsuario(indice), chr(10),"")))
							intUsuario = intCodigo
							strSql = "UPDATE CUOTA SET USUARIO_ASIG = " & intUsuario & " , FECHA_ASIGNACION = getdate(), ASIGNADO_POR = " & session("session_idusuario") & " WHERE CODCLIENTE = '" & strCodCliente & "' AND RUTDEUDOR = '" & strIdRut & "' AND ESTADO_DEUDA = 1"
							set rsUpdate = Conn.execute(strSql)
							strAsigna="S"
						Next
					CerrarScg()
					If strAsigna="S" Then
					%>
					<script>
							alert('Asignacion realizada correctamente');
					</script>
					<%
					End If


			End If



		If Trim(intSel) = "1" or Trim(intSel) = "2" Then

			AbrirScg()


				if Trim(intSel) = "1" Then
					strCondicion = " AND USUARIO_ASIG is NULL "
				End if
				If Trim(strTabla) <> "" Then
					strCondicion2 = " AND RUTDEUDOR IN (SELECT RUT FROM " & strTabla & ")"
				End if
				If UCASE(intSoloEmpresa)="ON" Then
					strCondicion3 = " AND CAST(SUBSTRING(RUTDEUDOR,1,LEN(RUTDEUDOR)-2) AS INT) > 50000000"
				End if

				If Trim(intCriterio) = "M" Then
					strSql = "SELECT DISTINCT RUTDEUDOR , SUM(SALDO) FROM CUOTA WHERE CODCLIENTE = '" & strCodCliente & "'"
					strSql = strSql & " AND ESTADO_DEUDA = 1 " & strCondicion & strCondicion2 & " GROUP BY RUTDEUDOR ORDER BY SUM(SALDO) DESC"
				Else
					strSql = "SELECT DISTINCT RUTDEUDOR , MAX(FECHAVENC), SUM(SALDO) FROM CUOTA WHERE CODCLIENTE = '" & strCodCliente & "'"
					If Trim(intRemesa) <> "TODAS" Then
						strSql = strSql & " AND CODREMESA = '" & intRemesa & "'"
					End if

					strSql = " AND ESTADO_DEUDA = 1 " & strCondicion & strCondicion2 & strCondicion3 & " GROUP BY RUTDEUDOR ORDER BY MAX(FECHAVENC),SUM(SALDO) ASC"
				End if


				'Response.write "<br>strSql=" & strSql

				'Response.write "<br> UBOUND(VUsuarios)=" &  UBOUND(VUsuarios)
				'Response.eND

				set rsAsigna = Conn.execute(strSql)

				intUsuarioAsig = ""
				n = 0
				If UBOUND(VUsuarios) >= 0 Then
					Do While Not rsAsigna.Eof
						intUsuarioAsig = VUsuarios(n)
						strSql = "UPDATE CUOTA SET USUARIO_ASIG = " & intUsuarioAsig & " , FECHA_ASIGNACION = getdate(), ASIGNADO_POR = " & session("session_idusuario") & " WHERE CODCLIENTE = '" & strCodCliente & "'"

						If Trim(intRemesa) <> "TODAS" Then
							strSql = strSql & " AND CODREMESA = '" & intRemesa & "'"
						End if

						'RESPONSE.WRITE "<br>strSql=" & strSql

						strSql = strSql & " AND RUTDEUDOR = '" & rsAsigna("RUTDEUDOR") & "' AND ESTADO_DEUDA = 1"

						set rsUpdate = Conn.execute(strSql)


						If Trim(strCampana)="1" Then

						strSql = "UPDATE DEUDOR SET IDCAMPANA = " & intIdCampana & " WHERE CODCLIENTE = '" & strCodCliente & "' AND RUTDEUDOR = '" & rsAsigna("RUTDEUDOR") & "'"
						'RESPONSE.WRITE "strSql=" & strSql
						'RESPONSE.End
						set rsUpdate = Conn.execute(strSql)

						End If



						'Response.write "<br>Asignando rut :" & rsAsigna("RUTDEUDOR")

						rsAsigna.MoveNext
						n=n+1
						If UBOUND(VUsuarios) + 1 = n Then
							n=0
						End If

					Loop
				End If
				%>
					<script>
							alert('Asignacion realizada correctamente');
					</script>
				<%
			CerrarScg()
		End If

	End If

	intContacto = Trim(request("contacto"))
	if Trim(strRutDeudor) <> "" and Trim(strCodCliente) <> "" Then

		AbrirScg()
		strSql = "SELECT RUTDEUDOR, USUARIO_ASIG FROM CUOTA "
		strSql = strSql & "WHERE CODCLIENTE = " & strCodCliente & " AND "
		strSql = strSql & "RUTDEUDOR = '" & strRutDeudor & "'"

		'Response.write "<br>strSql = " & strSql
		'Response.write "<br>Conn = " & Conn
		'Response.End

		set rsDEU=Conn.execute(strSql)
		if not rsDEU.eof then
			'Response.write "<br>strSql = " & strSql
			strRutDeudor = rsDEU("RUTDEUDOR")
			strEjeAsig = rsDEU("USUARIO_ASIG")

			strSql = "SELECT NOMBREDEUDOR FROM DEUDOR WHERE CODCLIENTE = '" & strCodCliente & "' AND "
			strSql = strSql & "RUTDEUDOR = '" & strRutDeudor & "'"
			'Response.write strSql
			set rsTemp=Conn.execute(strSql)
			If not rsTemp.eof then
				strNombreAMostrar = rsTemp("NOMBREDEUDOR")
			Else
				strNombreAMostrar = ""
			End If

			existe = "si"
		else
			strRutDeudor = ""
			strEjeAsig = ""
			existe = "si"
		end if

		rsDEU.close
		set rsDEU=nothing
		CerrarScg()

	End If


%>
<table width="100%" border="1" bordercolor="#FFFFFF">
	<tr>
		<TD height="20" ALIGN=LEFT class="pasos1_i">
			<B>ASIGNACION MASIVA</B>
		</TD>
	</tr>
</table>
<br>

<table width="600" border="0" ALIGN="CENTER">
	<tr>
		<td height="331" valign="top">
			<table width="100%" border="0">
			<tr>
			<td class="Estilo38">
				<strong><font color="#009900">CLIENTE</font></strong>
			</td>
			<td class="Estilo38">
				<strong><font color="#009900">CARTERA</font></strong>
			</td>
			<td class="Estilo38">
				<strong><font color="#009900">SOLO EMPRESAS</font></strong>
			</td>
			<!--td class="Estilo38">
				<strong><font color="#009900">HERRAMIENTA</font></strong>
			</td-->
			<td class="Estilo38">
				&nbsp
			</td>
			</tr>
			<tr>
			<td>
				<select name="CB_CLIENTE" OnChange="Refrescar();">
					<%
					abrirscg()
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
					cerrarscg()
					%>
				</select>
			</td>
			<td>
				<select name="CB_REMESA" OnChange="Refrescar();">
					<option value="TODAS" <%if Trim(intRemesa) = "TODAS" then response.Write("SELECTED") End If%>>TODAS</option>
					<%
					abrirscg()
					ssql="SELECT CONVERT(VARCHAR(10),FECHA_LLEGADA,103) as FECHAREMESA , CODREMESA FROM REMESA WHERE CODCLIENTE = '" & strCodCliente & "' AND CODREMESA >= 100"
					set rsTemp= Conn.execute(ssql)
					if not rsTemp.eof then
						do until rsTemp.eof%>
						<option value="<%=rsTemp("CODREMESA")%>" <%if Trim(intRemesa) = Trim(rsTemp("CODREMESA")) then response.Write("SELECTED") End If%>><%=rsTemp("CODREMESA") & "-" & rsTemp("FECHAREMESA")%></option>
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
				<INPUT TYPE=checkbox NAME="CH_EMPRESA" <%=strChecked%>>
			</td>
			<td>
				<acronym title="REFRESCAR">
					<input name="BT_REFRESCAR" type="button" id="BT_REFRESCAR" onClick="Refrescar();" value="OK">
				</acronym>
			 </td>
			<!--td>
				<select name="CB_HERRAMIENTA">
					<option value="TEL">TELEFONICA</option>
					<option value="TERR">TERRENO</option>
					<option value="EMAIL">EMAIL</option>
				</select>
			</td-->

			<td>
			  <acronym title="ASIGNAR">
				<input name="me_" type="button" id="me_" onClick="Asignar();" value="Procesar">
			  </acronym>
		   <input name="strCodCliente" type="hidden" value="<%=strCodCliente%>">
			  <input name="strRutDeudor" type="hidden" value="<%=strRutDeudor%>">
			  <input name="ANI" type="hidden" id="ANI" value="<%=ani%>">
			 </td>
			<td>
		</td>
	</tr>
</table>

<%
	AbrirScg()

	strSql="SELECT IsNull(COUNT(DISTINCT RUTDEUDOR),0) as CRUT, IsNull(SUM(SALDO),0) as CSALDO FROM CUOTA WHERE CODCLIENTE = '" & strCodCliente & "' AND ESTADO_DEUDA = 1"
	If Trim(intRemesa) <> "TODAS" Then
		strSql = strSql & " AND CODREMESA = '" & intRemesa & "'"
	End if
	If UCASE(intSoloEmpresa)="ON" Then
		strSql = strSql & " AND CAST(SUBSTRING(RUTDEUDOR,1,LEN(RUTDEUDOR)-2) AS INT) > 50000000"
	End if
	'Response.write strSql
	'Response.eND
	set rsDET= Conn.execute(strSql)
	if Not rsDET.eof Then
		intCrut = Trim(rsDET("CRUT"))
		intCsaldo = Trim(rsDET("CSALDO"))
	End if

	strSql="SELECT IsNull(COUNT(DISTINCT RUTDEUDOR),0) as CRUT, IsNull(SUM(SALDO),0) as CSALDO FROM CUOTA WHERE CODCLIENTE = '" & strCodCliente & "'"
	If Trim(intRemesa) <> "TODAS" Then
		strSql = strSql & " AND CODREMESA = '" & intRemesa & "'"
	End if
	If UCASE(intSoloEmpresa)="ON" Then
		strSql = strSql & " AND CAST(SUBSTRING(RUTDEUDOR,1,LEN(RUTDEUDOR)-2) AS INT) >= 50000000"
	End if
	strSql = strSql & " AND ESTADO_DEUDA = 1 AND (USUARIO_ASIG IS NULL OR USUARIO_ASIG = 0)"
	set rsDET1= Conn.execute(strSql)
	'Response.write "<BR>strSql1="&strSql
	'Response.write "<BR>eof="& Not rsDET1.eof
	if Not rsDET1.eof Then
		'Response.write "<BR>DDD1="&rsDET1("CRUT")
		intCrutSA = Trim(rsDET1("CRUT"))
		intCsaldoSA = Trim(rsDET1("CSALDO"))
	End if

	strSql="SELECT IsNull(COUNT(DISTINCT ID_USUARIO),0) as CUSUARIO FROM USUARIO WHERE ACTIVO = 1 AND (PERFIL_COB = 1 OR PERFIL_SUP = 1)"
	set rsDET= Conn.execute(strSql)
	if Not rsDET.eof Then
		intTotalEjecutivo = Trim(rsDET("CUSUARIO"))
	End if

	strSql="SELECT TOP 1 SUM(SALDO) AS MAXSALDO, RUTDEUDOR FROM CUOTA WHERE CODCLIENTE = '" & strCodCliente & "'"
	If Trim(intRemesa) <> "TODAS" Then
		strSql = strSql & " AND CODREMESA = '" & intRemesa & "'"
	End if
	If UCASE(intSoloEmpresa)="ON" Then
		strSql = strSql & " AND CAST(SUBSTRING(RUTDEUDOR,1,LEN(RUTDEUDOR)-2) AS INT) > 50000000"
	End if
	strSql = strSql & " AND ESTADO_DEUDA = 1 AND SALDO > 0 GROUP BY RUTDEUDOR ORDER BY SUM(SALDO) DESC"

	set rsDET= Conn.execute(strSql)
	if Not rsDET.eof Then
		intMaxSaldo = Trim(rsDET("MAXSALDO"))
	End if

	strSql="SELECT TOP 1 SUM(SALDO) AS MINSALDO, RUTDEUDOR FROM CUOTA WHERE CODCLIENTE = '" & strCodCliente & "'"
	If UCASE(intSoloEmpresa)="ON" Then
		strSql = strSql & " AND CAST(SUBSTRING(RUTDEUDOR,1,LEN(RUTDEUDOR)-2) AS INT) > 50000000"
	End if
	If Trim(intRemesa) <> "TODAS" Then
		strSql = strSql & " AND CODREMESA = '" & intRemesa & "'"
	End if

	strSql = strSql & " AND ESTADO_DEUDA = 1 AND SALDO > 0 GROUP BY RUTDEUDOR ORDER BY SUM(SALDO) ASC"

	set rsDET= Conn.execute(strSql)
	if Not rsDET.eof Then
		intMinSaldo = Trim(rsDET("MINSALDO"))
	End if

	strSql="SELECT SUM(SALDO)/COUNT(DISTINCT RUTDEUDOR) AS PROMSALDO FROM CUOTA WHERE CODCLIENTE = '" & strCodCliente & "'"
	If UCASE(intSoloEmpresa)="ON" Then
		strSql = strSql & " AND CAST(SUBSTRING(RUTDEUDOR,1,LEN(RUTDEUDOR)-2) AS INT) > 50000000"
	End if
	If Trim(intRemesa) <> "TODAS" Then
		strSql = strSql & " AND CODREMESA = '" & intRemesa & "'"
	End if
	strSql = strSql & " AND ESTADO_DEUDA = 1 AND SALDO > 0"
	set rsDET= Conn.execute(strSql)
	if Not rsDET.eof Then
		intPromSaldo = Trim(rsDET("PROMSALDO"))
	End if



	CerrarScg()

%>

<table width="600" border="1" ALIGN="CENTER">
	<tr>
		<td valign="top">
			<table width="580" border="0" ALIGN="CENTER">
				<tr bgcolor="#<%=session("COLTABBG")%>" class="Estilo13">
					<TD ALIGN="CENTER">
						GRABAR CAMPAÑA
					</TD>
					<TD ALIGN="LEFT">
						Nombre :
					</TD>
					<TD ALIGN="LEFT">
						<input name="TX_NOMCAMPANA" type="text" value="" size="20" maxlength="20" onchange="">
					</TD>
				</tr>
				<tr bgcolor="#<%=session("COLTABBG")%>" class="Estilo13">
					<TD ALIGN="CENTER">
					<input name="CH_CAMPANA" type="checkbox" value="1" onchange="">
					</TD>
					<TD ALIGN="LEFT">
						Descripción
					</TD>
					<TD ALIGN="LEFT">
					<input name="TX_DESCCAMPANA" type="text" value="" size="50" maxlength="120" onchange="">
					</TD>
				</tr>
			</table>
		</TD>
	</tr
</table>


<table width="600" border="1" ALIGN="CENTER">
	<tr>
		<td valign="top">
			<table width="580" border="0" ALIGN="CENTER">
				<tr bgcolor="#<%=session("COLTABBG")%>" class="Estilo13">
					<TD WIDTH="50%" ALIGN="CENTER">
						CRITERIOS DE SEGMENTACION DE LA CARTERA
					</TD>
					<TD ALIGN="CENTER" bgcolor="#ffffff">
						<select name="CB_CRITERIO">
							<option value="M">ASIG. POR MONTO</option>
							<option value="A">ASIG. POR ANTIGUEDAD - MONTO</option>
						</select>
					</TD>
				</tr>
			</table>
		</TD>
	</tr>
</table>

<table width="600" border="1" bordercolor="#FFFFFF" ALIGN="CENTER">
	<TR>
		<TD class=hdr_i width="50%">
			RUT
		</TD>
		<TD class=hdr_i width="50%">
			USUARIO (CODIGO)
		</TD>
	</TR>
	<TR>
		<TD class=hdr_i width="50%">
			<TEXTAREA NAME="TA_RUT" ROWS=10 COLS=20><%=strRut%></TEXTAREA>
		</TD>
		<TD class=hdr_i width="50%">
			<TEXTAREA NAME="TA_USUARIO" ROWS=10 COLS=20><%=strUsuario%></TEXTAREA>
		</TD>
	</TR>
</table>

<table width="600" border="1" ALIGN="CENTER">
	<tr>
		<td valign="top">
			<table width="580" border="0" ALIGN="CENTER">
				<tr bgcolor="#<%=session("COLTABBG")%>" class="Estilo13">
					<TD WIDTH="20%" ALIGN="CENTER">
						Deuda Maxima
					</TD>
					<TD WIDTH="20%" ALIGN="CENTER">
						Deuda Minima
					</TD>
					<TD WIDTH="20%" ALIGN="CENTER">
						Deuda Promedio
					</TD>
					<TD COLSPAN=2>
						Tabla Especial
					</TD>
				</tr>
				<tr bordercolor="#999999">
					<TD ALIGN="CENTER">
						$&nbsp;<%=FN(intMaxSaldo,0)%>
					</TD>
					<TD ALIGN="CENTER">
						$&nbsp;<%=FN(intMinSaldo,0)%>
					</TD>
					<TD ALIGN="CENTER">
						$&nbsp;<%=FN(intPromSaldo,0)%>
					</TD>
					<TD COLSPAN=2>
						<input type="text" name="TX_TABLA"  size="30" value="">
					</TD>
				</tr>
				<tr bgcolor="#<%=session("COLTABBG")%>" class="Estilo13">
					<TD WIDTH="20%" ALIGN="CENTER">
						Rut Total
					</TD>
					<TD WIDTH="20%" ALIGN="CENTER">
						Monto Total
					</TD>
					<TD WIDTH="20%" ALIGN="CENTER">
						Rut No Asignados
					</TD>
					<TD WIDTH="20%" ALIGN="CENTER">
						Monto No Asignados
					</TD>
					<TD WIDTH="20%" ALIGN="CENTER">
						Ejecutivos
					</TD>
				</tr>
				<tr bordercolor="#999999">
					<TD ALIGN="CENTER">
						<%=FN(intCrut,0)%>
					</TD>
					<TD ALIGN="CENTER">
						$&nbsp;<%=FN(intCsaldo,0)%>
					</TD>
					<TD ALIGN="CENTER">
						<%=FN(intCrutSA,0)%>
					</TD>
					<TD ALIGN="CENTER">
						$&nbsp;<%=FN(intCsaldoSA,0)%>
					</TD>
					<TD ALIGN="CENTER">
						<%=FN(intTotalEjecutivo,0)%>
					</TD>
				</tr>
			</table>
 		</td>
	</tr>
</table>


<table width="600" border="1" ALIGN="CENTER">
	<tr>
		<td width="600" valign="top">
			<TABLE BORDER="0" ALIGN="CENTER">
				<tr bordercolor="#999999">
					<TD>
						<INPUT TYPE=Radio VALUE="1" NAME="OP_SEL">
					</TD>
					<td>
						Asignar solo casos sin asignacion
					</td>
					<TD>
						<INPUT TYPE=Radio VALUE="2" NAME="OP_SEL">
					</TD>
					<td>
						Reasignar Todo
					</td>

					<TD>
						<INPUT TYPE=Radio VALUE="3" NAME="OP_SEL">
					</TD>
					<td>
						Eliminar Asignacion
					</td>
				</tr>
			</TABLE>
 		</td>
 	</tr>
 	<tr>
		<td width="600" valign="top">
			<table width="600" border="0" ALIGN="CENTER">
				<tr bordercolor="#999999">
				<TD WIDTH="10%" align="LEFT">
				Marcar
				</TD>
				<TD WIDTH="45%" align="LEFT">
				Ejecutivo
				</TD>
				<TD WIDTH="20%" align="CENTER">
				Rut Asig
				</TD>
				<TD WIDTH="25%" align="CENTER">
				Monto Asig.
				</TD>
				</TR>
			<%
				AbrirScg()
				strSql="SELECT * FROM USUARIO WHERE ACTIVO = 1 AND (PERFIL_COB = 1 OR PERFIL_SUP = 1) ORDER BY PERFIL_EMP, LOGIN"
				set rsDET= Conn.execute(strSql)
				IntTotalMonto = 0
				IntTotalRut = 0
				do until rsDET.eof
					strNombre = Trim(rsDET("NOMBRES_USUARIO")) & " " & Trim(rsDET("APELLIDOS_USUARIO"))
					strNombre = UCASE(strNombre)

					%>

					<tr bordercolor="#999999">
					<TD><INPUT TYPE=checkbox NAME="CH_USUARIO" value="<%=rsDET("ID_USUARIO")%>"></TD>
					<td><div ALIGN="LEFT"><%=strNombre%></div></td>
					<%
					total_ValorCuota = total_ValorCuota + intValorCuota
					total_docs = total_docs + 1

					strSql="SELECT COUNT(DISTINCT RUTDEUDOR) AS CRUT, IsNull(SUM(SALDO),0) AS CMONTO FROM CUOTA WHERE CODCLIENTE = '" & strCodCliente & "'"
					If UCASE(intSoloEmpresa)="ON" Then
						strSql = strSql & " AND CAST(SUBSTRING(RUTDEUDOR,1,LEN(RUTDEUDOR)-2) AS INT) > 50000000"
					End if
					If Trim(intRemesa) <> "TODAS" Then
						strSql = strSql & " AND CODREMESA = '" & intRemesa & "'"
					End if
					strSql = strSql & " AND ESTADO_DEUDA = 1 AND USUARIO_ASIG = " & rsDET("ID_USUARIO")
					set rsDUsr= Conn.execute(strSql)
					If Not rsDUsr.Eof Then
						intRut = rsDUsr("CRUT")
						intMonto = rsDUsr("CMONTO")
					Else
						intRut = "0"
						intMonto = "0"
					End If

					IntTotalRut = IntTotalRut + intRut
					IntTotalMonto = IntTotalMonto + intMonto

					%>
					<td><div ALIGN="RIGHT"><%=intRut%></div></td>
					<td><div ALIGN="RIGHT">$&nbsp;<%=FN(intMonto,0)%></div></td>
					</tr>
					<%rsDET.movenext
				loop
				CerrarScg()
			%>
			<tr>
				<td><div ALIGN="RIGHT">&nbsp</div></td>
				<td><div ALIGN="RIGHT">&nbsp</div></td>
				<td><div ALIGN="RIGHT"><%=FN(IntTotalRut,0)%></div></td>
				<td><div ALIGN="RIGHT">$&nbsp;<%=FN(IntTotalMonto,0)%></div></td>
			</tr>
			</table>
 		</td>
	</tr>
</table>

</table>
	</td>
	</tr>
</table>
</form>
</body>
</html>


<script language="JavaScript" type="text/JavaScript">
function envia(){
	datos.action='asigna_masiva.asp?Limpiar=1';
	datos.submit();
}

function Asignar(){
	//alert(datos.OP_SEL.value);
	datos.action='asigna_masiva.asp?Asignar=1';
	datos.submit();
}

function Refrescar(){
	datos.action='asigna_masiva.asp';
	datos.submit();
}

function gestionar(){
	if (datos.CB_EJECUTIVO.value == '') {
		alert('Debe Ingresar un ejecutivo');
		return;
	}
}

function gestionar(){
	datos.BT_GESTIONAR.disabled=true;
	datos.action='asigna_masiva.asp?intGrabar=1';
	datos.submit();
}

</script>
