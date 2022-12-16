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

strSql="SELECT ADIC1, ADIC2, ADIC3, ADIC4, ADIC5, ADIC91, ADIC92, ADIC93, ADIC94, ADIC95, ADIC96, ADIC97, ADIC98, ADIC99, ADIC100 FROM CUOTA WHERE IDCUOTA = " & idcuota
'response.write "strSql=" & strSql
'Response.End
set rsDET=Conn.execute(strSql)
strPatentes = ""
if Not rsDET.eof Then
	strAdic1 = rsDET("ADIC1")
	strAdic2 = rsDET("ADIC2")
	strAdic3 = rsDET("ADIC3")
	strAdic4 = rsDET("ADIC4")
	strAdic5 = rsDET("ADIC5")
	strAdic91 = rsDET("ADIC91")
	strAdic92 = rsDET("ADIC92")
	strAdic93 = rsDET("ADIC93")
	strAdic94 = rsDET("ADIC94")
	strAdic95 = rsDET("ADIC95")
	strAdic96 = rsDET("ADIC96")
	strAdic97 = rsDET("ADIC97")
	strAdic98 = rsDET("ADIC98")
	strAdic99 = rsDET("ADIC99")
	strAdic100 = rsDET("ADIC100")
End If

strSql="SELECT IsNull(ADIC1,'ADIC1') as ADIC1, IsNull(ADIC2,'ADIC2') as ADIC2, IsNull(ADIC3,'ADIC3') as ADIC3, IsNull(ADIC4,'ADIC4') as ADIC4, IsNull(ADIC5,'ADIC5') as ADIC5, IsNull(ADIC91,'ADIC91') as ADIC91, IsNull(ADIC92,'ADIC92') as ADIC92, IsNull(ADIC93,'ADIC93') as ADIC93, IsNull(ADIC94,'ADIC94') as ADIC94, IsNull(ADIC95,'ADIC95') as ADIC95, IsNull(ADIC96,'ADIC96') as ADIC96, IsNull(ADIC97,'ADIC97') as ADIC97, IsNull(ADIC98,'ADIC98') as ADIC98, IsNull(ADIC99,'ADIC99') as ADIC99, IsNull(ADIC100,'ADIC100') as ADIC100 FROM CLIENTE WHERE CODCLIENTE = '" & cliente & "'"
'response.write "strSql=" & strSql
'Response.End
set rsDET=Conn.execute(strSql)
if Not rsDET.eof Then
	strNombreAdic1 = rsDET("ADIC1")
	strNombreAdic2 = rsDET("ADIC2")
	strNombreAdic3 = rsDET("ADIC3")
	strNombreAdic4 = rsDET("ADIC4")
	strNombreAdic5 = rsDET("ADIC5")
	strNombreAdic91 = rsDET("ADIC91")
	strNombreAdic92 = rsDET("ADIC92")
	strNombreAdic93 = rsDET("ADIC93")
	strNombreAdic94 = rsDET("ADIC94")
	strNombreAdic95 = rsDET("ADIC95")
	strNombreAdic96 = rsDET("ADIC96")
	strNombreAdic97 = rsDET("ADIC97")
	strNombreAdic98 = rsDET("ADIC98")
	strNombreAdic99 = rsDET("ADIC99")
	strNombreAdic100 = rsDET("ADIC100")
End If


%>
<title>MAS DATOS</title><table width="350" height="167" border="0" bordercolor="#FFFFFF">
  <tr>
    <td height="21" bordercolor="#999999" bgcolor="#<%=session("COLTABBG")%>" class="Estilo20" colspan="4">
    OTROS DETALLE DE DEUDA RUT CLIENTE : <%=strRutDeudor%></td>
  </tr>
  	<tr  height="17" bordercolor="#999999" bgcolor="#<%=session("COLTABBG")%>" class="Estilo13">
		<td width="50%"><%=strNombreAdic1%></td><td><%=strAdic1%></td>
	</tr>
	<tr  height="17" bordercolor="#999999" bgcolor="#<%=session("COLTABBG")%>" class="Estilo13">
		<td><%=strNombreAdic2%></td><td><%=strAdic2%></td>
	</tr>
	<tr  height="17" bordercolor="#999999" bgcolor="#<%=session("COLTABBG")%>" class="Estilo13">
		<td><%=strNombreAdic3%></td><td><%=strAdic3%></td>
	</tr>
	<tr  height="17" bordercolor="#999999" bgcolor="#<%=session("COLTABBG")%>" class="Estilo13">
		<td><%=strNombreAdic4%></td><td><%=strAdic4%></td>
	</tr>
	<tr  height="17" bordercolor="#999999" bgcolor="#<%=session("COLTABBG")%>" class="Estilo13">
		<td><%=strNombreAdic5%></td><td><%=strAdic5%></td>
	</tr>
	<tr  height="17" bordercolor="#999999" bgcolor="#<%=session("COLTABBG")%>" class="Estilo13">
		<td><%=strNombreAdic91%></td><td><%=strAdic91%></td>
	</tr>
	<tr  height="17" bordercolor="#999999" bgcolor="#<%=session("COLTABBG")%>" class="Estilo13">
		<td><%=strNombreAdic92%></td><td><%=strAdic92%></td>
	</tr>
	<tr  height="17" bordercolor="#999999" bgcolor="#<%=session("COLTABBG")%>" class="Estilo13">
		<td><%=strNombreAdic93%></td><td><%=strAdic93%></td>
	</tr>
	<tr  height="17" bordercolor="#999999" bgcolor="#<%=session("COLTABBG")%>" class="Estilo13">
		<td><%=strNombreAdic94%></td><td><%=strAdic94%></td>
	</tr>
	<tr  height="17" bordercolor="#999999" bgcolor="#<%=session("COLTABBG")%>" class="Estilo13">
		<td><%=strNombreAdic95%></td><td><%=strAdic95%></td>
	</tr>
	<tr  height="17" bordercolor="#999999" bgcolor="#<%=session("COLTABBG")%>" class="Estilo13">
		<td><%=strNombreAdic96%></td><td><%=strAdic96%></td>
	</tr>
	<tr  height="17" bordercolor="#999999" bgcolor="#<%=session("COLTABBG")%>" class="Estilo13">
		<td><%=strNombreAdic97%></td><td><%=strAdic97%></td>
	</tr>
	<tr  height="17" bordercolor="#999999" bgcolor="#<%=session("COLTABBG")%>" class="Estilo13">
		<td><%=strNombreAdic98%></td><td><%=strAdic98%></td>
	</tr>
	<tr  height="17" bordercolor="#999999" bgcolor="#<%=session("COLTABBG")%>" class="Estilo13">
		<td><%=strNombreAdic99%></td><td><%=strAdic99%></td>
	</tr>
	<tr  height="17" bordercolor="#999999" bgcolor="#<%=session("COLTABBG")%>" class="Estilo13">
		<td><%=strNombreAdic100%></td><td><%=strAdic100%></td>
	</tr>
  <% CerrarSCG() %>
</table>

