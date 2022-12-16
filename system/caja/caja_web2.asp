<% @LCID = 1034 %>
<!--#include file="arch_utils.asp"-->
<!--#include file="../lib/comunes/rutinas/funciones.inc" -->
<!--#include file="../lib/comunes/rutinas/TraeCampo.inc" -->
<!--#include file="lib.asp"-->
<%
	rut = request("rut")
	'response.write(rut)
	strRutDeudor=rut
	'response.write(strRutDeudor)
	intSeq = request("intSeq")
	strGraba = request("strGraba")
	txt_FechaIni = request("txt_FechaIni")
	intSucursal="1"
	'hoy=now
	fecha= date
	strCodCliente = request("CB_CLIENTE")
	'usuario=110
	usuario=Session("intCodUsuario")
	sql="select * from usuario where cod_usuario = " & usuario & ""
	set rsUsu=Conn.execute(sql)
	if not rsUsu.eof then
		perfil=rsUsu("per_cajaweb")
		sucursalusuario = rsUsu("sucursal")
		strsql="select * from sucursal where cod_suc=" & sucursalusuario & ""
		set rssucursalusuario=ConexionSCG.execute(strSql)
		if not rssucursalusuario.eof then
			nom_sucursal=trim(rssucursalusuario("des_suc"))
		end if
	end if
	'response.write(perfil)
	if perfil = "caja_sucursal" then
	SQLL="select * from caja_web_cps_CIERRE WHERE SUCURSAL = '" & sucursalusuario & "' AND FECHA = '" & fecha & "'"
		set rsCIERRE=ConexionSCG.execute(SQLL)
		IF not rsCIERRE.EOF THEN

		%>
		<script>alert("La caja esta cerrada para este dia, no puede ingresar pagos")
		window.close();
		</script>
		<%
		'Response.Write ("<script language = ""Javascript"">" & vbCrlf)
		'Response.Write (vbTab & "location.href='javascript:parent.self.close()" & vbCrlf)
		'Response.Write ("</script>")
		end if
	end if

	intNroBoleta = request("TX_BOLETA")
	intCompIngreso = request("TX_COMPINGRESO")
	intCantDoc = request("TX_CANTDOC")
	intMontoCliente = request("TX_MONTOCLIENTE")
	intFormaPagoCliente = request("CB_FPAGO_CLIENTE")
	intMontoCps = request("TX_MONTOCPS")
	intFormaPagoCPS = request("CB_FPAGO_CLIENTE")
	intTipoPago = request("CB_TIPOPAGO")
	strNroDepositoCliente = request("TX_NRODEPCLIENTE")
	strNroDepositoCPS = request("TX_NRODEPCPS")
	strClaveDeudor = request("TX_CLAVEDOC")
	strNroLiquidacion = request("TX_NROLIQUIDACION")
	intPeriodoPagado = request("TX_PERIODO")
	intCapital = request("TX_CAPITAL")
	intReajuste = request("TX_REAJUSTE")
	intInteres = request("TX_INTERES")
	intGravamenes = request("TX_GRAVAMENES")
	intMulta = request("TX_MULTAS")
	intCargos = request("TX_CARGOS")
	intCostas = request("TX_COSTAS")
	intOtros = request("TX_OTROS")
	strDocCancelados = request("TX_DOCCANCELADOS")
	strObservaciones = request("TX_OBSERVACIONES")


	intNroBoleta = PN(intNroBoleta)
	intCompIngreso = PN(intCompIngreso)
	intCantDoc = PN(intCantDoc)
	intMontoCliente = PN(intMontoCliente)
	intFormaPagoCliente = PN(intFormaPagoCliente)
	intMontoCps = PN(intMontoCps)
	intFormaPagoCPS = PN(intFormaPagoCPS)
	intTipoPago = PN(intTipoPago)
	strNroDepositoCliente = PN(strNroDepositoCliente)
	strNroDepositoCPS = PN(strNroDepositoCPS)
	strClaveDeudor = PN(strClaveDeudor)
	strNroLiquidacion = PN(strNroLiquidacion)
	intPeriodoPagado = PN(intPeriodoPagado)
	intCapital = PN(intCapital)
	intReajuste = PN(intReajuste)
	intInteres = PN(intInteres)
	intGravamenes = PN(intGravamenes)
	intMulta = PN(intMulta)
	intCargos = PN(intCargos)
	intCostas = PN(intCostas)
	intOtros = PN(intOtros)
	strDocCancelados = PN(strDocCancelados)
	strObservaciones = PN(strObservaciones)

	'response.write(rut)
	'Response.write "<br>strGraba=" & strGraba
	'Response.write "<br>intSeq=" & intSeq

	If Trim(request("strGraba")) = "SI" AND Trim(request("intSeq")) <> "" Then
		strSql = "INSERT INTO CAJA_WEB_CPS (ID_PAGO, CORRELATIVO, PERIODO, SUCURSAL, FECHA_PAGO, COD_CLIENTE, RUTDEUDOR, COMP_INGRESO, NRO_BOLETA, CANTIDAD_DOC, MONTO_CAPITAL, FORMA_PAGO_CAPITAL, MONTO_CPS, FORMA_PAGO_CPS, TIPO_PAGO, NRO_DEPOSITO_CLIENTE, NRO_DEPOSITO_CPS, CLAVEDEUDOR, NRO_LIQUIDACION, PERIODO_PAGADO, CAPITAL, REAJUSTE, INTERESES, GRAVAMENES, MULTA, CARGOS, COSTAS, OTROS, DOC_CANCELADOS, OBSERVACIONES) "
		strSql = strSql & "VALUES (" & intSeq & ",usr_web_scg.CORR(" & intSeq & "),YEAR(getdate())," & intSucursal & ", getdate(),'" & strCodCliente & "','" &  strRutDeudor & "'," & intCompIngreso  & "," & intNroBoleta & "," & intCantDoc & "," & intMontoCliente & ",'" & intFormaPagoCliente & "'," & intMontoCps & ",'" & intFormaPagoCPS & "'," & intTipoPago & ",'" & strNroDepositoCliente & "','" & strNroDepositoCPS & "','" & strClaveDeudor & "'," & strNroLiquidacion & "," & intPeriodoPagado & "," & intCapital & "," & intReajuste & "," & intInteres & "," & intGravamenes & "," & intMulta & "," & intCargos & "," & intCostas & "," & intOtros & ",'" & strDocCancelados & "','" & strObservaciones & "')"
		'Response.write "strSql=" & strSql
		'Response.End
		'set rsInserta=ConexionSCG.execute(strSql)
	End If

	If Trim(request("strGraba")) <> "SI" AND Trim(request("intSeq")) = "" Then

		'strSql = "EXEC UPD_SEC 'CAJA_WEB_CPS'"
		'set rsPago=ConexionSCG.execute(strSql)
		'If not rsPago.Eof then
		'	intSeq = rsPago("SEQ")
		'End if

	End if
	'RESPONSE.WRITE "intSeq = " & intSeq
%>
<title>Intercapital</title>
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

function Refrescar(rut)
{
//alert(rut)
	if(rut == '')
	{
		return
	}
	//else{
		//with( document.datos )
		//{
//			alert(rut)
			datos.action = "caja_web2.asp?rut=" + rut + "&tipo=1";
			//alert(action)
			datos.submit();
		//}
	//}
}

function Ingresa(rut)
{

	if(rut == '')
	{
		return
	}

	with( document.datos )
	{
		action = "caja_web2.asp?rut=" + rut + "&tipo=2";
		submit();
	}
}

function IngresaP(rut)
{

	if(rut == '')
	{
		return
	}

	with( document.datos )
	{
		action = "caja_web2.asp?rut=" + rut + "&strGraba=SI&intSeq=<%=intSeq%>";
		submit();
	}
}

</script>


<link href="style.css" rel="Stylesheet">

