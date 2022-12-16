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
	AgregarCasos=Request("AgregarCasos")
	EliminarCasos=Request("EliminarCasos")
	EliminarCampana=Request("EliminarCampana")

	strCodCliente=session("ses_codcli")
	If trim(strCodCliente) = "" Then
		strCodCliente = request("strCodCliente")
	End if

	intCodCampana=Request("CB_CAMPANA")

	If Trim(intCodCampana) = "" Then
		strNombreCampana = ""
		strDescCampana = ""
	End if

	intSoloEmpresa=Request("CH_EMPRESA")
	strCampana=Request("CH_CAMPANA")

	strRut = Trim(Request("TA_RUT"))
	strUsuario = Trim(Request("TA_USUARIO"))

	strCota = Trim(Request("TX_COTA"))
	If Trim(strCota) <> "" Then
		strTop = "TOP " & strCota
	End If




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


	If UCASE(intSoloEmpresa)="ON" Then strChecked = "checked"

	strTabla=Request("TX_TABLA")


	If Trim(Request("strRutDeudor")) <> "" Then session("IdCliente") = Trim(Request("strRutDeudor"))
	If Trim(strRutDeudor) = "" Then strRutDeudor = Trim(Request("strRutDeudor"))



	If Trim(strCodCliente) = "" Then strCodCliente=session("ses_codcli")
	If Trim(intCodCampana) = "" Then intCodCampana = "99999999990"


	AbrirScg()
	strSql="SELECT * FROM CAMPANA WHERE CODCLIENTE = '" & strCodCliente & "' AND IDCAMPANA = " & intCodCampana
	set rsCampana=Conn.execute(strSql)
	If not rsCampana.eof Then
		strNombreCampana = rsCampana("NOMBRE")
		strDescCampana = rsCampana("DESCRIPCION")
	End if
	CerrarScg()



	intUsuarios =  Request("CH_USUARIO")

	VUsuarios = Split(intUsuarios, ",")
	n=0
	For Each XX in VUsuarios
		 n=n+1
	Next

	'Response.write "<br>intCodCampana=" & intCodCampana
	'Response.End
