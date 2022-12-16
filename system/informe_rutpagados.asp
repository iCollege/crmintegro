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

If Trim(strCliente) = "" Then strCliente = "1000"

strCliente=Request("CB_CLIENTE")
intEjecutivo=Request("CB_EJECUTIVO")
intRemesa=Request("CB_REMESA")
intPagoTotal=request("intPagoTotal")

strNombreGestion = "RUT PAGADOS"


If TraeSiNo(session("perfil_adm")) <> "Si" or trim(intEjecutivo) <> "" Then
	If trim(intEjecutivo) <> "" Then
		strSqlUsuario = " AND C.USUARIO_ASIG = " & intEjecutivo
	Else
		strSqlUsuario = " AND C.USUARIO_ASIG = " & session("session_idusuario")
	End if
End if

%>
<title>Estatus Cartera</title>

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
			<B>INFORME DE PAGOS</B> : <%=strNombreGestion%>
		</TD>
	</tr>
</table>

	<% If Trim(strCliente) <> "" and Trim(intRemesa) <> "" then %>
	<table width="600" border="1" bordercolor = "#<%=session("COLTABBG")%>" cellSpacing=0 cellPadding=1>

    <%
    	strTotalCuantia = 0
		abrirscg()

		strCondicion = ""

		strSql = "SELECT DISTINCT(RUTDEUDOR) as RUTDEUDOR, COUNT(NRODOC) as NRODOC, SUM(VALORCUOTA) as MONTO FROM CUOTA"

		If Trim(intPagoTotal) = "1" Then
			strSql = strSql & " WHERE CODCLIENTE = '" & strCliente &"' AND CODREMESA = " & intRemesa & " GROUP BY RUTDEUDOR HAVING SUM(SALDO) = 0"
		Else
			strSql = strSql & " WHERE CODCLIENTE = '" & strCliente &"' AND CODREMESA = " & intRemesa & " AND SALDO = 0 GROUP BY RUTDEUDOR HAVING SUM(SALDO) >= 0"
		End if

		set rsGTC= Conn.execute(strSql)
		if not rsGTC.eof then
			intConRegistros="S"
		%>

		<tr bgcolor="#<%=session("COLTABBG")%>" class="Estilo13">
			<td>&nbsp</td>
			<td width="40">Rut</td>
			<td width="200">Nombre o Razon Social</td>
			<td width="50">Documentos</td>
			<td width="50">Montos</td>
		</tr>

   	<%

		''Response.End
			strTotalMonto = 0

			intCorrelativo = 1
			Do until rsGTC.eof
				strRutDeudor = rsGTC("RUTDEUDOR")
				strNombre  = ""
				strDoc = rsGTC("NRODOC")
				strMonto = rsGTC("MONTO")

				strTotalMonto = strTotalMonto + strMonto

				%>
				<tr>
				<%
				strColsPan = 4
				strQry= " RUTDEUDOR = '" & rsGTC("RUTDEUDOR") & "' AND CODCLIENTE = '" & strCliente & "'"
				strNombre = TraeCampoIdWhere(Conn, "NOMBREDEUDOR", "DEUDOR", strQry)
				%>
					<td><%=intCorrelativo%></td>
					<td>
						<A HREF="principal.asp?rut=<%=strRutDeudor%>">
							<acronym title="Llevar a pantalla de selección"><%=strRutDeudor%></acronym>
						</A>
					</td>
					<td><%=strNombre%></td>
					<td ALIGN="RIGHT"><%=strDoc%></td>
					<td ALIGN="RIGHT"><%=FN(strMonto,0)%></td>

				<tr>
				<%
				intCorrelativo = intCorrelativo + 1
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
      <tr class="pasos1_i">
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
		datos.action='informe_rutpagados.asp';
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
