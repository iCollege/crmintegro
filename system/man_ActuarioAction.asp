<%@ LANGUAGE="VBScript" %>

<% ' Capa 1 ' %>
<!--#include file="asp/comunes/odbc/ADOVBS.INC" -->
<!--#include file="arch_utils.asp"-->
<!--#include file="asp/comunes/odbc/insertUpdate.inc"-->
<!--#include file="asp/comunes/odbc/ObtenerRecordset.inc"-->

<% ' Capa 2 ' %>
<!--#include file="asp/comunes/insert/Actuario.inc"-->
<!--#include file="asp/comunes/recordset/Actuario.inc"-->
<!--#include file="asp/comunes/general/funciones.inc"-->
<%

AbrirSCG()

If Request("strFormMode") = "Nuevo" Then
	If Trim(request("IDACTUARIO")) <> "" Then
		recordset_Actuario Conn, srsRegistro, request("IDACTUARIO")
		If Not srsRegistro.EOF Then
			Response.Write "<P>Ya existe un registro con el código " &  request("IDACTUARIO")
			Response.Write "<P>Debe asignarle otro código si desea crear un registro nuevo"
			Response.Write "<FORM><INPUT VALUE=Volver TYPE=BUTTON onClick='javascript:history.back()'></FORM>"
			Response.End
		End If
	End If
End If
'Response.write "hola"
'Response.write "CB_BANCO" & request("CB_BANCO")
'Response.End

Set dicActuario = CreateObject("Scripting.Dictionary")
dicActuario.Add "IDACTUARIO", request("IDACTUARIO")
dicActuario.Add "NOMACTUARIO", ValNulo(request("NOMACTUARIO"),"C")
dicActuario.Add "COD_INTERNO", ValNulo(request("COD_INTERNO"),"C")
dicActuario.Add "ACTIVO", ValNulo(request("ACTIVO"),"C")

insert_Actuario Conn, dicActuario

CerrarSCG()
Response.Redirect "man_Actuario.asp"
%>
