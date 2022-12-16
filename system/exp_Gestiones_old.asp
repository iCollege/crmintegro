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
<meta http-equiv="Content-Type" content="text/html;" charset=iso-8859-1" />
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
'******************************
%>
<%

 if Request("CB_CLIENTE") <> "" then
	strCliente=Request("CB_CLIENTE")
End if

 if Request("CB_ASIGNACION") <> "" then
	strAsignacion=Request("CB_ASIGNACION")
End if

dtmInicio = Request("inicio")
dtmTermino = Request("termino")


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

	strNomArchivoTerceros = "export_Gestiones_" & Fecha & ".csv"
	terceroCSV = request.serverVariables("APPL_PHYSICAL_PATH") & "Logs\" & strNomArchivoTerceros

	set confile = createObject("scripting.filesystemobject")
	set fichCA = confile.CreateTextFile(terceroCSV)

	strTextoTercero=""

	strTextoTercero = "IDGESTION;RUT;CLIENTE;NOM_CLIENTE;CORRELATIVO;CATEGORIA;SUBCATEGORIA;GESTION;NOMCATEGORIA;NOMSUBCATEGORIA;NOMGESTION;GESTION_CONCATENADA;FECHA_INGRESO;HORA_INGRESO;FECHA_COMPROMISO;FECHA_AGENDAMIENTO;OBSERVACIONES;TELEFONO_ASOCIADO;ID_USUARIO;NOM_USUARIO;SALDO_ACTIVO;ESTADO;EJEC_ASIGNADO;CAMPAÑA"

	fichCA.writeline(strTextoTercero)

	strSql = " IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'TMP_EXPORT_GESTIONES_" & session("session_idusuario") & "') AND type in (N'U'))"
	strSql = strSql & " DROP TABLE TMP_EXPORT_GESTIONES_" & session("session_idusuario")
	Conn.Execute strSql,64

	'**********CREO TABLA Y LA LLENO************'

	strSql="SELECT G.ID_GESTION, RUTDEUDOR, G.CODCLIENTE, CL.DESCRIPCION AS NOM_CLIENTE, CORRELATIVO, G.CODCATEGORIA, G.CODSUBCATEGORIA, G.CODGESTION,	GC.DESCRIPCION AS NOMCATEGORIA, GS.DESCRIPCION AS NOMSUBCATEGORIA , GG.DESCRIPCION AS NOMGESTION,"
	strSql = strSql & " FECHAINGRESO,HORAINGRESO,FECHACOMPROMISO, FECHA_AGENDAMIENTO, IsNull(OBSERVACIONES,'') as OBSERVACIONES, TELEFONO_ASOCIADO,	IDUSUARIO, U.LOGIN"
	strSql = strSql & " INTO TMP_EXPORT_GESTIONES_" & session("session_idusuario")
	strSql = strSql & " FROM GESTIONES G, GESTIONES_TIPO_CATEGORIA GC,GESTIONES_TIPO_SUBCATEGORIA GS, GESTIONES_TIPO_GESTION GG,USUARIO U, CLIENTE CL"
	strSql = strSql & " WHERE CL.CODCLIENTE = G.CODCLIENTE AND G.CODCATEGORIA = GC.CODCATEGORIA AND G.CODSUBCATEGORIA = GS.CODSUBCATEGORIA AND G.CODGESTION = GG.CODGESTION"
	strSql = strSql & " AND G.CODSUBCATEGORIA = GG.CODSUBCATEGORIA AND G.CODCATEGORIA = GG.CODCATEGORIA AND GC.CODCATEGORIA = GG.CODCATEGORIA"
	strSql = strSql & " AND GS.CODSUBCATEGORIA = GG.CODSUBCATEGORIA AND GS.CODCATEGORIA = GG.CODCATEGORIA AND G.IDUSUARIO *= U.ID_USUARIO"

	If Trim(strCliente) <> "" Then
		strSql = strSql & " AND G.CODCLIENTE = '" & strCliente & "'"
	End If

	If Trim(dtmInicio) <> "" Then
		strSql = strSql & " AND G.FECHAINGRESO >= '" & dtmInicio & "'"
	End If

	If Trim(dtmTermino) <> "" Then
		strSql = strSql & " AND G.FECHAINGRESO <= '" & dtmTermino & "'"
	End If

	If Trim(strAsignacion) <> "" Then
		''strSql = strSql & " AND C.CODREMESA = '" & strAsignacion & "'"
	End If

	''Response.write "strSql=" & strSql

	Conn.Execute strSql,64

	strSql = "SELECT * FROM TMP_EXPORT_GESTIONES_" & session("session_idusuario")

	set rsTemp= Conn.execute(strSql)

	strTextoTercero=""
	cantSiniestroC = 0
	Do While Not rsTemp.Eof

		strSql = "SELECT SUM(C.SALDO) AS SALDO, C.ESTADO_DEUDA, U.LOGIN FROM CUOTA C, USUARIO U WHERE C.USUARIO_ASIG *= U.ID_USUARIO and C.CODCLIENTE = '" & rsTemp("CODCLIENTE") & "' AND C.RUTDEUDOR = '" & rsTemp("RUTDEUDOR") & "'"
		strSql = strSql & " GROUP BY LOGIN, ESTADO_DEUDA ORDER BY ESTADO_DEUDA ASC"
		'Response.write "<br>strSql=" & strSql
		'Response.End
		set rsCuota= Conn.execute(strSql)
		strEstado = ""
		strUsuarioAsig = ""
		strEstado = ""
		If Not rsCuota.Eof Then
			intSaldo = rsCuota("SALDO")
			strUsuarioAsig = rsCuota("LOGIN")
			strEstado = rsCuota("ESTADO_DEUDA")
			If Trim(strEstado)="1" Then strEstado = "ACTIVO" Else strEstado = "NO ACTIVO"
		End If


		strSql = "SELECT IDCAMPANA FROM DEUDOR WHERE CODCLIENTE = '" & rsTemp("CODCLIENTE") & "' AND RUTDEUDOR = '" & rsTemp("RUTDEUDOR") & "'"
		set rsCamp= Conn.execute(strSql)
		If Not rsCamp.Eof Then
			intCampana = rsCamp("IDCAMPANA")
		End If

		strGestConcatenada = rsTemp("NOMCATEGORIA") & "-" & rsTemp("NOMSUBCATEGORIA") & "-" & rsTemp("NOMGESTION")
		strTextoTercero = rsTemp("ID_GESTION") & ";" & rsTemp("RUTDEUDOR") & ";" & rsTemp("NOM_CLIENTE") & ";" & rsTemp("CODCLIENTE") & ";" & rsTemp("CORRELATIVO") & ";" & rsTemp("CODCATEGORIA")  & ";" & rsTemp("CODSUBCATEGORIA") & ";" & rsTemp("CODGESTION") & ";"
		strTextoTercero = strTextoTercero & rsTemp("NOMCATEGORIA") & ";" & rsTemp("NOMSUBCATEGORIA") & ";" & rsTemp("NOMGESTION") & ";" & strGestConcatenada & ";" & rsTemp("FECHAINGRESO")  & ";" & rsTemp("HORAINGRESO") & ";"
		strTextoTercero = strTextoTercero & rsTemp("FECHACOMPROMISO") & ";" & rsTemp("FECHA_AGENDAMIENTO") & ";" & Replace(Replace(rsTemp("OBSERVACIONES"),chr(13),""),chr(10),"") & ";" & rsTemp("TELEFONO_ASOCIADO")  & ";" & rsTemp("IDUSUARIO") & ";" & rsTemp("LOGIN") & ";"
		strTextoTercero = strTextoTercero & intSaldo & ";" & strEstado & ";" & strUsuarioAsig & ";" & intCampana

		cantSiniestroC = cantSiniestroC + 1

		fichCA.writeline(strTextoTercero)

		rsTemp.movenext

	Loop


	strSql = " IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'TMP_EXPORT_GESTIONES_" & session("session_idusuario") & "') AND type in (N'U'))"
	strSql = strSql & " DROP TABLE TMP_EXPORT_GESTIONES_" & session("session_idusuario")
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

