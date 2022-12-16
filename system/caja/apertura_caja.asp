<% @LCID = 1034 %>
<!--#include file="../arch_utils.asp"-->
<!--#include file="../../lib/comunes/rutinas/funciones.inc" -->
<!--#include file="../../lib/comunes/rutinas/TraeCampo.inc" -->
<!--#include file="../asp/comunes/general/rutinasSCG.inc" -->

<script language="JavaScript" src="../../lib/cal2.js"></script>
<script language="JavaScript" src="../../lib/cal_conf2.js"></script>
<script language="JavaScript" src="../../lib/validaciones.js"></script>
<link href="style.css" rel="stylesheet" type="text/css">
<%


	AbrirSCG()
	intCodUsuario=session("session_idusuario")
	strCuadrar = Trim(request("strCuadrar"))

	'intCodUsuario = 110
	strsql="select * from usuario where id_usuario = " & intCodUsuario & ""
	set rsUsu=Conn.execute(strsql)
	if not rsUsu.eof then
		perfil=rsUsu("perfil_caja")

		if perfil = "caja_modif" or perfil = "caja_listado" then
			IF request("cmb_sucursal") <> "" THEN
				sucursal = request("cmb_sucursal")
			ELSE
				sucursal = rsUsu("cod_suc")
			END IF
		else
			sucursal = "" 'rsUsu("cod_suc")
		end if
	end if
	'response.write(perfil)
	codpago = request("TX_pago")
	strrut=request("TX_RUT")
	if sucursal="" then sucursal="0"
	'response.write(sucursal)
	usuario = request("cmb_usuario")
	if usuario = "" then usuario = "0"
	termino = request("termino")
	inicio = request("inicio")
	resp = request("resp")
	GRABA = request("GRABA")
	if Trim(inicio) = "" Then
		inicio = TraeFechaMesActual(Conn,0)
		'inicio = "01" & Mid(inicio,3,10)
	End If
	if Trim(termino) = "" Then
		termino = TraeFechaActual(Conn)
	End If
	'hoy=date

	'response.write(hoy)
