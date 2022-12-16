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
<title>INFORME DE PRODUCTIVIDAD</title>

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
    <td width="827" height="20" class="Estilo20"><img src="../lib/TIT_INFORME_PRODUCTIVIDAD.gif" width="740" height="22"></td>
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

	G111 = 0
	G112 = 0
	G121 = 0
	G122 = 0
	G123 = 0
	G124 = 0
	G125 = 0
	G131 = 0
	G132 = 0
	G133 = 0
	G134 = 0
	G140 = 0
	G150 = 0
	G210 = 0
	G220 = 0
	G230 = 0
	G240 = 0
	G250 = 0
	G310 = 0
	G320 = 0
	G330 = 0
	G411 = 0
	G412 = 0
	G421 = 0
	G422 = 0
	G423 = 0
	G424 = 0
	G431 = 0
	G432 = 0
	G433 = 0
	G434 = 0
	G440 = 0
	G450 = 0
	G510 = 0
	G520 = 0
	G530 = 0
	G540 = 0
	G550 = 0
%>
	<table width="100%"  border="0">
	<tr>
	   <td width="10%" bgcolor="#<%=session("COLTABBG")%>"><span class="Estilo37">EJECUTIVO</span></td>
	   <td width="8%" bgcolor="#<%=session("COLTABBG")%>"><div align="right"><span class="Estilo37">09.00</span></div></td>
	   <td width="8%" bgcolor="#<%=session("COLTABBG")%>"><div align="right"><span class="Estilo37">10.00</span></div></td>
	   <td width="8%" bgcolor="#<%=session("COLTABBG")%>"><div align="right"><span class="Estilo37">11.00</span></div></td>
	   <td width="8%" bgcolor="#<%=session("COLTABBG")%>"><div align="right"><span class="Estilo37">12.00</span></div></td>
	   <td width="8%" bgcolor="#<%=session("COLTABBG")%>"><div align="right"><span class="Estilo37">13.00</span></div></td>
	   <td width="8%" bgcolor="#<%=session("COLTABBG")%>"><div align="right"><span class="Estilo37">14.00</span></div></td>
	   <td width="8%" bgcolor="#<%=session("COLTABBG")%>"><div align="right"><span class="Estilo37">15.00</span></div></td>
	   <td width="8%" bgcolor="#<%=session("COLTABBG")%>"><div align="right"><span class="Estilo37">16.00</span></div></td>
	   <td width="8%" bgcolor="#<%=session("COLTABBG")%>"><div align="right"><span class="Estilo37">17.00</span></div></td>
	   <td width="8%" bgcolor="#<%=session("COLTABBG")%>"><div align="right"><span class="Estilo37">18.00</span></div></td>
	   <td width="8%" bgcolor="#<%=session("COLTABBG")%>"><div align="right"><span class="Estilo37">19.00</span></div></td>
	   <td width="10%" bgcolor="#FF9900"><div align="right"><span class="Estilo37">TOTAL</span></div></td>
	</tr>
    <%
	 abrirscg()
	 ssql2="select login from cobrador_cliente where codigo_cliente='"&cliente&"' and tipo='CAL'"
	 set rsCOB=Conn.execute(ssql2)
	 tsumatoria=0
	 sumatoria=0
	 	hora9=0
		hora10=0
		hora11=0
		hora12=0
		hora13=0
		hora14=0
		hora15=0
		hora16=0
		hora17=0
		hora18=0
		hora19=0
		hora20=0


	 if not rsCOB.eof then
	 	do until rsCOB.eof
			hora9=0
			hora10=0
			hora11=0
			hora12=0
			hora13=0
			hora14=0
			hora15=0
			hora16=0
			hora17=0
			hora18=0
			hora19=0
			hora20=0
			sumatoria=0

			ssql3="SELECT datepart(hour,HoraIngreso) as hora FROM GESTIONES WHERE CodCobrador='"&rsCOB("login")&"' AND FechaIngreso>='"&inicio&"' and FechaIngreso<='"&termino&"' and CodCliente='"&cliente&"'"
			set rsHR=Conn.execute(ssql3)
			if not rsHR.eof then
				do until rsHR.eof
				sumatoria=sumatoria+1
				tsumatoria=tsumatoria+1
				if rsHR("Hora")="9" or rsHR("Hora")="8" then
				hora9=hora9+1
				thora9=thora9+1
				elseif rsHR("Hora")="10" then
				hora10=hora10+1
				thora10=thora10+1
				elseif rsHR("Hora")="11" then
				hora11=hora11+1
				thora11=thora11+1
				elseif rsHR("Hora")="12" then
				hora12=hora12+1
				thora12=thora12+1
				elseif rsHR("Hora")="13" then
				hora13=hora13+1
				thora13=thora13+1
				elseif rsHR("Hora")="14" then
				hora14=hora14+1
				thora14=thora14+1
				elseif rsHR("Hora")="15" then
				hora15=hora15+1
				thora15=thora15+1
				elseif rsHR("Hora")="16" then
				hora16=hora16+1
				thora16=thora16+1
				elseif rsHR("Hora")="17" then
				hora17=hora17+1
				thora17=thora17+1
				elseif rsHR("Hora")="18" then
				hora18=hora18+1
				thora18=thora18+1
				elseif rsHR("Hora")="19" then
				hora19=hora19+1
				thora19=thora19+1
				elseif rsHR("Hora")="20" then
				hora20=hora20+1
				thora20=thora20+1
				end if
				rsHR.movenext
				loop
			else
				hora9=0
				hora10=0
				hora11=0
				hora12=0
				hora13=0
				hora14=0
				hora15=0
				hora16=0
				hora17=0
				hora18=0
				hora19=0
				hora20=0
			end if
			rsHR.close
			set rsR=Nothing
	 %>
	 <tr>
	   <td><span class="Estilo37 Estilo38"><%=rsCOB("login")%></span></td>
	   <td><div align="right"><span class="Estilo38"><%=hora9%></span></div></td>
	   <td><div align="right"><span class="Estilo38"><%=hora10%></span></div></td>
	   <td><div align="right"><span class="Estilo38"><%=hora11%></span></div></td>
	   <td><div align="right"><span class="Estilo38"><%=hora12%></span></div></td>
	   <td><div align="right"><span class="Estilo38"><%=hora13%></span></div></td>
	   <td><div align="right"><span class="Estilo38"><%=hora14%></span></div></td>
	   <td><div align="right"><span class="Estilo38"><%=hora15%></span></div></td>
	   <td><div align="right"><span class="Estilo38"><%=hora16%></span></div></td>
	   <td><div align="right"><span class="Estilo38"><%=hora17%></span></div></td>
	   <td><div align="right"><span class="Estilo38"><%=hora18%></span></div></td>
	   <td><div align="right"><span class="Estilo38"><%=hora19%></span></div></td>
	   <td bgcolor="#FF9900" align="right" class="Estilo37"><%=sumatoria%></td>
	 </tr>
	 <%
	 	rsCOB.movenext
	 	loop
	 end if
	 rsCOB.close
	 set rsCOB=Nothing
	 cerrarscg()
	 %>
	 <tr bgcolor="#<%=session("COLTABBG")%>">
	   <td><span class="Estilo37">TOTALES</span></td>
	   <td><div align="right" class="Estilo37"><%=thora9%></div></td>
	   <td><div align="right" class="Estilo37"><%=thora10%></div></td>
	   <td><div align="right" class="Estilo37"><%=thora11%></div></td>
	   <td><div align="right" class="Estilo37"><%=thora12%></div></td>
	   <td><div align="right" class="Estilo37"><%=thora13%></div></td>
	   <td><div align="right" class="Estilo37"><%=thora14%></div></td>
	   <td><div align="right" class="Estilo37"><%=thora15%></div></td>
	   <td><div align="right" class="Estilo37"><%=thora16%></div></td>
	   <td><div align="right" class="Estilo37"><%=thora17%></div></td>
	   <td><div align="right" class="Estilo37"><%=thora18%></div></td>
	   <td><div align="right" class="Estilo37"><%=thora19%></div></td>
	   <td bgcolor="#FF9900"><div align="right" class="Estilo37"><%=tsumatoria%></div></td>
	 </tr>
    </table>
	<br>
	<span class="Estilo39"><strong>NOTA</strong>: LA HORA 09.00 INCLUYE LAS GESTIONES GENERADAS DESDE 8.30 A 9.59. </span><br>
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
datos.action='informe_cargando_consolidado.asp';
datos.submit();
}
}
</script>
