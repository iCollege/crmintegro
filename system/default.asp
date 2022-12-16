<% @LCID = 1034 %>
<HTML>
<!--#include file="sesion_inicio.asp"-->
<%
If Trim(request("HD_CLIENTE")) <> "" Then
	session("ses_codcli")=request("HD_CLIENTE")
End If
%>
<TITLE>SISTEMA DE COBRANZA</TITLE>
 <FRAMESET cols="*,1160,*" frameborder="NO" border="0" framespacing="0">
	<FRAME src="blank.html" SCROLLING="NO" NORESIZE MARGINWIDTH='0' MARGINHEIGHT='0' BORDER='0'>
  <FRAMESET rows="70,*" frameborder="NO" border="0" framespacing="0">
        <frame NAME='topFrame' SRC='top.asp?EmpresaId=3'  SCROLLING="NO" NORESIZE MARGINWIDTH='0' MARGINHEIGHT='0' BORDER='0'>
        <FRAME NAME='Contenido' SRC='principal.asp?EmpresaId=3' SCROLLING='AUTO' NORESIZE MARGINWIDTH='0' MARGINHEIGHT='0' BORDER='0'>
  </FRAMESET>
  <FRAME src="blank.html" SCROLLING="NO" NORESIZE MARGINWIDTH='0' MARGINHEIGHT='0' BORDER='0'>
</FRAMESET>

</HTML>