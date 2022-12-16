<%@ LANGUAGE = "VBScript" %>
<!--#include file="asp/comunes/General/MostrarRegistro.inc"-->
<!--#include file="asp/comunes/general/JavaEfectoBotones.inc"-->
<!--#include file="asp/comunes/general/rutinasTraeCampo.inc"-->

<%

	IntId= session("ses_codcli")
   strRut= Request("strRut")
   archivo = Request("archivo")
    ''Response.write "strRut=" & strRut
    ''strRut = "11829013-5"

    AbrirSCG()

	'Response.write "<br>UploadFolder=" & Server.mapPath("UploadFolder")
	'Response.write "<br>archivo=" & Request("archivo")
	'Response.write "<br>REQUEST_METHOD=" & Request.ServerVariables("REQUEST_METHOD")

	Dim DestinationPath
	DestinationPath = Server.mapPath("UploadDoc") & "\" & IntId  & "\" & strRut

	If Trim(archivo) = "1" Then


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
				If (UBound(ks) <> -1) Then
					resumen = "<B>Archivos subidos:</B> "
					for each fileKey in Upload.UploadedFiles.keys
						resumen = resumen & Upload.UploadedFiles(fileKey).FileName & " (" & Upload.UploadedFiles(fileKey).Length & "B) "
					archivo = Upload.UploadedFiles(fileKey).FileName
					next

				Else
				End if


			End function

		If Request.ServerVariables("REQUEST_METHOD") = "POST" then

			response.write SaveFiles()

				strSql = "UPDATE DEUDOR SET FEC_SUBIDA_ULT_ARCHIVO = getdate() WHERE CODCLIENTE = '" & session("ses_codcli") & "' AND RUTDEUDOR = '" & strRut & "'"
				'response.end
				Conn.execute(strSql)

		End if

	End if

		' crear una instancia
		set Obj_FSO = createobject("scripting.filesystemobject")
		' verificar si existe
		if Obj_FSO.folderexists(DestinationPath) then
			''response.write "La Carpeta fue creada"
		else
			' si no existe lo creamos
			set nfolder = Obj_FSO.createfolder(DestinationPath)
			''response.write "La Carpeta fue creada"
		end if
		set nfolder=nothing
		set Obj_FSO=nothing

%>

<HTML>
<HEAD><TITLE>Documentos de Deudor</TITLE>
<LINK rel="stylesheet" TYPE="text/css" HREF="isk_style.css">
<link href="style.css" rel="Stylesheet">

	 <link href="../css/animate.min.css" rel="stylesheet"> <!-- Animated CSS  -->
	 <link href="../css/flexslider.css" rel="stylesheet"> <!-- Flexslider CSS  -->
</HEAD>

<BODY BGCOLOR='FFFFFF'>

<TABLE WIDTH="850" BORDER="0" CELLPADDING=0 CELLSPACING=0 ALIGN="CENTER">
    <TR>
     	<TD>
			<table width="850" border="0">
			 	 <tr>
				<td colspan =2 bordercolor="#999999"  bgcolor="#<%=session("COLTABBG")%>" class="Estilo13" ALIGN="CENTER">DOCUMENTOS</td>
				</tr>
			</table>

		</TD>
	</TR>
	<TR>
     	<TD>

		<table width="100%" border="0" CLASS="tabla1">

		<FORM name="frmSend" id="frmSend" onSubmit="return enviar(this)"  method="POST" enctype="multipart/form-data" action="biblioteca_deudores.asp">

			<tr BGCOLOR="#FFFFFF">
				<td height="45">
				Archivo: </td>
				<td>
				<input name="File1" type="file" VALUE="<%= File1%>" size="40" maxlength="40">
				<input Name="SubmitButton" Value="Cargar" Type="BUTTON" onClick="enviar();">
				</td>

			</tr>

		<%
			VarPath=  Server.mapPath("UploadDoc") & "\" & IntId & "\" & strRut
			''response.write "VarPath=" &  VarPath
			Set Obj_FSO = createobject("scripting.filesystemobject")
			Set Obj_Directorio = Obj_FSO.GetFolder (VarPath)
			For Each VarFichero IN Obj_Directorio.Files
			VarContador = VarContador + 1
			Set Obj_File = Obj_FSO.GetFile(VarFichero)
			VarNombreFichero = VarFichero.Name
		%>
		
		<tr BGCOLOR="#FFFFFF"><td>
		<a href="UploadDoc/<%=IntId%>/<%=strRut%>/<%=VarNombreFichero%>"><%=VarNombreFichero%></a>
		</td>
		<td align="center">
		<a href="EliminarArchivo.asp?IntId=<%=IntId%>&strRut=<%=strRut%>&VarNombreFichero=<%=VarNombreFichero%>">Eliminar</a>
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
function enviar(){
		frmSend.action = "biblioteca_deudores.asp?archivo=1&strRut=<%=strRut%>";
		frmSend.submit();
}
</SCRIPT>

<%CerrarSCG()%>

</BODY>
</HTML>