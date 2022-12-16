<% @LCID = 1034 %>
<!--#include file="arch_utils.asp"-->
<!--#include file="sesion.asp"-->
<!--#include file="../lib/comunes/rutinas/funciones.inc" -->
<!--#include file="../lib/comunes/rutinas/TraeCampo.inc" -->
<!--#include file="asp/comunes/general/rutinasSCG.inc" -->
<!--#include file="lib.asp"-->
<%


	AbrirSCG()
		cod_caja=session("session_idusuario")

		strSql = "EXEC UPD_SEC 'REPACTACION_ENC'"

		set rsPago=Conn.execute(strSql)
		If not rsPago.Eof then
			intSeq = rsPago("SEQ")
		End if

		strArrIdCuota=Replace(Request("strArrIdCuota"),";",",")
		''Response.write "strArrIdCuota=" & strArrIdCuota
		vArrIdCuota = split(strArrIdCuota,";")
		intTamvIdCuota=ubound(vArrIdCuota)

		strCodCliente = Request("strCodCliente")
		strRutDeudor = Request("strRutDeudor")
		intTotalConvenio = Request("intTotalConvenio")
		intTotalCapital = Request("intTotalCapital")
		intIndemComp = Request("intIndemComp")
		intGastos = Request("intGastos")
		intHonorarios = Request("intHonorarios")
		intDescTotalCapital = Request("intDescTotalCapital")
		intDescIndemComp = Request("intDescIndemComp")
		intDescGastos = Request("intDescGastos")
		intDescHonorarios = Request("intDescHonorarios")
		intPie = Request("intPie")
		intCuotas = Request("intCuotas")
		intDiaDePago = Request("intDiaPago")
		strObservaciones = Request("strObservaciones")
		intIntConvenio = Request("intIntConvenio")
		id_convenio = Request("id_convenio")

		'Response.write "intIntConvenio = " & intIntConvenio
		'Response.write "Cuotas = " & Round((intTotalConvenio-intPie+intIntConvenio)/intCuotas,0)
		'Response.End


		strSql = "INSERT INTO REPACTACION_ENC (ID_CONVENIO, FECHAINGRESO, COD_CLIENTE, RUTDEUDOR, USRINGRESO,  TOTAL_CONVENIO, CAPITAL, INTERESES, GASTOS, HONORARIOS, DESC_CAPITAL, DESC_INTERESES, DESC_GASTOS, DESC_HONORARIOS, PIE, CUOTAS, DIA_PAGO, OBSERVACIONES, CONVENIO_ANT) "
		strSql = strSql & " VALUES (" & intSeq & ", getdate(),'" & strCodCliente & "','" & strRutDeudor & "'," & session("session_idusuario") & "," &  intTotalConvenio & ","
		strSql = strSql & intTotalCapital & "," & intIndemComp & "," & intGastos & "," & intHonorarios & "," & intDescTotalCapital & "," &  intDescIndemComp & "," & intDescGastos & "," & intDescHonorarios & "," & intPie & "," & intCuotas & "," & intDiaDePago & ",'" & strObservaciones & "'," & id_convenio & ")"

		'Response.write strSql
		'Response.End

		set rsInsertaEnc=Conn.execute(strSql)

		strSql = "INSERT INTO REPACTACION_DET (ID_CONVENIO, CUOTA, TOTAL_CUOTA, FECHA_PAGO) "
		strSql = strSql & " VALUES (" & intSeq & ", 0," & intPie & ",getdate())"

		'Response.write strSql
		'Response.End
		set rsInsertaDet=Conn.execute(strSql)

		intMesDePago = Month(date)
		intAnoDePago = Year(date)
		For i=1 to intCuotas
			intMesDePago = intMesDePago + 1
			If intMesDePago = 13 Then
				intMesDePago = 1
				intAnoDePago = intAnoDePago + 1
			End if
			dtmFechaPago = PoneIzq(intDiaDePago,"0") & "/" & PoneIzq(intMesDePago,"0") & "/" & intAnoDePago
			intNroCuota = i
			intMonto = Round((intTotalConvenio-intPie+intIntConvenio)/intCuotas,0)

			''Response.write "<br>dtmFechaPago=" & dtmFechaPago


			strObjeto = "TX_CUOTA" & i
			intMonto = ValNulo(Request(strObjeto),"N")

			If Mid(dtmFechaPago,4,2) = "02" and Cdbl(intDiaDePago) > 28 Then
				dtmFechaPago = "28/02/" & Mid(dtmFechaPago,7,4)
			End if

			If Cdbl(intDiaDePago) > 30 Then
				dtmFechaPago = "30/" & Mid(dtmFechaPago,4,2) & "/" & Mid(dtmFechaPago,7,4)
			End if


			strSql = "INSERT INTO REPACTACION_DET (ID_CONVENIO, CUOTA, TOTAL_CUOTA, FECHA_PAGO) "
			strSql = strSql & " VALUES (" & intSeq & ", " & intNroCuota & "," & intMonto & ",'" & dtmFechaPago & "')"
			'Response.write strSql
			'Response.End
			set rsInsertaDet=Conn.execute(strSql)
		Next

		strSql = "UPDATE CONVENIO_DET SET PAGADA = 'R'"
		strSql = strSql & " WHERE ID_CONVENIO = " & id_convenio & " AND IsNull(PAGADA,'N') <> 'S'"
		set rsUpdate=Conn.execute(strSql)


		strSql = "UPDATE CUOTA SET ESTADO_DEUDA = 11, TIPOCOB = 'REPACTACION', FECHA_ESTADO = getdate()"
		strSql = strSql & " WHERE RUTDEUDOR = '" & strRutDeudor & "' AND CODCLIENTE = '" & strCodCliente &  "'"
		''strSql = strSql & " AND ID_CONVENIO = " & id_convenio
		strSql = strSql & " AND IDCUOTA IN (SELECT DISTINCT IDCUOTA FROM CONVENIO_CUOTA WHERE ID_CONVENIO = " & id_convenio & ")"

		'rESPONSE.WRITE strSql
		'rESPONSE.eND


		set rsInsertaConvCuota=Conn.execute(strSql)


		%>
			<script>alert("Convenio grabado correctamente.")</script>
		<%
		Response.Write ("<script language = ""Javascript"">" & vbCrlf)
		Response.Write (vbTab & "location.href='simulacion_repactacion.asp?rut=" & rut & "&tipo=1'" & vbCrlf)
		Response.Write ("</script>")
		%>
	</td>
   </tr>
  </table>

</form>
