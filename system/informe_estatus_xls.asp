<% @LCID = 1034 %>
<!--#include file="arch_utils.asp"-->
<!--#include file="../lib/comunes/rutinas/funciones.inc" -->
<!--#include file="../lib/comunes/rutinas/funcionesBD.inc" -->
<!--#include file="../lib/comunes/rutinas/TraeCampo.inc" -->

<%

inicio= request("inicio")
termino= request("termino")
cliente = request("CB_CLIENTE")
intGestion = request("intGestion")
intDePPal = request("intDePPal")

intCobrador = request("CB_COBRADOR")
intProcurador = request("CB_PROCURADOR")
intAbogado = request("CB_ABOGADO")

If Trim(intGestion) <> "T" Then
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

Response.Charset = "UTF-8"
Response.ContentType = "application/vnd.ms-excel"
Response.AddHeader "Content-Disposition", "attachment; filename=" & archivo

'Response.ContentType = "application/vnd.ms-excel"
'Response.Expires = -1500
'Response.ExpiresAbsolute = Now() - 1
'Response.AddHeader "pragma","no-cache"
'Response.AddHeader "cache-control","private"
'Response.AddHeader "Content-Disposition", "inline; filename=XXXXX.csv"
'Response.CacheControl = "no-cache"
'Response.Buffer = True
'Response.Write sFILE
'Response.flush


