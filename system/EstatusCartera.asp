<%@ LANGUAGE="VBScript" %>
<!--#include file="sesion.asp"-->
<!--#include file="arch_utils.asp"-->
<!--#include file="../lib/comunes/rutinas/funciones.inc" -->
<!--#include file="asp/comunes/general/rutinasBooleano.inc" -->

<%


	strCliente=Request("CB_CLIENTE")
	intEjecutivo=Request("CB_EJECUTIVO")
	intRemesa=Request("CB_REMESA")

	If Trim(strCliente) = "" Then
		strCliente = session("ses_codcli")
	End if
	If Trim(strCliente) = "" Then
		strCliente = "1000"
	End if

	If Trim(intRemesa) = "" Then intRemesa = "100"

	If (TraeSiNo(session("perfil_adm")) <> "Si" and TraeSiNo(session("perfil_sup")) <> "Si") or trim(intEjecutivo) <> "" Then
		If trim(intEjecutivo) <> "" Then
			strSqlUsuario = " AND USUARIO_ASIG = " & intEjecutivo
		Else
			strSqlUsuario = " AND USUARIO_ASIG = " & session("session_idusuario")
		End if
	End if

	abrirscg()

		strSql="SELECT FECHA_CARGA AS FECHA_INICIO, FECHA_TERMINO,300 AS META_RUT_PORC, 400 AS META_MONTO_PORC FROM REMESA WHERE CODCLIENTE = '" & strCliente & "' AND CODREMESA = " & intRemesa
		set rsTemp= Conn.execute(strSql)
		If not rsTemp.eof then
			strFechaInicio = rsTemp("FECHA_INICIO")
			strFechaTermino = rsTemp("FECHA_TERMINO")
			intMetaRutPorc = rsTemp("META_RUT_PORC")
			intMetaMontoPorc = rsTemp("META_MONTO_PORC")

		Else
			strFechaInicio = ""
			strFechaTermino = ""
			intMetaRutPorc = ""
			intMetaMontoPorc = ""
		End if
		rsTemp.close
		set rsTemp=nothing

		strSql="SELECT MAX(FECHA_CARGA) AS ULTACT FROM REMESA_ACT CUOTA WHERE CODCLIENTE = '" & strCliente & "' AND CODREMESA = " & intRemesa
		set rsTemp= Conn.execute(strSql)
		If not rsTemp.eof then
			strUltAct = rsTemp("ULTACT")
		Else
			strUltAct = rsTemp("ULTACT")
		End if
		rsTemp.close
		set rsTemp=nothing



		If Trim(Request("CB_REMESA"))="" Then
			strSql = "SELECT COUNT(DISTINCT RUTDEUDOR) as CUANTOS , SUM(SALDO) as MONTO FROM CUOTA WHERE CODCLIENTE = '" & strCliente & "' " & strSqlUsuario
		Else
			strSql = "SELECT COUNT(DISTINCT RUTDEUDOR) as CUANTOS , SUM(SALDO) as MONTO FROM CUOTA WHERE CODCLIENTE = '" & strCliente & "' AND CODREMESA = " & intRemesa & strSqlUsuario
		End If


		strSql = strSql & " AND RUTDEUDOR NOT IN (SELECT DISTINCT RUTDEUDOR FROM GESTIONES WHERE CODCLIENTE = '" & strCliente & "')"
		strSql = strSql & " AND RUTDEUDOR IN (SELECT DISTINCT RUTDEUDOR FROM DEUDOR_TELEFONO WHERE ESTADO IN (0,1))"


		'Response.write "<br>strSql NG=" &strSql
		'Response.End

		set rsTemp= Conn.execute(strSql)
		If not rsTemp.eof then
			intCasosNoGestionados = rsTemp("CUANTOS")
			intMontoNoGestionado = rsTemp("MONTO")
		Else
			intCasosNoGestionados = 0
			intMontoNoGestionado = 0
		End if
		rsTemp.close
		set rsTemp=nothing




		If Trim(Request("CB_REMESA"))="" Then
			strSql = "SELECT COUNT(DISTINCT RUTDEUDOR) as CUANTOS , SUM(SALDO) as MONTO FROM CUOTA WHERE CODCLIENTE = '" & strCliente & "' " & strSqlUsuario
		Else
			strSql = "SELECT COUNT(DISTINCT RUTDEUDOR) as CUANTOS , SUM(SALDO) as MONTO FROM CUOTA WHERE CODCLIENTE = '" & strCliente & "' AND CODREMESA = " & intRemesa & strSqlUsuario
		End If

		strSql = strSql & " AND RUTDEUDOR IN (SELECT DISTINCT RUTDEUDOR FROM DEUDOR_TELEFONO WHERE ESTADO IN (0,1))"
		'Response.write "<br>strSql G=" &strSql

		set rsTemp= Conn.execute(strSql)
		If not rsTemp.eof then
			intCasosGestionable = rsTemp("CUANTOS")
			intMontoGestionable = rsTemp("MONTO")
		Else
			intCasosGestionable = 0
			intMontoGestionable = 0
		End if
		rsTemp.close
		set rsTemp=nothing



		If Trim(Request("CB_REMESA"))="" Then
			strSql = "SELECT COUNT(DISTINCT RUTDEUDOR) as CUANTOS , SUM(SALDO) as MONTO FROM CUOTA WHERE CODCLIENTE = '" & strCliente & "' " & strSqlUsuario
		Else
			strSql = "SELECT COUNT(DISTINCT RUTDEUDOR) as CUANTOS , SUM(SALDO) as MONTO FROM CUOTA WHERE CODCLIENTE = '" & strCliente & "' AND CODREMESA = " & intRemesa & strSqlUsuario
		End If


		strSql = strSql & " AND RUTDEUDOR IN (SELECT DISTINCT RUTDEUDOR FROM GESTIONES WHERE CODCLIENTE = '" & strCliente & "')"
		strSql = strSql & " AND RUTDEUDOR IN (SELECT DISTINCT RUTDEUDOR FROM DEUDOR_TELEFONO WHERE ESTADO IN (0,1))"


		'Response.write "<br>strSql NG=" &strSql
		'Response.End

		set rsTemp= Conn.execute(strSql)
		If not rsTemp.eof then
			intCasosGestionados = rsTemp("CUANTOS")
			intMontoGestionado = rsTemp("MONTO")
		Else
			intCasosGestionados = 0
			intMontoGestionado = 0
		End if
		rsTemp.close
		set rsTemp=nothing


		If Trim(Request("CB_REMESA"))="" Then
			strSql = "SELECT COUNT(DISTINCT RUTDEUDOR) as CUANTOS , SUM(SALDO) as MONTO FROM CUOTA WHERE CODCLIENTE = '" & strCliente & "' " & strSqlUsuario
		Else
			strSql = "SELECT COUNT(DISTINCT RUTDEUDOR) as CUANTOS , SUM(SALDO) as MONTO FROM CUOTA WHERE CODCLIENTE = '" & strCliente & "' AND CODREMESA = " & intRemesa & strSqlUsuario
		End If


		''strSql = strSql & " AND RUTDEUDOR IN (SELECT RUTDEUDOR FROM DEUDOR_ASIGNACION WHERE CODCLIENTE = '" & strCliente & "' AND TIPO_ASIG = 'TEL')"

		set rsTemp= Conn.execute(strSql)
		If not rsTemp.eof then
			intCasosTelefonica = rsTemp("CUANTOS")
			intMontoTelefonica = rsTemp("MONTO")
		Else
			intCasosTelefonica = 0
			intMontoTelefonica = 0
		End if
		rsTemp.close
		set rsTemp=nothing

		'Response.write "strSql=" &strSql
		'Response.End



		If Trim(Request("CB_REMESA"))="" Then
			strSql = "SELECT COUNT(DISTINCT RUTDEUDOR) as CUANTOS , SUM(SALDO) as MONTO FROM CUOTA WHERE CODCLIENTE = '" & strCliente & "' " & strSqlUsuario
		Else
				strSql = "SELECT COUNT(DISTINCT RUTDEUDOR) as CUANTOS , SUM(SALDO) as MONTO FROM CUOTA WHERE CODCLIENTE = '" & strCliente & "' AND CODREMESA = " & intRemesa & strSqlUsuario
		End If


		'strSql = strSql & " AND RUTDEUDOR IN (SELECT RUTDEUDOR FROM DEUDOR_ASIGNACION WHERE CODCLIENTE = '" & strCliente & "' AND TIPO_ASIG = 'TERR')"

		set rsTemp= Conn.execute(strSql)
		If not rsTemp.eof then
			intCasosTerreno = rsTemp("CUANTOS")
			intMontoTerreno = rsTemp("MONTO")
		Else
			intCasosTerreno = 0
			intMontoTerreno = 0
		End if
		rsTemp.close
		set rsTemp=nothing




		If Trim(Request("CB_REMESA"))="" Then
			strSql = "SELECT COUNT(DISTINCT(RUTDEUDOR)) as RUT, IsNull(COUNT(NRODOC),0) as FOLIO, IsNull(SUM(VALORCUOTA),0) as MONTO FROM CUOTA WHERE CODCLIENTE = '" & strCliente & "'" & strSqlUsuario
		Else
			strSql = "SELECT COUNT(DISTINCT(RUTDEUDOR)) as RUT, IsNull(COUNT(NRODOC),0) as FOLIO, IsNull(SUM(VALORCUOTA),0) as MONTO FROM CUOTA WHERE CODCLIENTE = '" & strCliente & "' AND CODREMESA = " & intRemesa & strSqlUsuario
		End If


		strSql = strSql & " AND SALDO = 0 AND ESTADO_DEUDA IN (3,4)"
		set rsTemp= Conn.execute(strSql)
		If not rsTemp.eof then
			intRutConPagos = rsTemp("RUT")
			intFoliosConPagos = rsTemp("FOLIO")
			intMontosConPagos = rsTemp("MONTO")
		Else
			intRutConPagos = 0
			intFoliosConPagos = 0
			intMontosConPagos = 0
		End if
		rsTemp.close
		set rsTemp=nothing


		If Trim(Request("CB_REMESA"))="" Then
			strSql = "SELECT COUNT(DISTINCT(RUTDEUDOR)) as RUT, IsNull(COUNT(NRODOC),0) as FOLIO, IsNull(SUM(VALORCUOTA),0) as MONTO FROM CUOTA WHERE CODCLIENTE = '" & strCliente & "'" & strSqlUsuario
		Else
			strSql = "SELECT COUNT(DISTINCT(RUTDEUDOR)) as RUT, IsNull(COUNT(NRODOC),0) as FOLIO, IsNull(SUM(VALORCUOTA),0) as MONTO FROM CUOTA WHERE CODCLIENTE = '" & strCliente & "' AND CODREMESA = " & intRemesa & strSqlUsuario
		End If



		strSql = strSql & " AND SALDO >= 0 AND ESTADO_DEUDA = '1'"
		set rsTemp= Conn.execute(strSql)
		If not rsTemp.eof then
			intCasosActivos = rsTemp("RUT")
			intFoliosActivo = rsTemp("FOLIO")
			intMontoActivo = rsTemp("MONTO")
		Else
			intCasosActivos = 0
			intFoliosActivo = 0
			intMontoActivo = 0
		End if
		rsTemp.close
		set rsTemp=nothing

		If Trim(Request("CB_REMESA"))="" Then
			strSql = "SELECT COUNT(DISTINCT(RUTDEUDOR)) as RUT, IsNull(COUNT(NRODOC),0) as FOLIO, IsNull(SUM(VALORCUOTA),0) as MONTO FROM CUOTA WHERE CODCLIENTE = '" & strCliente & "'" & strSqlUsuario
		Else
			strSql = "SELECT COUNT(DISTINCT(RUTDEUDOR)) as RUT, IsNull(COUNT(NRODOC),0) as FOLIO, IsNull(SUM(VALORCUOTA),0) as MONTO FROM CUOTA WHERE CODCLIENTE = '" & strCliente & "' AND CODREMESA = " & intRemesa & strSqlUsuario
		End If

		strSql = strSql & " AND SALDO >= 0 AND ESTADO_DEUDA = '2'"
		set rsTemp= Conn.execute(strSql)
		If not rsTemp.eof then
			intCasosRetiros = rsTemp("RUT")
			intFoliosRetiro = rsTemp("FOLIO")
			intMontoRetiro = rsTemp("MONTO")
		Else
			intCasosRetiros = 0
			intFoliosRetiro = 0
			intMontoRetiro = 0
		End if
		rsTemp.close
		set rsTemp=nothing


		'Response.write "strSql=" &strSql
		'Response.End


		If Trim(Request("CB_REMESA"))="" Then
			strSql = "SELECT COUNT(DISTINCT(RUTDEUDOR)) as RUT, IsNull(COUNT(NRODOC),0) as FOLIO, IsNull(SUM(VALORCUOTA),0) as MONTO FROM CUOTA WHERE CODCLIENTE = '" & strCliente & "'" & strSqlUsuario & " AND RUTDEUDOR IN ("
		Else
			strSql = "SELECT COUNT(DISTINCT(RUTDEUDOR)) as RUT, IsNull(COUNT(NRODOC),0) as FOLIO, IsNull(SUM(VALORCUOTA),0) as MONTO FROM CUOTA WHERE CODCLIENTE = '" & strCliente & "' AND CODREMESA = " & intRemesa & strSqlUsuario & " AND RUTDEUDOR IN ("
		End If


		If Trim(Request("CB_REMESA"))="" Then
			strSql = strSql & " SELECT DISTINCT(RUTDEUDOR) FROM CUOTA WHERE CODCLIENTE = '" & strCliente & "'"
		Else
			strSql = strSql & " SELECT DISTINCT(RUTDEUDOR) FROM CUOTA WHERE CODCLIENTE = '" & strCliente & "' AND CODREMESA = " & intRemesa
		End If

		strSql = strSql & " GROUP BY RUTDEUDOR HAVING SUM(SALDO) = 0)"
		'Response.write strSql

		set rsTemp= Conn.execute(strSql)
		If not rsTemp.eof then
			intRutConPagoTotal = rsTemp("RUT")
			intFoliosConPagoTotal = rsTemp("FOLIO")
			intMontosConPagoTotal = rsTemp("MONTO")
		Else
			intRutConPagoTotal = 0
			intFoliosConPagoTotal = 0
			intMontosConPagoTotal = 0
		End if
		rsTemp.close
		set rsTemp=nothing

		'Response.write "intRutConPagoTotal = " & intRutConPagoTotal

		If Trim(Request("CB_REMESA"))="" Then
			strSql = "SELECT COUNT(DISTINCT(RUTDEUDOR)) as RUT, IsNull(COUNT(NRODOC),0) as FOLIO, IsNull(SUM(VALORCUOTA),0) as MONTO FROM CUOTA WHERE CODCLIENTE = '" & strCliente & "'" & strSqlUsuario & " AND SALDO = 0 AND RUTDEUDOR NOT IN ("
		Else
			strSql = "SELECT COUNT(DISTINCT(RUTDEUDOR)) as RUT, IsNull(COUNT(NRODOC),0) as FOLIO, IsNull(SUM(VALORCUOTA),0) as MONTO FROM CUOTA WHERE CODCLIENTE = '" & strCliente & "' AND CODREMESA = " & intRemesa & strSqlUsuario & " AND SALDO = 0 AND RUTDEUDOR NOT IN ("
		End If


		If Trim(Request("CB_REMESA"))="" Then
			strSql = strSql & " SELECT DISTINCT(RUTDEUDOR) FROM CUOTA WHERE CODCLIENTE = '" & strCliente & "'"
		Else
			strSql = strSql & " SELECT DISTINCT(RUTDEUDOR) FROM CUOTA WHERE CODCLIENTE = '" & strCliente & "' AND CODREMESA = " & intRemesa
		End If


		strSql = strSql & " GROUP BY RUTDEUDOR HAVING SUM(SALDO) = 0)"
		'Response.write strSql

		set rsTemp= Conn.execute(strSql)
		If not rsTemp.eof then
			intRutConPagoParcial = rsTemp("RUT")
			intFoliosConPagoParcial = rsTemp("FOLIO")
			intMontosConPagoParcial= rsTemp("MONTO")
		Else
			intRutConPagoParcial = 0
			intFoliosConPagoParcial = 0
			intMontosConPagoParcial = 0
		End if
		rsTemp.close
		set rsTemp=nothing


		If Trim(Request("CB_REMESA"))="" Then
			strSql="SELECT IsNull(COUNT(DISTINCT RUTDEUDOR),0) AS CUANTOS, IsNull(SUM(SALDO),0) AS SUMA FROM CUOTA WHERE CODCLIENTE = '" & strCliente & "' " & strSqlUsuario
		Else
			strSql="SELECT IsNull(COUNT(DISTINCT RUTDEUDOR),0) AS CUANTOS, IsNull(SUM(SALDO),0) AS SUMA FROM CUOTA WHERE CODCLIENTE = '" & strCliente & "' AND CODREMESA = " & intRemesa  & strSqlUsuario
		End If


		set rsTemp= Conn.execute(strSql)
		If not rsTemp.eof then
			intTotalProceso = rsTemp("CUANTOS")
			intTotalMontoProceso = rsTemp("SUMA")
		Else
			intTotalProceso = 0
			intTotalMontoProceso = 0
		End if
		rsTemp.close
		set rsTemp=nothing

		If Trim(Request("CB_REMESA"))="" Then
			strSql="SELECT IsNull(COUNT(DISTINCT RUTDEUDOR),0) AS CUANTOS, IsNull(SUM(SALDO),0) AS SUMA FROM CUOTA WHERE CODCLIENTE = '" & strCliente & "' AND ESTADO_DEUDA NOT IN (2,6) " & strSqlUsuario
		Else
			strSql="SELECT IsNull(COUNT(DISTINCT RUTDEUDOR),0) AS CUANTOS, IsNull(SUM(SALDO),0) AS SUMA FROM CUOTA WHERE CODCLIENTE = '" & strCliente & "' AND ESTADO_DEUDA NOT IN (2,6) AND CODREMESA = " & intRemesa  & strSqlUsuario
		End If
		set rsTemp= Conn.execute(strSql)
		If not rsTemp.eof then
			intTotalRetiro = rsTemp("CUANTOS")
			intTotalMontoRetiro = rsTemp("SUMA")
		Else
			intTotalRetiro = 0
			intTotalMontoRetiro = 0
		End if
		rsTemp.close
		set rsTemp=nothing


		'Response.write "strSql=" &strSql
		'Response.End

	cerrarscg()

	intMetaRut = Round(ValNulo(intCasosGestionable,"N") * ValNulo(intMetaRutPorc,"N")/100,0)
	intMetaMonto = Round(ValNulo(intCasosGestionable,"N") * ValNulo(intMetaMontoPorc,"N")/100,0)

	if intMetaRut = 0 Then intMetaRut = 1
	intAvanceMeta = Round((intRutConPagos * 100) / intMetaRut,1)

	'Response.write "strSql=" &strSql
	'Response.End

	'Response.write "<br>intTotalProceso=" & intTotalProceso
	'Response.write "<br>intCasosGestionable=" & intCasosGestionable

	intCasosNoGestionable = intTotalProceso - intCasosGestionable
	intMontoNoGestionable = intTotalMontoProceso - intMontoGestionable





