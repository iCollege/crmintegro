<% @LCID = 1034 %>
<!--#include file="arch_utils.asp"-->
<!--#include file="../lib/comunes/rutinas/funciones.inc" -->
<!--#include file="lib.asp"-->
<!--#include file="asp/comunes/general/SoloNumeros.inc" -->
<%
idGestion=request.QueryString("gestion")
abrirscg()
strSql="SELECT * FROM GESTIONES WHERE ID_GESTION = '" & idGestion & "'"
set rsGestCat=Conn.execute(strSql)
do until rsGestCat.eof

%>
<title>VER DETALLES DEL TICKET</title>
<style type="text/css">
<!--
.Estilo35 {color: #333333}
.Estilo36 {color: #FFFFFF}
.Estilo37 {color: #000000}
-->
</style>
<table align="center" width="1000" border="0">

 </table>
 <table align="center" width="1000" border="0">
  <tr>
  	<TD width="50%" height="30" ALIGN=LEFT class="pasos">
		<B>Modulo Ingreso de Gestiones</B>
	</TD>
    <TD width="50%" height="30" ALIGN=LEFT class="pasos">
		<B>VER DETALLE</B>
	</TD>
  </tr>
 </table>
 
<form action="" method="post" name="datos">
<table width="500" align="center" border="0">
  <tr>
  <td height="2" colspan="2"></td>	
  </tr>
  <tr>
  <td><strong>Ticket:</strong></td>
  <td><input type="text" disabled value="<%=rsGestCat("Id_Gestion")%>"></td> 
  </tr>
  

  <tr>
  <td><strong>Fecha y hora:</strong></td>
  <td><input type="text" disabled value="<%=rsGestCat("FechaIngreso")%>"></td> 
  </tr>
  
  <tr>
  <td><strong>Observacion:&nbsp;&nbsp;&nbsp;&nbsp;</strong></td>
  <td><input NAME="observacion" id="observacion" style="border:1px solid #B8B8B8; width:400px;height:50px;" disabled value="<%=rsGestCat("Observaciones")%>"></td>
  </tr>
  
<%
dim nomSubCat 
nomSubCat =rsGestCat("CodSubCategoria")
strSql2="SELECT * FROM Gestiones_Tipo_SubCategoria WHERE CodCategoria = '2' AND CodSubCategoria = '" & nomSubCat & "'"
set rs=Conn.execute(strSql2)
do until rs.eof
%>

  <tr>
  <td><strong>Sub&nbsp;Categoria:&nbsp;&nbsp;&nbsp;&nbsp;</strong></td>
  <td><input NAME="sub" id="sub" style="border:1px solid #B8B8B8;width:300px;" disabled value="<%=rs("Descripcion")%>"></td>
  </tr>
<%
rs.Movenext
loop
rs.close
set rs=nothing
%>

  <tr>
  <td></td>
  <td><input name="Volver" type="button" class="Estilo8" onClick="history.back();" value="Volver"></td>
  </tr>
  
	
</table>
</form>
<%
rsGestCat.Movenext
loop
rsGestCat.close
set rsGestCat=nothing
CerrarSCG()
%>