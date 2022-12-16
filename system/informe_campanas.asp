<% @LCID = 1034 %>
<!--#include file="arch_utils.asp"-->
<!--#include file="sesion.asp"-->
<!--#include file="../lib/comunes/rutinas/funciones.inc" -->
<!--#include file="../lib/comunes/rutinas/rutinasFecha.inc" -->
<!--#include file="../lib/comunes/rutinas/funcionesBD.inc" -->
<!--#include file="lib.asp"-->
<!--#include file="asp/comunes/general/rutinasBooleano.inc"-->

<script language="JavaScript">
function ventanaSecundaria (URL){
	window.open(URL,"DETALLE","width=200, height=200, scrollbars=no, menubar=no, location=no, resizable=no")
}

</script>
<link href="style.css" rel="stylesheet" type="text/css">

<%
dtmFecInicio= request("TX_FECINICIO")
dtmFecTermino= request("TX_FECTERMINO")
'Response.write "dtmFecInicio=" & dtmFecInicio
'Response.write "dtmFecTermino=" & dtmFecTermino
'Response.End

abrirscg()
	If Trim(dtmFecInicio) = "" Then
		dtmFecInicio = TraeFechaActual(Conn)
		dtmFecInicio = "01/" & Mid(TraeFechaActual(Conn),4,10)
	End If

	If Trim(dtmFecTermino) = "" Then
		dtmFecTermino = TraeFechaActual(Conn)
	End If
cerrarscg()

intCliente = request("CB_CLIENTE")
intCliente=session("ses_codcli")
intOrigen = request("CB_ORIGEN")
intCodRemesa = request("CB_REMESA")
intCodCampana = request("CB_CAMPANA")

If Trim(intCodUsuario) = "" Then intCodUsuario = session("session_idusuario")
''Response.write "intCliente=" & intCliente
If Trim(intCliente) = "" Then intCliente = "1000"

abrirscg()
If Trim(intCliente) <> "" and Trim(intCodCampana) <> "" Then
	strSql="SELECT COUNT(*) AS CANT FROM DEUDOR WHERE CODCLIENTE = '" & intCliente & "' AND IDCAMPANA = " & intCodCampana
	set rsCantC=Conn.execute(strSql)
	If Not rsCantC.eof Then
		intTotalCampana = rsCantC("CANT")
	Else
		intTotalCampana = 0
	End If
End If
cerrarscg()

%>
<title>INFORME CARTERA</title>

