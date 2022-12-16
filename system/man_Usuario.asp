<%@ LANGUAGE="VBScript" %>

<% ' General ' %>
<!--#include file="asp/comunes/general/Minimo.inc"-->
<!--#include file="asp/comunes/general/JavaEfectoBotones.inc"-->
<!--#include file="asp/comunes/general/rutinasTraeCampo.inc"-->
<!--#include file="asp/comunes/general/rutinasBooleano.inc"-->
<!--#include file="sesion.asp"-->

<% ' Capa 1 ' %>
<!--#include file="asp/comunes/odbc/Adovbs.inc"-->
<!--#include file="arch_utils.asp"-->
<!--#include file="asp/comunes/odbc/ObtenerRegistros.inc"-->
<!--#include file="asp/comunes/odbc/BorrarRegistro.inc"-->
<% ' Capa 2 ' %>
<!--#include file="asp/comunes/select/UsuarioQry.inc"-->
<!--#include file="asp/comunes/delete/Usuario.inc"-->
<%
    AbrirSCG()

    ''Obtiene los parámetros
    sintPagina  = Request("sintPagina")
    If Trim(sintPagina) <> "" Then
        intIndiceFilasIni = Request("intIndiceFilasIni")
        intIndiceFilasFin = Request("intIndiceFilasFin")
        If intIndiceFilasIni <> "" Then
            ReDim sarrBorrar( 1, intIndiceFilasFin )
            ObtenerListaBorrar sarrBorrar, intIndiceFilasIni, intIndiceFilasFin
            sstrMensajeBorrar = ""
            strMsg = ""
            For intRow = intIndiceFilasIni to intIndiceFilasFin
            	'Response.write "arrborrar = " &sarrBorrar( 0, intRow )
                If sarrBorrar( 0, intRow ) = "on" Then
                    delete_Usuario Conn, sarrBorrar(1, intRow), strMsg
                    If strMsg <> "" Then sstrMensajeBorrar = sstrMensajeBorrar & " - " & strMsg & sarrBorrar(1, intRow)
                End If
            Next
        End If
    End If

    Dim sarrRegistros, sintTotalRegistros
    select_UsuarioQry Conn, " WHERE ID_USUARIO >= 100 ", sarrRegistros,  sintTotalRegistros


%>

<!--#include file="asp/comunes/General/CalculoFilasPorPagina.inc"-->

<HTML>

<HEAD><TITLE>Mantenedor</TITLE>
<LINK rel="stylesheet" TYPE="text/css" HREF="isk_style.css">
</HEAD>

<BODY>
<!--#include file="asp/comunes/General/JavaScriptBotonesMantenedor.inc"-->

<FORM NAME="mantenedorForm" method="POST" action="man_Usuario.asp" onmouseover="highlightButton('start')" onmouseout="highlightButton('')">
<INPUT TYPE=HIDDEN NAME="sintNumFilasPagina" VALUE="<%= sintNumFilasPagina %>">
<INPUT TYPE=HIDDEN NAME="sintPagina" VALUE=<%= sintPagina  %>>
<INPUT TYPE=HIDDEN NAME="intIndiceFilasIni" VALUE="<%= intIndiceFilasIni  %>">
<INPUT TYPE=HIDDEN NAME="intIndiceFilasFin" VALUE="<%= intIndiceFilasFin  %>">

<TABLE WIDTH="100%" border=0 cellspacing=0 CLASS="tabla1">
    <TR BGCOLOR="#FFFFFF" HEIGHT="30" VALIGN="MIDDLE">
        <TD colspan=3 ALIGN=CENTER>
			<B>MANTENEDOR DE USUARIOS</B>
        </TD>
    </TR>
    <TR BGCOLOR="#FFFFFF" HEIGHT="30" VALIGN="MIDDLE">
        <TD>

		</TD>
		<TD ALIGN=RIGHT>

        </TD>

        <TD ALIGN=RIGHT>
        <INPUT TYPE=BUTTON NAME="Aceptar" VALUE="Borrar" onClick="BAceptar( this.form )">
        <INPUT TYPE=BUTTON NAME="Nuevo" VALUE="Nuevo" onClick="IrNuevo( 'man_UsuarioForm.asp' )">
        <INPUT TYPE=BUTTON NAME="Terminar" VALUE="Terminar" onClick="IrTerminar('menuadm.asp')">
        </TD>
    </TR>
    <TR BGCOLOR="#F3F3F3" HEIGHT="3" VALIGN="MIDDLE">
        <TD COLSPAN=5></TD>
    </TR>
</TABLE>

<!--#include file="asp/comunes/general/BarraNavegacion.inc"-->