<form name="datos" method="post">
<table width="600" height="500" border="1" bordercolor="#999999" cellpadding="2" cellspacing="10">
	<tr>
    	<td height="20"  bordercolor="#999999"  bgcolor="#339933" class="Estilo27" align="center"><strong>Módulo de Ingreso de Pagos Intercapital</strong></td>
  </tr>
  <tr>
    <td height="20" bordercolor="#999999"  bgcolor="#669966" class="Estilo27"><strong>Antecedentes de Ubicabilidad</strong></td>
  </tr>
  <tr>
    <td valign="top">
	  <%

	  if rut <> "" then

		strNombreDeudor = TraeNombreDeudor(conexionSCG,strRutDeudor)
		strFonoArea = TraeUltimoFonoDeudorSCG(conexionSCG,strRutDeudor,"CODAREA")
		strFonoFono = TraeUltimoFonoDeudorSCG(conexionSCG,strRutDeudor,"TELEFONO")

		strDirCalle= TraeUltimaDirDeudorSCG(conexionSCG,strRutDeudor,"CALLE")
		strDirNum = TraeUltimaDirDeudorSCG(conexionSCG,strRutDeudor,"NUMERO")
		strDirComuna = TraeUltimaDirDeudorSCG(conexionSCG,strRutDeudor,"COMUNA")
		strDirResto = TraeUltimaDirDeudorSCG(conexionSCG,strRutDeudor,"RESTO")

		strTelefonoDeudor = TraeUltimoFonoDeudorSCG(conexionSCG,strRutDeudor,"CODAREA") & "-" & TraeUltimoFonoDeudorSCG(conexionSCG,strRutDeudor,"TELEFONO")
		If Trim(strTelefonoDeudor) = "-" Then strTelefonoDeudor = "S/F"
	else
	strNombreDeudor=""
	strFonoArea = ""
	strFonoFono = ""
	strDirCalle = ""
	strDirNum = ""
	strDirComuna = ""
	strDirResto = ""
	end if

	%>

	<table width="100%" border="0" bordercolor="#FFFFFF">
	      <tr bgcolor="#FFFFFF" class="Estilo8">
	        <td ALIGN="LEFT">RUT : <input name="TX_RUT" type="text" size="10" maxlength="10" onChange="Valida_Rut(this.value)"></td>  <td>NOMBRE O RAZON SOCIAL: &nbsp;<%=strNombreDeudor%><INPUT TYPE="hidden" NAME="rut" value="<%=rut%>"> </td>
	        <td ALIGN="RIGHT">USUARIO : <%=Session("strNombreUsuario")%></td><td>&nbsp;&nbsp;SUCURSAL: <%=nom_sucursal%></td><td>FECHA: <%=DATE%></td>
	      </tr>
    </table>
	<table width="100%" border="0" bordercolor="#FFFFFF">
		<tr bordercolor="#999999"  bgcolor="#669966" class="Estilo13">
			<td width="50%">CALLE</td>
			<td width="10%">NÚMERO</td>
			<td width="20%">RESTO</td>
			<td width="20%">COMUNA</td>
		</tr>
		<tr>
			<td><INPUT TYPE="text" NAME="txt_calle" size="50" maxlength="100"></td>
			<td><INPUT TYPE="text" NAME="txt_numero" size="12" maxlength="10" onchange="solonumero(txt_numero);"></td>
			<td><INPUT TYPE="text" NAME="txt_resto" size="20" maxlength="50"></td>
			<td><SELECT NAME="cmb_comuna">
				<OPTION VALUE="">SELECCIONAR</OPTION>
			<%
		ssql="SELECT * FROM COMUNA WHERE CODIGO_COMUNA >0 order by nombre_comuna"
		set rsCM=ConexionSCG.execute(ssql)
		if not rsCM.eof then
			do until rsCM.eof
			%>
			<option value="<%=rsCM("codigo_comuna")%>"
			<%if Trim(comuna)=Trim(rsCM("nombre_comuna")) then
				response.Write("Selected")
			end if%>
			><%=ucase(rsCM("nombre_comuna"))%></option>

			<%rsCM.movenext
			loop
		end if
		rsCM.close
		set rsCM=nothing
		%>
			</SELECT></td>
		</tr>
		</table>
		<table width="100%" border="0" bordercolor="#FFFFFF">
		<tr bordercolor="#999999"  bgcolor="#669966" class="Estilo13">
			<td width="10%">COD. ÁREA</td>
			<td width="25%">TELEFONO 1</td>
			<td width="10%">COD. ÁREA</td>
			<td width="25%">TELEFONO 2</td>
			<td width="30%">E-MAIL</td>
		</tr>
		<tr>
			<td>
				<input name="num_min" type="hidden" value="0">
				<SELECT NAME="cmb_area1" id="cmb_area1" onblur="num_min.value=asigna_minimo(cmb_area1,num_min)">
					<option value="0">--</option>
					<option value="2">2</option>
					<option value="9">9</option>
				<%
					ssql="select distinct(codigo_area) from comuna where codigo_comuna > 0 and codigo_area > 2"
					set rstel=ConexionSCG.execute(ssql)
					if not rstel.eof then
						do until rstel.eof
						%>
						<option value="<%=rstel("codigo_area")%>"
						<%if Trim(codarea1)=Trim(rstel("codigo_area")) then
							response.Write("Selected")
						end if%>
						><%=ucase(rstel("codigo_area"))%></option>

						<%rstel.movenext
						loop
					end if
					rstel.close
					set rstel=nothing
		%>
				</SELECT>
			</td>
			<td><INPUT TYPE="text" NAME="txt_fono1" size="10" maxlength="8" onchange="valida_largo(datos.txt_fono1, datos.num_min.value);"></td>
			<td>
				<input name="num_min2" type="hidden" value="0">
				<SELECT NAME="cmb_area2" id="cmb_area2" onblur="num_min2.value=asigna_minimo2(cmb_area2,num_min2)">
					<option value="0">--</option>
					<option value="2">2</option>
					<option value="8">8</option>
					<option value="9">9</option>
					<%
					ssql="select distinct(codigo_area) from comuna where codigo_comuna > 0 and codigo_area > 2"
					set rstel=ConexionSCG.execute(ssql)
					if not rstel.eof then
						do until rstel.eof
						%>
						<option value="<%=rstel("codigo_area")%>"
						<%if Trim(codarea2)=Trim(rstel("codigo_area")) then
							response.Write("Selected")
						end if%>
						><%=ucase(rstel("codigo_area"))%></option>

						<%rstel.movenext
						loop
					end if
					rstel.close
					set rstel=nothing
					%>
				</SELECT>
			</td>
			<td><INPUT TYPE="text" NAME="txt_fono2" size="10" maxlength="8" onchange="valida_largo2(datos.txt_fono2, datos.num_min2.value);"></td>
			<td><INPUT TYPE="text" NAME="txt_mail" ONCHANGE="ValidarCorreo(this.value);"></td>
		</tr>
	</table>
	</td>
	</tr>
	<tr>
	<td  bordercolor="#999999"  bgcolor="#339933">
	<font class="Estilo27"><strong>&nbsp;Resumen Pago</strong></font>
	</td>
	</tr>
	<tr>
	<td>
	<table width="100%" border="0">
      <tr  bordercolor="#999999"  bgcolor="#339933">
		<%if perfil = "caja_modif" then%>
		<td><span class="Estilo27">SUCURSAL</span></td>
		<%end if%>
        <td><span class="Estilo27">CLIENTE</span></td>
        <td><span class="Estilo27">Nro. Liq.</span></td>
        <td><span class="Estilo27">N° Comprobante</span></td>
		<td><span class="Estilo27">N° Boleta</span></td>
		<td><span class="Estilo27">Tipo Pago</span></td>
       </tr>
      <tr class="Estilo8">
        <%if perfil = "caja_modif" then%>
		<td><SELECT NAME="cmb_sucursal" id="cmb_sucursal">
				<option value="">SELECCIONAR</option>
				<%
				ssql="SELECT * FROM sucursal where cod_suc > 0 order by cod_suc"
				set rsSuc=ConexionSCG.execute(ssql)
				if not rsSuc.eof then
					do until rsSuc.eof
					%>
					<option value="<%=rsSuc("cod_suc")%>"
					<%if Trim(sucursal)=Trim(rsSuc("cod_suc")) then
						response.Write("Selected")
					end if%>
					><%=ucase(rsSuc("cod_suc") & " - " & rsSuc("DES_suc"))%></option>

					<%rsSuc.movenext
					loop
				end if
				rsSuc.close
				set rsSuc=nothing
				%>
				</SELECT></td>
		<%end if%>

		<td>

		<select name="CB_CLIENTE" width="15" onchange="tipopago()">
		<option value="0">SELECCIONAR</option>
		<%
		ssql="SELECT * FROM CAJA_CLIENTE where activo=1 and id_cliente <> 'INT' and id_cliente <> 'cpspr'"
		set rsCLI=ConexionSCG.execute(ssql)
		if not rsCLI.eof then
			do until rsCLI.eof
			%>
			<option value="<%=rsCLI("ID_CLIENTE")%>"
			<%if Trim(cliente)=Trim(rsCLI("ID_CLIENTE")) then
				response.Write("Selected")
			end if%>
			><%=ucase(rsCLI("ID_CLIENTE") & " - " & rsCLI("DESC_CLIENTE"))%></option>

			<%rsCLI.movenext
			loop
		end if
		rsCLI.close
		set rsCLI=nothing
		%>
        </select>
        </td>
		<td><input name="TX_NROLIQUIDACION" type="text" value="" size="10" maxlength="10"></td>
	    <td><input name="TX_COMPINGRESO" type="text" value="" size="10" maxlength="10"></td>
		<td><input name="TX_BOLETA" type="text" value="" size="10" maxlength="10"></td>
		<td>
		<select name="CB_TIPOPAGO" width="10" onchange="tipopago();">
				<option value="" width="10">SELECCIONAR</option>
				<%
				ssql="SELECT * FROM CAJA_TIPO_PAGO"
				set rsCLI=ConexionSCG.execute(ssql)
				if not rsCLI.eof then
					do until rsCLI.eof
					%>
					<option value="<%=rsCLI("ID_TIPO_PAGO")%>"
					<%if Trim(cliente)=Trim(rsCLI("ID_TIPO_PAGO")) then
						response.Write("Selected")
					end if%>width="10"
					><%=ucase(rsCLI("ID_TIPO_PAGO") & " - " & rsCLI("DESC_TIPO_PAGO"))%></option>

					<%rsCLI.movenext
					loop
				end if
				rsCLI.close
				set rsCLI=nothing
				%>
		</select>
		</td>
        </tr>
    </table>
	</td>
	</tr>
	<tr>
	<td>
	<table width="100%" border="0">
	  <tr  bordercolor="#999999"  bgcolor="#339933">
		<td><span class="Estilo27">Monto Cliente</span></td>
		<td><span class="Estilo27">Nro.Dep.Cliente</span></td>
		<td><span class="Estilo27">Banco</span></td>
		<td><span class="Estilo27">Interes Plazo</span></td>
		<td><span class="Estilo27">Descuento Cliente</span></td>
		<td><span class="Estilo27">Total Cliente</span></td>
		<td></td>
		</tr>
		<tr class="Estilo8">
		<td><input name="TX_MONTOCLIENTE" type="text" value="" size="10" maxlength="10" onchange="validamonto();" disabled></td>

		<td><input name="TX_NRODEPCLIENTE" type="text" value="" size="10" maxlength="10"></td>
		<td><select name="CB_BCLIENTE" class="Estilo8">
		<option value="">SELECCIONAR</option>
		<%
		ssql="SELECT * FROM T_BANCOS"
		set rsBANC=ConexionSCG.execute(ssql)
		if not rsBANC.eof then
			do until rsBANC.eof
			%>
			<option value="<%=rsBANC("BA_CODIGO")%>"
			<%if Trim(bancocliente)=Trim(rsBANC("BA_CODIGO")) then
				response.Write("Selected")
			end if%>
			><%=ucase(rsBANC("BA_CODIGO") & " - " & Mid(rsBANC("BA_DESCRIPCION"),1,15))%></option>

			<%rsBANC.movenext
			loop
		end if
		rsBANC.close
		set rsBANC=nothing
		%>
		</select></td>
		<td><input name="TX_IPCLIENTE" type="text" value="" size="10" maxlength="10" onchange="solonumero(TX_DESCLIENTE);montocliente()"></td>
		<td><input name="TX_DESCLIENTE" type="text" value="" size="10" maxlength="10" onchange="solonumero(TX_DESCLIENTE);montocliente()"></td>
		<td><input name="TX_TOTALCLIENTE" type="text" value="" size="10" maxlength="10" disabled></td>
		</tr>
	<tr  bordercolor="#999999"  bgcolor="#339933">
		<td><span class="Estilo27">Monto Intercapital</span></td>
		<td><span class="Estilo27">Nro.Dep. Intercapital</span></td>
		<td><span class="Estilo27">Banco</span></td>
		<td><span class="Estilo27">Costas Intercapital</span></td>
		<td><span class="Estilo27">Descuento Intercapital</span></td>
		<td><span class="Estilo27">Total Intercapital</span></td>
		<td><span class="Estilo27">Total General</span></td>
	  </tr>

		<tr>
		<td><input name="TX_MONTOCPS" type="text" value="" size="10" maxlength="10" onchange="solonumero(TX_MONTOCPS);montocliente()" ></td>
		<!-- <td>
		<select name="CB_FPAGO_CPS" onchange="fpago_cps();">
		<option value="">SELECCIONE</option>
		<%
		ssql="SELECT * FROM CAJA_FORMA_PAGO"
		set rsCLI=ConexionSCG.execute(ssql)
		if not rsCLI.eof then
			do until rsCLI.eof
			%>
			<option value="<%=rsCLI("ID_FORMA_PAGO")%>"
			<%if Trim(cliente)=Trim(rsCLI("ID_FORMA_PAGO")) then
				response.Write("Selected")
			end if%>
			><%=rsCLI("ID_FORMA_PAGO") & " - " & Mid(rsCLI("DESC_FORMA_PAGO"),1,15)%></option>

			<%rsCLI.movenext
			loop
		end if
		rsCLI.close
		set rsCLI=nothing
		%>
		</select>
        </td> -->
		<td><input name="TX_NRODEPCPS" type="text" value="" size="10" maxlength="10"></td>
		<td><select name="CB_BCPS" class="Estilo8">
		<option value="">SELECCIONAR</option>
		<%
		ssql="SELECT * FROM T_BANCOS"
		set rsBANC=ConexionSCG.execute(ssql)
		if not rsBANC.eof then
			do until rsBANC.eof
			%>
			<option value="<%=rsBANC("BA_CODIGO")%>"
			<%if Trim(bancocps)=Trim(rsBANC("BA_CODIGO")) then
				response.Write("Selected")
			end if%>
			><%=ucase(rsBANC("BA_CODIGO") & " - " & Mid(rsBANC("BA_DESCRIPCION"),1,15))%></option>

			<%rsBANC.movenext
			loop
		end if
		rsBANC.close
		set rsBANC=nothing
		%>
		</select></td>
		<td><input name="TX_CCPS" type="text" value="" size="10" maxlength="10" onchange="solonumero(TX_CCPS);montocliente()"></td>
		<td><input name="TX_DESCUENTO" type="text" value="" size="10" maxlength="10" onchange="solonumero(TX_DESCUENTO);montocliente()"></td>
		<td><input name="TX_TOTALCPS" type="text" value="" size="10" maxlength="10" disabled></td>
		<td><input name="TX_TOTAL" type="text" value="" size="10" maxlength="10" disabled></td>
	  </tr>

	</table>
	<table><tr><td>OBSERVACIONES: </td><td><INPUT TYPE="text" NAME="tx_observacion" size="126"></td></tr></table>
