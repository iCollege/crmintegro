<% @LCID = 1034 %>
<!--#include file="../arch_utils.asp"-->
<!--#include file="../sesion.asp"-->
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
	strsql="SELECT * FROM USUARIO WHERE ID_USUARIO = " & intCodUsuario & ""
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
			''sucursal = rsUsu("cod_suc")
		end if
	end if
	'response.write(perfil)
	codpago = request("TX_PAGO")
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


	strsql = "SELECT ISNULL(SUM(ASIGNACION),0) AS ASIG FROM CAJA_WEB_EMP_CIERRE "
	strsql = strsql & "WHERE COD_USUARIO = " & intCodUsuario & " AND FECHA_APERTURA >= '" & inicio & " 00:00 ' AND FECHA_APERTURA <= '" & termino & " 23:59'"
	set rsFechas=Conn.execute(strsql)
	If not rsFechas.eof then
		intValorAsigCaja = rsFechas("ASIG")
		intValorCajaAsigCaja = intValorAsigCaja
	Else
		intValorAsigCaja = 0
		intValorCajaAsigCaja = 0
	End If

	'hoy=date

	''Response.write(strsql)
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
			alert('La fecha de cierre no puede ser posterior a la fecha actual')
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

	datos.action = "cerrar_caja_web_V2.asp?GRABA="+ GRABA +"&resp="+ resp +"";
	datos.submit();
}



function Ingresa()
{
	GRABA='si'
	resp='si'
	strCuadrar='no'
	if (!muestra_dia()) return;
	if (confirm("¿Está seguro de cerrar la caja,? no podrá seguir ingresando pagos para el día de hoy."))
		{
		datos.action = "cerrar_caja_web_V2.asp?strCuadrar="+ strCuadrar +"&GRABA="+ GRABA +"&resp="+ resp +"";
		datos.submit();
		}
	else
		alert("Caja no será cerrada");

}


function Cuadrar()
{
	//datos.TX_RUT.value='';
	//datos.TX_pago.value='';
	GRABA='no'
	resp='si'
	strCuadrar='si'
	datos.action = "cerrar_caja_web_V2.asp?strCuadrar="+ strCuadrar +"&GRABA="+ GRABA +"&resp="+ resp +"";
	datos.submit();
}


function envia()
{
	//datos.TX_RUT.value='';
	//datos.TX_pago.value='';
	GRABA='no'
	resp='si'
	strCuadrar='no'
	datos.action = "cerrar_caja_web_V2.asp?strCuadrar="+ strCuadrar +"&GRABA="+ GRABA +"&resp="+ resp +"";
	datos.submit();
}

function envia_excel(URL){

window.open(URL,"INFORMACION","width=200, height=200, scrollbars=yes, menubar=yes, location=yes, resizable=yes")
}
</script>


<link href="style.css" rel="Stylesheet">

