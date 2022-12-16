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
<html xmlns=http:"www.w3.org/1999/xhtml">
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

	strSqlFile = "DELETE FROM CARGA_GESTIONES WHERE COD_USUARIO = " & session("session_idusuario")
	'response.write "strSqlFile " & strSqlFile
	Conn.Execute strSqlFile,64

	strSql = " IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'TMP_CARGA_GESTIONES') AND type in (N'U'))"
	strSql = strSql & " DROP TABLE TMP_CARGA_GESTIONES"
	Conn.Execute strSql,64


	strSql = "CREATE TABLE TMP_CARGA_GESTIONES (RUTDEUDOR varchar(12) NULL, CODCLIENTE varchar(53) NULL, CODCATEGORIA int NULL,CODSUBCATEGORIA int NULL, "
	strSql = strSql & " CODGESTION int NULL, FECHAINGRESO datetime NULL,HORAINGRESO varchar(8) NULL,FECHACOMPROMISO datetime NULL, "
	strSql = strSql & " FECHAAGENDAMIENTO datetime NULL,OBSERVACIONES varchar(500) NULL,ID_USUARIO int NULL, TELEFONO_ASOCIADO VARCHAR(25) NULL)"


	Conn.Execute strSql,64

	'response.write "Conn = " & Conn
	'response.write "strSql " & strSql

	'**********CARGA ARCHIVO************'

	strSqlFile = "BULK INSERT TMP_CARGA_GESTIONES FROM '" & strFileDir & "' with ( fieldterminator =';',ROWTERMINATOR ='\n', FIRSTROW = 2)"

	response.write "strSqlFile " & strSqlFile
	'response.eND

	Conn.Execute strSqlFile,64





	strSql = "SELECT ISNULL(COUNT(*),0) AS CANTIDAD FROM TMP_CARGA_GESTIONES WHERE RUTDEUDOR IS NULL OR CODCLIENTE IS NULL OR CODCATEGORIA IS NULL OR CODSUBCATEGORIA IS NULL OR CODGESTION IS NULL OR FECHAINGRESO IS NULL"
	set rsTemp= Conn.execute(strSql)
	if not rsTemp.eof then
		intValida = rsTemp("CANTIDAD")
	Else
		intValida = 0
	End if

	If intValida > 0 Then
	%>
		<script>
			alert('RUTDEUDOR,CODCLIENTE,CODCATEGORIA,CODSUBCATEGORIA,CODGESTION Y FECHAINGRESO DEBEN TENER VALORES');
			history.back();
		</script>

	<%
		Response.End
	End if


	'strSqlFile = "INSERT INTO CARGA_GESTIONES SELECT " & Request("CB_CLIENTE") & "," & Request("Asignacion") & ", * FROM TMP_CARGA_GESTIONES"
	strSqlFile = "INSERT INTO CARGA_GESTIONES (RUTDEUDOR,CODCLIENTE,CODCATEGORIA,CODSUBCATEGORIA,CODGESTION,FECHAINGRESO,HORAINGRESO,FECHACOMPROMISO,FECHAAGENDAMIENTO,OBSERVACIONES,ID_USUARIO,TELEFONO_ASOCIADO,COD_USUARIO)"
	strSqlFile = strSqlFile & " SELECT RUTDEUDOR,CODCLIENTE,CODCATEGORIA,CODSUBCATEGORIA,CODGESTION,FECHAINGRESO,HORAINGRESO,FECHACOMPROMISO,FECHAAGENDAMIENTO,OBSERVACIONES,ID_USUARIO,TELEFONO_ASOCIADO, " & session("session_idusuario") & " FROM TMP_CARGA_GESTIONES"
	'Response.write "<BR>strSqlFile1111111111=" & strSqlFile
	'Response.End
	Conn.Execute strSqlFile,64

	strSqlFile = "UPDATE CARGA_GESTIONES SET HORAINGRESO = '12:13' WHERE HORAINGRESO IS NULL AND COD_USUARIO = " & session("session_idusuario")
	Conn.Execute strSqlFile,64

	strSqlFile = "UPDATE CARGA_GESTIONES SET ID_USUARIO = 0  WHERE ID_USUARIO IS NULL AND COD_USUARIO = " & session("session_idusuario")
	Conn.Execute strSqlFile,64


	strSql = "SELECT ISNULL(COUNT(*),0) AS CANTIDAD FROM TMP_CARGA_GESTIONES"
	set rsTemp= Conn.execute(strSql)
	if not rsTemp.eof then
		intTotal = rsTemp("CANTIDAD")
	Else
		intTotal = 0
	End if




	strObsCarga = now

	strFuente = "CARGA MASIVA: " & strObsCarga

	strSql = "INSERT GESTIONES (RUTDEUDOR, CODCLIENTE,CORRELATIVO, CODCATEGORIA,CODSUBCATEGORIA, CODGESTION, FECHAINGRESO ,HORAINGRESO ,FECHACOMPROMISO, FECHA_AGENDAMIENTO ,OBSERVACIONES ,IDUSUARIO, DIRECCION_ASOCIADA, NRODOC, CORRELATIVODATO,  TELEFONO_ASOCIADO)"
	strSql = strSql & " SELECT DISTINCT RUTDEUDOR, CODCLIENTE, DBO.FUN_MAX_CORR_GESTIONES (RUTDEUDOR,CODCLIENTE) ,CODCATEGORIA,CODSUBCATEGORIA, CODGESTION, FECHAINGRESO ,HORAINGRESO ,FECHACOMPROMISO, FECHAAGENDAMIENTO ,OBSERVACIONES ,ID_USUARIO,'" & strFuente & "',1,1, TELEFONO_ASOCIADO"
	strSql = strSql & " FROM CARGA_GESTIONES WHERE COD_USUARIO = " & session("session_idusuario")
	strSql = strSql & " AND RUTDEUDOR IN (SELECT RUTDEUDOR FROM DEUDOR)"

	'response.write "<br>strSql = " & strSql
	'response.End

	Conn.Execute strSql,64

	strSql = "SELECT ISNULL(COUNT(*),0) AS CANTIDAD FROM GESTIONES WHERE DIRECCION_ASOCIADA = '" & strFuente & "'"
	set rsTemp= Conn.execute(strSql)
	if not rsTemp.eof then
		intCargados = rsTemp("CANTIDAD")
	Else
		intCargados = 0
	End if


	%>
	<table>
	<tr><td>Cantidad Registros Totales: <%= intTotal %>&nbsp;<td>
	<tr><td>Registros Cargados Correctamente: <%= intCargados %>&nbsp;<td>

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

