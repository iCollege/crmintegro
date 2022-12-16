<%@ LANGUAGE="VBScript" %>
<!--#include file="sesion.asp"-->
<!--#include file="asp/comunes/general/rutinasBooleano.inc"-->

<%

%>

<HTML>

<HEAD><TITLE>Menú</TITLE>
<LINK rel="stylesheet" TYPE="text/css" HREF="isk_style.css">
</HEAD>

<BODY>

<TABLE ALIGN="CENTER" BORDER=0 CELLSPACING=0 CELLPADDING=0 WIDTH="600" CLASS="tabla1">
<TR HEIGHT="30">
	<TD align="CENTER">
		MODULO ADMINISTRACIÓN
    </TD>
</TR>
</TABLE>

<table ALIGN="CENTER" WIDTH="600" border="0" CLASS="tabla1">
<tr BGCOLOR="#FFFFFF">
	<td class="hdr_i" width="21">
		<img src='../images/boton_no_1.gif' align='absmiddle'>
	</td>
	<td class="hdr_i" width="100">
		General
	</td>
	<td class="hdr" width="21">
		<img src='../images/cuadrado_t1.gif' align='absmiddle'>
	</td>
	<td class="hdr_i" width="300">
	<% If TraeSiNo(session("perfil_full"))="Si" Then %>
		<A HREF="man_Usuario.asp">
			Mantenedor de Usuarios
		</A>
	<% End If%>
	</td>
</tr>

<tr BGCOLOR="#FFFFFF">
	<td class="hdr_i" width="21">
		&nbsp
	</td>
	<td class="hdr_i" width="100">
		&nbsp
	</td>
	<td class="hdr" width="21">
		<img src='../images/cuadrado_t1.gif' align='absmiddle'>
	</td>
	<td class="hdr_i" width="300">
		<A HREF="man_Cliente.asp">
			Mantenedor de Mandantes
		</A>
	</td>
</tr>


<tr BGCOLOR="#FFFFFF">
	<td class="hdr_i" width="21">
		&nbsp
	</td>
	<td class="hdr_i" width="100">
		&nbsp
	</td>
	<td class="hdr" width="21">
		<img src='../images/cuadrado_t1.gif' align='absmiddle'>
	</td>
	<td class="hdr_i" width="300">
		<A HREF="man_Remesa.asp">
			Mantenedor de Asignaciones
		</A>
	</td>
</tr>

<tr BGCOLOR="#FFFFFF">
	<td class="hdr_i" width="21">
		&nbsp
	</td>
	<td class="hdr_i" width="100">
		&nbsp
	</td>
	<td class="hdr" width="21">
		<img src='../images/cuadrado_t1.gif' align='absmiddle'>
	</td>
	<td class="hdr_i" width="300">
		<A HREF="man_Carga.asp">
			Modulo de cargas y actualizacion
		</A>
	</td>
</tr>

<tr BGCOLOR="#FFFFFF">
	<td class="hdr_i" width="21">
		&nbsp
	</td>
	<td class="hdr_i" width="100">
		&nbsp
	</td>
	<td class="hdr" width="21">
		<img src='../images/cuadrado_t1.gif' align='absmiddle'>
	</td>
	<td class="hdr_i" width="300">
		<A HREF="man_Export.asp">
			Exportación documentos y gestiones
		</A>
	</td>
</tr>


<tr BGCOLOR="#FFFFFF">
	<td colspan=4 class="hdr_i" >
		&nbsp
	</td>
</tr>

<tr BGCOLOR="#FFFFFF">
	<td class="hdr_i" width="21">
		<img src='../images/boton_no_2.gif' align='absmiddle'>
	</td>
	<td class="hdr_i" width="100">
		Demandas
	</td>
	<td class="hdr" width="21">
		<img src='../images/cuadrado_t1.gif' align='absmiddle'>
	</td>
	<td class="hdr_i" width="300">
		<A HREF="man_Abogado.asp">
			Mantenedor de Abogados
		</A>
	</td>
</tr>
<!---tr BGCOLOR="#FFFFFF">
	<td class="hdr_i" width="21">
		&nbsp
	</td>
	<td class="hdr_i" width="100">
		&nbsp
	</td>
	<td class="hdr" width="21">
		<img src='../images/cuadrado_t1.gif' align='absmiddle'>
	</td>
	<td class="hdr_i" width="300">
		<A HREF="man_procurador.asp">
			Mantenedor de Procuradores
		</A>
	</td>
