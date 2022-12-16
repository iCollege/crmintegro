<% @LCID = 1034 %>
<!--#include file="arch_utils.asp"-->
<!--#include file="../lib/comunes/rutinas/funciones.inc" -->
<!--#include file="../lib/comunes/rutinas/funcionesBD.inc" -->
<!--#include file="lib.asp"-->
<!--#include file="../lib/comunes/rutinas/TraeCampo.inc" -->
<!--#include file="asp/comunes/general/rutinasBooleano.inc" -->

<script language="JavaScript">
function ventanaSecundaria (URL){
window.open(URL,"DETALLE","width=200, height=200, scrollbars=no, menubar=no, location=no, resizable=no")
}
</script>

<%

strCliente=Request("strCliente")
If Trim(strCliente) = "" Then strCliente = session("ses_codcli")



intEjecutivo=Request("intEjecutivo")
intRemesa=Request("intRemesa")

If TraeSiNo(session("perfil_adm")) <> "Si" or trim(intEjecutivo) <> "" Then
	If trim(intEjecutivo) <> "" Then
		strSqlUsuario = " AND C.USUARIO_ASIG = " & intEjecutivo
	Else
		strSqlUsuario = " AND C.USUARIO_ASIG = " & session("session_idusuario")
	End if
End if


intPagoTotal=request("intPagoTotal")
intDePPal = request("intDePPal")

intCobrador = request("CB_COBRADOR")
intProcurador = request("CB_PROCURADOR")
intAbogado = request("CB_ABOGADO")
strNombreGestion = "DOCUMENTOS PAGADOS"
strCodRemesa = intRemesa

%>
<title>Estatus Cartera</title>

