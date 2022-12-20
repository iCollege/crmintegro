<% @LCID = 1034 %>
<head>
<meta charset="iso-8859-1">
<title>Login</title>
<meta http-equiv="Content-Type" content="text/html;">

<!--#include file="arch_utils.asp"-->
<!--#include file="lib.asp"-->
<!--#include file="sesion.asp"-->
<!--#include file="../lib/comunes/rutinas/funciones.inc" -->
<!--#include file="../lib/comunes/rutinas/TraeCampo.inc" -->
<!--#include file="asp/comunes/general/RutinasVarias.inc" -->
<!--#include file="asp/comunes/general/rutinasBooleano.inc" -->
<!--#include file="asp/comunes/general/SoloNumeros.inc" -->


 <link rel="stylesheet" href="../assets/bootstrap/bootstrap.minv2.css">

        <link rel="stylesheet" href="../assets/font-awesome/css/font-awesome.min.css">
        <link rel="stylesheet" href="../assets/normalize/normalize.css">
        <!--page specific css styles-->
        <link rel="stylesheet" href="../assets/jquery-ui/jquery-ui.min.css">

        <!--flaty css styles-->
        <link rel="stylesheet" href="../css/flaty.css">
        <link rel="stylesheet" href="../css/flaty-responsive.css">


		<script src="../assets/jquery/jquery-1.10.1.min.js"></script>

				<script src="../dist/sweetalert.min.js"></script> 
		<link rel="stylesheet" type="text/css" href="../dist/sweetalert.css">

<style type="text/css">

