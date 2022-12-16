<% @LCID = 1034 %>

<!--#include file="arch_utils.asp"-->
<!--#include file="../lib/comunes/rutinas/funciones.inc" -->
<!--#include file="lib.asp"-->
<%

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
<style type="text/css">
<!--
.Estilo27 {color: #FFFFFF}
.Estilo28 {color: #000000}
.Estilo32 {color: #FFFFFF; font-size: x-small; }
-->
</style>
<table width="680" height="420" border="0">
  <tr>
    <td height="20"><img src="file://///ICARUS/SCG-WEB/lib/DETALLE_DEUDA.gif" width="740" height="22"></td>
  </tr>
  <tr>
    <td height="20"><img src="file://///ICARUS/SCG-WEB/lib/36.gif" width="740" height="22"></td>
  </tr>
  <tr>
    <td valign="top" background="file://///ICARUS/SCG-WEB/images/fondo_coventa.jpg">
	<p align="right">
	  <%if not rut="" then%>
      <%

      abrirscg()
		ssql="SELECT TOP 1 NOMBREDEUDOR,RUTDEUDOR FROM DEUDOR WHERE RUTDEUDOR='"&rut&"' AND NOMBREDEUDOR IS NOT NULL AND LTRIM(RTRIM(NOMBREDEUDOR)) <> '' "
		set rsDEU=Conn.execute(ssql)
		if not rsDEU.eof then
			nombre_deudor = rsDEU("NOMBREDEUDOR")
			rut_deudor = rsDEU("RUTDEUDOR")
		end if
		rsDEU.close
		set rsDEU=nothing


		ssql=""
		ssql="SELECT TOP 1 Calle,Numero,Comuna,Correlativo FROM DEUDOR_DIRECCION WHERE RUTDEUDOR='"&rut_deudor&"' ORDER BY Correlativo DESC"
		set rsDIR=Conn.execute(ssql)
		if not rsDIR.eof then
			calle_deudor=rsDIR("Calle")
			numero_deudor=rsDIR("Numero")
			comuna_deudor=rsDIR("Comuna")
			correlativo_deudor=rsDIR("Correlativo")
		end if
		rsDIR.close
		set rsDIR=nothing


		ssql=""
		ssql="SELECT TOP 1 CodArea,Telefono,Correlativo FROM DEUDOR_TELEFONO WHERE  RUTDEUDOR='"&rut_deudor&"' ORDER BY Correlativo DESC"
		set rsFON=Conn.execute(ssql)
		if not rsFON.eof then
			codarea_deudor = rsFON("CodArea")
			Telefono_deudor = rsFON("Telefono")
			Correlativo_deudor2 = rsFON("Correlativo")
		end if
		rsFON.close
		set rsFON=nothing

		cerrarscg()

		%>
      <br>
      <strong>EJECUTIVO :</strong> <%=response.Write(session("session_login"))%>
	<table width="100%" border="0" bordercolor="#FFFFFF">
      <tr bordercolor="#999999" bgcolor="#<%=session("COLTABBG")%>" class="Estilo13">
        <td width="31%" >RUT</td>
        <td width="50%" >NOMBRE O RAZ&Oacute;N SOCIAL </td>
      </tr>
      <tr class="Estilo8">
        <td><%=rut_deudor%></td>
        <td><%=nombre_deudor%></td>
      </tr>
    </table>
	<table width="100%" border="0" bordercolor="#FFFFFF">
      <tr bordercolor="#999999" bgcolor="#<%=session("COLTABBG")%>" class="Estilo13">
        <td width="70%">DIRECCION</td>
        <td width="30%">TELEFONO</td>
      </tr>
      <tr class="Estilo8">
        <td>
		<%if not calle_deudor="" then%>
		<%=calle_deudor%> N&ordm; <%=numero_deudor%> - <%=comuna_deudor%>
		<%end if%>
		</td>
        <td><%if not telefono_deudor="" then%>
            <%=codarea_deudor%>-<%=telefono_deudor%>
            <%end if%></td>
      </tr>
    </table>
        <%
    abrirscg()
	ssql=""
	ssql="SELECT seriedecimal,NRODOC,VALORCUOTA,SALDO,GASTOSCOBRANZAS,FECHAEMISION,TIPOPRODUCTO,FECHAVENC,CODCOBRADOR,INTERESES,NROCUOTA,datediff(day,fechaemision,getdate()) AS DIASMORA,    glosa,left(glosa,1) as a, CASE LEN(glosa)	when 16 then right(glosa,1) 	when 15 then '' END as b , CASE LEN(glosa) WHEN 15 THEN right(glosa,1) 	WHEN 16 THEN LEFT(RIGHT(GLOSA,2),1) END AS C FROM CUOTA WHERE RUTDEUDOR='"&rut&"' AND CODCLIENTE='"&cliente&"'"
	'ssql="SELECT NRODOC,VALORCUOTA,SALDO,UTILIDAD_EMPRESAGASTOSCOBRANZAS,FECHAEMISION,TIPOPRODUCTO,FECHAVENC,CODCOBRADOR,INTERESES,NROCUOTA FROM CUOTA WHERE RUTDEUDOR='"&rut&"' AND CODCLIENTE='"&cliente&"'"

	set rsDET=Conn.execute(ssql)
	if not rsDET.eof then



	IF RSDET("b")=""  THEN
		GLOSA="CARTERA NORMAL"
	ELSEIF RSDET("b")="A" THEN
		GLOSA="CARTERA RENEGOCIADA DURA"
	ELSEIF RSDET("b")="N" THEN
		GLOSA="CARTERA RENEGOCIADA"
	else
		glosa=" "
	END IF


	'IF RSDET("seriedecimal")  =0 THEN
	'	camp_especial=""
	'ELSE
	IF trim(RSDET("c"))="0"  THEN
		camp_especial="  No castigada"
	ELSE
		'trim(RSDET("c"))="3,715" THEN
'		RESPONSE.Write(RSDET("seriedecimal") )
'		RESPONSE.End()
		camp_especial="  Castigada " & trim(RSDET("c"))
	END IF



	total=0
	total_saldo=0
	total_docs=0
	total_gc=0
	'RESPONSE.Write(GLOSA)
	%>
      </p>
	  <table width="100%"  border="0" bordercolor="#FFFFFF" align="center" >
	  <TR bordercolor="#999999" bgcolor="#<%=session("COLTABBG")%>" class="Estilo13" >
	  	    <td width="33%"> </td>
	  	    <td width="33%" bgcolor="#<%=session("COLTABBG2")%>"   align="center"  class="Estilo28"><B> <%=GLOSA%></B></td>
	  	    <td width="33%"><strong><%=camp_especial%> </strong></td>
			</TR></table>

	<table width="100%" border="0" bordercolor="#FFFFFF">
        <tr bordercolor="#999999" bgcolor="#<%=session("COLTABBG")%>" class="Estilo13">
          <td width="18%">N&ordm; DOCUMENTO </td>
          <td width="13%">PRODUCTO</td>
          <td width="10%"> EMISION </td>
          <td width="11%">VENCIMIENTO</td>
          <td width="6%">DIAS </td>
          <td width="13%"><div align="left">SALDO</div></td>
          <td width="9%">MORA</td>
          <td width="9%">INTERES</td>
          <td width="11%">GASTO </td>

        </tr>
		<%do until rsDET.eof
		%>
        <tr bordercolor="#999999" >
          <td>N&ordm; <%=rsDET("NRODOC")%></td>
          <td><%
			  sql3="SELECT DESCRIPCION FROM PRODUCTO WHERE TIPO_PRODU='"&rsDET("TIPOPRODUCTO")&"'"
			  set rsPP=Conn.Execute(sql3)
			  if not rsPP.eof then
			  response.Write(UCASE(rsPP("DESCRIPCION")))
			  end if
			  rsPP.close
			  set rsPP=nothing
		  %></td>
          <td><div align="right"><%=rsDET("FECHAEMISION")%></div></td>
          <td><div align="right"><%=rsDET("FECHAVENC")%></div></td>
          <td><div align="right"><%=(rsDET("FECHAVENC") - rsDET("FECHAEMISION"))%></div></td>
          <td><div align="right">$ <%=FN(rsDET("VALORCUOTA"),0)%></div></td>
          <td><div align="right">$ <%=FN(rsDET("SALDO"),0)%></div></td>
          <td><div align="right">$ <%=FN(rsDET("INTERESES"),0)%></div></td>
          <td><div align="right" >$ <%=FN(rsDET("GASTOSCOBRANZAS"),0)%></div></td>

        </tr>
		<%
		total= total + clng(rsDET("VALORCUOTA"))
		total_saldo = total_saldo + clng(rsDET("SALDO"))
		total_gc = total_gc + clng(rsDET("GASTOSCOBRANZAS"))
		total_int = total_int + clng(rsDET("INTERESES"))
		total_docs = total_docs + 1
		 rsDET.movenext
		 loop
		 %>

      </table>
	 	<table width="100%" border="0">
          <tr>
            <td width="18%" bgcolor="#<%=session("COLTABBG")%>"><span class="Estilo27">DOCUMENTOS : <%=total_docs%></span></td>
            <td width="40%" bgcolor="#<%=session("COLTABBG")%>"><div align="left"><span class="Estilo27">TOTALES</span></div></td>
            <td width="13%" bgcolor="#<%=session("COLTABBG2")%>"><div align="right">$  <%=FN(total,0)%></div></td>
            <td width="9%" bgcolor="#<%=session("COLTABBG2")%>"><div align="right"><span class="Estilo28">$ <%=FN(total_saldo,0)%></span></div></td>
            <td width="9%" bgcolor="#<%=session("COLTABBG2")%>"><div align="right"><span class="Estilo28">$ <%=FN(total_int,0)%></span></div></td>
            <td width="11%" bgcolor="#<%=session("COLTABBG2")%>"><div align="right"><span class="Estilo28">$ <%=FN(total_gc,0)%></span></div></td>

          </tr>
        </table>
	 	<br><br>	  <strong>
	 	<%total_pg = total_saldo + total_int + total_gc %>
	  TOTAL A PAGAR : $ <%=FN(total_pg,0)%>      </strong> 	  <p>
 		<div align="right">
	      <%end if
	  rsDET.close
	  set rsDET=nothing
	  cerrarscg()
	  %>
	      <br>
	      <br>
	      <strong>FECHA : <%=DATE%> HORA : <%=TIME%>
	      <%end if%>
	      </p>
          </strong>
	      <p align="left"><span class="Estilo20">
	      <input name="imp" type="button" onClick="window.print();" value="Imprimir Ficha">
	    </span>            </p>
    </div></td>
  </tr>
</table>
<script language="JavaScript" type="text/JavaScript">
function ventanaMas (URL){
window.open(URL,"DATOS","width=200, height=300, scrollbars=no, menubar=no, location=no, resizable=no")
}
</script>
