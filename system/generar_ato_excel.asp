<% @LCID = 1034 %>
<!--#include file="arch_utils.asp"-->
<!--#include file="../lib/comunes/rutinas/funciones.inc" -->
<!--#include file="../lib/comunes/rutinas/rutinasFecha.inc" -->
<!--#include file="lib.asp"-->
<!--#include file="asp/comunes/general/RutinasVarias.inc" -->

<script language="JavaScript">
function ventanaSecundaria (URL){
	window.open(URL,"DETALLE","width=200, height=200, scrollbars=no, menubar=no, location=no, resizable=no")
}

</script>

<%
inicio= request("inicio")
termino= request("termino")
intCliente = request("intCliente")
intTipoDeudor = request("intTipoDeudor")

strCabInicio=Mid(inicio,7,4) & Mid(inicio,4,2) & Mid(inicio,1,2)
strCabNroRegistros="0000000"
strCabTotalSaldo="00000000000000000"
strCabFiller="                          "


strDetFolio="0000000000"
strDetTipoDoc="00"
strDetMontoPagado="00000000"
strDetFechaPago="aaaammdd"
strDetNroCheque="0000000"
strDetBanco="000"
strDetPlaza="0000"
strDetTipoPago="0"
strCRP="000"
strCajero="0000"
strLote="00"
strSecuencia="000"
strCanalPago="00"
strTipoCliente="0"

