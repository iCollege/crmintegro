<% @LCID = 1034 %>
<!--#include file="asp/comunes/general/rutinasBooleano.inc"-->
<!--#include file="arch_utils.asp"-->
<html xmlns="http://www.w3.org/1999/xhtml">
  <head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<title>Slashdot's Menu</title>
	<link rel="stylesheet" type="text/css" href="sdmenu/sdmenu.css" />
	<script type="text/javascript" src="sdmenu/sdmenu.js">
		/***********************************************
		* Slashdot Menu script- By DimX
		* Submitted to Dynamic Drive DHTML code library: http://www.dynamicdrive.com
		* Visit Dynamic Drive at http://www.dynamicdrive.com/ for full source code
		***********************************************/
	</script>
	<script type="text/javascript">
	// <![CDATA[
	var myMenu;
	window.onload = function() {
		myMenu = new SDMenu("my_menu");
		myMenu.init();
	};
	// ]]>
	</script>
	<script type="text/javascript">
	function ventanaBiblioteca (URL){
	window.open(URL,"INFORMACION","width=1000, height=500, scrollbars=yes, menubar=no, location=no, resizable=yes")
	}
	</script>

</head>
<%
	AbrirSCG()
	strSql = "SELECT ID_CONVENIO FROM CONVENIO_ENC WHERE COD_CLIENTE = '" & session("ses_codcli") & "' AND COD_ESTADO_FOLIO IN (1,2)"
	set rsConv=Conn.execute(strSql)
	If not rsConv.eof then
		strMuestrMsj = "<img src='..\images\bolitaRojaFondoBlanco.gif' border=0>"
	End If
	CerrarSCG()

