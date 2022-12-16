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

strTipoCarga = request("CB_TIPO")
strCampoCuota = request("CB_CUOTA")




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
  	strNroDoc = Trim(Request("TX_NRODOC"))



	If Trim(strRut) <> "" then
		if ASC(RIGHT(strRut,1)) = 10 then strRut = Mid(strRut,1,len(strRut)-1)
		If Trim(strNroDoc) <> "" Then
			if ASC(RIGHT(strNroDoc,1)) = 10 then strNroDoc = Mid(strNroDoc,1,len(strNroDoc)-1)
		End If

		if ASC(RIGHT(strRut,1)) = 13 then strRut = Mid(strRut,1,len(strRut)-1)
		If Trim(strNroDoc) <> "" Then
			if ASC(RIGHT(strNroDoc,1)) = 13 then strNroDoc = Mid(strNroDoc,1,len(strNroDoc)-1)
		End If
	End if

	'rESPONSE.WRITE "<br>strRut=" & "-" & strRut & "-"

	vRut = split(strRut,CHR(13))
	vNroDoc = split(strNroDoc,CHR(13))



	'Response.write "<br>ASC = " & ASC(MID(strRut,11,1))

	intTamvRut=ubound(vRut)
	intTamvNroDoc=ubound(vNroDoc)

	'Response.write "<br>intTamvRut = " & intTamvRut
	'Response.write "<br>intTamvNroDoc = " & intTamvNroDoc
	'Response.End
	'Response.write "<br>Conn=" & Conn

  		For indice = 0 to intTamvRut
			if intTamvRut <> -1 Then
				strIdRut = Trim(Replace(vRut(indice), chr(10),""))
			End If
			if intTamvNroDoc <> -1 Then
				strNroDocumento = ucase(Trim(Replace(vNroDoc(indice), chr(10),"")))
			End If
			If Trim(strTipoCarga) = "ELIMINAR_GESTIONES" Then
				strSql = "DELETE FROM GESTIONES WHERE ID_GESTION = '" & strIdRut & "'"
			ElseIf Trim(strTipoCarga) = "ELIMINAR_TELEFONOS" Then
				strSql = "DELETE FROM DEUDOR_TELEFONO WHERE IDTELEFONO = '" & strIdRut & "'"
			ElseIf Trim(strTipoCarga) = "ELIMINAR_DOCUMENTOS" Then
				strSql = "DELETE FROM CUOTA WHERE IDCUOTA = '" & strIdRut & "'"
			ElseIf Trim(strTipoCarga) = "ELIMINAR_DIRECCIONES" Then
				strSql = "DELETE FROM DEUDOR_DIRECCION WHERE IDDIRECCION = '" & strIdRut & "'"
			ElseIf Trim(strTipoCarga) = "MODIF_DOCUMENTOS" Then
				strSql = "UPDATE CUOTA SET " & strCampoCuota & " = '" & strNroDocumento & "' WHERE IDCUOTA = '" & strIdRut & "'"
			ElseIf Trim(strTipoCarga) = "AUDITAR_TELEFONOS" Then
				strSql = "UPDATE DEUDOR_TELEFONO SET ESTADO = " & strNroDocumento & " WHERE IDTELEFONO = " & strIdRut
			ElseIf Trim(strTipoCarga) = "REBAJA_PAGOS_EN_CLIENTE" Then
				strSql = "UPDATE CUOTA SET SALDO = 0, FECHA_ESTADO = getdate(), ESTADO_DEUDA = 3, OBSERVACION = 'PAGO TOTAL POR " & session("session_idusuario") & "' WHERE IDCUOTA = " & strIdRut
			ElseIf Trim(strTipoCarga) = "REBAJA_PAGOS_EN_EMPRESA" Then
				strSql = "UPDATE CUOTA SET SALDO = 0, FECHA_ESTADO = getdate(), ESTADO_DEUDA = 4, OBSERVACION = 'PAGO TOTAL POR " & session("session_idusuario") & "' WHERE IDCUOTA = " & strIdRut
			ElseIf Trim(strTipoCarga) = "ABONO" Then
				strSql = "UPDATE CUOTA SET SALDO = SALDO - " & strNroDocumento & " , FECHA_ESTADO = getdate(), ESTADO_DEUDA = 7, OBSERVACION = 'ABONO POR " & session("session_idusuario") & "' WHERE IDCUOTA = " & strIdRut
			ElseIf Trim(strTipoCarga) = "RETIRO" Then
				strSql = "UPDATE CUOTA SET ESTADO_DEUDA = 2 , FECHA_ESTADO = getdate(), SALDO = 0, OBSERVACION = 'RETIRADO POR " & session("session_idusuario") & "' WHERE IDCUOTA = " & strIdRut
			ElseIf Trim(strTipoCarga) = "RETIRO_RES" Then
				strSql = "UPDATE CUOTA SET ESTADO_DEUDA = 5 , FECHA_ESTADO = getdate(), SALDO = 0, OBSERVACION = 'RETIRADO POR RESOL. POR " & session("session_idusuario") & "' WHERE IDCUOTA = " & strIdRut
			ElseIf Trim(strTipoCarga) = "ACTIVAR" Then
				strSql = "UPDATE CUOTA SET ESTADO_DEUDA = 1 , FECHA_ESTADO = getdate(), SALDO = VALORCUOTA, OBSERVACION = 'VUELTO A ACTIVAR POR " & session("session_idusuario") & "' WHERE IDCUOTA = " & strIdRut
			ElseIf Trim(strTipoCarga) = "AGREGAR_ROL" Then
				strSql = "UPDATE DEMANDA SET ROLANO = '" & strNroDocumento & "' WHERE IDDEMANDA = " & strIdRut
			End if
			'response.WRITE strSql
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
			<B>UTILITARIO POR IDENTIFICADOR</B>
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
			<td width="25%">TIPO PROCESO</td>
			<td width="25%">CAMPO DOCUMENTO</td>
		</tr>
		<tr>
			<td>
				<select name="CB_TIPO">
					<option value="ELIMINAR_GESTIONES" <%If strTipoCarga = "ELIMINAR_GESTIONES" then response.write "SELECTED"%>>ELIMINAR GESTIONES</option>
					<option value="ELIMINAR_TELEFONOS" <%If strTipoCarga = "ELIMINAR_TELEFONOS" then response.write "SELECTED"%>>ELIMINAR TELEFONOS</option>
					<option value="ELIMINAR_DIRECCIONES" <%If strTipoCarga = "ELIMINAR_DIRECCIONES" then response.write "SELECTED"%>>ELIMINAR DIRECCIONES</option>
					<option value="ELIMINAR_DOCUMENTOS" <%If strTipoCarga = "ELIMINAR_DOCUMENTOS" then response.write "SELECTED"%>>ELIMINAR DOCUMENTOS</option>
					<option value="AUDITAR_TELEFONOS" <%If strTipoCarga = "AUDITAR_TELEFONOS" then response.write "SELECTED"%>>AUDITAR TELEFONOS</option>

					<option value="RETIRO" <%If strTipoCarga = "RETIRO" then response.write "SELECTED"%>>RETIRO POR CLIENTE</option>
					<option value="RETIRO_RES" <%If strTipoCarga = "RETIRO_RES" then response.write "SELECTED"%>>RETIRO POR RESOLUCION</option>
					<option value="REBAJA_PAGOS_EN_CLIENTE" <%If strTipoCarga = "REBAJA_PAGOS_EN_CLIENTE" then response.write "SELECTED"%>>REBAJA PAGOS EN CLIENTE</option>
					<option value="ABONO" <%If strTipoCarga = "ABONO" then response.write "SELECTED"%>>ABONOS</option>
					<option value="ACTIVAR" <%If strTipoCarga = "ACTIVAR" then response.write "SELECTED"%>>VOLVER A ACTIVAR</option>
					<option value="MODIF_DOCUMENTOS" <%If strTipoCarga = "MODIF_DOCUMENTOS" then response.write "SELECTED"%>>MODIFICAR DOCUMENTOS</option>
					<option value="REBAJA_PAGOS_EN_EMPRESA" <%If strTipoCarga = "REBAJA_PAGOS_EN_EMPRESA" then response.write "SELECTED"%>>REBAJA PAGOS EN EMPRESA</option>
					<option value="AGREGAR_ROL" <%If strTipoCarga = "AGREGAR_ROL" then response.write "SELECTED"%>>AGREGAR ROL A DEMANDA</option>

				</select>
			</td>
			<td>
				<select name="CB_CUOTA">
					<option value="CODREMESA" <%If strCampoCuota = "CODREMESA" then response.write "SELECTED"%>>COD.ASIGNACION</option>
					<option value="NRODOC" <%If strCampoCuota = "NRODOC" then response.write "SELECTED"%>>NRODOC</option>
					<option value="CUENTA" <%If strCampoCuota = "CUENTA" then response.write "SELECTED"%>>CUENTA</option>
					<option value="NROCUOTA" <%If strCampoCuota = "NROCUOTA" then response.write "SELECTED"%>>NROCUOTA</option>
					<option value="FECHAVENC" <%If strCampoCuota = "FECHAVENC" then response.write "SELECTED"%>>FECHA VENCIMIENTO</option>
					<option value="VALORCUOTA" <%If strCampoCuota = "VALORCUOTA" then response.write "SELECTED"%>>VALOR ORIGINAL</option>
					<option value="SALDO" <%If strCampoCuota = "SALDO" then response.write "SELECTED"%>>SALDO</option>
					<option value="FECHA_ESTADO" <%If strCampoCuota = "FECHA_ESTADO" then response.write "SELECTED"%>>FECHA ESTADO</option>
					<option value="ESTADO_DEUDA" <%If strCampoCuota = "ESTADO_DEUDA" then response.write "SELECTED"%>>ESTADO DEUDA</option>
					<option value="FECHA_CREACION" <%If strCampoCuota = "FECHA_CREACION" then response.write "SELECTED"%>>FECHA CREACION</option>
					<option value="GASTOSPROTESTOS" <%If strCampoCuota = "GASTOSPROTESTOS" then response.write "SELECTED"%>>GASTOS PROTESTOS</option>
					<option value="TIPODOCUMENTO" <%If strCampoCuota = "TIPODOCUMENTO" then response.write "SELECTED"%>>TIPO DOCUMENTO</option>
					<option value="ADIC1" <%If strCampoCuota = "ADIC1" then response.write "SELECTED"%>>ADIC1</option>
					<option value="ADIC2" <%If strCampoCuota = "ADIC2" then response.write "SELECTED"%>>ADIC2</option>
					<option value="ADIC3" <%If strCampoCuota = "ADIC3" then response.write "SELECTED"%>>ADIC3</option>
					<option value="ADIC4" <%If strCampoCuota = "ADIC4" then response.write "SELECTED"%>>ADIC4</option>
					<option value="ADIC5" <%If strCampoCuota = "ADIC5" then response.write "SELECTED"%>>ADIC5</option>
					<option value="ADIC91" <%If strCampoCuota = "ADIC91" then response.write "SELECTED"%>>ADIC91</option>
					<option value="ADIC92" <%If strCampoCuota = "ADIC92" then response.write "SELECTED"%>>ADIC92</option>
					<option value="ADIC93" <%If strCampoCuota = "ADIC93" then response.write "SELECTED"%>>ADIC93</option>
					<option value="ADIC94" <%If strCampoCuota = "ADIC94" then response.write "SELECTED"%>>ADIC94</option>
					<option value="ADIC95" <%If strCampoCuota = "ADIC95" then response.write "SELECTED"%>>ADIC95</option>
					<option value="CUSTODIO" <%If strCampoCuota = "CUSTODIO" then response.write "SELECTED"%>>CUSTODIO</option>

				</select>
			</td>
		</tr>
	</table>


