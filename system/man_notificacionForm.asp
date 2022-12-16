<%@ LANGUAGE = "VBScript" %>
<!--#include file="asp/comunes/General/MostrarRegistro.inc"-->
<!--#include file="asp/comunes/general/JavaEfectoBotones.inc"-->
<!--#include file="asp/comunes/general/rutinasTraeCampo.inc"-->
<!--#include file="asp/comunes/general/rutinasVarias.inc"-->

<% ' Capa 1 ' %>
<!--#include file="asp/comunes/odbc/AdoVbs.inc"-->
<!--#include file="arch_utils.asp"-->
<!--#include file="asp/comunes/odbc/ObtenerRecordSet.inc"-->
<!--#include file="asp/comunes/odbc/ObtenerRegistros.inc"-->

<% ' Capa 2 ' %>
<!--#include file="asp/comunes/recordset/Notificacion.inc"-->
<!--#include file="asp/comunes/select/EstadoNotificacion.inc"-->


<%

	sintNuevo = request("sintNuevo")
    IdNotificacion= request("IdNotificacion")
    IntIdDemanda= request("IDDEMANDA")

	'Response.Write ("***" & IntId & "***")

    If sintNuevo = 1 Then
        strFormMode="Nuevo"
        IntId=0
    Else
        strFormMode="Edit"
    End If

    AbrirSCG()
	recordset_notificacion Conn, srsRegistro, IntIdDemanda, IdNotificacion
    If Not srsRegistro.Eof Then
    	intIdTipoNoti = srsRegistro("IDESTADONOTIF")
	Else
		intIdTipoNoti = ""
    End If

%>

<HTML>
<HEAD><TITLE>Ingreso de Gestiones</TITLE>
<LINK rel="stylesheet" TYPE="text/css" HREF="isk_style.css">
</HEAD>

<BODY BGCOLOR='FFFFFF'>

<SCRIPT Language=JavaScript>
function Continuar() {
    //if ( document.forms[0].ID.value == '' || esNumero('tinyint',document.forms[0].ID.value)=="false") {
    //    alert( "Debe ingresar en código un dato numerico entero entre 0 y 255" );
    //    return false
    //}

    //if ( document.forms[0].VAL1_AFP.value == '' || esNumero('money',document.forms[0].VAL1_AFP.value)=="false") {
	//	alert( "Debe ingresar en código un dato numerico real" );
	//	return false
    //}

    //if ( document.forms[0].VAL2_AFP.value == '' || esNumero('money',document.forms[0].VAL2_AFP.value)=="false") {
	//		alert( "Debe ingresar en código un dato numerico real" );
	//		return false
    //}

    //if (document.forms[0].NOM_AFP.value =='') {
    //    alert ("Debe ingresar Nombre de AFP");
    //    return false
    //}
    //if ( document.forms[0].ID_SCESAN.value == '' || esNumero('tinyint',document.forms[0].ID.value)=="false") {
	//        alert( "Debe ingresar en código de cesantía" );
	//        return false
	//    }
	document.forms[0].submit()
    return false
}
</SCRIPT>


<FORM NAME="mantenedorForm"  action="man_notificacionAction.asp" method="POST" onmouseover="highlightButton('start')" onmouseout="highlightButton('')">
	<INPUT TYPE="HIDDEN" NAME="prods">
    <INPUT TYPE="HIDDEN" NAME="strFormMode" VALUE="<%=strFormMode%>">
    <INPUT TYPE="HIDDEN" NAME="IntIdDemanda" VALUE="<%=IntIdDemanda%>">



<TABLE WIDTH="550" BORDER="0" CELLPADDING=0 CELLSPACING=0 ALIGN="CENTER">
    <TR>
     <TD>
<TABLE width="100%" CLASS="tabla1">
    <TR HEIGHT=50>
    	<TD width="100%" ALIGN=CENTER>
            <B>INGRESO DE NOTIFICACIONES</B>
        </TD>
    </TR>
</TABLE>