<form name="datos" method="post">
<table width="600" height="500" border="0">
  <tr>
    <td height="20" bordercolor="#999999"  bgcolor="#<%=session("COLTABBG")%>" class="Estilo13" ALIGN="CENTER">CERRAR CAJA</td>
  </tr>
  <tr>
    <td valign="top">
	<table width="100%" border="0" bordercolor="#999999">
	</table>
	<table width="100%" border="0" bordercolor="#999999">
	      <tr height="20" bordercolor="#999999"  bgcolor="#<%=session("COLTABBG")%>" class="Estilo13">
		  <%if perfil="caja_modif" or perfil = "caja_listado" then%>
	        <td>SUCURSAL</td>
			<%end if%>
			<td>DESDE</td>
			<td>HASTA</td>

	      </tr>
		  <tr bordercolor="#999999" class="Estilo8">
		  <%if perfil="caja_modif" or perfil = "caja_listado" then%>
	        <td>
				<SELECT NAME="cmb_sucursal" id="cmb_sucursal" onchange="Refrescar();">
				<option value="0">TODAS</option>
				<%
				strSql="SELECT * FROM sucursal where cod_suc > 0 order by cod_suc"
				set rsSuc=Conn.execute(strSql)
				if not rsSuc.eof then
					do until rsSuc.eof
					%>
					<option value="<%=rsSuc("cod_suc")%>"
					<%if Trim(sucursal)=Trim(rsSuc("cod_suc")) then
						response.Write("Selected")
					end if%>
					><%=ucase(rsSuc("cod_suc") & " - " & rsSuc("DES_suc"))%></option>

					<%rsSuc.movenext
					loop
				end if
				rsSuc.close
				set rsSuc=nothing
				%>
				</SELECT>
			</td>
			<%end if%>
			<td><input name="inicio" type="text" id="inicio" value="<%=inicio%>" size="10" maxlength="10">
		<a href="javascript:showCal('Calendar7');"><img src="../../images/calendario.gif" border="0"></a>
			</td>
			<td><input name="termino" type="text" id="termino" value="<%=termino%>" size="10" maxlength="10">
          <a href="javascript:showCal('Calendar6');"><img src="../../images/calendario.gif" border="0"></a>
			<input type="Button" name="Submit" value="Ver" onClick="envia();">

			<input type="Button" name="Submit" value="Cerrar" onClick="Ingresa();">

			</td>
	      </tr>
    </table>

	<% if resp="si" then

	if strCuadrar = "si" then


		intValorChequeDia = ValNulo(Request("TX_CHEQUEDIA"),"N")
		intValorChequeFecha = ValNulo(Request("TX_CHEQUEFECHA"),"N")
		intValorEfectivo = ValNulo(Request("TX_EFECTIVO"),"N")
		intValorDeposito = ValNulo(Request("TX_DEPOSITO"),"N")
		intValorValeVista = ValNulo(Request("TX_VALEVISTA"),"N")
		intValorTotal = ValNulo(Request("TX_TOTALHABER"),"N")



		intValorCajaChequeDia = ValNulo(Request("hd_valChequeDia"),"N")
		intValorCajaChequeFecha = ValNulo(Request("hd_valChequeFecha"),"N")
		intValorCajaEfectivo = ValNulo(Request("hd_valEfectivo"),"N")
		intValorCajaDeposito = ValNulo(Request("hd_valDeposito"),"N")
		intValorCajaValeVista = ValNulo(Request("hd_valValeVista"),"N")
		intValorCajaTotal = ValNulo(Request("hd_valTotal"),"N")



		strDescChequeDia = ValNulo(Request("TX_CHEQUEDIA"),"N") - ValNulo(Request("hd_valChequeDia"),"N")
		strDescChequeFecha = ValNulo(Request("TX_CHEQUEFECHA"),"N") - ValNulo(Request("hd_valChequeFecha"),"N")
		strDescEfectivo = ValNulo(Request("TX_EFECTIVO"),"N") - ValNulo(Request("hd_valEfectivo"),"N")
		strDescDeposito = ValNulo(Request("TX_DEPOSITO"),"N") - ValNulo(Request("hd_valDeposito"),"N")
		strDescValeVista = ValNulo(Request("TX_VALEVISTA"),"N") - ValNulo(Request("hd_valValeVista"),"N")
		strDescTotal = ValNulo(Request("TX_TOTALHABER"),"N") - ValNulo(Request("hd_valTotal"),"N")


	End If

	%>
	<table width="100%" border="0" bordercolor="#000000">
		<tr bordercolor="#999999"  bgcolor="#<%=session("COLTABBG")%>" class="Estilo13">
			<td>FORMA DE PAGO</td>
			<td>MONTO CLIENTE</td>
			<td>MONTO EMPRESA</td>
			<td>TOTAL</td>
		</tr>
	<%
	'dim vectormontos
			SQL = "SELECT * FROM CAJA_FORMA_PAGO WHERE ID_FORMA_PAGO NOT IN ('AB')"
			set rsDet=Conn.execute(SQL)
		if not rsDet.eof then


			Do while not rsDet.eof
				forma_pago = rsDet("id_forma_pago")
				nom_forma_pago = rsDet("desc_forma_pago")
				strSql="SELECT  SUM(CWDP.MONTO) AS MONTO FROM CAJA_WEB_EMP CWC,CAJA_WEB_EMP_DOC_PAGO CWDP WHERE CWC.ID_PAGO = CWDP.ID_PAGO "
				strSql=strSql & " AND CWDP.FORMA_PAGO = '" & forma_pago & "' AND CWDP.TIPO_PAGO = 0 AND DATEDIFF(DAY,'" & INICIO & "',FECHA_PAGO)>=0 AND DATEDIFF(day,FECHA_PAGO,'" & TERMINO & "')>=0 "
				strSql=strSql & " AND CWC.RUTDEUDOR NOT IN (SELECT RUTDEUDOR FROM |) "
				strSql=strSql & " GROUP BY CWDP.TIPO_PAGO"
				'Response.write strSql
				set rsPago=Conn.execute(strSql)
				monto_cliente = 0
				if not rsPago.eof then

					do while not rsPago.eof
						monto_cliente = monto_cliente + rsPago("MONTO")
						rsPago.movenext
					loop

				end if
				total_cliente = total_cliente + monto_cliente

				strSql="SELECT  SUM(CWDP.MONTO) AS MONTOINT FROM CAJA_WEB_EMP CWC,CAJA_WEB_EMP_DOC_PAGO CWDP WHERE CWC.ID_PAGO = CWDP.ID_PAGO "
				if sucursal <> 0 then
					strSql =strSql & " AND SUCURSAL = " & SUCURSAL & " "
				end if
				strSql= strSql & "AND CWDP.FORMA_PAGO = '" & forma_pago & "' AND CWDP.TIPO_PAGO = 1 AND DATEDIFF(DAY,'" & INICIO & "',FECHA_PAGO)>=0 AND DATEDIFF(day,FECHA_PAGO,'" & TERMINO & "')>=0 GROUP BY CWDP.TIPO_PAGO"
				'Response.write strSql
				set rsPago2=Conn.execute(strSql)
				monto_intercapital = 0
				if not rsPago2.eof then

					do while not rsPago2.eof
						monto_intercapital = monto_intercapital + rsPago2("MONTOINT")
						rsPago2.movenext
					loop

				end if
				total_intercapital = total_intercapital + monto_intercapital


				If Trim(forma_pago) = "CD" Then
				%>
				<INPUT TYPE="hidden" NAME="hd_valChequeDia" value="<%=monto_cliente + monto_intercapital%>">
	       		<%
				End If
				If Trim(forma_pago) = "CF" Then
				%>
				<INPUT TYPE="hidden" NAME="hd_valChequeFecha" value="<%=monto_cliente + monto_intercapital%>">
				<%
				End If
				If Trim(forma_pago) = "EF" Then
				%>
				<INPUT TYPE="hidden" NAME="hd_valEfectivo" value="<%=monto_cliente + monto_intercapital%>">
				<%
				End If
				If Trim(forma_pago) = "DP" Then
				%>
				<INPUT TYPE="hidden" NAME="hd_valDeposito" value="<%=monto_cliente + monto_intercapital%>">
				<%
				End If
				If Trim(forma_pago) = "VV" Then
				%>
				<INPUT TYPE="hidden" NAME="hd_valValeVista" value="<%=monto_cliente + monto_intercapital%>">
				<%
				End If


			%>
			<tr bgcolor="#<%=session("COLTABBG2")%>" class="Estilo8">
				<td align="left"><%= UCASE(nom_forma_pago)%></td>
				<td align="right"><%= formatnumber(monto_cliente,0)%></td>
				<td align="right"><%= formatnumber(monto_intercapital,0)%></td>
				<td align="right"><%= formatnumber(monto_cliente + monto_intercapital,0)%></td>
			</tr>
			<%
			rsDet.movenext
			Loop
		end if
		%>
		<tr bordercolor="#999999"  bgcolor="#<%=session("COLTABBG")%>" class="Estilo13">
				<td align="left">TOTAL</td>
				<td align="right"><%= formatnumber(total_cliente,0)%></td>
				<td align="right"><%= formatnumber(total_intercapital,0)%></td>
				<td align="right" bgcolor="#<%=session("COLTABBG2")%>">

				<A HREF="detalle_cuadratura.asp?resp=SI&INICIO=<%=INICIO%>&TERMINO=<%=TERMINO%>"><%= formatnumber(total_cliente + total_intercapital + intValorCajaAsigCaja,0)%></A>


				</td>
		</tr>
		</table>
		<INPUT TYPE="hidden" NAME="hd_valTotal" value="<%=total_cliente + total_intercapital + intValorCajaAsigCaja%>">

	<BR>
	<table width="100%" border="0" bordercolor="#000000">
		<tr bordercolor="#999999"  bgcolor="#<%=session("COLTABBG")%>" class="Estilo13">
			<TD WIDTH="30%">CLIENTE</td>
			<TD WIDTH="10%">EFECTIVO</td>
			<td WIDTH="20%">BANCO</td>
			<td WIDTH="10%">CHEQUE AL DIA</td>
			<td WIDTH="20%">BANCO</td>
			<td WIDTH="10%">CHEQUE A FECHA</td>
		</tr>

		<%
		X = 1
		DO WHILE X < 2
			intEfectivoEmpresa = 0
			strBancoEmpresaEfec = ""
			intEmpresaCD = 0
			strBancoEmpresaCD = ""
			intEmpresaCFC = 0


			'************************************************************
			'* 					EFECTIVO 			 					*
			'*															*
			'************************************************************


			''strSql = "SELECT CWDP.TIPO_PAGO,ISNULL(SUM(CWDP.MONTO),0) AS MONTOINT,NOMBRE_B FROM CAJA_WEB_EMP CWC,CAJA_WEB_EMP_DOC_PAGO CWDP, BANCOS B WHERE CWC.ID_PAGO = CWDP.ID_PAGO AND CWC.BCO_DEPOSITO_EMP = B.CODIGO "
			strSql = "SELECT CWDP.TIPO_PAGO,ISNULL(SUM(CWDP.MONTO),0) AS MONTOINT FROM CAJA_WEB_EMP CWC,CAJA_WEB_EMP_DOC_PAGO CWDP WHERE CWC.ID_PAGO = CWDP.ID_PAGO "
			if sucursal <> 0 then
				strSql = strSql & " AND SUCURSAL = " & SUCURSAL & " "
			end if
			strSql= strSql & "AND CWDP.FORMA_PAGO = 'EF' AND CWDP.TIPO_PAGO in (" & X & ") AND DATEDIFF(DAY,'" & INICIO & "',FECHA_PAGO)>=0 AND DATEDIFF(day,FECHA_PAGO,'" & TERMINO & "')>=0 GROUP BY CWDP.TIPO_PAGO"
			set rsEmpresa=Conn.execute(strSql)
			if not rsEmpresa.eof then
				intEfectivoEmpresa = rsEmpresa("MONTOINT")
				''strBancoEmpresaEfec = rsEmpresa("NOMBRE_B")
				intTotalEfectivo = intTotalEfectivo + intEfectivoEmpresa
			END IF


			'************************************************************
			'* 					CHEQUE AL DIA EMPRESA					*
			'*															*
			'************************************************************

			strSql = "SELECT CWDP.TIPO_PAGO,ISNULL(SUM(CWDP.MONTO),0) AS MONTOINT,NOMBRE_B FROM CAJA_WEB_EMP CWC,CAJA_WEB_EMP_DOC_PAGO CWDP, BANCOS B WHERE CWC.ID_PAGO = CWDP.ID_PAGO AND CWDP.COD_BANCO *= B.CODIGO "
			strSql = strSql & "AND CWDP.FORMA_PAGO = 'CD' AND CWDP.TIPO_PAGO in (" & X & ") AND DATEDIFF(DAY,'" & INICIO & "',FECHA_PAGO)>=0 AND DATEDIFF(day,FECHA_PAGO,'" & TERMINO & "')>=0 GROUP BY CWDP.TIPO_PAGO,NOMBRE_B"
			set rsEmpresaCD=Conn.execute(strSql)

			if not rsEmpresaCD.eof then
				'intEmpresaCD = rsEmpresaCD("MONTOINT")
				'strBancoEmpresaCD = rsEmpresaCD("NOMBRE_B")
				'intTotalCDEmpresa = intTotalCDEmpresa + intEmpresaCD
			End If



			'************************************************************
			'* 					CHEQUE A FECHA EMPRESA					*
			'*															*
			'************************************************************

			strSql = "SELECT CWDP.TIPO_PAGO,ISNULL(SUM(CWDP.MONTO),0) AS MONTOINT,NOMBRE_B  FROM CAJA_WEB_EMP CWC,CAJA_WEB_EMP_DOC_PAGO CWDP, BANCOS B WHERE CWC.ID_PAGO = CWDP.ID_PAGO AND CWDP.COD_BANCO *= B.CODIGO "
			strSql = strSql + "AND CWDP.FORMA_PAGO = 'CF' AND CWDP.TIPO_PAGO in (" & X & ") AND DATEDIFF(DAY,'" & INICIO & "',FECHA_PAGO)>=0 AND DATEDIFF(day,FECHA_PAGO,'" & TERMINO & "')>=0 GROUP BY CWDP.TIPO_PAGO,NOMBRE_B"

			'Response.write "<br>" & strSql
			'Response.End
			set rsEmpresaCF=Conn.execute(strSql)
			if not rsEmpresaCF.eof then
				'intEmpresaCF = rsEmpresaCF("MONTOINT")
				'intTotalCF = intTotalCF + intEmpresaCF
				'strBancoEmpresaCD = rsEmpresaCF("NOMBRE_B")
			END IF



			IF X = 1 THEN EMPRESA = "Empresa"
			IF X = 2 THEN EMPRESA = "Costas"
			%>
			<tr bgcolor="#<%=session("COLTABBG2")%>" class="Estilo8">
				<TD><%=EMPRESA%></TD>
				<TD ALIGN="RIGHT"><b><%=FORMATNUMBER(intEfectivoEmpresa,0)%></b></td>

				<td colspan="2">
				<table width="100%" border="0" bordercolor="#000000">
				<%
				Do While Not rsEmpresaCD.Eof
					intEmpresaCD = rsEmpresaCD("MONTOINT")
					strBancoEmpresaCD = rsEmpresaCD("NOMBRE_B")
					intTotalEmpresaCD = intTotalEmpresaCD + intEmpresaCD
				%>
				<tr>
				<td align="LEFT"><%=strBancoEmpresaCD%></td>
				<td ALIGN="RIGHT"><%=FORMATNUMBER(intEmpresaCD,0)%></td>
				</tr>

				<%
					rsEmpresaCD.movenext
				Loop
				%>

				<tr>
					<td align="LEFT"><B>TOTAL</B></td>
					<td ALIGN="RIGHT"><B><%=FORMATNUMBER(intTotalEmpresaCD,0)%></B></td>
				</tr>

				</table>
				</TD>



				<td colspan="2">
					<table width="100%" border="0" bordercolor="#000000">
					<%
					Do While Not rsEmpresaCF.Eof
						intEmpresaCF = rsEmpresaCF("MONTOINT")
						strBancoEmpresaCF = rsEmpresaCF("NOMBRE_B")
						intTotalEmpresaCF = intTotalEmpresaCF + intEmpresaCF
					%>
					<tr>
					<td align="LEFT"><%=strBancoEmpresaCF%></td>
					<td ALIGN="RIGHT"><%=FORMATNUMBER(intEmpresaCF,0)%></td>
					</tr>

					<%
						rsEmpresaCF.movenext
					Loop
					%>

					<tr>
						<td align="LEFT"><B>TOTAL</B></td>
						<td ALIGN="RIGHT"><B><%=FORMATNUMBER(intTotalEmpresaCF,0)%></B></td>
					</tr>

					</table>
				</TD>
			</tr>
		<%
			X = X + 1
		LOOP
		strSql = "SELECT * FROM CLIENTE WHERE ACTIVO = 1 AND CODCLIENTE <> '999'"
		set rsCliente=Conn.execute(strSql)
		if not rsCliente.eof then
			do while not rsCliente.eof
				EF = 0
				CD = 0
				CF = 0
				BANCOEF = ""
				BANCOCD = ""

				CLIENTE = rsCliente("CODCLIENTE")

				''strSql = "SELECT  ISNULL(SUM(CWDP.MONTO),0) AS MONTO ,NOMBRE_B FROM CAJA_WEB_EMP CWC,CAJA_WEB_EMP_DOC_PAGO CWDP, BANCOS B WHERE CWC.ID_PAGO = CWDP.ID_PAGO AND CWC.BCO_DEPOSITO_CLIENTE = B.CODIGO "
				strSql = "SELECT  ISNULL(SUM(CWDP.MONTO),0) AS MONTO FROM CAJA_WEB_EMP CWC,CAJA_WEB_EMP_DOC_PAGO CWDP WHERE CWC.ID_PAGO = CWDP.ID_PAGO"
				strSql = strSql & " AND CWDP.FORMA_PAGO in ('EF')  AND CWDP.TIPO_PAGO = 0 AND CWC.COD_CLIENTE = '" & CLIENTE & "' AND DATEDIFF(DAY,'" & INICIO & "',FECHA_PAGO)>=0 AND DATEDIFF(day,FECHA_PAGO,'" & TERMINO & "')>=0 GROUP BY CWDP.TIPO_PAGO"
				''Response.write "<br>strSql=" & strSql
				set rsDetalle=Conn.execute(strSql)

				IF NOT rsDetalle.EOF THEN
					EF = rsDetalle("MONTO")
					intTotalEfectivo = intTotalEfectivo  + EF
				END IF



				strSql = "SELECT  ISNULL(SUM(CWDP.MONTO),0) AS MONTO ,NOMBRE_B FROM CAJA_WEB_EMP CWC,CAJA_WEB_EMP_DOC_PAGO CWDP, BANCOS B WHERE CWC.ID_PAGO = CWDP.ID_PAGO AND CWDP.COD_BANCO = B.CODIGO "
				strSql = strSql & "AND CWDP.FORMA_PAGO in ('CD')  AND CWDP.TIPO_PAGO = 0 AND CWC.COD_CLIENTE = '" & CLIENTE & "' AND DATEDIFF(DAY,'" & INICIO & "',FECHA_PAGO)>=0 AND DATEDIFF(day,FECHA_PAGO,'" & TERMINO & "')>=0 GROUP BY CWDP.TIPO_PAGO,NOMBRE_B"
				set rsDetalleCD=Conn.execute(strSql)

				If Not rsDetalleCD.EOF THEN
					CD = rsDetalleCD("MONTO")
					BANCOCD = rsDetalleCD("NOMBRE_B")
					intTotalCD = intTotalCD + CD
				End if



				strSql = "SELECT  ISNULL(SUM(CWDP.MONTO),0) AS MONTO ,NOMBRE_B FROM CAJA_WEB_EMP CWC,CAJA_WEB_EMP_DOC_PAGO CWDP, BANCOS B WHERE CWC.ID_PAGO = CWDP.ID_PAGO AND CWDP.COD_BANCO = B.CODIGO "
				if sucursal <> 0 then
					strSql =strSql & " AND SUCURSAL = " & SUCURSAL & " "
				end if
				strSql = strSql & " AND CWDP.FORMA_PAGO in ('CF')  AND CWDP.TIPO_PAGO = 0 AND CWC.COD_CLIENTE = '" & CLIENTE & "' AND DATEDIFF(DAY,'" & INICIO & "',FECHA_PAGO)>=0 AND DATEDIFF(day,FECHA_PAGO,'" & TERMINO & "')>=0 GROUP BY CWDP.TIPO_PAGO,NOMBRE_B"
				'Response.write "<br>strSql=" & strSql
				set rsDetalleCF=Conn.execute(strSql)
				If not rsDetalleCF.EOF THEN
					CF = rsDetalleCF("MONTO")
					'CHEQUESBANCO = rsDetalleCF("NOMBRE_B")
					intTotalCF = intTotalCF + CF
				End if
				BANCO = ""

					%>
					<tr bgcolor="#<%=session("COLTABBG2")%>" class="Estilo8">
						<TD><%=rsCliente("DESCRIPCION")%></TD>
						<TD ALIGN="RIGHT"><b><%=formatnumber(EF,0)%></b></td>

						<td COLSPAN=2>
							<table width="100%" border="0" bordercolor="#000000">
								<%
								''intTotalCDia = 0
								intTotalCDiaSubTotal = 0
								Do while not rsDetalleCD.eof
									CD = rsDetalleCD("MONTO")
									BANCOCD = rsDetalleCD("NOMBRE_B")
									intTotalCDia = intTotalCDia + CD
									intTotalCDiaSubTotal = intTotalCDiaSubTotal + CD

									''rESPONSE.WRITE "<BR>CD=" & CD
									%>

									<TR>
										<TD ALIGN="LEFT" width="58%"><%=BANCOCD%></TD>
										<TD ALIGN="RIGHT" width="42%"><%=formatnumber(CD,0)%></TD>
									</TR>

									<%
									rsDetalleCD.movenext
								Loop

								%>

								<TR>
									<TD ALIGN="LEFT" width="58%"><B>TOTAL</B></TD>
									<TD ALIGN="RIGHT" width="42%"><B><%=formatnumber(intTotalCDiaSubTotal,0)%></B></TD>
								</TR>


							</TABLE>
						</TD>



						<td COLSPAN=2>
							<TABLE width="100%" border = 0 VALIGN="TOP">
								<%
								''intTotalCFecha = 0
								intTotalCFechaSubTotal = 0
								Do while not rsDetalleCF.eof
									CF = rsDetalleCF("MONTO")
									BANCOCF = rsDetalleCF("NOMBRE_B")
									intTotalCFecha = intTotalCFecha + CF
									intTotalCFechaSubTotal = intTotalCFechaSubTotal + CF
									%>

									<TR>
										<TD ALIGN="LEFT" width="58%"><%=BANCOCF%></TD>
										<TD ALIGN="RIGHT" width="42%"><%=formatnumber(CF,0)%></TD>
									</TR>

									<%
									rsDetalleCF.movenext
								Loop
								%>
								<TR>
									<TD ALIGN="LEFT" width="58%"><B>TOTAL</B></TD>
									<TD ALIGN="RIGHT" width="42%"><B><%=formatnumber(intTotalCFechaSubTotal,0)%></B></TD>
								</TR>
							</TABLE>
						</td>

					</tr>
					<%
				rsCliente.movenext
			loop
		end if
		%>
		<TR bordercolor="#999999"  bgcolor="#<%=session("COLTABBG")%>" class="Estilo13">
			<TD><b>TOTAL</b></TD>
			<TD ALIGN = "RIGHT"><b><%=FORMATNUMBER(intTotalEfectivo,0)%></b></TD>
			<TD></TD>
			<TD ALIGN = "RIGHT"><b><%=FORMATNUMBER(intTotalCDia + intTotalEmpresaCD,0)%></b></TD>
			<TD></TD>
			<TD ALIGN = "RIGHT"><b><%=FORMATNUMBER(intTotalCFecha + intTotalEmpresaCF,0)%></b></TD>
		</TR>


		<TR class="Estilo13">
			<TD COLSPAN="6" ALIGN = "RIGHT">&nbsp;</TD>
		</TR>



		<TR bordercolor="#999999"  bgcolor="#<%=session("COLTABBG")%>" class="Estilo13">
			<TD><b>TOTAL CHEQUES EMPRESA</b></TD>
			<TD ALIGN = "RIGHT"><b></b></TD>
			<TD></TD>
			<TD ALIGN = "RIGHT">&nbsp;</b></TD>
			<TD></TD>
			<TD ALIGN = "RIGHT"><b><%=FORMATNUMBER(intTotalEmpresaCF + intTotalEmpresaCD,0)%></b></TD>
		</TR>

		<TR bordercolor="#999999"  bgcolor="#<%=session("COLTABBG")%>" class="Estilo13">
			<TD><b>TOTAL CHEQUES CLIENTE</b></TD>
			<TD ALIGN = "RIGHT"><b></b></TD>
			<TD></TD>
			<TD ALIGN = "RIGHT">&nbsp;</b></TD>
			<TD></TD>
			<TD ALIGN = "RIGHT"><b><%=FORMATNUMBER(intTotalCDia + intTotalCFecha,0)%></b></TD>
		</TR>

		<TR bordercolor="#999999"  bgcolor="#<%=session("COLTABBG")%>" class="Estilo13">
			<TD><b>TOTAL CHEQUES</b></TD>
			<TD ALIGN = "RIGHT"><b></b></TD>
			<TD></TD>
			<TD ALIGN = "RIGHT">&nbsp;</b></TD>
			<TD></TD>
			<TD ALIGN = "RIGHT"><b><%=FORMATNUMBER(intTotalCDia + intTotalEmpresaCD + intTotalCFecha + intTotalEmpresaCF,0)%></b></TD>

		</TR>


	</table>



