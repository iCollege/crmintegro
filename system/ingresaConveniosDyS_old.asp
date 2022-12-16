<%@LANGUAGE="VBSCRIPT" CODEPAGE="1252"%>

<html>
<script language="JavaScript" src="../lib/cal2.js"></script>
<script language="JavaScript" >
addCalendar("Calendar92", "EMPRESA", "FECHA", "convenios");
setFont("tahoma", 9);
setWidth(90, 1, 15, 1);
setSize(200, 0, -200, 16);
</script>
<script language="JavaScript" src="../lib/validaciones.js"></script>
<link href="style.css" rel="stylesheet" type="text/css">


<head>

<title>Ingreso de Convenios DyS</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">


</head>

<body>
<%
Set Conn = Server.CreateObject("ADODB.Connection")
Set ConnD = Server.CreateObject("ADODB.Connection")

Sub AbrirSCG()
	Set Conn = Server.CreateObject("ADODB.Connection")
	Conn.Open "driver=Sql server;Uid=scgweb;Pwd=scgweb;Database=SCG;App=SCG-WEB ingreso convenios DyS;Server=ICARUS"
End Sub

Sub CerrarSCG()
	Conn.close
	set Conn = nothing
End Sub

Sub AbrirDEMO()
	Set ConnD = Server.CreateObject("ADODB.Connection")
	ConnD.Open "driver=Sql server;Uid=SA;Pwd=admin;Database=CALLCENTER;App=SCG-WEB ingreso convenios DyS;Server=DEMOEMPRESA"
End Sub

Sub CerrarDEMO()
	ConnD.close
	set ConnD = nothing
End Sub



cobrador=session("session_login")
rut=request("rut")
Fono=request("telges")
fecha=request("FECHA")
cuotas=request("NROCUOTA")
montocuota=request("VALORCUOTA")
total=request("TOTAL")
folio=request("folio")
producto=request("PRODUCTO")






if ( (rut<>"") and (Fono<>"") and (fecha<>"") and (cuotas<>"") and (montocuota<>"") and (total<>"") and (folio<>"") and (producto<>"") ) then
AbrirSCG()
'ingresa gestion
ssql="insert into gestiones(rutdeudor,codcliente,nrodoc,correlativo,codcategoria,codsubcategoria,codgestion, fechaingreso,horaingreso,codcobrador,fechacompromiso,observaciones,telefono_asociado,CorrelativoDato) "
ssql=ssql +"values('"+rut+"','36','1',dbo.CORRELATIVO_GESTION_CLIENTE ('"+rut+"','36'),1,2,3,getdate(),CONVERT(VARCHAR(20),GETDATE(),108),'" + cobrador + "','"+fecha+"','REALIZO CONVENIO DE PAGO','"+Fono+"',1)"
'response.Write(ssql)
Conn.execute(ssql)



SSQL2=SSQL2 + "insert into ConsolidadosConveniosDys "
SSQL2=SSQL2 + "(codcobrador,rutdeudor,telefono,fechagestion,fechaconvenida,nrocuotas,valorcuotas,total,folio,producto) "
SSQL2=SSQL2 + "values "
SSQL2=SSQL2 + "('" + cobrador + "','"+rut+"',RTRIM(REPLACE('"+Fono+"','-','')),  GETDATE(), '"+fecha+"', "+cuotas+","+montocuota+","+total+",'"+folio+"','"+producto+"')"
'response.Write(SSQL2)
Conn.execute(SSQL2)
CerrarSCG()


AbrirDEMO()

SSQL3= "UPDATE RECORDERMSG SET LABEL='"+rut+"' "
SSQL3=SSQL3 + "WHERE DATEPART(YEAR,RECTIME)= "& YEAR(DATE())
SSQL3=SSQL3 + " AND DATEPART(MONTH,RECTIME)= "& MONTH(DATE())
SSQL3=SSQL3 + " AND DATEPART(DAY,RECTIME)= "& DAY(DATE())
SSQL3=SSQL3 + " AND NROREMOTO LIKE '%'+RTRIM(REPLACE('"+Fono+"','-',''))"
'response.Write(SSQL3)
ConnD.execute(SSQL3)

response.Write("Datos Guardados")

CerrarDEMO()
else

%>

<form name="convenios" method="post" >
<center><strong>INGRESO DE CONVENIOS</strong></center>
  <br>
<br>
<TABLE>
	<TR><td>USUARIO  </td><td>  <strong><%=session("session_login")%></strong></td></TR>
  	<TR><td>RUT CLIENTE </td><td><input name="RUT" type="hidden"  value="<%=rut%>" ><strong><%=rut%></strong></td></TR>
	<TR>
      <td height="28">FONO CONTACTO </td>
      <td>   <select name="telges" id="telges">
          <option value="0">SELECCIONE</option>
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


         </select></td></TR>
    <TR><td>FECHA CONVENIO  </td><td> <strong><%=DATE()%> </strong>  </td></TR>
		 <TR><td>FECHA CONVENIDA </td>
		 <td><input name="FECHA" type="text" maxlength="10">
        <a href="javascript:showCal('Calendar92');"><img src="../lib/calendario.gif" border="0"></a></td>
    </TR>
    <TR><td>CUOTAS   </td><td>   <input type="text" name="NROCUOTA"></td></TR>
    <TR><td>MONTO CUOTA  </td><td>    <input type="text" name="VALORCUOTA"></td></TR>
    <TR><td>TOTAL  </td><td>    <input type="text" name="TOTAL"></td></TR>
    <TR><td>FOLIO   </td><td>   <input type="text" name="FOLIO"></td></TR>
    <TR><td>PRODUCTO  </td><td>    <input type="text" name="PRODUCTO"></td></TR>