<table width="100%" border="0" cellpadding=2 cellspacing=0>
    <tr>
     <td  width="26%" align=center>
		<%
		If strFormMode = "Nuevo" Then
        	'general_MostrarCampo "IDGESTION", False, Null, Null, srsRegistro

        Else
            'Response.Write srsRegistro("IDGESTION")
            Response.Write "<INPUT TYPE=HIDDEN NAME=IDDEMANDA VALUE=""" & srsRegistro("IDDEMANDA") & """>"
            Response.Write "<INPUT TYPE=HIDDEN NAME=IDNOTIFICACION VALUE=""" & srsRegistro("IDNOTIFICACION") & """>"

        End If%>
	</td>
    </tr>
 </Table>
 <table width="100%" border="0" CLASS="tabla1">
    	<tr BGCOLOR="#FFFFFF">
    		<td class="hdr_i"><img src='../images/boton_no_1.gif' align='absmiddle'>&nbspINGRESO DE NOTIFICACIONES</Font></td>
     </tr>
</Table>

<table width="100%" border="0" CLASS="tabla1">
	<tr BGCOLOR="#FFFFFF">
		<td class="hdr_i">Gestión</Font></td>
		<td class="td_t">
		<% select_EstadoNotificacion Conn, sarrTemp, sintTotalReg %>
			<SELECT NAME="CB_TIPONOTIF">
				<% For intRow = 0 To sintTotalReg%>
				<OPTION VALUE="<%=Trim(sarrTemp(intRow).Item("CODIGO"))%>"
				<% If Trim(sarrTemp(intRow).Item("CODIGO")) = Trim(intIdTipoNoti) Then Response.Write "SELECTED" %>><%=Trim(sarrTemp(intRow).Item("CODIGO")) & " - " &Trim(sarrTemp(intRow).Item("DESCRIPCION"))%>
				</OPTION>
				<% Next %>
			</SELECT>
		</td>
	</tr>
		<tr BGCOLOR="#FFFFFF">
		<td class="hdr_i">Fecha</Font></td>
		<td class="td_t"><% general_MostrarCampo "FECHA", False, Null, Null,srsRegistro %></td>
	</TR>
	<tr BGCOLOR="#FFFFFF">
		<td class="hdr_i">Monto</Font></td>
		<td class="td_t"><% general_MostrarCampo "VALOR", False, Null, Null,srsRegistro %></td>
	</tr>
	<tr BGCOLOR="#FFFFFF">
		<td class="hdr_i">Boleta</Font></td>
		<td class="td_t"><% general_MostrarCampo "BOLETA", False, Null, Null,srsRegistro %></td>
	</tr>
	<tr BGCOLOR="#FFFFFF">
		<td class="hdr_i">Patente</Font></td>
		<td class="td_t"><% general_MostrarCampo "PATENTE", False, Null, Null,srsRegistro %></td>
	</tr>
	<tr BGCOLOR="#FFFFFF">
		<td class="hdr_i">Observaciones</Font></td>
		<td class="td_t"><% general_MostrarCampo "OBSERVACIONES", False, Null, Null,srsRegistro %></td>
	</tr>
</table>

<table width="100%" border="0">
     <TR>
	  <td align=center  width="25%">
	   <INPUT TYPE="BUTTON" value="Guardar" name="B1" onClick="Continuar();return false;">
	   <input type="BUTTON" value="Terminar" name="terminar" onClick="Terminar('man_Demanda.asp?sintNuevo=0&IDDEMANDA=<%=IntIdDemanda%>');return false;"></TD>
	  </TD>
    </TR>
    <%If sintNuevo = 1 Then %>
    <!--TR>
    <TD align=center >
     <IMG BORDER="0" src="../images/asterisco.gif" WIDTH=10>=Campo requerido
     </TD>
    </TR-->
	<%End If %>
</table>

    </TD>
    </TR>
</TABLE>
</FORM>

<%CerrarSCG%>

</BODY>
</HTML>




