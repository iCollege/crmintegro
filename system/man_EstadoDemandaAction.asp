<%@ LANGUAGE="VBScript" %>

<% ' Capa 1 ' %>
<!--#include file="asp/comunes/odbc/ADOVBS.INC" -->
<!--#include file="arch_utils.asp"-->
<!--#include file="asp/comunes/odbc/insertUpdate.inc"-->
<!--#include file="asp/comunes/odbc/ObtenerRecordset.inc"-->

<% ' Capa 2 ' %>
<!--#include file="asp/comunes/insert/EstadoDemanda.inc"-->
<!--#include file="asp/comunes/recordset/EstadoDemanda.inc"-->
<!--#include file="asp/comunes/general/funciones.inc"-->
<%

AbrirSCG()

If Request("strFormMode") = "Nuevo" Then
	If Trim(request("IDESTADODEMANDA")) <> "" Then
		recordset_EstadoDemanda Conn, srsRegistro, request("IDESTADODEMANDA")
		If Not srsRegistro.EOF Then
			Response.Write "<P>Ya existe un registro con el código " &  request("IDESTADODEMANDA")
			Response.Write "<P>Debe asignarle otro código si desea crear un registro nuevo"
			Response.Write "<FORM><INPUT VALUE=Volver TYPE=BUTTON onClick='javascript:history.back()'></FORM>"
			Response.End
		End If
	End If
End If
'Response.write "hola"
'Response.write "CB_BANCO" & request("CB_BANCO")
'Response.End

Set dicEstadoDemanda = CreateObject("Scripting.Dictionary")
dicEstadoDemanda.Add "IDESTADODEMANDA", request("IDESTADODEMANDA")
dicEstadoDemanda.Add "NOMESTADODEMANDA", ValNulo(request("NOMESTADODEMANDA"),"C")
dicEstadoDemanda.Add "ACTIVO", ValNulo(request("ACTIVO"),"C")

insert_EstadoDemanda Conn, dicEstadoDemanda

CerrarSCG()
Response.Redirect "man_EstadoDemanda.asp"
%>
