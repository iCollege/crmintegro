<%@ Language=VBScript %>
<%Response.ContentType = "application/vnd.ms-excel"%>
<!--#include file="arch_utils.asp"-->
<!--#include file="../lib/comunes/rutinas/funciones.inc" -->
<!--#include file="lib.asp"-->


<%	
ejecutivo=request.QueryString("cobrador")
cliente = request.querystring("cliente")
inicio = request.QueryString("inicio")
termino = request.QueryString("termino")
%>
<title>INFORME DE COMPROMISOS DE PAGO CA&Iacute;DOS</title>
<style type="text/css">
<!--
.Estilo27 {color: #000000}
-->
</style>
<form name="datos" method="post">
	 <%
	abrirscg()
	ssql="SELECT DISTINCT RUTDEUDOR AS RUTDEUDOR FROM GESTIONES WHERE CodCobrador='"&ejecutivo&"' AND FechaCompromiso>='"&inicio&"' and FechaCompromiso<='"&termino&"' and CodCliente='"&cliente&"' And CodCategoria=1 And CodSubCategoria=2 and CodGestion=3 and FechaCompromiso is not null AND RUTDEUDOR NOT IN (SELECT RUTDEUDOR FROM GESTIONES WHERE FechaCompromiso>='"&termino&"' And CodCategoria=1 And CodSubCategoria=2 and CodGestion=3 And codcliente='"&cliente&"')"
    set rs = Conn.execute(ssql)
	if not rs.eof then
	 %>  
	
	<table width="59%"  border="1">
	<tr>
	   <td width="15%"><span class="Estilo37 Estilo37">RUT DEUDOR</span></td>	 
	   <td width="12%"><div align="left" class="Estilo37">MONTO ADEUDADO </div></td>	
	   <td width="15%">EJECUTIVO ASIGNADO</td>
      </tr>
	<%do until rs.eof
	
	ssql2="SELECT SUM(SALDO) AS SALDO,CODCOBRADOR FROM CUOTA WHERE RUTDEUDOR='"&rs("RUTDEUDOR")&"' AND CODCLIENTE='"&cliente&"' GROUP BY RUTDEUDOR,CODCOBRADOR"
	set rs2=Conn.execute(ssql2)
	if not rs2.eof then
		saldo = clng(rs2("SALDO"))
		ej_asignado = rs2("CODCOBRADOR")
	end if
	rs2.close
	set rs2=nothing
	
	IF clng(saldo) >0  THEN
	%>
	 <tr>
	   <td><span class="Estilo27"><%=rs("RUTDEUDOR")%></span></td>	 
	   <td><div align="right"><span class="Estilo27">
          <%=saldo%></span></div></td>	
	   <td><div align="right"><span class="Estilo27"><%=ej_asignado%></span></div></td>
      </tr>	 
	<%
	END IF
	rs.movenext
	loop
	%>  
    </table>
	<%end if
	rs.close
	set rs=nothing
	cerrarscg()
	%>
</form>
