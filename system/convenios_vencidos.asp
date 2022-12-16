<% @LCID = 1034 %>

<!--#include file="sesion.asp"-->
<!--#include file="arch_utils.asp"-->
<!--#include file="../lib/comunes/rutinas/funciones.inc" -->
<!--#include file="../lib/comunes/rutinas/TraeCampo.inc" -->
<!--#include file="asp/comunes/general/rutinasSCG.inc" -->

<!--#include file="lib.asp"-->



<!--#include file="../lib/comunes/rutinas/chkFecha.inc"-->
<!--#include file="../lib/comunes/rutinas/sondigitos.inc"-->
<!--#include file="../lib/comunes/rutinas/formatoFecha.inc"-->
<!--#include file="../lib/comunes/rutinas/validarFecha.inc"-->
<!--#include file="../lib/comunes/rutinas/diasEnMes.inc"-->


<%
	cod_caja=Session("intCodUsuario")

	AbrirSCG()
	intCodConvenio = request("TX_pago")
	strRut=request("TX_RUT")
	usuario = request("cmb_usuario")
	if usuario = "" then usuario = "0"
	termino = request("termino")
	inicio = request("inicio")
	resp = request("resp")
	resp="si"
	if Trim(inicio) = "" Then
		inicio = TraeFechaActual(Conn)
	End If
	if Trim(termino) = "" Then
		termino = TraeFechaActual(Conn)
	End If
	CLIENTE = REQUEST("CLIENTE")

	strAgrupado=Request("strAgrupado")

	'Response.write "CLIENTE=" & CLIENTE
	'hoy=date

	'response.write(hoy)
%>
<title></title>
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
	datos.action = "convenios_vencidos.asp?resp="+ resp +"";
	datos.submit();
}

function envia()
{
	resp='si'
	datos.action = "convenios_vencidos.asp?resp="+ resp +"";
	datos.submit();
}

function enviaA()
{
	resp='si'
	datos.action = "convenios_vencidos.asp?strAgrupado=S&resp="+ resp +"";
	datos.submit();
}

function envia_excel(URL){

window.open(URL,"INFORMACION","width=200, height=200, scrollbars=yes, menubar=yes, location=yes, resizable=yes")
}
</script>


<link href="style.css" rel="Stylesheet">

