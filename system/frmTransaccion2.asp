<% @LCID = 1034 %>
<html>
<!--#include file="arch_utils.asp"-->
<!--#include file="sesion.asp"-->
<!--#include file="../lib/comunes/rutinas/funciones.inc" -->
<!--#include file="../lib/comunes/rutinas/TraeCampo.inc" -->
<!--#include file="asp/comunes/general/RutinasVarias.inc" -->
<!--#include file="asp/comunes/general/Rutinas.inc" -->
<!--#include file="asp/comunes/general/rutinasBooleano.inc" -->

<style type="text/css">
	H1.SaltoDePagina {PAGE-BREAK-AFTER: always}
	.transpa {
	background-color: transparent;
	border: 1px solid #FFFFFF;
	text-align:center
	}

</style>
<head>
<title></title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
</head>
<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<form name="datos" id="datos" method="post">
<%

	strRutDeudor = Request("strRutDeudor")
	strNombreDeudor = Request("strNombreDeudor")
	strTribunal = Request("strTribunal")
	strRol = Request("strRol")
	strDomicilio = Request("strDomicilio")
	strComuna = Request("strComuna")
	intTotalaPagar = Request("strTotalAPagar")
	intIdDemanda = Request("intIdDemanda")

	strCodCliente = Request("strIdCliente")


	If strCodCliente = "1001" Then
		strAbogado = "MARGARITA ANGELICA JORDAN CACERES"
		strRazonSocial = "Sociedad Concesionaria Vespucio Norte Express S.A."
	Else
		strAbogado = "COVADONGA  SAURAS DINTEN"
		strRazonSocial = "Sociedad Concesionaria Autopista Vespucio Sur S.A."
	End if





	rut= LTRIM(RTRIM(cstr(request("rut_"))))
	if cstr(rut) = "" then
		rut = LTRIM(RTRIM(cstr(request("rut"))))
		if rut="" then
			rut = request.QueryString("rut")
		end if
	end if

	if trim(rut) <> "" Then
		session("session_rutdeudor") = rut
	Else
		rut = session("session_rutdeudor")
	End if

	If Trim(Request("Limpiar"))="1" Then
		session("session_rutdeudor") = ""
		rut = ""
	End if

	''Response.write "intTotalaPagar=" & intTotalaPagar

	abrirscg()
	strSql=""
	strSql="SELECT MAX(ID_PAGO) as IDPAGO FROM CAJA_WEB_EMP WHERE RUTDEUDOR = '" & strRutDeudor & "' AND COD_CLIENTE = '" & strCodCliente & "'"
	set rsIdPago=Conn.execute(strSql)
	If Not rsIdPago.eof Then
		intIdPago = rsIdPago("IDPAGO")
	End if

	'Response.write "intIdPago=" & intIdPago
	'Response.End

	If Trim(intIdPago) = "" or IsNull(intIdPago) Then
		%>
		<script language="JavaScript" type="text/JavaScript">
			alert("Deudor no tiene pagos ingresado en el sistema, no puede generar transacción");
			history.back();
		</script>
		<%
		Response.End
	End If

	If Trim(intIdPago) <> "" Then
		strSql=""
		strSql="SELECT TOTAL_CLIENTE + TOTAL_EMP  as TOTAL FROM CAJA_WEB_EMP WHERE ID_PAGO = " & intIdPago
		set rsIdPago=Conn.execute(strSql)
		If Not rsIdPago.eof Then
			intTotalaPagar = rsIdPago("TOTAL")
		End if
	Else
		intTotalaPagar = ""
	End if


	If Trim(intIdPago) <> "" Then
		strSql=""
		strSql="SELECT TOP 1 MONTO AS EFECTIVO FROM CAJA_WEB_EMP_DOC_PAGO WHERE ID_PAGO = " & intIdPago
		'Response.Write strSql
		set rsIdPago=Conn.execute(strSql)
		If Not rsIdPago.eof Then
			intTotalEFectivo = rsIdPago("EFECTIVO")
		End if
	End If

	If Trim(intIdPago) <> "" Then
		strSql=""
		strSql="SELECT TOP 1 NRO_CTACTE , NOMBRE_B FROM CAJA_WEB_EMP_DOC_PAGO D , BANCOS B WHERE FORMA_PAGO = 'CF' AND ID_PAGO = " & intIdPago & " AND B.CODIGO = D.COD_BANCO"
		set rsIdPago=Conn.execute(strSql)
		If Not rsIdPago.eof Then
			strBanco = rsIdPago("NOMBRE_B")
			strNroCtaCte = rsIdPago("NRO_CTACTE")
		End if
	End If

	If Trim(intIdPago) <> "" Then

		strSql=""
		strSql="SELECT COUNT(MONTO) AS CANTCUOTAS, MAX(MONTO) AS VALORCUOTA, MAX(VENCIMIENTO) as MAXVENCIMIENTO, MIN(VENCIMIENTO) as MINVENCIMIENTO FROM CAJA_WEB_EMP_DOC_PAGO WHERE FORMA_PAGO = 'CF' AND ID_PAGO = " & intIdPago
		set rsIdPago=Conn.execute(strSql)
		If Not rsIdPago.eof Then
			intCantCuotas = rsIdPago("CANTCUOTAS")
			intValorCuota = rsIdPago("VALORCUOTA")
			intDiaCuota1= Mid(rsIdPago("MINVENCIMIENTO"),1,2)
			intMesCuota1= Mid(rsIdPago("MINVENCIMIENTO"),4,2)
			intAnoCuota1= Mid(rsIdPago("MINVENCIMIENTO"),7,4)
			intDiaCuotaN= Mid(rsIdPago("MAXVENCIMIENTO"),1,2)
			intMesCuotaN= Mid(rsIdPago("MAXVENCIMIENTO"),4,2)
			intAnoCuotaN= Mid(rsIdPago("MAXVENCIMIENTO"),7,4)
		End if

	End if

	intSaldo = intTotalaPagar - intTotalEFectivo

	strSql=""
	strSql="SELECT NRODOC FROM CAJA_WEB_EMP_DETALLE WHERE ID_PAGO = " & intIdPago

	set rsDocs=Conn.execute(strSql)
	Do While Not rsDocs.eof
		strDocsDemanda = strDocsDemanda & ", " & rsDocs("NRODOC")
		rsDocs.movenext
	Loop

	strDocsDemanda = Mid(strDocsDemanda,2,len(strDocsDemanda))

