<%@Language="VBScript"%>
<%Response.Buffer = False%>
<!--#include file="arch_utils.asp"-->
<!--#include file="../lib/comunes/rutinas/funciones.inc" -->
<!--#include file="../lib/comunes/rutinas/TraeCampo.inc" -->
<!--#include file="asp/comunes/general/rutinasBooleano.inc"-->
<!--#include file="lib.asp"-->

<!--#include file="asp/comunes/General/MostrarRegistro.inc"-->
<!--#include file="asp/comunes/general/JavaEfectoBotones.inc"-->
<!--#include file="asp/comunes/general/rutinasTraeCampo.inc"-->
<!--#include file="asp/comunes/upload/freeASPUpload.asp"-->
<%

   IntId= session("ses_codcli")
   strRut= Request("strRut")
   archivo = Request("archivo")
    ''Response.write "IntId=" & IntId
    ''strRut = "11829013-5"

    AbrirSCG()

	'Response.write "<br>UploadFolder=" & Server.mapPath("UploadFolder")
	'Response.write "<br>archivo=" & Request("archivo")
	'Response.write "<br>REQUEST_METHOD=" & Request.ServerVariables("REQUEST_METHOD")

		' crear una instancia
		Set fso = CreateObject("Scripting.FileSystemObject")
		Dim DestinationPath
		DestinationPath = Server.mapPath("UploadDoc") & "\" & strRut
		' verificar si existe
		if fso.folderexists(DestinationPath) then
			''response.write "La Carpeta fue creada"
		else
			' si no existe lo creamos
			'DestinationPath = Server.mapPath("UploadDoc") & "\" & IntId
			'Set fol = fso.CreateFolder(DestinationPath)
			DestinationPath2 = Server.mapPath("UploadDoc") & "\" & strRut
			Set fol = fso.CreateFolder(DestinationPath2)
			'response.write "La Carpeta fue creada"
		end if
		set fol=nothing
		set fso=nothing


	If Trim(archivo) = "1" Then


			'Response.write "<br>DestinationPath2=" & DestinationPath

			Dim uploadsDirVar
			uploadsDirVar = DestinationPath

			function SaveFiles

				Dim Upload, fileName, fileSize, ks, i, fileKey, resumen
				Set Upload = New FreeASPUpload
				Upload.Save(uploadsDirVar)

				strSql = "UPDATE DEUDOR SET FEC_SUBIDA_ULT_ARCHIVO = getdate() WHERE CODCLIENTE = '" & session("ses_codcli") & "' AND RUTDEUDOR = '" & strRut & "'"
				
				Conn.execute(strSql)

				'Response.Write Count & " Archivo subido en: " & uploadsDirVar
				%>
				<script type="text/javascript">
				alert("Archivo agregado correctamente !!")
				window.close();
				</script>
				<%

				'If Err.Number <> 0 then Exit function
				'SaveFiles = ""
				'ks = Upload.UploadedFiles.keys
				'If (UBound(ks) <> -1) Then
				''	resumen = "<B>Archivos subidos:</B> "
				''	for each fileKey in Upload.UploadedFiles.keys
				''		resumen = resumen & Upload.UploadedFiles(fileKey).FileName & " (" & Upload.UploadedFiles(fileKey).Length & "B) "
				''	archivo = Upload.UploadedFiles(fileKey).FileName
				''	next

				'Else
				'End if



			End function

		If Request.ServerVariables("REQUEST_METHOD") = "POST" then

			response.write SaveFiles()
			response.end

		End if

	End if


%>
<HTML>
<HEAD><TITLE>Documentos de Deudor</TITLE>
<LINK rel="stylesheet" TYPE="text/css" HREF="isk_style.css">
<link href="style.css" rel="Stylesheet">
	 <link href="../css/animate.min.css" rel="stylesheet"> <!-- Animated CSS  -->
	 <link href="../css/flexslider.css" rel="stylesheet"> <!-- Flexslider CSS  -->
<meta charset="UTF-8">
</HEAD>

<BODY BGCOLOR='FFFFFF'>

<TABLE WIDTH="850" BORDER="0" CELLPADDING=0 CELLSPACING=0 ALIGN="CENTER">
    <TR>
     	<TD>
			<table width="850" border="0">
			 	 <tr>
				<td colspan=2 bordercolor="#999999"  bgcolor="#<%=session("COLTABBG")%>" class="Estilo13" ALIGN="CENTER"><h3>DOCUMENTOS ADJUNTOS</h3></td>
				</tr>
			</table>

		</TD>
	</TR>
	<TR>
    <TD>


	<FORM name="frmSend" id="frmSend" onSubmit="return enviar(this)"  method="POST" enctype="multipart/form-data" action="biblioteca_deudores.asp">
		<table width="100%" border="0" CLASS="tabla1">
			<tr BGCOLOR="#FFFFFF">
				<td height="45">
				<strong> Nuevo Archivo: </strong></td>
				<td>
				<input name="File1" type="file" VALUE="<%= File1%>" size="40" maxlength="40">
				<strong><input Name="SubmitButton" Value="Subir" Type="BUTTON" onClick="enviar();"></strong>
				</td>
			</tr>
		</table>
		</FORM>
		<br>
		<table width="100%" border="1" CLASS="tabla1">
		<td>Num.</td><td><strong>Nombre del archivo</strong></td><td align="center"><strong>Acciónes</strong></td>
		</tr>
		<tr>
		<%	
		dim contador
			VarPath=  Server.mapPath("UploadDoc") & "\" & strRut
			''response.write "VarPath=" &  VarPath
			Set Obj_FSO = createobject("scripting.filesystemobject")
			Set Obj_Directorio = Obj_FSO.GetFolder (VarPath)
			For Each VarFichero IN Obj_Directorio.Files
			VarContador = VarContador + 1
			Set Obj_File = Obj_FSO.GetFile(VarFichero)
			VarNombreFichero = VarFichero.Name
			contador = contador + 1
		%>
		
		<tr BGCOLOR="#FFFFFF">
		<td><%=contador%> - </td>
		<td>	
		<a href="UploadDoc/<%=strRut%>/<%=VarNombreFichero%>"><%=VarNombreFichero%></a>
		</td>
		<td align="center">
		<a href="EliminarArchivo.asp?strRut=<%=strRut%>&VarNombreFichero=<%=VarNombreFichero%>">Eliminar</a>
		</td>
		</tr>
		<%
			Next
		%>
		</table>

		
  	</TD>
    </TR>
</TABLE>


<SCRIPT>
function enviar(){
		frmSend.action = "biblioteca_deudores.asp?archivo=1&strRut=<%=strRut%>";
		frmSend.submit();
}
</SCRIPT>


</BODY>
</HTML>