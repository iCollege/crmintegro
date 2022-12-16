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

<%


strCliente=Request("CB_CLIENTE")
intCodRemesa=Request("CB_REMESA")
intGJ=Request("CB_GJUDICIAL")
strProbCobro=Request("CB_PROBABILIDAD")
intEjecutivo=Request("intEjecutivo")

intTipoInforme = Request("intTipoInforme")

' intTipoInforme = 1 : Para Cartas
' intTipoInforme = 2 : Pagados
' intTipoInforme = 3 : Retirados
' intTipoInforme = 4 : Demandas inverso

'Response.write "<br>intTipoInforme = " & intTipoInforme

'Response.End

If Trim(intTipoInforme) = "1" Then
	strTitulo = "CARTAS"
	intDias = -90
End If

If Trim(intTipoInforme) = "2" Then
	strTitulo = "PAGADOS"
End If

If Trim(intTipoInforme) = "3" Then
	strTitulo = "RETIROS"
End If

If Trim(intTipoInforme) = "" Then
	strTitulo = "DEMANDAS"
	intDias = -90
End If

If Trim(intDias) = "" Then intDias = -100



strRefrescar = Request("strRefrescar")

If Trim(strCliente) = "" Then strCliente = session("ses_codcli")
'If Trim(intCodRemesa)	 = "" Then intCodRemesa = 100
%>
<title>Estatus Cartera</title>