%>
<%strTitulo="PANTALLA PRINCIPAL DE ASIGNACION"%>
<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<form name="datos" method="post">
<%




	If Trim(strCampana)="1" Then
		strNombreCampana = request("TX_NOMCAMPANA")
		strDescCampana = request("TX_DESCCAMPANA")
		AbrirScg()
			strSql = "INSERT INTO CAMPANA (CODCLIENTE, CODREMESA, FECHA_CREACION, NOMBRE, DESCRIPCION) "
			strSql = strSql & "VALUES ('" & strCodCliente & "'," & intCodCampana & ", getdate(), '" & strNombreCampana & "','" & strDescCampana & "')"
			''Response.write "strSql=" & strSql
			set rsInsert = Conn.execute(strSql)
		CerrarScg()

		AbrirScg()
			strSql = "SELECT MAX(IDCAMPANA) as MAXIDCAMPANA FROM CAMPANA "
			set rsCampana = Conn.execute(strSql)
			If Not rsCampana.Eof Then
				intIdCampana = rsCampana("MAXIDCAMPANA")
			End If
		CerrarScg()

			For indice = 0 to intTamvRut
				strIdRut = Trim(Replace(vRut(indice), chr(10),""))
				intCodigo = ucase(Trim(Replace(vUsuario(indice), chr(10),"")))

				intusuario = intCodigo

				AbrirScg()
					strSql = "UPDATE CUOTA SET USUARIO_ASIG = " & intusuario & " , FECHA_ASIGNACION = getdate(), ASIGNADO_POR = " & session("session_idusuario") & " WHERE CODCLIENTE = '" & strCodCliente & "' AND RUTDEUDOR = '" & strIdRut & "'"
					set rsUpdate = Conn.execute(strSql)
				CerrarScg()

				AbrirScg()
					strSql = "UPDATE DEUDOR SET IDCAMPANA = " & intIdCampana & " WHERE CODCLIENTE = '" & strCodCliente & "' AND RUTDEUDOR = '" & strIdRut & "'"
					set rsUpdate = Conn.execute(strSql)
				CerrarScg()

				'Response.write "<br>strSql=" & strSql
				'set rsUpdate = Conn.execute(strSql)
			Next


	End If


	If Trim(AgregarCasos) = "1" Then

			intIdCampana = Request("hdidCampana")
			For indice = 0 to intTamvRut
				strIdRut = Trim(Replace(vRut(indice), chr(10),""))
				intCodigo = ucase(Trim(Replace(vUsuario(indice), chr(10),"")))

				intusuario = intCodigo
				AbrirScg()
					strSql = "UPDATE CUOTA SET USUARIO_ASIG = " & intusuario & " , FECHA_ASIGNACION = getdate(), ASIGNADO_POR = " & session("session_idusuario") & " WHERE CODCLIENTE = '" & strCodCliente & "' AND RUTDEUDOR = '" & strIdRut & "'"
					set rsUpdate = Conn.execute(strSql)
				CerrarScg()

				AbrirScg()
					strSql = "UPDATE DEUDOR SET IDCAMPANA = " & intIdCampana & " WHERE CODCLIENTE = '" & strCodCliente & "' AND RUTDEUDOR = '" & strIdRut & "'"
					set rsUpdate = Conn.execute(strSql)
				CerrarScg()

			Next


	End If

	If Trim(EliminarCasos) = "1" Then

			intIdCampana = Request("hdidCampana")
			For indice = 0 to intTamvRut
				strIdRut = Trim(Replace(vRut(indice), chr(10),""))
				AbrirScg()
					strSql = "UPDATE CUOTA SET USUARIO_ASIG = NULL , FECHA_ASIGNACION = getdate(), ASIGNADO_POR = " & session("session_idusuario") & " WHERE CODCLIENTE = '" & strCodCliente & "' AND RUTDEUDOR = '" & strIdRut & "'"
					set rsUpdate = Conn.execute(strSql)
				CerrarScg()

				AbrirScg()
					strSql = "UPDATE DEUDOR SET IDCAMPANA = NULL WHERE CODCLIENTE = '" & strCodCliente & "' AND RUTDEUDOR = '" & strIdRut & "'"
					set rsUpdate = Conn.execute(strSql)
				CerrarScg()
			Next
	End If

	If Trim(EliminarCampana) = "1" Then

		intIdCampana = Request("hdidCampana")
		AbrirScg()
			strSql = "UPDATE DEUDOR SET IDCAMPANA = NULL WHERE CODCLIENTE = '" & strCodCliente & "' AND IDCAMPANA = " & intIdCampana
			set rsUpdate = Conn.execute(strSql)

			strSql = "DELETE FROM CAMPANA WHERE IDCAMPANA = " & intIdCampana
			set rsUpdate = Conn.execute(strSql)
		CerrarScg()

	End If





	If Trim(Request("Asignar"))="1" Then
		intSel = request("OP_SEL")

		If Trim(intSel) = "3" Then


				strSql = "UPDATE CUOTA SET USUARIO_ASIG = NULL , FECHA_ASIGNACION = getdate(), ASIGNADO_POR = " & session("session_idusuario") & " WHERE CODCLIENTE = '" & strCodCliente & "'"
				If UCASE(intSoloEmpresa)="ON" Then
					strSql = strSql & " AND CAST(SUBSTRING(RUTDEUDOR,1,LEN(RUTDEUDOR)-2) AS INT) > 50000000"
				End if

				If Trim(intCodCampana) <> "0" Then
					strSql = strSql & " AND RUTDEUDOR IN (SELECT RUTDEUDOR FROM DEUDOR WHERE CODCLIENTE = '" & strCodCliente & "' AND IDCAMPANA = " & intCodCampana & ")"
				End if

				If trim(intUsuarios) <> "" Then
					strSql = strSql & " AND USUARIO_ASIG IN (" & intUsuarios & ")"
					'Response.write "<br>strSql=" & strSql
					'Response.End

					AbrirScg()
					set rsUpdate = Conn.execute(strSql)
					CerrarScg()
					%>
					<script>
							alert('Asignacion eliminada correctamente');
					</script>
					<%
				Else
					%>
					<script>
							alert('Debe seleccionar al menos un usuario para poder eliminar');
					</script>
					<%
				End If
		End If

		If Trim(intSel) = "1" or Trim(intSel) = "2" Then
				if Trim(intSel) = "1" Then
					strCondicion = " AND USUARIO_ASIG is NULL "
				End if
				If Trim(strTabla) <> "" Then
					strCondicion2 = " AND RUTDEUDOR IN (SELECT RUT FROM " & strTabla & ")"
				End if
				If UCASE(intSoloEmpresa)="ON" Then
					strCondicion3 = " AND CAST(SUBSTRING(RUTDEUDOR,1,LEN(RUTDEUDOR)-2) AS INT) > 50000000"
				End if

				strSql = "SELECT DISTINCT " & strTop & " RUTDEUDOR , SUM(SALDO) FROM CUOTA WHERE CODCLIENTE = '" & strCodCliente & "'"

				If Trim(intCodCampana) <> "0" Then
					strSql = strSql & " AND RUTDEUDOR IN (SELECT RUTDEUDOR FROM DEUDOR WHERE CODCLIENTE = '" & strCodCliente & "' AND IDCAMPANA = " & intCodCampana & ")"
				End if


				strSql = strSql & " " & strCondicion & strCondicion2 & " GROUP BY RUTDEUDOR ORDER BY SUM(SALDO) DESC"

				'Response.write "<br>PRINCIPAL strSql=" & strSql


				Server.ScriptTimeout = 9000
				Conn2.ConnectionTimeout = 9000
				Conn1.ConnectionTimeout = 9000
				AbrirScg2()

				set rsAsigna2 = Conn2.execute(strSql)

				intUsuarioAsig = ""
				n = 0
				If UBOUND(VUsuarios) >= 0 Then
					Do While Not rsAsigna2.Eof
						intUsuarioAsig = VUsuarios(n)

						strSql1 = "UPDATE CUOTA SET USUARIO_ASIG = " & intUsuarioAsig & " , FECHA_ASIGNACION = getdate() , ASIGNADO_POR = " & session("session_idusuario") & " WHERE CODCLIENTE = '" & strCodCliente & "'"

						If Trim(intCodCampana) <> "0" Then
							strSql1 = strSql1 & " AND RUTDEUDOR IN (SELECT RUTDEUDOR FROM DEUDOR WHERE CODCLIENTE = '" & strCodCliente & "' AND RUTDEUDOR = '" & rsAsigna2("RUTDEUDOR") & "' AND IDCAMPANA = " & intCodCampana & ")"
						End if
						strSql1 = strSql1 & " AND RUTDEUDOR = '" & rsAsigna2("RUTDEUDOR") & "'"

						'strSql1 = "EXEC proc_EjecutaSentencia '11'"

						'RESPONSE.WRITE "<br>VUsuarios=" & UBOUND(VUsuarios)
						'RESPONSE.WRITE "<br>Conn1=" & Conn1

						'RESPONSE.WRITE "<br>strSql=" & strSql1
						''RESPONSE.End

						AbrirSCG1()
							set rsModif = Conn1.execute(strSql1)
						CerrarSCG1()

						If Trim(strCampana)="1" Then

							strSql = "UPDATE DEUDOR SET IDCAMPANA = " & intIdCampana & " WHERE CODCLIENTE = '" & strCodCliente & "' AND RUTDEUDOR = '" & rsAsigna2("RUTDEUDOR") & "'"
							AbrirSCG1()
								set rsUpdate2 = Conn1.execute(strSql)
							CerrarSCG1()

						End If

						''Response.write "<br>Asignando rut :" & rsAsigna2("RUTDEUDOR")

						rsAsigna2.MoveNext
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
			CerrarScg2()
		End If

	End If

	intContacto = Trim(request("contacto"))
	if Trim(strRutDeudor) <> "" and Trim(strCodCliente) <> "" Then


		strSql = "SELECT RUTDEUDOR, USUARIO_ASIG FROM CUOTA "
		strSql = strSql & "WHERE CODCLIENTE = " & strCodCliente & " AND "
		strSql = strSql & "RUTDEUDOR = '" & strRutDeudor & "'"

		AbrirScg()
			set rsDEU=Conn.execute(strSql)
			if not rsDEU.eof then
				'Response.write "<br>strSql = " & strSql
				strRutDeudor = rsDEU("RUTDEUDOR")
				strEjeAsig = rsDEU("USUARIO_ASIG")

				strSql = "SELECT NOMBREDEUDOR FROM DEUDOR WHERE CODCLIENTE = '" & strCodCliente & "' AND "
				strSql = strSql & "RUTDEUDOR = '" & strRutDeudor & "'"

				AbrirScg1()
				set rsTemp=Conn.execute(strSql)
				If not rsTemp.eof then
					strNombreAMostrar = rsTemp("NOMBREDEUDOR")
				Else
					strNombreAMostrar = ""
				End If
				CerrarScg1()
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

