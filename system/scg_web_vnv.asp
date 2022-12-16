<% @LCID = 1034 %>
<!--#include file="arch_utils.asp"-->
<!--#include file="../lib/comunes/rutinas/funciones.inc" -->
<!--#include file="lib.asp"-->
<!--#include file="sesion.asp"-->
<html>
<head>
<title>SCG WEB</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
</head>
<body bgcolor="747E97" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<form name="datos" id="datos" method="post">
<%
rut= request.Form("rut_")
if rut="" then
rut = request.Form("rut")
end if
%>
<table width="100%" height="100%" border="0" cellpadding="0" cellspacing="0">
  <tr>
    <td valign="top">
      <table width="793" border="0" align="center" cellpadding="0" cellspacing="0">
        <tr>
          <td colspan="3"><img name="index_r1_c1" src="../images/index_r1_c1.gif" width="793" height="87" border="0" alt=""></td>
        </tr>
        <tr>
          <td width="17" background="../images/index_r2_c1.gif">&nbsp;</td>
          <td width="758">
          	<table width="100%" height="431" border="0" cellpadding="0" cellspacing="0" bgcolor="#FFFFFF">

          		<script type="text/javascript" language="JavaScript1.2" src="frameset/stm31.js"></script>
          		<tr valign=TOP>
							<td height="431" colspan="3"><p align="right">Usuario: <%=session("nombre_user")%> | <a href="javascript:ventanaMisGestiones('mis_gestiones.asp?codcob=<%=LTRIM(RTRIM(session("session_login")))%>')"><acronym title="GESTIONES PRODUCIDAS POR <%=session("nombre_user")%>">MIS GESTIONES</acronym></a> |
							<%if session("session_tipo")="COB_CAJ" Then%>
							<%if not rut="" then%><a href="javascript:ventanaPagos('caja.asp?rut=<%=rut%>')">MODULO DE PAGOS</a>
							<%else%>
							MODULO DE PAGOS
							<%end if%> |
							<%end if%>
							<a href="cbdd02.asp"> <acronym title="SALIR DEL SISTEMA">CERRAR SESI&Oacute;N</acronym></a></p>
							  <table width="100%" height="335" border="0">
                                <tr>
                                  <td height="331" valign="top"><table width="100%" border="0">
                                      <tr bgcolor="#<%=session("COLTABBG")%>">
                                        <td width="19%" bgcolor="#<%=session("COLTABBG")%>" class="Estilo13">RUT DE DEUDOR</td>
                                      </tr>
                  <tr>
                                        <td><acronym title="RUT EN FORMATO SIN PUNTOS EJ: 10111222-3"><input name="rut" type="text" id="rut" value="<%=rut%>" size="10" maxlength="10"></acronym>
&nbsp;&nbsp;
            <acronym title="DESPLEGAR DATOS DEL DEUDOR ASOCIADO AL RUT DE BÚSQUEDA"><input name="me_" type="button" id="me_" onClick="envia();" value="Buscar"></acronym>
&nbsp;&nbsp;
            <acronym title="LIMPIAR FORMULARIO"><input name="li_" type="button" onClick="window.navigate('scg_web_vnv.asp');" value="Limpiar"></acronym>

