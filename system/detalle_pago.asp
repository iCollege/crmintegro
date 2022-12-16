<% @LCID = 1034 %>
<!--#include file="../../comunes/bdatos/ConectarSCG_R.inc"-->
<!--#include file="../../comunes/bdatos/ConectarCargas.inc"-->
<!--#include file="../../comunes/rutinas/funciones.inc" -->
<!--#include file="lib.asp"-->

<%
	rut = request.form("rutf")
	cliente=request.form("cliente_paga")

	if rut="" then
		rut=request.Form("hrut")
		cliente=request.Form("hcliente")
		negociacion=request.Form("negociacion")
	end if


	ssql=""
	ssql="SELECT razon_social_cliente FROM CLIENTE WHERE codigo_cliente='"&cliente&"'"
	set rsCLI=ConexionCG.execute(ssql)
	if not rsCLI.eof then
	nombre_cliente=rsCLI("razon_social_cliente")
	end if
	rsCLI.close
	set rsCLI=nothing

	%>
<form name="datos" method="post">
<table width="700" height="420" border="0">
  <tr>
    <td height="20" bgcolor="#FF9900" class="Estilo20">REGISTRO DE PAGO  - CLIENTE : <%=nombre_cliente%></span></td>
  </tr>
  <tr>
    <td valign="top">

	<%if not rut="" then%>
	<%
		ssql=""
		ssql="SELECT TOP 1 NOMBREDEUDOR,RUTDEUDOR FROM DEUDOR WHERE RUTDEUDOR='"&rut&"' AND NOMBREDEUDOR IS NOT NULL AND LTRIM(RTRIM(NOMBREDEUDOR)) <> '' "
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
	<br>
	<span class="Estilo26">DATOS DEL DEUDOR
	<input name="hrut" type="hidden" id="hrut" value="<%=rut%>">
    <input name="hcliente" type="hidden" id="hcliente" value="<%=cliente%>">
    </span>
	<table width="100%" border="0">
        <tr bgcolor="#<%=session("COLTABBG")%>" class="Estilo13">
          <td width="31%">RUT</td>
          <td width="50%">NOMBRE</td>
        </tr>
        <tr class="Estilo8">
          <td><%=rut_deudor%></td>
          <td><%=nombre_deudor%></td>
        </tr>
      </table>
	  <table width="100%" border="0">
        <tr bgcolor="#<%=session("COLTABBG")%>" class="Estilo13">
          <td width="44%">CALLE</td>
          <td width="10%">NUMERO</td>
          <td width="22%">COMUNA</td>
          <td width="17%">TELEFONO</td>
        </tr>
        <tr class="Estilo8">
          <td><%=calle_deudor%></td>
          <td><%=numero_deudor%></td>
          <td><%=comuna_deudor%>
		  <%if cint(correlativo_deudor) > 1 then%>
		  <span class="Estilo24 Estilo27"><a href="mas_direcciones.asp?rut=<%=rut_deudor%>">ver m&aacute;s</a></span>
		  <%end if%>
		  </td>
          <td>
		  <%if not telefono_deudor="" then%>
		  <%=codarea_deudor%>-<%=telefono_deudor%>
		  	<%if cint(Correlativo_deudor2) > 1 then%>
		  		<span class="Estilo27"><a href="mas_telefonos.asp?rut=<%=rut_deudor%>">ver m&aacute;s</a></span>
		  	<%end if%>
		  <%end if%>
		  </td>
        </tr>
      </table>
	  <br><br>
	  <table width="100%" border="0">
  <tr bgcolor="#FF9900" class="Estilo13">
    <td width="76%">NEGOCIACION</td>
    <td width="24%">N&ordm; BOLETA</td>
    </tr>
  <tr>
    <td><select name="negociacion">
      <option value="0">SELECCIONE</option>
      <%
		ssql=""
		ssql="SELECT codigo_negociacion,fecha_negociacion FROM NEGOCIACION WHERE codigo_cliente='"&cliente&"' AND rut_deudor='"&rut_deudor&"' AND estado_negociacion='VIGENTE'"
		set rsNEG=ConexionSCG.execute(ssql)
		if not rsNEG.eof then
			do until rsNEG.eof
		%>
      <option value="<%=rsNEG("codigo_negociacion")%>" <%if clng(negociacion)=clng(rsNEG("codigo_negociacion")) then response.Write("Selected") end if%>><%=rsNEG("codigo_negociacion")%> - <%=rsNEG("fecha_negociacion")%></option>
      <%
			rsNEG.movenext
			loop
		else%>
      <option value="0">NO TIENE NEGOCIACIONES REGISTRADAS</option>
      <%
		end if
		rsNEG.close
		set rsNEG=nothing
		%>
    </select>
