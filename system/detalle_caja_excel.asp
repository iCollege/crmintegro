<%@ Language=VBScript %>
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
	Response.Buffer = TRUE
	Response.ContentType = "application/vnd.ms-excel"
	'cod_caja=71
	cod_caja=Session("intCodUsuario")
	strsql="select * from usuario where cod_usuario = " & cod_caja & ""
	set rsUsu=Conn.execute(strsql)
	if not rsUsu.eof then
		perfil=rsUsu("per_cajaweb")
		if perfil = "caja_modif" or perfil = "caja_listado" then
			sucursal = request("sucursal")
		else
			sucursal = rsUsu("sucursal")
		end if
	end if
	sw=0
	strrut=request("strrut")
	'response.write(strrut)
	codpago = request("codpago")
	if sucursal="" then sucursal="0"
	'response.write(sucursal)
	if sucursal <> 0 then
	ssql="select * from sucursal where cod_suc=" & sucursal & ""
	set rsSuc=ConexionSCG.execute(ssql)
	if not rssuc.eof then
		nomsucursal=UCASE(rsSuc("des_suc"))
	end if
	else
		nomsucursal="TODAS"
	end if
	usuario = request("usuario")
	if usuario = "" then usuario = "0"
	termino = request("termino")
	inicio = request("inicio")
	resp = request("resp")
	CLIENTE = REQUEST("CLIENTE")
	'response.write cliente
	'if Trim(inicio) = "" Then
	'	inicio = TraeFechaMesActual(conexionSCG,0)
	'	inicio = "01" & Mid(inicio,3,10)
	'End If

	'if Trim(termino) = "" Then
	'	termino = TraeFechaActual(conexionSCG)
	'End If
%>
<title>Intercapital</title>

<script language="JavaScript" src="../../comunes/lib/cal2.js"></script>
<script language="JavaScript" src="../../comunes/lib/cal_conf2.js"></script>
<script language="JavaScript" src="../../comunes/lib/validaciones.js"></script>
<script src="../../comunes/general/SelCombox.js"></script>
<script src="../../comunes/general/OpenWindow.js"></script>


<script language="JavaScript " type="text/JavaScript">

function Refrescar()
{
	resp='no'
	datos.action = "detalle_caja_old.asp?resp="+ resp +"";
	datos.submit();
}

function Ingresa()
{
	with( document.datos )
	{
		action = "detalle_caja_old.asp";
		submit();
	}
}

function envia()
{
	resp='si'
	datos.action = "detalle_caja.asp?resp="+ resp +"";
	datos.submit();
}


</script>


<link href="style.css" rel="Stylesheet">

