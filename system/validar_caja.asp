<% @LCID = 1034 %>
<!--#include file="../../comunes/bdatos/ControlDeAcceso.inc"-->
<!--#include file="../../comunes/bdatos/ConectarSCG.inc"-->
<!--#include file="../../comunes/rutinas/funciones.inc" -->
<!--#include file="../../comunes/rutinas/rutinasSCG.inc" -->
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
	'fecha= date
	cod_pago=request.querystring("cod_pago")
	strCodCliente = request("CB_CLIENTE")

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
	datos.action = "graba_validacion.asp";
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

</script>


<link href="style.css" rel="Stylesheet">

<form name="datos" method="post">
<table width="600" height="" border="1">
  <tr>
    <td height="20" bordercolor="#999999"  bgcolor="#336633" class="Estilo13" align="center">DETALLE DE PAGOS INTERCAPITAL </td>
  </tr>
  <tr>
    <td height="20" bordercolor="#999999"  bgcolor="#336633" class="Estilo27"><strong></strong></td>
  </tr>
  <tr>
    <td valign="top">
	  <%
		sql="select cwc.id_pago, CONVERT(varchar(10),cwc.fecha_pago, 103) AS fecha_pago,cwc.rutdeudor,cwc.comp_ingreso,cwc.nro_boleta,isnull(cwc.monto_capital,0) as monto_capital,isnull(cwc.monto_cps,0) as monto_cps,ctp.desc_tipo_pago,isnull(cwc.nro_deposito_cliente,'') as nro_deposito_cliente,isnull(cwc.nro_deposito_cps,'')as nro_deposito_cps ,cc.desc_cliente as nombre,cwc.cod_cliente,cwc.desc_cliente,cwc.desc_cps,cwc.total_cliente,cwc.total_cps,cwc.bco_deposito_cliente,cwc.bco_deposito_cps,cwc.observaciones,cwc.interes_plazo,cwc.costas_cps from caja_web_cps cwc,caja_tipo_pago ctp,caja_cliente cc where cwc.tipo_pago=ctp.id_tipo_pago and cc.id_cliente =cwc.cod_cliente and id_pago=" & cod_pago & ""
		set rsDet=ConexionSCG.execute(SQL)
		if not rsDet.eof then
			sql2="select nro_liquidacion from caja_web_cps_detalle where id_pago=" & cod_pago & ""
			set rsLiq=ConexionSCG.execute(SQL2)
			if not rsLiq.eof then
				if rsLiq("nro_liquidacion")=0 then
					nroliquidacion=""
				else
					nroliquidacion=rsLiq("nro_liquidacion")
				end if
			end if
			fecha = rsDet("fecha_pago")
			strCodCliente = rsDet("nombre")
			rutdeudor = rsDet("rutdeudor")
			cliente = rsDet("cod_cliente")
			nrocomp = rsDet("comp_ingreso")
			nrobolt = rsDet("nro_boleta")
			if nrobolt="0" then nrobolt=""
			tipago = rsDet("desc_tipo_pago")
			mcli = rsDet("monto_capital")
			nrodepcli = rsDet("nro_deposito_cliente")
			mint = rsDet("monto_cps")
			nrodepint = rsDet("nro_deposito_cps")
			desccliente = rsDet("desc_cliente")
			desccps = rsDet("desc_cps")
			ttcliente = rsDet("total_cliente")
			ttcps = rsDet("total_cps")
			bancocliente=rsDet("bco_deposito_cliente")
			sql="select * from t_bancos where ba_codigo='" & bancocliente & "'"
			set rsBC=ConexionSCG.execute(SQL)
			if not rsBC.eof then
				badescripcli=rsBC("ba_descripcion")
			else
				badescripcli=""
			end if

			bancocps=rsDet("bco_deposito_cps")
			sql="select * from t_bancos where ba_codigo='" & bancocps & "'"
			set rsBCps=ConexionSCG.execute(SQL)
			if not rsBCps.eof then
				badescripcps=rsBCps("ba_descripcion")
			else
				badescripcps=""
			end if

			'total = rsDet("cod_cliente")
			if nrodepcli="NULL" then
				nrodepcli=""
			end if
			if nrodepint="NULL" then
				nrodepint=""
			end if
			observaciones = rsDet("observaciones")
			ipcliente = rsDet("interes_plazo")
			ccps = rsDet("costas_cps")
		end if
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
	      <tr bgcolor="#99FFCC" class="Estilo8">
	        <td ALIGN="LEFT">RUT : <%=rutdeudor%></td><INPUT TYPE="hidden" NAME="cod_pago" value="<%=cod_pago%>">
	        <td ALIGN="RIGHT">FECHA: <%=fecha%><INPUT TYPE="hidden" NAME="tx_fechaing" value="<%=fecha%>"></td><td>USUARIO : <%=Session("strNombreUsuario")%></td>
	      </tr>
    </table>
	<%
	ssql="select calle,numero,resto,nombre_comuna,fono1codarea,fono1telefono,fono2codarea,fono2telefono,email from caja_web_ubicabilidad,comuna where comuna.codigo_comuna= caja_web_ubicabilidad.comuna and id_pago=" & cod_pago & ""
	set rsUbi=ConexionSCG.execute(sSQL)
	if not rsUbi.eof then
		if rsUbi("resto")="NULL" then
			resto=""
		else
			resto=rsUbi("resto")
		end if
		if rsUbi("email")="NULL" then
			mail=""
		else
			mail=rsUbi("email")
		end if
		if cint(rsUbi("fono2codarea"))=cint(0) then
			codarea2=""
		else
			codarea2=rsUbi("fono2codarea")
		end if
		if rsUbi("fono2telefono")=0 then
			fono2=""
		else
			fono2=rsUbi("fono2telefono")
		end if
		calle=rsUbi("calle")
		numero=rsUbi("numero")
		comuna=rsUbi("nombre_comuna")

		codaerea1=rsUbi("fono1codarea")
		fono1=rsUbi("fono1telefono")



	end if
	%>
	<!-- <table width="100%" border="0" bordercolor="#FFFFFF">
		<tr bordercolor="#999999"  bgcolor="#336633" class="Estilo13">
			<td width="50%">CALLE</td>
			<td width="10%">NÚMERO</td>
			<td width="20%">COMUNA</td>
			<td width="20%">RESTO</td>
		</tr>
		<tr bgcolor="#99FFCC">
			<td><%=calle%></td>
			<td><%=numero%></td>
			<td><%=comuna%></td>
			<td><%=resto%></td>
		</tr>
		</table>
		<table width="100%" border="0" bordercolor="#FFFFFF">
		<tr bordercolor="#999999"  bgcolor="#336633" class="Estilo13">
			<td width="10%">COD.ÁREA</td>
			<td width="25%">TELEFONO 1</td>
			<td width="10%">COD.ÁREA</td>
			<td width="25%">TELEFONO 2</td>
			<td width="30%">E-MAIL</td>
		</tr>
		<tr bgcolor="#99FFCC">
			<td>
			<%=codaerea1%>
			</td>
			<td><%=fono1%></td>
			<td>
				<%=codarea2%>
			</td>
			<td><%=fono2%></td>
			<td><%=mail%></td>
		</tr>
	</table> -->
	</td>
	</tr>
	<tr>
	<td bordercolor="#999999"  bgcolor="#336633">
	<font class="Estilo27"><strong>&nbsp;Resumen Pago</strong></font>
	</td>
	</tr>
	<tr>
	<td>
	<table width="100%" border="0">
      <tr bordercolor="#999999"  bgcolor="#336633">
        <td><span class="Estilo27">CLIENTE</span></td>
        <td><span class="Estilo27">Nro. Liq.</span></td>
        <td><span class="Estilo27">N° Comprobante</span></td>
		<td><span class="Estilo27">N° Boleta</span></td>
		<td><span class="Estilo27">Tipo Pago</span></td>
       </tr>
      <tr bgcolor="#99FFCC" class="Estilo8">
        <td><%=strCodCliente%>
		</td>
		<td><%=nroliquidacion%></td>
	    <td><%=nrocomp%><INPUT TYPE="hidden" NAME="tx_comp_ing" value="<%=nrocomp%>"></td>
		<td><%=nrobolt%></td>
		<td>
		<%=tipago%>
		</td>
        </tr>
    </table>
	</td>
	</tr>
	<tr>
	<td>
	<table width="100%" border="0">
	  <tr bordercolor="#999999"  bgcolor="#336633">
		<td><span class="Estilo27">Monto Cliente</span></td>
		<td><span class="Estilo27">Nro.Dep.Cliente</span></td>
		<td><span class="Estilo27">Banco</span></td>
		<td><span class="Estilo27">Interes Plazo</span></td>
		<td><span class="Estilo27">Descuento Cliente</span></td>
		<td><span class="Estilo27">Total Cliente</span></td>
		<td><span class="Estilo27"></span></td>
	  </tr>
	  <tr bgcolor="#99FFCC" class="Estilo8">
		<td><%=mcli%></td>
		<td><%=nrodepcli%></td>
		<td><%=badescripcli%></td>
		<td><%=ipcliente%></td>
		<td><%=desccliente%></td>
		<td><%=ttcliente%></td>
		<TD></TD>
	 </tr>
	  <tr bordercolor="#999999"  bgcolor="#336633">
		<td><span class="Estilo27">Monto Intercapital</span></td>
		<td><span class="Estilo27">Nro.Dep. Intercapital</span></td>
		<td><span class="Estilo27">Banco</span></td>
		<td><span class="Estilo27">Costas Intercapital</span></td>
		<td><span class="Estilo27">Descuento Intercapital</span></td>
		<td><span class="Estilo27">Total Intercapital</span></td>
		<td><span class="Estilo27">Total General</span></td>
	  </tr>
	  <tr bgcolor="#99FFCC" class="Estilo8">
		<td><%=mint%></td>
		<td><%=nrodepint%></td>
		<td><%=badescripcps%></td>
		<td><%=ccps%></td>
		<td><%=desccps%></td>
		<td><%=ttcps%></td>
		<td><%=ttcliente + ttcps%></td>
	  </tr>
	  <%
		ssql="select * from CAJA_WEB_VALIDACION where id_pago=" & cod_pago & ""
		set rsDet=ConexionSCG.execute(ssql)
		if not rsDet.eof then
			strconvenio=rsDet("convenio")
			strdep_cli=rsDet("deposito_cliente")
			strdep_cps=rsDet("deposito_cps")
			strcheques=rsDet("cheques")
			strcom_ing=rsDet("comp_ingreso")
			strboleta=rsDet("boleta")
			inicio=rsDet("fecha_deposito")
			strRendicion=rsDet("nro_rendicion")
			if strRendicion="0" then strRendicion=""
			strobservacion=rsDet("observaciones")
		end if
	  %>
	</table>
	    <table width="100%" border="0">
          <tr bordercolor="#999999"  bgcolor="#336633">
            <td><span class="Estilo27">Convenio</span></td>
            <td><span class="Estilo27">Deposito cliente</span></td>
            <td><span class="Estilo27">Deposito Intercapital</span></td>
            <td><span class="Estilo27">Cheques</span></td>
          </tr>
          <tr bgcolor="#99FFCC" class="Estilo8">
            <td>SI <INPUT TYPE="radio" NAME="convenio" value="1" <%if strconvenio = "1" then Response.Write("checked")%>> &nbsp;&nbsp;&nbsp;NO
              <INPUT TYPE="radio" NAME="convenio" value="0" <% if strconvenio = "0" then Response.Write("checked")%>></td>
            <td>SI <INPUT TYPE="radio" NAME="dep_cli" value="1" <% if strdep_cli = "1" then Response.Write("checked")%>> &nbsp;&nbsp;&nbsp;NO
              <INPUT TYPE="radio" NAME="dep_cli" value="0" <% if strdep_cli = "0" then Response.Write("checked")%>></td>
            <td>SI <INPUT TYPE="radio" NAME="dep_cps" value="1" <% if strdep_cps = "1" then Response.Write("checked")%>> &nbsp;&nbsp;&nbsp;NO
              <INPUT TYPE="radio" NAME="dep_cps" value="0" <% if strdep_cps = "0" then Response.Write("checked")%>></td>
            <td>SI <INPUT TYPE="radio" NAME="cheque" value="1" <% if strcheques = "1" then Response.Write("checked")%>> &nbsp;&nbsp;&nbsp;NO
              <INPUT TYPE="radio" NAME="cheque" value="0" <% if strcheques = "0" then Response.Write("checked")%>></td>
          </tr>
          <tr bordercolor="#999999"  bgcolor="#336633">
            <td><span class="Estilo27">Comprobante Ingreso</span></td>
            <td><span class="Estilo27">Boleta</span></td>
            <td><span class="Estilo27">Fecha deposito</span></td>
            <td><span class="Estilo27">Rendicion</span></td>
          </tr>
          <tr bgcolor="#99FFCC" class="Estilo8">
            <td>SI <INPUT TYPE="radio" NAME="comp_ing" value="1" <% if strcom_ing = "1" then Response.Write("checked")%>> &nbsp;&nbsp;&nbsp;NO
              <INPUT TYPE="radio" NAME="comp_ing" value="0" <% if strcom_ing = "0" then Response.Write("checked")%>></td>
            <td>SI <INPUT TYPE="radio" NAME="boleta" value="1" <% if strboleta = "1" then Response.Write("checked")%>> &nbsp;&nbsp;&nbsp;NO
              <INPUT TYPE="radio" NAME="boleta" value="0" <% if strboleta = "0" then Response.Write("checked")%>></td>
            <td><input name="inicio" type="text" id="inicio" value="<%=inicio%>" size="10" maxlength="10">
              <a href="javascript:showCal('Calendar7');"><img src="../../images/calendario.gif" border="0"></a></td>
            <td><INPUT TYPE="text" NAME="tx_rendicion" value="<%=strRendicion%>"></td>
          </tr>
          <tr bgcolor="#99FFCC" class="Estilo8">
            <td colspan="3">Observaciones:<INPUT TYPE="text" NAME="observacion" size="50" value="<%=strobservacion%>"></td>
            <td><INPUT TYPE="button" value="GUARDAR" onclick="Refrescar();"></td>
          </tr>

        </table>
		<A HREF="detalle_caja.asp">Volver</A>
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
	if(datos.TX_RUT.value==''){
		alert("Debe ingresar el rut")
		datos.TX_RUT.focus();
	}else if (datos.txt_calle.value==''){
		alert("Debe ingresar una dirección");
		datos.txt_calle.focus();
	}else if(datos.txt_numero.value==''){
		alert("Debe ingresar la numeración de la calle");
		datos.txt_numero.focus();
	}else if(datos.cmb_comuna.value==''){
		alert("Debe seleccionar una comuna");
		datos.cmb_comuna.focus();
	}else if((datos.cmb_area1.value=='')||(datos.txt_fono1.value=='')){
		alert("Debe ingresar un Telefono");
		datos.cmb_comuna.focus();
	}else if(datos.CB_CLIENTE.value == '0'){
		alert("Debe seleccionar el Cliente");
	}else if ((datos.CB_CLIENTE.value == 'DNP') && (datos.TX_NROLIQUIDACION.value=='')){
		alert("Debe ingresar el Número de Liquidación");
	}else if ((datos.CB_CLIENTE.value != 'DNP') && (datos.TX_NROLIQUIDACION.value=='')){
		datos.TX_NROLIQUIDACION.value = 0
	}else if (datos.TX_COMPINGRESO.value == ''){
		alert("Debe ingresar el Número del Comprobante de Pago");
	}else if (datos.TX_BOLETA.value == ''){
		alert("Debe ingresar Número de Boleta");
	}else if (datos.CB_TIPOPAGO.value == ''){
		alert("Debe seleccionar el Tipo de Pago");
	}else{
		JuntaDetalleCliente();
		JuntaDetalle();
		datos.TX_MONTOCLIENTE.disabled = false
		datos.TX_TOTAL.disabled = false;
		datos.action='grabacaja.asp';
		datos.submit();

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

