<table width="800" border="0" ALIGN="CENTER">
	<tr>
		<td height="331" valign="top">
			<table width="100%" border="0">
			<tr>
			<td class="Estilo38">
				<strong><font color="#009900">CLIENTE</font></strong>
			</td>
			<td class="Estilo38">
				<strong><font color="#009900">CAMPAÑA</font></strong>
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
				<select name="CB_CAMPANA" OnChange="Refrescar();">
				<option value="0">NUEVA</option>
				<%
				AbrirSCG()
					If Trim(strCodCliente) <> "" Then
						strSql="SELECT * FROM CAMPANA WHERE CODCLIENTE = '" & strCodCliente & "'"
						set rsCampana=Conn.execute(strSql)
						Do While not rsCampana.eof
						If Trim(intCodCampana)=Trim(rsCampana("IDCAMPANA")) Then strSelCam = "SELECTED" Else strSelCam = ""
						%>
						<option value="<%=rsCampana("IDCAMPANA")%>" <%=strSelCam%>> <%=rsCampana("IDCAMPANA") & " - " & rsCampana("NOMBRE")%></option>
						<%
						rsCampana.movenext
						Loop
						rsCampana.close
						set rsCampana=nothing
					End if
				CerrarSCG()
				''Response.End
				%>
				</select>
			</td>
			<td>
				<INPUT TYPE=checkbox NAME="CH_EMPRESA" <%=strChecked%>>
			</td>
			<td>
				<acronym title="REFRESCAR">
					<input name="BT_REFRESCAR" type="button" id="BT_REFRESCAR" onClick="Refrescar();" value="REFRESCAR">
				</acronym>
			 </td>
			<td>

		   <input name="strCodCliente" type="hidden" value="<%=strCodCliente%>">
		   <input name="hdidCampana" type="hidden" value="<%=intCodCampana%>">
			  <input name="strRutDeudor" type="hidden" value="<%=strRutDeudor%>">
			  <input name="ANI" type="hidden" id="ANI" value="<%=ani%>">
			 </td>
			<td>
		</td>
	</tr>
