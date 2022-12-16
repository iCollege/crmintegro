<!--#include file="asp/comunes/odbc/ADOVBS.INC" -->
<!--#include file="arch_utils.asp"-->
<!--#include file="lib.asp"-->
<!--#include file="asp/comunes/odbc/insertUpdate.inc"-->
<!--#include file="../lib/comunes/rutinas/funciones.inc" -->
<!--#include file="../lib/comunes/rutinas/TraeCampo.inc" -->
<!--#include file="asp/comunes/insert/Notificacion.inc"-->
<!--#include file="asp/comunes/general/rutinasBooleano.inc" -->

<script language="JavaScript">
function ventanaSecundaria (URL){
window.open(URL,"DETALLE","width=200, height=200, scrollbars=no, menubar=no, location=no, resizable=no")
}
</script>
<%

	rut = request("rut")
	cliente=request("cliente")
	cliente=session("ses_codcli")

	AbrirSCG()

	strSql = "SELECT COD_GESTION FROM PARAM_GESTION WHERE TIPO = 'FECHA_NOTIF'"
	set rsGest = Conn.execute(strSql )
	strFechaNotif = ""
	Do While not rsGest.eof
		strFechaNotif = strFechaNotif & "," & rsGest("COD_GESTION")
		rsGest.movenext
	Loop

	If Trim(strFechaNotif) <> "" Then strFechaNotif = Mid(strFechaNotif,2,Len(strFechaNotif))


	strSql = "SELECT COD_GESTION FROM PARAM_GESTION WHERE TIPO = 'FECHA_COMPARENDO'"
	set rsGest = Conn.execute(strSql )
	strFechaComparendo = ""
	Do While not rsGest.eof
		strFechaComparendo = strFechaComparendo & "," & rsGest("COD_GESTION")
		rsGest.movenext
	Loop

	If Trim(strFechaComparendo) <> "" Then strFechaComparendo = Mid(strFechaComparendo,2,Len(strFechaComparendo))


	strSql = "SELECT * FROM GESTION_NOTIFICACION WHERE CODCLIENTE = '" & cliente & "'"
	set rsGest = Conn.execute(strSql )
	strGestionNotif = ""
	Do While not rsGest.eof
		strGestionNotif = strGestionNotif & "," & rsGest("CODCATEGORIA")
		rsGest.movenext
	Loop

	If Trim(strGestionNotif) <> "" Then strGestionNotif = Mid(strGestionNotif,2,Len(strGestionNotif))




	if rut = "" then
		rut=request("rut_")
		cliente=request("cliente_")
		idGestionJudicial=request("CB_GESTIONJUDICIAL")
		idDemanda=request("CB_DEMANDA")
		idReceptor=request("CB_RECEPTOR")
		dtmFechaNotif=request("fecha1")
		dtmFechaComparendo=request("fecha2")
		idRemesa=request("CB_REMESA")
		strObservaciones=request("TX_OBSERVACIONES")
		strPatentes=request("TX_PATENTES")
		intValor=ValNulo(request("TX_VALOR"),"N")

		idCategoria=request("cmbcat")
		idSubCategoria=request("cmbsubcat")
		idGestion=request("cmbgest")
		if rut<>"" then
			ssql2="SELECT MAX(Correlativo)+1 AS CORRELATIVO FROM GESTIONES_NUEVAS_JUDICIAL WHERE RUTDEUDOR='" & rut & "' AND CODCLIENTE = '"& cliente &"'"
			set rsCOR = Conn.execute(ssql2)
			if not rsCOR.eof then
				correlativo=rsCOR("CORRELATIVO")
				if isNULL(rsCOR("CORRELATIVO")) THEN
					correlativo= "1"
				end if
			else
				correlativo= "1"
			end if
			rsCOR.close
			set rsCOR=nothing


			strSql="INSERT INTO GESTIONES_NUEVAS_JUDICIAL ( RUTDEUDOR, CODCLIENTE, CORRELATIVO,CODCATEGORIA, CODSUBCATEGORIA, CODGESTION, FECHAINGRESO,HORAINGRESO,IDUSUARIO,OBSERVACIONES,IDDEMANDA,IDRECEPTOR, FECHANOTIFICACION, FECHACOMPARENDO, PATENTES, VALOR) "
			strSql= strSql & "VALUES ('" & rut & "','" & cliente & "'," & correlativo & "," & idCategoria & "," & idSubCategoria & "," & idGestion & ",getdate(), '" & Mid(time,1,8) & "','" & session("session_idusuario") &"','" & UCASE(strObservaciones) & "'," & idDemanda & "," & idReceptor & ",'" & dtmFechaNotif & "','" & dtmFechaComparendo & "','" & strPatentes & "'," & intValor & ")"
			'response.write(strSql)
			'response.End()
			Conn.execute(strSql)

			strSql="SELECT MAX(IDGESTION) AS IDGESTIONEMPRESA FROM GESTIONES_NUEVAS_JUDICIAL WHERE RUTDEUDOR = '" & rut & "' AND CODCLIENTE = '" & cliente & "' AND CORRELATIVO = " & correlativo & " AND IDUSUARIO = " & session("session_idusuario")
			set rsMaxIGE = Conn.execute(strSql)
			If not rsMaxIGE.eof then
				intIdGestionEmpresa = rsMaxIGE("IDGESTIONEMPRESA")
			Else
				intIdGestionEmpresa= "1"
			End if

			idGestionCliente=request("cmbgestcliente")

			If trim(idGestionCliente) <> "X" Then

			strSql="INSERT INTO GESTIONES_JUDICIALES_CLIENTE ( RUTDEUDOR, CODCLIENTE, CORRELATIVO,CODGESTION, FECHAINGRESO,HORAINGRESO,IDUSUARIO,OBSERVACIONES, IDGESTIONEMPRESA) "
			strSql= strSql & "VALUES ('" & rut & "','" & cliente & "'," & correlativo & "," & idGestionCliente & ",getdate(), '" &  Mid(time,1,8) & "','" & session("session_idusuario") &"','" & UCASE(strObservaciones) & "'," & intIdGestionEmpresa & ")"
			'response.write(strSql)
			'response.End()
			Conn.execute(strSql)

			End if

			intIdEstadoNotif = "0"
			strSql = "SELECT IDNOTIFICACION FROM GESTION_NOTIFICACION WHERE CODCLIENTE = '" & cliente & "' AND CODCATEGORIA = " & idCategoria & " AND CODSUBCATEGORIA = " & idSubCategoria & " AND CODGESTION = " & idGestion
			set rsGest = Conn.execute(strSql)
			If Not rsGest.Eof Then
				intIdEstadoNotif = rsGest("IDNOTIFICACION")
			Else
				intIdEstadoNotif = "0"
			End If

			If Trim(intIdEstadoNotif) <> "0" and Trim(intIdEstadoNotif) <> "" Then

				strSql="SELECT MAX(IDNOTIFICACION)+1 AS IDNOTIFICACION FROM DEMANDA_NOTIF WHERE IDDEMANDA = " & idDemanda
				set rsCOR = Conn.execute(strSql)
				If not rsCOR.eof then
					IntIdNotificacion = rsCOR("IDNOTIFICACION")
					if isNULL(IntIdNotificacion) THEN
						IntIdNotificacion= "1"
					end if
				Else
					IntIdNotificacion= "1"
				End if

				strNuevo = "1"

				Set dicNotificacion = CreateObject("Scripting.Dictionary")
				dicNotificacion.Add "IDDEMANDA", idDemanda
				dicNotificacion.Add "IDNOTIFICACION", IntIdNotificacion
				dicNotificacion.Add "IDUSUARIO", session("session_idusuario")
				dicNotificacion.Add "FECHA", ValNulo(dtmFechaNotif,"C")
				dicNotificacion.Add "BOLETA", ValNulo(strBoletas,"C")
				dicNotificacion.Add "PATENTE", ValNulo(strPatentes,"C")
				dicNotificacion.Add "OBSERVACIONES", ValNulo(UCASE(strObservaciones),"C")
				dicNotificacion.Add "VALOR", ValNulo(intValor,"N")
				dicNotificacion.Add "IDESTADONOTIF", ValNulo(intIdEstadoNotif,"N")

				insert_Notificacion Conn, dicNotificacion

			End if

			strSql = "UPDATE CUOTA SET IDGJUDICIAL = " & idGestionJudicial
			strSql = strSql & " WHERE RUTDEUDOR = '" & rut & "' AND CODREMESA = " & idRemesa & " AND CODCLIENTE = '" & cliente & "'"
			'response.write(strSql)
			'response.End()
			'Conn.execute(strSql)
		end if


	end if

	CerrarSCG()

	AbrirSCG()
	ssql=""
	ssql="SELECT RAZON_SOCIAL FROM CLIENTE WHERE CODCLIENTE='"&cliente&"'"
	set rsCLI=Conn.execute(ssql)
	if not rsCLI.eof then
		nombre_cliente=rsCLI("RAZON_SOCIAL")
	end if
	rsCLI.close
	set rsCLI=nothing
	CerrarSCG()
	%>
