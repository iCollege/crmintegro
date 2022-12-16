<%@ Language=VBScript %>
<%Response.ContentType = "application/vnd.ms-excel"%>
<!--#include file="../lib/comunes/bdatos/ConectarSCG_R.inc" -->
<!--#include file="../lib/comunes/bdatos/ConectarCargas.inc"-->
<!--#include file="../lib/comunes/rutinas/funciones.inc" -->
<!--#include file="lib.asp"-->

<%
cliente = request.querystring("cliente")
ejecutivo = request.QueryString("ejecutivo")
remesa = request.QueryString("remesa")
%>
<title>ASIGNACION POR EJECUTIVO</title>

<style type="text/css">
<!--
.Estilo37 {color: #FFFFFF}
-->
</style>
<%
if not ejecutivo="TODOS" then
ssql="SELECT RUTDEUDOR,SUM(SALDO) AS SALDO, CODCOBRADOR FROM CUOTA WHERE SALDO>0 AND CODCLIENTE='"&CLIENTE&"' AND CODCOBRADOR='"&ejecutivo&"' AND CODREMESA='"&remesa&"' GROUP BY RUTDEUDOR,CODCOBRADOR ORDER BY SALDO DESC"
else
ssql="SELECT RUTDEUDOR,SUM(SALDO) AS SALDO, CODCOBRADOR FROM CUOTA WHERE SALDO>0 AND CODCLIENTE='"&CLIENTE&"' AND CODREMESA='"&remesa&"' GROUP BY CODCOBRADOR,RUTDEUDOR ORDER BY SALDO DESC"

end if
set rsASIG = conexionSCG.execute(ssql)
if not rsASIG.eof then

%>
<table width="56%"  border="0">
  <tr>
    <td width="15%">RUT</td>
    <td width="18%">CLIENTE</td>
    <td width="32%">MONTO DEUDA </td>
    <td width="23%">EJECUTIVO</td>
  </tr>
  <%do until rsASIG.eof%>
  <tr>
    <td><%=rsASIG("RUTDEUDOR")%></td>
    <td><%=cliente%></td>
    <td><%=rsASIG("SALDO")%></td>
    <td><%=rsASIG("CODCOBRADOR")%></td>
  </tr>
  <%rsASIG.movenext
  loop
  %>
</table>

<%
end if
rsASIG.close
set rsASIG = Nothing

%>