%>


<body>
<form name="form1" method="post" action="">



<TABLE ALIGN="CENTER" BORDER=0 CELLSPACING=0 CELLPADDING=0 WIDTH="650">
<TR ALIGN="LEFT" VALIGN=middle">
	<TD>

	<p><strong>TRANSACCION</strong></p>
	<p><strong>&nbsp;</strong></p>
	<p><strong>&nbsp;</strong></p>
	<p align="center"><strong>S.  J. L DE POLICIA LOCAL <%=UCASE(strTribunal)%><!--input type="text" name="TX_JUZGADO" VALUE=<%=strTribunal%>--></strong></p>
	<p align="center"><strong>&nbsp;</strong></p>
	<p><strong><%=strAbogado%>, </strong>Abogada, en Representaci&oacute;n de <%=strRazonSocial%>, demandante y don(&ntilde;a)<strong>,</strong> ___________________________ c&eacute;dula de identidad ________________ , de profesi&oacute;n             ___________________,
	domiciliado en ________________________________________  en representaci&oacute;n de seg&uacute;n se acreditar&aacute; de don(&ntilde;a) <strong><%=strNombreDeudor%></strong> c&eacute;dula de identidad  <%=strRutDeudor%> , de profesi&oacute;n__________________ domiciliado(a) en  <b><%=strDomicilio%></b>
	<!--input name="TX_CALLE" type="text" size="50" maxlength="100" value="<%=strDomicilio%>" class="transpa"-->
	comuna de <b><%=strComuna%></b>
	<!--input type="text" name="TX_COMUNA" size="30" maxlength="50" value="<%=strComuna%>" class="transpa"-->
	; demandado de autos, en autos rol  <%=strRol%>
	<!--input type="text" name="TX_ROL" /-->
&nbsp; caratulados a SS. respetuosamente decimos:</p>
	<p>Que con  esta fecha, las partes involucradas en este proceso hemos logrado el presente avenimiento que solicitamos se tenga aprobado por SS.:</p>
	<p></p>
	<p>:</p>
	<p align="left"><strong><u>PRIMERO</u></strong>: La parte demandada, declara que debe a la parte demandante <%=strRazonSocial%>, por concepto de peaje y/o  tarifa del uso de las autopistas concecsionadas, m&aacute;s los respectivos   recargos legales,
	la suma de $ (<%=intTotalaPagar%>)<!--input name="TX_TOTALDEUDA" type="text" size="10" maxlength="10" value="<%=intTotalaPagar%>" class="transpa"-->
	 . Las boletas o facturas que se repactan en este acto son: </p>
	<p align="left">
	   <%=strDocsDemanda%>
  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</p>
	<p><strong><u>SEGUNDO</u></strong>: La cantidad mencionada anteriormente, se realizara de la  siguiente forma:</p>
	<ol>
	<ul>
	  <li>Pago al d&iacute;a ascendiente a la  suma de $&nbsp;(<%=intTotalEFectivo%>)
	    <!--input name="TX_EFECTIVO" type="text" size="10" maxlength="10" VALUE="<%=intTotalEFectivo%>" class="transpa"-->
	    &nbsp;en efectivo.</li>
	  <li>El saldo&nbsp; correspondiente a la suma de $&nbsp;(<%=intSaldo%>)
	    <!--input name="TX_DOCS3" type="text" size="6" maxlength="10" VALUE="<%=intSaldo%>" class="transpa"-->
	    &nbsp; , ser&aacute;n pagadas en&nbsp;
	    (<%=intCantCuotas%><!--input name="TX_CANTCUOTAS" type="text" size="1" maxlength="2"  VALUE="<%=intCantCuotas%>" class="transpa"-->)
	    cheques de $ (<%=intValorCuota%><!--input name="TX_VALORCUOTA" type="text" size="6" maxlength="10" VALUE="<%=intValorCuota%>" class="transpa"-->
	    ) del Banco
	    (<%=strBanco%><!--input name="TX_DIACUOTA" type="text" size="1" maxlength="2" VALUE="<%=intDiaCuota1%>" class="transpa"-->)&nbsp; , numero de cuenta corriente (<%=strNroCtaCte%><!--input name="TX_ANOCUOTA1" type="text" size="4" maxlength="4" VALUE="<%=intAnoCuota1%>" class="transpa"-->)&nbsp;&nbsp;con vencimiento los dias
	    (<%=intDiaCuotaN%><!--input name="TX_DIACUOTAN" type="text" size="1" maxlength="2" VALUE="<%=intDiaCuotaN%>" class="transpa"-->)&nbsp; de
	    cada mes.	    </li>
	  </ul>

	<p><strong><u>TERCERO</u></strong>: Todo retraso o protesto en los documentos entregados,  autoriza a <%=strRazonSocial%>, a cobrar, en  forma directa o por intermedio de Reintegra SPA&nbsp;  los respectivos intereses, sin perjuicio de los dem&aacute;s recargos legales  que corresponda en caso de tener que proceder a exigir el cumplimiento forzado de la  obligaci&oacute;n que asume el demandado de autos Don/Do&ntilde;a <%=strNombreDeudor%>
	<!--input name="TX_NOMBRE2" type="text" size="50" maxlength="100" value="<%=strNombreDeudor%>" class="transpa"-->
	, en raz&oacute;n  del presente avenimiento, o en caso de tener que iniciar acciones judiciales en los Tribunales Ordinarios de Justicia por protestos en los documentos entregados en este acto.</p>
	<p>&nbsp;</p>


	</TD>
