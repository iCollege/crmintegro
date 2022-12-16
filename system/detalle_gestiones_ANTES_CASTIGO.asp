<!--#include file="arch_utils.asp"-->
<!--#include file="lib.asp"-->
<!--#include file="../lib/comunes/rutinas/funciones.inc" -->

<script language="JavaScript">
function ventanaSecundaria (URL){
window.open(URL,"DETALLE","width=200, height=200, scrollbars=no, menubar=no, location=no, resizable=no")
}

</script>

<%
	rut = request.QueryString("rut")
	cliente=request.QueryString("cliente")
	fono_con = request.QueryString("fono_con")
	area_con = request.QueryString("area_con")

	if rut="" then
	rut=request.Form("rut_")
	cliente=request.Form("cliente_")
	categoria=request.Form("cmbcat")
	subcategoria=request.Form("cmbsubcat")
	gestion=request.Form("cmbgest")
	fechacompromiso=request.Form("inicio")
	fechacancelo=request.Form("termino")
	comprobante=request.Form("comprobante")
	observaciones=request.Form("observaciones")
	telges=request.Form("telges")
	dirges=request.Form("dirges")
	retiro=request.Form("retiro")
	fono_aportado_fono=request.Form("fono_aportado_fono")
	fono_aportado_area=request.Form("fono_aportado_area")

		if not rut="" then
		AbrirSCG()


	if categoria="1" and (subcategoria="2" or subcategoria="3" or subcategoria="5") then

	ssql="UPDATE DEUDOR_TELEFONO SET ESTADO='1',FechaRevision='"&date&"',UsrRevision='"&session("session_login")&"' WHERE RUTDEUDOR='"&rut&"' AND TELEFONO='"&telges&"'"
	Conn.execute(ssql)

	end if


	if categoria="1" and subcategoria="1" then

		ssql="UPDATE DEUDOR_TELEFONO SET ESTADO='2',FechaRevision='"&date&"',UsrRevision='"&session("session_login")&"' WHERE RUTDEUDOR='"&rut&"' AND TELEFONO='"&telges&"'"
		Conn.execute(ssql)


	end if

		if not fono_aportado_fono="" and not fono_aportado_area="" then
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



		ssql2=""
		if fechacompromiso="" and fechacancelo="" then
		ssql2="INSERT INTO GESTIONES ( RutDeudor,CodCliente,NroDoc,Correlativo,CodCategoria,CodSubCategoria,CodGestion,FechaIngreso,HoraIngreso,CodCobrador,NroDocPago,Observaciones,CorrelativoDato,telefono_asociado,direccion_asociada,fecha_retiro)"
		ssql2= ssql2 & "VALUES ('"&rut&"','"&cliente&"','1','"&correlativo&"','"&categoria&"','"&subcategoria&"','"&gestion&"','"&date&"','"&time&"','"& session("session_login") &"','"&comprobante&"','"&UCASE(observaciones)&"','"&cint(correlativo2)&"','"&telges&"','"&dirges&"','"&retiro&"')"
		elseif fechacompromiso="" then
		ssql2="INSERT INTO GESTIONES ( RutDeudor,CodCliente,NroDoc,Correlativo,CodCategoria,CodSubCategoria,CodGestion,FechaIngreso,HoraIngreso,CodCobrador,NroDocPago,FechaPago,Observaciones,CorrelativoDato,telefono_asociado,direccion_asociada,fecha_retiro)"
		ssql2= ssql2 & "VALUES ('"&rut&"','"&cliente&"','1','"&correlativo&"','"&categoria&"','"&subcategoria&"','"&gestion&"','"&date&"','"&time&"','"& session("session_login") &"','"&comprobante&"','"&fechacancelo&"','"&UCASE(observaciones)&"','"&cint(correlativo2)&"','"&telges&"','"&dirges&"','"&retiro&"')"
		elseif fechacancelo="" then
		ssql2="INSERT INTO GESTIONES ( RutDeudor,CodCliente,NroDoc,Correlativo,CodCategoria,CodSubCategoria,CodGestion,FechaIngreso,HoraIngreso,CodCobrador,FechaCompromiso,NroDocPago,Observaciones,CorrelativoDato,telefono_asociado,direccion_asociada,fecha_retiro)"
		ssql2= ssql2 & "VALUES ('"&rut&"','"&cliente&"','1','"&correlativo&"','"&categoria&"','"&subcategoria&"','"&gestion&"','"&date&"','"&time&"','"& session("session_login") &"','"&fechacompromiso&"','"&comprobante&"','"&UCASE(observaciones)&"','"&cint(correlativo2)&"','"&telges&"','"&dirges&"','"&retiro&"')"
		end if
		Conn.execute(ssql2)
		end if
		CerrarSCG()

	end if

	AbrirSCG()
	ssql=""
	ssql="SELECT razon_social_cliente FROM CLIENTE WHERE codigo_cliente='"&cliente&"'"
	set rsCLI=Conn.execute(ssql)
	if not rsCLI.eof then
	nombre_cliente=rsCLI("razon_social_cliente")
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
<table width="680" height="420" border="0">
  <tr>
    <td height="20" ><img src="../lib/TITULO_INGRESO_GESTIONES.gif"></td>
  </tr>
  <tr>
    <td height="20" ><img src="../lib/<%=cliente%>.gif" width="740" height="22"></td>
  </tr>
  <tr>
    <td height="242" valign="top" background="../images/fondo_coventa.jpg">
      <%

	rut = request.QueryString("rut")
	cliente=request.QueryString("cliente")

	if rut="" then

	rut = request.Form("rut_")
	cliente=request.Form("cliente_")



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
		ssql="SELECT TOP 1 CodArea,Telefono,Correlativo FROM DEUDOR_TELEFONO WHERE  RUTDEUDOR='"&rut_deudor&"' ORDER BY Correlativo DESC"
		set rsFON=Conn.execute(ssql)
		if not rsFON.eof then
			codarea_deudor = rsFON("CodArea")
			Telefono_deudor = rsFON("Telefono")
			Correlativo_deudor2 = rsFON("Correlativo")
		end if
		rsFON.close
		set rsFON=nothing
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
        <td width="70%">DIRECCION</td>
        <td width="30%">TELEFONO</td>
      </tr>
      <tr class="Estilo8">
        <td><%if not calle_deudor="" then%>
            <%=calle_deudor%> N&ordm; <%=numero_deudor%> - <%=comuna_deudor%>
            <%end if%>
        </td>
        <td><%if not telefono_deudor="" then%>
            <%=codarea_deudor%>-<%=telefono_deudor%>
            <%end if%></td>
      </tr>
    </table>
	<BR>
	<img src="../lib/HISTORIAL_GESTIONES.gif" width="740" height="22"><BR>
	  <%if not rut="" then%>

	  <input name="rut_" type="hidden" id="rut_" value="<%=rut_deudor%>">
	  <input name="cliente_" type="hidden" id="cliente_" value="<%=cliente%>">
	  <input name="rut_o" type="hidden" id="rut_o" value="<%=rut_deudor_o%>">

	  <%
	  AbrirSCG()
	  ssql=""
	  ssql="SELECT TOP 15 CodCategoria,CodSubCategoria,CodGestion,FechaIngreso,CodCobrador,FechaCompromiso,HoraIngreso,Observaciones,telefono_asociado FROM GESTIONES WHERE RUTDEUDOR='"&rut&"' AND CODCLIENTE='"&cliente&"' order by FechaIngreso desc,HoraIngreso desc"
	  set rsDET=Conn.execute(ssql)
	  if not rsDET.eof then
	  %>
     <table width="100%" border="0" bordercolor="#FFFFFF">
        <tr bordercolor="#FFFFFF" bgcolor="#<%=session("COLTABBG")%>" class="Estilo13">
          <td width="15%" class="Estilo4">FECHA GESTION</td>
          <td width="12%" class="Estilo4">GESTION</td>
          <td width="17%" class="Estilo4">COMPROMISO</td>
          <td width="45%" class="Estilo4">OBSERVACIONES</td>
          <td width="11%" class="Estilo4">FONO</td>
          <td width="11%" class="Estilo4">COBRADOR</td>
          </tr>
		<%do until rsDET.eof
		Obs=UCASE(LTRIM(RTRIM(rsDET("Observaciones"))))
		if Obs="" then
		Obs="SIN INFORMACION ADICIONAL"
		end if
		%>
        <tr bordercolor="#FFFFFF" class="Estilo8">
          <td class="Estilo4"><%=rsDET("FechaIngreso")%></td>
          <td class="Estilo4"><a href= "javascript:ventanaSecundaria('gestion.asp?categoria=<%=rsDET("CodCategoria")%>&subcategoria=<%=rsDET("CodSubCategoria")%>&gestion=<%=rsDET("CodGestion")%>')">VER</a>&nbsp;&nbsp;<%=rsDET("CodCategoria")%><%=rsDET("CodSubCategoria")%><%=rsDET("CodGestion")%></td>
          <td class="Estilo4"><%=rsDET("FechaCompromiso")%></td>
          <td class="Estilo4"><%=Obs%></td>
          <td class="Estilo4"><%=rsDET("telefono_asociado")%></td>
          <td class="Estilo4"><%=UCASE(rsDET("CodCobrador"))%></td>
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
	  <BR>
      <img src="../lib/NUEVA_GESTION.gif" width="740" height="22"><BR>
  	    <table width="100%" border="0" bordercolor="#FFFFFF">
        <tr bordercolor="#999999" bgcolor="#<%=session("COLTABBG")%>" class="Estilo13">
          <td width="33%">CATEGORIA</td>
          <td width="34%">SUBCATEGORIA</td>
          <td width="33%">GESTION</td>
        </tr>
        <tr bordercolor="#999999">
          <td><select name="cmbcat" id="cmbcat" onChange="cargasubcat(this.value);">
		  	<option value="0">SELECCIONE</option>
            <option value="1">CONTACTO EN FONO</option>
            <option value="2">SIN CONTACTO EN FONO</option>
            <option value="3">GESTION DE APOYO</option>
            <option value="4">DIRECCION EXISTE</option>
            <option value="5">DIRECCION NO UBICADA</option>
          </select></td>
          <td><select name="cmbsubcat" id="cmbsubcat" onChange="cargagest(this.value,cmbcat.value);">
		  	  <option value="0">SELECCIONE</option>
          </select></td>
          <td><select name="cmbgest" id="cmbgest" onChange="cajas();">
		   <option value="0">SELECCIONE</option>
          </select></td>
        </tr>
        <tr bgcolor="#<%=session("COLTABBG")%>" class="Estilo13" >
          <td>FECHA DE COMPROMISO</td>
          <td>FECHA EN QUE CANCEL&Oacute; DEUDA</td>
          <td>COMPROBANTE DE PAGO</td>
        </tr>
        <tr>
          <td>
            <input name="inicio" type="text" id="inicio" size="10" maxlength="10" disabled>
		    <a href="javascript:showCal('Calendar7');"><img src="../lib/calendario.gif" border="0"></a>
		  </td>
          <td>
            <input name="termino" type="text" id="termino" size="10" maxlength="10" disabled>
		    <a href="javascript:showCal('Calendar6');"><img src="../lib/calendario.gif" border="0"></a>
		  </td>
          <td><input name="comprobante" type="text" disabled id="comprobante" size="10" maxlength="10"></td>
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
				ssql_ = "SELECT Telefono,Codarea FROM DEUDOR_TELEFONO WHERE RutDeudor='"&rut&"'"
				set rsFON=Conn.execute(ssql_)
				do until rsFON.eof
			  %>
				<option value="<%=rsFON("Telefono")%>"><%=rsFON("Codarea")%>-<%=rsFON("Telefono")%></option>
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
		 <%end if%>

         </select></td>
          <td><input name="observaciones" type="text" id="observaciones" size="70" maxlength="100"></td>
          <td><input name="fono_aportado_area" type="text" id="fono_aportado_area" size="2" maxlength="2">
            -
            <input name="fono_aportado_fono" type="text" id="fono_aportado_fono" size="8" maxlength="8"></td>
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
          <td><select name="dirges" id="dirges" disabled>
            <option value="0">SELECCIONE</option>
            <%
			AbrirSCG()
			ssql_ = "SELECT Calle,Numero,Resto,Comuna FROM DEUDOR_DIRECCION WHERE RutDeudor='"&rut&"'"
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
			<input name="Submit" type="button" onClick="nueva();" value="Ingresar">


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
function nueva(){
if((datos.cmbcat.value=='0')||(datos.cmbsubcat.value=='0')){
	alert('DEBE SELECCIONAR UNA CATEGORÍA O SUBCATEGORÍA');
}else if ((datos.cmbcat.value=='1')&&(datos.cmbsubcat.value=='2')&&(datos.cmbgest.value=='3')){
	if (datos.inicio.value==''){
	alert('DEBE INGRESAR FECHA DE COMPROMISO');
	}else{
	datos.action='detalle_gestiones.asp';
	datos.submit();
	}
}else if ((datos.cmbcat.value=='1')&&(datos.cmbsubcat.value=='2')&&(datos.cmbgest.value=='0')){
	alert('DEBE SELECCIONAR UNA GESTION');
}else if(datos.telges.value=='0'){
	alert('DEBE SELECCIONAR TELÉFONO DE GESTIÓN');
}else{
datos.action='detalle_gestiones.asp';
datos.submit();
}
}

