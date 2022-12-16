<% @LCID = 1034 %>
<!--#include file="arch_utils.asp"-->
<!--#include file="../lib/comunes/rutinas/funciones.inc" -->
<!--#include file="lib.asp"-->

<%
	rut = request.QueryString("rut")
	clientes = request.QueryString("cliente")
	'response.write(rut)
    'abrirscg()
	'ssql=""
	'ssql="select codcliente from cuota where rutdeudor='"&rut&"' group by codcliente"
	'set rsCLI=Conn.execute(ssql)
	'if not rsCLI.eof then
	'cliente=rsCLI("codcliente")
	'end if
	'rsCLI.close
	'set rsCLI=nothing
	'cerrarscg()

	%>
<title>Detalle de Ingreso BACKOFFICE</title>
<table width="640" height="420" border="0">
  <tr>
    <td height="20" class="Estilo20"><img src="../lib/DETALLE_DEUDA.gif" width="640" height="22"></td>
  </tr>
  <tr>
    <td height="20" class="Estilo20"></td>
  </tr>
  <tr>
    <td valign="top" background="../images/fondo_coventa.jpg">
	<%
	if not rut="" then
	abrirscg()
	ssql=""
	ssql="SELECT FECHAVENC,NRODOC,VALORCUOTA,SALDO,isnull(GASTOSCOBRANZAS,0) as GASTOSCOBRANZAS,CODCOBRADOR,NROCUOTA FROM CUOTA WHERE RUTDEUDOR='"&rut&"' AND CODCLIENTE='"&clientes&"'"
	'response.Write(ssql)
	'response.End()
	set rsDET=Conn.execute(ssql)
	if not rsDET.eof then
	%>
	  <table width="100%" border="0" bordercolor="#FFFFFF">
        <tr bordercolor="#999999" bgcolor="#<%=session("COLTABBG")%>" class="Estilo13">
          <td width="15%">DOCUMENTO</td>
          <td width="10%">MAS DATOS</td>
          <td width="8%">FECHA VENC</td>
          <td width="12%">MONTO</td>
          <td width="12%">SALDO</td>
          <td width="12%">G.COBRANZAS</td>
          <td width="12%">COBRADOR</td>

        </tr>
		<%do until rsDET.eof
		%>
        <tr bordercolor="#999999" >
          <td>N&ordm; <%=rsDET("NRODOC")%></td>
          <td><a href="javascript:ventanaMas('mas_datos.asp?nrodoc=<%=trim(rsDET("NRODOC"))%>&cliente=<%=cliente%>')">VER</a></td>

		  <td><div align="left" >  <%=FormatDateTime(rsDET("FECHAVENC"),2)%></div></td>

          <td><div align="right">$ <%=FN(rsDET("VALORCUOTA"),0)%></div></td>
          <td><div align="right">$ <%=FN(rsDET("SALDO"),0)%></div></td>
          <td><div align="right" >$ <%
		  if not isnull(rsDET("GASTOSCOBRANZAS")) then
		  response.Write(FN(rsDET("GASTOSCOBRANZAS"),0))
		  else
		  response.Write("0")
		  end if
		  %></div></td>
          <td><div align="right" ><%If Not rsDET("CODCOBRADOR")="0" Then %>
		  <%=rsDET("CODCOBRADOR")%>
		  <%else%>
		  <%="SIN COBRADOR"%>
		  <%End If%>
		  </div></td>
		 <%
		total= total + clng(rsDET("VALORCUOTA"))
		total_saldo = total_saldo + clng(rsDET("SALDO"))
		total_gc = total_gc + clng(rsDET("GASTOSCOBRANZAS"))
		total_docs = total_docs + 1
			%></tr>
		 <%rsDET.movenext
		 loop
		 %>
		 <tr>
          <td  bgcolor="#<%=session("COLTABBG")%>"><span class="Estilo27">DOCUMENTOS : <%=total_docs%></span></td>
          <td  bgcolor="#<%=session("COLTABBG")%>"><span class="Estilo27"></span></td>
          <td  bgcolor="#<%=session("COLTABBG2")%>"><div align="right"><span class="Estilo28"></span></div></td>
          <td  bgcolor="#<%=session("COLTABBG2")%>"><div align="right"><span class="Estilo28">$ <%=FN(total,0)%></span></div></td>
		  <td  bgcolor="#<%=session("COLTABBG2")%>"><div align="right"><span class="Estilo27">$ <%=FN(total_saldo,0)%></span></div></td>
          <td  bgcolor="#<%=session("COLTABBG2")%>"><div align="right"><span class="Estilo28">$ <%=FN(total_gc,0)%></span></div></td>
          <td  bgcolor="#<%=session("COLTABBG2")%>"><div align="right"><span class="Estilo28"></span></div></td>
        </tr>

      </table>
	  <%end if
	  rsDET.close
	  set rsDET=nothing
	  cerrarscg()
	  %>
	  <%end if%>
    </td>
  </tr>
  <tr>
<td>
<input name="imp" type="button" onClick="window.print();" value="Imprimir Ficha">
</td>
</tr>
</table>
<script language="JavaScript" type="text/JavaScript">
function ventanaMas (URL){
window.open(URL,"DATOS","width=200, height=300, scrollbars=no, menubar=no, location=no, resizable=yes")
}
</script>
