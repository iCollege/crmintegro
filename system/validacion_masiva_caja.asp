<% @LCID = 1034 %>
<!--#include file="../../comunes/bdatos/ControlDeAcceso.inc"-->
<!--#include file="../../comunes/bdatos/ConectarSCG.inc"-->
<!--#include file="../../comunes/rutinas/funciones.inc" -->
<!--#include file="../../comunes/rutinas/rutinasSCG.inc" -->
<!--#include file="../../comunes/bdatos/ConectarINTRACPS.inc"-->
<%

	'cod_caja=71
	cod_caja=Session("intCodUsuario")
	strsql="select * from usuario where cod_usuario = " & cod_caja & ""
	set rsUsu=Conn.execute(strsql)
	if not rsUsu.eof then
		perfil=rsUsu("per_cajaweb")
		if perfil = "caja_modif" or perfil = "caja_listado" then
			sucursal = request("cmb_sucursal")
		else
			sucursal = rsUsu("sucursal")
		end if
	end if
	'response.write(perfil)
	codpago = request("TX_pago")
	strrut=request("TX_RUT")
	if sucursal="" then sucursal="0"
	'response.write(sucursal)
	usuario = request("cmb_usuario")
	if usuario = "" then usuario = "0"
	termino = request("termino")
	inicio = request("inicio")
	resp = request("resp")
	cliente = request("CB_CLIENTE")
	'response.write(cliente)
	if Trim(inicio) = "" Then
		inicio = TraeFechaMesActual(conexionSCG,-1)
		inicio = "01" & Mid(inicio,3,10)
	End If
	if Trim(termino) = "" Then
		termino = TraeFechaActual(conexionSCG)
	End If

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

