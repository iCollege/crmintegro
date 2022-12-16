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

		strSql = "SELECT COD_CLIENTE, RUTDEUDOR  FROM CONVENIO_ENC WHERE ID_CONVENIO = " & intIdConvenio
		set rsCabecera=Conn.execute(strSql)
		If not rsCabecera.eof then
			strCodCliente = rsCabecera("COD_CLIENTE")
			strRutDeudor = rsCabecera("RUTDEUDOR")
		End if

		strSql = "SELECT SALDO, NRODOC, IDCUOTA FROM CONVENIO_CUOTA WHERE ID_CONVENIO = " & intIdConvenio
		'Response.write "<br>strSql = " & strSql
		set rsDetalle=Conn.execute(strSql)
		If not rsDetalle.eof then
			Do until rsDetalle.eof
				intCapital = rsDetalle("SALDO")
				strNroDoc = rsDetalle("NRODOC")
				intIdCuota = rsDetalle("IDCUOTA")

				strSql = "UPDATE CUOTA SET SALDO = SALDO + " & intCapital & ", ESTADO_DEUDA = '1', FECHA_ESTADO = GETDATE() "
				strSql = strSql & " WHERE IDCUOTA = " & intIdCuota
				'Response.write "<br>strSql = " & strSql
				set rsUpdate=Conn.execute(strSql)
				rsDetalle.MoveNext
			Loop
		End If



		strSql = "INSERT INTO REVERSO_CONVENIO_DET SELECT * FROM CONVENIO_DET WHERE ID_CONVENIO=" & intIdConvenio
		set rsIinserta=Conn.execute(strSql)

		strSql = "DELETE CONVENIO_DET WHERE ID_CONVENIO=" & intIdConvenio
		set rsBorra=Conn.execute(strSql)

		aa = GrabaAuditoria("BORRAR", "ID_CONVENIO=" & intIdConvenio, "reversar_convenio.asp","CONVENIO_DET")

		strSql = "DELETE CONVENIO_CUOTA WHERE ID_CONVENIO=" & intIdConvenio
		set rsBorra=Conn.execute(strSql)

		aa = GrabaAuditoria("BORRAR", "ID_CONVENIO=" & intIdConvenio, "reversar_convenio.asp","CONVENIO_CUOTA")


		'strSql = "INSERT INTO REVERSO_CONVENIO_ENC SELECT * FROM CONVENIO_ENC WHERE ID_CONVENIO=" & intIdConvenio
		'set rsIinserta=Conn.execute(strSql)

		strSql = "DELETE CONVENIO_ENC WHERE ID_CONVENIO=" & intIdConvenio
		set rsBorra=Conn.execute(strSql)

		aa = GrabaAuditoria("BORRAR", "ID_CONVENIO=" & intIdConvenio, "reversar_convenio.asp","CONVENIO_ENC")

		'Response.End

		CerrarScg()
	%>
	<script>alert("El convenio fue reversado correctamente")</script>
	<%
	Response.Write ("<script language = ""Javascript"">" & vbCrlf)
	Response.Write (vbTab & "location.href='detalle_convenio.asp'" & vbCrlf)
	Response.Write ("</script>")
%>
