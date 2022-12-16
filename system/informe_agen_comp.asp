<% @LCID = 1034 %>

<script language="JavaScript" src="loader1.js"></script>

<!--#include file="arch_utils.asp"-->
<!--#include file="sesion.asp"-->
<!--#include file="../lib/comunes/rutinas/funciones.inc" -->
<!--#include file="../lib/comunes/rutinas/rutinasFecha.inc" -->
<!--#include file="../lib/comunes/rutinas/funcionesBD.inc" -->
<!--#include file="../lib/comunes/rutinas/TraeCampo.inc" -->
<!--#include file="lib.asp"-->
<!--#include file="asp/comunes/general/rutinasBooleano.inc"-->

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


	strSql = "SELECT COD_GESTION FROM PARAM_GESTION WHERE TIPO = 'COMP_PAGO'"
	set rsGest = Conn.execute(strSql )
	strCodComPago = ""
	Do While not rsGest.eof
		strCodComPago = Trim(strCodComPago) & ",'" & Trim(rsGest("COD_GESTION")) & "'"
		rsGest.movenext
	Loop

	strSql = "SELECT COD_GESTION FROM PARAM_GESTION WHERE TIPO = 'AGEND'"
	set rsGest = Conn.execute(strSql )
	strCodAgend = ""
	Do While not rsGest.eof
		strCodAgend = Trim(strCodAgend) & ",'" & Trim(rsGest("COD_GESTION")) & "'"
		rsGest.movenext
	Loop

	If Trim (strCodComPago) <> "" Then strCodComPago = Mid(strCodComPago,2,Len(strCodComPago))
	If Trim (strCodAgend) <> "" Then strCodAgend = Mid (strCodAgend,2,Len(strCodAgend))



cerrarscg()

cliente = request("cliente")
cliente = session("ses_codcli")
If Trim(cliente) = "" Then cliente = "1000"


If Trim(request("CB_COBRADOR")) = "0" Then
	intCodUsuario = "0"
Else
	intCodUsuario = request("CB_COBRADOR")
	If Trim(intCodUsuario) = "" Then intCodUsuario = session("session_idusuario")
End If

''Response.write "<br>intCodUsuario" & intCodUsuario
strCodGestion = Trim(Request("CB_TIPOGESTION"))

%>
<title>INFORME AGENDAMIENTOS - COMPROMISOS</title>

