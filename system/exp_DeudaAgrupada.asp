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

	strNomArchivoTerceros = "export_DeudaAgrup_" & Fecha & ".csv"
	terceroCSV = request.serverVariables("APPL_PHYSICAL_PATH") & "Logs\" & strNomArchivoTerceros

	set confile = createObject("scripting.filesystemobject")
	set fichCA = confile.CreateTextFile(terceroCSV)

	strTextoTercero = "RUTDEUDOR;FECHA_INGRESO;ACREEDOR;NOM_ACREEDOR;ESTADO;DEUDACAPITAL;SALDO;USUARIO_ASIG;LOGIN;CAMPAÑA;DOCUMENTOS;FEC_SUBIDA_ARCH;FECHA_CREACION"

	fichCA.writeline(strTextoTercero)

	strSql = " IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'TMP_EXPORT_DEUDA_AGRUP_" & session("session_idusuario") & "') AND type in (N'U'))"
	strSql = strSql & " DROP TABLE TMP_EXPORT_DEUDA_AGRUP_" & session("session_idusuario")
	Conn.Execute strSql,64

	'**********CREO TABLA Y LA LLENO************'

	strSql="SELECT C.CODCLIENTE, CL.DESCRIPCION AS NOM_CLIENTE, C.RUTDEUDOR, D.FECHA_INGRESO, NOMBREDEUDOR, D.IDCAMPANA, "
	strSql = strSql & " CAST(SUM(VALORCUOTA) AS INT) AS DEUDACAPITAL, CAST(SUM(SALDO) AS INT) AS SALDO, "
	strSql = strSql & " COUNT(DISTINCT NRODOC) AS DOCUMENTOS, CONVERT(VARCHAR(10),FEC_SUBIDA_ULT_ARCHIVO,103) AS FEC_SUBIDA_ARCH, CONVERT(VARCHAR(10),MAX(C.FECHA_CREACION),103) AS FECHA_CREACION INTO TMP_EXPORT_DEUDA_AGRUP_" & session("session_idusuario")
	strSql = strSql & " FROM CUOTA C, DEUDOR D, CLIENTE CL"
	strSql = strSql & " WHERE C.RUTDEUDOR = D.RUTDEUDOR AND C.CODCLIENTE = D.CODCLIENTE AND "
	strSql = strSql & " CL.CODCLIENTE = D.CODCLIENTE AND CL.CODCLIENTE = C.CODCLIENTE "

	If Trim(strCliente) <> "" Then
		strSql = strSql & " AND C.CODCLIENTE = '" & strCliente & "'"
	End If

	If Trim(strAsignacion) <> "" Then
		strSql = strSql & " AND C.CODREMESA = '" & strAsignacion & "'"
	End If

	strSql = strSql & " GROUP BY C.CODCLIENTE, D.FECHA_INGRESO, CL.DESCRIPCION,  C.RUTDEUDOR, NOMBREDEUDOR, D.IDCAMPANA, FEC_SUBIDA_ULT_ARCHIVO "



	'Response.Write "strSql=" & strSql
	'Response.End
	Conn.Execute strSql,64

	strSql = "SELECT * FROM TMP_EXPORT_DEUDA_AGRUP_" & session("session_idusuario")

	set rsTemp= Conn.execute(strSql)

	strTextoTercero=""
	cantSiniestroC = 0
	Do While Not rsTemp.Eof

		strSql = "SELECT SALDO FROM CUOTA WHERE CODCLIENTE = '" & rsTemp("CODCLIENTE") & "' AND RUTDEUDOR = '" & rsTemp("RUTDEUDOR")  & "' AND (SALDO > 0 OR ESTADO_DEUDA IN (1,7,8)) "
		set rsEstado =  Conn.execute(strSql)
		If Not rsEstado.Eof Then
			strEstado = "ACTIVO"
		Else
			strEstado = "NO ACTIVO"
		End If

		strSql = "SELECT USUARIO_ASIG, LOGIN FROM CUOTA C, USUARIO U WHERE C.CODCLIENTE = '" & rsTemp("CODCLIENTE") & "' AND C.RUTDEUDOR = '" & rsTemp("RUTDEUDOR")  & "' AND C.USUARIO_ASIG = U.ID_USUARIO ORDER BY ESTADO_DEUDA"
		set rsEstado =  Conn.execute(strSql)
		If Not rsEstado.Eof Then
			intCodAsig = rsEstado("USUARIO_ASIG")
			strLogin = rsEstado("LOGIN")
		Else
			intCodAsig = ""
			strLogin = "SIN ASIGNACION"
		End If


		strTextoTercero = rsTemp("RUTDEUDOR") & ";" & rsTemp("FECHA_INGRESO") & ";" & rsTemp("CODCLIENTE") & ";" & rsTemp("NOM_CLIENTE") & ";" & strEstado & ";" & rsTemp("DEUDACAPITAL") & ";" & rsTemp("SALDO") & ";"
		strTextoTercero = strTextoTercero & intCodAsig & ";" & strLogin & ";" & rsTemp("IDCAMPANA") & ";" & rsTemp("DOCUMENTOS") & ";" & rsTemp("FEC_SUBIDA_ARCH") & ";" & rsTemp("FECHA_CREACION")

		cantSiniestroC = cantSiniestroC + 1

		fichCA.writeline(strTextoTercero)

		rsTemp.movenext

	Loop


	strSql = " IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'TMP_EXPORT_DEUDA_AGRUP_" & session("session_idusuario") & "') AND type in (N'U'))"
	strSql = strSql & " DROP TABLE TMP_EXPORT_DEUDA_AGRUP_" & session("session_idusuario")
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