</td>
</tr>

<tr>
<td  bordercolor="#999999"  bgcolor="#669966">
	<font class="Estilo27"><strong>&nbsp;Detalle Pago Mandante</strong></font>
</td>
</tr>
<tr>
<td>
	 <table width="100%" border="0">
	    <tr  bordercolor="#999999"  bgcolor="#669966">
			<td><span class="Estilo27">Clave / Nro Doc</span></td>
			<td><span class="Estilo27">Periodo</span></td>
			<td><span class="Estilo27">Nro Cuota</span></td>
			<td><span class="Estilo27">Capital</span></td>
			<td><span class="Estilo27">Reajuste</span></td>
			<td><span class="Estilo27">Interes</span></td>
			<td><span class="Estilo27">Gravámenes</span></td>
			<td><span class="Estilo27">Multas</span></td>
			<td><span class="Estilo27">Cargos</span></td>
			<td><span class="Estilo27">Costas</span></td>
			<!-- <td><span class="Estilo27">Otros</span></td> -->
			<td></td>
		</tr>
		<tr>
			<td><input name="TX_CLAVEDOC" type="text" value="" size="10" maxlength="20" class="Estilo8"></td>
			<td>
			<select name="TX_ANO" id="TX_ANO" class="Estilo8">
			<option value=""></option>
			<%
			i=1970
			anoactual = year(date)
			do while i <= anoactual %>
			<option value ="<%=i%>"><%=i%></option>
			<%
				i = i + 1
			loop%>
			</select>
			<select name="TX_MES" id="TX_MES" class="Estilo8">
			<option value=""></option>
			<option value="01">01</option>
			<option value="02">02</option>
			<option value="03">03</option>
			<option value="04">04</option>
			<option value="05">05</option>
			<option value="06">06</option>
			<option value="07">07</option>
			<option value="08">08</option>
			<option value="09">09</option>
			<option value="10">10</option>
			<option value="11">11</option>
			<option value="12">12</option>
			</select>
			<!-- <input name="TX_PERIODO" type="text" value="" size="10" maxlength="6" class="Estilo8"> --></td>
			<td><select name="CB_CUOTA" class="Estilo8" disabled>

		<%
		i=0
		do while i <=20
		%>
			<option value="<%=i%>"><%=i%></option>
		<%
			i=i+1
		loop
		%>
		</select></td>
			<td><input name="TX_CAPITAL" type="text" value="" size="8" maxlength="10" class="Estilo8" onchange="solonumero(TX_CAPITAL);"></td>
			<td><input name="TX_REAJUSTE" type="text" value="" size="8" maxlength="10" class="Estilo8" onchange="solonumero(TX_REAJUSTE);"></td>
			<td><input name="TX_INTERES" type="text" value="" size="8" maxlength="10" class="Estilo8" onchange="solonumero(TX_INTERES);"></td>
			<td><input name="TX_GRAVAMENES" type="text" value="" size="8" maxlength="10" class="Estilo8" onchange="solonumero(TX_GRAVAMENES);"></td>
			<td><input name="TX_MULTAS" type="text" value="" size="8" maxlength="10" class="Estilo8" onchange="solonumero(TX_MULTAS);"></td>
			<td><input name="TX_CARGOS" type="text" value="" size="8" maxlength="10" class="Estilo8" onchange="solonumero(TX_CARGOS);"></td>
			<td><input name="TX_COSTAS" type="text" value="" size="8" maxlength="10" class="Estilo8" onchange="solonumero(TX_COSTAS);"></td>
			<!-- <td><input name="TX_OTROS" type="text" value="" size="8" maxlength="10" class="Estilo8" onchange="solonumero(TX_OTROS);"></td> -->
			<td><input type="button" name="ingpago" value="Ingresar" onClick="meteplan();" class="Estilo8"></td>
		</tr>
		<tr>
			<td><select name="CLAVEDOC" size="3" id="CLAVEDOC"  ondblClick=" borra_combos(this.selectedIndex);" onChange="select_combos(this.selectedIndex);" class="Estilo8"></select></td>

			<td><select name="PERIODO" size="3" id="PERIODO"  ondblClick=" borra_combos(this.selectedIndex);" onChange="select_combos(this.selectedIndex);" class="Estilo8"></select></td>

			<td><select name="CUOTA" size="3" id="CUOTA"  ondblClick=" borra_combos_cli(this.selectedIndex);" onChange="select_combos_cli(this.selectedIndex);" class="Estilo8"></select></td>

			<td><select name="CAPITAL" size="3" id="CAPITAL"  ondblClick=" borra_combos(this.selectedIndex);" onChange="select_combos(this.selectedIndex);" class="Estilo8"></select></td>

			<td><select name="REAJUSTE" size="3" id="REAJUSTE"  ondblClick=" borra_combos(this.selectedIndex);" onChange="select_combos(this.selectedIndex);" class="Estilo8"></select></td>

			<td><select name="INTERES" size="3" id="INTERES"  ondblClick=" borra_combos(this.selectedIndex);" onChange="select_combos(this.selectedIndex);" class="Estilo8"></select></td>

			<td><select name="GRAVAMENES" size="3" id="GRAVAMENES"  ondblClick=" borra_combos(this.selectedIndex);" onChange="select_combos(this.selectedIndex);" class="Estilo8"></select></td>

			<td><select name="MULTAS" size="3" id="MULTAS"  ondblClick=" borra_combos(this.selectedIndex);" onChange="select_combos(this.selectedIndex);" class="Estilo8"></select></td>

			<td><select name="CARGOS" size="3" id="CARGOS"  ondblClick=" borra_combos(this.selectedIndex);" onChange="select_combos(this.selectedIndex);" class="Estilo8"></select></td>

			<td><select name="COSTAS" size="3" id="COSTAS"  ondblClick=" borra_combos(this.selectedIndex);" onChange="select_combos(this.selectedIndex);" class="Estilo8"></select></td>

			<!-- <td><select name="OTROS" size="3" id="OTROS"  ondblClick=" borra_combos(this.selectedIndex);" onChange="select_combos(this.selectedIndex);" class="Estilo8"></select></td> -->
			</tr>
	</table>
<tr  bordercolor="#999999"  bgcolor="#339933">
<td>
	<font class="Estilo27"><strong>&nbsp;Detalle de Documentos</strong></font>