%>
<title>Estatus Cartera</title>
	<%
	IF cliente <> "" or Trim(intDePPal) <> "" then
	%>
	<table border=1>
      <tr>
      	<% If Trim(intGestion)= "1" Then %>
			<td>Fecha Asign.</td>
			<td>Id Deudor</td>
			<td>Rut</td>
			<td>Nombre o Razon Social</td>
			<td>Probabilidad de Cobro</td>
			<td>Cobranza</td>
			<td>Cuantía</td>
			<td>Recaudado</td>
		<% End if %>
		<% If Trim(intGestion)= "2" or Trim(intGestion)= "3" or Trim(intGestion)= "4" Then %>
			<td>Fecha Asign.</td>
			<td>Id Deudor</td>
			<td>Rut</td>
			<td>Nombre o Razon Social</td>
			<td>Probabilidad de Cobro</td>
			<td>Cuantia</td>
			<td>Recaudado</td>
			<td>Dirección</td>
			<td>Teléfono</td>
		<% End if %>

		<% If Trim(intGestion)= "5" Then %>
			<td>Id Deudor</td>
			<td>Rut</td>
			<td>Nombre o Razon Social</td>
			<td>Probabilidad de Cobro</td>
			<td>Tribunal</td>
			<td>Rol - Año</td>
			<td>F.Ingreso</td>
			<td>Procurador</td>
			<td>Abogado</td>
			<td>Cuantia</td>
			<td>Recaudado</td>
			<td>Monto Demanda</td>
			<td>A Pagar</td>
		<% End if %>

		<% If Trim(intGestion)= "6" Then %>
			<td>Id Deudor</td>
			<td>Rut</td>
			<td>Nombre o Razon Social</td>
			<td>Probabilidad de Cobro</td>
			<td>Tribunal</td>
			<td>Rol - Año</td>
			<td>F.Ingreso</td>
			<td>Procurador</td>
			<td>Abogado</td>
			<td>Actuario</td>
			<td>Cuantia</td>
			<td>Recaudado</td>
			<td>Monto Demanda</td>
			<td>A Pagar</td>
		<% End if %>
		<% If Trim(intGestion)= "7" or Trim(intGestion)= "8" Then %>
			<td>Id Deudor</td>
			<td>Rut</td>
			<td>Nombre o Razon Social</td>
			<td>Probabilidad de Cobro</td>
			<td>Tribunal</td>
			<td>Rol - Año</td>
			<td>F.Ingreso</td>
			<td>Procurador</td>
			<td>Abogado</td>
			<td>Actuario</td>
			<td>Cuantia</td>
			<td>Recaudado</td>
			<td>Monto Demanda</td>
			<td>Gastos Judiciales</td>
			<td>A Pagar</td>
		<% End if %>
		<% If Trim(intGestion)= "9" Then %>
			<td>Id Deudor</td>
			<td>Rut</td>
			<td>Nombre o Razon Social</td>
			<td>Probabilidad de Cobro</td>
			<td>Tribunal</td>
			<td>Rol - Año</td>
			<td>F.Comparendo</td>
			<td>Procurador</td>
			<td>Abogado</td>
			<td>Actuario</td>
			<td>Cuantia</td>
			<td>Recaudado</td>
			<td>Monto Demanda</td>
			<td>Gastos Judiciales</td>
			<td>A Pagar</td>
		<% End if %>
		<% If Trim(intGestion)= "10" or Trim(intGestion)= "11" or Trim(intGestion)= "T" Then %>
			<td>Id Deudor</td>
			<td>Rut</td>
			<td>Nombre o Razon Social</td>
			<td>Probabilidad de Cobro</td>
			<td>Tribunal</td>
			<td>Rol - Año</td>
			<td>Fallo</td>
			<td>Procurador</td>
			<td>Abogado</td>
			<td>Actuario</td>
			<td>Cuantia</td>
			<td>Recaudado</td>
			<td>Monto Demanda</td>
			<td>Gastos Judiciales</td>
			<td>A Pagar</td>
		<% End if %>
		<% If Trim(intGestion)= "12" or Trim(intGestion)= "13" Then %>
			<td>Id Deudor</td>
			<td>Rut</td>
			<td>Nombre o Razon Social</td>
			<td>Probabilidad de Cobro</td>
			<td>Tribunal</td>
			<td>Rol - Año</td>
			<td>Procurador</td>
			<td>Abogado</td>
			<td>Cuantia</td>
			<td>Recaudado</td>
			<td>Monto Demanda</td>
			<td>Gastos Judiciales</td>
			<td>A Pagar</td>
		<% End if %>

      </tr>
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

		If Trim(intGestion) <> "T" Then
			strSql="SELECT R.FECHA_ASIGNACION, C.RUTDEUDOR, IsNull(C.NUM_CLIENTE,'&nbsp') as NUM_CLIENTE, IsNull(C.SALDO,0) as SALDO, C.TIPOCOB, IsNull(C.IDDEMANDA,0) as IDDEMANDA FROM CUOTA C, REMESA R WHERE C.CODREMESA = R.CODREMESA AND C.CODCLIENTE = R.CODCLIENTE AND IDGJUDICIAL = " & intGestion & " AND C.ESTADO_DEUDA = 1 " & strCondicion & " ORDER BY SALDO DESC"
		Else
			strSql="SELECT R.FECHA_ASIGNACION, C.RUTDEUDOR, IsNull(C.NUM_CLIENTE,'&nbsp') as NUM_CLIENTE, IsNull(C.SALDO,0) as SALDO, C.TIPOCOB, IsNull(C.IDDEMANDA,0) as IDDEMANDA FROM CUOTA C, REMESA R WHERE C.CODREMESA = R.CODREMESA AND C.CODCLIENTE = R.CODCLIENTE AND C.ESTADO_DEUDA = 1 " & strCondicion & " ORDER BY SALDO DESC"
		End If
		'Response.End
		set rsGTC= Conn.execute(strSql)
		if not rsGTC.eof then
			Do until rsGTC.eof
				strFechaAsig = rsGTC("FECHA_ASIGNACION")
				strIdDeudor = rsGTC("NUM_CLIENTE")
				strRutDeudor = rsGTC("RUTDEUDOR")
				strCuantia = rsGTC("SALDO")
				strNombre = TraeCampoId2(Conn, "NOMBREDEUDOR", Trim(rsGTC("RUTDEUDOR")), "DEUDOR", "RUTDEUDOR")
				strProbabilidad = "&nbsp"
				strCobranza = rsGTC("TIPOCOB")
				strRecaudado = strCuantia / 2
				strDireccion = "&nbsp"
				strTelefono = "&nbsp"

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
					<td><%=strRutDeudor%></td>
					<td><%=strNombre%></td>
					<td><%=strProbabilidad%></td>
					<td><%=strCobranza%></td>
					<td><%=FN(strCuantia,0)%></td>
					<td><%=FN(strRecaudado,0)%></td>
				<% End if %>
				<% If Trim(intGestion)= "2" or Trim(intGestion)= "3" or Trim(intGestion)= "4" Then
				strColsPan = 5
				%>
					<td><%=strFechaAsig%></td>
					<td><%=strIdDeudor%></td>
					<td><%=strRutDeudor%></td>
					<td><%=strNombre%></td>
					<td><%=strProbabilidad%></td>
					<td><%=FN(strCuantia,0)%></td>
					<td><%=FN(strRecaudado,0)%></td>
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
					<td><%=FN(strCuantia,0)%></td>
					<td><%=FN(strRecaudado,0)%></td>
					<td><%=FN(strMontoDemanda,0)%></td>
					<td><%=FN(strApagar,0)%></td>
				<% End if %>

				<% If Trim(intGestion)= "6" Then
				strColsPan = 10
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
					<td><%=strActuario%></td>
					<td><%=FN(strCuantia,0)%></td>
					<td><%=FN(strRecaudado,0)%></td>
					<td><%=FN(strMontoDemanda,0)%></td>
					<td><%=FN(strApagar,0)%></td>
				<% End if %>

				<% If Trim(intGestion)= "7" or Trim(intGestion)= "8" Then
				strColsPan = 10
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
					<td><%=strActuario%></td>
					<td><%=FN(strCuantia,0)%></td>
					<td><%=FN(strRecaudado,0)%></td>
					<td><%=FN(strMontoDemanda,0)%></td>
					<td><%=FN(intGastosJudiciales,0)%></td>
					<td><%=FN(strApagar,0)%></td>
				<% End if %>



				<% If Trim(intGestion)= "9" Then
				strColsPan = 10
				%>
					<td><%=strIdDeudor%></td>
					<td><%=strRutDeudor%></td>
					<td><%=strNombre%></td>
					<td><%=strProbabilidad%></td>
					<td><%=strTribunal%></td>
					<td><%=strRolAno%></td>
					<td><%=strFechaComparendo%></td>
					<td><%=strProcurador%></td>
					<td><%=strAbogado%></td>
					<td><%=strActuario%></td>
					<td><%=FN(strCuantia,0)%></td>
					<td><%=FN(strRecaudado,0)%></td>
					<td><%=FN(strMontoDemanda,0)%></td>
					<td><%=FN(intGastosJudiciales,0)%></td>
					<td><%=FN(strApagar,0)%></td>
				<% End if %>


				<% If Trim(intGestion)= "10" or Trim(intGestion)= "11" or Trim(intGestion)= "T" Then
				strColsPan = 10
				%>
					<td><%=strIdDeudor%></td>
					<td><%=strRutDeudor%></td>
					<td><%=strNombre%></td>
					<td><%=strProbabilidad%></td>
					<td><%=strTribunal%></td>
					<td><%=strRolAno%></td>
					<td><%=strFallo%></td>
					<td><%=strProcurador%></td>
					<td><%=strAbogado%></td>
					<td><%=strActuario%></td>
					<td><%=FN(strCuantia,0)%></td>
					<td><%=FN(strRecaudado,0)%></td>
					<td><%=FN(strMontoDemanda,0)%></td>
					<td><%=FN(intGastosJudiciales,0)%></td>
					<td><%=FN(strApagar,0)%></td>
				<% End if %>

				<% If Trim(intGestion)= "12" or Trim(intGestion)= "13" Then
				strColsPan = 8
				%>
					<td><%=strIdDeudor%></td>
					<td><%=strRutDeudor%></td>
					<td><%=strNombre%></td>
					<td><%=strProbabilidad%></td>
					<td><%=strTribunal%></td>
					<td><%=strRolAno%></td>
					<td><%=strProcurador%></td>
					<td><%=strAbogado%></td>
					<td><%=FN(strCuantia,0)%></td>
					<td><%=FN(strRecaudado,0)%></td>
					<td><%=FN(strMontoDemanda,0)%></td>
					<td><%=FN(intGastosJudiciales,0)%></td>
					<td><%=FN(strApagar,0)%></td>
				<% End if %>
				</tr>
				<%
				rsGTC.movenext
			loop
		End If
		rsGTC.close
		set rsGTC=nothing
		cerrarscg()
	%>
    </table>
	<% end if %>



