<% @LCID = 1034 %>
<!--#include file="arch_utils.asp"-->
<!--#include file="../lib/comunes/rutinas/funciones.inc" -->
<!--#include file="lib.asp"-->
<%
rut = request.QueryString("rut")
%>
<title>NUEVA DIRECCION</title>
<style type="text/css">
<!--
.Estilo27 {color: #FFFFFF}
.Estilo32 {color: #FFFFFF; font-size: x-small; }
-->
</style>
<form name="datos" method="post">
<table width="700" height="420" border="0">
  <tr>
    <td height="20"><img src="../lib/TITULO_NUEVA_DIR.gif" width="740" height="22"></td>
  </tr>
  <tr>
    <td valign="top" background="../images/fondo_coventa.jpg"><table width="100%" border="0" bordercolor="#FFFFFF">
      <tr bordercolor="#FFFFFF" bgcolor="#<%=session("COLTABBG")%>" class="Estilo13">
        <td width="38%">CALLE</td>
        <td width="16%">NUMERO</td>
        <td width="22%">RESTO</td>
        </tr>
      <tr bordercolor="#FFFFFF">
        <td><input name="calle" type="text" id="calle" size="40" maxlength="80"></td>
        <td><input name="numero" type="text" id="numero" size="10"></td>
        <td><input name="resto" type="text" id="resto" size="30" maxlength="80"></td>
        </tr>
      <tr bordercolor="#FFFFFF" bgcolor="#<%=session("COLTABBG")%>" class="Estilo13">
        <td>COMUNA</td>
        <td>FECHA</td>
        <td>USUARIO INGRESO</td>
        </tr>
      <tr bordercolor="#FFFFFF">
        <td>
<select name="comuna" id="comuna">
            <option value="0">SELECCIONE</option>
		    <%
		abrirscg()
		ssql="SELECT nombre_comuna,n_sadi FROM COMUNA WHERE codigo_comuna<>'0' ORDER BY nombre_comuna"
		set rsCOM= Conn.execute(ssql)
		 do until rsCOM.eof%>
		    <option value="<%=rsCOM("n_sadi")%>"><%=rsCOM("n_sadi")%></option>
		    <%
		  rsCOM.movenext
		  loop
		  rsCOM.close
		  set rsCOM=nothing
		  cerrarscg()
		  %>
        </select>
&nbsp;&nbsp;
		<input name="Submit" type="button" value="Aceptar" onClick="envia();">
		 </td>
        <td><%=date%></td>
        <td>
          <%response.Write(session("session_login"))%>
          <input name="rut" type="hidden" id="rut" value="<%=rut%>">
        </td>
        </tr>
    </table>
    </td>
  </tr>
</table>
</form>
<script language="JavaScript" type="text/JavaScript">
function envia(){
if(datos.calle.value==''){
alert('DEBE INGRESAR UNA CALLE');
}else if(datos.numero.value==''){
alert('DEBE INGRESAR UN NUMERO');
}else if(datos.comuna.value=='0'){
alert('DEBE SELECCIONAR UNA COMUNA');
}else{
datos.action='scg_dir.asp';
datos.submit();
}
}

</script>

