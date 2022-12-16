<% @LCID = 1034 %>
<!--#include file="arch_utils.asp"-->
<!--#include file="sesion.asp"-->
<!--#include file="../lib/comunes/rutinas/funciones.inc" -->
<!--#include file="../lib/comunes/rutinas/funcionesBD.inc" -->
<!--#include file="../lib/comunes/rutinas/rutinasFecha.inc" -->
<!--#include file="lib.asp"-->
<!--#include file="asp/comunes/general/rutinasBooleano.inc"-->
<!--#include file="../lib/comunes/rutinas/TraeCampo.inc" -->

<script language="JavaScript">
function ventanaSecundaria (URL)
{
	window.open(URL,"DETALLE","width=200, height=200, scrollbars=no, menubar=no, location=no, resizable=no")
}
</script>

<%

txt_FechaIni= request("inicio")
txt_FechaFin= request("termino")

abrirscg()
	If Trim(txt_FechaIni) = "" Then
		txt_FechaIni = TraeFechaActual(Conn)
	End If

	If Trim(txt_FechaFin) = "" Then
		txt_FechaFin = TraeFechaActual(Conn)
	End If
cerrarscg()



cliente = request("CB_CLIENTE")

intCartera = request("CB_CARTERA")
cliente=session("ses_codcli")

intGestion = request("intGestion")
intDePPal = request("intDePPal")
intRemesa = request("CB_REMESA")

intCobrador = request("CB_COBRADOR")
intProcurador = request("CB_PROCURADOR")
intAbogado = request("CB_ABOGADO")

intDiaIni=Mid(txt_FechaIni,1,2)
intMesIni=Mid(txt_FechaIni,4,2)
intAnoIni=Mid(txt_FechaIni,7,4)

intDiaFin=Mid(txt_FechaFin,1,2)
intMesFin=Mid(txt_FechaFin,4,2)
intAnoFin=Mid(txt_FechaFin,7,4)


If (Trim(intMesIni) <> Trim(intMesFin)) or (Trim(intAnoIni) <> Trim(intAnoFin)) Then
%>
<script language="JavaScript">
	alert('Mes y Año de Fecha Inicio y Fecha de Término deben ser los mismos');
	history.back();
</script>
<%
	Response.End
End If

abrirscg()
If Trim(txt_FechaIni) <> "" AND Trim(txt_FechaIni) <> "" Then
	strSql = "select datediff(d,'" & txt_FechaIni & "','" & txt_FechaFin & "') as DIAS"
	set rsDias=Conn.execute(strSql)
	If Not rsDias.Eof Then
		intDias=rsDias("DIAS") + 1
	Else
		intDias=31
	End If
End If
cerrarscg()
%>
<title>Gestiones</title>

