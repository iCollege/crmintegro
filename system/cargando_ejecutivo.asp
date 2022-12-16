<%@ LANGUAGE="VBScript" %>
<html><head><title>PREPARANDO DATOS</title>
<br>
<br>
<div align="center"><img src="../images/cargando2.gif" width="148" height="108"></div>
<%
inicio=request.Form("inicio")
termino=request.Form("termino")
cliente=request.Form("cliente")
ejecutivo=request.Form("ejecutivo")
strEnlace="informe_recuperacion_e.asp?inicio=" & inicio & "&termino=" & termino & "&cliente=" & cliente & "&ejecutivo=" & ejecutivo
%>
</head>
</body>

</html>
<script language="JavaScript" type="text/JavaScript">
location.href="<%=Replace(strEnlace,"'","")%>"
</script>