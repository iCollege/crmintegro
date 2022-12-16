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

	strNomArchivoTerceros = "export_Demandas_" & Fecha & ".csv"


	strPathInf = request.serverVariables("APPL_PHYSICAL_PATH")
	'strPathInf =  "F:\desa\asp\crm_integrocorp\"

	terceroCSV = strPathInf & "Logs\" & strNomArchivoTerceros

	set confile = createObject("scripting.filesystemobject")

	'Response.write "terceroCSV=" & terceroCSV
	set fichCA = confile.CreateTextFile(terceroCSV)

	strTextoTercero=""




	strTextoTercero = "IDDEMANDA;RUTDEUDOR;IDTRIBUNAL;ROLANO;FECHA_INGRESO;FECHA_COMPARENDO;HORA_COMPARENDO;MONTO;GASTOS_JUDICIALES;HONORARIOS;INDEM_COMPENSATORIA;TOTAL_APAGAR;CODCLIENTE;TIPO_DEMANDA"

	fichCA.writeline(strTextoTercero)

	strSql = " IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'TMP_EXPORT_DEMANDAS_" & session("session_idusuario") & "') AND type in (N'U'))"
	strSql = strSql & " DROP TABLE TMP_EXPORT_DEMANDAS_" & session("session_idusuario")
	Conn.Execute strSql,64

	'**********CREO TABLA Y LA LLENO************'

	strSql="SELECT IDDEMANDA,RUTDEUDOR,IDTRIBUNAL,ROLANO,FECHA_INGRESO,FECHA_COMPARENDO,HORA_COMPARENDO,MONTO,GASTOS_JUDICIALES,HONORARIOS,INDEM_COMPENSATORIA,TOTAL_APAGAR,CODCLIENTE,TIPO_DEMANDA "
	strSql = strSql & " INTO TMP_EXPORT_DEMANDAS_" & session("session_idusuario")
	strSql = strSql & " FROM DEMANDA "

	If Trim(strCliente)="" Then
		strSql = strSql & " WHERE IDCLIENTE = '" & strCliente & "'"
	End If

	Conn.Execute strSql,64

	strSql = "SELECT * FROM TMP_EXPORT_DEMANDAS_" & session("session_idusuario")

	set rsTemp= Conn.execute(strSql)

	strTextoTercero=""
	cantSiniestroC = 0
	Do While Not rsTemp.Eof

		strTextoTercero = rsTemp("IDDEMANDA") & ";" & rsTemp("RUTDEUDOR") & ";" & rsTemp("IDTRIBUNAL") & ";" & rsTemp("ROLANO") & ";" & rsTemp("FECHA_INGRESO")  & ";" & rsTemp("FECHA_COMPARENDO")  & ";" & rsTemp("HORA_COMPARENDO") & ";" & rsTemp("MONTO") & ";"
		strTextoTercero = strTextoTercero & rsTemp("GASTOS_JUDICIALES") & ";" & rsTemp("HONORARIOS") & ";" & rsTemp("INDEM_COMPENSATORIA") & ";" & rsTemp("TOTAL_APAGAR") & ";" & rsTemp("CODCLIENTE") & ";" & rsTemp("TIPO_DEMANDA")

		cantSiniestroC = cantSiniestroC + 1

		fichCA.writeline(strTextoTercero)

		rsTemp.movenext

	Loop


	strSql = " IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'TMP_EXPORT_DEMANDAS_" & session("session_idusuario") & "') AND type in (N'U'))"
	strSql = strSql & " DROP TABLE TMP_EXPORT_DEMANDAS_" & session("session_idusuario")
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


function lipiatexto(texto)

	if isnull(texto) then
		texto = ""
	end if


	texto = replace(texto,"'","")
	texto = replace(texto,"  "," ")
	texto = replace(texto,".","")
	texto = replace(texto,chr(44)," ")
	texto = replace(texto,"_","")
	texto = replace(texto,"--","-")

lipiatexto =texto

End function

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

