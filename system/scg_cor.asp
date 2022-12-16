<% @LCID = 1034 %>
<!--#include file="arch_utils.asp"-->
<!--#include file="../lib/comunes/rutinas/funciones.inc" -->
<!--#include file="lib.asp"-->
<title>EMPRESA S.A.</title>

<%
MAIL=UCASE(LTRIM(RTRIM(request.Form("EMAIL"))))
rut = request.FORM("rut")
abrirscg()
ssql="execute SCG_WEB_NUEVO_COR '"&rut&"','"&MAIL&"','"&session("session_login")&"'"
''Response.write "ssql="& ssql
Conn.execute(ssql)
cerrarscg()

strEnlace="mas_correos.asp?rut=" & rut
%>
<script language="JavaScript" type="text/JavaScript">
location.href="<%=Replace(strEnlace,"'","")%>"
</script>
