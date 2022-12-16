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

	if rut = "" then
	rut = request.Form("rut_")
	cliente = request.Form("cliente_")
	categoria = request.Form("cmbcat")
	subcategoria = request.Form("cmbsubcat")
	gestion = request.Form("cmbgest")
	fechacompromiso = request.Form("inicio")
	fechacancelo = request.Form("termino")
	comprobante = request.Form("comprobante")
	observaciones = request.Form("observaciones")
	telges = request.Form("telges")
	dirges = request.Form("dirges")
	retiro = request.Form("retiro")
	fono_aportado_fono = request.Form("fono_aportado_fono")
	fono_aportado_area = request.Form("fono_aportado_area")
	valida_dir = request.form("validar_dir")
		if not rut = "" then
		AbrirSCG()


	if valida_dir <> "0" then
		ssql="UPDATE DEUDOR_DIRECCION SET ESTADO='"&valida_dir&"',FechaRevision='"&date&"',UsrRevision='"&session("session_login")&"' WHERE RUTDEUDOR='"&rut&"' AND correlativo='"&dirges&"'"
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
	ssql="SELECT DESC_CLI FROM CLIENTES WHERE cod_cli='"&cliente&"'"
	set rsCLI=Conn.execute(ssql)
	if not rsCLI.eof then
	nombre_cliente=rsCLI("DESC_CLI")
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
    <td height="20" ><img src="../lib/<%  IF CLIENTE=19 THEN RESPONSE.WRITE("10") ELSE       RESPONSE.WRITE(cliente)   END IF %>.gif" width="740" height="22"></td>
  </tr>
  <tr>
    <td height="242" valign="top" background="../images/fondo_coventa.jpg">
      <%

	rut = request.QueryString("rut")
	cliente=request.querystring("cliente")

	if rut="" then

	rut = request.Form("rut_")
	cliente=request.form("cliente_")



	end if


		AbrirSCG()
		ssql="SELECT TOP 1 NOMBREDEUDOR,RUTDEUDOR FROM DEUDOR WHERE RUTDEUDOR='"&rut&"' AND NOMBREDEUDOR IS NOT NULL AND LTRIM(RTRIM(NOMBREDEUDOR)) <> '' "
		set rsDEU=Conn.execute(ssql)
		if not rsDEU.eof then
			nombre_deudor = rsDEU("NOMBREDEUDOR")
			rut_deudor = rsDEU("RUTDEUDOR")

		else
			ssql2="SELECT TOP 1 NOMBRE,RUT FROM DEUDOR_INP WHERE RUT='"&rut&"' AND NOMBRE IS NOT NULL AND LTRIM(RTRIM(NOMBRE)) <> '' "
			set rsDEU2=Conn.execute(ssql2)
			if not rsDEU2.eof then
				nombre_deudor = rsDEU2("NOMBRE")
				rut_deudor = rsDEU2("RUT")

			else
				rut_deudor = rut
				nombre_deudor = "SIN NOMBRE"
			end if
			rsDEU2.close
			set rsDEU2=nothing
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
	  'ssql="SELECT TOP 15 CodCategoria,CodSubCategoria,CodGestion,FechaIngreso,CodCobrador,FechaCompromiso,HoraIngreso,Observaciones,telefono_asociado FROM GESTIONES WHERE RUTDEUDOR='"&rut&"' AND CODCLIENTE='"&cliente&"' order by FechaIngreso desc,HoraIngreso desc"

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
	ssql=ssql + "END as CodGestion, fechaIngreso,codcobrador,fechacompromiso,horaingreso, observaciones, telefono_asociado "
	ssql=ssql + "from gestiones "
	ssql=ssql + "where rutdeudor= '"&rut&"' AND CODCLIENTE='"&cliente&"' "
	ssql=ssql + "order by FechaIngreso desc,HoraIngreso desc"
	  'response.Write(ssql)
	  'response.End()

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
            <!-- <option value="1">CONTACTO EN FONO</option>
            <option value="2">SIN CONTACTO EN FONO</option>
            <option value="3">GESTION DE APOYO</option> -->
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
            <input name="inicio" type="text" id="inicio" size="10" maxlength="10" onBlur="muestra_dia();">
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
          <td width="40%">DIRECCIÓN GESTION </td>
          <td width="60%">OBSERVACIONES</td>
        </tr>
        <tr bordercolor="#999999">
		<input name="validar_dir" type="hidden" value="0">
          <td><select name="dirges" id="dirges">
            <option value="0">SELECCIONE</option>
            <%
			AbrirSCG()
			ssql_ = "SELECT * FROM DEUDOR_DIRECCION WHERE RutDeudor='"&rut&"' and (estado = 1 or estado =0) order by estado desc,correlativo desc"
			num=0
		    set rsDIR=Conn.execute(ssql_)
		  	do until rsDIR.eof
			direccion = rsDIR("calle")+" "+rsDIR("Numero")+" "+rsDIR("Resto")+" "+rsDIR("COMUNA")

		  %>
            <option value="<%=rsDIR("Correlativo")%>"><%=direccion%></option>
            <%
		 	rsDIR.movenext
			loop
			rsDIR.close
			set rsDIR=nothing
			CerrarSCG()
		 %>
          </select></td>
          <td><input name="observaciones" type="text" id="observaciones" size="70" maxlength="100"></td>

        </tr>
      </table>
	  <table width="100%"  border="0">
        <tr>
          <td width="17%" bordercolor="#999999" bgcolor="#<%=session("COLTABBG")%>" class="Estilo13 Estilo34"><%=cliente%>COBRADOR</td>
          <td bgcolor="#<%=session("COLTABBG")%>"><span class="Estilo35">FECHA RETIRO </span></td>
          <td bgcolor="#<%=session("COLTABBG")%>"><span class="Estilo35">INGRESAR </span></td>
          </tr>
        <tr>
          <td bordercolor="#999999"><%=session("session_login")%></td>
			 <td><input name="retiro" type="text" id="retiro" size="10" maxlength="10" disabled>
            <a href="javascript:showCal('Calendar2');"><img src="../lib/calendario.gif" border="0"></a></td>
          <td>
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

