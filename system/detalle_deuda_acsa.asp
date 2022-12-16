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
<title>DETALLE DE DEUDA </title>
<style type="text/css">
<!--
.Estilo27 {color: #FFFFFF}
.Estilo28 {color: #000000}
-->
</style>
<table width="600" height="250" border="0">
  <tr>
    <td height="20"><img src="../lib/DETALLE_DEUDA.gif" width="580" height="22"></td>
  </tr>
  <tr>
    <td height="20"><img src="../lib/40.gif" width="580" height="22"></td>
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
	<table width="600" border="0" bordercolor="#FFFFFF">
      <tr bordercolor="#999999" bgcolor="#<%=session("COLTABBG")%>" class="Estilo13">
        <td width="31%">RUT</td>
        <td width="50%">NOMBRE O RAZ&Oacute;N SOCIAL </td>
      </tr>
      <tr class="Estilo8">
        <td><%=rut_deudor%></td>
        <td><%=nombre_deudor%></td>
      </tr>
    </table>
	<table width="600" border="0" bordercolor="#FFFFFF">
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
	ssql="SELECT ETAPACOBRANZA,NRODOC,VALORCUOTA,SALDO,ISNULL(MONTOEMPRESA,0) AS MONTOEMPRESA,CODCOBRADOR,NROCUOTA,NROCTACTE,CODDEUDOR,FECHAEMISION,CUENTA FROM CUOTA WHERE RUTDEUDOR='"&rut&"' AND CODCLIENTE='"&cliente&"'"
	set rsDET=Conn.execute(ssql)
	if not rsDET.eof then
	total=0
	total_saldo=0
	total_docs=0
	total_gc=0
	%>
      </p>
	<table width="600" border="0" bordercolor="#FFFFFF">
        <tr bordercolor="#999999" bgcolor="#<%=session("COLTABBG")%>" class="Estilo13">
          <td width="50">ESTADO DOCUM.</td>
          <td width="100">CODIGO SAP ACSA </td>
          <td width="100">DOC.OFICIAL </td>
          <td width="80">FECHA FACTURACI&Oacute;N </td>
          <td width="80">CUENTA CONTRATO </td>
          <td>MONTO</td>
          <td>G.COB.</td>
          <td>SALDO</td>
        </tr>
		<%do until rsDET.eof
		if rsDET("ETAPACOBRANZA")="ST7" Then
		estadodoc="RET"
		else
		estadodoc="EMPRESA"
		END IF


		%>
        <tr bordercolor="#999999" >
          <td><%=estadodoc%></td>
          <td>N&ordm; <%=rsDET("NRODOC")%></td>
          <td>
		  <%
		   	  interlocutor=rsDET("CODDEUDOR")
		  	  docoficial = rsDET("CUENTA")
			  ffactura= rsDET("FECHAEMISION")
		  	  response.Write(docoficial)
		  %>

		  </td>
          <td><%=ffactura%></td>
          <td><div align="left" ><%=rsDET("NROCTACTE")%></div></td>
          <td><div align="right">$ <%=FN(rsDET("VALORCUOTA"),0)%></div></td>
          <td><div align="right">$ <%=FN(rsDET("MONTOEMPRESA"),0)%></div></td>
          <td><div align="right">$ <%=FN(rsDET("SALDO"),0)%></div></td>
        </tr>
		<%
		total= total + clng(rsDET("VALORCUOTA"))
		total_saldo = total_saldo + clng(rsDET("SALDO"))
		total_gc = total_gc + clng(rsDET("MONTOEMPRESA"))
		total_docs = total_docs + 1
		 rsDET.movenext
		 loop
		 %>

       <tr>
          <td bgcolor="#<%=session("COLTABBG")%>" COLSPAN=3><span class="Estilo27">DOCUMENTOS : <%=total_docs%></span></td>
          <td bgcolor="#<%=session("COLTABBG")%>" COLSPAN=2><span class="Estilo27">TOTALES</span></td>
          <td bgcolor="#<%=session("COLTABBG2")%>"><div align="right"><span class="Estilo28">$ <%=FN(total,0)%></span></div></td>
          <td bgcolor="#<%=session("COLTABBG2")%>"><div align="right"><span class="Estilo28">$ <%=FN(total_gc,0)%></span></div></td>
          <td bgcolor="#<%=session("COLTABBG2")%>"><div align="right"><span class="Estilo28">$ <%=FN(total_saldo,0)%></span></div></td>
        </tr>
      </table>
	   <br>
		  <%
		  sql_convenio = "SELECT top 1 * FROM acsa_convenios WHERE rut='"&rut&"'"

		  set rsconvenio=Conn.execute(sql_convenio)
			  if not rsconvenio.eof then
			  conv_fecha=rsconvenio("fecha")
			  conv_alert="<font color=""#FF0000"">DEUDOR PRESENTA CONVENIO CON ACSA EL DIA : </font>"
			  else
			  conv_fecha=""
			  conv_alert=""
			  end if
		  rsconvenio.close
		  set rsconvenio=Nothing

		  %>
	  <strong><%= conv_alert %> </strong> <%=conv_fecha%>
	  <BR>
	  <strong>CODIGO DE INTERLOCUTOR :</strong> <%=interlocutor%>
	  <br>
	  <strong>DETALLE DE PATENTES :</strong>
	  <%
	  ssql_pat = "SELECT DISTINCT patente,tag,cta_contrato FROM ACSA_A3_DETALLE WHERE RUT_DEUDOR ='"&rut&"' order by cta_contrato"
	  set rsPAT=Conn.execute(ssql_pat)
	  if not rsPAT.eof then
	 %>
		<table width="600" border="0">
          <tr bgcolor="#<%=session("COLTABBG")%>">
            <td width="15%"><span class="Estilo27">CUENTA CONTRATO</span></td>
            <td width="10%"><span class="Estilo27">PATENTE</span></td>
            <td width="47%"><span class="Estilo27">NUMERO DE DISPOSITIVO TAG</span></td>
            <td width="28%"><span class="Estilo27">RECOMENDACI&Oacute;N</span></td>
          </tr>
		  <%
		  do until rsPAT.eof
		  %>
          <tr>
            <td><%=rsPAT("cta_contrato")%></td>
            <td><%=right(rsPAT("patente"),6)%></td>
            <td><%=rsPAT("tag")%></td>
            <td>
			<%
			if rsPAT("tag")="00000000TAG-AC-1-C000000000000000000" then
			response.Write("PATENTE INFRACTORA")
			else
			response.Write("TAG VALIDO")
			end if
			%>
			</td>
          </tr>
		  <%rsPAT.movenext
		  loop
		  %>
      </table>
		<br>
		  <%
	  end if
	  rsPAT.close
	  set rsPAT=nothing

	  %>
		**EN CASO DE NECESITAR EL DETALLE DE LAS TRANSACCIONES, <strong>EL SERVICIO SE PUEDE ACTIVAR LLAMANDO AL: 600 4000 600, EL CUAL TIENE COSTO DE $600</strong> Y LLEGA JUNTO A LA FACTURA. EN CASO DE SER MOROSO SE PUEDE OBTENER EL DETALLE EN CUALQUIERA DE LAS 4 OFICINAS COMERCIALES DE AUTOPISTA CENTRAL LAS CUALES SON:</p>
		<BR>
		<BR>
		<strong>SAN DIEGO : </strong>SAN DIEGO  634 - (Esquina 10 de julio) - SANTIAGO CENTRO<BR>
		<strong>SAN BERNARDO : </strong>SAN JOSÉ 1135 - SAN BERNARDO<BR>
		<strong>QUILICURA EXPRESS :</strong> AMERICO VESPUCIO NORTE 2250 - CONCHALI<BR>

		<BR><BR>
		<strong>Horario de atención: Lunes a Viernes de 9:00 a 17:30 y sábados de 9:00 a 14:00 hrs</strong>.
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
          </strong> </p>
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
