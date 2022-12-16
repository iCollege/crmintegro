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

intNuevo = Request("intNuevo")
''Response.write "intNuevo=" & intNuevo
rut = TRIM(request("rut"))
strCodCliente = TRIM(request("CB_CLIENTE"))
If Trim(rut) = "" Then
	rut=Request("strRutDeudor")
End if

AbrirSCG()
	ssql="SELECT TOP 1 NOMBREDEUDOR,RUTDEUDOR, REPLEG_RUT, REPLEG_NOMBRE FROM DEUDOR WHERE RUTDEUDOR='" & rut & "' AND NOMBREDEUDOR IS NOT NULL AND LTRIM(RTRIM(NOMBREDEUDOR)) <> '' AND CODCLIENTE = '" & strCodCliente & "'"
	''Response.write ssql
	set rsDEU=Conn.execute(ssql)
	if not rsDEU.eof then
		nombre_deudor = rsDEU("NOMBREDEUDOR")
		rut_deudor = rsDEU("RUTDEUDOR")
		strRutRL = rsDEU("REPLEG_RUT")
		strNombreRL = rsDEU("REPLEG_NOMBRE")
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
<table width="100%" border="1" bordercolor="#FFFFFF">
	<tr>
		<TD height="20" ALIGN=LEFT class="pasos2_i">
			<B>NUEVO CLIENTE - DEUDA</B>
		</TD>
	</tr>