<style type="text/css">
<!--
.Estilo37 {color: #FFFFFF}
-->
</style>
<form name="datos" method="post">
<INPUT TYPE="HIDDEN" NAME="intGestion" VALUE="<%=intGestion%>">
<table width="100%" border="1" bordercolor="#FFFFFF">
	<tr>
		<TD height="20" ALIGN=LEFT class="pasos1_i">
			<B>INFORME DE GESTIONES</B>
		</TD>
	</tr>
</table>
<table width="100%" border="0">
  <tr>
    <td valign="top" background="../images/fondo_coventa.jpg">
	<BR>
	<table width="100%" border="0">
      <tr bgcolor="#<%=session("COLTABBG")%>" class="Estilo13">
      	<td width="30">F.INICIO</td>
        <td width="30">F.TERMINO</td>
        <td width="100">MANDANTE</td>
        <td width="100">CARTERA</td>
        <!--td width="100">PROCURADOR</td>
        <td width="100">COBRADOR</td-->
        <td width="100">&nbsp</td>
      </tr>
      <tr>
		<td>
			<input name="inicio" type="text" id="inicio" value="<%=txt_FechaIni%>" size="9" maxlength="10">
			<a href="javascript:showCal('Calendar7');"><img src="../lib/calendario.gif" border="0">
		</td>
		<td>
			<input name="termino" type="text" id="termino" value="<%=txt_FechaFin%>" size="9" maxlength="10">
			<a href="javascript:showCal('Calendar6');"><img src="../lib/calendario.gif" border="0"></a>
		</td>

        <td>
			<select name="CB_CLIENTE">
				<%
				abrirscg()
				ssql="SELECT CODCLIENTE,RAZON_SOCIAL FROM CLIENTE WHERE CODCLIENTE = '" & cliente & "' ORDER BY RAZON_SOCIAL"

				set rsTemp= Conn.execute(ssql)
				if not rsTemp.eof then
					do until rsTemp.eof%>
					<option value="<%=rsTemp("CODCLIENTE")%>"<%if cliente=rsTemp("CODCLIENTE") then response.Write("SELECTED") End If%>><%=rsTemp("RAZON_SOCIAL")%></option>
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
			<select name="CB_CARTERA">
				<option value="">TODAS</option>
				<%
				AbrirSCG()
					strSql="SELECT CONVERT(VARCHAR(10),FECHA_LLEGADA,103) as FECHAREMESA , CODREMESA FROM REMESA WHERE CODCLIENTE = '" & cliente & "' AND CODREMESA >= 100"
					set rsRemesa=Conn.execute(strSql)
					Do While not rsRemesa.eof
					If Trim(intCartera)=Trim(rsRemesa("CODREMESA")) Then strSelRemesa = "SELECTED" Else strSelRemesa = ""
					%>
					<option value="<%=rsRemesa("CODREMESA")%>" <%=strSelRemesa%>> <%=rsRemesa("CODREMESA") & " - " & rsRemesa("FECHAREMESA")%></option>
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
		  <input type="button" name="SUBMIT" value="OK" onClick="envia();">
		  <input type="button" name="SUBMIT" value="EXCEL" onClick="excel();">
		</td>

      </tr>
    </table>

<% If TraeSiNo(session("perfil_proc")) = "Si" Then %>

	<table width="100%" border="1" bordercolor = "#<%=session("COLTABBG")%>" cellSpacing=0 cellPadding=1>
		<tr bgcolor="#<%=session("COLTABBG")%>" class="Estilo13">
			<td width="100%" colspan=<%=intDiaFin + 2 %>>GESTIONES PROCURADORES</td>
      </tr>
   	<%
   		'Response.End

		AbrirScg()

		strSql = "SELECT * FROM USUARIO WHERE PERFIL_COB = 1 AND ACTIVO = 1"


		If TraeSiNo(session("perfil_adm"))="Si" or TraeSiNo(session("perfil_sup"))="Si" Then

		Else
			strSql = strSql & "	AND ID_USUARIO = " & session("session_idusuario")
		End If

		set rsUsuario = Conn.execute(strSql)
		Do While Not rsUsuario.Eof
			intCodEjecutivo = rsUsuario("id_usuario")
			strNombreEjecutivo = rsUsuario("nombres_usuario") & " " & rsUsuario("apellidos_usuario")

			If strCabecera <> "SI" Then
				%>
				<tr>
					<td width="100">&nbsp</td>
					<%For i = intDiaIni to intDiaFin%>
					<td align="RIGHT" width="18"><%=i%></td>
					<%
			Next
			%>
			<td>Total</td>
			<%
			End If
			strCabecera = "SI"
			%>
			</tr>
			<tr>
			<td><%=strNombreEjecutivo%></td>
			<%
			intTotal=0
			For i = intDiaIni to intDiaFin
				If Trim(cliente) = "" Then
					strSql = "SELECT IsNull(COUNT(*),0) as CANTIDAD FROM GESTIONES_JUDICIAL WHERE DAY(FECHAINGRESO) = " & i & " AND MONTH(FECHAINGRESO) = " & intMesIni & " AND YEAR(FECHAINGRESO) = " & intAnoIni & " AND IDUSUARIO = " & intCodEjecutivo
					If Trim(intCartera) <> "" Then
						strSql = strSql & " AND RUTDEUDOR IN (SELECT RUTDEUDOR FROM CUOTA WHERE CODREMESA = " & intCartera & ")"
					End if
				Else
					strSql = "SELECT IsNull(COUNT(*),0) as CANTIDAD FROM GESTIONES_JUDICIAL WHERE DAY(FECHAINGRESO) = " & i & " AND MONTH(FECHAINGRESO) = " & intMesIni & " AND YEAR(FECHAINGRESO) = " & intAnoIni & " AND IDUSUARIO = " & intCodEjecutivo & " AND CODCLIENTE = '" & cliente & "'"
					If Trim(intCartera) <> "" Then
						strSql = strSql & " AND RUTDEUDOR IN (SELECT RUTDEUDOR FROM CUOTA WHERE CODCLIENTE = '" & cliente & "' AND CODREMESA = " & intCartera & ")"
					End if
				End if
				set rsCuenta = Conn.execute(strSql)
				If not rsCuenta.eof Then
					intCantidad = rsCuenta("CANTIDAD")
				Else
					intCantidad = 0
				End If
				intTotal=intTotal+intCantidad
			%>
				<td align="RIGHT">
					<A HREF="informe_gestiones_jud_detalle.asp?intTipoGestion=J&intDia=<%=i%>&intMes=<%=intMesIni%>&intAno=<%=intAnoIni%>&intEjecutivo=<%=intCodEjecutivo%>&strCliente=<%=cliente%>">
						<%=intCantidad%>
					</A>
				</td>
			<%Next%>
				<td align="RIGHT"><%=intTotal%></td>
			</tr>

		<%
   		rsUsuario.MoveNext

   		Loop
   		CerrarScg()
%>
		<tr>
			<td>Total</td>
			<%
			intTotal=0
			AbrirScg()
			For i = intDiaIni to intDiaFin

				If Trim(cliente) = "" Then
					strSql = "SELECT IsNull(COUNT(*),0) as CANTIDAD FROM GESTIONES_JUDICIAL WHERE DAY(FECHAINGRESO) = " & i & " AND MONTH(FECHAINGRESO) = " & intMesIni & " AND YEAR(FECHAINGRESO) = " & intAnoIni
					If Trim(intCartera) <> "" Then
						strSql = strSql & " AND RUTDEUDOR IN (SELECT RUTDEUDOR FROM CUOTA WHERE CODREMESA = " & intCartera & ")"
					End if
				Else
					strSql = "SELECT IsNull(COUNT(*),0) as CANTIDAD FROM GESTIONES_JUDICIAL WHERE DAY(FECHAINGRESO) = " & i & " AND MONTH(FECHAINGRESO) = " & intMesIni & " AND YEAR(FECHAINGRESO) = " & intAnoIni & " AND IDUSUARIO = " & intCodEjecutivo & " AND CODCLIENTE = '" & cliente & "'"
					If Trim(intCartera) <> "" Then
						strSql = strSql & " AND RUTDEUDOR IN (SELECT RUTDEUDOR FROM CUOTA WHERE CODCLIENTE = '" & cliente & "' AND CODREMESA = " & intCartera & ")"
					End if
				End if

				set rsCuenta = Conn.execute(strSql)
				If not rsCuenta.eof Then
					intCantidadT = rsCuenta("CANTIDAD")
				Else
					intCantidadT = 0
				End If

				intTotalT=intTotalT+intCantidadT
			%>
				<td align="RIGHT"><%=intCantidadT%></td>
			<%Next
			CerrarScg()
			%>
				<td align="RIGHT"><%=intTotalT%></td>
		</tr>
    </table>

<% End If %>

<br>
    <table width="100%" border="1" bordercolor = "#<%=session("COLTABBG")%>" cellSpacing=0 cellPadding=1>
		<tr bgcolor="#<%=session("COLTABBG")%>" class="Estilo13">
			<td width="100%" colspan=<%=intDiaFin + 2%>>GESTIONES COBRADORES</td>
		</tr>
<%
	strCabecera = ""
	AbrirScg()

	strSql = "	SELECT b.id_usuario, b.nombres_usuario, b.apellidos_usuario,"
%>
		<tr>
			<td width="100">&nbsp</td>
<%
	sep = " "
	For i = intDiaIni to intDiaFin
		strSql = strSql & sep & "COUNT(CASE WHEN DAY(a.fechaingreso) = " & i & " THEN 1 ELSE NULL END) AS cant" & i
%>
			<td align="RIGHT" width="18"><%=i%></td>
<%
		sep = ", "
	Next
%>
			<td>Total</td>
		</tr>
<%
	strSql = strSql & " FROM gestiones a INNER JOIN usuario b ON b.id_usuario = a.idusuario "

	If Trim(intCartera) <> "" Then
		strSql = strSql & "	INNER JOIN cuota c ON c.codcliente = a.codcliente AND c.rutdeudor = a.rutdeudor AND c.codremesa = " & intCartera
	End If

	cmd = "WHERE "
	If Trim(cliente) <> "" Then
		strSql = strSql & cmd & "a.codcliente = " & cliente
		cmd = " AND "
	End If

	If TraeSiNo(session("perfil_adm")) = "Si" or TraeSiNo(session("perfil_sup")) = "Si" Then
	else
		strSql = strSql & cmd & "b.id_usuario = " & session("session_idusuario")
	End If

	strSql = strsql & cmd & "a.fechaingreso BETWEEN CAST('" & txt_FechaIni & "' AS DATETIME) AND DATEADD(DAY, 1, CAST('" & txt_FechaFin & "' AS DATETIME)) "
	strSql = strSql & " GROUP BY b.id_usuario, b.nombres_usuario, b.apellidos_usuario"

	Dim grandTotal()
	Redim grandTotal(intDiaFin - intDiaIni)

	set rs = Conn.execute(strSql)
	Do While Not rs.Eof
		intCodEjecutivo = rs("id_usuario")
		strNombreEjecutivo = rs("nombres_usuario") & " " & rs("apellidos_usuario")
%>
		<tr>
			<td><%=strNombreEjecutivo%></td>
<%
		intTotal = 0
		For i = intDiaIni to intDiaFin
			intCantidad = rs("cant" & i)
			intTotal = intTotal + intCantidad
			grandTotal(i - intDiaIni) = grandTotal(i - intDiaIni) + intCantidad
%>
			<td align="RIGHT">
				<a href="informe_gestiones_jud_detalle.asp?intTipoGestion=P&intDia=<%=i%>&intMes=<%=intMesIni%>&intAno=<%=intAnoIni%>&intEjecutivo=<%=intCodEjecutivo%>&strCliente=<%=cliente%>"><%=intCantidad%></a>
			</td>
<%
		Next
%>
			<td align="RIGHT"><%=intTotal%></td>
		</tr>
<%
		rs.MoveNext

	Loop
	CerrarScg()
%>
		<tr>
			<td><strong>Total</strong></td>
<%
	intTotal = 0
	For i = intDiaIni to intDiaFin
%>
			<td align="RIGHT">
				<a href="informe_gestiones_jud_detalle.asp?intTipoGestion=P&intDia=<%=i%>&intMes=<%=intMesIni%>&intAno=<%=intAnoIni%>&strCliente=<%=cliente%>"><%=grandTotal(i - intDiaIni)%></a>
			</td>
<%
		intTotal = intTotal + grandTotal(i - intDiaIni)
	Next
%>
			<td align="RIGHT"><%=intTotal%></td>
		</tr>
	</table>
</form>

<script language="JavaScript1.2">
	function envia()
	{
		if (datos.CB_CLIENTE.value=='0'){
			alert('DEBE SELECCIONAR UN CLIENTE');
		} else {
			datos.action='informe_gestiones_jud.asp';
			datos.submit();
		}
	}

	function excel()
	{
		if (datos.CB_CLIENTE.value=='0'){
			alert('DEBE SELECCIONAR UN CLIENTE');
		} else {
			datos.action='informe_gestiones_jud_xls.asp';
			datos.submit();
		}
	}
</script>