&nbsp;&nbsp; <acronym title="LIMPIAR FORMULARIO">
<input name="li_" type="button" onClick="window.print();" value="Imprimir">
</acronym>
<input name="rutf" type="hidden" id="rutf" value="<%=rut%>">
                                        </td>
                                    </tr>
                                    </table>
                                      <%if not rut="" then%>
                                      <%
		abrirscg()
		ssql="SELECT TOP 1 NOMBREDEUDOR,RUTDEUDOR FROM DEUDOR WHERE RUTDEUDOR='"&rut&"' AND NOMBREDEUDOR IS NOT NULL AND LTRIM(RTRIM(NOMBREDEUDOR)) <> '' "
		set rsDEU=Conn.execute(ssql)
		if not rsDEU.eof then
			nombre_deudor = rsDEU("NOMBREDEUDOR")
			rut_deudor = rsDEU("RUTDEUDOR")
		end if
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
                                      <%if not rut_deudor="" then%>
                                      DATOS DEL DEUDOR
                                      <table width="100%" border="0" bordercolor="#FFFFFF">
                                        <tr bordercolor="#999999" bgcolor="#<%=session("COLTABBG")%>" class="Estilo13">
                                          <td width="31%">RUT</td>
                                          <td width="50%"">NOMBRE</td>
                                        </tr>
                                        <tr bgcolor="#FFFFFF" class="Estilo8">
                                          <td><%=rut_deudor%></td>
                                          <td><%=nombre_deudor%></td>
                                        </tr>
                                    </table>
                                      <table width="100%" border="0" bordercolor="#FFFFFF">
                                        <tr bordercolor="#999999" bgcolor="#<%=session("COLTABBG")%>" class="Estilo13">
                                          <td width="33%">CALLE</td>
                                          <td width="7%">NUMERO</td>
                                          <td width="30%">COMUNA</td>
                                          <td width="30%">TELEFONO</td>
                                        </tr>
                                        <tr bgcolor="#FFFFFF" class="Estilo8">
                                          <td><%=calle_deudor%></td>
                                          <td><%=numero_deudor%></td>
                                          <td><%=comuna_deudor%>
                                                <%if cint(correlativo_deudor) > 1 then%>
                                                | <a href="javascript:ventanaSecundaria('mas_direcciones.asp?rut=<%=rut_deudor%>')"><acronym title="VER TODAS LAS DIRECCIONES DEL DEUDOR">M&Aacute;S DIRECCIONES </acronym></a>
                                                <%end if%>
                                                | <a href="javascript:ventanaSecundaria('nueva_dir.asp?rut=<%=rut_deudor%>')"><acronym title="INGRESAR UNA NUEVA DIRECCION">NUEVA</acronym></a></td>
                                          <td>
                                            <%if not telefono_deudor="" then%>
                                            <%=codarea_deudor%>-<%=telefono_deudor%>
                                            <%if cint(Correlativo_deudor2) > 1 then%>
                                            | <a href="javascript:ventanaSecundaria('mas_telefonos.asp?rut=<%=rut_deudor%>')"><acronym title="VER TODOS LOS TELÉFONOS DEL DEUDOR">M&Aacute;S FONOS</acronym></a>
                                            <%end if%>
                                            <%end if%>
                                            | <a href="javascript:ventanaSecundaria('nuevo_tel.asp?rut=<%=rut_deudor%>')"><acronym title="INGRESAR UN NUEVO TELÉFONO">NUEVO</acronym></a></td>
                                        </tr>
                                    </table>
                                      <%
	  abrirscg()
	  ssql=""
	  ssql="SELECT COUNT(CUOTA.NRODOC) AS NUMDOC,SUM(CUOTA.SALDO) AS MONTODOC, CLIENTES.COD_CLI, CLIENTES.DESC_CLI AS DESC_CLI FROM CUOTA,CLIENTES "
	  ssql= ssql & "WHERE CUOTA.CODCLIENTE=CLIENTES.COD_CLI AND CUOTA.RUTDEUDOR='"&rut_deudor&"'"
	  ssql= ssql & "GROUP BY CUOTA.CODCLIENTE,CLIENTES.COD_CLI,CLIENTES.DESC_CLI"
	  set rsDEU=Conn.execute(ssql)
	  if not rsDEU.eof then
	  monto=0
	  %>
                                      <br>
                                      DEUDAS EN REGISTRO
                                      <table width="100%" border="0" bordercolor="#FFFFFF">
                                        <tr bordercolor="#999999" bgcolor="#<%=session("COLTABBG")%>" class="Estilo13">
                                          <td width="30%">CLIENTE</td>
                                          <td width="20%">GESTIONES</td>
                                          <td width="15%">DOCUMENTOS</td>
                                          <td width="13%">MONTO DEUDA</td>
                                          <td width="22%">DETALLE DE DEUDA </td>
                                        </tr>
                                        <%do until rsDEU.eof%>
                                        <tr bgcolor="#FFFFFF">
                                          <td><%=rsDEU("DESC_CLI")%></td>
										  <td>
										  <acronym title="MODULO DE GESTIÓN PARA EL CLIENTE <%=rsDEU("DESC_CLI")%>">
										  <%if session("session_tipo")="COB_TER" then%>
										  <a href="javascript:ventanaIngresoG('detalle_gestiones_terreno.asp?rut=<%=rut_deudor%>&cliente=<%=rsDEU("COD_CLI")%>')">MODULO DE GESTION <%=rsDEU("COD_CLI")%></a>
										  <%else%>
										  <a href="javascript:ventanaIngresoG('detalle_gestiones.asp?rut=<%=rut_deudor%>&cliente=<%=rsDEU("COD_CLI")%>')">MODULO DE GESTION <%=rsDEU("COD_CLI")%></a>
										  <%end if%>
										  </acronym>
										  </td>
                                          <td><div align="right"><%=rsDEU("NUMDOC")%></div></td>
                                          <td><div align="right">$ <%=(FN(rsDEU("MONTODOC"),0))%></div></td>
                                          <td>
										    <div align="left"><acronym title="DETALLE DE LA DEUDA DEL DEUDOR <%=rut%> CON EL CLIENTE <%=rsDEU("DESC_CLI")%>">
										    <%if rsDEU("COD_CLI")="40" then%>
										    <a href="javascript:ventanaDetalle('detalle_deuda_acsa.asp?rut=<%=rut_deudor%>&cliente=<%=rsDEU("COD_CLI")%>')">VER DETALLE DEUDA <%=rsDEU("COD_CLI")%></a>
										    <%elseif rsDEU("COD_CLI")="41" then%>
										    <a href="javascript:ventanaDetalle('detalle_deuda_acsa_infra.asp?rut=<%=rut_deudor%>&cliente=<%=rsDEU("COD_CLI")%>')">VER DETALLE DEUDA <%=rsDEU("COD_CLI")%></a>
										    <%elseif rsDEU("COD_CLI")="8" then%>
										    <a href="javascript:ventanaDetalle('detalle_deuda_inp_cheque.asp?rut=<%=rut_deudor%>&cliente=<%=rsDEU("COD_CLI")%>')">VER DETALLE DEUDA <%=rsDEU("COD_CLI")%></a>
										    <%elseif rsDEU("COD_CLI")="6" then%>
										    <a href="javascript:ventanaDetalle('detalle_deuda_bellsouth.asp?rut=<%=rut_deudor%>&cliente=<%=rsDEU("COD_CLI")%>')">VER DETALLE DEUDA <%=rsDEU("COD_CLI")%></a>
											<%elseif rsDEU("COD_CLI")="13" then%>
										    <a href="javascript:ventanaDetalle('detalle_deuda_ctcmundo.asp?rut=<%=rut_deudor%>&cliente=<%=rsDEU("COD_CLI")%>')">VER DETALLE DEUDA <%=rsDEU("COD_CLI")%></a>
										    <%elseif rsDEU("COD_CLI")="11" or  rsDEU("COD_CLI")="15" then%>
										    <a href="javascript:ventanaDetalleTelefonicas('detalle_deuda_movistar.asp?rut=<%=rut_deudor%>&cliente=<%=rsDEU("COD_CLI")%>')">VER DETALLE DEUDA <%=rsDEU("COD_CLI")%></a>
										    <%elseif rsDEU("COD_CLI")="21" then%>
										    <a href="javascript:ventanaDetalle2('detalle_deuda_ripley.asp?rut=<%=rut_deudor%>&cliente=<%=rsDEU("COD_CLI")%>')">VER DETALLE DEUDA <%=rsDEU("COD_CLI")%></a>
											<%else%>
										    <a href="javascript:ventanaDetalle('detalle_deuda.asp?rut=<%=rut_deudor%>&cliente=<%=rsDEU("COD_CLI")%>')">VER DETALLE DEUDA <%=rsDEU("COD_CLI")%></a>
										    <%end if%>
										      </acronym>
									        </div></td>
                                        </tr>
                                        <%
		 monto=monto + clng(rsDEU("MONTODOC"))
		 rsDEU.movenext
		 loop
		 %>
                                    </table>
                                      <%else%>
									  <br><br>
                                      <%="SIN DEUDAS CON CLIENTES EMPRESA"%>
                                      <%end if
	  rsDEU.close
	  set rsDEU=nothing
	  cerrarscg()
	  %>
                                      <%end if%>
                                  </td>
                                </tr>
                                <%end if%>
                              </table>
							  <p>&nbsp;</p>
			      </td>
	          </tr>
            </table>
          </td>
          <td width="18" background="../images/index_r2_c3.gif">&nbsp;</td>
        </tr>
        <tr>
          <td height="17" colspan="3"><img name="index_r3_c1" src="../images/index_r3_c1.gif" width="793" height="17" border="0" alt=""></td>
        </tr>
      </table> </td>
  </tr>