</td>
</tr>
<tr>
<td>
	<table width="100%" border="0">
	<tr  bordercolor="#999999"  bgcolor="#339933">
		<td><span class="Estilo27">Destino Pago</span></td>
		<td><span class="Estilo27">Forma Pago</span></td>

        <td class="Estilo27">Rut Cheque</td>
        <td><span class="Estilo27">Monto</span></td>
        <td><span class="Estilo27">Fecha Venc</span></td>
		<td><span class="Estilo27">Banco</span></td>
		<td><span class="Estilo27">Plaza</span></td>
		<td><span class="Estilo27">N° Cheque</span></td>
		<td><span class="Estilo27">Cta. Cte.</span></td>
		<TD></TD>
       </tr>
      <tr>
		<td><select name="CB_DESTINO" class="Estilo8">
		<option value="">SELECCIONAR</option>
		<option value="0">CLIENTE</option>
		<option value="1">INTERCAPITAL GASTOS</option>
		<option value="2">INTERCAPITAL COSTAS</option>
		</select></td>
		<td>
		<select name="CB_FPAGO" width="10" maxlength="10" class="Estilo8" onchange="FormaPago();">
		<option value="">SELECCIONAR</option>
		<%
		ssql="SELECT * FROM CAJA_FORMA_PAGO"
		set rsCLI=ConexionSCG.execute(ssql)
		if not rsCLI.eof then
			do until rsCLI.eof
			%>
			<option value="<%=rsCLI("ID_FORMA_PAGO")%>"
			<%if Trim(cliente)=Trim(rsCLI("ID_FORMA_PAGO")) then
				response.Write("Selected")
			end if%>
			><%=ucase(rsCLI("ID_FORMA_PAGO") & " - " & rsCLI("DESC_FORMA_PAGO"))%></option>

			<%rsCLI.movenext
			loop
		end if
		rsCLI.close
		set rsCLI=nothing
		%>
		</select>
        </td>

        <td><input name="TX_RUTCLI" type="text" value="" size="10" maxlength="10" class="Estilo8" onchange="Valida_Rut(this.value)"></td>
		<td><input name="TX_MONTOCLI" type="text" value="" size="8" maxlength="10" class="Estilo8" onchange="solonumero(TX_MONTOCLI);"></td>
	    <td><input name="inicio" type="text" id="inicio" value="" size="8" maxlength="10" class="Estilo8" onBlur="muestra_dia()"><a href="javascript:showCal('Calendar7');"><img src="../../images/calendario.gif" border="0"></a></td>
		<td><select name="CB_BANCO_CLIENTE" class="Estilo8">
		<option value="">SELECCIONAR</option>
		<%
		ssql="SELECT * FROM T_BANCOS"
		set rsBANC=ConexionSCG.execute(ssql)
		if not rsBANC.eof then
			do until rsBANC.eof
			%>
			<option value="<%=rsBANC("BA_CODIGO")%>"
			<%if Trim(banco)=Trim(rsBANC("BA_CODIGO")) then
				response.Write("Selected")
			end if%>
			><%=ucase(rsBANC("BA_CODIGO") & " - " & Mid(rsBANC("BA_DESCRIPCION"),1,15))%></option>

			<%rsBANC.movenext
			loop
		end if
		rsBANC.close
		set rsBANC=nothing
		%>
		</select></td>
		<td><select name="CB_PLAZA_CLIENTE" class="Estilo8">
		<option value="">SELECCIONAR</option>
		<%
		ssql="SELECT * FROM T_PLAZA"
		set rsPLA=ConexionSCG.execute(ssql)
		if not rsPLA.eof then
			do until rsPLA.eof
			%>
			<option value="<%=rsPLA("PL_CODIGO")%>"
			<%if Trim(plaza)=Trim(rsPLA("PL_CODIGO")) then
				response.Write("Selected")
			end if%>
			><%=ucase(rsPLA("PL_CODIGO") & " - " & Mid(rsPLA("PL_DESCRIPCION"),1,15))%></option>

			<%rsPLA.movenext
			loop
		end if
		rsPLA.close
		set rsPLA=nothing
		%>
		</select></td>
		<td><input name="TX_NROCHEQUECLI" type="text" value="" size="8" maxlength="20" class="Estilo8"></td>
		<td><input name="TX_NROCTACTECLI" type="text" value="" size="8" maxlength="20" class="Estilo8"></td>
		<td><input type="button" name="ingdoc" value="Ingresar" onClick="metedoccli();" class="Estilo8"></td>
        </tr>
	   <tr >

			<td><select name="DESTINO" size="3" id="DESTINO"  ondblClick=" borra_combos_cli(this.selectedIndex);" onChange="select_combos_cli(this.selectedIndex);" class="Estilo8"></select></td>

			<td><select name="FPAGO" size="3" id="FPAGO"  ondblClick=" borra_combos_cli(this.selectedIndex);" onChange="select_combos_cli(this.selectedIndex);" class="Estilo8"></select></td>

			<td><select name="RUTCLI" size="3" id="RUTCLI"  ondblClick=" borra_combos_cli(this.selectedIndex);" onChange="select_combos_cli(this.selectedIndex);" class="Estilo8"></select></td>

			<td><select name="MONTOCLI" size="3" id="MONTOCLI"  ondblClick=" borra_combos_cli(this.selectedIndex);" onChange="select_combos_cli(this.selectedIndex);" class="Estilo8"></select></td>

			<td><select name="FECHACLI" size="3" id="FECHACLI"  ondblClick=" borra_combos_cli(this.selectedIndex);" onChange="select_combos_cli(this.selectedIndex);" class="Estilo8"></select></td>

			<td><select name="BANCOCLI" size="3" id="BANCOCLI"  ondblClick=" borra_combos_cli(this.selectedIndex);" onChange="select_combos_cli(this.selectedIndex);" class="Estilo8"></select></td>

			<td><select name="PLAZACLI" size="3" id="PLAZACLI"  ondblClick=" borra_combos_cli(this.selectedIndex);" onChange="select_combos_cli(this.selectedIndex);" class="Estilo8"></select></td>

			<td><select name="NROCHECLI" size="3" id="NROCHECLI"  ondblClick=" borra_combos_cli(this.selectedIndex);" onChange="select_combos_cli(this.selectedIndex);" class="Estilo8"></select></td>

			<td><select name="NRCTACTECLI" size="3" id="NRCTACTECLI"  ondblClick=" borra_combos_cli(this.selectedIndex);" onChange="select_combos_cli(this.selectedIndex);" class="Estilo8"></select></td>
			<td><input type="button" name="Submit" value="Guardar" onClick="envia('<%=perfil%>');" class="Estilo8"></td>
		</tr>
		<tr>
			<td>
			<INPUT TYPE="hidden" NAME="TXCLAVEDOC" id ="TXCLAVEDOC">
			<INPUT TYPE="hidden" NAME="TXPERIODO" id="TXPERIODO">
			<INPUT TYPE="hidden" NAME="TXCAPITAL" id="TXCAPITAL">
			<INPUT TYPE="hidden" NAME="TXREAJUSTE" id="TXREAJUSTE">
			<INPUT TYPE="hidden" NAME="TXINTERES" id="TXINTERES">
			<INPUT TYPE="hidden" NAME="TXGRAVAMENES" id="TXGRAVAMENES">
			<INPUT TYPE="hidden" NAME="TXMULTAS" id="TXMULTAS">
			<INPUT TYPE="hidden" NAME="TXCARGOS" id="TXCARGOS">
			<INPUT TYPE="hidden" NAME="TXCOSTAS" id="TXCOSTAS">
			<!-- <INPUT TYPE="hidden" NAME="TXOTROS" id="TXOTROS"> -->

			<INPUT TYPE="hidden" NAME="TXFPAGO" id="TXFPAGO">
			<INPUT TYPE="hidden" NAME="TXDESTINO" id="TXDESTINO">
			<INPUT TYPE="hidden" NAME="TXCUOTA" id="TXCUOTA">
			<INPUT TYPE="hidden" NAME="TXRUTCLI" id="TXRUTCLI">
			<INPUT TYPE="hidden" NAME="TXMONTOCLI" id="TXMONTOCLI">
			<INPUT TYPE="hidden" NAME="TXFECVENCLI" id="TXFECVENCLI">
			<INPUT TYPE="hidden" NAME="TXBANCOCLIENTE" id="TXBANCOCLIENTE">
			<INPUT TYPE="hidden" NAME="TXPLAZACLIENTE" id="TXPLAZACLIENTE">
			<INPUT TYPE="hidden" NAME="TXNROCHEQUECLI" id="TXNROCHEQUECLI">
			<INPUT TYPE="hidden" NAME="TXNROCTACTECLI" id="TXNROCTACTECLI">
			<%hoy=date%>
			<INPUT TYPE="hidden" NAME="TXFECHAACTUAL" id="TXFECHAACTUAL" value="<%=hoy%>">
			<INPUT TYPE="hidden" NAME="TXRUTCPS" id="TXRUTCPS">
			<INPUT TYPE="hidden" NAME="TXMONTOCPS" id="TXMONTOCPS">
			<INPUT TYPE="hidden" NAME="TXFECVENCPS" id="TXFECVENCPS">
			<INPUT TYPE="hidden" NAME="TXBANCOCPS" id="TXBANCOCPS">
			<INPUT TYPE="hidden" NAME="TXPLAZACPS" id="TXPLAZACPS">
			<INPUT TYPE="hidden" NAME="TXNROCHEQUECPS" id="TXNROCHEQUECPS">
			<INPUT TYPE="hidden" NAME="TXNROCTACTECPS" id="TXNROCTACTECPS">
			</td>
		</tr>
	</table>
</td>
</tr>

	<%'end if%>
	</td>
   </tr>
  </table>

</form>
<script language="JavaScript" type="text/JavaScript">
function validamonto(){
//alert("hola")
if ((datos.CB_CLIENTE.value=='DNP') && (datos.CB_TIPOPAGO.value=='CO')){
	if (datos.TX_MONTOCLIENTE.value < '5000'){
		alert("El monto cliente ingresado no es correcto")
		datos.TX_MONTOCLIENTE.value='';
		//datos.TX_MONTOCLIENTE.disabled=true;
		datos.TX_MONTOCLIENTE.focus();
		//datos.TX_MONTOCLIENTE.focus();
	}
}
}
function CopiaRep(){
	datos.RUT_CON.value = datos.RUT_REP.value
	datos.NOM_CON1.value = datos.NOM_REP1.value
	datos.NOM_CON2.value = datos.NOM_REP2.value
	datos.APELL_CON1.value = datos.APELL_REP1.value
	datos.APELL_CON2.value = datos.APELL_REP2.value
	datos.SEXO_CON.selectedIndex = datos.SEXO_REP.selectedIndex
	datos.FECHANAC_CON.value = datos.FECHANAC_REP.value
	datos.ESTADOCIVIL_CON.selectedIndex = datos.ESTADOCIVIL_REP.selectedIndex
	datos.codarea_CON.selectedIndex = datos.codarea_REP.selectedIndex
	datos.fono_CON.value = datos.fono_REP.value
	datos.CALLE_CON.value = datos.CALLE_REP.value
	datos.NUMERO_CON.value = datos.NUMERO_REP.value
	datos.NUMERODEPTO_CON.value = datos.NUMERODEPTO_REP.value
	datos.NUMEROPISO_CON.value = datos.NUMEROPISO_REP.value
	datos.VILLA_CON.value = datos.VILLA_REP.value
	datos.CIUDAD_CON.selectedIndex = datos.CIUDAD_REP.selectedIndex
	datos.COMUNA_CON.selectedIndex = datos.COMUNA_REP.selectedIndex
}

/////////////----------------/////////////////----------------//////////////////////
function JuntaDetalle(){

	datos.TXCLAVEDOC.value=""
	datos.TXPERIODO.value=""
	datos.TXCAPITAL.value	=""
	datos.TXCUOTA.value = ""
	datos.TXREAJUSTE.value=""
	datos.TXINTERES.value=""
	datos.TXGRAVAMENES.value=""
	datos.TXMULTAS.value=""
	datos.TXCARGOS.value=""
	datos.TXCOSTAS.value=""
	//datos.TXOTROS.value=""
	for (var e=0; e<datos.CLAVEDOC.options.length;e++){
		if (e!=0) {
		//poner la coma
			datos.TXCLAVEDOC.value=datos.TXCLAVEDOC.value+"*"	;
			datos.TXPERIODO.value=datos.TXPERIODO.value+"*";
			datos.TXCUOTA.value=datos.TXCUOTA.value+"*";
			datos.TXCAPITAL.value	=datos.TXCAPITAL.value+"*";
			datos.TXREAJUSTE.value=datos.TXREAJUSTE.value+"*";
			datos.TXINTERES.value=datos.TXINTERES.value+"*";
			datos.TXGRAVAMENES.value=datos.TXGRAVAMENES.value+"*";
			datos.TXMULTAS.value=datos.TXMULTAS.value+"*";
			datos.TXCARGOS.value=datos.TXCARGOS.value+"*";
			datos.TXCOSTAS.value=datos.TXCOSTAS.value+"*";
			//datos.TXOTROS.value=datos.TXOTROS.value+"*";
		}
		//concatenar
		datos.TXCLAVEDOC.value=datos.TXCLAVEDOC.value+datos.CLAVEDOC.options[e].value;
		datos.TXPERIODO.value=datos.TXPERIODO.value+datos.PERIODO.options[e].value;
		datos.TXCUOTA.value=datos.TXCUOTA.value+datos.CUOTA.options[e].value;
		datos.TXCAPITAL.value=datos.TXCAPITAL.value+datos.CAPITAL.options[e].value;
		datos.TXREAJUSTE.value=datos.TXREAJUSTE.value+datos.REAJUSTE.options[e].value;
		datos.TXINTERES.value=datos.TXINTERES.value+datos.INTERES.options[e].value;
		datos.TXGRAVAMENES.value=datos.TXGRAVAMENES.value+datos.GRAVAMENES.options[e].value;
		datos.TXMULTAS.value=datos.TXMULTAS.value+datos.MULTAS.options[e].value;
		datos.TXCARGOS.value=datos.TXCARGOS.value+datos.CARGOS.options[e].value;
		datos.TXCOSTAS.value=datos.TXCOSTAS.value+datos.COSTAS.options[e].value;
		//datos.TXOTROS.value=datos.TXOTROS.value+datos.OTROS.options[e].value;
	}
}

