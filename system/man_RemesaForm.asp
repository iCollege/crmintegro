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
<!--#include file="asp/comunes/recordset/Remesa.inc"-->

<%

	sintNuevo = request("sintNuevo")
	IntId = request("CODREMESA")
    IntIdCliente = request("CODCLIENTE")

	'Response.Write ("***" & IntId & "***")

    If sintNuevo = 1 Then
        strFormMode="Nuevo"
        IntId=0
    Else
        strFormMode="Edit"
    End If

    AbrirSCG()

	recordset_Remesa Conn, srsRegistro, IntId, IntIdCliente
    If Not srsRegistro.Eof Then
		intIdActivo = Trim(srsRegistro("ACTIVO"))
	Else
		intIdActivo = ""
    End If

%>

<HTML>
<HEAD><TITLE>Mantenedor de Remesas</TITLE>
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


<FORM NAME="mantenedorForm"  action="man_RemesaAction.asp" method="POST" onmouseover="highlightButton('start')" onmouseout="highlightButton('')">
	<INPUT TYPE="HIDDEN" NAME="strFormMode" VALUE="<%= strFormMode %>">


<TABLE WIDTH="550" BORDER="0" CELLPADDING=0 CELLSPACING=0 ALIGN="CENTER">
    <TR>
     <TD>
<TABLE width="100%" CLASS="tabla1">
    <TR HEIGHT=50>
    	<TD width="100%" ALIGN=CENTER>
            <B>MANTENEDOR DE REMESA</B>
        </TD>
    </TR>
</TABLE>

 <table width="100%" border="0" CLASS="tabla1">
    	<tr BGCOLOR="#FFFFFF">
    		<td class="hdr_i"><img src='../images/cuadrado_t1.gif' align='absmiddle'>&nbspINGRESO REMESA</Font></td>
     </tr>
</Table>


<table width="100%" border="0" CLASS="tabla1">
	<tr BGCOLOR="#FFFFFF">
		<td class="hdr_i">Codigo Remesa</Font></td>

		<%
		If strFormMode = "Nuevo" Then
		%>
		<td class="td_t"><% general_MostrarCampo "CODREMESA", False, Null, Null,srsRegistro %></td>
		<%
		Else

			Response.Write "<INPUT TYPE=HIDDEN NAME=CODREMESA VALUE=""" & srsRegistro("CODREMESA") & """>"
		%>
			<td class="td_t"><%=srsRegistro("CODREMESA") %></td>
		<%
		End If
        %>
	</TR>
	<tr BGCOLOR="#FFFFFF">
		<td class="hdr_i">Codigo Cliente</Font></td>

		<%
		If strFormMode = "Nuevo" Then
		%>
		<td class="td_t">
			<select name="CODCLIENTE">
				<option value="Seleccionar">Seleccionar</option>
				<%
				ssql="SELECT CODCLIENTE, DESCRIPCION FROM CLIENTE ORDER BY DESCRIPCION "
				set rsTemp= Conn.execute(ssql)
				if not rsTemp.eof then
					do until rsTemp.eof%>
						<option value="<%=rsTemp("CODCLIENTE")%>"<%if strIdCodCliente=rsTemp("CODCLIENTE") then response.Write("Selected") End If%>><%=rsTemp("DESCRIPCION")%></option>
					<%
					rsTemp.movenext
					loop
				end if
				rsTemp.close
				set rsTemp=nothing

				%>
			</select>
		</td>
		<%
		Else
			Response.Write "<INPUT TYPE=HIDDEN NAME=CODCLIENTE VALUE=""" & srsRegistro("CODCLIENTE") & """>"
			strCliente = TraeCampoId(Conn, "DESCRIPCION", Trim(srsRegistro("CODCLIENTE")), "CLIENTE", "CODCLIENTE")
		%>
			<td class="td_t"><%=srsRegistro("CODCLIENTE") %> - <%=strCliente%></td>
		<%
		End If
		%>
	</TR>
 	<tr BGCOLOR="#FFFFFF">
		<td class="hdr_i">Nombre</Font></td>
		<td class="td_t"><% general_MostrarCampo "NOMBRE", False, Null, Null,srsRegistro %></td>
	</TR>
	<tr BGCOLOR="#FFFFFF">
		<td class="hdr_i">Descripcion</Font></td>
		<td class="td_t"><% general_MostrarCampo "DESCRIPCION", False, Null, Null,srsRegistro %></td>
	</TR>
	<tr BGCOLOR="#FFFFFF">
		<td class="hdr_i">Fecha llegada</Font></td>
		<td class="td_t"><% general_MostrarCampo "FECHA_LLEGADA", False, Null, Null,srsRegistro %></td>
	</TR>
	<tr BGCOLOR="#FFFFFF">
		<td class="hdr_i">Fecha carga</Font></td>
		<td class="td_t"><% general_MostrarCampo "FECHA_CARGA", False, Null, Null,srsRegistro %></td>
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
	   <input type="BUTTON" value="Terminar" name="terminar" onClick="Terminar('man_Remesa.asp');return false;"></TD>
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

	mantenedorForm.action='man_RemesaForm.asp?strTipoPropiedad=' + strTipo;
	if (mantenedorForm.strFormMode.value == 'Nuevo') {
		location.href="man_RemesaForm.asp?sintNuevo=1&strTipoPropiedad=" + strTipo;
		}
	else {
	 	mantenedorForm.submit();
	}
}
</SCRIPT>

<%CerrarSCG()%>

</BODY>
</HTML>




