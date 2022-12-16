<% @LCID = 1034 %>
<!--#include file="arch_utils.asp"-->
<!--#include file="../lib/comunes/rutinas/funciones.inc" -->
<!--#include file="../lib/comunes/rutinas/rutinasFecha.inc" -->
<!--#include file="lib.asp"-->
<!--#include file="asp/comunes/general/rutinasBooleano.inc"-->

<script language="JavaScript">
function ventanaSecundaria (URL){
	window.open(URL,"DETALLE","width=200, height=200, scrollbars=no, menubar=no, location=no, resizable=no")
}

</script>

<%
inicio= request("inicio")
termino= request("termino")

abrirscg()
	If Trim(inicio) = "" Then
		inicio = TraeFechaActual(Conn)
		inicio = "01/" & Mid(TraeFechaActual(Conn),4,10)
	End If

	If Trim(termino) = "" Then
		termino = TraeFechaActual(Conn)
	End If
cerrarscg()

intCliente = request("CB_CLIENTE")
intCliente=session("ses_codcli")
intOrigen = request("CB_ORIGEN")
intCodRemesa = request("CB_REMESA")
intCodUsuario = request("CB_COBRADOR")






If Trim(intCodUsuario) = "" Then intCodUsuario = session("session_idusuario")

''Response.write "intCliente=" & intCliente

If Trim(intCliente) = "" Then intCliente = "1000"
%>
<title>INFORME SCORING CARTERA</title>

