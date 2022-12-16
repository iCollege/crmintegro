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
<!--#include file="../lib/comunes/rutinas/GrabaAuditoria.inc" -->

<% ' Capa 2 ' %>
<!--#include file="asp/comunes/select/DemandaQry.inc"-->
<!--#include file="asp/comunes/delete/Demanda.inc"-->
<!--#include file="asp/comunes/select/Tribunal.inc"-->
<%
    AbrirSCG()

    intIdCliente=session("ses_codcli")
    intFiltro=Trim(Request("intFiltro"))
    strRolAno=Trim(Request("TX_ROLANO"))
    strRutDeudor=Trim(Request("TX_RUTDEUDOR"))
    intIdTribunal=Trim(Request("CB_TRIBUNAL"))



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

            If intFiltro <> "1" Then
				For intRow = intIndiceFilasIni to intIndiceFilasFin
					'Response.write "arrborrar = " &sarrBorrar( 0, intRow )
					If sarrBorrar( 0, intRow ) = "on" Then
						delete_Demanda Conn, sarrBorrar(1, intRow), strMsg

						aa = GrabaAuditoria("BORRAR", "IDDEMANDA=" & sarrBorrar(1, intRow), "man_demanda.asp", "DEMANDA")

						If strMsg <> "" Then
							sstrMensajeBorrar = sstrMensajeBorrar & " - " & strMsg & sarrBorrar(1, intRow)
						End If

						strSql="UPDATE CUOTA SET IDDEMANDA = NULL WHERE IDDEMANDA = " & sarrBorrar(1, intRow)
						Conn.execute(strSql)

					End If
				Next
            End If
        End If
    End If

    Dim sarrRegistros, sintTotalRegistros
    strQryWhere = "WHERE codcliente = '" & intIdCliente & "'"

    If Trim(strRolAno) <> "" Then
    	strQryWhere = strQryWhere & " AND ROLANO LIKE '" & strRolAno & "%'"
    End if
    If Trim(strRutDeudor) <> "" Then
	   	strQryWhere = strQryWhere & " AND RUTDEUDOR LIKE '" & strRutDeudor & "%'"
    End if

    If Trim(intIdTribunal) <> "" Then
	   	strQryWhere = strQryWhere & " AND IDTRIBUNAL= " & intIdTribunal
    End if

	''Response.write "strQryWhere = " & strQryWhere

    select_DemandaQry Conn, strQryWhere ,sarrRegistros, sintTotalRegistros

%>

<!--#include file="asp/comunes/General/CalculoFilasPorPagina25.inc"-->

<HTML>

<HEAD><TITLE>Mantenedor</TITLE>
<LINK rel="stylesheet" TYPE="text/css" HREF="isk_style.css">
</HEAD>

<BODY>
<!--#include file="asp/comunes/General/JavaScriptBotonesMantenedor.inc"-->

<FORM NAME="mantenedorForm" method="POST" action="man_Demanda.asp" onmouseover="highlightButton('start')" onmouseout="highlightButton('')">
<INPUT TYPE=HIDDEN NAME="sintNumFilasPagina" VALUE="<%= sintNumFilasPagina %>">
<INPUT TYPE=HIDDEN NAME="sintPagina" VALUE=<%= sintPagina  %>>
<INPUT TYPE=HIDDEN NAME="intIndiceFilasIni" VALUE="<%= intIndiceFilasIni  %>">
<INPUT TYPE=HIDDEN NAME="intIndiceFilasFin" VALUE="<%= intIndiceFilasFin  %>">

