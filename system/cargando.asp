<%@ LANGUAGE="VBScript" %>
<html><head><title>PREPARANDO DATOS</title>
<br>
<br>
<div align="center"><img src="../images/cargando2.gif" ></div>
<%
inicio=request.Form("inicio")
termino=request.Form("termino")
cliente=request.Form("cliente")
strEnlace="mi_recupero.asp?inicio=" & inicio & "&termino=" & termino & "&cliente=" & cliente
%>
</head>
</body>

</html>
<script language="JavaScript" type="text/JavaScript">
location.href="<%=Replace(strEnlace,"'","")%>"
</script>