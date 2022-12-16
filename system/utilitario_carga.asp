<% @LCID = 1034 %>
<!--#include file="arch_utils.asp"-->
<!--#include file="../lib/comunes/rutinas/funciones.inc" -->
<!--#include file="../lib/comunes/rutinas/rutinasFecha.inc" -->
<!--#include file="asp/comunes/general/rutinasBooleano.inc"-->
<!--#include file="sesion.asp"-->
<link href="style.css" rel="stylesheet" type="text/css">
<script language="JavaScript">
function ventanaSecundaria (URL){
	window.open(URL,"DETALLE","width=200, height=200, scrollbars=no, menubar=no, location=no, resizable=no")
}
</script>

<%
inicio= request("inicio")
termino= request("termino")

intCliente = request("CB_CLIENTE")
strTipoCarga = request("CB_TIPO")


abrirscg()
	If Trim(inicio) = "" Then
		inicio = TraeFechaActual(Conn)
		inicio = "01/" & Mid(TraeFechaActual(Conn),4,10)
	End If

	If Trim(termino) = "" Then
		termino = TraeFechaActual(Conn)
	End If


strGraba = request("strGraba")
  If Trim(strGraba) = "S" Then


  	strRut = Trim(Request("TX_RUT"))
	strScoring = Trim(Request("TX_SCORING"))
	strNroDoc = Trim(Request("TX_NRODOC"))


	If Trim(strRut) <> "" then
		if ASC(RIGHT(strRut,1)) = 10 then strRut = Mid(strRut,1,len(strRut)-1)
		''if ASC(RIGHT(strScoring,1)) = 10 then strScoring = Mid(strScoring,1,len(strScoring)-1)
		If Trim(strNroDoc) <> "" Then
			if ASC(RIGHT(strNroDoc,1)) = 10 then strNroDoc = Mid(strNroDoc,1,len(strNroDoc)-1)
		End If

		if ASC(RIGHT(strRut,1)) = 13 then strRut = Mid(strRut,1,len(strRut)-1)
		''if ASC(RIGHT(strScoring,1)) = 13 then strScoring = Mid(strScoring,1,len(strScoring)-1)
		If Trim(strNroDoc) <> "" Then
			if ASC(RIGHT(strNroDoc,1)) = 13 then strNroDoc = Mid(strNroDoc,1,len(strNroDoc)-1)
		End If
	End if

	'rESPONSE.WRITE "<br>strScoring=" & "-" & strScoring & "-"
	'rESPONSE.WRITE "<br>strRut=" & "-" & strRut & "-"
	'rESPONSE.WRITE "RIGHT=" & "-" & RIGHT(strScoring,1) & "-"
	'rESPONSE.WRITE "comp=" & "-" & ASC(RIGHT(strScoring,1)) & "-"

	vRut = split(strRut,CHR(13))
	vScoring = split(strScoring,CHR(13))
	vNroDoc = split(strNroDoc,CHR(13))



	'Response.write "<br>ASC = " & ASC(MID(strRut,11,1))

	intTamvRut=ubound(vRut)
	intTamvNroDoc=ubound(vNroDoc)
	intTamvScoring=ubound(vScoring)

	'Response.write "<br>intTamvRut = " & intTamvRut
	'Response.write "<br>intTamvNroDoc = " & intTamvNroDoc
	'Response.write "<br>intTamvScoring = " & intTamvScoring
	'Response.End


  		For indice = 0 to intTamvRut
			if intTamvRut <> -1 Then
				strIdRut = Trim(Replace(vRut(indice), chr(10),""))
			End If
			if intTamvNroDoc <> -1 Then
				strNroDocumento = ucase(Trim(Replace(vNroDoc(indice), chr(10),"")))
			End If
			if intTamvScoring <> -1 Then
				intCodigo = ucase(Trim(Replace(vScoring(indice), chr(10),"")))
			End If
			If Trim(strTipoCarga) = "REBAJA_PAGOS" Then
				strSql = "UPDATE CUOTA SET SALDO = 0, FECHA_ESTADO = getdate(), ESTADO_DEUDA = 3 , OBSERVACION = 'PAGADO POR " & session("session_idusuario") & "' WHERE CODCLIENTE = '" & intCliente & "' AND RUTDEUDOR = '" & strIdRut & "' AND NRODOC = '" & strNroDocumento & "'"
			ElseIf Trim(strTipoCarga) = "ABONO" Then
				strSql = "UPDATE CUOTA SET SALDO = SALDO - " & intCodigo & " , FECHA_ESTADO = getdate(), ESTADO_DEUDA = 7 , OBSERVACION = 'ABONADO POR " & session("session_idusuario") & "' WHERE CODCLIENTE = '" & intCliente & "' AND RUTDEUDOR = '" & strIdRut & "' AND NRODOC = '" & strNroDocumento & "'"
			ElseIf Trim(strTipoCarga) = "RETIRO" Then
				strSql = "UPDATE CUOTA SET ESTADO_DEUDA = 2 , FECHA_ESTADO = getdate(), SALDO = 0, OBSERVACION = 'RETIRADO POR " & session("session_idusuario") & "' WHERE CODCLIENTE = '" & intCliente & "' AND RUTDEUDOR = '" & strIdRut & "' AND NRODOC = '" & strNroDocumento & "'"
			ElseIf Trim(strTipoCarga) = "RETIRO_DEUDOR" Then
				strSql = "UPDATE CUOTA SET ESTADO_DEUDA = 2 , FECHA_ESTADO = getdate(), SALDO = 0, OBSERVACION = 'RETIRADO POR " & session("session_idusuario") & "' WHERE CODCLIENTE = '" & intCliente & "' AND RUTDEUDOR = '" & strIdRut & "' AND ESTADO_DEUDA IN ('1','7','8') AND SALDO > 0"
			ElseIf Trim(strTipoCarga) = "RETIRO_RES" Then
				strSql = "UPDATE CUOTA SET ESTADO_DEUDA = 5 , FECHA_ESTADO = getdate(), SALDO = 0, OBSERVACION = 'RETIRADO POR RESOL. POR " & session("session_idusuario") & "' WHERE CODCLIENTE = '" & intCliente & "' AND RUTDEUDOR = '" & strIdRut & "' AND NRODOC = '" & strNroDocumento & "'"
			ElseIf Trim(strTipoCarga) = "ACTIVAR" Then
				strSql = "UPDATE CUOTA SET ESTADO_DEUDA = 1 , FECHA_ESTADO = getdate(), SALDO = VALORCUOTA, OBSERVACION = 'VUELTO A ACTIVAR POR " & session("session_idusuario") & "' WHERE CODCLIENTE = '" & intCliente & "' AND RUTDEUDOR = '" & strIdRut & "' AND NRODOC = '" & strNroDocumento & "'"
			ElseIf Trim(strTipoCarga) = "ELIMINAR" Then
				strSql = "DELETE FROM CUOTA WHERE CODCLIENTE = '" & intCliente & "' AND RUTDEUDOR = '" & strIdRut & "' AND NRODOC = '" & strNroDocumento & "'"
			ElseIf Trim(strTipoCarga) = "ELIMINAR_DEUDOR" Then
				strSql = "DELETE FROM CUOTA WHERE CODCLIENTE = '" & intCliente & "' AND RUTDEUDOR = '" & strIdRut & "'"
				set rsUpdate = Conn.execute(strSql)

				strSql = "DELETE FROM GESTIONES WHERE CODCLIENTE = '" & intCliente & "' AND RUTDEUDOR = '" & strIdRut & "'"
				set rsUpdate = Conn.execute(strSql)

				strSql = "DELETE FROM DEUDOR WHERE CODCLIENTE = '" & intCliente & "' AND RUTDEUDOR = '" & strIdRut & "'"
				set rsUpdate = Conn.execute(strSql)

			ElseIf Trim(strTipoCarga) = "MODIF_ADIC1" Then
				strSql = "UPDATE CUOTA SET ADIC1 = '" & intCodigo & "' WHERE CODCLIENTE = '" & intCliente & "' AND RUTDEUDOR = '" & strIdRut & "' AND NRODOC = '" & strNroDocumento & "'"
			ElseIf Trim(strTipoCarga) = "TIPO_COBRANZA" Then
				strSql = "UPDATE DEUDOR SET ETAPA_COBRANZA = '" & intCodigo & "' WHERE CODCLIENTE = '" & intCliente & "' AND RUTDEUDOR = '" & strIdRut & "'"
			End If

			'Response.write "<br>strSql=" & strSql
			'Response.End
			set rsUpdate = Conn.execute(strSql)
		Next
	%>
	<script>
		alert('Proceso realizado correctamente');
	</script>
	<%


  End if