function Refrescar()
{
	resp='no'
	datos.action = "validacion_masiva_caja.asp?resp="+ resp +"";
	datos.submit();
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

function envia_excel(URL){
	window.open(URL,"INFORMACION","width=200, height=200, scrollbars=yes, menubar=yes, location=no, resizable=yes")
}
</script>


<link href="style.css" rel="Stylesheet">

<form name="datos" method="post">
<table width="850" height="" border="1">
  <tr>
    <td height="20" bordercolor="#999999"  bgcolor="#336633" class="Estilo13" align="center"> </td>
  </tr>
  <tr>
    <td height="20" bordercolor="#999999"  bgcolor="#336633" class="Estilo27"><strong></strong></td>
  </tr>
  <tr>
    <td valign="top">


        	<table width="100%" border="0" bordercolor="#999999">
	      <tr height="20" bordercolor="#999999"  bgcolor="#336633" class="Estilo13">
		  <%if perfil="caja_modif" or perfil = "caja_listado" then%>
	        <td>SUCURSAL</td>
			<%end if%>
			<td>CLIENTE</td>
			<td>DESDE</td>
			<td>HASTA</td>
	      </tr>
		  <tr bordercolor="#999999" class="Estilo8">
		  <%if perfil="caja_modif" or perfil = "caja_listado" then%>
	        <td>
				<SELECT NAME="cmb_sucursal" id="cmb_sucursal" onchange="Refrescar();">
				<option value="0">TODAS</option>
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
				</SELECT>
			</td>
			<%end if%>
			 <td>
				<select name="CB_CLIENTE" width="15" onchange="Refrescar();">
					<option value="0">SELECCIONAR</option>
						<%
						ssql="SELECT * FROM CAJA_CLIENTE where activo=1"
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
			<td><input name="inicio" type="text" id="inicio" value="<%=inicio%>" size="10" maxlength="10">
		<a href="javascript:showCal('Calendar7');"><img src="../../images/calendario.gif" border="0"></a>
			</td>
			<td><input name="termino" type="text" id="termino" value="<%=termino%>" size="10" maxlength="10">
          <a href="javascript:showCal('Calendar6');"><img src="../../images/calendario.gif" border="0"></a>
			<input type="button" name="Submit" value="Ver" onClick="envia();"><!-- <input type="button" name="Submit" value="Excel" onClick=""> -->
			<input type="button" name="Submit" value="Excel" onClick="javascript:envia_excel('validacion_masiva_caja_excel.asp?sucursal=<%=sucursal%>&termino=<%=termino%>&inicio=<%=inicio%>&CLIENTE=<%=CLIENTE%>')"></td>
	      </tr>
    </table>

	<%if resp = "si" then
		%>
		<table width="100%" border="0" bordercolor="#000000">
		<tr height="20" bordercolor="#999999"  bgcolor="#336633" class="Estilo13">
			<td>COD. PAGO</td>
			<td>FECHA PAGO</td>
			<td>SUCURSAL</td>
			<td>CLIENTE</td>
			<td>RUT DEUDOR</td>
			<td>COMP. INGRESO</td>
			<td>NRO. BOLETA</td>
			<td>TIPO PAGO</td>
			<td>Q DOC</td>
			<td>DESTINO</td>
			<td>MONTO</td>
			<td>FOR. PAGO</td>
			<td>NRO. DEPOSITO</td>
			<td>BANCO</td>
			<td>DESC. CLIENTE</td>
			<td>COSTAS INTER.</td>
			<td>CONVENIOS</td>
			<td>DEP. CLIENTE</td>
			<td>DEP. INTER.</td>
			<td>CHEQUES</td>
			<td>COMP. INGRESO</td>
			<td>BOLETA</td>
			<td>FECHA DEP</td>
			<td>RENDICION</td>
			<td>OBSERVACIONES</td>
			<td>EST. PAGO</td>

		</tr>
		<%

SQL = "select cwc.id_pago,cwc.rendido, CONVERT(varchar(10), cwc.fecha_pago, 103)AS fecha_pago, s.des_suc, cc.desc_cliente as nombre, cwc.rutdeudor, cwc.comp_ingreso, cwc.nro_boleta, cwc.monto_capital, cwc.monto_cps, ctp.desc_tipo_pago, cwc.nro_deposito_cliente, cwc.nro_deposito_cps, cwc.bco_deposito_cliente, cwc.bco_deposito_cps, cwc.usringreso, cwc.desc_cliente, cwc.desc_cps, cwc.total_cliente, cwc.total_cps, cwc.interes_plazo, cwc.costas_cps, cwc.estado_caja from caja_web_cps cwc,caja_cliente cc,caja_tipo_pago ctp,sucursal s where cc.id_cliente =cwc.cod_cliente and ctp.id_tipo_pago = cwc.tipo_pago and s.cod_suc = cwc.sucursal "
IF SUCURSAL <> "0" THEN
SQL = SQL & "and sucursal='" & sucursal & "'"
end if

if cliente <> "0" then
	SQL = SQL & "and  cwc.cod_cliente='" & cliente & "'"
end if
SQL = SQL & "and rendido between '" & inicio & "' and '" & termino & "' order by rendido"

		if sql <> "" then
		set rsDet=ConexionSCG.execute(SQL)

		if not rsDet.eof then
		i=1
		x=0
		COD_ANT = 0
			do while not rsDet.eof
				cod_pago=rsDet("id_pago")
				ssql="select * from usuario where cod_usuario = " & rsDet("usringreso") & ""
				set rsUsuIng=Conn.execute(ssql)
				if not rsUsuIng.eof then
					usringreso= rsUsuIng("login")
				end if


				if rsDet("nro_deposito_cliente")="NULL" then
					ndc=""
				else
					ndc=rsDet("nro_deposito_cliente")
				end if

				if rsDet("nro_deposito_cps")="NULL" then
					ndcps=""
				else
					ndcps=rsDet("nro_deposito_cps")
				end if
				if rsDet("nro_boleta")= "0" then
					boleta = ""
				else
					boleta = rsDet("nro_boleta")
				end if
				if color="#99FFCC" then
						color="#BBFFDD"
					else
						color="#99FFCC"
					end if
				strSql = "select count(*) as q,max(correlativo) as correlativo,id_pago,sum(monto) as monto,tipo_pago,forma_pago from caja_web_cps_doc_pago where id_pago = " & cod_pago & " group by id_pago,tipo_pago,forma_pago order by id_pago,tipo_pago"
				set rsDoc = ConexionSCG.execute(strSql)
				if not rsDoc.eof then
				do while not rsDoc.eof

				strsql = "select * from t_bancos where ba_codigo='" & rsDet("bco_deposito_cliente") & "'"
				set rsbc=ConexionSCG.execute(strsql)
				if not rsbc.eof then
					bc=rsbc("ba_descripcion")
				else
					bc=""
				end if


				stsql = "select * from t_bancos where ba_codigo='" & rsDet("bco_deposito_cps") & "'"
				set rsbcps=ConexionSCG.execute(stsql)
				if not rsbcps.eof then
					bcps=rsbcps("ba_descripcion")
				else
					bcps=""
				end if

				if cint(rsDoc("tipo_pago")) = 1 then
					if bcps = "" then
						nd = ndcps
						banc = ""
					else
						banc = rsbcps("ba_descripcion")
						nd = ndcps
					end if
					destino = "G"
				else
					banc = bc
					nd = ndc
					destino = "C"
				end if
				IF cint(COD_ANT) = cint(cod_pago) THEN X = X + 1
				IF cint(COD_ANT) <> cint(cod_pago) THEN X = 0
				sq="select fecha_deposito,replace(nro_rendicion,0,'') as nro_rendicion,replace(deposito_cliente,0,'') as deposito_cliente,replace(deposito_cps,0,'') as deposito_cps,replace(cheques,0,'') as cheques,replace(comp_ingreso,0,'') as comp_ingreso,replace(boleta,0,'') as boleta,replace(convenio,0,'') as convenio,replace(observaciones,0,'') as observaciones from CAJA_WEB_VALIDACION where id_pago=" & cod_pago & " and correlativo = " & X & ""

				set rsCWV=ConexionSCG.execute(sq)
				if not rsCWV.eof then
					strconvenio = rsCWV("convenio")
					strdep_cli = rsCWV("deposito_cliente")
					strdep_cps = rsCWV("deposito_cps")
					strcheques = rsCWV("cheques")
					strcom_ing = rsCWV("comp_ingreso")
					strboleta = rsCWV("boleta")
					fecha_dep = rsCWV("fecha_deposito")
					strRendicion = rsCWV("nro_rendicion")
					strObservacion = rsCWV("observaciones")
				else
					strconvenio = ""
					strdep_cli = ""
					strdep_cps = ""
					strcheques = ""
					strcom_ing = ""
					strboleta = ""
					fecha_dep = ""
					strRendicion = ""
					strObservacion = ""
				end if

				if rsDoc("tipo_pago") = "1" then formap = rsDoc("forma_pago")
					if rsDoc("forma_pago") = "CF" or rsDoc("forma_pago") = "CD" then
						q = rsDoc("q")
					else
						q = 0
					end if

			%>
			<tr bgcolor="<%=color%>" class="Estilo8">
				<td><%=rsDet("id_pago")%></td>
				<td><INPUT TYPE="hidden" NAME="<%="B"&i%>" value="<%=rsDet("fecha_pago")%>"><%=rsDet("fecha_pago")%></td>
				<td><INPUT TYPE="hidden" NAME="<%="A"&i%>" value="<%=cod_pago%>"><%=rsDet("des_suc")%></td>
				<td><%=rsDet("nombre")%></td>
				<td><%=rsDet("rutdeudor")%></td>
				<td><%=rsDet("comp_ingreso")%></td>
				<td><%=boleta%></td>
				<td><%=rsDet("desc_tipo_pago")%></td>
				<td><%=q%></td>
				<TD><%=DESTINO%></TD>
				<td align="right"><%=formatnumber(rsDoc("monto"),0)%></td>
				<td><%=rsDoc("forma_pago")%></td>
				<td><%=nd%></td>
				<td><%=banc%></td>
				<td><%=rsDet("desc_cliente")%></td>
				<td><%=rsDet("costas_cps")%></td>
				<td><INPUT TYPE="checkbox" NAME="<%="C"&i%>" value="1" <%if strconvenio="1" then Response.Write("checked")%>></td>
				<td><INPUT TYPE="checkbox" NAME="<%="D"&i%>" value="1"<%if strdep_cli="1" then Response.Write("checked")%>></td>
				<td><INPUT TYPE="checkbox" NAME="<%="E"&i%>" value="1" <%if strdep_cps="1" then Response.Write("checked")%>></td>
				<td><INPUT TYPE="checkbox" NAME="<%="F"&i%>" value="1" <%if strcheques="1" then Response.Write("checked")%>></td>
				<td><INPUT TYPE="checkbox" NAME="<%="G"&i%>" value="1" <%if strcom_ing="1" then Response.Write("checked")%>></td>
				<td><INPUT TYPE="checkbox" NAME="<%="H"&i%>" value="1" <%if strboleta="1" then Response.Write("checked")%>></td>
				<td><input name="<%="J"&i%>" type="text" id="<%="J"&i%>" value="<%=fecha_dep%>" size="6" maxlength="10" onblur="chkFecha(this)"></td>
				<td><INPUT TYPE="text" NAME="<%="K"&i%>" value="<%=strRendicion%>" size="6"></td>
				<td><INPUT TYPE="text" NAME="<%="L"&i%>"><%=strObservacion%></td>
				<%if rsDet("estado_caja")="N" then estado="NULO"%>
				<%if rsDet("estado_caja")="CN" then estado="COMPROBANTE NULO"%>
				<%if rsDet("estado_caja")="BN" then estado="BOLETA NULA"%>
				<%if rsDet("estado_caja")="A" then estado=""%>
				<td><%=estado%></td>
			</tr>
			<%
			bc=""
			bcps=""
			i = i + 1
			COD_ANT = cod_pago
			rsDoc.movenext

			loop
			end if

			rsDet.movenext
			loop
		end if
	end if
		%>
		<tr>
			<td><INPUT TYPE="hidden" NAME="indice" value="<%=i%>"></td>
			<td></td>
			<td></td>
			<td></td>
			<td></td>
			<td></td>
			<td></td>
			<td></td>
			<td></td>
			<td></td>
			<td></td>
			<td></td>
			<td></td>
			<td><!-- <A HREF="detalle_caja.asp">Volver</A> --></td>
			<td></td>
			<td></td>
			<td></td>
			<td></td>
			<td></td>
			<td></td>
			<td></td>
			<td></td>
			<td></td>
			<td></td>
			<td></td>
			<td></td>
			<td></td>
			<td></td>
			<td></td>
			<td></td>
			<%if perfil="caja_modif" then%>
			<td align="right"><INPUT TYPE="button" value="GUARDAR" onclick="envia2();"></td>
			<%else%>
			<td></td>
			<%end if%>
		</tr>
		<table>

		<%
	  end if

	%>

	  </td>
	</tr>
  </table>

</form>
<script language="JavaScript" type="text/JavaScript">
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
	datos.TXREAJUSTE.value=""
	datos.TXINTERES.value=""
	datos.TXGRAVAMENES.value=""
	datos.TXMULTAS.value=""
	datos.TXCARGOS.value=""
	datos.TXCOSTAS.value=""
	datos.TXOTROS.value=""
	for (var e=0; e<datos.CLAVEDOC.options.length;e++){
		if (e!=0) {
		//poner la coma
			datos.TXCLAVEDOC.value=datos.TXCLAVEDOC.value+"*"	;
			datos.TXPERIODO.value=datos.TXPERIODO.value+"*";
			datos.TXCAPITAL.value	=datos.TXCAPITAL.value+"*";
			datos.TXREAJUSTE.value=datos.TXREAJUSTE.value+"*";
			datos.TXINTERES.value=datos.TXINTERES.value+"*";
			datos.TXGRAVAMENES.value=datos.TXGRAVAMENES.value+"*";
			datos.TXMULTAS.value=datos.TXMULTAS.value+"*";
			datos.TXCARGOS.value=datos.TXCARGOS.value+"*";
			datos.TXCOSTAS.value=datos.TXCOSTAS.value+"*";
			datos.TXOTROS.value=datos.TXOTROS.value+"*";
		}
		//concatenar
		datos.TXCLAVEDOC.value=datos.TXCLAVEDOC.value+datos.CLAVEDOC.options[e].value;
		datos.TXPERIODO.value=datos.TXPERIODO.value+datos.PERIODO.options[e].value;
		datos.TXCAPITAL.value=datos.TXCAPITAL.value+datos.CAPITAL.options[e].value;
		datos.TXREAJUSTE.value=datos.TXREAJUSTE.value+datos.REAJUSTE.options[e].value;
		datos.TXINTERES.value=datos.TXINTERES.value+datos.INTERES.options[e].value;
		datos.TXGRAVAMENES.value=datos.TXGRAVAMENES.value+datos.GRAVAMENES.options[e].value;
		datos.TXMULTAS.value=datos.TXMULTAS.value+datos.MULTAS.options[e].value;
		datos.TXCARGOS.value=datos.TXCARGOS.value+datos.CARGOS.options[e].value;
		datos.TXCOSTAS.value=datos.TXCOSTAS.value+datos.COSTAS.options[e].value;
		datos.TXOTROS.value=datos.TXOTROS.value+datos.OTROS.options[e].value;
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
      if (isNaN(valor.value)) {
            //entonces (no es numero) devuelvo el valor cadena vacia
            valor.value=""
			//alert(valor.value)
			valor.focus();
			//return ""
      }else{
            //En caso contrario (Si era un número) devuelvo el valor
			valor.value
			return valor.value
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

	resta_capital(datos.OTROS.value);
	borra_opcion(datos.OTROS,indice);

}


function resta_capital(valor){
	datos.TX_MONTOCLIENTE.disabled = false;
	datos.TX_TOTAL.disabled = false;
	datos.TX_MONTOCLIENTE.value = eval(datos.TX_MONTOCLIENTE.value) - eval(valor);
	if (datos.TX_DESCUENTO.value == ""){
		datos.TX_DESCUENTO.value = 0;
	}
	if (datos.TX_MONTOCPS.value == ""){
		datos.TX_MONTOCPS.value = 0;
	}
	datos.TX_TOTAL.value = (eval(datos.TX_MONTOCLIENTE.value) + eval(datos.TX_MONTOCPS.value)) - eval(datos.TX_DESCUENTO.value);
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
	datos.CAPITAL.selectedIndex=indice;
	datos.REAJUSTE.selectedIndex=indice;
	datos.INTERES.selectedIndex=indice;
	datos.GRAVAMENES.selectedIndex=indice;
	datos.MULTAS.selectedIndex=indice;
	datos.CARGOS.selectedIndex=indice;
	datos.COSTAS.selectedIndex=indice;
	datos.OTROS.selectedIndex=indice;


}
//-------------------------------
function asigna_minimo(campo){
	if (campo.value!=0)	{
		if(campo.value.length==1){
			minimo1=7;
		}else {
			minimo1=6;
		}
	}else{minimo1=0;}
	return(minimo1);
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

				resta_capital(datos.OTROS.value);
				borra_opcion(datos.OTROS,i);
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
				datos.TX_OTROS.value="";
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
		if (datos.TX_CLAVEDOC.value==''){
			alert("Debe ingresar el número de clave o documento")
			datos.TX_CLAVEDOC.focus();
		}else if (datos.CB_CLIENTE.value=='DNP'){
			if ((datos.TX_MES.value=='')||(datos.TX_ANO.value=='')){
				alert("Debe ingresar el periodo")
				datos.TX_ANO.focus();
			}else if (datos.TX_CAPITAL.value==''){
				alert("Debe ingresar el monto capital")
				datos.TX_CAPITAL.focus();
			}else{
			apilar_textbox_combo(datos.TX_CLAVEDOC, datos.CLAVEDOC);
			apila_periodo()
			//apilar_textbox_combo(datos.TX_PERIODO, datos.PERIODO);
			apilar_textbox_combo(datos.TX_CAPITAL, datos.CAPITAL);
			apilar_textbox_combo(datos.TX_REAJUSTE, datos.REAJUSTE);
			apilar_textbox_combo(datos.TX_INTERES, datos.INTERES);
			apilar_textbox_combo(datos.TX_GRAVAMENES, datos.GRAVAMENES);
			apilar_textbox_combo(datos.TX_MULTAS, datos.MULTAS);
			apilar_textbox_combo(datos.TX_CARGOS, datos.CARGOS);
			apilar_textbox_combo(datos.TX_COSTAS, datos.COSTAS);
			apilar_textbox_combo(datos.TX_OTROS, datos.OTROS);
			montocliente();
			//limpiar textos
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
			datos.TX_OTROS.value="";
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
			apilar_textbox_combo(datos.TX_CAPITAL, datos.CAPITAL);
			apilar_textbox_combo(datos.TX_REAJUSTE, datos.REAJUSTE);
			apilar_textbox_combo(datos.TX_INTERES, datos.INTERES);
			apilar_textbox_combo(datos.TX_GRAVAMENES, datos.GRAVAMENES);
			apilar_textbox_combo(datos.TX_MULTAS, datos.MULTAS);
			apilar_textbox_combo(datos.TX_CARGOS, datos.CARGOS);
			apilar_textbox_combo(datos.TX_COSTAS, datos.COSTAS);
			apilar_textbox_combo(datos.TX_OTROS, datos.OTROS);
			montocliente();
			//limpiar textos
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
			datos.TX_OTROS.value="";
			datos.TX_CLAVEDOC.focus();
		}

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
	datos.TX_TOTAL.disabled = false;
	if (datos.TX_MONTOCLIENTE.value == ""){
		datos.TX_MONTOCLIENTE.value = 0
	}
	if (datos.TX_MONTOCPS.value == ""){
		datos.TX_MONTOCPS.value = 0
	}
	capital = eval(datos.TX_CAPITAL.value) + eval(datos.TX_REAJUSTE.value) + eval(datos.TX_INTERES.value) + eval(datos.TX_GRAVAMENES.value) + eval(datos.TX_MULTAS.value) + eval(datos.TX_CARGOS.value)+ eval(datos.TX_COSTAS.value) + eval(datos.TX_OTROS.value) + eval(datos.TX_MONTOCLIENTE.value);

	datos.TX_MONTOCLIENTE.value = eval(capital);

	if (datos.TX_DESCUENTO.value == ""){
		datos.TX_DESCUENTO.value = 0
	}
	total = (eval(capital) + eval(datos.TX_MONTOCPS.value))- eval(datos.TX_DESCUENTO.value);
	datos.TX_TOTAL.value = eval(total);
	datos.TX_MONTOCLIENTE.disabled = true;
	datos.TX_TOTAL.disabled = true;
}


function apilar_textbox_combo(origen, destino){
//addNew(document.myForm.proceso.options[document.myForm.proceso.selectedIndex].value)
	// Add a new option.
	var ok=false;
	i=destino.length;
	//valor = datos.txt_clavedoc.value.length;
	//alert(valor);
	valor=origen.value.length ;
	if (valor>=0){
		texto=origen.value;
		if (texto==''){
		texto='';
		origen.value = 0
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
			var el = new Option(texto,origen.value);
			destino.options[i] = el;
//		}
	}else
		alert("ingrese un valor para agregar.");
}
//------------------------------------------------------------------
function apilar_combo_combo(origen, destino){
//addNew(document.myForm.proceso.options[document.myForm.proceso.selectedIndex].value)
	// Add a new option.
	var ok=false;
	i=destino.length;
	valor=origen.selectedIndex ;
	if (valor>=0){
		texto=origen.options[valor].text;
		if (texto=='SELECCIONAR'){
			texto='';
			origen.options[valor].value=0;
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
			var el = new Option(texto,origen.options[valor].value);
			destino.options[i] = el;
//		}
	}else
		alert("Seleccione un valor para agregar.");
}
//////--------------------------------------------------------------------
function envia(){
		resp='si';
		datos.action="validacion_masiva_caja.asp?resp="+ resp +"";
		datos.submit();
}

function envia2(){
		//resp='si';
		datos.action="graba_validacion_masiva.asp";
		datos.submit();
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
if (f.value1=''){
  //str=f.value
  str1=f.value
  str2 = str1.replace('-','/')
  str= str2.replace('-','/')
		//alert(str)
  f.value=str
  //str2 = str1.replace('-','/')
  //str= str2.replace('-','/')
  //alert(str)
  if (str.length<10){
  	alert("Error - Ingresó una fecha no válida");
  	f.value=''
	f.focus();
  //	f.select();
  }else{

	if ( !formatoFecha(str) ) {
		//alert("Debe indicar la Fecha en formato DD/MM/AAAA. Ejemplo: 'Para 20 de Diciembre de 1982 se debe ingresar 20/12/1982'");
    //f.select()
		f.value='';
		f.focus();
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
		if ((diferencia>=0) && (diferencia<=90)) {
			//alert('Ok')
		}else{
			alert('la fecha de compromiso debe ser mayor a la \nfecha actual y dentro de los proximos 30 dias')
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
		if(campo.value.length==1){
			minimo1=7;
		}else if(campo.value==41 || campo.value==32){
			minimo1=7;
		}else {
			minimo1=6;
		}
	}else{minimo1=0}
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
		if(campo.value.length==1){
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

















