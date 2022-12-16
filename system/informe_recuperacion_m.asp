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
<title>INFORME DE VENTAS</title>

<style type="text/css">
<!--
.Estilo37 {color: #FFFFFF}
-->
</style>
<form name="datos" method="post">
<table width="830" height="432" border="0">
  <tr>
    <td height="20" class="Estilo20"><img src="../lib/TIT_INFORME_VENTAS.gif" width="740" height="22"></td>
  </tr>
  <tr>
    <td height="388" valign="top" background="../images/fondo_coventa.jpg"><div align="right">FECHA DE EMISI&Oacute;N : <%=DATE%><BR>
          <BR>
    </div>
      <table width="100%" border="0">
        <tr bgcolor="#<%=session("COLTABBG")%>" class="Estilo13">
          <td width="58%">CLIENTE</td>
          <td width="24%">MES ACTUAL </td>
          <td width="18%">A&Ntilde;O</td>
        </tr>
        <tr>
          <td><select name="cliente" id="cliente">
              <option value="0">SELECCIONE</option>
              <%
			 abrirscg()
			ssql="SELECT codigo_cliente,razon_social_cliente FROM CLIENTE where scg_web='1' order by razon_social_cliente"
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
            </select>
&nbsp;&nbsp;&nbsp;&nbsp;
      <input type="button" name="Submit" value="Aceptar" onClick="envia();"></td>
          <td><%=UCASE(MONTHNAME(MONTH(DATE)))%></td>
          <td><%=YEAR(DATE)%>&nbsp;&nbsp;&nbsp; &nbsp; </td>
        </tr>
      </table>
      <%
	IF not cliente=""  then
	abrirscg()
	ssql="SELECT * FROM SCG_WEB_INFORME_RECUPERACION WHERE CODIGO_CLIENTE='"&cliente&"' ORDER BY codigo_generacion asc"
	set rsDET=Conn.execute(ssql)
	if not rsDET.eof then

%>
      <table width="100%" border="0">
        <tr bgcolor="#<%=session("COLTABBG")%>">
          <td width="10%"><span class="Estilo37">CLIENTE</span></td>
          <td width="10%"><span class="Estilo37 Estilo37">RUT</span></td>
          <td width="10%"><span class="Estilo37">CAPITAL</span></td>
          <td width="10%"><span class="Estilo37">RECUPERADO</span></td>
          <td width="11%"><span class="Estilo37">GASTO COBRANZA </span></td>
          <td width="11%" bgcolor="#<%=session("COLTABBG")%>"><span class="Estilo37">META</span></td>
          <td width="14%" bgcolor="#<%=session("COLTABBG")%>"><span class="Estilo37">RECUPERACION</span></td>
          <td width="13%" bgcolor="#<%=session("COLTABBG")%>"><span class="Estilo37">MES</span></td>
          <td width="11%"><span class="Estilo37">FECHA GENERACION </span></td>
        </tr>
		<%DO UNTIL rsDET.eof
		recupero=rsDET("gasto_cobranza")
		meta=rsDET("cumplimiento")
		capital=rsDET("capital")
		%>
        <tr>
          <td height="38"><%
	sql="SELECT DESC_CLI FROM CLIENTES WHERE COD_CLI='"&cliente&"'"
	set rsNC=Conn.execute(sql)
	if not rsNC.eof then
	response.Write(rsNC("DESC_CLI"))
	end if
	rsNC.close
	set rsNC=nothing
	%></td>
          <td><div align="right">
              <div align="right">
                <%if not isnull(rsDET("rut_activos")) then%>
                <%=FN(rsDET("rut_activos"),0)%>
                <%else%>
          0
          <%end if%>
              </div>
          </div></td>
          <td><div align="right">
                <%if not isnull(rsDET("capital")) then%>
                <%=FN(rsDET("capital"),0)%>
                <%else%>
          $ 0
          <%end if%>
          </div></td>
          <td><div align="right">$ <%=FN(rsDET("capital_recuperado"),0)%></div></td>
          <td><div align="right">$ <%=FN(rsDET("gasto_cobranza"),0)%></div></td>
          <td><div align="right">$ <%=fn(rsDET("meta"),0)%></div></td>
          <td><div align="right"><%=rsDET("cumplimiento")%>%</div></td>
          <td><div align="right"><%=ucase(monthname(rsDET("mes")))%></div></td>
          <td><div align="right"><%=formatdatetime(rsDET("fecha_generacion"),2)%></div></td>
        </tr>
		<%rsDET.movenext
		loop
		%>
      </table>
      <p>
        <%	end if
	rsDET.close
	set rsDET=Nothing
	cerrarscg()
	%>
        <% end if %>
      </p>
      <p align="right"></p></td>
  </tr>
</table>

</form>

<script language="JavaScript1.2">
function envia(){
if (datos.cliente.value=='0'){
alert('DEBE SELECCIONAR UN CLIENTE');
}else{
datos.action='informe_cargando_m.asp';
datos.submit();
}
}


</script>