function JuntaDetalleCliente(){
	datos.TXDESTINO.value = ""
	datos.TXFPAGO.value = ""

	datos.TXRUTCLI.value=""
	datos.TXMONTOCLI.value=""
	datos.TXFECVENCLI.value	=""
	datos.TXBANCOCLIENTE.value=""
	datos.TXPLAZACLIENTE.value=""
	datos.TXNROCHEQUECLI.value=""
	datos.TXNROCTACTECLI.value=""
	for (var e=0; e<datos.DESTINO.options.length;e++){
		if (e!=0) {
		//poner la coma
			datos.TXDESTINO.value=datos.TXDESTINO.value+"*";
			datos.TXFPAGO.value=datos.TXFPAGO.value+"*";

			datos.TXRUTCLI.value=datos.TXRUTCLI.value+"*"	;
			datos.TXMONTOCLI.value=datos.TXMONTOCLI.value+"*";
			datos.TXFECVENCLI.value	=datos.TXFECVENCLI.value+"*";
			datos.TXBANCOCLIENTE.value=datos.TXBANCOCLIENTE.value+"*";
			datos.TXPLAZACLIENTE.value=datos.TXPLAZACLIENTE.value+"*";
			datos.TXNROCHEQUECLI.value=datos.TXNROCHEQUECLI.value+"*";
			datos.TXNROCTACTECLI.value=datos.TXNROCTACTECLI.value+"*";
		}
		//concatenar
		datos.TXDESTINO.value=datos.TXDESTINO.value+datos.DESTINO.options[e].value;
		datos.TXFPAGO.value=datos.TXFPAGO.value+datos.FPAGO.options[e].value;
		datos.TXRUTCLI.value=datos.TXRUTCLI.value+datos.RUTCLI.options[e].value;
		datos.TXMONTOCLI.value=datos.TXMONTOCLI.value+datos.MONTOCLI.options[e].value;
		datos.TXFECVENCLI.value=datos.TXFECVENCLI.value+datos.FECHACLI.options[e].value;
		datos.TXBANCOCLIENTE.value=datos.TXBANCOCLIENTE.value+datos.BANCOCLI.options[e].value;
		datos.TXPLAZACLIENTE.value=datos.TXPLAZACLIENTE.value+datos.PLAZACLI.options[e].value;
		datos.TXNROCHEQUECLI.value=datos.TXNROCHEQUECLI.value+datos.NROCHECLI.options[e].value;
		datos.TXNROCTACTECLI.value=datos.TXNROCTACTECLI.value+datos.NRCTACTECLI.options[e].value;
	}
}

function FormaPago(){
	if ((datos.CB_FPAGO.value=='EF')||(datos.CB_FPAGO.value=='DP')){
		datos.inicio.value=''
		datos.TX_RUTCLI.disabled = true;
		datos.inicio.disabled = true;
		datos.CB_BANCO_CLIENTE.disabled = true;
		datos.CB_PLAZA_CLIENTE.disabled = true;
		datos.TX_NROCHEQUECLI.disabled = true;
		datos.TX_NROCTACTECLI.disabled = true;
	}else{
		datos.TX_RUTCLI.disabled = false;
		datos.inicio.disabled = false;
		datos.CB_BANCO_CLIENTE.disabled = false;
		datos.CB_PLAZA_CLIENTE.disabled = false;
		datos.TX_NROCHEQUECLI.disabled = false;
		datos.TX_NROCTACTECLI.disabled = false;
		if (datos.CB_FPAGO.value=='CD'){
			datos.inicio.value=datos.TXFECHAACTUAL.value
		}else{
			datos.inicio.value=''
		}
	}
}


function MetePrimerFono(){
//alert(datos.codarea_CLI.value);
	for (var e=0; e<=datos.area.options.length-1;e++){
		//alert(datos.codarea_CLI.value + "**" + datos.area.options[e].value);
		if (datos.codarea_CLI.value==datos.area.options[e].value){
			datos.area.selectedIndex=e;

		}
	}
	datos.numero.value=datos.fono_cli.value
	meteplan();
}

function revisa_fonos_repetidos(){

		for (var e=0; e<= datos.spais.options.length-1; e++) {
			//alert(Trim(datos.spais.options[e].text) + Trim(datos.sarea.options[e].text) + Trim(datos.snumero.options[e].text));
			//alert(Trim(datos.pais.value) + Trim(datos.area.value) + Trim(datos.numero.value));
			if(Trim(datos.spais.options[e].text) + Trim(datos.sarea.options[e].text) + Trim(datos.snumero.options[e].text) ==Trim(datos.pais.value) + Trim(datos.area.value) + Trim(datos.numero.value)){
				return(true);
			}
			//combo.options[e].value=combo.options[e+1].value;
		}
		return(false)
		//combo.options[combo.options.length-1]=null;

}


function solonumero(valor){
     //Compruebo si es un valor numérico

 if (valor.value.length >0){
      if (isNaN(valor.value)) {
            //entonces (no es numero) devuelvo el valor cadena vacia
            valor.value="";
			//alert(valor.value)
			//valor.focus();
			return ""
      }else{
            //En caso contrario (Si era un número) devuelvo el valor
			valor.value
			return valor.value
      }
	  }
}

function borra_combos_cli(indice){
	borra_opcion(datos.DESTINO,indice);
	borra_opcion(datos.FPAGO,indice);

	borra_opcion(datos.RUTCLI,indice);
	borra_opcion(datos.MONTOCLI,indice);
	borra_opcion(datos.FECHACLI,indice);
	borra_opcion(datos.BANCOCLI,indice);
	borra_opcion(datos.PLAZACLI,indice);
	borra_opcion(datos.NROCHECLI,indice);
	borra_opcion(datos.NRCTACTECLI,indice);

}

function borra_combos(indice){
	borra_opcion(datos.CLAVEDOC,indice);
	borra_opcion(datos.PERIODO,indice);
	borra_opcion(datos.CUOTA,indice);
	resta_capital(datos.CAPITAL.value);
	borra_opcion(datos.CAPITAL,indice);

	resta_capital(datos.REAJUSTE.value);
	borra_opcion(datos.REAJUSTE,indice);

	resta_capital(datos.INTERES.value);
	borra_opcion(datos.INTERES,indice);

	resta_capital(datos.GRAVAMENES.value);
	borra_opcion(datos.GRAVAMENES,indice);

	resta_capital(datos.MULTAS.value);
	borra_opcion(datos.MULTAS,indice);

	resta_capital(datos.CARGOS.value);
	borra_opcion(datos.CARGOS,indice);

	resta_capital(datos.COSTAS.value);
	borra_opcion(datos.COSTAS,indice);

	//resta_capital(datos.OTROS.value);
	//borra_opcion(datos.OTROS,indice);

}


function resta_capital(valor){
	datos.TX_MONTOCLIENTE.disabled = false;
	datos.TX_TOTAL.disabled = false;
	if (valor==''){
		valor=0;
	}
	datos.TX_MONTOCLIENTE.value = eval(datos.TX_MONTOCLIENTE.value) - eval(valor);
	datos.TX_TOTALCLIENTE.value = (eval(datos.TX_MONTOCLIENTE.value) + eval(datos.TX_IPCLIENTE.value)) - eval(datos.TX_DESCLIENTE.value)
	if (datos.TX_DESCUENTO.value == ""){
		datos.TX_DESCUENTO.value = 0;
	}
	if (datos.TX_MONTOCPS.value == ""){
		datos.TX_MONTOCPS.value = 0;
	}
	datos.TX_TOTALCPS.value = ((eval(datos.TX_MONTOCPS.value) + eval(datos.TX_CCPS.value)) - eval(datos.TX_DESCUENTO.value))
	datos.TX_TOTAL.value = (eval(datos.TX_TOTALCLIENTE.value) + eval(datos.TX_TOTALCPS.value));
	datos.TX_MONTOCLIENTE.disabled = true;
	datos.TX_TOTAL.disabled = true;
	datos.TX_CLAVEDOC.focus();
}


function borra_opcion(combo,indice){
	if (combo.options.length>0){
	//	combo.options[indice]=null;
		for (var e=indice; e< combo.options.length-1; e++) {
			//alert(e);
			combo.options[e].text=combo.options[e+1].text;
			combo.options[e].value=combo.options[e+1].value;
		}
		combo.options[combo.options.length-1]=null;
	}
}

function select_combos_cli(indice){
	datos.DESTINO.selectedIndex=indice;
	datos.FPAGO.selectedIndex=indice;

	datos.RUTCLI.selectedIndex=indice;
	datos.MONTOCLI.selectedIndex=indice;
	datos.FECHACLI.selectedIndex=indice;
	datos.BANCOCLI.selectedIndex=indice;
	datos.PLAZACLI.selectedIndex=indice;
	datos.NROCHECLI.selectedIndex=indice;
	datos.NRCTACTECLI.selectedIndex=indice;
}

function select_combos(indice){
	datos.CLAVEDOC.selectedIndex=indice;
	datos.PERIODO.selectedIndex=indice;
	datos.CUOTA.selectedIndex=indice;
	datos.CAPITAL.selectedIndex=indice;
	datos.REAJUSTE.selectedIndex=indice;
	datos.INTERES.selectedIndex=indice;
	datos.GRAVAMENES.selectedIndex=indice;
	datos.MULTAS.selectedIndex=indice;
	datos.CARGOS.selectedIndex=indice;
	datos.COSTAS.selectedIndex=indice;
	//datos.OTROS.selectedIndex=indice;


}
//-------------------------------
function asigna_minimo(campo){
	if (campo.value!=0)	{
		if(campo.value.length==1){
			minimo1=8;
		}else if(campo.value==41 || campo.value==32){
			minimo1=7;
		}else {
			minimo1=6;
		}
	}else{minimo1=0}
	return(minimo1)
}



function valida_largo(campo, minimo){
//alert(datos.fono_aportado_area.value)
	//if (datos.fono_aportado_area.value!="0"){
		if(campo.value.length != minimo) {
			alert("Fono debe tener " + minimo + " digitos");
			campo.select();
			campo.focus();
			return(false);
		}
	//}
	return(true);
}

