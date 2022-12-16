<% @LCID = 1034 %>


<!--#include file="../arch_utils.asp"-->
<!--#include file="../sesion.asp"-->
<!--#include file="../../lib/comunes/rutinas/funciones.inc" -->
<!--#include file="../../lib/comunes/rutinas/TraeCampo.inc" -->
<!--#include file="../asp/comunes/general/rutinasSCG.inc" -->
<!--#include file="../asp/comunes/general/rutinasBooleano.inc"-->


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
		//alert("Opción deshabilitada");


	if (confirm("¿ Está seguro de reversar el pago ? El pago se eliminará completamente y la deuda será reversada, volviendo a su estado original antes del pago."))
		{
			action = "reversar_pago.asp?cod_pago=" + cod_pago;
			submit();
		}
	else
		alert("Reverso del pago cancelado");
	}
}

function Modificar(cod_pago)
{
	with( document.datos )
	{
		action = "modif_caja_web2.asp?strOrigen=detalle_caja.asp&cod_pago=" + cod_pago;
		submit();
	}
}

function envia()
{
	//datos.TX_RUT.value='';
	//datos.TX_PAGO.value='';
	resp='si'
	document.datos.action = "detalle_caja.asp?resp="+ resp +"";
	document.datos.submit();
}

function imprimir()
{
	datos.action = "../imprime_comprobantes.asp";
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
			<td><INPUT TYPE="TEXT" NAME="TX_RUT" value="<%=strRut%>" onchange=""></td>
		    <td>CODIGO PAGO: </td>
			<td><INPUT TYPE="TEXT" NAME="TX_PAGO" value="<%=intCodPago%>" onchange=""></td>
			<td><INPUT TYPE="BUTTON" NAME="Imprimir" VALUE="Imprimir" onClick="imprimir();"></td>
		</tr>

	</table>
	<table width="100%" border="0" bordercolor="#999999">

	      <tr height="20" bordercolor="#999999"  bgcolor="#<%=session("COLTABBG")%>" class="Estilo13">
		  <td>CLIENTE</td>
		  <%if perfil="caja_modif" or perfil = "caja_listado" then%>
	        <td>SUCURSAL</td>
			<%end if%>
			<td>TIPO DE PAGO</td>
			<td>USUARIO</td>
			<td>DESDE</td>
			<td>HASTA</td>
	      </tr>
		  <tr bordercolor="#999999" class="Estilo8">
		  <td>

		<select name="CLIENTE" ID = "CLIENTE" width="15" onchange="">
		<% If TraeSiNo(session("perfil_emp")) <> "Si" Then %>
		<option value="0">SELECCIONAR</option>
		<% End If%>
		<%
		ssql="SELECT * FROM CLIENTE WHERE ACTIVO=1 AND CODCLIENTE IN (SELECT CODCLIENTE FROM USUARIO_CLIENTE WHERE ID_USUARIO = " & session("session_idusuario") & ")"
		If TraeSiNo(session("perfil_emp")) = "Si" Then
			ssql = ssql & "AND CODCLIENTE = " & session("ses_codcli")
		End If

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
				If Trim(intTipoPago)="CO" OR Trim(intTipoPago)="CC" Then
					strTipoCompArch = "comp_pago_convenio.asp"
					ssql = ssql & " WHERE ID_TIPO_PAGO in ('CO','CC')"
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
			<td>
				<SELECT NAME="cmb_usuario" id="cmb_usuario" onchange="Refrescar();">
					<option value="0">TODOS</option>
					<%
					If Trim(intTipoPago)="CO" OR Trim(intTipoPago)="CC" Then
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
			</td>
			<td><input name="inicio" type="text" id="inicio" value="<%=inicio%>" size="10" maxlength="10">
		<a href="javascript:showCal('Calendar7');"><img src="../../images/calendario.gif" border="0"></a>
			</td>
			<td><input name="termino" type="text" id="termino" value="<%=termino%>" size="10" maxlength="10">
          <a href="javascript:showCal('Calendar6');"><img src="../../images/calendario.gif" border="0"></a>
			<input type="Button" name="Submit" value="Ver" onClick="envia();">
			<!--input type="button" name="Submit" value="Excel" onClick="javascript:envia_excel('detalle_caja_excel.asp?strRut=<%=strRut%>&intCodPago=<%=intCodPago%>&sucursal=<%=sucursal%>&termino=<%=termino%>&inicio=<%=inicio%>&usuario=<%=usuario%>&CLIENTE=<%=CLIENTE%>')"-->
			</td>
	      </tr>
    </table>
	<table width="100%" border="0" bordercolor="#000000">
		<tr bordercolor="#999999"  bgcolor="#<%=session("COLTABBG")%>" class="Estilo13">
			<td>COD. PAGO</td>
			<td>USU.ING.</td>
			<td>FEC.PAGO</td>
			<td>CLIENTE</td>
			<td>RUT</td>
			<td>M.CAPIT.</td>
			<td>HONOR.</td>
			<td>INDEM</td>
			<td>G.JUD.</td>
			<td>INTERES</td>
			<td>G.ADM.</td>
			<td>G.OPE.</td>
			<td>T.B.</td>
			<td>T.PAGO</td>
			<td>&nbsp;</td>
			<td>&nbsp;</td>
			<!--td></td-->
			<td>COMP.</td>
			<td>&nbsp;</td>
		</tr>
	<%
	If resp="si" then
		strSql = "SELECT ID_PAGO,RENDIDO, MONTO_CAPITAL, GASTOSADMINISTRATIVOS, GASTOSOTROS, INDEM_COMP, INTERES_PLAZO, MONTO_EMP, CONVERT(VARCHAR(10), FECHA_PAGO, 103) AS FECHA_PAGO,COMP_INGRESO, CLIENTE.DESCRIPCION, RUTDEUDOR, usr_cob.fun_trae_busqueda_pos_neg (CODCLIENTE ,RUTDEUDOR) as TB, TOTAL_CLIENTE, TOTAL_EMP, CAJA_TIPO_PAGO.DESC_TIPO_PAGO,ISNULL(USRINGRESO,0) AS USRINGRESO, GASTOSJUDICIALES FROM CAJA_WEB_EMP,CLIENTE,CAJA_TIPO_PAGO WHERE CLIENTE.CODCLIENTE = CAJA_WEB_EMP.COD_CLIENTE AND CAJA_TIPO_PAGO.ID_TIPO_PAGO = CAJA_WEB_EMP.TIPO_PAGO " ' " and sucursal.cod_suc = caja_web_emp.sucursal "
		'IF sucursal <> "0" THEN
		'	strSql = strSql & "and sucursal='" & sucursal & "' "
		'END IF
		IF CLIENTE <> "0" THEN
			strSql = strSql & "and caja_web_emp.cod_cliente = '" & CLIENTE & "'"
		END IF
		IF usuario <> "0" THEN
			strSql = strSql & "and  usringreso=" & usuario & " "
		END IF
		If Trim(strRut) <> "" Then
			strSql = strSql & " AND RUTDEUDOR = '" & strRut & "'"
		End If
		IF intTipoPago <> "" THEN
			strSql = strSql & " AND TIPO_PAGO = '" & intTipoPago & "' "
		Else
			strSql = strSql & " AND TIPO_PAGO NOT IN ('CO','CC')"
		END IF

		IF intCodPago <> "" THEN
			strSql = strSql & " AND ID_PAGO = " & intCodPago & " "
		END IF

		strSql = strSql & " AND CAJA_WEB_EMP.COD_CLIENTE IN (SELECT CODCLIENTE FROM USUARIO_CLIENTE WHERE ID_USUARIO = " & session("session_idusuario") & ")"

		strSql = strSql & "and fecha_pago between '" & inicio & " 00:00:00' and '" & termino & " 23:59:59' order by id_pago desc"
		'strSql = strSql & "and rendido between '" & inicio & "' and '" & termino & "' and caja_web_emp.estado_caja='A' order by rendido"

		''Response.write "strSql = " & strSql
	End if


		'Response.write "strSql = " & strSql
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
				If Trim(rsDet("TB")) = "1" Then
					strTipoBusq="+"
				ElseIf Trim(rsDet("TB")) = "0" Then
					strTipoBusq="-"
				Else
					strTipoBusq=""
				End if

			%>
			<tr bgcolor="#<%=session("COLTABBG2")%>" class="Estilo8">
				<td><A HREF="det_caja.asp?cod_pago=<%=rsDet("id_pago")%>"><%=rsDet("id_pago")%></A></td>
				<td><%=usringreso%></td>
				<td><%=rsDet("fecha_pago")%></td>
				<td><%=rsDet("DESCRIPCION")%></td>
				<td>
					<A HREF="../principal.asp?rut=<%=rsDet("rutdeudor")%>"><acronym title="Llevar a pantalla de selección"><%=rsDet("rutdeudor")%></acronym></A>
				</td>
				<td><%=rsDet("monto_capital")%></td>
				<td align="right"><%=rsDet("monto_emp")%></td>
				<td align="right"><%=rsDet("indem_comp")%></td>
				<td align="right"><%=rsDet("gastosjudiciales")%></td>
				<td align="right"><%=rsDet("interes_plazo")%></td>
				<td align="right"><%=rsDet("GASTOSADMINISTRATIVOS")%></td>
				<td align="right"><%=rsDet("GASTOSOTROS")%></td>
				<td align="center"><%=strTipoBusq%></td>
				<td><%=rsDet("desc_tipo_pago")%></td>

				<%'if perfil="caja_modif" then%>


					<!--td><A HREF="reversar_pago.asp?cod_pago=<%=rsDet("id_pago")%>">Rever.</A></td-->

					<% If TraeSiNo(session("perfil_full"))="Si" Then %>
						<% If Trim(intTipoPago)="CO" OR Trim(intTipoPago)="CC" Then%>
							<td><A HREF="#" onClick="Reversar(<%=rsDet("id_pago")%>)";>Rever.</A></td>
						<% ElseIf Trim(intTipoPago)="RP" Then%>
							<td><A HREF="#" onClick="Reversar(<%=rsDet("id_pago")%>)";>Rever.</A></td>
						<% Else%>
							<td><A HREF="#" onClick="Reversar(<%=rsDet("id_pago")%>)";>Rever.</A></td>
						<% End If%>
						<td><A HREF="#" onClick="Modificar(<%=rsDet("id_pago")%>)";>Modif.</A></td>
					<% Else%>
						<td>&nbsp;</td>
					<% End If%>

					<!--td><A HREF="validar_caja.asp?cod_pago=<%=rsDet("id_pago")%>">Validar</A></td-->
					<td><A HREF="../<%=strTipoCompArch%>?strImprime=S&intNroComp=<%=rsDet("comp_ingreso")%>"><acronym title="Imprimir Comprobante"><%=rsDet("comp_ingreso")%></acronym></A></td>
				<%'end if
				%>
				<td><INPUT TYPE=checkbox NAME="CH_<%=rsDET("id_pago")%>">  </td>
			</tr>
			<INPUT TYPE=HIDDEN NAME="HD_COMP" VALUE="<%=rsDET("id_pago")%>"></td>
			<%

			rsDet.movenext
			loop
		end if
		%>

	<%end if%>
			<tr bgcolor="#<%=session("COLTABBG2")%>" class="Estilo8">
				<td colspan=5>TOTAL</td>
				<td><%=intTotCapital%></td>
				<td><%=intTotHonorarios%></td>
				<td><%=intTotIC%></td>
				<td><%=intTotGastosJud%></td>
				<td><%=intTotInteres%></td>
				<td><%=intTotGastosAdmin%></td>
				<td><%=intTotGastosOtros%></td>
				<td colspan=6>&nbsp;</td>
			</tr>
	</table>
	</td>
   </tr>
  </table>

</form>