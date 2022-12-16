<%@ LANGUAGE = "VBScript" %>
<% ' Capa 1 ' %>
<!--#include file="asp/comunes/odbc/AdoVbs.inc"-->
<!--#include file="sesion.asp"-->


<%
	IntId= session("ses_codcli")
%>

<HTML>
<HEAD><TITLE>Mantenedor de Clientes</TITLE>
<LINK rel="stylesheet" TYPE="text/css" HREF="isk_style.css">
</HEAD>
<link href="style.css" rel="Stylesheet">

<BODY BGCOLOR='FFFFFF'>


<table width="850" border="0">
  <tr>
    <td colspan =2 bordercolor="#999999"  bgcolor="#<%=session("COLTABBG")%>" class="Estilo13" ALIGN="CENTER">BIBLIOTECA CLIENTES</td>
  </tr>

<%
	intCorrelativo = 0
	VarPath=  Server.mapPath("UploadFolder") & "\" & IntId
	Set Obj_FSO = createobject("scripting.filesystemobject")
	Set Obj_Directorio = Obj_FSO.GetFolder (VarPath)
	For Each VarFichero IN Obj_Directorio.Files
	VarContador = VarContador + 1
	Set Obj_File = Obj_FSO.GetFile(VarFichero)
	VarNombreFichero = VarFichero.Name
	intCorrelativo = intCorrelativo + 1
%>
<tr bgcolor="#<%=session("COLTABBG2")%>" class="Estilo8">
	<td>
		Archivo Nro. <%=intCorrelativo%>
	</td>
	<td>
	<a href="UploadFolder/<%=IntId%>/<%=VarNombreFichero%>"><%=VarNombreFichero%></a>
	</td>
</tr>
<%
	Next
%>
</table>

</FORM>
  </TD>
    </TR>
</TABLE>

</BODY>
</HTML>




