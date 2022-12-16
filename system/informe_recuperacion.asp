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
<title>INFORME DE RECUPERACI&Oacute;N DE CARTERA</title>

<style type="text/css">
<!--
.Estilo37 {color: #FFFFFF}
-->
</style>
<form name="datos" method="post">
<table width="680" height="432" border="0">
  <tr>
    <td height="20" class="Estilo20"><img src="../lib/TITULO_INFORME_RECUPERA.gif" width="740" height="22"></td>
  </tr>
  <tr>
    <td height="242" valign="top" background="">
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
			<%
			AbrirScg()
			ssql="SELECT CODCLIENTE,DESCRIPCION FROM CLIENTE"
			set rsCLI= Conn.execute(ssql)
			if not rsCLI.eof then
				do until rsCLI.eof%>
			<option value="<%=rsCLI("CODCLIENTE")%>"<%if cint(cliente)=rsCLI("CODCLIENTE") then response.Write("Selected") End If%>><%=rsCLI("DESCRIPCION")%></option>
			<%
				rsCLI.movenext
				loop
				end if
				rsCLI.close
				set rsCLI=nothing

			%>
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
	Server.ScriptTimeout=200000
	'ssql="EXECUTE SCG_WEB_RECUPERO_CLIENTE '"&inicio&"','"&termino&"','"&cliente&"' "
	set rsDET=conexionSCG.execute(ssql)
	if not rsDET.eof then
	'recupero=rsDET("GASTOCOBRANZA")
	'meta=rsDET("PORCENTAJE")
	'capital=rsDET("CARTERAACTIVA")

%>
<table width="100%" border="0">
  <tr bgcolor="#<%=session("COLTABBG")%>">
    <td width="14%"><span class="Estilo37">CLIENTE</span></td>
    <td width="14%"><span class="Estilo37 Estilo37">RUT</span></td>
    <td width="14%"><span class="Estilo37">CAPITAL</span></td>
    <td width="14%"><span class="Estilo37">RECUPERADO</span></td>
    <td width="15%"><span class="Estilo37">GASTO COBRANZA </span></td>
    <td width="13%"><span class="Estilo37">META </span></td>
    <td width="16%"><span class="Estilo37">% CUMPLIMIENTO </span></td>
    </tr>
  <tr>
    <td><%
	sql="SELECT DESC_CLI FROM CLIENTES WHERE COD_CLI='"&cliente&"'"
	set rsNC=ConexionSCG.execute(sql)
	if not rsNC.eof then
	response.Write(rsNC("DESC_CLI"))
	end if
	rsNC.close
	set rsNC=nothing
	%></td>
    <td><div align="right">
      <div align="right">
        <%if not isnull(rsDET("RUTS")) then%>
        <%=FN(rsDET("RUTS"),0)%>
        <%else%>
  0
  <%end if%>
      </div>
</div></td>
    <td><div align="right">
      <div align="right">
        <%if not isnull(rsDET("CARTERAACTIVA")) then%>
        <%=FN(rsDET("CARTERAACTIVA"),0)%>
        <%else%>
  $ 0
  <%end if%>
      </div>
    </div></td>
    <td><div align="right">$ <%=FN(rsDET("CAPITALRECUPERADO"),0)%></div></td>
    <td><div align="right">$ <%=FN(rsDET("GASTOCOBRANZA"),0)%></div></td>
    <td>
	  <div align="right">
	      <%
	response.Write(meta)
	%>
	      %	    </div></td>
    <td><div align="right">
	<%
	porcentaje=(clng(recupero)/clng(capital))*100
	response.Write(formatnumber(porcentaje,0))
	%>

	%</div></td>
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

<script language="JavaScript1.2">
function envia(){
if (datos.cliente.value=='0'){
alert('DEBE SELECCIONAR UN CLIENTE');
}else if(datos.inicio.value==''){
alert('DEBE SELECCIONAR FECHA DE INICIO');
}else if(datos.termino.value==''){
alert('DEBES SELECCIONAR FECHA DE TERMINO');
}else{
datos.action='informe_cargando.asp';
datos.submit();
}
}


</script>
