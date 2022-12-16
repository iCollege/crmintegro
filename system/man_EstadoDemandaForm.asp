<%@ LANGUAGE = "VBScript" %>
<!--#include file="asp/comunes/General/MostrarRegistro.inc"-->
<!--#include file="asp/comunes/general/JavaEfectoBotones.inc"-->
<!--#include file="asp/comunes/general/rutinasTraeCampo.inc"-->

<% ' Capa 1 ' %>
<!--#include file="asp/comunes/odbc/AdoVbs.inc"-->
<!--#include file="arch_utils.asp"-->
<!--#include file="asp/comunes/odbc/ObtenerRecordSet.inc"-->
<!--#include file="asp/comunes/odbc/ObtenerRegistros.inc"-->

<% ' Capa 2 ' %>
<!--#include file="asp/comunes/recordset/EstadoDemanda.inc"-->

<%

	sintNuevo = request("sintNuevo")
    IntId= request("IDESTADODEMANDA")

	'Response.Write ("***" & IntId & "***")

    If sintNuevo = 1 Then
        strFormMode="Nuevo"
        IntId=0
    Else
        strFormMode="Edit"
    End If

    AbrirSCG()
	recordset_ESTADODEMANDA Conn, srsRegistro, IntId
    If Not srsRegistro.Eof Then
		intIdACTIVO = Trim(srsRegistro("ACTIVO"))
	Else
		intIdACTIVO = ""
    End If

%>

<HTML>
<HEAD><TITLE>Mantenedor de Estado de la Demanda</TITLE>
<LINK rel="stylesheet" TYPE="text/css" HREF="isk_style.css">
</HEAD>

<BODY BGCOLOR='FFFFFF'>

<SCRIPT Language=JavaScript>
function Continuar() {
    //if ( document.forms[0].ID.value == '' || esNumero('tinyint',document.forms[0].ID.value)=="false") {
    //    alert( "Debe ingresar en código un dato numerico entero entre 0 y 255" );
    //    return false
    //}

	document.forms[0].submit()
    return false
}
</SCRIPT>


<FORM NAME="mantenedorForm"  action="man_EstadoDemandaAction.asp" method="POST" onmouseover="highlightButton('start')" onmouseout="highlightButton('')">
	<INPUT TYPE="HIDDEN" NAME="strFormMode" VALUE="<%= strFormMode %>">




<TABLE WIDTH="550" BORDER="0" CELLPADDING=0 CELLSPACING=0 ALIGN="CENTER">
    <TR>
     <TD>
<TABLE width="100%" CLASS="tabla1">
    <TR HEIGHT=50>
    	<TD width="100%" ALIGN=CENTER>
            <B>MANTENEDOR DE ESTADOS DE LA DEMANDA</B>
        </TD>
    </TR>
</TABLE>


<table width="100%" border="0" cellpadding=2 cellspacing=0>
    <tr>
     <td  width="26%" align=center>
		<%
		If strFormMode = "Nuevo" Then
        	'general_MostrarCampo "IDESTADODEMANDA", False, Null, Null, srsRegistro

        Else
            'Response.Write srsRegistro("IDESTADODEMANDA")
            Response.Write "<INPUT TYPE=HIDDEN NAME=IDESTADODEMANDA VALUE=""" & srsRegistro("IDESTADODEMANDA") & """>"

        End If%>
	</td>
    </tr>
 </Table>

 <table width="100%" border="0" CLASS="tabla1">
    	<tr BGCOLOR="#FFFFFF">
    		<td class="hdr_i"><img src='../images/cuadrado_t1.gif' align='absmiddle'>&nbspINGRESO ESTADO DE LA DEMANDA</Font></td>
     </tr>
</Table>


<table width="100%" border="0" CLASS="tabla1">
 	<tr BGCOLOR="#FFFFFF">
		<td class="hdr_i">Nombre EstadoDemanda</Font></td>
		<td class="td_t"><% general_MostrarCampo "NOMESTADODEMANDA", False, Null, Null,srsRegistro %></td>
	</TR>
	<tr BGCOLOR="#FFFFFF">
		<td class="hdr_i">Activo</Font></td>
		<td class="td_t"><% general_MostrarCampo "ACTIVO", False, Null, Null,srsRegistro %></td>
	</tr>

</table>

<table width="100%" border="0">
     <TR>
	  <td align=center  width="25%">
	   <INPUT TYPE="BUTTON" value="Guardar" name="B1" onClick="Continuar();return false;">
	   <input type="BUTTON" value="Terminar" name="terminar" onClick="Terminar('man_EstadoDemanda.asp');return false;"></TD>
	  </TD>
    </TR>
    <%If sintNuevo = 1 Then %>
    <TR>
    <TD align=center >
     <IMG BORDER="0" src="../images/bolita.jpg" WIDTH=10>=Campo requerido
     </TD>
    </TR>
	<%End If %>
</table>

    </TD>
    </TR>
</TABLE>
</FORM>

<SCRIPT>
function Refrescar(strTipo){

	mantenedorForm.action='man_EstadoDemandaForm.asp?strTipoPropiedad=' + strTipo;
	if (mantenedorForm.strFormMode.value == 'Nuevo') {
		location.href="man_EstadoDemandaForm.asp?sintNuevo=1&strTipoPropiedad=" + strTipo;
		}
	else {
	 	mantenedorForm.submit();
	}
}
</SCRIPT>

<%CerrarSCG()%>

</BODY>
</HTML>


