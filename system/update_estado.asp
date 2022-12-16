<% @LCID = 1034 %>
<!--#include file="arch_utils.asp"-->
<!--#include file="../lib/comunes/rutinas/funciones.inc" -->
<!--#include file="lib.asp"-->

<%
ruta=request.Form("rut_deudor")
idGestion=request.Form("id")
opcion=request.Form("opcion")
Observacion=request.Form("observacion")
abrirscg()
ssql="UPDATE GESTIONES SET ESTADO = '" & opcion & "', OBSER_CERRADO = '"& Observacion &"' WHERE ID_GESTION = '" & idGestion & "'"
Conn.execute(ssql)

cerrarscg()
%>
<!--
 <input name="id" type="text" value="<%=idGestion%>">
  <input name="id" type="text" value="<%=opcion%>">
   <input name="id" type="text" value="<%=ruta%>">
    <input name="id" type="text" value="<%=Observacion%>">
-->
<script language="JavaScript" type="text/JavaScript">
alert('ACTUALIZADO, ESTADO CAMBIADO !!');
window.navigate('principal.asp?rut=<%=ruta%>');
</script>