function ficha(){
datos.action='caja.asp';
datos.submit();
}

function cargasubcat(prov){
{
	var comboBox = document.getElementById('cmbsubcat');
	switch (prov)

	{
		case '1':
			comboBox.options.length = 0;
			var newOption = new Option('SELECCIONE', '0');comboBox.options[comboBox.options.length] = newOption;
			var newOption = new Option('FONO NO CORRESPONDE', '1');comboBox.options[comboBox.options.length] = newOption;
			var newOption = new Option('ENTREVISTA CON EL DEUDOR', '2');comboBox.options[comboBox.options.length] = newOption;
			var newOption = new Option('DEUDOR NO RECONOCE DEUDA', '3');comboBox.options[comboBox.options.length] = newOption;
			var newOption = new Option('DEUDOR FALLECIDO', '4');comboBox.options[comboBox.options.length] = newOption;
			var newOption = new Option('CONTACTO CON TERCEROS', '5');comboBox.options[comboBox.options.length] = newOption;

			break;
		case '2':
			 comboBox.options.length = 0;
			var newOption = new Option('SELECCIONE', '0');comboBox.options[comboBox.options.length] = newOption;
			var newOption = new Option('NUMERO FUERA DE SERVICIO', '1');comboBox.options[comboBox.options.length] = newOption;
			var newOption = new Option('NUMERO VACANTE', '2');comboBox.options[comboBox.options.length] = newOption;
			var newOption = new Option('NUMERO CORRESPONDE A FAX', '3');comboBox.options[comboBox.options.length] = newOption;
			var newOption = new Option('CONTESTADOR AUTOMÁTICO', '4');comboBox.options[comboBox.options.length] = newOption;
			var newOption = new Option('TELEFONO NO CONTESTA', '5');comboBox.options[comboBox.options.length] = newOption;
			break;

		case '3':
			comboBox.options.length = 0;
		    var newOption = new Option('SELECCIONE', '0');comboBox.options[comboBox.options.length] = newOption;
			var newOption = new Option('ENVÍO DE CORREO ELECTRÓNICO', '1');comboBox.options[comboBox.options.length] = newOption;
			var newOption = new Option('ENVÍO DE CARTA', '2');comboBox.options[comboBox.options.length] = newOption;
			var newOption = new Option('ENVÍO DE FAX', '3');comboBox.options[comboBox.options.length] = newOption;
			var newOption = new Option('LLAMADA IVR', '4');comboBox.options[comboBox.options.length] = newOption;
			break;

		case '4':
			comboBox.options.length = 0;
			var newOption = new Option('SELECCIONE', '0');comboBox.options[comboBox.options.length] = newOption;
			var newOption = new Option('DEUDOR NO RESIDE', '1');comboBox.options[comboBox.options.length] = newOption;
			var newOption = new Option('ENTREVISTA CON DEUDOR', '2');comboBox.options[comboBox.options.length] = newOption;
			var newOption = new Option('DEUDOR NO RECONOCE DEUDA', '3');comboBox.options[comboBox.options.length] = newOption;
			var newOption = new Option('DEUDOR FALLECIDO', '4');comboBox.options[comboBox.options.length] = newOption;
			var newOption = new Option('CONTACTO CON TERCEROS', '5');comboBox.options[comboBox.options.length] = newOption;
			break;

		case '5':
			comboBox.options.length = 0;
			var newOption = new Option('SELECCIONE', '0');comboBox.options[comboBox.options.length] = newOption;
			var newOption = new Option('NUMERO MUNICIPAL NO EXISTE', '1');comboBox.options[comboBox.options.length] = newOption;
			var newOption = new Option('NOMBRE DE CALLE NO EXISTE', '2');comboBox.options[comboBox.options.length] = newOption;
			var newOption = new Option('SITIO ERIAZO - ABANDONADO', '3');comboBox.options[comboBox.options.length] = newOption;
			var newOption = new Option('TERRENO EN CONSTRUCCIÓN', '4');comboBox.options[comboBox.options.length] = newOption;
			var newOption = new Option('FALTA INFORMACIÓN', '5');comboBox.options[comboBox.options.length] = newOption;
			break;
	}
}}


