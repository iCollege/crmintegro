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
<!--#include file="asp/comunes/select/Tribunal.inc"-->
<!--#include file="asp/comunes/delete/Tribunal.inc"-->
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
                    delete_Tribunal Conn, sarrBorrar(1, intRow), strMsg
                    If strMsg <> "" Then sstrMensajeBorrar = sstrMensajeBorrar & " - " & strMsg & sarrBorrar(1, intRow)
                End If
            Next
        End If
    End If

    Dim sarrRegistros, sintTotalRegistros
    select_Tribunal Conn, sarrRegistros, sintTotalRegistros


%>

<!--#include file="asp/comunes/General/CalculoFilasPorPagina.inc"-->

<HTML>

<HEAD><TITLE>Mantenedor</TITLE>
<LINK rel="stylesheet" TYPE="text/css" HREF="isk_style.css">
</HEAD>

<BODY>
<!--#include file="asp/comunes/General/JavaScriptBotonesMantenedor.inc"-->

<FORM NAME="mantenedorForm" method="POST" action="man_Tribunal.asp" onmouseover="highlightButton('start')" onmouseout="highlightButton('')">
<INPUT TYPE=HIDDEN NAME="sintNumFilasPagina" VALUE="<%= sintNumFilasPagina %>">
<INPUT TYPE=HIDDEN NAME="sintPagina" VALUE=<%= sintPagina  %>>
<INPUT TYPE=HIDDEN NAME="intIndiceFilasIni" VALUE="<%= intIndiceFilasIni  %>">
<INPUT TYPE=HIDDEN NAME="intIndiceFilasFin" VALUE="<%= intIndiceFilasFin  %>">

<TABLE WIDTH="100%" border=0 cellspacing=0 CLASS="tabla1">
    <TR BGCOLOR="#FFFFFF" HEIGHT="30" VALIGN="MIDDLE">
        <TD colspan=3 ALIGN=CENTER>
			<B>MANTENEDOR DE TRIBUNALES</B>
        </TD>
    </TR>
    <TR BGCOLOR="#FFFFFF" HEIGHT="30" VALIGN="MIDDLE">
        <TD>

		</TD>
		<TD ALIGN=RIGHT>

        </TD>

        <TD ALIGN=RIGHT>
        <INPUT TYPE=BUTTON NAME="Aceptar" VALUE="Borrar" onClick="BAceptar( this.form )">
        <INPUT TYPE=BUTTON NAME="Nuevo" VALUE="Nuevo" onClick="IrNuevo( 'man_TribunalForm.asp' )">
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
    <TD WIDTH="30%"><b>Nombre</TD>
    <TD WIDTH="25%"><b>Receptor</TD>
    <TD WIDTH="15%"><b>Telefono</TD>
    <TD WIDTH="20%"><b>Activo</TD>
    <TD><b>&nbsp;</TD>
    <TD WIDTH="5%"><center><b>Borrar<center></TD>
    </TR>

    <!--Datos-->
    <TR>
    <TD colspan=7 background="../images/arriba.jpg">
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

		If Trim(sarrRegistros(intRow).Item("IDTRIBUNAL"))="" or IsNull(sarrRegistros(intRow).Item("IDTRIBUNAL")) Then
			intIdTribunal=0
		Else
			intIdTribunal=sarrRegistros(intRow).Item("IDTRIBUNAL")
		End if
			'Response.write "<br>intIdTribunal =" & intIdTribunal

%>
<TR BGCOLOR="<%=sstrColor%>">
	<TD>&nbsp;</TD>
    <TD>
        <INPUT TYPE=HIDDEN NAME="sstrId<%= Cstr( intRow ) %>" VALUE="<%= Trim(sarrRegistros(intRow).Item("IDTRIBUNAL"))%>">
        <%= Trim(sarrRegistros(intRow).Item("IDTRIBUNAL")) %>
    </TD>
    <TD>
		<A HREF="man_TRIBUNALForm.asp?sintNuevo=0&IDTRIBUNAL=<%=Trim(sarrRegistros(intRow).Item("IDTRIBUNAL"))%>">
		<%= Trim(sarrRegistros(intRow).Item("NOMTRIBUNAL")) %>
		</A>
    </TD>
    <TD>
		<%= Trim(sarrRegistros(intRow).Item("RECEPTOR")) %>
    </TD>
    <TD>
		<%= Trim(sarrRegistros(intRow).Item("FONO1")) %>
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
	mantenedorForm.action='man_Tribunal.asp?intFiltro=1';
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
