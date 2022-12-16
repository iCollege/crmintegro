<%@ LANGUAGE = "VBScript" %>
<!--#include file="asp/comunes/General/MostrarRegistro.inc"-->
<!--#include file="asp/comunes/general/JavaEfectoBotones.inc"-->
<!--#include file="asp/comunes/general/rutinasTraeCampo.inc"-->

<% ' Capa 1 ' %>
<!--#include file="asp/comunes/odbc/AdoVbs.inc"-->
<!--#include file="arch_utils.asp"-->
<!--#include file="asp/comunes/odbc/ObtenerRecordSet.inc"-->
<!--#include file="asp/comunes/odbc/ObtenerRegistros.inc"-->

<% ' Capa 2 ' %>
<!--#include file="asp/comunes/recordset/Cliente.inc"-->
<!--#include file="freeaspupload.asp" -->

<%

	sintNuevo = request("sintNuevo")
    IntId= request("CODCLIENTE")

	'Response.Write ("***" & IntId & "***")

    If sintNuevo = 1 Then
        strFormMode="Nuevo"
        IntId=0
    Else
        strFormMode="Edit"
    End If

    AbrirSCG()

	recordset_Cliente Conn, srsRegistro, IntId
    If Not srsRegistro.Eof Then
		intIdActivo = Trim(srsRegistro("ACTIVO"))
		intCodMoneda = Trim(srsRegistro("COD_MONEDA"))
		intCodTipoDoc = Trim(srsRegistro("COD_TIPODOCUMENTO_HON"))

		If Trim(srsRegistro("TIPO_CLIENTE"))="JUDICIAL" Then
			strTipoClienteJU = "SELECTED"
		Else
			strTipoClienteEJ = "SELECTED"
		End If

	Else
		intIdActivo = ""
    End If

	'Response.write "<br>UploadFolder=" & Server.mapPath("UploadFolder")
	'Response.write "<br>archivo=" & Request("archivo")
	'Response.write "<br>REQUEST_METHOD=" & Request.ServerVariables("REQUEST_METHOD")
    Dim DestinationPath
		DestinationPath = Server.mapPath("UploadFolder") & "\" & IntId

		'Response.write "<br>DestinationPath=" & DestinationPath

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


		End function

	If Request.ServerVariables("REQUEST_METHOD") = "POST" then

		response.write SaveFiles()

	End if

%>

<HTML>
<HEAD><TITLE>Mantenedor de Clientes</TITLE>
<LINK rel="stylesheet" TYPE="text/css" HREF="isk_style.css">
</HEAD>

<BODY BGCOLOR='FFFFFF'>

<SCRIPT Language=JavaScript>
function Continuar() {
    //if ( document.forms[0].ID.value == '' || esNumero('tinyint',document.forms[0].ID.value)=="false") {
    //    alert( "Debe ingresar en código un dato numerico entero entre 0 y 255" );
    //    return false
    //}

	document.forms[0].submit()
    return false
}
</SCRIPT>


<FORM NAME="mantenedorForm"  action="man_ClienteAction.asp" method="POST" onmouseover="highlightButton('start')" onmouseout="highlightButton('')">
	<INPUT TYPE="HIDDEN" NAME="strFormMode" VALUE="<%= strFormMode %>">


<TABLE WIDTH="800" BORDER="0" CELLPADDING=0 CELLSPACING=0 ALIGN="CENTER">
    <TR>
     <TD>
<TABLE width="100%" CLASS="tabla1">
    <TR HEIGHT=50>
    	<TD width="100%" ALIGN=CENTER>
            <B>MANTENEDOR DE CLIENTES</B>
        </TD>
    </TR>
</TABLE>

 <table width="100%" border="0" CLASS="tabla1">
    	<tr BGCOLOR="#FFFFFF">
    		<td class="hdr_i"><img src='../images/cuadrado_t1.gif' align='absmiddle'>&nbspINGRESO CLIENTES</td>
     </tr>
</Table>


