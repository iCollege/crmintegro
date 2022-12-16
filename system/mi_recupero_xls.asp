<%@ Language=VBScript %>
<%Response.ContentType = "application/vnd.ms-excel"%>
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
inicio= request.Form("inicio")
termino= request.Form("termino")
cliente = request.Form("cliente")
%>
<title>MI RECUPERO</title>

<style type="text/css">
<!--
.Estilo37 {color: #FFFFFF}
-->
</style>
<form name="datos" method="post">
<table width="680" height="300" border="0">
  <tr>
    <td height="20" class="Estilo20"><img src="../lib/TITULO_MIS_RECUPERO.gif" width="740" height="22"></td>
  </tr>
  <tr>
    <td height="242" valign="top">
	<BR>

	<%
	IF not cliente=""  then
	ssql="EXECUTE SCG_WEB_RECUPERO_DETALLE '"&session("session_login")&"','"&inicio&"','"&termino&"','"&cliente&"' "
	set rsDET=conexionSCG.execute(ssql)
	if not rsDET.eof then
%>
<table width="100%" border="0">
  <tr bgcolor="#<%=session("COLTABBG")%>">
    <td width="27%"><span class="Estilo37">RUT DEUDOR </span></td>
    <td width="18%"><span class="Estilo37">DOCUMENTO</span></td>
    <td width="35%"><span class="Estilo37">FECHA DE PAGO </span></td>
    <td width="35%"><span class="Estilo37">MONTO PAGADO </span></td>
    <td width="20%"><span class="Estilo37">GASTO DE COBRANZA</span></td>
  </tr>
  <tr>
    <td><%=rsDET("RUT")%></td>
    <td><%=rsDET("NRODOC")%></td>
    <td><%=rsDET("FECHA")%></td>
    <td><div align="right">$ <%=rsDET("CAPITALRECUPERADO")%></div></td>
    <td><div align="right">$ <%=rsDET("GASTOCOBRANZA")%></div></td>
  </tr>
</table>

<%	end if
	rsDET.close
	set rsDET=Nothing
	%>
	<% end if %>
	  </td>
  </tr>
</table>

</form>

