<%@ LANGUAGE="VBScript" %>
<html><head><title>PREPARANDO DATOS</title>
<br>
<br>
<div align="center"><img src="../images/cargando2.gif" width="148" height="108"></div>
<%
apellido=request.Form("apellido")
nombre=request.Form("nombre")
region=request.Form("region")
strEnlace="dir_tel_externo.asp?apellido=" & apellido & "&region=" & region & "&nombre=" & nombre
%>
</head>
</body>

</html>
<script language="JavaScript" type="text/JavaScript">
location.href="<%=Replace(strEnlace,"'","")%>"
</script>