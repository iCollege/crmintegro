<%@ Language=VBScript %>
<%Response.ContentType = "application/vnd.ms-excel"%>
<!--#include file="arch_utils.asp"-->
<!--#include file="../lib/comunes/rutinas/funciones.inc" -->
<%
inicio= request.QueryString("inicio")
termino= request.QueryString("termino")
cliente = request.QueryString("cliente")
ejecutivo= request.QueryString("cobrador")
%>
<title>EMPRESA S.A.</title>
<style type="text/css">
<!--
.Estilo32 {font-family: Arial, Helvetica, sans-serif}
.Estilo33 {color: #000000}
.Estilo34 {font-size: 9px}
-->
</style>
<table width="720" height="300" border="0">
  <tr>
    <td height="242" valign="top">
	<BR>

	<%
	IF not cliente="" and not ejecutivo="0" then
	ssql="SELECT PAGO_CUOTA.RUTDEUDOR,PAGO_CUOTA.NRODOC,ISNULL(PAGO_CUOTA.MONTOCAPITAL,0) AS MONTOCAPITAL,ISNULL(PAGO_CUOTA.UTILIDAD_EMPRESA,0) AS UTILIDAD_EMPRESA,PAGO.FECHA FROM PAGO_CUOTA,PAGO WHERE PAGO_CUOTA.COD_CLI='"&cliente&"' AND PAGO_CUOTA.CODCOBRADOR='"&EJECUTIVO&"' AND PAGO_CUOTA.CODPAGO = PAGO.CODIGO AND PAGO.FECHA>='"&inicio&"' AND PAGO.FECHA<='"&termino&"'"
	abrirscg()
	set rsDET=Conn.execute(ssql)
	if not rsDET.eof then
	%>

	  <table width="100%" border="1">
        <tr class="Estilo13">
          <td width="13%" class="Estilo4 Estilo29 Estilo31 Estilo32 Estilo33 Estilo34">EJECUTIVO</td>
          <td width="13%" class="Estilo4 Estilo29 Estilo31 Estilo32 Estilo33 Estilo34">CLIENTE</td>
          <td width="13%" class="Estilo4 Estilo29 Estilo31 Estilo32 Estilo33 Estilo34">RUT DEUDOR</td>
          <td width="13%" class="Estilo4 Estilo29 Estilo31 Estilo32 Estilo33 Estilo34">DOCUMENTO</td>
          <td width="8%" class="Estilo4 Estilo29 Estilo31 Estilo32 Estilo33 Estilo34">MONTO</td>
          <td width="15%" class="Estilo4 Estilo29 Estilo31 Estilo32 Estilo33 Estilo34">GASTO</td>
          <td width="14%" class="Estilo4 Estilo29 Estilo31 Estilo32 Estilo33 Estilo34">FECHA</td>

          </tr>
		  <%
		  do until rsDET.eof
		  %>
        <tr bgcolor="#FFFFFF" class="Estilo8">
          <td class="Estilo4 Estilo29 Estilo31 Estilo32 Estilo33 Estilo34"><%=ejecutivo%></td>
          <td class="Estilo4 Estilo29 Estilo31 Estilo32 Estilo33 Estilo34"><%=cliente%></td>
          <td class="Estilo4 Estilo29 Estilo31 Estilo32 Estilo33 Estilo34"><%=rsDET("RUTDEUDOR")%></td>
          <td class="Estilo4 Estilo29 Estilo31 Estilo32 Estilo33 Estilo34"><%=rsDET("NRODOC")%></td>
          <td class="Estilo4 Estilo29 Estilo31 Estilo32 Estilo33 Estilo34">$ <%=FN(rsDET("MONTOCAPITAL"),0)%></td>
          <td class="Estilo4 Estilo29 Estilo31 Estilo32 Estilo33 Estilo34">$ <%=FN(rsDET("UTILIDAD_EMPRESA"),0)%></td>
          <td class="Estilo4 Estilo29 Estilo31 Estilo32 Estilo33 Estilo34"><%=rsDET("FECHA")%></td>
        </tr>

		<%
		rsDET.movenext
		loop
		%>

      </table>
	  <%END IF
	  rsDET.close
	  set rsDET=nothing
	  cerrarscg()
	  %>
	  <%end if%>
    </td>
  </tr>
</table>