</table>

<%


	strSql="SELECT IsNull(COUNT(DISTINCT RUTDEUDOR),0) as CRUT, IsNull(SUM(SALDO),0) as CSALDO FROM CUOTA WHERE CODCLIENTE = '" & strCodCliente & "' AND ESTADO_DEUDA = '1' AND SALDO > 0 "
	If Trim(intCodCampana) <> "0" Then
		strSql = strSql & " AND RUTDEUDOR IN (SELECT RUTDEUDOR FROM DEUDOR WHERE CODCLIENTE = '" & strCodCliente & "' AND IDCAMPANA = " & intCodCampana & ")"
	End if
	If UCASE(intSoloEmpresa)="ON" Then
		strSql = strSql & " AND CAST(SUBSTRING(RUTDEUDOR,1,LEN(RUTDEUDOR)-2) AS INT) > 50000000"
	End if
	'Response.write strSql
	'Response.eND

	AbrirScg()
	set rsDET= Conn.execute(strSql)
	if Not rsDET.eof Then
		intCrut = Trim(rsDET("CRUT"))
		intCsaldo = Trim(rsDET("CSALDO"))
	End if
	CerrarScg()


	strSql="SELECT IsNull(COUNT(DISTINCT RUTDEUDOR),0) as CRUT, IsNull(SUM(SALDO),0) as CSALDO FROM CUOTA WHERE CODCLIENTE = '" & strCodCliente & "'"
	If Trim(intCodCampana) <> "0" Then
		strSql = strSql & " AND RUTDEUDOR IN (SELECT RUTDEUDOR FROM DEUDOR WHERE CODCLIENTE = '" & strCodCliente & "' AND IDCAMPANA = " & intCodCampana & ")"
	End if
	If UCASE(intSoloEmpresa)="ON" Then
		strSql = strSql & " AND CAST(SUBSTRING(RUTDEUDOR,1,LEN(RUTDEUDOR)-2) AS INT) > 50000000"
	End if
	'Response.write strSql
	'Response.eND

	AbrirScg()
	set rsDET= Conn.execute(strSql)
	if Not rsDET.eof Then
		intCrutCampana = Trim(rsDET("CRUT"))
		intCsaldoCampana = Trim(rsDET("CSALDO"))
	End if
	CerrarScg()


	strSql="SELECT IsNull(COUNT(DISTINCT RUTDEUDOR),0) as CRUT, IsNull(SUM(SALDO),0) as CSALDO FROM CUOTA WHERE CODCLIENTE = '" & strCodCliente & "'"
	If Trim(intCodCampana) <> "0" Then
		strSql = strSql & " AND RUTDEUDOR IN (SELECT RUTDEUDOR FROM DEUDOR WHERE CODCLIENTE = '" & strCodCliente & "' AND IDCAMPANA = " & intCodCampana & ")"
	End if
	If UCASE(intSoloEmpresa)="ON" Then
		strSql = strSql & " AND CAST(SUBSTRING(RUTDEUDOR,1,LEN(RUTDEUDOR)-2) AS INT) >= 50000000"
	End if
	strSql = strSql & " AND (USUARIO_ASIG IS NULL OR USUARIO_ASIG = 0)"

	AbrirScg()
	set rsDET1= Conn.execute(strSql)
	'Response.write "<BR>strSql1="&strSql
	'Response.write "<BR>eof="& Not rsDET1.eof
	if Not rsDET1.eof Then
		'Response.write "<BR>DDD1="&rsDET1("CRUT")
		intCrutSA = Trim(rsDET1("CRUT"))
		intCsaldoSA = Trim(rsDET1("CSALDO"))
	End if
	CerrarScg()

	strSql="SELECT IsNull(COUNT(DISTINCT ID_USUARIO),0) as CUSUARIO FROM USUARIO WHERE ACTIVO = 1 AND (PERFIL_COB = 1 OR PERFIL_SUP = 1)"

	AbrirScg()
	set rsDET= Conn.execute(strSql)
	if Not rsDET.eof Then
		intTotalEjecutivo = Trim(rsDET("CUSUARIO"))
	End if
	CerrarScg()

	strSql="SELECT TOP 1 SUM(SALDO) AS MAXSALDO, RUTDEUDOR FROM CUOTA WHERE CODCLIENTE = '" & strCodCliente & "'"
	If Trim(intCodCampana) <> "0" Then
		strSql = strSql & " AND RUTDEUDOR IN (SELECT RUTDEUDOR FROM DEUDOR WHERE CODCLIENTE = '" & strCodCliente & "' AND IDCAMPANA = " & intCodCampana & ")"
	End if
	If UCASE(intSoloEmpresa)="ON" Then
		strSql = strSql & " AND CAST(SUBSTRING(RUTDEUDOR,1,LEN(RUTDEUDOR)-2) AS INT) > 50000000"
	End if
	strSql = strSql & " GROUP BY RUTDEUDOR ORDER BY SUM(SALDO) DESC"

	'Response.write "<br>strSql===" & strSql

	AbrirScg()
	set rsDET= Conn.execute(strSql)
	if Not rsDET.eof Then
		intMaxSaldo = Trim(rsDET("MAXSALDO"))
	End if
	CerrarScg()

	strSql="SELECT TOP 1 SUM(SALDO) AS MINSALDO, RUTDEUDOR FROM CUOTA WHERE CODCLIENTE = '" & strCodCliente & "'"
	If UCASE(intSoloEmpresa)="ON" Then
		strSql = strSql & " AND CAST(SUBSTRING(RUTDEUDOR,1,LEN(RUTDEUDOR)-2) AS INT) > 50000000"
	End if
	If Trim(intCodCampana) <> "0" Then
		strSql = strSql & " AND RUTDEUDOR IN (SELECT RUTDEUDOR FROM DEUDOR WHERE CODCLIENTE = '" & strCodCliente & "' AND IDCAMPANA = " & intCodCampana & ")"
	End if

	strSql = strSql & " GROUP BY RUTDEUDOR ORDER BY SUM(SALDO) ASC"

	AbrirScg()
	set rsDET= Conn.execute(strSql)
	if Not rsDET.eof Then
		intMinSaldo = Trim(rsDET("MINSALDO"))
	End if
	CerrarScg()

	strSql="SELECT SUM(SALDO)/COUNT(DISTINCT RUTDEUDOR) AS PROMSALDO FROM CUOTA WHERE CODCLIENTE = '" & strCodCliente & "'"
	If UCASE(intSoloEmpresa)="ON" Then
		strSql = strSql & " AND CAST(SUBSTRING(RUTDEUDOR,1,LEN(RUTDEUDOR)-2) AS INT) > 50000000"
	End if
	If Trim(intCodCampana) <> "0" Then
		strSql = strSql & " AND RUTDEUDOR IN (SELECT RUTDEUDOR FROM DEUDOR WHERE CODCLIENTE = '" & strCodCliente & "' AND IDCAMPANA = " & intCodCampana & ")"
	End if

	AbrirScg()
	set rsDET= Conn.execute(strSql)
	if Not rsDET.eof Then
		intPromSaldo = Trim(rsDET("PROMSALDO"))
	End if
	CerrarScg()




