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
<table width="700" height="250" border="0">
  <tr>
    <td height="20"><img src="../lib/DETALLE_DEUDA.gif" width="580" height="22"></td>
  </tr>
  <tr>
    <td height="20"><img src="../lib/48.gif" width="580" height="22"></td>
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
        <td width="31%">RUT</td>
        <td width="50%">NOMBRE O RAZ&Oacute;N SOCIAL </td>
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
	ssql="select c.rutdeudor,p.rut_cotizante,c.nrodoc,p.nombres,p.apellidos, " &_
	     "c.valorcuota,c.abono,c.saldo,c.coddeudor,c.etapacobranza,c.fechaemision " &_
         "from cuota c,cuota_prev p " &_
		 "where c.rutdeudor=p.rutdeudor " &_
		 "and c.codcliente=p.codcliente " &_
		 "and p.rut_cotizante=c.nservicio " &_
		 "and c.nrodoc=p.periodo and c.rutdeudor='"&rut&"' AND c.codcliente='"&cliente&"' order by p.rut_cotizante,c.nrodoc"
	set rsDET=Conn.execute(ssql)
	if not rsDET.eof then
	total=0
	total_saldo=0
	total_docs=0
	total_gc=0
	%>
      </p>
	<table width="700" border="0" bordercolor="#FFFFFF">
        <tr bordercolor="#999999" bgcolor="#<%=session("COLTABBG")%>" class="Estilo13">
          <td width="30">TIPO DOC</td>
          <td width="50">ID COTIZANTE</td>
          <td>PERIODO</td>
          <td>FOLIO</td>
          <td>CAPITAL</td>
          <td>ABONO</td>
          <td>SALDO</td>
          <td>INTERESES</td>
		  <td>REAJUSTES</td>
		  <td>RECARGOS</td>
		  <td>SUBTOTAL</td>
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
          <td><%=rsDET("rut_cotizante")%></td>
          <td>
		  <%
		   	  Clave=rsDET("NRODOC")
		  	  FOLIO= rsDET("CODDEUDOR")
		  	  response.Write(Clave)
			  'fech="31-05-2006"
			  fech= fechamasvida(date)
			  'response.write fech
			  ano= left(trim(Clave),4)
			  mes= right(trim(Clave),2)

		ssql=""
		ssql="select intereses,reajuste,recargo from GRAVAMENES_ISAPRE where fecha = '" & fech & "' and ano='" & ano & "' and mes='" & mes & "' "
		'response.write ssql
		'response.end
		set rsINTER=Conn.execute(ssql)
		if not rsINTER.eof then
			intereses = rsINTER("intereses")
			reajuste = rsINTER("reajuste")
			recargo = rsINTER("recargo")
		end if
		rsINTER.close
		set rsINTER=nothing
		  saldo=rsDET("SALDO")
		  subtot = clng(saldo) + (Cdbl(intereses) * Cdbl(rsDET("SALDO"))/100) + (Cdbl(reajuste) * Cdbl(rsDET("SALDO"))/100)+ (Cdbl(recargo) * Cdbl(rsDET("SALDO"))/100)

		  %>

		  </td>
          <td><%=FOLIO%></td>
          <td><div align="right" > <%=FN(rsDET("VALORCUOTA"),0)%></div></td>
          <td><div align="right"> <%=FN(rsDET("abono"),0)%></div></td>
          <td><div align="right"> <%=FN(rsDET("SALDO"),0)%></div></td>
          <td><div align="right"> <%=FN((Cdbl(intereses) * Cdbl(rsDET("SALDO"))/100),0)%></div></td>
		  <td><div align="right"> <%=FN((Cdbl(reajuste) * Cdbl(rsDET("SALDO"))/100),0)%></div></td>
		  <td><div align="right"> <%=FN((Cdbl(recargo) * Cdbl(rsDET("SALDO"))/100),0)%></div></td>
		  <td><div align="right"> <%=FN(subtot,0)%></div></td>
        </tr>
		<%
		total= total + clng(rsDET("VALORCUOTA"))
		total_saldo = total_saldo + clng(rsDET("SALDO"))
		total_abono = total_abono + clng(rsDET("abono"))
		total_intereses = total_intereses + clng(intereses)
		total_reajuste = total_reajuste + clng(reajuste)
		total_recargo = total_recargo + clng(recargo)
		total_subtot = total_subtot + clng(subtot)
		total_docs = total_docs + 1
		 rsDET.movenext
		 loop
		 %>

       <tr>
          <td bgcolor="#<%=session("COLTABBG")%>" COLSPAN=2><span class="Estilo27">DOCUMENTOS : <%=total_docs%></span></td>
          <td bgcolor="#<%=session("COLTABBG")%>" COLSPAN=2><span class="Estilo27">TOTALES</span></td>
          <td bgcolor="#<%=session("COLTABBG2")%>"><div align="right"><span class="Estilo28">$ <%=FN(total,0)%></span></div></td>
          <td bgcolor="#<%=session("COLTABBG2")%>"><div align="right"><span class="Estilo28">$ <%=FN(total_gc,0)%></span></div></td>
          <td bgcolor="#<%=session("COLTABBG2")%>"><div align="right"><span class="Estilo28">$ <%=FN(total_saldo,0)%></span></div></td>
		  <td bgcolor="#<%=session("COLTABBG2")%>"><div align="right"><span class="Estilo28">$ <%=FN(total_intereses,0)%></span></div></td>
		  <td bgcolor="#<%=session("COLTABBG2")%>"><div align="right"><span class="Estilo28">$ <%=FN(total_reajuste,0)%></span></div></td>
		  <td bgcolor="#<%=session("COLTABBG2")%>"><div align="right"><span class="Estilo28">$ <%=FN(total_recargo,0)%> </span></div></td>
		  <td bgcolor="#<%=session("COLTABBG2")%>"><div align="right"><span class="Estilo28"><strong>$ <%=FN(total_subtot,0)%></strong></span></div></td>
        </tr>
      </table>
	   <br>
	      <%end if
	  rsDET.close
	  set rsDET=nothing
	  	  cerrarscg()
	  %>
	      <br>
		  <strong>TOTAL A PAGAR =  <%=FN(total_subtot,0)%>

          </strong>
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