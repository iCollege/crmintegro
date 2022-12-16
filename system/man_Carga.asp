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

if Request("CB_CLIENTE")<>"" then
	strCliente=Request("CB_CLIENTE")
End if

strTipoCarga=Request("CB_TIPOCARGA")
strTipoProceso=Request("CB_TIPOPROCESO")
dtmFechaCreacion=Request("TX_FECHACREACION")





sFechaHoy = right("00"&Day(DATE()), 2) & "/" &right("00"&(Month(DATE())), 2) & "/" & Year(DATE())

if Request("Fecha")<>"" then
	FechaR=Request("Fecha")
End if

if Request("Asignacion")<>"" then
	strAsignacion=Request("Asignacion")
End if

if Request("opAc")<>"" then
	iOpAc=Request("opAc")
End if


'Response.write "<br>strTipoCarga=" & strTipoCarga
'Response.write "<br>CB_TIPOCARGA=" & Request("CB_TIPOCARGA")
'Response.write "<br>CB_TIPOPROCESO=" & Request("CB_TIPOPROCESO")
'Response.write "<br>CB_CLIENTE=" & Request("CB_CLIENTE")


	Dim DestinationPath
	DestinationPath = Server.mapPath("UploadFolder")

	Dim uploadsDirVar
	uploadsDirVar = DestinationPath

	function SaveFiles
		Dim Upload, fileName, fileSize, ks, i, fileKey, resumen
		Set Upload = New FreeASPUpload
		Upload.Save(uploadsDirVar)
		If Err.Number <> 0 then Exit function
		SaveFiles = ""
		ks = Upload.UploadedFiles.keys
		if (UBound(ks) <> -1) then
			resumen = "<B>Archivos subidos:</B> "
			for each fileKey in Upload.UploadedFiles.keys
				resumen = resumen & Upload.UploadedFiles(fileKey).FileName & " (" & Upload.UploadedFiles(fileKey).Length & "B) "
			archivo = Upload.UploadedFiles(fileKey).FileName
			next

		else
		End if


		''Response.End

			If Trim(strTipoCarga) = "DEUDOR" Then
		  		Response.Redirect "Man_UploadDeudor.asp?CB_CLIENTE=" + strCliente +"&strTipoCarga=" + strTipoCarga +"&Fecha=" + Fecha +"&Asignacion=" + strAsignacion +"&archivo=" + archivo +"&opAc=" + iOpAc
		  	End If
		  	If Trim(strTipoCarga) = "DEUDA" Then

		  		If Trim(strTipoProceso) = "CARGA" Then
					Response.Redirect "Man_UploadDeuda.asp?CB_CLIENTE=" + strCliente +"&strTipoCarga=" + strTipoCarga +"Fecha=" + Fecha +"&Asignacion=" + strAsignacion +"&archivo=" + archivo +"&opAc=" + iOpAc +"&TX_FECHACREACION=" + dtmFechaCreacion
		  		End If
		  		If Trim(strTipoProceso) = "ACTUALIZACION" Then
					Response.Redirect "Man_UploadActDeuda.asp?CB_CLIENTE=" + strCliente +"&strTipoCarga=" + strTipoCarga +"Fecha=" + Fecha +"&Asignacion=" + strAsignacion +"&archivo=" + archivo +"&opAc=" + iOpAc
		  		End If
		  	End If
		  	If Trim(strTipoCarga) = "UBICABILIDAD" Then
				Response.Redirect "Man_UploadUbicabilidad.asp?CB_CLIENTE=" + strCliente +"&strTipoCarga=" + strTipoCarga +"Fecha=" + Fecha +"&Asignacion=" + strAsignacion +"&archivo=" + archivo +"&opAc=" + iOpAc
		  	End If
		  	If Trim(strTipoCarga) = "GESTIONES" Then
				Response.Redirect "Man_UploadGestiones.asp?CB_CLIENTE=" + strCliente +"&strTipoCarga=" + strTipoCarga +"Fecha=" + Fecha +"&Asignacion=" + strAsignacion +"&archivo=" + archivo +"&opAc=" + iOpAc
		  	End If
		  	If Trim(strTipoCarga) = "GESTIONES_JUD" Then
				Response.Redirect "Man_UploadGestionesJud.asp?CB_CLIENTE=" + strCliente +"&strTipoCarga=" + strTipoCarga +"Fecha=" + Fecha +"&Asignacion=" + strAsignacion +"&archivo=" + archivo +"&opAc=" + iOpAc
			End If
			If Trim(strTipoCarga) = "DEMANDAS" Then
				Response.Redirect "Man_UploadDemanda.asp?CB_CLIENTE=" + strCliente +"&strTipoCarga=" + strTipoCarga +"Fecha=" + Fecha +"&Asignacion=" + strAsignacion +"&archivo=" + archivo +"&opAc=" + iOpAc
			End If	  	
			If Trim(strTipoCarga) = "TELEFONOS" Then
				Response.Redirect "Man_UploadTelefonos.asp?CB_CLIENTE=" + strCliente +"&strTipoCarga=" + strTipoCarga +"Fecha=" + Fecha +"&Asignacion=" + strAsignacion +"&archivo=" + archivo +"&opAc=" + iOpAc
		  	End If
			If Trim(strTipoCarga) = "CORREOS" Then
				Response.Redirect "Man_UploadCorreos.asp?CB_CLIENTE=" + strCliente +"&strTipoCarga=" + strTipoCarga +"Fecha=" + Fecha +"&Asignacion=" + strAsignacion +"&archivo=" + archivo +"&opAc=" + iOpAc
		  	End If

		  	If Trim(strTipoCarga) = "PATENTES" Then
				Response.Redirect "Man_UploadPatentes.asp?CB_CLIENTE=" + strCliente +"&strTipoCarga=" + strTipoCarga +"Fecha=" + Fecha +"&Asignacion=" + strAsignacion +"&archivo=" + archivo +"&opAc=" + iOpAc
		  	End If

	End function


