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
	if Trim(inicio) = "" Then
		inicio = TraeFechaMesActual(Conn,-1)
		inicio = "01" & Mid(inicio,3,10)
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
	datos.action = "detalle_repactacion.asp?resp="+ resp +"";
	datos.submit();
}

function Ingresa()
{
	with( document.datos )
	{
		action = "detalle_repactacion.asp";
		submit();
	}
}

function envia()
{
	datos.TX_RUT.value='';
	datos.TX_PAGO.value='';
	resp='si'
	datos.action = "detalle_repactacion.asp?resp="+ resp +"";
	datos.submit();
}

function Buscar()
{

	if (datos.TX_RUT.value == '' && datos.TX_PAGO.value =='' ) {
		alert('Debe ingresar rut o codigo de la repactacion');
		return
	}
	resp='123'
	datos.action = "detalle_repactacion.asp?resp="+ resp +"";
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
    <td height="20" bordercolor="#999999"  bgcolor="#<%=session("COLTABBG")%>" class="Estilo13" ALIGN="CENTER">LISTADO DE REPACTACIONES</td>
  </tr>
  <tr>
    <td valign="top">
	<table width="100%" border="0" bordercolor="#999999">
		<tr height="20" class="Estilo8">
	        <td>RUT: </td>
			<td><INPUT TYPE="text" NAME="TX_RUT" value="<%=strrut%>"></td>
		     <td>CODIGO REPACTACION: </td>
			<td><INPUT TYPE="text" NAME="TX_PAGO" value="<%=codpago%>"></td>
			<td><input type="Button" name="Submit" value="Buscar" onClick="Buscar();"></td>
		</tr>
		<%if codpago <> "" then
			if sucursal = "0" then
				'sql="select ID_CONVENIO,rendido, CONVERT(varchar(10), FECHAINGRESO, 103) AS FECHAINGRESO,comp_ingreso, sucursal.des_suc, cliente.DESCRIPCION, rutdeudor, total_cliente, total_emp, caja_tipo_pago.desc_tipo_pago,usringreso,CONVENIO_ANT from REPACTACION_ENC,cliente,caja_tipo_pago,sucursal where cliente.CODCLIENTE =REPACTACION_ENC.cod_cliente and caja_tipo_pago.id_tipo_pago = REPACTACION_ENC.tipo_pago and sucursal.cod_suc = REPACTACION_ENC.sucursal and REPACTACION_ENC.ID_CONVENIO=" & codpago & " and REPACTACION_ENC.estado_caja='A' and REPACTACION_ENC.estado = 1"
			else
				'sql="select ID_CONVENIO,rendido, CONVERT(varchar(10), FECHAINGRESO, 103) AS FECHAINGRESO,comp_ingreso, sucursal.des_suc, cliente.DESCRIPCION, rutdeudor, total_cliente, total_emp, caja_tipo_pago.desc_tipo_pago,usringreso,CONVENIO_ANT from REPACTACION_ENC,cliente,caja_tipo_pago,sucursal where cliente.CODCLIENTE =REPACTACION_ENC.cod_cliente and caja_tipo_pago.id_tipo_pago = REPACTACION_ENC.tipo_pago and sucursal.cod_suc = REPACTACION_ENC.sucursal and REPACTACION_ENC.ID_CONVENIO=" & codpago & " and REPACTACION_ENC.sucursal='" & sucursal & "' and REPACTACION_ENC.estado_caja='A' and REPACTACION_ENC.estado = 1"
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
				<SELECT NAME="cmb_usuario" id="cmb_usuario" onchange="Refrescar();">
				<option value="0">TODOS</option>
				<%
				ssql="SELECT DISTINCT ID_USUARIO, LOGIN FROM USUARIO U, REPACTACION_ENC C WHERE U.ID_USUARIO = C.USRINGRESO"
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
			<!--input type="button" name="Submit" value="Excel" onClick="javascript:envia_excel('detalle_repactacion_excel.asp?strrut=<%=strrut%>&codpago=<%=codpago%>&sucursal=<%=sucursal%>&termino=<%=termino%>&inicio=<%=inicio%>&usuario=<%=usuario%>&CLIENTE=<%=CLIENTE%>')"></td-->
	      </tr>
    </table>
	<table width="100%" border="0" bordercolor="#000000">
		<tr bordercolor="#999999"  bgcolor="#<%=session("COLTABBG")%>" class="Estilo13">
			<td>COD. REPACT</td>
			<td>USU.ING.</td>
			<td>FECHA REPACT</td>
			<td>CLIENTE</td>
			<td>RUT DEUDOR</td>
			<td>MONTO REPACT</td>
			<td>MOROSIDAD</td>
			<td>CONV.ANTERIOR</td>
			<td>&nbsp</td>
			<td>&nbsp</td>
			<td>&nbsp</td>
		</tr>
	<%
	if resp="si" then
		SQL = "SELECT ID_CONVENIO,CONVERT(VARCHAR(10), FECHAINGRESO, 103) AS FECHAINGRESO,CLIENTE.DESCRIPCION, RUTDEUDOR, TOTAL_CONVENIO, ISNULL(USRINGRESO,0) AS USRINGRESO, CONVENIO_ANT FROM REPACTACION_ENC,CLIENTE WHERE CLIENTE.CODCLIENTE = REPACTACION_ENC.COD_CLIENTE"
		IF CLIENTE <> "0" THEN
			SQL = SQL & " AND REPACTACION_ENC.COD_CLIENTE = '" & CLIENTE & "'"
		END IF
		IF usuario <> "0" THEN
			SQL = SQL & " AND  USRINGRESO=" & usuario & " "
		END IF
		SQL = SQL & " AND FECHAINGRESO between '" & inicio & " 00:00:00' and '" & termino & " 23:59:59' order by ID_CONVENIO desc"
	end if
	if resp="123" then
		SQL = "SELECT ID_CONVENIO,CONVERT(VARCHAR(10), FECHAINGRESO, 103) AS FECHAINGRESO,CLIENTE.DESCRIPCION, RUTDEUDOR, TOTAL_CONVENIO, ISNULL(USRINGRESO,0) AS USRINGRESO, CONVENIO_ANT FROM REPACTACION_ENC,CLIENTE WHERE CLIENTE.CODCLIENTE = REPACTACION_ENC.COD_CLIENTE"

		If Trim(strrut)  <> "" Then
			SQL = SQL & " AND RUTDEUDOR = '" & strrut & "'"
		End If
		If Trim(codpago)  <> "" Then
			SQL = SQL & " AND ID_CONVENIO = " & codpago
		End If
	end if
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


                sssql = "SELECT ID_CONVENIO, SUM(TOTAL_CUOTA) AS MOROSIDAD"
				sssql = sssql & " FROM REPACTACION_DET WHERE ID_CONVENIO = " & rsDet("ID_CONVENIO")
				sssql = sssql & " AND PAGADA IS NULL AND FECHA_PAGO < GETDATE()"
				sssql = sssql & " GROUP BY ID_CONVENIO ORDER BY ID_CONVENIO DESC"

				set rsMorosidad=Conn.execute(sssql)

				If not rsMorosidad.eof then
					usrMorosidad= rsMorosidad("morosidad")
				Else
					usrMorosidad= "0"
				End if


			%>
			<tr bgcolor="#<%=session("COLTABBG2")%>" class="Estilo8">
				<td><%=rsDet("ID_CONVENIO")%>&nbsp;&nbsp;<A HREF="det_repactacion.asp?id_convenio=<%=rsDet("ID_CONVENIO")%>"><acronym title="VER REPACTACION">Ver</acronym></A></td>
				<td><%=usringreso%></td>
				<td><%=rsDet("FECHAINGRESO")%></td>
				<td><%=rsDet("DESCRIPCION")%></td>
				<td><A HREF="principal.asp?rut=<%=rsDet("rutdeudor")%>"><acronym title="Llevar a pantalla de selección"><%=rsDet("rutdeudor")%></acronym></A></td>

				<TD ALIGN="RIGHT"><%=FN(intTotalConvenio,0)%></td>

				<TD ALIGN="RIGHT"><%=usrMorosidad%></td>

				<td><A HREF="det_convenio.asp?id_convenio=<%=rsDet("CONVENIO_ANT")%>"><acronym title="VER REPACTACION"><%=rsDet("CONVENIO_ANT")%></acronym></A></td>
				<td><A HREF="caja\caja_web.asp?CB_TIPOPAGO=RP&id_convenio=<%=rsDet("ID_CONVENIO")%>&rut=<%=rsDet("RUTDEUDOR")%>"><acronym title="PAGO DE CUOTAS DE LA REPACTACION">Pagar Cuota</acronym></A></td>
				<td><A HREF="cuponera_repactaciones.asp?strImprime=S&intNroConvenio=<%=rsDet("ID_CONVENIO")%>"><acronym title="IMPRIMIR CUPONERA DEL CONVENIO">Cuponera</acronym></A></td>

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
		if (confirm("¿ Está seguro de reversar la repactacion ? La repactacion se eliminará completamente y la deuda será reversada, volviendo a su estado original"))
			{
				action = "reversar_repactacion.asp?cod_convenio=" + cod_convenio;
				submit();
			}
		else
			alert("Reverso de la repactacion cancelado");
	}
}
</script>
