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
	datos.action = "informe_comparendos.asp?resp="+ resp +"";
	datos.submit();
}

function envia()
{
	resp='si'
	datos.action = "informe_comparendos.asp?resp="+ resp +"";
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
    <td height="20" bordercolor="#999999"  bgcolor="#<%=session("COLTABBG")%>" class="Estilo13" ALIGN="CENTER">LISTADO DE COMPARENDOS</td>
  </tr>
  <tr>
    <td valign="top">
	<table width="100%" border="0" bordercolor="#999999">
		<tr height="20" class="Estilo8">
	        <td>RUT: </td>
			<td><INPUT TYPE="text" NAME="TX_RUT" value="<%=strRut%>" onchange="envia();"></td>
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
		ssql="SELECT * FROM CLIENTE WHERE ACTIVO=1"
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
		<td>
			<input name="inicio" type="text" id="inicio" value="<%=inicio%>" size="10" maxlength="10">
			<a href="javascript:showCal('Calendar7');"><img src="../images/calendario.gif" border="0"></a>
		</td>
		<td>
			<input name="termino" type="text" id="termino" value="<%=termino%>" size="10" maxlength="10">
			<a href="javascript:showCal('Calendar6');"><img src="../lib/calendario.gif" border="0"></a>
		</td>
		<td>
			<input type="Button" name="Submit" value="Ver" onClick="envia();">
		</td>

	 </tr>
    </table>
	<table width="100%" border="0" bordercolor="#000000">
		<tr bordercolor="#999999"  bgcolor="#<%=session("COLTABBG")%>" class="Estilo13">
			<td>DEMANDA</td>
			<td>RUT</td>
			<td>F.COMPARENDO</td>
			<td>H.COMP.</td>
			<td>F.DEMANDA</td>
			<td>MANDANTE</td>
			<td>TRIBUNAL</td>
			<td>ROL</td>
			<td>MONTO</td>
		</tr>
	<% If resp="si" then
			strSql = "SELECT IDDEMANDA, RUTDEUDOR, NOMTRIBUNAL, FECHA_INGRESO, FECHA_COMPARENDO, ROLANO, HORA_COMPARENDO, C.DESCRIPCION AS NOMCLIENTE, MONTO "
			strSql = strSql & " FROM DEMANDA D, TRIBUNAL T  , CLIENTE C WHERE D.IDTRIBUNAL = T.IDTRIBUNAL AND D.CODCLIENTE = C.CODCLIENTE "
			strSql = strSql & " AND D.FECHA_COMPARENDO >= '" & inicio & "' AND D.FECHA_COMPARENDO <= '" & termino & "'"
			If cliente <> "" Then
				strSql = strSql & " AND D.CODCLIENTE = '" & CLIENTE & "'"
			END IF
			If strRut <> "" Then
				strSql = strSql & " AND D.RUTDEUDOR = '" & strRut & "'"
			End if
		End if
		'response.write(strSql)
		'response.end
	if strSql <> "" then
		set rsDet=Conn.execute(strSql)

		if not rsDet.eof then
			do while not rsDet.eof
				intMonto = ValNulo(rsDet("MONTO"),"N")
			%>
			<tr bgcolor="#<%=session("COLTABBG2")%>" class="Estilo8">
				<td><A HREF="man_DemandaForm.asp?sintNuevo=0&IDDEMANDA=<%=rsDet("IDDEMANDA")%>"><acronym title="VER DEMANDA"><%=rsDet("IDDEMANDA")%></acronym></A>&nbsp;</td>
				<td><A HREF="principal.asp?rut=<%=rsDet("RUTDEUDOR")%>"><acronym title="Llevar a pantalla de selección"><%=rsDet("RUTDEUDOR")%></acronym></A></td>
				<td><%=rsDet("FECHA_COMPARENDO")%></td>
				<td><%=rsDet("HORA_COMPARENDO")%></td>
				<td><%=rsDet("FECHA_INGRESO")%></td>
				<td><%=rsDet("NOMCLIENTE")%></td>
				<td><%=rsDet("NOMTRIBUNAL")%></td>
				<td><%=rsDet("ROLANO")%></td>
				<td ALIGN="RIGHT"><%=FN(intMonto,0)%></td>
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
			<td>&nbsp</td>
			<td>&nbsp</td>
			<td>&nbsp</td>
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

