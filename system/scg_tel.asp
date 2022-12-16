<% @LCID = 1034 %>
<!--#include file="arch_utils.asp"-->
<!--#include file="../lib/comunes/rutinas/funciones.inc" -->
<!--#include file="lib.asp"-->
<title>EMPRESA S.A.</title>

<%
codarea=UCASE(LTRIM(RTRIM(request.Form("codarea"))))
numero=LTRIM(RTRIM(request.form("numero")))
rut = request.FORM("rut")
abrirscg()
ssql="EXEC SCG_WEB_NUEVO_TEL '"&rut&"','"&codarea&"','"&numero&"','"&session("session_login")&"'"
Conn.execute(ssql)
cerrarscg()

strEnlace="mas_telefonos.asp?rut=" & rut
%>
<script language="JavaScript" type="text/JavaScript">
location.href="<%=Replace(strEnlace,"'","")%>"
</script>
