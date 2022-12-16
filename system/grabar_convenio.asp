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
		strRutSede = Request("strRutSede")
		strSede = Request("strSede")

		strArrIdCuota=Replace(Request("strArrIdCuota"),";",",")
		''Response.write "strArrIdCuota=" & strArrIdCuota
		vArrIdCuota = split(strArrIdCuota,";")
		intTamvIdCuota=ubound(vArrIdCuota)

		strTipoConv= Request("strTipoConv")

		intMonto = Request("intCuota" & "1")

		'Response.write "intMonto111=" & intMonto
		'Response.write "strTipoConv=" & Request("strTipoConv")


		''Response.End

		strCodCliente = ValNulo(Request("strCodCliente"),"C")
		strRutDeudor = ValNulo(Request("strRutDeudor"),"C")
		intTotalConvenio = ValNulo(Request("intTotalConvenio"),"N")

		intTotalCapital = ValNulo(Request("intTotalCapital"),"N")
		intIndemComp = ValNulo(Request("intIndemComp"),"N")
		intIntereses = ValNulo(Request("intIntereses"),"N")

		intInteresConvenio = ValNulo(Request("intInteresConvenio"),"N")

		intProtestos = ValNulo(Request("intProtestos"),"N")
		intGastos = ValNulo(Request("intGastos"),"N")
		intHonorarios = ValNulo(Request("intHonorarios"),"N")
		intDescTotalCapital = ValNulo(Request("intDescTotalCapital"),"N")
		intDescIndemComp = ValNulo(Request("intDescIndemComp"),"N")
		intDescGastos = ValNulo(Request("intDescGastos"),"N")
		intDescHonorarios = ValNulo(Request("intDescHonorarios"),"N")
		intDescProtestos = ValNulo(Request("intDescProtestos"),"N")
		intPie = ValNulo(Request("intPie"),"N")
		intCuotas = ValNulo(Request("intCuotas"),"N")
		intDiaDePago = Request("intDiaPago")
		strObservaciones = Request("strObservaciones")
		intIntConvenio = Request("intIntConvenio")
		intValorCuota = Request("intValorCuota")


		strSql = "EXEC UPD_SEC 'CONVENIO_ENC'"
		set rsPago=Conn.execute(strSql)
		If not rsPago.Eof then
			intSeq = rsPago("SEQ")
		End if

		strSql = "EXEC UPD_CONVENIO_CORRELATIVO '" & strCodCliente & "','" & strRutSede & "'"
		set rsPago=Conn.execute(strSql)
		If not rsPago.Eof then
			intFolio = rsPago("CORRELATIVO")
		Else
			%>
				<script>
				alert("No se ha definido correlativo para cliente y sede seleccionada");
				history.back();
				</script>
			<%
		End if

		'Response.write "<BR>intFolio = " & intFolio
		'Response.write "<BR>intSeq = " & intSeq
		'Response.write "<BR>intIntConvenio = " & intIntConvenio
		'Response.write "<BR>Cuotas = " & Round((intTotalConvenio-intPie+intIntConvenio)/intCuotas,0)
		'Response.End


		strSql = "INSERT INTO CONVENIO_ENC (ID_CONVENIO, FECHAINGRESO, COD_CLIENTE, RUTDEUDOR, USRINGRESO,  TOTAL_CONVENIO, CAPITAL, INTERESES, GASTOS, PROTESTOS, IC, HONORARIOS, DESC_CAPITAL, DESC_INTERESES, DESC_GASTOS, DESC_HONORARIOS, DESC_PROTESTOS, PIE, CUOTAS, DIA_PAGO, OBSERVACIONES, FOLIO, COD_ESTADO_FOLIO, SEDE, INTERES_CONVENIO) "
		strSql = strSql & " VALUES (" & intSeq & ", getdate(),'" & strCodCliente & "','" & strRutDeudor & "'," & session("session_idusuario") & "," &  intTotalConvenio & ","
		strSql = strSql & intTotalCapital & "," & intIntereses & "," & intGastos & "," & intProtestos & "," & intIndemComp & "," & intHonorarios & "," & intDescTotalCapital & "," &  intDescIndemComp & "," & intDescGastos & "," & intDescHonorarios & "," & intDescProtestos & "," & intPie & "," & intCuotas & "," & intDiaDePago & ",'" & strObservaciones & "'," & intFolio & ",1,'" & strSede & "'," & intInteresConvenio & ")"

		'Response.write strSql
		'Response.End

		set rsInsertaEnc=Conn.execute(strSql)

		strSql = "INSERT INTO CONVENIO_DET (ID_CONVENIO, CUOTA, TOTAL_CUOTA, FECHA_PAGO) "
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
			''intMonto = Round((intTotalConvenio-intPie+intIntConvenio)/intCuotas,0)

			''Response.write "<br>dtmFechaPago=" & dtmFechaPago
			''Response.write "<br>intMontoConInteres=" & intMontoConInteres

			If Not Isnull(intMontoConInteres/intCuotas) Then
				intMonto = Round(intMontoConInteres/intCuotas,0)
				intMonto= intValorCuota
			End if


			If Mid(dtmFechaPago,4,2) = "02" and Cdbl(intDiaDePago) > 28 Then
				dtmFechaPago = "28/02/" & Mid(dtmFechaPago,7,4)
			End if

			If Cdbl(intDiaDePago) > 30 Then
				dtmFechaPago = "30/" & Mid(dtmFechaPago,4,2) & "/" & Mid(dtmFechaPago,7,4)
			End if



			If Trim(strTipoConv) = "" Then
				strSql = "INSERT INTO CONVENIO_DET (ID_CONVENIO, CUOTA, TOTAL_CUOTA, FECHA_PAGO) "
				strSql = strSql & " VALUES (" & intSeq & ", " & intNroCuota & "," & intMonto & ",'" & dtmFechaPago & "')"
			Else
				intMonto = Request("intCuota" & Trim(i))
				strSql = "INSERT INTO CONVENIO_DET (ID_CONVENIO, CUOTA, TOTAL_CUOTA, FECHA_PAGO) "
				strSql = strSql & " VALUES (" & intSeq & ", " & intNroCuota & "," & intMonto & ",'" & dtmFechaPago & "')"
			End If
			'Response.write "<br>" & strSql
			'Response.End
			set rsInsertaDet=Conn.execute(strSql)
		Next


		strSql = "INSERT INTO CONVENIO_CUOTA (ID_CONVENIO, IDCUOTA, RUTDEUDOR,CODCLIENTE,NRODOC,NROCUOTA, SALDO) SELECT " & intSeq & ",  IDCUOTA, RUTDEUDOR,CODCLIENTE,NRODOC,NROCUOTA, SALDO FROM CUOTA "
		strSql = strSql & " WHERE RUTDEUDOR = '" & strRutDeudor & "' AND CODCLIENTE = '" & strCodCliente &  "'"
		strSql = strSql & " AND IDCUOTA IN (" & strArrIdCuota  & ")"
		'Response.write strSql
		'Response.end

		set rsInsertaConvCuota=Conn.execute(strSql)

		strSql = "UPDATE CUOTA SET ESTADO_DEUDA = 10, TIPOCOB = 'EN CONVENIO', SALDO = 0, FECHA_ESTADO = getdate(), ID_CONVENIO = " & intSeq
		strSql = strSql & " WHERE RUTDEUDOR = '" & strRutDeudor & "' AND CODCLIENTE = '" & strCodCliente &  "'"
		strSql = strSql & " AND IDCUOTA IN (" & strArrIdCuota  & ")"

		set rsInsertaConvCuota=Conn.execute(strSql)


		'Response.End

		%>
			<script>alert("Convenio grabado correctamente.")</script>
		<%
		Response.Write ("<script language = ""Javascript"">" & vbCrlf)
		Response.Write (vbTab & "location.href='simulacion_convenio.asp?rut=" & rut & "&tipo=1'" & vbCrlf)
		Response.Write ("</script>")
		%>
	</td>
   </tr>
  </table>

</form>