%>

<%
if Request.ServerVariables("REQUEST_METHOD") = "POST" then

	response.write SaveFiles()

End if

'******************************
'*	INICIO CODIGO PARTICULAR  *
''******************************
%>

<title>MODULO DE CARGAS</title>

<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
</head>
<%strTitulo="MI CARTERA"%>

<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<table width="100%" border="0" bordercolor="#FFFFFF">
	<tr>
		<TD height="20" ALIGN=LEFT class="pasos2_i">
			<B>MODULO DE CARGAS - DEUDOR - DEUDA - UBICABILIDAD</B>
		</TD>
	</tr>
</table>



<form name="frmSend" id="frmSend" onSubmit="return enviar(this)"  method="POST" enctype="multipart/form-data" action="man_Carga.asp">
 <INPUT TYPE=HIDDEN NAME="FechaHoy" id="FechaHoy" value="<%=sFechaHoy%>">
<TABLE border=0 cellspacing=0 cellPadding=0>


    <TR>
	<TD>
	<table width="800" border="0" bordercolor = "#<%=session("COLTABBG")%>" align="center" cellpadding="0" cellspacing="0">

			<tr>
			  <td valign="top">
			  <table width="100%" border="0">
			  <tr>
				<td width="32%"> Cliente:</td>
				<td colspan="2">
					<select name="CB_CLIENTE" onchange="Refrescar()">
						<option value="Seleccionar">Seleccionar</option>
						<%
						AbrirSCG()
						ssql="SELECT CODCLIENTE, DESCRIPCION FROM CLIENTE ORDER BY CODCLIENTE "
						set rsTemp= Conn.execute(ssql)
						if not rsTemp.eof then
							do until rsTemp.eof%>
								<option value="<%=rsTemp("CODCLIENTE")%>"<%if strCliente=rsTemp("CODCLIENTE") then response.Write("Selected") End If%>><%=rsTemp("CODCLIENTE") & "-" & rsTemp("DESCRIPCION")%></option>
							<%
							rsTemp.movenext
							loop
						end if
						rsTemp.close
						set rsTemp=nothing
						CerrarSCG()
						%>
					</select>
			&nbsp;&nbsp;Dato a Cargar&nbsp;&nbsp;
					<select name="CB_TIPOCARGA">
						<option value="Seleccionar" >Seleccionar</option>
						<option value="DEUDOR">DEUDOR</option>
						<option value="DEUDA">DEUDA</option>
						<option value="UBICABILIDAD">UBICABILIDAD</option>
						<option value="GESTIONES">GESTIONES</option>
						<option value="GESTIONES_JUD">GESTIONES_JUD</option>
						<option value="DEMANDAS">DEMANDAS</option>
						<option value="TELEFONOS">TELEFONOS</option>
						<option value="CORREOS">CORREOS</option>
						<option value="PATENTES">PATENTES</option>
					</select>
			&nbsp;&nbsp;Tipo Proceso&nbsp;&nbsp;
					<select name="CB_TIPOPROCESO">
						<option value="Seleccionar">Seleccionar</option>
						<option value="CARGA">CARGA</option>
						<option value="ACTUALIZACION" >ACTUALIZACION</option>
						<option value="ELIMINAR">ELIMINAR</option>
					</select>
			</td>
			</tr>
			<tr>
			<td>Asignación (cartera):</td>
			<td colspan="2">
				<input name="Fecha" type="TEXT" VALUE="<%=sFechaHoy%>" size="14" maxlength="14">

				<select name="Asignacion" onchange="RefrescaPagina()" >
				<option value="Seleccionar">Seleccionar</option>
				<%

						AbrirSCG()
						ssql="select CODREMESA, CONVERT(VARCHAR(10),FECHA_CARGA,103) AS FECHA_CARGA FROM REMESA WHERE CODCLIENTE = '" & strCliente & "' AND CODREMESA > 0 ORDER BY CODREMESA DESC "
						set rsTemp= Conn.execute(ssql)
						if not rsTemp.eof then
							do until rsTemp.eof%>
								<option value="<%=rsTemp("CODREMESA")%>"><%=rsTemp("CODREMESA")& "-" & rsTemp("fecha_carga")%></option>
							<%
							rsTemp.movenext
							loop
						end if
						rsTemp.close
						set rsTemp=nothing
						CerrarSCG()
						%>
				</select>
				Fecha Creación:
				<input name="TX_FECHACREACION" type="TEXT" VALUE="<%=sFechaHoy%>" size="10" maxlength="10">
			</td>
			</tr>
			<tr>
			<td height="45">

	   		Archivo de Carga Clientes: </td>
			<td width="37%"><input name="File1" type="file" VALUE="<%= File1%>" size="40" maxlength="40">
	     	</td>
		    <td width="31%"><input type="checkbox" name="ckbAc" value="ckbAc">
		      Actualiza</td>
			</tr>

