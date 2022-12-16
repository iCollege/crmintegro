<% @LCID = 1034 %>
<!--#include file="arch_utils.asp"-->
<!--#include file="../lib/comunes/rutinas/funciones.inc" -->
<!--#include file="lib.asp"-->

<%
rut=request.Form("rut")
abrirscg()
ssql="SELECT CORRELATIVO FROM DEUDOR_DIRECCION WHERE RUTDEUDOR='"&rut&"'"
set rsDIR=Conn.execute(ssql)
do until rsDIR.eof
	estado_correlativo=request.Form("radiodir"+cstr(rsDIR("CORRELATIVO")))
	correlativo=rsDIR("CORRELATIVO")

	ssql2="UPDATE DEUDOR_DIRECCION SET ESTADO='"&cint(estado_correlativo)&"' WHERE RUTDEUDOR='"&rut&"' and CORRELATIVO='"&correlativo&"'"
	Conn.execute(ssql2)

rsDIR.movenext
loop

rsDIR.close
set rsDIR=nothing
cerrarscg()
%>


<script language="JavaScript" type="text/JavaScript">
alert('DATOS DE DIRECCIONES ACTUALIZADOS');
window.navigate('principal.asp?rut=<%=rut%>');
</script>