<TABLE BORDER=0 CELLSPACING=0 CELLPADDING=0 WIDTH="100%" CLASS="tabla1">
    <!--Encabezado-->
    <TR BGCOLOR="#F3F3F3">
    <TD><b>&nbsp;</TD>
    <TD WIDTH="10%"><b>Id</TD>
    <TD WIDTH="20%"><b>Nombre</TD>
    <TD WIDTH="10%"><b>Login</TD>
    <TD WIDTH="10%"><b>Rut</TD>
    <TD WIDTH="10%"><b>Perfil Adm</TD>
    <TD WIDTH="10%"><b>Perfil Sup</TD>
    <TD WIDTH="10%"><b>Perfil Cob</TD>
    <TD WIDTH="10%"><b>Perfil Caja</TD>
    <TD WIDTH="10%"><b>Perfil Full</TD>
    <TD WIDTH="10%"><b>Activo</TD>
    <TD><b>&nbsp;</TD>
    <TD WIDTH="5%"><center><b>Borrar<center></TD>
    </TR>

    <!--Datos-->
    <TR>
    <TD colspan=13 background="../images/arriba.jpg">
    <img border="0" src="../images/arribaizq.jpg">
    </TD>
    </TR>
<%
    For intRow = intIndiceFilasIni to intIndiceFilasFin
        If intRow Mod 2 = 0 Then
            sstrColor = "#F3F3F3"
        Else
            sstrColor = "#FFFFFF"
        End if

		If Trim(sarrRegistros(intRow).Item("ID_USUARIO"))="" or IsNull(sarrRegistros(intRow).Item("ID_USUARIO")) Then
			intID_USUARIO=0
		Else
			intID_USUARIO=sarrRegistros(intRow).Item("ID_USUARIO")
		End if
			'Response.write "<br>intID_USUARIO =" & intID_USUARIO

%>
<TR BGCOLOR="<%=sstrColor%>">
	<TD>&nbsp;</TD>
    <TD>
        <INPUT TYPE=HIDDEN NAME="sstrId<%= Cstr( intRow ) %>" VALUE="<%= Trim(sarrRegistros(intRow).Item("ID_USUARIO"))%>">
        <%= Trim(sarrRegistros(intRow).Item("ID_USUARIO")) %>
    </TD>
    <TD>
		<A HREF="man_UsuarioForm.asp?sintNuevo=0&ID_USUARIO=<%=Trim(sarrRegistros(intRow).Item("ID_USUARIO"))%>">
		<%= Trim(sarrRegistros(intRow).Item("NOMBRES_USUARIO")) & " " & Trim(sarrRegistros(intRow).Item("APELLIDOS_USUARIO"))%>
		</A>
    </TD>
    <TD>
		<%= Trim(sarrRegistros(intRow).Item("LOGIN")) %>
    </TD>
    <TD>
		<%= Trim(sarrRegistros(intRow).Item("RUT_USUARIO")) %>
    </TD>
     <TD>
		<%= TraeSiNo(Trim(sarrRegistros(intRow).Item("PERFIL_ADM"))) %>
    </TD>
    <TD>
		<%= TraeSiNo(Trim(sarrRegistros(intRow).Item("PERFIL_SUP"))) %>
    </TD>
    <TD>
		<%= TraeSiNo(Trim(sarrRegistros(intRow).Item("PERFIL_COB"))) %>
    </TD>
    <TD>
		<%= TraeSiNo(Trim(sarrRegistros(intRow).Item("PERFIL_CAJA"))) %>
    </TD>
    <TD>
		<%= TraeSiNo(Trim(sarrRegistros(intRow).Item("PERFIL_FULL"))) %>
    </TD>
    <TD>
		<%= TraeSiNo(Trim(sarrRegistros(intRow).Item("ACTIVO"))) %>
    </TD>
    <TD>&nbsp;</TD>
    <TD WIDTH="10%" ALIGN=CENTER>
    	<INPUT TYPE=checkbox NAME="borrar<%= intRow %>">
    </TD>
   </TR>
<%
    Next
%>

 <!--#include file="asp/comunes/general/BarraNavegacion.inc"-->

</FORM>
</BODY>
</HTML>
<SCRIPT>
function Refrescar(){
	mantenedorForm.action='man_Usuario.asp?intFiltro=1';
	mantenedorForm.submit();
}

</SCRIPT>
<%
	CerrarSCG()
%>


<!-- ---------------------------------------------------- -->
<SCRIPT LANGUAGE=VBScript RUNAT=Server>

Sub ObtenerListaBorrar ( ByRef sarrBorrar, ByRef Inicio, ByVal Fin)
  For i = Inicio to Fin
    sarrBorrar(0, i) = Request( "borrar" & i )
    sarrBorrar(1, i) = Request( "sstrId" & i)
  Next
End Sub

</SCRIPT>