<br>
<br>

	<table width="600" height="500" border="1">

	<tr>
		<td height="20" bordercolor="#999999"  bgcolor="#<%=session("COLTABBG")%>" class="Estilo13" ALIGN="CENTER">
		CUADRATURA CAJA
		</td>
	</tr>

	<tr>
		<td height="20" class="Estilo13n" ALIGN="LEFT">
		HABER EXISTENTE
		</td>
	</tr>
  <tr>
    <td valign="top">
	<table width="100%" border="0" bordercolor="#999999">
		<tr height="20" bordercolor="#999999"  bgcolor="#<%=session("COLTABBG2")%>" class="Estilo13n">
			<td width="25%">&nbsp;</td>
			<td width="15%">&nbsp;</td>
			<td width="20%" ALIGN="RIGHT"><B>Total Caja</B></td>
			<td width="20%" ALIGN="RIGHT"><B>Total Sistema</B></td>
			<td width="20%" ALIGN="RIGHT"><B>Diferencia</B></td>
		</tr>
		<tr height="20" bordercolor="#999999"  bgcolor="#<%=session("COLTABBG2")%>" class="Estilo13n">
			<td>ASIGNACION DE CAJA</td>
			<td><input name="TX_ASIGCAJA" type="text" value="<%=intValorAsigCaja%>" size="10" maxlength="10" DISABLED onchange=""></td>
			<td ALIGN="RIGHT"><%=FN(intValorAsigCaja,0)%></td>
			<td ALIGN="RIGHT"><%=FN(intValorCajaAsigCaja,0)%></td>
			<td ALIGN="RIGHT"><%=FN(strDescAsigCaja,0)%></td>
		</tr>
		<tr height="20" bordercolor="#999999"  bgcolor="#<%=session("COLTABBG2")%>" class="Estilo13n">
			<td>CHEQUES AL DIA</td>
			<td><input name="TX_CHEQUEDIA" type="text" value="<%=intValorChequeDia%>" size="10" maxlength="10" onchange="solonumero(TX_CHEQUEDIA);suma_total_general(1);"></td>
			<td ALIGN="RIGHT"><%=FN(intValorChequeDia,0)%></td>
			<td ALIGN="RIGHT"><%=FN(intValorCajaChequeDia,0)%></td>
			<td ALIGN="RIGHT"><%=FN(strDescChequeDia,0)%></td>
		</tr>
		<tr height="20" bordercolor="#999999"  bgcolor="#<%=session("COLTABBG2")%>" class="Estilo13n">
			<td>CHEQUES A FECHA</td>
			<td><input name="TX_CHEQUEFECHA" type="text" value="<%=intValorChequeFecha%>" size="10" maxlength="10" onchange="solonumero(TX_CHEQUEFECHA);suma_total_general(1);"></td>
			<td ALIGN="RIGHT"><%=FN(intValorChequeFecha,0)%></td>
			<td ALIGN="RIGHT"><%=FN(intValorCajaChequeFecha,0)%></td>
			<td ALIGN="RIGHT"><%=FN(strDescChequeFecha,0)%></td>
		</tr>
		<tr height="20" bordercolor="#999999"  bgcolor="#<%=session("COLTABBG2")%>" class="Estilo13n">
			<td>EFECTIVO</td>
			<td><input name="TX_EFECTIVO" type="text" value="<%=intValorEfectivo%>" size="10" maxlength="10" onchange="solonumero(TX_EFECTIVO);suma_total_general(1);"></td>
			<td ALIGN="RIGHT"><%=FN(intValorEfectivo,0)%></td>
			<td ALIGN="RIGHT"><%=FN(intValorCajaEfectivo,0)%></td>
			<td ALIGN="RIGHT"><%=FN(strDescEfectivo,0)%></td>
		</tr>
		<tr height="20" bordercolor="#999999"  bgcolor="#<%=session("COLTABBG2")%>" class="Estilo13n">
			<td>DEPOSITO</td>
			<td><input name="TX_DEPOSITO" type="text" value="<%=intValorDeposito%>" size="10" maxlength="10" onchange="solonumero(TX_DEPOSITO);suma_total_general(1);"></td>
			<td ALIGN="RIGHT"><%=FN(intValorDeposito,0)%></td>
			<td ALIGN="RIGHT"><%=FN(intValorCajaDeposito,0)%></td>
			<td ALIGN="RIGHT"><%=FN(strDescDeposito,0)%></td>
		</tr>

		<tr height="20" bordercolor="#999999"  bgcolor="#<%=session("COLTABBG2")%>" class="Estilo13n">
			<td>VALE VISTA</td>
			<td><input name="TX_VALEVISTA" type="text" value="<%=intValorValeVista%>" size="10" maxlength="10" onchange="solonumero(TX_VALEVISTA);suma_total_general(1);"></td>
			<td ALIGN="RIGHT"><%=FN(intValorValeVista,0)%></td>
			<td ALIGN="RIGHT"><%=FN(intValorCajaValeVista,0)%></td>
			<td ALIGN="RIGHT"><%=FN(strDescValeVista,0)%></td>
		</tr>

		<tr height="20" bordercolor="#999999"  bgcolor="#<%=session("COLTABBG2")%>" class="Estilo13n">
			<td>TOTAL HABER EXISTENTE</td>
			<td><input name="TX_TOTALHABER" type="text" value="<%=intValorTotal%>" size="10" maxlength="10"></td>
			<td ALIGN="RIGHT"><%=FN(intValorTotal,0)%></td>
			<td ALIGN="RIGHT"><%=FN(intValorCajaTotal,0)%></td>
			<td ALIGN="RIGHT"><%=FN(strDescTotal,0)%></td>
		</tr>
		<tr height="20" bordercolor="#999999"  bgcolor="#<%=session("COLTABBG2")%>" class="Estilo13n">
			<td colspan=5>&nbsp;</td>
		</tr>
		<tr height="20" bordercolor="#999999"  bgcolor="#<%=session("COLTABBG2")%>" class="Estilo13n">
			<td colspan=5 ALIGN="center"><input type="Button" name="Submit" value="Cuadrar" onClick="Cuadrar();"></td>
		</tr>

    </table>
	</td>
	</tr>

