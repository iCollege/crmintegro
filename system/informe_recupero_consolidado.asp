<% @LCID = 1034 %>
<!--#include file="arch_utils.asp"-->
<!--#include file="../lib/comunes/rutinas/funciones.inc" -->
<!--#include file="lib.asp"-->

<%
inicio= request.querystring("inicio")
if inicio="" then
inicio=date
end if
termino= request.querystring("termino")
if termino="" then
termino=date
end if
cliente = request.querystring("cliente")
%>
<title>INFORME CONSOLIDADO DE RECUPERACION</title>

<style type="text/css">
<!--
.Estilo37 {color: #FFFFFF}
.Estilo38 {color: #000000}
.Estilo39 {color: #FF0000}
-->
</style>
<form name="datos" method="post">
<table width="720" height="420" border="0">
  <tr>
    <td width="827" height="20" class="Estilo20"><img src="../lib/TIT_INFORME_RECUPERACION2.gif" width="740" height="22"></td>
  </tr>
  <tr>
    <td height="242" valign="top" background="../images/fondo_coventa.jpg">
	<BR>
	<table width="100%" border="0">
      <tr bgcolor="#<%=session("COLTABBG")%>" class="Estilo13">
        <td width="35%">CLIENTE</td>
        <td width="16%">FECHA INICIO </td>
        <td width="15%" bgcolor="#<%=session("COLTABBG")%>">FECHA TERMINO </td>
        </tr>
      <tr>
        <td height="26" valign="top">
		<select name="cliente" id="cliente">
		<option value="0">SELECCIONE</option>
			<%
			abrirscg()
			ssql="SELECT codigo_cliente,razon_social_cliente FROM CLIENTE where scg_web= 1 order by razon_social_cliente"
			set rsCLI= Conn.execute(ssql)
			if not rsCLI.eof then
				do until rsCLI.eof%>
			<option value="<%=rsCLI("codigo_cliente")%>"<%if cint(cliente)=rsCLI("codigo_cliente") then response.Write("Selected") End If%>><%=rsCLI("razon_social_cliente")%></option>
			<%
				rsCLI.movenext
				loop
				end if
				rsCLI.close
				set rsCLI=nothing
				cerrarscg()
			%>
        </select></td>
        <td valign="top"><input name="inicio" type="text" id="inicio" value="<%=inicio%>" size="10" maxlength="10">
		<a href="javascript:showCal('Calendar7');"><img src="../lib/calendario.gif" border="0"></a></td>
        <td valign="top"><input name="termino" type="text" id="termino" value="<%=termino%>" size="10" maxlength="10">
          <a href="javascript:showCal('Calendar6');"><img src="../lib/calendario.gif" border="0"></a>
&nbsp;&nbsp;
<input type="submit" name="Submit" value="Ver" onClick="envia();">
</td>
        </tr>
    </table>

	<%
	IF not cliente="" then
%>
	<table width="100%"  border="0">
	<tr>
	   <td width="10%" bgcolor="#<%=session("COLTABBG")%>"><span class="Estilo37">EJECUTIVO</span></td>
	   <td width="8%" bgcolor="#<%=session("COLTABBG")%>"><div align="right"><span class="Estilo37">CAPITAL RECUPERADO</span></div></td>
	   <td width="8%" bgcolor="#<%=session("COLTABBG")%>"><div align="right"><span class="Estilo37">UTILIDAD GENERADA </span></div></td>
	   </tr>
    <%
	 montototal=0
	 gastototal=0
	 abrirscg()
	 ssql2="select login from cobrador_cliente where codigo_cliente='"&cliente&"' and tipo = 'CAL'"
	 set rsCOB=Conn.execute(ssql2)
	 if not rsCOB.eof then
	 	do until rsCOB.eof

				monto=0
				gasto=0

				sql3="SELECT SUM(PAGO_CUOTA.MONTOCAPITAL) AS MONTO,SUM(PAGO_CUOTA.UTILIDAD_EMPRESA) AS GASTO FROM PAGO_CUOTA,PAGO WHERE PAGO_CUOTA.CODPAGO = PAGO.CODIGO AND PAGO_CUOTA.COD_CLI='"&cliente&"' AND PAGO_CUOTA.CODCOBRADOR='"&rsCOB("login")&"' AND PAGO.FECHA>='"&inicio&"' AND PAGO.FECHA<='"&termino&"'"
				set rsHR=Conn.execute(sql3)
				if not rsHR.eof then
				monto=rsHR("MONTO")
				gasto=rsHR("GASTO")
				else
				monto=0
				gasto=0
				end if
				rsHR.close
				set rsR=Nothing
				if isnull(monto) then
				monto=0
				end if

				if isNULL(gasto) then
				gasto=0
				end if

				montototal=clng(monto) + clng(montototal)
				gastototal=clng(gasto) + clng(gastototal)
	 %>
	   <td><span class="Estilo37 Estilo38"><%=rsCOB("login")%></span></td>
	   <td><div align="right"><span class="Estilo38">$ <%=FN(clng(monto),0)%></span></div></td>
	   <td><div align="right"><span class="Estilo38">$ <%=FN(clng(gasto),0)%></span></div></td>
	   </tr>
	 <%
	 	rsCOB.movenext
	 	loop
	 end if
	 rsCOB.close
	 set rsCOB=Nothing
	 cerrarscg()
	 %>
	 <tr>
	   <td>OTROS</td>
	   <td><div align="right">
	         <%
	   monto_otros=0
	   gasto_otros=0
	   abrirscg()
	   ssql="SELECT SUM(isnull(PAGO_CUOTA.MONTOCAPITAL,0)) AS MONTO,SUM(isnull(PAGO_CUOTA.UTILIDAD_EMPRESA,0)) AS GASTO FROM PAGO_CUOTA,PAGO WHERE PAGO_CUOTA.CODPAGO = PAGO.CODIGO AND PAGO_CUOTA.COD_CLI='"&cliente&"' AND PAGO_CUOTA.CODCOBRADOR NOT IN (SELECT LOGIN FROM COBRADOR_CLIENTE WHERE CODIGO_CLIENTE='"&cliente&"' and tipo='CAL') AND PAGO.FECHA>='"&inicio&"' AND PAGO.FECHA<='"&termino&"'"
	   set rs=Conn.execute(ssql)
	   if not rs.eof then
	   monto_otros = rs("MONTO")
	   gasto_otros = rs("GASTO")
	   else
	   gasto_otros=0
	   monto_otros=0
	   end if
	   rs.Close
	   set rs=nothing
	   if isnull(monto_otros) then
	   monto_otros = 0
	   end if
	   response.Write("$ ")
	   response.Write(FN(clng(monto_otros),0))

	   if isNULL(gasto_otros) then
	   gasto_otros=0
	   end if

	   if isNULL(monto_otros) then
	   monto_otros=0
	   end if
	   montototal = clng(montototal) + CLNG(monto_otros)
	   gastototal = clng(gastototal) + CLNG(gasto_otros)

	   %>
	     </div></td>
	   <td><div align="right">$ <%=FN(clng(gasto_otros),0)%></div></td>
	   </tr>
	 <tr>
	 <tr bgcolor="#<%=session("COLTABBG")%>">
	   <td><span class="Estilo37">TOTALES</span></td>
	   <td><div align="right" class="Estilo37">$ <%=FN(montototal,0)%></div></td>
	   <td><div align="right" class="Estilo37">$ <%=FN(gastototal,0)%></div></td>
	   </tr>
    </table>
	<br>	<br>
<strong>	INFORME GENERADO EL DÍA: <%=DATE%>
	<BR>
	HORA: <%=TIME%></strong>
	</td>
  </tr>
</table>
<%end if%>
</form>

<script language="JavaScript1.2">
function envia(){
if (datos.cliente.value=='0'){
alert('DEBE SELECCIONAR UN CLIENTE');
}else{
datos.action='informe_cargando_consolidado_r.asp';
datos.submit();
}
}
</script>
