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
	cerrarscg

	%>
<title>DETALLE DE DEUDA</title>
<style type="text/css">
<!--
.Estilo27 {color: #FFFFFF}
.Estilo28 {color: #000000}
.Estilo32 {color: #FFFFFF; font-size: x-small; }
-->
</style>
<table width="700" height="420" border="0">
  <tr>
    <td height="20"><img src="../lib/DETALLE_DEUDA.gif" width="600" height="22"></td>
  </tr>
  <tr>
    <td height="20"><img src="../lib/14.gif" width="600" height="22"></td>
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
	<table width="700" border="0" bordercolor="#FFFFFF">
      <tr bordercolor="#999999" bgcolor="#<%=session("COLTABBG")%>" class="Estilo13">
        <td width="31%" >RUT</td>
        <td width="50%" >NOMBRE O RAZ&Oacute;N SOCIAL </td>
      </tr>
      <tr class="Estilo8">
        <td><%=rut_deudor%></td>
        <td><%=nombre_deudor%></td>
      </tr>
    </table>
	<table width="700" border="0" bordercolor="#FFFFFF">
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
	ssql="SELECT CUOTA.TRAMOCOMISION,CUOTA.INTERESES,CUOTA.NRODOC,CUOTA.VALORCUOTA,CUOTA.SALDO,CUOTA.GASTOSCOBRANZAS,CUOTA.FECHAVENC,CUOTA.CODCOBRADOR,DATO_EXTRA_CUOTA.CAUSAL_PROTESTO,DATO_EXTRA_CUOTA.CODIGO_BANCO,DATO_EXTRA_CUOTA.SUPERMERCADO, DATO_EXTRA_CUOTA.OBSERVACIONES"
	ssql= ssql & " FROM CUOTA,DATO_EXTRA_CUOTA WHERE CUOTA.NRODOC=DATO_EXTRA_CUOTA.NUMERO_DOCUMENTO AND"
	ssql= ssql & " CUOTA.CODCLIENTE = DATO_EXTRA_CUOTA.CODIGO_CLIENTE AND "
	ssql= ssql & " CUOTA.NROCUOTA = DATO_EXTRA_CUOTA.NUMERO_CUOTA AND "
	ssql= ssql & " CUOTA.RUTDEUDOR = DATO_EXTRA_CUOTA.RUT_DEUDOR AND RUTDEUDOR='"&rut&"' AND CODCLIENTE='"&cliente&"'"
	'response.Write(ssql)
	'response.end
	set rsDET=Conn.execute(ssql)
	if not rsDET.eof then
	total=0
	total_saldo=0
	total_docs=0
	total_gc=0
	total_int=0
	%>
      </p>
	<table width="700" border="0" bordercolor="#FFFFFF">
        <tr bordercolor="#999999" bgcolor="#<%=session("COLTABBG")%>" class="Estilo13">
          <td width="9%">N&ordm; CHEQUE</td>
          <td width="9%">BANCO</td>
          <td width="22%">MOTIVO DE PROTESTO </td>
          <td width="10%">UNIDAD DE NEGOCIOS </td>
          <td width="9%">FECHA DE PROTESTO </td>
          <td width="9%"><div align="left">MONTO</div></td>
          <td width="9%">SALDO</td>
          <td width="11%">GASTO</td>
          <td width="12%">INTERES</td>
        </tr>
		<%do until rsDET.eof
				%>
        <tr bordercolor="#999999" >
          <td>N&ordm; <%=rsDET("NRODOC")%></td>
          <td><%
		  ssql2="SELECT NOMBRE_BANCO FROM CENCOSUD_BANCO WHERE CODIGO_EMPRESA='"&rsDET("CODIGO_BANCO")&"'"
		  set rsBAN=Conn.execute(ssql2)
		  if not rsBAN.eof then
		  response.Write(rsBAN("NOMBRE_BANCO"))
		  else
		  response.Write("SIN INFORMACION")
		  end if
		  rsBAN.close
		  set rsBAN=nothing
			%></td>
          <td>
		  <%
		  ssql3="SELECT DESCRIPCION FROM CENCOSUD_CPROTESTO WHERE CAUSAL_PROTESTO='"&rsDET("CAUSAL_PROTESTO")&"'"
		  set rsPRO=Conn.execute(ssql3)
		  if not rsPRO.eof then
		  response.Write(rsPRO("DESCRIPCION"))
		  else
		  response.Write("SIN INFORMACION")
		  end if
		  rsPRO.close
		  set rsPRO=nothing

		 ' if rsDET("CAUSAL_PROTESTO")="F1" OR rsDET("CAUSAL_PROTESTO")="SI" OR rsDET("CAUSAL_PROTESTO")="F3" OR rsDET("CAUSAL_PROTESTO")="F2" OR rsDET("CAUSAL_PROTESTO")="CA" then
		  'interes = 0
		  'gasto = 0
		  'else
		  interes = rsDET("INTERESES")
		  gasto = rsDET("GASTOSCOBRANZAS")
		  'end if
			if rsDET("OBSERVACIONES") = "BBVA" or rsDET("OBSERVACIONES") = "SANTANDER" then
				COMPLEM_BCO="-"&rsDET("OBSERVACIONES")
			ELSE
				COMPLEM_BCO=""
			end if
			'IF NOT ISNULL(rsDET("TRAMOCOMISION")) THEN
			'	COMPLEM_BCO="-"&rsDET("TRAMOCOMISION")
			'ELSE
			'	COMPLEM_BCO=""
			'END IF



		%>
		  </td>
          <td><%=rsDET("SUPERMERCADO")&COMPLEM_BCO %></td>
          <td><div align="right"><%=FormatDateTime(rsDET("FECHAVENC"),2)%></div></td>
          <td><div align="right">$ <%=FN(rsDET("VALORCUOTA"),0)%></div></td>
          <td><div align="right">$ <%=FN(rsDET("SALDO"),0)%></div></td>
          <td><div align="right">$ <%=FN(CLNG(gasto),0)%></div></td>
          <td><div align="right" >$ <%=FN(interes,0)%></div></td>
        </tr>
		<%
		total= total + clng(rsDET("VALORCUOTA"))
		total_saldo = total_saldo + clng(rsDET("SALDO"))
		total_gc = total_gc + clng(gasto)
		total_int = total_int + clng(interes)
		total_docs = total_docs + 1
		 rsDET.movenext
		 loop
		 %>

      </table>
	 	<table width="700" border="0">
          <tr>
            <td width="22%" bgcolor="#<%=session("COLTABBG")%>"><span class="Estilo27">DOCUMENTOS : <%=total_docs%></span></td>
            <td width="37%" bgcolor="#<%=session("COLTABBG")%>"><span class="Estilo27">TOTALES</span></td>
            <td width="9%" bgcolor="#<%=session("COLTABBG2")%>"><div align="right">$  <%=FN(total,0)%></div></td>
            <td width="9%" bgcolor="#<%=session("COLTABBG2")%>"><div align="right"><span class="Estilo28">$ <%=FN(total_saldo,0)%></span></div></td>
            <td width="11%" bgcolor="#<%=session("COLTABBG2")%>"><div align="right"><span class="Estilo28">$ <%=FN(total_gc,0)%></span></div></td>
            <td width="12%" bgcolor="#<%=session("COLTABBG2")%>"><div align="right"><span class="Estilo28">$ <%=FN(total_int,0)%></span></div></td>
          </tr>
      </table>
	 	<br><br>
      <strong>
      <%total_pg = total_saldo + total_int + total_gc %>
      TOTAL A PAGAR : $ <%=FN(total_pg,0)%> </strong>
      <p>
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
