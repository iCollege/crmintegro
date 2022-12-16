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
    <td height="20"><img src="../lib/DETALLE_DEUDA.gif" width="740" height="22"></td>
  </tr>
  <tr>
    <td height="20"><img src="../lib/21.gif" width="740" height="22"></td>
  </tr>
  <tr>
    <td valign="top" background="../images/fondo_coventa.jpg">
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
	ssql="SELECT NRODOC,VALORCUOTA,SALDO,GASTOSCOBRANZAS,FECHAEMISION,TIPOPRODUCTO,FECHAVENC,CODCOBRADOR,INTERESES,NROCUOTA FROM CUOTA WHERE RUTDEUDOR='"&rut&"' AND CODCLIENTE='"&cliente&"'"
	set rsDET=Conn.execute(ssql)
	if not rsDET.eof then
	total=0
	total_saldo=0
	total_docs=0
	total_gc=0
	%>
      </p>
	<table width="100%" border="0" bordercolor="#FFFFFF">
        <tr bordercolor="#999999" bgcolor="#<%=session("COLTABBG")%>" class="Estilo13">
          <td width="18%">N&ordm; DOCUMENTO </td>
          <td width="13%">EMISION</td>
          <td width="11%"> VENCIMIENTO </td>
          <td width="8%">DIAS</td>
          <td width="8%">PAGO MINIMO </td>
          <td width="13%"><div align="left">MONTO</div></td>
          <td width="9%">SALDO</td>
          <td width="9%">INTERES</td>
          <td width="11%">GASTO </td>
        </tr>
		<%do until rsDET.eof
		%>
        <tr bordercolor="#999999" >
          <td>N&ordm; <%=rsDET("NRODOC")%></td>
          <td><%=MID(Cstr(rsDET("FECHAEMISION")),1,10)%></td>
          <td><div align="right"><%=MID(Cstr(rsDET("FECHAVENC")),1,10)%></div></td>
          <td><div align="right">
            <%
			sp1="SELECT dias_mora FROM RIPLEY WHERE rutdeudor = '"&rut&"' and codigo_remesa in (select max(codigo_remesa) from RIPLEY)"

			set rsDD=Conn.execute(sp1)
			if not rsDD.eof then
			response.Write(rsDD("dias_mora"))
			end if
			rsDD.close
			set rsDD=nothing
		  %>
          </div></td>
          <td><div align="right">
		  <%
			  sp="SELECT monto1 FROM ripley_pago_minimo WHERE RUT='"&rut&"'"
			  set rsMIN = Conn.execute(sp)
				  if not rsMIN.eof then
				  response.Write("$ ")
				  response.Write(FN(rsMIN("monto1"),0))
				  end if
			  rsMIN.close
			  set rsMIN=nothing
		  %>

		  </div></td>
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