%>

<HTML>

<HEAD><TITLE>Menú</TITLE>
<LINK rel="stylesheet" TYPE="text/css" HREF="isk_style.css">

<style type="text/css">
.style1 {
	font-family: Arial, Helvetica, sans-serif;
	font-weight: bold;
	font-size: 12px;
	color: #FFFF00;
}
</style>

</HEAD>

<BODY bgcolor="#000000">

<TABLE WIDTH="852" align = "CENTER" border=0 cellspacing=0>
    <TR HEIGHT="25" VALIGN="MIDDLE">
        <TD ALIGN=CENTER background="../images/top_plomo_ch.jpg" CLASS="txt8">
			<B>ESTADO CARTERA</B>
		</TD>
    </TR>
	<TR HEIGHT="20" VALIGN="MIDDLE" BGCOLOR="#EEEEEE">
		<TD ALIGN=CENTER>&nbsp;

	  </TD>
    </TR>
</TABLE>


<table width="852" align="CENTER" border="1" bordercolor = "#<%=session("COLTABBG")%>" cellSpacing=0 cellPadding=1>


<tr>
	<td WIDTH="190" rowspan="2" ALIGN="CENTER">
		<TABLE BORDER=0 CELLSPACING=0 CELLPADDING=0 VALIGN="TOP">
			<TR>
				<TD align="CENTER" colspan=2 WIDTH="190"><b>Medidor Efectividad</b></TD>
			<TR>
				<TD>Rut</TD>
				<TD ALIGN="RIGHT">Meta</TD>
			<TR>
				<TD>0</TD>
				<TD ALIGN="RIGHT"><%=intMetaRut%></TD>
			<TR>
				<TD COLSPAN=2 background="../images/indicador3.jpg" CLASS="txt8" WIDTH="190" VALIGN="BOTTOM">
				&nbsp;<img VALIGN="TOP" src="../images/ind_azul.jpg" WIDTH="<%=Round(intAvanceMeta,0)%>%" height="5">
				</TD>
			<TR>
				<TD WIDTH="<%=intAvanceMeta%>%" ALIGN="LEFT">&nbsp;</TD>
				<TD WIDTH="<%=100-intAvanceMeta%>%" ALIGN="LEFT">
					<%=intAvanceMeta%>%				</TD>
			<TR HEIGHT="100"><TD COLSPAN=2>&nbsp;</TD>
			<TR>
				<TD COLSPAN=2>
					<FORM name="datos" method="post">
					<TABLE BORDER=0 CELLSPACING=0 CELLPADDING=0>
						<TR>
							<TD class="Estilo2">
							Cliente							</TD>
						<TR>
							<TD>
								<select name="CB_CLIENTE" onChange="envia();">
									<%
									abrirscg()
									If TraeSiNo(session("perfil_adm")) = "Si" or TraeSiNo(session("perfil_sup")) = "Si" Then
										ssql="SELECT CODCLIENTE,RAZON_SOCIAL, NOMBRE_FANTASIA FROM CLIENTE WHERE CODCLIENTE IN (SELECT CODCLIENTE FROM USUARIO_CLIENTE WHERE ID_USUARIO = " & session("session_idusuario") & ") AND ACTIVO = 1 ORDER BY CODCLIENTE,RAZON_SOCIAL ASC"
									Else
										ssql="SELECT CODCLIENTE,RAZON_SOCIAL, NOMBRE_FANTASIA FROM CLIENTE WHERE CODCLIENTE = '" & strCliente & "' AND CODCLIENTE IN (SELECT CODCLIENTE FROM USUARIO_CLIENTE WHERE ID_USUARIO = " & session("session_idusuario") & ") AND ACTIVO = 1 ORDER BY CODCLIENTE,RAZON_SOCIAL ASC"
									End If
									set rsTemp= Conn.execute(ssql)
									if not rsTemp.eof then
										do until rsTemp.eof%>
										<option value="<%=rsTemp("CODCLIENTE")%>"<%if Trim(strCliente)=rsTemp("CODCLIENTE") then response.Write("Selected") End If%>><%=rsTemp("NOMBRE_FANTASIA")%></option>
										<%
										rsTemp.movenext
										loop
									end if
									rsTemp.close
									set rsTemp=nothing
									cerrarscg()
									%>
								</select>
							</TD>
						</TR>
						<TR><TD>&nbsp;</TD>
						<TR>
							<TD class="Estilo2">
								Cartera
							</TD>
						</TR>
						<TR>
							<%if Trim(Request("CB_REMESA")) = "" then intRemesa="" End If%>
							<TD>
								<select name="CB_REMESA" onChange="envia();">
									<option value="" <%if Trim(Request("CB_REMESA")) = "" then response.Write("SELECTED") End If%>>TODAS</option>
									<%
									abrirscg()
									ssql="SELECT CONVERT(VARCHAR(10),FECHA_LLEGADA,103) as FECHAREMESA , CODREMESA FROM REMESA WHERE CODCLIENTE = '" & strCliente & "' AND CODREMESA >= 100"
									set rsTemp= Conn.execute(ssql)
									if not rsTemp.eof then
										do until rsTemp.eof%>
										<option value="<%=rsTemp("CODREMESA")%>" <%if Trim(intRemesa) = Trim(rsTemp("CODREMESA")) then response.Write("SELECTED") End If%>><%=rsTemp("CODREMESA") & "-" & rsTemp("FECHAREMESA")%></option>
										<%
										rsTemp.movenext
										loop
									end if
									rsTemp.close
									set rsTemp=nothing
									cerrarscg()
									%>
								</select>
							</TD>
						</TR>
						<TR><TD>&nbsp;</TD><TR>

 				<% If TraeSiNo(session("perfil_adm")) = "Si" or TraeSiNo(session("perfil_sup")) = "Si" Then %>
						<TR>
							<TD class="Estilo2">
								Ejecutivo
							</TD>
						</TR>
						<TR>
							<TD>
								<select name="CB_EJECUTIVO">
									<option value="">TODOS</option>
									<%
									abrirscg()
									ssql="SELECT ID_USUARIO,LOGIN, NOMBRES_USUARIO, APELLIDOS_USUARIO FROM USUARIO WHERE PERFIL_COB = 1"
									set rsTemp= Conn.execute(ssql)
									if not rsTemp.eof then
										do until rsTemp.eof%>
										<option value="<%=rsTemp("ID_USUARIO")%>"<%if Trim(intEjecutivo)=Trim(rsTemp("ID_USUARIO")) then response.Write("Selected") End If%>><%=Mid(rsTemp("NOMBRES_USUARIO") & " " & rsTemp("APELLIDOS_USUARIO"),1,15) %></option>
										<%
										rsTemp.movenext
										loop
									end if
									rsTemp.close
									set rsTemp=nothing
									cerrarscg()
									%>
								</select>
							</TD>
						</TR>
				 <% End If%>


						<TR><TD>&nbsp;</TD>
						<TR>
							<TD>
								<a href="#" onClick="envia();">Filtrar</a>
							</TD>
						</TR>
					</TABLE>
					</FORM>				</TD>
			</TABLE></td>
	<td WIDTH="662">
		<TABLE ALIGN="CENTER">
			<TR>
				<TD COLSPAN=2>
					<img src="../images/LineaTiempo3.gif">
				</TD>
			</TR>
			<TR>
				<TD ALIGN="LEFT">
				<%=strFechaInicio%>
				</TD>
				<TD ALIGN="RIGHT">
				<%=strFechaTermino%>
				</TD>
			</TR>
		</TABLE>	</td>
