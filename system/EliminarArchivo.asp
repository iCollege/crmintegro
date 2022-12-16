<%@ LANGUAGE = "VBScript" %>
<!--#include file="asp/comunes/General/MostrarRegistro.inc"-->
<!--#include file="asp/comunes/general/JavaEfectoBotones.inc"-->
<!--#include file="asp/comunes/general/rutinasTraeCampo.inc"-->

<% ' Capa 1 ' %>
<!--#include file="asp/comunes/odbc/AdoVbs.inc"-->
<!--#include file="arch_utils.asp"-->

<%

	'IntId= request("IntId")
	IntId= session("ses_codcli")

    strRut= Request("strRut")
    VarNombreFichero=request("VarNombreFichero")

	Dim DestinationPath
    DestinationPath = Server.mapPath("UploadDoc") & "\" & strRut  & "\" & VarNombreFichero

	'Response.write "DestinationPath" & DestinationPath
	'response.End

	dim fs
    Set fs = Server.CreateObject("Scripting.FileSystemObject")
    if fs.FileExists(DestinationPath) then fs.DeleteFile(DestinationPath)
    Set fs = Nothing

 
	Response.Redirect "biblioteca_deudores.asp?strRut=" & strRut


%>