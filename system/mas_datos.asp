<% @LCID = 1034 %>
<!--#include file="../lib/comunes/bdatos/ConectarSCG_R.inc" -->
<!--#include file="../lib/comunes/bdatos/ConectarCargas.inc"-->
<!--#include file="../lib/comunes/rutinas/funciones.inc" -->
<!--#include file="lib.asp"-->

<%
nrodoc = request.QueryString("nrodoc")
cliente = request.QueryString("cliente")
if cliente="40" then

ssql="SELECT TOP 1 numero_doc_oficial,numero_cuenta FROM ACSA_A1_DETALLE WHERE numero_documento='"&nrodoc&"'"
set rsCAT= ConexionCG.execute(ssql)
if not rsCAT.eof then
DOCOF = rsCAT("numero_doc_oficial")
CUENTA= rsCAT("numero_cuenta")
end if
rsCAT.close
set rsCAT=nothing
%>
<title>MAS DATOS</title><table width="180" height="167" border="0" bordercolor="#FFFFFF">
  <tr>
    <td height="21" bordercolor="#999999" bgcolor="#<%=session("COLTABBG")%>" class="Estilo20">DETALLE DE DOCUMENTO  : <%=nrodoc%></td>
  </tr>
  <tr>
    <td height="21" bordercolor="#999999" bgcolor="#<%=session("COLTABBG")%>" class="Estilo13">PATENTES ASOCIADAS</td>
  </tr>
  <tr>
    <td height="21" bordercolor="#999999" bgcolor="#FFFFFF">
      <%
	ssql="SELECT numero_patente FROM PATENTE WHERE cuenta_contrato='"&CUENTA&"'"
	set rsPAT= ConexionCG.execute(ssql)
		if not rsPAT.eof then
			do until rsPAT.eof
			%>
			<%="Nº "%>
			<%response.Write(rsPAT("numero_patente"))%>
			<br>
      <%rsPAT.movenext
			loop
		else%>
		<%response.Write("SIN PATENTE")%>
		<%end if
	rsPAT.close
	set rsPAT=nothing
	%>
    </td>
  </tr>
  <tr>
    <td height="21" bordercolor="#999999" bgcolor="#<%=session("COLTABBG")%>" class="Estilo13">CUENTA CONTRATO</td>
  </tr>
  <tr>
    <td height="21" bordercolor="#999999" bgcolor="#FFFFFF"><%=UCASE(CUENTA)%></td>
  </tr>
  <tr>
    <td height="21" bordercolor="#999999" bgcolor="#<%=session("COLTABBG")%>" class="Estilo13">DOCUMENTO OFICIAL</td>
  </tr>
  <tr>
    <td height="21" bordercolor="#999999" bgcolor="#FFFFFF"><%=UCASE(DOCOF)%></td>
  </tr>
</table>

<%
else
response.Write("DATA NO IMPLEMENTADA")
end if
%>