%>

<table width="800" border="1" ALIGN="CENTER">
	<tr>
		<td valign="top">
			<table width="780" border="0" ALIGN="CENTER">
				<tr bgcolor="#<%=session("COLTABBG")%>" class="Estilo13">
					<TD ALIGN="CENTER">
						GRABAR CAMPAÑA
					</TD>
					<TD ALIGN="LEFT">
						Nombre :
					</TD>
					<TD ALIGN="LEFT">
						<input name="TX_NOMCAMPANA" type="text" value="<%=strNombreCampana%>" size="20" maxlength="20" onchange="">
						<acronym title="ASIGNAR">
						<input name="BT_GC" type="button" onClick="Generar();" value="Gen.Campaña">
						<input name="BT_AC" type="button" onClick="AgregarCasos();" value="Agreg.Casos">
						<input name="BT_EC" type="button" onClick="EliminarCasos();" value="Elim.Casos">
						<input name="BT_ECA" type="button" onClick="EliminarCampana();" value="Elim.Campaña">
						</acronym>
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
					<input name="TX_DESCCAMPANA" type="text" value="<%=strDescCampana%>" size="50" maxlength="120" onchange="">
					</TD>
				</tr>
			</table>
		</TD>
	</tr
</table>

<table width="800" border="1" bordercolor="#FFFFFF" ALIGN="CENTER">
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

