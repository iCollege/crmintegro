	<% @LCID = 1034 %>
<!--#include file="sesion.asp"-->
<!--#include file="arch_utils.asp"-->
<!--#include file="asp/comunes/general/rutinasBooleano.inc"-->
<!--#include file="../lib/comunes/rutinas/funciones.inc" -->
<!--#include file="../lib/comunes/rutinas/rutinasFecha.inc" -->
<!--#include file="../lib/comunes/rutinas/funcionesBD.inc" -->
<!--#include file="lib.asp"-->

<script language="JavaScript">
function ventanaSecundaria (URL){
window.open(URL,"DETALLE","width=200, height=200, scrollbars=no, menubar=no, location=no, resizable=no")
}

</script>

<%
inicio= request.Form("inicio")
termino= request.Form("termino")

abrirscg()
	If Trim(inicio) = "" Then
		inicio = TraeFechaActual(Conn)
	End If

	If Trim(termino) = "" Then
		termino = TraeFechaActual(Conn)
	End If
cerrarscg()


cliente = request("cliente")
cliente=session("ses_codcli")
intCodUsuario = request("CB_COBRADOR")
If Trim(intCodUsuario) = "" Then intCodUsuario = session("session_idusuario")

%>
<title>MIS GESTIONES REALIZADAS</title>

