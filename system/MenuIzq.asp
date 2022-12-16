<!--#include file="asp/comunes/general/rutinasBooleano.inc"-->
<html>
<head>
<STYLE type="text/css">
a:link {text-decoration: none;font-family: Verdana, Arial, Helvetica, sans-serif;font-size: 10px;color: #003366;padding: 0px;margin-right: 3px; width: 100%;}
a:hover {text-decoration: none;font-family: Verdana, Arial, Helvetica, sans-serif;font-size: 10px;color: #003366;padding: 0px;margin-right: 3px; width: 100%;}
a:active {font-family: Verdana, Arial, Helvetica, sans-serif;font-size: 10px;color: #003366;text-decoration: none;padding: 0px;margin-right: 3px; width: 100%;}
a:visited {font-family: Verdana, Arial, Helvetica, sans-serif;font-size: 10px;color: #003366;text-decoration: none;padding: 0px;margin-right: 3px; width: 100%;}
a.bot:visited {font-family: Verdana, Arial, Helvetica, sans-serif;font-size: 10px;color: #003366;text-decoration: none;margin-right: 3px;padding: 0px; width: 100%;}
txtmenu {font-family: Verdana, Arial, Helvetica, sans-serif; font-size: 10px; width: 100%; padding-top: 3px; color: #003366; text-decoration: none; padding-bottom: 3px; padding-left: 7px}
.titulobold {font-family: Verdana, Arial, Helvetica, sans-serif;font-size: 10px;font-weight: bold;color: #003366;background-color: eaf1fb;height: 22px; width: 100%;}
body {scrollbar-face-color: D9E0EA;scrollbar-highlight-color: D9E0EA;scrollbar-arrow-color: 034E3E;scrollbar-track-color: F5F5F5;}
.pixelderecho {border-top-width: 1px;border-top-style: solid;border-top-color: #d3d3d3;border-right-width: 1px;border-right-style: solid;border-right-color: #8ba7cb;}
.pixelarriba {height: 22px;clip:  rect(100px auto auto auto);background-color: FFFFFF;border-top-style: solid;border-top-color: D3D3D3;border-top-width: 1px;}
.pixelarribacolor {height: 22px;clip:    rect(auto auto auto auto);background-color: eaf1fb;bottom: 0px;border-top-width: 1px;border-top-style: solid;border-top-color: D3D3D3; width: 100%;border-left-width: 1px;border-left-style: solid;border-left-color: #8ba7cb;border-right-width: 1px;border-right-style: solid;border-right-color: #8ba7cb;}
.pixelizquierdocolor {background-color: eaf1fb;border-left-width: 1px;border-left-style: solid;border-left-color: #8ba7cb;}
.pixelderechocolor {background-color: eaf1fb;border-right-width: 1px;border-right-style: solid;border-right-color: #8ba7cb;}
.activando {border-top: 1px solid #D3D3D3;height: 22px; width: 90%;}
.activandosinpixelarriba {border-top: 1px solid #FFFFFF;height: 22px;}
.nombre {font-family: Arial, Helvetica, sans-serif;font-size: 11px;color: #003399;font-weight: normal;}
.pixelizquierdoarribacolor {background-color: eaf1fb;border-top-width: 1px;border-top-style: solid;border-top-color: D3D3D3;border-left-width: 1px;border-left-style: solid;border-left-color: #8ba7cb;}
.pixelderechoarribacolor {background-color: eaf1fb;border-right-width: 1px;border-right-style: solid;border-right-color: #8ba7cb;border-top-width: 1px;border-top-style: solid;border-top-color: D3D3D3;}
.fondotitulo {font-weight: bold;background-color: eaf1fb;height: 22px;border-top: 1px solid d3d3d3;}
.pixelizquierdo {border-top-width: 1px;border-top-style: solid;border-top-color: #d3d3d3;border-left-width: 1px;border-left-style: solid;border-left-color: #8ba7cb;}
.textocombo {font-family: Arial, Helvetica, sans-serif;font-size: 10px;color: #000000;}
a.textossubmenu:active {  font-family: Verdana, Arial, Helvetica, sans-serif; font-size: 10px; width: 100%; padding-top: 3px; color: #003366; text-decoration: none; padding-bottom: 4px; padding-left: 3px;}
a.textossubmenu:hover {  font-family: Verdana, Arial, Helvetica, sans-serif; font-size: 10px; width: 100%; padding-top: 3px; padding-left: 3px; background-color: #d8e0ec; color: #003366; text-decoration: none; padding-bottom: 4px; filter: Alpha(Opacity=80);}
a.textossubmenu:link {  font-family: Verdana, Arial, Helvetica, sans-serif; font-size: 10px; width: 100%; padding-top: 3px; padding-left: 3px; color: #003366; text-decoration: none; padding-bottom: 4px;}
a.textossubmenu:visited {  font-family: Verdana, Arial, Helvetica, sans-serif; font-size: 10px; width: 100%; padding-top: 3px; padding-left: 3px; color: #003366; text-decoration: none; padding-bottom: 4px;}
</STYLE>
<title>Menu Cobranzas</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<meta http-equiv="Control-Cache" content="no-cache">
</head>
<script>
var ventanaCambio = false; var vt;
function tigra_tables (
		str_tableid, // table id (req.)
		num_header_offset, // how many rows to skip before applying effects at the begining (opt.)
		num_footer_offset, // how many rows to skip at the bottom of the table (opt.)
		str_odd_color, // background color for odd rows (opt.)
		str_even_color, // background color for even rows (opt.)
		str_mover_color, // background color for rows with mouse over (opt.)
		str_onclick_color // background color for marked rows (opt.)
	) {
	// validate required parameters
	if (!str_tableid) return alert ("No table(s) ID specified in parameters");
	var obj_tables = (document.all ? document.all[str_tableid] : document.getElementById(str_tableid));
	if (!obj_tables) return alert ("Can't find table(s) with specified ID (" + str_tableid + ")");
	// set defaults for optional parameters
	var col_config = [];
	col_config.header_offset = (num_header_offset ? num_header_offset : 0);
	col_config.footer_offset = (num_footer_offset ? num_footer_offset : 0);
	col_config.odd_color = (str_odd_color ? str_odd_color : '#ffffff');
	col_config.even_color = (str_even_color ? str_even_color : '#ffffff');
	col_config.mover_color = (str_mover_color ? str_mover_color : '#d8e0ec');
	col_config.onclick_color = (str_onclick_color ? str_onclick_color : '#cde0f3');
	// init multiple tables with same ID
	if (obj_tables.length)
		for (var i = 0; i < obj_tables.length; i++)
			tt_init_table(obj_tables[i], col_config);
	// init single table
	else
		tt_init_table(obj_tables, col_config);
}
function tt_init_table (obj_table, col_config) {
	var col_lconfig = [],
		col_trs = obj_table.rows;
	if (!col_trs) return;
	for (var i = col_config.header_offset; i < col_trs.length - col_config.footer_offset; i++) {
		col_trs[i].config = col_config;
		col_trs[i].lconfig = col_lconfig;
		col_trs[i].set_color = tt_set_color;
		col_trs[i].onmouseover = tt_mover;
		col_trs[i].onmouseout = tt_mout;
	//	col_trs[i].onmousedown = tt_onclick;
		col_trs[i].order = (i - col_config.header_offset) % 2;
		col_trs[i].onmouseout();
	}
}
function tt_set_color(str_color) {
	this.style.backgroundColor = str_color;
}
// event handlers
function tt_mover () {
	if (this.lconfig.clicked != this)
		this.set_color(this.config.mover_color);
}
function tt_mout () {
	if (this.lconfig.clicked != this)
		this.set_color(this.order ? this.config.odd_color : this.config.even_color);
}
function tt_onclick () {
	if (this.lconfig.clicked == this) {
		this.lconfig.clicked = null;
		this.onmouseover();
	}
else {
	var last_clicked = this.lconfig.clicked;
	this.lconfig.clicked = this;
	if (last_clicked) last_clicked.onmouseout();
	this.set_color(this.config.onclick_color);
}
}
function formato_bch(cta) {var cta_aux=""; var ceros="000000000000"; for(var i=0;i<cta.length;i++) { caracter = cta.substring(i,i+1); if(caracter!="-") cta_aux = cta_aux + cta.substring(i,i+1); } cta_aux = ceros.substring(0, 12 - cta_aux.length) + cta_aux; cta_aux = cta_aux.substring(0,2) + "-"+ cta_aux.substring(2,5) + "-"+ cta_aux.substring(5,10)+"-"+ cta_aux.substring(10,12); return(cta_aux); }
function eje_cgi_bae(f,ref,btn,tipo){ref.href=f.action + "?" + btn + "=" + f.lst_capbae.options[f.lst_capbae.selectedIndex].text+"&tipo="+tipo;}
function exec_cgilir(f,op) { var cta_aux=""; cta_aux=formato_bch(op.lst_cta.options[op.lst_cta.selectedIndex].text); f.href="/cgi-bin/cgi_liqremuis?tipo=LIR&llave=" + cta_aux }
function exec_cart_ins(f, valor, ref, lst, btn) { ref.href="/cgi-bin/cart_inst_mn?" + btn + "=" + valor + "&" + lst + "=" + f.lst_cta.options[f.lst_cta.selectedIndex].text }
function cambiarBoton(n, ProxUrl){ if (n==0){ ventanaCambio = false; document.forms[0].action = ProxUrl; document.forms[0].submit(); } else{ ventaCambio = true; vt = window.open(ProxUrl, "vt", "width=300,height=240"); }} function cambiarVent(ProxUrl){ if (!ventanaCambio) cambiarBoton(1, ProxUrl); else vt.focus(); } function MandarGalleta(nombre, valor, path) { document.cookie = nombre + "=" + escape(valor) + ((path == null) ? "" : "; path=" + path); } function enviarTr(f,ref,tipo) { MandarGalleta("Flag","0","/"); ref.href="/cgi-bin/cgietar?tarjeta="+f.lst_cta.options[f.lst_cta.selectedIndex].text + "&tipo_tar=" + tipo; } function changeImg(ID,Name){ agent = navigator.userAgent; browser_version = 2; if (navigator.appVersion.substring(0,1) < "3") { browser_version = 2; } else { browser_version = 1; } if (browser_version == 1) { window.document.images[ID].src = eval(Name + ".src") } } agent=navigator.userAgent; browser_version=2; if (navigator.appVersion.substring(0,1) < "3"){ browser_version = 2; } else { browser_version = 1; } function abrir3(f,url) { url=url+"="+f.cta_pac.options[f.cta_pac.selectedIndex].text; window.open(url,"buscar", "resizable=no,menubar=no,location=no,toolbar=no,status=no,scrollbars=no,directories=no,width=430,height=400"); } function abrir1(f) { document.forms["PAC"].target="nuevo"; f.href="/cgi-bin/cgivpac2_act" + "?" + "tkn_pac" + "=" + document.forms["PAC"].cta_pac.options[document.forms["PAC"].cta_pac.selectedIndex].value + "&cuenta" + "=" + document.forms["PAC"].cta_pac.options[document.forms["PAC"].cta_pac.selectedIndex].text+"&llamado=1"; MM_openBrWindow('/cgi-bin/navega?pagina=ventapac/pop_servi_benef','Beneficios','width=430,height=400'); }
function exec_cgiBridge(f, llamada, ref) { ref.href="/cgi-bin/cgiBridge" + "?" + "parametros=" + f.lst_cta.options[f.lst_cta.selectedIndex].text + "&idLlamada=" + llamada }
function exec_cgicarpac(f) { f.href="/cgi-bin/carpac_act" + "?" + "tkn=" + document.forms["PAC"].cta_pac.options[document.forms["PAC"].cta_pac.selectedIndex].value + "&cuenta=" + document.forms["PAC"].cta_pac.options[document.forms["PAC"].cta_pac.selectedIndex].text } function exec_lc(f, valor, ref, lst, btn) { var cta_aux=""; cta_aux=formato_bch(f.lst_cta.options[f.lst_cta.selectedIndex].text); ref.href="/cgi-bin/cgi_carch12?"+"tipo"+"="+btn+ "&llave=" + cta_aux }
function exec_cgioncpac(f) { f.href="/cgi-bin/onc01_act" + "?" + "tkn=" + document.forms["PAC"].cta_pac.options[document.forms["PAC"].cta_pac.selectedIndex].value + "&cuenta=" + document.forms["PAC"].cta_pac.options[document.forms["PAC"].cta_pac.selectedIndex].text+"&origen=0"; } function exec_cgipac(f, ref, cgi, lst,tk) { ref.href=cgi + "?" + tk + "=" + document.forms["PAC"].cta_pac.options[document.forms["PAC"].cta_pac.selectedIndex].value + "&" + lst + "=" + f.cta_pac.options[f.cta_pac.selectedIndex].text+"&llamado=0"; } function exec_cgiref_ahorro(f,ref,par) { ref.href="/cgi-bin/cgiahb" + "?" + "prod=" + f.lst_cta.options[f.lst_cta.selectedIndex].value + "&sel_serv=" + par + "&tar_ahb=" + f.lst_cta.options[f.lst_cta.selectedIndex].text; } function h_exec_cgiref(f, valor, ref, lst, btn) { ref.href="/cgi-bin/cgi_hmn_act2" + "?" + btn + "=" + valor + "&" + lst + "=" + f.lst_cta.options[f.lst_cta.selectedIndex].text; } function exec_cgiref3(f, valor, ref, lst, btn) { ref.href=f.action + "2?" + btn + "=" + valor + "&" + lst + "=" + f.lst_cta.options[f.lst_cta.selectedIndex].text } function exec_cgiref(f, valor, ref, lst, btn) { ref.href=f.action + "?" + btn + "=" + valor + "&" + lst + "=" + f.lst_cta.options[f.lst_cta.selectedIndex].text; } function exec_formato_bch(f, ref, cgi, lst) { var cta_aux=""; cta_aux=formato_bch(f.lst_cta.options[f.lst_cta.selectedIndex].text); ref.href=cgi + "?" + lst + "=" + cta_aux; }
function exec_cons(f, ref, cgi, lst,tarj) { ref.href=cgi + "?" + lst + f.lst_cta.options[f.lst_cta.selectedIndex].text + tarj } function eje_cgi_llave(f, ref, btn) { ref.href=f.action + "?" + btn + "=" + f.lst_cta.options[f.lst_cta.selectedIndex].text } function eje_cgi_j2ee(f, ref, btn) { ref.href=f.action + "?url=" + btn + "=" + f.lst_cta.options[f.lst_cta.selectedIndex].text } function envio(){ } function eje_cgi_llave1(f, ref, btn ) { if(f.lst_cta.options[f.lst_cta.selectedIndex].value!="WAP") { ref.href="/cgi-bin/cgi_capval_rnew" + "?" + btn + "=" + f.lst_cta.options[f.lst_cta.selectedIndex].text + "&Recalcular=0"; return true; } else{ ref.href="javascript:envio()"; return false; } }
function eje_cgi_llave2(f, ref, btn ) { if(f.lst_cta.options[f.lst_cta.selectedIndex].value!="WAP") ref.href=f.action + "lst" + "?" + btn + "=" + f.lst_cta.options[f.lst_cta.selectedIndex].text; else{ ref.href="/cgi-bin/cgi_capresbae" + "?" + btn + "=" + f.lst_cta.options[f.lst_cta.selectedIndex].text.substring(5,f.lst_cta.options[f.lst_cta.selectedIndex].text.length)+"&tipo=otrobae"; } } function eje_cgi_llave2_res(f, ref, btn ) { var tipo="BCH"; if(f.lst_cta.options[f.lst_cta.selectedIndex].value=="WAP") tipo="BAE"; ref.href=f.action + "lst" + "?" + btn + "=" + f.lst_cta.options[f.lst_cta.selectedIndex].text.substring(5,f.lst_cta.options[f.lst_cta.selectedIndex].text.length)+"&tipo="+tipo; } function eje_cgi_llave3_mixto(f, ref, btn ) { ref.href="/cgi-bin/cgi_capresmix" + "?" + btn + "=" + f.lst_cta.options[f.lst_cta.selectedIndex].text+"&tipo=MIX";}
function eje_cgi_llave3(f, ref, btn ) {  var tipo="BCH"; if(f.lst_cta.options[f.lst_cta.selectedIndex].value=="WAP") { ref.href=f.action + "resbae" + "?" + btn + "=" + f.lst_cta.options[f.lst_cta.selectedIndex].text+"&tipo=invcapbae"; } else { ref.href=f.action + "resmix" + "?" + btn + "=" + f.lst_cta.options[f.lst_cta.selectedIndex].text+"&tipo="+tipo; } } function eje_cgi_llave4(f, ref, btn ) { ref.href=f.action + "log"; } function eje_cgi_llave5(f, ref,  cgi, lst ) { ref.href=cgi + "?" + lst + "=" + f.lst_cta.options[f.lst_cta.selectedIndex].text; } function eje_cgi_llave6(f, ref, btn ) { if(f.lst_cta.options[f.lst_cta.selectedIndex].value!="WAP") { ref.href=f.action.substring(0,f.action.length-3) + "validanew" + "?" + btn + "=" + f.lst_cta.options[f.lst_cta.selectedIndex].text; return true; } else{ ref.href="javascript:envio()";  return false; } }
function eje_cgi(f, ref) { ref.href=f.action; } function eje_prueba(f, ref, btn) { ref.href=f.action + "?" + btn + "=" + f.llave.options[f.llave.selectedIndex].text; ref.target="_top"; } function MM_openBrWindow(theURL,winName,features) { VO = window.open(theURL,"VO",features); } function MFZ_openBrWindow(theURL,winName,features) { V9 = window.open(theURL,"V9",features); } function exec_cginov01(f) { f.href="/cgi-bin/cginov01?vnt=0"; } function exec_cginov02(f) { f.href="/cgi-bin/cginov02?vnt=0"; } function CgiNov01() { document.forms[0].action="/cgi-bin/cginov01"; document.forms[0].submit(); }
function exec_cgiref2(f, valor, ref, lst, btn) {ref.href=f.action + "?" + btn + "=" + valor + "&" + lst + "=" + f.lst_cta.options[f.lst_cta.selectedIndex].text + "&portal=PER"}
function exec_estado(f, tipo, ref) { var cta_aux="",cta=""; var caracter=""; cta=f.lst_cta.options[f.lst_cta.selectedIndex].text; for(var i=0;i<cta.length;i++) { caracter = cta.substring(i,i+1); if(caracter!="-") cta_aux = cta_aux + cta.substring(i,i+1); } ref.href="/cgi-bin/cgip_ect?tarjeta=" + tipo + cta_aux + "&consulta=N"; }
function exec_cart_his(f, valor, ref, lst, btn) { ref.href="/cgi-bin/cart_hist_mn?" + btn + "=" + valor + "&" + lst + "=" + f.lst_cta.options[f.lst_cta.selectedIndex].text; }
function dar_foco(valor) { self.scrollTo(1,100*valor-125); }
</script>
<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" background="fondo_pag.gif">

<div align="center">
	<table width="156" border="0" cellspacing="0" cellpadding="0">
		<tr>
			<td colspan="3"><img src="../images/TopMenuIzq_MG.jpg" width="156" height="20"></td>
		</tr>
		<tr>
			<td width="1" height="20" class="pixelizquierdo">&nbsp;</td>
			<td width="153" class="activando">
			<a HREF="#" OnClick="jcAbrirURLFrame(parent.frames['Contenido'], 'EstatusCartJud.asp');">Estatus Cartera</a>
			</td>
			<td width="1" height="20" class="pixelderecho">&nbsp;</td>
		</tr>
		<tr>
			<td width="1" height="20" class="pixelizquierdo">&nbsp;</td>
			<td width="153" class="activando">
			<a HREF="#" OnClick="jcAbrirURLFrame(parent.frames['Contenido'], 'principal.asp');">Principal</a>
			</td>
			<td width="1" height="20" class="pixelderecho">&nbsp;</td>
		</tr>
		<tr>
			<td width="1" height="20" class="pixelizquierdo">&nbsp;</td>
			<td width="153" class="activando">
			<a HREF="#" OnClick="jcAbrirURLFrame(parent.frames['Contenido'], 'cartera_asignada.asp');">Cartera Asignada</a>
			</td>
			<td width="1" height="20" class="pixelderecho">&nbsp;</td>
		</tr>
		<tr>
			<td width="1" height="20" class="pixelizquierdo">&nbsp;</td>
			<td width="153" class="activando">
			<a HREF="#" OnClick="jcAbrirURLFrame(parent.frames['Contenido'], 'scg_ingreso.asp?intNuevo=1&strRutDeudor=<%=rut%>');">Nuevo Cliente - Deuda</a>
			</td>
			<td width="1" height="20" class="pixelderecho">&nbsp;</td>
		</tr>
		<tr>
			<td width="1" height="20" class="pixelizquierdo">&nbsp;</td>
			<td width="153" class="activando">
			<a HREF="#" OnClick="jcAbrirURLFrame(parent.frames['Contenido'], 'busqueda.asp');">Busqueda Deudor</a>
			</td>
			<td width="1" height="20" class="pixelderecho">&nbsp;</td>
		</tr>

		<tr>
			<td colspan="3" background="fon2be.gif" class="submenu"><img src="bordeabajo.gif" width="155" height="7"></td>
		</tr>
		<tr>
			<td colspan="3" bgcolor="#FFFFFF">&nbsp;</td>
		</tr>
	</table>
</div>




<div align="center">
	<table width="156" border="0" cellspacing="0" cellpadding="0" id="demo1_table">
		<tr>
			<td colspan="3"><img src="../images/TopMenuIzq_MI.jpg" width="156" height="20"></td>
		</tr>
		<tr>
			<td width="1" height="20" class="pixelizquierdo">&nbsp;</td>
			<td width="153" class="activando">
			<a HREF="#" OnClick="jcAbrirURLFrame(parent.frames['Contenido'], 'mis_gestiones.asp?codcob=<%=LTRIM(RTRIM(session("session_login")))%>');">Gestiones</a>
			</td>
			<td width="1" height="20" class="pixelderecho">&nbsp;</td>
		</tr>

		<tr>
			<td width="1" height="20" class="pixelizquierdo">&nbsp;</td>
			<td width="153" class="activando">
			<a HREF="#" OnClick="jcAbrirURLFrame(parent.frames['Contenido'], 'Informe_Gestiones_Jud.asp');">Gestiones Por Dia</a>
			</td>
			<td width="1" height="20" class="pixelderecho">&nbsp;</td>
		</tr>

		<tr>
			<td width="1" height="20" class="pixelizquierdo">&nbsp;</td>
			<td width="153" class="activando">
			<a HREF="#" OnClick="jcAbrirURLFrame(parent.frames['Contenido'], 'informe_metas.asp');">Metas</a>
			</td>
			<td width="1" height="20" class="pixelderecho">&nbsp;</td>
		</tr>


		<tr>
			<td width="1" height="20" class="pixelizquierdo">&nbsp;</td>
			<td width="153" class="activando">
			<a HREF="#" OnClick="jcAbrirURLFrame(parent.frames['Contenido'], 'informe_recupero.asp');">Recuperaci&oacute;n</a>
			</td>
			<td width="1" height="20" class="pixelderecho">&nbsp;</td>
		</tr>
		<tr>
			<td colspan="3" background="fon2be.gif" class="submenu"><img src="bordeabajo.gif" width="155" height="7"></td>
		</tr>
		<tr>
			<td colspan="3" bgcolor="#FFFFFF">&nbsp;</td>
		</tr>
	</table>
</div>






<div align="center">

<table width="156" border="0" cellspacing="0" cellpadding="0" id="demo1_table">
<tr>
<td colspan="3"><img src="../images/TopMenuIzq_MP.jpg" width="156" height="20"></td>
</tr>
<tr>



<%

If TraeSiNo(session("perfil_caja")) = "Si" Then %>

<tr>
	<td width="1" height="20" class="pixelizquierdo">&nbsp;</td>
	<td width="153" class="activando">
	<a HREF="#" OnClick="jcAbrirURLFrame(parent.frames['Contenido'], 'caja/caja_web.asp');">Ingreso de Pagos</a>
	</td>
	<td width="1" height="20" class="pixelderecho">&nbsp;</td>
</tr>
<tr>
	<td width="1" height="20" class="pixelizquierdo">&nbsp;</td>
	<td width="153" class="activando">
	<a HREF="#" OnClick="jcAbrirURLFrame(parent.frames['Contenido'], 'rendicion_caja.asp');">Informe Rendiciones</a>
	</td>
	<td width="1" height="20" class="pixelderecho">&nbsp;</td>
</tr>
<tr>
	<td width="1" height="20" class="pixelizquierdo">&nbsp;</td>
	<td width="153" class="activando">
	<a HREF="#" OnClick="jcAbrirURLFrame(parent.frames['Contenido'], 'caja/detalle_caja.asp');">Listado de Pagos</a>
	</td>
	<td width="1" height="20" class="pixelderecho">&nbsp;</td>
</tr>

<% End If%>

<tr>
<td colspan="3" background="fon2be.gif" class="submenu"><img src="bordeabajo.gif" width="155" height="7"></td>
</tr>
<tr>
<td colspan="3" bgcolor="#FFFFFF">&nbsp;</td>
</tr>
  </table>
</div>


<div align="center">

<table width="156" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td colspan="3"><img src="../images/TopMenuIzq_MA.jpg" width="156" height="20"></td>
	</tr>
	<tr>
		<td width="1" height="20" class="pixelizquierdo">&nbsp;</td>
		<td width="153" class="activando">
		<a HREF="#" OnClick="jcAbrirURLFrame(parent.frames['Contenido'], 'MenuAdm.asp');">Administración</a>
		</td>
		<td width="1" height="20" class="pixelderecho">&nbsp;</td>
	</tr>
	<tr>
		<td width="1" height="20" class="pixelizquierdo">&nbsp;</td>
		<td width="153" class="activando">
		<a HREF="#" OnClick="jcAbrirURLFrame(parent.frames['Contenido'], 'Asigna_masiva.asp');">Asignacion Masiva</a>
		</td>
		<td width="1" height="20" class="pixelderecho">&nbsp;</td>
	</tr>
	<tr>
		<td width="1" height="20" class="pixelizquierdo">&nbsp;</td>
		<td width="153" class="activando">
		<a HREF="#" OnClick="jcAbrirURLFrame(parent.frames['Contenido'], 'Asigna_manual.asp');">Asignacion Individual</a>
		</td>
		<td width="1" height="20" class="pixelderecho">&nbsp;</td>
	</tr>
	<tr>
		<td width="1" height="20" class="pixelizquierdo">&nbsp;</td>
		<td width="153" class="activando">
		<a HREF="#" OnClick="jcAbrirURLFrame(parent.frames['Contenido'], 'cbdd02.asp');">Cerrar Sesión</a>
		</td>
		<td width="1" height="20" class="pixelderecho">&nbsp;</td>
	</tr>
	<tr>
		<td colspan="3" background="fon2be.gif" class="submenu"><img src="bordeabajo.gif" width="155" height="7"></td>
	</tr>
	<tr>
		<td colspan="3" bgcolor="#FFFFFF">&nbsp;</td>
	</tr>
</table>
</div>



<script language="JavaScript" class="bordeceleste">
<!--
tigra_tables('demo1_table', 0, 0, '', '', '', '');
// -->
</script>
<script language="JavaScript" class="bordeceleste">
function jcAbrirURLFrame(frame_contenido, URL)  {

  //Cambia location para ejecutar busqueda
  frame_contenido.location.href = URL;
  return false;
}
</script>

	<!--
currentLevel=0
currentNumber=0
totalmodulos=10
nromodulos=8
factor=1
parseInt=0
-->
</body>
</html>
