<%@ LANGUAGE="VBScript" %>
<html><head><title>PREPARANDO DATOS</title>
<br>
<br>
<div align="center"><img src="../images/cargando2.gif" width="148" height="108"></div>
<%
ejecutivo=request.Form("ejecutivo")
cliente=request.Form("cliente")
remesa=request.Form("remesa")
strEnlace="asignacion_e_xls.asp?cliente=" & cliente & "&ejecutivo=" & ejecutivo & "&remesa=" & remesa
%>
</head>
</body>

</html>
<script language="JavaScript" type="text/JavaScript">
location.href="<%=Replace(strEnlace,"'","")%>"
</script>