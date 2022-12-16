<% @LCID = 1034 %>
<!--#include file="../lib/comunes/bdatos/ConectarSCG_R.inc"-->
<!--#include file="../lib/comunes/bdatos/ConectarCA.inc"-->
<!--#include file="../lib/comunes/rutinas/funciones.inc" -->
<!--#include file="lib.asp"-->

<%
apellido= request.querystring("apellido")
nombre= request.querystring("nombre")
region=request.querystring("region")
%>
<title>M&Oacute;DULO DE B&Uacute;SQUEDA</title>

<style type="text/css">
<!--
.Estilo37 {color: #FFFFFF}
-->
</style>
<form name="datos" method="post">
<table width="851" height="420" border="0">
  <tr>
    <td width="845" height="20" class="Estilo20"><img src="../lib/TITULO_busqueda.gif" width="740" height="22"></td>
  </tr>
  <tr>
    <td height="242" valign="top" background="../images/fondo_coventa.jpg">
	<BR>
	<table width="100%" border="0">
      <tr bgcolor="#<%=session("COLTABBG")%>" class="Estilo13">
        <td width="28%">REGION</td>
        <td width="13%">NOMBRE</td>
        <td width="59%">APELLIDO</td>
        </tr>
      <tr>
        <td><select name="region">
          <option value="14" <%if region="14" then response.Write("Selected") End if%>>SOLO REGIONES</option>
		  <option value="13" <%if region="13" then response.Write("Selected") End if%>>METROPOLITANA</option>
        </select></td>
        <td><input name="nombre" type="text" id="nombre" value="<%=nombre%>" size="15" maxlength="30"></td>
        <td><input name="apellido" type="text" id="apellido" value="<%=apellido%>" size="15" maxlength="30">&nbsp;&nbsp;&nbsp;
          <input type="button" name="Submit" value="Buscar" onClick="envia();">
          &nbsp;&nbsp;&nbsp;
<input type="button" name="Submit" value="Limpiar" onClick="window.navigate('dir_tel_externo.asp');">
&nbsp;&nbsp;&nbsp;
<input type="button" name="Submit" value="Guardar Cambios" onClick="rutea();"></td>
        </tr>
    </table>
	<% if not apellido="" then%>
	<%
	if region="14" then
		ssql="SELECT NOMBRE,DIRECCION,NUMERO,RESTO,COMUNA,FONO,RUT FROM ESPECIALIZA.DBO.REFERENCIA WHERE NOMBRE LIKE '%"&apellido&"%' and NOMBRE LIKE '%"&nombre&"%' AND REGION <> '13'"
	else
		ssql="SELECT NOMBRE,DIRECCION,NUMERO,RESTO,COMUNA,FONO,RUT FROM ESPECIALIZA.DBO.REFERENCIA WHERE NOMBRE LIKE '%"&apellido&"%' and NOMBRE LIKE '%"&nombre&"%' AND REGION = '"&region&"'"
	end if
	set rsBU=ConexionES.execute(ssql)
	if not rsBU.eof then
	%>

	<BR><BR>
	  <strong>RESULTADO DE LA B&Uacute;SQUEDA </strong><BR>
	  <BR>
	  <table width="100%"  border="0">
        <tr bgcolor="#<%=session("COLTABBG")%>">
          <td width="30%"><span class="Estilo37">NOMBRE</span></td>
          <td width="17%"><span class="Estilo37">CALLE</span></td>
          <td width="6%"><span class="Estilo37">NUMERO</span></td>
          <td width="11%"><span class="Estilo37">RESTO</span></td>
          <td width="13%"><span class="Estilo37">COMUNA</span></td>
          <td width="13%"><span class="Estilo37">TELEFONO</span></td>
          <td width="10%"><span class="Estilo37">RUT</span></td>
        </tr>
		<%
		Do until rsBU.eof
		%>
        <tr>
          <td><%=rsBU("NOMBRE")%></td>
          <td><%=rsBU("DIRECCION")%></td>
          <td><%=rsBU("NUMERO")%></td>
          <td><%=rsBU("RESTO")%></td>
          <td><%=rsBU("COMUNA")%></td>
          <td><%=rsBU("FONO")%> </td>
          <td><input name="rut<%=rsBU("FONO")%>" type="text" id="rut<%=rsBU("FONO")%>" value="<%=rsBU("RUT")%>" size="10" maxlength="10"></td>
        </tr>
		<%
		rsBU.movenext
		loop
		%>
      </table></td>
  </tr>
</table>

<%
else
response.Write("NO SE ENCONTRARON COINCIDENCIAS")
end if
rsBU.close
set rsBU=nothing
%>
<%end if%>
</form>

<script language="JavaScript1.2">
function envia(){
if((datos.nombre.value=='')&&(datos.apellido.value=='')){
alert('DEBE AL MENOS 1 TOPICO DE BÚSQUEDA');
}else{
datos.action='cargando_dir_tel.asp';
datos.submit();
}
}

function rutea(){
datos.action='guarda_rut.asp';
datos.submit();
}

</script>