<form name="datos" method="post">
<table width="800" height="500" border="1">
  <!-- <tr>
    <td height="20" bgcolor="#006699" class="Estilo13"></td>
  </tr> -->
  <tr>
    <td valign="top">
	<!-- <table width="100%" border="0" bordercolor="#FFFFFF">
		<tr height="20" class="Estilo8">
		</tr> -->
		<%if strrut <> "" then
			sw=1
			if sucursal="0" then
				sql="select cwc.id_pago,cwc.rendido, CONVERT(varchar(10), cwc.fecha_pago, 103) AS fecha_pago,s.des_suc, cc.desc_cliente as nombre, cwc.rutdeudor,cwc.comp_ingreso,cwc.nro_boleta,cwc.monto_capital,cwc.monto_cps, ctp.desc_tipo_pago,cwc.nro_deposito_cliente,cwc.nro_deposito_cps,cwc.bco_deposito_cliente,cwc.bco_deposito_cps,cwc.usringreso,cwc.desc_cliente,cwc.desc_cps,cwc.total_cliente,cwc.total_cps,cwc.interes_plazo,cwc.costas_cps,cwc.estado_caja,sum(cwcdp.monto) as monto,cwcdp.forma_pago from caja_web_cps cwc,caja_cliente cc,caja_tipo_pago ctp,sucursal s,CAJA_WEB_CPS_DOC_PAGO cwcdp  where cc.id_cliente =cwc.cod_cliente and ctp.id_tipo_pago = cwc.tipo_pago and cwcdp.id_pago=cwc.id_pago and cwcdp.tipo_pago in (0,1) and s.cod_suc = cwc.sucursal and cwc.rutdeudor='" & strrut & "' group by cwc.id_pago,cwc.rendido, cwc.fecha_pago,s.des_suc, cc.desc_cliente,cwc.rutdeudor,cwc.comp_ingreso,cwc.nro_boleta,cwc.monto_capital,cwc.monto_cps, ctp.desc_tipo_pago,cwc.nro_deposito_cliente,cwc.nro_deposito_cps,cwc.bco_deposito_cliente,cwc.bco_deposito_cps,cwc.usringreso,cwc.desc_cliente,cwc.desc_cps,cwcdp.monto,cwcdp.forma_pago,cwc.total_cliente,cwc.total_cps,cwc.interes_plazo,cwc.costas_cps,cwc.estado_caja order by rendido"
			else
				sql="select cwc.id_pago,cwc.rendido, CONVERT(varchar(10), cwc.fecha_pago, 103) AS fecha_pago,s.des_suc, cc.desc_cliente as nombre, cwc.rutdeudor,cwc.comp_ingreso,cwc.nro_boleta,cwc.monto_capital,cwc.monto_cps, ctp.desc_tipo_pago,cwc.nro_deposito_cliente,cwc.nro_deposito_cps,cwc.bco_deposito_cliente,cwc.bco_deposito_cps,cwc.usringreso,cwc.desc_cliente,cwc.desc_cps,cwc.total_cliente,cwc.total_cps,cwc.interes_plazo,cwc.costas_cps,cwc.estado_caja,sum(cwcdp.monto) as monto,cwcdp.forma_pago from caja_web_cps cwc,caja_cliente cc,caja_tipo_pago ctp,sucursal s,CAJA_WEB_CPS_DOC_PAGO cwcdp  where cc.id_cliente =cwc.cod_cliente and ctp.id_tipo_pago = cwc.tipo_pago and cwcdp.id_pago=cwc.id_pago and cwcdp.tipo_pago in (0,1) and s.cod_suc = cwc.sucursal and cwc.rutdeudor='" & strrut & "' and cwc.sucursal ='" & sucursal & "' group by cwc.id_pago,cwc.rendido, cwc.fecha_pago,s.des_suc, cc.desc_cliente,cwc.rutdeudor,cwc.comp_ingreso,cwc.nro_boleta,cwc.monto_capital,cwc.monto_cps, ctp.desc_tipo_pago,cwc.nro_deposito_cliente,cwc.nro_deposito_cps,cwc.bco_deposito_cliente,cwc.bco_deposito_cps,cwc.usringreso,cwc.desc_cliente,cwc.desc_cps,cwcdp.monto,cwcdp.forma_pago,cwc.total_cliente,cwc.total_cps,cwc.interes_plazo,cwc.costas_cps,cwc.estado_caja order by rendido"
			end if
		end if
		%>
		<%if codpago <> "" then
			sw=1
			if sucursal = "0" then
				sql="select cwc.id_pago,cwc.rendido, CONVERT(varchar(10), cwc.fecha_pago, 103) AS fecha_pago,s.des_suc, cc.desc_cliente as nombre, cwc.rutdeudor,cwc.comp_ingreso,cwc.nro_boleta,cwc.monto_capital,cwc.monto_cps, ctp.desc_tipo_pago,cwc.nro_deposito_cliente,cwc.nro_deposito_cps,cwc.bco_deposito_cliente,cwc.bco_deposito_cps,cwc.usringreso,cwc.desc_cliente,cwc.desc_cps,cwc.total_cliente,cwc.total_cps,cwc.interes_plazo,cwc.costas_cps,cwc.estado_caja,sum(cwcdp.monto) as monto,cwcdp.forma_pago from caja_web_cps cwc,caja_cliente cc,caja_tipo_pago ctp,sucursal s,CAJA_WEB_CPS_DOC_PAGO cwcdp  where cc.id_cliente =cwc.cod_cliente and ctp.id_tipo_pago = cwc.tipo_pago and cwcdp.id_pago=cwc.id_pago and cwcdp.tipo_pago in (0,1) and s.cod_suc = cwc.sucursal and cwc.id_pago=" & codpago & " group by cwc.id_pago,cwc.rendido, cwc.fecha_pago,s.des_suc, cc.desc_cliente,cwc.rutdeudor,cwc.comp_ingreso,cwc.nro_boleta,cwc.monto_capital,cwc.monto_cps, ctp.desc_tipo_pago,cwc.nro_deposito_cliente,cwc.nro_deposito_cps,cwc.bco_deposito_cliente,cwc.bco_deposito_cps,cwc.usringreso,cwc.desc_cliente,cwc.desc_cps,cwcdp.monto,cwcdp.forma_pago,cwc.total_cliente,cwc.total_cps,cwc.interes_plazo,cwc.costas_cps,cwc.estado_caja order by rendido"
			else
				sql="select cwc.id_pago,cwc.rendido, CONVERT(varchar(10), cwc.fecha_pago, 103) AS fecha_pago,s.des_suc, cc.desc_cliente as nombre, cwc.rutdeudor,cwc.comp_ingreso,cwc.nro_boleta,cwc.monto_capital,cwc.monto_cps, ctp.desc_tipo_pago,cwc.nro_deposito_cliente,cwc.nro_deposito_cps,cwc.bco_deposito_cliente,cwc.bco_deposito_cps,cwc.usringreso,cwc.desc_cliente,cwc.desc_cps,cwc.total_cliente,cwc.total_cps,cwc.interes_plazo,cwc.costas_cps,cwc.estado_caja,sum(cwcdp.monto) as monto,cwcdp.forma_pago from caja_web_cps cwc,caja_cliente cc,caja_tipo_pago ctp,sucursal s,CAJA_WEB_CPS_DOC_PAGO cwcdp  where cc.id_cliente =cwc.cod_cliente and ctp.id_tipo_pago = cwc.tipo_pago and cwcdp.id_pago=cwc.id_pago and cwcdp.tipo_pago in (0,1) and s.cod_suc = cwc.sucursal and cwc.id_pago=" & codpago & " and cwc.sucursal ='" & sucursal & "' group by cwc.id_pago,cwc.rendido, cwc.fecha_pago,s.des_suc, cc.desc_cliente,cwc.rutdeudor,cwc.comp_ingreso,cwc.nro_boleta,cwc.monto_capital,cwc.monto_cps, ctp.desc_tipo_pago,cwc.nro_deposito_cliente,cwc.nro_deposito_cps,cwc.bco_deposito_cliente,cwc.bco_deposito_cps,cwc.usringreso,cwc.desc_cliente,cwc.desc_cps,cwcdp.monto,cwcdp.forma_pago,cwc.total_cliente,cwc.total_cps,cwc.interes_plazo,cwc.costas_cps,cwc.estado_caja order by rendido"
			end if
		end if
		%>
	<!-- </table> -->
	<table width="100%" border="1" bordercolor="#000000">
		<tr>
			<td></td>
			<td></td>
			<td></td>
			<td></td>
			<td></td>
			<td></td>
			<td></td>
			<td></td>
			<td></td>
			<td></td>
			<td></td>
			<td></td>
			<td></td>
			<td></td>
			<td></td>
			<td></td>
			<td></td>
			<td></td>
			<td></td>
			<td></td>
			<td></td>
			<td></td>
			<td></td>
			<td></td>
			<td></td>
			<td></td>
			<td></td>
			<td></td>
			<td></td>
			<td></td>
		</tr>
		<tr>
			<td></td>
			<td></td>
			<td>SUCURSAL: </td>
			<td><%=nomsucursal%></td>
			<td></td>
			<td></td>
			<td>FECHA: </td>
			<td><%=date%></td>
			<td></td>
			<td></td>
			<td></td>
			<td></td>
			<td></td>
			<td></td>
			<td></td>
			<td></td>
			<td></td>
			<td></td>
			<td></td>
			<td></td>
			<td></td>
			<td></td>
			<td></td>
			<td></td>
			<td></td>
			<td></td>
			<td></td>
			<td></td>
			<td></td>
			<td></td>
		</tr>
		<tr>
			<td></td>
			<td></td>
			<td></td>
			<td></td>
			<td></td>
			<td></td>
			<td></td>
			<td></td>
			<td></td>
			<td></td>
			<td></td>
			<td></td>
			<td></td>
			<td></td>
			<td></td>
			<td></td>
			<td></td>
			<td></td>
			<td></td>
			<td></td>
			<td></td>
			<td></td>
			<td></td>
			<td></td>
			<td></td>
			<td></td>
			<td></td>
			<td></td>
			<td></td>
			<td></td>
		</tr>
		<tr bordercolor="#999999" bgcolor="#006699" class="Estilo13">
			<td>COD. PAGO</td>
			<td>USUARIO INGRESO</td>
			<td>FECHA PAGO</td>
			<td>SUCURSAL</td>
			<td>CLIENTE</td>
			<td>RUT DEUDOR</td>
			<td>COBRADOR</td>
			<td>COMP. INGRESO</td>
			<td>NRO. BOLETA</td>
			<td>NRO. LIQUIDACION</td>
			<td>TIPO PAGO</td>
			<td>FORMA PAGO</td>
			<td>MONTO CAPITAL</td>
			<td>NRO. DEPOSITO</td>
			<td>BANCO</td>
			<td>INTERES PLAZO</td>
			<td>DESC. CLIENTE</td>
			<td>TOTAL CLIENTE</td>
			<td>MONTO INTER</td>
			<td>NRO. DEP</td>
			<td>BANCO</td>
			<td>COSTAS INTER</td>
			<td>DESC. INTER</td>
			<td>TOTAL INTER</td>
			<td>TOTAL GENERAL</td>
			<td>CONVENIOS</td>
			<td>DEP. CLIENTE</td>
			<td>DEP. INTER</td>
			<td>CHEQUES</td>
			<td>COMP. INGRESO</td>
			<td>BOLETA</td>
			<td>FECHA DEP</td>
			<td>RENDICION</td>

		</tr>
	<% if sw=0 then
		'if sucursal = "0"then
			'if usuario= "0" then
			'	SQL="select cwc.id_pago,cwc.rendido, CONVERT(varchar(10), cwc.fecha_pago, 103) AS fecha_pago,s.des_suc, cc.desc_cliente as nombre, cwc.rutdeudor,cwc.comp_ingreso,cwc.nro_boleta,cwc.monto_capital,cwc.monto_cps, ctp.desc_tipo_pago,cwc.nro_deposito_cliente,cwc.nro_deposito_cps,cwc.bco_deposito_cliente,cwc.bco_deposito_cps,cwc.usringreso,cwc.desc_cliente,cwc.desc_cps,cwc.total_cliente,cwc.total_cps,cwc.interes_plazo,cwc.costas_cps,cwc.estado_caja,sum(cwcdp.monto) as monto,cwcdp.forma_pago from caja_web_cps cwc,caja_cliente cc,caja_tipo_pago ctp,sucursal s,CAJA_WEB_CPS_DOC_PAGO cwcdp where cc.id_cliente =cwc.cod_cliente and ctp.id_tipo_pago = cwc.tipo_pago and cwcdp.id_pago=cwc.id_pago and cwcdp.tipo_pago in (0,1) and s.cod_suc = cwc.sucursal  and rendido between '" & inicio & "' and '" & termino & "' group by cwc.id_pago,cwc.rendido, cwc.fecha_pago,s.des_suc, cc.desc_cliente,cwc.rutdeudor,cwc.comp_ingreso,cwc.nro_boleta,cwc.monto_capital,cwc.monto_cps, ctp.desc_tipo_pago,cwc.nro_deposito_cliente,cwc.nro_deposito_cps,cwc.bco_deposito_cliente,cwc.bco_deposito_cps,cwc.usringreso,cwc.desc_cliente,cwc.desc_cps,cwcdp.monto,cwcdp.forma_pago,cwc.total_cliente,cwc.total_cps,cwc.interes_plazo,cwc.costas_cps,cwc.estado_caja  order by rendido"
			'else
			'	SQL="select cwc.id_pago,cwc.rendido, CONVERT(varchar(10), cwc.fecha_pago, 103)AS fecha_pago,s.des_suc, cc.desc_cliente as nombre, cwc.rutdeudor,cwc.comp_ingreso,cwc.nro_boleta,cwc.monto_capital,cwc.monto_cps, ctp.desc_tipo_pago,cwc.nro_deposito_cliente,cwc.nro_deposito_cps,cwc.bco_deposito_cliente,cwc.bco_deposito_cps,cwc.usringreso,cwc.desc_cliente,cwc.desc_cps,cwc.total_cliente,cwc.total_cps,cwc.interes_plazo,cwc.costas_cps,cwc.estado_caja,sum(cwcdp.monto) as monto,cwcdp.forma_pago from caja_web_cps cwc,caja_cliente cc,caja_tipo_pago ctp,sucursal s,CAJA_WEB_CPS_DOC_PAGO cwcdp where cc.id_cliente =cwc.cod_cliente and ctp.id_tipo_pago = cwc.tipo_pago and cwcdp.id_pago=cwc.id_pago and cwcdp.tipo_pago in (0,1) and s.cod_suc = cwc.sucursal and s.cod_suc = cwc.sucursal and cwc.usringreso='" & usuario & "' and rendido between '" & inicio & "' and '" & termino & "' group by cwc.id_pago,cwc.rendido, cwc.fecha_pago,s.des_suc, cc.desc_cliente,cwc.rutdeudor,cwc.comp_ingreso,cwc.nro_boleta,cwc.monto_capital,cwc.monto_cps, ctp.desc_tipo_pago,cwc.nro_deposito_cliente,cwc.nro_deposito_cps,cwc.bco_deposito_cliente,cwc.bco_deposito_cps,cwc.usringreso,cwc.desc_cliente,cwc.desc_cps,cwcdp.monto,cwcdp.forma_pago,cwc.total_cliente,cwc.total_cps,cwc.interes_plazo,cwc.costas_cps,cwc.estado_caja order by rendido"
			'end if
		'else
		'	if usuario = "0" then
		'		SQL="select cwc.id_pago,cwc.rendido, CONVERT(varchar(10), cwc.fecha_pago, 103)AS fecha_pago,s.des_suc, cc.desc_cliente as nombre, cwc.rutdeudor,cwc.comp_ingreso,cwc.nro_boleta,cwc.monto_capital,cwc.monto_cps, ctp.desc_tipo_pago,cwc.nro_deposito_cliente,cwc.nro_deposito_cps,cwc.bco_deposito_cliente,cwc.bco_deposito_cps,cwc.usringreso,cwc.desc_cliente,cwc.desc_cps,cwc.total_cliente,cwc.total_cps,cwc.interes_plazo,cwc.costas_cps,cwc.estado_caja,sum(cwcdp.monto) as monto,cwcdp.forma_pago from caja_web_cps cwc,caja_cliente cc,caja_tipo_pago ctp,sucursal s,CAJA_WEB_CPS_DOC_PAGO cwcdp where cc.id_cliente =cwc.cod_cliente and ctp.id_tipo_pago = cwc.tipo_pago and cwcdp.id_pago=cwc.id_pago and cwcdp.tipo_pago in (0,1) and s.cod_suc = cwc.sucursal and sucursal='" & sucursal & "' and rendido between '" & inicio & "' and '" & termino & "' group by cwc.id_pago,cwc.rendido, cwc.fecha_pago,s.des_suc, cc.desc_cliente,cwc.rutdeudor,cwc.comp_ingreso,cwc.nro_boleta,cwc.monto_capital,cwc.monto_cps, ctp.desc_tipo_pago,cwc.nro_deposito_cliente,cwc.nro_deposito_cps,cwc.bco_deposito_cliente,cwc.bco_deposito_cps,cwc.usringreso,cwc.desc_cliente,cwc.desc_cps,cwcdp.monto,cwcdp.forma_pago,cwc.total_cliente,cwc.total_cps,cwc.interes_plazo,cwc.costas_cps,cwc.estado_caja order by rendido"
		'	else
		'		SQL="select cwc.id_pago,cwc.rendido, CONVERT(varchar(10), cwc.fecha_pago, 103) AS fecha_pago,s.des_suc, cc.desc_cliente as nombre, cwc.rutdeudor,cwc.comp_ingreso,cwc.nro_boleta,cwc.monto_capital,cwc.monto_cps, ctp.desc_tipo_pago,cwc.nro_deposito_cliente,cwc.nro_deposito_cps,cwc.bco_deposito_cliente,cwc.bco_deposito_cps,cwc.usringreso,cwc.desc_cliente,cwc.desc_cps,cwc.total_cliente,cwc.total_cps,cwc.interes_plazo,cwc.costas_cps,cwc.estado_caja,sum(cwcdp.monto) as monto,cwcdp.forma_pago from caja_web_cps cwc,caja_cliente cc,caja_tipo_pago ctp,sucursal s,CAJA_WEB_CPS_DOC_PAGO cwcdp where cc.id_cliente =cwc.cod_cliente and ctp.id_tipo_pago = cwc.tipo_pago and cwcdp.id_pago=cwc.id_pago and cwcdp.tipo_pago in (0,1) and s.cod_suc = cwc.sucursal and sucursal='" & sucursal & "' and  cwc.usringreso ='" & usuario & "' and rendido between '" & inicio & "' and '" & termino & "' group by cwc.id_pago,cwc.rendido, cwc.fecha_pago,s.des_suc, cc.desc_cliente,cwc.rutdeudor,cwc.comp_ingreso,cwc.nro_boleta,cwc.monto_capital,cwc.monto_cps, ctp.desc_tipo_pago,cwc.nro_deposito_cliente,cwc.nro_deposito_cps,cwc.bco_deposito_cliente,cwc.bco_deposito_cps,cwc.usringreso,cwc.desc_cliente,cwc.desc_cps,cwcdp.monto,cwcdp.forma_pago,cwc.total_cliente,cwc.total_cps,cwc.interes_plazo,cwc.costas_cps,cwc.estado_caja order by rendido"
		'	end if
		'end if
		SQL = "select cwc.id_pago,cwc.rendido, CONVERT(varchar(10), cwc.fecha_pago, 103) AS fecha_pago,s.des_suc, cc.desc_cliente as nombre, cwc.rutdeudor,cwc.comp_ingreso,cwc.nro_boleta,cwc.monto_capital,cwc.monto_cps, ctp.desc_tipo_pago,cwc.nro_deposito_cliente,cwc.nro_deposito_cps,cwc.bco_deposito_cliente,cwc.bco_deposito_cps,cwc.usringreso,cwc.desc_cliente,cwc.desc_cps,cwc.total_cliente,cwc.total_cps,cwc.interes_plazo,cwc.costas_cps,cwc.estado_caja,sum(cwcdp.monto) as monto,cwcdp.forma_pago"
		SQL = SQL & " from caja_web_cps cwc,caja_cliente cc,caja_tipo_pago ctp,sucursal s,CAJA_WEB_CPS_DOC_PAGO cwcdp "
		SQL = SQL & " where cc.id_cliente =cwc.cod_cliente and ctp.id_tipo_pago = cwc.tipo_pago and cwcdp.id_pago=cwc.id_pago and cwcdp.tipo_pago in (0,1) and s.cod_suc = cwc.sucursal"
		IF CLIENTE <> "0" THEN SQL = SQL & " and cwc.cod_cliente = '" & CLIENTE & "'"
		IF SUCURSAL <> "0" THEN SQL = SQL & " and sucursal='" & sucursal & "'"
		IF USUARIO <> "0" THEN SQL = SQL & " and  cwc.usringreso = '" & usuario & "'"
		SQL = SQL & " and rendido between '" & INICIO & "' and '" & TERMINO & "' group by cwc.id_pago,cwc.rendido, cwc.fecha_pago,s.des_suc, cc.desc_cliente,cwc.rutdeudor,cwc.comp_ingreso,cwc.nro_boleta,cwc.monto_capital,cwc.monto_cps, ctp.desc_tipo_pago,cwc.nro_deposito_cliente,cwc.nro_deposito_cps,cwc.bco_deposito_cliente,cwc.bco_deposito_cps,cwc.usringreso,cwc.desc_cliente,cwc.desc_cps,cwcdp.monto,cwcdp.forma_pago,cwc.total_cliente,cwc.total_cps,cwc.interes_plazo,cwc.costas_cps,cwc.estado_caja order by rendido"
	end if
		'response.write(sw)
		'response.write(SQL)
		'response.end
	if sql <> "" then
		set rsDet=ConexionSCG.execute(SQL)

		if not rsDet.eof then
		i=1
		x=0
			do while not rsDet.eof

				sql_nliq = "select nro_liquidacion from usr_web_scg.CAJA_WEB_CPS_DETALLE where id_pago = " & rsDet("id_pago") & ""
				set rsnliq=ConexionSCG.execute(sql_nliq)
				IF NOT rsnliq.EOF THEN
					NLIQUIDACIO = rsnliq("nro_liquidacion")
				ELSE
					NLIQUIDACIO = "0"
				END IF

				sql_rut = "select TOP 1 * from cuota where rutdeudor = '" & rsDet("rutdeudor") & "'"
				set rscobrador=ConexionSCG.execute(sql_rut)
				IF NOT rscobrador.EOF THEN
					COBRADOR = UCASE(rscobrador("CODCOBRADOR"))
				ELSE
					COBRADOR = ""
				END IF
				IF COBRADOR = "0" THEN COBRADOR = ""
				cod_pago=rsDet("id_pago")
				ssql="select * from usuario where cod_usuario = " & rsDet("usringreso") & ""
				set rsUsuIng=Conn.execute(ssql)
				if not rsUsuIng.eof then
					usringreso= rsUsuIng("login")
				end if

				strsql = "select * from t_bancos where ba_codigo='" & rsDet("bco_deposito_cliente") & "'"
				set rsbc=ConexionSCG.execute(strsql)
				if not rsbc.eof then
					bc=rsbc("ba_descripcion")
				else
					bc=""
				end if


				stsql = "select * from t_bancos where ba_codigo='" & rsDet("bco_deposito_cps") & "'"
				set rsbcps=ConexionSCG.execute(stsql)
				if not rsbcps.eof then
					bcps=rsbcps("ba_descripcion")
				else
					bcps=""
				end if
				if rsDet("nro_deposito_cliente")="NULL" then
					ndc=""
				else
					ndc=rsDet("nro_deposito_cliente")
				end if

				if rsDet("nro_deposito_cps")="NULL" then
					ndcps=""
				else
					ndcps=rsDet("nro_deposito_cps")
				end if
				if rsDet("nro_boleta")= "0" then
					boleta = ""
				else
					boleta = rsDet("nro_boleta")
				end if
				sq="select fecha_deposito,replace(nro_rendicion,0,'') as nro_rendicion,replace(deposito_cliente,0,'') as deposito_cliente,replace(deposito_cps,0,'') as deposito_cps,replace(cheques,0,'') as cheques,replace(comp_ingreso,0,'') as comp_ingreso,replace(boleta,0,'') as boleta,replace(convenio,0,'') as convenio,replace(observaciones,0,'') as observaciones from CAJA_WEB_VALIDACION where id_pago=" & cod_pago & ""
				'response.write sq
				'response.end
				set rsCWV=ConexionSCG.execute(sq)
				if not rsCWV.eof then
					strconvenio = rsCWV("convenio")
					strdep_cli = rsCWV("deposito_cliente")
					strdep_cps = rsCWV("deposito_cps")
					strcheques = rsCWV("cheques")
					strcom_ing = rsCWV("comp_ingreso")
					strboleta = rsCWV("boleta")
					fecha_dep = rsCWV("fecha_deposito")
					strRendicion = rsCWV("nro_rendicion")
				end if
				if x=0 then
					color="#99FFCC"
					x=1
				else
					color="#BBFFDD"
					x=0
				end if
			%>
			<tr bgcolor="<%=color%>" class="Estilo8">
				<td><%=rsDet("id_pago")%></td>
				<td><%=usringreso%></td>
				<!-- <td><%=usringreso%></td> -->
				<td><%=rsDet("fecha_pago")%></td>
				<td><%=rsDet("des_suc")%></td>
				<td><%=rsDet("nombre")%></td>
				<td><%=rsDet("rutdeudor")%></td>
				<td><%=COBRADOR%></td>
				<td><%=rsDet("comp_ingreso")%></td>
				<td><%=boleta%></td>
				<td><%=NLIQUIDACIO%></td>
				<td><%=rsDet("desc_tipo_pago")%></td>
				<td><%=rsDet("forma_pago")%></td>
				<td><%=rsDet("monto")%></td>

				<td><%=ndc%></td>
				<td><%=bc%></td>
				<td><%=rsDet("interes_plazo")%></td>
				<td><%=rsDet("desc_cliente")%></td>

				<td><%=rsDet("total_cliente")%></td>
				<td><%=rsDet("monto_cps")%></td>


			<!-- </tr>
			<tr bgcolor="<%=color%>" class="Estilo8"> -->
				<td><%=ndcps%></td>
				<td><%=bcps%></td>
				<td><%=rsDet("costas_cps")%></td>
				<td><%=rsDet("desc_cps")%></td>
				<td><%=rsDet("total_cps")%></td>
				<td><%=rsDet("total_cliente") + rsDet("total_cps")%></td>
				<td></td>
				<td></td>
				<td></td>
				<td></td>
				<td></td>
				<td></td>
				<td></td>
				<td></td>
				<%if rsDet("estado_caja")="N" then estado="NULO"%>
				<%if rsDet("estado_caja")="CN" then estado="COMPROBANTE NULO"%>
				<%if rsDet("estado_caja")="BN" then estado="BOLETA NULA"%>
				<%if rsDet("estado_caja")="A" then estado=""%>
				<td><%=estado%></td>
			</tr>
			<%
			bc=""
			bcps=""
			i = i + 1
			rsDet.movenext
			loop
		end if
	'end if		%>

	<%end if%>
	</table>
	</td>
   </tr>
  </table>

</form>
