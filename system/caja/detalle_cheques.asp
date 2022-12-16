<% @LCID = 1034 %>


<!--#include file="../arch_utils.asp"-->
<!--#include file="../../lib/comunes/rutinas/funciones.inc" -->
<!--#include file="../../lib/comunes/rutinas/TraeCampo.inc" -->
<!--#include file="../asp/comunes/general/rutinasSCG.inc" -->

<!--#include file="../lib.asp"-->



<!--#include file="../../lib/comunes/rutinas/chkFecha.inc"-->
<!--#include file="../../lib/comunes/rutinas/sondigitos.inc"-->
<!--#include file="../../lib/comunes/rutinas/formatoFecha.inc"-->
<!--#include file="../../lib/comunes/rutinas/validarFecha.inc"-->
<!--#include file="../../lib/comunes/rutinas/diasEnMes.inc"-->
<!--#include file="../asp/comunes/general/rutinasBooleano.inc"-->


<%
	'cod_caja=110

	cod_caja=Session("intCodUsuario")

	AbrirSCG()

	sucursal = request("cmb_sucursal")
	intTipoPago = request("CB_TIPOPAGO")
	'response.write(perfil)
	intCodPago = request("TX_PAGO")
	strRut=request("TX_RUT")
	if sucursal="" then sucursal="0"
	'response.write(sucursal)
	usuario = request("cmb_usuario")
	if usuario = "" then usuario = "0"
	termino = request("termino")
	inicio = request("inicio")
	resp = request("resp")
	if Trim(inicio) = "" Then
		inicio = TraeFechaMesActual(Conn,-1)
		inicio = "01" & Mid(inicio,3,10)
		inicio = TraeFechaActual(Conn)
	End If
	if Trim(termino) = "" Then
		termino = TraeFechaActual(Conn)
	End If
	CLIENTE = REQUEST("CLIENTE")
	'hoy=date

	'response.write(hoy)
%>
<title>CRM Cobros</title>
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
	datos.action = "detalle_cheques.asp?resp="+ resp +"";
	datos.submit();
}

function Ingresa()
{
	with( document.datos )
	{
		action = "detalle_cheques.asp";
		submit();
	}
}

function Reversar(cod_pago)
{
	with( document.datos )
	{

		if (confirm("¿ Está seguro de reversar el pago ? El pago se eliminará completamente y la deuda será reversada, volviendo a su estado original antes del pago."))
			{
				action = "reversar_pago.asp?cod_pago=" + cod_pago;
				submit();
			}
		else
			alert("Reverso del pago cancelado");


	}
}