<table width="800" border="1" ALIGN="CENTER">
	<tr>
		<td valign="top">
			<table width="780" border="0" ALIGN="CENTER">
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
					<TD WIDTH="20%" ALIGN="CENTER">
						Rut Deuda Activa
					</TD>
					<TD WIDTH="20%" ALIGN="CENTER">
						Rut Campaña
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
					<TD WIDTH="20%" ALIGN="CENTER">
						<A HREF="cartera_asignada.asp?CB_CAMPANA=<%=intCodCampana%>">
							<%=FN(intCrut,0)%>
						</A>
					</TD>
					<TD WIDTH="20%" ALIGN="CENTER">
						<A HREF="cartera_asignada.asp?CB_CAMPANA=<%=intCodCampana%>">
							<%=FN(intCrutCampana,0)%>
						</A>
					</TD>
				</tr>
				<tr bgcolor="#<%=session("COLTABBG")%>" class="Estilo13">
					<TD WIDTH="20%" ALIGN="CENTER">
						Rut No Asignados
					</TD>
					<TD WIDTH="20%" ALIGN="CENTER">
						Monto No Asignados
					</TD>
					<TD WIDTH="20%" ALIGN="CENTER">
						Ejecutivos
					</TD>
					<TD WIDTH="20%" ALIGN="CENTER">
						Monto Total Deuda Activa
					</TD>
					<TD WIDTH="20%" ALIGN="CENTER">
						Monto Total Campaña
					</TD>
				</tr>
				<tr bordercolor="#999999">
					<TD ALIGN="CENTER">
						<%=FN(intCrutSA,0)%>
					</TD>
					<TD ALIGN="CENTER">
						$&nbsp;<%=FN(intCsaldoSA,0)%>
					</TD>
					<TD ALIGN="CENTER">
						<%=FN(intTotalEjecutivo,0)%>
					</TD>
					<TD ALIGN="CENTER">
						$&nbsp;<%=FN(intCsaldo,0)%>
					</TD>
					<TD ALIGN="CENTER">
						$&nbsp;<%=FN(intCsaldoCampana,0)%>
					</TD>
				</tr>
			</table>
 		</td>
	</tr>
