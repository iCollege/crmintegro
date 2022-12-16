<% @LCID = 1034 %>
<!--#include file="arch_utils.asp"-->
<!--#include file="../lib/comunes/rutinas/funciones.inc" -->
<!--#include file="lib.asp"-->
<% 'Server.ScriptTimeout=120%>


<%
inicio= request.querystring("inicio")
if inicio="" then
inicio=date
end if
termino= request.querystring("termino")
if termino="" then
termino=date
end if
cliente = request.querystring("cliente")
sucursal = TRIM(request.QueryString("sucursal"))

%>
<title>INFORME CONSOLIDADO DE RECUPERACION</title>

<style type="text/css">
<!--
.Estilo37 {color: #FFFFFF}
.Estilo38 {color: #000000}
-->
</style>
<form name="datos" method="post">
<table width="720" height="420" border="0">
  <tr>
    <td width="827" height="20" class="Estilo20"><img src="../lib/TIT_INFORME_RECUPERACION2.gif" width="740" height="22"></td>
  </tr>
  <tr>
    <td height="242" valign="top" background="../images/fondo_coventa.jpg">
	<BR>
	<table width="100%" border="0">
      <tr bgcolor="#<%=session("COLTABBG")%>" class="Estilo13">
        <td width="22%">SUCURSAL</td>
        <td width="31%">CLIENTE</td>
        <td width="18%">FECHA INICIO </td>
        <td width="29%" bgcolor="#<%=session("COLTABBG")%>">FECHA TERMINO </td>
        </tr>
      <tr>
        <td valign="top"><select name="sucursal" id="sucursal">
          <option value="SELECCIONE">SELECCIONE</option>
          <option value="Arica" <%if sucursal="Arica" then response.Write("Selected") End if%>>ARICA</option>
          <option value="Iquique" <%if sucursal="Iquique" then response.Write("Selected") End if%>>IQUIQUE</option>
          <option value="Antofagasta" <%if sucursal="Antofagasta" then response.Write("Selected") End if%>>ANTOFAGASTA</option>
          <option value="Copiapo" <%if sucursal="Copiapo" then response.Write("Selected") End if%>>COPIAPO</option>
          <option value="La Serena" <%if sucursal="La Serena" then response.Write("Selected") End if%>>LA SERENA</option>
          <option value="Valparaiso" <%if sucursal="Valparaiso" then response.Write("Selected") End if%>>VALPARAISO</option>
          <option value="Santiago" <%if sucursal="Santiago" then response.Write("Selected") End if%>>SANTIAGO</option>
          <option value="Rancagua" <%if sucursal="Rancagua" then response.Write("Selected") End if%>>RANCAGUA</option>
          <option value="Talca" <%if sucursal="Talca" then response.Write("Selected") End if%>>TALCA</option>
          <option value="Concepcion" <%if sucursal="Concepcion" then response.Write("Selected") End if%>>CONCEPCION</option>
          <option value="Temuco" <%if sucursal="Temuco" then response.Write("Selected") End if%>>TEMUCO</option>
          <option value="Valdivia" <%if sucursal="Valdivia" then response.Write("Selected") End if%>>VALDIVIA</option>
          <option value="Osorno" <%if sucursal="Osorno" then response.Write("Selected") End if%>>OSORNO</option>
          <option value="Puerto Montt" <%if sucursal="Puerto Montt" then response.Write("Selected") End if%>>PTO. MONTT</option>
          <option value="Coyhaique" <%if sucursal="Coyhaique" then response.Write("Selected") End if%>>COYHAIQUE</option>
          <option value="Punta Arenas" <%if sucursal="Punta Arenas" then response.Write("Selected") End if%>>PUNTA ARENAS</option>
          <option value="0" <%if sucursal="0" then response.Write("Selected") End If%>>TODAS</option>
        </select></td>
        <td height="26" valign="top">
		<select name="cliente" id="cliente">
		<option value="0">SELECCIONE</option>
			<%
			abrirscg()
			ssql="SELECT codigo_cliente,razon_social_cliente FROM CLIENTE where scg_web= 1 order by razon_social_cliente"
			set rsCLI= Conn.execute(ssql)
			if not rsCLI.eof then
				do until rsCLI.eof%>
			<option value="<%=rsCLI("codigo_cliente")%>"<%if cint(cliente)=rsCLI("codigo_cliente") then response.Write("Selected") End If%>><%=rsCLI("razon_social_cliente")%></option>
			<%
				rsCLI.movenext
				loop
				end if
				rsCLI.close
				set rsCLI=nothing
				cerrarscg()
			%>
        </select></td>
        <td valign="top"><input name="inicio" type="text" id="inicio" value="<%=inicio%>" size="10" maxlength="10">
		<a href="javascript:showCal('Calendar7');"><img src="../lib/calendario.gif" border="0"></a></td>
        <td valign="top"><input name="termino" type="text" id="termino" value="<%=termino%>" size="10" maxlength="10">
          <a href="javascript:showCal('Calendar6');"><img src="../lib/calendario.gif" border="0"></a>
&nbsp;&nbsp;
<input type="submit" name="Submit" value="Ver" onClick="envia();">
</td>
        </tr>
    </table>

	<%
	total_deudores_activo_s=0
	total_capital_pago_s=0
	total_usuarios_s = 0
	if not cliente="" and not sucursal="0" then
%>
	<table width="100%"  border="0">
	<tr>
	  <td width="10%" bgcolor="#<%=session("COLTABBG")%>"><div align="center"><span class="Estilo37">SUCURSAL</span></div></td>
	   <td width="10%" bgcolor="#<%=session("COLTABBG")%>"><div align="center"><span class="Estilo37">EJECUTIVO</span></div></td>
	   <td width="8%" bgcolor="#<%=session("COLTABBG")%>"><div align="center"><span class="Estilo37">CAPITAL ASIGNADO</span></div></td>
	   <td width="8%" bgcolor="#<%=session("COLTABBG")%>"><div align="center"><span class="Estilo37">DEUDORES</span></div></td>
	   <td width="8%" bgcolor="#<%=session("COLTABBG")%>"><div align="center"><span class="Estilo37">CAPITAL RECUPERADO</span></div></td>
	   <td width="8%" bgcolor="#<%=session("COLTABBG")%>"><div align="center"><span class="Estilo37">GASTO</span></div></td>
	   <td width="8%" bgcolor="#<%=session("COLTABBG")%>"><div align="center"><span class="Estilo37">RUT</span></div></td>
	   </tr>
    <%
	 activo_total = 0
	 deudores_total = 0
	 montototal=0
	 gastototal=0
	 cdeudtotal=0
	 abrirscg()
	 if sucursal = "0" then
	 ssql2="select login,isnull(sucursal,'SIN SUCURSAL') as sucursal,ISNULL(monto_activo,0) as monto_activo,ISNULL(rut_activo,0) as rut_activo from cobrador_cliente where codigo_cliente='"&cliente&"' AND TIPO='TER'"
	 else
	 ssql2="select login,isnull(sucursal,'SIN SUCURSAL') as sucursal,ISNULL(monto_activo,0) as monto_activo,ISNULL(rut_activo,0) as rut_activo  from cobrador_cliente where codigo_cliente='"&cliente&"' AND TIPO='TER' AND sucursal='"&sucursal&"'"
	 end if
	 set rsCOB=Conn.execute(ssql2)
	 if not rsCOB.eof then
	 	do until rsCOB.eof

				monto=0
				gasto=0
				cdeud=0

				sql3="SELECT SUM(PAGO_CUOTA.MONTOCAPITAL) AS MONTO,SUM(PAGO_CUOTA.UTILIDAD_EMPRESA) AS GASTO,COUNT(DISTINCT RUTDEUDOR) AS CDEUDORES FROM PAGO_CUOTA,PAGO WHERE PAGO_CUOTA.CODPAGO = PAGO.CODIGO AND PAGO_CUOTA.COD_CLI='"&cliente&"' AND PAGO_CUOTA.CODCOBRADOR='"&rsCOB("login")&"' AND PAGO.FECHA>='"&inicio&"' AND PAGO.FECHA<='"&termino&"'"
				''Response.write "<br>sql3="&sql3
				set rsHR=Conn.execute(sql3)
				if not rsHR.eof then
				monto=rsHR("MONTO")
				gasto=rsHR("GASTO")
				cdeud=rsHR("CDEUDORES")
				else
				monto=0
				gasto=0
				cdeud=0
				end if
				rsHR.close
				set rsR=Nothing
				if isnull(monto) then
				monto=0
				end if

				if isNULL(gasto) then
				gasto=0
				end if

				if isnull(cdeud) then
				cdeud=0
				end if

				montototal=clng(monto) + clng(montototal)
				gastototal=clng(gasto) + clng(gastototal)
				cdeudtotal=clng(cdeudtotal) + clng(cdeud)
				activo_total = rsCOB("monto_activo") + activo_total
				deudores_total = rsCOB("rut_activo") + deudores_total
	 %>
	   <tr>
	     <td><span class="Estilo37 Estilo38"><%=rsCOB("sucursal")%></span></td>
	     <td><div align="left"><span class="Estilo37 Estilo38"><%=rsCOB("login")%></span></div></td>
	     <td><div align="right"><span class="Estilo37 Estilo38">$ <%=FN(rsCOB("monto_activo"),0)%></span></div></td>
	     <td><div align="right"><span class="Estilo37 Estilo38"><%=FN(rsCOB("rut_activo"),0)%></span></div></td>
	     <td><div align="right"><span class="Estilo38">$ <%=FN(clng(monto),0)%></span></div></td>
	     <td><div align="right"><span class="Estilo38">$ <%=FN(clng(gasto),0)%></span></div></td>
	     <td><div align="right"><span class="Estilo38">
			<%if cdeud > 0 then%>
			<a href="detalle_pagos_xls.asp?cliente=<%=cliente%>&cobrador=<%=rsCOB("login")%>&inicio=<%=inicio%>&termino=<%=termino%>"><%=FN(cdeud,0)%></a>
		 	<%else%>
		    0
		 	<%End if%>
		 </span></div></td>
	   </tr>
	 <%
	 	rsCOB.movenext
	 	loop
	 end if
	 rsCOB.close
	 set rsCOB=Nothing
	 cerrarscg()
	 %>
	 <tr>
	   <td>&nbsp;</td>
	   <td>CALL CENTER </td>
	   <td>&nbsp;</td>
	   <td>&nbsp;</td>
	   <td><div align="right">
	         <%
	   monto_otros=0
	   gasto_otros=0
	   abrirscg()
	   ssql="SELECT SUM(isnull(PAGO_CUOTA.MONTOCAPITAL,0)) AS MONTO,SUM(isnull(PAGO_CUOTA.UTILIDAD_EMPRESA,0)) AS GASTO,COUNT(DISTINCT RUTDEUDOR) AS CDEUDORES FROM PAGO_CUOTA,PAGO WHERE PAGO_CUOTA.CODPAGO = PAGO.CODIGO AND PAGO_CUOTA.COD_CLI='"&cliente&"' AND PAGO_CUOTA.CODCOBRADOR NOT IN (SELECT LOGIN FROM COBRADOR_CLIENTE WHERE CODIGO_CLIENTE='"&cliente&"' and tipo='TER') AND PAGO.FECHA>='"&inicio&"' AND PAGO.FECHA<='"&termino&"'"
	   set rs=Conn.execute(ssql)
	   if not rs.eof then
	   monto_otros = rs("MONTO")
	   gasto_otros = rs("GASTO")
	   deu_otros = rs("CDEUDORES")
	   else
	   gasto_otros=0
	   monto_otros=0
	   deu_otros=0
	   end if
	   rs.Close
	   set rs=nothing
	   response.Write("$ ")
	   if isnull(monto_otros) then
	   monto_otros = 0
	   end if
	   response.Write(FN(clng(monto_otros),0))

	   if isNULL(gasto_otros) then
	   gasto_otros=0
	   end if

	   if isNULL(monto_otros) then
	   monto_otros=0
	   end if

	   if isNULL(deu_otros) then
	   deu_otros=0
	   end if

   %>
	     </div></td>
	   <td><div align="right">$ <%=FN(clng(gasto_otros),0)%></div></td>
	   <td><div align="right"><span class="Estilo38"><%=FN(deu_otros,0)%></span></div></td>
	   </tr>
	 <tr>
	 <tr bgcolor="#<%=session("COLTABBG")%>">
	   <td><span class="Estilo37">TOTALES</span></td>
	   <td><div align="right"></div></td>
	   <td><div align="right"><span class="Estilo37">$ <%=FN(activo_total,0)%></span></div></td>
	   <td><div align="right"><span class="Estilo37"><%=FN(deudores_total,0)%></span></div></td>
	   <td><div align="right" class="Estilo37">$ <%=FN(montototal,0)%></div></td>
	   <td><div align="right"><span class="Estilo37">$ <%=FN(gastototal,0)%></span></div></td>
	   <td><div align="right" class="Estilo37"><%=FN(cdeudtotal,0)%></div></td>
	   </tr>
    </table>
	<%end if%>
	<%	if sucursal="0" then%>
	<%


		abrirscg()
		ssql="SELECT RAZON_SOCIAL_CLIENTE FROM CLIENTE WHERE codigo_cliente ='"&cliente&"'"
		set rsCLI=Conn.execute(ssql)
		if not rsCLI.eof then
		ncliente = rsCLI("RAZON_SOCIAL_CLIENTE")
		else
		ncliente = "ERROR"
		end if
		rsCLI.close
		set rsCLI=nothing
		cerrarscg()
	%>

	<table width="100%" border="0">
	  <tr bgcolor="#<%=session("COLTABBG")%>">
		<td width="20%"><div align="center"><span class="Estilo37">SUCURSAL</span></div></td>
		<td width="15%"><div align="center"><span class="Estilo37">CAPITAL ASIGNADO </span></div></td>
		<td width="15%"><div align="center"><span class="Estilo37">DEUDORES ASIGNADOS </span></div></td>
		<td width="15%"><div align="center"><span class="Estilo37">CAPITAL PAGO </span></div></td>
		<td width="15%"><div align="center"><span class="Estilo37">GASTO</span></div></td>
		<td width="15%"><div align="center"><span class="Estilo37">DEUDORES PAGADOS </span></div></td>
	  </tr>
	  <tr>
		<td><a href="informe_cargando_consolidado_rt.asp?cliente=<%=cliente%>&sucursal=Arica&inicio=<%=inicio%>&termino=<%=termino%>">ARICA</a></td>
		<td>
		  <div align="right">
		      <%
		abrirscg()
		ssql="SELECT SUM(monto_activo) AS monto_activo,sum(rut_activo) AS DEU FROM COBRADOR_CLIENTE WHERE SUCURSAL='Arica' AND codigo_cliente='"&cliente&"'"
		set rsA = Conn.execute(ssql)
		if not rsA.eof then
		monto_asignado_1 = rsA("monto_activo")
		ruts_activos_1  = rsA("DEU")
		else
		monto_asignado_1 = 0
		ruts_activos_1 = 0
		end if
		rsA.close
		set rsA = nothing
		cerrarscg()
		if not isnull(monto_asignado_1) then
		response.Write("$ ")
		response.Write(FN(monto_asignado_1,0))
		else
				monto_asignado_1 = 0
		response.Write("$ 0")
		end if

		if isnull(ruts_activos_1) then
		ruts_activos_1 = 0
		end if
		%>
		    </div></td>
		<td>
		<div align="right">
		<%total_deudores_activo_s = total_deudores_activo_s +  ruts_activos_1%>
		<%=ruts_activos_1%>		</div>
		</td>
		<td>
		  <div align="right">

	      		<%
 				monto=0
				gasto=0
				cdedu1=0
				abrirscg()
				sql3="SELECT SUM(PAGO_CUOTA.MONTOCAPITAL) AS MONTO,SUM(PAGO_CUOTA.UTILIDAD_EMPRESA) AS GASTO,COUNT(DISTINCT PAGO_CUOTA.RUTDEUDOR) AS CDEUDORES FROM PAGO_CUOTA,PAGO,COBRADOR_CLIENTE WHERE PAGO_CUOTA.CODPAGO = PAGO.CODIGO AND PAGO_CUOTA.COD_CLI='"&cliente&"' AND PAGO_CUOTA.CODCOBRADOR = COBRADOR_CLIENTE.LOGIN AND PAGO.FECHA>='"&inicio&"' AND PAGO.FECHA<='"&termino&"' AND COBRADOR_CLIENTE.SUCURSAL = 'Arica' "
				set rsHR=Conn.execute(sql3)
				if not rsHR.eof then
					monto=rsHR("MONTO")
					gasto=rsHR("GASTO")
					cdedu1=rsHR("CDEUDORES")
				else
					monto=0
					gasto=0
					cdedu=0
				end if
				rsHR.close
				set rsR=Nothing
				cerrarscg()
				if isnull(monto) then
				monto=0
				end if
				if isNULL(gasto) then
				gasto=0
				end if
				if isNULL(cdedu) then
				cdedu1=0
				end if%>
	            <%
		total_capital_pago_s = clng(monto) + CLNG(total_capital_pago_s)
		total_monto_gasto_s = clng(gasto) + clng(total_monto_gasto_s)
		total_usuarios_s = clng(total_usuarios_s) + clng(cdedu1)
		%>
		$ <%=FN(monto,0)%>
</div></td>
		<td><div align="right">$ <%=FN(gasto,0)%></div></td>
		<td><div align="right"><%=FN(cdedu1,0)%></div></td>
	  </tr>
	  <tr>
		<td><a href="informe_cargando_consolidado_rt.asp?cliente=<%=cliente%>&sucursal=Iquique&inicio=<%=inicio%>&termino=<%=termino%>">IQUIQUE</a></td>
		<td><div align="right">
		      <%
			abrirscg()
			ssql="SELECT SUM(monto_activo) AS monto_activo,sum(rut_activo) AS DEU FROM COBRADOR_CLIENTE WHERE SUCURSAL='Iquique' AND codigo_cliente='"&cliente&"'"
			set rsA = Conn.execute(ssql)
			if not rsA.eof then
			monto_asignado_2 = rsA("monto_activo")
			ruts_activos_2  = rsA("DEU")
			else
			monto_asignado_2 = 0
			ruts_activos_2 = 0
			end if
			rsA.close
			set rsA = nothing
		cerrarscg()
		if not isnull(monto_asignado_2) then
		response.Write("$ ")
		response.Write(FN(monto_asignado_2,0))
		else
				monto_asignado_2 = 0
		response.Write("$ 0")
		end if

		if isnull(ruts_activos_2) then
		ruts_activos_2 = 0
		end if
%>
		  </div></td>
		<td><div align="right">
		  <%total_deudores_activo_s = total_deudores_activo_s +  ruts_activos_2%>
		  <%=ruts_activos_2%></div></td>
		<td><div align="right">
		  <div align="right">
            <%
 				monto=0
				gasto=0
				cdedu1=0
				abrirscg()
				sql3="SELECT SUM(PAGO_CUOTA.MONTOCAPITAL) AS MONTO,SUM(PAGO_CUOTA.UTILIDAD_EMPRESA) AS GASTO,COUNT(DISTINCT PAGO_CUOTA.RUTDEUDOR) AS CDEUDORES FROM PAGO_CUOTA,PAGO,COBRADOR_CLIENTE WHERE PAGO_CUOTA.CODPAGO = PAGO.CODIGO AND PAGO_CUOTA.COD_CLI='"&cliente&"' AND PAGO_CUOTA.CODCOBRADOR = COBRADOR_CLIENTE.LOGIN AND PAGO.FECHA>='"&inicio&"' AND PAGO.FECHA<='"&termino&"' AND COBRADOR_CLIENTE.SUCURSAL = 'Iquique' "
				set rsHR=Conn.execute(sql3)
				if not rsHR.eof then
					monto=rsHR("MONTO")
					gasto=rsHR("GASTO")
					cdedu1=rsHR("CDEUDORES")
				else
					monto=0
					gasto=0
					cdedu=0
				end if
				rsHR.close
				set rsR=Nothing
				cerrarscg()
				if isnull(monto) then
				monto=0
				end if
				if isNULL(gasto) then
				gasto=0
				end if
				if isNULL(cdedu) then
				cdedu1=0
				end if
		%>
                  <%
		total_capital_pago_s = clng(monto) + CLNG(total_capital_pago_s)
		total_monto_gasto_s = clng(gasto) + clng(total_monto_gasto_s)
		total_usuarios_s = clng(total_usuarios_s) + clng(cdedu1)
		%>
            $ <%=FN(monto,0)%></div>
		</div></td>
		<td><div align="right">$ <%=FN(gasto,0)%></div></td>
		<td><div align="right"><%=FN(cdedu1,0)%></div></td>
	  </tr>
	  <tr>
		<td><a href="informe_cargando_consolidado_rt.asp?cliente=<%=cliente%>&sucursal=Antofagasta&inicio=<%=inicio%>&termino=<%=termino%>">ANTOFAGASTA</a></td>
		<td><div align="right">
		      <%
			abrirscg()
			ssql="SELECT SUM(monto_activo) AS monto_activo,sum(rut_activo) AS DEU FROM COBRADOR_CLIENTE WHERE SUCURSAL='Antofagasta' AND codigo_cliente='"&cliente&"'"
			set rsA = Conn.execute(ssql)
			if not rsA.eof then
			monto_asignado_3 = rsA("monto_activo")
			ruts_activos_3  = rsA("DEU")
			else
			monto_asignado_3 = 0
			ruts_activos_3 = 0
			end if
			rsA.close
			set rsA = nothing
			cerrarscg()
		if not isnull(monto_asignado_3) then
		response.Write("$ ")
		response.Write(FN(monto_asignado_3,0))
		else
				monto_asignado_3 = 0
		response.Write("$ 0")
		end if

		if isnull(ruts_activos_3) then
		ruts_activos_3 = 0
		end if
%>
		  </div></td>
		<td><div align="right">
		  <%total_deudores_activo_s = total_deudores_activo_s +  ruts_activos_3%>
		  <%=ruts_activos_3%></div></td>
		<td><div align="right">
		  <div align="right">
            <%
 				monto=0
				gasto=0
				cdedu1=0
				abrirscg()
				sql3="SELECT SUM(PAGO_CUOTA.MONTOCAPITAL) AS MONTO,SUM(PAGO_CUOTA.UTILIDAD_EMPRESA) AS GASTO,COUNT(DISTINCT PAGO_CUOTA.RUTDEUDOR) AS CDEUDORES FROM PAGO_CUOTA,PAGO,COBRADOR_CLIENTE WHERE PAGO_CUOTA.CODPAGO = PAGO.CODIGO AND PAGO_CUOTA.COD_CLI='"&cliente&"' AND PAGO_CUOTA.CODCOBRADOR = COBRADOR_CLIENTE.LOGIN AND PAGO.FECHA>='"&inicio&"' AND PAGO.FECHA<='"&termino&"' AND COBRADOR_CLIENTE.SUCURSAL = 'Antofagasta' "
				set rsHR=Conn.execute(sql3)
				if not rsHR.eof then
					monto=rsHR("MONTO")
					gasto=rsHR("GASTO")
					cdedu1=rsHR("CDEUDORES")
				else
					monto=0
					gasto=0
					cdedu=0
				end if
				rsHR.close
				set rsR=Nothing
				cerrarscg()
				if isnull(monto) then
				monto=0
				end if
				if isNULL(gasto) then
				gasto=0
				end if
				if isNULL(cdedu) then
				cdedu1=0
				end if
		%>
                  <%
		total_capital_pago_s = clng(monto) + CLNG(total_capital_pago_s)
		total_monto_gasto_s = clng(gasto) + clng(total_monto_gasto_s)
		total_usuarios_s = clng(total_usuarios_s) + clng(cdedu1)
		%>
            $ <%=FN(monto,0)%></div>
		</div></td>
		<td><div align="right">$ <%=FN(gasto,0)%></div></td>
		<td><div align="right"><%=FN(cdedu1,0)%></div></td>
	  </tr>
	  <tr>
		<td><a href="informe_cargando_consolidado_rt.asp?cliente=<%=cliente%>&sucursal=Copiapo&inicio=<%=inicio%>&termino=<%=termino%>">COPIAPO</a></td>
		<td><div align="right">
		      <%
			abrirscg()
			ssql="SELECT SUM(monto_activo) AS monto_activo,sum(rut_activo) AS DEU FROM COBRADOR_CLIENTE WHERE SUCURSAL='Copiapo' AND codigo_cliente='"&cliente&"'"
			set rsA = Conn.execute(ssql)
			if not rsA.eof then
			monto_asignado_4 = rsA("monto_activo")
			ruts_activos_4  = rsA("DEU")
			else
			monto_asignado_4 = 0
			ruts_activos_4 = 0
			end if
			rsA.close
			set rsA = nothing
			cerrarscg()
		if not isnull(monto_asignado_4) then
		response.Write("$ ")
		response.Write(FN(monto_asignado_4,0))
		else
				monto_asignado_4 = 0
		response.Write("$ 0")
		end if

		if isnull(ruts_activos_4) then
		ruts_activos_4 = 0
		end if
%>
		  </div></td>
		<td><div align="right">
		  <%total_deudores_activo_s = total_deudores_activo_s +  ruts_activos_4%>
		  <%=ruts_activos_4%></div></td>
		<td><div align="right">
		  <div align="right">
            <%
 				monto=0
				gasto=0
				cdedu1=0
				abrirscg()
				sql3="SELECT SUM(PAGO_CUOTA.MONTOCAPITAL) AS MONTO,SUM(PAGO_CUOTA.UTILIDAD_EMPRESA) AS GASTO,COUNT(DISTINCT PAGO_CUOTA.RUTDEUDOR) AS CDEUDORES FROM PAGO_CUOTA,PAGO,COBRADOR_CLIENTE WHERE PAGO_CUOTA.CODPAGO = PAGO.CODIGO AND PAGO_CUOTA.COD_CLI='"&cliente&"' AND PAGO_CUOTA.CODCOBRADOR = COBRADOR_CLIENTE.LOGIN AND PAGO.FECHA>='"&inicio&"' AND PAGO.FECHA<='"&termino&"' AND COBRADOR_CLIENTE.SUCURSAL = 'Copiapo' "
				set rsHR=Conn.execute(sql3)
				if not rsHR.eof then
					monto=rsHR("MONTO")
					gasto=rsHR("GASTO")
					cdedu1=rsHR("CDEUDORES")
				else
					monto=0
					gasto=0
					cdedu=0
				end if
				rsHR.close
				set rsR=Nothing
				cerrarscg()
				if isnull(monto) then
				monto=0
				end if
				if isNULL(gasto) then
				gasto=0
				end if
				if isNULL(cdedu) then
				cdedu1=0
				end if
		%>
                  <%
		total_capital_pago_s = clng(monto) + CLNG(total_capital_pago_s)
		total_monto_gasto_s = clng(gasto) + clng(total_monto_gasto_s)
		total_usuarios_s = clng(total_usuarios_s) + clng(cdedu1)
		%>
            $ <%=FN(monto,0)%></div>
		</div></td>
		<td><div align="right">$ <%=FN(gasto,0)%></div></td>
		<td><div align="right"><%=FN(cdedu1,0)%></div></td>
	  </tr>
	  <tr>
		<td><a href="informe_cargando_consolidado_rt.asp?cliente=<%=cliente%>&sucursal=La%20Serena&inicio=<%=inicio%>&termino=<%=termino%>">LA SERENA </a></td>
		<td><div align="right">
		      <%
			abrirscg()
			ssql="SELECT SUM(monto_activo) AS monto_activo,sum(rut_activo) AS DEU FROM COBRADOR_CLIENTE WHERE SUCURSAL='La Serena' AND codigo_cliente='"&cliente&"'"
			set rsA = Conn.execute(ssql)
			if not rsA.eof then
			monto_asignado_5 = rsA("monto_activo")
			ruts_activos_5  = rsA("DEU")
			else
			monto_asignado_5 = 0
			ruts_activos_5 = 0
			end if
			rsA.close
			set rsA = nothing
			cerrarscg()
		if not isnull(monto_asignado_5) then
		response.Write("$ ")
		response.Write(FN(monto_asignado_5,0))
		else
				monto_asignado_5 = 0
		response.Write("$ 0")
		end if

		if isnull(ruts_activos_5) then
		ruts_activos_5 = 0
		end if
%>
		  </div></td>
		<td><div align="right">
		  <%total_deudores_activo_s = total_deudores_activo_s +  ruts_activos_5%>
		  <%=ruts_activos_5%></div></td>
		<td><div align="right">
		  <div align="right">
            <%
 				monto=0
				gasto=0
				cdedu1=0
				abrirscg()
				sql3="SELECT SUM(PAGO_CUOTA.MONTOCAPITAL) AS MONTO,SUM(PAGO_CUOTA.UTILIDAD_EMPRESA) AS GASTO,COUNT(DISTINCT PAGO_CUOTA.RUTDEUDOR) AS CDEUDORES FROM PAGO_CUOTA,PAGO,COBRADOR_CLIENTE WHERE PAGO_CUOTA.CODPAGO = PAGO.CODIGO AND PAGO_CUOTA.COD_CLI='"&cliente&"' AND PAGO_CUOTA.CODCOBRADOR = COBRADOR_CLIENTE.LOGIN AND PAGO.FECHA>='"&inicio&"' AND PAGO.FECHA<='"&termino&"' AND COBRADOR_CLIENTE.SUCURSAL = 'La Serena' "
				set rsHR=Conn.execute(sql3)
				if not rsHR.eof then
					monto=rsHR("MONTO")
					gasto=rsHR("GASTO")
					cdedu1=rsHR("CDEUDORES")
				else
					monto=0
					gasto=0
					cdedu=0
				end if
				rsHR.close
				set rsR=Nothing
				cerrarscg()
				if isnull(monto) then
				monto=0
				end if
				if isNULL(gasto) then
				gasto=0
				end if
				if isNULL(cdedu) then
				cdedu1=0
				end if
		%>
                  <%
		total_capital_pago_s = clng(monto) + CLNG(total_capital_pago_s)
		total_monto_gasto_s = clng(gasto) + clng(total_monto_gasto_s)
		total_usuarios_s = clng(total_usuarios_s) + clng(cdedu1)
		%>
            $ <%=FN(monto,0)%></div>
		</div></td>
		<td><div align="right">$ <%=FN(gasto,0)%></div></td>
		<td><div align="right"><%=FN(cdedu1,0)%></div></td>
	  </tr>
	  <tr>
		<td><a href="informe_cargando_consolidado_rt.asp?cliente=<%=cliente%>&sucursal=Valparaiso&inicio=<%=inicio%>&termino=<%=termino%>">VALPARAISO</a></td>
		<td><div align="right">
		      <%
			abrirscg()
			ssql="SELECT SUM(monto_activo) AS monto_activo,sum(rut_activo) AS DEU FROM COBRADOR_CLIENTE WHERE SUCURSAL='Valparaiso' AND codigo_cliente='"&cliente&"'"
			set rsA = Conn.execute(ssql)
			if not rsA.eof then
			monto_asignado_6 = rsA("monto_activo")
			ruts_activos_6  = rsA("DEU")
			else
			monto_asignado_6 = 0
			ruts_activos_6 = 0
			end if
			rsA.close
			set rsA = nothing
			cerrarscg()
		if not isnull(monto_asignado_6) then
		response.Write("$ ")
		response.Write(FN(monto_asignado_6,0))
		else
				monto_asignado_6 = 0
		response.Write("$ 0")
		end if

		if isnull(ruts_activos_6) then
		ruts_activos_6 = 0
		end if
%>
		  </div></td>
		<td><div align="right">
		  <%total_deudores_activo_s = total_deudores_activo_s +  ruts_activos_6%>
		  <%=ruts_activos_6%></div></td>
		<td><div align="right">
		  <div align="right">
            <%
 				monto=0
				gasto=0
				cdedu1=0
				abrirscg()
				sql3="SELECT SUM(PAGO_CUOTA.MONTOCAPITAL) AS MONTO,SUM(PAGO_CUOTA.UTILIDAD_EMPRESA) AS GASTO,COUNT(DISTINCT PAGO_CUOTA.RUTDEUDOR) AS CDEUDORES FROM PAGO_CUOTA,PAGO,COBRADOR_CLIENTE WHERE PAGO_CUOTA.CODPAGO = PAGO.CODIGO AND PAGO_CUOTA.COD_CLI='"&cliente&"' AND PAGO_CUOTA.CODCOBRADOR = COBRADOR_CLIENTE.LOGIN AND PAGO.FECHA>='"&inicio&"' AND PAGO.FECHA<='"&termino&"' AND COBRADOR_CLIENTE.SUCURSAL = 'Valparaiso' "
				set rsHR=Conn.execute(sql3)
				if not rsHR.eof then
					monto=rsHR("MONTO")
					gasto=rsHR("GASTO")
					cdedu1=rsHR("CDEUDORES")
				else
					monto=0
					gasto=0
					cdedu=0
				end if
				rsHR.close
				set rsR=Nothing
				cerrarscg()
				if isnull(monto) then
				monto=0
				end if
				if isNULL(gasto) then
				gasto=0
				end if
				if isNULL(cdedu) then
				cdedu1=0
				end if
		%>
                  <%
		total_capital_pago_s = clng(monto) + CLNG(total_capital_pago_s)
		total_monto_gasto_s = clng(gasto) + clng(total_monto_gasto_s)
		total_usuarios_s = clng(total_usuarios_s) + clng(cdedu1)
		%>
            $ <%=FN(monto,0)%></div>
		</div></td>
		<td><div align="right">$ <%=FN(gasto,0)%></div></td>
		<td><div align="right"><%=FN(cdedu1,0)%></div></td>
	  </tr>
	  <tr>
		<td><a href="informe_cargando_consolidado_rt.asp?cliente=<%=cliente%>&sucursal=Santiago&inicio=<%=inicio%>&termino=<%=termino%>">SANTIAGO</a></td>
		<td><div align="right">
		      <%
			abrirscg()
			ssql="SELECT SUM(monto_activo) AS monto_activo,sum(rut_activo) AS DEU FROM COBRADOR_CLIENTE WHERE SUCURSAL='Santiago' AND codigo_cliente='"&cliente&"'"
			set rsA = Conn.execute(ssql)
			if not rsA.eof then
			monto_asignado_7 = rsA("monto_activo")
			ruts_activos_7  = rsA("DEU")
			else
			monto_asignado_7 = 0
			ruts_activos_7 = 0
			end if
			rsA.close
			set rsA = nothing
			cerrarscg()
		if not isnull(monto_asignado_7) then
		response.Write("$ ")
		response.Write(FN(monto_asignado_7,0))
		else
				monto_asignado_7 = 0
		response.Write("$ 0")
		end if

		if isnull(ruts_activos_7) then
		ruts_activos_7 = 0
		end if
%>
		  </div></td>
		<td><div align="right">
		  <%total_deudores_activo_s = total_deudores_activo_s +  ruts_activos_7%>
		  <%=ruts_activos_7%></div></td>
		<td><div align="right">
		  <div align="right">
            <%
 				monto=0
				gasto=0
				cdedu1=0
				abrirscg()
				sql3="SELECT SUM(PAGO_CUOTA.MONTOCAPITAL) AS MONTO,SUM(PAGO_CUOTA.UTILIDAD_EMPRESA) AS GASTO,COUNT(DISTINCT PAGO_CUOTA.RUTDEUDOR) AS CDEUDORES FROM PAGO_CUOTA,PAGO,COBRADOR_CLIENTE WHERE PAGO_CUOTA.CODPAGO = PAGO.CODIGO AND PAGO_CUOTA.COD_CLI='"&cliente&"' AND PAGO_CUOTA.CODCOBRADOR = COBRADOR_CLIENTE.LOGIN AND PAGO.FECHA>='"&inicio&"' AND PAGO.FECHA<='"&termino&"' AND COBRADOR_CLIENTE.SUCURSAL = 'Santiago' "
				set rsHR=Conn.execute(sql3)
				if not rsHR.eof then
					monto=rsHR("MONTO")
					gasto=rsHR("GASTO")
					cdedu1=rsHR("CDEUDORES")
				else
					monto=0
					gasto=0
					cdedu=0
				end if
				rsHR.close
				set rsR=Nothing
				cerrarscg()
				if isnull(monto) then
				monto=0
				end if
				if isNULL(gasto) then
				gasto=0
				end if
				if isNULL(cdedu) then
				cdedu1=0
				end if
		%>
                  <%
		total_capital_pago_s = clng(monto) + CLNG(total_capital_pago_s)
		total_monto_gasto_s = clng(gasto) + clng(total_monto_gasto_s)
		total_usuarios_s = clng(total_usuarios_s) + clng(cdedu1)
		%>
            $ <%=FN(monto,0)%></div>
		</div></td>
		<td><div align="right">$ <%=FN(gasto,0)%></div></td>
		<td><div align="right"><%=FN(cdedu1,0)%></div></td>
	  </tr>
	  <tr>
		<td><a href="informe_cargando_consolidado_rt.asp?cliente=<%=cliente%>&sucursal=Rancagua&inicio=<%=inicio%>&termino=<%=termino%>">RANCAGUA</a></td>
		<td><div align="right">
		      <%
			abrirscg()
			ssql="SELECT SUM(monto_activo) AS monto_activo,sum(rut_activo) AS DEU FROM COBRADOR_CLIENTE WHERE SUCURSAL='Rancagua' AND codigo_cliente='"&cliente&"'"
			set rsA = Conn.execute(ssql)
			if not rsA.eof then
			monto_asignado_8 = rsA("monto_activo")
			ruts_activos_8  = rsA("DEU")
			else
			monto_asignado_8 = 0
			ruts_activos_8 = 0
			end if
			rsA.close
			set rsA = nothing
			cerrarscg()
		if not isnull(monto_asignado_8) then
		response.Write("$ ")
		response.Write(FN(monto_asignado_8,0))
		else
				monto_asignado_8 = 0
		response.Write("$ 0")
		end if

		if isnull(ruts_activos_8) then
		ruts_activos_8 = 0
		end if
%>
		  </div></td>
		<td><div align="right">
		  <%total_deudores_activo_s = total_deudores_activo_s +  ruts_activos_8%>
		  <%=ruts_activos_8%></div></td>
		<td><div align="right">
		  <div align="right">
            <%
 				monto=0
				gasto=0
				cdedu1=0
				abrirscg()
				sql3="SELECT SUM(PAGO_CUOTA.MONTOCAPITAL) AS MONTO,SUM(PAGO_CUOTA.UTILIDAD_EMPRESA) AS GASTO,COUNT(DISTINCT PAGO_CUOTA.RUTDEUDOR) AS CDEUDORES FROM PAGO_CUOTA,PAGO,COBRADOR_CLIENTE WHERE PAGO_CUOTA.CODPAGO = PAGO.CODIGO AND PAGO_CUOTA.COD_CLI='"&cliente&"' AND PAGO_CUOTA.CODCOBRADOR = COBRADOR_CLIENTE.LOGIN AND PAGO.FECHA>='"&inicio&"' AND PAGO.FECHA<='"&termino&"' AND COBRADOR_CLIENTE.SUCURSAL = 'Rancagua' "
				set rsHR=Conn.execute(sql3)
				if not rsHR.eof then
					monto=rsHR("MONTO")
					gasto=rsHR("GASTO")
					cdedu1=rsHR("CDEUDORES")
				else
					monto=0
					gasto=0
					cdedu=0
				end if
				rsHR.close
				set rsR=Nothing
				cerrarscg()
				if isnull(monto) then
				monto=0
				end if
				if isNULL(gasto) then
				gasto=0
				end if
				if isNULL(cdedu) then
				cdedu1=0
				end if
		%>
                  <%
		total_capital_pago_s = clng(monto) + CLNG(total_capital_pago_s)
		total_monto_gasto_s = clng(gasto) + clng(total_monto_gasto_s)
		total_usuarios_s = clng(total_usuarios_s) + clng(cdedu1)
		%>
            $ <%=FN(monto,0)%></div>
		</div></td>
		<td><div align="right">$ <%=FN(gasto,0)%></div></td>
		<td><div align="right"><%=FN(cdedu1,0)%></div></td>
	  </tr>
	  <tr>
		<td><a href="informe_cargando_consolidado_rt.asp?cliente=<%=cliente%>&sucursal=Talca&inicio=<%=inicio%>&termino=<%=termino%>">TALCA</a></td>
		<td><div align="right">
		      <%
			abrirscg()
			ssql="SELECT SUM(monto_activo) AS monto_activo,sum(rut_activo) AS DEU FROM COBRADOR_CLIENTE WHERE SUCURSAL='Talca' AND codigo_cliente='"&cliente&"'"
			set rsA = Conn.execute(ssql)
			if not rsA.eof then
			monto_asignado_9 = rsA("monto_activo")
			ruts_activos_9  = rsA("DEU")
			else
			monto_asignado_9 = 0
			ruts_activos_9 = 0
			end if
			rsA.close
			set rsA = nothing
			cerrarscg()
		if not isnull(monto_asignado_9) then
		response.Write("$ ")
		response.Write(FN(monto_asignado_9,0))
		else
				monto_asignado_9 = 0
		response.Write("$ 0")
		end if

		if isnull(ruts_activos_9) then
		ruts_activos_9 = 0
		end if
%>
		  </div></td>
		<td><div align="right">
		  <%total_deudores_activo_s = total_deudores_activo_s +  ruts_activos_9%>
		  <%=ruts_activos_9%></div></td>
		<td><div align="right">
		  <div align="right">
            <%
 				monto=0
				gasto=0
				cdedu1=0
				abrirscg()
				sql3="SELECT SUM(PAGO_CUOTA.MONTOCAPITAL) AS MONTO,SUM(PAGO_CUOTA.UTILIDAD_EMPRESA) AS GASTO,COUNT(DISTINCT PAGO_CUOTA.RUTDEUDOR) AS CDEUDORES FROM PAGO_CUOTA,PAGO,COBRADOR_CLIENTE WHERE PAGO_CUOTA.CODPAGO = PAGO.CODIGO AND PAGO_CUOTA.COD_CLI='"&cliente&"' AND PAGO_CUOTA.CODCOBRADOR = COBRADOR_CLIENTE.LOGIN AND PAGO.FECHA>='"&inicio&"' AND PAGO.FECHA<='"&termino&"' AND COBRADOR_CLIENTE.SUCURSAL = 'Talca' "
				set rsHR=Conn.execute(sql3)
				if not rsHR.eof then
					monto=rsHR("MONTO")
					gasto=rsHR("GASTO")
					cdedu1=rsHR("CDEUDORES")
				else
					monto=0
					gasto=0
					cdedu=0
				end if
				rsHR.close
				set rsR=Nothing
				cerrarscg()
				if isnull(monto) then
				monto=0
				end if
				if isNULL(gasto) then
				gasto=0
				end if
				if isNULL(cdedu) then
				cdedu1=0
				end if
		%>
                  <%
		total_capital_pago_s = clng(monto) + CLNG(total_capital_pago_s)
		total_monto_gasto_s = clng(gasto) + clng(total_monto_gasto_s)
		total_usuarios_s = clng(total_usuarios_s) + clng(cdedu1)
		%>
            $ <%=FN(monto,0)%></div>
		</div></td>
		<td><div align="right">$ <%=FN(gasto,0)%></div></td>
		<td><div align="right"><%=FN(cdedu1,0)%></div></td>
	  </tr>
	  <tr>
		<td><a href="informe_cargando_consolidado_rt.asp?cliente=<%=cliente%>&sucursal=Concepcion&inicio=<%=inicio%>&termino=<%=termino%>">CONCEPCION</a></td>
		<td><div align="right">
		      <%
			abrirscg()
			ssql="SELECT SUM(monto_activo) AS monto_activo,sum(rut_activo) AS DEU FROM COBRADOR_CLIENTE WHERE SUCURSAL='Concepcion' AND codigo_cliente='"&cliente&"'"
			set rsA = Conn.execute(ssql)
			if not rsA.eof then
			monto_asignado_10 = rsA("monto_activo")
			ruts_activos_10  = rsA("DEU")
			else
			monto_asignado_10 = 0
			ruts_activos_10 = 0
			end if
			rsA.close
			set rsA = nothing
			cerrarscg()
		if not isnull(monto_asignado_10) then
		response.Write("$ ")
		response.Write(FN(monto_asignado_10,0))
		else
				monto_asignado_10 = 0
		response.Write("$ 0")
		end if

		if isnull(ruts_activos_10) then
		ruts_activos_10 = 0
		end if
%>
		  </div></td>
		<td><div align="right">
		  <%total_deudores_activo_s = total_deudores_activo_s +  ruts_activos_10%>
		  <%=ruts_activos_10%></div></td>
		<td><div align="right">
		  <div align="right">
            <%
 				monto=0
				gasto=0
				cdedu1=0
				abrirscg()
				sql3="SELECT SUM(PAGO_CUOTA.MONTOCAPITAL) AS MONTO,SUM(PAGO_CUOTA.UTILIDAD_EMPRESA) AS GASTO,COUNT(DISTINCT PAGO_CUOTA.RUTDEUDOR) AS CDEUDORES FROM PAGO_CUOTA,PAGO,COBRADOR_CLIENTE WHERE PAGO_CUOTA.CODPAGO = PAGO.CODIGO AND PAGO_CUOTA.COD_CLI='"&cliente&"' AND PAGO_CUOTA.CODCOBRADOR = COBRADOR_CLIENTE.LOGIN AND PAGO.FECHA>='"&inicio&"' AND PAGO.FECHA<='"&termino&"' AND COBRADOR_CLIENTE.SUCURSAL = 'Concepcion' "
				set rsHR=Conn.execute(sql3)
				if not rsHR.eof then
					monto=rsHR("MONTO")
					gasto=rsHR("GASTO")
					cdedu1=rsHR("CDEUDORES")
				else
					monto=0
					gasto=0
					cdedu=0
				end if
				rsHR.close
				set rsR=Nothing
				cerrarscg()
				if isnull(monto) then
				monto=0
				end if
				if isNULL(gasto) then
				gasto=0
				end if
				if isNULL(cdedu) then
				cdedu1=0
				end if
		%>
                  <%
		total_capital_pago_s = clng(monto) + CLNG(total_capital_pago_s)
		total_monto_gasto_s = clng(gasto) + clng(total_monto_gasto_s)
		total_usuarios_s = clng(total_usuarios_s) + clng(cdedu1)
		%>
            $ <%=FN(monto,0)%></div>
		</div></td>
		<td><div align="right">$ <%=FN(gasto,0)%></div></td>
		<td><div align="right"><%=FN(cdedu1,0)%></div></td>
	  </tr>
	  <tr>
		<td><a href="informe_cargando_consolidado_rt.asp?cliente=<%=cliente%>&sucursal=Temuco&inicio=<%=inicio%>&termino=<%=termino%>">TEMUCO</a></td>
		<td><div align="right">
		      <%
			abrirscg()
			ssql="SELECT SUM(monto_activo) AS monto_activo,sum(rut_activo) AS DEU FROM COBRADOR_CLIENTE WHERE SUCURSAL='Temuco' AND codigo_cliente='"&cliente&"'"
			set rsA = Conn.execute(ssql)
			if not rsA.eof then
			monto_asignado_11 = rsA("monto_activo")
			ruts_activos_11  = rsA("DEU")
			else
			monto_asignado_11 = 0
			ruts_activos_11 = 0
			end if
			rsA.close
			set rsA = nothing
			cerrarscg()
		if not isnull(monto_asignado_11) then
		response.Write("$ ")
		response.Write(FN(monto_asignado_11,0))
		else
				monto_asignado_11 = 0
		response.Write("$ 0")
		end if

		if isnull(ruts_activos_11) then
		ruts_activos_11 = 0
		end if
%>
		  </div></td>
		<td><div align="right">
		  <%total_deudores_activo_s = total_deudores_activo_s +  ruts_activos_11%>
		  <%=ruts_activos_11%></div></td>
		<td><div align="right">
		  <div align="right">
            <%
 				monto=0
				gasto=0
				cdedu1=0
				abrirscg()
				sql3="SELECT SUM(PAGO_CUOTA.MONTOCAPITAL) AS MONTO,SUM(PAGO_CUOTA.UTILIDAD_EMPRESA) AS GASTO,COUNT(DISTINCT PAGO_CUOTA.RUTDEUDOR) AS CDEUDORES FROM PAGO_CUOTA,PAGO,COBRADOR_CLIENTE WHERE PAGO_CUOTA.CODPAGO = PAGO.CODIGO AND PAGO_CUOTA.COD_CLI='"&cliente&"' AND PAGO_CUOTA.CODCOBRADOR = COBRADOR_CLIENTE.LOGIN AND PAGO.FECHA>='"&inicio&"' AND PAGO.FECHA<='"&termino&"' AND COBRADOR_CLIENTE.SUCURSAL = 'Temuco' "
				set rsHR=Conn.execute(sql3)
				if not rsHR.eof then
					monto=rsHR("MONTO")
					gasto=rsHR("GASTO")
					cdedu1=rsHR("CDEUDORES")
				else
					monto=0
					gasto=0
					cdedu=0
				end if
				rsHR.close
				set rsR=Nothing
				cerrarscg()
				if isnull(monto) then
				monto=0
				end if
				if isNULL(gasto) then
				gasto=0
				end if
				if isNULL(cdedu) then
				cdedu1=0
				end if
		%>
                  <%
		total_capital_pago_s = clng(monto) + CLNG(total_capital_pago_s)
		total_monto_gasto_s = clng(gasto) + clng(total_monto_gasto_s)
		total_usuarios_s = clng(total_usuarios_s) + clng(cdedu1)
		%>
            $ <%=FN(monto,0)%></div>
		</div></td>
		<td><div align="right">$ <%=FN(gasto,0)%></div></td>
		<td><div align="right"><%=FN(cdedu1,0)%></div></td>
	  </tr>
	  <tr>
		<td><a href="informe_cargando_consolidado_rt.asp?cliente=<%=cliente%>&sucursal=Valdivia&inicio=<%=inicio%>&termino=<%=termino%>">VALDIVIA</a></td>
		<td><div align="right">
		      <%
			abrirscg()
			ssql="SELECT SUM(monto_activo) AS monto_activo,sum(rut_activo) AS DEU FROM COBRADOR_CLIENTE WHERE SUCURSAL='Valdivia' AND codigo_cliente='"&cliente&"'"
			set rsA = Conn.execute(ssql)
			if not rsA.eof then
			monto_asignado_12 = rsA("monto_activo")
			ruts_activos_12  = rsA("DEU")
			else
			monto_asignado_12 = 0
			ruts_activos_12 = 0
			end if
			rsA.close
			set rsA = nothing
			cerrarscg()
		if not isnull(monto_asignado_12) then
		response.Write("$ ")
		response.Write(FN(monto_asignado_12,0))
		else
				monto_asignado_12 = 0
		response.Write("$ 0")
		end if

		if isnull(ruts_activos_12) then
		ruts_activos_12 = 0
		end if
%>
		  </div></td>
		<td><div align="right">
		  <%total_deudores_activo_s = total_deudores_activo_s +  ruts_activos_12%>
		  <%=ruts_activos_12%></div></td>
		<td><div align="right">
		  <div align="right">
            <%
 				monto=0
				gasto=0
				cdedu1=0
				abrirscg()
				sql3="SELECT SUM(PAGO_CUOTA.MONTOCAPITAL) AS MONTO,SUM(PAGO_CUOTA.UTILIDAD_EMPRESA) AS GASTO,COUNT(DISTINCT PAGO_CUOTA.RUTDEUDOR) AS CDEUDORES FROM PAGO_CUOTA,PAGO,COBRADOR_CLIENTE WHERE PAGO_CUOTA.CODPAGO = PAGO.CODIGO AND PAGO_CUOTA.COD_CLI='"&cliente&"' AND PAGO_CUOTA.CODCOBRADOR = COBRADOR_CLIENTE.LOGIN AND PAGO.FECHA>='"&inicio&"' AND PAGO.FECHA<='"&termino&"' AND COBRADOR_CLIENTE.SUCURSAL = 'Valdivia' "
				set rsHR=Conn.execute(sql3)
				if not rsHR.eof then
					monto=rsHR("MONTO")
					gasto=rsHR("GASTO")
					cdedu1=rsHR("CDEUDORES")
				else
					monto=0
					gasto=0
					cdedu=0
				end if
				rsHR.close
				set rsR=Nothing
				cerrarscg()
				if isnull(monto) then
				monto=0
				end if
				if isNULL(gasto) then
				gasto=0
				end if
				if isNULL(cdedu) then
				cdedu1=0
				end if
		%>
                  <%
		total_capital_pago_s = clng(monto) + CLNG(total_capital_pago_s)
		total_monto_gasto_s = clng(gasto) + clng(total_monto_gasto_s)
		total_usuarios_s = clng(total_usuarios_s) + clng(cdedu1)
		%>
            $ <%=FN(monto,0)%></div>
		</div></td>
		<td><div align="right">$ <%=FN(gasto,0)%></div></td>
		<td><div align="right"><%=FN(cdedu1,0)%></div></td>
	  </tr>
	  <tr>
		<td><a href="informe_cargando_consolidado_rt.asp?cliente=<%=cliente%>&sucursal=Osorno&inicio=<%=inicio%>&termino=<%=termino%>">OSORNO</a></td>
		<td><div align="right">
		      <%
			abrirscg()
			ssql="SELECT SUM(monto_activo) AS monto_activo,sum(rut_activo) AS DEU FROM COBRADOR_CLIENTE WHERE SUCURSAL='Osorno' AND codigo_cliente='"&cliente&"'"
			set rsA = Conn.execute(ssql)
			if not rsA.eof then
			monto_asignado_13 = rsA("monto_activo")
			ruts_activos_13  = rsA("DEU")
			else
			monto_asignado_13 = 0
			ruts_activos_13 = 0
			end if
			rsA.close
			set rsA = nothing
			cerrarscg()
		if not isnull(monto_asignado_13) then
		response.Write("$ ")
		response.Write(FN(monto_asignado_13,0))
		else
				monto_asignado_13 = 0
		response.Write("$ 0")
		end if

		if isnull(ruts_activos_13) then
		ruts_activos_13 = 0
		end if
%>
		  </div></td>
		<td><div align="right">
		  <%total_deudores_activo_s = total_deudores_activo_s +  ruts_activos_13%>
		  <%=ruts_activos_13%></div></td>
		<td><div align="right">
		  <div align="right">
            <%
 				monto=0
				gasto=0
				cdedu1=0
				abrirscg()
				sql3="SELECT SUM(PAGO_CUOTA.MONTOCAPITAL) AS MONTO,SUM(PAGO_CUOTA.UTILIDAD_EMPRESA) AS GASTO,COUNT(DISTINCT PAGO_CUOTA.RUTDEUDOR) AS CDEUDORES FROM PAGO_CUOTA,PAGO,COBRADOR_CLIENTE WHERE PAGO_CUOTA.CODPAGO = PAGO.CODIGO AND PAGO_CUOTA.COD_CLI='"&cliente&"' AND PAGO_CUOTA.CODCOBRADOR = COBRADOR_CLIENTE.LOGIN AND PAGO.FECHA>='"&inicio&"' AND PAGO.FECHA<='"&termino&"' AND COBRADOR_CLIENTE.SUCURSAL = 'Osorno' "
				set rsHR=Conn.execute(sql3)
				if not rsHR.eof then
					monto=rsHR("MONTO")
					gasto=rsHR("GASTO")
					cdedu1=rsHR("CDEUDORES")
				else
					monto=0
					gasto=0
					cdedu=0
				end if
				rsHR.close
				set rsR=Nothing
				cerrarscg()
				if isnull(monto) then
				monto=0
				end if
				if isNULL(gasto) then
				gasto=0
				end if
				if isNULL(cdedu) then
				cdedu1=0
				end if
		%>
                  <%
		total_capital_pago_s = clng(monto) + CLNG(total_capital_pago_s)
		total_monto_gasto_s = clng(gasto) + clng(total_monto_gasto_s)
		total_usuarios_s = clng(total_usuarios_s) + clng(cdedu1)
		%>
            $ <%=FN(monto,0)%></div>
		</div></td>
		<td><div align="right">$ <%=FN(gasto,0)%></div></td>
		<td><div align="right"><%=FN(cdedu1,0)%></div></td>
	  </tr>
	  <tr>
		<td><a href="informe_cargando_consolidado_rt.asp?cliente=<%=cliente%>&sucursal=Puerto%20Montt&inicio=<%=inicio%>&termino=<%=termino%>">PUERTO MONTT </a></td>
		<td><div align="right">
		      <%
			abrirscg()
			ssql="SELECT SUM(monto_activo) AS monto_activo,sum(rut_activo) AS DEU FROM COBRADOR_CLIENTE WHERE SUCURSAL='Puerto Montt' AND codigo_cliente='"&cliente&"'"
			set rsA = Conn.execute(ssql)
			if not rsA.eof then
			monto_asignado_14 = rsA("monto_activo")
			ruts_activos_14  = rsA("DEU")
			else
			monto_asignado_14 = 0
			ruts_activos_14 = 0
			end if
			rsA.close
			set rsA = nothing
			cerrarscg()
		if not isnull(monto_asignado_14) then
		response.Write("$ ")
		response.Write(FN(monto_asignado_14,0))
		else
				monto_asignado_14 = 0
		response.Write("$ 0")
		end if

		if isnull(ruts_activos_14) then
		ruts_activos_14 = 0
		end if
%>
		  </div></td>
		<td><div align="right">
		  <%total_deudores_activo_s = total_deudores_activo_s +  ruts_activos_14%>
		  <%=ruts_activos_14%></div></td>
		<td><div align="right">
		  <div align="right">
            <%
 				monto=0
				gasto=0
				cdedu1=0
				abrirscg()
				sql3="SELECT SUM(PAGO_CUOTA.MONTOCAPITAL) AS MONTO,SUM(PAGO_CUOTA.UTILIDAD_EMPRESA) AS GASTO,COUNT(DISTINCT PAGO_CUOTA.RUTDEUDOR) AS CDEUDORES FROM PAGO_CUOTA,PAGO,COBRADOR_CLIENTE WHERE PAGO_CUOTA.CODPAGO = PAGO.CODIGO AND PAGO_CUOTA.COD_CLI='"&cliente&"' AND PAGO_CUOTA.CODCOBRADOR = COBRADOR_CLIENTE.LOGIN AND PAGO.FECHA>='"&inicio&"' AND PAGO.FECHA<='"&termino&"' AND COBRADOR_CLIENTE.SUCURSAL = 'Puerto Montt' "
				set rsHR=Conn.execute(sql3)
				if not rsHR.eof then
					monto=rsHR("MONTO")
					gasto=rsHR("GASTO")
					cdedu1=rsHR("CDEUDORES")
				else
					monto=0
					gasto=0
					cdedu=0
				end if
				rsHR.close
				set rsR=Nothing
				cerrarscg()
				if isnull(monto) then
				monto=0
				end if
				if isNULL(gasto) then
				gasto=0
				end if
				if isNULL(cdedu) then
				cdedu1=0
				end if
		%>
                  <%
		total_capital_pago_s = clng(monto) + CLNG(total_capital_pago_s)
		total_monto_gasto_s = clng(gasto) + clng(total_monto_gasto_s)
		total_usuarios_s = clng(total_usuarios_s) + clng(cdedu1)
		%>
            $ <%=FN(monto,0)%></div>
		</div></td>
		<td><div align="right">$ <%=FN(gasto,0)%></div></td>
		<td><div align="right"><%=FN(cdedu1,0)%></div></td>
	  </tr>
	  <tr>
		<td><a href="informe_cargando_consolidado_rt.asp?cliente=<%=cliente%>&sucursal=Coyhaique&inicio=<%=inicio%>&termino=<%=termino%>">COYHAIQUE</a></td>
		<td><div align="right">
		      <%
			abrirscg()
			ssql="SELECT SUM(monto_activo) AS monto_activo,sum(rut_activo) AS DEU FROM COBRADOR_CLIENTE WHERE SUCURSAL='Coyhaique' AND codigo_cliente='"&cliente&"'"
			set rsA = Conn.execute(ssql)
			if not rsA.eof then
			monto_asignado_15 = rsA("monto_activo")
			ruts_activos_15  = rsA("DEU")
			else
			monto_asignado_15 = 0
			ruts_activos_15 = 0
			end if
			rsA.close
			set rsA = nothing
			cerrarscg()
		if not isnull(monto_asignado_15) then
		response.Write("$ ")
		response.Write(FN(monto_asignado_15,0))
		else
				monto_asignado_15 = 0
		response.Write("$ 0")
		end if

		if isnull(ruts_activos_15) then
		ruts_activos_15 = 0
		end if
%>
		  </div></td>
		<td><div align="right">
		  <%total_deudores_activo_s = total_deudores_activo_s +  ruts_activos_15%>
		  <%=ruts_activos_15%></div></td>
		<td><div align="right">
		  <div align="right">
            <%
 				monto=0
				gasto=0
				cdedu1=0
				abrirscg()
				sql3="SELECT SUM(PAGO_CUOTA.MONTOCAPITAL) AS MONTO,SUM(PAGO_CUOTA.UTILIDAD_EMPRESA) AS GASTO,COUNT(DISTINCT PAGO_CUOTA.RUTDEUDOR) AS CDEUDORES FROM PAGO_CUOTA,PAGO,COBRADOR_CLIENTE WHERE PAGO_CUOTA.CODPAGO = PAGO.CODIGO AND PAGO_CUOTA.COD_CLI='"&cliente&"' AND PAGO_CUOTA.CODCOBRADOR = COBRADOR_CLIENTE.LOGIN AND PAGO.FECHA>='"&inicio&"' AND PAGO.FECHA<='"&termino&"' AND COBRADOR_CLIENTE.SUCURSAL = 'Coyhaique' "
				set rsHR=Conn.execute(sql3)
				if not rsHR.eof then
					monto=rsHR("MONTO")
					gasto=rsHR("GASTO")
					cdedu1=rsHR("CDEUDORES")
				else
					monto=0
					gasto=0
					cdedu=0
				end if
				rsHR.close
				set rsR=Nothing
				cerrarscg()
				if isnull(monto) then
				monto=0
				end if
				if isNULL(gasto) then
				gasto=0
				end if
				if isNULL(cdedu) then
				cdedu1=0
				end if
		%>
                  <%
		total_capital_pago_s = clng(monto) + CLNG(total_capital_pago_s)
		total_monto_gasto_s = clng(gasto) + clng(total_monto_gasto_s)
		total_usuarios_s = clng(total_usuarios_s) + clng(cdedu1)
		%>
            $ <%=FN(monto,0)%></div>
		</div></td>
		<td><div align="right">$ <%=FN(gasto,0)%></div></td>
		<td><div align="right"><%=FN(cdedu1,0)%></div></td>
	  </tr>
	  <tr>
		<td><a href="informe_cargando_consolidado_rt.asp?cliente=<%=cliente%>&sucursal=Punta%20Arenas&inicio=<%=inicio%>&termino=<%=termino%>">PUNTA ARENAS </a></td>
		<td><div align="right">
		      <%
			abrirscg()
			ssql="SELECT SUM(monto_activo) AS monto_activo,sum(rut_activo) AS DEU FROM COBRADOR_CLIENTE WHERE SUCURSAL='Punta Arenas' AND codigo_cliente='"&cliente&"'"
			set rsA = Conn.execute(ssql)
			if not rsA.eof then
			monto_asignado_16 = rsA("monto_activo")
			ruts_activos_16  = rsA("DEU")
			else
			monto_asignado_16 = 0
			ruts_activos_16 = 0
			end if
			rsA.close
			set rsA = nothing
			cerrarscg()
		if not isnull(monto_asignado_16) then
		response.Write("$ ")
		response.Write(FN(monto_asignado_16,0))
		else
		monto_asignado_16 = 0
		response.Write("$ 0")
		end if

		if isnull(ruts_activos_16) then
		ruts_activos_16 = 0
		end if
%>
		  </div></td>
		<td><div align="right">
		  <%total_deudores_activo_s = total_deudores_activo_s +  ruts_activos_16%>
		  <%=ruts_activos_16%></div></td>
		<td><div align="right">
		  <div align="right">
            <%
 				monto=0
				gasto=0
				cdedu1=0
				abrirscg()
				sql3="SELECT SUM(PAGO_CUOTA.MONTOCAPITAL) AS MONTO,SUM(PAGO_CUOTA.UTILIDAD_EMPRESA) AS GASTO,COUNT(DISTINCT PAGO_CUOTA.RUTDEUDOR) AS CDEUDORES FROM PAGO_CUOTA,PAGO,COBRADOR_CLIENTE WHERE PAGO_CUOTA.CODPAGO = PAGO.CODIGO AND PAGO_CUOTA.COD_CLI='"&cliente&"' AND PAGO_CUOTA.CODCOBRADOR = COBRADOR_CLIENTE.LOGIN AND PAGO.FECHA>='"&inicio&"' AND PAGO.FECHA<='"&termino&"' AND COBRADOR_CLIENTE.SUCURSAL = 'Punta Arenas' "
				set rsHR=Conn.execute(sql3)
				if not rsHR.eof then
					monto=rsHR("MONTO")
					gasto=rsHR("GASTO")
					cdedu1=rsHR("CDEUDORES")
				else
					monto=0
					gasto=0
					cdedu=0
				end if
				rsHR.close
				set rsR=Nothing
				cerrarscg()
				if isnull(monto) then
				monto=0
				end if
				if isNULL(gasto) then
				gasto=0
				end if
				if isNULL(cdedu) then
				cdedu1=0
				end if
		%>
                  <%
		total_capital_pago_s = clng(monto) + CLNG(total_capital_pago_s)
		total_monto_gasto_s = clng(gasto) + clng(total_monto_gasto_s)
		total_usuarios_s = clng(total_usuarios_s) + clng(cdedu1)
		%>
            $ <%=FN(monto,0)%></div>
		</div></td>
		<td><div align="right">$ <%=FN(gasto,0)%></div></td>
		<td><div align="right"><%=FN(cdedu1,0)%></div></td>
	  </tr>
	  <tr bgcolor="#<%=session("COLTABBG")%>">
		<td height="21"><span class="Estilo37">CLIENTE : <%=ncliente%></span></td>
		<td><div align="right" class="Estilo37">
		      <% montototal = monto_asignado_1 + monto_asignado_2 + monto_asignado_3 + monto_asignado_4 + monto_asignado_5 + monto_asignado_6 + monto_asignado_7 + monto_asignado_8 + monto_asignado_9 + monto_asignado_10 + monto_asignado_11 + monto_asignado_12 + monto_asignado_11 + monto_asignado_12 + monto_asignado_13 + monto_asignado_14 + monto_asignado_15 + monto_asignado_16 %>
			  $ <%=FN(montototal,0)%>
		  </div></td>
		<td><div align="right"><span class="Estilo37">
		  <%=fn(total_deudores_activo_s,0)%>
		</span></div></td>
		<td><div align="right"><span class="Estilo37">$ <%=fn(CLNG(total_capital_pago_s),0)%></span></div></td>
		<td><div align="right"><span class="Estilo37">$ <%=fn(total_monto_gasto_s,0)%></span></div></td>
		<td><div align="right"><span class="Estilo37"><%=fn(total_usuarios_s,0)%></span></div></td>
	  </tr>
	</table>
<br>
<br>
<strong>INFORME GENERADO EL DÍA: <%=DATE%>
<BR>HORA: <%=TIME%></strong>
	</td>
  </tr>
</table>
<%end if%>



</form>

<script language="JavaScript1.2">
function envia(){
if (datos.cliente.value=='0'){
alert('DEBE SELECCIONAR UN CLIENTE');
}else{
datos.action='informe_cargando_consolidado_rt.asp';
datos.submit();
}
}
</script>
