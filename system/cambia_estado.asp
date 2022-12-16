<% @LCID = 1034 %>
<!--#include file="arch_utils.asp"-->
<!--#include file="../lib/comunes/rutinas/funciones.inc" -->
<!--#include file="lib.asp"-->
<!--#include file="asp/comunes/general/SoloNumeros.inc" -->
<%
idGestion=request.QueryString("gestion")
rut_=request.QueryString("deudor")
%>
<title>CAMBIAR ESTADO TICKET</title>
<style type="text/css">
<!--
.Estilo35 {color: #333333}
.Estilo36 {color: #FFFFFF}
.Estilo37 {color: #000000}
-->
</style>
<table align="center" width="1000" border="0">
  <tr>
  	<TD width="50%" height="30" ALIGN=LEFT class="pasos">
		<B>Modulo Ingreso de Gestiones</B>
	</TD>
    <TD width="50%" height="30" ALIGN=LEFT class="pasos">
		<B>CERRAR TICKET</B>
	</TD>
  </tr>
 </table>
 
<form action="" method="post" name="datos">
<table width="200" align="center" border="0">
  <tr>
    <td height="2" colspan=2></td>
  </tr>

  <tr>
  <td width="200xp"><strong>Abrir</strong></td><td><input name="opcion" type="radio" id="opcion" value="ABIERTO"></td>
  </tr>
  <tr>
  <td><strong>Cerrar</strong></td><td><input name="opcion" type="radio" id="opcion" value="CERRADO" checked>
  <input name="id" id="id" type="hidden" value="<%=idGestion%>">
  <input name="rut_deudor" id="rut_deudor" type="hidden" value="<%=rut_%>">
  </td>
  </td>  
  </tr>
  <tr>
  <td><strong>CUAL ES LA RAZON?</strong></td>
  <td><TEXTAREA NAME="observacion" id="observacion" ROWS=4 COLS=65></TEXTAREA></td>
  </tr>
  
   <tr bordercolor="#FFFFFF">
    <td></td>
	<td align="LEFT"><input name="Submit" type="button" class="Estilo8" onClick="envia();" value="GUARDAR Y CAMBIAR ESTADO">
	<input name="Volver" type="button" class="Estilo8" onClick="history.back();" value="Volver"></td>
  </tr>
  
	
</table>
</form>

<script language="JavaScript" type="text/JavaScript">
function envia(){

datos.action='update_estado.asp';
datos.submit();
}

</script>

