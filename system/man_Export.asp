<%@ LANGUAGE="VBScript" %>
<!--#include file="sesion.asp"-->
<!--#include file="arch_utils.asp"-->
<!--#include file="lib.asp"-->
<!--#include file="freeaspupload.asp" -->

<html xmlns="http:www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<LINK rel="stylesheet" TYPE="text/css" HREF="../css/isk_style.css">
</head>

<%
'Stores only files with size less than MaxFileSize

if Request("CB_CLIENTE") <> "" then
	strCliente=Trim(Request("CB_CLIENTE"))
End if

if Request("CB_ASIGNACION") <> "" then
	strAsignacion=Trim(Request("CB_ASIGNACION"))
End if

if Request("inicio") <> "" then
	dtmInicio=Trim(Request("inicio"))
End if
if Request("termino") <> "" then
	dtmTermino=Trim(Request("termino"))
End if



strTipoProceso=Request("CB_TIPOPROCESO")

sFechaHoy = right("00"&Day(DATE()), 2) & "/" &right("00"&(Month(DATE())), 2) & "/" & Year(DATE())

if Request("Fecha")<>"" then
	FechaR=Request("Fecha")
End if

if Request("Asignacion")<>"" then
	strAsignacion=Request("Asignacion")
End if

if Request("archivo")<>"" then
	archivo=Request("archivo")
End if


'Response.write "<br>strTipoProceso=" & strTipoProceso
'Response.write "<br>CB_TIPOPROCESO=" & Request("CB_TIPOPROCESO")
'Response.write "<br>CB_CLIENTE=" & Request("CB_CLIENTE")


	Dim DestinationPath
	DestinationPath = Server.mapPath("UploadFolder")

	Dim uploadsDirVar
	uploadsDirVar = DestinationPath

	function SaveFiles

			If Trim(strTipoProceso) = "DEUDA" Then
		  		Response.Redirect "exp_Deuda.asp?CB_CLIENTE=" + strCliente +"&strTipoProceso=" + strTipoProceso +"&Fecha=" + Fecha +"&CB_ASIGNACION=" + strAsignacion +"&archivo=" + archivo +"&opAc=" + iOpAc
		  	End If
		  	If Trim(strTipoProceso) = "DEUDA_AGRUP" Then
				Response.Redirect "exp_DeudaAgrupada.asp?CB_CLIENTE=" + strCliente +"&strTipoProceso=" + strTipoProceso +"&Fecha=" + Fecha +"&CB_ASIGNACION=" + strAsignacion +"&archivo=" + archivo +"&opAc=" + iOpAc
		  	End If
		  	If Trim(strTipoProceso) = "GESTIONES" Then
				Response.Redirect "exp_Gestiones.asp?CB_CLIENTE=" + strCliente +"&strTipoProceso=" + strTipoProceso +"Fecha=" + Fecha +"&CB_ASIGNACION=" + strAsignacion +"&dtmTermino=" + dtmTermino + "&dtmInicio=" + dtmInicio + "&archivo=" + archivo +"&opAc=" + iOpAc
		  	End If
		  	If Trim(strTipoProceso) = "TELEFONOS" Then
				Response.Redirect "exp_Telefonos.asp?CB_CLIENTE=" + strCliente +"&strTipoProceso=" + strTipoProceso +"Fecha=" + Fecha +"&CB_ASIGNACION=" + strAsignacion +"&archivo=" + archivo +"&opAc=" + iOpAc
		  	End If
		  	If Trim(strTipoProceso) = "DIRECCIONES" Then
				Response.Redirect "exp_Direcciones.asp?CB_CLIENTE=" + strCliente +"&strTipoProceso=" + strTipoProceso +"Fecha=" + Fecha +"&CB_ASIGNACION=" + strAsignacion +"&archivo=" + archivo +"&opAc=" + iOpAc
		  	End If
		  	If Trim(strTipoProceso) = "EMAIL" Then
				Response.Redirect "exp_Email.asp?CB_CLIENTE=" + strCliente +"&strTipoProceso=" + strTipoProceso +"Fecha=" + Fecha +"&CB_ASIGNACION=" + strAsignacion +"&archivo=" + archivo +"&opAc=" + iOpAc
		  	End If
		  	If Trim(strTipoProceso) = "DEMANDAS" Then
				Response.Redirect "exp_Demandas.asp?CB_CLIENTE=" + strCliente +"&strTipoProceso=" + strTipoProceso +"Fecha=" + Fecha +"&CB_ASIGNACION=" + strAsignacion +"&archivo=" + archivo +"&opAc=" + iOpAc
		  	End If

	End function


%>

<%
if Request.ServerVariables("REQUEST_METHOD") = "POST" and archivo = "1" then

	response.write SaveFiles()

End if

'******************************
'*	INICIO CODIGO PARTICULAR  *
''******************************
%>

<title>MODULO DE EXPORTACION DE DATOS</title>

<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
</head>
<%strTitulo="MI CARTERA"%>

<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<table width="100%" border="1" bordercolor="#FFFFFF">
	<tr>
		<TD height="20" ALIGN="LEFT" bordercolor="#999999"  bgcolor="#<%=session("COLTABBG")%>" class="Estilo13">
			&nbsp;<B>MODULO INFORMES - REPORTES ESPECIFICOS</B>
		</TD>
	</tr>
</table>

<form name="datos" id="datos" onSubmit="return enviar(this)"  method="POST" action="man_Export.asp">
 <INPUT TYPE=HIDDEN NAME="FechaHoy" id="FechaHoy" value="<%=sFechaHoy%>">
