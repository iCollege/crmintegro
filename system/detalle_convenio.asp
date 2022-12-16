<% @LCID = 1034 %>

<!--#include file="sesion.asp"-->
<!--#include file="arch_utils.asp"-->
<!--#include file="../lib/comunes/rutinas/funciones.inc" -->
<!--#include file="../lib/comunes/rutinas/TraeCampo.inc" -->
<!--#include file="asp/comunes/general/rutinasSCG.inc" -->
<!--#include file="asp/comunes/general/rutinasBooleano.inc"-->

<!--#include file="lib.asp"-->



<!--#include file="../lib/comunes/rutinas/chkFecha.inc"-->
<!--#include file="../lib/comunes/rutinas/sondigitos.inc"-->
<!--#include file="../lib/comunes/rutinas/formatoFecha.inc"-->
<!--#include file="../lib/comunes/rutinas/validarFecha.inc"-->
<!--#include file="../lib/comunes/rutinas/diasEnMes.inc"-->


<%
	cod_caja=Session("intCodUsuario")

	AbrirSCG()
	codpago = request("TX_PAGO")
	strrut=request("TX_RUT")
	usuario = request("cmb_usuario")
	if usuario = "" then usuario = "0"
	termino = request("termino")
	inicio = request("inicio")
	resp = request("resp")
	If Trim(resp)="" Then resp = "si"
	if Trim(inicio) = "" Then
		inicio = TraeFechaMesActual(Conn,-1)
		inicio = "01" & Mid(inicio,3,10)
		inicio = TraeFechaActual(Conn)
	End If
	if Trim(termino) = "" Then
		termino = TraeFechaActual(Conn)
	End If


	strTipo = request("strTipo")

	CLIENTE = REQUEST("CLIENTE")
	If CLIENTE = "" Then
		CLIENTE = session("ses_codcli")
	End If
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
	datos.action = "detalle_convenio.asp?resp="+ resp +"";
	datos.submit();
}

function Ingresa()
{
	with( document.datos )
	{
		action = "detalle_convenio.asp";
		submit();
	}
}

function envia()
{
	datos.TX_RUT.value='';
	datos.TX_PAGO.value='';
	resp='si'
	datos.action = "detalle_convenio.asp?resp="+ resp +"";
	datos.submit();
}

function Buscar()
{

	if (datos.TX_RUT.value == '' && datos.TX_PAGO.value =='' ) {
		alert('Debe ingresar rut o codigo del <%=session("NOMBRE_CONV_PAGARE")%>');
		return
	}
	resp='123'
	datos.action = "detalle_convenio.asp?resp="+ resp +"";
	datos.submit();
}

function envia_excel(URL){
	window.open(URL,"INFORMACION","width=200, height=200, scrollbars=yes, menubar=yes, location=yes, resizable=yes")
}
</script>


<link href="style.css" rel="Stylesheet">

<form name="datos" method="post">
<input name="strTipo" id="strTipo" type="hidden" value="<%=strTipo%>">

