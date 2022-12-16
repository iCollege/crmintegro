<% @LCID = 1034 %>
<!--#include file="arch_utils.asp"-->
<!--#include file="../lib/comunes/rutinas/funciones.inc" -->
<!--#include file="lib.asp"-->
<%
calle=UCASE(LTRIM(RTRIM(request.Form("calle"))))
numero=LTRIM(RTRIM(request.form("numero")))
resto=UCASE(LTRIM(RTRIM(request.Form("resto"))))
if resto="" then
resto=" "
end if
comuna=request.Form("comuna")
rut = request.FORM("rut")

abrirscg()
ssql="execute SCG_WEB_NUEVA_DIR '"&rut&"','"&calle&"','"&numero&"','"&resto&"','"&comuna&"','"&session("session_login")&"'"
Conn.execute(ssql)
cerrarscg()

strEnlace="principal.asp?rut=" & rut
%>
<script language="JavaScript" type="text/JavaScript">
location.href="<%=Replace(strEnlace,"'","")%>"
</script>