.Estilo30 {color: #FFFFFF}
.Estilo36 {color: #FF0000}
.Estilo37 {color: #CCCCCC}
.Estilo28 {color: #FF0000}
body {
	background-image: url();
}
.Estilo38 {color: #000000}
.Estilo_LetraBlanca {font-family: tahoma;font-size: x-small; color: #FFFFFF;}

.tabla6 {
	border-bottom : 2px outset;
	border-left : 0px outset;
	border-top : 0px outset;
	border-right : 2px outset;
	font-family : Verdana;
	font-size : 10pt;
	font-weight : normal;
	letter-spacing : 1px;
}

.tabla8 {
	border-bottom : 1px outset;
	border-left : 0px outset;
	border-top : 0px outset;
	border-right : 1px outset;
	font-family : Arial;
	font-size : 8px;
	font-weight : normal;
	letter-spacing : 0px;
}

.tabla7 {
	font-family : Verdana;
	font-size : 22px;
	font-weight : normal;
	color : #FF0000;
	letter-spacing : 2px;
}

</style>
<head>
<title>CRM COBROS</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
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


	If session("permite_no_validar_fonos") = "S" Then
		strNoValida = "disabled"
	End If
	strNoValida = ""

%>

	<table width="793" border="0" align="center" cellpadding="0" cellspacing="0">
	<tr>
        <td colspan="2" align="right">
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
								<table width="100%" border="0">
									<tr>
										<TD height="20" ALIGN="LEFT" class="pasos2_i" colspan="2">
											<B>Busqueda</B>
											<!-- <font size="-7"> &nbsp(sin puntos , con digito verificador)</FONT> -->
										</TD>
									</tr>
									 <tr>
										<td>
											<br>
										  <input name="rut" type="text" id="rut" value="<%=rut%>" size="15" maxlength="15">

										  		&nbsp;&nbsp;<input name="opcion" type="radio" id="opcion" value="rut" checked> RUT
												&nbsp;&nbsp;<input name="opcion" type="radio" id="opcion" value="telefono"> TELEFONO
	
										  &nbsp;&nbsp;<input name="me_"  type="button" id="me_" onClick="envia();" value="Buscar" class="btn btn-info btn-sm">
										  </acronym>&nbsp;&nbsp; <acronym title="LIMPIAR FORMULARIO">
										  <input name="li_"  class="btn btn-info btn-sm" type="button" onClick="limpiar();" value="Limpiar">
										  </acronym>&nbsp;&nbsp; <acronym title="IMPRIMIR FORMULARIO (CONFIGURACION HORIZONTAL)">
										  <input name="li_" class="btn btn-info btn-sm" type="button" onClick="window.print();" value="Imprimir">
										  </acronym>
										</td>

										<td height="20">
										<% if rut <> "" and not isnull(rut) then %>

											<TABLE class="tabla6" height="30" width="100%" border="0" bgcolor="#f4f4f4">
												<TR bgcolor="#eae7e7">
													<TD width="100%" COLSPAN=5 height="10" style="vertical-align: top;">
													<table border=0 width="100%">
														<TR>
															<%If TraeSiNo(session("perfil_full")) = "Si" or TraeSiNo(session("perfil_adm")) = "Si" or TraeSiNo(session("perfil_emp")) = "Si" or TraeSiNo(session("perfil_caja")) = "Si" Then%>
																<td align="CENTER"><input name="BT_PAGOS" class="btn btn-info btn-xs" type="button" id="BT_PAGOS" onClick="envia_caja();" value="Pago en Cliente"><td>
																	<!--
																<td align="CENTER"><input name="BT_CONVENIO" class="boton_azul" type="button" id="BT_CONVENIO" onClick="envia_convenio();" value="<%=session("NOMBRE_CONV_PAGARE")%>"><td>
																-->
															<%End If%>

															<!--
															<td align="CENTER"><input name="BT_PLANPAGO" class="boton_azul" type="button" id="BT_PLANPAGO" onClick="envia_plandepago();" value="Plan Pagos"><td>
															-->
															<td align="CENTER">
																<!--
<input name="BT_BIBLIOTECA" class="boton_azul" type="button" id="BT_BIBLIOTECA" onClick="envia_doc();" value="Documentos"><td>
-->
																<input name="BT_BIBLIOTECA" class="btn btn-info btn-xs" type="button" id="BT_BIBLIOTECA" onClick="javascript:ventanaBiblioteca('biblioteca_deudores.asp?strRut=<%=rut%>');" value="--Documentos--"><td>
																<!--
															<td align="CENTER"><input name="BT_CARTERA" class="boton_azul" type="button" id="BT_CARTERA" onClick="javascript:window.navigate('cartera_asignada.asp?Limpiar=1');" value="Cart.Asig."><td>
															-->
														</TR>
													</table>
													</TD>
											</TABLE>
										<% Else %>

										<% End if %>
										</TD>
                          			</tr>
								</table>
                            </td>
                          </tr>

                        </table>

        <%
		if rut <> "" and not isnull(rut) then


			tipo=request("opcion")

			direccion_val=request("radiodir")
			fono_val=request("radiofon")
			email_val=request("radiomail")
			cor_tel=request("correlativo_fono")
			cor_dir=request("correlativo_direccion")
			cor_cor=request("correlativo_mail")
			var_dir =  request("dir")
			var_fon = request("fon")
			var_mail = request("mail")

			AbrirSCG()

			If var_fon <> "" then
				if fono_val <> "" and Not IsNull(fono_val) then
					ssql=""
					ssql="UPDATE DEUDOR_TELEFONO SET estado='"& fono_val &"' WHERE RUTDEUDOR='"&rut&"' AND CORRELATIVO= " & cint(cor_tel)
					'Response.write ssql
					Conn.execute(ssql)
				end If
			End if

			If var_dir <> "" then
				if direccion_val <> "" and Not IsNull(direccion_val) then
					ssql=""
					ssql="UPDATE DEUDOR_DIRECCION SET estado='"&direccion_val&"' WHERE RUTDEUDOR='"&rut&"' AND CORRELATIVO='"&cint(cor_dir)&"'"
					Conn.execute(ssql)
				end If
			End if

			If var_mail <> "" then
				if email_val <> "" and Not IsNull(email_val) then
					ssql=""
					ssql="UPDATE DEUDOR_EMAIL SET estado='"& email_val &"' WHERE RUTDEUDOR='"&rut&"' AND CORRELATIVO='"&cint(cor_cor)&"'"
					Conn.execute(ssql)
				end If
			End If

			CerrarSCG()




			AbrirSCG()

				if tipo = "rut" then

					strSql1 = "SELECT TOP 1 RUTDEUDOR, NOMBREDEUDOR FROM DEUDOR WHERE DEUDOR.RUTDEUDOR LIKE '%" & rut & "%'"
					set RsDeudor=Conn.execute(strSql1)
						If not RsDeudor.eof then
							existe = "si"
							rut_deudor = RsDeudor("RUTDEUDOR")
							nombre_deudor = RsDeudor("NOMBREDEUDOR")
						Else
							existe = "no"
							%>
							<script language="JavaScript" type="text/javascript">
								swal(
								{   
								title: "Rut no encontrado", 
								type: "warning",
								confirmButtonText: "Volver",
								showConfirmButton: true 
								},
								function()
								{
							    window.location.href = "principal.asp";
								});
							</script>	
							<%
						End if

				Else

					strSql1 = "SELECT TOP 1 RUTDEUDOR FROM DEUDOR_TELEFONO WHERE TELEFONO LIKE '%" & rut & "%'"
					set RsDeudor=Conn.execute(strSql1)

					If not RsDeudor.eof then
						existe = "si"
						rut_deudor = RsDeudor("RUTDEUDOR")

						'Verifica los datos del deudor buscando el rut obtenido por el teleofno
						strSql2 = "SELECT TOP 1 RUTDEUDOR, NOMBREDEUDOR FROM DEUDOR WHERE DEUDOR.RUTDEUDOR LIKE '%" & rut_deudor & "%'"
						set RsDeudor=Conn.execute(strSql2)
						If not RsDeudor.eof then
						existe = "si"
						rut = RsDeudor("RUTDEUDOR")
						nombre_deudor = RsDeudor("NOMBREDEUDOR")
						Else
						existe = "no"
						End if

					Else
						existe = "no"

					End if

				End if

				''strSql="SELECT TOP 1 ISNULL(REPLEG_RUT,'') as REPLEG_RUT,  ISNULL(REPLEG_NOMBRE,'') as REPLEG_NOMBRE, C.NOMBRE FROM DEUDOR D , CAMPANA C WHERE  D.IDCAMPANA = C.IDCAMPANA AND D.RUTDEUDOR = '" & rut_deudor & "' AND D.CODCLIENTE = '" & intCodCliente & "'"
				
				'response.write strSql

				RsDeudor.close
				set RsDeudor=nothing
				strDicom = "N/I"
			cerrarSCG()

			if existe = "si" then

				AbrirSCG()
					strSql = "SELECT * FROM DEUDOR_PATENTE WHERE RUT = '" & rut & "'"
					set RsPPU=Conn.execute(strSql)
					If not RsPPU.eof then
						rut_patente = RsPPU("PATENTE")
					Else
					End if
					RsPPU.close
					set RsPPU=nothing
				cerrarSCG()




				abrirSCG()
					strSql = "SELECT TOP 1 NOMBREDEUDOR,RUTDEUDOR,ISNULL(DEUDOR.REPLEG_RUT,'') as REPLEG_RUT, ISNULL(DEUDOR.REPLEG_NOMBRE,'') as REPLEG_NOMBRE, CAMPANA.NOMBRE, ESTADO_COBRANZA.NOM_ESTADO_COBRANZA,IC,MONTO,DIAS_DE_MORA,MARCA"
					strSql = strSql & " FROM DEUDOR LEFT OUTER JOIN CAMPANA ON DEUDOR.IDCAMPANA = CAMPANA.IDCAMPANA LEFT OUTER JOIN ESTADO_COBRANZA ON DEUDOR.ETAPA_COBRANZA = ESTADO_COBRANZA.COD_ESTADO_COBRANZA"
					strSql = strSql & " WHERE DEUDOR.RUTDEUDOR = '" & rut & "' AND DEUDOR.CODCLIENTE = '" & intCodCliente & "'"

					set RsDeudor=Conn.execute(strSql)
					If not RsDeudor.eof then
						strRutRepLegal = RsDeudor("REPLEG_RUT")
						strNombreRepLegal = RsDeudor("REPLEG_NOMBRE")
						strCampana = RsDeudor("NOMBRE")
						nombre_deudor = RsDeudor("NOMBREDEUDOR")
						rut_deudor = RsDeudor("RUTDEUDOR")
						strTipoCobranza = RsDeudor("NOM_ESTADO_COBRANZA")
						ic = RsDeudor("IC")
						monto_deuda = RsDeudor("MONTO")
						dias_de_mora = RsDeudor("DIAS_DE_MORA")
						marca = RsDeudor("MARCA")
					Else
						strCampana = ""
						'nombre_deudor = ""
						'rut_deudor = ""
						strTipoCobranza = ""
					End if
					RsDeudor.close
					set RsDeudor=nothing
					strDicom = "N/I"
				cerrarSCG()

				abrirSCG()
					ssql="SELECT * FROM CLIENTE WHERE CODCLIENTE = '" & intCodCliente & "'"
					set rsCliente=Conn.execute(ssql)
					if not rsCliente.eof then
						intGOpeSD=rsCliente("GASTOS_OPERACIONALES")
						intGOpeCD=rsCliente("GASTOS_OPERACIONALES_CD")
						intGAdmSD=rsCliente("GASTOS_ADMINISTRATIVOS")
						intGAdmCD=rsCliente("GASTOS_ADMINISTRATIVOS_CD")
						strUsaCustodio = rsCliente("USA_CUSTODIO")
						strColorCustodio = rsCliente("COLOR_CUSTODIO")
						intTasaMensual = ValNulo(rsCliente("INTERES_MORA"),"C")
						strNoHon = "S"
						strNoInt = "S"
					end if
					If intTasaMensual = "" Then
						%>
						<SCRIPT>alert('No se ha definido tasa de interes de mora, se ocupara una tasa del 2%, favor parametrizar')</SCRIPT>
						<%
						intTasaMensual = "2"
					End If
					rsCliente.close
					set rsCliente=nothing
				cerrarSCG()

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
					ssql="SELECT TOP 1 CODAREA,TELEFONO,CORRELATIVO,ESTADO, ISNULL(TELEFONODAL,0) AS TELEFONODAL FROM DEUDOR_TELEFONO WHERE  RUTDEUDOR='" & rut_deudor & "' and ESTADO <> '2' ORDER BY ESTADO DESC"
					set rsFON=Conn.execute(ssql)
					if not rsFON.eof then
						codarea_deudor = rsFON("CodArea")
						Telefono_deudor = rsFON("Telefono")
						strTelefonoDal = rsFON("TELEFONODAL")
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

				if Trim(rut_deudor) <> ""  then %>
				<br>

<button onclick="telus()"" value="va el rut" type="button" class="btn btn-default btn-xs">BUSCAR CUENTAS </button><br><br>



				<table width="100%" border="1" bordercolor="#FFFFFF">
					<tr>
						<TD height="20" ALIGN=LEFT class="pasos1_i">
							<B>INFORMACIÓN DEL DEUDOR</B>
						</TD>
					</tr>
				</table>
				<table width="100%" border="1" bordercolor="#FFFFFF">
				<tr bordercolor="#999999"  bgcolor="#<%=session("COLTABBG")%>" class="Estilo13">
					<td width="80">RUT</td>
					<td>NOMBRE O RAZ&Oacute;N SOCIAL</td>
					<td>RUT REP.LEG.</td>
					<td>ASIGNACION:</td>
					<td>TIPO COB.</td>
					<!--<td align=center><b>CAMPAÑA</b></td>-->
					<td><%=strNomAdic1Deudor%></td>


				</tr>
				<tr bgcolor="#<%=session("COLTABBG2")%>" class="Estilo8">
					<td ><strong><%=rut_deudor%></strong></td>
					<td><%=nombre_deudor%></td>
					<td><%=strRutRepLegal%></td>
					<td><%=strNombreRepLegal%></td>
					<td><%=strTipoCobranza%></td>
					<td align=center>
				<!--	<%If Trim(strCampana)<>"" Then%>
					<img src="../images/campana.gif" border="0" width=15 height=15>&nbsp;&nbsp;<B><%=ucase(strCampana)%></B>
					<%End If%> -->
					</td>
					<td><%=strAdic1Deudor%></td>
				</tr>
				</table>



				<table width="100%" border="1" bordercolor="#FFFFFF">
				<tr bordercolor="#999999"  bgcolor="#<%=session("COLTABBG")%>" class="Estilo13">
					<td >PATENTE</td><td  class="Estilo13">IC</td><td>MONTO ASIGNADO</td><td>DIAS DE MORA</td><td>MARCA</td>
				</tr>
				<tr bgcolor="#<%=session("COLTABBG2")%>" class="Estilo8">
					<td><%if request.form("rut_patente") then Response.write rut_patente End if%></td>
					<td><%if request.form("ic") then Response.write ic End if%></td>
					<td><strong><%if request.form("monto_deuda") then Response.write monto_deuda End if%></strong></td>
					<td><%if request.form("dias_de_mora") then Response.write dias_de_mora End if%></td>
					<td><font color='red'><strong><%if request.form("marca") then Response.write marca End if%></strong></font></td>
				</tr>
				</table>

				<%

								AbrirSCG()






								ssql="SELECT COUNT(CUOTA.NRODOC) AS NUMDOC, SUM(CUOTA.VALORCUOTA) AS VALORORIGINAL, SUM(CUOTA.SALDO) AS MONTODOC, MAX(IsNull(datediff(d,fechavenc,getdate()),0)) as ANTIGUEDAD, CLIENTE.CODCLIENTE, TIPODOCUMENTO, CLIENTE.DESCRIPCION AS DESCRIPCION , ESTADO_DEUDA, ESTADO_DEUDA.DESCRIPCION AS NOMESTADODEUDA, NOM_TIPO_DOCUMENTO, COD_TIPODOCUMENTO_HON FROM CUOTA,CLIENTE,ESTADO_DEUDA,TIPO_DOCUMENTO "

								ssql= ssql & " WHERE CUOTA.CODCLIENTE=CLIENTE.CODCLIENTE AND CUOTA.RUTDEUDOR='" & rut_deudor & "' AND CUOTA.ESTADO_DEUDA = ESTADO_DEUDA.CODIGO AND CUOTA.TIPODOCUMENTO = TIPO_DOCUMENTO.COD_TIPO_DOCUMENTO"
								ssql= ssql & " AND CUOTA.CODCLIENTE IN (" & session("strCliUsuarios") & ")"
								ssql= ssql & " GROUP BY CUOTA.CODCLIENTE,CLIENTE.CODCLIENTE,CLIENTE.DESCRIPCION,TIPODOCUMENTO, ESTADO_DEUDA, IDCUOTA_ENC, ESTADO_DEUDA.DESCRIPCION, NOM_TIPO_DOCUMENTO,COD_TIPODOCUMENTO_HON"
								'Response.write ssql

								set rsDEU=Conn.execute(ssql)
								if not rsDEU.eof then

								intTipoDocHono = ValNulo(rsDEU("COD_TIPODOCUMENTO_HON"),"C")
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
									  <td>CLIENTE</td>
									  <td>T.COBRANZA</td>
									  <td>PRODUCTO</td>
									  <td>ANTIG.</td>
									  <td>CAPITAL</td>
									  <td>INTERESES</td>
									  <td>HONORARIOS</td>
									  <td>PROTESTOS</td>
									  <td>TOTAL</td>
									  <td>DOCS</td>
									  <td>EJECUTIVO</td>
									  <td>DETALLE</td>
									</tr>
									<%


									Do until rsDEU.eof

										intTotHonorarios = 0
										intTotIntereses = 0
										intTotProtesto = 0

										intValorOriginal = Round(session("valor_moneda") * ValNulo(rsDEU("VALORORIGINAL"),"N"),0)

										intCodDetCliente=rsDEU("CODCLIENTE")
										intAntiguedad=rsDEU("ANTIGUEDAD")
										''intCuotaEnc=rsDEU("IDCUOTA_ENC")

										intTasaMensual = intTasaMensual/100
										intTasaDiaria = intTasaMensual/30

										If Trim(rsDEU("ESTADO_DEUDA")) = "1" Then

											strSql = "SELECT IDCUOTA,DATEDIFF(MONTH,FECHAVENC,GETDATE()) AS ANT_MESES,RUTDEUDOR, IsNull(FECHAVENC,'01/01/1900') as FECHAVENC, IsNull(datediff(d,fechavenc,getdate()),0) as ANTIGUEDAD, IsNull(VIGENTE,0) as VIGENTE, IsNull(VALORCUOTA,0) as VALORCUOTA,IsNull(SALDO,0) as SALDO,isnull(GASTOSCOBRANZAS,0) as GASTOSCOBRANZAS,IsNull(USUARIO_ASIG,0) as USUARIO_ASIG,NROCUOTA, VIGENTE, IsNull(GASTOSPROTESTOS,0) as GASTOSPROTESTOS, IsNull(VENCIDA,0) as VENCIDA, IsNull(CASTIGO,0) as CASTIGO, CENTRO_COSTO, SUCURSAL , ESTADO_DEUDA, CODREMESA, CUENTA, NRODOC, TIPODOCUMENTO, CONVERT(VARCHAR(10),FECHA_ESTADO,103) AS FEC_ESTADO, ADIC1, CUSTODIO FROM CUOTA "
											strSql = strSql & " WHERE RUTDEUDOR='" & rut_deudor & "' AND CODCLIENTE='" & intCodDetCliente & "' AND TIPODOCUMENTO = '" & rsDEU("TIPODOCUMENTO") & "' and estado_deuda = '1'"
											''Response.write "strSql=" & strSql
											set rsCalculo=Conn.execute(strSql)
											Do While Not rsCalculo.Eof

												intSaldo = Round(session("valor_moneda") * ValNulo(rsCalculo("SALDO"),"N"),0)
												intProtesto = Round(session("valor_moneda") * ValNulo(rsCalculo("GASTOSPROTESTOS"),"N"),0)
												intAntiguedad = ValNulo(rsCalculo("ANTIGUEDAD"),"N")

												If intAntiguedad > 0 Then
													intIntereses = intTasaDiaria * intAntiguedad * intSaldo

													If Trim(intTipoDocHono) = Trim(rsCalculo("TIPODOCUMENTO")) Then
														intCMeses = rsCalculo("ANT_MESES")
														intHonorarios = GastosCobranzas(HonorariosEspeciales1(intSaldo,intCMeses))
													Else
														intHonorarios = GastosCobranzas(intSaldo)
													End If
												Else
													intIntereses = 0
													intHonorarios = 0
												End If

												If Trim(strUsaCustodio) = "S" and Trim(rsCalculo("CUSTODIO")) <> "" Then
													intHonorarios = 0
												End if

												intTotHonorarios = intTotHonorarios + intHonorarios
												intTotIntereses = intTotIntereses + intIntereses
												intTotProtesto = intTotProtesto + intProtesto

												rsCalculo.movenext
											Loop

										ElseIf (Trim(rsDEU("ESTADO_DEUDA")) = "7" or Trim(rsDEU("ESTADO_DEUDA")) = "8") Then

											strSql = "SELECT IDCUOTA,RUTDEUDOR, IsNull(FECHAVENC,'01/01/1900') as FECHAVENC, IsNull(datediff(d,fechavenc,getdate()),0) as ANTIGUEDAD, IsNull(VIGENTE,0) as VIGENTE, IsNull(VALORCUOTA,0) as VALORCUOTA,IsNull(SALDO,0) as SALDO,isnull(GASTOSCOBRANZAS,0) as GASTOSCOBRANZAS,IsNull(USUARIO_ASIG,0) as USUARIO_ASIG,NROCUOTA, VIGENTE, IsNull(GASTOSPROTESTOS,0) as GASTOSPROTESTOS, IsNull(VENCIDA,0) as VENCIDA, IsNull(CASTIGO,0) as CASTIGO, CENTRO_COSTO, SUCURSAL , ESTADO_DEUDA, CODREMESA, CUENTA, NRODOC, TIPODOCUMENTO, CONVERT(VARCHAR(10),FECHA_ESTADO,103) AS FEC_ESTADO, ADIC1 FROM CUOTA "
											strSql = strSql & " WHERE RUTDEUDOR='" & rut_deudor & "' AND CODCLIENTE='" & intCodDetCliente & "' AND TIPODOCUMENTO = '" & rsDEU("TIPODOCUMENTO") & "' and estado_deuda in ('7','8')"
											''Response.write "strSql=" & strSql
											set rsCalculo=Conn.execute(strSql)
											Do While Not rsCalculo.Eof

												intSaldo = ValNulo(rsCalculo("SALDO"),"N")
												intProtesto = ValNulo(rsCalculo("GASTOSPROTESTOS"),"N")
												intAntiguedad = ValNulo(rsCalculo("ANTIGUEDAD"),"N")

												If intSaldo <> 0 Then
													intProtesto = 0
												End If

												intTotProtesto = intTotProtesto + intProtesto
												intTotHonorarios = 0
												intTotIntereses = 0

												rsCalculo.movenext
											Loop

										''Response.write "ESTADO_DEUDA=" & rsDEU("ESTADO_DEUDA")

										Else
											intProtesto = 0
											intTotHonorarios = 0
											intTotIntereses = 0
											intTotProtesto = 0
										End If

										If Trim(strNoHon) = "S" Then
											intTotHonorarios = 0
										End If
										If Trim(strNoInt) = "S" Then
											intTotIntereses = 0
										End If

										intTotalProducto = ValNulo(rsDEU("MONTODOC"),"N") + Round(intTotHonorarios,0) + Round(intTotIntereses,0) + Round(intTotProtesto,0)

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

										if Trim(intCodDetCliente) = intCodCliente Then

											strClase = "class='EstiloDestRojo'"
										Else
											strClase = ""
										End if


									%>
									<tr <%=strClase%>>
										<td><%=TRIM(rsDEU("DESCRIPCION"))%></td>
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

										<td height="20"><%=rsDEU("NOM_TIPO_DOCUMENTO")%></td>
										<td height="20" align="RIGHT"><%=intAntiguedad%></td>

										<td align="RIGHT">$<%=FN(intValorOriginal,0)%></td>
										<td align="RIGHT">$<%=FN(intTotIntereses,0)%></td>
										<td align="RIGHT">$<%=FN(intTotHonorarios,0)%></td>
										<td align="RIGHT">$<%=FN(intTotProtesto,0)%></td>
										<td align="RIGHT">$<%=FN(intTotalProducto,0)%></td>

									  <td align="right"><%=rsDEU("NUMDOC")%></td>
									  <td align="right">
									   <%
											strSql="SELECT TOP 1 ISNULL(USUARIO_ASIG,0) as USUARIO_ASIG FROM CUOTA WHERE RUTDEUDOR='" & rut_deudor &"' AND CODCLIENTE = '" & intCodDetCliente & "' AND ESTADO_DEUDA = '" & rsDEU("ESTADO_DEUDA") & "'"
											'reSPONSE.WRITE strSql
											'reSPONSE.eND
											set rsEJ=Conn.execute(strSql)
											if not rsEJ.eof then
												strCob = TraeCampoId(Conn, "LOGIN", rsEJ("USUARIO_ASIG"), "USUARIO", "ID_USUARIO")
											else
												strCob = "SIN ASIG."
											end if
											rsEJ.close
											set rsEJ=nothing
										%>
										<%=UCASE(strCob)%>
										</td>
									  <td align="right">
										<acronym title="DETALLE DE LA DEUDA DEL DEUDOR <%=rut%> CON EL CLIENTE <%=rsDEU("DESCRIPCION")%>">

										<a href="javascript:ventanaDetalle('detalle_deuda.asp?intCodEstado=<%=Trim(rsDEU("ESTADO_DEUDA"))%>&rut=<%=rut_deudor%>&cliente=<%=intCodDetCliente%>')">DETALLE</a>
										<a href="javascript:ventanaDetalle('detalle_deuda.asp?rut=<%=rut_deudor%>&cliente=<%=intCodDetCliente%>')">T</a>



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

				 If Trim(session("tipo_cliente")) = "JUDICIAL" Then %>

				 <br>
				<table width="100%" border="1" bordercolor="#FFFFFF">
					<tr>
						<TD width="50%" height="20" ALIGN=LEFT class="pasos1_i">
							<B>INFORMACIÓN ULTIMO PROCESO JUDICIAL.</B>
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
						strTipoDda=rsDemanda("TIPO_DEMANDA")
						strTribunal=TraeCampoId(Conn, "NOMTRIBUNAL", ValNulo(rsDemanda("IDTRIBUNAL"),"N"), "TRIBUNAL", "IDTRIBUNAL")
						strEstadoDemanda=TraeCampoId(Conn, "NOMESTADODEMANDA", ValNulo(rsDemanda("IDESTADO"),"N"), "ESTADODEMANDA", "IDESTADODEMANDA")
						strFechaIngreso=Saca1900(rsDemanda("FECHA_INGRESO"))
						strFechaCaducidad=Saca1900(rsDemanda("FECHA_CADUCIDAD"))
						strProcurador=TraeCampoId(Conn, "LOGIN", rsDemanda("IDPROCURADOR"), "USUARIO", "ID_USUARIO")
						strAbogado=TraeCampoId(Conn, "NOMABOGADO", ValNulo(rsDemanda("IDABOGADO"),"N"), "ABOGADO", "IDABOGADO")
						strMonto=rsDemanda("MONTO")
						strRazonTermino=TraeCampoId(Conn, "NOMRAZONTERMINO", ValNulo(rsDemanda("RAZON_TERMINO"),"N"), "RAZONTERMINO", "IDRAZONTERMINO")
						strAcuario=TraeCampoId(Conn, "NOMACTUARIO", ValNulo(rsDemanda("IDACTUARIO"),"N"), "ACTUARIO", "IDACTUARIO")

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

					Else
						intGOpeCD = 0
						intGAdmCD = 0
					End if
				%>
				<table width="100%" border="1" bordercolor="#FFFFFF">
					<tr bordercolor="#999999"  bgcolor="#<%=session("COLTABBG")%>" class="Estilo13">
						<td>ID</td>
						<td>CLIENTE</td>
						<td>TIPO</td>
						<td>TRIBUNAL</td>
						<td>ROL-AÑO</td>
						<td>F.INGRESO</td>
						<td>CADUCIDAD</td>
						<td>PROCURADOR</td>
						<td>ABOGADO</td>
						<td>COMPARENDO</td>

					</tr>
					<tr bgcolor="#<%=session("COLTABBG2")%>" class="Estilo8" height="15">
						<td>
						<%	If TraeSiNo(session("perfil_emp")) <> "Si" Then %>
							<A HREF="man_DemandaForm.asp?sintNuevo=0&IDDEMANDA=<%=Trim(intIdDemanda)%>"><%=intIdDemanda%></A>
						<% End If %>
						</td>
						<td><%=strNomCliente%></td>
						<td><%=strTipoDda%></td>
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
						<td>COSTAS PERS.</td>
						<td>G.OPER./I.C.</td>
						<td>INTERESES</td>
						<td>G.OPERA.</td>
						<td>G.ADMIN.</td>
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
						<td ALIGN="RIGHT"><%=FN(intGOpeCD,0)%></td>
						<td ALIGN="RIGHT"><%=FN(intGAdmCD,0)%></td>
						<td ALIGN="RIGHT"><%=FN(intGOpeCD+intGAdmCD+strTotalAPagar,0)%></td>
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
				<br>
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

				<table width="100%" border="1" bordercolor="#000000">
					<tr bordercolor="#000000" bgcolor="#<%=session("COLTABBG")%>" class="Estilo13">
						<td width="10%" class="Estilo4">FECHA</td>
						<td width="10%" class="Estilo4">HORA</td>
						<td width="30%" class="Estilo4">GESTION</td>
						<td width="40%" class="Estilo4">OBSERVACIONES</td>
						<td width="10%" class="Estilo4">DEMANDA</td>
						<td width="10%" class="Estilo4">F.NOTIF.</td>
						<td width="10%" class="Estilo4">EJECUTIVO</td>
					</tr>


				<%

			
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


						  	 AbrirSCG()
						  	 ssql=""
						  	 strSql = "SELECT TOP 1 REPLACE(C.DESCRIPCION + '-' + S.DESCRIPCION + '-' + E.DESCRIPCION,'-SIN DATOS ADICIONALES','') AS GEST,CONVERT(VARCHAR(10),FECHAINGRESO,103) as FECHAINGRESO1, CONVERT(VARCHAR(10),FECHAINGRESO,108) as HORAINGRESO, IDDEMANDA,IDUSUARIO,CONVERT(VARCHAR(10),FECHACOMPARENDO,103) as FECHACOMPARENDO, CONVERT(VARCHAR(10),FECHANOTIFICACION,103) as FECHANOTIFICACION, OBSERVACIONES, IDRECEPTOR,PATENTES "
						  	 strSql = strSql & " FROM GESTIONES_NUEVAS_JUDICIAL G, GESTIONES_JUDICIAL_CATEGORIA C, GESTIONES_JUDICIAL_SUBCATEGORIA S, GESTIONES_JUDICIAL_GESTION E WHERE G.RUTDEUDOR='" & rut_deudor & "' AND G.CODCLIENTE='" & intCodCliente &"' AND G.CODCATEGORIA = C.CODCATEGORIA AND G.CODSUBCATEGORIA = S.CODSUBCATEGORIA AND G.CODGESTION = E.CODGESTION "
						  	 strSql = strSql & " AND C.CODCATEGORIA = E.CODCATEGORIA AND S.CODSUBCATEGORIA = E.CODSUBCATEGORIA AND S.CODCATEGORIA = E.CODCATEGORIA ORDER BY FECHAINGRESO DESC "

						  	  'response.Write(strSql)
						  	  'response.End

						  	  set rsDET=Conn.execute(strSql)
						  	  If not rsDET.eof then
								  %>

									<%
									Do until rsDET.eof
										strFNotificacion = rsDET("FECHANOTIFICACION")
										If trim(strFNotificacion) = "01/01/1900" then strFNotificacion=""

										strOtros = strFNotificacion & " " & strFComparendo & " " & strPatentes & " " & strReceptor

										Obs=UCASE(LTRIM(RTRIM(rsDET("Observaciones"))))
										If Obs="" then
											Obs="SIN OBS"
										End if

										strUsuario=TraeCampoId(Conn, "LOGIN", Trim(rsDET("IDUSUARIO")), "USUARIO", "ID_USUARIO")
										strGestion=rsDET("GEST")
										%>
										  <tr bordercolor="#FFFFFF" class="Estilo8">
											<td class="Estilo4"><%=rsDET("FECHAINGRESO1")%></td>
											<td class="Estilo4"><%=rsDET("HORAINGRESO")%></td>
											<td class="Estilo4"><%=strGestion%></td>


											<td class="Estilo4">
											  <acronym title="<%=Obs%>">
												<%=Mid(Obs,1,200)%>
											</acronym>
										  </td>

											<td class="Estilo4"><%=UCASE(rsDET("IDDEMANDA"))%></td>
											<td class="Estilo4"><%=strFNotificacion%></td>
											<td class="Estilo4"><%=UCASE(strUsuario)%></td>


										  </tr>
										   <%rsDET.movenext
									 Loop
									 %>
									</TABLE>
								  <%
						  	  Else


						  	  strSql = "SELECT TOP 1 CONVERT(VARCHAR(10),FECHAINGRESO,103) AS FECHAINGRESO1, CONVERT(VARCHAR(10),FECHAINGRESO,108) AS HORAINGRESO, OBSERVACIONES, IDGESTIONJUDICIAL, IDUSUARIO "
							  strSql=strSql & "FROM GESTIONES_JUDICIAL "
							  strSql=strSql & "WHERE RUTDEUDOR = '" & rut & "' AND CODCLIENTE = '" & session("ses_codcli") & "'"
							  strSql=strSql & " ORDER BY FECHAINGRESO DESC"
							
							 'response.Write(strSql)
						  	  'response.End

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
							  strUsuario1 = TraeCampoId(Conn, "LOGIN", strUsuario, "USUARIO", "ID_USUARIO")

							  %>
							  <tr bordercolor="#FFFFFF" class="Estilo8">
							  <td class="Estilo4"><%=rsUltGest("FECHAINGRESO1")%></td>
							  <td class="Estilo4"><%=rsUltGest("HORAINGRESO")%></td>
							  <td class="Estilo4"><%=strGestion%></td>
							  <td class="Estilo4"><acronym title="<%=Obs%>"><%=Mid(Obs,1,200)%></acronym></td>
							  <td class="Estilo4">&nbsp;</td>
							  <td class="Estilo4">&nbsp;</td>
							  <td class="Estilo4"><%=UCASE(strUsuario1)%></td>
							  </tr>

							  <%

							  End If

						  	End if
						  	  rsDET.close
						  	  set rsDET=nothing
		  	  %>
				</table>
				<%
					End If ' del JUDICIAL

				'If TraeSiNo(session("perfil_emp")) <> "Si" Then %>
				<br>
				<table width="100%" border="1" bordercolor="#FFFFFF">
				<tr>
					<TD width="50%" height="20" ALIGN=LEFT class="pasos1_i">
						<B>ULTIMA GESTIÓN PRE-JUDICIAL</B>
					</TD>
					<TD width="50%" height="20" ALIGN=RIGHT class="pasos1_i">
						<!--a href="javascript:ventanaIngresoG('detalle_gestiones.asp?rut=<%=rut_deudor%>&cliente=<%=intCodCliente%>&area_con=<%=area_con%>&fono_con=<%=fono_con%>')">Nueva Gestión</a></acronym-->
						<a href="detalle_gestiones.asp?rut=<%=rut_deudor%>&cliente=<%=intCodCliente%>&area_con=<%=area_con%>&fono_con=<%=fono_con%>">Nueva Gestión</a></acronym>
					</TD>
				</tr>
				</table>
				 <table width="100%" border="1" bordercolor="#FFFFFF">
					<tr bordercolor="#FFFFFF" bgcolor="#<%=session("COLTABBG")%>" class="Estilo13">
					  <td width="30" class="Estilo4">FECHA</td>
					  <td width="30" class="Estilo4">HORA</td>
					  <td width="220" class="Estilo4">GESTION</td>
					  <td width="30" class="Estilo4">F.COMP.</td>
					  <td width="30" class="Estilo4">F.AGEND</td>
					  <td width="220" class="Estilo4">OBSERVACIONES</td>
					  <% If TraeSiNo(session("perfil_emp")) <> "Si" Then %>
					  <td width="10" class="Estilo4">FONO</td>
					  <% End If%>
					  <td width="10" class="Estilo4">EJECUTIVO</td>
					  </tr>
					<%
						strSql = "SELECT TOP 1 CODSUBCATEGORIA, CODCATEGORIA, CODGESTION, FECHAINGRESO,FECHACOMPROMISO, FECHA_AGENDAMIENTO, CONVERT(VARCHAR(10),FECHAINGRESO,108) AS HORAINGRESO, IDUSUARIO,FECHACOMPROMISO,HORAINGRESO, OBSERVACIONES, TELEFONO_ASOCIADO "
						strSql=strSql + "FROM GESTIONES "
						strSql=strSql + "WHERE RUTDEUDOR= '" & rut & "' AND CODCLIENTE = '" & session("ses_codcli") & "'"
						strSql=strSql + "ORDER BY ID_GESTION DESC"

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

						ssql="SELECT DESCRIPCION FROM GESTIONES_TIPO_GESTION WHERE CODCATEGORIA = '" & intCategoria & "' AND CODSUBCATEGORIA = '" & intSubCategoria & "' AND CODGESTION = '" & intGestion & "'"
						set rsCAT= Conn.execute(ssql)
						If not rsCAT.eof then
							gestion_nombre = rsCAT("Descripcion")
						End if
						rsCAT.close
						set rsCAT=nothing



					''strGestion = TraeCampoId(Conn, "DESCRIPCION", intCategoria, "GESTIONES_TIPO_CATEGORIA", "CODCATEGORIA") & " - " & TraeCampoId(Conn, "DESCRIPCION", rsUltGest("CodCategoria"), "GESTIONES_TIPO_CATEGORIA", "CODCATEGORIA") & " " & subcategoria_nombre & " " & gestion_nombre
					strGestion = TraeCampoId(Conn, "DESCRIPCION", rsUltGest("CodCategoria"), "GESTIONES_TIPO_CATEGORIA", "CODCATEGORIA") & "-" & subcategoria_nombre & "-" & gestion_nombre

					%>
					<tr bordercolor="#FFFFFF" class="Estilo8">
					  <td class="Estilo4"><%=rsUltGest("FECHAINGRESO")%></td>
					  <td class="Estilo4"><%=rsUltGest("HORAINGRESO")%></td>
					  <!--td class="Estilo4"><a href= "javascript:ventanaSecundaria('gestion.asp?categoria=<%=rsUltGest("CodCategoria")%>&subcategoria=<%=rsUltGest("CodSubCategoria")%>&gestion=<%=rsUltGest("CodGestion")%>')">VER</a>&nbsp;&nbsp;<%=rsUltGest("CodCategoria")%><%=rsUltGest("CodSubCategoria")%><%=rsUltGest("CodGestion")%></td-->
					  <td class="Estilo4"><%=strGestion%></td>

					  <td class="Estilo4"><%=rsUltGest("FECHACOMPROMISO")%></td>
					  <td class="Estilo4"><%=rsUltGest("FECHA_AGENDAMIENTO")%></td>
					  <td class="Estilo4"><acronym title="<%=Obs%>"><%=Mid(Obs,1,200)%></acronym></td>
					   <% If TraeSiNo(session("perfil_emp")) <> "Si" Then %>
					  <td class="Estilo4"><%=rsUltGest("telefono_asociado")%></td>
					   <% End If %>

					   <%
					   		If trim(rsUltGest("IDUSUARIO")) <> "" Then
							strNomUsuario = TraeCampoId(Conn, "LOGIN", rsUltGest("IDUSUARIO"), "USUARIO", "ID_USUARIO")
							End If
						%>

					  <td class="Estilo4"><%=UCASE(strNomUsuario)%></td>
					</tr>
					 <%
					 End If
					 CerrarSCG()
					 %>
				</table>

				<% 'End If ' del permiso del cliente%>



				<% If TraeSiNo(session("perfil_emp")) <> "Si" Then %>
				<br>
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
						<a href="mas_direcciones.asp?rut=<%=rut_deudor%>"><acronym title="VER TODAS LAS DIRECCIONES DEL DEUDOR">M&aacute;s</acronym></a>
					</td>
					<td width="30%">
						<strong>&nbsp;<a href="sip:<%=SoloNumeros(strTelefonoDal)%>"><%=SoloNumeros(strTelefono)%></a></strong>
					</td>
					<td ALIGN="CENTER">
						<a href="mas_telefonos.asp?rut=<%=rut_deudor%>"> <acronym title="VER TODOS LOS TEL&Eacute;FONOS DEL DEUDOR">M&aacute;s</acronym></a>
					</td>
					<td width="30%">
						<strong>&nbsp;<%=strEmail%></strong>
					</td>
					<td ALIGN="CENTER">
						<a href="mas_correos.asp?rut=<%=rut_deudor%>"> <acronym title="VER TODOS LOS CORREOS ELECTRONICOS DEL DEUDOR">M&aacute;s</acronym></a>
					</td>
				</tr>
				<tr class="Estilo8">
					<td>
						<input name="radiodir" type="radio" value="1" <%if estado_direccion="VALIDA" then Response.Write("checked") end if%> <%if estado_direccion="" then response.Write("Disabled") end if%>>VA
						<input name="radiodir" type="radio" value="2" <%if estado_direccion="NO VALIDA" then Response.Write("checked") end if%> <%if estado_direccion="" then response.Write("Disabled") end if%>>NV
						<input name="radiodir" type="radio" value="0" <%if estado_direccion="SIN AUDITAR" then Response.Write("checked") end if%> <%if estado_direccion="" then response.Write("Disabled") end if%>>SA
				  		<input name="Submit" type="button" class="btn btn-info btn-xs" onClick="envia_dir();" value="Auditar" <%if estado_direccion="" then response.Write("Disabled") end if%>>
				  	</td>
				  	<td><a href="nueva_dir.asp?rut=<%=rut_deudor%>"><acronym title="INGRESAR UNA NUEVA DIRECCION">&nbsp;Nuevo&nbsp</acronym></a>
				  		<input name="correlativo_direccion" type="hidden" id="correlativo_direccion" value="<%=correlativo_deudor%>">
					</td>
					<td>
						<input name="radiofon" type="radio" value="1" <%if estado_fono="VALIDO" then Response.Write("checked") end if%> <%if estado_fono="" then response.Write("Disabled") end if%>> VA
						<input name="radiofon" type="radio" value="2" <%=strNoValida%> <%if estado_fono="NO VALIDO" then Response.Write("checked") end if%> <%if estado_fono="" then response.Write("Disabled") end if%>> NV
						<input name="radiofon" type="radio" value="0" <%if estado_fono="SIN AUDITAR" then Response.Write("checked") end if%> <%if estado_fono="" then response.Write("Disabled") end if%>> SA
						<input name="Submit" type="button" class="btn btn-info btn-xs" onClick="envia_fon();" value="Auditar" <%if estado_fono="" then response.Write("Disabled") end if%>>
					</td>
				  	<td><a href="nuevo_tel.asp?rut=<%=rut_deudor%>"> <acronym title="INGRESAR UN NUEVO TEL&Eacute;FONO">&nbsp;Nuevo&nbsp</acronym></a>
						<input name="correlativo_fono" type="hidden" id="correlativo_fono" value="<%=correlativo_deudor2%>">
					</td>
					<td>
						<input name="radiomail" type="radio" value="1" <%if estado_mail="VALIDO" then Response.Write("checked") end if%> <%if estado_mail="" then response.Write("Disabled") end if%>> VA
						<input name="radiomail" type="radio" value="2" <%if estado_mail="NO VALIDO" then Response.Write("checked") end if%> <%if estado_mail="" then response.Write("Disabled") end if%>> NV
						<input name="radiomail" type="radio" value="0" <%if estado_mail="SIN AUDITAR" then Response.Write("checked") end if%> <%if estado_mail="" then response.Write("Disabled") end if%>> SA
						<input name="Submit" type="button" class="btn btn-info btn-xs" onClick="envia_mail();" value="Auditar" <%if estado_mail="" then response.Write("Disabled") end if%>>
					</td>
				  	<td><a href="nuevo_cor.asp?rut=<%=rut_deudor%>"> <acronym title="INGRESAR UN NUEVO CORREO ELECTRONICO">&nbsp;Nuevo&nbsp</acronym>
						 <input name="correlativo_mail" type="hidden" id="correlativo_mail" value="<%=correlativo_deudor3%>">
					</td>
				</tr>
				</table>
				<% End If %>
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


function telus() {
    var ruti=document.getElementById('rut');
    myRef = window.open('https://www.servipag.com/wps/portal/servipag/home/!ut/p/b1/04_Sj9CPykssy0xPLMnMz0vMAfGjzOLd_YyCvTzNPJyD_fzNDTyNvY3dAkxCjC38zIAKIoEKDHAARwNC-sP1o_ArMYEqwGOFn0d-bqp-QW6EQZaJoyIAZ4d8Fw!!/dl4/d5/L2dBISEvZ0FBIS9nQSEh/pw/Z7_2GQ5N3A5EL6N80A0OU0AF030G1/act/id=0/287276983881/-/?idAccionIdentificador=P&servicios=0&billers=0&TipoBusqueda=N&IntTipoBusqueda=0&array=11%2C130%2C'+ruti.value);
    dataLayer.push({'event': 'voyaservipag'});
    myRef.focus();
    myRef.blur();
}
    


function envia(){
datos.action='principal.asp';
datos.submit();
}

function limpiar(){
datos.action='principal.asp?Limpiar=1';
datos.submit();
}

function envia_caja(){
datos.action='ingreso_pagos.asp';
datos.submit();
}

function envia_plandepago(){
datos.action='simulacion_convenio.asp?intOrigen=PP';
datos.submit();
}

function envia_convenio(){
datos.action='simulacion_convenio.asp?intOrigen=CO';
datos.submit();
}

function envia_biblioteca(){
datos.action='biblioteca_deudores.asp?strRut=<%=rut%>';
datos.submit();
}

function envia_dir(){
datos.action='principal.asp?dir=si';
datos.submit();
}

function envia_fon(){
datos.action='principal.asp?fon=si';
datos.submit();
}

function envia_mail(){
datos.action='principal.asp?mail=si';
datos.submit();
}

function paga(){
datos.action='detalle_pago.asp';
datos.submit();
}

function ventanaSecundaria (URL){
window.open(URL,"INFORMACION","width=800, height=400, scrollbars=yes, menubar=no, location=no, resizable=yes")
}

function ventanaBiblioteca (URL){
window.open(URL,"INFORMACION","width=1000, height=500, scrollbars=yes, menubar=no, location=no, resizable=yes")
}

function ventanaDetalle (URL){
window.open(URL,"DETALLEDEUDA","width=1200, height=400, scrollbars=yes, menubar=no, location=no, resizable=yes")
}

function ventanaIngresoG (URL){
window.open(URL,"INFORMACION","width=800, height=400, scrollbars=yes, menubar=no, location=no, resizable=yes")
}

function ventanaMas (URL){
window.open(URL,"DATOS","width=200, height=300, scrollbars=no, menubar=no, location=no, resizable=yes")
}
</script>


