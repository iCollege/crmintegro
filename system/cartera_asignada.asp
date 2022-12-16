<% @LCID = 1034 %>
<!--#include file="arch_utils.asp"-->
<!--#include file="lib.asp"-->
<!--#include file="sesion.asp"-->
<!--#include file="../lib/comunes/rutinas/funciones.inc" -->
<!--#include file="../lib/comunes/rutinas/TraeCampo.inc" -->
<!--#include file="asp/comunes/general/Minimo.inc"-->
<!--#include file="asp/comunes/general/rutinasBooleano.inc" -->

<script language="JavaScript">
function ventanaSecundaria (URL){
window.open(URL,"DETALLE","width=800, height=300, scrollbars=YES, menubar=no, location=no, resizable=yes")
}
</script>
<%

Dim PaginaActual ' en qué pagina estamos
Dim PaginasTotales ' cuántas páginas tenemos
Dim TamPagina ' cuantos registros por pagina
Dim CuantosRegistros ' para imprimir solo el nº de registro por pagina que

strNombres= Request("TX_NOMBRES")
strRut = Request("TX_RUT")
strDesde= Request("TX_DESDE")
strHasta= Request("TX_HASTA")
intCodRemesa = Request("CB_REMESA")
intCodCampana = Request("CB_CAMPANA")
strCodCliente=session("ses_codcli")
strEjeAsig = Request("CB_EJECUTIVO")
strTipoInf = Request("CB_TIPOCARTERA")


If Trim(strTipoInf) = "" Then strTipoInf = "GESTIONABLES"
If Trim(strCodCliente) = "" Then strCodCliente = "1000"


''Response.write "strBuscar=" & Request("strBuscar")
If Trim(Request("strBuscar")) = "S" Then
	session("Ftro_Ejecutivo") = strEjeAsig
	session("Ftro_Campana") = intCodCampana
	session("Ftro_Asignacion") = intCodRemesa
	session("Ftro_TipoCartera") = strTipoInf
End If
If Trim(Request("strBuscar")) = "N" Then
	session("Ftro_Ejecutivo") = ""
	session("Ftro_Campana") = ""
	session("Ftro_Asignacion") = ""
	session("Ftro_TipoCartera") = ""
End If


If strEjeAsig <> "0" Then strEjeAsig = session("Ftro_Ejecutivo")
If intCodCampana = "" Then intCodCampana = session("Ftro_Campana")
If intCodRemesa = "" Then intCodRemesa = session("Ftro_Asignacion")
''If strTipoInf = "GESTIONABLES" Then strTipoInf = session("Ftro_TipoCartera")


'MODIFICAR AQUI PARA CAMBIAR EL Nº DE REGISTRO POR PAGINA
TamPagina=100

'Leemos qué página mostrar. La primera vez será la inicial
if Request.Querystring("pagina")="" then
	PaginaActual=1
else
	PaginaActual=CInt(Request.Querystring("pagina"))
end if


%>
<title>CARTERA ASIGNADA</title>

<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
</head>
<%strTitulo="MI CARTERA"%>

<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<form name="datos" method="post">

<table width="100%" border="1" bordercolor="#FFFFFF">
	<tr>
		<TD height="20" ALIGN=LEFT class="pasos2_i">
			<B>CARTERA ASIGNADA</B>
		</TD>
	</tr>
