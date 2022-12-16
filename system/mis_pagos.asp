<% @LCID = 1034 %>
<!--#include file="arch_utils.asp"-->
<!--#include file="../lib/comunes/rutinas/funciones.inc" -->
<!--#include file="lib.asp"-->

<script language="JavaScript">
function ventanaSecundaria (URL){
window.open(URL,"DETALLE","width=200, height=200, scrollbars=no, menubar=no, location=no, resizable=no")
}

</script>

<%
inicio= request.querystring("inicio")
termino= request.querystring("termino")
cliente = request.querystring("cliente")
%>
<title>MI RECUPERO</title>

<style type="text/css">
<!--
.Estilo37 {color: #FFFFFF}
-->
</style>
<!--#include file="menu_secundario.inc"-->

<table width="720" align="CENTER" border="0">
  <tr>
    <td height="20" class="Estilo20"><img src="../lib/TITULO_MIS_RECUPERO.gif" width="740" height="22"></td>
  </tr>
  <tr>
    <td valign="top" background="../images/fondo_coventa.jpg">
	<BR>
	<form name="datos" method="post">
	<table width="100%" border="0">
		<tr bgcolor="#<%=session("COLTABBG")%>" class="Estilo13">
			<td width="33%">CLIENTE</td>
			<td width="25%">FECHA INICIO </td>
			<td width="42%">FECHA TERMINO </td>
		</tr>
		<tr>
			<td>
			<select name="cliente" id="cliente">
				<%
				abrirscg()
				''ssql="SELECT CODCLIENTE,DESCRIPCION FROM CLIENTE WHERE SCG_WEB = '1' AND CODCLIENTE IN (SELECT CODCLIENTE FROM COBRADOR_CLIENTE WHERE LOGIN='" & session("session_idusuario") & "') ORDER BY DESCRIPCION"
				ssql="SELECT CODCLIENTE,DESCRIPCION FROM CLIENTE"
				set rsCLI= Conn.execute(ssql)
				if not rsCLI.eof then
					Do until rsCLI.eof%>
					<option value="<%=rsCLI("CODCLIENTE")%>"<%if cint(cliente)=rsCLI("CODCLIENTE") then response.Write("Selected") End If%>><%=rsCLI("descripcion")%></option>
				<%
					rsCLI.movenext
					Loop
					end if
					rsCLI.close
					set rsCLI=nothing
					cerrarscg()

				%>
			</select></td>
			<td>
				<input name="inicio" type="text" id="inicio" value="<%=inicio%>" size="10" maxlength="10">
			 	<a href="javascript:showCal('Calendar7');"><img src="../lib/calendario.gif" border="0">
			 </td>
			<td>
				<input name="termino" type="text" id="termino" value="<%=termino%>" size="10" maxlength="10">
				<a href="javascript:showCal('Calendar6');"><img src="../lib/calendario.gif" border="0"></a>
			  &nbsp;&nbsp;&nbsp;<input type="button" name="Submit" value="Aceptar" onClick="envia();">
			</td>
		</tr>
    </table>
</form>
	<%
	IF not cliente = ""  then
	abrirscg()

	intGastoCob = 100000
	recupero = 100000
	intCapRecup = 1250000
	intCartActiva = 25000000
	intRuts = 250
%>
	<table width="100%" border="0">
	  <tr bgcolor="#<%=session("COLTABBG")%>" class="Estilo13">
		<td >Fecha</td>
		<td >Sucursal</td>
		<td >Nro. Doc</td>
		<td >Nro.Comprob.</td>
		<td >Monto Capital</td>
		<td >Monto Pagado</td>
		<td >G.Cobra.</td>
	  </tr>
	  <tr>
		<td>01/09/2009</td>
		<td>SANTIAGO</td>
		<td>956002332</td>
		<td>00014205</td>
		<td align="right">$ 150.000 </td>
		<td align="right">$ 150.000 </td>
		<td align="right">$ 15.000 </td>
	  </tr>
	  <tr>
		<td>01/09/2009</td>
		<td>VALPARAISO</td>
		<td>956442032</td>
		<td>00014209</td>
		<td align="right">$ 850.000 </td>
		<td align="right">$ 450.000 </td>
		<td align="right">$ 45.000 </td>
	  </tr>
	  <tr>
		<td>02/09/2009</td>
		<td>SANTIAGO</td>
		<td>956442000</td>
		<td>00014212</td>
		<td align="right">$ 400.000 </td>
		<td align="right">$ 400.000 </td>
		<td align="right">$ 40.000 </td>
	  </tr>
	   <tr>
	  		<td bgcolor="#<%=session("COLTABBG")%>" class="Estilo13">Totales</td>
	  		<td bgcolor="#<%=session("COLTABBG2")%>" span class="Estilo28" align="right" colspan=3></td>
	  		<td bgcolor="#<%=session("COLTABBG2")%>" span class="Estilo28" align="right">$ 1.400.000 </td>
	  		<td bgcolor="#<%=session("COLTABBG2")%>" span class="Estilo28" align="right">$ 1.000.000 </td>
	  		<td bgcolor="#<%=session("COLTABBG2")%>" span class="Estilo28" align="right">$ 100.000 </td>
	  </tr>



	</table>



  </td>
  </tr>
</table>



<!--table width="720" align="CENTER" border="0">
  <tr>
    <td align="CENTER">
		<img src="../images/recupero1.jpg">
	</td>
    </tr>
</table-->

<% End if %>
<script language="JavaScript1.2">
function envia(){
		if (datos.cliente.value=='0'){
			alert('DEBE SELECCIONAR UN CLIENTE');
		}else if(datos.inicio.value==''){
			alert('DEBE SELECCIONAR FECHA DE INICIO');
		}else if(datos.termino.value==''){
			alert('DEBES SELECCIONAR FECHA DE TERMINO');
		}else{
		datos.action='cargando_pagos.asp';
		datos.submit();
	}
}


function enviaexcel(){
if (datos.cliente.value=='0'){
alert('DEBE SELECCIONAR UN CLIENTE');
}else if(datos.inicio.value==''){
alert('DEBE SELECCIONAR FECHA DE INICIO');
}else if(datos.termino.value==''){
alert('DEBES SELECCIONAR FECHA DE TERMINO');
}else{
datos.action='mi_recupero_xls.asp';
datos.submit();
}
}



</script>
