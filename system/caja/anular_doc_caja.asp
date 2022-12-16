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
	usuario=Session("intCodUsuario")
	'usuario=110
	strsql="select * from usuario where cod_usuario = " & usuario & ""
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
	fecha=date
	if sucursal="" then sucursal="0"
	'response.write(sucursal)
	'usuario = request("cmb_usuario")
	'if usuario = "" then usuario = "0"
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
	if resp = "si" then
		doc = request("com_doc")
		strdoc=request("TX_DOC")
		strSql = "EXEC UPD_SEC 'CAJA_WEB_CPS'"
		set rsPago=ConexionSCG.execute(strSql)
		If not rsPago.Eof then
			intSeq = rsPago("SEQ")
		End if
		if doc = 1 then
			estado="CN"
			sql="insert into CAJA_WEB_CPS (ID_PAGO,RENDIDO,fecha_pago,PERIODO,SUCURSAL,COD_CLIENTE,COMP_INGRESO,TIPO_PAGO,USRINGRESO,ESTADO_CAJA) values(" & intSeq & ",'" & fecha & "','" & fecha & "',YEAR(getdate()),'" & sucursal & "','INT'," & strdoc  & ",'PT'," & usuario & ",'" & estado & "')"

			%>
			<script>alert("El Comprobante de Ingreso fue anulado")</script>
			<%
			Response.Write ("<script language = ""Javascript"">" & vbCrlf)
			Response.Write (vbTab & "location.href='anular_doc_caja.asp?rut=" & rut & "&tipo=1'" & vbCrlf)
			Response.Write ("</script>")
		end if
		if doc = 2 then
			estado="BN"
			sql="insert into CAJA_WEB_CPS (ID_PAGO,RENDIDO,fecha_pago,PERIODO,SUCURSAL,COD_CLIENTE,NRO_BOLETA,TIPO_PAGO,USRINGRESO,ESTADO_CAJA) values(" & intSeq & ",'" & fecha & "','" & fecha & "',YEAR(getdate()),'" & sucursal & "','INT'," & strdoc  & ",'PT'," & usuario & ",'" & estado & "')"
			'set rsInser=ConexionSCG.execute(SQL)
			%>
			<script>alert("El N° de boleta fue anulado")</script>
			<%
			Response.Write ("<script language = ""Javascript"">" & vbCrlf)
			Response.Write (vbTab & "location.href='anular_doc_caja.asp?rut=" & rut & "&tipo=1'" & vbCrlf)
			Response.Write ("</script>")
		end if
		'response.write(sql)
		'response.end
		set rsInser=ConexionSCG.execute(SQL)
		'intSeq=651
		SQL = "INSERT INTO CAJA_WEB_CPS_DETALLE (ID_PAGO, CORRELATIVO, CLAVEDEUDOR, NRO_LIQUIDACION, PERIODO_PAGADO, CAPITAL)values(" & intSeq & ",1,0,0,0,0)"
		set rsDet=ConexionSCG.execute(SQL)

		SQL = "INSERT INTO CAJA_WEB_cps_DOC_PAGO (ID_PAGO, CORRELATIVO, MONTO, tipo_pago, forma_pago)values(" & intSeq & ",1,0,0,'EF')"
		set rsdoc=ConexionSCG.execute(SQL)
		response.write(sql)
	end if
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
	datos.action = "detalle_caja.asp?resp="+ resp +"";
	datos.submit();
}

function Ingresa()
{
	with( document.datos )
	{
		action = "detalle_caja.asp";
		submit();
	}
}

function envia()
{
	//datos.TX_RUT.value='';
	//datos.TX_pago.value='';
	resp='si'
	datos.action = "anular_doc_caja.asp?resp="+ resp +"";
	datos.submit();
}

function envia_excel(URL){

window.open(URL,"INFORMACION","width=200, height=200, scrollbars=yes, menubar=yes, location=yes, resizable=yes")
}
</script>


<link href="style.css" rel="Stylesheet">

<form name="datos" method="post">
<table width="800" height="500" border="1">
  <tr>
    <td height="20" bordercolor="#999999"  bgcolor="#336633" class="Estilo13" ALIGN="CENTER">ANULAR DOCUMENTOS</td>
  </tr>
  <tr>
    <td valign="top">
	<table width="100%" border="0" bordercolor="#999999">
		<tr height="20" class="Estilo8">
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
					><%=ucase(rsSuc("DES_suc"))%></option>

					<%rsSuc.movenext
					loop
				end if
				rsSuc.close
				set rsSuc=nothing
				%>
				</SELECT>
			</td>
			<%end if%>
	        <td><SELECT NAME="com_doc">
				<option value="1">COMPROBANTE INGRESO</option>
				<option value="2">BOLETA</option>
			</SELECT></td>
			<td><INPUT TYPE="text" NAME="TX_DOC"></td>
		</tr>
		<tr>
			<td></td>
			<td></td>
			<td><INPUT TYPE="button" value="GUARDAR" onclick="envia();"></td>
		</tr>
	</table>
	</td>
   </tr>
  </table>

</form>
