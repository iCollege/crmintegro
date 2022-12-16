<%@ LANGUAGE="VBScript" %>
<!--#include file="sesion.asp"-->
<%
strRut=Request("strRut")
%>

<HTML>

<HEAD><TITLE>Menú</TITLE>
<LINK rel="stylesheet" TYPE="text/css" HREF="isk_style.css">
</HEAD>

<BODY>

<TABLE ALIGN="CENTER" BORDER=0 CELLSPACING=0 CELLPADDING=0 WIDTH="600" CLASS="tabla1">
<TR HEIGHT="30">
	<TD align="CENTER">
		VISOR DOCUMENTOS
    </TD>
</TR>
</TABLE>

<table ALIGN="CENTER" WIDTH="600" border="0" CLASS="tabla1">
<tr BGCOLOR="#FFFFFF">
	<td class="hdr_i" width="21">
		<img src='../images/boton_no_1.gif' align='absmiddle'>
	</td>
	<td class="hdr_i" width="200">
		Documentos Rut : <%=strRut%>
	</td>
	<td class="hdr" width="21">
		<img src='../images/cuadrado_t1.gif' align='absmiddle'>
	</td>
	<td class="hdr_i" width="300">
		<A HREF="../expedientes/<%=session("ses_codcli")%>/<%=strRut%>/documento1.pdf">
			Documento 1
		</A>
	</td>
</tr>

<tr BGCOLOR="#FFFFFF">
	<td class="hdr_i" width="21">
		&nbsp
	</td>
	<td class="hdr_i" width="100">
		&nbsp
	</td>
	<td class="hdr" width="21">
		<img src='../images/cuadrado_t1.gif' align='absmiddle'>
	</td>
	<td class="hdr_i" width="300">
		<A HREF="../expedientes/<%=session("ses_codcli")%>/<%=strRut%>/documento2.pdf">
			Documento 2
		</A>
	</td>
</tr>



<tr BGCOLOR="#FFFFFF">
	<td colspan=4 class="hdr_i" >
		&nbsp
	</td>
</tr>

</Table>

