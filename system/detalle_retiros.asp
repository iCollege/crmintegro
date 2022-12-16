<% @LCID = 1034 %>
<!--#include file="arch_utils.asp"-->
<!--#include file="../lib/comunes/rutinas/funciones.inc" -->
<!--#include file="../lib/comunes/rutinas/rutinasFecha.inc" -->
<!--#include file="../lib/comunes/rutinas/funcionesBD.inc" -->
<!--#include file="../lib/comunes/rutinas/TraeCampo.inc" -->
<!--#include file="lib.asp"-->

<%
hdd_cod_cliente = request("cmb_cliente")
txt_FechaIni = request("txt_FechaIni")
txt_FechaFin = request("txt_FechaFin")


intCliente = request("intCliente")
intOrigen = request("intOrigen")
intCodRemesa = request("intCodRemesa")
intCodUsuario = request("intCodUsuario")
intFecha = request("intFecha")
intFechaIni = request("intFechaIni")
intFechaFin = request("intFechaFin")

abrirscg()

	strSql = "SELECT DISTINCT(RUTDEUDOR) as RUTDEUDOR, CUENTA, IsNull(COUNT(NRODOC),0) as NUMDOC, IsNull(SUM(VALORCUOTA),0) as MONTO, CONVERT(VARCHAR(10),FECHA_ESTADO,103) AS FECHA_ESTADO, ESTADO_DEUDA, IsNull(USUARIO_ASIG,0) as USUARIO_ASIG FROM CUOTA WHERE CODCLIENTE = '" & intCliente & "'"
	If Trim(intCodRemesa) <> "T" Then
		strSql = strSql & " AND CODREMESA = " & intCodRemesa
	End If
	''strSql = strSql & " AND SALDO = 0 "

	If Trim(intFecha) <> "" Then
		strSql = strSql & " AND CONVERT(VARCHAR(10),FECHA_ESTADO,103) = '" & intFecha & "'"
	Else
		strSql = strSql & " AND FECHA_ESTADO >= '" & intFechaIni & "' AND FECHA_ESTADO <= '" & intFechaFin & "'"
	End If

	strSql = strSql & " AND ESTADO_DEUDA IN "

	If Trim(intOrigen) = "T" Then
		strSql = strSql & " (2,6)"
	End if
	If Trim(intOrigen) = "R" Then
		strSql = strSql & " (2)"
	End if
	If Trim(intOrigen) = "C" Then
		strSql = strSql & " (6)"
	End if



	If Trim(intCodUsuario) <> "T" Then
		strSql = strSql & " AND USUARIO_ASIG = " & intCodUsuario
	End If

	strSql = strSql & " GROUP BY RUTDEUDOR, CUENTA , CONVERT(VARCHAR(10),FECHA_ESTADO,103), ESTADO_DEUDA, USUARIO_ASIG"


	'Response.write strSql
	'Response.End

	set rsDetPago= Conn.execute(strSql)
	rsDetPago.close
	set rsDetPago=nothing


SET rsDetPago=Conn.execute(strSql)
%>
<title>Detalle Pagos</title>
<style type="text/css">
<!--
.Estilo37 {color: #FFFFFF}
-->
</style>
<body>
<form name="Free" method="post">
<center>

<table width="100%" border="0" cellspacing="0" cellpadding="0" class="Estilo13">
<tr  class="Estilo20">
<td width="100%" align="LEFT"><a href="javascript:history.back();">Volver</a></td>
</tr>
</table>

<table width="100%" border="1" bordercolor = "#<%=session("COLTABBG")%>" cellSpacing=0 cellPadding=2>

<tr bgcolor="#<%=session("COLTABBG")%>" class="Estilo13">
	<td>Fecha</td>
	<td>Rut</td>
	<td>Cuenta</td>
	<td>Nombre</td>
	<td>Monto Retirado</td>
	<td>Origen</td>
	<td>Ejecutivo</td>
</tr>
<%
Do while not rsDetPago.eof

If Trim(rsDetPago("USUARIO_ASIG")) <> "" Then
	strEjecutivo = TraeCampoId(Conn, "NOMBRES_USUARIO", Trim(rsDetPago("USUARIO_ASIG")), "USUARIO", "ID_USUARIO") & "-" & TraeCampoId(Conn, "APELLIDOS_USUARIO", Trim(rsDetPago("USUARIO_ASIG")), "USUARIO", "ID_USUARIO")
End if

strOrigen = rsDetPago("ESTADO_DEUDA")
'strEjecutivo = rsDetPago("USUARIO_ASIG")



If Trim(rsDetPago("ESTADO_DEUDA")) <> "" Then
	strOrigen = TraeCampoId(Conn, "DESCRIPCION", Trim(rsDetPago("ESTADO_DEUDA")), "ESTADO_DEUDA", "CODIGO")
End if


If Trim(rsDetPago("RUTDEUDOR")) <> "" Then
	strNombreDeudor = TraeCampoId2(Conn, "NOMBREDEUDOR", Trim(rsDetPago("RUTDEUDOR")), "DEUDOR", "RUTDEUDOR")
End if

'RESPONSE.write "USUARIO_ASIG=" & Trim(rsDetPago("USUARIO_ASIG"))
'RESPONSE.END

%>

<tr>
	<td class="DatosDeudorTexto"><font class="TextoDatos"><%= rsDetPago("FECHA_ESTADO") %></font></td>

	<td class="DatosDeudorTexto"><font class="TextoDatos">
	<A HREF="principal.asp?rut=<%=rsDetPago("RUTDEUDOR")%>">
		<acronym title="Llevar a pantalla de selección"><%= rsDetPago("RUTDEUDOR") %></acronym>
	</A></font>
	</td>
	<td class="DatosDeudorTexto"><font class="TextoDatos"><%= rsDetPago("CUENTA") %></font></td>
	<td class="DatosDeudorTexto"><font class="TextoDatos"><%= strNombreDeudor %></font></td>
	<td class="DatosDeudorTexto" align="RIGHT"><font class="TextoDatos"><%= FN(rsDetPago("MONTO"),0) %></font></td>
	<td class="DatosDeudorTexto"><font class="TextoDatos"><%= strOrigen %></font></td>
	<td class="DatosDeudorTexto"><font class="TextoDatos"><%= strEjecutivo %></font></td>
</tr>

<%rsDetPago.movenext
	Loop%>
</table>
<form>
<input type="Hidden" name="cmb_cliente">
</form>

</body>


</html>

<%
rsDetPago.close
set rsDetPago=nothing
cerrarscg()
%>