<style type="text/css">
<!--
.Estilo37 {color: #FFFFFF}
-->
</style>



<TABLE border=0 cellspacing=0 cellPadding=0>
<form name="datos" method="post">

    <TR>
        <TD>
        	<TABLE WIDTH="850" align = "LEFT" border=0 cellspacing=0>
			    <TR HEIGHT="25" VALIGN="MIDDLE">
			        <TD ALIGN=CENTER background="../images/top_plomo_ch.jpg" CLASS="txt8">
						<B>INFORME AGENDAMIENTOS - COMPROMISOS</B>
					</TD>
			    </TR>
				<TR HEIGHT="20" VALIGN="MIDDLE" BGCOLOR="#EEEEEE">
					<TD ALIGN=CENTER>
						&nbsp;
					</TD>
			    </TR>
			</TABLE>

		</TD>
    </TR>

    <TR>
		<TD>
			<table WIDTH="850" align = "LEFT" height="300" border="0">
			  <tr>
			    <td height="242" valign="top" background="">
					<table width="100%" border="0">
					  <tr bgcolor="#<%=session("COLTABBG")%>" class="Estilo13">
						<td width="20%">CLIENTE</td>
						<% If TraeSiNo(session("perfil_adm")) = "Si" or TraeSiNo(session("perfil_sup")) = "Si" Then %>
						<td width="20%">EJECUTIVO</td>
						<% End If%>

						<td width="20%">FECHA INICIO </td>
						<td width="20%" bgcolor="#<%=session("COLTABBG")%>">FECHA TERMINO </td>
					 </tr>
					  <tr>
						<td>
							<select name="cliente" id="cliente">
								<%
								abrirscg()
								ssql="SELECT CODCLIENTE,RAZON_SOCIAL FROM CLIENTE WHERE CODCLIENTE = '" & cliente & "' ORDER BY RAZON_SOCIAL"
								set rsCLI= Conn.execute(ssql)
								if not rsCLI.eof then
									do until rsCLI.eof%>
								<option value="<%=rsCLI("CODCLIENTE")%>"<%if Trim(cliente)=rsCLI("CODCLIENTE") then response.Write("Selected") End If%>><%=rsCLI("RAZON_SOCIAL")%></option>
								<%
									rsCLI.movenext
									loop
									end if
									rsCLI.close
									set rsCLI=nothing
									cerrarscg()
								%>
							  <option value="100">TODOS</option>
							</select>
						</td>
						<% If TraeSiNo(session("perfil_adm")) = "Si" or TraeSiNo(session("perfil_sup")) = "Si" Then %>
						<td>
							<select name="CB_COBRADOR">
								<option value="0">TODOS</option>
								<%
								abrirscg()
								ssql="SELECT ID_USUARIO, LOGIN, NOMBRES_USUARIO, APELLIDOS_USUARIO FROM USUARIO WHERE PERFIL_COB = 1"
								set rsTemp= Conn.execute(ssql)
								if not rsTemp.eof then
									do until rsTemp.eof
									strNomUsuario = Trim(Mid(rsTemp("NOMBRES_USUARIO"),1,1) & "." & rsTemp("APELLIDOS_USUARIO"))
									strNomUsuario = Mid(strNomUsuario,1,10)
									strNomUsuario = Mid(rsTemp("LOGIN"),1,10)
									%>
									<option value="<%=rsTemp("ID_USUARIO")%>"<%if Trim(intCodUsuario)=Trim(rsTemp("ID_USUARIO")) then response.Write("Selected") End If%>><%=strNomUsuario%></option>
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
						</tr>
						<tr>
						<td COLSPAN=2>
							<select name="CB_TIPOGESTION">
							<option value="TT" <%if strCodGestion = "TT" Then strGestSel="SELECTED" Else strGestSel=""%> <%=strGestSel%>>TODOS TODOS</option>
							<option value="TA" <%if strCodGestion = "TA" Then strGestSel="SELECTED" Else strGestSel=""%> <%=strGestSel%>>TODOS AGENDAMIENTO</option>
							<option value="TC" <%if strCodGestion = "TC" Then strGestSel="SELECTED" Else strGestSel=""%> <%=strGestSel%>>TODOS COMPROMISO</option>
							<%
							abrirscg()

								strSql = "SELECT COD_GESTION,TIPO FROM PARAM_GESTION WHERE TIPO = 'COMP_PAGO'"
								strSql = strSql & " UNION SELECT COD_GESTION,TIPO FROM PARAM_GESTION WHERE TIPO = 'AGEND' ORDER BY TIPO"
								set rsGest = Conn.execute(strSql)
								''strCodComPago = ""

								Do While not rsGest.eof

									strSql = "SELECT CODCATEGORIA, CODSUBCATEGORIA, DESCRIPCION FROM GESTIONES_TIPO_GESTION WHERE cast(CODCATEGORIA as varchar(2))+ '-' + cast(CODSUBCATEGORIA as varchar(2)) + '-' + cast(CODGESTION as varchar(2)) = '" & rsGest("COD_GESTION") & "'"
									set rsGestion = Conn.execute(strSql)
									If not rsGestion.eof Then
										strSql = "SELECT DESCRIPCION FROM GESTIONES_TIPO_CATEGORIA WHERE CODCATEGORIA = " & rsGestion("CODCATEGORIA")
										set rsTemp = Conn.execute(strSql)
										If Not rsTemp.Eof Then
											strNomCategoria = rsTemp("DESCRIPCION")
										End if

										strSql = "SELECT DESCRIPCION FROM GESTIONES_TIPO_SUBCATEGORIA WHERE CODCATEGORIA = " & rsGestion("CODCATEGORIA") & " AND CODSUBCATEGORIA = " & rsGestion("CODSUBCATEGORIA")
										set rsTemp = Conn.execute(strSql)
										If Not rsTemp.Eof Then
											strNomSubCategoria = rsTemp("DESCRIPCION")
										End if


										strNombreGestion = rsGestion("DESCRIPCION")
										strGestionTotal = strNomCategoria & "-" & strNomSubCategoria & "-" & strNombreGestion

									End if

									if strCodGestion = Trim(rsGest("COD_GESTION")) Then strGestSel="SELECTED" Else strGestSel=""
								%>
									<option value="<%=Trim(rsGest("COD_GESTION"))%>" <%=strGestSel%>><%=strGestionTotal%></option>

								<%
									rsGest.movenext
								Loop

							cerrarscg()
							%>
							</select>
						</td>


						<td>
							<input type="button" name="Submit" value="Aceptar" onClick="envia();">
							<!--input type="button" name="Submit" value="Excel" onClick="excel();"-->
						  </td>
					  </tr>
					</table>

				<%
				IF cliente <> "" and Trim(Request("CB_TIPOGESTION")) <> "" then


				abrirscg()
				strSql = "SELECT rutdeudor,codcategoria,codsubcategoria,ISnull(codgestion,0) as "
				strSql = strSql & " codgestion,fechaingreso,horaingreso,codcobrador,IsNull(fechacompromiso,'') as fechacompromiso,IsNull(observaciones,'&nbsp') as observaciones, "
				strSql = strSql & " convert(varchar(2),codcategoria) + convert(varchar(2),codsubcategoria) + "
				strSql = strSql & " convert(varchar(2),IsNull(codgestion,0)) as CODGESTION, IsNull(IDUSUARIO,0) as IDUSUARIO, IsNull(FECHA_AGENDAMIENTO,'') as FECHA_AGENDAMIENTO, HORA_AGENDAMIENTO FROM GESTIONES "
				strSql = strSql & " WHERE CODCLIENTE='" & cliente & "' "


				If Trim(Request("CB_TIPOGESTION")) <> "TA" AND Trim(Request("CB_TIPOGESTION")) <> "TC" AND Trim(Request("CB_TIPOGESTION")) <> "TT" Then
					strSql = strSql & " AND cast(CODCATEGORIA as varchar(2))+ '-' + cast(CODSUBCATEGORIA as varchar(2)) + '-' + cast(CODGESTION as varchar(2)) = '" & Request("CB_TIPOGESTION") & "'"
				Else

					If Trim(Request("CB_TIPOGESTION")) = "TA" Then
						strSql = strSql & " AND cast(CODCATEGORIA as varchar(2)) + '-' + cast(CODSUBCATEGORIA as varchar(2)) + '-' + cast(CODGESTION as varchar(2)) in (" & strCodAgend & ")"
					End If

					If Trim(Request("CB_TIPOGESTION")) = "TC" Then
						strSql = strSql & " AND cast(CODCATEGORIA as varchar(2)) + '-' + cast(CODSUBCATEGORIA as varchar(2)) + '-' + cast(CODGESTION as varchar(2)) in (" & strCodComPago & ")"
					End If

					If Trim(Request("CB_TIPOGESTION")) = "TT" Then
						strSql = strSql & " AND cast(CODCATEGORIA as varchar(2)) + '-' + cast(CODSUBCATEGORIA as varchar(2)) + '-' + cast(CODGESTION as varchar(2)) in (" & strCodAgend & "," & strCodComPago & ")"
					End If

				End If

				strSql = strSql & " AND ((FECHACOMPROMISO >= '" & inicio & "' AND FECHACOMPROMISO <='" & termino & " 23:59:00')"
				strSql = strSql & " OR (FECHA_AGENDAMIENTO >= '" & inicio & "' AND FECHA_AGENDAMIENTO <='" & termino & " 23:59:00'))"

				If Trim(intCodUsuario) <> "0" Then
					strSql = strSql & " AND IDUSUARIO = " & Trim(intCodUsuario)
				End If

				strSql = strSql & " GROUP BY RUTDEUDOR,CODCATEGORIA,CODSUBCATEGORIA,ISNULL(CODGESTION,0), "
				strSql = strSql & " FECHAINGRESO,HORAINGRESO,CODCOBRADOR,FECHACOMPROMISO,OBSERVACIONES ,CODGESTION, IDUSUARIO,FECHA_AGENDAMIENTO,HORA_AGENDAMIENTO "
				strSql = strSql & " ORDER BY RUTDEUDOR,CODCATEGORIA,CODSUBCATEGORIA,ISNULL(CODGESTION,0), "
				strSql = strSql & " FECHAINGRESO,HORAINGRESO,CODCOBRADOR,FECHACOMPROMISO,OBSERVACIONES,IDUSUARIO,FECHA_AGENDAMIENTO "

				'RESPONSE.WRITE "<BR>strSql = " & strSql
				'RESPONSE.End

				SET rsGES=Conn.execute(strSql)
				%>

				<table width="100%" border="1" bordercolor = "#<%=session("COLTABBG")%>" cellSpacing=0 cellPadding=2>

				<tr bgcolor="#<%=session("COLTABBG")%>" class="Estilo13">
					<td>Rut&nbsp;&nbsp;Deudor</td>
					<td>Fecha U.G.</td>
					<td>Fecha Ingreso</td>
					<td>Hora Ingreso</td>
					<td>Gestión</td>
					<td>Ejecutivo</td>
					<td>Fecha Compromiso</td>
					<td>Fecha Agendamiento</td>
					<td>Hora Agend.</td>
					<td>Observaciones</td>
					<td>&nbsp;</td>
				</tr>
				<%
				intTotalGestiones = 0
				Do while not rsGES.eof


				strSql = "SELECT TOP 1 FECHAINGRESO FROM GESTIONES WHERE CODCLIENTE='" & cliente & "' AND RUTDEUDOR = '" & Trim(rsges("rutdeudor")) & "' ORDER BY FECHAINGRESO DESC"
				set rsFecha=Conn.execute(strSql)
				If Not rsFecha.Eof Then
					dtmFecUG = rsFecha("FECHAINGRESO")
				Else
					dtmFecUG = rsges("FECHAINGRESO")
				End If

				If (datevalue(dtmFecUG) >= datevalue(rsges("FECHA_AGENDAMIENTO"))) Then
					strColorG="cuad_verde_15.jpg"
				Else
					strColorG="cuad_naranja_15.jpg"
				End If

				strHoraAgend = Trim(rsges("HORA_AGENDAMIENTO"))


				strFecComp=""
				strFecAgend=""
				strObservaciones=""
				If Trim(rsges("observaciones"))="" Then strObservaciones = "&nbsp;" Else strObservaciones = rsges("observaciones")
				If Trim(Mid(rsges("fechacompromiso"),1,10))="01/01/1900" Then strFecComp = "&nbsp;" Else strFecComp = rsges("fechacompromiso")
				If Trim(Mid(rsges("fecha_agendamiento"),1,10))="01/01/1900" Then strFecAgend = "&nbsp;" Else strFecAgend = rsges("fecha_agendamiento")



				'strEjecutivo = TraeCampoId(Conn, "NOMBRES_USUARIO", Trim(rsges("IDUSUARIO")), "USUARIO", "ID_USUARIO") & "-" & TraeCampoId(Conn, "APELLIDOS_USUARIO", Trim(rsges("IDUSUARIO")), "USUARIO", "ID_USUARIO")
				strEjecutivo = TraeCampoId(Conn, "LOGIN", Trim(rsges("IDUSUARIO")), "USUARIO", "ID_USUARIO")

				strSql = "SELECT G.CODCATEGORIA, G.CODSUBCATEGORIA, G.CODGESTION,C.DESCRIPCION + ' ' + S.DESCRIPCION + ' ' +  G.DESCRIPCION as DESCRIP"
				strSql = strSql & " FROM GESTIONES_TIPO_CATEGORIA C, GESTIONES_TIPO_SUBCATEGORIA S, GESTIONES_TIPO_GESTION G"
				strSql = strSql & " WHERE C.CODCATEGORIA = S.CODCATEGORIA"
				strSql = strSql & " AND C.CODCATEGORIA = G.CODCATEGORIA"
				strSql = strSql & " AND S.CODSUBCATEGORIA = G.CODSUBCATEGORIA"
				strSql = strSql & " AND CAST(G.CODCATEGORIA AS VARCHAR(2)) + CAST(G.CODSUBCATEGORIA AS VARCHAR(2)) + CAST(G.CODGESTION AS VARCHAR(2)) = '" & rsges("CODGESTION") & "'"

				'RESPONSE.WRITE "<BR>strSql = " & strSql
				'RESPONSE.End

				SET rsNomGestion=Conn.execute(strSql)
				If Not rsNomGestion.Eof Then
					strNomGestion = rsNomGestion("DESCRIP")
				Else
					strNomGestion = ""
				End If

				%>

				<tr>
					<td class="DatosDeudorTexto" ><font class="TextoDatos">

					<A HREF="principal.asp?rut=<%=Trim(rsges("rutdeudor"))%>">
						<acronym title="Llevar a pantalla de selección"><%=Trim(rsges("rutdeudor"))%></acronym>
					</A>

					</font></td>
					<td class="DatosDeudorTexto" ><font class="TextoDatos"><%=dtmFecUG%></font></td>
					<td class="DatosDeudorTexto" ><font class="TextoDatos"><%=rsges("fechaingreso") %></font></td>
					<td class="DatosDeudorTexto"><font class="TextoDatos"><%=rsges("horaingreso") %></font></td>
					<td class="DatosDeudorTexto" align="">
					<font class="TextoDatos">
					<%= Trim(strNomGestion) %>
					</font></td>
					<td class="DatosDeudorTexto"><font class="TextoDatos"><%=strEjecutivo %></font></td>
					<td class="DatosDeudorTexto"><font class="TextoDatos"><%=strFecComp %></font></td>
					<td class="DatosDeudorTexto"><font class="TextoDatos"><%=strFecAgend %></font></td>
					<td class="DatosDeudorTexto"><font class="TextoDatos"><%=strHoraAgend %></font></td>
					<td class="DatosDeudorTexto" ><font class="TextoDatos"><%=strObservaciones %></font></td>
					<td class="DatosDeudorTexto" ><img src="../images/<%=strColorG%>" border="0"></td>

				</tr>

				<%
				intTotalGestiones = intTotalGestiones + 1
				rsGES.movenext
					Loop%>


				<tr bgcolor="#FFFFFF">
					<td colspan=10>&nbsp</td>
				</tr>

				<tr bgcolor="#<%=session("COLTABBG")%>">
			        <td colspan=9><span class="Estilo37">TOTAL DE GESTIONES REALIZADAS</span></td>
			        <td align="right" class="Estilo37"><%=intTotalGestiones%></td>
			      </tr>
			    </table>
				<% end if %>
				  </td>
			  </tr>
			</table>





		</TD>
    </TR>

</form>
</TABLE>





<script language="JavaScript" src="loader2.js"></script>

<script language="JavaScript1.2">
function envia(){
if (datos.cliente.value=='0'){
alert('DEBE SELECCIONAR UN CLIENTE');
}else if(datos.inicio.value==''){
alert('DEBE SELECCIONAR FECHA DE INICIO');
}else if(datos.termino.value==''){
alert('DEBES SELECCIONAR FECHA DE TERMINO');
}else{
datos.action='informe_agen_comp.asp';
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
datos.action='informe_agen_comp_xls.asp';
datos.submit();
}
}
</script>
