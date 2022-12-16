<% @LCID = 1034 %>
<!--#include file="arch_utils.asp"-->
<!--#include file="../lib/comunes/rutinas/funciones.inc" -->
<!--#include file="lib.asp"-->

<%
	total_docs=0
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
<table width="676" height="420" border="0">
  <tr>
    <td width="670" height="20" class="Estilo20"><img src="../lib/DETALLE_DEUDA.gif" width="600" height="22"></td>
  </tr>
  <tr>
    <td height="20" class="Estilo20"><font color="#000000" size="3" face="Geneva, Arial, Helvetica, sans-serif"><strong>VESPUCIO
      NORTE EXPRESS INFRACTORES</strong></font></td>
  </tr>
  <tr>
    <td valign="top" background="../images/fondo_coventa.jpg">
	<p align="right">
	  <%if not rut="" then%>
      <%

      abrirscg()

		'ssql="SELECT TOP 1 NOMBREDEUDOR,RUTDEUDOR FROM DEUDOR WHERE RUTDEUDOR='"&rut&"' AND NOMBREDEUDOR IS NOT NULL AND LTRIM(RTRIM(NOMBREDEUDOR)) <> '' "
		SSQL="SELECT TOP 1 D.NOMBREDEUDOR,D.RUTDEUDOR, V.FECHA,CASE WHEN V.FECHA IS NULL THEN 0 	WHEN DATEDIFF(DAY,GETDATE(),V.FECHA) > 0 THEN 1 	WHEN DATEDIFF(DAY,GETDATE(),V.FECHA)<= 0 THEN 2 END AS PUB FROM DEUDOR D, VNE_PUBLICACION V WHERE D.RUTDEUDOR='"&rut&"' AND D.NOMBREDEUDOR IS NOT NULL AND LTRIM(RTRIM(D.NOMBREDEUDOR)) <> ''  AND D.RUTDEUDOR*=V.RUT "
		set rsDEU=Conn.execute(ssql)
		if not rsDEU.eof then
			nombre_deudor = rsDEU("NOMBREDEUDOR")
			rut_deudor = rsDEU("RUTDEUDOR")
		end if
		fecha_pub=rsdeu("fecha")
		pub=rsdeu("pub")
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
	  <table width="670" border="0" bordercolor="#FFFFFF">
        <tr bordercolor="#999999" bgcolor="#<%=session("COLTABBG")%>" class="Estilo13">
        <td width="31%">RUT</td>
        <td width="50%">NOMBRE O RAZ&Oacute;N SOCIAL </td>
      </tr>
      <tr class="Estilo8">
        <td><%=rut_deudor%></td>
        <td><%=nombre_deudor%></td>
      	  	</tr>

	  <% if pub<>"0" then %>

	        <% if pub="1" then %>
				<tr bordercolor="yellow" bgcolor="#FFFF00" class="Estilo13">
				<td><font color="#000000">SE PUBLICARA EN DICOM EL <%=FECHA_PUB%></font></td>
				</tr>
	        <% elseif pub="2" then %>
				<tr bordercolor="red" bgcolor="#FF0000" class="Estilo13">
				<td><font color="#000000">SE PUBLICO EN DICOM EL <%=FECHA_PUB%></font></td>
				</tr>
			<% end  if %>

	  <%end if %>


    </table>
	<table width="671" border="0" bordercolor="#FFFFFF">
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
	if not rut="" then
	abrirscg()
	ssql=""
	'ssql="SELECT FECHAVENC,NRODOC,VALORCUOTA,SALDO,GASTOSCOBRANZAS,CODCOBRADOR,NROCUOTA FROM CUOTA WHERE RUTDEUDOR='"&rut&"' AND CODCLIENTE='"&cliente&"'"
	'if cliente=10 then
			ssql="SELECT NSERVICIO AS INTER_COM, CUENTA AS CTA_CONTR, nroctacte, FECHAVENC, rtrim(c.NRODOC) as NRODOC,rtrim(c.VALORCUOTA) as VALORCUOTA,rtrim(c.SALDO) as SALDO,rtrim(isnull(c.MONTOEMPRESA,0)) as MONTOEMPRESA,rtrim(c.CODCOBRADOR) as CODCOBRADOR,rtrim(c.NROCUOTA) as NROCUOTA,rtrim(v.nom_archivo) as nom_archivo,SUM(cast(BETRW_B_KK as int)) AS ANTIREPITICION FROM CUOTA c,VNE_CARGA_CESION v WHERE c.nrodoc = v.opbel_kk and v.XBLNR=c.nroctacte and v.gpart_kk=c.nservicio and v.vkont_kk=c.cuenta and c.RUTDEUDOR='"&rut&"' AND c.CODCLIENTE='" &cliente& "'  GROUP BY FECHAVENC, rtrim(c.NRODOC) ,rtrim(c.VALORCUOTA),rtrim(c.SALDO),rtrim(isnull(c.MONTOEMPRESA,0)),rtrim(c.CODCOBRADOR),rtrim(c.NROCUOTA),rtrim(v.nom_archivo),NSERVICIO , CUENTA,nroctacte"
	'end if
	'response.Write(ssql)
	'response.End()
	set rsDET=Conn.execute(ssql)
	if not rsDET.eof then
	       INTER_COM =rsDET("INTER_COM")
        CTA_CONTR=rsDET("CTA_CONTR")

	%>
	  <table width="671" border="0" bordercolor="#FFFFFF">
        <tr bordercolor="#999999" bgcolor="#<%=session("COLTABBG")%>" class="Estilo13">
          <td width="14%">DOCUMENTO</td>
          <td width="10%">BOLETA</td>
          <td width="10%">FECHA VENC</td>
          <td width="11%">MONTO</td>
          <td width="11%">SALDO</td>
          <td width="13%">G.COBRANZAS</td>
          <td width="10%">COBRADOR</td>

		  <td width="21%">ARCH.CESION </td>

        </tr>
		<%do until rsDET.eof
		%>
        <tr bordercolor="#999999" >
          <td>N&ordm; <%=rsDET("NRODOC")%></td>
          <td>
            <%=rsDET("nroctacte") %>
          </td>
          <td><div align="left" >  <%=FormatDateTime(rsDET("FECHAVENC"),2)%></div></td>
          <td><div align="right">$ <%=FN(rsDET("VALORCUOTA"),0)%></div></td>
          <td><div align="right">$ <%=FN(rsDET("SALDO"),0)%></div></td>
          <td><div align="right" >$ <%
		  Total_docs=total_docs+1
		  total=total+FN(rsDET("VALORCUOTA"),0)
		  total_saldo=total_saldo+FN(rsDET("SALDO"),0)

		  if not isnull(rsDET("MONTOEMPRESA")) then
		  response.Write(FN(rsDET("MONTOEMPRESA"),0))
		   total_GC=total_GC+FN(rsDET("MONTOEMPRESA"),0)
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
		   <td width="21%"><%=rsDET("nom_archivo")%>
		 </tr>
		 <%rsDET.movenext
		 loop
		 %>
		<tr>
          <td height="33" bgcolor="#<%=session("COLTABBG")%>"><span class="Estilo27">DOCUMENTOS:&nbsp;<%=total_docs%></span></td>
          <td bgcolor="#<%=session("COLTABBG")%>"></td>
          <td bgcolor="#<%=session("COLTABBG")%>" colspan="1"><div align="left"><span class="Estilo27">TOTALES</span></div></td>
		  <td bgcolor="#<%=session("COLTABBG2")%>"><div align="right">$ <%=FN(total,0)%></div></td>
          <td bgcolor="#<%=session("COLTABBG2")%>"><div align="right"><span class="Estilo28">$
              <%=FN(total_saldo,0)%></span></div></td>
          <td bgcolor="#<%=session("COLTABBG2")%>"><div align="right"><span class="Estilo28">$
              <%=FN(total_GC,0)%></span></div></td>
          <td colspan="3" bgcolor="#<%=session("COLTABBG2")%>"></td>
        </tr>

      </table>
	    <table width="671" border="0" bordercolor="#FFFFFF">
	  	<tr bordercolor="#999999" bgcolor="#<%=session("COLTABBG")%>" class="Estilo13">
        <td width="323" >INTERLOCUTOR COMERCIAL</td>
        <td width="338" >CUENTA DE CONTRATO</td>
      </tr>
      <tr class="Estilo8">

        <td><%=INTER_COM%></td>
        <td><%=CTA_CONTR%></td>
      </tr>
	   </table>
       <!--<table width="600" border="0">
        <!-- <tr>
          <td height="33" bgcolor="#<%=session("COLTABBG")%>"><span class="Estilo27">DOCS:&nbsp;<%'=total_docs%></span></td>
          <td bgcolor="#<%=session("COLTABBG")%>"><div align="left"><span class="Estilo27">TOTALES</span></div></td>
          <td bgcolor="#<%=session("COLTABBG2")%>"><div align="right">$ <%'=FN(total,0)%></div></td>
          <td bgcolor="#<%=session("COLTABBG2")%>"><div align="right"><span class="Estilo28">$
              <%'=FN(total_saldo,0)%></span></div></td>
          <td bgcolor="#<%=session("COLTABBG2")%>"><div align="right"><span class="Estilo28">$
              <%'=FN(total_GC,0)%></span></div></td>
          <td colspan="3" ></td>
        </tr>
      </table> -->
      <br> <br> <strong>
      <%total_pg = total_saldo  '+ total_gc
	  %>
      TOTAL A PAGAR : $ <%=FN(total_pg,0)%> </strong> <p>
      <div align="right"> <br>
        <br>
        <strong><span class="Estilo20"> </span>FECHA : <%=DATE%> HORA : <%=TIME%>
        </strong>
        <p></p>
        <p align="left">&nbsp;</p>
        <p align="left"><strong><span class="Estilo20"> </span></strong></p>
        <p align="left"><strong><span class="Estilo20">
          <input name="imp" type="button" onClick="window.print();" value="Imprimir Ficha">
          </span></strong></p>
      </div>

      <p>&nbsp;</p></td>
  </tr>
</table>
<%end if
	  rsDET.close
	  set rsDET=nothing
	  cerrarscg()
	  end if
	  end if%>

<script language="JavaScript" type="text/JavaScript">
function ventanaMas (URL){
window.open(URL,"DATOS","width=200, height=300, scrollbars=no, menubar=no, location=no, resizable=yes")
}
</script>