function metedoccli(){
	if (datos.CB_DESTINO.value==''){
		alert("Debe seleccionar el destino del pago");
		datos.CB_DESTINO.focus();
	}else if (datos.CB_FPAGO.value==''){
		alert("Debe seleccionar la forma de pago");
		datos.CB_FPAGO.focus();
	}else if(((datos.CB_FPAGO.value=='CD')||(datos.CB_FPAGO.value=='CF'))&&((datos.TX_RUTCLI.value==''))){
		alert("Debe ingresar el Rut")
		datos.TX_RUTCLI.focus();
	}else if(datos.CB_FPAGO.value=='DP' && datos.CB_DESTINO.value=='0' && datos.TX_NRODEPCLIENTE.value==''){
		alert("Debe ingresar el número del deposito del Cliente")
		datos.TX_NRODEPCLIENTE.focus();
	}else if(datos.CB_FPAGO.value=='DP' && datos.CB_DESTINO.value=='0' && datos.TX_NRODEPCLIENTE.value!='' && datos.CB_BCLIENTE.value==''){
		alert("Debe seleccionar el banco al que pertenece el deposito del Cliente")
		datos.CB_BCLIENTE.focus();
	}else if(datos.CB_FPAGO.value=='DP' && datos.CB_DESTINO.value=='1' && datos.TX_NRODEPCPS.value!='' && datos.CB_BCPS.value==''){
		alert("Debe seleccionar el banco al que pertenece el deposito de Intercapital")
		datos.CB_BCPS.focus();
	}else if (datos.TX_MONTOCLI.value==''){
		alert("Debe ingresar el Monto")
		datos.TX_MONTOCLI.focus();
	}else if(((datos.CB_FPAGO.value=='CD')||(datos.CB_FPAGO.value=='CF'))&&((datos.inicio.value==''))){
		alert("Debe ingresar la fecha de vencimiento")
		datos.inicio.focus();
	}else if(((datos.CB_FPAGO.value=='CD')||(datos.CB_FPAGO.value=='CF'))&&((datos.CB_BANCO_CLIENTE.value==''))){
		alert("Debe ingresar el Banco al que pretenece el cheque")
		datos.CB_BANCO_CLIENTE.focus();
	}else if(((datos.CB_FPAGO.value=='CD')||(datos.CB_FPAGO.value=='CF'))&&((datos.CB_PLAZA_CLIENTE.value==''))){
		alert("Debe ingresar la plaza")
		datos.CB_PLAZA_CLIENTE.focus();
	}else if(((datos.CB_FPAGO.value=='CD')||(datos.CB_FPAGO.value=='CF'))&&((datos.TX_NROCHEQUECLI.value==''))){
		alert("Debe ingresar el número del cheque")
		datos.TX_NROCHEQUECLI.focus();
	}else if(((datos.CB_FPAGO.value=='CD')||(datos.CB_FPAGO.value=='CF'))&&((datos.TX_NROCTACTECLI.value==''))){
		alert("Debe ingresar el número de la cuenta corriente")
		datos.TX_NROCTACTECLI.focus();
	}else{

		datos.TX_RUTCLI.disabled = false;
		datos.TX_MONTOCLI.disabled = false;
		datos.inicio.disabled = false;
		datos.CB_BANCO_CLIENTE.disabled = false;
		datos.CB_PLAZA_CLIENTE.disabled = false;
		datos.TX_NROCHEQUECLI.disabled = false;
		datos.TX_NROCTACTECLI.disabled = false;
		apilar_combo_combo(datos.CB_DESTINO, datos.DESTINO);
		apilar_combo_combo(datos.CB_FPAGO, datos.FPAGO);
		apilar_textbox_combo(datos.TX_RUTCLI, datos.RUTCLI);
		apilar_textbox_combo(datos.TX_MONTOCLI, datos.MONTOCLI);
		apilar_textbox_combo(datos.inicio, datos.FECHACLI);
		apilar_combo_combo(datos.CB_BANCO_CLIENTE, datos.BANCOCLI);
		apilar_combo_combo(datos.CB_PLAZA_CLIENTE, datos.PLAZACLI);
		apilar_textbox_combo(datos.TX_NROCHEQUECLI, datos.NROCHECLI);
		apilar_textbox_combo(datos.TX_NROCTACTECLI, datos.NRCTACTECLI);
		datos.CB_DESTINO.value="";
		datos.CB_FPAGO.value="";
		datos.TX_RUTCLI.value="";
		datos.TX_MONTOCLI.value="";
		datos.inicio.value="";
		datos.CB_BANCO_CLIENTE.value="";
		datos.CB_PLAZA_CLIENTE.value="";
		datos.TX_NROCHEQUECLI.value="";
		datos.TX_NROCTACTECLI.value="";
		datos.CB_DESTINO.focus();
	}
}

function revisaclaveperiodo(){
	//var ok=false;
	i=datos.CLAVEDOC.length;
	//valor=datos.CLAVEDOC.options[i].value
	//alert(i)
	for (var e=0; e<i;e++){

		//alert(datos.PERIODO.options[e].value);
		//alert(datos.CLAVEDOC.options[i].value)
		if (e!=0){
			if(((datos.CLAVEDOC.options[e].value) == (datos.TX_CLAVEDOC.value))){
				valor = datos.TX_MES.value + " " + datos.TX_ANO.value
				//alert(valor)
				//alert(datos.PERIODO.options[e].value)
				if ((datos.PERIODO.options[e].value)==valor){
				alert("Ha ingresado Una clave duplicada para el mismo periodo")
				//borra_combos(.selectedIndex)
				borra_opcion(datos.CLAVEDOC,i);
				borra_opcion(datos.PERIODO,i);
				resta_capital(datos.CAPITAL.value);
				borra_opcion(datos.CAPITAL,i);

				resta_capital(datos.REAJUSTE.value);
				borra_opcion(datos.REAJUSTE,i);

				resta_capital(datos.INTERES.value);
				borra_opcion(datos.INTERES,i);

				resta_capital(datos.GRAVAMENES.value);
				borra_opcion(datos.GRAVAMENES,i);

				resta_capital(datos.MULTAS.value);
				borra_opcion(datos.MULTAS,i);

				resta_capital(datos.CARGOS.value);
				borra_opcion(datos.CARGOS,i);

				resta_capital(datos.COSTAS.value);
				borra_opcion(datos.COSTAS,i);

				//resta_capital(datos.OTROS.value);
				//borra_opcion(datos.OTROS,i);
				datos.TX_CLAVEDOC.value="";
				datos.TX_MES.value="";
				datos.TX_ANO.value="";
				datos.TX_CAPITAL.value="";
				datos.TX_REAJUSTE.value="";
				datos.TX_INTERES.value="";
				datos.TX_GRAVAMENES.value="";
				datos.TX_MULTAS.value="";
				datos.TX_CARGOS.value="";
				datos.TX_COSTAS.value="";
				//datos.TX_OTROS.value="";
				datos.TX_CLAVEDOC.focus();
				}

			}
	//valor=datos.TX_MES.selectedIndex;
	//valor2=datos.TX_ANO.selectedIndex;
	//if ((valor>=0)&&(valor2)){
	//	texto1=datos.TX_MES.options[valor].text;
	//	texto2=datos.TX_ANO.options[valor2].text;
	//	texto = texto1 + " " + texto2
	//	val1 = datos.TX_MES.options[valor].value;
	//	val2 = datos.TX_ANO.options[valor].value
	//	val = val1 + " " + val2
	//	if (texto==''){
	//		texto='';
	//		val=0;
	}
	//		var el = new Option(texto,val);
	//		datos.PERIODO.options[i] = el;
	}
}

function meteplan(){
	 if (datos.CB_CLIENTE.value=='0'){
		alert("Debe seleccionar el cliente")
	 }else{
		if (datos.TX_CLAVEDOC.value=='' && datos.CB_TIPOPAGO.value!='CT' && datos.CB_TIPOPAGO.value!='CO'){
			alert("Debe ingresar el número de clave o documento")
			datos.TX_CLAVEDOC.focus();
		}else if((datos.CB_CUOTA.value=='CD')&&(datos.CB_TIPOPAGO.value=='CT')){
			alert("Debe seleccionar el número de cuotas")
			datos.CB_CUOTA.focus();
		}else if ((datos.CB_CLIENTE.value=='DNP')&&(datos.CB_TIPOPAGO.value!='CT') && (datos.CB_TIPOPAGO.value!='CO')){
			if ((datos.TX_MES.value=='')||(datos.TX_ANO.value=='')){
				alert("Debe ingresar el periodo")
				datos.TX_ANO.focus();
			}else if (datos.TX_CAPITAL.value==''){
				alert("Debe ingresar el monto capital")
				datos.TX_CAPITAL.focus();
			}else{
			apilar_textbox_combo(datos.TX_CLAVEDOC, datos.CLAVEDOC);
			apila_periodo()
			if (datos.CB_CUOTA.disabled==true){
				datos.CB_CUOTA.disabled==false;
			}
			//apilar_textbox_combo(datos.TX_PERIODO, datos.PERIODO);
			apilar_combo_combo(datos.CB_CUOTA, datos.CUOTA);
			apilar_textbox_combo(datos.TX_CAPITAL, datos.CAPITAL);
			apilar_textbox_combo(datos.TX_REAJUSTE, datos.REAJUSTE);
			apilar_textbox_combo(datos.TX_INTERES, datos.INTERES);
			apilar_textbox_combo(datos.TX_GRAVAMENES, datos.GRAVAMENES);
			apilar_textbox_combo(datos.TX_MULTAS, datos.MULTAS);
			apilar_textbox_combo(datos.TX_CARGOS, datos.CARGOS);
			apilar_textbox_combo(datos.TX_COSTAS, datos.COSTAS);
			//apilar_textbox_combo(datos.TX_OTROS, datos.OTROS);
			montocliente();
			//limpiar textos
			datos.TX_CLAVEDOC.value="";
			datos.TX_MES.value="";
			datos.TX_ANO.value="";
			datos.CB_CUOTA.value='0';
			datos.TX_CAPITAL.value="";
			datos.TX_REAJUSTE.value="";
			datos.TX_INTERES.value="";
			datos.TX_GRAVAMENES.value="";
			datos.TX_MULTAS.value="";
			datos.TX_CARGOS.value="";
			datos.TX_COSTAS.value="";
			//datos.TX_OTROS.value="";
			datos.TX_CLAVEDOC.focus();
			revisaclaveperiodo();
			}
		}else if (datos.TX_CAPITAL.value==''){
			alert("Debe ingresar el monto capital")
			datos.TX_CAPITAL.focus();
		}else{
			if (datos.CB_CLIENTE.value!='DNP'){
			datos.TX_MES.value="";
			datos.TX_ANO.value="";
			}
			apilar_textbox_combo(datos.TX_CLAVEDOC, datos.CLAVEDOC);
			apila_periodo()
			//apilar_textbox_combo(datos.TX_PERIODO, datos.PERIODO);
			if (datos.CB_CUOTA.disabled==true){
				datos.CB_CUOTA.disabled==false;
			}
			apilar_combo_combo(datos.CB_CUOTA, datos.CUOTA);
			apilar_textbox_combo(datos.TX_CAPITAL, datos.CAPITAL);
			apilar_textbox_combo(datos.TX_REAJUSTE, datos.REAJUSTE);
			apilar_textbox_combo(datos.TX_INTERES, datos.INTERES);
			apilar_textbox_combo(datos.TX_GRAVAMENES, datos.GRAVAMENES);
			apilar_textbox_combo(datos.TX_MULTAS, datos.MULTAS);
			apilar_textbox_combo(datos.TX_CARGOS, datos.CARGOS);
			apilar_textbox_combo(datos.TX_COSTAS, datos.COSTAS);
			//apilar_textbox_combo(datos.TX_OTROS, datos.OTROS);
			montocliente();
			//limpiar textos
			datos.TX_CLAVEDOC.value="";
			datos.TX_MES.value="";
			datos.TX_ANO.value="";
			datos.CB_CUOTA.value='0';
			datos.TX_CAPITAL.value="";
			datos.TX_REAJUSTE.value="";
			datos.TX_INTERES.value="";
			datos.TX_GRAVAMENES.value="";
			datos.TX_MULTAS.value="";
			datos.TX_CARGOS.value="";
			datos.TX_COSTAS.value="";
			//datos.TX_OTROS.value="";
			datos.TX_CLAVEDOC.focus();
		}

	}
}