</table>


	<table width="850" align="CENTER" border="0" bordercolor="#FFFFFF">
			<tr bordercolor="#999999"  bgcolor="#FFFFFF" class="Estilo13">
				<tr bordercolor="#999999"  bgcolor="#<%=session("COLTABBG")%>" class="Estilo13">
				  <td>MANDANTE</td>
				  <td>ASIGNACION</td>
				  <td>CAMPAÑA</td>
				  <% If TraeSiNo(session("perfil_adm")) = "Si" Then %>
				  <td>EJECUTIVO</td>
				  <% End If %>
				</tr>

				<td>
					<select name="CB_CLIENTE">
						<!--option value="100">TODOS</option-->
						<%
						abrirscg()
						ssql="SELECT CODCLIENTE,RAZON_SOCIAL FROM CLIENTE WHERE CODCLIENTE = '" & strCodCliente & "' ORDER BY RAZON_SOCIAL"
						set rsTemp= Conn.execute(ssql)
						if not rsTemp.eof then
							do until rsTemp.eof%>
							<option value="<%=rsTemp("CODCLIENTE")%>"<%if cint(cliente)=rsTemp("CODCLIENTE") then response.Write("Selected") End If%>><%=rsTemp("RAZON_SOCIAL")%></option>
							<%
							rsTemp.movenext
							loop
						end if
						rsTemp.close
						set rsTemp=nothing
						cerrarscg()
						%>
					</select>
				</td>
				<td>
					<select name="CB_REMESA">
						<option value="">TODAS</option>
						<%
						AbrirSCG()
							strSql="SELECT * FROM REMESA WHERE CODREMESA >= 100 and codcliente = '" & strCodCliente & "'"

							strSql="SELECT CONVERT(VARCHAR(10),FECHA_LLEGADA,103) as FECHAREMESA , CODREMESA FROM REMESA WHERE CODCLIENTE = '" & strCodCliente & "' AND CODREMESA >= 100"

							set rsRemesa=Conn.execute(strSql)
							Do While not rsRemesa.eof
							If Trim(intCodRemesa)=Trim(rsRemesa("CODREMESA")) Then strSelRem = "SELECTED" Else strSelRem = ""
							%>
							<option value="<%=rsRemesa("CODREMESA")%>" <%=strSelRem%>> <%=rsRemesa("CODREMESA") & " - " & rsRemesa("FECHAREMESA")%></option>
							<%
							rsRemesa.movenext
							Loop
							rsRemesa.close
							set rsRemesa=nothing
						CerrarSCG()
						''Response.End
						%>
					</select>
				</td>
				<td>
					<select name="CB_CAMPANA">
						<option value="">TODAS</option>
						<%
						AbrirSCG()
							strSql="SELECT * FROM CAMPANA WHERE CODCLIENTE = '" & strCodCliente & "'"
							set rsCampana=Conn.execute(strSql)
							Do While not rsCampana.eof
								If Trim(intCodCampana)=Trim(rsCampana("IDCAMPANA")) Then strSelCam = "SELECTED" Else strSelCam = ""
								%>
								<option value="<%=rsCampana("IDCAMPANA")%>" <%=strSelCam%>> <%=rsCampana("IDCAMPANA") & " - " & rsCampana("NOMBRE")%></option>
								<%
								rsCampana.movenext
							Loop
							rsCampana.close
							set rsCampana=nothing
						CerrarSCG()
						''Response.End
						%>
					</select>
				</td>
				<% If TraeSiNo(session("perfil_adm")) = "Si" Then %>
				<td>
					<select name="CB_EJECUTIVO">
						<option value="0" <%if Trim(strEjeAsig)="0" then response.Write("Selected") end if%>>SELECCIONE</option>
						<%
						AbrirScg()
						strSql="SELECT ID_USUARIO,LOGIN FROM USUARIO WHERE ACTIVO = 1 AND PERFIL_COB = 1"
						''Response.write "strSql=" & strSql
						If trim(intGrupo) <> "" and trim(intGrupo) <> "0" Then
							strSql = strSql & " and grupo = '" & intGrupo & "'"
						End if
						set rsEjecutivo=Conn.execute(strSql)
						if not rsEjecutivo.eof then
							do until rsEjecutivo.eof
							%>
							<option value="<%=rsEjecutivo("ID_USUARIO")%>" <%if Trim(strEjeAsig)=Trim(rsEjecutivo("ID_USUARIO")) then response.Write("selected") end if%>><%=ucase(rsEjecutivo("LOGIN"))%></option>
							<%rsEjecutivo.movenext
							loop
						end if
						rsEjecutivo.close
						set rsEjecutivo=nothing
						CerrarScg()
						%>
					</select>
				</td>
				<% End If%>
			</tr>
	</table>

	<table width="850" align="CENTER" border="0" bordercolor="#FFFFFF">
		<tr bordercolor="#999999"  bgcolor="#<%=session("COLTABBG")%>" class="Estilo13">
			<td>NOMBRE O RAZON SOCIAL</td>
			<td>RUT</td>
			<td>MONTO DESDE</td>
			<td>MONTO HASTA</td>
			<td>TIPO CART</td>
			<td>&nbsp</td>
		</tr>
		<tr bgcolor="#f6f6f6" class="Estilo8">
			<td><input name="TX_NOMBRES" type="text" value="" size="40" maxlength="40"></td>
			<td><input name="TX_RUT" type="text" value="" size="12" maxlength="12"></td>
			<td><input name="TX_DESDE" type="text" value="" size="12" maxlength="12"></td>
			<td><input name="TX_HASTA" type="text" value="" size="12" maxlength="12"></td>
			<td>
				<select name="CB_TIPOCARTERA">
						<option value="GESTIONABLES" <%If Trim(strTipoInf) ="GESTIONABLES" Then Response.write "SELECTED"%>>GESTIONABLES</option>
						<option value="NOGESTIONABLES" <%If Trim(strTipoInf) ="NOGESTIONABLES" Then Response.write "SELECTED"%>>NO GESTIONABLES</option>
						<option value="PENDIENTES" <%If Trim(strTipoInf) ="PENDIENTES" Then Response.write "SELECTED"%>>PENDIENTES</option>
						<option value="GESTIONADOS" <%If Trim(strTipoInf) ="GESTIONADOS" Then Response.write "SELECTED"%>>GESTIONADOS</option>


						<option value="TODOS" <%If Trim(strTipoInf) ="TODOS" Then Response.write "SELECTED"%>>TODOS</option>
				</select>
			</td>
			<td><input name="Buscar" type="button" value="Buscar"  onClick="buscar();"></td>
		</tr>
	</table>

	<table width="850" align="CENTER">
		<tr bgcolor="#<%=session("COLTABBG")%>" class="Estilo13">
			<td width="60%" align="center"><%=strMensaje%></td>
		</tr>
	</table>





				<%
					AbrirSCG()

					strSql = "SELECT CUOTA.RUTDEUDOR, NOMBREDEUDOR, MIN(ESTADO_DEUDA) AS ESTADO_DEUDA, SUM(SALDO) as SALDO, CUOTA.CODCLIENTE as CODCLIENTE, deudor.Expediente "
					strSql = strSql & " FROM DEUDOR , CUOTA	WHERE DEUDOR.RUTDEUDOR = CUOTA.RUTDEUDOR "
					strSql = strSql & " AND CUOTA.CODCLIENTE = '" & strCodCliente & "' AND DEUDOR.CODCLIENTE = CUOTA.CODCLIENTE "


					If trim(strEjeAsig) = "0" OR trim(strEjeAsig) = "" Then
						If TraeSiNo(session("perfil_adm")) <> "Si" and TraeSiNo(session("perfil_sup")) <> "Si"Then
							strSql = strSql & " AND USUARIO_ASIG = " & session("session_idusuario")
						End If
					Else
						strSql = strSql & " AND USUARIO_ASIG = " & strEjeAsig
					End if

					strParametro = "0"

					If Trim(strNombres) <> "" Then
						strSql = strSql & " AND NOMBREDEUDOR  LIKE '%" & strNombres & "%'"
						strParametro = "1"
					End if

					If Trim(strRut) <> "" Then
						strSql = strSql & " AND CUOTA.RUTDEUDOR  LIKE '" & strRut & "%'"
						strParametro = "1"
					End if

					If Trim(intCodRemesa) <> "0" and Trim(intCodRemesa) <> "" Then
						strSql = strSql & " AND CUOTA.CODREMESA = " & intCodRemesa
						strParametro = "1"
					End if

					If Trim(intCodCampana) <> "0" and Trim(intCodCampana) <> "" Then
						strSql = strSql & " AND CUOTA.RUTDEUDOR IN (SELECT RUTDEUDOR FROM DEUDOR WHERE CODCLIENTE = '" & strCodCliente & "' AND IDCAMPANA = " & intCodCampana & ")"
						strParametro = "1"
					End if

					If Trim(strTipoInf)="NOGESTIONABLES" Then
						strSql = strSql & " AND DEUDOR.RUTDEUDOR NOT IN (SELECT DISTINCT RUTDEUDOR FROM DEUDOR_TELEFONO WHERE ESTADO IN (0,1))"
					End If

					If Trim(strTipoInf)="GESTIONABLES" Then
							strSql = strSql & " AND DEUDOR.RUTDEUDOR IN (SELECT DISTINCT RUTDEUDOR FROM DEUDOR_TELEFONO WHERE ESTADO IN (0,1))"
					End If

					If Trim(strTipoInf)="PENDIENTES" Then
						strSql = strSql & " AND DEUDOR.RUTDEUDOR NOT IN (SELECT DISTINCT RUTDEUDOR FROM GESTIONES WHERE CODCLIENTE = '" & strCodCliente & "')"
						'strSql = strSql & " AND DEUDOR.RUTDEUDOR IN (SELECT DISTINCT RUTDEUDOR FROM DEUDOR_TELEFONO WHERE ESTADO IN (0,1)) "
					End If

					If Trim(strTipoInf)="GESTIONADOS" Then
						strSql = strSql & " AND DEUDOR.RUTDEUDOR IN (SELECT DISTINCT RUTDEUDOR FROM GESTIONES WHERE CODCLIENTE = '" & strCodCliente & "')"
					End If


					strSql = strSql & " GROUP BY CUOTA.RUTDEUDOR, NOMBREDEUDOR, CUOTA.CODCLIENTE, deudor.Expediente"
					If Trim(strDesde) = "" Then strDesde = "0"
					If Trim(strDesde) <> "" Then
						strSql = strSql & " HAVING SUM(CUOTA.SALDO) >= " & strDesde
						strParametro = "1"
					End if

					If Trim(strHasta) <> "" Then
						strSql = strSql & " AND SUM(CUOTA.SALDO) <= " & strHasta
						strParametro = "1"
					End if

					strSql = strSql & " ORDER BY SUM(SALDO) DESC, ESTADO_DEUDA"

					'rESPONSE.WRITE "strSql=" & strSql
					'rESPONSE.eND

					set rsCuota=Server.CreateObject("ADODB.Recordset")
					rsCuota.Open strSql, Conn, 1, 2
					intTotalSaldo = 0
					intTotalRut = 0

					' Defino el tamaño de las páginas
					rsCuota.PageSize=TamPagina
					rsCuota.CacheSize=TamPagina
					PaginasTotales=rsCuota.PageCount
					''Response.write "PaginaActual=" & PaginasTotales

					'Compruebo que la pagina actual está en el rango
					if PaginaActual < 1 then
						PaginaActual = 1
					end if
					if PaginaActual > PaginasTotales then
						PaginaActual = PaginasTotales
					end if

					'Por si la consulta no devuelve registros!
					if PaginasTotales=0 then
						strMensaje = "No se encontraron resultados"
					else
						strMensaje = "Resultado Búsqueda"
						rsCuota.AbsolutePage=PaginaActual
					End If


					sintPagina = PaginaActual
					sintTotalPaginas = PaginasTotales
					%>


					  <table width="850" align="CENTER">
						<tr bgcolor="#<%=session("COLTABBG")%>" class="Estilo13">
							<td>RUT</td>
							<td>NOMBRE O RAZON SOCIAL</td>
							<td>SALDO</td>
							<td>ESTADO DEUDA</td>
							<td>ULT.GESTION</td>
							<td>F.AGEND.</td>
							<td>&nbsp;</td>
							<td>&nbsp</td>
							<td>&nbsp</td>
						</tr>
						<TR>
							<TD COLSPAN=9>
								<TABLE BORDER=0 CELLSPACING=0 CELLPADDING=0 WIDTH="100%">
									<TR BGCOLOR="#F3F3F3">
										<TD WIDTH="20%" ALIGN=left>
											<%if PaginaActual > 1 then %>
											<INPUT TYPE=BUTTON NAME="Retroceder" VALUE="  &lt;  " onClick="IrPagina( 'Retroceder')">
											<% end if %>
										</TD>
										<TD WIDTH="60%" ALIGN=center>
											<FONT FACE="verdana, Sans-Serif" Size=1 COLOR="#FF0000"><b>Página <%= sintPagina %> de <%= sintTotalPaginas %></b></FONT>
										</TD>
										<TD WIDTH="20%" ALIGN=right>
											<%if PaginaActual < PaginasTotales then%>
											<INPUT TYPE=BUTTON NAME="Avanzar" VALUE="  &gt;  " onClick="IrPagina( 'Avanzar')">
											<% end if %>
										</TD>
									</TR>
								</TABLE>
							</TD>
						</TR>

						<TR>
							<TD COLSPAN=8 ALIGN="CENTER">
								<%=strMensaje%>
							</TD>
						</TR>
					<%

						If Not rsCuota.eof Then
							totalventa=0
							Do while not rsCuota.eof and CuantosRegistros < TamPagina

								'strSqlG = "SELECT * FROM GESTIONES WHERE CODCLIENTE = " & strCodCliente
								'set rsGestion=Conn.execute(strSqlG)
								'If rsGestion.eof Then
								'	strbgcolor="#F6F6F6"
								'Else
								'	strbgcolor="#F6F6CF"
								'End If

								strSql = "SELECT TOP 1 FECHAINGRESO, CONVERT(VARCHAR(10),FECHA_AGENDAMIENTO,103) AS FECHA_AGENDAMIENTO2 , IsNull(FECHA_AGENDAMIENTO,GETDATE()-1) as FECHA_AGENDAMIENTO, GETDATE() , DATEDIFF(day,FECHA_AGENDAMIENTO,GETDATE()) AS DIFERENCIA FROM GESTIONES WHERE CODCLIENTE='" & strCodCliente & "' AND RUTDEUDOR = '" & Trim(rsCuota("RUTDEUDOR")) & "' ORDER BY ID_GESTION DESC"
								'REsponse.write "strSql = " & strSql
								'REsponse.End
								set rsFecha=Conn.execute(strSql)
								If Not rsFecha.Eof Then
									dtmFecUG = rsFecha("FECHAINGRESO")
									dtmDif = rsFecha("DIFERENCIA")
									dtmFecAgend = rsFecha("FECHA_AGENDAMIENTO2")
								Else
									dtmFecUG = ""
									dtmDif = "9999999999"
									dtmFecAgend = ""
								End If

								'Response.write "<br>DIFERENCIA=" & dtmDif
								'Response.write "<br>dtmFecUG=" & dtmFecUG
								'Response.write "<br>FECHA_AGENDAMIENTO=" & rsFecha("FECHA_AGENDAMIENTO")
								'Response.write "<br>FECHAINGRESO=" & rsFecha("FECHAINGRESO")

								If (dtmDif >= 0) or (dtmDif = "") or IsNull(dtmDif) or (dtmDif = "9999999999") Then
									If (dtmDif > 4) Then
										strColorG="cuad_rojo_15.jpg"
									Else
										'Response.write "<br>dtmFecAgend=-" & dtmFecAgend & "-"
										if Trim(dtmFecAgend) = "" or IsNull(dtmFecAgend) Then
											strColorG="cuad_rojo_15.jpg"
										Else
											strColorG="cuad_amarillo_15.jpg"
										End If
									End If
								Else
									strColorG="cuad_verde_15.jpg"
								End If
								''rESPONSE.WRITE "valor_moneda=" & session("valor_moneda")
								intValorSaldo = Round(session("valor_moneda") * ValNulo(rsCuota("SALDO"),"N"),0)
								intTotalSaldo = intTotalSaldo + intValorSaldo
								intTotalRut = intTotalRut + 1

								%>
									<tr bgcolor="<%=strbgcolor%>" class="Estilo8">
										<td ALIGN="right"><%=rsCuota("RUTDEUDOR")%></td>
										<td><%=rsCuota("NOMBREDEUDOR")%></td>
										<td ALIGN="right"><%=FN(intValorSaldo,0)%></td>
										<td ALIGN="center"><%=TraeCampoId(Conn, "DESCRIPCION", rsCuota("ESTADO_DEUDA"), "ESTADO_DEUDA", "CODIGO")%></td>
										<td ALIGN="center"><%=dtmFecUG%></td>
										<td ALIGN="center"><%=dtmFecAgend%></td>
										<td ALIGN="right"><img src="../images/<%=strColorG%>" border="0"></td>
										<td>
											<A HREF="principal.asp?rut=<%=rsCuota("RUTDEUDOR")%>">
												<acronym title="Llevar a pantalla de selección">Seleccionar</acronym>
											</A>
										</td>
										<td>
											<% If TraeSiNo(session("perfil_adm")) = "Si" Then %>
											<A HREF="asigna_manual.asp?strCodCliente=<%=rsCuota("CODCLIENTE")%>&strRutDeudor=<%=rsCuota("RUTDEUDOR")%>">
												<acronym title="Asigna Deudor">Asignar</acronym>
											</A>
											<% End If%>
										</td>
									</tr>
								<%
								CuantosRegistros=CuantosRegistros+1
								rsCuota.movenext
							Loop
						End If
					rsCuota.close
					set rsCuota=NOTHING
					%>
					<TR>
						<TD COLSPAN=9>
							<TABLE BORDER=0 CELLSPACING=0 CELLPADDING=0 WIDTH="100%">
								<TR BGCOLOR="#F3F3F3">
									<TD WIDTH="20%" ALIGN=left>
										<%if PaginaActual > 1 then %>
										<INPUT TYPE=BUTTON NAME="Retroceder" VALUE="  &lt;  " onClick="IrPagina( 'Retroceder')">
										<% end if %>
									</TD>
									<TD WIDTH="60%" ALIGN=center>
										<FONT FACE="verdana, Sans-Serif" Size=1 COLOR="#FF0000"><b>Página <%= sintPagina %> de <%= sintTotalPaginas %></b></FONT>
									</TD>
									<TD WIDTH="20%" ALIGN=right>
										<%if PaginaActual < PaginasTotales then%>
										<INPUT TYPE=BUTTON NAME="Avanzar" VALUE="  &gt;  " onClick="IrPagina( 'Avanzar')">
										<% end if %>
									</TD>
								</TR>
							</TABLE>
						</TD>
					</TR>
					<tr>
						<td bgcolor="#<%=session("COLTABBG")%>" class="Estilo13">Totales</td>
						<td bgcolor="#<%=session("COLTABBG2")%>" span class="Estilo28" align="right"  colspan=2>$ <%=FN(intTotalSaldo,0)%></td>
						<td bgcolor="#<%=session("COLTABBG2")%>" span class="Estilo28" align="center" colspan=6>Total Rut : <%=intTotalRut%> </td>
					</tr>
			</table>

		<table width="850" align="CENTER">
			<tr bgcolor="#<%=session("COLTABBG")%>" class="Estilo13">
				<td bgcolor="#<%=session("COLTABBG")%>" class="Estilo13">Fecha asignacion </td>
				<td align="right">01/09/2007</td>
				<td bgcolor="#<%=session("COLTABBG")%>" class="Estilo13">Fecha cierre</td>
				<td align="right">30/09/2007</td>
			</tr>
		</table>
</form>
</body>
<script language="JavaScript1.2">

function buscar(){
	datos.action='cartera_asignada.asp?strBuscar=S';
	datos.submit();

}

function IrPagina( sintAccion ) {
	if (sintAccion == 'Retroceder') {
    	self.location.href = 'cartera_asignada.asp?pagina=<%=PaginaActual - 1%>&TX_NOMBRES=<%=strNombres%>&CB_REMESA=<%=intCodRemesa%>&CB_CLIENTE=<%=strCodCliente%>&CB_EJECUTIVO=<%=strEjeAsig%>&CB_CAMPANA=<%=intCodCampana%>&CB_TIPOCARTERA=<%=strTipoInf%>'
    }
    if (sintAccion == 'Avanzar') {
	    self.location.href = 'cartera_asignada.asp?pagina=<%=PaginaActual + 1%>&TX_NOMBRES=<%=strNombres%>&CB_REMESA=<%=intCodRemesa%>&CB_CLIENTE=<%=strCodCliente%>&CB_EJECUTIVO=<%=strEjeAsig%>&CB_CAMPANA=<%=intCodCampana%>&CB_TIPOCARTERA=<%=strTipoInf%>'
    }

}

</script>