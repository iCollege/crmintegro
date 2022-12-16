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
intEjecutivo=Request("intEjecutivo")

If TraeSiNo(session("perfil_adm")) <> "Si" or trim(intEjecutivo) <> "" Then
	If trim(intEjecutivo) <> "" Then
		strSqlUsuario = " AND C.USUARIO_ASIG = " & intEjecutivo
	Else
		strSqlUsuario = " AND C.USUARIO_ASIG = " & session("session_idusuario")
	End if
End if

inicio= request("inicio")
termino= request("termino")
cliente = request("CB_CLIENTE")

If Trim(cliente) = "" Then cliente = "1000"
intGestion = request("intGestion")
intDePPal = request("intDePPal")

intCobrador = request("CB_COBRADOR")
intProcurador = request("CB_PROCURADOR")
intAbogado = request("CB_ABOGADO")


If Trim(intGestion) <> "T" AND Trim(intGestion) <> "R" Then
	abrirscg()
		strSql="SELECT NOMGESTION FROM GESTION_JUDICIAL WHERE IDGESTION = " & intGestion
		'Response.write "strSql=" & strSql
		'Response.End
		set rsTemp= Conn.execute(strSql)
		If not rsTemp.eof then
			strNombreGestion = rsTemp("NOMGESTION")
		End if
		rsTemp.close
		set rsTemp=nothing
	cerrarscg()
Else
	strNombreGestion = "TOTAL CASOS DEL PROCESO"