function tipopago(){
	if (datos.CB_TIPOPAGO.value=='CO'){

		if (datos.CB_CLIENTE.value=='CPSBR' || datos.CB_CLIENTE.value=='CPSIS' || datos.CB_CLIENTE.value=='CPSJU' || datos.CB_CLIENTE.value=='CPSMC' || datos.CB_CLIENTE.value=='CPSPR' || datos.CB_CLIENTE.value=='DNP' ){
			datos.TX_MONTOCLIENTE.disabled=false
		}else{
			datos.CB_TIPOPAGO.value=''
			alert("Para ese cliente no se puede ingresar un convenio")
		}
	}
	if (datos.CB_TIPOPAGO.value=='CT'){
		datos.CB_CUOTA.disabled=false
		datos.TX_MONTOCLIENTE.disabled=true
	}
	if (datos.CB_TIPOPAGO.value!='CT'){
		datos.CB_CUOTA.disabled=true
	}
	if (datos.CB_TIPOPAGO.value!='CO'){
		datos.TX_MONTOCLIENTE.disabled=true
	}
}

function apila_periodo(){
	var ok=false;
	i=datos.PERIODO.length;
	valor=datos.TX_MES.selectedIndex;
	valor2=datos.TX_ANO.selectedIndex;
	if ((valor>=0)&&(valor2>=0)){
		texto1=datos.TX_MES.options[valor].text;
		texto2=datos.TX_ANO.options[valor2].text;
		texto = texto2 + texto1
		val1 = datos.TX_MES.options[valor].value;
		val2 = datos.TX_ANO.options[valor2].value
		val = val2 + val1
		//alert(texto)
		//alert(val)
		if (texto==''){
			texto='';
			val=0;
		}
			var el = new Option(texto,val);
			datos.PERIODO.options[i] = el;
	}
}

function montocliente(){
	datos.TX_MONTOCLIENTE.disabled = false;
	datos.TX_TOTALCPS.disabled = false;
	datos.TX_TOTALCLIENTE.disabled = false;
	datos.TX_TOTAL.disabled = false;
	if (datos.TX_MONTOCLIENTE.value == ""){
		datos.TX_MONTOCLIENTE.value = 0
	}
	if (datos.TX_MONTOCPS.value == ""){
		datos.TX_MONTOCPS.value = 0
	}
	if (datos.TX_CAPITAL.value == ""){
		datos.TX_CAPITAL.value = 0
	}
	if (datos.TX_REAJUSTE.value == ""){
		datos.TX_REAJUSTE.value = 0
	}
	if (datos.TX_INTERES.value == ""){
		datos.TX_INTERES.value = 0
	}
	if (datos.TX_GRAVAMENES.value == ""){
		datos.TX_GRAVAMENES.value = 0
	}
	if (datos.TX_MULTAS.value == ""){
		datos.TX_MULTAS.value = 0
	}
	if (datos.TX_CARGOS.value == ""){
		datos.TX_CARGOS.value = 0
	}
	if (datos.TX_COSTAS.value == ""){
		datos.TX_COSTAS.value = 0
	}
	//if (datos.TX_OTROS.value == ""){
	//	datos.TX_OTROS.value = 0
	//}

	if (datos.TX_DESCLIENTE.value == ""){
		datos.TX_DESCLIENTE.value = 0
	}
	capital = eval(datos.TX_CAPITAL.value) + eval(datos.TX_REAJUSTE.value) + eval(datos.TX_INTERES.value) + eval(datos.TX_GRAVAMENES.value) + eval(datos.TX_MULTAS.value) + eval(datos.TX_CARGOS.value)+ eval(datos.TX_COSTAS.value) + eval(datos.TX_MONTOCLIENTE.value);

	datos.TX_MONTOCLIENTE.value = eval(capital);

	if (datos.TX_DESCUENTO.value == ""){
		datos.TX_DESCUENTO.value = 0
	}
	if (datos.TX_IPCLIENTE.value == ""){
		datos.TX_IPCLIENTE.value = 0
	}
	if (datos.TX_CCPS.value == ""){
		datos.TX_CCPS.value = 0
	}

	totalcliente = (eval(capital)+ eval(datos.TX_IPCLIENTE.value) - eval(datos.TX_DESCLIENTE.value))
	totalcps = ((eval(datos.TX_MONTOCPS.value) + eval(datos.TX_CCPS.value)) - eval(datos.TX_DESCUENTO.value))
	total = (eval(totalcliente) + eval(totalcps));
	datos.TX_TOTAL.value = eval(total);
	datos.TX_TOTALCLIENTE.value = eval(totalcliente);
	datos.TX_TOTALCPS.value=eval(totalcps);
	datos.TX_MONTOCLIENTE.disabled = true;
	datos.TX_TOTALCPS.disabled = true;
	datos.TX_TOTALCLIENTE.disabled = true;
	datos.TX_TOTAL.disabled = true;
	datos.TX_CAPITAL.value = "";
	datos.TX_REAJUSTE.value = "";
	datos.TX_INTERES.value = "";
	datos.TX_GRAVAMENES.value = "";
	datos.TX_MULTAS.value = "";
	datos.TX_CARGOS.value = "";
	datos.TX_COSTAS.value = "";
	//datos.TX_OTROS.value = "";
	//datos.TX_MONTOCLIENTE.disabled = true;
	//datos.TX_TOTAL.disabled = true;
}


function apilar_textbox_combo(origen, destino){
//addNew(document.myForm.proceso.options[document.myForm.proceso.selectedIndex].value)
	// Add a new option.
	var ok=false;
	i=destino.length;
	//valor = datos.txt_clavedoc.value.length;
	//alert(valor);
	valor=origen.value.length ;
	valor2=origen.value;
	if (valor>=0){
		texto=origen.value;
		if (texto==''){
		texto='';
		valor2 = '';
		//valor=0;
		}
//		for (var e=0; e< i; e++) {
//			if (texto==destino.options[e].text){
//				ok=true;
//				break;
//			}else
//				ok=false;
//			}
//		if (!ok){
//			//var el = new Option(texto,value);

//		}
	}else{
	texto='';
	valor2='';
	}
	var el = new Option(texto,valor2);
			destino.options[i] = el;
		//alert("ingrese un valor para agregar.");
}
//------------------------------------------------------------------
function apilar_combo_combo(origen, destino){
//addNew(document.myForm.proceso.options[document.myForm.proceso.selectedIndex].value)
	// Add a new option.
	var ok=false;
	i=destino.length;
	valor=origen.selectedIndex ;
	valor2=origen.options[valor].value;
	if (valor>=0){
		texto=origen.options[valor].text;
		if (texto=='SELECCIONAR' || texto=='0'){
			texto='';
			valor2='';
		}
//		for (var e=0; e< i; e++) {
//			if (texto==destino.options[e].text){
//				ok=true;
//				break;
//			}else
//				ok=false;
//			}
//		if (!ok){
			//var el = new Option(texto,value);

//		}
	}else{
	texto='';
	valor2='';
	}
	var el = new Option(texto,valor2);
	destino.options[i] = el;
		//alert("Seleccione un valor para agregar.");
}
//////--------------------------------------------------------------------
function disa(){
		datos.TX_MONTOCLIENTE.disabled = true;
		datos.TX_TOTAL.disabled = true;
		datos.TX_TOTALCLIENTE.disabled = true;
		datos.TX_TOTALCPS.disabled = true;
}
function envia(perfilusuario){
	datos.TX_MONTOCLIENTE.disabled = false
	datos.TX_TOTAL.disabled = false;
	datos.TX_TOTALCLIENTE.disabled = false;
	datos.TX_TOTALCPS.disabled = false;

	if(datos.TX_RUT.value==''){
		alert("Debe ingresar el rut")
		disa();
		datos.TX_RUT.focus();
	}else if (datos.txt_calle.value==''){
		alert("Debe ingresar una dirección");
		disa();
		datos.txt_calle.focus();
	}else if(datos.txt_numero.value==''){
		alert("Debe ingresar la numeración de la calle");
		disa();
		datos.txt_numero.focus();
	}else if(datos.cmb_comuna.value==''){
		alert("Debe seleccionar una comuna");
		disa();
		datos.cmb_comuna.focus();
	}else if((datos.cmb_area1.value=='')||(datos.txt_fono1.value=='')){
		alert("Debe ingresar un Telefono");
		disa();
		datos.cmb_comuna.focus();
	}else if (perfilusuario=='caja_modif' && datos.cmb_sucursal.value==''){
		alert("Debe seleccionar la sucursal que corresponde")
	}else if(datos.CB_CLIENTE.value == '0'){
		alert("Debe seleccionar el Cliente");
		disa();
	}else if ((datos.CB_CLIENTE.value == 'DNP') && (datos.TX_NROLIQUIDACION.value=='')&&(datos.CB_TIPOPAGO.value!='CT')){
		alert("Debe ingresar el Número de Liquidación");
		disa();
	}else if (datos.TX_COMPINGRESO.value == ''){
		alert("Debe ingresar el Número del Comprobante de Pago");
		disa();
	}else if (datos.TX_BOLETA.value == '' && datos.CB_TIPOPAGO.value!='CT' && (datos.CB_CLIENTE.value=='DNP')){
		alert("Debe ingresar Número de Boleta");
		disa();
	}else if (datos.CB_TIPOPAGO.value == ''){
		alert("Debe seleccionar el Tipo de Pago");
		disa();
	}else if (datos.CB_TIPOPAGO.value == 'CO' && datos.TX_TOTALCLIENTE.value=='' && datos.TX_TOTALCPS.value=='' && datos.TX_TOTALCLIENTE.value=='0' && datos.TX_TOTALCPS.value=='0'){
		alert("En un Convenio debe ingresar montos para el Cliente y para Intercapital");
		disa();

	}else{
		i=datos.DESTINO.length;
		montcli=0
		montcps=0
		cli=0
		cps=0
		for (var e=0; e<i;e++){
			if(datos.DESTINO.options[e].value=='0'){
				//cli=1
				montcli= eval(montcli) + eval(datos.MONTOCLI.options[e].value);
			}else{
				//CPS=1
				montcps = eval(montcps) + eval(datos.MONTOCLI.options[e].value);
			}
		}
		//if (datos.CB_TIPOPAGO.value == 'CO' && cli == 0 && cps == 0){
			//alert("En un convenio debe ingresar valores para el Cliente y para Intercapital")
		//}else{
			if (eval(datos.TX_TOTALCLIENTE.value) != eval(montcli) || eval(datos.TX_TOTALCPS.value)!= eval(montcps)){
				alert("Los montos ingresados en el detalle de documentos no son correctos");
				disa();
			}else if (datos.TX_NRODEPCLIENTE.value!= "" && datos.TX_NRODEPCPS.value!="" && datos.CB_BCLIENTE.value!="" && datos.CB_BCPS.value!="" && datos.TX_NRODEPCLIENTE.value==datos.TX_NRODEPCPS.value && datos.CB_BCLIENTE.value==datos.CB_BCPS.value){
				alert("Ingreso dos números de deposito iguales");
				disa();
				datos.TX_NRODEPCLIENTE.value="";
				datos.TX_NRODEPCPS.value="";
				datos.CB_BCLIENTE.value="";
				datos.CB_BCPS.value="";
			}else{
				JuntaDetalleCliente();
				JuntaDetalle();
				datos.action='grabacaja.asp';
				datos.submit();
			}
		//}
	}
}

