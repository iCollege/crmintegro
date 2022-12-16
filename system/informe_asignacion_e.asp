<% @LCID = 1034 %>
<!--#include file="../lib/comunes/bdatos/ConectarSCG_R.inc" -->
<!--#include file="../lib/comunes/bdatos/ConectarCargas.inc"-->
<!--#include file="../lib/comunes/rutinas/funciones.inc" -->
<!--#include file="lib.asp"-->

<script language="JavaScript">
function ventanaSecundaria (URL){
window.open(URL,"DETALLE","width=200, height=200, scrollbars=no, menubar=no, location=no, resizable=no")
}

</script>

<%
cliente = request.querystring("cliente")
ejecutivo = request.QueryString("ejecutivo")

if cliente="" or isnull(cliente) then
cliente= request.Form("cliente")
end if



%>
<title>ASIGNACION POR EJECUTIVO</title>

<style type="text/css">
<!--
.Estilo37 {color: #FFFFFF}
-->
</style>
<form name="datos" method="post">
<table width="680" height="432" border="0">
  <tr>
    <td height="20" class="Estilo20"><img src="../lib/TITULO_ASIGNACION_E.gif" width="740" height="22"></td>
  </tr>
  <tr>
    <td height="242" valign="top" background="../images/fondo_coventa.jpg">
	<BR>
	<table width="100%" border="0">
      <tr bgcolor="#<%=session("COLTABBG")%>" class="Estilo13">
        <td width="37%">CLIENTE</td>
        <td width="20%">REMESA</td>
        <td width="43%">EJECUTIVO</td>
        </tr>
      <tr>
        <td>
		<select name="cliente" id="cliente" onChange="recarga();">
		<option value="0">SELECCIONE</option>
			<%
			ssql="SELECT codigo_cliente,razon_social_cliente FROM CLIENTE where scg_web='1' order by razon_social_cliente"
			set rsCLI= conexionCG.execute(ssql)
			if not rsCLI.eof then
				do until rsCLI.eof%>
			<option value="<%=rsCLI("codigo_cliente")%>"<%if cint(cliente)=rsCLI("codigo_cliente") then response.Write("Selected") End If%>><%=rsCLI("razon_social_cliente")%></option>
			<%
				rsCLI.movenext
				loop
				end if
				rsCLI.close
				set rsCLI=nothing

			%>
        </select></td>
        <td><input name="remesa" type="text" id="remesa" size="10" maxlength="10"></td>
        <td>

		<select name="ejecutivo" id="ejecutivo">
		<option value="TODOS">TODOS</option>
        <%ssql="SELECT codcobrador FROM SCG_ASIGNACION_GES_CLI WHERE codcliente='"&cliente&"'"
		set rsCLI=conexionSCG.execute(ssql)
		if not rsCLI.eof then
			do until rsCLI.eof
		%>
		  <option value="<%=rsCLI("codcobrador")%>"<%if ejecutivo=rsCLI("codcobrador") then response.Write("Selected") end if%>><%=rsCLI("codcobrador")%></option>

		<%
			rsCLI.movenext
			loop
		end if
		rsCLI.close
		set rsCLI=nothing
		%>
        </select>
&nbsp;&nbsp;&nbsp;
<input type="button" name="Submit" value="Generar Archivo" onClick="envia();">
&nbsp; </td>
        </tr>
    </table>

	</td>
  </tr>
</table>

</form>

<script language="JavaScript1.2">
function envia(){
if (datos.cliente.value=='0'){
alert('DEBE SELECCIONAR UN CLIENTE');
}else{
datos.action='cargando_xls_asig.asp';
datos.submit();
}
}


function recarga(){
datos.action='informe_asignacion_e.asp';
datos.submit();
}



</script>