End If
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
        <td width="20%">COBRADOR</td>
        <td width="20%">PROCURADOR</td>
        <td width="20%">ABOGADO</td>
        <td width="20%">&nbsp</td>
      </tr>
      <tr>
        <td>
			<select name="CB_CLIENTE">
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
        <td>
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
	<table width="1200" border="1" bordercolor = "#<%=session("COLTABBG")%>" cellSpacing=0 cellPadding=1>

    <%
    	strTotalCuantia = 0
		abrirscg()

		strCondicion = ""
		If Trim(intCobrador) <> "100" and Trim(intCobrador) <> "" Then
			strCondicion = " AND USUARIO_ASIG = " & intCobrador
		End if
		If Trim(intAbogado) <> "100" and Trim(intAbogado) <> "" Then
			strCondicion = strCondicion & " AND IDDEMANDA IN (SELECT IDDEMANDA FROM DEMANDA WHERE IDABOGADO = " & intAbogado & ")"
		End if
		If Trim(intProcurador) <> "100" and Trim(intProcurador) <> "" Then
			strCondicion = strCondicion & " AND IDDEMANDA IN (SELECT IDDEMANDA FROM DEMANDA WHERE IDPROCURADOR = " & intProcurador & ")"
		End if

		If Trim(intGestion) <> "T" AND Trim(intGestion) <> "R" Then
			strSql="SELECT R.FECHA_ASIGNACION, C.RUTDEUDOR, '' as NUM_CLIENTE, IsNull(SUM(C.SALDO),0) as SALDO, COUNT(C.NRODOC) as CNRODOC , C.TIPOCOB, IsNull(C.IDDEMANDA,0) as IDDEMANDA FROM CUOTA C, REMESA R WHERE C.CODREMESA = R.CODREMESA AND C.CODCLIENTE = R.CODCLIENTE AND IDGJUDICIAL = " & intGestion & " AND C.ESTADO_DEUDA = 1 " & strCondicion & strSqlUsuario & " GROUP BY R.FECHA_ASIGNACION, C.RUTDEUDOR, C.TIPOCOB, C.IDDEMANDA ORDER BY SALDO DESC"
		Else
			If Trim(intGestion) = "T" Then
				strSql="SELECT R.FECHA_ASIGNACION, C.RUTDEUDOR, '' as NUM_CLIENTE, IsNull(SUM(C.SALDO),0) as SALDO, COUNT(C.NRODOC) as CNRODOC, C.TIPOCOB, IsNull(C.IDDEMANDA,0) as IDDEMANDA FROM CUOTA C, REMESA R WHERE C.CODREMESA = R.CODREMESA AND C.CODCLIENTE = R.CODCLIENTE AND C.ESTADO_DEUDA = 1 " & strCondicion & strSqlUsuario & " GROUP BY R.FECHA_ASIGNACION, C.RUTDEUDOR, C.TIPOCOB, C.IDDEMANDA ORDER BY SALDO DESC"
			End If
			If Trim(intGestion) = "R" Then
				strSql="SELECT R.FECHA_ASIGNACION, C.RUTDEUDOR, '' as NUM_CLIENTE, IsNull(SUM(C.SALDO),0) as SALDO, COUNT(C.NRODOC) as CNRODOC, C.TIPOCOB, IsNull(C.IDDEMANDA,0) as IDDEMANDA FROM CUOTA C, REMESA R WHERE C.CODREMESA = R.CODREMESA AND C.CODCLIENTE = R.CODCLIENTE AND C.ESTADO_DEUDA = 2 " & strCondicion & strSqlUsuario & " GROUP BY R.FECHA_ASIGNACION, C.RUTDEUDOR, C.TIPOCOB, C.IDDEMANDA ORDER BY SALDO DESC"
			End If
		End If
		'Response.write "strSql = " & strSql
		'Response.End
		set rsGTC= Conn.execute(strSql)
		if not rsGTC.eof then
			intConRegistros="S"

		%>


		<tr bgcolor="#<%=session("COLTABBG")%>" class="Estilo13">

		      	<% If Trim(intGestion)= "1" Then %>
					<td width="30">Fecha Asign.</td>
					<td width="25">Id Deudor</td>
					<td width="25">Rut</td>
					<td width="150">Nombre o Razon Social</td>
					<td width="50">Probabilidad de Cobro</td>
					<td width="100">Cobranza</td>
					<td width="20">Cuantía</td>
					<td width="20">Recaudado</td>
				<% End if %>
				<% If Trim(intGestion)= "2" or Trim(intGestion)= "3" or Trim(intGestion)= "4" Then %>
					<td width="50">Fecha Asign.</td>
					<td width="50">Id Deudor</td>
					<td width="50">Rut</td>
					<td width="120">Nombre o Razon Social</td>
					<td width="50">Probabilidad de Cobro</td>
					<td width="50">Cuantia</td>
					<td width="50">Recaudado</td>
					<td width="150">Dirección</td>
					<td width="50">Teléfono</td>
				<% End if %>

				<% If Trim(intGestion)= "5" Then %>
					<td width="25">Id Deudor</td>
					<td width="25">Rut</td>
					<td width="150">Nombre o Razon Social</td>
					<td width="50">Probabilidad de Cobro</td>
					<td width="60">Tribunal</td>
					<td width="40">Rol - Año</td>
					<td width="25">F.Ingreso</td>
					<td width="40">Procurador</td>
					<td width="40">Abogado</td>
					<td width="30">Cuantia</td>
					<td width="30">Recaudado</td>
					<td width="30">Monto Demanda</td>
					<td width="30">A Pagar</td>
				<% End if %>

				<% If Trim(intGestion)= "6" Then %>
					<td width="25">Id Deudor</td>
					<td width="25">Rut</td>
					<td width="150">Nombre o Razon Social</td>
					<td width="50">Probabilidad de Cobro</td>
					<td width="60">Tribunal</td>
					<td width="40">Rol - Año</td>
					<td width="15">F.Ingreso</td>
					<td width="40">Procurador</td>
					<td width="40">Abogado</td>
					<td width="40">Actuario</td>
					<td width="20">Cuantia</td>
					<td width="20">Recaudado</td>
					<td width="20">Monto Demanda</td>
					<td width="20">A Pagar</td>
				<% End if %>
				<% If Trim(intGestion)= "7" or Trim(intGestion)= "8" Then %>
					<td width="25">Id Deudor</td>
					<td width="25">Rut</td>
					<td width="150">Nombre o Razon Social</td>
					<td width="50">Probabilidad de Cobro</td>
					<td width="60">Tribunal</td>
					<td width="40">Rol - Año</td>
					<td width="15">F.Ingreso</td>
					<td width="40">Procurador</td>
					<td width="40">Abogado</td>
					<td width="40">Actuario</td>
					<td width="20">Cuantia</td>
					<td width="20">Recaudado</td>
					<td width="20">Monto Demanda</td>
					<td width="20">Gastos Judiciales</td>
					<td width="20">A Pagar</td>
				<% End if %>
				<% If Trim(intGestion)= "9" Then %>
					<td width="25">Id Deudor</td>
					<td width="25">Rut</td>
					<td width="150">Nombre o Razon Social</td>
					<td width="50">Probabilidad de Cobro</td>
					<td width="60">Tribunal</td>
					<td width="40">Rol - Año</td>
					<td width="15">F.Comparendo</td>
					<td width="40">Procurador</td>
					<td width="40">Abogado</td>
					<td width="40">Actuario</td>
					<td width="20">Cuantia</td>
					<td width="20">Recaudado</td>
					<td width="20">Monto Demanda</td>
					<td width="20">Gastos Judiciales</td>
					<td width="20">A Pagar</td>
				<% End if %>
				<% If Trim(intGestion)= "10" or Trim(intGestion)= "11" or Trim(intGestion)= "T" or Trim(intGestion)= "R" Then %>
					<td width="25">Id Deudor</td>
					<td width="25">Rut</td>
					<td width="150">Nombre o Razon Social</td>
					<td width="50">Probabilidad de Cobro</td>
					<td width="60">Tribunal</td>
					<td width="40">Rol - Año</td>
					<td width="15">Fallo</td>
					<td width="40">Procurador</td>
					<td width="40">Abogado</td>
					<td width="40">Actuario</td>
					<td width="20">Cuantia</td>
					<td width="20">Recaudado</td>
					<td width="20">Monto Demanda</td>
					<td width="20">Gastos Judiciales</td>
					<td width="20">A Pagar</td>
				<% End if %>
				<% If Trim(intGestion)= "12" or Trim(intGestion)= "13" Then %>
					<td width="25">Id Deudor</td>
					<td width="25">Rut</td>
					<td width="150">Nombre o Razon Social</td>
					<td width="50">Probabilidad de Cobro</td>
					<td width="60">Tribunal</td>
					<td width="40">Rol - Año</td>
					<td width="40">Procurador</td>
					<td width="40">Abogado</td>
					<td width="20">Cuantia</td>
					<td width="20">Recaudado</td>
					<td width="20">Monto Demanda</td>
					<td width="20">Gastos Judiciales</td>
					<td width="20">A Pagar</td>
				<% End if %>

      </tr>

   	<%

		''Response.End
			Do until rsGTC.eof
				strFechaAsig = rsGTC("FECHA_ASIGNACION")
				strIdDeudor = rsGTC("NUM_CLIENTE")
				strRutDeudor = rsGTC("RUTDEUDOR")
				strCuantia = rsGTC("SALDO")
				strNombre = Mid(TraeCampoId2 (Conn, "NOMBREDEUDOR", Trim(rsGTC("RUTDEUDOR")), "DEUDOR", "RUTDEUDOR"),1,40)

				''strSql="SELECT PROB_COBRO, HONORARIOS FROM CUOTA_ENC WHERE RUTDEUDOR='" & rut_deudor &"' AND CODCLIENTE = " & intCodCliente & " AND IDCUOTA_ENC = " & intCuotaEnc
				strSql="SELECT PROB_COBRO, HONORARIOS FROM CUOTA_ENC WHERE RUTDEUDOR='" & strRutDeudor &"' AND CODCLIENTE = " & cliente
				'Response.write "strSql=" & strSql
				'Response.End
				set rsCuotaEnc=Conn.execute(strSql)
				if not rsCuotaEnc.eof then
					strProbabilidad = rsCuotaEnc("PROB_COBRO")
				else
					strProbabilidad = ""
				end if
				rsCuotaEnc.close
				set rsCuotaEnc=nothing


				strCobranza = rsGTC("TIPOCOB")
				strRecaudado = 0' strCuantia / 2
				strDireccion = Mid (TraeCampoSeleccionado (Conn, "DIRECCION", "SELECT TOP 1 IsNull(CALLE,'') + ' ' + IsNull(NUMERO,'') + ' ' + IsNull(RESTO,'') + ' ' + COMUNA as DIRECCION FROM DEUDOR_DIRECCION WHERE RUTDEUDOR = '" & strRutDeudor & "' AND ESTADO IN (1 ,0) ORDER BY ESTADO, FECHAINGRESO DESC"),1,50)
				strTelefono = TraeCampoSeleccionado (Conn, "TELEFONO", "SELECT TOP 1 CAST(CODAREA AS VARCHAR(3))+ '-' + CAST(TELEFONO AS VARCHAR(15)) AS TELEFONO  FROM DEUDOR_TELEFONO WHERE RUTDEUDOR = '" & strRutDeudor & "' AND ESTADO IN (1 ,0) ORDER BY ESTADO, FECHAINGRESO DESC")

				ssql="SELECT IsNull(MONTO,0) as MONTO, FECHA_INGRESO, ROLANO, IDTRIBUNAL, IsNull(IDPROCURADOR,0) AS IDPROCURADOR , IsNull(IDABOGADO,0) AS IDABOGADO, IsNull(IDACTUARIO,0) AS IDACTUARIO , GASTOS_JUDICIALES , FECHA_COMPARENDO, FALLO FROM DEMANDA WHERE IDDEMANDA = " & rsGTC("IDDEMANDA")
				set rsDemanda= Conn.execute(ssql)
				If not rsDemanda.eof Then
					strMontoDemanda = rsDemanda("MONTO")
					strTribunal = TraeCampoId(Conn, "NOMTRIBUNAL", rsDemanda("IDTRIBUNAL"), "TRIBUNAL", "IDTRIBUNAL")

					strFechaIngreso = rsDemanda("FECHA_INGRESO")
					strRolAno = rsDemanda("ROLANO")
					strProcurador = TraeCampoId(Conn, "NOMPROCURADOR", rsDemanda("IDPROCURADOR"), "PROCURADOR", "IDPROCURADOR")
					strAbogado = TraeCampoId(Conn, "NOMABOGADO", rsDemanda("IDABOGADO"), "ABOGADO", "IDABOGADO")
					strActuario = TraeCampoId(Conn, "NOMACTUARIO", rsDemanda("IDACTUARIO"), "ACTUARIO", "IDACTUARIO")
					intGastosJudiciales = rsDemanda("GASTOS_JUDICIALES")
					strFechaComparendo = rsDemanda("FECHA_COMPARENDO")
					strFallo = rsDemanda("FALLO")
				Else
					strMontoDemanda = "0"
					strTribunal = "&nbsp"
					strFechaIngreso = "&nbsp"
					strRolAno = "&nbsp"
					strProcurador = "&nbsp"
					strAbogado = "&nbsp"
					strActuario = "&nbsp"
					intGastosJudiciales = 0
					strFechaComparendo = "&nbsp"
					strFallo = "&nbsp"
				End if
				rsDemanda.close
				set rsDemanda=nothing

				strAPagar = 0
				strTotalCuantia = strTotalCuantia + strCuantia
				strTotalRecaudado = strTotalRecaudado + strRecaudado
				strTotalMontoDemanda = strTotalMontoDemanda + strMontoDemanda
				strTotalGastosJudiciales = strTotalGastosJudiciales + intGastosJudiciales
				strTotalApagar = strTotalApagar + strAPagar

				%>
				<tr>
				<%
				If Trim(intGestion)= "1" Then
				strColsPan = 6
				%>
					<td><%=strFechaAsig%></td>
					<td><%=strIdDeudor%></td>
					<td>
						<A HREF="principal.asp?rut=<%=strRutDeudor%>">
							<acronym title="Llevar a pantalla de selección"><%=strRutDeudor%></acronym>
						</A>
					</td>
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
					<td>
						<A HREF="principal.asp?rut=<%=strRutDeudor%>">
							<acronym title="Llevar a pantalla de selección"><%=strRutDeudor%></acronym>
						</A>
					</td>
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
					<td>
						<A HREF="principal.asp?rut=<%=strRutDeudor%>">
							<acronym title="Llevar a pantalla de selección"><%=strRutDeudor%></acronym>
						</A>
					</td>
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

				<% If Trim(intGestion)= "6" Then
				strColsPan = 10
				%>
					<td><%=strIdDeudor%></td>
					<td>
					<A HREF="principal.asp?rut=<%=strRutDeudor%>">
						<acronym title="Llevar a pantalla de selección"><%=strRutDeudor%></acronym>
					</A>
					</td>
					<td><%=strNombre%></td>
					<td><%=strProbabilidad%></td>
					<td><%=strTribunal%></td>
					<td><%=strRolAno%></td>
					<td><%=strFechaIngreso%></td>
					<td><%=strProcurador%></td>
					<td><%=strAbogado%></td>
					<td><%=strActuario%></td>
					<td ALIGN="RIGHT"><%=FN(strCuantia,0)%></td>
					<td ALIGN="RIGHT"><%=FN(strRecaudado,0)%></td>
					<td ALIGN="RIGHT"><%=FN(strMontoDemanda,0)%></td>
					<td ALIGN="RIGHT"><%=FN(strApagar,0)%></td>
				<% End if %>

				<% If Trim(intGestion)= "7" or Trim(intGestion)= "8" Then
				strColsPan = 10
				%>
					<td><%=strIdDeudor%></td>
					<td>
						<A HREF="principal.asp?rut=<%=strRutDeudor%>">
							<acronym title="Llevar a pantalla de selección"><%=strRutDeudor%></acronym>
						</A>
					</td>
					<td><%=strNombre%></td>
					<td><%=strProbabilidad%></td>
					<td><%=strTribunal%></td>
					<td><%=strRolAno%></td>
					<td><%=strFechaIngreso%></td>
					<td><%=strProcurador%></td>
					<td><%=strAbogado%></td>
					<td><%=strActuario%></td>
					<td ALIGN="RIGHT"><%=FN(strCuantia,0)%></td>
					<td ALIGN="RIGHT"><%=FN(strRecaudado,0)%></td>
					<td ALIGN="RIGHT"><%=FN(strMontoDemanda,0)%></td>
					<td ALIGN="RIGHT"><%=FN(intGastosJudiciales,0)%></td>
					<td ALIGN="RIGHT"><%=FN(strApagar,0)%></td>
				<% End if %>



				<% If Trim(intGestion)= "9" Then
				strColsPan = 10
				%>
					<td><%=strIdDeudor%></td>
					<td>
						<A HREF="principal.asp?rut=<%=strRutDeudor%>">
							<acronym title="Llevar a pantalla de selección"><%=strRutDeudor%></acronym>
						</A>
					</td>
					<td><%=strNombre%></td>
					<td><%=strProbabilidad%></td>
					<td><%=strTribunal%></td>
					<td><%=strRolAno%></td>
					<td><%=strFechaComparendo%></td>
					<td><%=strProcurador%></td>
					<td><%=strAbogado%></td>
					<td><%=strActuario%></td>
					<td ALIGN="RIGHT"><%=FN(strCuantia,0)%></td>
					<td ALIGN="RIGHT"><%=FN(strRecaudado,0)%></td>
					<td ALIGN="RIGHT"><%=FN(strMontoDemanda,0)%></td>
					<td ALIGN="RIGHT"><%=FN(intGastosJudiciales,0)%></td>
					<td ALIGN="RIGHT"><%=FN(strApagar,0)%></td>
				<% End if %>


				<% If Trim(intGestion)= "10" or Trim(intGestion)= "11" or Trim(intGestion)= "T" or Trim(intGestion)= "R" Then
				strColsPan = 10
				%>
					<td><%=strIdDeudor%></td>
					<td>
						<A HREF="principal.asp?rut=<%=strRutDeudor%>">
							<acronym title="Llevar a pantalla de selección"><%=strRutDeudor%></acronym>
						</A>
					</td>
					<td><%=strNombre%></td>
					<td><%=strProbabilidad%></td>
					<td><%=strTribunal%></td>
					<td><%=strRolAno%></td>
					<td><%=strFallo%></td>
					<td><%=strProcurador%></td>
					<td><%=strAbogado%></td>
					<td><%=strActuario%></td>
					<td ALIGN="RIGHT"><%=FN(strCuantia,0)%></td>
					<td ALIGN="RIGHT"><%=FN(strRecaudado,0)%></td>
					<td ALIGN="RIGHT"><%=FN(strMontoDemanda,0)%></td>
					<td ALIGN="RIGHT"><%=FN(intGastosJudiciales,0)%></td>
					<td ALIGN="RIGHT"><%=FN(strApagar,0)%></td>
				<% End if %>

				<% If Trim(intGestion)= "12" or Trim(intGestion)= "13" Then
				strColsPan = 8
				%>
					<td><%=strIdDeudor%></td>
					<td>
						<A HREF="principal.asp?rut=<%=strRutDeudor%>">
							<acronym title="Llevar a pantalla de selección"><%=strRutDeudor%></acronym>
						</A>
					</td>
					<td><%=strNombre%></td>
					<td><%=strProbabilidad%></td>
					<td><%=strTribunal%></td>
					<td><%=strRolAno%></td>
					<td><%=strProcurador%></td>
					<td><%=strAbogado%></td>
					<td ALIGN="RIGHT"><%=FN(strCuantia,0)%></td>
					<td ALIGN="RIGHT"><%=FN(strRecaudado,0)%></td>
					<td ALIGN="RIGHT"><%=FN(strMontoDemanda,0)%></td>
					<td ALIGN="RIGHT"><%=FN(intGastosJudiciales,0)%></td>
					<td ALIGN="RIGHT"><%=FN(strApagar,0)%></td>
				<% End if %>

				<tr>
				<%
				rsGTC.movenext
			loop

		Else
			intConRegistros="N"
		End If
		rsGTC.close
		set rsGTC=nothing
		cerrarscg()


		If intConRegistros="S" then
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
		<% If Trim(intGestion)= "6" Then %>
			<td ALIGN="RIGHT"><%=FN(strTotalCuantia,0)%></td>
			<td ALIGN="RIGHT"><%=FN(strTotalRecaudado,0)%></td>
			<td ALIGN="RIGHT"><%=FN(strTotalMontoDemanda,0)%></td>
			<td ALIGN="RIGHT"><%=FN(strTotalApagar,0)%></td>
		<% End If%>
		<% If Trim(intGestion)= "7" or Trim(intGestion)= "8" or Trim(intGestion)= "9" or Trim(intGestion)= "10" or Trim(intGestion)= "11" or Trim(intGestion)= "T" or Trim(intGestion)= "R" Then %>
			<td ALIGN="RIGHT"><%=FN(strTotalCuantia,0)%></td>
			<td ALIGN="RIGHT"><%=FN(strTotalRecaudado,0)%></td>
			<td ALIGN="RIGHT"><%=FN(strTotalMontoDemanda,0)%></td>
			<td ALIGN="RIGHT"><%=FN(strTotalGastosJudiciales,0)%></td>
			<td ALIGN="RIGHT"><%=FN(strTotalApagar,0)%></td>
		<% End If%>
		<% If Trim(intGestion)= "12" or Trim(intGestion)= "13" Then %>
			<td ALIGN="RIGHT"><%=FN(strTotalCuantia,0)%></td>
			<td ALIGN="RIGHT"><%=FN(strTotalRecaudado,0)%></td>
			<td ALIGN="RIGHT"><%=FN(strTotalMontoDemanda,0)%></td>
			<td ALIGN="RIGHT"><%=FN(strTotalGastosJudiciales,0)%></td>
			<td ALIGN="RIGHT"><%=FN(strTotalApagar,0)%></td>
		<% End If%>
      </tr>
      <% Else %>
      <tr>
      	<td colspan="<%=strColsPan%>" ALIGN="CENTER">Seleccion No Arrojó resultados</td>
	  </tr>


      <% End if %>
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
	if (datos.CB_CLIENTE.value=='0'){
		alert('DEBE SELECCIONAR UN CLIENTE');
	}else{
		datos.action='informe_estatus_xls.asp';
		datos.submit();
	}
}
</script>