<style type="text/css">
<!--
.Estilo37 {color: #FFFFFF}
-->
</style>


<table width="100%" border="1" bordercolor="#FFFFFF">
	<tr>
		<TD height="20" ALIGN=LEFT class="pasos2_i">
			<B>INFORME RESULTADO DE CAMPAÑAS</B>
		</TD>
		<TD height="20">

		</TD>
	</tr>
</table>



<table width="800" border="1" bordercolor="#FFFFFF">
	<tr>
		<TD>
			<table width="800" align="LEFT" border="0">
			   <tr>
			    <td valign="top" background="../images/fondo_coventa.jpg">
				<BR>
				<FORM name="datos" method="post">
				<table width="100%" border="0">
					<tr bgcolor="#<%=session("COLTABBG")%>" class="Estilo13">
						<td width="20">MANDANTE</td>
						<td width="20%">CAMPAÑA</td>
						<td width="20%">FEC.INICIO</td>
						<td width="20%">FEC.TERMINO</td>
						<td width="20%">&nbsp</td>
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
							<select name="CB_CAMPANA">
								<option value="0">SELECCIONAR</option>
								<%
								AbrirSCG()
									If Trim(intCliente) <> "" Then
										strSql="SELECT * FROM CAMPANA WHERE CODCLIENTE = '" & intCliente & "'"
										'Response.write strSql
										set rsCampana=Conn.execute(strSql)
										Do While not rsCampana.eof
										If Trim(intCodCampana)=Trim(rsCampana("IDCAMPANA")) Then strSelRem = "SELECTED" Else strSelRem = ""
										%>
										<option value="<%=rsCampana("IDCAMPANA")%>" <%=strSelRem%>> <%=rsCampana("IDCAMPANA") & " - " & rsCampana("NOMBRE")%></option>
										<%
										rsCampana.movenext
										Loop
										rsCampana.close
										set rsCampana=nothing
									End if
								CerrarSCG()
								''Response.End
								%>
							</select>
						</td>
						<td><input name="TX_FECINICIO" type="text" value="<%=dtmFecInicio%>" size="10" maxlength="10">
						    <a href="javascript:showCal('Cal_TX_FECINICIO');"><img src="../lib/calendario.gif" border="0">
						</td>
						<td><input name="TX_FECTERMINO" type="text" value="<%=dtmFecTermino%>" size="10" maxlength="10">
          					<a href="javascript:showCal('Cal_TX_FECTERMINO');"><img src="../lib/calendario.gif" border="0"></a>
          				</td>
						<td>
							<input type="button" name="Submit" value="Aceptar" onClick="envia();">
						</td>
					</tr>
				</table>
			</form>

				  </td>
			  </tr>
			</table>


		</TD>
	</tr>
	<tr>
		<TD>
			<%If intCodCampana <> "" and intCodCampana <> "0" Then%>



				<table width="800" border="1" bordercolor = "#<%=session("COLTABBG")%>" cellSpacing=0 cellPadding=2>
			      <tr bgcolor="#<%=session("COLTABBG")%>" class="Estilo13">
			        <td width="23%">CATEGORIA</td>
			        <td width="31%">SUBCATEGORIA</td>
			        <td width="36%">GESTION</td>
			        <td width="10%" align="right">CANTIDAD</td>
			        <td width="10%" align="right">U.G.</td>
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
							strSql="SELECT * FROM GESTIONES_TIPO_SUBCATEGORIA WHERE CODCATEGORIA = " & rsGTC("CODCATEGORIA")
							set rsGTSC= Conn.execute(strSql)
							if not rsGTSC.eof then
								Do until rsGTSC.eof
									%>
									<td><%=rsGTSC("CODCATEGORIA")%>. <%=rsGTSC("CODSUBCATEGORIA")%>&nbsp&nbsp<%=rsGTSC("DESCRIPCION")%></td>
									<%
										strSql="SELECT IsNull(CODCATEGORIA,0) as CODCATEGORIA, IsNull(CODSUBCATEGORIA,0) as CODSUBCATEGORIA, IsNull(CODGESTION,0) as CODGESTION , DESCRIPCION FROM GESTIONES_TIPO_GESTION WHERE CODCATEGORIA = " & rsGTSC("CODCATEGORIA") & " AND CODSUBCATEGORIA = " & rsGTSC("CODSUBCATEGORIA")
										set rsGTG= Conn.execute(strSql)
										if not rsGTG.eof then
											Do until rsGTG.eof
												intCant = TraeCantGestionesCampana(Conn, intCodCampana, rsGTG("CODCATEGORIA"), rsGTG("CODSUBCATEGORIA"), rsGTG("CODGESTION"), intCliente, dtmFecInicio, dtmFecTermino)
												intCantUG = TraeCantGestionesCampanaUG(Conn, rsGTSC("CODCATEGORIA") & "-" & rsGTSC("CODSUBCATEGORIA") & "-" & rsGTG("CODGESTION"), intCliente, intCodCampana, dtmFecInicio, dtmFecTermino)
												intTotalGestiones = intTotalGestiones + intCant
												intTotalGestionesUG = intTotalGestionesUG + intCantUG
												%>
												<td><%=rsGTG("CODCATEGORIA")%>.<%=rsGTG("CODSUBCATEGORIA")%>.<%=rsGTG("CODGESTION")%>&nbsp&nbsp<%=rsGTG("DESCRIPCION")%></td>

												<td align="right">
												<A HREF="mis_gestiones_detalle.asp?GESTION=<%=rsGTSC("CODCATEGORIA") & "-" & rsGTSC("CODSUBCATEGORIA") & "-" & rsGTG("CODGESTION")%>&txt_FechaIni=<%=dtmFecInicio%>&txt_FechaFin=<%=dtmFecTermino%>&cmb_cliente=<%=intCliente%>&intCodCampana=<%=intCodCampana%>">
													<%=intCant%>
												</A>
												</td>
												<td align="right"><%=intCantUG%></td>
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
											intCant = TraeCantGestionesCampana(Conn, intCodCampana, rsGTSC("CODCATEGORIA"), rsGTSC("CODSUBCATEGORIA"), 0, intCliente, dtmFecInicio, dtmFecTermino)
											intCantUG = TraeCantGestionesCampanaUG(Conn, rsGTSC("CODCATEGORIA") & "-" & rsGTSC("CODSUBCATEGORIA") & "-" & "0", intCliente, intCodCampana, dtmFecInicio, dtmFecTermino)

											intTotalGestiones = intTotalGestiones + intCant
											intTotalGestionesUG = intTotalGestionesUG + intCantUG
											%>
											<td>&nbsp</td>
											<td align="right">
												<A HREF="mis_gestiones_detalle.asp?GESTION=<%=rsGTSC("CODCATEGORIA")& "-" &rsGTSC("CODSUBCATEGORIA")& "-" &"0"%>&txt_FechaIni=<%=dtmFecInicio%>&txt_FechaFin=<%=dtmFecTermino%>&cmb_cliente=<%=intCliente%>&intCodCampana=<%=intCodCampana%>">
												<%=intCant%>
												</A>
											</td>
											<td align="right"><%=intCantUG%></td>
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
									<td>&nbsp</td>
									<%
									End If


								Loop
							Else
								%>
								<td>&nbsp</td>
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
						<td>&nbsp</td>
						</tr>
						<%
					End If
					rsGTC.close
					set rsGTC=nothing
					cerrarscg()


					AbrirScg()
					strSql = "SELECT COUNT(*) AS CANT FROM GESTIONES WHERE CODCLIENTE = '" & intCliente & "' AND IDCAMPANA = " & intCodCampana & " AND FECHAINGRESO >= '" & dtmFecInicio & "' AND FECHAINGRESO <= '" & dtmFecTermino & "' AND cast(CODCATEGORIA as varchar(2)) + '-' + cast(CODSUBCATEGORIA  as varchar(2))+ '-' + cast(CODGESTION  as varchar(2)) IN ("
					strSql = strSql & " SELECT CAST(CODCATEGORIA AS VARCHAR(2)) + '-' + CAST(CODSUBCATEGORIA  AS VARCHAR(2))+ '-' + CAST(CODGESTION  AS VARCHAR(2)) FROM GESTIONES_TIPO_GESTION WHERE COMUNICA = 1)"

					'Response.write "strSql=" & strSql
					'Response.End

					set rsTemp = Conn.execute(strSql)
					If not rsTemp.eof then
						intCantComunica = rsTemp("CANT")
					Else
						intCantComunica = 0
					End If

					strSql = "SELECT COUNT(*) AS CANT FROM GESTIONES WHERE CODCLIENTE = '" & intCliente & "' AND IDCAMPANA = " & intCodCampana & " AND FECHAINGRESO >= '" & dtmFecInicio & "' AND FECHAINGRESO <= '" & dtmFecTermino & "' AND cast(CODCATEGORIA as varchar(2)) + '-' + cast(CODSUBCATEGORIA  as varchar(2))+ '-' + cast(CODGESTION  as varchar(2)) IN ("
					strSql = strSql & " SELECT CAST(CODCATEGORIA AS VARCHAR(2)) + '-' + CAST(CODSUBCATEGORIA  AS VARCHAR(2))+ '-' + CAST(CODGESTION  AS VARCHAR(2)) FROM GESTIONES_TIPO_GESTION WHERE COMUNICA = 0)"

					set rsTemp = Conn.execute(strSql)
					If not rsTemp.eof then
						intCantNoComunica = rsTemp("CANT")
					Else
						intCantNoComunica = 0
					End If


					CerrarScg()

					intGestTelefonicas = intCantComunica + intCantNoComunica

					'intPorcRecorridos

				If intTotalCampana <> 0 Then
					intPorcCasosRecorridos = intTotalGestionesUG/intTotalCampana*100
				Else
					intPorcCasosRecorridos = 0
				End If

				If intGestTelefonicas <> 0 Then
					intPorcContactados = intCantComunica/intGestTelefonicas*100
					intPorcNoContactados = intCantNoComunica/intGestTelefonicas*100
				Else
					intPorcContactados = 0
					intPorcNoContactados = 0
				End If
				%>

			      <tr>
			        <td COLSPAN=2>&nbsp</td>
			        <td><B>TOTAL DE GESTIONES REALIZADAS</B></td>
			        <td align="right" bgcolor="#FFFFFF">

			        <A HREF="mis_gestiones_detalle.asp?GESTION=&txt_FechaIni=<%=dtmFecInicio%>&txt_FechaFin=<%=dtmFecTermino%>&cmb_cliente=<%=intCliente%>&intCodCampana=<%=intCodCampana%>">
						<%=intTotalGestiones%>
					</A>
			        </td>
			        <td align="right" bgcolor="#FFFFFF">&nbsp;</td>
			      </tr>

				   <tr bgcolor="#<%=session("COLTABBG")%>">
						<td>&nbsp</td>
						<td>&nbsp</td>
						<td><span class="Estilo37">TOTAL CASOS CAMPAÑA</span></td>
						<td align="right" class="Estilo37">&nbsp;</td>
						<td align="right" class="Estilo37" bgcolor="#FFFFFF">
						<A HREF="cartera_asignada.asp?CB_CAMPANA=<%=intCodCampana%>">
								<%=FN(intTotalCampana,0)%>
						</A>
						</td>
				  </tr>

			      <tr bgcolor="#<%=session("COLTABBG")%>">
					<td>&nbsp</td>
					<td>&nbsp</td>
					<td><span class="Estilo37">TOTAL CASOS RECORRIDO</span></td>
					<td align="right" class="Estilo37"><%=intTotalGestionesUG%></td>
					<td align="right" class="Estilo37"><%=Round(intPorcCasosRecorridos,1)%>%</td>
			      </tr>

			      <tr bgcolor="#<%=session("COLTABBG")%>">
					<td>&nbsp</td>
					<td>&nbsp</td>
					<td><span class="Estilo37">CONTACTADOS</span></td>
					<td align="right" class="Estilo37"><%=intCantComunica%></td>
					<td align="right" class="Estilo37"><%=Round(intPorcContactados,1)%>%</td>
			      </tr>

			      <tr bgcolor="#<%=session("COLTABBG")%>">
					<td>&nbsp</td>
					<td>&nbsp</td>
					<td><span class="Estilo37">NO CONTACTADOS</span></td>
					<td align="right" class="Estilo37"><%=intCantNoComunica%></td>
					<td align="right" class="Estilo37"><%=Round(intPorcNoContactados,1)%>%</td>
			      </tr>
			      <tr bgcolor="#<%=session("COLTABBG")%>">
					<td>&nbsp</td>
					<td>&nbsp</td>
					<td><span class="Estilo37">TOTAL GESTIONES TELEFONICAS</span></td>
					<td align="right" class="Estilo37"><%=intGestTelefonicas%></td>
					<td align="right" class="Estilo37">&nbsp;</td>
			      </tr>




			    </table>
				<% end if %>




		</TD>
	</tr>
</table>



<%If (TraeSiNo(session("perfil_adm"))="Si" or TraeSiNo(session("perfil_sup"))="Si") and (Trim(intCliente) <> "" and Trim(intCodCampana) <> "") Then%>
<%If intCodCampana <> "" and intCodCampana <> "0" Then%>
<br>
<table width="680" border="1" bordercolor = "#<%=session("COLTABBG")%>" cellSpacing=0 cellPadding=2>
  <tr bgcolor="#<%=session("COLTABBG")%>" class="Estilo13">
    <td colspan=9>RESUMEN GESTIONES Y COMPROMISOS DE PAGO</td>
  </tr>
   <tr bgcolor="#<%=session("COLTABBG")%>" class="Estilo13">
        <td>Ejecutivo</td>
        <td>Cantidad Gestiones</td>
        <td>Cantidad Comp.Pago</td>
        <td>Cantidad Contactados</td>
        <td>Porcentaje Contactados</td>
        <td>Cantidad No Contactados</td>
        <td>Porcentaje No Contactados</td>
        <td>Monto Estimado Comp.Pago</td>
        <td>Honorarios Estimado (9%) Comp.Pago</td>
  </tr>
<%

	abrirscg()
	'strSql="SELECT DISTINCT IDUSUARIO, LOGIN, COUNT(*) AS CANTIDAD FROM GESTIONES G, USUARIO U WHERE G.IDUSUARIO = U.ID_USUARIO AND G.CODCLIENTE = '" & Trim(intCliente) & "' AND G.FECHAINGRESO >= '" & dtmFecInicio & "' AND G.FECHAINGRESO <= '" & dtmFecTermino & "' AND  G.CODCATEGORIA = 2 AND G.CODSUBCATEGORIA = 2 AND G.CODGESTION = 1 AND G.IDCAMPANA = " & intCodCampana & " GROUP BY LOGIN, IDUSUARIO"
	strSql="SELECT DISTINCT IDUSUARIO, LOGIN, COUNT(*) AS CANTIDAD FROM GESTIONES G, USUARIO U WHERE G.IDUSUARIO = U.ID_USUARIO AND G.CODCLIENTE = '" & Trim(intCliente) & "' AND G.IDCAMPANA = " & intCodCampana & " AND G.FECHAINGRESO >= '" & dtmFecInicio & "' AND G.FECHAINGRESO <= '" & dtmFecTermino & "' GROUP BY LOGIN, IDUSUARIO"
	'Response.write strSql
	'Response.End
	set rsCP= Conn.execute(strSql)
	if not rsCP.eof then
		Do until rsCP.eof
			strEjecutivo = UCASE(rsCP("LOGIN"))
			intCodEjecutivo = UCASE(rsCP("IDUSUARIO"))
			intCantidad = rsCP("CANTIDAD")
			intMontoEjec = TraeSaldoGestionesUsuarioCampana(Conn, 2, 2, 1, intCliente, rsCP("IDUSUARIO"), intCodCampana, dtmFecInicio, dtmFecTermino)
			intMontoHonEjec = intMontoEjec*(9/100) + 1290 + 980

			intTotCantidadCP = intTotCantidadCP + intCantidadCP
			intTotCantidad = intTotCantidad + intCantidad
			intTotMontoEjec = intTotMontoEjec + intMontoEjec
			intTotMontoHonEjec = intTotMontoHonEjec + intMontoHonEjec

			strSql="SELECT COUNT(*) AS CANTIDAD FROM GESTIONES WHERE IDUSUARIO = " & intCodEjecutivo & " AND CODCLIENTE = '" & Trim(intCliente) & "' AND CODCATEGORIA = 2 AND CODSUBCATEGORIA = 2 AND CODGESTION = 1 AND IDCAMPANA = " & intCodCampana & " AND FECHAINGRESO >= '" & dtmFecInicio & "' AND FECHAINGRESO <= '" & dtmFecTermino & "'"
			set rsCompPago= Conn.execute(strSql)
			if not rsCompPago.eof then
				intCantidadCP = rsCompPago("CANTIDAD")
			Else
				intCantidadCP = 0
			End if


			strSql="SELECT COUNT(*) AS CANTIDAD FROM GESTIONES WHERE IDUSUARIO = " & intCodEjecutivo & " AND CODCLIENTE = '" & Trim(intCliente) & "' AND IDCAMPANA = " & intCodCampana & " AND FECHAINGRESO >= '" & dtmFecInicio & "' AND FECHAINGRESO <= '" & dtmFecTermino & "' AND cast(CODCATEGORIA as varchar(2)) + '-' + cast(CODSUBCATEGORIA  as varchar(2))+ '-' + cast(CODGESTION  as varchar(2)) IN ("
			strSql = strSql & " SELECT CAST(CODCATEGORIA AS VARCHAR(2)) + '-' + CAST(CODSUBCATEGORIA  AS VARCHAR(2))+ '-' + CAST(CODGESTION  AS VARCHAR(2)) FROM GESTIONES_TIPO_GESTION WHERE COMUNICA = 1)"
			set rsCompPago= Conn.execute(strSql)
			if not rsCompPago.eof then
				intContactadosEje = rsCompPago("CANTIDAD")
			Else
				intContactadosEje = 0
			End if

			strSql="SELECT COUNT(*) AS CANTIDAD FROM GESTIONES WHERE IDUSUARIO = " & intCodEjecutivo & " AND CODCLIENTE = '" & Trim(intCliente) & "' AND IDCAMPANA = " & intCodCampana & " AND FECHAINGRESO >= '" & dtmFecInicio & "' AND FECHAINGRESO <= '" & dtmFecTermino & "' AND cast(CODCATEGORIA as varchar(2)) + '-' + cast(CODSUBCATEGORIA  as varchar(2))+ '-' + cast(CODGESTION  as varchar(2)) IN ("
			strSql = strSql & " SELECT CAST(CODCATEGORIA AS VARCHAR(2)) + '-' + CAST(CODSUBCATEGORIA  AS VARCHAR(2))+ '-' + CAST(CODGESTION  AS VARCHAR(2)) FROM GESTIONES_TIPO_GESTION WHERE COMUNICA = 0)"
			set rsCompPago= Conn.execute(strSql)
			if not rsCompPago.eof then
				intNoContactadosEje = rsCompPago("CANTIDAD")
			Else
				intNoContactadosEje = 0
			End if


			intGestTelefonicasEje = intContactadosEje + intNoContactadosEje
			If intGestTelefonicasEje <> 0 Then
				intPorcContactadosEje = intContactadosEje/intGestTelefonicasEje*100
				intPorcNoContactadosEje = intNoContactadosEje/intGestTelefonicasEje*100
			Else
				intPorcContactadosEje = 0
				intPorcNoContactadosEje = 0
			End If

	%>
  <tr>
	  <td><%=strEjecutivo%></td>
	  <td align="right">
	  		<A HREF="mis_gestiones_detalle.asp?txt_FechaIni=<%=dtmFecInicio%>&txt_FechaFin=<%=dtmFecTermino%>&cmb_cliente=<%=intCliente%>&intCodEjecutivo=<%=intCodEjecutivo%>&intCodCampana=<%=intCodCampana%>">
	  			<%=FN(intCantidad,0)%>
	  		</A>
	  </td>
	  <td align="right">
		<A HREF="mis_gestiones_detalle.asp?GESTION=2-2-1&txt_FechaIni=<%=dtmFecInicio%>&txt_FechaFin=<%=dtmFecTermino%>&cmb_cliente=<%=intCliente%>&intCodEjecutivo=<%=intCodEjecutivo%>&intCodCampana=<%=intCodCampana%>">
			<%=FN(intCantidadCP,0)%>
		</A>
	  </td>
	  <td align="right"><%=FN(intContactadosEje,0)%></td>
	  <td align="right"><%=FN(intPorcContactadosEje,1)%>%</td>
	  <td align="right"><%=FN(intNoContactadosEje,0)%></td>
	  <td align="right"><%=FN(intPorcNoContactadosEje,1)%>%</td>
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
		<A HREF="mis_gestiones_detalle.asp?GESTION=2-2-1&txt_FechaIni=<%=dtmFecInicio%>&txt_FechaFin=<%=dtmFecTermino%>&cmb_cliente=<%=intCliente%>&intCodCampana=<%=intCodCampana%>">
			<%=FN(intTotCantidad,0)%>
		</A>
	  </td>
	  <td align="right">
	  		<A HREF="mis_gestiones_detalle.asp?GESTION=2-2-1&txt_FechaIni=<%=dtmFecInicio%>&txt_FechaFin=<%=dtmFecTermino%>&cmb_cliente=<%=intCliente%>&intCodCampana=<%=intCodCampana%>">
	  			<%=FN(intTotCantidadCP,0)%>
	  		</A>
	  </td>
	  <td align="right"><%=FN(intTotContactadosEje,0)%></td>
	  <td align="right">&nbsp;</td>
	  <td align="right"><%=FN(intTotNoContactadosEje,0)%></td>
	  <td align="right">&nbsp;</td>
	  <td align="right"><%=FN(intTotMontoEjec,0)%></td>
	  <td align="right"><%=FN(intTotMontoHonEjec,0)%></td>
  </tr>
</table>

	<%End if%>

<%End if%>
<%End if%>






<script language="JavaScript1.2">
function envia(){
		if (datos.CB_CLIENTE.value=='0'){
			alert('DEBE SELECCIONAR UN CLIENTE');
		}else{
		//datos.action='cargando.asp';
		datos.action='informe_campanas.asp';
		datos.submit();
	}
}


function refrescar(){
		if (datos.CB_CLIENTE.value=='0'){
			alert('DEBE SELECCIONAR UN CLIENTE');
		}else if (datos.CB_REMESA.value=='0'){
			alert('DEBE SELECCIONAR UNA ASIGNACION');
		}else
		{
		datos.action='informe_campanas.asp';
		datos.submit();
	}
}

</script>
