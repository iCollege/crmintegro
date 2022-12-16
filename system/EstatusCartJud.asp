<%@ LANGUAGE="VBScript" %>
<!--#include file="sesion.asp"-->
<!--#include file="arch_utils.asp"-->
<!--#include file="../lib/comunes/rutinas/funciones.inc" -->
<!--#include file="asp/comunes/general/rutinasBooleano.inc" -->
<%



	''strCliente=Request("CB_CLIENTE")
	strCliente=session("ses_codcli")

	intEjecutivo=Request("CB_EJECUTIVO")
	intRemesa=Request("CB_REMESA")

	If Trim(strCliente) = "" Then strCliente = session("ses_codcli")
	''If Trim(intRemesa) = "" Then intRemesa = "100"
	If Trim(intRemesa) = "" Then intRemesa = ""


	If TraeSiNo(session("perfil_adm")) <> "Si" or trim(intEjecutivo) <> "" Then
		If trim(intEjecutivo) <> "" Then
			strSqlUsuario = " AND USUARIO_ASIG = " & intEjecutivo
		Else
			strSqlUsuario = " AND USUARIO_ASIG = " & session("session_idusuario")
		End if
	End if

	abrirscg()

		If Trim(strCliente) = "1000" Then
			strSql="SELECT MAX(FECHA_CARGA) AS ULTACT FROM REMESA_ACT CUOTA WHERE CODCLIENTE = '" & strCliente & "'"
			if trim(intRemesa) <> "" Then
				strSql = strSql & "AND CODREMESA = " & intRemesa
			End if

			set rsTemp= Conn.execute(strSql)
			If not rsTemp.eof then
				strUltAct = rsTemp("ULTACT")
			Else
				strUltAct = "NO DISPONIBLE"
			End if
			rsTemp.close
			set rsTemp=nothing
		End if

		If Trim(strCliente) = "1001" Then
			strSql="SELECT TOP 1 NOMBRE_ARCHIVO AS ULTACT FROM [cargas].[usr_cargas].[VNE_ARCHIVOS] ORDER BY ID DESC"
			set rsTemp= Conn.execute(strSql)
			If not rsTemp.eof then
				strUltAct = RIGHT(rsTemp("ULTACT"),8)
			Else
				strUltAct = "NO DISPONIBLE"
			End if
			rsTemp.close
			set rsTemp=nothing
		End if



		strSql = "SELECT COUNT(DISTINCT(RUTDEUDOR)) as RUT, IsNull(COUNT(NRODOC),0) as FOLIO, IsNull(SUM(VALORCUOTA),0) as MONTO FROM CUOTA WHERE CODCLIENTE = '" & strCliente & "'"

		If trim(intRemesa) <> "" Then
			strSql = strSql & " AND CODREMESA = " & intRemesa
		End if

		strSql = strSql & " AND SALDO = 0 AND ESTADO_DEUDA IN (3,4) AND RUTDEUDOR IN ("
		strSql = strSql & " SELECT DISTINCT(RUTDEUDOR) FROM CUOTA WHERE CODCLIENTE = '" & strCliente & "'"

		If trim(intRemesa) <> "" Then
			strSql = strSql & " AND CODREMESA = " & intRemesa
		End if

		strSql = strSql & " GROUP BY RUTDEUDOR HAVING SUM(SALDO) = 0)"
		''Response.write strSql

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

		strSql = "SELECT COUNT(DISTINCT(RUTDEUDOR)) as RUT, IsNull(COUNT(NRODOC),0) as FOLIO, IsNull(SUM(VALORCUOTA),0) as MONTO FROM CUOTA WHERE CODCLIENTE = '" & strCliente & "'"

		If trim(intRemesa) <> "" Then
			strSql = strSql & " AND CODREMESA = " & intRemesa
		End if

		strSql = strSql & " AND SALDO = 0 AND ESTADO_DEUDA IN (3,4) AND RUTDEUDOR NOT IN ("
		strSql = strSql & " SELECT DISTINCT(RUTDEUDOR) FROM CUOTA WHERE CODCLIENTE = '" & strCliente & "'"

		If trim(intRemesa) <> "" Then
			strSql = strSql & " AND CODREMESA = " & intRemesa
		End if

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

		strSql="SELECT IsNull(COUNT(DISTINCT RUTDEUDOR),0) AS CUANTOS, IsNull(SUM(SALDO),0) AS SUMA FROM CUOTA WHERE CODCLIENTE = '" & strCliente & "' AND IDGJUDICIAL IS NOT NULL AND ESTADO_DEUDA = '1' "

		If trim(intRemesa) <> "" Then
			strSql = strSql & " AND CODREMESA = " & intRemesa
		End if

		strSql = strSql & strSqlUsuario

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

		strSql="SELECT IsNull(COUNT(DISTINCT RUTDEUDOR),0) AS CUANTOS, IsNull(SUM(VALORCUOTA),0) AS SUMA FROM CUOTA WHERE CODCLIENTE = '" & strCliente & "' AND IDGJUDICIAL IS NOT NULL AND ESTADO_DEUDA = '2' "

		If trim(intRemesa) <> "" Then
			strSql = strSql & " AND CODREMESA = " & intRemesa
		End if

		strSql = strSql & strSqlUsuario


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

		'Response.write "<BR>intTotalRetiro=" & intTotalRetiro
		'Response.write "<BR>intTotalMontoRetiro=" & intTotalMontoRetiro


		strSql="SELECT IsNull(COUNT(DISTINCT RUTDEUDOR),0) AS CUANTOS, IsNull(SUM(SALDO),0) AS SUMA, IDGJUDICIAL FROM CUOTA WHERE CODCLIENTE = '" & strCliente & "' AND ESTADO_DEUDA = 1 AND IDGJUDICIAL IS NOT NULL "

		If trim(intRemesa) <> "" Then
			strSql = strSql & " AND CODREMESA = " & intRemesa
		End if

		strSql = strSql & strSqlUsuario & " GROUP BY IDGJUDICIAL"

		'Response.write strSql
		set rsTemp= Conn.execute(strSql)
		Do While not rsTemp.eof
			SELECT CASE rsTemp("IDGJUDICIAL")
				CASE  1 :
					intRecienAsignado = rsTemp("CUANTOS")
					intMontoRecienAsignado = rsTemp("SUMA")
				CASE  2 :
					intVerifDomicilio = rsTemp("CUANTOS")
					intMontoVerifDomicilio = rsTemp("SUMA")
				CASE  3 :
					intInubicable = rsTemp("CUANTOS")
					intMontoInubicable = rsTemp("SUMA")
				CASE  4 :
					intUbicable = rsTemp("CUANTOS")
					intMontoUbicable = rsTemp("SUMA")
				CASE  5 :
					intIngreTribunal = rsTemp("CUANTOS")
					intMontoIngreTribunal = rsTemp("SUMA")
				CASE  6 :
					intNotificacion = rsTemp("CUANTOS")
					intMontoNotificacion = rsTemp("SUMA")
				CASE  7 :
					intBusqNegativa = rsTemp("CUANTOS")
					intMontoBusqNegativa = rsTemp("SUMA")
				CASE  8 :
					intBusqPositiva = rsTemp("CUANTOS")
					intMontoBusqPositiva = rsTemp("SUMA")
				CASE  9 :
					intComparendo = rsTemp("CUANTOS")
					intMontoComparendo = rsTemp("SUMA")
				CASE  10 :
					intParaFallo = rsTemp("CUANTOS")
					intMontoParaFallo = rsTemp("SUMA")
				CASE  11 :
					intTerminado = rsTemp("CUANTOS")
					intMontoTerminado = rsTemp("SUMA")
				CASE  12 :
					intTotalConPago = rsTemp("CUANTOS")
					intMontoTotalConPago = rsTemp("SUMA")
				CASE  13 :
					intTotalConAvenimiento = rsTemp("CUANTOS")
					intMontoTotalConAvenimiento = rsTemp("SUMA")
				CASE  14 :
					intTotalIncobrables = rsTemp("CUANTOS")
					intMontoTotalIncobrables = rsTemp("SUMA")
				CASE  15 :
					intTotalUbicConComp = rsTemp("CUANTOS")
					intMontoTotalUbicConComp = rsTemp("SUMA")

			END SELECT


			rsTemp.movenext
		Loop
		rsTemp.close
		set rsTemp=nothing
	cerrarscg()