</table>
	<input Name="SubmitButton" Value="Cargar" Type="BUTTON" onClick="enviar();">
	<input Name=EliminarButton Value="Eliminar" Type=BUTTON onClick="Eliminar();"><br>
</FORM>

 <table width="100%" border="0">
	<tr>
		<td>Formato de carga deudor: (CSV (MS-DOS))</td>
		<td><a href="formatos/FORMATO_CARGA_DEUDOR.CSV" target='Contenido'>Descargar</a></td>
	</tr>
	<tr>
		<td>Formato de carga deuda: (CSV (MS-DOS))</td>
		<td><a href="formatos/FORMATO_CARGA_DEUDA.CSV" target='Contenido'>Descargar</a></td>
	</tr>
	<tr>
		<td>Formato de carga ubicabilidad: (CSV (MS-DOS))</td>
		<td><a href="formatos/FORMATO_CARGA_UBICABILIDAD.CSV" target='Contenido'>Descargar</a></td>
	</tr>
	<tr>
		<td>Formato de carga gestiones: (CSV (MS-DOS))</td>
		<td><a href="formatos/FORMATO_CARGA_GESTIONES.CSV" target='Contenido'>Descargar</a></td>
	</tr>
	<tr>
		<td>Formato de carga gestiones judiciales: (CSV (MS-DOS))</td>
		<td><a href="formatos/FORMATO_CARGA_GESTIONES_JUD.CSV" target='Contenido'>Descargar</a></td>
	</tr>
	<tr>
		<td>Formato de carga demandas: (CSV (MS-DOS))</td>
		<td><a href="formatos/FORMATO_DEMANDA.CSV" target='Contenido'>Descargar</a></td>
	</tr>
		<tr>
		<td>Formato de carga Telefonos: (CSV (MS-DOS)) <font color="blue">*Nueva</font></td>
		<td><a href="formatos/FORMATO_CARGA_TELEFONOS.CSV" target='Contenido'>Descargar</a></td>
	</tr>
	<tr>
		<td>Formato de carga Correos: (CSV (MS-DOS)) <font color="blue">*Nueva</font></td>
		<td><a href="formatos/FORMATO_CARGA_EMAIL.CSV" target='Contenido'>Descargar</a></td>
	</tr>
	<tr>
		<td>Formato de carga Patentes: (CSV (MS-DOS)) <font color="blue">*Nueva</font></td>
		<td><a href="formatos/FORMATO_CARGA_PATENTES.CSV" target='Contenido'>Descargar</a></td>
	</tr>
</table>


<br>



