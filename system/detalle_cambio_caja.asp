<% @LCID = 1034 %>
<!--#include file="../../comunes/bdatos/ControlDeAcceso.inc"-->
<!--#include file="../../comunes/bdatos/ConectarSCG.inc"-->
<!--#include file="../../comunes/rutinas/funciones.inc" -->
<!--#include file="../../comunes/rutinas/rutinasSCG.inc" -->
<!--#include file="../../comunes/bdatos/ConectarINTRACPS.inc"-->
<!--#include file="../../comunes/rutinas/chkFecha.inc"-->
<!--#include file="../../comunes/rutinas/sondigitos.inc"-->
<!--#include file="../../comunes/rutinas/formatoFecha.inc"-->
<!--#include file="../../comunes/rutinas/validarFecha.inc"-->
<!--#include file="../../comunes/rutinas/diasEnMes.inc"-->
<%
	cod_caja=Session("intCodUsuario")
	'cod_caja=110
	strsql="select * from usuario where cod_usuario = " & cod_caja & ""
	set rsUsu=Conn.execute(strsql)
	if not rsUsu.eof then
		perfil=rsUsu("per_cajaweb")
		if perfil = "caja_modif" or perfil = "caja_listado" then
			sucursal = request("cmb_sucursal")
		else
			sucursal = rsUsu("sucursal")
		end if
	end if
	'response.write(perfil)
	codpago = request("TX_pago")
	strrut=request("TX_RUT")
	if sucursal="" then sucursal="0"
	'response.write(sucursal)
	usuario = request("cmb_usuario")
	if usuario = "" then usuario = "0"
	termino = request("termino")
	inicio = request("inicio")
	resp = request("resp")
	if Trim(inicio) = "" Then
		inicio = TraeFechaMesActual(conexionSCG,-1)
		inicio = "01" & Mid(inicio,3,10)
	End If
	if Trim(termino) = "" Then
		termino = TraeFechaActual(conexionSCG)
	End If
	'hoy=date

	'response.write(hoy)