</TR>
</TABLE>


<BR>
<H1 class=SaltoDePagina> </H1>
<BR>

<TABLE ALIGN="CENTER" BORDER=0 CELLSPACING=0 CELLPADDING=0 WIDTH="650">
<TR ALIGN="LEFT" VALIGN=middle">
	<TD>


	<p><strong><u>CUARTO</u></strong>: Don/o&ntilde;a, <%=strNombreDeudor%>
	  <!--input name="TX_NOMBRE3" type="text" size="50" maxlength="100" value="<%=strNombreDeudor%>" class="transpa"-->
	, declara que el domicilio  identificado en la comparecencia le corresponde actualmente, oblig&aacute;ndose a  informar a la <%=strRazonSocial%> y / o a la Empresa Reintegra  SPA&nbsp; de cualquier cambio de domicilio o  direcci&oacute;n que experimente, dejando constancia que en caso de no informar dicho  cambio de domicilio, no ser&aacute; oponible a la empresa concesionaria.</p>
	<p><strong><u>QUINTO</u></strong>: Las partes de com&uacute;n acuerdo&nbsp;  establecen que solo otorgaran finiquito una vez&nbsp; que el demandado de autos haya pagado hasta  la &uacute;ltima cuota pactada en el avenimiento contrato de transacci&oacute;n, renunciando a toda acci&oacute;n que pudiera emanar de estos autos; con la sola excepci&oacute;n de aquellas acciones que emanen de un eventual incumplimiento del presente avenimiento por parte de algunos de los comparecientes, en cuyo caso la parte demandante quedar&aacute; facultada para solicitar ante vuestro Tribunal su cumplimiento incidental, por el monto total de lo demandado en autos, m&aacute;s la indemnizaci&oacute;n compensatoria seg&uacute;n lo establece el art&iacute;culo 42 de la Ley de Concesiones, todo con reajustes, intereses y costas.<br />
	</p>
	<p><strong><u>SEXTO:</u></strong> En caso e existir medida precautoria en contra del veh&iacute;culo de propiedad del demandado de autos, el respectivo alzamiento de la medida ser&aacute; solicitado al cumplimiento integro y oportuno del presente contrato.</p>
	<p><strong><u>SEPTIMO:</u></strong> Las partes de com&uacute;n acuerdo solicitan a S.S. aprobar el presente  avenimiento, disponer que se otorgue copia autorizada de la misma a la parte  que lo solicite y &nbsp;ordenar el archivo de  los antecedentes.</p>
	<p align="center"><strong>POR TANTO;</strong></p>
	<p><strong>RUEGO A U. S: </strong>Tener  presente la transacci&oacute;n precedente y aprobarla para todos los efectos legales.</p>
	<p><strong>OTROSI: PIDO A SS.</strong> se sirva tener por acompa&ntilde;ado, bajo apercibimiento se&ntilde;alado en art&iacute;culo 346 N&ordm; 3 de C&oacute;digo de Procedimiento Civil , escrito en el cual consta poder otorgado por el demandado a mi persona, bajo el cual me autoriza para comparecer a su nombre en los autos ya individualizados. </p></TD>
</TR>
</TABLE>
</form>

</body>
</html>



<script language="JavaScript" type="text/JavaScript">
function ModificaOtros(){
	datos.TX_NOMBRE2.value = datos.TX_NOMBRE.value
	datos.TX_NOMBRE3.value = datos.TX_NOMBRE.value

}

</script>


