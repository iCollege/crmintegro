<% @LCID = 1034 %>
<!--#include file="arch_utils.asp"-->
<!--#include file="../lib/comunes/rutinas/funciones.inc" -->
<!--#include file="lib.asp"-->
<title>Detalle de Ingreso BACKOFFICE</title>

<%
rut = request("rut")
nrodoc=UCASE(TRIM(request("nrodoc")))
monto=TRIM(REPLACE(request("monto"),".",""))
banco=UCASE(TRIM(request("banco")))
cliente=TRIM(request("cliente"))
cobrador=UCASE(TRIM(request("cobrador")))
inicio=TRIM(request("inicio"))
termino=TRIM(request("termino"))
centro_costo=UCASE(TRIM(request("centrocosto")))
sucursal=UCASE(TRIM(request("sucursal")))
strGlosa=TRIM(request("glosa"))

strCuenta=TRIM(request("TX_CUENTA"))
intCodRemesa=TRIM(request("CB_REMESA"))

strAdic1=TRIM(request("TX_ADIC1"))
strAdic2=TRIM(request("TX_ADIC2"))
strAdic3=TRIM(request("TX_ADIC3"))
strAdic4=TRIM(request("TX_ADIC4"))
strAdic5=TRIM(request("TX_ADIC5"))
dtmFecCreacion=TRIM(request("TX_FEC_CREACION"))
If Trim(dtmFecCreacion) = "" Then
	dtmFecCreacion = "getdate()"
Else
	dtmFecCreacion = "'" & dtmFecCreacion & "'"
End If

dtmFecEstado = dtmFecCreacion

strTipoDoc=TRIM(request("TX_TIPODOC"))
intNroCuota = Trim(request("TX_NROCUOTA"))

vigente = trim(replace(request("TX_SALDO"),".",""))
vencida = trim(replace(request("vencida"),".",""))
mora = trim(replace(request("mora"),".",""))
protesto = trim(replace(request("protesto"),".",""))


vigente = ValNulo(vigente,"N")
vencida = ValNulo(vencida,"N")
mora = ValNulo(mora,"N")
protesto = ValNulo(protesto,"N")

intSaldo = ValNulo(vigente,"N")
monto=ValNulo(monto,"N")

'response.write (vigente)
'response.write ("<br>")

abrirscg()
strSql=""
strSql="SELECT * FROM CUOTA WHERE RUTDEUDOR = '" & rut & "' AND CODCLIENTE = " & cliente & " AND NRODOC='" & nrodoc & "'"
'REsponse.write "strSql=" & strSql
'REsponse.End
set rsDET = Conn.execute(strSql)
If not rsDET.eof then
	esta="si"
Else
	esta="no"
End if

rsDET.close
set rsDET=nothing

'response.write (ssql)
'response.end
If esta="no" then
	abrirscg()
		strSql = "INSERT INTO CUOTA (RUTDEUDOR,CODCLIENTE,NRODOC,FECHAVENC,NROCUOTA, CUENTA,"
		strSql = strSql & "VALORCUOTA,SALDO,VIGENTE,VENCIDA, MORA, GASTOSPROTESTOS, CODREMESA,ESTADO_DEUDA,FECHA_ESTADO, TIPODOCUMENTO, "
		strSql = strSql & "GLOSA,FECHA_ASIGNACION,USUARIO_ASIG, FECHA_CREACION, USUARIO_CREACION, SUCURSAL, CENTRO_COSTO, "
		strSql = strSql & "ADIC1,ADIC2,ADIC3, ADIC4, ADIC5) "
		strSql = strSql & "VALUES ('"&rut&"','"&cliente&"','"&nrodoc&"','"&inicio&"'," & intNroCuota & ",'" & strCuenta & "',"
		strSql = strSql &  intSaldo & "," & intSaldo & "," & vigente & "," & vencida & "," & mora & "," & protesto & "," & intCodRemesa & ",1,"  & dtmFecEstado & ",'" & strTipoDoc & "','"
		strSql = strSql &  strGlosa & "'," & dtmFecCreacion & "," & cobrador & "," & dtmFecCreacion & "," & session("session_idusuario") & ", '" & sucursal & "','" & centro_costo & "','"
		strSql = strSql &  strAdic1 & "','" & strAdic2 & "','" & strAdic3 & "','" & strAdic4 & "','" & strAdic5 & "')"
		'response.write (strSql)
		'response.end
		Conn.execute(strSql)
	cerrarscg()
Else
	strEnlace="nueva_deuda_gral.asp?cliente=" & cliente & " &rut=" & rut
	%>
	<script language="JavaScript" type="text/JavaScript">
		alert("DEUDA YA SE ENCUENTRA EN NUESTROS SISTEMAS")
		location.href="<%=Replace(strEnlace,"'","")%>"
	</script>
	<%
End if
strEnlace="nueva_deuda_gral.asp?cliente=" & cliente & "&rut=" & rut
%>
<script language="JavaScript" type="text/JavaScript">
	alert("DEUDA INGRESADA EXITOSAMENTE")
	location.href="<%=Replace(strEnlace,"'","")%>"
</script>
