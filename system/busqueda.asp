<% @LCID = 1034 %>
<!--#include file="sesion.asp"-->
<!--#include file="arch_utils.asp"-->
<!--#include file="../lib/comunes/rutinas/funciones.inc" -->
<!--#include file="lib.asp"-->

<%
	criterio= request("criterio")
	TX_NOMBRE = UCASE(TRIM(request("TX_NOMBRE")))
	TX_DOCUMENTO = UCASE(TRIM(request("TX_DOCUMENTO")))
%>
<title>M&Oacute;DULO DE B&Uacute;SQUEDA</title>

<style type="text/css">
<!--
.Estilo37 {color: #FFFFFF}
-->
</style>

<table width="100%" border="1" bordercolor="#FFFFFF">
	<tr>
		<TD height="20" ALIGN=LEFT class="pasos2_i">
			<B>BUSQUEDA DEL DEUDOR</B>
		</TD>
	</tr>
</table>

  <table width="720" align="CENTER" height="420" border="0">
  <tr>
    <td height="242" valign="top">
    <form name="datos" method="post">
	<table width="100%" border="0">
      <tr bgcolor="#<%=session("COLTABBG")%>" class="Estilo13">
        <td>NOMBRE</td>
        <td>DOCUMENTO</td>
        <td>&nbsp;</td>
        </tr>
      <tr>
        <td><input name="TX_NOMBRE" type="text" id="TX_NOMBRE" size="40" maxlength="40"></td>
        <td><input name="TX_DOCUMENTO" type="text" id="TX_DOCUMENTO" size="40" maxlength="40"></td>
        <td>
			<input type="button" name="Submit" value="Buscar" onClick="envia();">
				&nbsp;&nbsp;&nbsp;
			<input type="button" name="Submit" value="Limpiar" onClick="window.navigate(busqueda.asp);">
		</td>
        </tr>
    </table>

	<%
	If Trim(TX_NOMBRE) <> "" or Trim(TX_DOCUMENTO) <> "" Then
		If Trim(TX_NOMBRE) <> "" Then
			ssql="SELECT DISTINCT RUTDEUDOR,NOMBREDEUDOR FROM DEUDOR WHERE NOMBREDEUDOR LIKE '%"&TX_NOMBRE&"%'"
		End If
		If Trim(TX_DOCUMENTO) <> "" Then
			ssql="SELECT DISTINCT RUTDEUDOR,NOMBREDEUDOR FROM DEUDOR WHERE RUTDEUDOR IN (SELECT RUTDEUDOR FROM CUOTA WHERE NRODOC = '" & TX_DOCUMENTO &"')"
		End If
	abrirscg()
	set rsBU=Conn.execute(ssql)
	if not rsBU.eof then
	%>
	<BR>
	  <strong>RESULTADO DE LA B&Uacute;SQUEDA </strong><BR>
	  <BR>
	  <table width="100%"  border="0">
        <tr bgcolor="#<%=session("COLTABBG")%>" class="Estilo13">
          <td width="31%">RUT DEUDOR</td>
          <td width="69%">NOMBRE DEUDOR</td>
          </tr>
		<%
		do until rsBU.eof
		%>
        <tr>
          <td>

          <a href="principal.asp?rut=<%=rsBU("RUTDEUDOR")%>"><%=rsBU("RUTDEUDOR")%></a>
          </td>
          <td><%=rsBU("NOMBREDEUDOR")%></td>
          </tr>
		<%
		rsBU.movenext
		loop
		%>
      </table></td>
  </tr>
</table>

<%
else
	response.Write("NO SE ENCONTRARON COINCIDENCIAS")
end if
rsBU.close
set rsBU=nothing
cerrarscg()
End If
%>

</form>

<script language="JavaScript1.2">
function envia(){
if ((datos.TX_NOMBRE.value=='') && (datos.TX_DOCUMENTO.value=='')) {
	alert('DEBE INGRESAR TEXTO DE BUSQUEDA');
}
else
{
	datos.action='busqueda.asp';
	datos.submit();
}
}

</script>