<style type="text/css">
<!--
.Estilo37 {color: #FFFFFF}
-->
</style>

<table width="800" align="CENTER" border="0">
  <tr>
    <td height="20" class="Estilo20"><img src="../lib/TITULO_MIS_RECUPERO.gif" width="740" height="22"></td>
  </tr>
  <tr>
    <td valign="top" background="../images/fondo_coventa.jpg">
	<BR>
	<form name="datos" method="post">
	<table width="100%" border="0">
		<tr bgcolor="#<%=session("COLTABBG")%>" class="Estilo13">
			<td width="18%">MANDANTE</td>
			<td width="18%">ASIGNACION</td>
			<% If TraeSiNo(session("perfil_adm")) = "Si" or TraeSiNo(session("perfil_sup")) = "Si" Then %>
			<td width="18%">EJECUTIVO</td>
			<% End If%>
			<td width="18%">F.INICIO</td>
			<td width="18%">F.TERMINO</td>
			<td width="10%">&nbsp</td>
		</tr>
		<tr>
			<td>
			<select name="CB_CLIENTE" onChange="refrescar();">
				<%
				abrirscg()
				ssql="SELECT CODCLIENTE,DESCRIPCION FROM CLIENTE WHERE CODCLIENTE = '" & intCliente & "'"
				set rsCLI= Conn.execute(ssql)
				if not rsCLI.eof then
					Do until rsCLI.eof%>
					<option value="<%=rsCLI("CODCLIENTE")%>" <%if Trim(intCliente)=rsCLI("CODCLIENTE") then response.Write("Selected") End If%>><%=rsCLI("descripcion")%></option>
				<%
					rsCLI.movenext
					Loop
					end if
					rsCLI.close
					set rsCLI=nothing
					cerrarscg()
				%>
			</select>
			</td>
			<td>
				<select name="CB_REMESA">
					<option value="T">TODAS</option>
					<%
					AbrirSCG()
						strSql="SELECT * FROM REMESA WHERE CODREMESA >= 100 and codcliente = '" & intCliente & "'"
						set rsRemesa=Conn.execute(strSql)
						Do While not rsRemesa.eof
						If Trim(intCodRemesa)=Trim(rsRemesa("CODREMESA")) Then strSelRem = "SELECTED" Else strSelRem = ""
						%>
						<option value="<%=rsRemesa("CODREMESA")%>" <%=strSelRem%>> <%=rsRemesa("CODREMESA") & " - " & rsRemesa("FECHA_ASIGNACION")%></option>
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
			<% If TraeSiNo(session("perfil_adm")) = "Si" or TraeSiNo(session("perfil_sup")) = "Si" Then %>
				<td>
					<select name="CB_COBRADOR">
						<option value="T">TODOS</option>
						<%
						abrirscg()
						ssql="SELECT ID_USUARIO,LOGIN FROM USUARIO WHERE PERFIL_COB = 1"
						set rsTemp= Conn.execute(ssql)
						if not rsTemp.eof then
							do until rsTemp.eof%>
							<option value="<%=rsTemp("ID_USUARIO")%>"<%if Trim(intCodUsuario)=Trim(rsTemp("ID_USUARIO")) then response.Write("Selected") End If%>><%=rsTemp("LOGIN")%></option>
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
			<% End If%>
			<td>
				<input name="inicio" type="text" id="inicio" value="<%=inicio%>" size="10" maxlength="10">
			 	<a href="javascript:showCal('Calendar7');"><img src="../lib/calendario.gif" border="0">
			 </td>
			<td>
				<input name="termino" type="text" id="termino" value="<%=termino%>" size="10" maxlength="10">
				<a href="javascript:showCal('Calendar6');"><img src="../lib/calendario.gif" border="0"></a>
			 </td>
			<td>
				<input type="button" name="Submit" value="Aceptar" onClick="envia();">
			</td>
		</tr>
		<tr>
			<td colspan"6">Origen Pago :

			<%
				If Trim(intOrigen) = "T" Then strSelTodos = "SELECTED"
				If Trim(intOrigen) = "E" Then strSelEmpresa = "SELECTED"
				If Trim(intOrigen) = "M" Then strSelMandante = "SELECTED"
			%>
				<select name="CB_ORIGEN">
					<option value="T" <%=strSelTodos%>>TODOS</option>
					<option value="E" <%=strSelEmpresa%>>EMPRESA</option>
					<option value="M" <%=strSelMandante%>>MANDANTE</option>
				</select>
			</td>
		</tr>
    </table>
</form>

<table width="100%" border="0">

	<tr bgcolor="#<%=session("COLTABBG")%>">
		<td width="8%"><span class="Estilo37">DIAS GESTION</span></td>
		<td width="12%"><span class="Estilo37 Estilo37">ASIGNACION (mm$)</span></td>
		<td width="10%"><span class="Estilo37">CASOS ASIGNADOS</span></td>
		<td width="12%"><span class="Estilo37">MONTO RECUP</span></td>
		<td width="10%"><span class="Estilo37">CASOS RECUP</span></td>
		<td width="12%"><span class="Estilo37">META MONTO</span></td>
		<td width="12%"><span class="Estilo37">META CASOS</span></td>
		<td width="12%"><span class="Estilo37">% RECUP. CUANTIA</span></td>
		<td width="12%"><span class="Estilo37">% RECUP. CASOS</span></td>
	</tr>

    <%

		If Trim(intCliente) <> "" and Trim(intCodRemesa) <> "" then
		abrirscg()

		If Trim(intCodRemesa) = "T" Then
			intDiasGestion = 0
		Else
			strSql="SELECT IsNull(datediff(d,FECHA_CARGA,getdate()),0) as DIAS FROM REMESA WHERE CODREMESA = " & intCodRemesa
			set rsTemp=Conn.execute(strSql)
			if not rsTemp.eof then
				intDiasGestion = rsTemp("DIAS")
			else
				intDiasGestion = 1
			End if
			rsTemp.close
			set rsTemp=nothing
		End if


		strSql = "SELECT COUNT(DISTINCT(RUTDEUDOR)) as RUT, IsNull(COUNT(NRODOC),0) as FOLIO, IsNull(SUM(VALORCUOTA),0) as MONTO FROM CUOTA WHERE CODCLIENTE = '" & intCliente & "'"

		If Trim(intCodRemesa) <> "T" Then
			strSql = strSql & " AND CODREMESA = " & intCodRemesa
		End If
		strSql = strSql & " AND RUTDEUDOR IN ("
		strSql = strSql & " SELECT DISTINCT(RUTDEUDOR) FROM CUOTA WHERE CODCLIENTE = '" & intCliente & "'"

		If Trim(intCodRemesa) <> "T" Then
			strSql = strSql & " AND CODREMESA = " & intCodRemesa
		End If

		strSql = strSql & " AND ESTADO_DEUDA IN "


		If Trim(intOrigen) = "T" Then
			strSql = strSql & " (3,4)"
		End if
		If Trim(intOrigen) = "M" Then
			strSql = strSql & " (3)"
		End if
		If Trim(intOrigen) = "E" Then
			strSql = strSql & " (4)"
		End if

		strSql = strSql & " GROUP BY RUTDEUDOR HAVING SUM(SALDO) = 0)"

		If Trim(intCodUsuario) <> "T" Then
			strSql = strSql & " AND USUARIO_ASIG = " & intCodUsuario
		End If
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

		strSql = "SELECT COUNT(DISTINCT(RUTDEUDOR)) as RUT, IsNull(COUNT(NRODOC),0) as FOLIO, IsNull(SUM(VALORCUOTA),0) as MONTO FROM CUOTA WHERE CODCLIENTE = '" & intCliente & "'"

		If Trim(intCodRemesa) <> "T" Then
			strSql = strSql & " AND CODREMESA = " & intCodRemesa
		End If


		strSql = strSql & " AND SALDO = 0 AND RUTDEUDOR NOT IN ("
		strSql = strSql & " SELECT DISTINCT(RUTDEUDOR) FROM CUOTA WHERE CODCLIENTE = '" & intCliente & "'"

		If Trim(intCodRemesa) <> "T" Then
			strSql = strSql & " AND CODREMESA = " & intCodRemesa
		End If

		strSql = strSql & " AND ESTADO_DEUDA IN "

		If Trim(intOrigen) = "T" Then
			strSql = strSql & " (3,4)"
		End if
		If Trim(intOrigen) = "M" Then
			strSql = strSql & " (3)"
		End if
		If Trim(intOrigen) = "E" Then
			strSql = strSql & " (4)"
		End if

		strSql = strSql & " GROUP BY RUTDEUDOR HAVING SUM(SALDO) = 0)"

		If Trim(intCodUsuario) <> "T" Then
			strSql = strSql & " AND USUARIO_ASIG = " & intCodUsuario
		End If
		''Response.write strSql

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

		strSql="SELECT IsNull(COUNT(DISTINCT RUTDEUDOR),0) AS CUANTOS, IsNull(SUM(SALDO),0) AS SUMA FROM CUOTA WHERE CODCLIENTE = '" & intCliente & "' AND IDGJUDICIAL IS NOT NULL AND ESTADO_DEUDA = '1'"

		If Trim(intCodRemesa) <> "T" Then
			strSql = strSql & " AND CODREMESA = " & intCodRemesa
		End If

		If Trim(intCodUsuario) <> "T" Then
			strSql = strSql & " AND USUARIO_ASIG = " & intCodUsuario
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

		intTotalPagos = intMontosConPagoTotal + intMontosConPagoParcial
		intTotalRuts = intRutConPagoTotal + intRutConPagoParcial

		If intTotalMontoProceso <> 0 Then
			intPorcPagos=intTotalPagos/intTotalMontoProceso
		Else
			intPorcPagos=0
		End If
		If intTotalProceso <> 0 Then
			intPorcRuts=intTotalRuts/intTotalProceso
		Else
			intPorcRuts=0
		End If




%>

<tr>
	<td ALIGN="RIGHT"><%=FN(intDiasGestion,0)%></td>
	<td ALIGN="RIGHT"><%=FN(intTotalMontoProceso,0)%></td>
	<td ALIGN="RIGHT"><%=FN(intTotalProceso,0)%></td>
	<td ALIGN="RIGHT"><%=FN(intTotalPagos,0)%></td>
	<td ALIGN="RIGHT"><%=FN(intTotalRuts,0)%></td>
	<td ALIGN="RIGHT"><%=FN(intMetaMonto,0)%></td>
	<td ALIGN="RIGHT"><%=FN(intMetaCasos,0)%></td>
	<td ALIGN="RIGHT"><%=FN((intPorcPagos)*100,2)%></td>
	<td ALIGN="RIGHT"><%=FN((intPorcRuts)*100,2)%></td>
</tr>
</table>
<table width="100%" border="0">
	<tr bgcolor="#<%=session("COLTABBG")%>">
		<td width="40%" COLSPAN="3"><span class="Estilo37">&nbsp;</span></td>
		<td width="14%"><span class="Estilo37">CASOS RECUP.(TOTAL)</span></td>
		<td width="14%"><span class="Estilo37">CASOS RECUP.(PARCIAL)</span></td>
		<td width="14%"><span class="Estilo37">MONTO RECUP.(TOTAL)</span></td>
		<td width="14%"><span class="Estilo37">MONTO RECUP.(PARCIAL)</span></td>
	</tr>


<tr>
	<td width="40%" COLSPAN="3">&nbsp;</td>
	<td ALIGN="RIGHT"><%=FN(intRutConPagoTotal,0)%></td>
	<td ALIGN="RIGHT"><%=FN(intRutConPagoParcial,0)%></td>
	<td ALIGN="RIGHT"><%=FN(intMontosConPagoTotal,0)%></td>
	<td ALIGN="RIGHT"><%=FN(intMontosConPagoParcial,0)%></td>
</tr>
</table>
<table width="100%" border="0">
  <tr bgcolor="#<%=session("COLTABBG")%>">
  		<td><span class="Estilo37">FECHA:</span></td>
  		<td><span class="Estilo37">CASOS</span></td>
  		<td><span class="Estilo37">MONTO</span></td>
  		<td><span class="Estilo37">DOCS</span></td>
  		<td><span class="Estilo37">ACUM CASOS</span></td>
  		<td><span class="Estilo37">ACUM MONTO</span></td>
  		<td><span class="Estilo37">ACUM DOCS</span></td>
  	</tr>
    <%

	strSql="SELECT IsNull(datediff(d,'" & inicio & "' , '" & termino & "'),0) + 1 as DIAS"

	intFecha = inicio
	set rsFechas=Conn.execute(strSql)
	If Not rsFechas.eof Then
		intDias = rsFechas("DIAS")
		For I = 1 To intDias

			strSql = "SELECT COUNT(DISTINCT(RUTDEUDOR)) as RUT, IsNull(COUNT(NRODOC),0) as FOLIO, IsNull(SUM(VALORCUOTA),0) as MONTO FROM CUOTA WHERE CODCLIENTE = '" & intCliente & "'"
			If Trim(intCodRemesa) <> "T" Then
				strSql = strSql & " AND CODREMESA = " & intCodRemesa
			End If
			strSql = strSql & " AND SALDO = 0 AND CONVERT(VARCHAR(10),FECHA_ESTADO,103) = '" & intFecha & "' AND ESTADO_DEUDA IN "

			If Trim(intOrigen) = "T" Then
				strSql = strSql & " (3,4)"
			End if
			If Trim(intOrigen) = "M" Then
				strSql = strSql & " (3)"
			End if
			If Trim(intOrigen) = "E" Then
				strSql = strSql & " (4)"
			End if
			If Trim(intCodUsuario) <> "T" Then
				strSql = strSql & " AND USUARIO_ASIG = " & intCodUsuario
			End If

			set rsTemp= Conn.execute(strSql)
			If not rsTemp.eof then
				intCasos = rsTemp("RUT")
				intDocs = rsTemp("FOLIO")
				intMonto = rsTemp("MONTO")
			Else
				intCasos = 0
				intDocs = 0
				intMonto = 0
			End if
			rsTemp.close
			set rsTemp=nothing

			intAcumCasos = intAcumCasos + intCasos
			intAcumDocs = intAcumDocs + intDocs
			intAcumMonto = intAcumMonto + intMonto

			If intCasos <> 0 Then
				intMuestraCasos = intAcumCasos
				intMuestraDocs = intAcumDocs
				intMuestraMonto = intAcumMonto
			Else
				intMuestraCasos = 0
				intMuestraDocs = 0
				intMuestraMonto = 0
			End if

		%>

		<tr>
			<TD WIDTH="14%" ALIGN="RIGHT">
				<A HREF="detalle_recuperacion.asp?intFecha=<%=intFecha%>&intCliente=<%=intCliente%>&intOrigen=<%=intOrigen%>&intCodRemesa=<%=intCodRemesa%>&intCodUsuario=<%=intCodUsuario%>">
					<%=intFecha%>
				</A>
			</td>
			<TD WIDTH="14%" ALIGN="RIGHT"><%=FN(intCasos,0)%></td>
			<TD WIDTH="14%" ALIGN="RIGHT"><%=FN(intMonto,0)%></td>
			<TD WIDTH="14%" ALIGN="RIGHT"><%=FN(intDocs,0)%></td>
			<TD WIDTH="14%" ALIGN="RIGHT"><%=FN(intMuestraCasos,0)%></td>
			<TD WIDTH="14%" ALIGN="RIGHT"><%=FN(intMuestraMonto,0)%></td>
			<TD WIDTH="14%" ALIGN="RIGHT"><%=FN(intMuestraDocs,0)%></td>
		</tr>
		<%

			strSql = "SELECT DATEADD(day, 1, '" & intFecha & "') AS fecha"
			set rsTemp = Conn.execute(strSql)
			If Not rsTemp.eof Then
				intFecha = rsTemp("fecha")
			End if
		Next
	End If
	rsFechas.close
	set rsFechas=nothing
	''Response.End
	%>

	  <tr bgcolor="#<%=session("COLTABBG")%>">
	  		<td ALIGN="RIGHT" bgcolor="#FFFFFF">
	  			<span class="Estilo37">
					<A HREF="detalle_recuperacion.asp?intFecha=&intCliente=<%=intCliente%>&intOrigen=<%=intOrigen%>&intCodRemesa=<%=intCodRemesa%>&intCodUsuario=<%=intCodUsuario%>">
						TOTALES
					</A>
	  			</span>
	  		</td>
	  		<td ALIGN="RIGHT"><span class="Estilo37"><%=FN(intAcumCasos,0)%></span></td>
			<td ALIGN="RIGHT"><span class="Estilo37"><%=FN(intAcumMonto,0)%></span></td>
	  		<td ALIGN="RIGHT"><span class="Estilo37"><%=FN(intAcumDocs,0)%></span></td>
	  		<td ALIGN="RIGHT"><span class="Estilo37"><%=FN(intAcumCasos,0)%></span></td>
	  		<td ALIGN="RIGHT"><span class="Estilo37"><%=FN(intAcumMonto,0)%></span></td>
	  		<td ALIGN="RIGHT"><span class="Estilo37"><%=FN(intAcumDocs,0)%></span></td>
  	</tr>

    <%	cerrarscg()
end if %>
</table>

<!--table width="720" align="CENTER" border="0">
  <tr>
    <td align="CENTER">
		<img src="../images/recupero1.jpg">
	</td>
    </tr>
</table-->


	  </td>
  </tr>
</table>






<script language="JavaScript1.2">
function envia(){
		if (datos.CB_CLIENTE.value=='0'){
			alert('DEBE SELECCIONAR UN CLIENTE');
		}else if(datos.inicio.value==''){
			alert('DEBE SELECCIONAR FECHA DE INICIO');
		}else if(datos.termino.value==''){
			alert('DEBES SELECCIONAR FECHA DE TERMINO');
		}else{
		//datos.action='cargando.asp';
		datos.action='informe_scoring.asp';
		datos.submit();
	}
}


function refrescar(){
		if (datos.CB_CLIENTE.value=='0'){
			alert('DEBE SELECCIONAR UN CLIENTE');
		}else
		{
		datos.action='informe_scoring.asp';
		datos.submit();
	}
}

</script>