<table width="100%" border="0">
<tr>
	<td>
		<table width="100%" border="1">
		<tr>
			<td colspan="2"><b>Tipo Documento</b></td>
		</tr>
		<tr>
			<td><b>Cod</b></td>
			<td><b>Nombre</b></td>
		</tr>
		<%
			AbrirSCG()
				ssql="SELECT * FROM TIPO_DOCUMENTO ORDER BY COD_TIPO_DOCUMENTO "
				set rsTemp= Conn.execute(ssql)
				if not rsTemp.eof then
					do until rsTemp.eof%>
					<tr>
							<td><%=rsTemp("COD_TIPO_DOCUMENTO")%></td>
							<td><%=rsTemp("NOM_TIPO_DOCUMENTO")%></td>
					</tr>

					<%
					rsTemp.movenext
					loop
				end if
				rsTemp.close
				set rsTemp=nothing
			CerrarSCG()

		%>
		</table>
	</td>


	<td>
			<table width="100%" border="1">
			<tr>
				<td colspan="2"><b>Tipo Cobranza</b></td>
			</tr>
			<tr>
				<td><b>Cod</b></td>
				<td><b>Nombre</b></td>
			</tr>
			<%
				AbrirSCG()
					ssql="SELECT * FROM ESTADO_COBRANZA ORDER BY COD_ESTADO_COBRANZA "
					set rsTemp= Conn.execute(ssql)
					if not rsTemp.eof then
						do until rsTemp.eof%>
						<tr>
								<td><%=rsTemp("COD_ESTADO_COBRANZA")%></td>
								<td><%=rsTemp("NOM_ESTADO_COBRANZA")%></td>
						</tr>

						<%
						rsTemp.movenext
						loop
					end if
					rsTemp.close
					set rsTemp=nothing
				CerrarSCG()

			%>
			</table>
	</td>
</tr>
</table>







<script language="JavaScript1.2">

function RefrescaPagina() {

		 var texto;
    	 var indice = document.frmSend.Asignacion.selectedIndex;
		 var fechahoy = document.frmSend.FechaHoy.value;

		if(document.frmSend.Asignacion.value =='Seleccionar'){

			document.frmSend.Fecha.value = document.frmSend.FechaHoy.value;

		}else{
			document.frmSend.Fecha.value = document.frmSend.Asignacion.options[indice].text;
		}

}

function enviar(){

		if(document.frmSend.CB_CLIENTE.value =='Seleccionar'){
			alert('Debe seleccionar el cliente');
			return false;
		}else if(document.frmSend.CB_TIPOCARGA.value =='Seleccionar'){
			alert('Debe seleccionar el tipo de carga');
			return false;
		}else if(document.frmSend.CB_TIPOPROCESO.value =='Seleccionar'){
			alert('Debe seleccionar el tipo de proceso');
			return false;
		}else if(document.frmSend.Fecha.value ==''){
			alert('Debe ingresar la fecha de ingreso');
			return false;
		}else if(document.frmSend.TX_FECHACREACION.value ==''){
			alert('Debe ingresar la fecha de creación');
			return false;
		}else if(document.frmSend.File1.value ==''){
			alert('Debe ingresar la direccion del documento para cargarlo');
			return false;
		}else{
			if(document.frmSend.ckbAc.checked == true){
				chek = 1;
			}else{
				chek = 0;
			}

			frmSend.action = "man_Carga.asp?CB_CLIENTE=" + document.frmSend.CB_CLIENTE.value + "&CB_TIPOCARGA=" + document.frmSend.CB_TIPOCARGA.value + "&TX_FECHACREACION=" + document.frmSend.TX_FECHACREACION.value + "&CB_TIPOPROCESO=" + document.frmSend.CB_TIPOPROCESO.value + "&Fecha=" + document.frmSend.Fecha.value  + "&Asignacion=" + document.frmSend.Asignacion.value + "&opAc=" + chek;
			frmSend.submit();
		}
}

function Refrescar(){

		if(document.frmSend.CB_CLIENTE.value =='Seleccionar'){
			alert('Debe seleccionar el cliente');
			return false;
		}
		else
		{
			frmSend.action = "man_Carga.asp?CB_CLIENTE=" + document.frmSend.CB_CLIENTE.value + "&CB_TIPOCARGA=" + document.frmSend.CB_TIPOCARGA.value + "&TX_FECHACREACION=" + document.frmSend.TX_FECHACREACION.value + "&CB_TIPOPROCESO=" + document.frmSend.CB_TIPOPROCESO.value + "&Fecha=" + document.frmSend.Fecha.value  + "&Asignacion=" + document.frmSend.Asignacion.value;
			frmSend.submit();
		}
}
</script>

</body>