%>

<HTML>

<HEAD><TITLE>Menú</TITLE>
<LINK rel="stylesheet" TYPE="text/css" HREF="isk_style.css">
<style type="text/css">
<!--
.Estilo1 {
	color: #0000FF;
	font-size: 16px;
	font-weight: bold;
}
.Estilo2 {
	font-size: 12px;
	color: #0000FF;
}
.Estilo4 {font-size: 9px}
.Estilo5 {color: #FFFFFF; font-weight: bold; font-size: 9px; }
-->
</style>
</HEAD>

<BODY>

<TABLE ALIGN="CENTER" BORDER=0 CELLSPACING=0 CELLPADDING=0 WIDTH="800">
	<TR HEIGHT="20">
		<TD align="CENTER">
		<span class="Estilo1">ESTATUS DE LA CARTERA JUDICIAL</span></TD>
	</TR>
	<TR HEIGHT="15">
		<TD align="CENTER">
		<span class="Estilo2">(INFORMACION EN CASOS)</span></TD>
	</TR>


	<form name="datos" method="post">
	<TR HEIGHT="15">
		<TD align="CENTER">
			<TABLE ALIGN="LEFT" BORDER=0 CELLSPACING=0 CELLPADDING=0 WIDTH="800">
			<TR>
				<td>
				Cliente
				</td>
				<td>
					<select name="CB_CLIENTE" onChange="envia();">
						<!--option value="100">TODOS</option-->
						<%
						abrirscg()
						ssql="SELECT CODCLIENTE,RAZON_SOCIAL FROM CLIENTE WHERE CODCLIENTE = '" & strCliente & "' ORDER BY RAZON_SOCIAL"
						set rsTemp= Conn.execute(ssql)
						if not rsTemp.eof then
							do until rsTemp.eof%>
							<option value="<%=rsTemp("CODCLIENTE")%>"<%if Trim(strCliente)=rsTemp("CODCLIENTE") then response.Write("Selected") End If%>><%=rsTemp("RAZON_SOCIAL")%></option>
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


				<% If TraeSiNo(session("perfil_adm")) = "Si" Then %>

				<td>
				Ejecutivo
				</td>
				<td>
					<select name="CB_EJECUTIVO">
						<option value="">TODOS</option>
						<%
						abrirscg()
						ssql="SELECT ID_USUARIO,LOGIN FROM USUARIO WHERE PERFIL_COB = 1"
						set rsTemp= Conn.execute(ssql)
						if not rsTemp.eof then
							do until rsTemp.eof%>
							<option value="<%=rsTemp("ID_USUARIO")%>" <%if Trim(intEjecutivo) = Trim(rsTemp("ID_USUARIO")) then response.Write("SELECTED") End If%>><%=rsTemp("LOGIN")%></option>
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

				<% End if%>

				<td>
				Asignacion
				</td>
				<td>
					<select name="CB_REMESA">
						<option value="">TODOS</option>
						<%
						abrirscg()

						ssql="SELECT CONVERT(VARCHAR(10),FECHA_LLEGADA,103) as FECHAREMESA , NOMBRE, CODREMESA FROM REMESA WHERE CODCLIENTE = '" & strCliente & "' AND CODREMESA >= 100"
						REsponse.write 	ssql
						set rsTemp= Conn.execute(ssql)
						if not rsTemp.eof then
							do until rsTemp.eof%>
							<option value="<%=rsTemp("CODREMESA")%>" <%if Trim(intRemesa) = Trim(rsTemp("CODREMESA")) then response.Write("SELECTED") End If%>><%=rsTemp("CODREMESA") & "-" & rsTemp("NOMBRE")%></option>
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
					<a href="#" onClick="envia();">Filtrar</a></td>
				</td>
			</TR>
			</TABLE>
		</TD>
	</TR>
	</form>



</TABLE>



<table ALIGN="CENTER" WIDTH="800" border="0">

<tr BGCOLOR="#FFFFFF">
	<td>
		<table ALIGN="CENTER" WIDTH="200" border="0">
		<tr BGCOLOR="#FFFFFF">
		  <td colspan="3" align="center"><strong>Total casos del proceso</strong></td>
		  </tr>
		<tr BGCOLOR="#FFFFFF">
			<td bordercolor="#0000FF">&nbsp;</td>
		    <td bordercolor="#0000FF" align="center"><a href="informe_estatus.asp?strCliente=<%=strCliente%>&intGestion=T&intDePPal=1&intRemesa=<%=intRemesa%>"><%=FN(intTotalProceso,0)%></a></td>
		    <td bordercolor="#0000FF">&nbsp;</td>
		</tr>
	  </table>
	</td>


    <td>
    	<table ALIGN="CENTER" WIDTH="200" border="0">
		<tr BGCOLOR="#FFFFFF">
		  <td colspan="3" align="center"><strong>Total casos con pago</strong></td>
		  </tr>
		<tr BGCOLOR="#FFFFFF">
			<td>&nbsp;</td>
			<td bordercolor="#0000FF" align="center"><a href="informe_estatus.asp?strCliente=<%=strCliente%>&intGestion=12&intEjecutivo=<%=intEjecutivo%>&intDePPal=1&intRemesa=<%=intRemesa%>"><%=FN(intTotalConPago,0)%></a></td>
			<td>&nbsp;</td>
		</tr>
		</table>
    </td>
    <td>
    	<table ALIGN="CENTER" WIDTH="200" border="0">
		<tr BGCOLOR="#FFFFFF">
		  <td colspan="3" align="center"><strong>Casos con avenimiemto</strong></td>
		  </tr>
		<tr BGCOLOR="#FFFFFF">
			<td>&nbsp;</td>
			<td bordercolor="#0000FF" align="center"><a href="informe_estatus.asp?strCliente=<%=strCliente%>&intGestion=13&intEjecutivo=<%=intEjecutivo%>&intDePPal=1&intRemesa=<%=intRemesa%>"><%=FN(intTotalConAvenimiento,0)%></a></td>
			<td>&nbsp;</td>
		</tr>
		</table>
    </td>


    <td>
		<table ALIGN="CENTER" WIDTH="200" border="0">
		<tr BGCOLOR="#FFFFFF">
		  <td colspan="3" align="center"><strong>Casos Retirados</strong></td>
		  </tr>
		<tr BGCOLOR="#FFFFFF">
			<td>&nbsp;</td>
			<td bordercolor="#0000FF" align="center"><a href="informe_estatus.asp?strCliente=<%=strCliente%>&intGestion=R&intEjecutivo=<%=intEjecutivo%>&intDePPal=1&intRemesa=<%=intRemesa%>"><%=FN(intTotalRetiro,0)%></a></td>
			<td>&nbsp;</td>
		</tr>
		</table>
    </td>
</tr>
</Table>

<BR>
<table width="725" height="175" border="0" align="center">
  <tr height="35">
    <td width="55" align="center">&nbsp;</td>
    <td width="20" align="center"><span class="Estilo4">&nbsp</span></td>
    <td width="55" align="center">&nbsp;</td>
    <td width="20" align="center"><img src="../images/flecha_azul_arriba.jpg" width="20" height="11"></td>
    <td width="55" bgcolor="#0000FF" align="center"><span class="Estilo5"><%=FN(intInubicable,0)%></span></td>
    <td align="center"><span class="Estilo4"><img src="../images/flecha_azul.jpg" width="20" height="14"></span></td>
    <td width="55" bgcolor="#0000FF" align="center"><span class="Estilo5"><%=FN(intTotalIncobrables,0)%></span></td>
    <td width="20" align="center"><span class="Estilo4">&nbsp</span></td>
    <td width="55" align="center"><span class="Estilo4">&nbsp</span></td>
    <td width="20" align="center"><span class="Estilo4">&nbsp</span></td>
    <td width="55" align="center"><span class="Estilo4">&nbsp</span></td>
    <td width="20" align="center"><span class="Estilo4">&nbsp</span></td>
    <td width="55" align="center"><span class="Estilo4">&nbsp</span></td>
    <td width="20" align="center"><span class="Estilo4">&nbsp</span></td>
    <td width="55" align="center"><span class="Estilo4">&nbsp</span></td>
    <td width="20" align="center"><span class="Estilo4">&nbsp</span></td>
    <td width="55" align="center"><span class="Estilo4">&nbsp</span></td>
  </tr>


  <tr height="35">
      <td bgcolor="#0000FF" align="center"><span class="Estilo5"><%=FN(intRecienAsignado,0)%></span></td>
      <td align="center"><img src="../images/flecha_azul.jpg" width="20" height="14"></td>
      <td bgcolor="#0000FF" align="center"><span class="Estilo5"><%=FN(intVerifDomicilio,0)%></span></td>
      <td align="center"><span class="Estilo4">&nbsp</span></td>
      <td align="center"><span class="Estilo4">
      <a href="informe_estatus.asp?strCliente=<%=strCliente%>&intGestion=3&intEjecutivo=<%=intEjecutivo%>&intDePPal=1&intRemesa=<%=intRemesa%>">Inubicab.</a></span>
      </span></td>
      <td align="center"><span class="Estilo4">&nbsp</span></td>
      <td align="center"><span class="Estilo4">
	  <a href="informe_estatus.asp?strCliente=<%=strCliente%>&intGestion=14&intEjecutivo=<%=intEjecutivo%>&intDePPal=1&intRemesa=<%=intRemesa%>">InCobrab.</a></span>
      </span></td>
      <td align="center"><span class="Estilo4">&nbsp</span></td>
      <td align="center"><span class="Estilo4">&nbsp</span></td>
      <td align="center"><img src="../images/flecha_azul_arriba.jpg" width="20" height="11"></td>
      <td bgcolor="#0000FF" align="center"><span class="Estilo5"><%=FN(intBusqNegativa,0)%></span></td>
      <td align="center"><span class="Estilo4">&nbsp</span></td>
      <td align="center"><span class="Estilo4">&nbsp</span></td>
      <td align="center"><span class="Estilo4">&nbsp</span></td>
      <td align="center"><span class="Estilo4">&nbsp</span></td>
      <td align="center"><span class="Estilo4">&nbsp</span></td>
      <td align="center"><span class="Estilo4">&nbsp</span></td>
  </tr>


  <tr height="35">
    <td align="center"><span class="Estilo4">
    <a href="informe_estatus.asp?strCliente=<%=strCliente%>&intGestion=1&intEjecutivo=<%=intEjecutivo%>&intRemesa=<%=intRemesa%>&intDePPal=1">Recien Asignados</a></span>
    </td>
    <td align="center"><span class="Estilo4">&nbsp</span></td>
    <td align="center"><span class="Estilo4">
    	<a href="informe_estatus.asp?strCliente=<%=strCliente%>&intGestion=2&intEjecutivo=<%=intEjecutivo%>&intDePPal=1&intRemesa=<%=intRemesa%>">Verif.de Domicilio</a></span>
    </span></td>
    <td align="center"><img src="../images/flecha_azul_abajo.jpg" width="20" height="11"></td>
    <td bgcolor="#0000FF" align="center"><span class="Estilo5"><%=FN(intUbicable,0)%></span></td>
    <td align="center"><span class="Estilo4"><img src="../images/flecha_azul.jpg" width="20" height="14"></span></td>
    <td bgcolor="#0000FF" align="center"><span class="Estilo5"><%=FN(intIngreTribunal,0)%></span></td>
    <td align="center"><img src="../images/flecha_azul.jpg" width="20" height="14"></td>
    <td bgcolor="#0000FF" align="center"><span class="Estilo5"><%=FN(intNotificacion,0)%></span></td>
    <td align="center"><span class="Estilo4">&nbsp</span></td>
    <td align="center"><span class="Estilo4">
    <a href="informe_estatus.asp?strCliente=<%=strCliente%>&intGestion=7&intEjecutivo=<%=intEjecutivo%>&intDePPal=1&intRemesa=<%=intRemesa%>">Busqueda Negativa</a>
    </span></td>
    <td align="center"><span class="Estilo4">&nbsp</span></td>
    <td align="center"><span class="Estilo4">&nbsp</span></td>
    <td align="center"><span class="Estilo4">&nbsp</span></td>
    <td align="center"><span class="Estilo4">&nbsp</span></td>
    <td align="center"><span class="Estilo4">&nbsp</span></td>
    <td align="center"><span class="Estilo4">&nbsp</span></td>
  </tr>
  <tr height="35">
      <td align="center"><span class="Estilo4">&nbsp</span></td>
      <td align="center"><span class="Estilo4">&nbsp</span></td>
      <td align="center"><span class="Estilo4">&nbsp</span></td>
      <td align="center"><span class="Estilo4">&nbsp</span></td>
      <td align="center"><span class="Estilo4">
      <a href="informe_estatus.asp?strCliente=<%=strCliente%>&intGestion=4&intEjecutivo=<%=intEjecutivo%>&intDePPal=1&intRemesa=<%=intRemesa%>">Ubicables</a></span>
      </span></td>
      <td align="center"><span class="Estilo4">&nbsp</span></td>
      <td align="center"><span class="Estilo4">
      <a href="informe_estatus.asp?strCliente=<%=strCliente%>&intGestion=5&intEjecutivo=<%=intEjecutivo%>&intDePPal=1&intRemesa=<%=intRemesa%>">Ingres. a Tribunal</a></span>
      </span></td>
      <td align="center"><span class="Estilo4">&nbsp</span></td>
      <td align="center"><span class="Estilo4">
      <a href="informe_estatus.asp?strCliente=<%=strCliente%>&intGestion=6&intEjecutivo=<%=intEjecutivo%>&intDePPal=1&intRemesa=<%=intRemesa%>">Notificacion</a></span>
      </span></td>
      <td align="center"><img src="../images/flecha_azul_abajo.jpg" width="20" height="11"></td>
      <td bgcolor="#0000FF" align="center"><span class="Estilo5"><%=FN(intBusqPositiva,0)%></span></td>
      <td align="center"><span class="Estilo4"><img src="../images/flecha_azul.jpg" width="20" height="14"></span></td>
      <td bgcolor="#0000FF" align="center"><span class="Estilo5"><%=FN(intComparendo,0)%></span></td>
      <td align="center"><img src="../images/flecha_azul.jpg" width="20" height="14"></td>
      <td bgcolor="#0000FF" align="center"><span class="Estilo5"><%=FN(intParaFallo,0)%></span></td>
      <td align="center"><img src="../images/flecha_azul.jpg" width="20" height="14"></td>
      <td bgcolor="#0000FF" align="center"><span class="Estilo5"><%=FN(intTerminado,0)%></span></td>
  </tr>
  <tr height="35">
      <td align="center"><span class="Estilo4">&nbsp</span></td>
      <td align="center"><span class="Estilo4">&nbsp</span></td>
      <td align="center"><span class="Estilo4">&nbsp</span></td>
      <td align="center"><span class="Estilo4">&nbsp</span></td>
      <td align="center"><img src="../images/flecha_azul_abajo.jpg" width="20" height="11"></td>
      <td align="center"><img src="../images/flecha_azul.jpg" width="20" height="14"></td>
      <td bgcolor="#0000FF" align="center"><span class="Estilo5"><%=FN(intTotalUbicConComp,0)%></span></td>
      <td align="center"><span class="Estilo4">&nbsp</span></td>
      <td align="center"><span class="Estilo4">&nbsp</span></td>
      <td align="center"><span class="Estilo4">&nbsp</span></td>
      <td align="center"><span class="Estilo4">
      <a href="informe_estatus.asp?strCliente=<%=strCliente%>&intGestion=8&intEjecutivo=<%=intEjecutivo%>&intDePPal=1&intRemesa=<%=intRemesa%>">Busqueda Positiva</a>
      </span></td>
      <td align="center"><span class="Estilo4">&nbsp</span></td>
      <td align="center"><span class="Estilo4">
      <a href="informe_estatus.asp?strCliente=<%=strCliente%>&intGestion=9&intEjecutivo=<%=intEjecutivo%>&intDePPal=1&intRemesa=<%=intRemesa%>">Comparendo</a>
      </span></td>
      <td align="center"><span class="Estilo4">&nbsp</span></td>
      <td align="center"><span class="Estilo4">
      <a href="informe_estatus.asp?strCliente=<%=strCliente%>&intGestion=10&intEjecutivo=<%=intEjecutivo%>&intDePPal=1&intRemesa=<%=intRemesa%>">Para Fallo</a>
      </span></td>
      <td align="center"><span class="Estilo4">&nbsp</span></td>
      <td align="center"><span class="Estilo4">
      <a href="informe_estatus.asp?strCliente=<%=strCliente%>&intGestion=11&intEjecutivo=<%=intEjecutivo%>&intDePPal=1&intRemesa=<%=intRemesa%>">Terminado</a>
      </span></td>
  </tr>
  <tr height="35">
	<td align="center"><span class="Estilo4">&nbsp</span></td>
	<td align="center"><span class="Estilo4">&nbsp</span></td>
	<td align="center"><span class="Estilo4">&nbsp</span></td>
	<td align="center"><span class="Estilo4">&nbsp</span></td>
	<td align="center"><span class="Estilo4">&nbsp</span></td>
	<td align="center"><span class="Estilo4">&nbsp</span></td>
	<td align="center"><span class="Estilo4">
	      <a href="informe_estatus.asp?strCliente=<%=strCliente%>&intGestion=15&intEjecutivo=<%=intEjecutivo%>&intDePPal=1&intRemesa=<%=intRemesa%>">Ubic. Con.Comp</a></span>
      </span></td>
	<td align="center"><span class="Estilo4">&nbsp</span></td>
	<td align="center"><span class="Estilo4">&nbsp</span></td>
	<td align="center"><span class="Estilo4">&nbsp</span></td>
	<td align="center"><span class="Estilo4">&nbsp</span></td>
	<td align="center"><span class="Estilo4">&nbsp</span></td>
	<td align="center"><span class="Estilo4">&nbsp</span></td>
	<td align="center"><span class="Estilo4">&nbsp</span></td>
	<td align="center"><span class="Estilo4">&nbsp</span></td>
	<td align="center"><span class="Estilo4">&nbsp</span></td>
	<td align="center"><span class="Estilo4">&nbsp</span></td>
  </tr>

</table>
<p>&nbsp;</p>




























<TABLE ALIGN="CENTER" BORDER=0 CELLSPACING=0 CELLPADDING=0 WIDTH="600">
<TR HEIGHT="20">
	<TD align="CENTER">
	<span class="Estilo1">ESTATUS DE LA CARTERA JUDICIAL</span></TD>
</TR>
<TR HEIGHT="15">
	<TD align="CENTER">
	<span class="Estilo2">(INFORMACION EN CUANTIA)</span></TD>
</TR>

</TABLE>

<table ALIGN="CENTER" WIDTH="600" border="0">

<tr BGCOLOR="#FFFFFF">
	<td>
		<table ALIGN="CENTER" WIDTH="200" border="0">
		<tr BGCOLOR="#FFFFFF">
		  <td colspan="3" align="center"><strong>Total casos del proceso</strong></td>
		  </tr>
		<tr BGCOLOR="#FFFFFF">
			<td bordercolor="#0000FF">&nbsp;</td>
		    <td bordercolor="#0000FF" align="center"><a href="informe_estatus.asp?strCliente=<%=strCliente%>&intGestion=T&intEjecutivo=<%=intEjecutivo%>&intDePPal=1&intRemesa=<%=intRemesa%>"><%=FN(intTotalMontoProceso/1000000,0)%> mm$</a></td>
		    <td bordercolor="#0000FF">&nbsp;</td>
		</tr>
	  </table>
	</td>
    <td>
    	<table ALIGN="CENTER" WIDTH="200" border="0">
		<tr BGCOLOR="#FFFFFF">
		  <td colspan="3" align="center"><strong>Total casos con pago</strong></td>
		  </tr>
		<tr BGCOLOR="#FFFFFF">
			<td>&nbsp;</td>
			<td bordercolor="#0000FF" align="center"><a href="informe_estatus.asp?strCliente=<%=strCliente%>&intGestion=12&intEjecutivo=<%=intEjecutivo%>&intDePPal=1&intRemesa=<%=intRemesa%>"><%=FN(intMontoTotalConPago/1000000,0)%> mm$</a></td>
			<td>&nbsp;</td>
		</tr>
		</table>
    </td>
    <td>
    	<table ALIGN="CENTER" WIDTH="200" border="0">
		<tr BGCOLOR="#FFFFFF">
		  <td colspan="3" align="center"><strong>Casos con avenimiemto</strong></td>
		  </tr>
		<tr BGCOLOR="#FFFFFF">
			<td>&nbsp;</td>
			<td bordercolor="#0000FF" align="center"><a href="informe_estatus.asp?strCliente=<%=strCliente%>&intGestion=13&intEjecutivo=<%=intEjecutivo%>&intDePPal=1&intRemesa=<%=intRemesa%>"><%=FN(intMontoTotalConAvenimiento/1000000,0)%> mm$</a></td>
			<td>&nbsp;</td>
		</tr>
		</table>
    </td>
    <td>
		<table ALIGN="CENTER" WIDTH="200" border="0">
		<tr BGCOLOR="#FFFFFF">
		  <td colspan="3" align="center"><strong>Casos Retirados</strong></td>
		  </tr>
		<tr BGCOLOR="#FFFFFF">
			<td>&nbsp;</td>
			<td bordercolor="#0000FF" align="center"><a href="informe_estatus.asp?strCliente=<%=strCliente%>&intGestion=R&intEjecutivo=<%=intEjecutivo%>&intDePPal=1&intRemesa=<%=intRemesa%>"><%=FN(intTotalMontoRetiro/1000000,0)%> mm$</a></td>
			<td>&nbsp;</td>
		</tr>
		</table>
    </td>
</tr>
</Table>
<BR>


<BR>
<table width="725" height="175" border="0" align="center">
  <tr height="35">
    <td width="55" align="center">&nbsp;</td>
    <td width="20" align="center"><span class="Estilo4">&nbsp</span></td>
    <td width="55" align="center">&nbsp;</td>
    <td width="20" align="center"><img src="../images/flecha_azul_arriba.jpg" width="20" height="11"></td>
    <td width="55" bgcolor="#0000FF" align="center"><span class="Estilo5"><%=FN(intMontoInubicable/1000000,0)%></span></td>
    <td align="center"><span class="Estilo4"><img src="../images/flecha_azul.jpg" width="20" height="14"></span></td>
    <td width="55" bgcolor="#0000FF" align="center"><span class="Estilo5"><%=FN(intMontoTotalIncobrables/1000000,0)%></span></td>
    <td width="20" align="center"><span class="Estilo4">&nbsp</span></td>
    <td width="55" align="center"><span class="Estilo4">&nbsp</span></td>
    <td width="20" align="center"><span class="Estilo4">&nbsp</span></td>
    <td width="55" align="center"><span class="Estilo4">&nbsp</span></td>
    <td width="20" align="center"><span class="Estilo4">&nbsp</span></td>
    <td width="55" align="center"><span class="Estilo4">&nbsp</span></td>
    <td width="20" align="center"><span class="Estilo4">&nbsp</span></td>
    <td width="55" align="center"><span class="Estilo4">&nbsp</span></td>
    <td width="20" align="center"><span class="Estilo4">&nbsp</span></td>
    <td width="55" align="center"><span class="Estilo4">&nbsp</span></td>
  </tr>








  <tr height="35">
      <td bgcolor="#0000FF" align="center"><span class="Estilo5"><%=FN(intMontoRecienAsignado/1000000,0)%></span></td>
      <td align="center"><img src="../images/flecha_azul.jpg" width="20" height="14"></td>
      <td bgcolor="#0000FF" align="center"><span class="Estilo5"><%=FN(intMontoVerifDomicilio/1000000,0)%></span></td>
      <td align="center"><span class="Estilo4">&nbsp</span></td>
      <td align="center"><span class="Estilo4">
      <a href="informe_estatus.asp?strCliente=<%=strCliente%>&intGestion=3&intEjecutivo=<%=intEjecutivo%>&intDePPal=1&intRemesa=<%=intRemesa%>">Inubicab.</a></span>
      </span></td>
      <td align="center"><span class="Estilo4">&nbsp</span></td>
      <td align="center"><span class="Estilo4">
	  <a href="informe_estatus.asp?strCliente=<%=strCliente%>&intGestion=14&intEjecutivo=<%=intEjecutivo%>&intDePPal=1&intRemesa=<%=intRemesa%>">InCobrab.</a></span>
      </span></td>
      <td align="center"><span class="Estilo4">&nbsp</span></td>
      <td align="center"><span class="Estilo4">&nbsp</span></td>
      <td align="center"><img src="../images/flecha_azul_arriba.jpg" width="20" height="11"></td>
      <td bgcolor="#0000FF" align="center"><span class="Estilo5"><%=FN(intMontoBusqNegativa/1000000,0)%></span></td>
      <td align="center"><span class="Estilo4">&nbsp</span></td>
      <td align="center"><span class="Estilo4">&nbsp</span></td>
      <td align="center"><span class="Estilo4">&nbsp</span></td>
      <td align="center"><span class="Estilo4">&nbsp</span></td>
      <td align="center"><span class="Estilo4">&nbsp</span></td>
      <td align="center"><span class="Estilo4">&nbsp</span></td>
  </tr>
  <tr height="35">
    <td align="center"><span class="Estilo4">
    <a href="informe_estatus.asp?strCliente=<%=strCliente%>&intGestion=1&intEjecutivo=<%=intEjecutivo%>&intRemesa=<%=intRemesa%>&intDePPal=1">Recien Asignados</a></span>
    </td>
    <td align="center"><span class="Estilo4">&nbsp</span></td>
    <td align="center"><span class="Estilo4">
    	<a href="informe_estatus.asp?strCliente=<%=strCliente%>&intGestion=2&intEjecutivo=<%=intEjecutivo%>&intDePPal=1&intRemesa=<%=intRemesa%>">Verif.de Domicilio</a></span>
    </span></td>
    <td align="center"><img src="../images/flecha_azul_abajo.jpg" width="20" height="11"></td>
    <td bgcolor="#0000FF" align="center"><span class="Estilo5"><%=FN(intMontoUbicable/1000000,0)%></span></td>
    <td align="center"><span class="Estilo4"><img src="../images/flecha_azul.jpg" width="20" height="14"></span></td>
    <td bgcolor="#0000FF" align="center"><span class="Estilo5"><%=FN(intMontoIngreTribunal/1000000,0)%></span></td>
    <td align="center"><img src="../images/flecha_azul.jpg" width="20" height="14"></td>
    <td bgcolor="#0000FF" align="center"><span class="Estilo5"><%=FN(intMontoNotificacion/1000000,0)%></span></td>
    <td align="center"><span class="Estilo4">&nbsp</span></td>
    <td align="center"><span class="Estilo4">
    <a href="informe_estatus.asp?strCliente=<%=strCliente%>&intGestion=7&intEjecutivo=<%=intEjecutivo%>&intDePPal=1&intRemesa=<%=intRemesa%>">Busqueda Negativa</a>
    </span></td>
    <td align="center"><span class="Estilo4">&nbsp</span></td>
    <td align="center"><span class="Estilo4">&nbsp</span></td>
    <td align="center"><span class="Estilo4">&nbsp</span></td>
    <td align="center"><span class="Estilo4">&nbsp</span></td>
    <td align="center"><span class="Estilo4">&nbsp</span></td>
    <td align="center"><span class="Estilo4">&nbsp</span></td>
  </tr>
  <tr height="35">
      <td align="center"><span class="Estilo4">&nbsp</span></td>
      <td align="center"><span class="Estilo4">&nbsp</span></td>
      <td align="center"><span class="Estilo4">&nbsp</span></td>
      <td align="center"><span class="Estilo4">&nbsp</span></td>
      <td align="center"><span class="Estilo4">
      <a href="informe_estatus.asp?strCliente=<%=strCliente%>&intGestion=4&intEjecutivo=<%=intEjecutivo%>&intDePPal=1&intRemesa=<%=intRemesa%>">Ubicables</a></span>
      </span></td>
      <td align="center"><span class="Estilo4">&nbsp</span></td>
      <td align="center"><span class="Estilo4">
      <a href="informe_estatus.asp?strCliente=<%=strCliente%>&intGestion=5&intEjecutivo=<%=intEjecutivo%>&intDePPal=1&intRemesa=<%=intRemesa%>">Ingres. a Tribunal</a></span>
      </span></td>
      <td align="center"><span class="Estilo4">&nbsp</span></td>
      <td align="center"><span class="Estilo4">
      <a href="informe_estatus.asp?strCliente=<%=strCliente%>&intGestion=6&intEjecutivo=<%=intEjecutivo%>&intDePPal=1&intRemesa=<%=intRemesa%>">Notificacion</a></span>
      </span></td>
      <td align="center"><img src="../images/flecha_azul_abajo.jpg" width="20" height="11"></td>
      <td bgcolor="#0000FF" align="center"><span class="Estilo5"><%=FN(intMontoBusqPositiva/1000000,0)%></span></td>
      <td align="center"><span class="Estilo4"><img src="../images/flecha_azul.jpg" width="20" height="14"></span></td>
      <td bgcolor="#0000FF" align="center"><span class="Estilo5"><%=FN(intMontoComparendo/1000000,0)%></span></td>
      <td align="center"><img src="../images/flecha_azul.jpg" width="20" height="14"></td>
      <td bgcolor="#0000FF" align="center"><span class="Estilo5"><%=FN(intMontoParaFallo/1000000,0)%></span></td>
      <td align="center"><img src="../images/flecha_azul.jpg" width="20" height="14"></td>
      <td bgcolor="#0000FF" align="center"><span class="Estilo5"><%=FN(intMontoTerminado/1000000,0)%></span></td>
  </tr>

  <tr height="35">
      <td align="center"><span class="Estilo4">&nbsp</span></td>
      <td align="center"><span class="Estilo4">&nbsp</span></td>
      <td align="center"><span class="Estilo4">&nbsp</span></td>
      <td align="center"><span class="Estilo4">&nbsp</span></td>
      <td align="center"><img src="../images/flecha_azul_abajo.jpg" width="20" height="11"></td>
	  <td align="center"><img src="../images/flecha_azul.jpg" width="20" height="14"></td>
      <td bgcolor="#0000FF" align="center"><span class="Estilo5"><%=FN(intMontoTotalUbicConComp/1000000,0)%></span></td>
      <td align="center"><span class="Estilo4">&nbsp</span></td>
      <td align="center"><span class="Estilo4">&nbsp</span></td>
      <td align="center"><span class="Estilo4">&nbsp</span></td>
      <td align="center"><span class="Estilo4">
      <a href="informe_estatus.asp?strCliente=<%=strCliente%>&intGestion=8&intEjecutivo=<%=intEjecutivo%>&intDePPal=1&intRemesa=<%=intRemesa%>">Busqueda Positiva</a>
      </span></td>
      <td align="center"><span class="Estilo4">&nbsp</span></td>
      <td align="center"><span class="Estilo4">
      <a href="informe_estatus.asp?strCliente=<%=strCliente%>&intGestion=9&intEjecutivo=<%=intEjecutivo%>&intDePPal=1&intRemesa=<%=intRemesa%>">Comparendo</a>
      </span></td>
      <td align="center"><span class="Estilo4">&nbsp</span></td>
      <td align="center"><span class="Estilo4">
      <a href="informe_estatus.asp?strCliente=<%=strCliente%>&intGestion=10&intEjecutivo=<%=intEjecutivo%>&intDePPal=1&intRemesa=<%=intRemesa%>">Para Fallo</a>
      </span></td>
      <td align="center"><span class="Estilo4">&nbsp</span></td>
      <td align="center"><span class="Estilo4">
      <a href="informe_estatus.asp?strCliente=<%=strCliente%>&intGestion=11&intEjecutivo=<%=intEjecutivo%>&intDePPal=1&intRemesa=<%=intRemesa%>">Terminado</a>
      </span></td>
  </tr>

   <tr height="35">
  	<td align="center"><span class="Estilo4">&nbsp</span></td>
  	<td align="center"><span class="Estilo4">&nbsp</span></td>
  	<td align="center"><span class="Estilo4">&nbsp</span></td>
  	<td align="center"><span class="Estilo4">&nbsp</span></td>
  	<td align="center"><span class="Estilo4">&nbsp</span></td>
  	<td align="center"><span class="Estilo4">&nbsp</span></td>
  	<td align="center"><span class="Estilo4">
  	      <a href="informe_estatus.asp?strCliente=<%=strCliente%>&intGestion=15&intEjecutivo=<%=intEjecutivo%>&intDePPal=1&intRemesa=<%=intRemesa%>">Ubic. Con.Comp</a></span>
        </span></td>
  	<td align="center"><span class="Estilo4">&nbsp</span></td>
  	<td align="center"><span class="Estilo4">&nbsp</span></td>
  	<td align="center"><span class="Estilo4">&nbsp</span></td>
  	<td align="center"><span class="Estilo4">&nbsp</span></td>
  	<td align="center"><span class="Estilo4">&nbsp</span></td>
  	<td align="center"><span class="Estilo4">&nbsp</span></td>
  	<td align="center"><span class="Estilo4">&nbsp</span></td>
  	<td align="center"><span class="Estilo4">&nbsp</span></td>
  	<td align="center"><span class="Estilo4">&nbsp</span></td>
  	<td align="center"><span class="Estilo4">&nbsp</span></td>
  </tr>
</table>




<BR>

<table ALIGN="CENTER" WIDTH="800" border="0">

<tr BGCOLOR="#FFFFFF">
	<td>
		<table ALIGN="CENTER" WIDTH="200" border="0">
		<tr BGCOLOR="#FFFFFF">
		  <td colspan="3" align="center"><strong>Rut Pagados (Pago Total)</strong></td>
		  </tr>
		<tr BGCOLOR="#FFFFFF">
			<td bordercolor="#0000FF">&nbsp;</td>
		    <td bordercolor="#0000FF" align="center"><a href="informe_rutpagados.asp?CB_CLIENTE=<%=strCliente%>&intGestion=T&intPagoTotal=1&intDePPal=1&CB_REMESA=<%=intRemesa%>"><%=FN(intRutConPagoTotal,0)%></a></td>
		    <td bordercolor="#0000FF">&nbsp;</td>
		</tr>
	  </table>
	</td>
    <td>
    	<table ALIGN="CENTER" WIDTH="200" border="0">
		<tr BGCOLOR="#FFFFFF">
		  <td colspan="3" align="center"><strong>Documentos Pagados</strong></td>
		  </tr>
		<tr BGCOLOR="#FFFFFF">
			<td>&nbsp;</td>
			<td bordercolor="#0000FF" align="center"><a href="informe_docpagados.asp?intGestion=12&intEjecutivo=<%=intEjecutivo%>&intPagoTotal=1&intDePPal=1&strCliente=<%=strCliente%>&intRemesa=<%=intRemesa%>"><%=FN(intFoliosConPagoTotal,0)%></a></td>
			<td>&nbsp;</td>
		</tr>
		</table>
    </td>

    <td>
    	<table ALIGN="CENTER" WIDTH="200" border="0">
		<tr BGCOLOR="#FFFFFF">
		  <td colspan="3" align="center"><strong>Monto Pagado</strong></td>
		  </tr>
		<tr BGCOLOR="#FFFFFF">
			<td>&nbsp;</td>
			<td bordercolor="#0000FF" align="center"><a href="informe_docpagados.asp?intGestion=13&intEjecutivo=<%=intEjecutivo%>&intPagoTotal=1&intDePPal=1&intRemesa=<%=intRemesa%>"><%=FN(intMontosConPagoTotal,0)%></a></td>
			<td>&nbsp;</td>
		</tr>
		</table>
    </td>

    <td>
		<table ALIGN="CENTER" WIDTH="200" border="0">
		<tr BGCOLOR="#FFFFFF">
		  <td colspan="3" align="center"><strong>Ultima Actualización de Pagos</strong></td>
		  </tr>
		<tr BGCOLOR="#FFFFFF">
			<td>&nbsp;</td>
			<td bordercolor="#0000FF" align="center"><%=strUltAct%></td>
			<td>&nbsp;</td>
		</tr>
		</table>
    </td>
</tr>


<tr BGCOLOR="#FFFFFF">
	<td>
		<table ALIGN="CENTER" WIDTH="200" border="0">
		<tr BGCOLOR="#FFFFFF">
		  <td colspan="3" align="center"><strong>Rut Pagados (Parcialmente)</strong></td>
		  </tr>
		<tr BGCOLOR="#FFFFFF">
			<td bordercolor="#0000FF">&nbsp;</td>
		    <td bordercolor="#0000FF" align="center"><a href="informe_rutpagados.asp?CB_CLIENTE=<%=strCliente%>&intGestion=T&intPagoTotal=0&intDePPal=1&CB_REMESA=<%=intRemesa%>"><%=FN(intRutConPagoParcial,0)%></a></td>
		    <td bordercolor="#0000FF">&nbsp;</td>
		</tr>
	  </table>
	</td>


    <td>
    	<table ALIGN="CENTER" WIDTH="200" border="0">
		<tr BGCOLOR="#FFFFFF">
		  <td colspan="3" align="center"><strong>Documentos Pagados</strong></td>
		  </tr>
		<tr BGCOLOR="#FFFFFF">
			<td>&nbsp;</td>
			<td bordercolor="#0000FF" align="center"><a href="informe_docpagados.asp?intGestion=12&intEjecutivo=<%=intEjecutivo%>&intPagoTotal=0&intDePPal=1&intRemesa=<%=intRemesa%>"><%=FN(intFoliosConPagoParcial,0)%></a></td>
			<td>&nbsp;</td>
		</tr>
		</table>
    </td>

    <td>
    	<table ALIGN="CENTER" WIDTH="200" border="0">
		<tr BGCOLOR="#FFFFFF">
		  <td colspan="3" align="center"><strong>Monto Pagado</strong></td>
		  </tr>
		<tr BGCOLOR="#FFFFFF">
			<td>&nbsp;</td>
			<td bordercolor="#0000FF" align="center"><a href="informe_docpagados.asp?intGestion=13&intEjecutivo=<%=intEjecutivo%>&intPagoTotal=0&intDePPal=1&intRemesa=<%=intRemesa%>"><%=FN(intMontosConPagoParcial,0)%></a></td>
			<td>&nbsp;</td>
		</tr>
		</table>
    </td>

    <td>
		<table ALIGN="CENTER" WIDTH="200" border="0">
		<tr BGCOLOR="#FFFFFF">
		  <td>&nbsp;</td>
		</tr>
		</table>
    </td>
</tr>

</Table>


</BODY>
<script language="JavaScript1.2">
function envia()	{
	if (datos.CB_CLIENTE.value=='0'){
		alert('DEBE SELECCIONAR UN CLIENTE');
	}else{
		datos.action='EstatusCartJud.asp';
		datos.submit();
	}
}
</script>
