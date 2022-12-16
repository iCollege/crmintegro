<% @LCID = 1034 %>
<!--#include file="arch_utils.asp"-->
<!--#include file="lib.asp"-->
<!--#include file="../lib/comunes/rutinas/funciones.inc" -->
<html>
<style type="text/css">
<!--
.Estilo30 {color: #FFFFFF}
.Estilo36 {color: #FF0000}
.Estilo37 {color: #CCCCCC}
body {
	background-image: url();
}
.Estilo38 {color: #000000}
-->
</style>
<head>
<title>SCG WEB</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
</head>
<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<form name="datos" id="datos" method="post">
<%



rut= LTRIM(RTRIM(cstr(request.Form("rut_"))))
if cstr(rut)="" then
rut = LTRIM(RTRIM(cstr(request.Form("rut"))))
	if rut="" then
	rut = request.QueryString("rut")
	end if
end if


	lenani = Instr(Trim(request.QueryString("ani")),";")
	If lenani <> 0 Then
		lenani = lenani + 2
	Else
		lenani = 1
	End if
	ani = Mid(Trim(request.QueryString("ani")),lenani,len(Trim(request.QueryString("ani"))))


	'Response.write "lenani="&lenani
	'Response.End
	ani = Mid(Trim(request.QueryString("ani")),lenani,len(Trim(request.QueryString("ani"))))

	'Response.write "ani="&ani
	'Response.End
%>

	<table width="793" border="0" align="center" cellpadding="0" cellspacing="0">
	<tr>
        <td colspan="2"><div align="right">
          <table width="100%" height="568" border="0" cellpadding="0" cellspacing="0" bgcolor="#FFFFFF">
            <script type="text/javascript" language="JavaScript1.2" src="frameset/stm31.js"></script>
            <tr valign=TOP>
              <td height="43" colspan="3"><img src="../system/top.jpg" width="720" height="48"></td>
            </tr>
            <tr valign=TOP>
              <td height="431" colspan="3"><p align="right" class="Estilo37">Usuario: <%=UCASE(session("nombre_user"))%> | <a href="javascript:ventanaSecundaria('dir_tel_externo.asp')">B&Uacute;SQUEDA TEL -DIR</A> | <a href="javascript:ventanaMisGestiones('mis_gestiones.asp?codcob=<%=LTRIM(RTRIM(session("session_login")))%>')"><acronym title="GESTIONES PRODUCIDAS POR <%=session("nombre_user")%>">MIS GESTIONES</acronym></a> | <a href="javascript:ventanaDetalle('mi_recupero.asp')">MI RECUPERACI&Oacute;N</a> | <a href="javascript:ventanaDetalle('busqueda.asp')">B&Uacute;SQUEDA DEUDOR </a> | <a href="javascript:Predictivo()">B&Uacute;SQUEDA PREDICTIVO </a> | <a href="javascript:Sms()">B&Uacute;SQUEDA SMS </a> |
                      <%if session("session_tipo")="COB_CAJ" Then%>
                      <%if not rut="" then%>
                      <a href="javascript:ventanaPagos('caja.asp?rut=<%=rut%>')">MODULO DE PAGOS</a>
                      <%else%>
        MODULO DE PAGOS
        <%end if%>
        |
        <%end if%>
         <a href="scg_web_inp.asp"> <acronym title="GESTIONES TERRENO INP">GEST.TERR.INP</acronym></a> |
         <a href="cbdd02.asp"> <acronym title="SALIR DEL SISTEMA">CERRAR SESI&Oacute;N</acronym></a></p>
                  <table width="100%" height="335" border="0">
                    <tr>
                      <td height="331" valign="top" background="../images/fondo_coventa.jpg"><table width="100%" border="0">
                          <tr>
                            <td width="19%" class="Estilo13"><span class="Estilo38">
                            </span><img src="../lib/RUT_DEUDOR.gif" width="740" height="22"></td>
                          </tr>
                          <tr>
                            <td><acronym title="RUT EN FORMATO SIN PUNTOS EJ: 10111222-3">
                              <input name="rut" type="text" id="rut" value="<%=rut%>" size="10" maxlength="10">
                              </acronym>&nbsp;&nbsp; <acronym title="DESPLEGAR DATOS DEL DEUDOR ASOCIADO AL RUT DE B&Uacute;SQUEDA">
                              <input name="me_" type="button" id="me_" onClick="envia();" value="Buscar">
                              </acronym>&nbsp;&nbsp; <acronym title="LIMPIAR FORMULARIO">
                              <input name="li_" type="button" onClick="window.navigate('scg_web.asp');" value="Limpiar">
                              </acronym>&nbsp;&nbsp; <acronym title="IMPRIMIR FORMULARIO (CONFIGURACION HORIZONTAL)">
                              <input name="li_" type="button" onClick="window.print();" value="Imprimir">
                              </acronym>
                              <input name="rutf" type="hidden" id="rutf" value="<%=rut%>">
                              <input name="ANI" type="hidden" id="ANI" value="<%=ani%>">
                            <span class="Estilo38">                            </span></td>
                          </tr>
                          <tr><%if not ani="" then%>
                            <td bgcolor="#FFFFFF">
					          <div align="right">
					            <%
							if len(ani)=7 then
								area_con = "2"
								fono_con = ani
							else
								if mid(ani,1,3)="122" then
								ani = mid(ani,4,8)
								end if
								if mid(ani,1,1)="0" then
								area_con = "0"
								fono_con = mid(ani,2,8)
								elseif mid(ani,1,1)="2" then
								area_con = "2"
								fono_con = mid(ani,2,8)
								else
								area_con = mid(ani,1,2)
								fono_con = mid(ani,3,6)
								end if
							end if

							%>
					            DISCADOR AUTOM&Aacute;TICO - DEUDOR CONTACTADO EN FONO : <%=area_con%> - <%=fono_con%></div></td>
							<%
							else
							fono_con="0"
							area_con="0"
							end if
							%>
                          </tr>
                        </table>
                          <%
		if not rut="" and not isnull(rut) then
		direccion_val=request.Form("radiodir")
		fono_val=request.Form("radiofon")
		email_val=request.Form("radiomail")
		cor_tel=request.Form("correlativo_fono")
		cor_dir=request.Form("correlativo_direccion")
		cor_cor=request.Form("correlativo_mail")

		AbrirSCG()

		if not fono_val="" and not fono_val="0" then
			ssql=""
			ssql="UPDATE DEUDOR_TELEFONO SET estado='"&fono_val&"' WHERE RUTDEUDOR='"&rut&"' AND CORRELATIVO='"&cint(cor_tel)&"'"
			Conn.execute(ssql)
		end if

		if not direccion_val="" and not direccion_val="0" then
			ssql=""
			ssql="UPDATE DEUDOR_DIRECCION SET estado='"&direccion_val&"' WHERE RUTDEUDOR='"&rut&"' AND CORRELATIVO='"&cint(cor_dir)&"'"
			Conn.execute(ssql)
		end if


		if not email_val="" and not email_val="0" then
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
			existe = "si"
		else
			rut_deudor = rut
			existe = "no"
			nombre_deudor = "SIN NOMBRE"
		end if
		rsDEU.close
		set rsDEU=nothing
		cerrarSCG()

		if existe = "si" then

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
			email = "SIN INFORMACI&Oacute;N"
		end if
		rsMAIL.close
		set rsMAIL=nothing
		cerrarSCG()

		abrirSCG()
		ssql=""
		ssql="SELECT TOP 1 RUTDEUDOR,FECHA,ESTADO FROM DEUDOR_PUBLICACION WHERE  RUTDEUDOR='"&rut_deudor&"' and ESTADO='1'"
		set rsPUBLI=Conn.execute(ssql)
		if not rsPUBLI.eof then
			PUBLICACION_FECHA = rsPUBLI("FECHA")
			PUBLICACION_ESTADO = rsPUBLI("ESTADO")


				if PUBLICACION_ESTADO="1" then
				PUBLICACION="<font color=""#FF0000"">PUBLICADO EN CAMARA COMERCIO</font>"
				end if
		else
			PUBLICACION = "NO PUBLICADO EN CAMARA COMERCIO"
		end if
		rsPUBLI.close
		set rsPUBLI=nothing
		cerrarSCG()

		%>
                          <%if not rut_deudor=""  then%>
                          <img src="../lib/DATOS_DEUDOR.gif" width="740" height="22"><BR>
                          <table width="100%" border="0" bordercolor="#FFFFFF">
                            <tr bordercolor="#999999"  bgcolor="#<%=session("COLTABBG")%>" class="Estilo13">
                              <td width="18%" bgcolor="#<%=session("COLTABBG")%>">RUT</td>
                              <td width="38%">NOMBRE O RAZ&Oacute;N SOCIAL</td>
							  <td width="24%">PUBLICACION CAMARA COMERCIO</td>
                            </tr>
                            <tr bgcolor="#<%=session("COLTABBG2")%>" class="Estilo8">
                             <td><%=rut_deudor%></td>
                              <td><%=nombre_deudor%></td>
							  <td><%=Publicacion%></td>
                            </tr>
                          </table>
                          <img src="../lib/DATOS_UBICA.gif" width="740" height="22">
                          <table width="100%" border="0" bordercolor="#FFFFFF">
                            <tr bordercolor="#999999" bgcolor="#<%=session("COLTABBG")%>" class="Estilo13">
                              <td width="46%">DIRECCI&Oacute;N M&Aacute;S RECIENTE </td>
                              <td width="28%">ESTADO DIRECCION</td>
                              <td width="26%">OTRAS DIRECCIONES </td>
                            </tr>
                            <tr class="Estilo8">
                              <td><%=calle_deudor%> <%=numero_deudor%> &nbsp;<span class="Estilo36"><%=resto_deudor%></span> &nbsp;<strong><%=comuna_deudor%></strong> </td>
                              <td><input name="radiodir" type="radio" value="1" <%if estado_direccion="VALIDA" then Response.Write("checked") end if%> <%if estado_direccion="" then response.Write("Disabled") end if%>>
                                VA
                                  <input name="radiodir" type="radio" value="2" <%if estado_direccion="NO VALIDA" then Response.Write("checked") end if%> <%if estado_direccion="" then response.Write("Disabled") end if%>>
                                  NV
                                  <input name="radiodir" type="radio" value="0" <%if estado_direccion="SIN AUDITAR" then Response.Write("checked") end if%> <%if estado_direccion="" then response.Write("Disabled") end if%>>
                                  SA
                                  <input name="Submit" type="button" class="Estilo8" onClick="envia();" value="Auditar" <%if estado_direccion="" then response.Write("Disabled") end if%>>
                              </td>
                              <td>| <a href="javascript:ventanaSecundaria('mas_direcciones.asp?rut=<%=rut_deudor%>')"><acronym title="VER TODAS LAS DIRECCIONES DEL DEUDOR">M&Aacute;S</acronym></a> | <a href="javascript:ventanaSecundaria('nueva_dir.asp?rut=<%=rut_deudor%>')"><acronym title="INGRESAR UNA NUEVA DIRECCION">NUEVA DIRECCI&Oacute;N </acronym></a>
                                  <input name="correlativo_direccion" type="hidden" id="correlativo_direccion" value="<%=correlativo_deudor%>">
                              </td>
                            </tr>
                            <tr bgcolor="#<%=session("COLTABBG")%>" class="Estilo8">
                              <td><span class="Estilo30">TELEFONO M&Aacute;S RECIENTE</span></td>
                              <td><span class="Estilo30">ESTADO TEL&Eacute;FONO </span></td>
                              <td><span class="Estilo30">OTROS TELEFONOS </span></td>
                            </tr>
                            <tr class="Estilo8">
                              <td><%if not telefono_deudor="" then%>
                                  <%=codarea_deudor%>-<%=telefono_deudor%>
                                  <%ELSE RESPONSE.Write("SIN INFORMACIÓN")
								  END IF%>
                              </td>
                              <td><input name="radiofon" type="radio" value="1" <%if estado_fono="VALIDO" then Response.Write("checked") end if%> <%if estado_fono="" then response.Write("Disabled") end if%>>
                                VA
                                  <input name="radiofon" type="radio" value="2" <%if estado_fono="NO VALIDO" then Response.Write("checked") end if%> <%if estado_fono="" then response.Write("Disabled") end if%>>
                                  NV
                                  <input name="radiofon" type="radio" value="0" <%if estado_fono="SIN AUDITAR" then Response.Write("checked") end if%> <%if estado_fono="" then response.Write("Disabled") end if%>>
                                  SA
                                  <input name="Submit" type="button" class="Estilo8" onClick="envia();" value="Auditar" <%if estado_fono="" then response.Write("Disabled") end if%>>
                              </td>
                              <td>| <a href="javascript:ventanaSecundaria('mas_telefonos.asp?rut=<%=rut_deudor%>')"> <acronym title="VER TODOS LOS TEL&Eacute;FONOS DEL DEUDOR">M&Aacute;S</acronym></a> | <a href="javascript:ventanaSecundaria('nuevo_tel.asp?rut=<%=rut_deudor%>')"> <acronym title="INGRESAR UN NUEVO TEL&Eacute;FONO">NUEVO TELEFONO</acronym></a>
                                  <input name="correlativo_fono" type="hidden" id="correlativo_fono" value="<%=correlativo_deudor2%>">
                              </td>
                            </tr>
                            <tr bgcolor="#<%=session("COLTABBG")%>" class="Estilo8">
                              <td><span class="Estilo30">CORREO ELECTR&Oacute;NICO M&Aacute;S RECIENTE </span></td>
                              <td><span class="Estilo30">ESTADO CORREO ELECTR&Oacute;NICO </span></td>
                              <td><span class="Estilo30">OTROS CORREOS ELECTR&Oacute;NICOS </span></td>
                            </tr>
                            <tr class="Estilo8">
                              <td><%=email%></td>
                              <td><input name="radiomail" type="radio" value="1" <%if estado_mail="VALIDO" then Response.Write("checked") end if%> <%if estado_mail="" then response.Write("Disabled") end if%>>
                                VA
                                  <input name="radiomail" type="radio" value="2" <%if estado_mail="NO VALIDO" then Response.Write("checked") end if%> <%if estado_mail="" then response.Write("Disabled") end if%>>
                                  NV
                                  <input name="radiomail" type="radio" value="0" <%if estado_mail="SIN AUDITAR" then Response.Write("checked") end if%> <%if estado_mail="" then response.Write("Disabled") end if%>>
                                  SA
                                  <input name="Submit" type="button" class="Estilo8" onClick="envia();" value="Auditar" <%if estado_mail="" then response.Write("Disabled") end if%>>
                              </td>
                              <td>| <a href="javascript:ventanaSecundaria('mas_correos.asp?rut=<%=rut_deudor%>')"> <acronym title="VER TODOS LOS CORREOS ELECTRONICOS DEL DEUDOR">M&Aacute;S</acronym></a> | <a href="javascript:ventanaSecundaria('nuevo_cor.asp?rut=<%=rut_deudor%>')"> <acronym title="INGRESAR UN NUEVO CORREO ELECTRONICO">NUEVO CORREO </acronym></a>
                                  <input name="correlativo_mail" type="hidden" id="correlativo_mail" value="<%=correlativo_deudor3%>">
                              </td>
                            </tr>
                          </table>
                          <%
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
                          <table width="100%" height="0%" border="0" bordercolor="#FFFFFF">
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
                              <td height="20"><%IF rsDEU("DESC_CLI")="VNE" THEN RESPONSE.Write("VESPUCIO NORTE EXPRESS") ELSE RESPONSE.Write(rsDEU("DESC_CLI"))%></td>
                              <td><acronym title="MODULO DE GESTI&Oacute;N PARA EL CLIENTE <%=rsDEU("DESC_CLI")%>"><a href="javascript:ventanaIngresoG('detalle_gestiones.asp?rut=<%=rut_deudor%>&cliente=<%=rsDEU("COD_CLI")%>&area_con=<%=area_con%>&fono_con=<%=fono_con%>')">MODULO DE GESTION</a></acronym></td>
                              <td><div align="right"><%=rsDEU("NUMDOC")%></div></td>
                              <td><div align="right">$
                                      <%if not isnull(rsDEU("MONTODOC")) then%>
                                      <%=(FN(CLNG(rsDEU("MONTODOC")),0))%>
                                      <%end if%>
                              </div></td>
                              <td><div align="right">

                              <div align="right"><acronym title="DETALLE DE LA DEUDA DEL DEUDOR <%=rut%> CON EL CLIENTE <%=rsDEU("DESC_CLI")%>">
                                <%if rsDEU("COD_CLI")="40" then%>
                                <a href="javascript:ventanaDetalle('detalle_deuda_acsa.asp?rut=<%=rut_deudor%>&cliente=<%=rsDEU("COD_CLI")%>')">VER
                                DETALLE DEUDA</a>
                                <%elseif rsDEU("COD_CLI")="41" then%>
                                <a href="javascript:ventanaDetalle('detalle_deuda_acsa_infra.asp?rut=<%=rut_deudor%>&cliente=<%=rsDEU("COD_CLI")%>')">VER
                                DETALLE DEUDA</a>
                                <%elseif rsDEU("COD_CLI")="45" then%>
                                <a href="javascript:ventanaDetalle('detalle_deuda_embonor.asp?rut=<%=rut_deudor%>&cliente=<%=rsDEU("COD_CLI")%>')">VER
                                DETALLE DEUDA</a>
								<%elseif rsDEU("COD_CLI")="31" then%>
                                <a href="javascript:ventanaDetalle('detalle_deuda_EMPRESA_cheque.asp?rut=<%=rut_deudor%>&cliente=<%=rsDEU("COD_CLI")%>')">VER
                                DETALLE DEUDA</a>
                                <%elseif rsDEU("COD_CLI")="8" then%>
                                <a href="javascript:ventanaDetalle('detalle_deuda_inp_cheque.asp?rut=<%=rut_deudor%>&cliente=<%=rsDEU("COD_CLI")%>')">VER
                                DETALLE DEUDA</a>
								<%elseif rsDEU("COD_CLI")="9" then%>
                                <a href="javascript:ventanaDetalle('detalle_deuda_EMPRESA_cheque.asp?rut=<%=rut_deudor%>&cliente=<%=rsDEU("COD_CLI")%>')">VER
                                DETALLE DEUDA</a>
                                <%elseif rsDEU("COD_CLI")="13" then%>
                                <a href="javascript:ventanaDetalle('detalle_deuda_ctcmundo.asp?rut=<%=rut_deudor%>&cliente=<%=rsDEU("COD_CLI")%>')">VER
                                DETALLE DEUDA</a>
                                <%elseif rsDEU("COD_CLI")="36" then%>
                                <a href="javascript:ventanaDetalle('detalle_deuda_dys.asp?rut=<%=rut_deudor%>&cliente=<%=rsDEU("COD_CLI")%>')">VER
                                DETALLE DEUDA</a>
                                <%elseif rsDEU("COD_CLI")="21" then%>
                                <a href="javascript:ventanaDetalle('detalle_deuda_ripley.asp?rut=<%=rut_deudor%>&cliente=<%=rsDEU("COD_CLI")%>')">VER
                                DETALLE DEUDA</a>
                                <%elseif rsDEU("COD_CLI")="6" then%>
                                <a href="javascript:ventanaDetalle('detalle_deuda_bellsouth.asp?rut=<%=rut_deudor%>&cliente=<%=rsDEU("COD_CLI")%>')">VER
                                DETALLE DEUDA</a>
                                <%elseif rsDEU("COD_CLI")="12" then%>
                                <a href="javascript:ventanaDetalle('detalle_deuda_121.asp?rut=<%=rut_deudor%>&cliente=<%=rsDEU("COD_CLI")%>')">VER
                                DETALLE DEUDA</a>
                                <%elseif rsDEU("COD_CLI")="14" then%>
                                <a href="javascript:ventanaDetalle('detalle_deuda_cencosud.asp?rut=<%=rut_deudor%>&cliente=<%=rsDEU("COD_CLI")%>')">VER
                                DETALLE DEUDA</a>
                                <%elseif rsDEU("COD_CLI")="18" then%>
                                <a href="javascript:ventanaDetalle('detalle_deuda_telcoy.asp?rut=<%=rut_deudor%>&cliente=<%=rsDEU("COD_CLI")%>')">VER
                                DETALLE DEUDA</a>
                                <%elseif rsDEU("COD_CLI")="11" or  rsDEU("COD_CLI")="15" then%>
                                <a href="javascript:ventanaDetalleTelefonicas('detalle_deuda_movistar.asp?rut=<%=rut_deudor%>&cliente=<%=rsDEU("COD_CLI")%>')">VER
                                DETALLE DEUDA</a>
								 <%elseif rsDEU("COD_CLI")="19" then%>
                                <a href="javascript:ventanaDetalleTelefonicas('detalle_deuda_vne_TAG.asp?rut=<%=rut_deudor%>&cliente=<%=rsDEU("COD_CLI")%>')">VER
                                DETALLE DEUDA</a>
                                <%elseif rsDEU("COD_CLI")="10"  then%>
                                <a href="javascript:ventanaDetalle('detalle_deuda_vne.asp?rut=<%=rut_deudor%>&cliente=<%=rsDEU("COD_CLI")%>')">VER
                                DETALLE DEUDA</a>
                                <%elseif rsDEU("COD_CLI")="5"  then%>
                                <a href="javascript:ventanaDetalle('detalle_deuda_vne_infra.asp?rut=<%=rut_deudor%>&cliente=<%=rsDEU("COD_CLI")%>')">VER
                                DETALLE DEUDA</a>
								<%elseif rsDEU("COD_CLI")="46"  then%>
                                <a href="javascript:ventanaDetalle('detalle_deuda_clinicarenaca.asp?rut=<%=rut_deudor%>&cliente=<%=rsDEU("COD_CLI")%>')">VER
                                DETALLE DEUDA</a>
								<%elseif rsDEU("COD_CLI")="48"  then%>
                                <a href="javascript:ventanaDetalle('detalle_deuda_mas_vida.asp?rut=<%=rut_deudor%>&cliente=<%=rsDEU("COD_CLI")%>')">VER
                                DETALLE DEUDA</a>
								<%elseif rsDEU("COD_CLI")="2"  then%>
                                <a href="javascript:ventanaDetalle('detalle_deuda_telmex.asp?rut=<%=rut_deudor%>&cliente=<%=rsDEU("COD_CLI")%>')">VER
                                DETALLE DEUDA</a>
                                <%else%>
                                <a href="javascript:ventanaDetalle('detalle_deuda.asp?rut=<%=rut_deudor%>&cliente=<%=rsDEU("COD_CLI")%>')">VER
                                DETALLE DEUDA</a>
                                <%end if%>
                                </acronym></div>
                                <acronym title="DETALLE DE LA DEUDA DEL DEUDOR <%=rut%> CON EL CLIENTE <%=rsDEU("DESC_CLI")%>">                              </acronym></div></td>
                              <td><div align="right">
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
                  </div></td>
                            </tr>
                            <%
					if not isnull(rsDEU("MONTODOC")) then
					monto=monto + clng(rsDEU("MONTODOC"))
					end if
			 rsDEU.movenext
			 loop
			  %>
		<%end if
	  	rsDEU.close
	  	set rsDEU=nothing
		cerrarSCG()

		end if
		end if
		end if
		%>
</table>
	</td>
                    </tr>
                </table></td>
            </tr>
          </table>
        </div></td>
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

function Predictivo() {
window.open("http://icarus/especializa/proyecto/cobrador/Buscador.asp","Predictivos","width=720, height=400, scrollbars=yes, menubar=no, location=no, resizable=no")
}

function Sms() {
window.open("http://icarus/especializa/proyecto/cobrador/Buscador_sms.asp","Sms","width=720, height=400, scrollbars=yes, menubar=no, location=no, resizable=no")
}

</script>