function cargagest(prov,cat){
{
	var comboBox = document.getElementById('cmbgest');
	switch (cat)
	{
		case '1':
			comboBox.options.length = 0;

			if (prov=='1') {
			var newOption = new Option('SELECCIONE', '0');comboBox.options[comboBox.options.length] = newOption;
			var newOption = new Option('DATOS ADICIONALES', '1');comboBox.options[comboBox.options.length] = newOption;
			var newOption = new Option('SIN DATOS ADICIONALES', '2');comboBox.options[comboBox.options.length] = newOption;
			}else if (prov=='2') {
			var newOption = new Option('SELECCIONE', '0');comboBox.options[comboBox.options.length] = newOption;
			var newOption = new Option('SIN INTENCIÓN DE PAGO', '1');comboBox.options[comboBox.options.length] = newOption;
			var newOption = new Option('CESANTE', '2');comboBox.options[comboBox.options.length] = newOption;
			var newOption = new Option('COMPROMISO DE PAGO', '3');comboBox.options[comboBox.options.length] = newOption;
			var newOption = new Option('DEUDOR SOLICITA DEMANDA', '4');comboBox.options[comboBox.options.length] = newOption;
			var newOption = new Option('REAGENDAR LLAMADA', '5');comboBox.options[comboBox.options.length] = newOption;
			var newOption = new Option('RETIRO DE PAGO A DOMICILIO', '6');comboBox.options[comboBox.options.length] = newOption;
			var newOption = new Option('SOLICITA COBRANZA DE TERRENO', '7');comboBox.options[comboBox.options.length] = newOption;

			}else if (prov=='3'){
			var newOption = new Option('SELECCIONE', '0');comboBox.options[comboBox.options.length] = newOption;
			var newOption = new Option('DEUDA CANCELADA', '1');comboBox.options[comboBox.options.length] = newOption;
			var newOption = new Option('RECLAMO PENDIENTE', '2');comboBox.options[comboBox.options.length] = newOption;
			var newOption = new Option('DEUDA POR NORMALIZAR', '3');comboBox.options[comboBox.options.length] = newOption;
			var newOption = new Option('DEUDOR CON CONVENIO DE PAGO', '4');comboBox.options[comboBox.options.length] = newOption;
			}else{
			var newOption = new Option('SELECCIONE', '0');comboBox.options[comboBox.options.length] = newOption;
			var newOption = new Option('SIN GESTION LA CATEGORIA', '0');comboBox.options[comboBox.options.length] = newOption;
			}
			break;


		case '2':
			comboBox.options.length = 0;
			var newOption = new Option('SIN GESTION LA CATEGORIA', '0');comboBox.options[comboBox.options.length] = newOption;
			break;

		case '3':
			comboBox.options.length = 0;
			if (prov=='4') {
			var newOption = new Option('SELECCIONE', '0');comboBox.options[comboBox.options.length] = newOption;
			var newOption = new Option('LLAMADO POSITIVO', '1');comboBox.options[comboBox.options.length] = newOption;
			var newOption = new Option('LLAMADO NEGATIVO', '2');comboBox.options[comboBox.options.length] = newOption;
			}else{
			var newOption = new Option('SIN GESTION LA CATEGORIA', '0');comboBox.options[comboBox.options.length] = newOption;
			}
			break;

		case '4':
			comboBox.options.length = 0;

			if (prov=='1') {
			var newOption = new Option('DATOS ADICIONALES', '1');comboBox.options[comboBox.options.length] = newOption;
			var newOption = new Option('SIN DATOS ADICIONALES', '2');comboBox.options[comboBox.options.length] = newOption;
			}else if (prov=='2') {
			var newOption = new Option('SIN INTENCIÓN DE PAGO DEMANDABLE', '1');comboBox.options[comboBox.options.length] = newOption;
			var newOption = new Option('SIN INTENCIÓN DE PAGO NO DEMANDABLE', '2');comboBox.options[comboBox.options.length] = newOption;
			var newOption = new Option('CESANTE', '3');comboBox.options[comboBox.options.length] = newOption;
			var newOption = new Option('COMPROMISO DE PAGO', '4');comboBox.options[comboBox.options.length] = newOption;
			}else if (prov=='3'){
			var newOption = new Option('DEUDA CANCELADA', '1');comboBox.options[comboBox.options.length] = newOption;
			var newOption = new Option('RECLAMO PENDIENTE', '2');comboBox.options[comboBox.options.length] = newOption;
			var newOption = new Option('DEUDA POR NORMALIZAR', '3');comboBox.options[comboBox.options.length] = newOption;
			var newOption = new Option('DEUDOR CON CONVENIO DE PAGO', '4');comboBox.options[comboBox.options.length] = newOption;
			}else{
			var newOption = new Option('SIN GESTION LA CATEGORIA', '0');comboBox.options[comboBox.options.length] = newOption;
			}
			break;




		case '5':
			comboBox.options.length = 0;
			var newOption = new Option('SIN GESTION LA CATEGORIA', '0');comboBox.options[comboBox.options.length] = newOption;
			break;


	}
}}

function cajas(){
if((datos.cmbcat.value=='1')&&(datos.cmbsubcat.value=='3')&&(datos.cmbgest.value=='1')){
datos.comprobante.disabled=false;
datos.termino.disabled=false;
}else{
datos.comprobante.disabled=true;
datos.termino.disabled=true;
}


if ((datos.cmbcat.value=='1')&&(datos.cmbsubcat.value=='2')&&(datos.cmbgest.value=='3')){
datos.inicio.disabled=false;
}else{
datos.inicio.disabled=true;
}

if ((datos.cmbcat.value=='1')&&(datos.cmbsubcat.value=='2')&&((datos.cmbgest.value=='6')||(datos.cmbgest.value=='7'))){
datos.retiro.disabled=false;
datos.dirges.disabled=false;
}else{
datos.retiro.disabled=true;
datos.dirges.disabled=true;
}

}
</script>
