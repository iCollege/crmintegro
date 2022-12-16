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

	AbrirSCG()
	intCodConvenio = request("TX_pago")
	strRut=request("TX_RUT")
	usuario = request("cmb_usuario")
	if usuario = "" then usuario = "0"
	resp = request("resp")
	resp="si"

	intCliente = request("CB_CLIENTE")
	intCodRemesa = request("CB_REMESA")
	intCodUsuario = request("CB_COBRADOR")
	intCodEstado = request("CB_ESTADO")

	''Response.write "intCliente=" & intCliente

If Trim(intCliente) = "" Then intCliente = "1000"


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
	datos.action = "informe_cartera.asp?resp="+ resp +"";
	datos.submit();
}

function envia()
{
	resp='si'
	datos.action = "informe_cartera.asp?resp="+ resp +"";
	datos.submit();
}

function envia_excel(URL){

window.open(URL,"INFORMACION","width=200, height=200, scrollbars=yes, menubar=yes, location=yes, resizable=yes")
}
</script>


<link href="style.css" rel="Stylesheet">

<form name="datos" method="post">
<table width="100%" border="1">
  <tr>
    <td height="20" bordercolor="#999999"  bgcolor="#<%=session("COLTABBG")%>" class="Estilo13" ALIGN="CENTER">LISTADO DE COMPARENDOS</td>
  </tr>
  <tr>
    <td valign="top">
	<table width="100%" border="0" bordercolor="#999999">

	      <tr height="20" bordercolor="#999999"  bgcolor="#<%=session("COLTABBG")%>" class="Estilo13">
		  	<td>CLIENTE</td>
		  	<td>ASIGNACION</td>
		  	<td>EJECUTIVO</td>
		  	<td>ESTADO</td>
		 	<td>&nbsp;</td>
			</tr>
		  <tr bordercolor="#999999" class="Estilo8">
		  <td>

		<select name="CB_CLIENTE" width="15" onchange="Refrescar()">
		<option value="">SELECCIONAR</option>
		<%
		ssql="SELECT * FROM CLIENTE WHERE ACTIVO=1"
		set rsCLI=Conn.execute(ssql)
		if not rsCLI.eof then
			do until rsCLI.eof
			%>
			<option value="<%=rsCLI("CODCLIENTE")%>"
			<%if Trim(intCliente)=Trim(rsCLI("CODCLIENTE")) then
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
		<select name="CB_REMESA">
			<option value="">TODAS</option>
			<%
				strSql="SELECT * FROM REMESA WHERE CODREMESA >= 100 AND CODCLIENTE = '" & intCliente & "'"
				set rsRemesa=Conn.execute(strSql)
				Do While not rsRemesa.eof
				If Trim(intCodRemesa)=Trim(rsRemesa("CODREMESA")) Then strSelRem = "SELECTED" Else strSelRem = ""
				%>
				<option value="<%=rsRemesa("CODREMESA")%>" <%=strSelRem%>> <%=rsRemesa("CODREMESA") & " - " & rsRemesa("FECHA_ASIGNACION")%></option>
				<%
				rsRemesa.movenext
				Loop
				rsRemesa.close
				set rsRemesa=nothing

			''Response.End
			%>
		</select>
		</td>
		<td>
		<select name="CB_COBRADOR">
			<option value="">TODOS</option>
			<%
			ssql="SELECT ID_USUARIO,LOGIN FROM USUARIO WHERE PERFIL_COB = 1"
			set rsTemp= Conn.execute(ssql)
			if not rsTemp.eof then
				do until rsTemp.eof%>
				<option value="<%=rsTemp("LOGIN")%>"<%if Trim(intCodUsuario)=Trim(rsTemp("LOGIN")) then response.Write("Selected") End If%>><%=rsTemp("LOGIN")%></option>
				<%
				rsTemp.movenext
				loop
			end if
			rsTemp.close
			set rsTemp=nothing
			%>
		</select>
		</td>

		<td>
			<select name="CB_ESTADO">
				<option value="">TODOS</option>
				<%
				ssql="SELECT * FROM ESTADO_DEUDA"
				set rsTemp= Conn.execute(ssql)
				if not rsTemp.eof then
					do until rsTemp.eof%>

					<option value="<%=rsTemp("DESCRIPCION")%>"<%if Trim(intCodEstado)=Trim(rsTemp("DESCRIPCION")) then response.Write("Selected") End If%>><%=rsTemp("DESCRIPCION")%></option>
					<%
					rsTemp.movenext
					loop
				end if
				rsTemp.close
				set rsTemp=nothing

				%>
			</select>
		</td>

		<td>
			<input type="Button" name="Submit" value="Ver" onClick="envia();">
		</td>

	 </tr>
    </table>
