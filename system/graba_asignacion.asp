<% @LCID = 1034 %>
<!--#include file="arch_utils.asp"-->
<!--#include file="lib.asp"-->
<!--#include file="sesion.asp"-->
<!--#include file="../lib/comunes/rutinas/funciones.inc" -->


<%
'SSQL="SELECT  login FROM COBRADOR_CLIENTE wHERE (tipo = 'TER')GROUP BY login"
Rut=request("rut")
cliente=request("cliente")
cobrador=request("cobrador")
'if cobrador="0" then
'	cobrador="SIN COBRADOR"
'end if
cod_remesa=request("remesa")
ejecutivo=request("ejecutivo")
'response.write(cobrador)
'response.write(Rut)
'response.write(cliente)
nrodoc=request("nrodoc")
'response.write(nrodoc)
'response.write(ejecutivo)

abrirscg()
sql="SELECT * from clientes where cod_cli=" & cliente & ""
set rsDET = Conn.execute(sql)
if not rsDET.eof then
	nombre_cli=rsDET("desc_cli")
end if
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
	if (datos.ejecutivo.value==''){
		alert("Debe seleccionar un cobrador")
	}else{
		datos.action = "graba_asignacion.asp";
		datos.submit();
	}
}
</script>
<%
	sql = "update cuota set codcobrador= '" & ejecutivo & "',usuarioasignacion='" & trim(ucase(session("session_login"))) & "' where codcliente=" & cliente & " and codremesa=" & cod_remesa & " and rutdeudor='" & rut & "' and nrodoc='" & nrodoc & "'"
	set rs = Conn.execute(sql)
%>
	<script>alert("La asignación fue ingresada con exito")</script>
<%
	Response.Write ("<script language = ""Javascript"">" & vbCrlf)
	Response.Write (vbTab & "location.href='scg_cobr.asp?rut=" & rut & "&cliente=" & cliente & "'" & vbCrlf)
	Response.Write ("</script>")

%>
<!-- <form name="datos" method="post">
<table width="720" height="450" border="0">
  <tr>
    <td width="827" height="20" class="Estilo20"></td>
  </tr>
  <tr>
    <td height="242" valign="top" background="../images/fondo_coventa.jpg">
	<BR>
		<table width="80%" border="0">
			<tr bordercolor="#999999" bgcolor="#<%=session("COLTABBG")%>" class="Estilo13">
				<td bordercolor="#999999" bgcolor="#<%=session("COLTABBG")%>">RUT:</td>

				<td bordercolor="#999999" bgcolor="#<%=session("COLTABBG")%>">CLIENTE:</td>

				<td bordercolor="#999999" bgcolor="#<%=session("COLTABBG")%>">COBRADOR ACTUAL</td>

			</tr>
			<tr>
				<td><%=rut%></td>
				<td><%=nombre_cli%></td>
				<td><%=cobrador%></td>
			</tr>
		</table>
		<BR><BR>
		<%'if strrut <> ""  and cliente <> "" then
		%>
		<table>
			<!-- <tr class="Estilo8">
				<td width="25%">NRO. DOC.</td>
				<td width="12%">COBRADOR</td>
				<td>MONTO DEUDA</td>
				<TD>SALDO</TD>
			</tr> -->

		<%
			'abrirscg()
			'SQL="SELECT * FROM CUOTA WHERE CODCLIENTE=" & CLIENTE & " AND RUTDEUDOR='" & strrut & "'"
			'set rsCuota = Conn.execute(sql)
			'do while not rsCuota.eof
		%>
			<!-- <tr>
				<td></td>
				<td></td>
				<td></td>
				<td></td>
			</tr> -->
		<%
		'		rsCuota.movenext
		'	loop
		%>
			<!--  <td>NUEVA ASIGNACION</td>
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
			<td><INPUT TYPE="button" value="ASIGNAR" onclick="enviar()"></td>

		</table> -->

		<%
		'end if%>
	<!-- </td>
  </tr>
</table>
</form> -->
</body>
</html>
