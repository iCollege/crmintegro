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
	IF not cliente=""  then
	abrirscg()
	'''***ssql="EXECUTE SCG_WEB_RECUPERO '" & session("session_idusuario") & "','" & inicio & "','" & termino & "','" & cliente & "'"
	'''***set rsDET=Conn.execute(ssql)
	'''***if not rsDET.eof then
	'''***recupero=rsDET("GASTOCOBRANZA")

	'''***intGastoCob = rsDET("GASTOCOBRANZA")
	'''***intCapRecup = rsDET("CAPITALRECUPERADO")
	'''***intCartActiva = rsDET("CARTERAACTIVA")
	'''***intRuts = rsDET("RUTS")

	intGastoCob = 100000
	recupero = 100000
	intCapRecup = 1250000
	intCartActiva = 25000000
	intRuts = 250
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
	sql="SELECT DESCRIPCION FROM CLIENTE WHERE CODCLIENTE = '" & cliente & "'"
	set rsNC=Conn.execute(sql)
	if not rsNC.eof then
		response.Write(rsNC("DESCRIPCION"))
	end if
	rsNC.close
	set rsNC=nothing
	%>
	</td>
    <td align="right">
	<%if not isnull(intRuts) then%>
		<%=FN(intRuts,0)%>
	<%else%>
  		0
  	<%end if%>
	</td>
    <td align="right">
	<%if not isnull(intCartActiva) then%>
	<%=FN(intCartActiva,0)%>
	<%else%>
	$ 0
	<%end if%>
     </td>
    <td align="right">$ <%=FN(intCapRecup,0)%> </td>
    <td align="right">$ <%=FN(intGastoCob,0)%> </td>
    <td align="right">
	    $<%
		ssql2="SELECT META FROM COBRADOR_CLIENTE WHERE ID_USUARIO = " & session("session_idusuario") & " AND CODCLIENTE = '" & cliente & "'"
		set rsMETA=Conn.execute(ssql2)
		if not rsMETA.eof then
			intMeta=rsMETA("meta")
		else
			intMeta=0
		End if
		rsMETA.close
		set rsMETA=nothing
		porcentaje=(clng(recupero)/clng(intMeta))*100
		%>
		<%=FN(intMeta,0)%>
	</td>
	<td align="right">
		<%=FN(porcentaje,0)%>%
	</td>
    </tr>
</table>

<table width="720" align="CENTER" border="0">
  <tr>
    <td align="CENTER">
		<img src="../images/recupero1.jpg">
	</td>
    </tr>
</table>

<%	''end if
	'''***rsDET.close
	'''***set rsDET=Nothing
	cerrarscg()
	%>
	<% end if %>
	  </td>
  </tr>
</table>






<script language="JavaScript1.2">
function envia(){
		if (datos.cliente.value=='0'){
			alert('DEBE SELECCIONAR UN CLIENTE');
		}else if(datos.inicio.value==''){
			alert('DEBE SELECCIONAR FECHA DE INICIO');
		}else if(datos.termino.value==''){
			alert('DEBES SELECCIONAR FECHA DE TERMINO');
		}else{
		datos.action='cargando.asp';
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