</table>


<table width="800" border="1" ALIGN="CENTER">
	<tr>
		<td width="800" valign="top">
			<TABLE BORDER="0" ALIGN="CENTER">
				<tr bordercolor="#999999">
					<TD><input name="TX_COTA" type="text" value="<%=strCota%>" size="5" maxlength="5" onchange=""></TD>
					<TD><INPUT TYPE=Radio VALUE="1" NAME="OP_SEL"></TD>
					<td>Asignar solo casos sin asignacion</td>
					<TD><INPUT TYPE=Radio VALUE="2" NAME="OP_SEL"></TD>
					<td>Reasignar Todo</td>
					<TD><INPUT TYPE=Radio VALUE="3" NAME="OP_SEL"></TD>
					<TD>Eliminar Asignacion</td>
					<TD><input name="BT_ASIGNAR" type="button" onClick="Asignar();" value="Procesar"></TD>
				</tr>
			</TABLE>
 		</td>
 	</tr>
 	<tr>
		<td width="800" valign="top">
			<table width="800" border="0" ALIGN="CENTER">
				<TR BORDERCOLOR="#999999">
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
				strSql="SELECT * FROM USUARIO WHERE ACTIVO = 1 AND (PERFIL_COB = 1 OR PERFIL_SUP = 1)"
				set rsDET= Conn.execute(strSql)
				IntTotalMonto = 0
				IntTotalRut = 0
				do until rsDET.eof
					strNombre = Trim(rsDET("NOMBRES_USUARIO")) & " " & Trim(rsDET("APELLIDOS_USUARIO"))
					strNombre = UCASE(strNombre)

					%>

					<tr bordercolor="#999999">
					<TD><INPUT TYPE=checkbox NAME="CH_USUARIO" value="<%=rsDET("ID_USUARIO")%>"></TD>
					<td><div ALIGN="LEFT"><%=rsDET("ID_USUARIO")%> - <%=strNombre%></div></td>
					<%
					total_ValorCuota = total_ValorCuota + intValorCuota
					total_docs = total_docs + 1

					strSql="SELECT COUNT(DISTINCT RUTDEUDOR) AS CRUT, IsNull(SUM(SALDO),0) AS CMONTO FROM CUOTA WHERE CODCLIENTE = '" & strCodCliente & "'"
					If UCASE(intSoloEmpresa)="ON" Then
						strSql = strSql & " AND CAST(SUBSTRING(RUTDEUDOR,1,LEN(RUTDEUDOR)-2) AS INT) > 50000000"
					End if
					If Trim(intCodCampana) <> "" Then
						strSql = strSql & " AND RUTDEUDOR IN (SELECT RUTDEUDOR FROM DEUDOR WHERE CODCLIENTE = '" & strCodCliente & "' AND IDCAMPANA = " & intCodCampana & ")"
					End if
					strSql = strSql & " AND USUARIO_ASIG = " & rsDET("ID_USUARIO")

					''Response.write "strSql=" & strSql

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
	datos.action='genera_campanas.asp?Limpiar=1';
	datos.submit();
}