<form name="datos" method="post">
<table width="850" height="500" border="1">
  <tr>
    <td height="20" bordercolor="#999999"  bgcolor="#<%=session("COLTABBG")%>" class="Estilo13" ALIGN="CENTER">LISTADO DE CONVENIOS VENCIDOS</td>
  </tr>
  <tr>
    <td valign="top">
	<table width="100%" border="0" bordercolor="#999999">
		<tr height="20" class="Estilo8">
	        <td>RUT: </td>
			<td><INPUT TYPE="text" NAME="TX_RUT" value="<%=strRut%>" onchange="envia();"></td>
		</tr>
		<tr height="20" class="Estilo8">
	        <td>CODIGO CONVENIO: </td>
			<td ><INPUT TYPE="text" NAME="TX_pago" value="<%=intCodConvenio%>" onchange="envia();"></td>
		</tr>
	</table>
	<table width="100%" border="0" bordercolor="#999999">

	      <tr height="20" bordercolor="#999999"  bgcolor="#<%=session("COLTABBG")%>" class="Estilo13">
		  	<td>CLIENTE</td>
		 	<td>DESDE</td>
		 	<td>HASTA</td>
		 	<td>&nbsp;</td>
			</tr>
		  <tr bordercolor="#999999" class="Estilo8">
		  <td>

		<select name="CLIENTE" ID = "CLIENTE" width="15" onchange="tipopago()">
		<option value="">SELECCIONAR</option>
		<%
		ssql="SELECT * FROM CLIENTE WHERE ACTIVO=1 AND CODCLIENTE IN (SELECT CODCLIENTE FROM USUARIO_CLIENTE WHERE ID_USUARIO = " & session("session_idusuario") & ")"
		set rsCLI=Conn.execute(ssql)
		if not rsCLI.eof then
			do until rsCLI.eof
			%>
			<option value="<%=rsCLI("CODCLIENTE")%>"
			<%if Trim(cliente)=Trim(rsCLI("CODCLIENTE")) then
				response.Write("Selected")
			end if%>
			><%=ucase(rsCLI("DESCRIPCION"))%></option>

			<%rsCLI.movenext
			loop
		end if
		rsCLI.close
		set rsCLI=nothing
		%>
        </select>
        </td>
		  <td><input name="inicio" type="text" id="inicio" value="<%=inicio%>" size="10" maxlength="10">
			<a href="javascript:showCal('Calendar7');">
			<img src="../images/calendario.gif" border="0">
			</a>
			</td>
		<td><input name="termino" type="text" id="termino" value="<%=termino%>" size="10" maxlength="10">
			<a href="javascript:showCal('Calendar7');">
			<img src="../images/calendario.gif" border="0">
			</a>
		</td>
		<td>
			<input type="Button" name="Submit" value="Ver Detalle" onClick="envia();">
			<input type="Button" name="Submit" value="Ver Agrupado" onClick="enviaA();">
		</td>
			 </tr>
    </table>
	<table width="100%" border="0" bordercolor="#000000">
		<tr bordercolor="#999999"  bgcolor="#<%=session("COLTABBG")%>" class="Estilo13">
			<td>COD. CONV</td>
			<td>CUOTA</td>
			<td>MONTO</td>
			<td>FECHA</td>
			<td>MANDANTE</td>
			<td>RUT</td>
			<td>CONVENIO</td>
		</tr>
	<% If resp="si" then

			If trim(strAgrupado)="S" Then
				strSql = "SELECT D.ID_CONVENIO, COUNT(*) AS CUOTA, sum(TOTAL_CUOTA) AS TOTAL_CUOTA, CONVERT(VARCHAR(10),min(FECHA_PAGO),103) as FECHA_PAGO, E.COD_CLIENTE,E.RUTDEUDOR , IsNull(datediff(d,mIN(FECHA_PAGO),getdate()),0) as ANTIGUEDAD FROM CONVENIO_DET D, CONVENIO_ENC E WHERE D.ID_CONVENIO = E.ID_CONVENIO AND D.FECHA_PAGO >= '" & inicio & "' AND D.FECHA_PAGO <= '" & termino & "' AND D.PAGADA IS NULL"
			Else
				strSql = "SELECT D.ID_CONVENIO, CUOTA, TOTAL_CUOTA, CONVERT(VARCHAR(10),FECHA_PAGO,103) as FECHA_PAGO, E.COD_CLIENTE,E.RUTDEUDOR , IsNull(datediff(d,FECHA_PAGO,getdate()),0) as ANTIGUEDAD"
				strSql = strSql & " FROM CONVENIO_DET D, CONVENIO_ENC E WHERE D.ID_CONVENIO = E.ID_CONVENIO "
				strSql = strSql & " AND D.FECHA_PAGO >= '" & inicio & "' AND D.FECHA_PAGO <= '" & termino & "' AND D.PAGADA IS NULL"
			End If

			strSql = strSql & " AND E.COD_CLIENTE IN (SELECT CODCLIENTE FROM USUARIO_CLIENTE WHERE ID_USUARIO = " & session("session_idusuario") & ")"

			If cliente <> "" Then
				strSql = strSql & " AND E.COD_CLIENTE = '" & CLIENTE & "'"
			End if

			If strRut <> "" Then
				strSql = strSql & " AND E.RUTDEUDOR = '" & strRut & "'"
			End if

			If intCodConvenio <> "" Then
				strSql = strSql & " AND E.ID_CONVENIO = " & intCodConvenio
			End if

			If trim(strAgrupado)="S" Then
				strSql = strSql & " GROUP BY D.ID_CONVENIO, E.COD_CLIENTE, E.RUTDEUDOR"
			End if
		End if
		'response.write(strSql)
		'response.end
	if strSql <> "" then
		set rsDet=Conn.execute(strSql)

		if not rsDet.eof then
			do while not rsDet.eof
				intTotalCuota = ValNulo(rsDet("TOTAL_CUOTA"),"N")
				intCuota = ValNulo(rsDet("CUOTA"),"N")
				If Trim(intCuota)= "0" Then
					strCuota="PIE"
				Else
					strCuota=intCuota
				End if
				intTotalCuota = ValNulo(rsDet("TOTAL_CUOTA"),"N")
				intTotalTotalCuota = intTotalTotalCuota + ValNulo(rsDet("TOTAL_CUOTA"),"N")

			%>
			<tr bgcolor="#<%=session("COLTABBG2")%>" class="Estilo8">
				<td><%=rsDet("ID_CONVENIO")%></td>
				<td><%=strCuota%></td>
				<td ALIGN="RIGHT"><%=FN(intTotalCuota,0)%></td>
				<td><%=rsDet("FECHA_PAGO")%></td>
				<td><%=rsDet("COD_CLIENTE")%></td>
				<td>
					<A HREF="principal.asp?rut=<%=rsDet("rutdeudor")%>"><acronym title="Llevar a pantalla de selección"><%=rsDet("rutdeudor")%></acronym></A>
				</td>
				<td><A HREF="det_convenio.asp?id_convenio=<%=rsDet("ID_CONVENIO")%>"><acronym title="VER CONVENIO">Ver </acronym></A>&nbsp;<%=rsDet("ID_CONVENIO")%></td>
				<!--td><A HREF="caja\caja_web.asp?CB_TIPOPAGO=CO&id_convenio=<%=rsDet("ID_CONVENIO")%>&rut=<%=rsDet("RUTDEUDOR")%>"><acronym title="PAGO DE CUOTAS DEL CONVENIO">Pagar Cuota</acronym></A></td-->
				</tr>
			<%
			rsDet.movenext
			loop
		end if
		%>

	<%end if%>
		<tr bgcolor="#<%=session("COLTABBG2")%>" class="Estilo8">
			<td>&nbsp</td>
			<td>&nbsp</td>
			<td ALIGN="RIGHT"><%=FN(intTotalTotalCuota,0)%></td>
			<td>&nbsp</td>
			<td>&nbsp</td>
			<td>&nbsp</td>
			<td>&nbsp</td>
		</tr>
	</table>
	</td>
   </tr>
  </table>

</form>

