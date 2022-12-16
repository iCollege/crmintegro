<% @LCID = 1034 %>
<html>
<!--#include file="arch_utils.asp"-->
<!--#include file="lib.asp"-->
<!--#include file="sesion.asp"-->
<!--#include file="../lib/comunes/rutinas/funciones.inc" -->
<!--#include file="../lib/comunes/rutinas/TraeCampo.inc" -->

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

	lenani = Instr(Trim(request.QueryString("ani")),",")
	If lenani <> 0 Then
		lenani = lenani + 3
	Else
		lenani = 1
	End if
	ani = Mid(Trim(request.QueryString("ani")),lenani,len(Trim(request.QueryString("ani"))))

	AbrirSCG()
		strEnPantallaPpal = TraeCampoId(Conn, "DETALLE_ENPPPAL", 1, "PARAMETRO_SISTEMA", "ID")
	CerrarSCG()

%>

	<table width="793" border="1" align="center" cellpadding="0" cellspacing="0">
	<tr>
        <td colspan="2 align="right">
          <table width="100%" border="0" cellpadding="0" cellspacing="0" bgcolor="#FFFFFF">
            <script type="text/javascript" language="JavaScript1.2" src="frameset/stm31.js"></script>
            <tr valign=TOP>
              <td height="43" colspan="3" align="center"><img src="../system/top.jpg" width="720" height="48"></td>
            </tr>
            <tr valign=TOP>
              <td colspan="3">
              <p align="right" class="Estilo37">Usuario: <%=UCASE(session("nombre_user"))%> |
              <a href="cartera_asignada.asp">MI CARTERA</A> |
              <a href="javascript:ventanaMisGestiones('mis_gestiones.asp?codcob=<%=LTRIM(RTRIM(session("session_login")))%>')"><acronym title="GESTIONES PRODUCIDAS POR <%=session("nombre_user")%>">MIS GESTIONES</acronym></a> |
              <!--a href="javascript:ventanaDetalle('enmantencion.asp')">MI RECUPERACI&Oacute;N</a-->
              <a href="mi_recupero.asp">MI RECUPERACI&Oacute;N</a> |
              <a href="mis_pagos.asp">MIS PAGOS</a> |
              <a href="scg_ingreso.asp?intNuevo=1&strRutDeudor=<%=rut%>">NUEVA DEUDA</a> |
              <a href="busqueda.asp">B&Uacute;SQUEDA DEUDOR </a> |
		      <a href="cbdd02.asp"> <acronym title="SALIR DEL SISTEMA">CERRAR SESI&Oacute;N</acronym></a>
		          <table width="100%" height="335" border="0">
                    <tr>
                      <td height="331" valign="top" background="../images/fondo_coventa1111.jpg">
                      <table width="100%" border="0">
                          <tr>
                            <td>
								<table width="100%" border="1" bordercolor="#FFFFFF">
									<tr>
										<TD height="20" ALIGN=LEFT class="pasos2_i">
											<B>RUT DEL DEUDOR</B>
											<font size="-7"> &nbsp(sin puntos , con digito verificador)</FONT>
										</TD>
										<TD height="20">

										</TD>
									</tr>
								</table>
                            </td>
                          </tr>
                          <tr>
                            <td><acronym title="RUT EN FORMATO SIN PUNTOS EJ: 11111111-1">
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
                          <tr>
                          <%if not ani="" then%>
                            <td bgcolor="#FFFFFF" align="right">
					            <%
								if len(ani)=7 then
									area_con = "2"
									fono_con = ani
								else
									if mid(ani,1,3)="122" or mid(ani,1,3)="171" then
										ani = mid(ani,4, len(ani)-3)
									end if
									if mid(ani,1,1)="0" then
										fono_con = mid(ani,2,len(ani)-1)
										area_con = mid(fono_con,1,1)
										fono_con = mid(fono_con,2,len(ani)-1)
									elseif mid(ani,1,1)="2" then
										area_con = "2"
										fono_con = mid(ani,2,len(ani)-1)
									else
										area_con = mid(ani,1,2)
										fono_con = mid(ani,3,len(ani)-2)
									end if
								end if
								Session("AreaDiscada") = area_con
								Session("NumeroDiscado") = fono_con

							%>
					            DISCADOR AUTOM&Aacute;TICO - DEUDOR CONTACTADO EN FONO : <%=area_con%> - <%=fono_con%></td>

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

				if not rut_deudor=""  then%>
				<table width="100%" border="1" bordercolor="#FFFFFF">
					<tr>
						<TD height="20" ALIGN=LEFT class="pasos1_i">
							<B>INFORMACIÓN DEL DEUDOR</B>
						</TD>
					</tr>
				</table>
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
				<table width="100%" border="1" bordercolor="#FFFFFF">
					<tr>
						<TD height="20" ALIGN=LEFT class="pasos1_i">
							<B>INFORMACIÓN DE UBICABILIDAD</B>
						</TD>
					</tr>
				</table>
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


				<table width="100%" border="1" bordercolor="#FFFFFF">
				<tr>
					<TD height="20" ALIGN=LEFT class="pasos1_i">
						<B>ULTIMA GESTIÓN</B>
					</TD>
				</tr>
				</table>
				 <table width="100%" border="1" bordercolor="#FFFFFF">
					<tr bordercolor="#FFFFFF" bgcolor="#<%=session("COLTABBG")%>" class="Estilo13">
					  <td width="15%" class="Estilo4">FECHA GESTION</td>
					  <td width="12%" class="Estilo4">GESTION</td>
					  <td width="17%" class="Estilo4">COMPROMISO</td>
					  <td width="45%" class="Estilo4">OBSERVACIONES</td>
					  <td width="11%" class="Estilo4">FONO</td>
					  <td width="11%" class="Estilo4">COBRADOR</td>
					  </tr>
					<%
						strSql = "select top 1 CodSubCategoria, CodCategoria, CodGestion, fechaIngreso,codcobrador,fechacompromiso,horaingreso, observaciones, telefono_asociado "
						strSql=strSql + "from gestiones "
						strSql=strSql + "where rutdeudor= '"&rut&"'"
						strSql=strSql + "order by FechaIngreso desc,HoraIngreso desc"

						Response.Write "strSql= " & strSql

					AbrirSCG()
					set rsUltGest=Conn.execute(strSql)
	  				If not rsUltGest.eof then

	  				Response.Write "HOLA"

					Obs=UCASE(LTRIM(RTRIM(rsUltGest("Observaciones"))))
					If Obs="" then
						Obs="SIN INFORMACION ADICIONAL"
					End if
					%>
					<tr bordercolor="#FFFFFF" class="Estilo8">
					  <td class="Estilo4"><%=rsUltGest("FechaIngreso")%></td>
					  <td class="Estilo4"><a href= "javascript:ventanaSecundaria('gestion.asp?categoria=<%=rsUltGest("CodCategoria")%>&subcategoria=<%=rsUltGest("CodSubCategoria")%>&gestion=<%=rsUltGest("CodGestion")%>')">VER</a>&nbsp;&nbsp;<%=rsUltGest("CodCategoria")%><%=rsUltGest("CodSubCategoria")%><%=rsUltGest("CodGestion")%></td>
					  <td class="Estilo4"><%=rsUltGest("FechaCompromiso")%></td>
					  <td class="Estilo4"><%=Mid(Obs,1,45)%></td>
					  <td class="Estilo4"><%=rsUltGest("telefono_asociado")%></td>
					  <td class="Estilo4"><%=UCASE(rsUltGest("CodCobrador"))%></td>
					</tr>
					 <%
					 End If
					 CerrarSCG()
					 %>
      			</table>
				<%
				AbrirSCG()
				ssql=""
				ssql="SELECT COUNT(CUOTA.NRODOC) AS NUMDOC,SUM(CUOTA.SALDO) AS MONTODOC, CLIENTE.CODCLIENTE, CLIENTE.DESCRIPCION AS DESCRIPCION FROM CUOTA,CLIENTE "
				ssql= ssql & "WHERE CUOTA.CODCLIENTE=CLIENTE.CODCLIENTE AND CUOTA.RUTDEUDOR='"&rut_deudor&"'"
				ssql= ssql & "GROUP BY CUOTA.CODCLIENTE,CLIENTE.CODCLIENTE,CLIENTE.DESCRIPCION"
				set rsDEU=Conn.execute(ssql)
				if not rsDEU.eof then
				monto=0
				%>
					<table width="100%" border="1" bordercolor="#FFFFFF">
						<tr>
							<TD height="20" ALIGN=LEFT class="pasos1_i">
								<B>INFORMACIÓN DE DEUDAS</B>
							</TD>
						</tr>
					</table>
				  <table width="100%" border="1" bordercolor="#FFFFFF">
					<tr bordercolor="#999999" bgcolor="#<%=session("COLTABBG")%>" class="Estilo13">
					  <td width="24%">CLIENTE</td>
					  <td width="16%">GESTIONES</td>
					  <td width="10%">DOCS</td>
					  <td width="13%">MONTO</td>
					  <td width="26%">DETALLE DE DEUDAS </td>
					  <td width="11%">EJECUTIVO</td>
					</tr>
					<%Do until rsDEU.eof%>
					<tr>
					  <td height="20"><%IF rsDEU("DESCRIPCION")="VNE" THEN RESPONSE.Write("VESPUCIO NORTE EXPRESS") ELSE RESPONSE.Write(rsDEU("DESCRIPCION"))%></td>
					  <td><acronym title="MODULO DE GESTI&Oacute;N PARA EL CLIENTE <%=rsDEU("DESCRIPCION")%>"><a href="javascript:ventanaIngresoG('detalle_gestiones.asp?rut=<%=rut_deudor%>&cliente=<%=rsDEU("CODCLIENTE")%>&area_con=<%=area_con%>&fono_con=<%=fono_con%>')">MODULO DE GESTION</a></acronym></td>
					  <td align="right"><%=rsDEU("NUMDOC")%></td>
					  <td align="right">$
							  <%if not isnull(rsDEU("MONTODOC")) then%>
							  <%=(FN(CLNG(rsDEU("MONTODOC")),0))%>
							  <%end if%>

					  </td>
					  <td align="right"><acronym title="DETALLE DE LA DEUDA DEL DEUDOR <%=rut%> CON EL CLIENTE <%=rsDEU("DESCRIPCION")%>">
						<%if rsDEU("CODCLIENTE")="10001" then%>
							<a href="javascript:ventanaDetalle('detalle_deuda_BBVA.asp?rut=<%=rut_deudor%>&cliente=<%=rsDEU("CODCLIENTE")%>')">VER
							DETALLE DEUDA</a>
						<%else%>
							<a href="javascript:ventanaDetalle('detalle_deuda.asp?rut=<%=rut_deudor%>&cliente=<%=rsDEU("CODCLIENTE")%>')">VER
							DETALLE DEUDA</a>
						<%end if%>
						</acronym>
						<acronym title="DETALLE DE LA DEUDA DEL DEUDOR <%=rut%> CON EL CLIENTE <%=rsDEU("DESCRIPCION")%>">                              </acronym></td>
					  <td align="right">
						  <%
							sej="SELECT TOP 1 ISNULL(USUARIO_ASIG,0) as USUARIO_ASIG FROM CUOTA WHERE RUTDEUDOR='"&rut_deudor&"' AND CODCLIENTE='"&rsDEU("CODCLIENTE")&"'"
							set rsEJ=Conn.execute(sej)
							if not rsEJ.eof then strCob = TraeCampoId(Conn, "LOGIN", rsEJ("USUARIO_ASIG"), "USUARIO", "ID_USUARIO") else strCob = "SIN EJECUTIVO" end if
							rsEJ.close
							set rsEJ=nothing
						%>
						<%=strCob%>
						</td>
					</tr>
					<%
						if not isnull(rsDEU("MONTODOC")) then
							monto=monto + clng(rsDEU("MONTODOC"))
						end if
					 rsDEU.movenext
					 Loop
					 %>
					 </table>
					 <%
				  end if
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
                </table>
                </td>
            </tr>
          </table>

        </td>
    </tr>

