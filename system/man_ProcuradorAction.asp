<%@ LANGUAGE="VBScript" %>

<% ' Capa 1 ' %>
<!--#include file="asp/comunes/odbc/ADOVBS.INC" -->
<!--#include file="arch_utils.asp"-->
<!--#include file="asp/comunes/odbc/insertUpdate.inc"-->
<!--#include file="asp/comunes/odbc/ObtenerRecordset.inc"-->

<% ' Capa 2 ' %>
<!--#include file="asp/comunes/insert/Procurador.inc"-->
<!--#include file="asp/comunes/recordset/Procurador.inc"-->
<!--#include file="asp/comunes/general/funciones.inc"-->
<%

AbrirSCG()

If Request("strFormMode") = "Nuevo" Then
	If Trim(request("IDPROCURADOR")) <> "" Then
		recordset_procurador Conn, srsRegistro, request("IDPROCURADOR")
		If Not srsRegistro.EOF Then
			Response.Write "<P>Ya existe un registro con el código " &  request("IDPROCURADOR")
			Response.Write "<P>Debe asignarle otro código si desea crear un registro nuevo"
			Response.Write "<FORM><INPUT VALUE=Volver TYPE=BUTTON onClick='javascript:history.back()'></FORM>"
			Response.End
		End If
	End If
End If
'Response.write "hola"
'Response.write "CB_BANCO" & request("CB_BANCO")
'Response.End

Set dicProcurador = CreateObject("Scripting.Dictionary")
dicProcurador.Add "IDPROCURADOR", request("IDPROCURADOR")
dicProcurador.Add "NOMPROCURADOR", ValNulo(request("NOMPROCURADOR"),"C")
dicProcurador.Add "ACTIVO", ValNulo(request("ACTIVO"),"C")

insert_Procurador Conn, dicProcurador

CerrarSCG()
Response.Redirect "man_procurador.asp"
%>
