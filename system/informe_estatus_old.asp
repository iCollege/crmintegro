<% @LCID = 1034 %>
<!--#include file="arch_utils.asp"-->
<!--#include file="../lib/comunes/rutinas/funciones.inc" -->
<!--#include file="../lib/comunes/rutinas/funcionesBD.inc" -->
<!--#include file="lib.asp"-->
<!--#include file="../lib/comunes/rutinas/TraeCampo.inc" -->

<script language="JavaScript">
function ventanaSecundaria (URL){
window.open(URL,"DETALLE","width=200, height=200, scrollbars=no, menubar=no, location=no, resizable=no")
}

</script>

<%

inicio= request("inicio")
termino= request("termino")
cliente = request("CB_CLIENTE")
intGestion = request("intGestion")
intDePPal = request("intDePPal")

abrirscg()
	strSql="SELECT NOMGESTION FROM GESTION_JUDICIAL WHERE IDGESTION = " & intGestion
	set rsTemp= Conn.execute(strSql)
	If not rsTemp.eof then
		strNombreGestion = rsTemp("NOMGESTION")
	End if
	rsTemp.close
	set rsTemp=nothing
cerrarscg()

%>
<title>Estatus Cartera</title>

<style type="text/css">
<!--
.Estilo37 {color: #FFFFFF}
-->
</style>
<form name="datos" method="post">
<table width="100%" border="1" bordercolor="#FFFFFF">
	<tr>
		<TD height="20" ALIGN=LEFT class="pasos1_i">
			<B>ESTATUS DE LA CARTERA JUDICIAL</B> : <%=strNombreGestion%>
		</TD>
	</tr>
</table>
<table width="100%" height="300" border="0">
  <tr>
    <td height="242" valign="top" background="../images/fondo_coventa.jpg">
	<BR>
	<table width="100%" border="0">
      <tr bgcolor="#<%=session("COLTABBG")%>" class="Estilo13">
        <td width="20%">CLIENTE</td>
        <td width="20%">COBRADOR</td>
        <td width="20%">PROCURADOR</td>
        <td width="20%">ABOGADO</td>
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
					<option value="<%=rsTemp("CODCLIENTE")%>"<%if cint(cliente)=rsTemp("CODCLIENTE") then response.Write("Selected") End If%>><%=rsTemp("RAZON_SOCIAL")%></option>
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
					<option value="<%=rsTemp("ID_USUARIO")%>"<%if cint(cliente)=rsTemp("LOGIN") then response.Write("Selected") End If%>><%=rsTemp("LOGIN")%></option>
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
			<select name="CB_PROCURADOR">
				<option value="100">TODOS</option>
				<%
				abrirscg()
				ssql="SELECT * FROM PROCURADOR WHERE ACTIVO = 1"
				set rsTemp= Conn.execute(ssql)
				if not rsTemp.eof then
					do until rsTemp.eof%>
					<option value="<%=rsTemp("IDPROCURADOR")%>"<%if cint(cliente)=rsTemp("IDPROCURADOR") then response.Write("Selected") End If%>><%=Mid(rsTemp("NOMPROCURADOR"),1,15)%></option>
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
					<option value="<%=rsTemp("IDABOGADO")%>"<%if cint(cliente)=rsTemp("IDABOGADO") then response.Write("Selected") End If%>><%=Mid(rsTemp("NOMABOGADO"),1,15)%></option>
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
		  <input type="button" name="Submit" value="Aceptar" onClick="envia();">
		  <input type="button" name="Submit" value="Excel" onClick="excel();">
		</td>

      </tr>
    </table>

	<%
	IF cliente <> "" or Trim(intDePPal) <> "" then

	%>
	<table width="100%" border="1" bordercolor = "#<%=session("COLTABBG")%>" cellSpacing=0 cellPadding=2>



      <tr bgcolor="#<%=session("COLTABBG")%>" class="Estilo13">

      	<% If Trim(intGestion)= "1" Then %>
			<td width="10%">Fecha Asign.</td>
			<td width="10%">Id Deudor</td>
			<td width="10%">Rut</td>
			<td width="20%">Nombre o Razon Social</td>
			<td width="10%">Probabilidad de Cobro</td>
			<td width="10%">Cobranza</td>
			<td width="10%">Cuantía</td>
			<td width="10%">Recaudado</td>
		<% End if %>
		<% If Trim(intGestion)= "2" or Trim(intGestion)= "3" or Trim(intGestion)= "4" Then %>
			<td width="10%">Fecha Asign.</td>
			<td width="10%">Id Deudor</td>
			<td width="10%">Rut</td>
			<td width="20%">Nombre o Razon Social</td>
			<td width="10%">Probabilidad de Cobro</td>
			<td width="10%">Cuantia</td>
			<td width="10%">Recaudado</td>
			<td width="10%">Dirección</td>
			<td width="10%">Teléfono</td>
		<% End if %>

		<% If Trim(intGestion)= "5" Then %>
			<td width="10%">Id Deudor</td>
			<td width="10%">Rut</td>
			<td width="20%">Nombre o Razon Social</td>
			<td width="10%">Probabilidad de Cobro</td>
			<td width="10%">Tribunal</td>
			<td width="10%">Rol - Año</td>
			<td width="10%">F.Ingreso</td>
			<td width="10%">Procurador</td>
			<td width="10%">Abogado</td>
			<td width="10%">Cuantia</td>
			<td width="10%">Recaudado</td>
			<td width="10%">Monto Demanda</td>
			<td width="10%">A Pagar</td>
		<% End if %>

      </tr>
    <%
    	strTotalCuantia = 0
		abrirscg()
		strSql="SELECT * FROM DEMANDA WHERE IDGESTIONACTUAL = " & intGestion & " ORDER BY MONTO DESC"
		set rsGTC= Conn.execute(strSql)
		if not rsGTC.eof then
			Do until rsGTC.eof
				strFechaAsig = rsGTC("FECHA_INGRESO")
				strIdDeudor = rsGTC("FECHA_INGRESO")
				strRutDeudor = rsGTC("RUTDEUDOR")
				strCuantia = rsGTC("MONTO")
				strNombre = TraeCampoId2(Conn, "NOMBREDEUDOR", Trim(rsGTC("RUTDEUDOR")), "DEUDOR", "RUTDEUDOR")
				strProbabilidad = "&nbsp"
				strCobranza = "&nbsp"
				strRecaudado = strCuantia / 2
				strDireccion = "&nbsp"
				strTelefono = "&nbsp"
				strMontoDemanda = rsGTC("MONTO")
				strTribunal = "&nbsp"
				strFechaIngreso = rsGTC("FECHA_INGRESO")
				strRolAno = rsGTC("ROLANO")
				strProcurador = "&nbsp"
				strAbogado = "&nbsp"
				strAPagar = 0

				strTotalCuantia = strTotalCuantia + strCuantia
				strTotalRecaudado = strTotalRecaudado + strRecaudado
				strTotalMontoDemanda = strTotalMontoDemanda + strMontoDemanda
				strTotalApagar = strTotalApagar + strAPagar


				%>
				<tr>
				<%
				If Trim(intGestion)= "1" Then
				strColsPan = 6
				%>
					<td><%=strFechaAsig%></td>
					<td><%=strIdDeudor%></td>
					<td><%=strRutDeudor%></td>
					<td><%=strNombre%></td>
					<td><%=strProbabilidad%></td>
					<td><%=strCobranza%></td>
					<td ALIGN="RIGHT"><%=FN(strCuantia,0)%></td>
					<td ALIGN="RIGHT"><%=FN(strRecaudado,0)%></td>
				<% End if %>
				<% If Trim(intGestion)= "2" or Trim(intGestion)= "3" or Trim(intGestion)= "4" Then
				strColsPan = 5
				%>
					<td><%=strFechaAsig%></td>
					<td><%=strIdDeudor%></td>
					<td><%=strRutDeudor%></td>
					<td><%=strNombre%></td>
					<td><%=strProbabilidad%></td>
					<td ALIGN="RIGHT"><%=FN(strCuantia,0)%></td>
					<td ALIGN="RIGHT"><%=FN(strRecaudado,0)%></td>
					<td><%=strDireccion%></td>
					<td><%=strTelefono%></td>
				<% End if %>
				<% If Trim(intGestion)= "5" Then
				strColsPan = 9
				%>
					<td><%=strIdDeudor%></td>
					<td><%=strRutDeudor%></td>
					<td><%=strNombre%></td>
					<td><%=strProbabilidad%></td>
					<td><%=strTribunal%></td>
					<td><%=strRolAno%></td>
					<td><%=strFechaIngreso%></td>
					<td><%=strProcurador%></td>
					<td><%=strAbogado%></td>
					<td ALIGN="RIGHT"><%=FN(strCuantia,0)%></td>
					<td ALIGN="RIGHT"><%=FN(strRecaudado,0)%></td>
					<td ALIGN="RIGHT"><%=FN(strMontoDemanda,0)%></td>
					<td ALIGN="RIGHT"><%=FN(strApagar,0)%></td>
				<% End if %>
				<tr>
				<%
				rsGTC.movenext
			loop
		End If
		rsGTC.close
		set rsGTC=nothing
		cerrarscg()


	%>

      <tr bgcolor="#<%=session("COLTABBG")%>" class="Estilo37">
      	<td colspan="<%=strColsPan%>" >TOTALES</td>
      	<% If Trim(intGestion)= "1" Then %>
			<td ALIGN="RIGHT"><%=FN(strTotalCuantia,0)%></td>
			<td ALIGN="RIGHT"><%=FN(strTotalRecaudado,0)%></td>
		<% End If%>
		<% If Trim(intGestion)= "2" or Trim(intGestion)= "3" or Trim(intGestion)= "4" Then %>
			<td ALIGN="RIGHT"><%=FN(strTotalCuantia,0)%></td>
			<td ALIGN="RIGHT"><%=FN(strTotalRecaudado,0)%></td>
			<td>&nbsp</td>
			<td>&nbsp</td>
		<% End If%>
		<% If Trim(intGestion)= "5" Then %>
			<td ALIGN="RIGHT"><%=FN(strTotalCuantia,0)%></td>
			<td ALIGN="RIGHT"><%=FN(strTotalRecaudado,0)%></td>
			<td ALIGN="RIGHT"><%=FN(strTotalMontoDemanda,0)%></td>
			<td ALIGN="RIGHT"><%=FN(strTotalApagar,0)%></td>
		<% End If%>
      </tr>
    </table>
	<% end if %>
	  </td>
  </tr>
</table>

</form>

<script language="JavaScript1.2">
function envia()	{
	if (datos.CB_CLIENTE.value=='0'){
		alert('DEBE SELECCIONAR UN CLIENTE');
	}else{
		datos.action='informe_estatus.asp';
		datos.submit();
	}
}

function excel(){
	if (datos.cliente.value=='0'){
		alert('DEBE SELECCIONAR UN CLIENTE');
	}else{
		datos.action='mis_gestiones_xls.asp';
		datos.submit();
	}
}
</script>