</tr--->
<tr BGCOLOR="#FFFFFF">
	<td class="hdr_i" width="21">
		&nbsp
	</td>
	<td class="hdr_i" width="100">
		&nbsp
	</td>
	<td class="hdr" width="21">
		<img src='../images/cuadrado_t1.gif' align='absmiddle'>
	</td>
	<td class="hdr_i" width="300">
		<A HREF="man_Actuario.asp">
			Mantenedor de Actuarios
		</A>
	</td>
</tr>
<tr BGCOLOR="#FFFFFF">
	<td class="hdr_i" width="21">
		&nbsp
	</td>
	<td class="hdr_i" width="100">
		&nbsp
	</td>
	<td class="hdr" width="21">
		<img src='../images/cuadrado_t1.gif' align='absmiddle'>
	</td>
	<td class="hdr_i" width="300">
		<A HREF="man_tribunal.asp">
			Mantenedor de Tribunales
		</A>
	</td>
</tr>
<tr BGCOLOR="#FFFFFF">
	<td class="hdr_i" width="21">
		&nbsp
	</td>
	<td class="hdr_i" width="100">
		&nbsp
	</td>
	<td class="hdr" width="21">
		<img src='../images/cuadrado_t1.gif' align='absmiddle'>
	</td>
	<td class="hdr_i" width="300">
		<A HREF="man_Demanda.asp">
			Administracion Demandas
		</A>
	</td>
</tr>
<tr BGCOLOR="#FFFFFF">
	<td colspan=4 class="hdr_i" >
		&nbsp
	</td>
</tr>

<table ALIGN="CENTER" WIDTH="600" border="0" CLASS="tabla1">
<tr BGCOLOR="#FFFFFF">
	<td class="hdr_i" width="21">
		<img src='../images/boton_no_3.gif' align='absmiddle'>
	</td>
	<td class="hdr_i" width="100">
		BackOffice
	</td>
	<td class="hdr" width="21">
		<img src='../images/cuadrado_t1.gif' align='absmiddle'>
	</td>
	<!--td class="hdr_i" width="300">
		<A HREF="informe_demandas.asp?intGestion=4&intEjecutivo=&intDePPal=1">
			Informe para imprimir demandas
		</A>
	</td-->
	<td class="hdr_i" width="300">
		<A HREF="informe_generico.asp?intGestion=4&intEjecutivo=&intDePPal=1&intTipoInforme=">
			Informe para imprimir Demandas
		</A>
	</td>
</tr>

<tr BGCOLOR="#FFFFFF">
	<td class="hdr_i" width="21">
		&nbsp
	</td>
	<td class="hdr_i" width="100">
		&nbsp
	</td>
	<td class="hdr" width="21">
		<img src='../images/cuadrado_t1.gif' align='absmiddle'>
	</td>
	<td class="hdr_i" width="300">
		<A HREF="informe_generico.asp?intGestion=4&intEjecutivo=&intDePPal=1&intTipoInforme=1&intParaCarta=1">
			Informe para imprimir Cartas
		</A>
	</td>
</tr>

<tr BGCOLOR="#FFFFFF">
	<td class="hdr_i" width="21">
		&nbsp
	</td>
	<td class="hdr_i" width="100">
		&nbsp
	</td>
	<td class="hdr" width="21">
		<img src='../images/cuadrado_t1.gif' align='absmiddle'>
	</td>
	<td class="hdr_i" width="300">
		<A HREF="informe_generico.asp?intGestion=4&intEjecutivo=&intDePPal=1&intTipoInforme=2">
			Informe de Pagos
		</A>
	</td>
</tr>

<tr BGCOLOR="#FFFFFF">
	<td class="hdr_i" width="21">
		&nbsp
	</td>
	<td class="hdr_i" width="100">
		&nbsp
	</td>
	<td class="hdr" width="21">
		<img src='../images/cuadrado_t1.gif' align='absmiddle'>
	</td>
	<!--td class="hdr_i" width="300">
		<A HREF="informe_seguimiento_pagos.asp?intGestion=4&intEjecutivo=&intDePPal=1&intParaCarta=1">
			Informe para seguimiento de pagos
		</A>
	</td-->
	<td class="hdr_i" width="300">
		<A HREF="informe_generico.asp?intGestion=4&intEjecutivo=&intDePPal=1&intTipoInforme=3">
			Informe de Retiros
		</A>
	</td>
</tr>

</Table>

