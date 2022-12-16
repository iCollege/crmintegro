<% @LCID = 1034 %>
<!--#include file="arch_utils.asp"-->
<!--#include file="../lib/comunes/rutinas/funciones.inc" -->
<!--#include file="../lib/comunes/rutinas/TraeCampo.inc" -->
<!--#include file="asp/comunes/general/rutinasSCG.inc" -->
<!--#include file="../lib/comunes/rutinas/GrabaAuditoria.inc" -->
<!--#include file="lib.asp"-->

<%
	rut = request("TX_RUT")
	strRutDeudor=rut
	intIdConvenio = request("cod_convenio")
	fecha=date
	usuario=session("session_idusuario")

	AbrirScg()

		strSql = "SELECT COD_CLIENTE, RUTDEUDOR, CONVENIO_ANT  FROM REPACTACION_ENC WHERE ID_CONVENIO = " & intIdConvenio
		set rsCabecera=Conn.execute(strSql)
		If not rsCabecera.eof then
			strCodCliente = rsCabecera("COD_CLIENTE")
			strRutDeudor = rsCabecera("RUTDEUDOR")
			intConvAsociado = rsCabecera("CONVENIO_ANT")
		End if

		strSql = "UPDATE CUOTA SET ESTADO_DEUDA = '10', FECHA_ESTADO = GETDATE() "
		strSql = strSql & " WHERE IDCUOTA IN (SELECT IDCUOTA FROM CONVENIO_CUOTA WHERE ID_CONVENIO = " & intConvAsociado & ")"
		set rsUpdate=Conn.execute(strSql)

		strSql = "UPDATE CONVENIO_DET SET PAGADA = NULL"
		strSql = strSql & " WHERE PAGADA = 'R' AND ID_CONVENIO = " & intConvAsociado

		set rsUpdate=Conn.execute(strSql)

		strSql = "INSERT INTO REVERSO_REPACTACION_DET SELECT * FROM REPACTACION_DET WHERE ID_CONVENIO=" & intIdConvenio
		set rsBorra=Conn.execute(strSql)

		strSql = "DELETE REPACTACION_DET WHERE ID_CONVENIO=" & intIdConvenio
		set rsBorra=Conn.execute(strSql)

		aa = GrabaAuditoria("BORRAR", "ID_CONVENIO=" & intIdConvenio, "reversar_repactacion.asp","REPACTACION_DET")


		strSql = "INSERT INTO REVERSO_REPACTACION_ENC SELECT * FROM REPACTACION_ENC WHERE ID_CONVENIO=" & intIdConvenio
		set rsBorra=Conn.execute(strSql)

		strSql = "DELETE REPACTACION_ENC WHERE ID_CONVENIO=" & intIdConvenio
		set rsBorra=Conn.execute(strSql)
		aa = GrabaAuditoria("BORRAR", "ID_CONVENIO=" & intIdConvenio, "reversar_repactacion.asp","REPACTACION_ENC")

		'Response.End

		CerrarScg()
	%>
	<script>alert("Repactacion fue reversada correctamente")</script>
	<%
	Response.Write ("<script language = ""Javascript"">" & vbCrlf)
	Response.Write (vbTab & "location.href='detalle_repactacion.asp'" & vbCrlf)
	Response.Write ("</script>")
%>
