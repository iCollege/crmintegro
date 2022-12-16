<% @LCID = 1034 %>
<!--#include file="sesion.asp"-->
<!--#include file="arch_utils.asp"-->
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
%>
<title>MIS GESTIONES REALIZADAS</title>

<style type="text/css">
<!--
.Estilo37 {color: #FFFFFF}
-->
</style>
<form name="datos" method="post">
<table width="100%" border="1" bordercolor="#FFFFFF">
	<tr>
	<TD height="20" ALIGN=LEFT class="pasos2_i">
		<B>Gestiones Judiciales</B>
	</TD>
	</tr>
</table>
<table width="680" height="300" border="0">
    <tr>
    <td height="242" valign="top">
	<BR>
	<table width="100%" border="0">
      <tr bgcolor="#<%=session("COLTABBG")%>" class="Estilo13">
        <td width="33%">CLIENTE</td>
        <td width="25%">FECHA INICIO </td>
        <td width="42%" bgcolor="#<%=session("COLTABBG")%>">FECHA TERMINO </td>
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
        </select></td>
        <td><input name="inicio" type="text" id="inicio" value="<%=inicio%>" size="10" maxlength="10">
         <a href="javascript:showCal('Calendar7');"><img src="../lib/calendario.gif" border="0"></td>
        <td><input name="termino" type="text" id="termino" value="<%=termino%>" size="10" maxlength="10">
          <a href="javascript:showCal('Calendar6');"><img src="../lib/calendario.gif" border="0"></a>
		  &nbsp;&nbsp;&nbsp;<input type="button" name="Submit" value="Aceptar" onClick="envia();">
		 </td>
      </tr>
    </table>

	<%
	IF not cliente="" then

	%>
	<table width="100%" border="1" bordercolor = "#<%=session("COLTABBG")%>" cellSpacing=0 cellPadding=2>
      <tr bgcolor="#<%=session("COLTABBG")%>" class="Estilo13">
        <td width="33%">CATEGORIA</td>
        <td width="33%">SUBCATEGORIA</td>
        <td width="33%">ESTATUS</td>
        <td width="10%" align="right">CANTIDAD</td>
      </tr>

    <%
	abrirscg()
		strSql="SELECT * FROM GESTIONES_JUDICIAL_CATEGORIA"
		set rsGTC= Conn.execute(strSql)
		if not rsGTC.eof then
			Do until rsGTC.eof
				%>
				<tr>
				<td><%=rsGTC("CODCATEGORIA")%>.&nbsp&nbsp<%=rsGTC("DESCRIPCION")%></td>
				<%
				strSql="SELECT * FROM GESTIONES_JUDICIAL_SUBCATEGORIA WHERE CODCATEGORIA = " & rsGTC("CODCATEGORIA")
				set rsGTSC= Conn.execute(strSql)
				if not rsGTSC.eof then
					Do until rsGTSC.eof
						%>
						<td><%=rsGTSC("CODCATEGORIA")%>. <%=rsGTSC("CODSUBCATEGORIA")%>&nbsp&nbsp<%=rsGTSC("DESCRIPCION")%></td>
						<%
							strSql="SELECT IsNull(CODCATEGORIA,0) as CODCATEGORIA, IsNull(CODSUBCATEGORIA,0) as CODSUBCATEGORIA, IsNull(CODGESTION,0) as CODGESTION , DESCRIPCION FROM GESTIONES_JUDICIAL_GESTION WHERE CODCATEGORIA = " & rsGTSC("CODCATEGORIA") & " AND CODSUBCATEGORIA = " & rsGTSC("CODSUBCATEGORIA")
							set rsGTG= Conn.execute(strSql)
							if not rsGTG.eof then
								Do until rsGTG.eof
									intCant = TraeCantGestionesJud(Conn, inicio, termino, rsGTG("CODCATEGORIA"), rsGTG("CODSUBCATEGORIA"), rsGTG("CODGESTION"), cliente)
									intTotalGestiones = intTotalGestiones + intCant
									%>
									<td><%=rsGTG("CODCATEGORIA")%>.<%=rsGTG("CODSUBCATEGORIA")%>.<%=rsGTG("CODGESTION")%>&nbsp&nbsp<%=rsGTG("DESCRIPCION")%></td>
									<td align="right">
									<A HREF="mis_gestiones_judiciales_detalle.asp?CODCATEGORIA=<%=rsGTG("CODCATEGORIA")%>&CODSUBCATEGORIA=<%=rsGTG("CODSUBCATEGORIA")%>&CODGESTION=<%=rsGTG("CODGESTION")%>&txt_FechaIni=<%=inicio%>&txt_FechaFin=<%=termino%>&cmb_cliente=<%=cliente%>">
										<%=intCant%>
									</A>
									</td>
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
								intCant = TraeCantGestionesJud(Conn, inicio, termino, rsGTSC("CODCATEGORIA"), rsGTSC("CODSUBCATEGORIA"), 0, cliente)
								intTotalGestiones = intTotalGestiones + intCant
								%>
								<td>&nbsp</td>
								<td align="right">
									<A HREF="mis_gestiones_judiciales_detalle.asp?CODCATEGORIA=<%=rsGTSC("CODCATEGORIA")%>&CODSUBCATEGORIA=<%=rsGTSC("CODSUBCATEGORIA")%>&CODGESTION=0&txt_FechaIni=<%=inicio%>&txt_FechaFin=<%=termino%>&cmb_cliente=<%=cliente%>">
									<%=intCant%>
									</A>
								</td>
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
		cerrarscg()


	%>

      <tr bgcolor="#<%=session("COLTABBG")%>">
        <td>&nbsp</td>
        <td>&nbsp</td>
        <td><span class="Estilo37">TOTAL DE GESTIONES REALIZADAS</span></td>
        <td align="right" class="Estilo37"><%=intTotalGestiones%></td>
      </tr>
    </table>
	<% end if %>
	  </td>
  </tr>
</table>

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
datos.action='mis_gestiones_judiciales.asp';
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
