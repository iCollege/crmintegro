<% @LCID = 1034 %>
<!--#include file="arch_utils.asp"-->
<!--#include file="../lib/comunes/rutinas/funciones.inc" -->
<!--#include file="../lib/comunes/rutinas/funcionesBD.inc" -->
<!--#include file="../lib/comunes/rutinas/rutinasFecha.inc" -->
<!--#include file="lib.asp"-->
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
		txt_FechaIni = "01" & Mid(txt_FechaIni,3,10)
	End If

	If Trim(txt_FechaFin) = "" Then
		txt_FechaFin = TraeFechaActual(Conn)
	End If

	strSql = "update caja_web_emp set codcobrador = t.usuario_asig from caja_web_emp e, cuota t where t.rutdeudor = e.rutdeudor and t.codcliente = e.cod_cliente and e.codcobrador is null"
	set rsUpdate = Conn.execute(strSql)

	cerrarscg()



cliente = request("CB_CLIENTE")
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
		intDias = rsDias("DIAS") + 1
	Else
		intDias = 31
	End If
End If




strSql = "SELECT COUNT(*) as CANTIDAD FROM CALENDARIO_METAS WHERE ANO = " & intAnoFin & " AND MES = " & intMesFin
set rsFeriados = Conn.execute(strSql)
If Not rsFeriados.Eof Then
	intCantFeriados = rsFeriados("CANTIDAD")
End If


strSql = "SELECT DAY(DATEADD(DAY,-1,'01/" & intMesFin + 1 & "/" & intAnoFin & "')) as DIAS"
set rsFeriados = Conn.execute(strSql)
If Not rsFeriados.Eof Then
	intDiasMes = rsFeriados("DIAS")
Else
	intDiasMes = 30
End If



intDiasHabiles = intDiasMes - intCantFeriados
''Response.write "<br>intDiasMes = " & intDiasMes
''Response.write "<br>intCantFeriados = " & intCantFeriados


strSql = "UPDATE CUOTA SET HONORARIOS_INF = (VALORCUOTA - SALDO) * 0.09 "
strSql = strSql & "WHERE ESTADO_DEUDA IN (2,3,4,7,8) AND HONORARIOS_INF IS NULL"
set rsModifica = Conn.execute(strSql)


