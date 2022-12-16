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

	rut = request("rut")
	cliente=request("cliente")
	cliente=session("ses_codcli")

	fono_con = request("fono_con")
	area_con = request("area_con")

	if rut = "" then
		rut=request("rut_")
		cliente=request("cliente_")
		idGestionJudicial=request("CB_GESTIONJUDICIAL")
		idDemanda=request("CB_DEMANDA")
		idRemesa=request("CB_REMESA")
		observaciones=request("observaciones")
		if rut<>"" then
			AbrirSCG()

			ssql2=""
			ssql2="SELECT MAX(Correlativo)+1 AS CORRELATIVO FROM GESTIONES_JUDICIAL WHERE RUTDEUDOR='" & rut & "' AND CODCLIENTE = '"& cliente &"'"
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

			strSql="INSERT INTO GESTIONES_JUDICIAL ( RUTDEUDOR, CODCLIENTE, CORRELATIVO,IDGESTIONJUDICIAL,FECHAINGRESO,HORAINGRESO,IDUSUARIO,OBSERVACIONES,IDDEMANDA) "
			strSql= strSql & "VALUES ('" & rut & "','" & cliente & "'," & correlativo & "," & idGestionJudicial & ",getdate(), '" & time & "','" & session("session_idusuario") &"','" & UCASE(observaciones) & "'," & idDemanda & ")"
			'response.write(strSql)
			'response.End()
			Conn.execute(strSql)

			strSql = "UPDATE CUOTA SET IDGJUDICIAL = " & idGestionJudicial
			strSql = strSql & " WHERE RUTDEUDOR = '" & rut & "' AND CODREMESA = " & idRemesa & " AND CODCLIENTE = '" & cliente & "'"
			'response.write(strSql)
			'response.End()
			Conn.execute(strSql)
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
	ssql="SELECT TOP 1 Calle,Numero,Comuna,Correlativo FROM DEUDOR_DIRECCION WHERE RUTDEUDOR='"&rut_deudor&"' AND ESTADO <> '2' ORDER BY Correlativo DESC"
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
	ssql="SELECT TOP 1 CodArea,Telefono,Correlativo FROM DEUDOR_TELEFONO WHERE  ESTADO<>2 AND RUTDEUDOR='"&rut_deudor&"' AND ESTADO <> '2' ORDER BY Correlativo DESC"
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
    <table width="100%" border="1" bordercolor="#FFFFFF">
     	<tr>
			<TD height="20" ALIGN=LEFT class="pasos2_i">
				<B>Historial de Gestiones Judiciales</B>
			</TD>
  		</tr>
	</table>
	  <%if not rut="" then%>

	  <input name="rut_" type="hidden" value="<%=rut_deudor%>">
	  <input name="cliente_" type="hidden" value="<%=cliente%>">
	  <input name="rut_o" type="hidden" value="<%=rut_deudor_o%>">

	  <%
	  AbrirSCG()
	  ssql=""
	  strSql = "SELECT TOP 100 GESTIONES_JUDICIAL.IDGESTION,IDGESTIONJUDICIAL,CONVERT(VARCHAR(10),FECHAINGRESO,103) as FECHAINGRESO1, CONVERT(VARCHAR(10),FECHAINGRESO,108) as HORAINGRESO, IDDEMANDA,IDUSUARIO,FECHACOMPROMISO,HORAINGRESO,OBSERVACIONES,TELEFONO_ASOCIADO "
	  strSql = strSql & " FROM GESTIONES_JUDICIAL, GESTION_JUDICIAL WHERE GESTIONES_JUDICIAL.IDGESTIONJUDICIAL = GESTION_JUDICIAL.IDGESTION AND RUTDEUDOR='" & rut & "' AND CODCLIENTE='" & cliente &"' ORDER BY FECHAINGRESO DESC"

	  'response.Write(strSql)
	  'response.End

	  set rsDET=Conn.execute(strSql)
	  if not rsDET.eof then
	  %>
     <table width="100%" border="0" bordercolor="#FFFFFF">
        <tr bordercolor="#FFFFFF" bgcolor="#<%=session("COLTABBG")%>" class="Estilo13">
          <td width="15%" class="Estilo4">FECHA</td>
          <td width="15%" class="Estilo4">HORA</td>
          <td width="30%" class="Estilo4">GESTION</td>
          <td width="40%" class="Estilo4">OBSERVACIONES</td>
          <td width="40%" class="Estilo4">DEMANDA</td>
          <td width="15%" class="Estilo4">COBRADOR</td>
          </tr>
		<%do until rsDET.eof
		Obs=UCASE(LTRIM(RTRIM(rsDET("Observaciones"))))
		if Obs="" then
		Obs="SIN INFORMACION ADICIONAL"
		end if

		strUsuario=TraeCampoId(Conn, "LOGIN", Trim(rsDET("IDUSUARIO")), "USUARIO", "ID_USUARIO")
		strGestion=TraeCampoId(Conn, "NOMGESTION", Trim(rsDET("idGestionJudicial")), "GESTION_JUDICIAL", "IDGESTION")
		%>
        <tr bordercolor="#FFFFFF" class="Estilo8">
          <td class="Estilo4"><%=rsDET("FECHAINGRESO1")%></td>
          <td class="Estilo4"><%=rsDET("HORAINGRESO")%></td>
          <td class="Estilo4"><%=strGestion%></td>
          <td class="Estilo4"><%=Mid(Obs,1,80)%></td>
          <td class="Estilo4"><%=UCASE(rsDET("IDDEMANDA"))%></td>
          <td class="Estilo4"><%=UCASE(strUsuario)%></td>
        </tr>
		 <%rsDET.movenext
		 loop
		 %>
      </table>
	  <%
	  else
	  response.Write("MENSAJE : ")
	  response.Write("EL DEUDOR NO POSEE GESTIONES JUDICIALES REGISTRADAS PARA EL CLIENTE ")
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
	  				<B>Nueva Gestión Judicial</B>
	  			</TD>
	    		</TR>
	  	</TABLE>


  	    <table width="100%" border="0" bordercolor="#FFFFFF">
        <tr bordercolor="#999999" bgcolor="#<%=session("COLTABBG")%>" class="Estilo13">
          <td width="40%">CATEGORIA</td>
          <td width="40%">DEMANDA</td>
          <td width="20%">REMESA</td>
        </tr>
        <tr bordercolor="#999999">
          <td>
          <select name="CB_GESTIONJUDICIAL">
          <option value="0">SELECCIONE</option>
    <%
          AbrirSCG()
		  	strSql="SELECT * FROM GESTION_JUDICIAL"
		  	set rsGestCat=Conn.execute(strSql)
		  	Do While not rsGestCat.eof
	%>
		  	<option value="<%=rsGestCat("IDGESTION")%>"><%=rsGestCat("NOMGESTION")%></option>
	<%
		  	rsGestCat.movenext
		  	Loop
		  	rsGestCat.close
		  	set rsGestCat=nothing
			CerrarSCG()
			''Response.End
	%>
          </select>
          </td>
          <td>
          <select name="CB_DEMANDA">
		            <option value="0">SELECCIONE</option>
		      <%
		            AbrirSCG()
		  		  	strSql="SELECT * FROM DEMANDA WHERE RUTDEUDOR = '" & rut & "' AND CODCLIENTE = " & cliente
		  		  	set rsDemanda=Conn.execute(strSql)
		  		  	Do While not rsDemanda.eof
		  	%>
		  		  	<option value="<%=rsDemanda("IDDEMANDA")%>"> Demanda : <%=rsDemanda("IDDEMANDA") & " - "& rsDemanda("FECHA_INGRESO") & " - " & rsDemanda("MONTO")%></option>
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
				<select name="CB_REMESA">
				<option value="0">SELECCIONE</option>
				<%
				AbrirSCG()
				strSql="SELECT * FROM REMESA WHERE CODREMESA >= 100 and codcliente = '" & cliente & "'"
				set rsCLiente=Conn.execute(strSql)
				Do While not rsCLiente.eof
				%>
				<option value="<%=rsCLiente("CODREMESA")%>"> Remesa : <%=rsCLiente("CODREMESA") & " - "& rsCLiente("NOMBRE") & " - " & rsCLiente("FECHA_ASIGNACION")%></option>
				<%
				rsCLiente.movenext
				Loop
				rsCLiente.close
				set rsCLiente=nothing
				CerrarSCG()
				''Response.End
				%>
				</select>
          </td>
        </tr>
        </table>

      <table width="100%" border="0" bordercolor="#FFFFFF">
        <tr bordercolor="#999999" bgcolor="#<%=session("COLTABBG")%>" class="Estilo13" >
          <td width="80%">OBSERVACIONES</td>
          <td width="20%">&nbsp</td>
        </tr>
        <tr bordercolor="#999999">
   	       <td><input name="observaciones" type="text" size="70" maxlength="100"></td>
   	       <td><input name="ingresar" type="button" onClick="nueva();" value="Ingresar"></td>
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

	if(datos.CB_GESTIONJUDICIAL.value=='0')
	{
		alert('DEBE SELECCIONAR UNA GESTION JUDICIAL');
	}
	else if((datos.CB_DEMANDA.value=='0') && (datos.CB_GESTIONJUDICIAL.value > 4))
	{
			alert('DEBE SELECCIONAR DEMANDA ASOCIADA');
	}
	else if(datos.CB_REMESA.value=='0')
	{
			alert('DEBE SELECCIONAR UNA REMESA');
	}
	else
	{

		datos.ingresar.disabled=true;
		datos.action='gestiones_judiciales.asp';
		datos.submit();
	}
}

</script>