</tr>
<tr>

	<td align="center">
		<table border="0" align="center">
			<tr>
				<td width="100" align="center" style="height: 67px"><span class="Estilo4">&nbsp</span></td>
				<td width="40" align="center" style="height: 67px"><span class="Estilo4">&nbsp</span></td>
				<td width="100" align="center" style="height: 67px"><span class="Estilo4">&nbsp</span></td>
				<td width="90" align="center" style="height: 67px"><img src="../images/Fecha_42.gif" width="90" height="65"></td>
				<td width="100" align="center" background="../images/EstadoAzul3.gif" style="height: 67px">
				<span class="style1">Casos<br>Gestionados</span><br>
				<a href="cartera_asignada.asp?strBuscar=S&CB_CLIENTE=<%=strCliente%>&CB_REMESA=<%=intRemesa%>&CB_EJECUTIVO=<%=intEjecutivo%>&CB_TIPOCARTERA=GESTIONADOS"><%=FN(intCasosGestionados,0)%></a>
				</td>
				<td align="center" style="width: 60px; height: 67px">&nbsp;</td>
				<td height="67" width="100" align="center" background="../images/EstadoMorado.gif">
				<span class="style1">
				Casos<br>Activos</span><br>
				<span class="Estilo4" style="font-weight: bold; font-family: Arial, Helvetica, sans-serif; font-size: 12px; color: #FFFF00"><a href="informe_workflow.asp?strCliente=<%=strCliente%>&intRemesa=<%=intRemesa%>&intTipo=3&intGestion=12&intEjecutivo=<%=intEjecutivo%>&intDePPal=1"><%=FN(intCasosActivos,0)%></a></span></td>
			</tr>

			<tr>
				<td height="67" width="100" align="center"><span class="Estilo4">&nbsp</span></td>
				<td height="67" width="40" align="center"><img src="../images/Fecha_22.gif" width="40" height="67"></td>
				<td width="100" height="67" align="center" background="../images/EstadoMorado.gif" class="Estilo4" style="font-weight: bold; font-family: Arial, Helvetica, sans-serif; font-size: 12px; color: #FFFF00">Casos Gestionables <br>
				<a href="cartera_asignada.asp?strBuscar=S&CB_CLIENTE=<%=strCliente%>&CB_REMESA=<%=intRemesa%>&CB_EJECUTIVO=<%=intEjecutivo%>&CB_TIPOCARTERA=GESTIONABLES"><%=FN(intCasosGestionable,0)%></a>
				</td>
				<td height="67" width="90" align="center"><span class="Estilo4"><img src="../images/Fecha_43.gif" width="90" height="65"></span></td>
				<td height="67" width="100" align="center">
				&nbsp;</td>
				<td height="67" align="center" style="width: 60px">&nbsp;</td>
				<td height="67" width="100" align="center" background="../images/EstadoVerde.gif"><span class="Estilo4" style="font-weight: bold; font-family: Arial, Helvetica, sans-serif; font-size: 12px; color: #FFFF00">Pagos</span><br>
				<span class="Estilo4" style="font-weight: bold; font-family: Arial, Helvetica, sans-serif; font-size: 12px; color: #FFFF00"><a href="informe_workflow.asp?strCliente=<%=strCliente%>&intRemesa=<%=intRemesa%>&intTipo=11&intGestion=12&intEjecutivo=<%=intEjecutivo%>&intDePPal=1"><%=FN(intRutConPagos,0)%></a></span>
				</td>
			</tr>

			<tr>
				<td height="67" width="100" align="center" background="../images/EstadoVerde.gif" bgcolor="#FF0000"><span style="font-family: Arial, Helvetica, sans-serif; font-weight: bold; color: #FF3333; font-size: 12px">Casos<BR>Cargados </span><BR>
				<a href="cartera_asignada.asp?strBuscar=S&CB_CLIENTE=<%=strCliente%>&CB_REMESA=<%=intRemesa%>&CB_EJECUTIVO=<%=intEjecutivo%>&CB_TIPOCARTERA="><%=FN(intTotalProceso,0)%></a>
				</td>
				<td height="67" width="40" align="center"><img src="../images/Fecha_23.gif" width="40" height="67"></td>
				<td height="67" width="100" align="center"><span class="Estilo4">&nbsp</span></td>
				<td height="67" width="90" align="center"><img src="../images/Fecha_46.gif" width="90" height="65"></td>
				<td height="67" width="100" align="center" background="../images/EstadoAzul3.gif">
				<span class="Estilo4" style="font-family: Arial, Helvetica, sans-serif; font-size: 12px; font-weight: bold; color: #FFFF00">
				Casos Pendientes</span><br>
				<a href="cartera_asignada.asp?strBuscar=S&CB_CLIENTE=<%=strCliente%>&CB_REMESA=<%=intRemesa%>&CB_EJECUTIVO=<%=intEjecutivo%>&CB_TIPOCARTERA=PENDIENTES"><%=FN(intCasosNoGestionados,0)%></a>
				</td>
				<td height="67" align="center" style="width: 60px">&nbsp;</td>
				<td height="67" width="100" align="center" background="../images/EstadoAzul3.gif">
				<span class="Estilo4" style="font-family: Arial, Helvetica, sans-serif; font-size: 12px; font-weight: bold; color: #FFFF00">
				Retiros<br>
				<a href="informe_workflow.asp?strCliente=<%=strCliente%>&intRemesa=<%=intRemesa%>&intTipo=2&intGestion=12&intEjecutivo=<%=intEjecutivo%>&intDePPal=1"><%=FN(intCasosRetiros,0)%></a>
				</span>
				</td>
			</tr>
			<tr>
				<td height="67" width="100" align="center">&nbsp;</td>
				<td height="67" width="40" align="center"><img src="../images/Fecha_24.gif" width="40" height="67"></td>
				<td height="67" width="100" align="center" background="../images/EstadoMorado.gif"><span class="Estilo4" style="font-weight: bold; font-family: Arial, Helvetica, sans-serif; font-size: 12px; color: #FFFF00">Casos NO Gestionables</span><br>
				<span class="Estilo4" style="font-weight: bold; font-family: Arial, Helvetica, sans-serif; font-size: 12px; color: #FFFF00">
				<a href="cartera_asignada.asp?strBuscar=S&CB_CLIENTE=<%=strCliente%>&CB_REMESA=<%=intRemesa%>&CB_EJECUTIVO=<%=intEjecutivo%>&CB_TIPOCARTERA=NOGESTIONABLES"><%=FN(intCasosNoGestionable,0)%></a>
				</td>

				<td height="67" width="90" align="center">&nbsp;</td>
				<td height="67" width="100" align="center">&nbsp;</td>
				<td height="67" align="center" style="width: 60px">&nbsp;</td>
				<td height="67" width="100" align="center" background="../images/EstadoMorado.gif"><span class="Estilo4" style="font-weight: bold; font-family: Arial, Helvetica, sans-serif; font-size: 12px; color: #FFFF00">
				Convenios</span><br>
				<span class="Estilo4" style="font-weight: bold; font-family: Arial, Helvetica, sans-serif; font-size: 12px; color: #FFFF00"><a href="informe_workflow.asp?strCliente=<%=strCliente%>&intRemesa=<%=intRemesa%>&intTipo=3&intGestion=12&intEjecutivo=<%=intEjecutivo%>&intDePPal=1"><%=FN(intCasosConvenio,0)%></a></span></td>
			</tr>
			<tr>
				<td height="67" width="100" align="center">&nbsp;</td>
				<td height="67" width="40" align="center">&nbsp;</td>
				<td height="67" width="100" align="center">&nbsp;</td>
				<td height="67" width="90" align="center">&nbsp;</td>
				<td height="67" width="100" align="center">&nbsp;</td>
				<td height="67" align="center" style="width: 60px">&nbsp;</td>
				<td height="67" width="100" align="center"><span class="Estilo4">&nbsp</span></td>
			</tr>
		</table>
	</td>
</tr>
</table>

</BODY>
<script language="JavaScript1.2">
function envia()	{
	if (datos.CB_CLIENTE.value=='0'){
		alert('DEBE SELECCIONAR UN CLIENTE');
	}else if (datos.CB_REMESA.value=='0'){
			alert('DEBE SELECCIONAR UNA CAMPAÑA');
	}else{
		datos.action='EstatusCartera.asp';
		datos.submit();
	}
}
</script>
