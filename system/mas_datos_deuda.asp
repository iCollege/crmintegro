<% @LCID = 1034 %>
<!--#include file="arch_utils.asp"-->
<!--#include file="../lib/comunes/rutinas/funciones.inc" -->
<!--#include file="lib.asp"-->

<%
nrodoc = request("nrodoc")
cliente = request("cliente")

strNroDoc=Request("strNroDoc")
strNroCuota=Request("strNroCuota")
strSucursal=Request("strSucursal")
strCodRemesa=Request("strCodRemesa")

%>
<title>MAS DATOS</title><table width="180" height="167" border="0" bordercolor="#FFFFFF">
  <tr>
    <td height="21" bordercolor="#999999" bgcolor="#<%=session("COLTABBG")%>" class="Estilo20">
    OTROS DETALLE DE DEUDA <br> NUM CLIENTE : <%=nrodoc%></td>
  </tr>
  <tr>
    <td height="21" bordercolor="#999999" bgcolor="#FFFFFF">
		<%

		%>
    </td>
  </tr>
  <tr>
      <td height="21" bordercolor="#999999" bgcolor="#<%=session("COLTABBG")%>" class="Estilo13">PATENTES</td>
    </tr>
    <tr>
      <td height="21" bordercolor="#999999" bgcolor="#FFFFFF"><%=strPatentes%></td>
  </tr>
  <tr>
    <td height="21" bordercolor="#999999" bgcolor="#<%=session("COLTABBG")%>" class="Estilo13">NRO. DOC</td>
  </tr>
  <tr>
    <td height="21" bordercolor="#999999" bgcolor="#FFFFFF"><%=strNroDoc%></td>
  </tr>
  <tr>
    <td height="21" bordercolor="#999999" bgcolor="#<%=session("COLTABBG")%>" class="Estilo13">REMESA</td>
  </tr>
  <tr>
    <td height="21" bordercolor="#999999" bgcolor="#FFFFFF"><%=strCodRemesa%></td>
  </tr>
</table>