function envia()
{
	//datos.TX_RUT.value='';
	//datos.TX_PAGO.value='';
	resp='si'
	datos.action = "detalle_cheques.asp?resp="+ resp +"";
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
    <td height="20" bordercolor="#999999"  bgcolor="#<%=session("COLTABBG")%>" class="Estilo13" ALIGN="CENTER">LISTADO DE PAGOS</td>
  </tr>
  <tr>
    <td valign="top">
	<table width="100%" border="0" bordercolor="#999999">
		<tr height="20" class="Estilo8">
	        <td>RUT: </td>
			<td><INPUT TYPE="text" NAME="TX_RUT" value="<%=strRut%>" onchange=""></td>
		    <td>CODIGO PAGO: </td>
			<td ><INPUT TYPE="text" NAME="TX_PAGO" value="<%=intCodPago%>" onchange=""></td>
		</tr>

	</table>
	<table width="100%" border="0" bordercolor="#999999">

	      <tr height="20" bordercolor="#999999"  bgcolor="#<%=session("COLTABBG")%>" class="Estilo13">
		  <td>CLIENTE</td>
		  <%if perfil="caja_modif" or perfil = "caja_listado" then%>
	        <td>SUCURSAL</td>
			<%end if%>
			<td>TIPO DE PAGO</td>
			<!--td>USUARIO</td-->
			<td>DESDE</td>
			<td>HASTA</td>
	      </tr>
		  <tr bordercolor="#999999" class="Estilo8">
		  <td>

		<select name="CLIENTE" ID = "CLIENTE" width="15" onchange="tipopago()">
		<option value="0">SELECCIONAR</option>
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
			<select name="CB_TIPOPAGO">
				<%
				ssql="SELECT * FROM CAJA_TIPO_PAGO	"
				If Trim(intTipoPago)="CO" Then
					strTipoCompArch = "comp_pago_convenio.asp"
					ssql = ssql & " WHERE ID_TIPO_PAGO = 'CO'"
				ElseIf Trim(intTipoPago)="RP" Then
					strTipoCompArch = "comp_pago_repactacion.asp"
					ssql = ssql & " WHERE ID_TIPO_PAGO = 'RP'"
				Else
					strTipoCompArch = "comp_pago.asp"
					ssql = ssql & " WHERE ID_TIPO_PAGO NOT IN ('CO','RP')"
				%>
					<option value="">SELECCIONAR</option>
				<%
				End If
				set rsCLI=Conn.execute(ssql)
				if not rsCLI.eof then
					do until rsCLI.eof
					%>
					<option value="<%=rsCLI("ID_TIPO_PAGO")%>"
					<%if Trim(intTipoPago)=Trim(rsCLI("ID_TIPO_PAGO")) then Response.Write("SELECTED") end if%> WIDTH="10"
					><%=MID(rsCLI("DESC_TIPO_PAGO"),1,19)%></option>
					<%rsCLI.movenext
					loop
				end if
				rsCLI.close
				set rsCLI=nothing
				%>
			</select>
		</td>
		  <%if perfil="caja_modif" or perfil = "caja_listado" then%>
	        <td>
				<SELECT NAME="cmb_sucursal" id="cmb_sucursal" onchange="Refrescar();">
				<option value="0">TODAS</option>
				<%
				ssql="SELECT * FROM sucursal where cod_suc > 0 order by cod_suc"
				set rsSuc=Conn.execute(ssql)
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
			<!--td>
				<SELECT NAME="cmb_usuario" id="cmb_usuario" onchange="Refrescar();">
					<option value="0">TODOS</option>
					<%
					If Trim(intTipoPago)="CO" Then
						stsSql="SELECT DISTINCT ID_USUARIO, LOGIN FROM USUARIO U, CONVENIO_ENC C WHERE U.ID_USUARIO = C.USRINGRESO"
					ElseIf Trim(intTipoPago)="RP" Then
						stsSql="SELECT DISTINCT ID_USUARIO, LOGIN FROM USUARIO U, REPACTACION_ENC C WHERE U.ID_USUARIO = C.USRINGRESO"
					Else
						stsSql="SELECT DISTINCT ID_USUARIO, LOGIN FROM USUARIO U, CAJA_WEB_EMP C WHERE U.ID_USUARIO = C.USRINGRESO"
					End if
					set rsUsu=Conn.execute(stsSql)
					if not rsUsu.eof then
						do until rsUsu.eof
						%>
						<option value="<%=rsUsu("ID_USUARIO")%>"
						<%if Trim(usuario)=Trim(rsUsu("ID_USUARIO")) then
							response.Write("Selected")
						end if%>
						><%=ucase(rsUsu("LOGIN"))%></option>

						<%rsUsu.movenext
						loop
					end if
					rsUsu.close
					set rsUsu=nothing
					%>
				</SELECT>
			</td-->
			<td><input name="inicio" type="text" id="inicio" value="<%=inicio%>" size="10" maxlength="10">
		<a href="javascript:showCal('Calendar7');"><img src="../../images/calendario.gif" border="0"></a>
			</td>
			<td><input name="termino" type="text" id="termino" value="<%=termino%>" size="10" maxlength="10">
          <a href="javascript:showCal('Calendar6');"><img src="../../images/calendario.gif" border="0"></a>
			<input type="Button" name="Submit" value="Ver" onClick="envia();">
			<input type="button" name="Submit" value="Excel" onClick="javascript:envia_excel('detalle_cheques_excel.asp?strRut=<%=strRut%>&intCodPago=<%=intCodPago%>&sucursal=<%=sucursal%>&termino=<%=termino%>&inicio=<%=inicio%>&usuario=<%=usuario%>&CLIENTE=<%=CLIENTE%>')">
			</td>
	      </tr>
    </table>


	<table width="100%" border="0" bordercolor="#000000">
		<tr bordercolor="#999999"  bgcolor="#<%=session("COLTABBG")%>" class="Estilo13">
			<td>COD.PAGO</td>
			<td>FECHA ING</td>
			<td>CLIENTE</td>
			<td>RUT DEUDOR</td>
			<td>FECHA CHEQUE</td>
			<td>MONTO</td>
			<td>CHEQUE</td>
			<td>CTA.CTE.</td>
			<td>BANCO</td>
			<td>RUT CHEQUE</td>
			<td>COMPROB.</td>
		</tr>
	<%
	If resp="si" then

		strSql = "SELECT COMP_INGRESO,C.RUTDEUDOR AS RUTDEUDOR, CONVERT(VARCHAR(10),C.FECHA_PAGO,103) AS FECHA_PAGO, M.NOMBRE_FANTASIA,D.ID_PAGO, D.MONTO, CONVERT(VARCHAR(10),D.VENCIMIENTO,103) AS VENCIMIENTO, B.NOMBRE_B, D.NRO_CHEQUE, D.NRO_CTACTE, D.RUT_CHEQUE "
		strSql = strSql & " FROM CAJA_WEB_EMP C,CLIENTE M,CAJA_WEB_EMP_DOC_PAGO D, BANCOS B "
		strSql = strSql & " WHERE B.CODIGO = D.COD_BANCO AND C.ID_PAGO = D.ID_PAGO AND M.CODCLIENTE = C.COD_CLIENTE "
		strSql = strSql & " AND D.FORMA_PAGO IN ('CF','CD') "

		IF (CLIENTE <> "0" AND CLIENTE <> "") THEN
			strSql = strSql & " AND C.COD_CLIENTE = '" & CLIENTE & "'"
		END IF
		'IF usuario <> "0" THEN
		'	strSql = strSql & " AND  USRINGRESO=" & usuario & " "
		'END IF
		If Trim(strRut) <> "" Then
			strSql = strSql & " AND RUTDEUDOR = '" & strRut & "' "
		End If

		IF intCodPago <> "" THEN
			strSql = strSql & " AND ID_PAGO = " & intCodPago & " "
		END IF
		strSql = strSql & " AND FECHA_PAGO BETWEEN '" & inicio & " 00:00:00' and '" & termino & " 23:59:59' ORDER BY D.ID_PAGO DESC"

		''Response.write "strSql = " & strSql
	End if


		'Response.write "strSql = " & strSql
		'Response.End
	if strSql <> "" then
		set rsDet=Conn.execute(strSql)

		if not rsDet.eof then
			Do while not rsDet.eof
			%>
			<tr bgcolor="#<%=session("COLTABBG2")%>" class="Estilo8">
				<td><A HREF="det_caja.asp?cod_pago=<%=rsDet("ID_PAGO")%>"><%=rsDet("ID_PAGO")%></A></td>
				<td><%=rsDet("FECHA_PAGO")%></td>
				<td><%=rsDet("NOMBRE_FANTASIA")%></td>
				<td><A HREF="../principal.asp?rut=<%=rsDet("RUTDEUDOR")%>"><acronym title="Llevar a pantalla de selección"><%=rsDet("RUTDEUDOR")%></acronym></A></td>
				<td><%=rsDet("VENCIMIENTO")%></td>
				<td><%=rsDet("MONTO")%></td>
				<td><%=rsDet("NRO_CHEQUE")%></td>
				<td><%=rsDet("NRO_CTACTE")%></td>
				<td><%=rsDet("NOMBRE_B")%></td>
				<td><%=rsDet("RUT_CHEQUE")%></td>
				<td><%=rsDet("COMP_INGRESO")%></td>
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