cerrarscg()
%>
<title>Metas</title>

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
			<B>INFORME DE METAS</B>
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
		  <input type="button" name="SUBMIT" value="OK" onClick="envia();">
		  <input type="button" name="SUBMIT" value="EXCEL" onClick="excel();">
		</td>

      </tr>
    </table>
	<br>
    <table width="100%" border="1" bordercolor = "#<%=session("COLTABBG")%>" cellSpacing=0 cellPadding=1>
		  <tr bgcolor="#<%=session("COLTABBG")%>" class="Estilo13">
			<td width="100%" colspan=<%=intDiaFin + 2%>>INFORME DE METAS</td>
	      </tr>
	   	<%
	   		'Response.End
			strCabecera = ""
			AbrirScg()

			strSql = "SELECT * FROM USUARIO WHERE PERFIL_COB = 1 AND ACTIVO = 1"
			set rsUsuario = Conn.execute(strSql)
			Do While Not rsUsuario.Eof
				intCodEjecutivo = rsUsuario("id_usuario")
				strNombreEjecutivo = UCASE(rsUsuario("nombres_usuario")) & " " & UCASE(rsUsuario("apellidos_usuario"))
				If strCabecera <> "SI" Then
					%>
					<tr>
						<td width="100">&nbsp</td>
						<%For i = intDiaIni to intDiaFin

						strSql = "SELECT IsNull(count(*),0) as CANTIDAD FROM CALENDARIO_METAS WHERE MES = " & intMesIni & " AND ANO = " & intAnoIni & " AND DIA = " & i
						set rsCuenta = Conn.execute(strSql)
						If not rsCuenta.eof Then
							intCantidad = rsCuenta("CANTIDAD")
							If intCantidad = 0 Then
							%>
							<td align="RIGHT" width="18"><%=i%></td>
							<%
							End if
						End If
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
					strSql = "SELECT IsNull(meta/" & intDiasHabiles & ",0) as CANTIDAD FROM USUARIO_META WHERE SUBSTRING(CAST(PERIODO AS CHAR(6)),5,2) = " & intMesIni & " AND SUBSTRING(CAST(PERIODO AS CHAR(6)),1,4) = " & intAnoIni & " AND ID_USUARIO = " & intCodEjecutivo
					''Response.write "<br>" & strSql
					set rsCuenta = Conn.execute(strSql)
					If not rsCuenta.eof Then
						intMeta = rsCuenta("CANTIDAD")
					Else
						intMeta = 0
					End If



					strSql = "SELECT IsNull(count(*),0) as CANTIDAD FROM CALENDARIO_METAS WHERE MES = " & intMesIni & " AND ANO = " & intAnoIni & " AND DIA = " & i
					set rsCuenta = Conn.execute(strSql)
					If not rsCuenta.eof Then
						intCantidad = rsCuenta("CANTIDAD")
						If intCantidad = 0 Then
						intTotal=intTotal+intMeta

						%>
						<td align="RIGHT">
						<!--A HREF="informe_metas_detalle.asp?intTipoGestion=P&intDia=<%=i%>&intMes=<%=intMesIni%>&intAno=<%=intAnoIni%>&intEjecutivo=<%=intCodEjecutivo%>&strCliente=<%=cliente%>"-->
						<%=intMeta%>
						<!--/A-->
						</td>
						<%


						End if

					End If


				Next%>
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
			intTotalT=0
			AbrirScg()
			For i = intDiaIni to intDiaFin


				strSql = "SELECT IsNull(SUM(meta/" & intDiasHabiles & "),0) as CANTIDAD FROM USUARIO_META WHERE SUBSTRING(CAST(PERIODO AS CHAR(6)),5,2) = " & intMesIni & " AND SUBSTRING(CAST(PERIODO AS CHAR(6)),1,4) = " & intAnoIni
				set rsCuenta = Conn.execute(strSql)
				If not rsCuenta.eof Then
					intCantidadT = rsCuenta("CANTIDAD")
				Else
					intCantidadT = 0
				End If



				strSql = "SELECT IsNull(count(*),0) as CANTIDAD FROM CALENDARIO_METAS WHERE MES = " & intMesIni & " AND ANO = " & intAnoIni & " AND DIA = " & i
				set rsCuenta = Conn.execute(strSql)
				If not rsCuenta.eof Then
					intCantidad = rsCuenta("CANTIDAD")
					If intCantidad = 0 Then
					intTotalT=intTotalT+intCantidadT
					%>
					<td align="RIGHT">
						<!--A HREF="informe_metas_detalle.asp?intTipoGestion=P&intDia=<%=i%>&intMes=<%=intMesIni%>&intAno=<%=intAnoIni%>&strCliente=<%=cliente%>"-->
							<%=intCantidadT%>
						<!--/A-->
					</td>
					<%
					End if
				End If
			Next
			CerrarScg()
			%>
				<td align="RIGHT"><%=intTotalT%></td>
		</tr>
		<tr>
			<td width="100%" colspan=<%=intDiaFin + 2%>&nbsp</td>
		</tr>
   		  <tr bgcolor="#<%=session("COLTABBG")%>" class="Estilo13">
				<td width="100%" colspan=<%=intDiaFin + 2%>>INFORME DE METAS</td>
		      </tr>
		   	<%
		   		''Response.End
				strCabecera = ""
				AbrirScg()

				strSql = "SELECT ID_USUARIO, NOMBRES_USUARIO, APELLIDOS_USUARIO FROM USUARIO WHERE PERFIL_COB = 1 AND ACTIVO = 1"
				strSql = strSql & " UNION SELECT 9999999999999999,'SIN ASIGNAR',''"
				set rsUsuario = Conn.execute(strSql)
				Do While Not rsUsuario.Eof
					intCodEjecutivo = rsUsuario("id_usuario")
					strNombreEjecutivo = UCASE(rsUsuario("nombres_usuario")) & " " & UCASE(rsUsuario("apellidos_usuario"))
					If strCabecera <> "SI" Then
						%>
						<tr>
							<td width="100">&nbsp</td>
							<%For i = intDiaIni to intDiaFin

							strSql = "SELECT IsNull(count(*),0) as CANTIDAD FROM CALENDARIO_METAS WHERE MES = " & intMesIni & " AND ANO = " & intAnoIni & " AND DIA = " & i
							set rsCuenta = Conn.execute(strSql)
							If not rsCuenta.eof Then
								intCantidad = rsCuenta("CANTIDAD")
								If intCantidad = 0 Then
								%>
								<td align="RIGHT" width="18"><%=i%></td>
								<%
								End if
							End If
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
						intHonorariosT = 0
						intHonorarios = 0
						intHonorariosM = 0

						strSql = "SELECT SUM(HONORARIOS_INF) AS PAGADOMANDANTE"
						strSql = strSql & " FROM CUOTA WHERE ESTADO_DEUDA IN (3,7) "
						strSql = strSql & " AND MONTH(FECHA_ESTADO) = " & intMesIni & " AND YEAR(FECHA_ESTADO) = " & intAnoIni & " AND DAY(FECHA_ESTADO) = " & i

						If Trim(intCodEjecutivo) = "9999999999999999" Then
							strSql = strSql & " AND USUARIO_ASIG NOT IN (SELECT ID_USUARIO FROM USUARIO WHERE PERFIL_COB = 1 AND ACTIVO = 1) "
						Else
							strSql = strSql & " AND USUARIO_ASIG = " & intCodEjecutivo
						End If
						'Response.write "<br>" & strSql

						set rsPagoMand = Conn.execute(strSql)
						If not rsPagoMand.eof Then
							 intHonorariosM = Round(ValNulo(rsPagoMand("PAGADOMANDANTE"),"N"),0)
						Else
							 intHonorariosM = 0
						End If

						'Response.write "<br>intHonorariosM=" & intHonorariosM


						strSql = "SELECT SUM(CAST(MONTO_CAPITAL AS INT)) AS MONTO_CAPITAL, ISNULL(SUM(CAST(MONTO_EMP AS INT)),0) AS HONORARIOS,"
						strSql = strSql & " SUM(CAST(INTERES_PLAZO AS INT)) AS INTERES,	SUM(CAST(INDEM_COMP AS INT)) AS INDEM_COMP, SUM(CAST(IC_INFORME AS INT)) AS IC_INFORME,"
						strSql = strSql & " SUM(CAST(GASTOSJUDICIALES AS INT)) AS GASTOSJUDICIALES"
						strSql = strSql & " FROM CAJA_WEB_EMP C "
						strSql = strSql & " WHERE MONTH(C.FECHA_PAGO) = " & intMesIni & " AND YEAR(C.FECHA_PAGO) = " & intAnoIni & " AND DAY(C.FECHA_PAGO) = " & i

						If Trim(intCodEjecutivo) = "9999999999999999" Then
							strSql = strSql & " AND C.CODCOBRADOR NOT IN (SELECT ID_USUARIO FROM USUARIO WHERE PERFIL_COB = 1 AND ACTIVO = 1) "
						Else
							strSql = strSql & " AND C.CODCOBRADOR = " & intCodEjecutivo
						End If


						''Response.write "<br>" & strSql


						set rsHonorarios = Conn.execute(strSql)
						If not rsHonorarios.eof Then
							intHonorarios = rsHonorarios("HONORARIOS") + ValNulo(rsHonorarios("IC_INFORME"),"N")
						Else
							intHonorarios = 0
						End If

						'Response.write "<br>intHonorarios=" & intHonorarios

						intHonorariosT = ValNulo(intHonorarios,"N") + ValNulo(intHonorariosM,"N")

						'Response.write "<br>intHonorariosT=" & intHonorariosT

						strSql = "SELECT IsNull(count(*),0) as CANTIDAD FROM CALENDARIO_METAS WHERE MES = " & intMesIni & " AND ANO = " & intAnoIni & " AND DIA = " & i
						set rsCuenta = Conn.execute(strSql)
						If not rsCuenta.eof Then
							intCantidad = rsCuenta("CANTIDAD")
							If intCantidad = 0 Then
							intTotal=intTotal+intHonorariosT

							%>
							<td align="RIGHT">
							<!--A HREF="informe_metas_detalle.asp?intTipoGestion=P&intDia=<%=i%>&intMes=<%=intMesIni%>&intAno=<%=intAnoIni%>&intEjecutivo=<%=intCodEjecutivo%>&strCliente=<%=cliente%>"-->
							<%=intHonorariosT%>
							<!--/A-->
							</td>
							<%


							End if

						End If


					Next%>
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
				intTotalT=0
				AbrirScg()
				For i = intDiaIni to intDiaFin
					intCantidadT=0
					intHonorariosMT=0
					intCantidad=0

					strSql = "SELECT SUM(CAST(VALORCUOTA AS INT) * 0.09) AS PAGADOMANDANTE"
					strSql = strSql & " FROM CUOTA WHERE ESTADO_DEUDA = 3 "
					strSql = strSql & " AND MONTH(FECHA_ESTADO) = " & intMesIni & " AND YEAR(FECHA_ESTADO) = " & intAnoIni & " AND DAY(FECHA_ESTADO) = " & i

					''Response.write "<br>" & strSql

					set rsPagoMand = Conn.execute(strSql)
					If not rsPagoMand.eof Then
						 intHonorariosMT = Round(ValNulo(rsPagoMand("PAGADOMANDANTE"),"N"),0)
					Else
						 intHonorariosMT = 0
					End If

					'Response.write "<br>intHonorariosMT=" & intHonorariosMT


					strSql = "SELECT SUM(CAST(MONTO_CAPITAL AS INT)) AS MONTO_CAPITAL, ISNULL(SUM(CAST(MONTO_EMP AS INT)),0) AS CANTIDAD,"
					strSql = strSql & " SUM(CAST(INTERES_PLAZO AS INT)) AS INTERES,	SUM(CAST(INDEM_COMP AS INT)) AS INDEM_COMP, SUM(CAST(IC_INFORME AS INT)) AS IC_INFORME,"
					strSql = strSql & " SUM(CAST(GASTOSJUDICIALES AS INT)) AS GASTOSJUDICIALES"
					strSql = strSql & " FROM CAJA_WEB_EMP C "
					strSql = strSql & " WHERE MONTH(C.FECHA_PAGO) = " & intMesIni & " AND YEAR(C.FECHA_PAGO) = " & intAnoIni & " AND DAY(C.FECHA_PAGO) = " & i


					set rsCuenta = Conn.execute(strSql)
					If not rsCuenta.eof Then
						intCantidadT = rsCuenta("CANTIDAD") + ValNulo(rsCuenta("IC_INFORME"),"N")
					Else
						intCantidadT = 0
					End If

					intTotalTotal = intCantidadT + intHonorariosMT

					'Response.write "<br>intCantidadT=" & intCantidadT

					strSql = "SELECT IsNull(count(*),0) as CANTIDAD FROM CALENDARIO_METAS WHERE MES = " & intMesIni & " AND ANO = " & intAnoIni & " AND DIA = " & i
					set rsCuenta = Conn.execute(strSql)
					If not rsCuenta.eof Then
						intCantidad = rsCuenta("CANTIDAD")
						If intCantidad = 0 Then

						intTotalT=intTotalT + intTotalTotal
					'Response.write 	"<br>intTotalT=" & intTotalT
						%>
						<td align="RIGHT">
							<!--A HREF="informe_metas_detalle.asp?intTipoGestion=P&intDia=<%=i%>&intMes=<%=intMesIni%>&intAno=<%=intAnoIni%>&strCliente=<%=cliente%>"-->
								<%=intTotalTotal%>
							<!--/A-->
						</td>
						<%
						End if
					End If
				Next
				CerrarScg()
				%>
					<td align="RIGHT"><%=intTotalT%></td>
			</tr>
    </table>

	  </td>
  </tr>
</table>

</form>

<script language="JavaScript1.2">
function envia()	{
	//if (datos.CB_CLIENTE.value=='0'){
	//	alert('DEBE SELECCIONAR UN CLIENTE');
	//}else{
		datos.action='informe_metas.asp';
		datos.submit();
	//}
}

function excel(){
	if (datos.CB_CLIENTE.value=='0'){
		alert('DEBE SELECCIONAR UN CLIENTE');
	}else{
		datos.action='informe_metas_xls.asp';
		datos.submit();
	}
}
</script>
