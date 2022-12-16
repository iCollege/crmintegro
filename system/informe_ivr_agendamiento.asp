<!--#include file="arch_utils.asp"-->
<!--#include file="../lib/comunes/rutinas/funciones.inc" -->
<!--#include file="lib.asp"-->


<%
inicio= request.querystring("inicio")
termino= request.querystring("termino")
cliente = request.querystring("cliente")

%>
<title>INFORME DE AGENDAMIENTOS</title>

<style type="text/css">
<!--
.Estilo37 {color: #FFFFFF}
-->
</style>
<form name="datos" method="post">
<table width="680" height="432" border="0">
  <tr>
    <td height="20" class="Estilo20"><img src="../lib/TITULO_INFORME_AGENDMIENTO.gif" width="740" height="22"></td>
  </tr>
  <tr>
    <td height="242" valign="top" background="../images/fondo_coventa.jpg">
	<BR>
	<table width="100%" border="0">
      <tr bgcolor="#<%=session("COLTABBG")%>" class="Estilo13">
        <td width="33%">CLIENTE</td>
        <td width="25%">FECHA INICIO </td>
        <td width="42%">FECHA TERMINO </td>
      </tr>
      <tr>
        <td>
		<select name="cliente" id="cliente">
		  <option value="ACSA" <%if cliente="ACSA" then response.Write("Selected") End if%>>ACSA</option>
		  <option value="MOVISTAR" <%if cliente="MOVISTAR" then response.Write("Selected") End if%>>MOVISTAR</option>
		  <option value="PUBLIGUIAS" <%if cliente="PUBLIGUIAS" then response.Write("Selected") End if%>>PUBLIGUIAS</option>
		  <option value="RELIQUIDACIONES" <%if cliente="RELIQUIDACIONES" then response.Write("Selected") End if%>>RELIQUIDACIONES INP</option>
        </select></td>
        <td><input name="inicio" type="text" id="inicio" value="<%=inicio%>" size="10" maxlength="10">
         <a href="javascript:showCal('Calendar7');"><img src="../lib/calendario.gif" border="0"></td>
        <td><input name="termino" type="text" id="termino" value="<%=termino%>" size="10" maxlength="10">
          <a href="javascript:showCal('Calendar6');"><img src="../lib/calendario.gif" border="0"></a>
		  &nbsp;&nbsp;&nbsp;<input type="button" name="Submit" value="Aceptar" onClick="envia();">
&nbsp;
</td>
      </tr>
    </table>

	<%
	IF not cliente=""  then
	abrires()
	'ssql="SELECT RUTDEUDOR,ANI,ANI_RET,FECHA,HORA,CLIENTE from DAL_RETIRO WHERE CLIENTE= '" & cliente & "' AND FECHA>='" & FECHA1 & "' AND FECHA<='" &FECHA2) & "'"
	ssql="SELECT RUTDEUDOR,ANI,ANI_RET,FECHA,HORA,CLIENTE from DAL_RETIRO WHERE CLIENTE= '" & cliente & "' AND FECHA>='" & replace(inicio,"/","-") & "' AND FECHA<='" & replace(termino,"/","-") & "'"
	'response.Write(ssql)
	' response.End
	set rsDET=Conn2.execute(ssql)
	if not rsDET.eof then
%>
<table width="100%" border="0">
  <tr bgcolor="#<%=session("COLTABBG")%>">
    <td width="14%"><span class="Estilo37">CLIENTE</span></td>
    <td width="14%"><span class="Estilo37">RUT</span></td>
    <td width="14%"><span class="Estilo37">FONO LLAMADO</span></td>
    <td width="14%"><span class="Estilo37">FONO A CONTACTAR</span></td>
    <td width="15%"><span class="Estilo37">FECHA</span></td>
    <td width="13%"><span class="Estilo37">HORA </span></td>
    </tr>
	<%do until rsDET.eof
	cliente=rsDET("CLIENTE")
	rut=rsDET("RUTDEUDOR")
	ani=rsDET("ANI")
	ani2=rsDET("ANI_RET")
	fecha=rsDET("FECHA")
	hora=rsDET("HORA")
	%>
  <tr>
    <td><%=cliente%></td>
    <td><%=rut%></td>
    <td><%=ani%></td>
    <td><%=ani2%></td>
    <td><%=fecha%></td>
    <td><%=hora%></td>
    </tr>
    <%	rsDET.movenext
		loop
	%>
</table>

<%
end if
	rsDET.close
	set rsDET=Nothing
	cerrarEs()
	%>
	<% end if
	 %>
	  </td>
  </tr>
</table>

</form>

<script language="JavaScript1.2">
function envia(){
if(datos.inicio.value==''){
alert('DEBE SELECCIONAR FECHA DE INICIO');
}else if(datos.termino.value==''){
alert('DEBES SELECCIONAR FECHA DE TERMINO');
}else{
datos.action='informe_cargando_ivr_agenda.asp';
datos.submit();
}
}

</script>
