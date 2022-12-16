<% @LCID = 1034 %>
<!--#include file="arch_utils.asp"-->
<!--#include file="../lib/comunes/rutinas/funciones.inc" -->
<!--#include file="lib.asp"-->
<!--#include file="asp/comunes/general/SoloNumeros.inc" -->
<%
	AbrirScg()

	idGestion=request.QueryString("gestion")

	strSql="SELECT * FROM GESTIONES WHERE ID_GESTION = '" & idGestion & "'"
	set rsGestCat=Conn.execute(strSql)
	do until rsGestCat.eof

	detalle = rsGestCat("Observaciones")
	rut = rsGestCat("RutDeudor")
	fecha = rsGestCat("FechaIngreso")

	rsGestCat.Movenext
	loop
	rsGestCat.close
	set rsGestCat=nothing

	strSql = "DELETE FROM GESTIONES WHERE Id_Gestion = '" & idGestion & "'"
	set rsGest = Conn.execute(strSql )


	observ = "Eliminacion de gestion " &  detalle & " Rut: " & rut
	'response.write(observ)


		strSql = "INSERT INTO LOG_CRMCOBROS (ID_USUARIO, LOGIN, FECHA, IP, IP_HOST, IP_LOCAL, IP_CLIENTE, OBSERVACION)"
		strSql = strSql & " Values (" & session("session_idusuario") & ",'" & session("session_login") & "',getdate(),'" & Mid(request.servervariables("REMOTE_ADDR"),1,19) & "','" & Mid(request.servervariables("REMOTE_HOST"),1,19) & "','" & Mid(request.servervariables("LOCAL_ADDR"),1,19) & "','" & Mid(request.servervariables("HTTP_CLIENT_IP"),1,19) & "','" & observ & "')"
		set rsInserta=Conn.execute(strSql)

	'response.write(strSql)
%>
<script language="JavaScript" type="text/JavaScript">
alert('GESTION ELIMINADA !!');
window.navigate('principal.asp?rut=<%=rut%>');
</script>