<style type="text/css">
<!--
.Estilo37 {color: #FFFFFF}
-->
</style>
<form name="datos" method="post">
<INPUT TYPE="HIDDEN" NAME="intGestion" VALUE="<%=intGestion%>">
<INPUT TYPE="HIDDEN" NAME="intTipoInforme" VALUE="<%=intTipoInforme%>">





<TABLE ALIGN="CENTER" BORDER=0 CELLSPACING=0 CELLPADDING=0 WIDTH="600" CLASS="tabla1">
<TR HEIGHT="30">
	<TD align="CENTER">
		INFORMES EXCEL
    </TD>
</TR>

<table ALIGN="CENTER" WIDTH="800" border="0" CLASS="tabla1">
<tr BGCOLOR="#FFFFFF">
	<td class="hdr_i" width="21">
		<img src='../images/boton_no_1.gif' align='absmiddle'>
	</td>
	<td class="hdr_i" width="200">
		Vespucio Sur
	</td>
	<td class="hdr" width="21">
		<img src='../images/cuadrado_t1.gif' align='absmiddle'>
	</td>
	<td class="hdr_i" width="300">
		<A HREF="../Informes/CartasVS.xls">
			Imprimir Cartas
		</A>
	</td>

	<td class="hdr" width="21">
			<img src='../images/cuadrado_t1.gif' align='absmiddle'>
		</td>
		<td class="hdr_i" width="300">
			<A HREF="../Informes/PagosVS.xls">
			Pagos
			</A>
		</td>
</tr>



<table ALIGN="CENTER" WIDTH="800" border="0" CLASS="tabla1">
<tr BGCOLOR="#FFFFFF">
	<td class="hdr_i" width="21">
		<img src='../images/boton_no_2.gif' align='absmiddle'>
	</td>
	<td class="hdr_i" width="200">
		Vespucio Norte
	</td>
	<td class="hdr" width="21">
		<img src='../images/cuadrado_t1.gif' align='absmiddle'>
	</td>
	<td class="hdr_i" width="300">
		<A HREF="../Informes/CartasVNE.xls">
			Imprimir Cartas
		</A>
	</td>
	<td class="hdr" width="21">
			<img src='../images/cuadrado_t1.gif' align='absmiddle'>
	</td>
	<td class="hdr_i" width="300">
		<A HREF="../Informes/PagosVNE.xls">
			Pagos
		</A>
	</td>
</tr>

</Table>

<table width="100%" border="1" bordercolor="#FFFFFF">
	<tr>
		<TD height="20" ALIGN=LEFT class="pasos1_i">
			<B>INFORME PARA IMPRIMIR <%=strTitulo%></B>
		</TD>
	</tr>
</table>


<table width="100%" border="1" bordercolor="#FFFFFF">
	<tr>
		<TD>

		<TABLE width="100%" ALIGN="LEFT" BORDER=0 CELLSPACING=0 CELLPADDING=0>
			<TR>
				<td>
					Cliente
				</td>
				<td>
					<select name="CB_CLIENTE" OnChange="envia('R')">
						<!--option value="100">TODOS</option-->
						<%
						abrirscg()
						ssql="SELECT CODCLIENTE,RAZON_SOCIAL FROM CLIENTE ORDER BY RAZON_SOCIAL"
						set rsTemp= Conn.execute(ssql)
						if not rsTemp.eof then
							do until rsTemp.eof%>
							<option value="<%=rsTemp("CODCLIENTE")%>"<%if Trim(strCliente)=rsTemp("CODCLIENTE") then response.Write("Selected") End If%>><%=rsTemp("RAZON_SOCIAL")%></option>
							<%
							rsTemp.movenext
							loop
						end if
						rsTemp.close
						set rsTemp=nothing
						cerrarscg()
						%>
					</select>
				</td>

				<td>
					Asignacion
				</td>
				<td>
					<select name="CB_REMESA">
						<option value="0">TODOS</option>
						<%
						abrirscg()
						ssql="SELECT CONVERT(VARCHAR(10),FECHA_LLEGADA,103) as FECHAREMESA , CODREMESA FROM REMESA WHERE CODCLIENTE = '" & strCliente & "' AND CODREMESA >= 100"
						set rsTemp= Conn.execute(ssql)
						if not rsTemp.eof then
							do until rsTemp.eof%>
							<option value="<%=rsTemp("CODREMESA")%>" <%if Trim(intCodRemesa) = Trim(rsTemp("CODREMESA")) then response.Write("SELECTED") End If%>><%=rsTemp("CODREMESA") & "-" & rsTemp("FECHAREMESA")%></option>
							<%
							rsTemp.movenext
							loop
						end if
						rsTemp.close
						set rsTemp=nothing
						cerrarscg()
						%>
					</select>
				</td>
				<td>
					Gestion Judicial
				</td>
				<td>
					<select name="CB_GJUDICIAL">
						<option value="111">TODOS PARA DEMANDA</option>
						<%
						abrirscg()
						ssql="SELECT * FROM GESTION_JUDICIAL"
						set rsTemp= Conn.execute(ssql)
						if not rsTemp.eof then
							do until rsTemp.eof%>
							<option value="<%=rsTemp("IDGESTION")%>" <%if Trim(intGJ) = Trim(rsTemp("IDGESTION")) then response.Write("SELECTED") End If%>><%=rsTemp("NOMGESTION")%></option>
							<%
							rsTemp.movenext
							loop
						end if
						rsTemp.close
						set rsTemp=nothing
						cerrarscg()
						%>
					</select>
				</td>
				<td>
					<select name="CB_PROBABILIDAD">
						<option value="T">TODO</option>
						<%
						abrirscg()
						ssql="SELECT * FROM PROBABILIDAD_COBRO"
						set rsTemp= Conn.execute(ssql)
						if not rsTemp.eof then
							do until rsTemp.eof%>
							<option value="<%=rsTemp("DESCRIPCION")%>" <%if Trim(strProbCobro) = Trim(rsTemp("DESCRIPCION")) then response.Write("SELECTED") End If%>><%=rsTemp("DESCRIPCION")%></option>
							<%
							rsTemp.movenext
							loop
						end if
						rsTemp.close
						set rsTemp=nothing
						cerrarscg()
						%>
					</select>
				</td>
				<td>
					<a href="#" onClick="envia('E');">Filtrar</a></td>
				</td>
			</TR>
			</TABLE>
		</TD>
	</tr>
	<tr>
			<TD>

			<%IF strCliente <> "" and  Trim(intCodRemesa) <> "" and  Trim(strRefrescar) <> "R" then %>

				<table width="100%" border="1" bordercolor = "#<%=session("COLTABBG")%>" cellSpacing=0 cellPadding=1>

				      <tr>
				      	<td width="20">&nbsp</td>
				      	<td width="150">ESTADO</td>
				        <td width="70">RUT</td>
				        <td width="70">NOMBRE O RAZON SOCIAL</td>
				        <td width="70">MONTO DEUDA</td>
				        <td width="70">MONTO 40 VECES</td>
				        <td width="70">DIRECCION</td>
				        <td width="70">COMUNA</td>
				        <td width="70">CIUDAD</td>
				        <td width="70">PROB.COBRO</td>

				        <% If intTipoInforme = "" or intTipoInforme = "1" or intTipoInforme = "2" or intTipoInforme = "3" Then %>
				        	<td width="70">ULT.F.PAGO</td>
				        	<td width="70">F.INGRESO</td>
							<td width="70">F.COMPARENDO</td>
							<td width="70">F.NOTIFICACION</td>
							<td width="70">GASTOS JUDICIALES</td>
							<td width="70">ROL</td>
							<td width="70">TRIBUNAL</td>
							<td width="70">MONTO</td>
				        <% End If %>

				        <td width="960">DOCUMENTOS</td>
				        <td width="70">RUT.REP.</td>
				        <td width="70">NOMBRE REP.</td>
				        <td width="70">EJECUTIVO</td>
				        <td width="70">ASIG</td>
				        <td width="70">EMAIL</td>
				        <td width="70">ANTIG.</td>
				      </tr>
			    <%
			    	strTotalCuantia = 0
					abrirscg()

					strCondicion = ""
					If Trim(intGJ) <> "111" Then
						strCondicion = " AND IDGJUDICIAL = " & intGJ
					Else
						If intTipoInforme <> "2" then
							strCondicion = " AND IDGJUDICIAL NOT IN (12,13)"
						End if
						If intTipoInforme = "1" or intTipoInforme = "" then
							strCondicion = " AND IDGJUDICIAL NOT IN (12,14)"
						End if
					End if

					strSql = "SELECT RUTDEUDOR, SUM(SALDO) as MONTO, COUNT(*), MAX(ISNULL(DATEDIFF(D,FECHAVENC,GETDATE()),0)) as DIASANT FROM CUOTA WHERE CODCLIENTE = '" & strCliente & "'"

					If intTipoInforme = "1" or intTipoInforme = "" then
						strSql = strSql & " AND SALDO > 0 AND ESTADO_DEUDA = 1 "
					End If

					If intTipoInforme = "2" then
						strSql = strSql & " AND ESTADO_DEUDA IN (3,4) "
					End If

					If intTipoInforme = "3" then
						strSql = strSql & " AND ESTADO_DEUDA = 2 "
					End If

					If Trim(intCodRemesa) <> "0" Then
						strSql = strSql & " AND CODREMESA = " & intCodRemesa
					End If

					strSql = strSql & strCondicion & " AND DATEDIFF(DAY,FECHAVENC,GETDATE()) > " & intDias & " GROUP BY RUTDEUDOR "


					If Trim(intTipoInforme) = "1" or Trim(intTipoInforme) = "" Then
						strSql = strSql & " HAVING SUM(SALDO) >= 75000 "
					End If

					If Trim(intTipoInforme) = "4" Then
						strSql = strSql & " HAVING SUM(SALDO) < 100000 "
					End If

					If trim(strProbCobro) <> "T" Then
						strSql = strSql & " AND RUTDEUDOR IN (SELECT RUTDEUDOR FROM CUOTA_ENC WHERE PROB_COBRO = '" & strProbCobro & "')"
					End if

					'Response.write "strSql = " & strSql
					'Response.End
					set rsGTC= Conn.execute(strSql)
					if not rsGTC.eof then
						intConRegistros="S"

			'Response.write strSql
			'response.end

						''Response.write "HOLA"
						intCorre = 0
						Do until rsGTC.eof

							strSql="SELECT NRODOC, GJ.NOMGESTION AS NOMBRE , C.SALDO, C.VALORCUOTA FROM CUOTA C, GESTION_JUDICIAL GJ WHERE C.IDGJUDICIAL = GJ.IDGESTION AND C.RUTDEUDOR = '" & rsGTC("RUTDEUDOR") & "' AND CODCLIENTE = '" & strCliente & "'"

							If intTipoInforme = "1" or intTipoInforme = "" then
								strSql = strSql & " AND SALDO > 0 AND ESTADO_DEUDA = 1 "
							End If

							If intTipoInforme = "2" then
								strSql = strSql & " AND ESTADO_DEUDA IN (3,4) "
							End If

							If intTipoInforme = "3" then
								strSql = strSql & " AND ESTADO_DEUDA = 2 "
							End If

							If Trim(intCodRemesa) <> "0" Then
								strSql = strSql & " AND CODREMESA = " & intCodRemesa
							End If

							strSql=strSql & " AND datediff(day,fechavenc,getdate()) > " & intDias & " ORDER BY IDGJUDICIAL,FECHAVENC ASC"
							'Response.write "HOLA=" & strSql
							'Response.End
							set rsCuotaEnc=Conn.execute(strSql)
							strProbabilidad = ""
							intSaldo = 0
							strNombre=""

			'Response.write strSql

							Do while not rsCuotaEnc.eof
								strNombre = Trim(rsCuotaEnc("NOMBRE"))
								strProbabilidad = strProbabilidad & ", " & rsCuotaEnc("NRODOC")
								''intSaldo = intSaldo + rsCuotaEnc("SALDO")

								If intTipoInforme = "1" or intTipoInforme = "" Then
									intSaldo = intSaldo + rsCuotaEnc("SALDO")
								Else
									intSaldo = intSaldo + (rsCuotaEnc("VALORCUOTA") - rsCuotaEnc("SALDO"))
								End if
								rsCuotaEnc.movenext

							Loop
							rsCuotaEnc.close
							set rsCuotaEnc=nothing
							intCorre = intCorre + 1

							strSql="SELECT PROB_COBRO FROM CUOTA_ENC WHERE RUTDEUDOR='" & rsGTC("RUTDEUDOR") &"' AND CODCLIENTE = '" & strCliente & "'"
							set RsDeudor=Conn.execute(strSql)

			'Response.write strSql

							If not RsDeudor.eof then
								strProbCobro = RsDeudor("PROB_COBRO")
							Else
								strProbCobro = "&nbsp;"
							End if


							strSql="SELECT TOP 1 NOMBREDEUDOR,RUTDEUDOR ,REPLEG_NOMBRE, REPLEG_RUT FROM DEUDOR WHERE RUTDEUDOR='" & rsGTC("RUTDEUDOR") &"' AND NOMBREDEUDOR IS NOT NULL AND LTRIM(RTRIM(NOMBREDEUDOR)) <> '' AND CODCLIENTE = '" & strCliente & "'"
							set RsDeudor=Conn.execute(strSql)

			'Response.write strSql

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

			'Response.write strSql

							if not rsDIR.eof then
								strDireccion = rsDIR("CALLE") & " " & rsDIR("NUMERO") & " " & rsDIR("RESTO")
								strComuna = rsDIR("COMUNA")
								strCiudad = rsDIR("CIUDAD")
							end if
							rsDIR.close
							set rsDIR=nothing

							strEmail = ""
							strSql=""
							strSql="SELECT TOP 1 EMAIL FROM DEUDOR_EMAIL WHERE RUTDEUDOR='"& rsGTC("RUTDEUDOR") &"' and ESTADO <> '2' ORDER BY Correlativo DESC"
							set rsDIR=Conn.execute(strSql)

			'Response.write strSql

							if not rsDIR.eof then
								strEmail = rsDIR("EMAIL")
							Else
								strEmail = ""
							end if
							rsDIR.close
							set rsDIR=nothing

							strSql="SELECT MAX(IDDEMANDA) as IDDEMANDA FROM DEMANDA WHERE CODCLIENTE = '" & strCliente 	& "' AND RUTDEUDOR = '" & rsGTC("RUTDEUDOR")  & "'"
							set rsDemanda = Conn.execute(strSql)

			'Response.write strSql

							if not rsDemanda.eof then
								intIdDemanda = rsDemanda("IDDEMANDA")
							Else
								intIdDemanda = "0"
							End if
							rsDemanda.close
							set rsDemanda=nothing

							intGastosJud = ""
							intIdTribunal = ""
							strRolAno = ""
							strTribunal = ""
							strFechaComparendo = ""
							strFechaIngreso = ""
							intMontoDemanda = ""

							If intIdDemanda <> "0" Then
								intGastosJud = TraeCampoId(Conn, "GASTOS_JUDICIALES", intIdDemanda, "DEMANDA", "IDDEMANDA")
								intIdTribunal = TraeCampoId(Conn, "IDTRIBUNAL", intIdDemanda, "DEMANDA", "IDDEMANDA")
								strRolAno = TraeCampoId(Conn, "ROLANO", intIdDemanda, "DEMANDA", "IDDEMANDA")
								intMontoDemanda = TraeCampoId(Conn, "MONTO", intIdDemanda, "DEMANDA", "IDDEMANDA")


								strTribunal = TraeCampoId(Conn, "NOMTRIBUNAL", intIdTribunal, "TRIBUNAL", "IDTRIBUNAL")
								strFechaComparendo = TraeCampoId(Conn, "FECHA_COMPARENDO", intIdDemanda, "DEMANDA", "IDDEMANDA")
								strFechaIngreso = TraeCampoId(Conn, "FECHA_INGRESO", intIdDemanda, "DEMANDA", "IDDEMANDA")
							End if

							If Trim(intTipoInforme) = "2" Then
								strSql = "SELECT TOP 1 USUARIO_ASIG , CODREMESA, LOGIN, CONVERT(VARCHAR(10),MAX(FECHA_ESTADO),103) as FECHA_ULTPAGO FROM CUOTA, USUARIO WHERE CUOTA.USUARIO_ASIG *= USUARIO.ID_USUARIO AND CODCLIENTE = '" & strCliente & "' AND RUTDEUDOR = '" & rsGTC("RUTDEUDOR") & "' AND ESTADO_DEUDA IN (3,4) GROUP BY USUARIO_ASIG , CODREMESA, LOGIN"
							Else
								strSql = "SELECT TOP 1 USUARIO_ASIG , CODREMESA, LOGIN FROM CUOTA, USUARIO WHERE CUOTA.USUARIO_ASIG *= USUARIO.ID_USUARIO AND CODCLIENTE = '" & strCliente & "' AND RUTDEUDOR = '" & rsGTC("RUTDEUDOR") & "'"
							End if
							set rsUsAsig= Conn.execute(strSql)

			'Response.write strSql

							if not rsUsAsig.eof then
								strUsuarioAsig = rsUsAsig("LOGIN")
								strAsignacion = rsUsAsig("CODREMESA")
								If Trim(intTipoInforme) = "2" Then
									dtmFecPago = rsUsAsig("FECHA_ULTPAGO")
								End If
							Else
								strUsuarioAsig = ""
								strAsignacion = ""
								dtmFecPago = ""
							End if

							intDiasAntiguedad = rsGTC("DIASANT")



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
								<td ALIGN="LEFT"><%=strProbCobro%></td>
								<% If intTipoInforme = "" or intTipoInforme = "1" or intTipoInforme = "2" or intTipoInforme = "3" Then %>
									<td ALIGN="LEFT"><%=dtmFecPago%></td>
									<td ALIGN="LEFT"><%=strFechaIngreso%></td>
									<td ALIGN="LEFT"><%=strFechaComparendo%></td>
									<td ALIGN="LEFT">&nbsp</td>
									<td ALIGN="LEFT"><%=intGastosJud%></td>
									<td ALIGN="LEFT"><%=strRolAno%></td>
									<td ALIGN="LEFT"><%=strTribunal%></td>
									<td ALIGN="LEFT"><%=intMontoDemanda%></td>
								<% End If %>
								<td ALIGN="LEFT"><%=Mid(strProbabilidad,2,len(strProbabilidad))%></td>
								<td ALIGN="LEFT"><%=strRepLegalRut%></td>
								<td ALIGN="LEFT"><%=strRepLegalNombre%></td>
								<td ALIGN="LEFT"><%=strUsuarioAsig%></td>
								<td ALIGN="LEFT"><%=strAsignacion%></td>
								<td ALIGN="LEFT"><%=strEmail%></td>
								<td ALIGN="LEFT"><%=intDiasAntiguedad%></td>




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
			datos.action='informe_generico.asp?strRefrescar=R';
		}else{
			datos.action='informe_generico.asp';
		}
		datos.submit();
	}
}

function excel(){
	if (datos.CB_CLIENTE.value=='0'){
		alert('DEBE SELECCIONAR UN CLIENTE');
	}else{
		datos.action='informe_demandas_xls.asp';
		datos.submit();
	}
}
function ventanaDetalle (URL){
window.open(URL,"DETALLEGESTION","width=800, height=300, scrollbars=yes, menubar=no, location=no, resizable=yes")
}

</script>
