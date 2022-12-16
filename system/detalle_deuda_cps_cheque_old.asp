<% @LCID = 1034 %>
<!--#include file="arch_utils.asp"-->
<!--#include file="../lib/comunes/rutinas/funciones.inc" -->
<!--#include file="lib.asp"-->

<% total_docs=0
total_INT=0
total_GC=0
total_docs=0
total=0
total_saldo=0

	rut = request.QueryString("rut")
	cliente=request.QueryString("cliente")
    abrirscg()
	ssql=""
	ssql="SELECT razon_social_cliente FROM CLIENTE WHERE codigo_cliente='"&cliente&"'"
	set rsCLI=Conn.execute(ssql)
	if not rsCLI.eof then
	nombre_cliente=rsCLI("razon_social_cliente")
	end if
	rsCLI.close
	set rsCLI=nothing
	cerrarscg()

	%>
<title>DETALLE DE DEUDA</title>
<table width="680" height="429" border="0">
  <tr>
    <td height="20" class="Estilo20"><img src="../lib/DETALLE_DEUDA.gif" width="740" height="22"></td>
  </tr>
  <tr>
    <td height="20" class="Estilo20"><img src="../lib/<%=cliente%>.gif" width="740" height="22"></td>
  </tr>
  <tr>
    <td height="373" valign="top" background="../images/fondo_coventa.jpg">
      <%
	if not rut="" then
	abrirscg()
	ssql=""
	ssql="SELECT FECHAVENC,NRODOC,VALORCUOTA,SALDO,GASTOSCOBRANZAS,INTERESES,CODCOBRADOR,NROCUOTA FROM CUOTA WHERE RUTDEUDOR='"&rut&"' AND CODCLIENTE='"&cliente&"'"

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
		  <td width="12%">INTERESES</td>
          <td width="12%">COBRADOR</td>

        </tr>
		<%do until rsDET.eof
		%>
        <tr bordercolor="#999999" >

          <td>N&ordm; <%=rsDET("NRODOC")%></td>
          <!-- <td><a href="javascript:ventanaMas('mas_datos.asp?nrodoc=<%=trim(rsDET("NRODOC"))%>&cliente=<%=cliente%>')">VER</a></td> -->
          <td><div align="left" >  <%=FormatDateTime(rsDET("FECHAVENC"),2)%></div></td>
          <td><div align="right">$ <%=FN(rsDET("VALORCUOTA"),0)%></div></td>
          <td><div align="right">$ <%=FN(rsDET("SALDO"),0)%></div></td>
          <td><div align="right" >$ <%
		  total_docs=total_docs+1
		  total=total+FN(rsDET("VALORCUOTA"),0)
		  total_saldo=total_saldo+FN(rsDET("SALDO"),0)
		  if not isnull(rsDET("GASTOSCOBRANZAS")) then
			  response.Write(FN(rsDET("GASTOSCOBRANZAS"),0))
			  total_GC=total_GC+FN(rsDET("GASTOSCOBRANZAS"),0)
		  else
		  		response.Write("0")
		  end if
		  %></div></td>
		  <td><div align="right" >$ <%
		  if not isnull(rsDET("INTERESES")) then
		  response.Write(FN(rsDET("INTERESES"),0))
		  total_INT=total_INT+ FN(rsDET("INTERESES"),0)
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



        </tr>
		 <%rsDET.movenext
		 loop
		 %>
      </table>

      <table width="87%" border="0">
        <tr>
          <td width="15%" height="33" bgcolor="#<%=session("COLTABBG")%>"><span class="Estilo27">DOCUMENTOS
            : <%=total_docs%></span></td>
          <td width="26%" bgcolor="#<%=session("COLTABBG")%>"><div align="left"><span class="Estilo27">TOTALES</span></div></td>
          <td width="15%" bgcolor="#<%=session("COLTABBG2")%>"><div align="right">$ <%=FN(total,0)%></div></td>
          <td width="15%" bgcolor="#<%=session("COLTABBG2")%>"><div align="right"><span class="Estilo28">$
              <%=FN(total_saldo,0)%></span></div></td>
          <td width="15%" bgcolor="#<%=session("COLTABBG2")%>"><div align="right"><span class="Estilo28">$
              <%=FN(total_GC,0)%></span></div></td>
          <td width="14%" bgcolor="#<%=session("COLTABBG2")%>"><div align="right"><span class="Estilo28">$
              <%=FN(total_INT,0)%></span></div></td>
        </tr>
      </table>
      <br>
      <br> <strong>
      <%total_pg = total_saldo + total_int + total_gc %>
      TOTAL A PAGAR : $ <%=FN(total_pg,0)%> </strong> <p>
      <div align="right"> <br>
        <br>
        <strong><span class="Estilo20"> </span>FECHA : <%=DATE%> HORA : <%=TIME%>
        <p></p>
        </strong>
        <p align="left">&nbsp;</p>
        <p align="left"><strong><span class="Estilo20"> </span></strong></p>
        <p align="left"><strong><span class="Estilo20">
          <input name="imp" type="button" onClick="window.print();" value="Imprimir Ficha">
          </span></strong><strong><span class="Estilo20"> </span></strong><span class="Estilo20">
          </span></p>
      </div></td>
  </tr>
</table>
	  <%end if
	  rsDET.close
	  set rsDET=nothing
	  cerrarscg()
	  %>
	  <%end if%>
<script language="JavaScript" type="text/JavaScript">
function ventanaMas (URL){
window.open(URL,"DATOS","width=200, height=300, scrollbars=no, menubar=no, location=no, resizable=yes")
}
</script>
