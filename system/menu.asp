<!--#include file="asp/comunes/general/rutinasBooleano.inc"-->
<link rel="stylesheet" type="text/css" href="menu/menu.css" />

<script src="menu/stuHover.js" type="text/javascript"></script>

<ul id="nav">
	<li class="top"><a href="#nogo22" id="Mod.Gestion" class="top_link"><span>Mod.Gestion</span></a>
		<ul class="sub">
			<li><a href="principal.asp">Principal</a></li>
			<% If TraeSiNo(session("perfil_emp")) <> "Si" Then %>
			<li><a href="EstatusClientes.asp">Estatus Clientes</a></li>
			<li><a href="cartera_asignada.asp">Cartera Asignada</a></li>
			<li><a href="busqueda.asp">Busqueda Deudor</a></li>
			<% If TraeSiNo(session("perfil_full")) = "Si" Then %>
				<li><a href="scg_ingreso.asp?intNuevo=1&strRutDeudor=<%=rut%>">Nuevo Cliente - Deuda</a></li>
			<% End If %>
			<% End If %>

		</ul>
	</li>
	<% If TraeSiNo(session("perfil_emp")) <> "Si" Then %>
	<li class="top"><a href="#nogo22" id="Mod.Informes" class="top_link"><span class="down">Mod.Informes</span></a>
		<ul class="sub">
			<li><a href="mis_gestiones.asp?codcob=<%=LTRIM(RTRIM(session("session_login")))%>">Gestiones</a></li>
			<li><a href="Informe_Gestiones_Jud.asp">Gestiones Diarias</a></li>
			<li><a href="informe_recupero.asp">Recuperaci&oacute;n</a></li>
			<li><a href="informe_campanas.asp">Campanas</a></li>
			<li><a href="informe_retiros.asp">Retiros</a></li>
			<li><a href="informe_agen_comp.asp">Agendamientos</a></li>
			<li><a href="man_Export.asp?codcob=<%=LTRIM(RTRIM(session("session_login")))%>">Exportes Generales</a></li>
			<li><a href="mi_exportes.asp?codcob=<%=LTRIM(RTRIM(session("session_login")))%>">Exportes Específicos</a></li>
		</ul>
	</li>
	<% End If %>

	<% If TraeSiNo(session("perfil_emp")) <> "Si" Then %>
		<% If TraeSiNo(session("perfil_caja"))="Si" Then%>
			<li class="top"><a href="#nogo22" id="Mod.Caja" class="top_link"><span class="down">Mod.Caja</span></a>
				<ul class="sub">

					<li><a href="apertura_caja.asp">Apertura Caja</a></li>
					<li><a href="caja_web.asp">Ingreso de Pagos</a></li>
					<li><a href="cerrar_caja_web.asp">Cuadruatura y Cierre</a></li>
					<li><a href="detalle_caja.asp">Listado de Pagos</a></li>
					<li><a href="detalle_cuadratura.asp">Detalle Pagos</a></li>
					<li><a href="detalle_cheques.asp">Listado de Cheques</a></li>
					<li><a href="#nogo3" class="fly">Rendiciones</a>
						<ul>
							<li><a href="rendicion_caja_inf2.asp">Informe Rendiciones</a></li>
						</ul>
					</li>
				</ul>
			</li>
		<% End If%>
	<% End If %>


	<% If TraeSiNo(session("perfil_emp")) <> "Si" Then %>
	<li class="top"><a href="#nogo27" id="Mod.Convenios" class="top_link"><span class="down">Mod.Convenios</span></a>
		<ul class="sub">
			<li><a href="simulacion_convenio.asp?intOrigen=CO">Convenios</a></li>
			<li><a href="simulacion_convenio_sr.asp">Convenio Manual</a></li>
			<li><a href="detalle_convenio.asp">Listado Convenios</a></li>
			<li><a href="convenios_vencidos.asp">Convenios Vencidos</a></li>
			<% If TraeSiNo(session("perfil_adm"))="Si" or TraeSiNo(session("perfil_caja"))="Si" or TraeSiNo(session("perfil_sup"))="Si" or TraeSiNo(session("perfil_supterr"))="Si" Then %>
				<li><a href="detalle_caja.asp?CB_TIPOPAGO=CO">Listado de Pagos</a></li>
			<% End If%>
			<li><a href="informe_convenios.asp">Informe Convenios</a></li>



		</ul>
	</li>

	<li class="top"><a href="#nogo27" id="Mod.Judicial" class="top_link"><span class="down">Mod.Judicial</span></a>
		<ul class="sub">
			<li><a href="man_demanda.asp">Ingreso de Demandas</a></li>
			<li><a href="#nogo3" class="fly">Informes</a>
				<ul>
					<li><a href="mis_gestiones_judiciales.asp?codcob=<%=LTRIM(RTRIM(session("session_login")))%>">Gestiones Judiciales</a></li>
					<li><a href="informe_comparendos.asp">Comparendos</a></li>
				</ul>
			</li>
				<li>
					<a href="#nogo3" class="fly">Administracion</a>
					<ul>
						<li><a href="man_abogado.asp">Adm. de Abogados</a></li>
						<li><a href="man_actuario.asp">Adm. de Actuarios</a></li>
						<li><a href="man_tribunal.asp">Adm.de Tribunales</a></li>

					</ul>
				</li>
		</ul>
	</li>

	<% End If%>
	<li class="top"><a href="#nogo27" id="Administracion" class="top_link"><span class="down">Administracion</span></a>
		<ul class="sub">

			<% If TraeSiNo(session("perfil_adm"))="Si" or TraeSiNo(session("perfil_proc"))="Si" Then %>

			<li>
				<a href="#nogo3" class="fly">Asignación - Campanas</a>
				<ul>
					<li><a href="genera_campanas.asp">Adm. Campanas</a></li>
					<li><a href="Asigna_masiva.asp">Asignacion Masiva</a></li>
					<li><a href="Asigna_manual.asp">Asignacion Individual</a></li>
				</ul>
			</li>

			<li>
				<a href="#nogo3" class="fly">General</a>
				<ul>
					<% If TraeSiNo(session("perfil_full"))="Si" Then %>
						<li><a href="man_Usuario.asp">Adm. de Usuarios</a></li>
					<% End If%>
					<li><a href="man_Cliente.asp">Adm. de Mandantes</a></li>
					<li><a href="man_remesa.asp">Adm. de Asignaciones</a></li>
				</ul>
			</li>
			<li><a href="man_Carga.asp">Cargas y actualizaciones</a></li>
			<li><a href="utilitario_carga.asp">Utilitario</a></li>
			<li><a href="utilitario_2.asp">Utilitario por id</a></li>

			<%end if%>
			<li><a href="man_CambioClave.asp">Cambio Clave</a></li>
		</ul>
	</li>
	<li class="top"><a href="cbdd02.asp" id="Ayuda" class="top_link"><span>Cerrar Sesion</span></a></li>
</ul>