</TABLE>
   <br><input name="GRABAR" type="button" value="GRABAR CONVENIO" onClick="envia();" >

  </form>

<%
  end if
%>
</body>
</html>
<script language="JavaScript" type="text/JavaScript">
function ventanaIngresoG (URL){
window.open(URL,"INFORMACION","width=400, height=400, scrollbars=yes, menubar=yes, location=no, resizable=yes")
}

function solonumero(campo){
     //Compruebo si es un valor numérico
      if (isNaN(campo.value)) {
            //entonces (no es numero) devuelvo el valor cadena vacia
            campo.value="";
			campo.focus();
			return "";
      }else{
            //En caso contrario (Si era un número) devuelvo el valor
			campo.value;
			return campo.value;
      }
}

function envia(){


	if (convenios.telges.selectedIndex=='0'){
		alert('Ingrese el Numero de Telefono');
		convenios.telges.focus();
	}else if (!chkFecha(convenios.FECHA)){
		alert('Ingrese Fecha convenida Correcta');
		convenios.FECHA.focus();
	}else if ((convenios.NROCUOTA.value=='') ||  (!solonumero(convenios.NROCUOTA))){
		alert('Ingrese el Numero de Cuotas Valido');
		convenios.NROCUOTA.focus();
	}else if ((convenios.VALORCUOTA.value=='')||  (!solonumero(convenios.VALORCUOTA))){
		alert('Ingrese el Monto de la Cuota Valido');
		convenios.VALORCUOTA.focus();
	}else if ((convenios.TOTAL.value=='')||  (!solonumero(convenios.TOTAL))){
		alert('Ingrese el Total del Monto Valido');
		convenios.TOTAL.focus();
	}else if (convenios.FOLIO.value==''){
		alert('Ingrese el Folio');
		convenios.FOLIO.focus();
	}else if (convenios.PRODUCTO.value==''){
		alert('Ingrese el Producto');
		convenios.PRODUCTO.focus();

	}else{

		convenios.GRABAR.disabled=true;
		convenios.action='ingresaConveniosDyS.asp';
		convenios.RUT.disabled=false;
		convenios.submit();
	}
}

function chkFecha(f) {
  str = f.value

  if (str.length<10){
  	alert("Error - Ingresó una fecha no válida");
  	//f.focus();
  //	f.select();
  }

  if ( !formatoFecha(str) ) {
    alert("Debe indicar la Fecha en formato DD/MM/AAAA. Ejemplo: 'Para 20 de Diciembre de 1982 se debe ingresar 20/12/1982'");
    //f.select()
   // f.focus()
    return false
  }

  // validacion de la fecha
  if ( !validarFecha(str) ) {
    // Los mensajes de error están dentro de validarFecha.
    //f.select()
   // f.focus()
    return false
  }

  return true
}

//-----------------------------------------------------------
  function validarFecha(str_fecha){

  var sl1=str_fecha.indexOf("/")
  var sl2=str_fecha.lastIndexOf("/")
  var inday = parseFloat(str_fecha.substring(0,sl1))
  var inmonth = parseFloat(str_fecha.substring(sl1+1,sl2))
  var inyear = parseFloat(str_fecha.substring(sl2+1,str_fecha.length))

  //alert("day:" + inday + ", mes:" + inmonth + ", agno: " + inyear)

  if (inmonth < 1 || inmonth > 12) {
    alert("Mes inválido en la fecha");
    return false;
  }
  if (inday < 1 || inday > diasEnMes(inmonth, inyear)) {
    alert("Día inválido en la fecha");
    return false;
  }

  return true
}


//------------------------------------------------------------------

function formatoFecha(str) {
  var sl1, sl2, ui, ddstr, mmstr, aaaastr;

  // El formato debe ser d/m/aaaa, d/mm/aaaa, dd/m/aaaa, dd/mm/aaaa,
  // Las posiciones son a partir de 0
  if (str.length < 8 &&  str.length > 10)    // el tamagno es fijo de 8, 9 o 10
    return false


  sl1=str.indexOf("/")
  if (sl1 < 1 && sl1 > 2 )    // el primer slash debe estar en la 1 o 2
    return false

  sl2=str.lastIndexOf("/")
  if (sl2 < 3 &&  sl2 > 5)    // el último slash debe estar en la 3, 4 o 5
    return false

  ddstr = str.substring(0,sl1)
  mmstr = str.substring(sl1+1,sl2)
  aaaastr = str.substring(sl2+1,str.length)

  if ( !sonDigitos(ddstr) || !sonDigitos(mmstr) || !sonDigitos(aaaastr) )
    return false

  return true
}
function sonDigitos(str) {
  var l, car

  l = str.length
  if ( l<1 )
    return false

  for ( i=0; i<l; i++) {
    car = str.substring(i,i+1)
    if ( "0" <= car &&  car <= "9" )
      continue
    else
      return false
  }
  return true
}

function diasEnMes (month, year)
{
  if (month == 1 || month == 3 || month == 5 || month == 7 || month == 8 || month == 10 || month == 12)
    return 31;
  else if (month == 2)
    // February has 29 days in any year evenly divisible by four,
      // EXCEPT for centurial years which are not also divisible by 400.
      return (  ((year % 4 == 0) && ( (!(year % 100 == 0)) || (year % 400 == 0) ) ) ? 29 : 28 );
  else if (month == 4 || month == 6 || month == 9 || month == 11)
    return 30;
  // En caso contrario:
  alert("diasEnMes: Mes inválido");
  return -1;
}
</script>
