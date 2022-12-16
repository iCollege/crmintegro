<% @LCID = 1034 %>
<!--#include file="../lib/comunes/bdatos/ConectarSCG_R.inc" -->
<!--#include file="../lib/comunes/bdatos/ConectarCargas.inc"-->
<!--#include file="../lib/comunes/rutinas/funciones.inc" -->
<!--#include file="lib.asp"-->

<%
inicio= request.Form("inicio")
if inicio="" then
inicio=request.QueryString("inicio")
end if

termino= request.Form("termino")
if termino="" then
termino=request.QueryString("termino")
end if

cliente = request.Form("cliente")
if cliente="" then
cliente = request.querystring("cliente")
end if


ejecutivo= request.Form("ejecutivo")
if ejecutivo="" then
ejecutivo=request.QueryString("ejecutivo")
end if

hora=request.Form("hora")
if hora="" then
hora=request.QueryString("hora")
end if

%>
<title>INFORME</title>

<style type="text/css">
<!--
.Estilo37 {color: #FFFFFF}
-->
</style>
<form name="datos" method="post">
<table width="833" height="420" border="0">
  <tr>
    <td width="827" height="20" class="Estilo20"><img src="../lib/TIT_INFORME_BALANCECARTERA.gif" width="740" height="22"></td>
  </tr>
  <tr>
    <td height="242" valign="top" background="../images/fondo_coventa.jpg">
	<BR>
	<table width="100%" border="0">
      <tr bgcolor="#<%=session("COLTABBG")%>" class="Estilo13">
        <td width="35%">CLIENTE</td>
        <td width="12%">EJECUTIVO</td>
        <td width="16%">FECHA INICIO </td>
        <td width="15%" bgcolor="#<%=session("COLTABBG")%>">FECHA TERMINO </td>
        <td width="22%" bgcolor="#<%=session("COLTABBG")%>">HORA</td>
        </tr>
      <tr>
        <td height="26" valign="top">
		<select name="cliente" id="cliente" onChange="envia();">
		<option value="">SELECCIONE</option>
		<option value="69" <%if cliente="69" then response.Write("Selected") end if%>>TODOS</option>
			<%
			ssql="SELECT codigo_cliente,razon_social_cliente FROM CLIENTE where scg_web= 1 order by razon_social_cliente"
			set rsCLI= conexionCG.execute(ssql)
			if not rsCLI.eof then
				do until rsCLI.eof%>
			<option value="<%=rsCLI("codigo_cliente")%>"<%if cint(cliente)=rsCLI("codigo_cliente") then response.Write("Selected") End If%>><%=rsCLI("razon_social_cliente")%></option>
			<%
				rsCLI.movenext
				loop
				end if
				rsCLI.close
				set rsCLI=nothing

			%>
        </select></td>
        <td valign="top"><select name="ejecutivo" id="ejecutivo">
		<option value="0">SELECCIONE</option>
		<option value="1" <%if ejecutivo="1" then response.Write("Selected") end if%>>TODOS</option>
		<%
		ssql="SELECT login FROM COBRADOR_CLIENTE WHERE codigo_cliente='"&cliente&"'"
		set rsCOB=ConexionSCG.execute(ssql)
		if not rsCOB.eof then
			do until rsCOB.eof
		%>
          <option value="<%=rsCOB("login")%>" <%if ejecutivo=rsCOB("login") then response.Write("Selected") end if%>><%=rsCOB("login")%></option>
		 <%
		 	rsCOB.movenext
			loop
		End If
		rsCOB.close
		set rsCOB=Nothing
		 %>
        </select></td>
        <td valign="top"><input name="inicio" type="text" id="inicio" value="<%=inicio%>" size="10" maxlength="10">
		<a href="javascript:showCal('Calendar7');"><img src="../lib/calendario.gif" border="0"></a></td>
        <td valign="top"><input name="termino" type="text" id="termino" value="<%=termino%>" size="10" maxlength="10">
          <a href="javascript:showCal('Calendar6');"><img src="../lib/calendario.gif" border="0"></a>
		  </td>
        <td valign="top"><select name="hora" id="hora">
          <option value="0" <%if hora="0" then%>Selected<%End If%>>TODAS</option>
          <option value="9" <%if hora="9" then%>Selected<%End If%>>09:00</option>
          <option value="10" <%if hora="10" then%>Selected<%End If%>>10:00</option>
          <option value="11" <%if hora="11" then%>Selected<%End If%>>11:00</option>
          <option value="12" <%if hora="12" then%>Selected<%End If%>>12:00</option>
          <option value="13" <%if hora="13" then%>Selected<%End If%>>13:00</option>
          <option value="14" <%if hora="14" then%>Selected<%End If%>>14:00</option>
          <option value="15" <%if hora="15" then%>Selected<%End If%>>15:00</option>
          <option value="16" <%if hora="16" then%>Selected<%End If%>>16:00</option>
          <option value="17" <%if hora="17" then%>Selected<%End If%>>17:00</option>
          <option value="18" <%if hora="18" then%>Selected<%End If%>>18:00</option>
          <option value="19" <%if hora="19" then%>Selected<%End If%>>19:00</option>
          <option value="20" <%if hora="20" then%>Selected<%End If%>>20:00</option>
        </select>&nbsp;&nbsp; <input type="submit" name="Submit" value="Ver" onClick="envia2();">
        <input type="submit" name="Submit" value="Detalle" onClick="excel();"></td>
        </tr>
    </table>

	<%
	IF not cliente="" and not ejecutivo="0" then

	G111 = 0
	G112 = 0
	G121 = 0
	G122 = 0
	G123 = 0
	G124 = 0
	G125 = 0
	G131 = 0
	G132 = 0
	G133 = 0
	G134 = 0
	G140 = 0
	G150 = 0
	G210 = 0
	G220 = 0
	G230 = 0
	G240 = 0
	G250 = 0
	G310 = 0
	G320 = 0
	G330 = 0
	G411 = 0
	G412 = 0
	G421 = 0
	G422 = 0
	G423 = 0
	G424 = 0
	G431 = 0
	G432 = 0
	G433 = 0
	G434 = 0
	G440 = 0
	G450 = 0
	G510 = 0
	G520 = 0
	G530 = 0
	G540 = 0
	G550 = 0
	G126 = 0
	G127 = 0
	M111 = 0


	if cliente="69" Then
		if ejecutivo="1" then
				if hora="0" then
						ssql="SELECT DISTINCT RutDeudor AS DEUDOR FROM GESTIONES WHERE FechaIngreso>='"&inicio&"' and FechaIngreso<='"&termino&"'"
				else
						ssql="SELECT DISTINCT RutDeudor AS DEUDOR FROM GESTIONES WHERE FechaIngreso>='"&inicio&"' and FechaIngreso<='"&termino&"' and datepart(hour,HoraIngreso)='"&hora&"'"
				end if
		else
				if hora="0" then
						ssql="SELECT DISTINCT RutDeudor AS DEUDOR FROM GESTIONES WHERE CodCobrador='"&ejecutivo&"' and FechaIngreso>='"&inicio&"' and FechaIngreso<='"&termino&"'"
				else
						ssql="SELECT DISTINCT RutDeudor AS DEUDOR FROM GESTIONES WHERE CodCobrador='"&ejecutivo&"' and FechaIngreso>='"&inicio&"' and FechaIngreso<='"&termino&"' and datepart(hour,HoraIngreso)='"&hora&"'"
				end if
		end if
	else
		if ejecutivo="1" then
				if hora="0" then
						ssql="SELECT DISTINCT RutDeudor AS DEUDOR FROM GESTIONES WHERE codcliente='"&cliente&"' and  FechaIngreso>='"&inicio&"' and FechaIngreso<='"&termino&"'"
				else
						ssql="SELECT DISTINCT RutDeudor AS DEUDOR FROM GESTIONES WHERE codcliente='"&cliente&"' and  FechaIngreso>='"&inicio&"' and FechaIngreso<='"&termino&"' and datepart(hour,HoraIngreso)='"&hora&"'"
				end if
		else
			if hora="0" then
				ssql="SELECT DISTINCT RutDeudor AS DEUDOR FROM GESTIONES WHERE CodCobrador='"&ejecutivo&"' and codcliente='"&cliente&"' and  FechaIngreso>='"&inicio&"' and FechaIngreso<='"&termino&"'"
			else
				ssql="SELECT DISTINCT RutDeudor AS DEUDOR FROM GESTIONES WHERE CodCobrador='"&ejecutivo&"' and codcliente='"&cliente&"' and  FechaIngreso>='"&inicio&"' and FechaIngreso<='"&termino&"' and datepart(hour,HoraIngreso)='"&hora&"'"
			end if
		end if
	end if

	set rsDET=conexionSCG.execute(ssql)
	if not rsDET.eof then
		do until rsDET.eof
					rut = rsDET("DEUDOR")

					sql2="SELECT TOP 1 CAST(CodCategoria AS CHAR(1))+CAST(CodSubCategoria AS CHAR(1))+CAST(ISNULL(CodGestion,0) AS CHAR(1)) AS GESTION FROM GESTIONES WHERE CODCLIENTE='"&cliente&"' AND RUTDEUDOR='"& rut &"' ORDER BY CORRELATIVO DESC"
					set rs = conexionSCG.execute(sql2)
					if not rs.eof then
					gestion=rs("GESTION")

						SELECT CASE gestion
						CASE "111":
							G111 = G111 + 1
						CASE "112":
							G112 = G112 + 1
						CASE "121":
							G121 = G121 + 1
						CASE "122":
							G122 = G122 + 1
						CASE "123":
							G123 = G123 + 1
						CASE "124":
							G124 = G124 + 1
						CASE "125":
							G125 = G125 + 1
						CASE "126":
							G126 = G126 + 1
						CASE "127":
							G127 = G127 + 1
						CASE "131":
							G131 = G131 + 1
						CASE "132":
							G132 = G132 + 1
						CASE "133":
							G133 = G133 + 1
						CASE "134":
							G134 = G134 + 1
						CASE "140":
							G140 = G140 + 1
						CASE "150":
							G150 = G150 + 1
						CASE "210":
							G210 = G210 + 1
						CASE "220":
							G220 = G220 + 1
						CASE "230":
							G230 = G230 + 1
						CASE "240":
							G240 = G240 + 1
						CASE "250":
							G250 = G250 + 1
						CASE "310":
							G310 = G310 + 1
						CASE "320":
							G320 = G320 + 1
						CASE "330":
							G330 = G330 + 1
						CASE "411":
							G411 = G411 + 1
						CASE "412":
							G412 = G412 + 1
						CASE "421":
							G421 = G421 + 1
						CASE "422":
							G422 = G422 + 1
						CASE "423":
							G423 = G423 + 1
						CASE "424":
							G424 = G424 + 1
						CASE "431":
							G431 = G431 + 1
						CASE "432":
							G432 = G432 + 1
						CASE "433":
							G433 = G433 + 1
						CASE "434":
							G434 = G434 + 1
						CASE "440":
							G440 = G440 + 1
						CASE "450":
							G450 = G450 + 1
						CASE "510":
							G510 = G510 + 1
						CASE "520":
							G520 = G520 + 1
						CASE "530":
							G530 = G530 + 1
						CASE "540":
							G540 = G540 + 1
						CASE "550":
							G550 = G550 + 1
						END SELECT

					end if
					rs.close
					set rs = nothing

					sql3="SELECT PAGO_CUOTA.MONTOCAPITAL AS MONTO FROM PAGO_CUOTA,PAGO WHERE PAGO_CUOTA.CODPAGO = PAGO.CODIGO AND PAGO_CUOTA.COD_CLI='"&cliente&"' AND PAGO_CUOTA.RUTDEUDOR='"&rut&"' AND PAGO.FECHA>='"&inicio&"'"
					set rs=conexionSCG.execute(sql3)
					if not rs.eof then
					monto=clng(rs("MONTO"))
					M111 = M111 + monto
					end if
					rs.close
					set rs=nothing

		rsDET.movenext
		loop
	end if
	rsDET.close
	set rsDET=nothing
	RUTS = 0
	%>

	<table width="100%" border="0">
      <tr bgcolor="#<%=session("COLTABBG")%>" class="Estilo13">
        <td width="23%">CATEGORIA</td>
        <td width="31%">SUBCATEGORIA</td>
        <td width="36%">GESTION</td>
        <td width="10%"><div align="left">RUTS</div></td>
        </tr>
      <tr>
        <td>1. CONTACTO EN FONO</td>
        <td>1. FONO NO CORRESPONDE</td>
        <td>1. DATOS ADICIONALES</td>
        <td><div align="right"><%=G111%></div></td>
        </tr>
      <tr>
        <td>&nbsp;</td>
        <td>&nbsp;</td>
        <td>2. SIN DATOS ADICIONALES </td>
        <td><div align="right"><%=G112%></div></td>
        </tr>
      <tr>
        <td>&nbsp;</td>
        <td>2. ENTREVISTA CON EL DEUDOR </td>
        <td>1. SIN INTENCION DE PAGO </td>
        <td><div align="right"><%=G121%></div></td>
        </tr>
      <tr>
        <td>&nbsp;</td>
        <td>&nbsp;</td>
        <td>2. CESANTE</td>
        <td><div align="right"><%=G122%></div></td>
        </tr>
      <tr>
        <td>&nbsp;</td>
        <td>&nbsp;</td>
        <td bgcolor="#66CCFF">3. COMPROMISO DE PAGO </td>
        <td bgcolor="#66CCFF"><div align="right"><%=G123%></div></td>
        </tr>
      <tr>
        <td>&nbsp;</td>
        <td>&nbsp;</td>
        <td>4. DEUDOR SOLICITA DEMANDA</td>
        <td><div align="right"><%=G124%></div></td>
        </tr>
      <tr>
        <td>&nbsp;</td>
        <td>&nbsp;</td>
        <td bgcolor="#66CCFF">5. REAGENDAR LLAMADA </td>
        <td bgcolor="#66CCFF"><div align="right"><%=G125%></div></td>
        </tr>
      <tr>
        <td>&nbsp;</td>
        <td>&nbsp;</td>
        <td bgcolor="#66CCFF">6. RETIRO DE PAGO A DOMICILIO </td>
        <td bgcolor="#66CCFF"><div align="right"><%=G126%></div></td>
        </tr>
      <tr>
        <td>&nbsp;</td>
        <td>&nbsp;</td>
        <td bgcolor="#66CCFF">7. SOLICITUD DE COBRANZA DE TERRENO </td>
        <td bgcolor="#66CCFF"><div align="right"><%=G127%></div></td>
        </tr>
      <tr>
        <td>&nbsp;</td>
        <td>3. DEUDOR NO RECONOCE DEUDA </td>
        <td>1. DEUDA CANCELADA </td>
        <td><div align="right"><%=G131%></div></td>
        </tr>
      <tr>
        <td>&nbsp;</td>
        <td>&nbsp;</td>
        <td>2. RECLAMO PENDIENTE </td>
        <td><div align="right"><%=G132%></div></td>
        </tr>
      <tr>
        <td>&nbsp;</td>
        <td>&nbsp;</td>
        <td>3. DEUDA POR NORMALIZAR </td>
        <td><div align="right"><%=G133%></div></td>
        </tr>
      <tr>
        <td>&nbsp;</td>
        <td>&nbsp;</td>
        <td>4. DEUDOR CON CONVENIO DE PAGO </td>
        <td><div align="right"><%=G134%></div></td>
        </tr>
      <tr>
        <td>&nbsp;</td>
        <td>4. DEUDOR FALLECIDO </td>
        <td>&nbsp;</td>
        <td><div align="right"><%=G140%></div></td>
        </tr>
      <tr>
        <td>&nbsp;</td>
        <td bgcolor="#66CCFF">5. CONTACTO CON TERCEROS</td>
        <td bgcolor="#66CCFF">&nbsp;</td>
        <td bgcolor="#66CCFF"><div align="right"><%=G150%></div></td>
        </tr>
      <tr>
        <td>2. SIN CONTACTO EN FONO </td>
        <td>1. NUMERO FUERA DE SERVICIO </td>
        <td>&nbsp;</td>
        <td><div align="right"><%=G210%></div></td>
        </tr>
      <tr>
        <td>&nbsp;</td>
        <td>2. NUMERO VACANTE </td>
        <td>&nbsp;</td>
        <td><div align="right"><%=G220%></div></td>
        </tr>
      <tr>
        <td>&nbsp;</td>
        <td>3. NUMERO CORRESPONDE A FAX</td>
        <td>&nbsp;</td>
        <td><div align="right"><%=G230%></div></td>
        </tr>
      <tr>
        <td>&nbsp;</td>
        <td>4. CONTESTADOR AUTOM&Aacute;TICO </td>
        <td>&nbsp;</td>
        <td><div align="right"><%=G240%></div></td>
        </tr>
      <tr>
        <td>&nbsp;</td>
        <td>5. TELEFONO NO CONTESTA / OCUPADO </td>
        <td>&nbsp;</td>
        <td><div align="right"><%=G250%></div></td>
        </tr>
      <tr>
        <td>3. GESTION DE APOYO </td>
        <td>1. ENV&Iacute;O DE CORREO ELECTR&Oacute;NICO </td>
        <td>&nbsp;</td>
        <td><div align="right"><%=G310%></div></td>
        </tr>
      <tr>
        <td>&nbsp;</td>
        <td>2. ENV&Iacute;O DE CARTA </td>
        <td>&nbsp;</td>
        <td><div align="right"><%=G320%></div></td>
        </tr>
      <tr>
        <td>&nbsp;</td>
        <td>3. ENV&Iacute;O DE FAX </td>
        <td>&nbsp;</td>
        <td><div align="right"><%=G330%></div></td>
        </tr>
      <tr>
        <td>4. DIRECCI&Oacute;N EXISTE </td>
        <td>1. DEUDOR NO RESIDE </td>
        <td>1. DATOS ADICIONALES </td>
        <td><div align="right"><%=G411%></div></td>
        </tr>
      <tr>
        <td>&nbsp;</td>
        <td>&nbsp;</td>
        <td>2. SIN DATOS ADICIONALES </td>
        <td><div align="right"><%=G412%></div></td>
        </tr>
      <tr>
        <td>&nbsp;</td>
        <td>2. ENTREVISTA CON EL DEUDOR </td>
        <td>1. SIN INTENCI&Oacute;N DE PAGO DEMANDABLE </td>
        <td><div align="right"><%=G421%></div></td>
        </tr>
      <tr>
        <td>&nbsp;</td>
        <td>&nbsp;</td>
        <td>2. SIN INTENCI&Oacute;N DE PAGO NO DEMANDABLE </td>
        <td><div align="right"><%=G422%></div></td>
        </tr>
      <tr>
        <td>&nbsp;</td>
        <td>&nbsp;</td>
        <td>3. CESANTE </td>
        <td><div align="right"><%=G423%></div></td>
        </tr>
      <tr>
        <td>&nbsp;</td>
        <td>&nbsp;</td>
        <td>4. COMPROMISO DE PAGO </td>
        <td><div align="right"><%=G424%></div></td>
        </tr>
      <tr>
        <td>&nbsp;</td>
        <td>3. DEUDOR NO RECONOCE DEUDA </td>
        <td>1. DEUDA CANCELADA </td>
        <td><div align="right"><%=G431%></div></td>
        </tr>
      <tr>
        <td>&nbsp;</td>
        <td>&nbsp;</td>
        <td>2. RECLAMO PENDIENTE </td>
        <td><div align="right"><%=G432%></div></td>
        </tr>
      <tr>
        <td>&nbsp;</td>
        <td>&nbsp;</td>
        <td>3. DEUDA POR NORMALIZAR (COMPROBANTE) </td>
        <td><div align="right"><%=G433%></div></td>
        </tr>
      <tr>
        <td>&nbsp;</td>
        <td>&nbsp;</td>
        <td>4. DEUDOR CON CONVENIO DE PAGO </td>
        <td><div align="right"><%=G434%></div></td>
        </tr>
      <tr>
        <td>&nbsp;</td>
        <td>4. DEUDOR FALLECIDO </td>
        <td>&nbsp;</td>
        <td><div align="right"><%=G440%></div></td>
        </tr>
      <tr>
        <td>&nbsp;</td>
        <td>5. CONTACTO CON TERCEROS - NOTIF.</td>
        <td>&nbsp;</td>
        <td><div align="right"><%=G450%></div></td>
        </tr>
      <tr>
        <td>5. DIRECCI&Oacute;N NO UBICADA </td>
        <td>1. NUMERO MUNICIPAL NO EXISTE </td>
        <td>&nbsp;</td>
        <td><div align="right"><%=G510%></div></td>
        </tr>
      <tr>
        <td>&nbsp;</td>
        <td>2. CALLE NO EXISTE </td>
        <td>&nbsp;</td>
        <td><div align="right"><%=G520%></div></td>
        </tr>
      <tr>
        <td>&nbsp;</td>
        <td>3. SITIO ERIAZO </td>
        <td>&nbsp;</td>
        <td><div align="right"><%=G530%></div></td>
        </tr>
      <tr>
        <td>&nbsp;</td>
        <td>4. CONSTRUCCI&Oacute;N </td>
        <td>&nbsp;</td>
        <td><div align="right"><%=G540%></div></td>
        </tr>
      <tr>
        <td>&nbsp;</td>
        <td>5. FALTA INFORMACI&Oacute;N </td>
        <td>&nbsp;</td>
        <td><div align="right"><%=G550%></div></td>
        </tr>
      <tr bgcolor="#<%=session("COLTABBG")%>">
        <td>&nbsp;</td>
        <td>&nbsp;</td>
        <td><span class="Estilo37">MONTO RECUPERADO </span></td>
        <td><div align="right" class="Estilo37">$ <%=FN(M111,0)%></div></td>
        </tr>
      <tr bgcolor="#<%=session("COLTABBG")%>">
        <td><span class="Estilo37"></span></td>
        <td><span class="Estilo37"></span></td>
        <td><span class="Estilo37">TOTAL DE GESTIONES REALIZADAS</span></td>
        <td><div align="right" class="Estilo37"><%=TT%></div></td>
        </tr>
      <tr bgcolor="#<%=session("COLTABBG")%>">
        <td>&nbsp;</td>
        <td>&nbsp;</td>
        <td><span class="Estilo37">TOTAL DEUDORES ACTIVOS </span></td>
        <td><span class="Estilo37">
          <%
		cantidad_activa = 0
		ssql="SELECT rut_activos FROM SCG_WEB_INFORME_RECUPERACION WHERE CODIGO_CLIENTE='"&cliente&"' AND MES=DATEPART(MONTH,GETDATE()) AND ANNO=DATEPART(YEAR,GETDATE())"
		set rsACT=conexionSCG.execute(ssql)
		if not rsACT.eof then
		cantidad_activa = CLNG(rsACT("rut_activos"))
		end if
		rsACT.close
		set rsACT=nothing
		response.Write(cantidad_Activa)
		porcentaje_recorrido=(RUTS/cantidad_Activa)*100
		%>
        </span></td>
        </tr>
      <tr bgcolor="#<%=session("COLTABBG")%>">
        <td>&nbsp;</td>
        <td>&nbsp;</td>
        <td><span class="Estilo37">PORCENTAJE GESTIONADO</span></td>
        <td><div align="right" class="Estilo37">
          <%response.Write(FN(porcentaje_recorrido,0))%>
  % </div></td>
        </tr>
    </table>
	<% end if %>
	  </td>
  </tr>
</table>

</form>

<script language="JavaScript1.2">
function envia(){
if (datos.cliente.value=='0'){
alert('DEBE SELECCIONAR UN CLIENTE');
}else{
datos.action='informe_desarrollo.asp';
datos.submit();
}
}

function envia2(){
if (datos.cliente.value=='0'){
alert('DEBE SELECCIONAR UN CLIENTE');
}else{
datos.action='informe_cargando_gestiones_d.asp';
datos.submit();
}
}



function excel(){
if (datos.cliente.value=='0'){
alert('DEBE SELECCIONAR UN CLIENTE');
}else if(datos.inicio.value==''){
alert('DEBE SELECCIONAR FECHA DE INICIO');
}else if(datos.termino.value==''){
alert('DEBES SELECCIONAR FECHA DE TERMINO');
}else{
datos.action='informe_gestiones_xls.asp';
datos.submit();
}
}
</script>
