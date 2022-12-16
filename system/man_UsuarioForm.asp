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

	sintNuevo = request("sintNuevo")
    IntId= request("ID_USUARIO")

	'Response.Write ("***" & IntId & "***")

    If sintNuevo = 1 Then
        strFormMode="Nuevo"
        IntId=0
    Else
        strFormMode="Edit"
    End If

    AbrirSCG()
	recordset_Usuario Conn, srsRegistro, IntId
    If Not srsRegistro.Eof Then
		intIdACTIVO = Trim(srsRegistro("ACTIVO"))
	Else
		intIdACTIVO = ""
    End If

%>

<HTML>
<HEAD><TITLE>Mantenedor de Usuarios</TITLE>
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


<FORM NAME="mantenedorForm"  action="man_UsuarioAction.asp" method="POST" onmouseover="highlightButton('start')" onmouseout="highlightButton('')">
	<INPUT TYPE="HIDDEN" NAME="strFormMode" VALUE="<%= strFormMode %>">


<TABLE WIDTH="550" BORDER="0" CELLPADDING=0 CELLSPACING=0 ALIGN="CENTER">
    <TR>
     <TD>
<TABLE width="100%" CLASS="tabla1">
    <TR HEIGHT=50>
    	<TD width="100%" ALIGN=CENTER>
            <B>MANTENEDOR DE USUARIOS</B>
        </TD>
    </TR>
</TABLE>


<table width="100%" border="0" cellpadding=2 cellspacing=0>
    <tr>
     <td  width="26%" align=center>
		<%
		If strFormMode = "Nuevo" Then
        	'general_MostrarCampo "ID_USUARIO", False, Null, Null, srsRegistro

        Else
            'Response.Write srsRegistro("ID_USUARIO")
            Response.Write "<INPUT TYPE=HIDDEN NAME=ID_USUARIO VALUE=""" & srsRegistro("ID_USUARIO") & """>"

        End If%>
	</td>
    </tr>
 </Table>

 <table width="100%" border="0" CLASS="tabla1">
    	<tr BGCOLOR="#FFFFFF">
    		<td class="hdr_i"><img src='../images/cuadrado_t1.gif' align='absmiddle'>&nbsp;INGRESO USUARIOS</Font></td>
     </tr>
</Table>


<table width="100%" border="0" CLASS="tabla1">
 	<tr BGCOLOR="#FFFFFF">
		<td class="hdr_i">Nombres</Font></td>
		<td class="td_t"><% general_MostrarCampo "NOMBRES_USUARIO", False, Null, Null,srsRegistro %></td>
	</TR>
	<tr BGCOLOR="#FFFFFF">
		<td class="hdr_i">Apellidos</Font></td>
		<td class="td_t"><% general_MostrarCampo "APELLIDOS_USUARIO", False, Null, Null,srsRegistro %></td>
	</TR>
	<tr BGCOLOR="#FFFFFF">
		<td class="hdr_i">Rut</Font></td>
		<td class="td_t"><% general_MostrarCampo "RUT_USUARIO", False, Null, Null,srsRegistro %></td>
	</TR>
	<tr BGCOLOR="#FFFFFF">
		<td class="hdr_i">Perfil Administrador</Font></td>
		<td class="td_t"><% general_MostrarCampo "PERFIL_ADM", False, Null, Null,srsRegistro %></td>
	</TR>
	<tr BGCOLOR="#FFFFFF">
		<td class="hdr_i">Perfil Supervisor</Font></td>
		<td class="td_t"><% general_MostrarCampo "PERFIL_SUP", False, Null, Null,srsRegistro %></td>
	</TR>
	<tr BGCOLOR="#FFFFFF">
		<td class="hdr_i">Perfil Cobrador</Font></td>
		<td class="td_t"><% general_MostrarCampo "PERFIL_COB", False, Null, Null,srsRegistro %></td>
	</TR>
	<tr BGCOLOR="#FFFFFF">
		<td class="hdr_i">Perfil Caja</Font></td>
		<td class="td_t"><% general_MostrarCampo "PERFIL_CAJA", False, Null, Null,srsRegistro %></td>
	</TR>
	<tr BGCOLOR="#FFFFFF">
		<td class="hdr_i">Perfil Judicial</Font></td>
		<td class="td_t"><% general_MostrarCampo "PERFIL_PROC", False, Null, Null,srsRegistro %></td>
	</TR>
	<tr BGCOLOR="#FFFFFF">
		<td class="hdr_i">Perfil Full</Font></td>
		<td class="td_t"><% general_MostrarCampo "PERFIL_FULL", False, Null, Null,srsRegistro %></td>
	</TR>
	<tr BGCOLOR="#FFFFFF">
		<td class="hdr_i">Perfil Cliente</Font></td>
		<td class="td_t"><% general_MostrarCampo "PERFIL_EMP", False, Null, Null,srsRegistro %></td>
	</TR>
	<tr BGCOLOR="#FFFFFF">
		<td class="hdr_i">Login</Font></td>
		<td class="td_t"><% general_MostrarCampo "LOGIN", False, Null, Null,srsRegistro %></td>
	</TR>
	<tr BGCOLOR="#FFFFFF">
		<td class="hdr_i">Contraseña</Font></td>
		<td class="td_t"><% general_MostrarCampo "CLAVE", False, Null, Null,srsRegistro %></td>
	</TR>
	<tr BGCOLOR="#FFFFFF">
		<td class="hdr_i">Activo</Font></td>
		<td class="td_t"><% general_MostrarCampo "ACTIVO", False, Null, Null,srsRegistro %></td>
	</tr>

</table>


<BR>
<BR>

<% If strFormMode <> "Nuevo" Then %>
<table width="100%" border="0" CLASS="tabla1">
 	<tr BGCOLOR="#FFFFFF">
		<td class="hdr_i">Asignar Cliente</Font></td>
		<td class="td_t">
		<%
			strSql = "SELECT CODCLIENTE, RAZON_SOCIAL FROM CLIENTE WHERE ACTIVO = 1"
			set rsEmpresa= Conn.execute(strSql)
			Do While not rsEmpresa.eof
				strSql = "SELECT CODCLIENTE FROM USUARIO_CLIENTE WHERE ID_USUARIO = " & IntId & " AND CODCLIENTE = " & rsEmpresa("CODCLIENTE")
				set rsUsuarioEmpresa= Conn.execute(strSql)
				If Not rsUsuarioEmpresa.Eof Then
					strChecked = "CHECKED"
				Else
					strChecked = ""
				End If


		%>
			<INPUT TYPE=checkbox NAME="CH_CLIENTE_<%=rsEmpresa("CODCLIENTE")%>" <%=strChecked%>> <%=rsEmpresa("RAZON_SOCIAL")%>

		<%
				intCorr = intCorr + 1
				rsEmpresa.movenext
			Loop
		%>

		</td>
	</TR>
</table>
<% End If%>


<table width="100%" border="0">
     <TR>
	  <td align=center  width="25%">
	   <INPUT TYPE="BUTTON" value="Guardar" name="B1" onClick="Continuar();return false;">
	   <input type="BUTTON" value="Terminar" name="terminar" onClick="Terminar('man_Usuario.asp');return false;"></TD>
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

	mantenedorForm.action='man_UsuarioForm.asp?strTipoPropiedad=' + strTipo;
	if (mantenedorForm.strFormMode.value == 'Nuevo') {
		location.href="man_UsuarioForm.asp?sintNuevo=1&strTipoPropiedad=" + strTipo;
		}
	else {
	 	mantenedorForm.submit();
	}
}
</SCRIPT>

<%CerrarSCG()%>

</BODY>
</HTML>