<TABLE border=0 cellspacing=0 cellPadding=0>

    <TR>
	<TD>
	<table width="800" border="0" bordercolor = "#<%=session("COLTABBG")%>" align="center" cellpadding="0" cellspacing="0">

			<tr>
			  <td valign="top">
			  <table width="100%" border="0">
			  <tr height="50">
				<td> Cliente:</td>
				<td>
					<select name="CB_CLIENTE" onchange="Refrescar()">
						<option value="Seleccionar">Seleccionar</option>
						<option value="" <%if strCliente="" then response.Write("Selected") End If%>>Todos</option>
						<%
						AbrirSCG()
						ssql="SELECT CODCLIENTE, DESCRIPCION FROM CLIENTE ORDER BY DESCRIPCION "
						set rsTemp= Conn.execute(ssql)
						if not rsTemp.eof then
							do until rsTemp.eof%>
								<option value="<%=rsTemp("CODCLIENTE")%>"<%if strCliente=rsTemp("CODCLIENTE") then response.Write("Selected") End If%>><%=rsTemp("DESCRIPCION")%></option>
							<%
							rsTemp.movenext
							loop
						end if
						rsTemp.close
						set rsTemp=nothing
						CerrarSCG()
						%>
					</select>
				</td>
				<td>Asignación</td>
				<td>
					<select name="CB_ASIGNACION">
						<option value="" <%if strAsignacion="" then response.Write("Selected") End If%>>Todas</option>
						<%
						abrirscg()
						ssql="SELECT CONVERT(VARCHAR(10),FECHA_LLEGADA,103) as FECHAREMESA , CODREMESA FROM REMESA WHERE CODCLIENTE = '" & strCliente & "' AND CODREMESA >= 100"
						set rsTemp= Conn.execute(ssql)
						if not rsTemp.eof then
							do until rsTemp.eof%>
							<option value="<%=rsTemp("CODREMESA")%>" <%if Trim(intRemesa) = Trim(rsTemp("CODREMESA")) then response.Write("SELECTED") End If%>><%=rsTemp("CODREMESA") & "-" & rsTemp("FECHAREMESA")%></option>
							<%
							rsTemp.movenext
							loop
						end if
						rsTemp.close
						set rsTemp=nothing
						cerrarscg()
						%>
					</select>

					</td>
					<td>Tipo Export</td>
					<td>
					<select name="CB_TIPOPROCESO">
						<option value="Seleccionar">Seleccionar</option>
						<option value="DEUDA">DEUDA</option>
						<option value="DEUDA_AGRUP">DEUDA AGRUPADA</option>
						<option value="GESTIONES">GESTIONES</option>
						<option value="TELEFONOS">TELEFONOS</option>
						<option value="DIRECCIONES">DIRECCIONES</option>
						<option value="EMAIL">EMAIL</option>
						<option value="DEMANDAS">DEMANDAS</option>
					</select>
					</td>
			</td>
			</tr>

			<tr height="50">
				<td colspan="6" align="CENTER">
					(Solo para gestiones) F.Desde :<input name="inicio" type="text" id="inicio" value="<%=inicio%>" size="10" maxlength="10">
					<a href="javascript:showCal('Calendar7');"><img src="../lib/calendario.gif" border="0"></a>
					F.Hasta :<input name="termino" type="text" id="termino" value="<%=termino%>" size="10" maxlength="10">
					<a href="javascript:showCal('Calendar6');"><img src="../lib/calendario.gif" border="0"></a>
				</td>
			</tr>


			<tr height="50">
				<td colspan="6" align="CENTER">
					<input Name="SubmitButton" Value="Exportar" Type="BUTTON" onClick="enviar();">
				</td>
			</tr>



</table>

</FORM>

<script language="JavaScript1.2">

function RefrescaPagina() {

		 var texto;
    	 var indice = document.datos.Asignacion.selectedIndex;
		 var fechahoy = document.datos.FechaHoy.value;

		if(document.datos.Asignacion.value =='Seleccionar'){

			document.datos.Fecha.value = document.datos.FechaHoy.value;

		}else{
			document.datos.Fecha.value = document.datos.Asignacion.options[indice].text;
		}

}

function enviar(){

		if(document.datos.CB_CLIENTE.value =='Seleccionar'){
			alert('Debe seleccionar el cliente');
			return false;
		}else if(document.datos.CB_TIPOPROCESO.value =='Seleccionar'){
			alert('Debe seleccionar el tipo de proceso');
			return false;
		//}else if(document.datos.CB_ASIGNACION.value =='Seleccionar'){
		//	alert('Debe seleccionar la asignacion');
		//	return false;
		}else{
			datos.action = "man_Export.asp?archivo=1&CB_CLIENTE=" + document.datos.CB_CLIENTE.value + "&CB_TIPOPROCESO=" + document.datos.CB_TIPOPROCESO.value + "&CB_ASIGNACION=" + document.datos.CB_ASIGNACION.value;
			datos.submit();
		}
}

function Refrescar(){

		if(document.datos.CB_CLIENTE.value =='Seleccionar'){
			alert('Debe seleccionar el cliente');
			return false;
		}
		else
		{
			datos.action = "man_Export.asp?CB_CLIENTE=" + document.datos.CB_CLIENTE.value + "&CB_TIPOPROCESO=" + document.datos.CB_TIPOPROCESO.value + "&CB_ASIGNACION=" + document.datos.CB_ASIGNACION.value;
			datos.submit();
		}
}
</script>

</body>


