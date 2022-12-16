<%@ LANGUAGE="VBScript" %>
<html><head><title>PREPARANDO DATOS</title>
<br>
<br>
<div align="center"><img src="../images/cargando2.gif" width="148" height="108"></div>
<%
inicio=request.Form("inicio")
termino=request.Form("termino")
cliente=request.Form("cliente")
sucursal=request.Form("sucursal")

if sucursal="" then
inicio=request.QueryString("inicio")
termino=request.QueryString("termino")
cliente=request.QueryString("cliente")
sucursal=request.QueryString("sucursal")


end if

strEnlace="informe_recupero_terreno.asp?inicio=" & inicio & "&termino=" & termino & "&cliente=" & cliente & "&sucursal=" & sucursal
%>
</head>
</body>

</html>
<script language="JavaScript" type="text/JavaScript">
location.href="<%=Replace(strEnlace,"'","")%>"
</script>