<table width="850" height="500" border="1">
  <tr>
    <td height="20" bordercolor="#999999"  bgcolor="#<%=session("COLTABBG")%>" class="Estilo13" ALIGN="CENTER">LISTADO DE <%=UCASE(session("NOMBRE_CONV_PAGARE"))%>S</td>
  </tr>
  <tr>
    <td valign="top">
	<table width="100%" border="0" bordercolor="#999999">
		<tr height="20" class="Estilo8">
	        <td>RUT: </td>
			<td><INPUT TYPE="text" NAME="TX_RUT" value="<%=strrut%>"></td>
		     <td>CODIGO <%=UCASE(session("NOMBRE_CONV_PAGARE"))%>: </td>
			<td><INPUT TYPE="text" NAME="TX_PAGO" value="<%=codpago%>"></td>
			<td><input type="Button" name="Submit" value="Buscar" onClick="Buscar();"></td>
		</tr>
		<%if codpago <> "" then
			if sucursal = "0" then
				'sql="select ID_CONVENIO,rendido, CONVERT(varchar(10), FECHAINGRESO, 103) AS FECHAINGRESO,comp_ingreso, sucursal.des_suc, cliente.DESCRIPCION, rutdeudor, total_cliente, total_emp, caja_tipo_pago.desc_tipo_pago,usringreso from CONVENIO_ENC,cliente,caja_tipo_pago,sucursal where cliente.CODCLIENTE =CONVENIO_ENC.cod_cliente and caja_tipo_pago.id_tipo_pago = CONVENIO_ENC.tipo_pago and sucursal.cod_suc = CONVENIO_ENC.sucursal and CONVENIO_ENC.ID_CONVENIO=" & codpago & " and CONVENIO_ENC.estado_caja='A' and CONVENIO_ENC.estado = 1"
			else
				'sql="select ID_CONVENIO,rendido, CONVERT(varchar(10), FECHAINGRESO, 103) AS FECHAINGRESO,comp_ingreso, sucursal.des_suc, cliente.DESCRIPCION, rutdeudor, total_cliente, total_emp, caja_tipo_pago.desc_tipo_pago,usringreso from CONVENIO_ENC,cliente,caja_tipo_pago,sucursal where cliente.CODCLIENTE =CONVENIO_ENC.cod_cliente and caja_tipo_pago.id_tipo_pago = CONVENIO_ENC.tipo_pago and sucursal.cod_suc = CONVENIO_ENC.sucursal and CONVENIO_ENC.ID_CONVENIO=" & codpago & " and CONVENIO_ENC.sucursal='" & sucursal & "' and CONVENIO_ENC.estado_caja='A' and CONVENIO_ENC.estado = 1"
			end if
		end if
		%>
	</table>
	<table width="100%" border="0" bordercolor="#999999">

	      <tr height="20" bordercolor="#999999"  bgcolor="#<%=session("COLTABBG")%>" class="Estilo13">
		  <td>CLIENTE</td>
		 	<td>USUARIO</td>
			<td>DESDE</td>
			<td>HASTA</td>
	      </tr>
		  <tr bordercolor="#999999" class="Estilo8">
		  <td>

		<select name="CLIENTE" ID = "CLIENTE" width="15" onchange="tipopago()">
		<option value="0">SELECCIONAR</option>
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
		  	<td>
				<SELECT NAME="cmb_usuario" id="cmb_usuario" onchange="Refrescar();">
				<option value="0">TODOS</option>
				<%
				ssql="SELECT DISTINCT ID_USUARIO, LOGIN FROM USUARIO U, CONVENIO_ENC C WHERE U.ID_USUARIO = C.USRINGRESO"
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
		<a href="javascript:showCal('Calendar7');"><img src="../images/calendario.gif" border="0"></a>
			</td>
			<td><input name="termino" type="text" id="termino" value="<%=termino%>" size="10" maxlength="10">
          <a href="javascript:showCal('Calendar6');"><img src="../images/calendario.gif" border="0"></a>
			<input type="Button" name="Submit" value="Ver" onClick="envia();">
			<!--input type="button" name="Submit" value="Excel" onClick="javascript:envia_excel('detalle_convenio_excel.asp?strrut=<%=strrut%>&codpago=<%=codpago%>&sucursal=<%=sucursal%>&termino=<%=termino%>&inicio=<%=inicio%>&usuario=<%=usuario%>&CLIENTE=<%=CLIENTE%>')"></td-->
	      </tr>
    </table>
	<table width="100%" border="0" bordercolor="#000000">
		<tr bordercolor="#999999"  bgcolor="#<%=session("COLTABBG")%>" class="Estilo13">
			<td>COD. CONV</td>
			<td>FOLIO</td>
			<td>ESTADO</td>
			<td>USU.ING.</td>
			<td>FECHA CONV</td>
			<td>CLIENTE</td>
			<td>RUT DEUDOR</td>
			<td>MONTO <%=UCASE(session("NOMBRE_CONV_PAGARE"))%></td>
			<td>MOROSIDAD</td>
			<td>&nbsp</td>
			<td>&nbsp</td>
			<td>&nbsp</td>
			<td>&nbsp</td>
			<td>&nbsp</td>
		</tr>
	<%
	if resp="si" then
		SQL = "SELECT FOLIO,NOM_ESTADO_FOLIO,ID_CONVENIO,CONVERT(VARCHAR(10), FECHAINGRESO, 103) AS FECHAINGRESO,CLIENTE.DESCRIPCION, RUTDEUDOR, TOTAL_CONVENIO, ISNULL(USRINGRESO,0) AS USRINGRESO FROM CONVENIO_ENC,CLIENTE,ESTADO_FOLIO WHERE CLIENTE.CODCLIENTE = CONVENIO_ENC.COD_CLIENTE AND ESTADO_FOLIO.COD_ESTADO_FOLIO = CONVENIO_ENC.COD_ESTADO_FOLIO"
		SQL = SQL & " AND CONVENIO_ENC.COD_CLIENTE IN (SELECT CODCLIENTE FROM USUARIO_CLIENTE WHERE ID_USUARIO = " & session("session_idusuario") & ")"
		IF CLIENTE <> "0" THEN
			SQL = SQL & " AND CONVENIO_ENC.COD_CLIENTE = '" & CLIENTE & "'"
		END IF
		IF usuario <> "0" THEN
			SQL = SQL & " AND  USRINGRESO=" & usuario & " "
		END IF
		SQL = SQL & " AND FECHAINGRESO between '" & inicio & " 00:00:00' and '" & termino & " 23:59:59' "
	end if
	if resp="123" then
		SQL = "SELECT FOLIO,NOM_ESTADO_FOLIO,ID_CONVENIO,CONVERT(VARCHAR(10), FECHAINGRESO, 103) AS FECHAINGRESO,CLIENTE.DESCRIPCION, RUTDEUDOR, TOTAL_CONVENIO, ISNULL(USRINGRESO,0) AS USRINGRESO FROM CONVENIO_ENC,CLIENTE,ESTADO_FOLIO WHERE CLIENTE.CODCLIENTE = CONVENIO_ENC.COD_CLIENTE AND ESTADO_FOLIO.COD_ESTADO_FOLIO = CONVENIO_ENC.COD_ESTADO_FOLIO"
		SQL = SQL & " AND CONVENIO_ENC.COD_CLIENTE IN (SELECT CODCLIENTE FROM USUARIO_CLIENTE WHERE ID_USUARIO = " & session("session_idusuario") & ")"

		If Trim(strrut)  <> "" Then
			SQL = SQL & " AND RUTDEUDOR = '" & strrut & "'"
		End If
		If Trim(codpago)  <> "" Then
			SQL = SQL & " AND ID_CONVENIO = " & codpago
		End If
	end if
	'response.write "strTipo=" & strTipo
	If Trim(strTipo) = "EP" Then
		SQL = SQL & " AND CONVENIO_ENC.COD_ESTADO_FOLIO IN ( 1,2 )"
	End If
		SQL = SQL & " order by ID_CONVENIO desc"
		'response.write(SQL)
		'response.end
	if sql <> "" then
		set rsDet=Conn.execute(SQL)

		if not rsDet.eof then
			do while not rsDet.eof
				ssql="SELECT * FROM USUARIO WHERE ID_USUARIO = " & rsDet("USRINGRESO")
				set rsUsuIng=Conn.execute(ssql)
				if not rsUsuIng.eof then
					usringreso= rsUsuIng("login")
				end if
				intTotalConvenio = ValNulo(rsDet("TOTAL_CONVENIO"),"N")


                sssql = "SELECT id_convenio, sum(total_cuota) as morosidad"
				sssql = sssql & " from convenio_det where id_convenio = " & rsDet("ID_CONVENIO")
				sssql = sssql & " and pagada is null and fecha_pago < getdate()"
				sssql = sssql & "group by id_convenio order by ID_CONVENIO desc"

				set rsMorosidad=Conn.execute(sssql)

				if not rsMorosidad.eof then
					usrMorosidad= rsMorosidad("morosidad")
					else
					usrMorosidad= "0"
				end if


			%>
			<tr bgcolor="#<%=session("COLTABBG2")%>" class="Estilo8">
				<td><%=rsDet("ID_CONVENIO")%></td>
				<td><%=rsDet("FOLIO")%></td>
				<td><%=rsDet("NOM_ESTADO_FOLIO")%></td>
				<td><%=usringreso%></td>
				<td><%=rsDet("FECHAINGRESO")%></td>
				<td><%=rsDet("DESCRIPCION")%></td>
				<td><A HREF="principal.asp?rut=<%=rsDet("rutdeudor")%>"><acronym title="Llevar a pantalla de selección"><%=rsDet("rutdeudor")%></acronym></A></td>

				<TD ALIGN="RIGHT"><%=FN(intTotalConvenio,0)%></td>

				<TD ALIGN="RIGHT"><%=usrMorosidad%></td>

				<td><A HREF="det_convenio.asp?id_convenio=<%=rsDet("ID_CONVENIO")%>"><acronym title="VER CONVENIO"><%=rsDet("ID_CONVENIO")%></acronym></A></td>
				<td><A HREF="caja_web.asp?CB_TIPOPAGO=CO&id_convenio=<%=rsDet("ID_CONVENIO")%>&rut=<%=rsDet("RUTDEUDOR")%>"><acronym title="PAGO DE CUOTAS DEL CONVENIO">Pagar Cuota</acronym></A></td>
				<td><A HREF="cuponera_convenios.asp?strImprime=S&intNroConvenio=<%=rsDet("ID_CONVENIO")%>"><acronym title="IMPRIMIR CUPONERA DEL CONVENIO">Cuponera</acronym></A></td>
				<td><A HREF="visualizar_convenio.asp?strGrabar=N&TX_RUT=<%=rsDet("RUTDEUDOR")%>&intIdConvenio=<%=rsDet("ID_CONVENIO")%>"><acronym title="IMPRIMIR <%=UCASE(session("NOMBRE_CONV_PAGARE"))%> ORIGINAL"><%=session("NOMBRE_CONV_PAGARE")%></acronym></A></td>
				<% If TraeSiNo(session("perfil_full"))="Si" Then %>
					<td><A HREF="#" onClick="Reversar(<%=rsDet("ID_CONVENIO")%>)";>Reversar</A></td>
				<% Else%>
					<td>&nbsp;</td>
				<% End If%>
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

<script language="JavaScript " type="text/JavaScript">
function Reversar(cod_convenio)
{
	with( document.datos )
	{
		//alert("Opción deshabilitada");

		if (confirm("¿ Está seguro de reversar el <%=session("NOMBRE_CONV_PAGARE")%> ? El <%=session("NOMBRE_CONV_PAGARE")%> se eliminará completamente y la deuda será reversada, volviendo a su estado original antes del pago."))
			{
				action = "reversar_convenio.asp?cod_convenio=" + cod_convenio;
				submit();
			}
		else
			alert("Reverso del <%=session("NOMBRE_CONV_PAGARE")%> cancelado");
	}
}
</script>