function Asignar(){
	//alert(datos.OP_SEL.value);
	datos.action='genera_campanas.asp?Asignar=1';
	datos.submit();
}

function Generar(){
	if (datos.CB_CAMPANA.value != '0') {
			alert('Debe ingresar Campaña NUEVA');
			datos.CB_CAMPANA.focus();
			return;
	}

	if (datos.TX_NOMCAMPANA.value == '') {
		alert('Debe ingresar Nombre Campaña');
		datos.TX_NOMCAMPANA.focus();
		return;
	}

	if (datos.TX_DESCCAMPANA.value == '') {
		alert('Debe ingresar descripcion Campaña');
		datos.TX_DESCCAMPANA.focus();
		return;
	}

	datos.CH_CAMPANA.value = 1;
	datos.action='genera_campanas.asp?Asignar=1idd';
	datos.submit();
}

function AgregarCasos(){
	if (datos.CB_CAMPANA.value == '0') {
			alert('Debe seleccionar campaña');
			datos.CB_CAMPANA.focus();
			return;
	}

	if (datos.TX_NOMCAMPANA.value == '') {
		alert('Debe ingresar Nombre Campaña');
		datos.TX_NOMCAMPANA.focus();
		return;
	}

	if (datos.TX_DESCCAMPANA.value == '') {
		alert('Debe ingresar descripcion Campaña');
		datos.TX_DESCCAMPANA.focus();
		return;
	}

	datos.action='genera_campanas.asp?AgregarCasos=1';
	datos.submit();
}

function EliminarCampana(){
	if (datos.CB_CAMPANA.value == '0') {
			alert('Debe seleccionar campaña');
			datos.CB_CAMPANA.focus();
			return;
	}

	if (datos.TX_NOMCAMPANA.value == '') {
		alert('Debe ingresar Nombre Campaña');
		datos.TX_NOMCAMPANA.focus();
		return;
	}

	if (datos.TX_DESCCAMPANA.value == '') {
		alert('Debe ingresar descripcion Campaña');
		datos.TX_DESCCAMPANA.focus();
		return;
	}

	datos.action='genera_campanas.asp?EliminarCampana=1';
	datos.submit();
}

function EliminarCasos(){
	if (datos.CB_CAMPANA.value == '0') {
			alert('Debe seleccionar campaña');
			datos.CB_CAMPANA.focus();
			return;
	}

	if (datos.TX_NOMCAMPANA.value == '') {
		alert('Debe seleccionar campaña');
		datos.TX_NOMCAMPANA.focus();
		return;
	}

	if (datos.TX_DESCCAMPANA.value == '') {
		alert('Debe seleccionar campaña');
		datos.TX_DESCCAMPANA.focus();
		return;
	}

	datos.action='genera_campanas.asp?EliminarCasos=1';
	datos.submit();
}

function Refrescar(){
	datos.CH_CAMPANA.value = ''
	datos.action='genera_campanas.asp?Refrescar=1';
	datos.submit();
}

</script>