</table>
<table width="2000" border="1">

	<table width="100%" border="0" bordercolor="#000000">
		<tr bordercolor="#999999"  bgcolor="#<%=session("COLTABBG")%>" class="Estilo13">
			<td width="65">RUT</td>
			<td>NOMBRE</td>
			<td>DEUDA</td>
			<td>ASIGNACION</td>
			<td>EJECUTIVO</td>
			<td>FEC.ESTADO</td>
			<td>ESTADO</td>
			<td>FEC.UGP</td>
			<td>GESTION PREJUD</td>
			<td>ULT.GEST.PREJUD.</td>
			<td>FEC.UGJ</td>
			<td>ESTADO JUD</td>
			<td>ULT.GEST.JUD.</td>
		</tr>
	<% If resp="si" then
			strSql = "SELECT RUT, DEUDA, ASIGNACION, EJECUTIVO, PAGADO, CONVERT(VARCHAR(10),FECHA_ESTADO,103) AS FECHA_ESTADO, NOMBRE, CONVERT(VARCHAR(10),FEC_ULT_GES_JUD,103) AS FEC_ULT_GES_JUD, OBS_ULT_GES_JUD, ESTADO_JUDICIAL, CONVERT(VARCHAR(10),FEC_ULT_GES_PRE,103) AS FEC_ULT_GES_PRE, OBS_ULT_GES_PRE, GESTION_PREJUDICIAL FROM INF_INFORME_MACRO "
			strSql = strSql & " WHERE COD_CLIENTE = '" & intCliente & "'"
			If intCodRemesa <> "" Then
				strSql = strSql & " AND ASIGNACION = '" & intCodRemesa & "'"
			End if
			If intCodUsuario <> "" Then
				strSql = strSql & " AND EJECUTIVO = '" & intCodUsuario & "'"
			End if
			If intCodEstado <> "" Then
				strSql = strSql & " AND PAGADO = '" & intCodEstado & "'"
			End if
			''Response.write strSql
		End if

	if strSql <> "" then
		set rsDet=Conn.execute(strSql)

		if not rsDet.eof then
			do while not rsDet.eof
				intMonto = ValNulo(rsDet("DEUDA"),"N")
			%>
			<tr bgcolor="#<%=session("COLTABBG2")%>" class="Estilo8">
				<td><A HREF="principal.asp?rut=<%=rsDet("RUT")%>"><acronym title="Llevar a pantalla de selección"><%=rsDet("RUT")%></acronym></A></td>
				<td><%=rsDet("NOMBRE")%></td>
				<td ALIGN="RIGHT"><%=FN(rsDet("DEUDA"),0)%></td>
				<td><%=rsDet("ASIGNACION")%></td>
				<td><%=rsDet("EJECUTIVO")%></td>
				<td><%=rsDet("FECHA_ESTADO")%></td>
				<td><%=rsDet("PAGADO")%></td>
				<td><%=rsDet("FEC_ULT_GES_JUD")%></td>
				<td><%=rsDet("GESTION_PREJUDICIAL")%></td>
				<td><%=rsDet("OBS_ULT_GES_JUD")%></td>
				<td><%=rsDet("FEC_ULT_GES_PRE")%></td>
				<td><%=rsDet("ESTADO_JUDICIAL")%></td>
				<td><%=rsDet("OBS_ULT_GES_PRE")%></td>
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

<%CerrarSCG()%>

