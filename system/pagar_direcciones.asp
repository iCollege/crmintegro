<% @LCID = 1034 %>
<!--#include file="arch_utils.asp"-->
<!--#include file="../lib/comunes/rutinas/funciones.inc" -->
<!--#include file="../lib/comunes/rutinas/funcionesBD.inc" -->
<!--#include file="lib.asp"-->
<!--#include file="../lib/comunes/rutinas/TraeCampo.inc" -->
<!--#include file="asp/comunes/general/rutinasBooleano.inc" -->

<script language="JavaScript">
function ventanaSecundaria (URL){
window.open(URL,"DETALLE","width=200, height=200, scrollbars=no, menubar=no, location=no, resizable=no")
}
</script>

<title>Estatus Cartera</title>

<style type="text/css">
<!--
.Estilo37 {color: #FFFFFF}
-->
</style>
<form name="datos" method="post">
<INPUT TYPE="HIDDEN" NAME="intGestion" VALUE="<%=intGestion%>">
<INPUT TYPE="HIDDEN" NAME="intParaCarta" VALUE="<%=intParaCarta%>">



<table width="100%" border="1" bordercolor="#FFFFFF">
	<tr>
		<TD height="20" ALIGN=LEFT class="pasos1_i">
			<B><%=strTitulo%></B>
		</TD>
	</tr>
</table>


<table width="100%" border="1" bordercolor="#FFFFFF">
	<tr>
			<TD>

			<%IF strCliente <> "" and  Trim(intCodRemesa) <> "" and  Trim(strRefrescar) <> "R" then %>

				<table width="100%" border="1" bordercolor = "#<%=session("COLTABBG")%>" cellSpacing=0 cellPadding=1>

				      <tr>
				      	<td width="20">&nbsp</td>
				      	<td width="150">ESTADO</td>
				        <td width="70">RUT</td>
				        <td width="70">NOMBRE O RAZON SOCIAL</td>
				        <td width="70">DEUDA ORIGINAL</td>
				        <td width="70">MONTO 40 VECES</td>
				        <td width="70">DIRECCION</td>
				        <td width="70">COMUNA</td>
				        <td width="70">CIUDAD</td>

				        <% If intParaCarta = "1" Then %>
							<td width="70">F.COMPARENDO</td>
							<td width="70">F.NOTIFICACION</td>
							<td width="70">GASTOS JUDICIALES</td>
							<td width="70">ROL</td>
							<td width="70">TRIBUNAL</td>
				        <% End If %>
						<td width="70">RUT.REP.</td>
				        <td width="70">NOMBRE REP.</td>
				        <td width="70">MONTO PAGADO</td>
				        <td width="70">DOC.PAGADOS.</td>
				        <td width="70">LUGAR PAGO</td>
				        <td width="70">FORMA PAGO</td>
				       </tr>
			    <%
			    	strTotalCuantia = 0
					abrirscg()

					strCondicion = ""
					If Trim(intGJ) <> "111" Then
						strCondicion = " AND IDGJUDICIAL = " & intGJ
					End if

					strSql = "SELECT RUTDEUDOR, SUM(VALORCUOTA) as MONTO, SUM(VALORCUOTA - SALDO) AS PAGADO, COUNT(*) FROM CUOTA WHERE CODCLIENTE = '" & strCliente & "' AND ESTADO_DEUDA IN (3,4) AND CODREMESA = " & intCodRemesa
					strSql = strSql & strCondicion & " GROUP BY RUTDEUDOR"
					If trim(strProbCobro) <> "T" Then
						strSql = strSql & " AND RUTDEUDOR IN (SELECT RUTDEUDOR FROM CUOTA_ENC WHERE PROB_COBRO = '" & strProbCobro & "')"
					End if

					Response.write "strSql = " & strSql
					'Response.End
					set rsGTC= Conn.execute(strSql)
					if not rsGTC.eof then
						intConRegistros="S"
						intPagado = rsGTC("PAGADO")

						''Response.write "HOLA"
						intCorre = 0
						Do until rsGTC.eof

							strSql="SELECT NRODOC, GJ.NOMGESTION AS NOMBRE , C.VALORCUOTA AS SALDO, C.ESTADO_DEUDA as ESTADO_DEUDA FROM CUOTA C, GESTION_JUDICIAL GJ WHERE C.IDGJUDICIAL = GJ.IDGESTION AND C.RUTDEUDOR = '" & rsGTC("RUTDEUDOR") & "' AND CODCLIENTE = '" & strCliente & "' AND ESTADO_DEUDA IN (3,4) AND CODREMESA = " & intCodRemesa
							strSql=strSql & " AND datediff(day,fechavenc,getdate()) > " & intDias & " ORDER BY IDGJUDICIAL,FECHAVENC ASC"
							'Response.write "HOLA=" & strSql
							'Response.End
							set rsCuotaEnc=Conn.execute(strSql)
							strDocPagados = ""
							intSaldo = 0
							strNombre=""
							Do while not rsCuotaEnc.eof
								strNombre = Trim(rsCuotaEnc("NOMBRE"))
								strDocPagados = strDocPagados & ", " & rsCuotaEnc("NRODOC")
								intSaldo = intSaldo + rsCuotaEnc("SALDO")
								strLugarPago = Trim(rsCuotaEnc("ESTADO_DEUDA"))
								rsCuotaEnc.movenext
							Loop

							If Trim(strLugarPago) = "3" Then strLugarPago = "EMPRESA"
							If Trim(strLugarPago) = "4" Then strLugarPago = "MANDANTE"

							rsCuotaEnc.close
							set rsCuotaEnc=nothing
							intCorre = intCorre + 1

							strSql="SELECT TOP 1 NOMBREDEUDOR,RUTDEUDOR ,REPLEG_NOMBRE, REPLEG_RUT FROM DEUDOR WHERE RUTDEUDOR='" & rsGTC("RUTDEUDOR") &"' AND NOMBREDEUDOR IS NOT NULL AND LTRIM(RTRIM(NOMBREDEUDOR)) <> '' AND CODCLIENTE = '" & strCliente & "'"
							set RsDeudor=Conn.execute(strSql)
							If not RsDeudor.eof then
								strNombreDeudor = RsDeudor("NOMBREDEUDOR")
								strRepLegalNombre = RsDeudor("REPLEG_NOMBRE")
								strRepLegalRut = RsDeudor("REPLEG_RUT")
							End if

							If Trim(strRepLegalNombre) = "" or IsNull(strRepLegalNombre) Then strRepLegalNombre = "&nbsp;"
							If Trim(strRepLegalRut) = "" or IsNull(strRepLegalRut) Then strRepLegalRut = "&nbsp;"

							RsDeudor.close
							set RsDeudor=nothing

							strSql=""
							strSql="SELECT TOP 1 CALLE,NUMERO,COMUNA,RESTO,CIUDAD FROM DEUDOR_DIRECCION WHERE RUTDEUDOR='"& rsGTC("RUTDEUDOR") &"' and ESTADO <> '2' ORDER BY Correlativo DESC"
							set rsDIR=Conn.execute(strSql)
							if not rsDIR.eof then
								strDireccion = rsDIR("CALLE") & " " & rsDIR("NUMERO") & " " & rsDIR("RESTO")
								strComuna = rsDIR("COMUNA")
								strCiudad = rsDIR("CIUDAD")
							end if
							rsDIR.close
							set rsDIR=nothing

							strSql="SELECT MAX(IDDEMANDA) as IDDEMANDA FROM DEMANDA WHERE CODCLIENTE = '" & strCliente 	& "' AND RUTDEUDOR = '" & rsGTC("RUTDEUDOR")  & "'"
							set rsDemanda = Conn.execute(strSql)
							if not rsDemanda.eof then
								intIdDemanda = rsDemanda("IDDEMANDA")
							Else
								intIdDemanda = "0"
							End if
							rsDemanda.close
							set rsDemanda=nothing

							intGastosJud = "&nbsp;"
							intIdTribunal = "&nbsp;"
							strRolAno = "&nbsp;"
							strTribunal = "&nbsp;"
							strFechaComparendo = "&nbsp;"

							If intIdDemanda <> "0" Then
								intGastosJud = TraeCampoId(Conn, "GASTOS_JUDICIALES", intIdDemanda, "DEMANDA", "IDDEMANDA")
								intIdTribunal = TraeCampoId(Conn, "IDTRIBUNAL", intIdDemanda, "DEMANDA", "IDDEMANDA")
								strRolAno = TraeCampoId(Conn, "ROLANO", intIdDemanda, "DEMANDA", "IDDEMANDA")


								strTribunal = TraeCampoId(Conn, "NOMTRIBUNAL", intIdTribunal, "TRIBUNAL", "IDTRIBUNAL")
								strFechaComparendo = TraeCampoId(Conn, "FECHA_COMPARENDO", intIdDemanda, "DEMANDA", "IDDEMANDA")
							End if
							If strNombre <> "" Then
							%>
							<tr>
								<td ALIGN="LEFT"><%=intCorre%></td>
								<td ALIGN="LEFT"><%=strNombre%></td>
								<td ALIGN="LEFT"><%=rsGTC("RUTDEUDOR")%></td>
								<td ALIGN="LEFT"><%=strNombreDeudor%></td>
								<td ALIGN="LEFT"><%=intSaldo%></td>
								<td ALIGN="LEFT"><%=intSaldo * 40%></td>
								<td ALIGN="LEFT"><%=strDireccion%></td>
								<td ALIGN="LEFT"><%=strComuna%></td>
								<td ALIGN="LEFT"><%=strCiudad%></td>
								<% If intParaCarta = "1" Then %>
									<td ALIGN="LEFT"><%=strFechaComparendo%></td>
									<td ALIGN="LEFT">&nbsp</td>
									<td ALIGN="LEFT"><%=intGastosJud%></td>
									<td ALIGN="LEFT"><%=strRolAno%></td>
									<td ALIGN="LEFT"><%=strTribunal%></td>
								<% End If %>
								<td ALIGN="LEFT"><%=strRepLegalRut%></td>
								<td ALIGN="LEFT"><%=strRepLegalNombre%></td>
								<td ALIGN="LEFT"><%=Mid(strDocPagados,2,len(strDocPagados))%></td>
								<td ALIGN="LEFT"><%=intPagado%></td>
								<td ALIGN="LEFT"><%=strLugarPago%></td>
								<td ALIGN="LEFT"><%=strFormaPago%></td>
							</tr>
							<%
							End If

							rsGTC.movenext
						loop

					Else
						intConRegistros="N"
					End If
					rsGTC.close
					set rsGTC=nothing
					cerrarscg()
			 %>
			    </TABLE>

      <%  End if%>
			</TD>
	</tr>
</table>








<script language="JavaScript1.2">
function envia(intTipo)	{
	if (datos.CB_CLIENTE.value=='0'){
		alert('DEBE SELECCIONAR UN CLIENTE');
	}else{
		if (intTipo=='R'){
			datos.action='informe_seguimiento_pagos.asp?strRefrescar=R';
		}else{
			datos.action='informe_seguimiento_pagos.asp';
		}
		datos.submit();
	}
}

function excel(){
	if (datos.CB_CLIENTE.value=='0'){
		alert('DEBE SELECCIONAR UN CLIENTE');
	}else{
		datos.action='informe_seguimiento_pagos_xls.asp';
		datos.submit();
	}
}
function ventanaDetalle (URL){
window.open(URL,"DETALLEGESTION","width=800, height=300, scrollbars=yes, menubar=no, location=no, resizable=yes")
}

</script>