%>
  <body>
    <div style="float: left" id="my_menu" class="sdmenu">
	<div>
		<span>Mod. Gestion</span>

		<a href="principal.asp" target='Contenido'>Principal</a>
		<a href="EstatusCartera.asp" target='Contenido'>Estatus Cartera</a>
		<a href="EstatusClientes.asp" target='Contenido'>Estatus Clientes</a>
		<a href="cartera_asignada.asp?strBuscar=N" target='Contenido'>Cartera Asignada</a>
		<% If TraeSiNo(session("perfil_emp")) <> "Si" Then %>
			<% If TraeSiNo(session("perfil_adm"))="Si" Then %>
				<a href="scg_ingreso.asp?intNuevo=1&strRutDeudor=<%=rut%>" target='Contenido'>Nuevo Cliente - Deuda</a>
			<% End If %>
			<a href="busqueda.asp" target='Contenido'>Busqueda Deudor</a>
		<% End If %>
		<a href="javascript:ventanaBiblioteca('biblioteca_clientes.asp')">Biblioteca clientes</a>

	</div>

	<% 'If TraeSiNo(session("perfil_emp")) <> "Si" Then %>
	<div>
		<span>Mod.Informes</span>
		<a href="mis_gestiones.asp?codcob=<%=LTRIM(RTRIM(session("session_login")))%>" target='Contenido'>Gestiones</a>
		<a href="Informe_Gestiones_Jud.asp" target='Contenido'>Gestiones Por Dia</a>
		<!--a href="informe_metas.asp" target='Contenido'>Metas</a-->
		<a href="informe_recupero.asp" target='Contenido'>Recuperaci&oacute;n</a>
		<a href="informe_campanas.asp" target='Contenido'>Campanas</a>
		<a href="informe_retiros.asp" target='Contenido'>Retiros</a>
		<a href="informe_agen_comp.asp" target='Contenido'>Agendamientos</a>
		<% If TraeSiNo(session("perfil_proc")) = "Si" Then %>
			<a href="mis_gestiones_judiciales.asp?codcob=<%=LTRIM(RTRIM(session("session_login")))%>" target='Contenido'>Gestiones Judiciales</a>
			<a href="informe_comparendos.asp" target='Contenido'>Comparendos</a>
		<% End If%>




	</div>
	<% 'End if%>
	<% If TraeSiNo(session("perfil_caja"))="Si" Then%>
	<div>
		<span>Mod. Caja</span>
		<% If TraeSiNo(session("perfil_emp")) <> "Si" Then %>
		<a href="apertura_caja.asp" target='Contenido'>Apertura Caja</a>
		<a href="caja_web.asp" target='Contenido'>Ingreso de Pagos</a>
		<a href="cerrar_caja_web.asp" target='Contenido'>Cuadruatura y Cierre</a>
		<% End If %>
		<a href="detalle_caja.asp" target='Contenido'>Listado de Pagos</a>
		<a href="detalle_cuadratura.asp" target='Contenido'>Detalle Pagos</a>
		<% If TraeSiNo(session("perfil_emp")) <> "Si" Then %>
		<a href="detalle_cheques.asp" target='Contenido'>Listado de Cheques</a>
		<% End If %>

	</div>
	<% End If%>
	<% If 1=2 Then %>
	<div>
		<span>Mod. Rendiciones</span>
		<a href="rendicion_caja_inf2.asp" target='Contenido'>Informe Rendiciones</a>
	</div>
	<%
	End If
	If TraeSiNo(session("perfil_caja"))="Si" or TraeSiNo(session("perfil_emp"))="Si" Then%>
	<div>
		<span>Mod.<%=session("NOMBRE_CONV_PAGARE")%>&nbsp;<%=strMuestrMsj%></span>
		<a href="simulacion_convenio.asp" target='Contenido'><%=session("NOMBRE_CONV_PAGARE")%></a>
		<% If TraeSiNo(session("perfil_adm"))="Si" and 1=2 Then %>
			<a href="simulacion_convenio_sr.asp" target='Contenido'><%=session("NOMBRE_CONV_PAGARE")%> Manual</a>
		<% End if%>
		<a href="detalle_convenio.asp" target='Contenido'>Listado <%=session("NOMBRE_CONV_PAGARE")%>s</a>
		<a href="detalle_convenio.asp?strTipo=EP" target='Contenido'><%=session("NOMBRE_CONV_PAGARE")%>s Pendientes<%=strMuestrMsj%></a>
		<a href="convenios_vencidos.asp?strAgrupado=S" target='Contenido'>
		<%=session("NOMBRE_CONV_PAGARE")%>s Vencidos</a>
		<% If TraeSiNo(session("perfil_adm"))="Si" or TraeSiNo(session("perfil_caja"))="Si" or TraeSiNo(session("perfil_sup"))="Si" or TraeSiNo(session("perfil_supterr"))="Si" Then %>
			<a href="detalle_caja.asp?CB_TIPOPAGO=CO" target='Contenido'>Listado de Pagos</a>
		<% End If%>
	</div>
	<% End If%>
	<% If 1 = 2 Then %>
	<div>
		<span>Repactaciones</span>
		<a href="simulacion_repactacion.asp" target='Contenido'>Repactar</a>
		<a href="detalle_repactacion.asp" target='Contenido'>Listado Repact.</a>
		<a href="repactaciones_vencidas.asp" target='Contenido'>Repact.Vencidas.</a>
		<a href="detalle_caja.asp?CB_TIPOPAGO=RP" target='Contenido'>Listado de Pagos</a>
	</div>
	<% End If%>

	<div>
		<span>Mod. Administ.</span>
		<a href="man_CambioClave.asp" target='Contenido'>Cambio Clave</a>
		<% If TraeSiNo(session("perfil_adm"))="Si" Then %>
		<a href="MenuAdm.asp" target='Contenido'>Administracion</a>
		<a href="genera_campanas.asp" target='Contenido'>Adm. Campanas</a>
		<a href="Asigna_masiva.asp" target='Contenido'>Asignacion Masiva</a>
		<a href="Asigna_manual.asp" target='Contenido'>Asignacion Individual</a>
		<a href="utilitario_carga.asp" target='Contenido'>Utilitario</a>
		<a href="utilitario_2.asp" target='Contenido'>Utilitario por ID</a>
		<% End If%>
		<a href="cbdd02.asp" target="_top">Cerrar Sesion</a>
	</div>
   </div>

 </body>
</html>
