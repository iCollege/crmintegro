<% @LCID = 1034 %>
<!--#include file="arch_utils.asp"-->
<!--#include file="lib.asp"-->
<!--#include file="sesion.asp"-->
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
<title>BACKOFFICE SCG</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
</head>
<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<form name="datos" id="datos" method="post">
<%


rut= TRIM(cstr(request.Form("rut_")))
if cstr(rut)="" then
rut = TRIM(cstr(request.Form("rut")))
	if rut="" then
	rut = request.QueryString("rut")
	end if
end if

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

'response.write ("existe=")
'response.write existe

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
              <td height="431" colspan="3"><p align="right" class="Estilo37">Usuario: <%=UCASE(session("nombre_user"))%>
                  <table width="100%" height="335" border="0">
                    <tr>
                      <td height="331" valign="top" background=""><table width="100%" border="0">
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
                              <input name="li_" type="button" onClick="window.navigate('scg_cheq.asp');" value="Limpiar">
                              </acronym>&nbsp;&nbsp; <acronym title="IMPRIMIR FORMULARIO (CONFIGURACION HORIZONTAL)">
                              <input name="li_" type="button" onClick="window.print();" value="Imprimir">
                              </acronym>
                              <input name="rutf" type="hidden" id="rutf" value="<%=rut%>">
                            <span class="Estilo38">                            </span></td>
                          </tr>
                         <% if existe = "no"  then %>
						  <tr>
						  	<td>

							<strong>!!!NO SE ENCONTRO EL RUT¡¡¡ Favor ingresar Nombre</strong>

							</td>
						  </tr>

						  <tr>
						  	<td>
						  	NOMBRE :&nbsp;&nbsp;<acronym title="INGRESE NOMBRE"><input name="nombre" type="text" id="nombre" value="" size="50" maxlength="50"></acronym>&nbsp;&nbsp;<select name="cliente" id="cliente">
            <option value="0">SELECCIONE</option>
		    <%
		abrirscg()
		ssql="SELECT cast(codcliente as int) as codigo_cliente,razon_social " &_
		     "FROM CLIENTE order by razon_social asc"
		set rscli= Conn.execute(ssql)
		 do until rscli.eof%>
		    <option value="<%=rscli("codigo_cliente")%>"><%=rscli("razon_social")%></option>
		    <%
		  rscli.movenext
		  loop
		  rscli.close
		  set rscli=nothing
		  cerrarscg()
		  %>
        </select>&nbsp;&nbsp;<input name="gr" type="button" id="gr" onclick="graba();" value="Grabar">
							</td>
						  </tr>
						  <% end if %>


						  <tr>
						    <td bgcolor="#FFFFFF">
					          <div align="right">

					            </td>

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
		ssql="select isnull(sum(saldo),0) as saldo from cuota where rutdeudor='"&rut_deudor&"'"
		set rsSALDO=Conn.execute(ssql)
		if not rsSALDO.eof then
			saldo = rsSALDO("saldo")
				if saldo>"0" then
				estado_saldo="ACTIVO"
				else
				estado_saldo="SIN DEUDA"
				end if
		else
			saldo = 0
		end if
		rsSALDO.close
		set rsSALDO=nothing
		cerrarSCG()
		%>

                          <%if not rut_deudor=""  then%>
                          <img src="../lib/DATOS_DEUDOR.gif" width="740" height="22"><BR>
                          <table width="100%" border="0" bordercolor="#FFFFFF">
                            	<tr bordercolor="#999999"  bgcolor="black" class="Estilo13">
                              		<td width="18%" bgcolor="black">RUT</td>
                              		<td width="38%">NOMBRE O RAZ&Oacute;N SOCIAL</td>
							   	</tr>
                            	<tr bgcolor="#<%=session("COLTABBG2")%>" class="Estilo8">
                             		<td><%=rut_deudor%></td>
                              		<td><%=nombre_deudor%></td>
							  	</tr>
                          </table>
                          <img src="../lib/DATOS_UBICA.gif" width="740" height="22">
                          <table width="100%" border="0" bordercolor="#FFFFFF">
                           	 <tr bordercolor="#999999" bgcolor="black" class="Estilo13">
                              	<td width="46%">DIRECCI&Oacute;N M&Aacute;S RECIENTE </td>
                              	<td width="28%">ESTADO DIRECCION</td>
                              	<td width="26%">OTRAS DIRECCIONES </td>
                             </tr>
                             <tr class="Estilo8">
                              	<td><%=calle_deudor%>&nbsp;<%=numero_deudor%> &nbsp;<span class="Estilo36"><%=resto_deudor%></span> &nbsp;<strong><%=comuna_deudor%></strong> </td>
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
                             <tr bgcolor="black" class="Estilo8">
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
                              <tr bgcolor="black" class="Estilo8">
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
							  <tr bgcolor="black" class="Estilo8">
                              	<td><span class="Estilo30">DEUDA RECIENTE </span></td>
                              	<td><span class="Estilo30">ESTADO DEUDOR </span></td>
                              	<td><span class="Estilo30">OTROS DEUDAS </span></td>
                              </tr>
                              <tr class="Estilo8">
                              	<td>$<%=FN(saldo,0)%></td>
                              	<td><%=estado_saldo%></td>
                              	<td>| <a href="scg_web.asp"> <acronym title="VER TODOS LAS DEUDAS DEL DEUDOR">M&Aacute;S</acronym></a> | <a href="javascript:ventanaSecundaria('nueva_deuda_bbva.asp?rut=<%=rut_deudor%>')"> <acronym title="INGRESAR UNA NUEVA DEUDA">NUEVA MORA</acronym></a>

                              	</td>
                              </tr>
                          </table>



						 <%
						 else


						 end if
						 end if
						 end if
						 %>



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
function graba(){
if(datos.nombre.value==''){
alert('DEBE INGRESAR UN NOMBRE');
}else if(datos.cliente.value=='0'){
alert('DEBE INGRESAR UN CLIENTE');
}else if(datos.rut.value==''){
alert('DEBE INGRESAR UN rut');
}else{
datos.action='graba_deudor.asp';
datos.submit();
}
}
function envia(){
datos.action='scg_cheq.asp';
datos.submit();
}
function ventanaSecundaria (URL){
window.open(URL,"INFORMACION","width=800, height=400, scrollbars=yes, menubar=no, location=no, resizable=yes")
}
</script>