</table>
</form>
</body>
</html>
<script language="JavaScript" type="text/JavaScript">
function envia(){
datos.action='scg_web_vnv.asp';
datos.submit();
}

function paga(){
datos.action='detalle_pago.asp';
datos.submit();
}

function ventanaSecundaria (URL){
window.open(URL,"INFORMACION","width=600, height=300, scrollbars=no, menubar=no, location=no, resizable=no")
}

function ventanaDetalle (URL){
window.open(URL,"DETALLEGESTION","width=720, height=300, scrollbars=yes, menubar=no, location=no, resizable=no")
}

function ventanaDetalle2 (URL){
window.open(URL,"DETALLEGESTION","width=800, height=400, scrollbars=yes, menubar=no, location=no, resizable=yes")
}
function ventanaDetalleTelefonicas (URL){
window.open(URL,"DETALLEGESTION","width=800, height=300, scrollbars=yes, menubar=no, location=no, resizable=no")
}

function ventanaIngresoG (URL){
window.open(URL,"INFORMACION","width=720, height=400, scrollbars=yes, menubar=no, location=no, resizable=no")
}

function ventanaMisGestiones (URL){
window.open(URL,"MISGESTIONES","width=720, height=400, scrollbars=yes, menubar=no, location=no, resizable=no")
}

function ventanaPagos (URL){
window.open(URL,"PAGOS","width=720, height=400, scrollbars=yes, menubar=no, location=no, resizable=no")
}

</script>
