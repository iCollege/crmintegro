<% @LCID = 1034 %>
<!--#include file="arch_utils.asp"-->
<!--#include file="lib.asp"-->
<!--#include file="sesion.asp"-->
<!--#include file="../lib/comunes/rutinas/funciones.inc" -->


<%
SSQL="SELECT  login FROM COBRADOR_CLIENTE wHERE (tipo = 'TER')GROUP BY login"
strRut=request("tx_rut")
if strRut ="" then
	strRut = request.querystring("rut")
end if
cliente=request("cm_cliente")
if cliente="" then
	cliente=request.querystring("cliente")
end if
ejecutivo=request("ejecutivo")
'response.write(strRut)
'response.write(cliente)
%>

<html>
<style type="text/css">
<!--
.Estilo30 {color: #FFFFFF}
a:link {
	color: #000000;
	text-decoration: none;
}
a:visited {
	color: #000000;
	text-decoration: none;
}
a:hover {
	text-decoration: none;
}
a:active {
	text-decoration: none;
	color: #FFFFFF;
}
-->
</style>
<head>
	<title>MODULO BACKOFFICE</title>
</head>

<body>
<script language="JavaScript " type="text/JavaScript">
function Refrescar()
{
	//alert("hola")
	//if (rut==''){
	//	alert("Debe ingresar un rut")
	//}else{
	//	with( document.datos )
	//	{
		datos.action = "scg_cobr.asp";
		//alert(action)
		datos.submit();
	//	}
	//}
}

function enviar(){
	if (datos.tx_rut.value==''){
		alert("Debe ingresar un RUT")
	}else if (datos.cm_cliente.value==''){
		alert("Debe seleccionar un cliente")
	}else{
		datos.action = "graba_asignacion.asp";
		datos.submit();
	}
}
</script>
<form name="datos" method="post">
<table width="720" height="450" border="0">
  <tr>
    <td width="827" height="20" class="Estilo20"></td>
  </tr>
  <tr>
    <td height="242" valign="top" background="../images/fondo_coventa.jpg">
	<BR>
		<table width="50%" border="0">
			<tr bordercolor="#999999" bgcolor="#<%=session("COLTABBG")%>" class="Estilo13">
				<td>RUT:</td>

				<td>CLIENTE:</td>

			</tr>
			<tr>
				<td><INPUT TYPE="text" NAME="tx_rut" value="<%=strrut%>" onChange="Refrescar();"></td>
				<td>
				<SELECT NAME="cm_cliente" onChange="Refrescar();">
					<option value="">SELECCIONAR</option>
				<%
					abrirscg()
					sql="SELECT * from clientes"
					set rsDET = Conn.execute(sql)
					do while not rsdet.eof
				%>
				<option value="<%=rsdet("cod_cli")%>" <%if Trim(cliente)=Trim(rsdet("cod_cli")) then response.Write("Selected")%>><%=rsdet("desc_cli")%></option>

				<%
						rsdet.movenext
					loop
					cerrarscg()
				%>
				</SELECT>
				</td>
			</tr>
		</table>
		<%if strrut <> ""  and cliente <> "" then
		%>
		<table>
			<tr bordercolor="#999999" bgcolor="#<%=session("COLTABBG")%>" class="Estilo13">
				<td width="25%">NRO. DOC.</td>
				<td width="12%">COBRADOR</td>
				<td>MONTO DEUDA</td>
				<TD>SALDO</TD>
			</tr>

		<%
			abrirscg()
			SQL="SELECT * FROM CUOTA WHERE CODCLIENTE=" & CLIENTE & " AND RUTDEUDOR='" & strrut & "'"
			set rsCuota = Conn.execute(sql)
			do while not rsCuota.eof

			if rsCuota("codcobrador")="0" then
				cobrador="SIN COBRADOR"
			else
				cobrador=rsCuota("codcobrador")
			end if
		%>
			<tr>
				<td><A HREF="asig_cobr.asp?nrodoc=<%=rsCuota("nrodoc")%>&rut=<%=strrut%>&cliente=<%=cliente%>&cobrador=<%=rsCuota("codcobrador")%>&remesa=<%=rsCuota("codremesa")%>"><%=rsCuota("nrodoc")%></A></td>
				<td><%=cobrador%></td>
				<td><%=rsCuota("valorcuota")%></td>
				<td><%=rsCuota("saldo")%></td>
			</tr>
		<%
				rsCuota.movenext
			loop
		%>
			<!-- <td>COBRADOR</td>
			<td>
			<SELECT NAME="ejecutivo">
					<option value="">SELECCIONAR</option>
				<%
					abrirscg()
					sql="SELECT * from cliente_cobrador where cod_producto > 1"
					set rscob = Conn.execute(sql)
					do while not rscob.eof
				%>
				<option value="<%=rscob("cod_cobrador")%>" <%if Trim(ejecutivo)=Trim(rscob("cod_cobrador")) then response.Write("Selected")%>><%=rscob("cod_cobrador")%></option>

				<%
						rscob.movenext
					loop
					cerrarscg()
				%>
				</SELECT>
			</td>
			<td></td>
			<td><INPUT TYPE="button" value="ASIGNAR" onclick="enviar()"></td> -->

		</table>

		<%
		end if%>
	</td>
  </tr>
</table>
</form>
</body>
</html>