%>
<title>ATO</title>

		<%
		strLinea=""
		If Trim(intCliente) <> "" then
		abrirscg()

		strSql = "SELECT ID_PAGO, RUTDEUDOR , MONTO_CAPITAL, INTERES_PLAZO, GASTOSJUDICIALES, INDEM_COMP, MONTO_EMP, CONVERT(VARCHAR(10),FECHA_PAGO,103) as FECHA_PAGO FROM CAJA_WEB_EMP WHERE COD_CLIENTE = '" & intCliente & "'"
		strSql = strSql & " AND FECHA_PAGO >= '" & inicio & " 00:00" & "' AND FECHA_PAGO <= '" & termino & " 23:59" & "'"

		strSql = "SELECT ID_PAGO, RUTDEUDOR , CONVERT(VARCHAR(10),FECHA_PAGO,103) as FECHA_PAGO , 'NO' as TIPOP FROM CAJA_WEB_EMP WHERE COD_CLIENTE = '" & intCliente & "'"
		strSql = strSql & " AND FECHA_PAGO >= '" & inicio & " 00:00" & "' AND FECHA_PAGO <= '" & termino & " 23:59" & "'"
		strSql = strSql & " AND TIPO_PAGO IN ('PTE','PTC')  AND ID_PAGO IN (SELECT DISTINCT E.ID_PAGO FROM CAJA_WEB_EMP E, CAJA_WEB_EMP_DETALLE D "
		strSql = strSql & " WHERE E.ID_PAGO = D.ID_PAGO AND E.COD_CLIENTE = '" & intCliente & "' AND E.FECHA_PAGO >= '" & inicio & " 00:00'"
		strSql = strSql & " AND E.FECHA_PAGO  <= '" & termino & " 23:59'"

		If Trim(intTipoDeudor) = "I" Then
			strSql = strSql & " AND LEN(D.CUENTA) >=10 )"
		End If
		If Trim(intTipoDeudor) = "D" Then
			strSql = strSql & " AND LEN(D.CUENTA) < 10 )"
		End If

		'strSql = strSql & " UNION "
		'strSql = strSql & " SELECT 1, RUTDEUDOR , CONVERT(VARCHAR(10),FECHA_PAGO,103) as FECHA_PAGO , 'CO' as TIPOP "
		'strSql = strSql & " FROM CAJA_WEB_EMP "
		'strSql = strSql & " WHERE COD_CLIENTE = '" & intCliente & "'"
		'strSql = strSql & " AND FECHA_PAGO >= '" & inicio & " 00:00" & "' AND FECHA_PAGO <= '" & termino & " 23:59" & "'"
		'strSql = strSql & " AND RUTDEUDOR IN (SELECT DISTINCT RUTDEUDOR FROM CUOTA "
		'strSql = strSql & " WHERE CODCLIENTE = '" & intCliente & "' AND ESTADO_DEUDA = 10 "
		'strSql = strSql & " AND FECHA_ESTADO >= '" & inicio & " 00:00'"
		'strSql = strSql & " AND FECHA_ESTADO  <= '" & termino & " 23:59'"


		If Trim(intTipoDeudor) = "I" Then
		'	strSql = strSql & " AND LEN(CUENTA) >=10 )"
		End If
		If Trim(intTipoDeudor) = "D" Then
		'	strSql = strSql & " AND LEN(CUENTA) < 10 )"
		End If

		'strSql = strSql & "GROUP BY RUTDEUDOR, CONVERT(VARCHAR(10),FECHA_PAGO,103)"
		'Response.write "strSql=" & strSql
		''Response.End

		set rsCaja=Conn.execute(strSql)
		If Not rsCaja.eof Then
			intNroDoc = 0
			intSumaCapital = 0


			If Trim(intTipoDeudor) = "I" Then

				Do While not rsCaja.Eof

					strRut = rsCaja("RUTDEUDOR")
					strFechaPago=rsCaja("FECHA_PAGO")
					strFechaPago=Mid(strFechaPago,7,4) & Mid(strFechaPago,4,2) & Mid(strFechaPago,1,2)

					strMostrarRut = strRut

					If Trim(rsCaja("TIPOP")) = "NO" Then
						strSql = "SELECT * FROM CAJA_WEB_EMP_DETALLE WHERE ID_PAGO = " & rsCaja("ID_PAGO") & " AND LEN(CUENTA) >= 10"
					Else
						strSql = "SELECT NRODOC, (VALORCUOTA - SALDO) AS CAPITAL FROM CUOTA "
						strSql = strSql & " WHERE RUTDEUDOR = '" & strRut & "' AND CODCLIENTE = '" & intCliente & "' AND ESTADO_DEUDA = 10 "
						strSql = strSql & " AND FECHA_ESTADO >= '" & inicio & " 00:00'"
						strSql = strSql & " AND FECHA_ESTADO  <= '" & termino & " 23:59' AND LEN(CUENTA) >= 10"
					End if

					'Response.write "<br>KKKKK=" & strSql
					set rsDetCaja=Conn.execute(strSql)
					If Not rsDetCaja.eof Then

						Do While not rsDetCaja.Eof

							strNroDoc = rsDetCaja("NRODOC")
							intCapital = rsDetCaja("CAPITAL")
							intSumaCapital = intSumaCapital + intCapital
							strSql="SELECT CUENTA,FECHAVENC, TIPODOCUMENTO FROM CUOTA WHERE RUTDEUDOR = '" & strRut & "' AND CODCLIENTE = '" & intCliente & "' AND NRODOC = '" & strNroDoc & "'"
							set RsCuota=Conn.execute(strSql)
							If not RsCuota.eof then
								strCuenta = RsCuota("CUENTA")
								strFechaVenc = RsCuota("FECHAVENC")
								strTipoDocumento = RsCuota("TIPODOCUMENTO")
								If Trim(strTipoDocumento)="FAC3" Then strTipoDocumento="34"
								If Trim(strTipoDocumento)="BOL2" Then strTipoDocumento="41"
							End if
							RsCuota.close
							set RsCuota=nothing

							strDetFolio="0000000000"&strNroDoc
							strDetFolio=Right(strDetFolio,10)

							strDetTipoDoc=strTipoDocumento

							strDetMontoPagado="00000000"&intCapital
							strDetMontoPagado=Right(strDetMontoPagado,8)

							strDetFechaPago=strFechaPago

							strDetNroCheque="0000000"
							strDetBanco="000"
							strDetPlaza="0000"
							strDetTipoPago="0"
							strCRP="000"
							strCajero="0000"
							strLote="00"
							strSecuencia="000"
							strCanalPago="00"
							strTipoCliente="2"

							strLinea=strLinea & strDetFolio & ";" & strDetTipoDoc & ";" & strDetMontoPagado & ";" & Mid(strDetFechaPago,7,2) & "/" & Mid(strDetFechaPago,5,2) & "/" & Mid(strDetFechaPago,1,4) & "<br>"

						strNombreDeudor=""
						strMostrarRut=""
						rsDetCaja.movenext
						intNroDoc = intNroDoc + 1
						Loop
					End If
				rsCaja.movenext
				Loop

			End if


			If Trim(intTipoDeudor) = "D" Then

				Do While not rsCaja.Eof

					strRut = rsCaja("RUTDEUDOR")
					strFechaPago=rsCaja("FECHA_PAGO")
					strFechaPago=Mid(strFechaPago,7,4) & Mid(strFechaPago,4,2) & Mid(strFechaPago,1,2)

					strMostrarRut = strRut
					If Trim(rsCaja("TIPOP")) = "NO" Then
						strSql = "SELECT SUM(CAPITAL) AS SUMCAPITAL, MAX(FECHAVENC) as MAXFV, CUENTA FROM CAJA_WEB_EMP_DETALLE WHERE LEN(CUENTA) < 10 AND ID_PAGO = " & rsCaja("ID_PAGO") & " GROUP BY CUENTA"
					Else
						strSql = "SELECT SUM(VALORCUOTA) AS SUMCAPITAL, MAX(FECHAVENC) as MAXFV, CUENTA FROM CUOTA "
						strSql = strSql & " WHERE RUTDEUDOR = '" & strRut & "' AND CODCLIENTE = '" & intCliente & "' AND ESTADO_DEUDA = 10 "
						strSql = strSql & " AND FECHA_ESTADO >= '" & inicio & " 00:00'"
						strSql = strSql & " AND FECHA_ESTADO  <= '" & termino & " 23:59' AND LEN(CUENTA) < 10 GROUP BY CUENTA"
					End if
					''Response.write "<br>KKKKK2=" & strSql
					set rsDetCaja=Conn.execute(strSql)
					If Not rsDetCaja.eof Then

						Do While not rsDetCaja.Eof

							'strNroDoc = rsDetCaja("NRODOC")
							intCapital = rsDetCaja("SUMCAPITAL")
							intSumaCapital = intSumaCapital + intCapital
							strFechaVenc = rsDetCaja("MAXFV")
							strCuenta = rsDetCaja("CUENTA")

							strSql="SELECT NRODOC, CUENTA, FECHAVENC, TIPODOCUMENTO FROM CUOTA WHERE RUTDEUDOR = '" & strRut & "' AND CODCLIENTE = '" & intCliente & "' AND FECHAVENC = '" & strFechaVenc & "' AND CUENTA = '" & strCuenta & "'"
							''Response.write "<br>"&strSql
							set RsCuota=Conn.execute(strSql)
							If not RsCuota.eof then
								strNroDoc = RsCuota("NRODOC")
								strTipoDocumento = RsCuota("TIPODOCUMENTO")
								If Trim(strTipoDocumento)="FAC3" Then strTipoDocumento="34"
								If Trim(strTipoDocumento)="BOL2" Then strTipoDocumento="41"
							End if
							RsCuota.close
							set RsCuota=nothing

							strDetFolio="0000000000"&strNroDoc
							strDetFolio=Right(strDetFolio,10)

							strDetTipoDoc=strTipoDocumento

							strDetMontoPagado="00000000"&intCapital
							strDetMontoPagado=Right(strDetMontoPagado,8)

							strDetFechaPago=strFechaPago

							strDetNroCheque="0000000"
							strDetBanco="000"
							strDetPlaza="0000"
							strDetTipoPago="0"
							strCRP="000"
							strCajero="0000"
							strLote="00"
							strSecuencia="000"
							strCanalPago="00"
							strTipoCliente="1"

							strLinea=strLinea & strDetFolio & ";" & strDetTipoDoc & ";" & strDetMontoPagado & ";" & Mid(strDetFechaPago,7,2) & "/" & Mid(strDetFechaPago,5,2) & "/" & Mid(strDetFechaPago,1,4) & "<br>"

						strNombreDeudor=""
						strMostrarRut=""
						rsDetCaja.movenext
						intNroDoc = intNroDoc + 1
						Loop
					End If
				rsCaja.movenext
				Loop

			End if





		End If
		rsCaja.close
		set rsCaja=nothing
		''Response.End
		cerrarscg()
		end if


		strCabInicio=Mid(inicio,7,4) & Mid(inicio,4,2) & Mid(inicio,1,2)
		strCabNroRegistros="0000000"


		strCabNroRegistros="0000000"&intNroDoc
		strCabNroRegistros=Right(strCabNroRegistros,7)


		strCabTotalSaldo="00000000000000000"&intSumaCapital
		strCabTotalSaldo=Right(strCabTotalSaldo,17)


		strCabFiller="                          "

		strCabecera=strCabInicio&strCabNroRegistros&strCabTotalSaldo&strCabFiller

		Response.write "<BR>" & strLinea

		%>
