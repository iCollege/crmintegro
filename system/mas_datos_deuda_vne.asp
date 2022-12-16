<% @LCID = 1034 %>
<!--#include file="arch_utils.asp"-->
<!--#include file="../lib/comunes/rutinas/funciones.inc" -->
<!--#include file="lib.asp"-->

<%
nrodoc = request("nrodoc")
cliente = request("cliente")
idcuota = request("idcuota")

strNroDoc=Request("strNroDoc")
strNroCuota=Request("strNroCuota")
strSucursal=Request("strSucursal")
strCodRemesa=Request("strCodRemesa")

AbrirSCG()

strSql="SELECT RUTDEUDOR, CODCLIENTE, NRODOC, INTERLOCUTOR_COMERCIAL,NRODOC_SAP, OFICINA_COBRO, CODREMESA FROM DETCUOTA_VNE WHERE IDCUOTA = " & idcuota
set rsDET=Conn.execute(strSql)
If not rsDET.eof then
	strInterComercial = rsDET("INTERLOCUTOR_COMERCIAL")
	strDocSap = rsDET("NRODOC_SAP")
	strOficinaCobro = rsDET("OFICINA_COBRO")
	strNroDoc = rsDET("NRODOC")
	strCodRemesa = rsDET("CODREMESA")
	strRutDeudor = rsDET("RUTDEUDOR")
Else
	strInterComercial = ""
	strDocSap = ""
	strDocSap = ""
	strNroDoc = ""
	strCodRemesa = ""
	strRutDeudor = ""
End If



%>
<title>MAS DATOS</title><table width="350" height="167" border="0" bordercolor="#FFFFFF">
  <tr>
    <td height="21" bordercolor="#999999" bgcolor="#<%=session("COLTABBG")%>" class="Estilo20" colspan="4">
    OTROS DETALLE DE DEUDA RUT CLIENTE : <%=strRutDeudor%></td>
  </tr>
  	<tr  height="17" bordercolor="#999999" bgcolor="#<%=session("COLTABBG")%>" class="Estilo13">
		<td>Interl.Comercial</td>
		<td>Nro.Doc.SAP</td>
		<td>Ofic.Cobro</td>
		<td>Remesa</td>
	</tr>
	<% Do While Not rsDET.eof
			strInterComercial = rsDET("INTERLOCUTOR_COMERCIAL")
			strDocSap = rsDET("NRODOC_SAP")
			strOficinaCobro = rsDET("OFICINA_COBRO")
			strNroDoc = rsDET("NRODOC")
			strCodRemesa = rsDET("CODREMESA")
			strRutDeudor = rsDET("RUTDEUDOR")
	%>
  <tr>
     <td height="21" bordercolor="#999999" bgcolor="#FFFFFF"><%=strInterComercial%></td>
     <td height="21" bordercolor="#999999" bgcolor="#FFFFFF"><%=strDocSap%></td>
     <td height="21" bordercolor="#999999" bgcolor="#FFFFFF"><%=strOficinaCobro%></td>
     <td height="21" bordercolor="#999999" bgcolor="#FFFFFF"><%=strCodRemesa%></td>
  </tr>

  <%
  rsDET.movenext
  Loop

  CerrarSCG()
  %>

</table>

