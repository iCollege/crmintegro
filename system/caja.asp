<% @LCID = 1034 %>
<!--#include file="../lib/comunes/bdatos/ConectarSCG_R.inc" -->
<!--#include file="../lib/comunes/bdatos/ConectarCargas.inc"-->
<!--#include file="../lib/comunes/rutinas/funciones.inc" -->
<!--#include file="lib.asp"-->

<%
	rut = request.QueryString("rut")
	cliente=request.QueryString("cliente")

	if rut="" then
	rut=request.Form("rut")
	end if

	if cliente="" then
	cliente=request.Form("cliente")
	end if


	documento=request.Form("documento")
	if not documento="0" AND not documento="" then
	ssql="EXECUTE SCG_WEB_PAGO '"&documento&"','"&montocliente&"','"&montoEMPRESA&"','"&boleta&"','"&comprobante&"','"&rut&"','"&cliente&"'"
	conexionCG.execute(ssql)
	end if

	%>
<title>EMPRESA S.A.</title>
<style type="text/css">
<!--
.Estilo27 {color: #FFFFFF}
-->
</style>
<form name="datos" method="post">
<table width="680" height="250" border="0">
  <tr>
    <td height="20" bgcolor="#<%=session("COLTABBG")%>" class="Estilo20">MODULO DE PAGOS EMPRESA S.A. </td>
  </tr>
  <tr>
    <td valign="top">
	<p align="right">
	  <%if not rut="" then%>
      <%
		ssql="SELECT TOP 1 NOMBREDEUDOR,RUTDEUDOR FROM DEUDOR WHERE RUTDEUDOR='"&rut&"' AND NOMBREDEUDOR IS NOT NULL AND LTRIM(RTRIM(NOMBREDEUDOR)) <> '' "

		'Response.write "ssql="&ssql
		'Response.End
		set rsDEU=ConexionSCG.execute(ssql)
		if not rsDEU.eof then
			nombre_deudor = rsDEU("NOMBREDEUDOR")
			rut_deudor = rsDEU("RUTDEUDOR")
		end if
		rsDEU.close
		set rsDEU=nothing


		ssql=""
		ssql="SELECT TOP 1 Calle,Numero,Comuna,Correlativo FROM DEUDOR_DIRECCION WHERE RUTDEUDOR='"&rut_deudor&"' ORDER BY Correlativo DESC"
		set rsDIR=ConexionSCG.execute(ssql)
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
		set rsFON=ConexionSCG.execute(ssql)
		if not rsFON.eof then
			codarea_deudor = rsFON("CodArea")
			Telefono_deudor = rsFON("Telefono")
			Correlativo_deudor2 = rsFON("Correlativo")
		end if
		rsFON.close
		set rsFON=nothing

		%>
		<input name="rut" type="hidden" value="<%=rut%>">
      <br>
    EJECUTIVO : <%=response.Write(session("session_login"))%>
	<table width="100%" border="0" bordercolor="#FFFFFF">
      <tr bordercolor="#999999" bgcolor="#<%=session("COLTABBG")%>" class="Estilo13">
        <td width="31%">RUT</td>
        <td width="50%">NOMBRE</td>
      </tr>
      <tr bgcolor="#FFFFFF" class="Estilo8">
        <td><%=rut_deudor%></td>
        <td><%=nombre_deudor%></td>
      </tr>
    </table>

	<table width="100%" border="0" bordercolor="#FFFFFF">
      <tr bordercolor="#999999" bgcolor="#<%=session("COLTABBG")%>" class="Estilo13">
        <td width="70%">DIRECCION</td>
        <td width="30%">TELEFONO</td>
      </tr>
      <tr bgcolor="#FFFFFF" class="Estilo8">
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


	<table width="100%" border="0">
      <tr>
        <td width="45%">&nbsp;</td>
        </tr>
      <tr bgcolor="#<%=session("COLTABBG")%>">
        <td><span class="Estilo27">CLIENTE </span></td>
        </tr>
      <tr>
        <td>

		<select name="cliente" id="cliente"
		onChange="
		alert('IMPORTANDO DOCUMENTOS');
		datos.action='caja.asp';
		datos.submit();
		">
		<option value="0">SELECCIONE</option>
		<%
		ssql="SELECT razon_social_cliente,codigo_cliente FROM CLIENTE WHERE codigo_cliente in (SELECT DISTINCT CODCLIENTE FROM CUOTA WHERE RUTDEUDOR='"&rut&"')"
		response.write "ssql="&ssql
		response.End
		set rsCLI=conexionCG.execute(ssql)
		if not rsCLI.eof then
			do until rsCLI.eof
			%>

			<option value="<%=rsCLI("codigo_cliente")%>"
			<%if cint(cliente)=cint(rsCLI("codigo_cliente")) then
				response.Write("Selected")
			end if%>
			><%=rsCLI("razon_social_cliente")%></option>

			<%rsCLI.movenext
			loop
		end if
		rsCLI.close
		set rsCLI=nothing
		%>

        </select></td>
        </tr>
    </table>
	<br><br>
	<%
	ssql="SELECT NRODOC,SALDO,VALORCUOTA,GASTOSCOBRANZAS,INTERESES FROM CUOTA WHERE CODCLIENTE='"&cliente&"' AND RUTDEUDOR='"&rut&"'"
		set rsNRO=conexionSCG.execute(ssql)
		if not rsNRO.eof then
	%>
	<table width="100%" border="0">
  <tr bgcolor="#<%=session("COLTABBG")%>">
    <td width="19%"><span class="Estilo27">N&ordm; DOCUMENTO </span></td>
    <td width="15%"><span class="Estilo27">MONTO </span></td>
    <td width="14%"><span class="Estilo27">SALDO </span></td>
    <td width="22%"><span class="Estilo27">GASTOS COBRANZAS</span></td>
    <td width="15%"><span class="Estilo27"> INTER&Eacute;S</span></td>
    <td width="15%"><div align="right"><span class="Estilo27">SELECCIONAR

    </span></div></td>
  </tr>
  <%do until rsNRO.eof%>
  <tr>
    <td>N&ordm; <%=rsNRO("NRODOC")%></td>
    <td><div align="right">$ <%=FN(rsNRO("VALORCUOTA"),0)%></div></td>
    <td><div align="right">$ <%=FN(rsNRO("SALDO"),0)%></div></td>
    <td><div align="right">$ <%=FN(rsNRO("GASTOSCOBRANZAS"),0)%> </div></td>
    <td><div align="right">$ <%=FN(rsNRO("INTERESES"),0)%> </div></td>
    <td><div align="right">
      <input name="<%=rsNRO("NRODOC")%>" type="checkbox" id="<%=rsNRO("NRODOC")%>" value="checkbox" <% if rsNRO("SALDO")="0" Then response.write("Disabled") end if%>
	  onClick="a(this.name,<%=rsNRO("SALDO")%>,this.value,this.checked);">

	<script language="JavaScript" type="text/JavaScript">
	function a(caja,saldo,cajita,estado){
		  if(estado==true){
		  datos.montocliente.value = parseInt(datos.montocliente.value) + parseInt(saldo);
		  datos.montocliente.focus();
		  }else{
		  datos.montocliente.value = parseInt(datos.montocliente.value) - parseInt(saldo);
		  datos.montocliente.focus();
		  }

	}
	</script>

    </div></td>
  </tr>
  <%
  rsNRO.movenext
   loop
  %>
</table>
		<%end if
		rsNRO.close
		set rsNRO=nothing
		%>

	<br><br>
	<table width="100%" border="0">
      <tr bgcolor="#<%=session("COLTABBG")%>">
        <td width="17%"><span class="Estilo27">MONTO CLIENTE </span></td>
        <td width="17%"><span class="Estilo27">MONTO EMPRESA </span></td>
        <td width="17%"><span class="Estilo27">FECHA DE PAGO </span></td>
        <td width="19%"><span class="Estilo27">N&ordm; BOLETA </span></td>
        <td width="30%"><span class="Estilo27">N&ordm; COMPROBANTE</span></td>
      </tr>
      <tr>
        <td><input name="montocliente" type="text" id="montocliente" value="0" size="10" maxlength="10"></td>
        <td><input name="montoEMPRESA" type="text" id="montoEMPRESA" size="10" maxlength="10"></td>
        <td><input name="inicio" type="text" id="inicio" value="<%=DATE%>" size="10" maxlength="10">
         <a href="javascript:showCal('Calendar7');"><img src="../lib/calendario.gif" border="0"></td>
        <td><input name="boleta" type="text" id="boleta" size="15" maxlength="15"></td>
        <td><input name="comprobante" type="text" id="comprobante" size="15" maxlength="15">
          &nbsp;&nbsp;&nbsp;<input type="button" name="Submit" value="Aceptar" onClick="paga();"> </td>
      </tr>
    </table>
	<%end if%>

	</td>
  </tr>

</table>
</form>

<script language="JavaScript " type="text/JavaScript">

function recarga(){
alert('RECARGANDO');
datos.action='caja.asp';
datos.submit();
}

function pago(){
if datos.documento.value!='0'{
datos.action='caja.asp';
datos.submit();
}
}

</script>