function ventanaSecundaria (URL){
window.open(URL,"INFORMACION","width=800, height=400, scrollbars=yes, menubar=no, location=no, resizable=yes")
}


function ventanaDetalle (URL){
window.open(URL,"DETALLEGESTION","width=800, height=300, scrollbars=yes, menubar=no, location=no, resizable=yes")
}
function ventanaDetalleTelefonicas (URL){
window.open(URL,"DETALLEGESTION","width=800, height=300, scrollbars=yes, menubar=no, location=no, resizable=yes")
}

function ventanaIngresoG (URL){
window.open(URL,"INFORMACION","width=800, height=400, scrollbars=yes, menubar=no, location=no, resizable=yes")
}

function ventanaMisGestiones (URL){
window.open(URL,"MISGESTIONES","width=800, height=400, scrollbars=yes, menubar=no, location=no, resizable=no")
}

function chkFecha(f) {
  str = f.value
  if (str.length<10){
  	alert("Error - Ingresó una fecha no válida");
  	f.value=''
	f.focus();
  //	f.select();
  }else{
	if ( !formatoFecha(str) ) {
		alert("Debe indicar la Fecha en formato DD/MM/AAAA. Ejemplo: 'Para 20 de Diciembre de 1982 se debe ingresar 20/12/1982'");
    //f.select()
		f.value=''
		f.focus()
		return false
	}
	if ( !validarFecha(str) ) {
    // Los mensajes de error están dentro de validarFecha.
    //f.select()
   f.value=''
	f.focus()
    return false
  }
  }

  // validacion de la fecha


  return true
}

//-----------------------------------------------------------
  function validarFecha(str_fecha){

  var sl1=str_fecha.indexOf("/")
  var sl2=str_fecha.lastIndexOf("/")
  var inday = parseFloat(str_fecha.substring(0,sl1))
  var inmonth = parseFloat(str_fecha.substring(sl1+1,sl2))
  var inyear = parseFloat(str_fecha.substring(sl2+1,str_fecha.length))

  //alert("day:" + inday + ", mes:" + inmonth + ", agno: " + inyear)

  if (inmonth < 1 || inmonth > 12) {
    alert("Mes inválido en la fecha");
    return false;
  }
  if (inday < 1 || inday > diasEnMes(inmonth, inyear)) {
    alert("Día inválido en la fecha");
    return false;
  }

  return true
}


//------------------------------------------------------------------

function formatoFecha(str) {
  var sl1, sl2, ui, ddstr, mmstr, aaaastr;

  // El formato debe ser d/m/aaaa, d/mm/aaaa, dd/m/aaaa, dd/mm/aaaa,
  // Las posiciones son a partir de 0
  if (str.length < 8 &&  str.length > 10)    // el tamagno es fijo de 8, 9 o 10
    return false


  sl1=str.indexOf("/")
  if (sl1 < 1 && sl1 > 2 )    // el primer slash debe estar en la 1 o 2
    return false

  sl2=str.lastIndexOf("/")
  if (sl2 < 3 &&  sl2 > 5)    // el último slash debe estar en la 3, 4 o 5
    return false

  ddstr = str.substring(0,sl1)
  mmstr = str.substring(sl1+1,sl2)
  aaaastr = str.substring(sl2+1,str.length)

  if ( !sonDigitos(ddstr) || !sonDigitos(mmstr) || !sonDigitos(aaaastr) )
    return false

  return true
}
function sonDigitos(str) {
  var l, car

  l = str.length
  if ( l<1 )
    return false

  for ( i=0; i<l; i++) {
    car = str.substring(i,i+1)
    if ( "0" <= car &&  car <= "9" )
      continue
    else
      return false
  }
  return true
}

function diasEnMes (month, year)
{
  if (month == 1 || month == 3 || month == 5 || month == 7 || month == 8 || month == 10 || month == 12)
    return 31;
  else if (month == 2)
    // February has 29 days in any year evenly divisible by four,
      // EXCEPT for centurial years which are not also divisible by 400.
      return (  ((year % 4 == 0) && ( (!(year % 100 == 0)) || (year % 400 == 0) ) ) ? 29 : 28 );
  else if (month == 4 || month == 6 || month == 9 || month == 11)
    return 30;
  // En caso contrario:
  alert("diasEnMes: Mes inválido");
  return -1;
}
function Valida_Rut(Vrut)
{
	var dig
	Vrut = Vrut.split("-");

	if (!isNaN(Vrut[0]))
	{
		largo_rut = Vrut[0].length;
		if ((largo_rut >= 7 ) && (largo_rut <= 8))
		{
			if (largo_rut > 7)
			{
				multiplicador = 3;
			}
			else
			{
				multiplicador = 2;
			}
			suma = 0;
			contador = 0;
				do
				{
					digito = Vrut[0].charAt(contador);
					digito = Number(digito);
						if (multiplicador == 1)
						{
							multiplicador = 7;
						}

					suma = suma + (digito * multiplicador);
					multiplicador --;
					contador ++;
				}
				while (contador < largo_rut);
			resto = suma % 11
			dig_verificador = 11 - resto;

				if (dig_verificador == 10)
				{
					dig = "k";
				}
				else if (dig_verificador == 11)
				{
					dig = 0
				}
				else
				{
					dig = dig_verificador;
				}

				if (dig != Vrut[1])
				{
					alert ("El Rut es invalido !");
					datos.TX_RUTCLI.value="";
					datos.TX_RUTCLI.focus();
					//return 0;
				}
		}
		else
		{
			datos.TX_RUTCLI.value="";
			datos.TX_RUTCLI.focus();
			alert("El Rut es invalido ! ");

			//return 0;
		}
	}
	else
	{
		alert("El Rut es invalido ! ");
		datos.TX_RUTCLI.value="";
		datos.TX_RUTCLI.focus();
		//return 0;
	}
		//return 1;
}


function muestra_dia(){
//alert(getCurrentDate())
//alert("hola")
	var diferencia=DiferenciaFechas(datos.inicio.value)
	//alert(diferencia)
	if(datos.inicio.value!=''){
		if ((diferencia>=-30)) {
			//alert('Ok')
		}else{
			alert('la fecha de compromiso debe ser mayor a la \nfecha actual')
			datos.inicio.value=''
			datos.inicio.focus()
		}
	}
}


function DiferenciaFechas (CadenaFecha1) {


   fecha_hoy = getCurrentDate() //hoy


   //Obtiene dia, mes y año
   var fecha1 = new fecha( CadenaFecha1 )
   var fecha2 = new fecha(fecha_hoy)

   //Obtiene objetos Date
   var miFecha1 = new Date( fecha1.anio, fecha1.mes, fecha1.dia )
   var miFecha2 = new Date( fecha2.anio, fecha2.mes, fecha2.dia )

   //Resta fechas y redondea
   var diferencia = miFecha1.getTime() - miFecha2.getTime()
   var dias = Math.floor(diferencia / (1000 * 60 * 60 * 24))
   var segundos = Math.floor(diferencia / 1000)
   //alert ('La diferencia es de ' + dias + ' dias,\no ' + segundos + ' segundos.')

   return dias //false
}
//---------------------------------------------------------------------
function fecha( cadena ) {

   //Separador para la introduccion de las fechas
   var separador = "/"

   //Separa por dia, mes y año
   if ( cadena.indexOf( separador ) != -1 ) {
        var posi1 = 0
        var posi2 = cadena.indexOf( separador, posi1 + 1 )
        var posi3 = cadena.indexOf( separador, posi2 + 1 )
        this.dia = cadena.substring( posi1, posi2 )
        this.mes = cadena.substring( posi2 + 1, posi3 )
        this.anio = cadena.substring( posi3 + 1, cadena.length )
   } else {
        this.dia = 0
        this.mes = 0
        this.anio = 0
   }
}
///----------------------------------------
function ValidarCorreo(strmail){
     var Email = strmail
     var Formato = /^([\w-\.])+@([\w-]+\.)+([a-z]){2,4}$/;
	 var Comparacion = Formato.test(Email);
     if(Comparacion == false){
          alert("CORREO ELECTRÓNICO NO VALIDO");
          return false;
     }
}
function asigna_minimo(campo, minimo1){
	if (campo.value!=0)	{

		if(campo.value=='9'){
			minimo1=8;
		}else if(campo.value=='2'){
			minimo1=7;
		}else if(campo.value=='41' || campo.value=='32'){
			minimo1=7;
		}else{
			minimo1=6;
		}
	}else{minimo1=0}
	//alert(minimo1)
	return(minimo1)
}



function valida_largo(campo, minimo){
		if(campo.value.length != minimo) {
			alert("Fono debe tener " + minimo + " digitos")
			campo.value = ""
			//campo.select()
			campo.focus()
			return(true)
		}

	return(false)
}

function asigna_minimo2(campo, minimo2){
	if (campo.value!=0)	{
		if(campo.value==9){
			minimo2=8;
		}else if(campo.value==2){
			minimo2=7;
		}else if(campo.value==41 || campo.value==32){
			minimo2=7;
		}else {
			minimo2=6;
		}
	}else{minimo2=0}
	//alert(minimo2)
	return(minimo2)
}



function valida_largo2(campo, minimo){
		if(campo.value.length != minimo) {
			alert("Fono debe tener " + minimo + " digitos")
			campo.value = ""
			//campo.select()
			campo.focus()
			return(true)
		}

	return(false)
}

</script>


















