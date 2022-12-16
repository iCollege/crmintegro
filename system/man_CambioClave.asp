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
<!--#include file="asp/comunes/recordset/Usuario.inc"-->

<%
  	strUsuario = session("session_idusuario")
    AbrirSCG()
	recordset_Usuario Conn, srsRegistro, strUsuario
    If Not srsRegistro.Eof Then
		strClave = Trim(srsRegistro("CLAVE"))
    End If
%>

<HTML>
<HEAD><TITLE>Cambio de Clave</TITLE>
<LINK rel="stylesheet" TYPE="text/css" HREF="isk_style.css">
</HEAD>

<BODY BGCOLOR='FFFFFF'>

<SCRIPT Language=JavaScript>
function Continuar() {
    //if ( document.forms[0].ID.value == '' || esNumero('tinyint',document.forms[0].ID.value)=="false") {
    //    alert( "Debe ingresar en código un dato numerico entero entre 0 y 255" );
    //    return false
    //}
	frm = document.forms[0];
	if (frm.CLAVE_OLD.value != '<%=strClave%>'){
		alert('Contraseña Actual ingresada no corresponde');
		frm.CLAVE_NEW2.focus();
		return false;
	}
	if (frm.CLAVE_NEW1.value != frm.CLAVE_NEW2.value){
		alert('Las claves no coinciden');
		frm.CLAVE_NEW2.focus();
		return false;
	}
	document.forms[0].submit()
    return false
}
</SCRIPT>


<FORM NAME="mantenedorForm"  action="man_CambioClaveAction.asp" method="POST" onmouseover="highlightButton('start')" onmouseout="highlightButton('')">
<TABLE WIDTH="550" BORDER="0" CELLPADDING=0 CELLSPACING=0 ALIGN="CENTER">
    <TR>
     <TD>
<TABLE width="100%" CLASS="tabla1">
    <TR HEIGHT=50>
    	<TD width="100%" ALIGN=CENTER>
            <B>CAMBIO DE CLAVE</B>
        </TD>
    </TR>
</TABLE>



 <table width="100%" border="0" CLASS="tabla1">
    	<tr BGCOLOR="#FFFFFF">
    		<td class="hdr_i"><img src='../images/cuadrado_t1.gif' align='absmiddle'>&nbspCAMBIO DE CLAVE</Font></td>
     </tr>
</Table>

<table width="100%" border="0" CLASS="tabla1">
	<tr BGCOLOR="#FFFFFF">
		<td class="hdr_i">Contraseña Actual</Font></td>
          <TD class=td_t><INPUT  type="password" maxLength=10  name="CLAVE_OLD" ></TD>
	</TR>
	<tr BGCOLOR="#FFFFFF">
		<td class="hdr_i">Contraseña Nueva</Font></td>
          <TD class=td_t><INPUT type="password" maxLength=10  name="CLAVE_NEW1" ></TD>
	</TR>
	<tr BGCOLOR="#FFFFFF">
		<td class="hdr_i">Reingrese Contraseña Nueva</Font></td>
          <TD class=td_t><INPUT type="password" maxLength=10  name="CLAVE_NEW2" ></TD>
	</TR>

</table>

<TABLE width="100%" CLASS="tabla1">
     <TR>
	  <td align=center  width="25%">
	   <INPUT TYPE="BUTTON" value="Guardar" name="B1" onClick="Continuar();return false;">
	   <input type="BUTTON" value="Terminar" name="terminar" onClick="Terminar('principal.asp');return false;"></TD>
	  </TD>
    </TR>
</table>

    </TD>
    </TR>
</TABLE>
</FORM>


</BODY>
</HTML>