<style type="text/css">
<!--
.Estilo37 {color: #FFFFFF}
-->
</style>
<form name="datos" method="post">
<table width="680" height="300" border="0">
  <tr>
    <td height="20" class="Estilo20"><img src="../lib/TITULO_MIS_GESTIONES.gif" width="740" height="22"></td>
  </tr>
  <tr>
    <td height="242" valign="top">
	<BR>
	<table width="100%" border="0">
      <tr bgcolor="#<%=session("COLTABBG")%>" class="Estilo13">
        <td>CLIENTE</td>
		<% If TraeSiNo(session("perfil_adm")) = "Si" or TraeSiNo(session("perfil_sup")) = "Si" Then %>
			<td>EJECUTIVO</td>
		<% End If%>

        <td>FECHA INICIO </td>
        <td bgcolor="#<%=session("COLTABBG")%>">FECHA TERMINO </td>
      </tr>
      <tr>
        <td>
		<select name="cliente">
			<%
			abrirscg()
			ssql="SELECT CODCLIENTE,RAZON_SOCIAL FROM CLIENTE WHERE CODCLIENTE = '" & cliente & "' ORDER BY RAZON_SOCIAL"
			set rsCLI= Conn.execute(ssql)
			if not rsCLI.eof then
				do until rsCLI.eof%>
			<option value="<%=rsCLI("CODCLIENTE")%>"<%if cint(cliente)=rsCLI("CODCLIENTE") then response.Write("Selected") End If%>><%=rsCLI("RAZON_SOCIAL")%></option>
			<%
				rsCLI.movenext
				loop
				end if
				rsCLI.close
				set rsCLI=nothing
				cerrarscg()
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

        <td><input name="inicio" type="text" id="inicio" value="<%=inicio%>" size="10" maxlength="10">
         <a href="javascript:showCal('Calendar7');"><img src="../lib/calendario.gif" border="0"></td>
        <td><input name="termino" type="text" id="termino" value="<%=termino%>" size="10" maxlength="10">
          <a href="javascript:showCal('Calendar6');"><img src="../lib/calendario.gif" border="0"></a>
		  &nbsp;&nbsp;&nbsp;<input type="button" name="Submit" value="Aceptar" onClick="envia();"></td>
      </tr>
    </table>

	<%
	IF not cliente="" then

	%>
	<table width="100%" border="1" bordercolor = "#<%=session("COLTABBG")%>" cellSpacing=0 cellPadding=2>
      <tr bgcolor="#<%=session("COLTABBG")%>" class="Estilo13">
        <td width="23%">CATEGORIA</td>
        <td width="31%">SUBCATEGORIA</td>
        <td width="36%">GESTION</td>
        <td width="10%" align="right">CANT.G</td>
        <td width="10%" align="right">CANT.UG</td>
        <td width="10%" align="right">MONTO ASOCIADO</td>
        <td width="10%" align="right">HONORARIOS ASOCIADOS</td>
      </tr>

    <%
	abrirscg()
		strSql="SELECT * FROM GESTIONES_TIPO_CATEGORIA"
		set rsGTC= Conn.execute(strSql)
		if not rsGTC.eof then
			Do until rsGTC.eof
				%>
				<tr>
				<td><%=rsGTC("CODCATEGORIA")%>.&nbsp&nbsp<%=rsGTC("DESCRIPCION")%></td>
				<%
				strSql="SELECT CODCATEGORIA,CODSUBCATEGORIA,DESCRIPCION FROM GESTIONES_TIPO_SUBCATEGORIA WHERE CODCATEGORIA = " & rsGTC("CODCATEGORIA")
				set rsGTSC= Conn.execute(strSql)
				if not rsGTSC.eof then
					Do until rsGTSC.eof
						intMontoAsociado = 0
						intHonAsociado=0
						intCant=0
						intCantUG=0
						%>
						<td><%=rsGTSC("CODCATEGORIA")%>. <%=rsGTSC("CODSUBCATEGORIA")%>&nbsp&nbsp<%=rsGTSC("DESCRIPCION")%></td>
						<%
							strSql="SELECT IsNull(CODCATEGORIA,0) as CODCATEGORIA, IsNull(CODSUBCATEGORIA,0) as CODSUBCATEGORIA, IsNull(CODGESTION,0) as CODGESTION , DESCRIPCION FROM GESTIONES_TIPO_GESTION WHERE CODCATEGORIA = " & rsGTSC("CODCATEGORIA") & " AND CODSUBCATEGORIA = " & rsGTSC("CODSUBCATEGORIA")
							set rsGTG= Conn.execute(strSql)
							if not rsGTG.eof then
								Do until rsGTG.eof

									If (TraeSiNo(session("perfil_adm"))="Si" or TraeSiNo(session("perfil_sup"))="Si") AND intCodUsuario = "T" Then
										intCant = TraeCantGestiones(Conn, inicio, termino, rsGTG("CODCATEGORIA"), rsGTG("CODSUBCATEGORIA"), rsGTG("CODGESTION"), cliente)
										intCantUG = TraeCantGestionesUG2(Conn, inicio, termino, rsGTG("CODCATEGORIA"), rsGTG("CODSUBCATEGORIA"), rsGTG("CODGESTION"), cliente)
										intMontoAsociado = TraeSaldoGestiones(Conn, inicio, termino, rsGTG("CODCATEGORIA"), rsGTG("CODSUBCATEGORIA"), rsGTG("CODGESTION"), cliente)
										intMontoAsociadoUG = TraeSaldoGestiones(Conn, inicio, termino, rsGTG("CODCATEGORIA"), rsGTG("CODSUBCATEGORIA"), rsGTG("CODGESTION"), cliente)
									Else
										intCant = TraeCantGestionesUsuario(Conn, inicio, termino, rsGTG("CODCATEGORIA"), rsGTG("CODSUBCATEGORIA"), rsGTG("CODGESTION"), cliente, intCodUsuario)
										intCantUG = TraeCantGestionesUsuario(Conn, inicio, termino, rsGTG("CODCATEGORIA"), rsGTG("CODSUBCATEGORIA"), rsGTG("CODGESTION"), cliente, intCodUsuario)
										intMontoAsociado = TraeCantGestionesUsuario(Conn, inicio, termino, rsGTG("CODCATEGORIA"), rsGTG("CODSUBCATEGORIA"), rsGTG("CODGESTION"), cliente, intCodUsuario)
										intMontoAsociadoUG = TraeCantGestionesUsuario(Conn, inicio, termino, rsGTG("CODCATEGORIA"), rsGTG("CODSUBCATEGORIA"), rsGTG("CODGESTION"), cliente, intCodUsuario)
									End if
									intTotalGestiones = intTotalGestiones + intCant
									intTotalGestionesUG = intTotalGestionesUG + intCantUG
									intTotalMontoAsociado = intTotalMontoAsociado + ValNulo(intMontoAsociado,"N")
									intTotalMontoAsociadoUG = intTotalMontoAsociadoUG + ValNulo(intMontoAsociadoUG,"N")

									If intMontoAsociado > 0 Then
										intHonAsociado= intMontoAsociado*(9/100) + 1290 + 980
									Else
										intHonAsociado= 0
									End If

									intTotalHonAsociado = intTotalHonAsociado + ValNulo(intHonAsociado,"N")
									%>
									<td><%=rsGTG("CODCATEGORIA")%>.<%=rsGTG("CODSUBCATEGORIA")%>.<%=rsGTG("CODGESTION")%>&nbsp&nbsp<%=rsGTG("DESCRIPCION")%></td>

									<td align="right">
										<A HREF="mis_gestiones_detalle.asp?GESTION=<%=rsGTSC("CODCATEGORIA") & "-" & rsGTSC("CODSUBCATEGORIA") & "-" & rsGTG("CODGESTION")%>&txt_FechaIni=<%=inicio%>&txt_FechaFin=<%=termino%>&cmb_cliente=<%=cliente%>">
											<%=intCant%>
										</A>
									</td>
									<td align="right">
										<A HREF="mis_gestiones_detalleUG.asp?GESTION=<%=rsGTSC("CODCATEGORIA") & "-" & rsGTSC("CODSUBCATEGORIA") & "-" & rsGTG("CODGESTION")%>&txt_FechaIni=<%=inicio%>&txt_FechaFin=<%=termino%>&cmb_cliente=<%=cliente%>">
											<%=intCantUG%>
										</A>
									</td>
									<td align="right"><%=FN(intMontoAsociado,0)%></td>
									<td align="right"><%=FN(intHonAsociado,0)%></td>
									</tr>
									<%

									rsGTG.movenext
									If not rsGTG.eof then
									%>
									<tr>
									<td>&nbsp</td>
									<td>&nbsp</td>
									<%
									''rsGTG.moveprevious
									End if
									''rsGTG.movenext
								Loop
							Else


								If (TraeSiNo(session("perfil_adm"))="Si" or TraeSiNo(session("perfil_sup"))="Si") AND intCodUsuario = "T" Then
									intCant = TraeCantGestiones(Conn, inicio, termino, rsGTSC("CODCATEGORIA"), rsGTSC("CODSUBCATEGORIA"), 0, cliente)
									intCantUG = TraeCantGestiones(Conn, inicio, termino, rsGTSC("CODCATEGORIA"), rsGTSC("CODSUBCATEGORIA"), 0, cliente)
									intMontoAsociado = TraeSaldoGestiones(Conn, inicio, termino, rsGTSC("CODCATEGORIA"), rsGTSC("CODSUBCATEGORIA"), 0, cliente)
									intMontoAsociadoUG = TraeSaldoGestiones(Conn, inicio, termino, rsGTSC("CODCATEGORIA"), rsGTSC("CODSUBCATEGORIA"), 0, cliente)
								Else
									intCant = TraeCantGestionesUsuario(Conn, inicio, termino, rsGTSC("CODCATEGORIA"), rsGTSC("CODSUBCATEGORIA"), 0, cliente,intCodUsuario)
									intCantUG = TraeCantGestionesUsuario(Conn, inicio, termino, rsGTSC("CODCATEGORIA"), rsGTSC("CODSUBCATEGORIA"), 0, cliente,intCodUsuario)
									intMontoAsociado = TraeCantGestionesUsuario(Conn, inicio, termino, rsGTSC("CODCATEGORIA"), rsGTSC("CODSUBCATEGORIA"), 0, cliente, intCodUsuario)
									intMontoAsociadoUG = TraeCantGestionesUsuario(Conn, inicio, termino, rsGTSC("CODCATEGORIA"), rsGTSC("CODSUBCATEGORIA"), 0, cliente, intCodUsuario)
								End If

								intTotalGestiones = intTotalGestiones + intCant
								intTotalGestionesUG = intTotalGestionesUG + intCantUG
								intTotalMontoAsociado = intTotalMontoAsociado + ValNulo(intMontoAsociado,"N")
								intTotalMontoAsociadoUG = intTotalMontoAsociadoUG + ValNulo(intMontoAsociadoUG,"N")

								If intMontoAsociado > 0 Then
									intHonAsociado= intMontoAsociado*(9/100) + 1290 + 980
								Else
									intHonAsociado= 0
								End If

								intTotalHonAsociado = intTotalHonAsociado + ValNulo(intHonAsociado,"N")
								%>
								<td>&nbsp</td>
								<td align="right">
									<A HREF="mis_gestiones_detalle.asp?GESTION=<%=rsGTSC("CODCATEGORIA") & "-" & rsGTSC("CODSUBCATEGORIA") & "-" & "0"%>&txt_FechaIni=<%=inicio%>&txt_FechaFin=<%=termino%>&cmb_cliente=<%=cliente%>">
									<%=intCant%>
									</A>
								</td>
								<td align="right">
									<A HREF="mis_gestiones_detalleUG.asp?GESTION=<%=rsGTSC("CODCATEGORIA") & "-" & rsGTSC("CODSUBCATEGORIA") & "-" & "0"%>&txt_FechaIni=<%=inicio%>&txt_FechaFin=<%=termino%>&cmb_cliente=<%=cliente%>">
									<%=intCantUG%>
									</A>
								</td>
								<td align="right"><%=FN(intMontoAsociado,0)%></td>
								<td align="right"><%=FN(intHonAsociado,0)%></td>
								<%
							End If
							rsGTG.close
							set rsGTG=nothing
							rsGTSC.movenext
						%>
						</tr>
						<tr>
						<td>&nbsp</td>
						<%
						If rsGTSC.Eof Then
						%>
						<td>&nbsp</td>
						<td>&nbsp</td>
						<td>&nbsp</td>
						<%
						End If


					Loop
				Else
					%>
					<td>&nbsp</td>
					<td>&nbsp</td>
					<%
				End If
				rsGTSC.close
				set rsGSTC=nothing
				%>
				<%
				rsGTC.movenext
			loop
		Else
			%>
			<td>&nbsp</td>
			<td>&nbsp</td>
			<td>&nbsp</td>
			<td>&nbsp</td>
			</tr>
			<%
		End If
		rsGTC.close
		set rsGTC=nothing



	%>

      <tr bgcolor="#<%=session("COLTABBG")%>">
        <td>&nbsp</td>
        <td>&nbsp</td>
        <td><span class="Estilo37">TOTAL DE GESTIONES REALIZADAS</span></td>
        <td align="right" class="Estilo37"><%=FN(intTotalGestiones,0)%></td>
        <td align="right" class="Estilo37"><%=FN(intTotalGestionesUG,0)%></td>
        <td align="right" class="Estilo37"><%=FN(intTotalMontoAsociado,0)%></td>
        <td align="right" class="Estilo37"><%=FN(intTotalHonAsociado,0)%></td>

      </tr>
    </table>
	<% end if %>
	  </td>
  </tr>
</table>


<%If TraeSiNo(session("perfil_adm"))="Si" or TraeSiNo(session("perfil_sup"))="Si" Then%>
<br>
<table width="680" border="1" bordercolor = "#<%=session("COLTABBG")%>" cellSpacing=0 cellPadding=2>
  <tr bgcolor="#<%=session("COLTABBG")%>" class="Estilo13">
    <td colspan=4>RESUMEN COMPROMISOS DE PAGO</td>
  </tr>
   <tr bgcolor="#<%=session("COLTABBG")%>" class="Estilo13">
        <td>Ejecutivo</td>
        <td>Cantidad</td>
        <td>Monto Estimado</td>
        <td>Honorarios Estimado (9%)</td>
  </tr>
<%

	abrirscg()
	strSql="SELECT DISTINCT IDUSUARIO, LOGIN, COUNT(*) AS CANTIDAD FROM GESTIONES G, USUARIO U WHERE G.IDUSUARIO = U.ID_USUARIO AND G.CODCLIENTE = '" & Trim(cliente) & "' and G.fechaingreso >= '" & inicio & "' and G.fechaingreso <= '" & termino & "' AND  G.CODCATEGORIA = 2 AND G.CODSUBCATEGORIA= 2 AND G.CODGESTION =1 GROUP BY LOGIN, IDUSUARIO"
	set rsCP= Conn.execute(strSql)
	if not rsCP.eof then
		Do until rsCP.eof
			strEjecutivo = UCASE(rsCP("LOGIN"))
			intCodEjecutivo = UCASE(rsCP("IDUSUARIO"))
			intCantidad = rsCP("CANTIDAD")

			intMontoEjec = TraeSaldoGestionesUsuario(Conn, inicio, termino, 2, 2, 1, cliente, rsCP("IDUSUARIO"))
			intMontoHonEjec = intMontoEjec*(9/100) + 1290 + 980

			intTotCantidad = intTotCantidad + intCantidad
			intTotMontoEjec = intTotMontoEjec + intMontoEjec
			intTotMontoHonEjec = intTotMontoHonEjec + intMontoHonEjec
	%>
  <tr>
	  <td><%=strEjecutivo%></td>
	  <td align="right">
		<A HREF="mis_gestiones_detalle.asp?GESTION=2-2-1&txt_FechaIni=<%=inicio%>&txt_FechaFin=<%=termino%>&cmb_cliente=<%=cliente%>&intCodEjecutivo=<%=intCodEjecutivo%>">
			<%=FN(intCantidad,0)%>
		</A>
	  </td>
	  <td align="right"><%=FN(intMontoEjec,0)%></td>
	  <td align="right"><%=FN(intMontoHonEjec,0)%></td>
  </tr>
<%
	rsCP.movenext
	Loop
	cerrarscg()
%>

  <tr>
	  <td>Totales</td>
	  <td align="right">
		<A HREF="mis_gestiones_detalle.asp?GESTION=2-2-1&txt_FechaIni=<%=inicio%>&txt_FechaFin=<%=termino%>&cmb_cliente=<%=cliente%>">
			<%=FN(intTotCantidad,0)%>
		</A>

	  </td>
	  <td align="right"><%=FN(intTotMontoEjec,0)%></td>
	  <td align="right"><%=FN(intTotMontoHonEjec,0)%></td>
  </tr>
</table>

	<%End if%>

<%End if%>
</form>

<script language="JavaScript1.2">
function envia(){
if (datos.cliente.value=='0'){
alert('DEBE SELECCIONAR UN CLIENTE');
}else if(datos.inicio.value==''){
alert('DEBE SELECCIONAR FECHA DE INICIO');
}else if(datos.termino.value==''){
alert('DEBES SELECCIONAR FECHA DE TERMINO');
}else{
datos.action='mis_gestiones.asp';
datos.submit();
}
}

function excel(){
if (datos.cliente.value=='0'){
alert('DEBE SELECCIONAR UN CLIENTE');
}else if(datos.inicio.value==''){
alert('DEBE SELECCIONAR FECHA DE INICIO');
}else if(datos.termino.value==''){
alert('DEBES SELECCIONAR FECHA DE TERMINO');
}else{
datos.action='mis_gestiones_xls.asp';
datos.submit();
}
}
</script>
