<%@ LANGUAGE="VBScript" %>

<% ' Capa 1 ' %>
<!--#include file="asp/comunes/odbc/ADOVBS.INC" -->
<!--#include file="arch_utils.asp"-->
<!--#include file="asp/comunes/odbc/insertUpdate.inc"-->
<!--#include file="asp/comunes/odbc/ObtenerRecordset.inc"-->

<% ' Capa 2 ' %>
<!--#include file="asp/comunes/insert/Remesa.inc"-->
<!--#include file="asp/comunes/recordset/Remesa.inc"-->
<!--#include file="asp/comunes/general/funciones.inc"-->
<%

AbrirSCG()

If Request("strFormMode") = "Nuevo" Then
	If Trim(request("CODREMESA")) <> "" AND Trim(request("CODCLIENTE")) <> "" Then
		recordset_Remesa Conn, srsRegistro, request("CODREMESA"), request("CODCLIENTE")
		If Not srsRegistro.EOF Then
			Response.Write "<P>Ya existe un registro con el código de asignacion : " &  request("CODREMESA")& " y codigo de cliente : " & request("CODCLIENTE")
			Response.Write "<P>Debe asignarle otro código si desea crear un registro nuevo"
			Response.Write "<FORM><INPUT VALUE=Volver TYPE=BUTTON onClick='javascript:history.back()'></FORM>"
			Response.End
		End If
	End If
End If
'Response.write "hola"
'Response.write "CB_BANCO" & request("CB_BANCO")
'Response.End

Set dicRemesa = CreateObject("Scripting.Dictionary")
dicRemesa.Add "CODREMESA", request("CODREMESA")
dicRemesa.Add "CODCLIENTE", request("CODCLIENTE")
dicRemesa.Add "NOMBRE", ValNulo(request("NOMBRE"),"C")
dicRemesa.Add "DESCRIPCION", ValNulo(request("DESCRIPCION"),"C")
dicRemesa.Add "FECHA_LLEGADA", ValNulo(request("FECHA_LLEGADA"),"C")
dicRemesa.Add "FECHA_CARGA", ValNulo(request("FECHA_CARGA"),"C")
dicRemesa.Add "ACTIVO", ValNulo(request("ACTIVO"),"N")

insert_Remesa Conn, dicRemesa

CerrarSCG()
Response.Redirect "man_Remesa.asp"
%>
