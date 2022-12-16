<% @LCID = 1034 %>
<!--#include file="../lib/comunes/bdatos/ConectarCA.inc"-->
<!--#include file="../lib/comunes/rutinas/funciones.inc" -->
<div align="center"><img src="../images/cargando2.gif">
  
  <%
apellido=request.Form("apellido")
nombre=request.Form("nombre")
region=request.Form("region")

	if region="14" then
	ssql="SELECT NOMBRE,DIRECCION,NUMERO,RESTO,COMUNA,FONO,RUT FROM ESPECIALIZA.DBO.REFERENCIA WHERE NOMBRE LIKE '%"&apellido&"%' and NOMBRE LIKE '%"&nombre&"%' AND REGION <> '13'"
	else
	ssql="SELECT NOMBRE,DIRECCION,NUMERO,RESTO,COMUNA,FONO,RUT FROM ESPECIALIZA.DBO.REFERENCIA WHERE NOMBRE LIKE '%"&apellido&"%' and NOMBRE LIKE '%"&nombre&"%' AND REGION = '"&region&"'"
	end if
set rsAU=conexionES.execute(ssql)
if not rsAU.eof then
	do until rsAU.eof
	
	dato="rut"+CSTR(rsAU("FONO"))
	rutcicito=request.Form(dato)
	If not ltrim(rtrim(rutcicito))="" then
	ssql2="UPDATE REFERENCIA SET RUT='"&rutcicito&"' WHERE FONO='"&rsAU("FONO")&"'"
	conexionES.execute(ssql2)
	%>
	  <br>
  <%	end if
	
	rsAU.movenext
	loop
end if
rsAU.close
set rsAU=Nothing
%>
  </head>
</div>
</body>
</html>
<script language="JavaScript" type="text/JavaScript">
alert('INFORMACION GUARDADA');
window.navigate('dir_tel_externo.asp');
</script>