<table width="50%" border="1" bordercolor="#FFFFFF" ALIGN="CENTER">
	<TR>
		<TD class=hdr_i>
			IDENTIFICADOR<BR>
			<TEXTAREA NAME="TX_RUT" ROWS=30 COLS=15><%=strRut%></TEXTAREA>
		</TD>
		<TD class=hdr_i>
			VALOR NUEVO<BR>
			<TEXTAREA NAME="TX_NRODOC" ROWS=30 COLS=15><%=strNroDoc%></TEXTAREA>
		</TD>
	</TR>
	<TR>
		<TD colspan="2" ALIGN="CENTER">
			<INPUT TYPE="BUTTON" value="Procesar" name="B1" onClick="envia('G');return false;">
		</TD>
	</TR>
</table>
</form>


	  </td>
  </tr>
</table>

<script language="JavaScript1.2">
function envia(intTipo)	{
		if (document.forms[0].CB_TIPO.value == 'ELIMINAR'){
			if (confirm("¿ Está seguro de eliminar los documentos ingresados ? Este proceso es IRREVERSIBLE"))
			{
				if (confirm("¿ Está REALMENTE seguro de eliminar los documentos ingresados ? Este proceso es COMPLETAMENTE IRREVERSIBLE"))
				{
					if (intTipo=='G'){
								document.forms[0].action='utilitario_2.asp?strGraba=S';
							}else{
								document.forms[0].action='utilitario_2.asp?strRefrescar=C';
							}
					document.forms[0].submit();
				}
			}


		}
		else if (document.forms[0].CB_TIPO.value == 'ELIMINAR_GESTIONES'){
			if (confirm("¿ Está seguro de eliminar las gestiones ingresadas ? Este proceso es IRREVERSIBLE"))
			{
				if (confirm("¿ Está REALMENTE seguro de eliminar las gestiones ingresadas ? Este proceso es COMPLETAMENTE IRREVERSIBLE"))
				{
					if (intTipo=='G'){
								document.forms[0].action='utilitario_2.asp?strGraba=S';
							}else{
								document.forms[0].action='utilitario_2.asp?strRefrescar=C';
							}
					document.forms[0].submit();
				}
			}


		}
		else if (document.forms[0].CB_TIPO.value == 'ELIMINAR_DOCUMENTOS'){
				if (confirm("¿ Está seguro de eliminar los documentos ingresados ? Este proceso es IRREVERSIBLE"))
				{
					if (confirm("¿ Está REALMENTE seguro de eliminar los documentos ingresados ? Este proceso es COMPLETAMENTE IRREVERSIBLE"))
					{
						if (intTipo=='G'){
									document.forms[0].action='utilitario_2.asp?strGraba=S';
								}else{
									document.forms[0].action='utilitario_2.asp?strRefrescar=C';
								}
						document.forms[0].submit();
					}
				}


		}
		else if (document.forms[0].CB_TIPO.value == 'ELIMINAR_TELEFONOS'){
			if (confirm("¿ Está seguro de eliminar los teléfonos ingresados ? Este proceso es IRREVERSIBLE"))
			{
				if (confirm("¿ Está REALMENTE seguro de eliminar los teléfonos ingresados ? Este proceso es COMPLETAMENTE IRREVERSIBLE"))
				{
					if (intTipo=='G'){
								document.forms[0].action='utilitario_2.asp?strGraba=S';
							}else{
								document.forms[0].action='utilitario_2.asp?strRefrescar=C';
							}
					document.forms[0].submit();
				}
			}
		}
		else if (document.forms[0].CB_TIPO.value == 'ELIMINAR_DIRECCIONES'){
			if (confirm("¿ Está seguro de eliminar las direcciones ingresadas ? Este proceso es IRREVERSIBLE"))
			{
				if (confirm("¿ Está REALMENTE seguro de eliminar las direcciones ingresadas ? Este proceso es COMPLETAMENTE IRREVERSIBLE"))
				{
					if (intTipo=='G'){
								document.forms[0].action='utilitario_2.asp?strGraba=S';
							}else{
								document.forms[0].action='utilitario_2.asp?strRefrescar=C';
							}
					document.forms[0].submit();
				}
			}
		}
		else
		{
			if (intTipo=='G'){
						document.forms[0].action='utilitario_2.asp?strGraba=S';
					}else{
						document.forms[0].action='utilitario_2.asp?strRefrescar=C';
					}
			document.forms[0].submit();
		}


}

function RefrescaDatos(){
	document.forms[0].submit();
}
</script>
