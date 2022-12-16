<!--#include file="arch_utils.asp"-->
<!--#include file="lib.asp"-->
<!--#include file="../lib/comunes/rutinas/funciones.inc" -->
<!--#include file="../lib/comunes/rutinas/TraeCampo.inc" -->
<script language="JavaScript">
function ventanaSecundaria (URL){
window.open(URL,"DETALLE","width=200, height=200, scrollbars=no, menubar=no, location=no, resizable=no")
}
</script>
<%
	AbrirScg()
	strSql = "SELECT COD_GESTION FROM PARAM_GESTION WHERE TIPO = 'COMP_PAGO'"
	set rsGest = Conn.execute(strSql )
	strCodComPago = ""
	Do While not rsGest.eof
		strCodComPago = strCodComPago & "," & rsGest("COD_GESTION")
		rsGest.movenext
	Loop

	strSql = "SELECT COD_GESTION FROM PARAM_GESTION WHERE TIPO = 'AGEND'"
	set rsGest = Conn.execute(strSql )
	strCodAgend = ""
	Do While not rsGest.eof
		strCodAgend = strCodAgend & "," & rsGest("COD_GESTION")
		rsGest.movenext
	Loop

	strSql = "SELECT COD_GESTION FROM PARAM_GESTION WHERE TIPO = 'PAGADA'"
	set rsGest = Conn.execute(strSql )
	strCodPagada = ""
	Do While not rsGest.eof
		strCodPagada = strCodPagada & "," & rsGest("COD_GESTION")
		rsGest.movenext
	Loop


	CerrarScg()
	If Trim (strCodComPago) <> "" Then strCodComPago = Mid(strCodComPago,2,Len(strCodComPago))
	If Trim (strCodAgend) <> "" Then strCodAgend = Mid (strCodAgend,2,Len(strCodAgend))
	If Trim (strCodPagada) <> "" Then strCodPagada = Mid (strCodPagada,2,Len(strCodPagada))

	rut = request("rut")
	cliente=request("cliente")
	fono_con = request("fono_con")
	area_con = request("area_con")

	if rut="" then
		rut=request("rut_")
		cliente=request("cliente_")
		categoria=request("cmbcat")
		subcategoria=request("cmbsubcat")
		gestion=request("cmbgest")
		fechacompromiso=request("TX_COMPROMISO")
		fechacancelo=request("TX_CANCELO")
		comprobante=request("comprobante")
		observaciones=request("observaciones")
		telges=request("telges")
		dirges=request("dirges")
		retiro=request("retiro")
		fono_aportado_fono=request("fono_aportado_fono")
		fono_aportado_area=request("fono_aportado_area")
		validar_fono=request("validar_fono")
		reagen=request("reagen")
		if not rut="" then
			AbrirSCG()

			if (categoria=1 and subcategoria=2 and gestion=5 ) then
				reagen="'" + reagen + "'"
			else
				reagen="NULL"
			end if
					'response.write(reagen)
				'response.End()
			if (categoria="1" and subcategoria="2" and gestion="6" ) then
				retiro="'" + retiro + "'"
			else
				retiro="NULL"
			end if

			if request("validar_fono")<>"0" and request("validar_fono")<>"" then

				'ssql="UPDATE DEUDOR_TELEFONO SET ESTADO='2',FechaRevision='"&date&"',UsrRevision='"&session("session_login")&"' WHERE RUTDEUDOR='"&rut&"' AND TELEFONO='"&telges&"'"
				ssql="UPDATE DEUDOR_TELEFONO SET ESTADO='"&request("validar_fono")&"',FechaRevision='"&date&"',UsrRevision='"&session("session_login")&"' WHERE RUTDEUDOR='"&rut&"' AND cast(codarea as varchar(3)) + '-' + TELEFONO='"&telges&"'"

				Conn.execute(ssql)
			end if

			if not fono_aportado_fono="" and not fono_aportado_area="0" then
				ssql_1 = "EXECUTE PD_AGREGA_FONO '"&rut&"','"&fono_aportado_area&"','"&fono_aportado_fono&"','"&session("session_login")&"'"
				Conn.execute(ssql_1)
			end if

			ssql2=""
			ssql2="SELECT MAX(Correlativo)+1 AS CORRELATIVO FROM GESTIONES WHERE RutDeudor='"&rut&"' AND CodCliente='"&cliente&"'"
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

			ssql2=""
			ssql2="SELECT MAX(CorrelativoDato)+1 AS CORRELATIVO2 FROM GESTIONES WHERE RutDeudor='"&rut&"' AND CodCliente='"&cliente&"'"
			set rsCOR=Conn.execute(ssql2)
			if not rsCOR.eof then
				correlativo2=rsCOR("CORRELATIVO2")
				if isNULL(rsCOR("CORRELATIVO2")) THEN
					correlativo2= "1"
				end if
			else
				correlativo2= "1"
			end if
			rsCOR.close
			set rsCOR=nothing

			If trim(gestion) = "" then
				gestion = 0
			End if
			ssql2=""
			if fechacompromiso="" and fechacancelo="" then
				ssql2="INSERT INTO GESTIONES ( RutDeudor,CodCliente,NroDoc,Correlativo,CodCategoria,CodSubCategoria,CodGestion,FechaIngreso,HoraIngreso,IdUsuario,NroDocPago,Observaciones,CorrelativoDato,telefono_asociado,direccion_asociada,fecha_retiro,FECHA_AGENDAMIENTO)"
				ssql2= ssql2 & "VALUES ('"&rut&"','"&cliente&"','1','"&correlativo&"','"&categoria&"','"&subcategoria&"','"&gestion&"','"&date&"','"&time&"',"& session("session_idusuario") &",'"&comprobante&"','"&UCASE(observaciones)&"','"&cint(correlativo2)&"','"&telges&"','"&dirges&"',"&retiro&","&reagen&")"
			elseif fechacompromiso="" then
				ssql2="INSERT INTO GESTIONES ( RutDeudor,CodCliente,NroDoc,Correlativo,CodCategoria,CodSubCategoria,CodGestion,FechaIngreso,HoraIngreso,IdUsuario,NroDocPago,FechaPago,Observaciones,CorrelativoDato,telefono_asociado,direccion_asociada,fecha_retiro,FECHA_AGENDAMIENTO)"
				ssql2= ssql2 & "VALUES ('"&rut&"','"&cliente&"','1','"&correlativo&"','"&categoria&"','"&subcategoria&"','"&gestion&"','"&date&"','"&time&"',"& session("session_idusuario") &",'"&comprobante&"','"&fechacancelo&"','"&UCASE(observaciones)&"','"&cint(correlativo2)&"','"&telges&"','"&dirges&"',"&retiro&","&reagen&")"
			elseif fechacancelo="" then
				ssql2="INSERT INTO GESTIONES ( RutDeudor,CodCliente,NroDoc,Correlativo,CodCategoria,CodSubCategoria,CodGestion,FechaIngreso,HoraIngreso,IdUsuario,FechaCompromiso,NroDocPago,Observaciones,CorrelativoDato,telefono_asociado,direccion_asociada,fecha_retiro,FECHA_AGENDAMIENTO)"
				ssql2= ssql2 & "VALUES ('"&rut&"','"&cliente&"','1','"&correlativo&"','"&categoria&"','"&subcategoria&"','"&gestion&"','"&date&"','"&time&"',"& session("session_idusuario") &",'"&fechacompromiso&"','"&comprobante&"','"&UCASE(observaciones)&"','"&cint(correlativo2)&"','"&telges&"','"&dirges&"',"&retiro&","&reagen&")"
			end if
				'response.write(ssql2)
				'response.End()
			Conn.execute(ssql2)
		end if
		CerrarSCG()

	end if

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
<title>INGRESO DE GESTIONES</title>
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
		<B>Módulo Ingreso de Gestiones</B>
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
	ssql="SELECT TOP 1 NOMBREDEUDOR,RUTDEUDOR FROM DEUDOR WHERE RUTDEUDOR='"&rut&"' AND NOMBREDEUDOR IS NOT NULL AND LTRIM(RTRIM(NOMBREDEUDOR)) <> '' "
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


	AbrirSCG()
	ssql=""
	ssql="SELECT TOP 1 Calle,Numero,Comuna,Correlativo FROM DEUDOR_DIRECCION WHERE RUTDEUDOR='"&rut_deudor&"' ORDER BY Correlativo DESC"
	set rsDIR=Conn.execute(ssql)
	if not rsDIR.eof then
		calle_deudor=rsDIR("Calle")
		numero_deudor=rsDIR("Numero")
		comuna_deudor=rsDIR("Comuna")
		correlativo_deudor=rsDIR("Correlativo")
	end if
	rsDIR.close
	set rsDIR=nothing


	ssql=""
	ssql="SELECT TOP 1 CodArea,Telefono,Correlativo FROM DEUDOR_TELEFONO WHERE  ESTADO<>2 AND RUTDEUDOR='"&rut_deudor&"' ORDER BY Correlativo DESC"
	set rsFON=Conn.execute(ssql)
	if not rsFON.eof then
		codarea_deudor = rsFON("CodArea")
		Telefono_deudor = rsFON("Telefono")
		Correlativo_deudor2 = rsFON("Correlativo")
	end if
	rsFON.close
	set rsFON=nothing


	ssql=""
	ssql="SELECT TOP 1 Email,Correlativo FROM DEUDOR_EMAIL WHERE  ESTADO <> 2 AND RUTDEUDOR='"&rut_deudor&"' ORDER BY Correlativo DESC"
	set rsEmail=Conn.execute(ssql)
	if not rsEmail.eof then
		strEmail = rsEmail("Email")
		Correlativo_deudor3 = rsEmail("Correlativo")
	end if
	rsEmail.close
	set rsEmail=nothing





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
	<table width="100%" border="0" bordercolor="#FFFFFF">
      <tr bordercolor="#999999" bgcolor="#<%=session("COLTABBG")%>" class="Estilo13">
        <td width="60%">DIRECCION</td>
        <td width="20%">TELEFONO</td>
        <td width="20%">EMAIL</td>
      </tr>
      <tr class="Estilo8">
        <td><%if not calle_deudor="" then%>
            <%=calle_deudor%> N&ordm; <%=numero_deudor%> - <%=comuna_deudor%>
            <%end if%>
        </td>
        <td><%if not telefono_deudor="" then%>
            <%=codarea_deudor%>-<%=telefono_deudor%>
            <%end if%></td>
        <td><%if not strEmail="" then%>
            <%=strEmail%>
            <%end if%></td>
      </tr>
    </table>
    <table width="100%" border="1" bordercolor="#FFFFFF">
     	<tr>
			<TD height="20" ALIGN=LEFT class="pasos2_i">
				<B>Historial de Gestiones</B>
			</TD>
  		</tr>
	</table>
	  <%if not rut="" then%>

	  <input name="rut_" type="hidden" id="rut_" value="<%=rut_deudor%>">
	  <input name="cliente_" type="hidden" id="cliente_" value="<%=cliente%>">
	  <input name="rut_o" type="hidden" id="rut_o" value="<%=rut_deudor_o%>">

	  <%
	  AbrirSCG()
	  ssql=""
	ssql="select top 15  "
	ssql=ssql + "CASE "
	ssql=ssql + "WHEN CodCategoria=3 AND codSubCategoria=1 AND CodGestion IS NULL AND horaingreso='21:59:00' THEN '1' "
	ssql=ssql + "ELSE CodCategoria  "
	ssql=ssql + "END as CodCategoria, "
	ssql=ssql + "CASE "
	ssql=ssql + "WHEN CodCategoria=3 AND codSubCategoria=1 AND CodGestion IS NULL AND horaingreso='21:59:00' THEN '2' "
	ssql=ssql + "ELSE codSubCategoria "
	ssql=ssql + "END as CodSubCategoria, "
	ssql=ssql + "CASE "
	ssql=ssql + "WHEN CodCategoria=3 AND codSubCategoria=1 AND CodGestion IS NULL AND horaingreso='21:59:00' THEN '8' "
	ssql=ssql + "ELSE CodGestion "
	ssql=ssql + "END as CodGestion, fechaIngreso,IdUsuario,fechacompromiso,horaingreso, observaciones, telefono_asociado "
	ssql=ssql + "from gestiones "
	ssql=ssql + "where rutdeudor= '"&rut&"' AND CODCLIENTE='" & cliente & "'"
	'ssql=ssql + "order by FechaIngreso desc"
	ssql=ssql + "order by id_gestion desc"
	  'response.Write(ssql)
	  'response.End()

	  set rsDET=Conn.execute(ssql)
	  if not rsDET.eof then
	  %>
     <table width="100%" border="0" bordercolor="#FFFFFF">
        <tr bordercolor="#FFFFFF" bgcolor="#<%=session("COLTABBG")%>" class="Estilo13">
          <td class="Estilo4">FECHA</td>
          <td class="Estilo4">GESTION</td>
          <td class="Estilo4">COMPROMISO</td>
          <td class="Estilo4">OBSERVACIONES</td>
          <td WIDTH="60"class="Estilo4">FONO</td>
          <td class="Estilo4">COBRADOR</td>
          </tr>
		<%do until rsDET.eof
		Obs=UCASE(LTRIM(RTRIM(rsDET("Observaciones"))))
		if Obs="" then
			Obs="SIN INFORMACION ADICIONAL"
		end if



		strCodGestion= rsDET("CodCategoria")&rsDET("CodSubCategoria")&rsDET("CodGestion")

		strSql = "SELECT G.CODCATEGORIA, G.CODSUBCATEGORIA, G.CODGESTION,C.DESCRIPCION + '-' + S.DESCRIPCION + '-' +  G.DESCRIPCION as DESCRIP"
		strSql = strSql & " FROM GESTIONES_TIPO_CATEGORIA C, GESTIONES_TIPO_SUBCATEGORIA S, GESTIONES_TIPO_GESTION G"
		strSql = strSql & " WHERE C.CODCATEGORIA = S.CODCATEGORIA"
		strSql = strSql & " AND C.CODCATEGORIA = G.CODCATEGORIA"
		strSql = strSql & " AND S.CODSUBCATEGORIA = G.CODSUBCATEGORIA"
		strSql = strSql & " AND CAST(G.CODCATEGORIA AS CHAR(1)) + CAST(G.CODSUBCATEGORIA AS VARCHAR(2)) + CAST(G.CODGESTION AS CHAR(1)) = '" & Trim(strCodGestion) & "'"

		'Response.write "strSql=" &strSql
		'Response.End
		SET rsNomGestion=Conn.execute(strSql)
		If Not rsNomGestion.Eof Then
			strNomGestion = rsNomGestion("DESCRIP")
		Else
			strNomGestion = ""
		End If

		strLoginCobrador = TraeCampoId(Conn, "LOGIN", rsDET("IdUsuario"), "USUARIO", "ID_USUARIO")

		%>
        <tr bordercolor="#FFFFFF" class="Estilo8">
          <td class="Estilo4"><%=rsDET("FechaIngreso")%></td>
          <td class="Estilo4"><%=strNomGestion%></td>
          <td class="Estilo4"><%=rsDET("FechaCompromiso")%></td>
          <td class="Estilo4"><%=Mid(Obs,1,45)%></td>
          <td class="Estilo4"><%=rsDET("telefono_asociado")%></td>
          <td class="Estilo4"><%=UCASE(strLoginCobrador)%></td>
        </tr>
		 <%rsDET.movenext
		 loop
		 %>
      </table>
	  <%
	  else
	  response.Write("MENSAJE : ")
	  response.Write("EL DEUDOR NO POSEE GESTIONES REGISTRADAS PARA EL CLIENTE ")
	  response.Write(nombre_cliente)
	  end if
	  rsDET.close
	  set rsDET=nothing
	  %>
	  <%end if
	  CerrarSCG()
	  %>
	  <%
	  if not session("session_login")="" then
  	  %>
  	      <TABLE WIDTH="100%" BORDER="1" BORDERCOLOR="#FFFFFF">
	       	<TR>
	  			<TD height="20" ALIGN=LEFT class="pasos2_i">
	  				<B>Nueva Gestión</B>
	  			</TD>
	    		</TR>
	  	</TABLE>


  	    <table width="100%" border="0" bordercolor="#FFFFFF">
        <tr bordercolor="#999999" bgcolor="#<%=session("COLTABBG")%>" class="Estilo13">
          <td width="33%">CATEGORIA</td>
          <td width="34%">SUBCATEGORIA</td>
          <td width="33%">GESTION</td>
        </tr>
        <tr bordercolor="#999999">
          <td><select name="cmbcat" onChange="cargasubcat(this.value);">
          <option value="0">SELECCIONE</option>
    <%
          AbrirSCG()
		  	strSql="SELECT * FROM GESTIONES_TIPO_CATEGORIA"
		  	set rsGestCat=Conn.execute(strSql)
		  	Do While not rsGestCat.eof
	%>
		  	<option value="<%=rsGestCat("CODCATEGORIA")%>"><%=rsGestCat("DESCRIPCION")%></option>
	<%
		  	rsGestCat.movenext
		  	Loop
		  	rsGestCat.close
		  	set rsGestCat=nothing
			CerrarSCG()
			''Response.End
	%>
          </select></td>
          <td><select name="cmbsubcat" onChange="cargagest(this.value,cmbcat.value);">
		  	  <option value="0">SELECCIONE</option>
          </select></td>
          <td><select name="cmbgest" onChange="cajas();">
		   <option value="X">SELECCIONE</option>
          </select></td>
        </tr>
        </table>
        <table width="100%" border="0" bordercolor="#FFFFFF">
        <tr bgcolor="#<%=session("COLTABBG")%>" class="Estilo13" >
          <td>FECHA DE COMPROMISO</td>
          <td>FECHA EN QUE CANCEL&Oacute; DEUDA</td>
          <td>COMPROBANTE DE PAGO</td>
		  <td>FECHA REAGENDAMIENTO</td>

        </tr>
        <tr>
         <td>
            <input name="TX_COMPROMISO" type="text" size="10" maxlength="10" onBlur="muestra_dia();"  >
		    <a href="javascript:showCal('Calendar15');"><img src="../lib/calendario.gif" border="0"></a>
		 </td>
         <td>
            <input name="TX_CANCELO" type="text" size="10" maxlength="10" disabled>
		    <a href="javascript:showCal('Calendar16'); "><img src="../lib/calendario.gif" border="0"></a>
		 </td>
         <td><input name="comprobante" type="text" disabled id="comprobante" size="10" maxlength="10"></td>
		 <td>
            <input name="reagen" type="text" id="reagen" size="10" maxlength="10" disabled >
		    <a href="javascript:showCal('Calendar13');"><img src="../lib/calendario.gif" border="0"></a>
		 </td>

        </tr>
      </table>
      <table width="100%" border="0" bordercolor="#FFFFFF">
        <tr bordercolor="#999999" bgcolor="#<%=session("COLTABBG")%>" class="Estilo13" >
          <td width="17%">TELEFONO GESTION </td>
          <td width="59%">OBSERVACIONES</td>
          <td width="24%">NUEVO FONO (AREA-TELEFONO) </td>
        </tr>
        <tr bordercolor="#999999">
          <td><select name="telges" id="telges">
		  	<option value="0">SELECCIONE</option>
			<%if fono_con="0" or fono_con="" then%>
			  <%
				AbrirSCG()
				ssql_ = "SELECT Telefono,Codarea FROM DEUDOR_TELEFONO WHERE RutDeudor='"&rut&"' AND ESTADO<>2"
				set rsFON=Conn.execute(ssql_)
				do until rsFON.eof
			  %>
				<option value="<%=rsFON("Codarea")%>-<%=rsFON("Telefono")%>"><%=rsFON("Codarea")%>-<%=rsFON("Telefono")%></option>
			 <%
				rsFON.movenext
				loop
				rsFON.close
				set rsFON=nothing
				CerrarSCG()
			 %>
		 <option value="TERRENO">TERRENO</option>
		 <option value="SINFONO">SIN FONO</option>
		 <%else%>
		 		<option value="<%=fono_con%>"><%=area_con%>-<%=fono_con%></option>
		 <%end if
		 %>

         </select></td>
		 <input name="num_min" type="hidden" value="0">
		 <input name="validar_fono" type="hidden" value="0"> <!-- invalidar=1, validar=2 nada=0-->
          <td>
          <TEXTAREA NAME="observaciones" ROWS=2 COLS=50></TEXTAREA>
          </td>
          <td><select name="fono_aportado_area" id="fono_aportado_area"  onblur="num_min.value=asigna_minimo(fono_aportado_area,num_min)">

				 <%abrirscg()
				 ssql="SELECT DISTINCT codigo_area FROM COMUNA where id_sadi<>0 union select 9 as codigo_area  ORDER BY codigo_area desc"
				 set rsCOM= Conn.execute(ssql)
				 do until rsCOM.eof%>
						<option value="<%=rsCOM("codigo_area")%>" selected><%=rsCOM("codigo_area")%></option>
						<%
				  rsCOM.movenext
				  loop
				  rsCOM.close
				  set rsCOM=nothing
				  cerrarscg() %>
				  <option value="0" selected>--</option>
           </select>
            -
              <input name="fono_aportado_fono" type="text" id="fono_aportado_fono" size="8" maxlength="8" onKeyup="fono_aportado_fono.value=solonumero(fono_aportado_fono)"   ></td>
        </tr>
      </table>
	  <table width="100%"  border="0">
        <tr>
          <td width="17%" bordercolor="#999999" bgcolor="#<%=session("COLTABBG")%>" class="Estilo13 Estilo34">COBRADOR</td>
          <td bgcolor="#<%=session("COLTABBG")%>"><span class="Estilo35">DIRECCION ASOCIADA A LA VISITA</span></td>
          <td bgcolor="#<%=session("COLTABBG")%>"><span class="Estilo35">FECHA RETIRO </span></td>
          </tr>
        <tr>
          <td bordercolor="#999999"><%=session("session_login")%></td>
          <td><select name="dirges" disabled>
            <option value="0">SELECCIONE</option>
            <%
			AbrirSCG()
			ssql_ = "SELECT CALLE,NUMERO,RESTO,COMUNA FROM DEUDOR_DIRECCION WHERE RUTDEUDOR = '" & rut & "'"
		    set rsDIR=Conn.execute(ssql_)
		  	do until rsDIR.eof
			direccion = rsDIR("calle")+" "+rsDIR("Numero")+" "+rsDIR("Resto")+" "+rsDIR("COMUNA")

		  %>
            <option value="<%=direccion%>"><%=direccion%></option>
            <%
		 	rsDIR.movenext
			loop
			rsDIR.close
			set rsDIR=nothing
			CerrarSCG()
		 %>
          </select></td>
          <td>
		    <input name="retiro" type="text" id="retiro" size="10" maxlength="10" disabled>
            <a href="javascript:showCal('Calendar2');"><img src="../lib/calendario.gif" border="0"></a>
			<input name="ingresar" type="button" onClick="nueva();" value="Ingresar">


		  </td>
          </tr>
      </table>
	  <%
	  else%>
	  <BR>
	  <BR><BR>
	  <strong><span class="Estilo33">
	  <%response.Write("NO PUEDE INGRESAR GESTIONES YA QUE SU TIEMPO DE SESIÓN HA EXPIRADO.")%>
	  <br>
	   <%response.Write("PARA CONTINUAR, CIERRE ESTA VENTANA Y HAGA CLICK EN ACTUALIZAR EN EL MÓDULO PRINCIPAL (PRESIONE LA TECLA F5)")%></span></strong>
	  <%end if%>
      </td>
  </tr>
