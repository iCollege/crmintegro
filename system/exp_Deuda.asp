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

	strNomArchivoTerceros = "export_Deuda_" & Fecha & ".csv"
	terceroCSV = request.serverVariables("APPL_PHYSICAL_PATH") & "Logs\" & strNomArchivoTerceros

	'terceroCSV = request.serverVariables("PATH_INFO") & "Logs\" & strNomArchivoTerceros

	'rESPONSE.WRITE "terceroCSV=" & terceroCSV

	'rESPONSE.WRITE "terceroCSV=" & request.serverVariables("PATH_INFO")


	set confile = createObject("scripting.filesystemobject")
	set fichCA = confile.CreateTextFile(terceroCSV)


	strSql="SELECT IsNull(ADIC1,'ADIC1') as ADIC1, IsNull(ADIC2,'ADIC2') as ADIC2, IsNull(ADIC3,'ADIC3') as ADIC3, IsNull(ADIC4,'ADIC4') as ADIC4, IsNull(ADIC5,'ADIC5') as ADIC5, IsNull(ADIC91,'ADIC91') as ADIC91, IsNull(ADIC92,'ADIC92') as ADIC92, IsNull(ADIC93,'ADIC93') as ADIC93, IsNull(ADIC94,'ADIC94') as ADIC94, IsNull(ADIC95,'ADIC95') as ADIC95 , IsNull(ADIC96,'ADIC96') as ADIC96 , IsNull(ADIC97,'ADIC97') as ADIC97 , IsNull(ADIC98,'ADIC98') as ADIC98, IsNull(ADIC99,'ADIC99') as ADIC99 , IsNull(ADIC100,'ADIC100') as ADIC100 FROM CLIENTE WHERE CODCLIENTE = '" & strCliente & "'"
	'response.write "strSql=" & strSql
	'Response.End
	set rsDET=Conn.execute(strSql)
	if Not rsDET.eof Then
		strNombreAdic1 = UCASE(rsDET("ADIC1"))
		strNombreAdic2 = UCASE(rsDET("ADIC2"))
		strNombreAdic3 = UCASE(rsDET("ADIC3"))
		strNombreAdic4 = UCASE(rsDET("ADIC4"))
		strNombreAdic5 = UCASE(rsDET("ADIC5"))

		strNombreAdic91 = UCASE(rsDET("ADIC91"))
		strNombreAdic92 = UCASE(rsDET("ADIC92"))
		strNombreAdic93 = UCASE(rsDET("ADIC93"))
		strNombreAdic94 = UCASE(rsDET("ADIC94"))
		strNombreAdic95 = UCASE(rsDET("ADIC95"))

		strNombreAdic96 = UCASE(rsDET("ADIC96"))
		strNombreAdic97 = UCASE(rsDET("ADIC97"))
		strNombreAdic98 = UCASE(rsDET("ADIC98"))
		strNombreAdic99 = UCASE(rsDET("ADIC99"))
		strNombreAdic100 = UCASE(rsDET("ADIC100"))
	End If

	If trim(strNombreAdic1) = "" Then strNombreAdic1 = "ADIC1"
	If trim(strNombreAdic2) = "" Then strNombreAdic2 = "ADIC2"
	If trim(strNombreAdic3) = "" Then strNombreAdic3 = "ADIC3"
	If trim(strNombreAdic4) = "" Then strNombreAdic4 = "ADIC4"
	If trim(strNombreAdic5) = "" Then strNombreAdic5 = "ADIC5"

	If trim(strNombreAdic91) = "" Then strNombreAdic91 = "ADIC91"
	If trim(strNombreAdic92) = "" Then strNombreAdic92 = "ADIC92"
	If trim(strNombreAdic93) = "" Then strNombreAdic93 = "ADIC93"
	If trim(strNombreAdic94) = "" Then strNombreAdic94 = "ADIC94"
	If trim(strNombreAdic95) = "" Then strNombreAdic95 = "ADIC95"

	If trim(strNombreAdic96) = "" Then strNombreAdic96 = "ADIC96"
	If trim(strNombreAdic97) = "" Then strNombreAdic97 = "ADIC97"
	If trim(strNombreAdic98) = "" Then strNombreAdic98 = "ADIC98"
	If trim(strNombreAdic99) = "" Then strNombreAdic99 = "ADIC99"
	If trim(strNombreAdic100) = "" Then strNombreAdic100 = "ADIC100"


	strTextoTercero=""
	strTextoTercero = "ID_DEUDA;COD_ASIGNACION;ACREEDOR;NOM_ACREEDOR;TIPODOCUMENTO;FECHA_CARGA;FECHA_LLEGADA;FECHA_CREACION;NRODOC;NROCUOTA;FECHAVENC;RUTDEUDOR;NOMBREDEUDOR;REPLEG_NOMBRE;" & strNombreAdic1 & ";" & strNombreAdic2 & ";" & strNombreAdic3 & ";" & strNombreAdic4 & ";" & strNombreAdic5 & ";" & strNombreAdic91 & ";" & strNombreAdic92 & ";" & strNombreAdic93 & ";" & strNombreAdic94 & ";" & strNombreAdic95 & ";" & strNombreAdic96 & ";" & strNombreAdic97 & ";" & strNombreAdic98 & ";" & strNombreAdic99 & ";" & strNombreAdic100 & ";OBSERVACION;DEUDACAPITAL;SALDO;GASTOSPROTESTOS;ESTADO_DEUDA;DESCRIPCION;FECHA_ESTADO;USUARIO_ASIG;LOGIN;CAMPAÑA;CUSTODIO" '& chr(13) & chr(10)

	'response.write "strTextoTercero=" & strTextoTercero
	'Response.End

	fichCA.writeline(strTextoTercero)

	strSql = " IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'TMP_EXPORT_DEUDA_" & session("session_idusuario") & "') AND type in (N'U'))"
	strSql = strSql & " DROP TABLE TMP_EXPORT_DEUDA_" & session("session_idusuario")
	Conn.Execute strSql,64

	'**********CREO TABLA Y LA LLENO************'

	strSql="SELECT C.IDCUOTA,C.CODREMESA, C.CODCLIENTE, CL.DESCRIPCION AS NOM_CLIENTE, TIPODOCUMENTO,CONVERT(VARCHAR(10),R.FECHA_CARGA,103) AS FECHA_CARGA, "
	strSql = strSql & " CONVERT(VARCHAR(10),R.FECHA_LLEGADA,103) AS FECHA_LLEGADA,CONVERT(VARCHAR(10),C.FECHA_CREACION,103) AS FECHA_CREACION,NRODOC,NROCUOTA, CONVERT(VARCHAR(10),C.FECHAVENC,103) AS FECHAVENC,"
	strSql = strSql & " C.RUTDEUDOR, NOMBREDEUDOR, D.IDCAMPANA, REPLEG_NOMBRE, C.ADIC1, C.ADIC2, C.ADIC3, C.ADIC4, C.ADIC5, C.ADIC91, C.ADIC92, C.ADIC93, C.ADIC94, C.ADIC95, C.ADIC96, C.ADIC97, C.ADIC98, C.ADIC99, C.ADIC100, OBSERVACION, CAST(VALORCUOTA AS INT) AS DEUDACAPITAL,"
	strSql = strSql & " CAST(SALDO AS INT) AS SALDO, CAST(GASTOSPROTESTOS AS INT) AS GASTOSPROTESTOS,C.ESTADO_DEUDA, CONVERT(VARCHAR(10),C.FECHA_ESTADO,103) AS FECHA_ESTADO,E.DESCRIPCION, TD.NOM_TIPO_DOCUMENTO,"
	strSql = strSql & " C.USUARIO_ASIG, U.LOGIN, C.CUSTODIO INTO TMP_EXPORT_DEUDA_" & session("session_idusuario") & " FROM CUOTA C, REMESA R, DEUDOR D, ESTADO_DEUDA E, USUARIO U, CLIENTE CL, TIPO_DOCUMENTO TD"
	strSql = strSql & " WHERE C.CODREMESA = R.CODREMESA AND C.CODCLIENTE = R.CODCLIENTE AND C.RUTDEUDOR = D.RUTDEUDOR AND C.CODCLIENTE = D.CODCLIENTE AND CL.CODCLIENTE = D.CODCLIENTE"
	strSql = strSql & " AND C.ESTADO_DEUDA = E.CODIGO AND C.USUARIO_ASIG *= U.ID_USUARIO AND CL.CODCLIENTE = C.CODCLIENTE AND C.TIPODOCUMENTO = TD.COD_TIPO_DOCUMENTO"

	If Trim(strCliente) <> "" Then
		strSql = strSql & " AND C.CODCLIENTE = '" & strCliente & "'"
	End If

	If Trim(strAsignacion) <> "" Then
		strSql = strSql & " AND C.CODREMESA = '" & strAsignacion & "'"
	End If

	'Response.Write "strSql=" & strSql
	'Response.End
	Conn.Execute strSql,64

	strSql = "SELECT * FROM TMP_EXPORT_DEUDA_" & session("session_idusuario")

	set rsTemp= Conn.execute(strSql)

	strTextoTercero=""
	cantSiniestroC = 0
	Do While Not rsTemp.Eof
		strTextoTercero = rsTemp("IDCUOTA") & ";" & rsTemp("CODREMESA") & ";" & rsTemp("CODCLIENTE") & ";" & rsTemp("NOM_CLIENTE") & ";" & rsTemp("NOM_TIPO_DOCUMENTO") & ";" & rsTemp("FECHA_CARGA") & ";" & rsTemp("FECHA_LLEGADA")  & ";" & rsTemp("FECHA_CREACION")  & ";" & rsTemp("NRODOC") & ";" & rsTemp("NROCUOTA") & ";"
		strTextoTercero = strTextoTercero & rsTemp("FECHAVENC") & ";" & rsTemp("RUTDEUDOR") & ";" & rsTemp("NOMBREDEUDOR") & ";" & rsTemp("REPLEG_NOMBRE")  & ";" & rsTemp("ADIC1") & ";"
		strTextoTercero = strTextoTercero & rsTemp("ADIC2") & ";" & rsTemp("ADIC3") & ";" & rsTemp("ADIC4") & ";" & rsTemp("ADIC5")  & ";" & rsTemp("ADIC91") & ";" & rsTemp("ADIC92") & ";" & rsTemp("ADIC93") & ";" & rsTemp("ADIC94") & ";" & rsTemp("ADIC95")  & ";" & rsTemp("ADIC96")  & ";" & rsTemp("ADIC97")  & ";" & rsTemp("ADIC98")  & ";" & rsTemp("ADIC99")  & ";" & rsTemp("ADIC100")  & ";" & rsTemp("OBSERVACION") & ";" & rsTemp("DEUDACAPITAL") & ";"
		strTextoTercero = strTextoTercero & rsTemp("SALDO") & ";" & rsTemp("GASTOSPROTESTOS") & ";" & rsTemp("ESTADO_DEUDA") & ";" & rsTemp("DESCRIPCION")  & ";" & rsTemp("FECHA_ESTADO")  & ";" & rsTemp("USUARIO_ASIG") & ";" & rsTemp("LOGIN") & ";" & rsTemp("IDCAMPANA") & ";" & rsTemp("CUSTODIO")

		cantSiniestroC = cantSiniestroC + 1

		fichCA.writeline(strTextoTercero)

		rsTemp.movenext

	Loop


	strSql = " IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'TMP_EXPORT_DEUDA_" & session("session_idusuario") & "') AND type in (N'U'))"
	strSql = strSql & " DROP TABLE TMP_EXPORT_DEUDA_" & session("session_idusuario")
	Conn.Execute strSql,64

	%>
	<table>
	<tr><td>Cantidad de registros generados : <%= cantSiniestroC %></td></tr>
	<tr><td><a href="#" onClick="AbreArchivo('../logs/<%=strNomArchivoTerceros%>')">Descargar</a></td></tr>


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


%>







				</td>
			  </tr>
			</table>


		</td>

	</tr>

</table>

</body>
</html>