&nbsp;&nbsp;&nbsp;
<input type="submit" name="Submit" value="Cargar" onClick="CargaNeg();">
&nbsp;&nbsp;&nbsp;
<input type="submit" name="Submit" value="Nueva">
&nbsp;&nbsp;&nbsp;
<input type="submit" name="Submit" value="Imprimir"></td>
    <td><input name="boleta" type="text" id="boleta" size="12" maxlength="12"></td>
    </tr>
</table>
<br>

<%
strSQL="SELECT monto_efectivo_cliente,monto_30_cliente,monto_60_cliente,monto_90_cliente,monto_efectivo_EMPRESA,monto_30_EMPRESA,monto_60_EMPRESA,monto_90_EMPRESA"
strSQL= strSQL & " FROM NEGOCIACION WHERE codigo_negociacion='"&negociacion&"'"
set rsNEGO=ConexionSCG.execute(strSQL)
if not rsNEGO.eof then

%>
	  <span class="Estilo26">DETALLE DE NEGOCIACION CLIENTE
      </span>	  <table width="100%" border="0">
        <tr bgcolor="#<%=session("COLTABBG")%>" class="Estilo13">
          <td width="20%">TOTAL CLIENTE </td>
          <td width="20%">PAGO EFECTIVO </td>
          <td width="20%">PAGO 30 </td>
          <td width="20%">PAGO 60 </td>
          <td width="20%">PAGO 90 </td>
        </tr>
        <tr class="Estilo8">
          <td><div align="right">$ <%=(rsNEGO("monto_efectivo_cliente")+rsNEGO("monto_30_cliente")+rsNEGO("monto_60_cliente")+rsNEGO("monto_90_cliente"))%></div></td>
          <td><div align="right">$ <%=rsNEGO("monto_efectivo_cliente")%></div></td>
          <td><div align="right">$ <%=rsNEGO("monto_30_cliente")%></div></td>
          <td><div align="right">$ <%=rsNEGO("monto_60_cliente")%></div></td>
          <td><div align="right">$ <%=rsNEGO("monto_90_cliente")%></div></td>
        </tr>
      </table>
	  <table width="100%" border="0">
        <tr bgcolor="#FF9900" class="Estilo13">
          <td width="36%"> TITULAR CUENTA</td>
          <td width="64%"> BANCO</td>
          </tr>
        <tr>
          <td><input name="titular" type="text" id="titular" size="30" maxlength="100"></td>
          <td><select name="banco">
            <option value="0">SELECCIONE</option>
            <%
		  ssql_2="SELECT nombre_banco FROM BANCO WHERE codigo_banco <>0 order by nombre_banco"
		  set rsBAN=ConexionCG.execute(ssql_2)
		  if not rsBAN.eof then
		  	do until rsBAN.eof
		  %>
            <option value="<%=rsBAN("nombre_banco")%>"><%=rsBAN("nombre_banco")%></option>
            <%
		   rsBAN.movenext
		   loop
		   end if
		   rsBAN.close
		   set rsBAN=nothing
		   %>
          </select></td>
          </tr>
      </table>
	  <table width="100%" border="0">
        <tr bgcolor="#FF9900" class="Estilo13">
          <td width="12%">N&ordm; CHEQUE</td>
          <td width="17%">MONTO</td>
          <td width="19%">FECHA COBRO </td>
        </tr>
        <tr>
          <td><input name="cheque1" type="text" id="cheque1" size="15" maxlength="15"></td>
          <td>&nbsp;</td>
          <td>&nbsp;</td>
        </tr>
        <tr>
          <td>&nbsp;</td>
          <td>&nbsp;</td>
          <td>&nbsp;</td>
        </tr>
        <tr>
          <td>&nbsp;</td>
          <td>&nbsp;</td>
          <td>&nbsp;</td>
        </tr>
      </table>
	  <br>
	  <span class="Estilo26">DETALLE DE NEGOCIACION EMPRESA </span>
	  <table width="100%" border="0">
        <tr bgcolor="#<%=session("COLTABBG")%>" class="Estilo13">
          <td width="20%">TOTAL EMPRESA </td>
          <td width="20%">PAGO EFECTIVO </td>
          <td width="20%">PAGO 30 </td>
          <td width="20%">PAGO 60 </td>
          <td width="20%">PAGO 90 </td>
        </tr>
        <tr class="Estilo8">
          <td><div align="right">$ <%=(rsNEGO("monto_efectivo_EMPRESA")+rsNEGO("monto_30_EMPRESA")+rsNEGO("monto_60_EMPRESA")+rsNEGO("monto_90_EMPRESA"))%></div></td>
          <td><div align="right">$ <%=rsNEGO("monto_efectivo_EMPRESA")%></div></td>
          <td><div align="right">$ <%=rsNEGO("monto_30_EMPRESA")%></div></td>
          <td><div align="right">$ <%=rsNEGO("monto_60_EMPRESA")%></div></td>
          <td><div align="right">$ <%=rsNEGO("monto_90_EMPRESA")%></div></td>
        </tr>
      </table>
	  <table width="100%" border="0">
        <tr bgcolor="#FF9900" class="Estilo13">
          <td width="36%"> TITULAR CUENTA</td>
          <td width="64%"> BANCO</td>
        </tr>
        <tr>
          <td><input name="titular" type="text" id="titular" size="30" maxlength="100"></td>
          <td><select name="banco">
              <option value="0">SELECCIONE</option>
              <%
		  ssql_2="SELECT nombre_banco FROM BANCO WHERE codigo_banco <>0 order by nombre_banco"
		  set rsBAN=ConexionCG.execute(ssql_2)
		  if not rsBAN.eof then
		  	do until rsBAN.eof
		  %>
              <option value="<%=rsBAN("nombre_banco")%>"><%=rsBAN("nombre_banco")%></option>
              <%
		   rsBAN.movenext
		   loop
		   end if
		   rsBAN.close
		   set rsBAN=nothing
		   %>
          </select></td>
        </tr>
      </table>
	  <table width="100%" border="0">
        <tr bgcolor="#FF9900" class="Estilo13">
          <td width="12%">N&ordm; CHEQUE</td>
          <td width="17%">MONTO</td>
          <td width="19%">FECHA COBRO </td>
        </tr>
        <tr>
          <td><input name="cheque1" type="text" id="cheque1" size="15" maxlength="15"></td>
          <td>&nbsp;</td>
          <td>&nbsp;</td>
        </tr>
        <tr>
          <td>&nbsp;</td>
          <td>&nbsp;</td>
          <td>&nbsp;</td>
        </tr>
        <tr>
          <td>&nbsp;</td>
          <td>&nbsp;</td>
          <td>&nbsp;</td>
        </tr>
      </table>

	  <%
	  end if
	  rsNEGO.close
	  set rsNEGO=nothing
	  %>

	  <span class="Estilo26"> </span>
	  <%end if%>
    </td>
  </tr>
  <tr>
    <td height="20" class="Estilo13"><div align="right">
      <input type="button" name="Submit" value="Atr&aacute;s" onClick="history.back();">
&nbsp;&nbsp;&nbsp;<input type="button" name="Submit" value="Finalizar" onClick="history.back();">
&nbsp;&nbsp;&nbsp;</div></td>
  </tr>
  <tr>
    <td height="20" bgcolor="#FF9900" class="Estilo13"><div align="right">Fecha : <%=DATE%> - Hora : <%=TIME%></div></td>
  </tr>
</table>
</form>

<script language="JavaScript" type="text/JavaScript">
function CargaNeg(){
datos.action='detalle_pago.asp';
datos.submit();
}
</script>
