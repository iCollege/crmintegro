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


if Request("Fecha") <> "" then
	Fecha=Request("Fecha")
End if


if Request("Asignacion") <> "Seleccionar" then
	strAsignacion=Request("Asignacion")
else
	strAsignacion = 0
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

	strNomArchivoTerceros = "Terceros_cargados_"&Fecha&".csv"
	terceroCSV = request.serverVariables("APPL_PHYSICAL_PATH") & "Logs\" & strNomArchivoTerceros

	strTextoTercero = strTextoTercero & "ID_TERCERO;PATENTE;RUT;NOMBRE;MARCA;MODELO;TELEFONO1;TELEFONO2;TELEFONO3;DIRECCION;COMUNA;CIUDAD" & chr(13) & chr(10)

	strTextoArchivoCC = ""
	strTextoArchivoCNC = ""
	strTextoArchivoCA = ""


	strFileDir = server.mappath("UploadFolder\"& strArchivo)

	strSqlFile = "DELETE FROM CARGA_DEUDA WHERE COD_CLIENTE = '" & Request("CB_CLIENTE") & "' AND COD_REMESA = " & Request("Asignacion")
	Conn.Execute strSqlFile,64

	strSql = " IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[TMP_CARGA_DEUDA]') AND type in (N'U'))"
	strSql = strSql & " DROP TABLE [TMP_CARGA_DEUDA]"
	Conn.Execute strSql,64


	strSql = " CREATE TABLE TMP_CARGA_DEUDA ( RUT varchar(12) NULL, NRO_DOC varchar(25) NULL,"
	strSql = strSql & " CUOTA tinyint NULL, TIPO_DOC varchar(30) NULL, PROTESTO varchar(60) NULL, FEC_VENC datetime NULL, FEC_PROTESTO datetime NULL,"
	strSql = strSql & " FEC_EMISION datetime NULL, MONTO numeric(12, 2) NULL, MONTO_PROTESTO numeric(12, 2) NULL, BANCO varchar(30) NULL,"
	strSql = strSql & " RUT_DEUDOR varchar(12) NULL, OBSERVACIONES varchar(80) NULL, ADICIONAL1 varchar(50) NULL,"
	strSql = strSql & " ADICIONAL2 varchar(50) NULL, ADICIONAL3 varchar(50) NULL, ADICIONAL4 varchar(50) NULL, ADICIONAL5 varchar(50) NULL ) "


	Conn.Execute strSql,64

	'response.write "Conn = " & Conn
	'response.write "strSql " & strSql

	'**********CARGA ARCHIVO************'

	strSqlFile = "BULK INSERT TMP_CARGA_DEUDA FROM '" & strFileDir & "' with ( fieldterminator =';',ROWTERMINATOR ='\n', FIRSTROW = 2)"
	Conn.Execute strSqlFile,64

	'rESPONSE.WRITE "<br>strSql=" & strSqlFile

	strSqlFile = "INSERT INTO CARGA_DEUDA SELECT " & Request("CB_CLIENTE") & "," & Request("Asignacion") & ", * FROM TMP_CARGA_DEUDA"
	Conn.Execute strSqlFile,64

	''Response.write "<br>strSql=" & strSqlFile


	strSql = "SELECT ISNULL(COUNT(*),0) AS CANTIDAD FROM TMP_CARGA_DEUDA"
	set rsTemp= Conn.execute(strSql)
	if not rsTemp.eof then
		intDeudaCarga = rsTemp("CANTIDAD")
	Else
		intDeudaCarga = 0
	End if

	strObsCarga = now

	strSql = "INSERT INTO CUOTA (RUTDEUDOR, CODCLIENTE, NRODOC, NROCUOTA, TIPODOCUMENTO, VALORCUOTA, SALDO, "
	strSql = strSql & " FECHAVENC, FECHAEMISION, FECHA_PROTESTO, ADIC1, ADIC2, ADIC3, ADIC4, ADIC5, CODREMESA,"
	strSql = strSql & " USUARIO_CREACION, FECHA_CREACION,ESTADO_DEUDA,FECHA_ESTADO, OBSERVACION,GASTOSPROTESTOS) "
	strSql = strSql & " SELECT RUT, COD_CLIENTE, NRO_DOC, IsNull(CUOTA,1), TIPO_DOC,  SUM(MONTO), SUM(MONTO), "
	strSql = strSql & " FEC_VENC, FEC_EMISION, FEC_PROTESTO,ADICIONAL1, ADICIONAL2,ADICIONAL3,ADICIONAL4,ADICIONAL5, COD_REMESA, "
	strSql = strSql & " 1,GETDATE(), 1, GETDATE(),OBSERVACIONES,MONTO_PROTESTO "
	strSql = strSql & " FROM CARGA_DEUDA WHERE COD_CLIENTE = '" & Request("CB_CLIENTE") & "' AND COD_REMESA = " & Request("Asignacion")
	strSql = strSql & " AND RUT + '-' + NRO_DOC + CAST(CUOTA AS VARCHAR(10)) NOT IN ( "
	strSql = strSql & " SELECT RUTDEUDOR + '-' + NRODOC + CAST(NROCUOTA AS VARCHAR(10)) FROM CUOTA WHERE CODCLIENTE = '" & Request("CB_CLIENTE") & "')"
	strSql = strSql & " AND RUT IN (SELECT RUTDEUDOR FROM DEUDOR WHERE CODCLIENTE = '" & Request("CB_CLIENTE") & "')"
	strSql = strSql & " GROUP BY RUT, COD_CLIENTE, NRO_DOC, CUOTA, TIPO_DOC, FEC_VENC,FEC_EMISION, FEC_PROTESTO,ADICIONAL1, ADICIONAL2,ADICIONAL3,ADICIONAL4,ADICIONAL5, COD_REMESA, OBSERVACIONES, MONTO_PROTESTO "

	'Response.write "strSql=" & strSql

	Conn.Execute strSql,64

	strSql = "UPDATE REMESA SET OBS_CARGA = '" & strObsCarga & "' WHERE CODCLIENTE = '" & Request("CB_CLIENTE") & "' AND CODREMESA = " & Request("Asignacion")
	'Response.write "strSql=" & strSql
	Conn.Execute strSql,64

	strSql = "UPDATE CUOTA SET OBS_CARGA = '" & strObsCarga & "' WHERE CODCLIENTE = '" & Request("CB_CLIENTE") & "' AND CODREMESA = " & Request("Asignacion")
	'Response.write "strSql=" & strSql
	Conn.Execute strSql,64

	strSql = "SELECT ISNULL(COUNT(*),0) AS CANTIDAD FROM CUOTA WHERE OBS_CARGA = '" & strObsCarga & "'"
	set rsTemp= Conn.execute(strSql)
	if not rsTemp.eof then
		intDeudaNueva = rsTemp("CANTIDAD")
	Else
		intDeudaNueva = 0
	End if



	'response.write "now = " & now
	'response.End

	%>
	<table>
	<tr><td>Cantidad Registros Totales: <%= intDeudaCarga %>&nbsp;<td>
	<tr><td>Cantidad Registros Nuevos: <%= intDeudaNueva %>&nbsp;<td>
	<!--tr><td>Terceros Cargados : <%= cantTercerosC %>&nbsp;<a href="#" onClick="AbreArchivo('../logs/<%=strNomArchivoTerceros%>')">Ver</a></td></tr>
	<tr><td>Terceros Actualizados : <%= cantTercerosA %>&nbsp;<a href="#" onClick="AbreArchivo('../logs/<%=strNomArchivoTercerosA%>')">Ver</a></td></tr-->

	<% if sIopAc = 1 then %>

	<tr><td>Terceros Actualizados : <%= cantSiniestroC %>&nbsp;<a href="#" onClick="AbreArchivo('../logs/<%=strNomArchivoSiniestrosA%>')">Ver</a></td></tr>

	<% end if%>

	</table>
 <%


	'conectamos con el FSO
	set confile = createObject("scripting.filesystemobject")
	'creamos el objeto TextStream

	'response.write "terceroCSV=" & terceroCSV
	'response.End

	set fichCA = confile.CreateTextFile(terceroCSV)
	fichCA.write(strTextoTercero)
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

