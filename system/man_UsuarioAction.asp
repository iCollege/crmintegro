<%@ LANGUAGE="VBScript" %>

<% ' Capa 1 ' %>
<!--#include file="asp/comunes/odbc/ADOVBS.INC" -->
<!--#include file="arch_utils.asp"-->
<!--#include file="sesion.asp"-->
<!--#include file="asp/comunes/odbc/insertUpdate.inc"-->
<!--#include file="asp/comunes/odbc/ObtenerRecordset.inc"-->

<% ' Capa 2 ' %>
<!--#include file="asp/comunes/insert/Usuario.inc"-->
<!--#include file="asp/comunes/recordset/Usuario.inc"-->
<!--#include file="asp/comunes/general/funciones.inc"-->
<%

AbrirSCG()

If Request("strFormMode") = "Nuevo" Then
	If Trim(request("ID_USUARIO")) <> "" Then
		recordset_Usuario Conn, srsRegistro, request("ID_USUARIO")
		If Not srsRegistro.EOF Then
			Response.Write "<P>Ya existe un registro con el código " &  request("ID_USUARIO")
			Response.Write "<P>Debe asignarle otro código si desea crear un registro nuevo"
			Response.Write "<FORM><INPUT VALUE=Volver TYPE=BUTTON onClick='javascript:history.back()'></FORM>"
			Response.End
		End If
	End If
End If
'Response.write "hola"
'Response.write "CB_BANCO" & request("CB_BANCO")
'Response.End

Set dicUsuario = CreateObject("Scripting.Dictionary")
dicUsuario.Add "ID_USUARIO", request("ID_USUARIO")
dicUsuario.Add "RUT_USUARIO", ValNulo(request("RUT_USUARIO"),"C")
dicUsuario.Add "NOMBRES_USUARIO", ValNulo(request("NOMBRES_USUARIO"),"C")
dicUsuario.Add "APELLIDOS_USUARIO", ValNulo(request("APELLIDOS_USUARIO"),"C")
dicUsuario.Add "PERFIL", ValNulo(request("PERFIL"),"C")
dicUsuario.Add "LOGIN", ValNulo(request("LOGIN"),"C")
dicUsuario.Add "CLAVE", ValNulo(request("CLAVE"),"C")
dicUsuario.Add "PERFIL_ADM", ValNulo(request("PERFIL_ADM"),"N")
dicUsuario.Add "PERFIL_COB", ValNulo(request("PERFIL_COB"),"N")
dicUsuario.Add "PERFIL_SUP", ValNulo(request("PERFIL_SUP"),"N")
dicUsuario.Add "PERFIL_CAJA", ValNulo(request("PERFIL_CAJA"),"N")
dicUsuario.Add "PERFIL_PROC", ValNulo(request("PERFIL_PROC"),"N")
dicUsuario.Add "PERFIL_FULL", ValNulo(request("PERFIL_FULL"),"N")
dicUsuario.Add "PERFIL_EMP", ValNulo(request("PERFIL_EMP"),"N")

dicUsuario.Add "ACTIVO", ValNulo(request("ACTIVO"),"N")

insert_Usuario Conn, dicUsuario


If Request("strFormMode") <> "Nuevo" Then

	strSql = "DELETE FROM USUARIO_CLIENTE WHERE ID_USUARIO = " & request("ID_USUARIO")
	set rsBorra= Conn.execute(strSql)

	strSql = "SELECT CODCLIENTE FROM CLIENTE WHERE ACTIVO = 1"

	Response.write "strSql=" & strSql

	set rsEmpresa= Conn.execute(strSql)

	Do While not rsEmpresa.Eof
		strObjeto = "CH_CLIENTE_" & rsEmpresa("CODCLIENTE")
		strValorObjeto = Request(strObjeto)

		'Response.write "<br>strObjeto=" & strObjeto
		'Response.write "<br>strValorObjeto=" & UCASE(strValorObjeto)

		If UCASE(strValorObjeto) = "ON" Then
			strSql = "INSERT INTO USUARIO_CLIENTE (ID_USUARIO, CODCLIENTE) "
			strSql = strSql & "VALUES (" & request("ID_USUARIO") & "," & rsEmpresa("CODCLIENTE") & ")"
			set rsInserta= Conn.execute(strSql)
		End if

		intCorr = intCorr + 1
		rsEmpresa.movenext
	Loop

End if

CerrarSCG()
Response.Redirect "man_Usuario.asp"
%>
