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


<%
	'cod_caja=110


	cod_caja=Session("intCodUsuario")

	AbrirSCG()

	sucursal = request("cmb_sucursal")

	'response.write(perfil)
	codpago = request("TX_PAGO")
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

function Reversar(cod_pago)
{
	with( document.datos )
	{
		action = "reversar_pago.asp?cod_pago=" + cod_pago;
		submit();
	}
}

function envia()
{
	datos.TX_RUT.value='';
	datos.TX_PAGO.value='';
	resp='si'
	datos.action = "detalle_caja.asp?resp="+ resp +"";
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
			<td><INPUT TYPE="text" NAME="TX_RUT" value="<%=strRut%>" onchange="Ingresa();"></td>
		</tr>
		<%if strRut <> "" then
			if sucursal = "0" then
				sql="select id_pago,rendido, CONVERT(varchar(10), fecha_pago, 103) AS fecha_pago,comp_ingreso, sucursal.des_suc, cliente.DESCRIPCION, rutdeudor, total_cliente, total_emp, caja_tipo_pago.desc_tipo_pago,usringreso from caja_web_emp,cliente,caja_tipo_pago,sucursal where cliente.CODCLIENTE =caja_web_emp.cod_cliente and caja_tipo_pago.id_tipo_pago = caja_web_emp.tipo_pago and sucursal.cod_suc = caja_web_emp.sucursal and caja_web_emp.rutdeudor='" & strRut & "' and caja_web_emp.estado_caja='A'"
			else
				sql="select id_pago,rendido, CONVERT(varchar(10), fecha_pago, 103) AS fecha_pago,comp_ingreso, sucursal.des_suc, cliente.DESCRIPCION, rutdeudor, total_cliente, total_emp, caja_tipo_pago.desc_tipo_pago,usringreso from caja_web_emp,cliente,caja_tipo_pago,sucursal where cliente.CODCLIENTE =caja_web_emp.cod_cliente and caja_tipo_pago.id_tipo_pago = caja_web_emp.tipo_pago and sucursal.cod_suc = caja_web_emp.sucursal and caja_web_emp.rutdeudor='" & strRut & "' and caja_web_emp.sucursal='" & sucursal & "' and caja_web_emp.estado_caja='A'"
			end if
		end if
		%>
		<tr height="20" class="Estilo8">
	        <td>CODIGO PAGO: </td>
			<td ><INPUT TYPE="text" NAME="TX_PAGO" value="<%=codpago%>" onchange="Ingresa();"></td>
		</tr>
		<%if codpago <> "" then
			if sucursal = "0" then
				sql="select id_pago,rendido, CONVERT(varchar(10), fecha_pago, 103) AS fecha_pago,comp_ingreso, sucursal.des_suc, cliente.DESCRIPCION, rutdeudor, total_cliente, total_emp, caja_tipo_pago.desc_tipo_pago,usringreso from caja_web_emp,cliente,caja_tipo_pago,sucursal where cliente.CODCLIENTE =caja_web_emp.cod_cliente and caja_tipo_pago.id_tipo_pago = caja_web_emp.tipo_pago and sucursal.cod_suc = caja_web_emp.sucursal and caja_web_emp.id_pago=" & codpago & " and caja_web_emp.estado_caja='A'"
			else
				sql="select id_pago,rendido, CONVERT(varchar(10), fecha_pago, 103) AS fecha_pago,comp_ingreso, sucursal.des_suc, cliente.DESCRIPCION, rutdeudor, total_cliente, total_emp, caja_tipo_pago.desc_tipo_pago,usringreso from caja_web_emp,cliente,caja_tipo_pago,sucursal where cliente.CODCLIENTE =caja_web_emp.cod_cliente and caja_tipo_pago.id_tipo_pago = caja_web_emp.tipo_pago and sucursal.cod_suc = caja_web_emp.sucursal and caja_web_emp.id_pago=" & codpago & " and caja_web_emp.sucursal='" & sucursal & "' and caja_web_emp.estado_caja='A'"
			end if
		end if
		%>
	</table>
	<table width="100%" border="0" bordercolor="#999999">

	      <tr height="20" bordercolor="#999999"  bgcolor="#<%=session("COLTABBG")%>" class="Estilo13">
		  <td>CLIENTE</td>
		  <%if perfil="caja_modif" or perfil = "caja_listado" then%>
	        <td>SUCURSAL</td>
			<%end if%>
			<td>USUARIO</td>
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
			<td>
				<SELECT NAME="cmb_usuario" id="cmb_usuario" onchange="Refrescar();">
				<option value="0">TODOS</option>
				<%
				ssql="SELECT * FROM USUARIO WHERE PERFIL_CAJA = 1"
				set rsUsu=Conn.execute(ssql)
				if not rsUsu.eof then
					do until rsUsu.eof
					%>
					<option value="<%=rsUsu("id_usuario")%>"
					<%if Trim(usuario)=Trim(rsUsu("id_usuario")) then
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
			<input type="Button" name="Submit" value="Ver" onClick="envia();">
			<input type="button" name="Submit" value="Excel" onClick="javascript:envia_excel('detalle_caja_excel.asp?strRut=<%=strRut%>&codpago=<%=codpago%>&sucursal=<%=sucursal%>&termino=<%=termino%>&inicio=<%=inicio%>&usuario=<%=usuario%>&CLIENTE=<%=CLIENTE%>')">
			<a href="../comp_pago_enblanco.asp">Comp.Blanco</a>
			</td>
	      </tr>
    </table>
	<table width="100%" border="0" bordercolor="#000000">
		<tr bordercolor="#999999"  bgcolor="#<%=session("COLTABBG")%>" class="Estilo13">
			<td>COD. PAGO</td>
			<td>USU.ING.</td>
			<td>FECHA PAGO</td>
			<td>CLIENTE</td>
			<td>COMP. INGRESO</td>
			<td>RUT 	</td>
			<td>MONTO CAPITAL</td>
			<td>MONTO EMPRESA</td>
			<td>TIPO PAGO</td>
			<td></td>
			<!--td></td-->
			<td>COMPROB.</td>
		</tr>
	<%
	If resp="si" then
		strSql = "SELECT ID_PAGO,RENDIDO, CONVERT(VARCHAR(10), FECHA_PAGO, 103) AS FECHA_PAGO,COMP_INGRESO, CLIENTE.DESCRIPCION, RUTDEUDOR, TOTAL_CLIENTE, TOTAL_EMP, CAJA_TIPO_PAGO.DESC_TIPO_PAGO,ISNULL(USRINGRESO,0) AS USRINGRESO FROM CAJA_WEB_EMP,CLIENTE,CAJA_TIPO_PAGO WHERE CLIENTE.CODCLIENTE = CAJA_WEB_EMP.COD_CLIENTE AND CAJA_TIPO_PAGO.ID_TIPO_PAGO = CAJA_WEB_EMP.TIPO_PAGO " ' " and sucursal.cod_suc = caja_web_emp.sucursal "
		'IF sucursal <> "0" THEN
		'	strSql = strSql & "and sucursal='" & sucursal & "' "
		'END IF
		IF CLIENTE <> "0" THEN
			strSql = strSql & "and caja_web_emp.cod_cliente = '" & CLIENTE & "'"
		END IF
		IF usuario <> "0" THEN
			strSql = strSql & "and  usringreso=" & usuario & " "
		END IF
		strSql = strSql & "and fecha_pago between '" & inicio & " 00:00:00' and '" & termino & " 23:59:59' order by id_pago desc"
		'strSql = strSql & "and rendido between '" & inicio & "' and '" & termino & "' and caja_web_emp.estado_caja='A' order by rendido"

		If Trim(strRut) <> "" Then
			strSql = strSql & " AND RUTDEUDOR = '" & strRut & "'"
		End If
		'Response.write "strSql = " & strSql
	End if




	'Response.End
	if strSql <> "" then
		set rsDet=Conn.execute(strSql)

		if not rsDet.eof then
			do while not rsDet.eof
				ssql="SELECT * FROM USUARIO WHERE ID_USUARIO = " & rsDet("USRINGRESO")
				'Response.write ssql
				'Response.End
				set rsUsuIng=Conn.execute(ssql)
				if not rsUsuIng.eof then
					usringreso= rsUsuIng("login")
				end if
			%>
			<tr bgcolor="#<%=session("COLTABBG2")%>" class="Estilo8">
				<td><A HREF="det_caja.asp?cod_pago=<%=rsDet("id_pago")%>"><%=rsDet("id_pago")%></A></td>
				<td><%=usringreso%></td>
				<td><%=rsDet("fecha_pago")%></td>
				<td><%=rsDet("DESCRIPCION")%></td>
				<td><%=rsDet("comp_ingreso")%></td>
				<td><%=rsDet("rutdeudor")%></td>
				<td><%=rsDet("total_cliente")%></td>
				<td><%=rsDet("total_emp")%></td>
				<td><%=rsDet("desc_tipo_pago")%></td>

				<%'if perfil="caja_modif" then%>
					<!--td><A HREF="reversar_pago.asp?cod_pago=<%=rsDet("id_pago")%>">Reversar</A></td-->
					<td><!--A HREF="#" onClick="Reversar(<%=rsDet("id_pago")%>)";>Reversar</A--></td>
					<!--td><A HREF="validar_caja.asp?cod_pago=<%=rsDet("id_pago")%>">Validar</A></td-->
					<td><A HREF="../comp_pago.asp?strImprime=S&intNroComp=<%=rsDet("comp_ingreso")%>"><acronym title="Imprimir Comprobante"><%=rsDet("comp_ingreso")%></acronym></A></td>
				<%'end if
				%>
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