%>
<title>Intercapital</title>
<style type="text/css">
<!--
.Estilo13 {color: #FFFFFF}
.Estilo27 {color: #FFFFFF}
-->
</style>

<script language="JavaScript" src="../../comunes/lib/cal2.js"></script>
<script language="JavaScript" src="../../comunes/lib/cal_conf2.js"></script>
<script language="JavaScript" src="../../comunes/lib/validaciones.js"></script>
<script src="../../comunes/general/SelCombox.js"></script>
<script src="../../comunes/general/OpenWindow.js"></script>


<script language="JavaScript " type="text/JavaScript">

function Refrescar()
{
	resp='no'
	datos.action = "detalle_cambio_caja.asp?resp="+ resp +"";
	datos.submit();
}

function Ingresa()
{
	with( document.datos )
	{
		action = "detalle_cambio_caja.asp";
		submit();
	}
}

function envia()
{
	datos.TX_RUT.value='';
	datos.TX_pago.value='';
	resp='si'
	datos.action = "detalle_cambio_caja.asp?resp="+ resp +"";
	datos.submit();
}

function envia_excel(){
	datos.action = "detalle_caja_excel.asp";
	datos.submit();
}
</script>


<link href="style.css" rel="Stylesheet">

<form name="datos" method="post">
<table width="800" height="500" border="1">
  <tr>
    <td height="20" bordercolor="#999999"  bgcolor="#336633" class="Estilo13" ALIGN="CENTER">LISTADO DE PAGOS</td>
  </tr>
  <tr>
    <td valign="top">
	<table width="100%" border="0" bordercolor="#999999">
		<tr height="20" class="Estilo8">
	        <td>RUT: </td>
			<td><INPUT TYPE="text" NAME="TX_RUT" value="<%=strrut%>"onchange="Ingresa();"></td>
		</tr>
		<%if strrut <> "" then
			if sucursal = "0" then
				sql="select id_pago,rendido, CONVERT(varchar(10), fecha_pago, 103) AS fecha_pago,comp_ingreso,  sucursal.des_suc, caja_cliente.desc_cliente, rutdeudor, monto_capital, monto_cps, caja_tipo_pago.desc_tipo_pago,usringreso from caja_web_cps,caja_cliente,caja_tipo_pago,sucursal where caja_cliente.id_cliente =caja_web_cps.cod_cliente and caja_tipo_pago.id_tipo_pago = caja_web_cps.tipo_pago and sucursal.cod_suc = caja_web_cps.sucursal and caja_web_cps.rutdeudor='" & strrut & "' and caja_web_cps.estado_caja='A'"
			else
				sql="select id_pago,rendido, CONVERT(varchar(10), fecha_pago, 103) AS fecha_pago,comp_ingreso,  sucursal.des_suc, caja_cliente.desc_cliente, rutdeudor, monto_capital, monto_cps, caja_tipo_pago.desc_tipo_pago,usringreso from caja_web_cps,caja_cliente,caja_tipo_pago,sucursal where caja_cliente.id_cliente =caja_web_cps.cod_cliente and caja_tipo_pago.id_tipo_pago = caja_web_cps.tipo_pago and sucursal.cod_suc = caja_web_cps.sucursal and caja_web_cps.rutdeudor='" & strrut & "' and caja_web_cps.sucursal='" & sucursal & "' and caja_web_cps.estado_caja='A'"
			end if
		end if
		%>
		<tr height="20" class="Estilo8">
	        <td>CODIGO PAGO: </td>
			<td ><INPUT TYPE="text" NAME="TX_pago" value="<%=codpago%>" onchange="Ingresa();"></td>
		</tr>
		<%if codpago <> "" then
			if sucursal = "0" then
				sql="select id_pago,rendido, CONVERT(varchar(10), fecha_pago, 103) AS fecha_pago,comp_ingreso,  sucursal.des_suc, caja_cliente.desc_cliente, rutdeudor, monto_capital, monto_cps, caja_tipo_pago.desc_tipo_pago,usringreso from caja_web_cps,caja_cliente,caja_tipo_pago,sucursal where caja_cliente.id_cliente =caja_web_cps.cod_cliente and caja_tipo_pago.id_tipo_pago = caja_web_cps.tipo_pago and sucursal.cod_suc = caja_web_cps.sucursal and caja_web_cps.id_pago=" & codpago & " and caja_web_cps.estado_caja='A'"
			else
				sql="select id_pago,rendido, CONVERT(varchar(10), fecha_pago, 103) AS fecha_pago,comp_ingreso,  sucursal.des_suc, caja_cliente.desc_cliente, rutdeudor, monto_capital, monto_cps, caja_tipo_pago.desc_tipo_pago,usringreso from caja_web_cps,caja_cliente,caja_tipo_pago,sucursal where caja_cliente.id_cliente =caja_web_cps.cod_cliente and caja_tipo_pago.id_tipo_pago = caja_web_cps.tipo_pago and sucursal.cod_suc = caja_web_cps.sucursal and caja_web_cps.id_pago=" & codpago & " and caja_web_cps.sucursal='" & sucursal & "' and caja_web_cps.estado_caja='A'"
			end if
		end if
		%>
	</table>
	<table width="100%" border="0" bordercolor="#999999">
	      <tr height="20" bordercolor="#999999"  bgcolor="#336633" class="Estilo13">
		  <%if perfil="caja_modif" or perfil = "caja_listado" then%>
	        <td>SUCURSAL</td>
			<%end if%>
			<td>USUARIO</td>
			<td>DESDE</td>
			<td>HASTA</td>
	      </tr>
		  <tr bordercolor="#999999" class="Estilo8">
		  <%if perfil="caja_modif" or perfil = "caja_listado" then%>
	        <td>
				<SELECT NAME="cmb_sucursal" id="cmb_sucursal" onchange="Refrescar();">
				<option value="0">TODAS</option>
				<%
				ssql="SELECT * FROM sucursal where cod_suc > 0 order by cod_suc"
				set rsSuc=ConexionSCG.execute(ssql)
				if not rsSuc.eof then
					do until rsSuc.eof
					%>
					<option value="<%=rsSuc("cod_suc")%>"
					<%if Trim(sucursal)=Trim(rsSuc("cod_suc")) then
						response.Write("Selected")
					end if%>
					><%=ucase(rsSuc("cod_suc") & " - " & rsSuc("DES_suc"))%></option>

					<%rsSuc.movenext
					loop
				end if
				rsSuc.close
				set rsSuc=nothing
				%>
				</SELECT>
			</td>
			<%end if%>
			<td>
				<SELECT NAME="cmb_usuario" id="cmb_usuario" onchange="Refrescar();">
				<option value="0">TODOS</option>
				<%
				ssql="select * from USUARIO where cod_tipo_usuario=1 and PER_CAJAWEB <> 'NULL' and sucursal= " & sucursal & " order by login"
				set rsUsu=Conn.execute(ssql)
				if not rsUsu.eof then
					do until rsUsu.eof
					%>
					<option value="<%=rsUsu("cod_usuario")%>"
					<%if Trim(usuario)=Trim(rsUsu("cod_usuario")) then
						response.Write("Selected")
					end if%>
					><%=ucase(rsUsu("login"))%></option>

					<%rsUsu.movenext
					loop
				end if
				rsUsu.close
				set rsUsu=nothing
				%>
				</SELECT>
			</td>
			<td><input name="inicio" type="text" id="inicio" value="<%=inicio%>" size="10" maxlength="10">
		<a href="javascript:showCal('Calendar7');"><img src="../../images/calendario.gif" border="0"></a>
			</td>
			<td><input name="termino" type="text" id="termino" value="<%=termino%>" size="10" maxlength="10">
          <a href="javascript:showCal('Calendar6');"><img src="../../images/calendario.gif" border="0"></a>
			<input type="button" name="Submit" value="Ver" onClick="envia();"><!-- <input type="button" name="Submit" value="Excel" onClick="envia_excel();"> --></td>
	      </tr>
    </table>
	<table width="100%" border="0" bordercolor="#000000">
		<tr bordercolor="#999999"  bgcolor="#336633" class="Estilo13">
			<td width="5%">COD. PAGO</td>
			<td width="8%">USUARIO INGRESO</td>
			<td width="8%">FECHA PAGO</td>
			<td width="10%">SUCURSAL</td>
			<td width="15%">CLIENTE</td>
			<td width="15%">COMP. INGRESO</td>
			<td width="10%">RUT DEUDOR</td>
			<td width="5%">MONTO CAPITAL</td>
			<td width="5%">MONTO INTERCAPITAL</td>
			<td width="5%">TIPO PAGO</td>
			<td width="14%"></td>
		</tr>
	<% if resp="si" then
		if sucursal = "0" then
			if usuario= "0" then
				SQL="select id_pago,rendido, CONVERT(varchar(10), fecha_pago, 103) AS fecha_pago,comp_ingreso, sucursal.des_suc, caja_cliente.desc_cliente, rutdeudor, monto_capital, monto_cps, caja_tipo_pago.desc_tipo_pago,usringreso from caja_web_cps,caja_cliente,caja_tipo_pago,sucursal where caja_cliente.id_cliente =caja_web_cps.cod_cliente and caja_tipo_pago.id_tipo_pago = caja_web_cps.tipo_pago and sucursal.cod_suc = caja_web_cps.sucursal and rendido between '" & inicio & "' and '" & termino & "' and caja_web_cps.estado_caja='A' order by rendido"
			else
				SQL="select id_pago,rendido, CONVERT(varchar(10), fecha_pago, 103) AS fecha_pago,comp_ingreso, sucursal.des_suc, caja_cliente.desc_cliente, rutdeudor, monto_capital, monto_cps, caja_tipo_pago.desc_tipo_pago,usringreso from caja_web_cps,caja_cliente,caja_tipo_pago,sucursal where caja_cliente.id_cliente =caja_web_cps.cod_cliente and caja_tipo_pago.id_tipo_pago = caja_web_cps.tipo_pago and sucursal.cod_suc = caja_web_cps.sucursal and usringreso=" & usuario & " and rendido between '" & inicio & "' and '" & termino & "' and caja_web_cps.estado_caja='A' order by rendido"
			end if
		else
			if usuario = "0" then
				SQL="select id_pago,rendido, CONVERT(varchar(10), fecha_pago, 103) AS fecha_pago,comp_ingreso,  sucursal.des_suc, caja_cliente.desc_cliente, rutdeudor, monto_capital, monto_cps, caja_tipo_pago.desc_tipo_pago,usringreso from caja_web_cps,caja_cliente,caja_tipo_pago,sucursal where caja_cliente.id_cliente =caja_web_cps.cod_cliente and caja_tipo_pago.id_tipo_pago = caja_web_cps.tipo_pago and sucursal.cod_suc = caja_web_cps.sucursal and sucursal='" & sucursal & "' and rendido between '" & inicio & "' and '" & termino & "' and caja_web_cps.estado_caja='A' order by rendido"
			else
				SQL="select id_pago,rendido, CONVERT(varchar(10), fecha_pago, 103) AS fecha_pago,comp_ingreso,  sucursal.des_suc, caja_cliente.desc_cliente, rutdeudor, monto_capital, monto_cps, caja_tipo_pago.desc_tipo_pago,usringreso from caja_web_cps,caja_cliente,caja_tipo_pago,sucursal where caja_cliente.id_cliente =caja_web_cps.cod_cliente and caja_tipo_pago.id_tipo_pago = caja_web_cps.tipo_pago and sucursal.cod_suc = caja_web_cps.sucursal and sucursal='" & sucursal & "' and  usringreso=" & usuario & " and rendido between '" & inicio & "' and '" & termino & "' and caja_web_cps.estado_caja='A' order by rendido"
			end if
		end if
	end if
		'response.write(SQL)
		'response.end
	if sql <> "" then
		set rsDet=ConexionSCG.execute(SQL)

		if not rsDet.eof then
			do while not rsDet.eof
				ssql="select * from usuario where cod_usuario = " & rsDet("usringreso") & ""
				set rsUsuIng=Conn.execute(ssql)
				if not rsUsuIng.eof then
					usringreso= rsUsuIng("login")
				end if
			%>
			<tr bgcolor="#99FFCC" class="Estilo8">
				<td><A HREF="cambio_doc_caja_web.asp?cod_pago=<%=rsDet("id_pago")%>"><%=rsDet("id_pago")%></A></td>
				<td><%=usringreso%></td>
				<td><%=rsDet("fecha_pago")%></td>
				<td><%=rsDet("des_suc")%></td>
				<td><%=rsDet("desc_cliente")%></td>
				<td><%=rsDet("comp_ingreso")%></td>
				<td><%=rsDet("rutdeudor")%></td>
				<td><%=rsDet("monto_capital")%></td>
				<td><%=rsDet("monto_cps")%></td>
				<td><%=rsDet("desc_tipo_pago")%></td>
				<td><A HREF="cambio_doc_caja_web.asp?cod_pago=<%=rsDet("id_pago")%>">Cambio de Cheque</A></td>
			</tr>
			<%
			rsDet.movenext
			loop
		end if
		%>

	<%end if%>
	</table>
	</td>
   </tr>
  </table>

</form>