<TABLE WIDTH="100%" border=0 cellspacing=0 CLASS="tabla1">
    <TR BGCOLOR="#FFFFFF" HEIGHT="30" VALIGN="MIDDLE">
        <TD colspan=3 ALIGN=CENTER>
			<B>MANTENEDOR DE DEMANDAS</B>
        </TD>
    </TR>
    <TR BGCOLOR="#FFFFFF" HEIGHT="30" VALIGN="MIDDLE">
        <TD>
			Rol-Año : <input name="TX_ROLANO" type="text" value="">
			Rut : <input name="TX_RUTDEUDOR" type="text" value="">
			Tribunal :
			<% select_Tribunal Conn, sarrTemp, sintTotalReg %>
					<SELECT NAME="CB_TRIBUNAL">
						<OPTION VALUE="">TODOS</OPTION>
						<% For intRow = 0 To sintTotalReg%>
						<OPTION VALUE="<%=Trim(sarrTemp(intRow).Item("IDTRIBUNAL"))%>"
						<% If Trim(sarrTemp(intRow).Item("IDTRIBUNAL"))  = intIdTribunal Then Response.Write "SELECTED" %>><%=Trim(sarrTemp(intRow).Item("NOMTRIBUNAL"))%>
						</OPTION>
						<% Next %>
			</SELECT>
			&nbsp;<INPUT TYPE=BUTTON NAME="Buscar" VALUE="Buscar" onClick="Refrescar()">


		</TD>
		<TD ALIGN=RIGHT>

        </TD>

        <TD ALIGN=RIGHT>
        <INPUT TYPE=BUTTON NAME="Aceptar" VALUE="Borrar" onClick="BAceptar( this.form )">
        <INPUT TYPE=BUTTON NAME="Nuevo" VALUE="Nuevo" onClick="IrNuevo( 'man_DemandaForm.asp' )">
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
    <TD WIDTH="5%"><b>Id</TD>
    <TD WIDTH="15%"><b>Rut</TD>
    <TD WIDTH="15%"><b>Tribunal</TD>
    <TD WIDTH="15%"><b>Procurador</TD>
    <TD WIDTH="15%"><b>Abogado</TD>
    <TD WIDTH="15%"><b>Rol- Año</TD>
    <TD WIDTH="10%"><b>Fecha Ingreso</TD>
    <TD WIDTH="10%"><b>Monto</TD>
    <TD WIDTH="10%"><b>Expediente</TD>
    <TD><b>&nbsp;</TD>
    <TD WIDTH="5%"><center><b>Borrar<center></TD>
    </TR>

    <!--Datos-->
    <TR>
    <TD colspan=12 background="../images/arriba.jpg">
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

		If Trim(sarrRegistros(intRow).Item("IDDEMANDA"))="" or IsNull(sarrRegistros(intRow).Item("IDDEMANDA")) Then
			intIdDemanda=0
		Else
			intIdDemanda=sarrRegistros(intRow).Item("IDDEMANDA")
		End if
			'Response.write "<br>intIdDemanda =" & intIdDemanda



		strSql = "SELECT ISNULL(EXPEDIENTE,'NO') as EXPEDIENTE FROM DEUDOR "
		strSql = strSql & " WHERE CODCLIENTE = '" & intIdCliente & "' AND RUTDEUDOR = '" & Trim(sarrRegistros(intRow).Item("RUTDEUDOR")) & "'"
		set rsExpediente=Conn.execute(strSql)
		If Not rsExpediente.eof Then
			strExpediente = rsExpediente("EXPEDIENTE")
		Else
			strExpediente = "NO"
		End If


%>
<TR BGCOLOR="<%=sstrColor%>">
	<TD>&nbsp;</TD>
    <TD>
        <INPUT TYPE=HIDDEN NAME="sstrId<%= Cstr( intRow ) %>" VALUE="<%= Trim(sarrRegistros(intRow).Item("IDDEMANDA"))%>">
        <A HREF="man_DEMANDAForm.asp?sintNuevo=0&IDDEMANDA=<%=Trim(sarrRegistros(intRow).Item("IDDEMANDA"))%>">
        	<%= Trim(sarrRegistros(intRow).Item("IDDEMANDA")) %>
        </A>
    </TD>
    <TD>
    	<A HREF="principal.asp?rut=<%=Trim(sarrRegistros(intRow).Item("RUTDEUDOR"))%>">
			&nbsp;&nbsp;<%= Trim(sarrRegistros(intRow).Item("RUTDEUDOR")) %>
		</A>
    </TD>
    <TD>
    	<%= TraeCampoId(Conn, "NOMTRIBUNAL", Trim(sarrRegistros(intRow).Item("IDTRIBUNAL")), "TRIBUNAL", "IDTRIBUNAL") %>
    </TD>

    <TD>
		<%= Mid(TraeCampoId(Conn, "NOMBRES_USUARIO", Trim(sarrRegistros(intRow).Item("IDPROCURADOR")), "USUARIO", "ID_USUARIO") & " " & TraeCampoId(Conn, "APELLIDOS_USUARIO", Trim(sarrRegistros(intRow).Item("IDPROCURADOR")), "USUARIO", "ID_USUARIO"),1,15) %>
    </TD>
    <TD>
		<%= Mid(TraeCampoId(Conn, "NOMABOGADO", Trim(sarrRegistros(intRow).Item("IDABOGADO")), "ABOGADO", "IDABOGADO"),1,15) %>
    </TD>

    <TD>
		<%= Trim(sarrRegistros(intRow).Item("ROLANO")) %>
    </TD>
    <!--TD>

    </TD-->

    <TD>
		<%= Trim(sarrRegistros(intRow).Item("FECHA_INGRESO")) %>
    </TD>

    <TD>
		<%= Trim(sarrRegistros(intRow).Item("MONTO")) %>
    </TD>
    <TD>
		<%=strExpediente%>
    </TD>
     <TD>&nbsp;</TD>
    <TD WIDTH="10%" ALIGN=CENTER>
	<% If TraeSiNo(session("perfil_adm"))="Si" Then %>
    	<INPUT TYPE=checkbox NAME="borrar<%= intRow %>">
	<% Else%>
		<INPUT TYPE=HIDDEN NAME="borrar<%= intRow %>">
		&nbsp;
	<% End If%>
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
	mantenedorForm.action='man_Demanda.asp?intFiltro=1';
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