</table>


<%
AbrirSCG()
ssql=""
ssql="SELECT CLIENTE.CODCLIENTE, CLIENTE.DESCRIPCION AS DESCRIPCION FROM CUOTA,CLIENTE "
ssql= ssql & "WHERE CUOTA.CODCLIENTE=CLIENTE.CODCLIENTE AND CUOTA.RUTDEUDOR='"&rut_deudor&"'"
ssql= ssql & "GROUP BY CUOTA.CODCLIENTE,CLIENTE.CODCLIENTE,CLIENTE.DESCRIPCION"
set rsClienteDeuda=Conn.execute(ssql)
Do While not rsClienteDeuda.eof
cliente=rsClienteDeuda("CODCLIENTE")
nombre_cliente=rsClienteDeuda("DESCRIPCION")

%>



<table width="793" border="0" ALIGN="CENTER">
  <tr>
    <TD height="30" ALIGN=LEFT class="pasos">
		<B>Detalle Deuda&nbsp&nbsp&nbsp&nbsp<%=nombre_cliente%></B>
	</TD>
  </tr>
  <tr>
    <td valign="top">
	<%
	if not rut="" then
	abrirscg()
	ssql=""
	ssql="SELECT IsNull(FECHAVENC,'01/01/1900') as FECHAVENC,NRODOC,IsNull(VIGENTE,0) as VIGENTE, IsNull(VALORCUOTA,0) as VALORCUOTA,IsNull(SALDO,0) as SALDO,isnull(GASTOSCOBRANZAS,0) as GASTOSCOBRANZAS,IsNull(USUARIO_ASIG,0) as USUARIO_ASIG,NROCUOTA, VIGENTE, MORA, VENCIDA, CASTIGO, CENTRO_COSTO, SUCURSAL , ESTADO_DEUDA, CODREMESA FROM CUOTA WHERE RUTDEUDOR='"&rut&"' AND CODCLIENTE='"&cliente&"'"
		'response.Write(ssql)
		'response.End()
		set rsDET=Conn.execute(ssql)
		if not rsDET.eof then
		%>
		  <table width="100%" border="0" bordercolor="#FFFFFF">
	        <tr bordercolor="#999999" bgcolor="#<%=session("COLTABBG")%>" class="Estilo13">
	          <td width="8%">NUM.CLIENTE</td>
	          <!--td width="8%">PRODUCTO</td-->
	          <td width="12%">VIGENTE</td>
	          <td width="12%">MORA</td>
	          <td width="12%">VENCIDA</td>
	          <td width="12%">CASTIGO</td>
	          <td width="12%">SALDO</td>
	          <td width="12%">COBRADOR</td>
	          <td width="12%">C.COSTO</td>
	          <td width="6%">OTROS</td>

	        </tr>
			<%

			do until rsDET.eof
			intSaldo = ValNulo(rsDET("MORA"),"N") + ValNulo(rsDET("VENCIDA"),"N") + ValNulo(rsDET("CASTIGO"),"N")
			strNroDoc = Trim(rsDET("NRODOC"))
			strNroCuota = Trim(rsDET("NROCUOTA"))
			strSucursal = Trim(rsDET("SUCURSAL"))
			strEstadoDeuda = Trim(rsDET("ESTADO_DEUDA"))
			strCodRemesa = Trim(rsDET("CODREMESA"))

			%>
	        <tr bordercolor="#999999" >
	          <td>N&ordm; <%=rsDET("NRODOC")%></td>
	          <!--td><div align="left">&nbsp</div></td-->
	          <td><div align="right">$ <%=FN(rsDET("VIGENTE"),0)%></div></td>
	          <td><div align="right">$ <%=FN(rsDET("MORA"),0)%></div></td>
	          <td><div align="right">$ <%=FN(rsDET("VENCIDA"),0)%></div></td>
	          <td><div align="right">$ <%=FN(rsDET("CASTIGO"),0)%></div></td>
	          <td align="right" >$ <%=FN((intSaldo),0)%></td>
	          <td align="right" >
	          <%If Not rsDET("USUARIO_ASIG")="0" Then %>
			  	<%=TraeCampoId(Conn, "LOGIN", rsDET("USUARIO_ASIG"), "USUARIO", "ID_USUARIO")%>
			  <%else%>
			  	<%="SIN COB"%>
			  <%End If%>
			  </td>
			  <td align="right"><%=rsDET("CENTRO_COSTO")%></td>
			  <td><a href="javascript:ventanaMas('mas_datos_deuda_bbva.asp?nrodoc=<%=trim(rsDET("NRODOC"))%>&cliente=<%=cliente%>&strNroDoc=<%=strNroDoc%>&strNroCuota=<%=strNroCuota%>&strSucursal=<%=strSucursal%>&strCodRemesa=<%=strCodRemesa%>')">VER</a></td>

			 <%
				total_vigente= total_vigente + clng(rsDET("VIGENTE"))
				total_mora = total_mora + clng(rsDET("MORA"))
				total_vencida = total_vencida + clng(rsDET("VENCIDA"))
				total_castigo = total_castigo + clng(rsDET("CASTIGO"))
				total_saldo = total_saldo + clng(intSaldo)
				total_gc = total_gc + clng(rsDET("GASTOSCOBRANZAS"))
				total_docs = total_docs + 1
			 %>
			 </tr>
			 <%rsDET.movenext
			 loop
			 %>
			<tr>
				<td bgcolor="#<%=session("COLTABBG")%>"><span class="Estilo13">Docs : <%=total_docs%></span></td>
				<!--td bgcolor="#<%=session("COLTABBG")%>"><span class="Estilo13"></span></td-->
				<td bgcolor="#<%=session("COLTABBG2")%>"><div align="right"><span class="Estilo28">$ <%=FN(total_vigente,0)%></span></div></td>
				<td bgcolor="#<%=session("COLTABBG2")%>"><div align="right"><span class="Estilo27">$ <%=FN(total_mora,0)%></span></div></td>
				<td bgcolor="#<%=session("COLTABBG2")%>"><div align="right"><span class="Estilo27">$ <%=FN(total_vencida,0)%></span></div></td>
				<td bgcolor="#<%=session("COLTABBG2")%>"><div align="right"><span class="Estilo27">$ <%=FN(total_castigo,0)%></span></div></td>
				<td bgcolor="#<%=session("COLTABBG2")%>"><div align="right"><span class="Estilo28">$ <%=FN(total_saldo,0)%></span></div></td>
				<td bgcolor="#<%=session("COLTABBG2")%>"><div align="right"><span class="Estilo28"></span></div></td>
				<td bgcolor="#<%=session("COLTABBG2")%>"><div align="right"><span class="Estilo28"></span></div></td>
				<td bgcolor="#<%=session("COLTABBG2")%>"><div align="right"><span class="Estilo28"></span></div></td>
			</tr>

	      </table>
		  <%end if
		  rsDET.close
		  set rsDET=nothing

	  %>
	  <%end if%>
    </td>
  </tr>
  <tr>
<td ALIGN="center">
<input name="imp" type="button" onClick="window.print();" value="Imprimir Ficha">
</td>
</tr>
</table>

<%
	rsClienteDeuda.Movenext
Loop
cerrarSCG()
%>


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
window.open(URL,"MISGESTIONES","width=800, height=600, scrollbars=yes, menubar=no, location=no, resizable=yes")
}

function ventanaPagos (URL){
window.open(URL,"PAGOS","width=720, height=400, scrollbars=yes, menubar=no, location=no, resizable=no")
}

function Predictivo() {
window.open("http://192.168.1.249/especializa/proyecto/cobrador/Buscador.asp","Predictivos","width=720, height=400, scrollbars=yes, menubar=no, location=no, resizable=no")
}

function Sms() {
window.open("http://192.168.1.249/especializa/proyecto/cobrador/Buscador_sms.asp","Sms","width=720, height=400, scrollbars=yes, menubar=no, location=no, resizable=no")
}

function ventanaMas (URL){
window.open(URL,"DATOS","width=200, height=300, scrollbars=no, menubar=no, location=no, resizable=yes")
}
</script>


