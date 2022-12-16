<% @LCID = 1034 %>
<html>
<!--#include file="arch_utils.asp"-->
<!--#include file="lib.asp"-->
<!--#include file="sesion.asp"-->
<!--#include file="../lib/comunes/rutinas/funciones.inc" -->
<!--#include file="../lib/comunes/rutinas/TraeCampo.inc" -->
<!--#include file="asp/comunes/general/RutinasVarias.inc" -->
<!--#include file="asp/comunes/general/rutinasBooleano.inc" -->

<style type="text/css">
<!--
.Estilo30 {color: #FFFFFF}
.Estilo36 {color: #FF0000}
.Estilo37 {color: #CCCCCC}
.Estilo28 {color: #FF0000}
body {
	background-image: url();
}
.Estilo38 {color: #000000}
.Estilo_LetraBlanca {font-family: tahoma;font-size: x-small; color: #FFFFFF;}
-->
</style>
<head>
<title>SCG WEB</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
</head>
<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<form name="datos" id="datos" method="post">
<%
	intCodCliente = session("ses_codcli")
	rut= LTRIM(RTRIM(cstr(request("rut_"))))
	if cstr(rut) = "" then
		rut = LTRIM(RTRIM(cstr(request("rut"))))
		if rut="" then
			rut = request.QueryString("rut")
		end if
	end if

	if trim(rut) <> "" Then
		session("session_rutdeudor") = rut
	Else
		rut = session("session_rutdeudor")
	End if

	If Trim(Request("Limpiar"))="1" Then
		session("session_rutdeudor") = ""
		rut = ""
	End if

	AbrirSCG()
		strEnPantallaPpal = TraeCampoId(Conn, "DETALLE_ENPPPAL", 1, "PARAMETRO_SISTEMA", "ID")
	CerrarSCG()

%>

	<table width="793" border="0" align="center" cellpadding="0" cellspacing="0">
	<tr>
        <td colspan="2 align="right">
          <table width="100%" border="0" cellpadding="0" cellspacing="0" bgcolor="#FFFFFF">
            <script type="text/javascript" language="JavaScript1.2" src="frameset/stm31.js"></script>
            <tr valign=TOP>
              <td colspan="3">
                  <table width="100%" height="335" border="0">
                    <tr>
                      <td height="331" valign="top" background="../images/fondo_111.jpg">
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
                              <input name="li_" type="button" onClick="window.navigate('principal.asp?Limpiar=1');" value="Limpiar">
                              </acronym>&nbsp;&nbsp; <acronym title="IMPRIMIR FORMULARIO (CONFIGURACION HORIZONTAL)">
                              <input name="li_" type="button" onClick="window.print();" value="Imprimir">
                              </acronym>
                            </td>
                          </tr>
                        </table>

                          <%
		if rut <> "" and not isnull(rut) then

			direccion_val=request("radiodir")
			fono_val=request("radiofon")
			email_val=request("radiomail")
			cor_tel=request("correlativo_fono")
			cor_dir=request("correlativo_direccion")
			cor_cor=request("correlativo_mail")

			AbrirSCG()
			if fono_val <> "" and Not IsNull(fono_val) then
				ssql=""
				ssql="UPDATE DEUDOR_TELEFONO SET estado='"& fono_val &"' WHERE RUTDEUDOR='"&rut&"' AND CORRELATIVO= " & cint(cor_tel)
				'Response.write ssql
				Conn.execute(ssql)
			end if

			if direccion_val <> "" and Not IsNull(direccion_val) then
				ssql=""
				ssql="UPDATE DEUDOR_DIRECCION SET estado='"&direccion_val&"' WHERE RUTDEUDOR='"&rut&"' AND CORRELATIVO='"&cint(cor_dir)&"'"
				Conn.execute(ssql)
			end if


			if email_val <> "" and Not IsNull(email_val) then
				ssql=""
				ssql="UPDATE DEUDOR_EMAIL SET estado='"& email_val &"' WHERE RUTDEUDOR='"&rut&"' AND CORRELATIVO='"&cint(cor_cor)&"'"
				Conn.execute(ssql)
			end if
			CerrarSCG()

			AbrirSCG()
			ssql="SELECT TOP 1 NOMBREDEUDOR,RUTDEUDOR FROM DEUDOR WHERE RUTDEUDOR='"&rut&"' AND NOMBREDEUDOR IS NOT NULL AND LTRIM(RTRIM(NOMBREDEUDOR)) <> '' "
			set RsDeudor=Conn.execute(ssql)
			if not RsDeudor.eof then
				nombre_deudor = RsDeudor("NOMBREDEUDOR")
				rut_deudor = RsDeudor("RUTDEUDOR")
				existe = "si"
			else
				rut_deudor = rut
				existe = "no"
				nombre_deudor = "SIN NOMBRE"
			end if
			RsDeudor.close
			set RsDeudor=nothing
			cerrarSCG()

			if existe = "si" then

				abrirSCG()
					ssql=""
					ssql="SELECT TOP 1 Calle,Numero,Comuna,Resto,Correlativo,Estado FROM DEUDOR_DIRECCION WHERE RUTDEUDOR='" & rut_deudor & "' and ESTADO <>'2' ORDER BY ESTADO DESC"
					set rsDIR=Conn.execute(ssql)
					if not rsDIR.eof then
						calle_deudor=rsDIR("Calle")
						numero_deudor=rsDIR("Numero")
						comuna_deudor=rsDIR("Comuna")
						resto_deudor=rsDIR("Resto")
						correlativo_deudor=rsDIR("Correlativo")
						estado_direccion=rsDIR("Estado")
						If estado_direccion="1" then
							estado_direccion="VALIDA"
						ElseIf estado_direccion="2" then
							estado_direccion="NO VALIDA"
						Else
							estado_direccion="SIN AUDITAR"
						End if
					end if
					rsDIR.close
					set rsDIR=nothing
				cerrarSCG()

				abrirSCG()
					ssql=""
					ssql="SELECT TOP 1 CODAREA,TELEFONO,CORRELATIVO,ESTADO FROM DEUDOR_TELEFONO WHERE  RUTDEUDOR='" & rut_deudor & "' and ESTADO <> '2' ORDER BY ESTADO DESC"
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
					ssql="SELECT TOP 1 RUTDEUDOR,CORRELATIVO,FECHAINGRESO,EMAIL,ESTADO FROM DEUDOR_EMAIL WHERE  RUTDEUDOR='" & rut_deudor & "' and ESTADO<>'2' ORDER BY ESTADO DESC"
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

				strDireccion = calle_deudor & " " & numero_deudor & " " & resto_deudor & " " & comuna_deudor
				strDomicilio = calle_deudor & " " & numero_deudor & " " & resto_deudor

				strTelefono = codarea_deudor & " " & telefono_deudor
				strEmail = email

				abrirSCG()
					strSql="SELECT TOP 1 REPLEG_RUT,REPLEG_NOMBRE FROM DEUDOR WHERE  RUTDEUDOR = '" & rut_deudor & "' AND ISNULL(REPLEG_RUT,'') <> ''"
					set rsRepLeg=Conn.execute(strSql)
					If not rsRepLeg.eof then
						strRutRepLegal = rsRepLeg("REPLEG_RUT")
						strNombreRepLegal = rsRepLeg("REPLEG_NOMBRE")
					Else
						strRutRepLegal = ""
						strNombreRepLegal = ""
					End if
					rsRepLeg.close
					set rsRepLeg=nothing
				cerrarSCG()

				if Trim(rut_deudor) <> ""  then %>
				<table width="100%" border="1" bordercolor="#FFFFFF">
					<tr>
						<TD height="20" ALIGN=LEFT class="pasos1_i">
							<B>INFORMACIÓN DEL DEUDOR</B>
						</TD>
					</tr>
				</table>
				<table width="100%" border="0" bordercolor="#FFFFFF">
					<tr bordercolor="#999999"  bgcolor="#<%=session("COLTABBG")%>" class="Estilo13">
						<td width="10%" bgcolor="#<%=session("COLTABBG")%>">RUT</td>
						<td width="35%">NOMBRE O RAZ&Oacute;N SOCIAL</td>
						<td width="10%" bgcolor="#<%=session("COLTABBG")%>">RUT REP.LEGAL</td>
						<td width="35%">NOMBRE RUT REP.LEGAL</td>
						<td width="10%">ASIGNACION</td>
					</tr>
					<tr bgcolor="#<%=session("COLTABBG2")%>" class="Estilo8">
						<td><%=rut_deudor%></td>
						<td><%=nombre_deudor%></td>
						<td><%=strRutRepLegal%></td>
						<td><%=strNombreRepLegal%></td>
						<td><%=strAsignacion%></td>
					</tr>
				</table>
				<%

								AbrirSCG()
								ssql=""
								ssql="SELECT COUNT(CUOTA.NRODOC) AS NUMDOC,SUM(CUOTA.SALDO) AS MONTODOC, MAX(IsNull(datediff(d,fechavenc,getdate()),0)) as ANTIGUEDAD, CLIENTE.CODCLIENTE, CLIENTE.DESCRIPCION AS DESCRIPCION , ESTADO_DEUDA, IsNull(IDCUOTA_ENC,0) as IDCUOTA_ENC, CODREMESA, ESTADO_DEUDA.DESCRIPCION AS NOMESTADODEUDA FROM CUOTA,CLIENTE,ESTADO_DEUDA "
								ssql= ssql & " WHERE CUOTA.CODCLIENTE=CLIENTE.CODCLIENTE AND CUOTA.RUTDEUDOR='" & rut_deudor & "' AND CUOTA.ESTADO_DEUDA = ESTADO_DEUDA.CODIGO"
								ssql= ssql & " AND CUOTA.CODCLIENTE IN (" & session("strCliUsuarios") & ")"
								ssql= ssql & " GROUP BY CUOTA.CODCLIENTE,CLIENTE.CODCLIENTE,CLIENTE.DESCRIPCION,ESTADO_DEUDA, IDCUOTA_ENC, CODREMESA, ESTADO_DEUDA.DESCRIPCION"

								set rsDEU=Conn.execute(ssql)
								if not rsDEU.eof then
								monto=0

								strSql = "SELECT COUNT(*)  as CANT FROM CONVENIO_ENC WHERE RUTDEUDOR = '" & rut_deudor & "' AND COD_CLIENTE IN (" & session("strCliUsuarios") & ")"
								set rsCountConvenio=Conn.execute(strSql)
								If Not rsCountConvenio.Eof Then
									intConvenios = rsCountConvenio("CANT")
								Else
									intConvenios = 0
								End if

								strSql = "SELECT COUNT(*)  as CANT FROM REPACTACION_ENC WHERE RUTDEUDOR = '" & rut_deudor & "' AND COD_CLIENTE IN (" & session("strCliUsuarios") & ")"
								set rsCountRepact=Conn.execute(strSql)
								If Not rsCountRepact.Eof Then
									intRepactaciones = rsCountRepact("CANT")
								Else
									intRepactaciones = 0
								End if


								strSql = "SELECT RUTDEUDOR FROM CONVENIO_ENC E, CONVENIO_DET D WHERE E.ID_CONVENIO = D.ID_CONVENIO "
								strSql = strSql & "AND E.COD_CLIENTE = '1000' AND D.ID_TIPOASEG IS NOT NULL AND RUTDEUDOR = '" & rut_deudor & "'"

								set rsDet1=Conn.execute(strSql)
								If not rsDet1.eof then
									strSegurado = "Rut Asegurado"
								Else
									strSegurado = ""
								End If

								%>
									<table width="100%" border="1" bordercolor="#FFFFFF">
										<tr>
											<TD height="20" ALIGN=LEFT class="pasos1_i">
												<B>INFORMACIÓN DE LAS DEUDAS</B>
											</TD>
											<TD width="70%" height="20" ALIGN=RIGHT class="pasos1_i">
											<% If TraeSiNo(session("perfil_emp")) <> "Si" Then %>

												<a href='detalle_convenio.asp?resp=123&TX_RUT=<%=rut_deudor%>'>Ver Convenios (<%=intConvenios%>)</a></acronym>&nbsp;&nbsp;
												<a href='detalle_repactacion.asp?resp=123&TX_RUT=<%=rut_deudor%>'>Ver Repactaciones (<%=intRepactaciones%>)</a></acronym>&nbsp;&nbsp;
												<font color="#FF0000"><%=strSegurado%></FONT>
											<% End If%>

											</TD>
										</tr>

									</table>
								  <table width="100%" border="1" bordercolor="#FFFFFF">
									<tr bordercolor="#999999" bgcolor="#<%=session("COLTABBG")%>" class="Estilo13">
									  <td width="20%">CLIENTE</td>
									  <td width="10%">T.COBRANZA</td>
									  <td width="5%">ANTIG.</td>
									  <td width="10%">PROB.COBRO</td>
									  <td width="10%">ASIG</td>
									  <td width="10%">CUANTIA</td>
									  <td width="5%">DOCS</td>
									  <td width="5%">CONV.</td>
									  <td width="5%">REPACT.</td>
									  <td width="10%">EJECUTIVO</td>
									  <td width="10%">DETALLE</td>

									</tr>
									<%
									Do until rsDEU.eof



										intCodDetCliente=rsDEU("CODCLIENTE")
										intAntiguedad=rsDEU("ANTIGUEDAD")
										intCuotaEnc=rsDEU("IDCUOTA_ENC")
										intCodRemesa = rsDEU("CODREMESA")


										strSql=""
										strSql="SELECT ID_CONVENIO FROM CONVENIO_ENC "
										strSql= strSql & "WHERE RUTDEUDOR = '" & rut_deudor & "' AND COD_CLIENTE = '" & intCodDetCliente & "' ORDER BY ID_CONVENIO DESC"

										set rsConvenio=Conn.execute(strSql)
										If Not rsConvenio.Eof Then
											id_convenio = rsConvenio("ID_CONVENIO")
										Else
											id_convenio = ""
										End If

										strSql=""
										strSql="SELECT ID_CONVENIO FROM REPACTACION_ENC "
										strSql= strSql & "WHERE RUTDEUDOR = '" & rut_deudor & "' AND COD_CLIENTE = '" & intCodDetCliente & "'"

										set rsConvenio=Conn.execute(strSql)
										If Not rsConvenio.Eof Then
											id_repactacion = rsConvenio("ID_CONVENIO")
										Else
											id_repactacion = ""
										End If

										strSql="SELECT PROB_COBRO, HONORARIOS FROM CUOTA_ENC WHERE RUTDEUDOR='" & rut_deudor &"' AND CODCLIENTE = " & intCodDetCliente ''& " AND IDCUOTA_ENC = " & intCuotaEnc
										'Response.write strSql
										set rsCuotaEnc=Conn.execute(strSql)
										if not rsCuotaEnc.eof then
											strProcCobro = rsCuotaEnc("PROB_COBRO")
										else
											strProcCobro = ""
										end if
										rsCuotaEnc.close
										set rsCuotaEnc=nothing

										If Trim(intCodDetCliente) = intCodCliente Then

											strClase = "class='EstiloDestRojo'"
										Else
											strClase = ""
										End if
									%>
									<tr <%=strClase%>>
										<td>
											<%=TRIM(rsDEU("DESCRIPCION"))%>
										</td>
										<!--td height="20">
											<%=rsDEU("ESTADO_DEUDA")%>
										</td-->
										<% If Trim(rsDEU("ESTADO_DEUDA")) = "10" Then %>
										<TD BGCOLOR='#FF0000' class='Estilo_LetraBlanca'>
										<A HREF="det_convenio.asp?id_convenio=<%=id_convenio%>"><acronym title="VER CONVENIO"><%=Mid(rsDEU("NOMESTADODEUDA"),1,10)%></acronym></A>
										</TD>
										<% ElseIf Trim(rsDEU("ESTADO_DEUDA")) = "11" Then %>
										<td BGCOLOR='#FF5000' class='Estilo_LetraBlanca'>
											<A HREF="det_repactacion.asp?id_convenio=<%=id_repactacion%>"><acronym title="VER REPACTACION"><%=Mid(rsDEU("NOMESTADODEUDA"),1,10)%></acronym></A>
										</td>
										<% Else %>
										<td><%=rsDEU("NOMESTADODEUDA")%></td>
										<% End If %>



										<td height="20" align="RIGHT">
											<%=intAntiguedad%>
										</td>
										<td height="20">
											<%=strProcCobro%>
										</td>
										<td height="20">
											<%=rsDEU("CODREMESA")%>
										</td>
									  <td align="right">$
											  <%if not isnull(rsDEU("MONTODOC")) then%>
											  <%=(FN(CLNG(rsDEU("MONTODOC")),0))%>
											  <%end if%>

									  </td>
									  <td align="right"><%=rsDEU("NUMDOC")%></td>
									  <td align="right">  <A HREF="det_convenio.asp?id_convenio=<%=id_convenio%>"><acronym title="VER CONVENIO"><%=id_convenio%></acronym></A></td>
									  <td align="right">  <A HREF="det_repactacion.asp?id_convenio=<%=id_repactacion%>"><acronym title="VER REPACTACION"><%=id_repactacion%></acronym></A></td>

									  <td align="right">
									   <%
											strSql="SELECT TOP 1 ISNULL(USUARIO_ASIG,0) as USUARIO_ASIG FROM CUOTA WHERE RUTDEUDOR='" & rut_deudor &"' AND CODCLIENTE = " & intCodDetCliente
											'reSPONSE.WRITE strSql
											'reSPONSE.eND
											set rsEJ=Conn.execute(strSql)
											if not rsEJ.eof then
												strCob = TraeCampoId(Conn, "NOMBRES_USUARIO", rsEJ("USUARIO_ASIG"), "USUARIO", "ID_USUARIO")
											else
												strCob = "SIN ASIG."
											end if
											rsEJ.close
											set rsEJ=nothing
										%>
										<%=strCob%>
										</td>
									  <td align="right">
										<acronym title="DETALLE DE LA DEUDA DEL DEUDOR <%=rut%> CON EL CLIENTE <%=rsDEU("DESCRIPCION")%>">
										<a href="javascript:ventanaDetalle('detalle_deuda.asp?rut=<%=rut_deudor%>&cliente=<%=intCodDetCliente%>')">
										DETALLE
										</a>
										</acronym>
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


								strSql = "SELECT COUNT(*)  as CANT FROM DEMANDA WHERE RUTDEUDOR = '" & rut_deudor & "' AND CODCLIENTE IN (" & session("strCliUsuarios") & ")"
								set rsCountDemanda=Conn.execute(strSql)
								If Not rsCountDemanda.Eof Then
									intDemandas = rsCountDemanda("CANT")
								Else
									intDemandas = 0
								End if


								cerrarSCG()
				%>

				<table width="100%" border="1" bordercolor="#FFFFFF">
					<tr>
						<TD width="50%" height="20" ALIGN=LEFT class="pasos1_i">
							<B>INFORMACIÓN ULTIMO PROCESO JUDICIAL</B>
						</TD>
						<TD width="50%" height="20" ALIGN=RIGHT class="pasos1_i">
							<% If TraeSiNo(session("perfil_emp")) <> "Si" Then %>
							<a href='man_Demanda.asp?TX_RUTDEUDOR=<%=rut_deudor%>'>Ver Todas (<%=intDemandas%>)</a></acronym>&nbsp;&nbsp;
							<a href='man_DemandaForm.asp?sintNuevo=1&FormMode=Nuevo&rut=<%=rut_deudor%>'>Nueva Demanda</a></acronym>
							<% End If%>
						</TD>
					</tr>
				</table>

				<%
					AbrirSCG()

					ssql=""
					ssql="SELECT TOP 1 * FROM DEMANDA WHERE RUTDEUDOR = '" & rut_deudor & "' AND CODCLIENTE = '" & session("ses_codcli") & "'"
					ssql= ssql & "ORDER BY IDDEMANDA DESC"
					set rsDemanda=Conn.execute(ssql)
					If not rsDemanda.eof then
						intIdDemanda=rsDemanda("IDDEMANDA")
						strRolAno=rsDemanda("ROLANO")
						strTribunal=TraeCampoId(Conn, "NOMTRIBUNAL", Trim(rsDemanda("IDTRIBUNAL")), "TRIBUNAL", "IDTRIBUNAL")
						strEstadoDemanda=TraeCampoId(Conn, "NOMESTADODEMANDA", Trim(rsDemanda("IDESTADO")), "ESTADODEMANDA", "IDESTADODEMANDA")
						strFechaIngreso=Saca1900(rsDemanda("FECHA_INGRESO"))
						strFechaCaducidad=Saca1900(rsDemanda("FECHA_CADUCIDAD"))
						strProcurador=TraeCampoId(Conn, "LOGIN", rsDemanda("IDPROCURADOR"), "USUARIO", "ID_USUARIO")
						strAbogado=TraeCampoId(Conn, "NOMABOGADO", Trim(rsDemanda("IDABOGADO")), "ABOGADO", "IDABOGADO")
						strMonto=rsDemanda("MONTO")
						strRazonTermino=TraeCampoId(Conn, "NOMRAZONTERMINO", Trim(rsDemanda("RAZON_TERMINO")), "RAZONTERMINO", "IDRAZONTERMINO")
						strAcuario=TraeCampoId(Conn, "NOMACTUARIO", Trim(rsDemanda("IDACTUARIO")), "ACTUARIO", "IDACTUARIO")

						strFechaComparendo=rsDemanda("FECHA_COMPARENDO")

						strGastosJudiciales=rsDemanda("GASTOS_JUDICIALES")
						strHonorarios=rsDemanda("HONORARIOS")
						strIntereres=rsDemanda("INTERESES")
						strIndemComp=rsDemanda("INDEM_COMPENSATORIA")
						strTotalAPagar=rsDemanda("TOTAL_APAGAR")
						strIdCliente = rsDemanda("CODCLIENTE")


						'Response.write "IDCLIENTE=" &rsDemanda("IDCLIENTE")
						'Response.End
						strNomCliente=TraeCampoId(Conn, "DESCRIPCION", strIdCliente, "CLIENTE", "CODCLIENTE")

					End if
				%>
				<table width="100%" border="1" bordercolor="#FFFFFF">
					<tr bordercolor="#999999"  bgcolor="#<%=session("COLTABBG")%>" class="Estilo13">
						<td>ID</td>
						<td>CLIENTE</td>
						<td>TRIBUNAL</td>
						<td>ROL-AÑO</td>
						<td>F.ING TRIBUNAL</td>
						<td>CADUCIDAD</td>
						<td>PROCURADOR</td>
						<td>ABOGADO</td>
						<td>COMPARENDO</td>

					</tr>
					<tr bgcolor="#<%=session("COLTABBG2")%>" class="Estilo8" height="15">
						<td>
						<% If TraeSiNo(session("perfil_emp")) <> "Si" Then %>
						<A HREF="man_DemandaForm.asp?sintNuevo=0&IDDEMANDA=<%=Trim(intIdDemanda)%>">
							<%=intIdDemanda%>
        				</A>
        				<% End if%>
						</td>
						<td><%=strNomCliente%></td>
						<td><%=strTribunal%></td>
						<td><%=strRolAno%></td>
						<td><%=strFechaIngreso%></td>
						<td><%=strFechaCaducidad%></td>
						<td><%=strProcurador%></td>
						<td><%=strAbogado%></td>
						<td><%=strFechaComparendo%></td>
					</tr>
				</table>
				<table width="100%" border="1" bordercolor="#FFFFFF">
					<tr bordercolor="#999999"  bgcolor="#<%=session("COLTABBG")%>" class="Estilo13">
						<td>ACTUARIO</td>
						<td>MONTO</td>
						<td>G.JUDIC.</td>
						<td>HONORARIOS</td>
						<td>INDEM.COMP.</td>
						<td>INTERESES</td>
						<td>A PAGAR</td>
						<td>R.TERMINO</td>
						<td>TRANSACCION.</td>
					</tr>
					<tr bgcolor="#<%=session("COLTABBG2")%>" class="Estilo8" height="15">
						<td><%=strAcuario%></td>
						<td ALIGN="RIGHT"><%=FN(strMonto,0)%></td>
						<td ALIGN="RIGHT"><%=FN(strGastosJudiciales,0)%></td>
						<td ALIGN="RIGHT"><%=FN(strHonorarios,0)%></td>
						<td ALIGN="RIGHT"><%=FN(strIndemComp,0)%></td>
						<td ALIGN="RIGHT"><%=FN(strIntereres,0)%></td>
						<td ALIGN="RIGHT"><%=FN(strTotalAPagar,0)%></td>
						<td><%=strRazonTermino%></td>
						<td>
						<%If Trim(intIdDemanda) <> "" Then%>
						<A HREF="FrmTransaccion1.asp?strRutDeudor=<%=rut_deudor%>&strNombreDeudor=<%=nombre_deudor%>&strTribunal=<%=strTribunal%>&strRol=<%=strRolAno%>&strDomicilio=<%=strDomicilio%>&strComuna=<%=comuna_deudor%>&strTotalAPagar=<%=strTotalAPagar%>&intIdDemanda=<%=intIdDemanda%>&strIdCliente=<%=strIdCliente%>">
							Tran.1
        				</A>
        				&nbsp;
        				<A HREF="FrmTransaccion2.asp?strRutDeudor=<%=rut_deudor%>&strNombreDeudor=<%=nombre_deudor%>&strTribunal=<%=strTribunal%>&strRol=<%=strRolAno%>&strDomicilio=<%=strDomicilio%>&strComuna=<%=comuna_deudor%>&strTotalAPagar=<%=strTotalAPagar%>&intIdDemanda=<%=intIdDemanda%>&strIdCliente=<%=strIdCliente%>">
							Tran.2
        				</A>
        				<%End If%>
        				</td>
					</tr>
				</table>

				<% If TraeSiNo(session("perfil_emp")) <> "Si" Then %>

				<table width="100%" border="1" bordercolor="#FFFFFF">
				<tr>
					<TD width="50%" height="20" ALIGN=LEFT class="pasos1_i">
						<B>ULTIMA GESTIÓN JUDICIAL</B>
					</TD>
					<TD width="50%" height="20" ALIGN=RIGHT class="pasos1_i">
						<a href="javascript:ventanaIngresoG('gestiones_judiciales_nueva.asp?rut=<%=rut_deudor%>&cliente=<%=intCodCliente%>&area_con=<%=area_con%>&fono_con=<%=fono_con%>')">Nueva Gestión</a></acronym>
					</TD>
				</tr>
				</table>
				 <table width="100%" border="1" bordercolor="#FFFFFF">
					<tr bordercolor="#FFFFFF" bgcolor="#<%=session("COLTABBG")%>" class="Estilo13">
					  <td width="30" class="Estilo4">FECHA</td>
					  <td width="30" class="Estilo4">HORA</td>
					  <td width="250" class="Estilo4">GESTION</td>
					  <td width="250" class="Estilo4">OBSERVACIONES</td>
					  <td width="25%" class="Estilo4">PROCURADOR</td>
					  </tr>
					<%
						'Response.Write "strSql= " & strSql

					AbrirSCG()

					strSql = "SELECT CONVERT(VARCHAR(10),FECHAINGRESO,103) as FECHAINGRESO "
					strSql=strSql + "FROM GESTIONES_JUDICIAL "
					strSql=strSql + "WHERE RUTDEUDOR = '" & rut & "' AND CODCLIENTE = '" & session("ses_codcli") & "' AND IDGESTIONJUDICIAL = 7 "

					set rsGestNeg=Conn.execute(strSql)
					If not rsGestNeg.eof then
					%>
						<SCRIPT>
							alert('El rut posee una búsqueda negativa con fecha <%=rsGestNeg("FECHAINGRESO")%>, favor revise.');
						</SCRIPT>
					<%
					End if

					strSql = "SELECT TOP 1 CONVERT(VARCHAR(10),FECHAINGRESO,103) AS FECHAINGRESO1, CONVERT(VARCHAR(10),FECHAINGRESO,108) AS HORAINGRESO, OBSERVACIONES, IDGESTIONJUDICIAL, IDUSUARIO "
					strSql=strSql + "FROM GESTIONES_JUDICIAL "
					strSql=strSql + "WHERE RUTDEUDOR = '" & rut & "' AND CODCLIENTE = '" & session("ses_codcli") & "'"
					strSql=strSql + "ORDER BY FECHAINGRESO DESC"
					'rESPONSE.WRITE strSql
					''rESPONSE.eND



					set rsUltGest=Conn.execute(strSql)
					If not rsUltGest.eof then
						Obs=UCASE(LTRIM(RTRIM(rsUltGest("OBSERVACIONES"))))
					If Obs="" then
						Obs="SIN INFORMACION ADICIONAL"
					End if

					strGestion = TraeCampoId(Conn, "NOMGESTION", rsUltGest("IDGESTIONJUDICIAL"), "GESTION_JUDICIAL", "IDGESTION")
					''strUsuario = TraeCampoId(Conn, "NOMPROCURADOR", rsUltGest("IDUSUARIO"), "PROCURADOR", "IDPROCURADOR")
					strUsuario = TraeCampoId(Conn, "NOMBRES_USUARIO", rsUltGest("IDUSUARIO"), "USUARIO", "ID_USUARIO")
					strUsuario = rsUltGest("IDUSUARIO")
					strUsuario1 = TraeCampoId(Conn, "NOMBRES_USUARIO", rsUltGest("IDUSUARIO"), "USUARIO", "ID_USUARIO")

					%>
					<tr bordercolor="#FFFFFF" class="Estilo8">
					  <td class="Estilo4"><%=rsUltGest("FECHAINGRESO1")%></td>
					  <td class="Estilo4"><%=rsUltGest("HORAINGRESO")%></td>
					  <td class="Estilo4"><%=strGestion%></td>
					  <td class="Estilo4"><acronym title="<%=Obs%>"><%=Mid(Obs,1,200)%></acronym></td>
					  <td class="Estilo4"><%=UCASE(strUsuario1)%></td>
					</tr>
					 <%
					 End If
					 CerrarSCG()
					 %>
				</table>

				<table width="100%" border="1" bordercolor="#FFFFFF">
				<tr>
					<TD width="50%" height="20" ALIGN=LEFT class="pasos1_i">
						<B>ULTIMA GESTIÓN PRE-JUDICIAL</B>
					</TD>
					<TD width="50%" height="20" ALIGN=RIGHT class="pasos1_i">
						<a href="javascript:ventanaIngresoG('detalle_gestiones.asp?rut=<%=rut_deudor%>&cliente=<%=intCodCliente%>&area_con=<%=area_con%>&fono_con=<%=fono_con%>')">Nueva Gestión</a></acronym>
					</TD>
				</tr>
				</table>
				 <table width="100%" border="1" bordercolor="#FFFFFF">
					<tr bordercolor="#FFFFFF" bgcolor="#<%=session("COLTABBG")%>" class="Estilo13">
					  <td width="30" class="Estilo4">FECHA</td>
					  <td width="30" class="Estilo4">HORA</td>
					  <td width="250" class="Estilo4">GESTION</td>
					  <td width="250" class="Estilo4">OBSERVACIONES</td>
					  <td width="10%" class="Estilo4">FONO</td>
					  <td width="10%" class="Estilo4">EJECUTIVO</td>
					  </tr>
					<%
						strSql = "SELECT TOP 1 CODSUBCATEGORIA, CODCATEGORIA, CODGESTION, FECHAINGRESO,CONVERT(VARCHAR(10),FECHAINGRESO,108) AS HORAINGRESO, IDUSUARIO,FECHACOMPROMISO,HORAINGRESO, OBSERVACIONES, TELEFONO_ASOCIADO "
						strSql=strSql + "FROM GESTIONES "
						strSql=strSql + "WHERE RUTDEUDOR= '" & rut & "' AND CODCLIENTE = '" & session("ses_codcli") & "'"
						strSql=strSql + "ORDER BY FECHAINGRESO DESC,CORRELATIVO DESC"

						'Response.Write "strSql= " & strSql

					AbrirSCG()
					set rsUltGest=Conn.execute(strSql)
					If not rsUltGest.eof then
					Obs=UCASE(LTRIM(RTRIM(rsUltGest("Observaciones"))))
					If Obs="" then
						Obs="SIN INFORMACION ADICIONAL"
					End if

					intCategoria = Trim(rsUltGest("CodCategoria"))
					intSubCategoria = Trim(rsUltGest("CodSubCategoria"))
					intGestion = Trim(rsUltGest("CodGestion"))

						ssql="SELECT DESCRIPCION FROM GESTIONES_TIPO_SUBCATEGORIA WHERE CODCATEGORIA = " & intCategoria & " AND CODSUBCATEGORIA = " & intSubCategoria
						set rsCAT= Conn.execute(ssql)
						If not rsCAT.eof then
							subcategoria_nombre = rsCAT("Descripcion")
						End if
						rsCAT.close
						set rsCAT=nothing

						ssql="SELECT DESCRIPCION FROM GESTIONES_TIPO_GESTION WHERE CODCATEGORIA='" & cint(categoria) & "' and CodSubCategoria='" & cint(subcategoria) & "' and CodGestion='" & cint(gestion) & "'"
						set rsCAT= Conn.execute(ssql)
						If not rsCAT.eof then
							gestion_nombre = rsCAT("Descripcion")
						End if
						rsCAT.close
						set rsCAT=nothing

					strGestion = TraeCampoId(Conn, "DESCRIPCION", intCategoria, "GESTIONES_TIPO_CATEGORIA", "CODCATEGORIA") & " - " & TraeCampoId(Conn, "DESCRIPCION", rsUltGest("CodCategoria"), "GESTIONES_TIPO_CATEGORIA", "CODCATEGORIA") & " " & subcategoria_nombre & " " & gestion_nombre

					%>
					<tr bordercolor="#FFFFFF" class="Estilo8">
					  <td class="Estilo4"><%=rsUltGest("FECHAINGRESO")%></td>
					  <td class="Estilo4"><%=rsUltGest("HORAINGRESO")%></td>
					  <!--td class="Estilo4"><a href= "javascript:ventanaSecundaria('gestion.asp?categoria=<%=rsUltGest("CodCategoria")%>&subcategoria=<%=rsUltGest("CodSubCategoria")%>&gestion=<%=rsUltGest("CodGestion")%>')">VER</a>&nbsp;&nbsp;<%=rsUltGest("CodCategoria")%><%=rsUltGest("CodSubCategoria")%><%=rsUltGest("CodGestion")%></td-->
					  <td class="Estilo4"><%=strGestion%></td>

					  <!--td class="Estilo4"><%=rsUltGest("FechaCompromiso")%></td-->
					  <td class="Estilo4"><acronym title="<%=Obs%>"><%=Mid(Obs,1,200)%></acronym></td>
					  <td class="Estilo4"><%=rsUltGest("telefono_asociado")%></td>

					   <%
							strNomUsuario = TraeCampoId(Conn, "NOMBRES_USUARIO", rsUltGest("IDUSUARIO"), "USUARIO", "ID_USUARIO")
						%>

					  <td class="Estilo4"><%=UCASE(strNomUsuario)%></td>
					</tr>
					 <%
					 End If
					 CerrarSCG()
					 %>
				</table>

				<% End If ' del permiso del cliente%>

				<table width="100%" border="1" bordercolor="#FFFFFF">
					<tr>
						<TD height="20" ALIGN=LEFT class="pasos1_i">
							<B>DATOS DEL CONTACTO</B>
						</TD>
					</tr>
				</table>

				<table width="100%" cellpadding="0" cellspacing="0" border="1" bordercolor="#<%=session("COLTABBG")%>">
				<tr width="40%" bordercolor="#999999" bgcolor="#<%=session("COLTABBG")%>" class="Estilo13">
					<td width="40%" colspan="2">DIRECCI&Oacute;N M&Aacute;S RECIENTE </td>
					<td width="25%" colspan="2">TELEFONO M&Aacute;S RECIENTE </td>
					<td width="35%" colspan="2">EMAIL M&Aacute;S RECIENTE </td>
				</tr>
				<tr height="25" class="Estilo8">
					<td width="40%">
						&nbsp;<%=strDireccion%>
					</td>
					<td ALIGN="CENTER">
						<a href="javascript:ventanaSecundaria('mas_direcciones.asp?rut=<%=rut_deudor%>')"><acronym title="VER TODAS LAS DIRECCIONES DEL DEUDOR">M&aacute;s</acronym></a>
					</td>
					<td width="30%">
						&nbsp;<%=strTelefono%>
					</td>
					<td ALIGN="CENTER">
						<a href="javascript:ventanaSecundaria('mas_telefonos.asp?rut=<%=rut_deudor%>')"> <acronym title="VER TODOS LOS TEL&Eacute;FONOS DEL DEUDOR">M&aacute;s</acronym></a>
					</td>
					<td width="30%">
						&nbsp;<%=strEmail%>
					</td>
					<td ALIGN="CENTER">
						<a href="javascript:ventanaSecundaria('mas_correos.asp?rut=<%=rut_deudor%>')"> <acronym title="VER TODOS LOS CORREOS ELECTRONICOS DEL DEUDOR">M&aacute;s</acronym></a>
					</td>
				</tr>
				<tr class="Estilo8">
					<td>
						<input name="radiodir" type="radio" value="1" <%if estado_direccion="VALIDA" then Response.Write("checked") end if%> <%if estado_direccion="" then response.Write("Disabled") end if%>>VA
						<input name="radiodir" type="radio" value="2" <%if estado_direccion="NO VALIDA" then Response.Write("checked") end if%> <%if estado_direccion="" then response.Write("Disabled") end if%>>NV
						<input name="radiodir" type="radio" value="0" <%if estado_direccion="SIN AUDITAR" then Response.Write("checked") end if%> <%if estado_direccion="" then response.Write("Disabled") end if%>>SA
				  		<input name="Submit" type="button" class="Estilo8" onClick="envia();" value="Auditar" <%if estado_direccion="" then response.Write("Disabled") end if%>>
				  	</td>
				  	<td><a href="javascript:ventanaSecundaria('nueva_dir.asp?rut=<%=rut_deudor%>')"><acronym title="INGRESAR UNA NUEVA DIRECCION">&nbsp;Nuevo&nbsp</acronym></a>
				  		<input name="correlativo_direccion" type="hidden" id="correlativo_direccion" value="<%=correlativo_deudor%>">
					</td>
					<td>
						<input name="radiofon" type="radio" value="1" <%if estado_fono="VALIDO" then Response.Write("checked") end if%> <%if estado_fono="" then response.Write("Disabled") end if%>> VA
						<input name="radiofon" type="radio" value="2" <%if estado_fono="NO VALIDO" then Response.Write("checked") end if%> <%if estado_fono="" then response.Write("Disabled") end if%>> NV
						<input name="radiofon" type="radio" value="0" <%if estado_fono="SIN AUDITAR" then Response.Write("checked") end if%> <%if estado_fono="" then response.Write("Disabled") end if%>> SA
						<input name="Submit" type="button" class="Estilo8" onClick="envia();" value="Auditar" <%if estado_fono="" then response.Write("Disabled") end if%>>
					</td>
				  	<td><a href="javascript:ventanaSecundaria('nuevo_tel.asp?rut=<%=rut_deudor%>')"> <acronym title="INGRESAR UN NUEVO TEL&Eacute;FONO">&nbsp;Nuevo&nbsp</acronym></a>
						<input name="correlativo_fono" type="hidden" id="correlativo_fono" value="<%=correlativo_deudor2%>">
					</td>
					<td>
						<input name="radiomail" type="radio" value="1" <%if estado_mail="VALIDO" then Response.Write("checked") end if%> <%if estado_mail="" then response.Write("Disabled") end if%>> VA
						<input name="radiomail" type="radio" value="2" <%if estado_mail="NO VALIDO" then Response.Write("checked") end if%> <%if estado_mail="" then response.Write("Disabled") end if%>> NV
						<input name="radiomail" type="radio" value="0" <%if estado_mail="SIN AUDITAR" then Response.Write("checked") end if%> <%if estado_mail="" then response.Write("Disabled") end if%>> SA
						<input name="Submit" type="button" class="Estilo8" onClick="envia();" value="Auditar" <%if estado_mail="" then response.Write("Disabled") end if%>>
					</td>
				  	<td><a href="javascript:ventanaSecundaria('nuevo_cor.asp?rut=<%=rut_deudor%>')"> <acronym title="INGRESAR UN NUEVO CORREO ELECTRONICO">&nbsp;Nuevo&nbsp</acronym>
						 <input name="correlativo_mail" type="hidden" id="correlativo_mail" value="<%=correlativo_deudor3%>">
					</td>
				</tr>
				</table>





				<%

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




</form>
</body>
</html>


<script language="JavaScript" type="text/JavaScript">
function envia(){
datos.action='principal.asp';
datos.submit();
}

function paga(){
datos.action='detalle_pago.asp';
datos.submit();
}

function ventanaSecundaria (URL){
window.open(URL,"INFORMACION","width=800, height=400, scrollbars=yes, menubar=no, location=no, resizable=yes")
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

function ventanaMas (URL){
window.open(URL,"DATOS","width=200, height=300, scrollbars=no, menubar=no, location=no, resizable=yes")
}
</script>