cerrarscg()


If Trim(intCodUsuario) = "" Then intCodUsuario = session("session_idusuario")

''Response.write "intCliente=" & intCliente

If Trim(intCliente) = "" Then intCliente = session("ses_codcli")
%>
<title>UTILITARIO</title>

<style type="text/css">
<!--
.Estilo37 {color: #FFFFFF}
-->
</style>

<TABLE WIDTH="850" align = "CENTER" border=0 cellspacing=0>
   <TR HEIGHT="20" VALIGN="MIDDLE" BGCOLOR="#EEEEEE">
		<TD ALIGN=CENTER>
			<B>UTILITARIO</B>
		</TD>
    </TR>
</TABLE>

<table width="800" align="CENTER" border="0">
   <tr>
    <td valign="top" background="../images/fondo_coventa.jpg">
	<BR>
	<FORM name="datos" method="post">
	<table width="50%" border="0" ALIGN="CENTER">
		<tr bgcolor="#<%=session("COLTABBG")%>" class="Estilo13">
			<td width="25%">MANDANTE</td>
			<!--td width="25%">ASIGNACION</td-->
			<td width="25%">TIPO PROCESO</td>
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
				<select name="CB_TIPO">
					<option value="RETIRO" <%If strTipoCarga = "RETIRO" then response.write "SELECTED"%>>RETIRO POR CLIENTE (DEUDOR-NRODOC)</option>
					<option value="RETIRO_DEUDOR" <%If strTipoCarga = "RETIRO_DEUDOR" then response.write "SELECTED"%>>RETIRO POR CLIENTE (DEUDOR)</option>
					<option value="RETIRO_RES" <%If strTipoCarga = "RETIRO_RES" then response.write "SELECTED"%>>RETIRO POR RESOLUCION</option>
					<option value="RETIRO_DEUDOR" <%If strTipoCarga = "RETIRO_DEUDOR" then response.write "SELECTED"%>>RETIRO POR CLIENTE</option>
					<option value="REBAJA_PAGOS" <%If strTipoCarga = "REBAJA_PAGOS" then response.write "SELECTED"%>>REBAJA PAGOS</option>
					<option value="ABONO" <%If strTipoCarga = "ABONO" then response.write "SELECTED"%>>ABONOS</option>
					<option value="ACTIVAR" <%If strTipoCarga = "ACTIVAR" then response.write "SELECTED"%>>VOLVER A ACTIVAR</option>
					<option value="ELIMINAR" <%If strTipoCarga = "ELIMINAR" then response.write "SELECTED"%>>ELIMINAR DOCUMENTOS</option>
					<option value="ELIMINAR_DEUDOR" <%If strTipoCarga = "ELIMINAR_DEUDOR" then response.write "SELECTED"%>>ELIMINAR DEUDOR</option>
					<option value="TIPO_COBRANZA" <%If strTipoCarga = "TIPO_COBRANZA" then response.write "SELECTED"%>>TIPO COBRANZA</option>
				</select>
			</td>
		</tr>
	</table>


<table width="50%" border="1" bordercolor="#FFFFFF" ALIGN="CENTER">
	<TR>
		<TD class=hdr_i>
			Rut<BR><BR>
			<TEXTAREA NAME="TX_RUT" ROWS=30 COLS=15><%=strRut%></TEXTAREA>
		</TD>
		<TD class=hdr_i>
			Nro. Documento<BR><BR>
			<TEXTAREA NAME="TX_NRODOC" ROWS=30 COLS=15><%=strNroDoc%></TEXTAREA>
		</TD>
		<TD class=hdr_i>
			Codigo o Valor<BR>
			Solo para Abonos
			<TEXTAREA NAME="TX_SCORING" ROWS=30 COLS=10><%=strScoring%></TEXTAREA>
		</TD>
	</TR>
	<TR>
		<TD colspan="3" ALIGN="CENTER">
			<INPUT TYPE="BUTTON" value="Procesar" name="B1" onClick="envia('G');return false;">
		</TD>
	</TR>
</table>
</form>
<%

		If Trim(intCliente) <> "" and Trim(intCodRemesa) <> "" then
		abrirscg()
		End if
%>




	  </td>
  </tr>
</table>

<script language="JavaScript1.2">
function envia(intTipo)	{
		if ((document.forms[0].CB_TIPO.value == 'ELIMINAR') || (document.forms[0].CB_TIPO.value == 'ELIMINAR_ID')){
			if (confirm("¿ Está seguro de eliminar los documentos ingresados ? Este proceso es IRREVERSIBLE"))
			{
				if (confirm("¿ Está REALMENTE seguro de eliminar los documentos ingresados ? Este proceso es COMPLETAMENTE IRREVERSIBLE"))
				{
					if (intTipo=='G'){
								document.forms[0].action='utilitario_carga.asp?strGraba=S';
							}else{
								document.forms[0].action='utilitario_carga.asp?strRefrescar=C';
							}
					document.forms[0].submit();
				}
			}


		}
		else if (document.forms[0].CB_TIPO.value == 'ELIMINAR_DEUDOR'){
					if (confirm("¿ Está seguro de eliminar los deudores ingresados ? Este proceso es IRREVERSIBLE"))
					{
						if (confirm("¿ Está REALMENTE seguro de eliminar los deudores ingresados ? Este proceso es COMPLETAMENTE IRREVERSIBLE, y eliminará deuda y gestiones asociadas al deudor - cliente"))
						{
							if (intTipo=='G'){
										document.forms[0].action='utilitario_carga.asp?strGraba=S';
									}else{
										document.forms[0].action='utilitario_carga.asp?strRefrescar=C';
									}
							document.forms[0].submit();
						}
					}


		}
		else
		{
			if (intTipo=='G'){
						document.forms[0].action='utilitario_carga.asp?strGraba=S';
					}else{
						document.forms[0].action='utilitario_carga.asp?strRefrescar=C';
					}
			document.forms[0].submit();
		}


}

function RefrescaDatos(){
	document.forms[0].submit();
}
</script>
