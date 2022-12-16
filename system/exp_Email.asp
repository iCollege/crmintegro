<%@ LANGUAGE="VBScript" %>
<!--#include file="sesion.asp"-->
<!--#include file="arch_utils.asp"-->
<!--#include file="lib.asp"-->
<!--#include file="asp/comunes/odbc/AdoVbs.inc"-->
<script language="JavaScript" type="text/JavaScript">
function AbreArchivo(nombre){
window.open(nombre,"INFORMACION","width=800, height=400, scrollbars=yes, menubar=no, location=no, resizable=yes");
}
</script>
<html xmlns="http:"www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<LINK rel="stylesheet" TYPE="text/css" HREF="../css/isk_style.css">
<title>CRM RSA</title>
<style type="text/css">
<!--body {	background-color: #cccccc;}-->
</style>
</head>

<body leftmargin="0" rightmargin="0" marginwidth="0" topmargin="0" marginheight="0">

<%

'******************************
'*	INICIO CODIGO PARTICULAR  *
''******************************
%>
<%

 if Request("CB_CLIENTE") <> "" then
	strCliente=Request("CB_CLIENTE")
End if

 if Request("CB_ASIGNACION") <> "" then
	strAsignacion=Request("CB_ASIGNACION")
End if


if Request("Fecha") <> "" then
	Fecha=Request("Fecha")
End if

if Request("archivo") <> "" then
	strArchivo=Request("archivo")
End if
strArchivo=1
if Request("opAc")= "0" then
	sIopAc=0
else
	sIopAc=1
End if

Server.ScriptTimeout = 9000
Conn.ConnectionTimeout = 9000

AbriRsCG()

''ACA DEBERIA TRAER LOS REGISTROS
dim ConnectDBQ,rsPlanilla,dbc



If strArchivo <> "" Then

	Fecha= right("00"&Day(DATE()), 2) &right("00"&(Month(DATE())), 2) &Year(DATE())

	strNomArchivoTerceros = "export_EMAIL_" & Fecha & ".csv"
	terceroCSV = request.serverVariables("APPL_PHYSICAL_PATH") & "Logs\" & strNomArchivoTerceros

	set confile = createObject("scripting.filesystemobject")
	set fichCA = confile.CreateTextFile(terceroCSV)

	strTextoTercero=""




	strTextoTercero = "RUTDEUDOR;CORRELATIVO;FECHAINGRESO;EMAIL;USRINGRESO;FECHAREVISION;ESTADO;FUENTE;USRREVISION"

	fichCA.writeline(strTextoTercero)

	strSql = " IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'TMP_EXPORT_EMAIL_" & session("session_idusuario") & "') AND type in (N'U'))"
	strSql = strSql & " DROP TABLE TMP_EXPORT_EMAIL_" & session("session_idusuario")
	Conn.Execute strSql,64

	'**********CREO TABLA Y LA LLENO************'

	strSql="SELECT RUTDEUDOR,CORRELATIVO,FECHAINGRESO,EMAIL,USRINGRESO,FECHAREVISION,ESTADO,FUENTE,USRREVISION "
	strSql = strSql & " INTO TMP_EXPORT_EMAIL_" & session("session_idusuario")
	strSql = strSql & " FROM DEUDOR_EMAIL"

	Conn.Execute strSql,64

	strSql = "SELECT * FROM TMP_EXPORT_EMAIL_" & session("session_idusuario")

	set rsTemp= Conn.execute(strSql)

	strTextoTercero=""
	cantSiniestroC = 0
	Do While Not rsTemp.Eof

		strTextoTercero = rsTemp("RUTDEUDOR") & ";" & rsTemp("CORRELATIVO") & ";" & rsTemp("FECHAINGRESO") & ";" & rsTemp("EMAIL")  & ";" & rsTemp("USRINGRESO") & ";" & rsTemp("FECHAREVISION") & ";"
		strTextoTercero = strTextoTercero & rsTemp("ESTADO") & ";" & rsTemp("FUENTE") & ";" & rsTemp("USRREVISION")

		cantSiniestroC = cantSiniestroC + 1

		fichCA.writeline(strTextoTercero)

		rsTemp.movenext

	Loop


	strSql = " IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'TMP_EXPORT_EMAIL_" & session("session_idusuario") & "') AND type in (N'U'))"
	strSql = strSql & " DROP TABLE TMP_EXPORT_EMAIL_" & session("session_idusuario")
	Conn.Execute strSql,64

	%>
	<table>
	<tr><td>Cantidad de registros generados : <%= cantSiniestroC %></td></tr>
	<tr><td>
	<a href="#" onClick="AbreArchivo('../logs/<%=strNomArchivoTerceros%>')">Descargar</a>
	&nbsp;
	<a href="#" onClick="history.back()">Volver</a>


	</td></tr>


	</table>
 <%


	'conectamos con el FSO
	set confile = createObject("scripting.filesystemobject")
	'creamos el objeto TextStream

	'response.write "terceroCSV=" & terceroCSV
	'response.End

	''set fichCA = confile.CreateTextFile(terceroCSV)
	''fichCA.write(strTextoTercero)
	fichCA.close()

End if


%>







				</td>
			  </tr>
			</table>


		</td>

	</tr>

</table>

</body>
</html>

