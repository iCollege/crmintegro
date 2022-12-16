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

strDetFolio="0000000000"
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

		''Response.write "<br>-" & Space(3) & "-"


		strSql = "SELECT TIPO_PAGO,ID_PAGO, RUTDEUDOR , USR_COB.FUN_TRAE_MONTO_ATO_VNE (ID_PAGO) AS MONTO_CAPITAL, INTERES_PLAZO, GASTOSJUDICIALES, INDEM_COMP, "
		strSql = strSql & " MONTO_EMP, CONVERT(VARCHAR(10),FECHA_PAGO,103) as FECHA_PAGO FROM CAJA_WEB_EMP WHERE COD_CLIENTE = '" & intCliente & "'"
		strSql = strSql & " AND FECHA_PAGO >= '" & inicio & " 00:00" & "' AND FECHA_PAGO <= '" & termino & " 23:59" & "' AND TIPO_PAGO NOT IN ('PH') "
		''strSql = strSql & " AND ID_PAGO NOT IN (SELECT DISTINCT ID_PAGO FROM CAJA_WEB_EMP_DOC_PAGO WHERE FORMA_PAGO IN ('CF','AB','CU'))"
		strSql = strSql & " AND ID_PAGO IN (SELECT DISTINCT ID_PAGO FROM CAJA_WEB_EMP_DOC_PAGO WHERE FORMA_PAGO IN ('EF','DP') AND TIPO_PAGO = 0)"

		'strSql = strSql & " AND ID_PAGO IN (SELECT DISTINCT E.ID_PAGO FROM CAJA_WEB_EMP E, CAJA_WEB_EMP_DETALLE D "
		'strSql = strSql & " WHERE E.ID_PAGO = D.ID_PAGO AND E.COD_CLIENTE = '" & intCliente & "' AND E.FECHA_PAGO >= '" & inicio & " 00:00'"
		'strSql = strSql & " AND E.FECHA_PAGO  <= '" & termino & " 23:59'"

		'If Trim(intTipoDeudor) = "I" Then
		'	strSql = strSql & " AND LEN(D.CUENTA) >=10 )"
		'End If
		'If Trim(intTipoDeudor) = "D" Then
		'	strSql = strSql & " AND LEN(D.CUENTA) < 10 )"
		'End If

		'Response.write "strSql=" & strSql

		set rsCaja=Conn.execute(strSql)
		If Not rsCaja.eof Then
			strCabNroRegistros = 0
			strCabTotalSaldo = 0
				intCapital=0

				Do While not rsCaja.Eof

					strRut = rsCaja("RUTDEUDOR")
					strFechaPago=rsCaja("FECHA_PAGO")
					strFechaPago=Mid(strFechaPago,7,4) & Mid(strFechaPago,4,2) & Mid(strFechaPago,1,2)
					intCapital=rsCaja("MONTO_CAPITAL")

					'***********************
					'* cambio
					'***********************

					intGastos=0

					intGastos=rsCaja("GASTOSJUDICIALES")

					if intGastos = 0 Then
						strSql = "SELECT ISNULL(GASTOS,0) AS GASTOS FROM CONVENIO_ENC WHERE COD_CLIENTE = '" & intCliente & "'"
						strSql = strSql & " AND FECHAINGRESO >= '" & inicio & " 00:00" & "' AND FECHAINGRESO <= '" & termino & " 23:59" & "'"
						strSql = strSql & " AND RUTDEUDOR = '" & strRut & "'"

						set rsGastos=Conn.execute(strSql)
						If Not rsGastos.eof Then
							intGastos = rsGastos("GASTOS")
						Else
							intGastos = 0
						End If
					End if

					If Trim(rsCaja("TIPO_PAGO")) <> "CO" Then
						intCapital=intCapital - intGastos
					End If

					'***********************
					'* cambio
					'***********************


					strSql = "SELECT MIN(NRODOC) AS NRODOC, CUENTA FROM CUOTA WHERE CODCLIENTE = '" & intCliente & "'"
					strSql = strSql & " AND RUTDEUDOR = '" & strRut & "' AND ESTADO_DEUDA <> 1 GROUP BY CUENTA"

					'Response.write "<br>" & strSql & "<br>"
					''Response.End
					set rsDetCaja=Conn.execute(strSql)
					If Not rsDetCaja.eof Then

						Do While not rsDetCaja.Eof

							strNroDoc = rsDetCaja("NRODOC")
							strCabTotalSaldo = strCabTotalSaldo + intCapital
							''strSql="SELECT CUENTA,FECHAVENC, TIPODOCUMENTO FROM CUOTA WHERE RUTDEUDOR = '" & strRut & "' AND CODCLIENTE = '" & intCliente & "' AND NRODOC = '" & strNroDoc & "'"


							strSql = "SELECT TOP 1 NRODOC_SAP,INTERLOCUTOR_COMERCIAL,OFICINA_COBRO,CUENTA,FECHAVENC, TIPODOCUMENTO, C.NRODOC, D.VALOR AS VALORD FROM CUOTA C, DETCUOTA_VNE D "
							strSql = strSql & " WHERE C.IDCUOTA = D.IDCUOTA AND "
							strSql = strSql & " C.RUTDEUDOR = '" & strRut & "' AND C.CODCLIENTE = '" & intCliente & "' AND C.NRODOC = '" & Cdbl(strNroDoc) & "' ORDER BY NRODOC_SAP"

							'Response.write "<br>strSql111=" & strSql
							'Response.End
							set RsCuota=Conn.execute(strSql)
							If not RsCuota.eof then
								Do While Not RsCuota.eof
									strNroDocSap = RsCuota("NRODOC_SAP")
									strInterComercial = RsCuota("INTERLOCUTOR_COMERCIAL")
									strCuentaContrato = RsCuota("CUENTA")
									strFechaVenc = RsCuota("FECHAVENC")

									strNroDocSap="000000000000"&strNroDocSap
									strNroDocSap=Right(strNroDocSap,12)

									strInterComercial="000000000000"&strInterComercial
									strInterComercial=Right(strInterComercial,10)

									strCuentaContrato="000000000000"&strCuentaContrato
									strCuentaContrato=Right(strCuentaContrato,12)

									strDetMontoPagado="0000000000000000"&intCapital

									'Esto de abajo se comentarizo por el cambio solicitado por VNE de asociar a cualquier nro de documento el total de la deuda pagado por cuenta contrato
									''strDetMontoPagado="0000000000000000"&ValNulo(RsCuota("VALORD"),"N")


									strDetMontoPagado=Right(strDetMontoPagado,16)

									strDetFechaPago=strFechaPago

									strTipoRegistro="2"
									strTipoTransaccion="1"
									strPosicion=space(3)
									strPosicion="XXX"
									strClave="CLP  "
									strClave="CLPXX"
									strDetTipoPago="0"

									intNINKB="0000000000000000"
									intBETRI="0000000000000000"
									intBETRC="0000000000000000"
									intNRZAS="000000000000"
									intTXTVW="XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
									intCHCKN="XXXXXXXXXXXXX"
									intKOINHS="XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
									intBANKS="XXX"
									intBANKL="XXXXXXXXXXXXXXX"
									intBANKN="XXXXXXXXXXXXXXXXXX"
									intCCNUM="XXXXXXXXXXXXXXXXXXXXXXXXX"
									intKOINHC="XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
									intCCINS="XXXX"
									intDATAB="XXXXXXXX"
									intDATBI="XXXXXXXX"





									strLinea=strLinea&strTipoRegistro&strInterComercial&strCuentaContrato&strTipoTransaccion&strNroDocSap&strPosicion&strDetFechaPago&strClave&strDetMontoPagado&intNINKB&intBETRI&intBETRC&intNRZAS&intTXTVW&intCHCKN&intKOINHS&intBANKS&intBANKL&intBANKN&intCCNUM&intKOINHC&intCCINS&intDATAB&intDATBI&"<BR>"
									strCabNroRegistros = strCabNroRegistros + 1

								RsCuota.movenext
								Loop
							End if
							RsCuota.close
							set RsCuota=nothing
						rsDetCaja.movenext
						Loop
					End If
				rsCaja.movenext
				Loop

		strTipoRegFich  = "2"
		strNroInterlCom =  "" '10
		strNroCtaContrato = "" '12
		strTipoTran = "1"


		strNroDocSap = "" ''12
		strPosCobro = "   "
		strPosCobro = "XXX"
		strFechaValor = "" 'AAAAMMDD
		strClaveMoneda = "CLP  "

		strImportePago="0000000000000000"&strImportePago
		strImportePago=Right(strImportePago,16)
		strImportePago = "" '16


		End If
		rsCaja.close
		set rsCaja=nothing
		''Response.End
		cerrarscg()
		end if

		strCabTipoRegistro="1"
		strCabOficinaCobro="0011302042"
		strCabFechaHoy=Mid(now,7,4) & Mid(now,4,2) & Mid(now,1,2)
		strCabFechaHoy=Mid(termino,7,4) & Mid(termino,4,2) & Mid(termino,1,2)
		strCabCuentaComp="1101133071"
		strCabMoneda="CLP  "
		strCabMoneda="CLPXX"

		strTipoRegPie="9"

		strCabNroRegistros="000000"&strCabNroRegistros
		strNroReg=Right(strCabNroRegistros,6)

		strCabTotalSaldo="0000000000000000"&strCabTotalSaldo
		strTotalPagos=Right(strCabTotalSaldo,16)
		''strPie="90000320000000000107469"

		''Response.write "strNroReg-" &strTotalPagos& "-strNroReg"

		strPie=strTipoRegPie&strNroReg&strTotalPagos

		strBVRCH = "XXXXXXXXXX"
		strCCCKO = "XXXXXXXXXX"

		strCabecera = strCabTipoRegistro&strCabOficinaCobro&strCabFechaHoy&strCabCuentaComp&strBVRCH&strCCCKO&strCabMoneda

		Response.write strCabecera & "<BR>" & strLinea & strPie
		'Response.write strCabecera & "<BR>" & strLinea & "<BR>" & strPie

		%>
