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
<html xmlns="">
<head>
<meta http-equiv="Content-Type" content="text/html" charset="iso-8859-1" />
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


if Request("Fecha") <> "" then
	Fecha=Request("Fecha")
End if

''Response.Write(strAsignacion)
if strAsignacion = "Seleccionar" then
	strAsignacion = 0
else
	strAsignacion=strAsignacion
End if

if Request("archivo") <> "" then
	strArchivo=Request("archivo")
End if

if Request("opAc")= "0" then
	sIopAc=0
else
	sIopAc=1
End if

AbriRsCG()

''ACA DEBERIA TRAER LOS REGISTROS
dim ConnectDBQ,rsPlanilla,dbc

If strArchivo <> "" Then


	Fecha= right("00"&Day(DATE()), 2) &right("00"&(Month(DATE())), 2) &Year(DATE())

	strNomArchivoTerceros = "Terceros_cargados_fonos_"&Fecha&".csv"
	terceroCSV = request.serverVariables("APPL_PHYSICAL_PATH") & "Logs\" & strNomArchivoTerceros

	strTextoArchivoCC = ""
	strTextoArchivoCNC = ""
	strTextoArchivoCA = ""

	strFileDir = server.mappath("UploadFolder\"& strArchivo)
	'response.write "strSql " & strSql

	dim intTelRutRepetido,intTelNuevo,correlativo
	intTelNuevo = 0
	intTelRutRepetido = 0
	correlativo = 0

	'**********CARGA ARCHIVO************'
	strSqlFile = "BULK INSERT TMP_DEUDOR_EMAIL FROM '" & strFileDir & "' with ( fieldterminator =';',ROWTERMINATOR ='\n', FIRSTROW = 2) "
	Conn.Execute strSqlFile,64
	'response.write "strSqlFile " & strSqlFile

	strSql = "SELECT * FROM TMP_DEUDOR_EMAIL"
	set rsTemp= Conn.execute(strSql)
	
	Do While not rsTemp.eof
		

		rut = rsTemp("RutDeudor")
		correo = rsTemp("Email")


		strSqlc = "SELECT ISNULL(COUNT(*),0) AS CANTIDAD FROM DEUDOR_EMAIL WHERE Email = '"&correo&"'"
		set rsTempc= Conn.execute(strSqlc)
		'response.write "strSqlc " & strSqlc
		if rsTempc("CANTIDAD") = 0 then

		ssql="EXEC SCG_WEB_NUEVO_COR '"&rut&"','"&correo&"','"&session("session_login")&"'"
		Conn.execute(ssql)
		intTelNuevo = intTelNuevo + 1

		else 
		intTelRutRepetido = intTelRutRepetido + 1
		end if


	rsTemp.movenext
	Loop


	strSqldel = "DELETE FROM TMP_DEUDOR_EMAIL"
	Conn.Execute strSqldel,64

	%>
	<table>
	<tr><td>
	Correos repetidos: <font color="red"><strong><%= intTelRutRepetido %>&nbsp;</strong></font><td>
	</tr><tr>
	Correos nuevos: <font color="red"><strong><%= intTelNuevo %>&nbsp;</strong></font><td>
	Proceso realizado correctamente
	</tr>
	</table>
 <%

	'conectamos con el FSO
	set confile = createObject("scripting.filesystemobject")
	'creamos el objeto TextStream

	response.write "terceroCSV=" & terceroCSV
	response.End

	set fichCA = confile.CreateTextFile(terceroCSV)
	fichCA.write(strTextoTercero)
	fichCA.close()

End if


function lipiatelefono(texto)

	if isnull(texto) then
		texto = ""
	end if

	texto = replace(texto,"(","")
	texto = replace(texto,")","")
	texto = replace(texto,".","")
	texto = replace(texto,"_","")
	texto = replace(texto,"--","-")
	texto = replace(texto,"/","")
	texto = replace(texto,"\","\")

lipiatelefono =texto

End function


function fechaYYMMDD(fechaI)

FechaInv= Year(fechaI) & "-" & right("00"&Day(fechaI), 2) & "-" &  right("00"&(Month(fechaI)), 2)

fechaYYMMDD = FechaInv

End function

function SioNo(valor)

	min = LCase(valor)

	if min = "si" OR min = "s" then
		ValorI = 1
	else
		ValorI = 0
	End if

SioNo = ValorI

End function

Function codigo_veri(ruts)
	rut= lipiatelefono(ruts)

	tur=strreverse(rut)
	mult = 2

	for i = 1 to len(tur)
	if mult > 7 then mult = 2 end if

	suma = mult * mid(tur,i,1) + suma
	mult = mult +1
	next

	valor = 11 - (suma mod 11)

	if valor = 11 then
	codigo_veri = "0"
	elseif valor = 10 then
	codigo_veri = "k"
	else
	codigo_veri = valor
	end if

End function
%>


				</td>
			  </tr>
			</table>


		</td>

	</tr>

</table>

</body>
</html>