</table>
</form>

<script language="JavaScript1.2">



function muestra_dia(){
//alert(getCurrentDate())
	var diferencia=DiferenciaFechas(datos.TX_COMPROMISO.value)
	//alert(diferencia)
	if(datos.TX_COMPROMISO.value!=''){
		if ((diferencia>=0) && (diferencia<=90)) {
			//alert('Ok')
		}else{
			alert('La Fecha de Compromiso de Pago debe ser mayor a la fecha actual y dentro de los proximos 30 dias')
			datos.TX_COMPROMISO.value=''
			datos.TX_COMPROMISO.focus()
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
///------x-x-x-x--x-x-x-x-x-x*x-x*x-x*x-x*x-x*x-x*x*-*-*-*

function asigna_minimo(campo, minimo1){
	if (campo.value!=0)	{
		if(campo.value.length==1){
			minimo1=8
		}else if(campo.value==32 || campo.value==41){
			minimo1=7;
		}else {
			minimo1=6
		}
	}else{minimo1=0}
	return(minimo1)
}


function valida_largo(campo, minimo){
//alert(datos.fono_aportado_area.value)
	//if (datos.fono_aportado_area.value!="0"){
		if(campo.value.length != minimo) {
			alert("Fono debe tener " + minimo + " digitos")
			campo.select()
			campo.focus()
			return(true)
		}
	//}
	return(false)
}

function solonumero(valor){
     //Compruebo si es un valor numérico
      if (isNaN(valor.value)) {
            //entonces (no es numero) devuelvo el valor cadena vacia
            valor.value=""
			return ""
      }else{
            //En caso contrario (Si era un número) devuelvo el valor
			valor.value
			return valor.value
      }
}


function GestionesCompPago() {
	var x = [<%=strCodComPago%>];
	var sum = 0;
	for ( i=0; i < x.length; i++ ) {
	//alert(x[i]);
		if ((datos.cmbcat.value + datos.cmbsubcat.value + datos.cmbgest.value == x[i]) && (datos.TX_COMPROMISO.value == '')) {
			return(true);
			break;
		}
	}

}

function GestionesAgendables() {
	var x = [<%=strCodAgend%>];
	var sum = 0;
	for ( i=0; i < x.length; i++ ) {
	//alert(x[i]);
		if ((datos.cmbcat.value + datos.cmbsubcat.value + datos.cmbgest.value == x[i]) && (datos.reagen.value == '')) {
			return(true);
			break;
		}
	}

}

function GestionesDeudaCancelada() {
	var x = [<%=strCodPagada%>];
	var sum = 0;
	for ( i=0; i < x.length; i++ ) {
	//alert(x[i]);
		if ((datos.cmbcat.value + datos.cmbsubcat.value + datos.cmbgest.value == x[i]) && (datos.reagen.value == '')) {
			return(true);
			break;
		}
	}

}

function nueva(){
	datos.reagen.disabled=false
	datos.retiro.disabled=false

	if((datos.cmbcat.value=='0')||(datos.cmbsubcat.value=='0')){
		alert('DEBE SELECCIONAR UNA CATEGORÍA O SUBCATEGORÍA');
	}else if (GestionesCompPago()){
		alert('DEBE INGRESAR FECHA DE COMPROMISO');
	}else if (GestionesAgendables()){
		alert('DEBE INGRESAR FECHA DE REAGENDAMIENTO');
	}else if (datos.cmbgest.value=='X') {
		alert('DEBE INGRESAR UNA GESTION');
	}else if(datos.telges.value=='0'){
		alert('DEBE SELECCIONAR TELÉFONO DE GESTIÓN');
	}else if(datos.telges.value=='0'){
		alert('DEBE SELECCIONAR TELÉFONO DE GESTIÓN');
	}else if (valida_largo(datos.fono_aportado_fono, datos.num_min.value)){


	}else{

		datos.ingresar.disabled=true
		validar_fonos()
		datos.action='detalle_gestiones_test.asp';
		datos.submit();
	}
}

//--------------------------------------------
function validar_fonos(){

//validar/invalidar fonos
	 //if ((datos.cmbcat.value=='1')&&(datos.cmbsubcat.value=='4')&&(datos.cmbgest.value=='0')){
	//	datos.validar_fono.value='1'
//
	//}else if ((datos.cmbcat.value=='2')&&(datos.cmbsubcat.value=='1')&&(datos.cmbgest.value=='0')){
	//	datos.validar_fono.value='2'
//
	//}else if ((datos.cmbcat.value=='2')&&(datos.cmbsubcat.value=='2')&&(datos.cmbgest.value=='0')){
	//	datos.validar_fono.value='2'
//
	//}else if ((datos.cmbcat.value=='2')&&(datos.cmbsubcat.value=='3')&&(datos.cmbgest.value=='0')){
	//	datos.validar_fono.value='1'
//
	//}else if ((datos.cmbcat.value=='2')&&(datos.cmbsubcat.value=='4')&&(datos.cmbgest.value=='0')){
	//	datos.validar_fono.value='1'

	//}else if ((datos.cmbcat.value=='2')&&(datos.cmbsubcat.value=='5')&&(datos.cmbgest.value=='0')){
	//	datos.validar_fono.value='1'
	//}else if ((datos.cmbcat.value=='1')&&(datos.cmbsubcat.value=='2')){
	//	datos.validar_fono.value='1'
	//}else if ((datos.cmbcat.value=='1')&&(datos.cmbsubcat.value=='3')){
	//	datos.validar_fono.value='1'
	//}else if ((datos.cmbcat.value=='1')&&(datos.cmbsubcat.value=='5')){
	//	datos.validar_fono.value='1'
	//}else if ((datos.cmbcat.value=='1')&&(datos.cmbsubcat.value=='1')){
	//	datos.validar_fono.value='2'
	//}




}

//--------------------------------------------

function ficha(){
datos.action='caja.asp';
datos.submit();
}

function cargasubcat(subCat){
{
	var comboBox = document.getElementById('cmbsubcat');
	switch (subCat)

	{

		<%
		  AbrirSCG()
			strSql="SELECT * FROM GESTIONES_TIPO_CATEGORIA"
			set rsGestCat=Conn.execute(strSql)
			Do While not rsGestCat.eof
		%>

		case '<%=rsGestCat("CODCATEGORIA")%>':
			comboBox.options.length = 0;
			var newOption = new Option('SELECCIONE', '0');comboBox.options[comboBox.options.length] = newOption;
			<%
			strSql="SELECT * FROM GESTIONES_TIPO_SUBCATEGORIA WHERE CODCATEGORIA = " & rsGestCat("CODCATEGORIA")
			set rsGestSubCat=Conn.execute(strSql)
			Do While not rsGestSubCat.eof
				%>
				var newOption = new Option('<%=rsGestSubCat("DESCRIPCION")%>', '<%=rsGestSubCat("CODSUBCATEGORIA")%>');comboBox.options[comboBox.options.length] = newOption;
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
}}


function cargagest(subCat,cat){
{
	var comboBox = document.getElementById('cmbgest');
	switch (cat)
	{
		<%
		  AbrirSCG()
			strSql="SELECT * FROM GESTIONES_TIPO_CATEGORIA"
			set rsGestCat=Conn.execute(strSql)
			Do While not rsGestCat.eof
		%>
		case '<%=rsGestCat("CODCATEGORIA")%>':
			comboBox.options.length = 0;
			<%
			strSql="SELECT * FROM GESTIONES_TIPO_SUBCATEGORIA WHERE CODCATEGORIA = " & rsGestCat("CODCATEGORIA")
			set rsGestSubCat=Conn.execute(strSql)
			If Not rsGestSubCat.eof Then
				Do While not rsGestSubCat.eof
					%>
					if (subCat=='<%=rsGestSubCat("CODSUBCATEGORIA")%>') {
						var newOption = new Option('SELECCIONE', 'X');comboBox.options[comboBox.options.length] = newOption;
						<%
						strSql="SELECT * FROM GESTIONES_TIPO_GESTION WHERE CODCATEGORIA = " & rsGestCat("CODCATEGORIA") & " AND CODSUBCATEGORIA = " & rsGestSubCat("CODSUBCATEGORIA")
						''Response.write "sql=" & strSql
						set rsGestion=Conn.execute(strSql)
						If Not rsGestion.Eof Then
							Do While Not rsGestion.Eof
								%>
									var newOption = new Option('<%=rsGestion("DESCRIPCION")%>', '<%=rsGestion("CODGESTION")%>');comboBox.options[comboBox.options.length] = newOption;
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
}

function cajas()
{
	if(GestionesDeudaCancelada())
	{
		datos.comprobante.disabled=false;
		datos.TX_CANCELO.disabled=false;
	}
	else
	{
		datos.comprobante.disabled=true;
		datos.TX_CANCELO.disabled=true;
	}

	if (GestionesCompPago())
	{
		datos.TX_COMPROMISO.disabled=false;
	}
	else
	{
		datos.TX_COMPROMISO.disabled=true;
	}

	if (datos.cmbcat.value == '3')
	{
		datos.dirges.disabled=false;
	}
	else
	{
		datos.dirges.disabled=true;
	}
}
</script>




































