<style type="text/css">
<!--
.Estilo37 {color: #FFFFFF}
-->
</style>
<form name="datos" method="post">
<INPUT TYPE="HIDDEN" NAME="intRemesa" VALUE="<%=intRemesa%>">
<table width="100%" border="1" bordercolor="#FFFFFF">
	<tr>
		<TD height="20" ALIGN=LEFT class="pasos1_i">
			<B>ESTATUS DE LA CARTERA JUDICIAL</B> : <%=strNombreGestion%>
		</TD>
	</tr>
</table>
<table width="800" border="0">
  <tr>
    <td valign="top" background="../images/fondo_coventa.jpg">
	<BR>
	<table width="800" border="0">
      <tr bgcolor="#<%=session("COLTABBG")%>" class="Estilo13">
        <td width="20%">CLIENTE</td>
        <td width="20%">EJECUTIVO</td>
        <!--td width="20%">PROCURADOR</td>
        <td width="20%">ABOGADO</td-->
        <td width="20%">&nbsp</td>
      </tr>
      <tr>
        <td>
			<select name="CB_CLIENTE">
				<option value="100">TODOS</option>
				<%
				abrirscg()
				ssql="SELECT CODCLIENTE,RAZON_SOCIAL FROM CLIENTE ORDER BY RAZON_SOCIAL"
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
        <td>
			<select name="CB_COBRADOR">
				<option value="100">TODOS</option>
				<%
				abrirscg()
				ssql="SELECT ID_USUARIO,LOGIN FROM USUARIO WHERE PERFIL_COB = 1"
				set rsTemp= Conn.execute(ssql)
				if not rsTemp.eof then
					do until rsTemp.eof%>
					<option value="<%=rsTemp("ID_USUARIO")%>"<%if cint(intCobrador)=rsTemp("ID_USUARIO") then response.Write("Selected") End If%>><%=rsTemp("LOGIN")%></option>
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
        <!--td>
			<select name="CB_PROCURADOR">
				<option value="100">TODOS</option>
				<%
				abrirscg()
				ssql="SELECT * FROM PROCURADOR WHERE ACTIVO = 1"
				set rsTemp= Conn.execute(ssql)
				if not rsTemp.eof then
					do until rsTemp.eof%>
					<option value="<%=rsTemp("IDPROCURADOR")%>"<%if cint(intProcurador)=rsTemp("IDPROCURADOR") then response.Write("Selected") End If%>><%=Mid(rsTemp("NOMPROCURADOR"),1,15)%></option>
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
			<select name="CB_ABOGADO">
				<option value="100">TODOS</option>
				<%
				abrirscg()
				ssql="SELECT * FROM ABOGADO WHERE ACTIVO = 1"
				set rsTemp= Conn.execute(ssql)
				if not rsTemp.eof then
					do until rsTemp.eof%>
					<option value="<%=rsTemp("IDABOGADO")%>"<%if cint(intAbogado)=rsTemp("IDABOGADO") then response.Write("Selected") End If%>><%=Mid(rsTemp("NOMABOGADO"),1,15)%></option>
					<%
					rsTemp.movenext
					loop
				end if
				rsTemp.close
				set rsTemp=nothing
				cerrarscg()
				%>

			</select>
        </td-->
        <td>
		  <input type="button" name="Submit" value="Aceptar" onClick="envia();">
		  <input type="button" name="Submit" value="Excel" onClick="excel();">
		</td>

      </tr>
    </table>

	<%
	IF strCliente <> "" or Trim(intDePPal) <> "" then

	%>
	<table width="800" border="1" bordercolor = "#<%=session("COLTABBG")%>" cellSpacing=0 cellPadding=1>

    <%
    	strTotalCuantia = 0
		abrirscg()

		strCondicion = ""
		If Trim(intCobrador) <> "100" and Trim(intCobrador) <> "" Then
			strCondicion = " AND USUARIO_ASIG = " & intCobrador
		End if



		strSql="SELECT RUTDEUDOR AS RUT, CUENTA, NRODOC AS FOLIO, IsNull(VALORCUOTA,0) AS MONTO FROM CUOTA WHERE CODREMESA = " & strCodRemesa & " AND CODCLIENTE = '" & strCliente & "' AND SALDO = 0"

		If Trim(intPagoTotal) = "1" Then
			strSql=strSql & " AND RUTDEUDOR IN (SELECT DISTINCT(RUTDEUDOR) FROM CUOTA WHERE CODCLIENTE = '" & strCliente & "' AND CODREMESA = " & strCodRemesa & " GROUP BY RUTDEUDOR HAVING SUM(SALDO) = 0)"
		Else
			strSql=strSql & " AND RUTDEUDOR NOT IN (SELECT DISTINCT(RUTDEUDOR) FROM CUOTA WHERE CODCLIENTE = '" & strCliente & "' AND CODREMESA = " & strCodRemesa & " GROUP BY RUTDEUDOR HAVING SUM(SALDO) = 0)"
		End if

		strSql=strSql & strCondicion
		strSql=strSql & " ORDER BY RUT,FOLIO"

		'Response.Write strSql
		'Response.End
		set rsGTC= Conn.execute(strSql)
		if not rsGTC.eof then
			intConRegistros="S"

	%>

		<tr bgcolor="#<%=session("COLTABBG")%>" class="Estilo13">
			<td>&nbsp</td>
			<td width="25">Rut</td>
			<td width="150">Nombre o Razon Social</td>
			<td width="50">Prob.Cobro</td>
			<td width="50">Cuenta</td>
			<td width="100">Folio</td>
			<td width="20">Monto</td>
		</tr>

   	<%


			strTotalMonto = 0
			intCorrelativo = 1
			Do until rsGTC.eof
				strRutDeudor = rsGTC("RUT")
				strNombre  = strNombre
				strCuenta = rsGTC("CUENTA")
				strDoc = rsGTC("FOLIO")
				strMonto = rsGTC("MONTO")

				strQry= " RUTDEUDOR = '" & rsGTC("RUT") &"' AND CODCLIENTE = '" & strCliente & "' AND CODREMESA = " & strCodRemesa
				intProcCobro = TraeCampoIdWhere(Conn, "PROB_COBRO", "CUOTA_ENC", strQry)

				strQry= " RUTDEUDOR = '" & rsGTC("RUT") & "' AND CODCLIENTE = '" & strCliente & "'"
				strNombre = TraeCampoIdWhere(Conn, "NOMBREDEUDOR", "DEUDOR", strQry)



				strTotalMonto = strTotalMonto + strMonto

				%>
				<tr>
				<%
				strColsPan = 6
				%>
					<td><%=intCorrelativo%></td>
					<td>
						<A HREF="principal.asp?rut=<%=strRutDeudor%>">
							<acronym title="Llevar a pantalla de selección"><%=strRutDeudor%></acronym>
						</A>
					</td>
					<td><%=strNombre%></td>
					<td><%=intProcCobro%></td>
					<td><%=strCuenta%></td>
					<td><%=strDoc%></td>
					<td ALIGN="RIGHT"><%=FN(strMonto,0)%></td>

				<tr>
				<%
				intCorrelativo=intCorrelativo+1
				rsGTC.movenext
			loop

		Else
			intConRegistros="N"
		End If
		rsGTC.close
		set rsGTC=nothing
		cerrarscg()

%>
      <tr bgcolor="#<%=session("COLTABBG")%>" class="Estilo37">
      	<td colspan="<%=strColsPan%>" >TOTALES</td>
		<td ALIGN="RIGHT"><%=FN(strTotalMonto,0)%></td>

      </tr>

      <% Else %>
      <tr>
      	<td colspan="<%=strColsPan%>" ALIGN="CENTER">Seleccion No Arrojó resultados</td>
	  </tr>


      <% End if %>
    </table>
	  </td>
  </tr>
</table>

</form>

<script language="JavaScript1.2">
function envia()	{
	if (datos.CB_CLIENTE.value=='0'){
		alert('DEBE SELECCIONAR UN CLIENTE');
	}else{
		datos.action='informe_docpagados.asp';
		datos.submit();
	}
}

function excel(){
	if (datos.CB_CLIENTE.value=='0'){
		alert('DEBE SELECCIONAR UN CLIENTE');
	}else{
		datos.action='informe_estatus_xls.asp';
		datos.submit();
	}
}
</script>
