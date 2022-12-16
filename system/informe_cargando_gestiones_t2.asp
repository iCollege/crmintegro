<%@ LANGUAGE="VBScript" %>
<html><head><title>PREPARANDO DATOS</title>
<br>
<br>
<div align="center"><img src="../images/cargando2.gif" width="148" height="108"></div>
<%
inicio=request.Form("inicio")
termino=request.Form("termino")
cliente=request.Form("cliente")
ejecutivo= request.Form("ejecutivo")
sucursal=request.form("sucursal")
hora=request.Form("hora")
strEnlace="informe_gestiones_terreno.asp?inicio=" & inicio & "&termino=" & termino & "&cliente=" & cliente & "&sucursal=" & sucursal & "&ejecutivo=" &ejecutivo & "&hora=" & hora
%>
</head>
</body>

</html>
<script language="JavaScript" type="text/JavaScript">
location.href="<%=Replace(strEnlace,"'","")%>"
</script>