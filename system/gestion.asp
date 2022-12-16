<% @LCID = 1034 %>
<!--#include file="arch_utils.asp"-->
<!--#include file="../lib/comunes/rutinas/funciones.inc" -->
<!--#include file="lib.asp"-->

<%
categoria = request.QueryString("categoria")
subcategoria = request.QueryString("subcategoria")
gestion = request.QueryString("gestion")
if gestion="" then
gestion="0"
end if

abrirscg()
ssql="SELECT Descripcion FROM Gestiones_Tipo_Categoria WHERE CodCategoria='"&cint(categoria)&"'"
set rsCAT= Conn.execute(ssql)
if not rsCAT.eof then
categoria_nombre = rsCAT("Descripcion")
end if
rsCAT.close
set rsCAT=nothing
cerrarscg()


abrirscg()
ssql="SELECT Descripcion FROM Gestiones_Tipo_SubCategoria WHERE CodCategoria='"&cint(categoria)&"' and CodSubCategoria='"&cint(subcategoria)&"'"
set rsCAT= Conn.execute(ssql)
if not rsCAT.eof then
subcategoria_nombre = rsCAT("Descripcion")
end if
rsCAT.close
set rsCAT=nothing
cerrarscg()
'RESPONSE.WRITE(GESTION)
if categoria="1" and subcategoria="2" and gestion="8" then
gestion_nombre="Rompe compromiso de pago"
else
	abrirscg()
	ssql="SELECT Descripcion FROM Gestiones_Tipo_Gestion WHERE CodCategoria='"&cint(categoria)&"' and CodSubCategoria='"&cint(subcategoria)&"' and CodGestion='"&cint(gestion)&"'"
	set rsCAT= Conn.execute(ssql)
	if not rsCAT.eof then
	gestion_nombre = rsCAT("Descripcion")
	end if
	rsCAT.close
	set rsCAT=nothing
	cerrarscg()
end if

%>
<title>DESCRIPCION DE GESTION</title><table width="180" height="167" border="0" bordercolor="#FFFFFF">
  <tr>
    <td height="21" bordercolor="#999999" bgcolor="#<%=session("COLTABBG")%>" class="Estilo20">CODIGO DE GESTION : <%=categoria%><%=subcategoria%><%=gestion%></td>
  </tr>
  <tr>
    <td height="21" bordercolor="#999999" bgcolor="#<%=session("COLTABBG")%>" class="Estilo13">CATEGORIA</td>
  </tr>
  <tr>
    <td height="21" bordercolor="#999999" bgcolor="#FFFFFF"><%=UCASE(categoria_nombre)%></td>
  </tr>
  <tr>
    <td height="21" bordercolor="#999999" bgcolor="#<%=session("COLTABBG")%>" class="Estilo13">SUBCATEGORIA</td>
  </tr>
  <tr>
    <td height="21" bordercolor="#999999" bgcolor="#FFFFFF"><%IF UCASE(subcategoria_nombre)="" THEN RESPONSE.WRITE("SIN GESTION") ELSE RESPONSE.Write(UCASE(subcategoria_nombre))%></td>
  </tr>
  <tr>
    <td height="21" bordercolor="#999999" bgcolor="#<%=session("COLTABBG")%>" class="Estilo13">GESTION</td>
  </tr>
  <tr>
    <td height="21" bordercolor="#999999" bgcolor="#FFFFFF"><% IF UCASE(gestion_nombre)="" THEN RESPONSE.WRITE("SIN GESTION") ELSE RESPONSE.Write(UCASE(gestion_nombre))%></td>
  </tr>
</table>