</table>


	<%end if%>
	<%IF GRABA = "si" THEN
		fecha = inicio
		sw=0
		do while sw = 0

			if day(fecha) = day(termino) and month(fecha) = month(termino) and year(fecha) = year(termino) then
				sw= 1
			end if
			strSql="SELECT * FROM CAJA_WEB_EMP_CIERRE WHERE SUCURSAL = '" & SUCURSAL & "' AND FECHA = '" & fecha & "'"
			set rsCIERRE=Conn.execute(strSql)
			IF rsCIERRE.EOF THEN

				strsql = "INSERT INTO CAJA_WEB_EMP_CIERRE (FECHA,SUCURSAL,FECHA_CIERRE,CODUSUARIO) VALUES ('" & fecha & "','" & SUCURSAL & "',GETDATE(),'" & intCodUsuario & "')"
				'response.write (strsql)
				set rsGRABA=Conn.execute(strsql)
			END IF
			fecha = dateadd("d",1,fecha)
		loop
		%>
			<script>alert("Cierre de caja realizado correctamente. No podra seguir ingresando pagos para esta fecha")</script>
		<%
		Response.Write ("<script language = ""Javascript"">" & vbCrlf)
		Response.Write (vbTab & "location.href='cerrar_caja_web_V2.asp?rut=" & rut & "&tipo=1'" & vbCrlf)
		Response.Write ("</script>")
		RESPONSE.WRITE(strsql)
	  END IF
	%>
	</td>
   </tr>
  </table>

</form>


<script language="JavaScript" type="text/JavaScript">

function suma_total_general(){
	datos.TX_TOTALHABER.value = eval(datos.TX_CHEQUEDIA.value) + eval(datos.TX_CHEQUEFECHA.value) + eval(datos.TX_VALEVISTA.value) + eval(datos.TX_EFECTIVO.value) + eval(datos.TX_DEPOSITO.value) + eval(datos.TX_ASIGCAJA.value)
}

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

datos.TX_CHEQUEDIA.value = 0;
datos.TX_CHEQUEFECHA.value = 0;
datos.TX_VALEVISTA.value = 0;
datos.TX_EFECTIVO.value = 0;
datos.TX_DEPOSITO.value = 0;
datos.TX_TOTALHABER.value = 0;
</script>

