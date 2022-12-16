<% @LCID = 1034 %>
<!--#include file="arch_utils.asp"-->
<!--#include file="../lib/comunes/rutinas/funciones.inc" -->
<!--#include file="lib.asp"-->

<%
rut=request.Form("rut")
abrirscg()
ssql="SELECT CORRELATIVO FROM DEUDOR_TELEFONO WHERE RUTDEUDOR = '" & rut & "'"
set rsDIR=Conn.execute(ssql)
do until rsDIR.eof
	estado_correlativo=request("radiofon" & Trim(rsDIR("CORRELATIVO")))
	correlativo=rsDIR("CORRELATIVO")

	''Response.write "<br>estado_correlativo=" & estado_correlativo
	If Trim(estado_correlativo) <> "" and Not IsNull(estado_correlativo) Then
		strSql = "UPDATE DEUDOR_TELEFONO SET ESTADO='" & cint(estado_correlativo) & "' WHERE RUTDEUDOR = '" & rut & "' and CORRELATIVO='" & correlativo & "'"
		Conn.execute(strSql)
	End If
rsDIR.movenext
loop

'Response.end

rsDIR.close
set rsDIR=nothing
cerrarscg()
%>


<script language="JavaScript" type="text/JavaScript">
alert('DATOS DE TELEFONOS ACTUALIZADOS');
window.navigate('principal.asp?rut=<%=rut%>');
</script>