function nueva(){
if ((datos.cmbcat.value=='4')&&(datos.cmbsubcat.value>1)){
	datos.validar_dir.value='1'
}else{
	datos.validar_dir.value='2'
}
if((datos.cmbcat.value=='0')||(datos.cmbsubcat.value=='0')){
	alert('DEBE SELECCIONAR UNA CATEGORÍA O SUBCATEGORÍA');
}else if ((datos.cmbcat.value >'3')&&(datos.cmbsubcat.value >'0')&&(datos.cmbgest.value == '0')){
	alert('DEBE SELECCIONAR UNA GESTION');
}else if (datos.dirges.value=='0'){
	alert('DEBE SELECCIONAR LA DIRECCION DE GESTION');
}else if ((datos.cmbcat.value=='4')&&(datos.cmbsubcat.value=='2')&&(datos.cmbgest.value=='4')){
		if (datos.inicio.value==''){
			alert('DEBE INGRESAR FECHA DE COMPROMISO');
		}else{
			datos.ingresar.disabled=true
			datos.action='detalle_gestiones_terreno.asp';
			datos.submit();
		}
}else if ((datos.cmbcat.value=='4')&&(datos.cmbsubcat.value=='3')&&(datos.cmbgest.value=='1')){
	if ((datos.termino.value=='')||(datos.comprobante.value=='')){
		alert('DEBE INGRESAR FECHA DE PAGO Y COMPROBANTE DE PAGO');
	}else{
		datos.ingresar.disabled=true
		datos.action='detalle_gestiones_terreno.asp';
		datos.submit();
	}
}else if ((datos.cmbcat.value=='4')&&(datos.cmbsubcat.value=='1')&&(datos.cmbgest.value=='1')){
	if (datos.observaciones.value==''){
		alert('DEBE INGRESAR UNA OBSERVACIÓN');
	}else{
		datos.ingresar.disabled=true
		datos.action='detalle_gestiones_terreno.asp';
		datos.submit();
	}
}else{
		datos.ingresar.disabled=true
		datos.action='detalle_gestiones_terreno.asp';
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
			var newOption = new Option('SIN GESTION LA CATEGORIA', '1');comboBox.options[comboBox.options.length] = newOption;
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
			var newOption = new Option('SELECCIONE', '0');comboBox.options[comboBox.options.length] = newOption;
			var newOption = new Option('DATOS ADICIONALES', '1');comboBox.options[comboBox.options.length] = newOption;
			var newOption = new Option('SIN DATOS ADICIONALES', '2');comboBox.options[comboBox.options.length] = newOption;
			}else if (prov=='2') {
			var newOption = new Option('SELECCIONE', '0');comboBox.options[comboBox.options.length] = newOption;
			var newOption = new Option('SIN INTENCIÓN DE PAGO DEMANDABLE', '1');comboBox.options[comboBox.options.length] = newOption;
			var newOption = new Option('SIN INTENCIÓN DE PAGO NO DEMANDABLE', '2');comboBox.options[comboBox.options.length] = newOption;
			var newOption = new Option('CESANTE', '3');comboBox.options[comboBox.options.length] = newOption;
			var newOption = new Option('COMPROMISO DE PAGO', '4');comboBox.options[comboBox.options.length] = newOption;
			}else if (prov=='3'){
			var newOption = new Option('SELECCIONE', '0');comboBox.options[comboBox.options.length] = newOption;
			var newOption = new Option('DEUDA CANCELADA', '1');comboBox.options[comboBox.options.length] = newOption;
			var newOption = new Option('RECLAMO PENDIENTE', '2');comboBox.options[comboBox.options.length] = newOption;
			var newOption = new Option('DEUDA POR NORMALIZAR', '3');comboBox.options[comboBox.options.length] = newOption;
			var newOption = new Option('DEUDOR CON CONVENIO DE PAGO', '4');comboBox.options[comboBox.options.length] = newOption;
			}else{
			var newOption = new Option('SELECCIONE', '0');comboBox.options[comboBox.options.length] = newOption;
			var newOption = new Option('SIN GESTION LA CATEGORIA', '1');comboBox.options[comboBox.options.length] = newOption;
			}
			break;




		case '5':
			comboBox.options.length = 0;
			var newOption = new Option('SELECCIONE', '0');comboBox.options[comboBox.options.length] = newOption;
			var newOption = new Option('SIN GESTION LA CATEGORIA', '1');comboBox.options[comboBox.options.length] = newOption;
			break;


	}
}}

function cajas(){
if ((datos.cmbcat.value=='4')&&(datos.cmbsubcat.value=='2')&&(datos.cmbgest.value=='4')){
datos.inicio.disabled=false;
}else{
datos.inicio.disabled=true;
}

if((datos.cmbcat.value=='4')&&(datos.cmbsubcat.value=='3')&&(datos.cmbgest.value=='1')){
datos.comprobante.disabled=false;
datos.termino.disabled=false;
}else{
datos.comprobante.disabled=true;
datos.termino.disabled=true;
}

}
</script>
