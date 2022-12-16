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
if inicio="" then
inicio=date
end if
termino= request.querystring("termino")

if termino="" then
termino=date
end if
cliente = request.querystring("cliente")
%>
<title>INFORME DE PROYECCIONES</title>

<style type="text/css">
<!--
.Estilo37 {color: #FFFFFF}
.Estilo38 {color: #000000}
-->
</style>
<form name="datos" method="post">
<table width="720" height="420" border="0">
  <tr>
    <td width="827" height="20" class="Estilo20"><img src="../lib/TIT_INFORME_PROYECCIONES.gif" width="740" height="22"></td>
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
		<option value="">SELECCIONE</option>
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
	   <td width="18%" bgcolor="#<%=session("COLTABBG")%>"><span class="Estilo37 Estilo37">EJECUTIVO</span></td>
	   <td width="18%" bgcolor="#<%=session("COLTABBG")%>"><div align="left" class="Estilo37">COMPROMISOS </div></td>
	   <td width="11%" bgcolor="#<%=session("COLTABBG")%>"><div align="right" class="Estilo37">
	     <div align="left"><span class="Estilo37">DEUDORES</span></div>
	   </div></td>
	   <td width="25%" bgcolor="#<%=session("COLTABBG")%>"><div align="right" class="Estilo37">
	     <div align="left"><span class="Estilo37">MONTO CAPITAL PROYECTADO</span></div>
	   </div></td>
	   <td width="28%" bgcolor="#<%=session("COLTABBG")%>"><span class="Estilo37">GASTO DE COBRANZA PROYECTADO</span></td>
	</tr>
    <%
	montog=0
	monto=0
	RUT=0
	total=0
	totalg=0
	abrirscg()
	 ssql2="select login from cobrador_cliente where codigo_cliente='"&cliente&"' AND TIPO='CAL'"
	 set rsCOB=Conn.execute(ssql2)
	 if not rsCOB.eof then
	 	do until rsCOB.eof
			ssql88="SELECT COUNT(DISTINCT RUTDEUDOR) AS DEUDORES FROM GESTIONES WHERE CodCobrador='"&rsCOB("login")&"' AND FechaCompromiso>='"&inicio&"' and FechaCompromiso<='"&termino&"' and CodCliente='"&cliente&"' And CodCategoria=1 And CodSubCategoria=2 and CodGestion=3 and FechaCompromiso is not null"
			set rsRUT=Conn.execute(ssql88)
			if not rsRUT.eof then
			deudores=rsRUT("DEUDORES")
			end if
			rsRUT.close
			set rsRUT=nothing

			RUT = RUT + deudores

			montocob=0
			montogasto=0

			ssql3="SELECT DISTINCT RUTDEUDOR AS RUTDEUDOR FROM GESTIONES WHERE CodCobrador='"&rsCOB("login")&"' AND FechaCompromiso>='"&inicio&"' and FechaCompromiso<='"&termino&"' and CodCliente='"&cliente&"' And CodCategoria=1 And CodSubCategoria=2 and CodGestion=3 and FechaCompromiso is not null"
			set rsHR=Conn.execute(ssql3)
				do until rsHR.eof
						ssql55="SELECT SUM(SALDO) AS SALDO,SUM(ISNULL(montoEMPRESA,0)) AS GASTO FROM CUOTA WHERE RUTDEUDOR='"&rsHR("RUTDEUDOR")&"' AND CODCLIENTE='"&cliente&"'"
						set rsMAS=Conn.execute(ssql55)
						if not rsMAS.eof then
							montocob=clng(rsMAS("SALDO"))+clng(montocob)
							montogasto=clng(rsMAS("GASTO"))+clng(montogasto)
						else
							montocob=0
							montogasto=0
						end if
						rsMAS.close
						set rsMAS=nothing
				rsHR.movenext
				loop
			total = total + montocob
			totalg = totalg + montogasto

			rsHR.close
			set rsHR=Nothing
	 %>
	 <tr>
	   <td><span class="Estilo37 Estilo38"><%=rsCOB("login")%></span></td>
	   <td><div align="right"><span class="Estilo38"><%=fn(deudores,0)%></span></div></td>
	   <td><div align="right"><span class="Estilo38"><%=fn(deudores,0)%></span></div></td>
	   <td><div align="right">$ <%=fn(montocob,0)%></div></td>
	   <td><div align="right">$<%=fn(montogasto,0)%></div></td>
	 </tr>
	 <%
	 	rsCOB.movenext
	 	loop
	 end if
	 rsCOB.close
	 set rsCOB=Nothing
	 cerrarscg()
	 %>
	 <tr bgcolor="#FF9900">
	   <td><span class="Estilo37">TOTALES</span></td>
	   <td><div align="right" class="Estilo37"><%=RUT%></div></td>
	   <td><div align="right" class="Estilo37"><%=RUT%></div></td>
	   <td><div align="right" class="Estilo37">$ <%=fn(total,0)%></div></td>
	   <td><div align="right"><span class="Estilo37">$<%=fn(totalg,0)%></span></div></td>
	 </tr>
    </table>
	<br>
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
datos.action='informe_cargando_compromiso.asp';
datos.submit();
}
}
</script>
