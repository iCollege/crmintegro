<% @LCID = 1034 %>
<!--#include file="arch_utils.asp"-->
<!--#include file="../lib/comunes/rutinas/funciones.inc" -->
<!--#include file="lib.asp"-->
<%
nrodoc = request("nrodoc")
cliente = request("cliente")
strRutDeudor = request("strRutDeudor")
idcuota = request("idcuota")

strNroDoc=Request("strNroDoc")
strNroCuota=Request("strNroCuota")
strSucursal=Request("strSucursal")
strCodRemesa=Request("strCodRemesa")

AbrirSCG()

strSql="SELECT RUT, PATENTE FROM PATENTES WHERE RUT = '" & strRutDeudor & "' AND CODCLIENTE = '" & cliente & "'"
'response.write "strSql=" & strSql
'Response.End
set rsDET=Conn.execute(strSql)
strPatentes = ""
Do while not rsDET.eof
	strPatentes = strPatentes & " ; " & rsDET("PATENTE")
	rsDET.movenext
Loop

strPatentes = Mid(strPatentes,3,len(strPatentes))



%>
<title>MAS DATOS</title><table width="350" height="167" border="0" bordercolor="#FFFFFF">
  <tr>
    <td height="21" bordercolor="#999999" bgcolor="#<%=session("COLTABBG")%>" class="Estilo20" colspan="4">
    OTROS DETALLE DE DEUDA RUT CLIENTE : <%=strRutDeudor%></td>
  </tr>
  	<tr  height="17" bordercolor="#999999" bgcolor="#<%=session("COLTABBG")%>" class="Estilo13">
		<td>Patentes</td>
	</tr>

  <tr>
     <td height="21" bordercolor="#999999" bgcolor="#FFFFFF"><%=strPatentes%></td>
  </tr>
  <% CerrarSCG() %>
</table>