<title>INGRESO DE GESTIONES JUDICIALES</title>
<style type="text/css">
<!--
.Estilo33 {color: #FF0000}
.Estilo34 {font-size: xx-small}
.Estilo35 {color: #FFFFFF}
-->
</style>
<form name="datos" method="post">
<table width="740" border="0">
  <tr>
  	<TD width="50%" height="30" ALIGN=LEFT class="pasos">
		<B>Módulo Ingreso de Gestiones Judiciales</B>
	</TD>
    <TD width="50%" height="30" ALIGN=LEFT class="pasos">
		<B><%=nombre_cliente%></B>
	</TD>
  </tr>
 </table>
 <table width="740" height="420" border="0">
  <tr>
    <td height="242" valign="top" background="../images/fondo_coventa.jpg">
      <%

	rut = request("rut")
	cliente=request("cliente")

	if rut="" then
		rut = request("rut_")
		cliente=request("cliente_")
	end if


	AbrirSCG()
	ssql="SELECT TOP 1 NOMBREDEUDOR,RUTDEUDOR FROM DEUDOR WHERE RUTDEUDOR='"& rut &"' AND NOMBREDEUDOR IS NOT NULL AND LTRIM(RTRIM(NOMBREDEUDOR)) <> '' "
	set rsDEU=Conn.execute(ssql)
	if not rsDEU.eof then
		nombre_deudor = rsDEU("NOMBREDEUDOR")
		rut_deudor = rsDEU("RUTDEUDOR")

	else
		rut_deudor = rut
		nombre_deudor = "SIN NOMBRE"
	end if
	rsDEU.close
	set rsDEU=nothing
	CerrarSCG()


	%>
	<table width="100%" border="0" bordercolor="#FFFFFF">
      <tr bordercolor="#999999" bgcolor="#<%=session("COLTABBG")%>" class="Estilo13">
        <td width="31%">RUT</td>
        <td width="50%">NOMBRE O RAZ&Oacute;N SOCIAL </td>
      </tr>
      <tr class="Estilo8">
        <td><%=rut_deudor%></td>
        <td><%=nombre_deudor%></td>
      </tr>
    </table>
			<table width="100%" border="1" bordercolor="#FFFFFF">
				<tr>
				<TD height="20" ALIGN=LEFT class="pasos2_i">
					<B>Gestiones Judiciales Empresa</B>
				</TD>
				</tr>
			</table>
		  	  <%
		  	  If not rut="" then%>
		  	  <input name="rut_" type="hidden" value="<%=rut_deudor%>">
		  	  <input name="cliente_" type="hidden" value="<%=cliente%>">
		  	  <input name="rut_o" type="hidden" value="<%=rut_deudor_o%>">
		  	  <%
		  	  AbrirSCG()
		  	  ssql=""
		  	  strSql = "SELECT TOP 15 REPLACE(C.DESCRIPCION + '-' + S.DESCRIPCION + '-' + E.DESCRIPCION,'-SIN DATOS ADICIONALES','') AS GEST,CONVERT(VARCHAR(10),FECHAINGRESO,103) as FECHAINGRESO1, CONVERT(VARCHAR(10),FECHAINGRESO,108) as HORAINGRESO, IDDEMANDA,IDUSUARIO,CONVERT(VARCHAR(10),FECHACOMPARENDO,103) as FECHACOMPARENDO, CONVERT(VARCHAR(10),FECHANOTIFICACION,103) as FECHANOTIFICACION, OBSERVACIONES, IDRECEPTOR,PATENTES "
		  	  strSql = strSql & " FROM GESTIONES_NUEVAS_JUDICIAL G, GESTIONES_JUDICIAL_CATEGORIA C, GESTIONES_JUDICIAL_SUBCATEGORIA S, GESTIONES_JUDICIAL_GESTION E WHERE G.RUTDEUDOR='" & rut & "' AND G.CODCLIENTE='" & cliente &"' AND G.CODCATEGORIA = C.CODCATEGORIA AND G.CODSUBCATEGORIA = S.CODSUBCATEGORIA AND G.CODGESTION = E.CODGESTION "
		  	  strSql = strSql & " AND C.CODCATEGORIA = E.CODCATEGORIA AND S.CODSUBCATEGORIA = E.CODSUBCATEGORIA AND S.CODCATEGORIA = E.CODCATEGORIA ORDER BY FECHAINGRESO DESC "

		  	  'response.Write(strSql)
		  	  'response.End

		  	  set rsDET=Conn.execute(strSql)
		  	  If not rsDET.eof then
				  %>
				   <table width="100%" border="1" bordercolor="#000000">
					<tr bordercolor="#000000" bgcolor="#<%=session("COLTABBG")%>" class="Estilo13">
						<td width="10%" class="Estilo4">FECHA</td>
						<td width="10%" class="Estilo4">HORA</td>
						<td width="30%" class="Estilo4">GESTION</td>
						<td width="40%" class="Estilo4">OBSERVACIONES</td>
						<td width="10%" class="Estilo4">DEMANDA</td>
						<td width="10%" class="Estilo4">F.NOTIF.</td>
						<td width="10%" class="Estilo4">EJECUTIVO</td>
					</tr>
					<%
					Do until rsDET.eof
						strFNotificacion = rsDET("FECHANOTIFICACION")
						If trim(strFNotificacion) = "01/01/1900" then strFNotificacion=""

						strOtros = strFNotificacion & " " & strFComparendo & " " & strPatentes & " " & strReceptor

						Obs=UCASE(LTRIM(RTRIM(rsDET("Observaciones"))))
						If Obs="" then
							Obs="SIN OBS"
						End if

						strUsuario=TraeCampoId(Conn, "LOGIN", Trim(rsDET("IDUSUARIO")), "USUARIO", "ID_USUARIO")
						strGestion=rsDET("GEST")
						%>
						  <tr bordercolor="#FFFFFF" class="Estilo8">
							<td class="Estilo4"><%=rsDET("FECHAINGRESO1")%></td>
							<td class="Estilo4"><%=rsDET("HORAINGRESO")%></td>
							<td class="Estilo4"><%=strGestion%></td>


							<td class="Estilo4">
							  <acronym title="<%=Obs%>">
								<%=Mid(Obs,1,40)%>
							</acronym>
						  </td>

							<td class="Estilo4"><%=UCASE(rsDET("IDDEMANDA"))%></td>
							<td class="Estilo4"><%=strFNotificacion%></td>
							<td class="Estilo4"><%=UCASE(strUsuario)%></td>


						  </tr>
						   <%rsDET.movenext
					 Loop
					 %>
					</TABLE>
				  <%
		  	  Else
		  		  response.Write("MENSAJE : ")
		  		  response.Write("EL DEUDOR NO POSEE GESTIONES JUDICIALES REGISTRADAS PARA : ")
		  		  response.Write(nombre_cliente)
		  	  End if
		  	  rsDET.close
		  	  set rsDET=nothing
		  	  %>
		  	  <%end if
		  	  CerrarSCG()
	  if not session("session_login")="" then
  	  %>
  	      <TABLE WIDTH="100%" BORDER="1" BORDERCOLOR="#FFFFFF">
	       	<TR>
	  			<TD height="20" ALIGN=LEFT class="pasos2_i">
	  				<B>Nueva Gestión Judicial Empresa</B>
	  			</TD>
	    		</TR>
	  	</TABLE>


	  	<table width="100%" border="0" bordercolor="#FFFFFF">
			<tr bordercolor="#999999" bgcolor="#<%=session("COLTABBG")%>" class="Estilo13">
			  <td width="33%">CATEGORIA</td>
			  <td width="34%">SUBCATEGORIA</td>
			  <td width="33%">ESTATUS</td>
			</tr>
			<tr bordercolor="#999999">
			  <td><select name="cmbcat" id="cmbcat" onChange="cargasubcat(this.value);">
			  <option value="X">SELECCIONE</option>
		<%
			  AbrirSCG()
				strSql="SELECT * FROM GESTIONES_JUDICIAL_CATEGORIA"
				set rsGestCat=Conn.execute(strSql)
				Do While not rsGestCat.eof
		%>
				<option value="<%=rsGestCat("CODCATEGORIA")%>"><%=rsGestCat("CODCATEGORIA")&"-"&rsGestCat("DESCRIPCION")%></option>
		<%
				rsGestCat.movenext
				Loop
				rsGestCat.close
				set rsGestCat=nothing
				CerrarSCG()
				''Response.End
		%>
			  </select></td>
			  <td>
				<select name="cmbsubcat" id="cmbsubcat" onChange="cargagest(this.value,cmbcat.value);">
				<option value="X">SELECCIONE</option>
				</select>
			  </td>

				<td>
					<select name="cmbgest" id="cmbgest" onChange="cajas();">
						<option value="X">SELECCIONE</option>
					</select>
				</td>
			</tr>
        </table>


		<table width="100%" border="0" bordercolor="#FFFFFF">
			<tr bordercolor="#999999" bgcolor="#<%=session("COLTABBG")%>" class="Estilo13">
			   <td>DEMANDA</td>
			   <td>FECHA NOTIF / FALLO</td>
			   <td>RECEPTOR</td>
			   <td>VALOR</td>
			</tr>
			<tr class="Estilo13">
			  <td>
				<select name="CB_DEMANDA">
						<option value="0">SELECCIONE</option>
				<%
						AbrirSCG()
						strSql="SELECT * FROM DEMANDA WHERE RUTDEUDOR = '" & rut & "' AND CODCLIENTE = " & cliente
						set rsDemanda=Conn.execute(strSql)
						Do While not rsDemanda.eof
				%>
						<option value="<%=rsDemanda("IDDEMANDA")%>"> Rol : <%=rsDemanda("ROLANO") & " - " & rsDemanda("FECHA_INGRESO")%></option>
				<%
						rsDemanda.movenext
						Loop
						rsDemanda.close
						set rsDemanda=nothing
						CerrarSCG()
						''Response.End
				%>
				</select>

			 </td>

			 <td><input name="fecha1" type="text" value="" size="10" maxlength="10">
				<a href="javascript:showCal('Calendar9');">
				<img src="../images/calendario.gif" border="0">
				</a>
			</td>
			 <td>
					<select name="CB_RECEPTOR">
							<option value="0">SELECCIONE</option>
					  <%
							AbrirSCG()
							strSql="SELECT IDRECEPTOR,NOM_RECEPTOR, NOMTRIBUNAL FROM RECEPTOR R, TRIBUNAL T WHERE R.IDTRIBUNAL = T.IDTRIBUNAL ORDER BY T.IDTRIBUNAL,NOM_RECEPTOR"
							set rsDemanda=Conn.execute(strSql)
							Do While not rsDemanda.eof
					%>
							<option value="<%=rsDemanda("IDRECEPTOR")%>"> <%=rsDemanda("NOMTRIBUNAL") & "-"& Mid(rsDemanda("NOM_RECEPTOR"),1,20)%></option>
					<%
							rsDemanda.movenext
							Loop
							rsDemanda.close
							set rsDemanda=nothing
							CerrarSCG()
							''Response.End
					%>
					</select>

			 </td>
			<td>
				<input name="TX_VALOR" TYPE="TEXT" VALUE="" SIZE="10" MAXLENGTH="10">
			</td>
			</tr>
        </table>

      <table width="100%" border="0" bordercolor="#FFFFFF">
        <tr bordercolor="#999999" bgcolor="#<%=session("COLTABBG")%>" class="Estilo13" >
          <td width="60%">OBSERVACIONES</td>
          <td width="20%">PATENTES</td>
          <td width="20%">F.COMPARENDO</td>
          <td width="15%">&nbsp</td>
        </tr>
        <tr bordercolor="#999999">
   	       <td><input name="TX_OBSERVACIONES" type="text" size="60" maxlength="200"></td>
   	       <td><input name="TX_PATENTES" type="text" size="15" maxlength="100"></td>
   	       <td><input name="fecha2" type="text" value="" size="10" maxlength="10">
		   		<a href="javascript:showCal('Calendar10');"><img src="../images/calendario.gif" border="0"></a>
			</td>
   	       <td>
   	       <% If TraeSiNo(session("perfil_emp")) <> "Si" Then %>
   	       <input name="ingresar" type="button" onClick="nueva();" value="Ingresar">
   	       <% End If %>
   	       </td>
        </tr>
      </table>


		<table width="100%" border="1" bordercolor="#FFFFFF">
				<tr>
				<TD height="20" ALIGN=LEFT class="pasos2_i">
					<B>Gestiones Judiciales Cliente</B>
				</TD>
				</tr>
		</table>

		<%
			  AbrirSCG()
			  ssql=""
			  strSql = "SELECT TOP 15 D.NOMGESTION AS GEST,CONVERT(VARCHAR(10),FECHAINGRESO,103) as FECHAINGRESO1, CONVERT(VARCHAR(10),FECHAINGRESO,108) as HORAINGRESO, IDDEMANDA,IDUSUARIO, OBSERVACIONES "
			  strSql = strSql & " FROM GESTIONES_JUDICIALES_CLIENTE G, GESTIONES_JUDICIAL_CLIENTE D WHERE G.RUTDEUDOR='" & rut & "' AND G.CODCLIENTE='" & cliente &"' AND G.CODGESTION = D.CODGESTION AND G.CODCLIENTE = D.CODCLIENTE "
			  strSql = strSql & " ORDER BY FECHAINGRESO DESC "

			  'response.Write(strSql)
			  'response.End

			  set rsDET=Conn.execute(strSql)
			  If not rsDET.eof then
				  %>
				   <table width="100%" border="1" bordercolor="#000000">
					<tr bordercolor="#000000" bgcolor="#<%=session("COLTABBG")%>" class="Estilo13">
						<td width="10%" class="Estilo4">FECHA</td>
						<td width="10%" class="Estilo4">HORA</td>
						<td width="30%" class="Estilo4">GESTION</td>
						<td width="40%" class="Estilo4">OBSERVACIONES</td>
						<td width="10%" class="Estilo4">EJECUTIVO</td>
					</tr>
					<%
					Do until rsDET.eof

						Obs=UCASE(LTRIM(RTRIM(rsDET("Observaciones"))))
						If Obs="" then
							Obs="SIN OBS"
						End if

						strUsuario=TraeCampoId(Conn, "LOGIN", Trim(rsDET("IDUSUARIO")), "USUARIO", "ID_USUARIO")
						strGestion=rsDET("GEST")
						%>
						  <tr bordercolor="#FFFFFF" class="Estilo8">
							<td class="Estilo4"><%=rsDET("FECHAINGRESO1")%></td>
							<td class="Estilo4"><%=rsDET("HORAINGRESO")%></td>
							<td class="Estilo4"><%=strGestion%></td>


							<td class="Estilo4">
							  <acronym title="<%=Obs%>">
								<%=Mid(Obs,1,40)%>
							</acronym>
						  </td>

							<td class="Estilo4"><%=UCASE(strUsuario)%></td>


						  </tr>
						   <%rsDET.movenext
					 Loop
					 %>
					</TABLE>
				  <%
			  Else
				  response.Write("MENSAJE : ")
				  response.Write("EL DEUDOR NO POSEE GESTIONES JUDICIALES CLIENTE REGISTRADAS PARA : ")
				  response.Write(nombre_cliente)
			  End if
			  rsDET.close
			  set rsDET=nothing
	  CerrarSCG()
		%>

		<TABLE WIDTH="100%" BORDER="1" BORDERCOLOR="#FFFFFF">
	       	<TR>
	  			<TD height="20" ALIGN=LEFT class="pasos2_i">
	  				<B>Nueva Gestión Judicial Cliente</B>
	  			</TD>
	    		</TR>
	  	</TABLE>


	  	<table width="100%" border="0" bordercolor="#FFFFFF">
			<tr bordercolor="#999999" bgcolor="#<%=session("COLTABBG")%>" class="Estilo13">
			  <td width="33%">GESTION<td>
			</tr>
			<tr bordercolor="#999999">
			  <td><select name="cmbgestcliente" id="cmbgestcliente">
			  <option value="X">SELECCIONE</option>
		<%
			  AbrirSCG()
				strSql="SELECT * FROM GESTIONES_JUDICIAL_CLIENTE WHERE CODCLIENTE = '" & cliente & "' AND ACTIVA = 'S' ORDER BY ORDEN"
				set rsGestGJ=Conn.execute(strSql)
				Do While not rsGestGJ.eof
		%>
				<option value="<%=rsGestGJ("CODGESTION")%>"><%=rsGestGJ("CODGESTION")&"-"&rsGestGJ("NOMGESTION")%></option>
		<%
				rsGestGJ.movenext
				Loop
				rsGestGJ.close
				set rsGestCat=nothing
				CerrarSCG()
				''Response.End
		%>
			  </select>
			  </td>
			</tr>
        </table>

	  <%
	  Else
	  %>
	  <BR><BR>
	  <strong><span class="Estilo33">
	  <%response.Write("NO PUEDE INGRESAR GESTIONES YA QUE SU TIEMPO DE SESIÓN HA EXPIRADO.")%>
	  <br>
	   <%response.Write("PARA CONTINUAR, CIERRE ESTA VENTANA Y HAGA CLICK EN ACTUALIZAR EN EL MÓDULO PRINCIPAL (PRESIONE LA TECLA F5)")%></span></strong>
	  <%End if%>
      </td>
  </tr>
</table>
</form>

<script language="JavaScript1.2">

function GestionesFechaNotif() {
	var x = [<%=strFechaNotif%>];
	var sum = 0;
	for ( i=0; i < x.length; i++ ) {
	//alert((datos.cmbcat.value + datos.cmbsubcat.value + datos.cmbgest.value == x[i]));
		if ((datos.cmbcat.value + datos.cmbsubcat.value + datos.cmbgest.value == x[i]) && (datos.fecha1.value == '')) {
			return(true);
			break;
		}
	}

}

function GestionesFechaComparendo() {
	var x = [<%=strFechaComparendo%>];
	var sum = 0;
	for ( i=0; i < x.length; i++ ) {
	//alert(x[i]);
		if ((datos.cmbcat.value + datos.cmbsubcat.value + datos.cmbgest.value == x[i]) && (datos.fecha2.value == '')) {
			return(true);
			break;
		}
	}

}

function muestra_dia(){
//alert(getCurrentDate())
	var diferencia=DiferenciaFechas(datos.inicio.value)
	//alert(diferencia)
	if(datos.inicio.value!=''){
		if ((diferencia>=0) && (diferencia<=90)) {
			//alert('Ok')
		}else{
			alert('la fecha de compromiso debe ser mayor a la \nfecha actual y dentro de los proximos 30 dias')
			datos.inicio.value=''
			datos.inicio.focus()
		}
	}
}


function DiferenciaFechas (CadenaFecha1) {


   fecha_hoy = getCurrentDate() //hoy


   //Obtiene dia, mes y año
   var fecha1 = new fecha( CadenaFecha1 )
   var fecha2 = new fecha(fecha_hoy)

   //Obtiene objetos Date
   var miFecha1 = new Date( fecha1.anio, fecha1.mes, fecha1.dia )
   var miFecha2 = new Date( fecha2.anio, fecha2.mes, fecha2.dia )

   //Resta fechas y redondea
   var diferencia = miFecha1.getTime() - miFecha2.getTime()
   var dias = Math.floor(diferencia / (1000 * 60 * 60 * 24))
   var segundos = Math.floor(diferencia / 1000)
   //alert ('La diferencia es de ' + dias + ' dias,\no ' + segundos + ' segundos.')

   return dias //false
}
//---------------------------------------------------------------------
function fecha( cadena ) {

   //Separador para la introduccion de las fechas
   var separador = "/"

   //Separa por dia, mes y año
   if ( cadena.indexOf( separador ) != -1 ) {
        var posi1 = 0
        var posi2 = cadena.indexOf( separador, posi1 + 1 )
        var posi3 = cadena.indexOf( separador, posi2 + 1 )
        this.dia = cadena.substring( posi1, posi2 )
        this.mes = cadena.substring( posi2 + 1, posi3 )
        this.anio = cadena.substring( posi3 + 1, cadena.length )
   } else {
        this.dia = 0
        this.mes = 0
        this.anio = 0
   }
}

function cargasubcat(subCat)
{
	var comboBox = document.getElementById('cmbsubcat');
	switch (subCat)

	{

		<%
		  AbrirSCG()
			strSql="SELECT * FROM GESTIONES_JUDICIAL_CATEGORIA"
			set rsGestCat=Conn.execute(strSql)
			Do While not rsGestCat.eof
		%>

		case '<%=rsGestCat("CODCATEGORIA")%>':
			comboBox.options.length = 0;
			var newOption = new Option('SELECCIONE', '0');comboBox.options[comboBox.options.length] = newOption;
			<%
			strSql="SELECT * FROM GESTIONES_JUDICIAL_SUBCATEGORIA WHERE CODCATEGORIA = " & rsGestCat("CODCATEGORIA")
			set rsGestSubCat=Conn.execute(strSql)
			Do While not rsGestSubCat.eof
				%>
				var newOption = new Option('<%=rsGestSubCat("CODSUBCATEGORIA")&"-"&rsGestSubCat("DESCRIPCION")%>', '<%=rsGestSubCat("CODSUBCATEGORIA")%>');comboBox.options[comboBox.options.length] = newOption;
				<%
				rsGestSubCat.movenext
			Loop
			rsGestSubCat.close
			set rsGestSubCat=nothing
			%>
			break;


		<%
		  	rsGestCat.movenext
		  	Loop
		  	rsGestCat.close
		  	set rsGestCat=nothing
			CerrarSCG()
		%>

	}
}



function cargagest(subCat,cat)
{
	var comboBox = document.getElementById('cmbgest');
	switch (cat)
	{
		<%
		  AbrirSCG()
			strSql="SELECT * FROM GESTIONES_JUDICIAL_CATEGORIA"
			set rsGestCat=Conn.execute(strSql)
			Do While not rsGestCat.eof
		%>
		case '<%=rsGestCat("CODCATEGORIA")%>':
			comboBox.options.length = 0;
			<%
			strSql="SELECT * FROM GESTIONES_JUDICIAL_SUBCATEGORIA WHERE CODCATEGORIA = " & rsGestCat("CODCATEGORIA")
			set rsGestSubCat=Conn.execute(strSql)
			If Not rsGestSubCat.eof Then
				Do While not rsGestSubCat.eof
					%>
					if (subCat=='<%=rsGestSubCat("CODSUBCATEGORIA")%>') {
						var newOption = new Option('SELECCIONE', 'X');comboBox.options[comboBox.options.length] = newOption;
						<%
						strSql="SELECT * FROM GESTIONES_JUDICIAL_GESTION WHERE CODCATEGORIA = " & rsGestCat("CODCATEGORIA") & " AND CODSUBCATEGORIA = " & rsGestSubCat("CODSUBCATEGORIA")
						''Response.write "sql=" & strSql
						set rsGestion=Conn.execute(strSql)
						If Not rsGestion.Eof Then
							Do While Not rsGestion.Eof
								%>
									var newOption = new Option('<%=rsGestion("CODGESTION")&"-"&rsGestion("DESCRIPCION")%>', '<%=rsGestion("CODGESTION")%>');comboBox.options[comboBox.options.length] = newOption;
								<%
								rsGestion.movenext
							Loop
						Else
						%>
							var newOption = new Option('SIN GESTION LA CATEGORIA', '0');comboBox.options[comboBox.options.length] = newOption;
						<%
						End if
						%>
						break;
					}
					<%
					rsGestSubCat.movenext
				Loop
				rsGestSubCat.close
				set rsGestSubCat=nothing
			Else
				%>
				{
					var newOption = new Option('SELECCIONE', 'X');comboBox.options[comboBox.options.length] = newOption;
					var newOption = new Option('SIN GESTION LA CATEGORIA', '0');comboBox.options[comboBox.options.length] = newOption;
				}
				break;
			<%
			End If
			%>
		<%
		  	rsGestCat.movenext
		  	Loop
		  	rsGestCat.close
		  	set rsGestCat=nothing
			CerrarSCG()
		%>
	}
	
}

function cajas()
{
	if (GestionesFechaNotif())
	{
		datos.fecha1.disabled=false;
	}
	else
	{
		datos.fecha1.disabled=true;
	}
}

function nueva(){

	if((datos.cmbcat.value=='X')||(datos.cmbsubcat.value=='X')){
		alert('DEBE SELECCIONAR UNA CATEGORÍA O SUBCATEGORÍA');
	}else if (GestionesFechaNotif()){
		alert('DEBE INGRESAR FECHA DE NOTIFICACION');
	}else if (GestionesFechaComparendo()){
		alert('DEBE INGRESAR FECHA DE COMPARENDO');
	}else if (datos.cmbgest.value=='X') {
		alert('DEBE INGRESAR UNA GESTION (ESTATUS)');
	}else if((datos.CB_DEMANDA.value=='0') && (datos.cmbcat.value!='1')) {
		alert('DEBE SELECCIONAR DEMANDA ASOCIADA');
	}else if(datos.cmbgestcliente.value=='X') {
		document.getElementById("cmbgestcliente").focus();
		alert('DEBE SELECCIONAR UNA GESTION JUDICIAL CLIENTE');
	}	
	else
	{	
		datos.ingresar.disabled=true;
		datos.action='gestiones_judiciales_nueva.asp';
		datos.submit();
	}
}

</script>