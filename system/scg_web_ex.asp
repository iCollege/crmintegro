<% @LCID = 1034 %>
<!--#include file="arch_utils.asp"-->
<!--#include file="lib.asp"-->
<!--#include file="sesion.asp"-->
<!--#include file="../lib/comunes/rutinas/funciones.inc" -->
<html>
<style type="text/css">
<!--
.Estilo30 {color: #FFFFFF}
.Estilo35 {color: #333333}
.Estilo36 {color: #FF0000}
.Estilo37 {color: #CCCCCC}
-->
</style>
<head>
<title>SCG WEB</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
</head>
<body bgcolor="747E97" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<form name="datos" id="datos" method="post">
<%


rut= LTRIM(RTRIM(cstr(request.Form("rut_"))))
if cstr(rut)="" then
rut = LTRIM(RTRIM(cstr(request.Form("rut"))))
	if rut="" then
	rut = request.QueryString("rut")
	end if
end if

rut_ora = REPLACE(LTRIM(RTRIM(cstr(rut))),"-","")
if LEN(cstr(rut_ora)) = 9 then
rut_ora = MID(cstr(rut_ora),1,8)
elseif LEN(cstr(rut_ora)) = 8 Then
rut_ora = MID(cstr(rut_ora),1,7)
elseif LEN(cstr(rut_ora)) = 7 Then
rut_ora = MID(cstr(rut_ora),1,6)
elseif LEN(cstr(rut_ora)) = 6 Then
rut_ora = MID(cstr(rut_ora),1,5)
elseif LEN(cstr(rut_ora)) = 5 Then
rut_ora = MID(cstr(rut_ora),1,4)
end if

inp = 0

if not cstr(rut_ora) = "" and not ISNULL(cstr(rut_ora)) then
	'AbrirSCG()
	'ssqora="select TOP 1 T_JUICIO.RUT from t_juicio, t_ddaafp where t_juicio.juicio = t_ddaafp.juicio and t_ddaafp.estado_deuda = '00' and T_JUICIO.RUT = '"& rut_ora &"' and t_ddaafp.MONTO > 0 "
	'set rsEX = Conn.execute(ssqora)
	'if isNULL(rsEX) then
		'inp = 0
	'else
		'if not rsEX.eof then
		'inp = 1
		'else
		'inp = 0
		'end if
	'end if
	'rsEX.close
   ' set rsEX=nothing
	'cerrarSCG()
	inp=0

end if
%>
<table width="100%" height="100%" border="0" cellpadding="0" cellspacing="0">
  <tr>
    <td valign="top">
      <table width="793" border="0" align="center" cellpadding="0" cellspacing="0">

		<tr>
          <td colspan="3"><div align="right"><img name="index_r1_c1" src="../images/index_r1_c1.gif" width="793" height="87" border="0" alt=""></div></td>
        </tr>


        <tr>
          <td width="17" background="../images/index_r2_c1.gif">&nbsp;</td>
          <td width="758">
          	<table width="100%" height="431" border="0" cellpadding="0" cellspacing="0" bgcolor="#FFFFFF"><script type="text/javascript" language="JavaScript1.2" src="frameset/stm31.js"></script>
          		<tr valign=TOP>
							<td height="431" colspan="3"><p align="right" class="Estilo37">Usuario: <%=UCASE(session("nombre_user"))%> | <a href="javascript:ventanaSecundaria('dir_tel_externo.asp')">B&Uacute;SQUEDA TEL -DIR</A> | <a href="javascript:ventanaMisGestiones('mis_gestiones.asp?codcob=<%=LTRIM(RTRIM(session("session_login")))%>')"><acronym title="GESTIONES PRODUCIDAS POR <%=session("nombre_user")%>">MIS GESTIONES</acronym></a> | <a href="javascript:ventanaDetalle('mi_recupero.asp')">MI RECUPERACI&Oacute;N</a> | <a href="javascript:ventanaDetalle('busqueda.asp')">B&Uacute;SQUEDA DEUDOR </a> |
							  <%if session("session_tipo")="COB_CAJ" Then%>
							<%if not rut="" then%><a href="javascript:ventanaPagos('caja.asp?rut=<%=rut%>')">MODULO DE PAGOS</a>
							<%else%>
							MODULO DE PAGOS
							<%end if%> |
							<%end if%>
							<a href="cbdd02.asp"> <acronym title="SALIR DEL SISTEMA">CERRAR SESI&Oacute;N</acronym></a></p>
							  <table width="100%" height="335" border="0">
                                <tr>
                                  <td height="331" valign="top" background="../images/fondo_coventa.jpg"><table width="100%" border="0">
                                      <tr>
                                        <td width="19%" class="Estilo13"><img src="../lib/RUT_DEUDOR.gif" width="740" height="22"></td>
                                      </tr>
                  <tr>
                 <td><acronym title="RUT EN FORMATO SIN PUNTOS EJ: 10111222-3"><input name="rut" type="text" id="rut" value="<%=rut%>" size="10" maxlength="10"></acronym>&nbsp;&nbsp;
            		<acronym title="DESPLEGAR DATOS DEL DEUDOR ASOCIADO AL RUT DE BÚSQUEDA"><input name="me_" type="button" id="me_" onClick="envia();" value="Buscar"></acronym>&nbsp;&nbsp;
            		<acronym title="LIMPIAR FORMULARIO"><input name="li_" type="button" onClick="window.navigate('scg_web.asp');" value="Limpiar"></acronym>&nbsp;&nbsp;
					<acronym title="IMPRIMIR FORMULARIO (CONFIGURACION HORIZONTAL)"><input name="li_" type="button" onClick="window.print();" value="Imprimir"></acronym>
					<span class="Estilo35">

					</span>
					<input name="rutf" type="hidden" id="rutf" value="<%=rut%>">
                  </td>
                  </tr>
        	</table>
        <%if not rut="" and not isnull(rut) then%>
		<%
		direccion_val=request.Form("radiodir")
		fono_val=request.Form("radiofon")
		email_val=request.Form("radiomail")

		cor_tel=request.Form("correlativo_fono")
		cor_dir=request.Form("correlativo_direccion")
		cor_cor=request.Form("correlativo_mail")

		AbrirSCG()

		if not fono_val="" then

		ssql=""
		ssql="UPDATE DEUDOR_TELEFONO SET estado='"&fono_val&"' WHERE RUTDEUDOR='"&rut&"' AND CORRELATIVO='"&cint(cor_tel)&"'"
		Conn.execute(ssql)
		end if

		if not direccion_val="" then
		ssql=""
		ssql="UPDATE DEUDOR_DIRECCION SET estado='"&direccion_val&"' WHERE RUTDEUDOR='"&rut&"' AND CORRELATIVO='"&cint(cor_dir)&"'"
		Conn.execute(ssql)
		end if


		if not email_val="" then
		ssql=""
		ssql="UPDATE DEUDOR_EMAIL SET estado='"&email_val&"' WHERE RUTDEUDOR='"&rut&"' AND CORRELATIVO='"&cint(cor_cor)&"'"
		Conn.execute(ssql)
		end if
		CerrarSCG()



		AbrirSCG()
		ssql="SELECT TOP 1 NOMBREDEUDOR,RUTDEUDOR FROM DEUDOR WHERE RUTDEUDOR='"&rut&"' AND NOMBREDEUDOR IS NOT NULL AND LTRIM(RTRIM(NOMBREDEUDOR)) <> '' "
		set rsDEU=Conn.execute(ssql)
		if not rsDEU.eof then
			nombre_deudor = rsDEU("NOMBREDEUDOR")
			rut_deudor = rsDEU("RUTDEUDOR")
		else
			rut_deudor = rut
			nombre_deudor = "SIN NOMBRE"
		end if
		rsDEU.close
		set rsDEU=nothing
		cerrarSCG()

		abrirSCG()
		ssql=""
		ssql="SELECT TOP 1 Calle,Numero,Comuna,Resto,Correlativo,Estado FROM DEUDOR_DIRECCION WHERE RUTDEUDOR='"&rut_deudor&"' and ESTADO<>'2' ORDER BY Correlativo DESC"
		set rsDIR=Conn.execute(ssql)
		if not rsDIR.eof then
			calle_deudor=rsDIR("Calle")
			numero_deudor=rsDIR("Numero")
			comuna_deudor=rsDIR("Comuna")
			resto_deudor=rsDIR("Resto")
			correlativo_deudor=rsDIR("Correlativo")
			estado_direccion=rsDIR("Estado")
				if estado_direccion="1" then
				estado_direccion="VALIDA"
				elseif estado_direccion="2" then
				estado_direccion="NO VALIDA"
				else
				estado_direccion="SIN AUDITAR"
				end if
		end if
		rsDIR.close
		set rsDIR=nothing
		cerrarSCG()

		abrirSCG()
		ssql=""
		ssql="SELECT TOP 1 CodArea,Telefono,Correlativo,Estado FROM DEUDOR_TELEFONO WHERE  RUTDEUDOR='"&rut_deudor&"' and ESTADO<>'2' ORDER BY Correlativo DESC"
		set rsFON=Conn.execute(ssql)
		if not rsFON.eof then
			codarea_deudor = rsFON("CodArea")
			Telefono_deudor = rsFON("Telefono")
			Correlativo_deudor2 = rsFON("Correlativo")
			estado_fono = rsFON("Estado")

				if estado_fono="1" then
				estado_fono="VALIDO"
				elseif estado_fono="2" then
				estado_fono="NO VALIDO"
				else
				estado_fono="SIN AUDITAR"
				end if
		end if
		rsFON.close
		set rsFON=nothing
		cerrarSCG()

		abrirSCG()
		ssql=""
		ssql="SELECT TOP 1 RUTDEUDOR,CORRELATIVO,FECHAINGRESO,EMAIL,ESTADO FROM DEUDOR_EMAIL WHERE  RUTDEUDOR='"&rut_deudor&"' and ESTADO<>'2' ORDER BY Correlativo DESC"
		set rsMAIL=Conn.execute(ssql)
		if not rsMAIL.eof then
			email = rsMAIL("EMAIL")
			Correlativo_deudor3 = rsMAIL("Correlativo")
			estado_mail = rsMAIL("ESTADO")

				if estado_mail="1" then
				estado_mail="VALIDO"
				elseif estado_mail="2" then
				estado_mail="NO VALIDO"
				else
				estado_mail="SIN AUDITAR"
				end if
		else
			email = "SIN INFORMACIÓN"
		end if
		rsMAIL.close
		set rsMAIL=nothing
		cerrarSCG()
		%>
       <%if not rut_deudor="" then%>
       <img src="../lib/DATOS_DEUDOR.gif" width="740" height="22"><BR>
	   <table width="100%" border="0" bordercolor="#FFFFFF">
		   <tr bordercolor="#999999"  bgcolor="#<%=session("COLTABBG")%>" class="Estilo13">
			 <td width="31%" bgcolor="#<%=session("COLTABBG")%>">RUT</td>
			 <td width="50%">NOMBRE O RAZ&Oacute;N SOCIAL</td>
			</tr>
            <tr bgcolor="#<%=session("COLTABBG2")%>" class="Estilo8">
              <td><%=rut_deudor%></td>
              <td><%=nombre_deudor%></td>
            </tr>
        </table>

		<img src="../lib/DATOS_UBICA.gif" width="740" height="22">
        <table width="100%" border="0" bordercolor="#FFFFFF">
			<tr bordercolor="#999999" bgcolor="#<%=session("COLTABBG")%>" class="Estilo13">
			   <td width="46%">DIRECCI&Oacute;N</td>
			   <td width="28%">ESTADO DIRECCION</td>
			   <td width="26%">OTRAS DIRECCIONES </td>
			   </tr>
			 <tr class="Estilo8">
				<td><%=calle_deudor%>
				  <%=numero_deudor%> &nbsp;<span class="Estilo36"><%=resto_deudor%></span> &nbsp;<strong><%=comuna_deudor%></strong>
                 </td>
				<td>
                  <input name="radiodir" type="radio" value="1" <%if estado_direccion="VALIDA" then Response.Write("checked") end if%> <%if estado_direccion="" then response.Write("Disabled") end if%>>VA
  				  <input name="radiodir" type="radio" value="2" <%if estado_direccion="NO VALIDA" then Response.Write("checked") end if%> <%if estado_direccion="" then response.Write("Disabled") end if%>>NV
                  <input name="radiodir" type="radio" value="0" <%if estado_direccion="SIN AUDITAR" then Response.Write("checked") end if%> <%if estado_direccion="" then response.Write("Disabled") end if%>>SA
  					<input name="Submit" type="button" class="Estilo8" onClick="envia();" value="Auditar" <%if estado_direccion="" then response.Write("Disabled") end if%>>
				</td>
				<td>| <a href="javascript:ventanaSecundaria('mas_direcciones.asp?rut=<%=rut_deudor%>')">
				<acronym title="VER TODAS LAS DIRECCIONES DEL DEUDOR">M&Aacute;S</acronym></a>
				| <a href="javascript:ventanaSecundaria('nueva_dir.asp?rut=<%=rut_deudor%>')">
				<acronym title="INGRESAR UNA NUEVA DIRECCION">NUEVA DIRECCI&Oacute;N </acronym></a>
				<input name="correlativo_direccion" type="hidden" id="correlativo_direccion" value="<%=correlativo_deudor%>"></td>
				</tr>

			  <tr bgcolor="#<%=session("COLTABBG")%>" class="Estilo8">
			    <td><span class="Estilo30">TELEFONO</span></td>
			    <td><span class="Estilo30">ESTADO TEL&Eacute;FONO </span></td>
			    <td><span class="Estilo30">OTROS  TELEFONOS </span></td>
			    </tr>
			  <tr class="Estilo8">
			  <td><%if not telefono_deudor="" then%>
			    <%=codarea_deudor%>-<%=telefono_deudor%>
				<%END IF%>
               </td>
			  <td>
                <input name="radiofon" type="radio" value="1" <%if estado_fono="VALIDO" then Response.Write("checked") end if%> <%if estado_fono="" then response.Write("Disabled") end if%>>VA
  				<input name="radiofon" type="radio" value="2" <%if estado_fono="NO VALIDO" then Response.Write("checked") end if%> <%if estado_fono="" then response.Write("Disabled") end if%>>NV
  				<input name="radiofon" type="radio" value="0" <%if estado_fono="SIN AUDITAR" then Response.Write("checked") end if%> <%if estado_fono="" then response.Write("Disabled") end if%>>SA
  				<input name="Submit" type="button" class="Estilo8" onClick="envia();" value="Auditar" <%if estado_fono="" then response.Write("Disabled") end if%>>
              </td>
			  <td>| <a href="javascript:ventanaSecundaria('mas_telefonos.asp?rut=<%=rut_deudor%>')">
			  <acronym title="VER TODOS LOS TEL&Eacute;FONOS DEL DEUDOR">M&Aacute;S</acronym></a>
				| <a href="javascript:ventanaSecundaria('nuevo_tel.asp?rut=<%=rut_deudor%>')">
				<acronym title="INGRESAR UN NUEVO TEL&Eacute;FONO">NUEVO TELEFONO</acronym></a>
				<input name="correlativo_fono" type="hidden" id="correlativo_fono" value="<%=correlativo_deudor2%>"></td>
			  </tr>
			  <tr bgcolor="#<%=session("COLTABBG")%>" class="Estilo8">
			    <td><span class="Estilo30">CORREO ELECTR&Oacute;NICO </span></td>
			    <td><span class="Estilo30">ESTADO CORREO ELECTR&Oacute;NICO </span></td>
			    <td><span class="Estilo30">OTROS CORREOS ELECTR&Oacute;NICOS </span></td>
			    </tr>
			  <tr class="Estilo8">
			    <td><%=email%> </td>
			    <td><input name="radiomail" type="radio" value="1" <%if estado_mail="VALIDO" then Response.Write("checked") end if%> <%if estado_mail="" then response.Write("Disabled") end if%>>VA
                    <input name="radiomail" type="radio" value="2" <%if estado_mail="NO VALIDO" then Response.Write("checked") end if%> <%if estado_mail="" then response.Write("Disabled") end if%>>NV
                    <input name="radiomail" type="radio" value="0" <%if estado_mail="SIN AUDITAR" then Response.Write("checked") end if%> <%if estado_mail="" then response.Write("Disabled") end if%>>SA
                    <input name="Submit" type="button" class="Estilo8" onClick="envia();" value="Auditar" <%if estado_mail="" then response.Write("Disabled") end if%>></td>
			    <td>| <a href="javascript:ventanaSecundaria('mas_correos.asp?rut=<%=rut_deudor%>')"> <acronym title="VER TODOS LOS CORREOS ELECTRONICOS DEL DEUDOR">M&Aacute;S</acronym></a> | <a href="javascript:ventanaSecundaria('nuevo_cor.asp?rut=<%=rut_deudor%>')"> <acronym title="INGRESAR UN NUEVO CORREO ELECTRONICO">NUEVO CORREO </acronym></a>
                  <input name="correlativo_mail" type="hidden" id="correlativo_mail" value="<%=correlativo_deudor3%>"></td>
			    </tr>
        </table>

        <u></u>       <%
	  AbrirSCG()
	  ssql=""
	  ssql="SELECT COUNT(CUOTA.NRODOC) AS NUMDOC,SUM(CUOTA.SALDO) AS MONTODOC, CLIENTES.COD_CLI, CLIENTES.DESC_CLI AS DESC_CLI FROM CUOTA,CLIENTES "
	  ssql= ssql & "WHERE CUOTA.CODCLIENTE=CLIENTES.COD_CLI AND CUOTA.RUTDEUDOR='"&rut_deudor&"'"
	  ssql= ssql & "GROUP BY CUOTA.CODCLIENTE,CLIENTES.COD_CLI,CLIENTES.DESC_CLI"
	  set rsDEU=Conn.execute(ssql)
	  if not rsDEU.eof then
	  monto=0
	  %>
       <img src="../lib/DATOS_DEUDA.gif" width="740" height="22">
	   <table width="100%" border="0" bordercolor="#FFFFFF">
       <tr bordercolor="#999999" bgcolor="#<%=session("COLTABBG")%>" class="Estilo13">
		   <td width="24%">CLIENTE</td>
		   <td width="16%">GESTIONES</td>
		   <td width="10%">DOCS</td>
		   <td width="13%">MONTO</td>
		   <td width="26%">DETALLE DE DEUDAS </td>
           <td width="11%">EJECUTIVO</td>
       </tr>

		<%do until rsDEU.eof%>

	   <tr>
		   <td>
				<%=rsDEU("DESC_CLI")%>
		   </td>
		   <td>
				<acronym title="MODULO DE GESTIÓN PARA EL CLIENTE <%=rsDEU("DESC_CLI")%>">
				<a href="javascript:ventanaIngresoG('detalle_gestiones.asp?rut=<%=rut_deudor%>&cliente=<%=rsDEU("COD_CLI")%>')">MODULO DE GESTION </a>
				</acronym>
		   </td>
		   <td>
				<div align="right"><%=rsDEU("NUMDOC")%></div></td>

				<td><div align="right">$ <%if not isnull(rsDEU("MONTODOC")) then%><%=(FN(CLNG(rsDEU("MONTODOC")),0))%><%end if%></div>
		   </td>
		   <td>
				<div align="right"><acronym title="DETALLE DE LA DEUDA DEL DEUDOR <%=rut%> CON EL CLIENTE <%=rsDEU("DESC_CLI")%>">
				<%if rsDEU("COD_CLI")="40" then%><a href="javascript:ventanaDetalle('detalle_deuda_acsa.asp?rut=<%=rut_deudor%>&cliente=<%=rsDEU("COD_CLI")%>')">VER DETALLE DEUDA</a>
				<%elseif rsDEU("COD_CLI")="41" then%><a href="javascript:ventanaDetalle('detalle_deuda_acsa_infra.asp?rut=<%=rut_deudor%>&cliente=<%=rsDEU("COD_CLI")%>')">VER DETALLE DEUDA</a>
				<%elseif rsDEU("COD_CLI")="8" then%><a href="javascript:ventanaDetalle('detalle_deuda_inp_cheque.asp?rut=<%=rut_deudor%>&cliente=<%=rsDEU("COD_CLI")%>')">VER DETALLE DEUDA</a>
				<%elseif rsDEU("COD_CLI")="13" then%><a href="javascript:ventanaDetalle('detalle_deuda_ctcmundo.asp?rut=<%=rut_deudor%>&cliente=<%=rsDEU("COD_CLI")%>')">VER DETALLE DEUDA</a>
				<%elseif rsDEU("COD_CLI")="36" then%><a href="javascript:ventanaDetalle('detalle_deuda_dys.asp?rut=<%=rut_deudor%>&cliente=<%=rsDEU("COD_CLI")%>')">VER DETALLE DEUDA</a>
				<%elseif rsDEU("COD_CLI")="21" then%><a href="javascript:ventanaDetalle('detalle_deuda_ripley.asp?rut=<%=rut_deudor%>&cliente=<%=rsDEU("COD_CLI")%>')">VER DETALLE DEUDA</a>
				<%elseif rsDEU("COD_CLI")="6" then%><a href="javascript:ventanaDetalle('detalle_deuda_bellsouth.asp?rut=<%=rut_deudor%>&cliente=<%=rsDEU("COD_CLI")%>')">VER DETALLE DEUDA</a>
				<%elseif rsDEU("COD_CLI")="12" then%><a href="javascript:ventanaDetalle('detalle_deuda_121.asp?rut=<%=rut_deudor%>&cliente=<%=rsDEU("COD_CLI")%>')">VER DETALLE DEUDA</a>
				<%elseif rsDEU("COD_CLI")="14" then%><a href="javascript:ventanaDetalle('detalle_deuda_cencosud.asp?rut=<%=rut_deudor%>&cliente=<%=rsDEU("COD_CLI")%>')">VER DETALLE DEUDA</a>
				<%elseif rsDEU("COD_CLI")="11" or  rsDEU("COD_CLI")="15" then%><a href="javascript:ventanaDetalleTelefonicas('detalle_deuda_movistar.asp?rut=<%=rut_deudor%>&cliente=<%=rsDEU("COD_CLI")%>')">VER DETALLE DEUDA</a>
				<%else%><a href="javascript:ventanaDetalle('detalle_deuda.asp?rut=<%=rut_deudor%>&cliente=<%=rsDEU("COD_CLI")%>')">VER DETALLE DEUDA</a>
				<%end if%></acronym></div>
			</td>
		   <td>
		           <div align="right">
		             <%
		   sej="SELECT TOP 1 CODCOBRADOR FROM CUOTA WHERE RUTDEUDOR='"&rut_deudor&"' AND CODCLIENTE='"&rsDEU("COD_CLI")&"'"
		   set rsEJ=Conn.execute(sej)
		   if not rsEJ.eof then
		   response.Write(rsEJ("CODCOBRADOR"))
		   else
		   response.Write("SIN EJECUTIVO")
		   end if
		   rsEJ.close
		   set rsEJ=nothing
		   %>
		             </div></td></tr>
              <%
			  	if not isnull(rsDEU("MONTODOC")) then
		 		monto=monto + clng(rsDEU("MONTODOC"))
				end if
		 		rsDEU.movenext
		 		loop
		 		%>

					<%
					if inp = 1 then
					sORAD="SELECT SUM(MONTO_) AS MONTO,COUNT(*) AS CANTIDAD FROM T_JUICIO WHERE RUT='"&rut_ora&"'"
					set rsMO=Conn.execute(sORAD)
						if not rsMO.eof then
						monto=rsMO("MONTO")
							if isnull(monto) then
							monto=0
							end if
					%>
					<tr>
					</tr>
					<%end if
					end if
					%>
                     </table>

									  <%
									  else
									  sORAD="SELECT SUM(MONTO_) AS MONTO,COUNT(*) AS CANTIDAD FROM T_JUICIO WHERE RUT='"&rut_ora&"'"
									  set rsMO=Conn.execute(sORAD)
									  if not rsMO.eof then
									  			monto=rsMO("MONTO")
												if isnull(monto) then
												monto=0
												end if
									  %>
									  <br>
										DEUDAS EN REGISTRO

									  		<table width="100%" border="0">
											  <tr bgcolor="#<%=session("COLTABBG")%>" class="Estilo13">
												<td width="30%"> CLIENTE</td>
												<td width="20%"> GESTIONES</td>
												<td width="11%"> DOCUMENTOS</td>
												<td width="17%"> DEUDA CON CLIENTE </td>
												<td width="22%"> VER DETALLE DEUDA </td>
											  </tr>
											  <tr>
												<td>INP </td>
												<td> <a href="javascript:ventanaIngresoG('detalle_gestiones.asp?rut=<%=rut_deudor%>&cliente=7')">MODULO DE GESTION </a></td>
												<td><div align="right"><%=rsMO("CANTIDAD")%></div></td>
												<td><div align="right">$ <%=FN(clng(monto),0)%></div></td>
												<td><div align="right"><a href="javascript:ventanaDetalleINPP('detalle_deuda_inp.asp?rut=<%=rut_deudor%>&cliente=7')">VER DETALLE DEUDA </a></div></td>
											  </tr>
									</table>
									<%end if

									%>

                                      <%end if
	  									rsDEU.close
	  									set rsDEU=nothing
	  								%>

                                      <%cerrarSCG()
									  end if%>

                                  </td>
                                </tr>
                                <%

								end if

								%>
                     </table>
			      </td>
	          </tr>
            </table>
          </td>
          <td width="18" background="../images/index_r2_c3.gif">&nbsp;</td>
        </tr>
			<tr>
			  <td height="17" colspan="3"><img name="index_r3_c1" src="../images/index_r3_c1.gif" width="793" height="17" border="0" alt=""></td>
			</tr>
      </table>

	  </td>

  </tr>

</table>
</form>
</body>
</html>


<script language="JavaScript" type="text/JavaScript">
function envia(){
datos.action='scg_web.asp';
datos.submit();
}

function paga(){
datos.action='detalle_pago.asp';
datos.submit();
}

function ventanaSecundaria (URL){
window.open(URL,"INFORMACION","width=800, height=400, scrollbars=yes, menubar=no, location=no, resizable=yes")
}


function ventanaDetalleINPP (URL){
window.open(URL,"DETALLEGESTION","width=800, height=400, scrollbars=yes, menubar=no, location=no, resizable=yes")
}
function ventanaDetalle (URL){
window.open(URL,"DETALLEGESTION","width=800, height=300, scrollbars=yes, menubar=no, location=no, resizable=yes")
}
function ventanaDetalleTelefonicas (URL){
window.open(URL,"DETALLEGESTION","width=800, height=300, scrollbars=yes, menubar=no, location=no, resizable=yes")
}

function ventanaIngresoG (URL){
window.open(URL,"INFORMACION","width=800, height=400, scrollbars=yes, menubar=no, location=no, resizable=yes")
}

function ventanaMisGestiones (URL){
window.open(URL,"MISGESTIONES","width=800, height=400, scrollbars=yes, menubar=no, location=no, resizable=no")
}

function ventanaPagos (URL){
window.open(URL,"PAGOS","width=720, height=400, scrollbars=yes, menubar=no, location=no, resizable=no")
}

</script>