</table>

	<table width="793" border="0" align="center" cellpadding="0" cellspacing="0">
	<tr>
        <td colspan="2"><div align="right">
          <table width="100%" height="568" border="0" cellpadding="0" cellspacing="0" bgcolor="#FFFFFF">
            <tr valign=TOP>
              <td height="431" colspan="3">
                  <table width="100%" height="335" border="0">
                    <tr>
                      <td height="331" valign="top" background="">
                      <table width="100%" border="0">
                          <tr>
                            <td class="Estilo13" colspan=3>
                            <img src="../lib/RUT_DEUDOR.gif" width="740" height="22">
                            </td>
                          </tr>

                          <tr>
                            <td>
                            	<acronym title="RUT EN FORMATO SIN PUNTOS EJ: 10111222-3">
                              <input name="rut" type="text" id="rut" value="<%=rut%>" size="10" maxlength="10">
                             </td>
                             <td>
								<select name="CB_CLIENTE" id="CB_CLIENTE">
								<option value="0">SELECCIONE</option>
								<%
								abrirscg()
								strSql="SELECT CAST(CODCLIENTE AS INT) AS CODIGO_CLIENTE,RAZON_SOCIAL FROM CLIENTE WHERE ACTIVO = 1 ORDER BY RAZON_SOCIAL ASC"
								set rscli= Conn.execute(strSql)
								Do until rscli.eof%>
									<option value="<%=rscli("CODIGO_CLIENTE")%>"<%if strCodCliente=Trim(rscli("CODIGO_CLIENTE")) then response.Write("SELECTED") End If%>><%=rscli("RAZON_SOCIAL")%></option>
									<%
									rscli.movenext
								Loop
								rscli.close
								set rscli=nothing
								cerrarscg()
								%>
								</select>
							</td>

							<td>
                              </acronym>&nbsp;&nbsp; <acronym title="DESPLEGAR DATOS DEL DEUDOR ASOCIADO AL RUT DE B&Uacute;SQUEDA">
                              <input name="me_" type="button" id="me_" onClick="envia();" value="Buscar">
                              </acronym>&nbsp;&nbsp; <acronym title="LIMPIAR FORMULARIO">
                              <input name="li_" type="button" onClick="window.navigate('scg_ingreso.asp');" value="Limpiar">
                              </acronym>&nbsp;&nbsp; <acronym title="IMPRIMIR FORMULARIO (CONFIGURACION HORIZONTAL)">
                              <input name="li_" type="button" onClick="window.print();" value="Imprimir">
                              </acronym>
                              <input name="rutf" type="hidden" id="rutf" value="<%=rut%>">

                           </td>
                          </tr>
                        </table>
                        <% if existe = "no" and intNuevo <> "1" then %>

						<table width="100%" border="0">
						  <tr>
							<td>
								<strong>NO SE ENCONTRO EL RUT ASOCIADO AL CLIENTE SELECCIONADO</strong>
							</td>
						  </tr>
						  <tr>
						  	<td>
								<table width="100%" border="0">
								<tr bordercolor="#999999"  bgcolor="#<%=session("COLTABBG")%>" class="Estilo13">
						  			<td>CLIENTE</td>
						  			<td>NOMBRE O RAZON SOCIAL</td>
									<td>APELLIDOS</td>
									<td>&nbsp</td>
								</tr>
								<tr>
									<td>
										<%
										abrirscg()
										strSql="SELECT CAST(CODCLIENTE AS INT) AS CODIGO_CLIENTE,RAZON_SOCIAL FROM CLIENTE WHERE CODCLIENTE = '" & strCodCliente & "' AND ACTIVO = 1 ORDER BY RAZON_SOCIAL ASC"
										set rscli= Conn.execute(strSql)
										If Not rscli.eof Then
											strNomCLiente=rscli("RAZON_SOCIAL")
										End If
										rscli.close
										set rscli=nothing
										cerrarscg()
										%>
										<%=strNomCLiente%>
									</td>
									<td>
										<acronym title="INGRESE NOMBRE"><input name="TX_NOMBRES" type="text" value="" size="45" maxlength="50"></acronym>
									</td>
									<td>
										<acronym title="INGRESE APELLIDO"><input name="TX_APELLIDOS" type="text" value="" size="30" maxlength="50"></acronym>&nbsp;&nbsp;
									</td>


									<td>
										<input name="gr" type="button" id="gr" onclick="graba();" value="Grabar">
									</td>
						  		</tr>
								<tr bordercolor="#999999"  bgcolor="#<%=session("COLTABBG")%>" class="Estilo13">
									<td>TIPO PERSONA</td>
									<td>NOMBRE REP. LEGAL</td>
									<td>RUT REP. LEGAL</td>
									<td>&nbsp</td>
								</tr>
								<tr>
									<td>
									<select name="CB_TIPO" id="cliente">
										<option value="0">SELECCIONE</option>
										<option value="N">NATURAL</option>
										<option value="J">JURIDICA</option>
									</select>

									</td>
									<td>
										<acronym title="INGRESE NOMBRE DEL REPRESENTANTE LEGAL"><input name="TX_NOMBRE_REPLEGAL" type="text" value="" size="45" maxlength="50"></acronym>
									</td>
									<td>
										<acronym title="INGRESE RUT DEL REPRESENTANTE LEGAL"><input name="TX_RUT_REPLEGAL" type="text" value="" size="20" maxlength="50"></acronym>&nbsp;&nbsp;
									</td>
									<td>&nbsp</td>
								</tr>
								</table>
							</td>
						  </tr>
					    </table>
					     <% end if %>
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
			strDirDeudor = calle_deudor & " " & numero_deudor & " " & resto_deudor & " " & comuna_deudor

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
		ssql="select isnull(sum(saldo),0) as saldo from cuota where rutdeudor='" & rut_deudor & "' AND CODCLIENTE = '" & session("ses_codcli") & "'"

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

		  If not rut_deudor=""  then
		  If trim(strDirDeudor) = "" Then strDirDeudor = "SIN INFORMACIÓN"
		  %>
		  <img src="../lib/DATOS_DEUDOR.gif" width="740" height="22"><BR>
		  <table width="100%" border="0" bordercolor="#FFFFFF">
				<tr bordercolor="#999999"  bgcolor="#<%=session("COLTABBG")%>" class="Estilo13">
					<td width="10%" bgcolor="#<%=session("COLTABBG")%>">RUT</td>
					<td width="40%">NOMBRE O RAZ&Oacute;N SOCIAL</td>
					<td width="10%" bgcolor="#<%=session("COLTABBG")%>">RUT REP.LEGAL</td>
					<td width="40%">NOMBRE RUT REP.LEGAL</td>
				</tr>
				<tr bgcolor="#<%=session("COLTABBG2")%>" class="Estilo8">
					<td><%=rut_deudor%></td>
					<td><%=nombre_deudor%></td>
					<td><%=strRUTRL%></td>
					<td><%=strNombreRL%></td>
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
				<td><%=strDirDeudor%></strong> </td>
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
			 <tr bordercolor="#999999" bgcolor="#<%=session("COLTABBG")%>" class="Estilo13">
				<td>TELEFONO M&Aacute;S RECIENTE</td>
				<td>ESTADO TEL&Eacute;FONO </td>
				<td>OTROS TELEFONOS </td>
				</tr>
			 <tr class="Estilo8">
				<td>
				<%
				strTelefono = codarea_deudor & " - " & telefono_deudor
				If Trim(strTelefono) = "-" Then strTelefono = "SIN INFORMACIÓN"
				%>
				<%=strTelefono%>
				</td>
				<td>
					<input name="radiofon" type="radio" value="1" <%if estado_fono="VALIDO" then Response.Write("checked") end if%> <%if estado_fono="" then response.Write("Disabled") end if%>>
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
			  <tr bordercolor="#999999" bgcolor="#<%=session("COLTABBG")%>" class="Estilo13">
				<td>CORREO ELECTR&Oacute;NICO M&Aacute;S RECIENTE </td>
				<td>ESTADO CORREO ELECTR&Oacute;NICO </td>
				<td>OTROS CORREOS ELECTR&Oacute;NICOS </td>
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
			  <tr bordercolor="#999999" bgcolor="#<%=session("COLTABBG")%>" class="Estilo13">
				<td>DEUDA RECIENTE </td>
				<td>ESTADO DEUDOR </td>
				<td>OTROS DEUDAS </td>
			  </tr>
			  <tr class="Estilo8">
				<td>$<%=FN(saldo,0)%></td>
				<td><%=estado_saldo%></td>
				<td>| <a href="principal.asp?rut=<%=rut_deudor%>"> <acronym title="VER TODOS LAS DEUDAS DEL DEUDOR">M&Aacute;S</acronym></a> |
				<!--a href="javascript:ventanaSecundaria('nueva_deuda_bbva.asp?rut=<%=rut_deudor%>')"> <acronym title="INGRESAR UNA NUEVA DEUDA">NUEVA MORA</acronym></a-->
				<a href="nueva_deuda_gral.asp?rut=<%=rut_deudor%>&cliente=<%=strCodCliente%>"> <acronym title="INGRESAR UNA NUEVA DEUDA">NUEVA MORA</acronym></a>

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
function graba() {
	if(datos.TX_NOMBRES.value==''){
		alert('DEBE INGRESAR NOMBRES');
	}else if(datos.TX_APELLIDOS.value=='0'){
		alert('DEBE INGRESAR APELLIDOS');
	}else if(datos.CB_CLIENTE.value=='0'){
		alert('DEBE INGRESAR UN CLIENTE');
	}else if(datos.rut.value==''){
		alert('DEBE INGRESAR UN RUT');
	}else{
		datos.action='graba_deudor.asp';
		datos.submit();
	}
}
function envia(){
	if(datos.rut.value==''){
		alert('DEBE RUT A BUSCAR');
	}else if(datos.CB_CLIENTE.value=='0'){
		alert('DEBE INGRESAR CLIENTE');
	}else{
		datos.action='scg_ingreso.asp';
		datos.submit();
	}



}
function ventanaSecundaria (URL){
	window.open(URL,"INFORMACION","width=800, height=400, scrollbars=yes, menubar=no, location=no, resizable=yes")
}
</script>