%>
<title>Empresa</title>
<style type="text/css">
<!--
.Estilo13 {color: #FFFFFF}
.Estilo13n {color: #000000}
.Estilo27 {color: #FFFFFF}
-->
</style>

<script language="JavaScript " type="text/JavaScript">

function muestra_dia(){
//alert(getCurrentDate())
//alert("hola")
	var diferencia=DiferenciaFechas(datos.termino.value)
	//alert(diferencia)
	if(datos.termino.value!=''){
		if ((diferencia<=0)) {
			//alert('Ok')
			return true
		}else{
			alert('La fecha de apertura no puede ser posterior a la fecha actual')
			datos.termino.value = getCurrentDate();
			datos.termino.focus();
			return false;
		}
	}
}


function DiferenciaFechas (CadenaFecha1) {
   var fecha_hoy = getCurrentDate() //hoy


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

function Refrescar()
{
	GRABA='no'
	resp='no'

	datos.action = "apertura_caja.asp?GRABA="+ GRABA +"&resp="+ resp +"";
	datos.submit();
}



function Ingresa()
{
	GRABA='si'
	resp='si'
	strCuadrar='no'


	if (datos.TX_BOLETAINICIAL.value == '' || datos.TX_ASIGNACION.value == '')
	{
		alert("Debe ingresar boleta y asignacion para abrir la caja");
		return;
	}
	if (confirm("¿Está seguro de realizar la apertura de caja?"))
		{
		datos.action = "apertura_caja.asp?strCuadrar="+ strCuadrar +"&GRABA="+ GRABA +"&resp="+ resp +"";
		datos.submit();
		}
	else
		alert("Proceso de apertura de caja no se ha realizado");

}


function Cuadrar()
{
	//datos.TX_RUT.value='';
	//datos.TX_pago.value='';
	GRABA='no'
	resp='si'
	strCuadrar='si'
	datos.action = "apertura_caja.asp?strCuadrar="+ strCuadrar +"&GRABA="+ GRABA +"&resp="+ resp +"";
	datos.submit();
}


function envia()
{
	//datos.TX_RUT.value='';
	//datos.TX_pago.value='';
	GRABA='no'
	resp='si'
	strCuadrar='no'
	datos.action = "apertura_caja.asp?strCuadrar="+ strCuadrar +"&GRABA="+ GRABA +"&resp="+ resp +"";
	datos.submit();
}

function envia_excel(URL){

window.open(URL,"INFORMACION","width=200, height=200, scrollbars=yes, menubar=yes, location=yes, resizable=yes")
}
</script>


<link href="style.css" rel="Stylesheet">

<form name="datos" method="post">
<table width="600" height="500" border="1">
  <tr>
    <td height="20" bordercolor="#999999"  bgcolor="#<%=session("COLTABBG")%>" class="Estilo13" ALIGN="CENTER">
    <B>APERTURA DE CAJA</B>
    </td>
  </tr>
  <tr>
    <td valign="top">
	<table width="100%" border="0" bordercolor="#999999">
	</table>
	<table width="100%" border="0" bordercolor="#999999">
	      <tr height="20" bordercolor="#999999"  bgcolor="#<%=session("COLTABBG")%>" class="Estilo13">
			<td colspan=2>
				Datos Apertura de caja
			</td>
		  </tr>
		  <tr height="20" bordercolor="#999999" class="Estilo8">
			<td class="hdr_i" width="45%">
				Fecha Hora Apertura
			</td>
			<td class="td_t" width="55%">
				<%=now()%>
			</td>
		  </tr>
		  <tr height="20" bordercolor="#999999" class="Estilo8">
			<td class="hdr_i">
				Usuario
			</td>
			<td class="td_t">
				<%=session("nombre_user")%>
			</td>
		  </tr>
		  <tr height="20" bordercolor="#999999" class="Estilo8">
		  	<td class="hdr_i">
				Boleta Inicial
			</td>
			<td class="td_t">
				<INPUT NAME="TX_BOLETAINICIAL" TYPE="TEXT" VALUE="<%=intBoletaInicial%>" SIZE="10" MAXLENGTH="10">
			</td>
		  </tr>
		  <tr height="20" bordercolor="#999999" class="Estilo8">
				<td class="hdr_i">
					Asignación de Caja
				</td>
				<td class="td_t">
					<INPUT NAME="TX_ASIGNACION" TYPE="TEXT" VALUE="<%=intAsignaciom%>" SIZE="10" MAXLENGTH="10">
				</td>
		  </tr>
		  <tr height="20" bordercolor="#999999" class="Estilo8">
			<td class="hdr_i">
				Apertura dia siguiente
			</td>
			<td class="td_t">
				<INPUT TYPE=CHECKBOX NAME="CH_DIASGTE">
			</td>
		  </tr>



	      <tr bordercolor="#999999" class="Estilo8">
			<td colspan=2>
				<input type="Button" name="Submit" value="Abrir" onClick="Ingresa();">
			</td>
     	  </tr>


    </table>
	</td>
	</tr>

</table>


	<%If GRABA = "si" Then
		fecha = inicio
		intAsignacion = Request("TX_ASIGNACION")
		strBoletaInicial = Request("TX_BOLETAINICIAL")
		sw=0
		Response.write "CH_DIASGTE=" & Request("CH_DIASGTE")
		If Request("CH_DIASGTE") <> "" Then
			strSql="SELECT * FROM CAJA_WEB_EMP_CIERRE WHERE COD_USUARIO = " & intCodUsuario & " AND FECHA_APERTURA = '" & DateAdd("d",1,fecha) & "'"
			set rsApertura=Conn.execute(strSql)
			If rsApertura.EOF Then
				strsql = "INSERT INTO CAJA_WEB_EMP_CIERRE (COD_USUARIO, FECHA_APERTURA, FECHA, ASIGNACION, BOLETA_INICIAL) VALUES (" & intCodUsuario & ",'" & DateAdd("d",1,fecha) & "',GETDATE()," & intAsignacion & ",'" & strBoletaInicial & "')"
				'Response.write (strsql)
				'Response.End
				set rsGRABA=Conn.execute(strsql)
				Response.Write ("<script language = ""Javascript"">" & vbCrlf)
				Response.Write (vbTab & "location.href='apertura_caja.asp?rut=" & rut & "&tipo=1';" & vbCrlf)
				Response.Write (vbTab & "alert('Apertura de caja realizada correctamente');" & vbCrlf)
				Response.Write ("</script>")
			Else
				%>
					<script>
					if (confirm("La caja ya se encuentra abierta para este día : <%= DateAdd("d",1,fecha) %>."))
							{
							<%

							'strsql = "INSERT INTO CAJA_WEB_EMP_CIERRE (COD_USUARIO, FECHA_APERTURA, FECHA, ASIGNACION, BOLETA_INICIAL) VALUES (" & intCodUsuario & ",'" & fecha & "',dateadd(day,1, getdate())," & intAsignacion & ",'" & strBoletaInicial & "')"
							'set rsGRABA=Conn.execute(strsql)

							%>
							//alert("Ya esta abierta para el dia sgte.");
							}
						else
					alert("Proceso de apertura de caja no se ha realizado");
					</script>
				<%
			End if
		Else
			strSql="SELECT * FROM CAJA_WEB_EMP_CIERRE WHERE COD_USUARIO = " & intCodUsuario & " AND FECHA_APERTURA = '" & fecha & "'"
			set rsApertura=Conn.execute(strSql)
			If rsApertura.EOF Then
				strsql = "INSERT INTO CAJA_WEB_EMP_CIERRE (COD_USUARIO, FECHA_APERTURA, FECHA, ASIGNACION, BOLETA_INICIAL) VALUES (" & intCodUsuario & ",'" & fecha & "',GETDATE()," & intAsignacion & ",'" & strBoletaInicial & "')"
				'Response.write (strsql)
				'Response.End
				set rsGRABA=Conn.execute(strsql)
				Response.Write ("<script language = ""Javascript"">" & vbCrlf)
				Response.Write (vbTab & "location.href='apertura_caja.asp?rut=" & rut & "&tipo=1';" & vbCrlf)
				Response.Write (vbTab & "alert('Apertura de caja realizada correctamente');" & vbCrlf)
				Response.Write ("</script>")
			Else
				%>
					<script>
					if (confirm("La caja ya se encuentra abierta para este día : <%=fecha%>."))
							{
							<%

							'strsql = "INSERT INTO CAJA_WEB_EMP_CIERRE (COD_USUARIO, FECHA_APERTURA, FECHA, ASIGNACION, BOLETA_INICIAL) VALUES (" & intCodUsuario & ",'" & fecha & "',dateadd(day,1, getdate())," & intAsignacion & ",'" & strBoletaInicial & "')"
							'set rsGRABA=Conn.execute(strsql)

							%>
							//alert("Ya esta abierta para el dia sgte.");
							}
						else
					alert("Proceso de apertura de caja no se ha realizado");
					</script>
				<%

			End if


		End if
	  End if
	%>
	</td>
   </tr>
  </table>

</form>


<script language="JavaScript" type="text/JavaScript">



function solonumero(valor){
     //Compruebo si es un valor numérico

 if (valor.value.length >0){
      if (isNaN(valor.value)) {
            //entonces (no es numero) devuelvo el valor cadena vacia
            ////valor.value="0";
			//alert(valor.value)
			//valor.focus();
			return ""
      }else{
            //En caso contrario (Si era un número) devuelvo el valor
			valor.value
			return valor.value
      }
	  }
}

</script>

