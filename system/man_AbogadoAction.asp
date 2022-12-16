<%@ LANGUAGE="VBScript" %>

<% ' Capa 1 ' %>
<!--#include file="asp/comunes/odbc/ADOVBS.INC" -->
<!--#include file="arch_utils.asp"-->
<!--#include file="asp/comunes/odbc/insertUpdate.inc"-->
<!--#include file="asp/comunes/odbc/ObtenerRecordset.inc"-->

<% ' Capa 2 ' %>
<!--#include file="asp/comunes/insert/Abogado.inc"-->
<!--#include file="asp/comunes/recordset/Abogado.inc"-->
<!--#include file="asp/comunes/general/funciones.inc"-->
<%

AbrirSCG()

If Request("strFormMode") = "Nuevo" Then
	If Trim(request("IDABOGADO")) <> "" Then
		recordset_abogado Conn, srsRegistro, request("IDABOGADO")
		If Not srsRegistro.EOF Then
			Response.Write "<P>Ya existe un registro con el código " &  request("IDABOGADO")
			Response.Write "<P>Debe asignarle otro código si desea crear un registro nuevo"
			Response.Write "<FORM><INPUT VALUE=Volver TYPE=BUTTON onClick='javascript:history.back()'></FORM>"
			Response.End
		End If
	End If
End If
'Response.write "hola"
'Response.write "CB_BANCO" & request("CB_BANCO")
'Response.End

Set dicAbogado = CreateObject("Scripting.Dictionary")
dicAbogado.Add "IDABOGADO", request("IDABOGADO")
dicAbogado.Add "NOMABOGADO", ValNulo(request("NOMABOGADO"),"C")
dicAbogado.Add "ACTIVO", ValNulo(request("ACTIVO"),"C")

insert_abogado Conn, dicAbogado

CerrarSCG()
Response.Redirect "man_abogado.asp"
%>
