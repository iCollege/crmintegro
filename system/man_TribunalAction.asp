<%@ LANGUAGE="VBScript" %>

<% ' Capa 1 ' %>
<!--#include file="asp/comunes/odbc/ADOVBS.INC" -->
<!--#include file="arch_utils.asp"-->
<!--#include file="asp/comunes/odbc/insertUpdate.inc"-->
<!--#include file="asp/comunes/odbc/ObtenerRecordset.inc"-->

<% ' Capa 2 ' %>
<!--#include file="asp/comunes/insert/Tribunal.inc"-->
<!--#include file="asp/comunes/recordset/Tribunal.inc"-->
<!--#include file="asp/comunes/general/funciones.inc"-->
<%

AbrirSCG()

If Request("strFormMode") = "Nuevo" Then
	If Trim(request("IDTRIBUNAL")) <> "" Then
		recordset_Tribunal Conn, srsRegistro, request("IDTRIBUNAL")
		If Not srsRegistro.EOF Then
			Response.Write "<P>Ya existe un registro con el código " &  request("IDTRIBUNAL")
			Response.Write "<P>Debe asignarle otro código si desea crear un registro nuevo"
			Response.Write "<FORM><INPUT VALUE=Volver TYPE=BUTTON onClick='javascript:history.back()'></FORM>"
			Response.End
		End If
	End If
End If
'Response.write "hola"
'Response.write "CB_BANCO" & request("CB_BANCO")
'Response.End

Set dicTribunal = CreateObject("Scripting.Dictionary")
dicTribunal.Add "IDTRIBUNAL", request("IDTRIBUNAL")
dicTribunal.Add "NOMTRIBUNAL", ValNulo(request("NOMTRIBUNAL"),"C")
dicTribunal.Add "RECEPTOR", ValNulo(request("RECEPTOR"),"C")
dicTribunal.Add "DIRECCION", ValNulo(request("DIRECCION"),"C")
dicTribunal.Add "COMUNA", ValNulo(request("COMUNA"),"C")
dicTribunal.Add "FONO1", ValNulo(request("FONO1"),"C")
dicTribunal.Add "FONO2", ValNulo(request("FONO2"),"C")
dicTribunal.Add "ACTIVO", ValNulo(request("ACTIVO"),"C")

insert_Tribunal Conn, dicTribunal

CerrarSCG()
Response.Redirect "man_Tribunal.asp"
%>