<table width="100%" border="0" CLASS="tabla1">
	<tr BGCOLOR="#FFFFFF">
		<td class="hdr_i">Codigo</td>

		<%
		If strFormMode = "Nuevo" Then
		%>
		<td class="td_t"><% general_MostrarCampo "CODCLIENTE", False, Null, Null,srsRegistro %></td>
		<%
		Else
			Response.Write "<INPUT TYPE=HIDDEN NAME=CODCLIENTE VALUE=""" & srsRegistro("CODCLIENTE") & """>"
		%>

			<td class="td_t"><%=srsRegistro("CODCLIENTE") %></td>
		<%
		End If
        %>
        <td class="hdr_i">Tipo Cliente</td>
		<td class="td_t">
			<select name="TIPO_CLIENTE" onChange="">
				<option value="JUDICIAL" <%=strTipoClienteJU%>>Judicial</option>
				<option value="EXTRAJUD" <%=strTipoClienteEJ%>>Extra Judicial</option>
			</select>
		</td>
	</TR>
	<tr BGCOLOR="#FFFFFF">
		<td class="hdr_i">Nombre</td>
		<td class="td_t"><% general_MostrarCampo "DESCRIPCION", False, Null, Null,srsRegistro %></td>
		<td class="hdr_i">Razon Social</td>
		<td class="td_t"><% general_MostrarCampo "RAZON_SOCIAL", False, Null, Null,srsRegistro %></td>
	</TR>
	<tr BGCOLOR="#FFFFFF">
		<td class="hdr_i">Rut</td>
		<td class="td_t"><% general_MostrarCampo "RUT", False, Null, Null,srsRegistro %></td>
		<td class="hdr_i">Nombre Fantasia</td>
		<td class="td_t"><% general_MostrarCampo "NOMBRE_FANTASIA", False, Null, Null,srsRegistro %></td>
	</TR>
	<tr BGCOLOR="#FFFFFF">
		<td class="hdr_i">Direccion</td>
		<td class="td_t"><% general_MostrarCampo "DIRECCION", False, Null, Null,srsRegistro %></td>
		<td class="hdr_i">Comuna</td>
		<td class="td_t" colspan=3><% general_MostrarCampo "COMUNA", False, Null, Null,srsRegistro %></td>
	</TR>
	<tr BGCOLOR="#FFFFFF">
		<td class="hdr_i">Telefono 1</td>
		<td class="td_t"><% general_MostrarCampo "FONO1", False, Null, Null,srsRegistro %></td>
		<td class="hdr_i">Telefono 2</td>
		<td class="td_t"><% general_MostrarCampo "FONO2", False, Null, Null,srsRegistro %></td>
	</TR>
	<tr BGCOLOR="#FFFFFF">
		<td class="hdr_i">Nombre Contacto</td>
		<td class="td_t"><% general_MostrarCampo "NOM_CONTACTO", False, Null, Null,srsRegistro %></td>
		<td class="hdr_i">Email Contacto</td>
		<td class="td_t"><% general_MostrarCampo "EMAIL_CONTACTO", False, Null, Null,srsRegistro %></td>
	</TR>
	<tr BGCOLOR="#FFFFFF">
		<td class="hdr_i">Imdem.Comp.</td>
		<td class="td_t"><% general_MostrarCampo "IC_PORC_CAPITAL", False, Null, Null,srsRegistro %>(% Capital)</td>
		<td class="hdr_i">Honorarios</td>
		<td class="td_t"><% general_MostrarCampo "HON_PORC_CAPITAL", False, Null, Null,srsRegistro %>(% Capital)</td>
	</TR>
	<tr BGCOLOR="#FFFFFF">
		<td class="hdr_i">Pie Convenio</td>
		<td class="td_t"><% general_MostrarCampo "PIE_PORC_CAPITAL", False, Null, Null,srsRegistro %>(% Capital)</td>
		<td class="hdr_i">Interes Mora</td>
		<td class="td_t" colspan=3><% general_MostrarCampo "INTERES_MORA", False, Null, Null,srsRegistro %>(Mensual)</td>
	</TR>
	<tr BGCOLOR="#FFFFFF">
		<td class="hdr_i">Interes Futuro</td>
		<td class="td_t" ><% general_MostrarCampo "TASA_MAX_CONV", False, Null, Null,srsRegistro %>(Mensual)</td>
		<td class="hdr_i">Tipo Int.Futuro</td>
		<td class="td_t"><% general_MostrarCampo "TIPO_INTERES", False, Null, Null,srsRegistro %> (C:Comp., S:Simple)</td>
	</TR>
	<tr BGCOLOR="#FFFFFF">
		<td class="hdr_i">Expiracion Convenio</td>
		<td class="td_t" ><% general_MostrarCampo "EXPIRACION_CONVENIO", False, Null, Null,srsRegistro %>(Dias)</td>
		<td class="hdr_i">Expiracion Anulacion</td>
		<td class="td_t"><% general_MostrarCampo "EXPIRACION_ANULACION", False, Null, Null,srsRegistro %>(Dias)</td>
	</TR>
	<tr BGCOLOR="#FFFFFF">
		<td class="hdr_i">Con Custodio</td>
		<td class="td_t"><% general_MostrarCampo "USA_CUSTODIO", False, Null, Null,srsRegistro %> (S:Si, N:No)</td>
		<td class="hdr_i">Color Custodio</td>
		<td class="td_t"><% general_MostrarCampo "COLOR_CUSTODIO", False, Null, Null,srsRegistro %></td>
	</TR>
	<tr BGCOLOR="#FFFFFF">
		<td class="hdr_i">Gastos Op. S/Dem.</td>
		<td class="td_t"><% general_MostrarCampo "GASTOS_OPERACIONALES", False, Null, Null,srsRegistro %></td>
		<td class="hdr_i">Gastos Adm. S/Dem.</td>
		<td class="td_t"><% general_MostrarCampo "GASTOS_ADMINISTRATIVOS", False, Null, Null,srsRegistro %></td>
	</TR>
	<tr BGCOLOR="#FFFFFF">
		<td class="hdr_i">Gastos Op. C/Dem.</td>
		<td class="td_t"><% general_MostrarCampo "GASTOS_OPERACIONALES_CD", False, Null, Null,srsRegistro %></td>
		<td class="hdr_i">Gastos Adm. C/Dem.</td>
		<td class="td_t"><% general_MostrarCampo "GASTOS_ADMINISTRATIVOS_CD", False, Null, Null,srsRegistro %></td>
	</TR>
	<tr BGCOLOR="#FFFFFF">
		<td class="hdr_i">Adic 1</td>
		<td class="td_t"><% general_MostrarCampo "ADIC1", False, Null, Null,srsRegistro %></td>
		<td class="hdr_i">Adic 2</td>
		<td class="td_t"><% general_MostrarCampo "ADIC2", False, Null, Null,srsRegistro %></td>
	</TR>
	<tr BGCOLOR="#FFFFFF">
		<td class="hdr_i">Adic 3</td>
		<td class="td_t"><% general_MostrarCampo "ADIC3", False, Null, Null,srsRegistro %></td>
		<td class="hdr_i">Adic 4</td>
		<td class="td_t"><% general_MostrarCampo "ADIC4", False, Null, Null,srsRegistro %></td>
	</TR>
	<tr BGCOLOR="#FFFFFF">
		<td class="hdr_i">Adic 5</td>
		<td class="td_t"><% general_MostrarCampo "ADIC5", False, Null, Null,srsRegistro %></td>
		<td class="hdr_i">Adic 91</td>
		<td class="td_t"><% general_MostrarCampo "ADIC91", False, Null, Null,srsRegistro %></td>
	</TR>
	<tr BGCOLOR="#FFFFFF">
		<td class="hdr_i">Adic 92</td>
		<td class="td_t"><% general_MostrarCampo "ADIC92", False, Null, Null,srsRegistro %></td>
		<td class="hdr_i">Adic 93</td>
		<td class="td_t"><% general_MostrarCampo "ADIC93", False, Null, Null,srsRegistro %></td>
	</TR>
	<tr BGCOLOR="#FFFFFF">
		<td class="hdr_i">Adic 94</td>
		<td class="td_t"><% general_MostrarCampo "ADIC94", False, Null, Null,srsRegistro %></td>
		<td class="hdr_i">Adic 95</td>
		<td class="td_t"><% general_MostrarCampo "ADIC95", False, Null, Null,srsRegistro %></td>
	</TR>
	<tr BGCOLOR="#FFFFFF">
		<td class="hdr_i">Nombre Conv-Pagare</td>
		<td class="td_t"><% general_MostrarCampo "NOMBRE_CONV_PAGARE", False, Null, Null,srsRegistro %></td>
		<td class="hdr_i">&nbsp;</td>
		<td class="td_t">&nbsp;</td>
	</TR>
	<tr BGCOLOR="#FFFFFF">
		<td class="hdr_i">Tipo Moneda</td>
		<td class="td_t">
			<SELECT NAME="COD_MONEDA" onChange="">

			<%
			strSql="SELECT * FROM MONEDA"
			set rsTemp= Conn.execute(strSql)
			if not rsTemp.eof then
				do until rsTemp.eof%>
				  <option value="<%=rsTemp("COD_MONEDA")%>" <% if Trim(rsTemp("COD_MONEDA")) = intCodMoneda then Response.Write "SELECTED" %> ><%=rsTemp("NOM_MONEDA")%></option>
				  <%
				rsTemp.movenext
				loop
			end if
			rsTemp.close
			set rsTemp=nothing

			%>
			  </SELECT>
		</td>
		<td class="hdr_i">Tipo Doc.Hon.</td>
		<td class="td_t">
			<SELECT NAME="COD_TIPODOCUMENTO_HON" onChange="">
			<option value="" <% if Trim(intCodTipoDoc) = "" then Response.Write "SELECTED" %> >SIN TIPO DOC</option>

			<%
			strSql="SELECT * FROM TIPO_DOCUMENTO"
			set rsTemp= Conn.execute(strSql)
			if not rsTemp.eof then
			do until rsTemp.eof%>
			  <option value="<%=rsTemp("COD_TIPO_DOCUMENTO")%>" <% if Trim(rsTemp("COD_TIPO_DOCUMENTO")) = intCodTipoDoc then Response.Write "SELECTED" %> ><%=rsTemp("NOM_TIPO_DOCUMENTO")%></option>
			  <%
			rsTemp.movenext
			loop
			end if
			rsTemp.close
			set rsTemp=nothing

			%>
			</SELECT>
		</td>
	</tr>
	<tr BGCOLOR="#FFFFFF">
		<td class="hdr_i">Activo</td>
		<td class="td_t" colspan=3><% general_MostrarCampo "ACTIVO", False, Null, Null,srsRegistro %></td>
	</tr>
</table>

<table width="100%" border="0">
     <TR>
	  <td align=center  width="25%">
	   <INPUT TYPE="BUTTON" value="Guardar" name="B1" onClick="Continuar();return false;">
	   <input type="BUTTON" value="Terminar" name="terminar" onClick="Terminar('man_Cliente.asp');return false;"></TD>
	  </TD>
    </TR>
    <%If sintNuevo = 1 Then %>
    <TR>
    <TD align=center >
     <IMG BORDER="0" src="../images/bolita.jpg" WIDTH=10>=Campo requerido
     </TD>
    </TR>
	<%End If %>
</table>
</FORM>


<table width="100%" border="0" CLASS="tabla1">

<FORM name="frmSend" id="frmSend" onSubmit="return enviar(this)"  method="POST" enctype="multipart/form-data" action="man_ClienteForm.asp">

<tr BGCOLOR="#FFFFFF">
		<td height="45">
	   		Archivo: </td>
		<td><input name="File1" type="file" VALUE="<%= File1%>" size="40" maxlength="40"> <input Name="SubmitButton" Value="Cargar" Type="BUTTON" onClick="enviar();"></td>

	</tr>

<%
	VarPath=  Server.mapPath("UploadFolder") & "\" & IntId
	Set Obj_FSO = createobject("scripting.filesystemobject")
	Set Obj_Directorio = Obj_FSO.GetFolder (VarPath)
	For Each VarFichero IN Obj_Directorio.Files
	VarContador = VarContador + 1
	Set Obj_File = Obj_FSO.GetFile(VarFichero)
	VarNombreFichero = VarFichero.Name
%>
<tr BGCOLOR="#FFFFFF">
<td>
<a href="UploadFolder/<%=IntId%>/<%=VarNombreFichero%>"><%=VarNombreFichero%></a>
</td>
<td align="center">
<a href="EliminarArchivo.asp?IntId=<%=IntId%>&VarNombreFichero=<%=VarNombreFichero%>">Eliminar</a>
</td>

</tr>
<%
	Next
%>
</table>

</FORM>
  </TD>
    </TR>
</TABLE>


<SCRIPT>
function Refrescar(strTipo){

	mantenedorForm.action='man_ClienteForm.asp?strTipoPropiedad=' + strTipo;
	if (mantenedorForm.strFormMode.value == 'Nuevo') {
		location.href="man_ClienteForm.asp?sintNuevo=1&strTipoPropiedad=" + strTipo;
		}
	else {
	 	mantenedorForm.submit();
	}
}


function enviar(){
		frmSend.action = "man_ClienteForm.asp?archivo=1&CODCLIENTE=" + document.forms[0].CODCLIENTE.value;
		frmSend.submit();
}


</SCRIPT>



<%CerrarSCG()%>

</BODY>
</HTML>




