<% @LCID = 1034 %>
<!--#include file="arch_utils.asp"-->
<!--#include file="../lib/comunes/rutinas/funciones.inc" -->
<!--#include file="lib.asp"-->


<%
rut = request.Form("rut")
nombres=UCASE(TRIM(request("TX_NOMBRES")))
apellidos=UCASE(TRIM(request("TX_APELLIDOS")))
strNombreRP=UCASE(TRIM(request("TX_NOMBRE_REPLEGAL")))
strRutRP=TRIM(request("TX_RUT_REPLEGAL"))

strTipo = request("CB_TIPO")

nombre = nombres & " " & apellidos
cliente=request("CB_CLIENTE")

abrirscg()
strSql="SELECT * FROM DEUDOR WHERE RUTDEUDOR = '" & rut & "' AND CODCLIENTE = '" & cliente & "'"
set rsDET = Conn.execute(strSql)
If rsDET.eof then
	abrirscg()
		strSql = "INSERT INTO DEUDOR (RUTDEUDOR, CODCLIENTE, NOMBREDEUDOR, NOMBRES, APELLIDOS, FECHA_INGRESO, USUARIO_INGRESO, REPLEG_RUT, REPLEG_NOMBRE, TIPO_PERSONA) "
		strSql = strSql & " VALUES ('" & rut & "','" & cliente & "','" & nombre & "','" & nombres & "','" & apellidos & "',getdate(),'" & trim(ucase(session("session_idusuario"))) & "','" & strRutRP & "','" & strNombreRP & "','" & strTipo & "')"
		'response.write (strSql)
		'response.end
		Conn.execute(strSql)
	cerrarscg()
End if

rsDET.close
set rsDET=nothing

strEnlace="scg_ingreso.asp?rut=" & rut & "&CB_CLIENTE=" & cliente
%>
<script language="JavaScript" type="text/JavaScript">
location.href="<%=Replace(strEnlace,"'","")%>"
</script>

