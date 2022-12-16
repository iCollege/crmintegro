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

'Response.write "<br>intTipoInforme = " & intTipoInforme

'Response.End

If Trim(intTipoInforme) = "1" Then
	strTitulo = "CARTAS"
End If

If Trim(intTipoInforme) = "2" Then
	strTitulo = "PAGADOS"
End If

If Trim(intTipoInforme) = "3" Then
	strTitulo = "RETIROS"
End If

If Trim(intTipoInforme) = "" Then
	strTitulo = "DEMANDAS"
End If

intDias=30

strRefrescar = Request("strRefrescar")

If Trim(strCliente) = "" Then strCliente = "1000"
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

				        <% If intTipoInforme = "1" or intTipoInforme = "2" or intTipoInforme = "3" Then %>
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
				      </tr>
			    <%
			    	strTotalCuantia = 0
					abrirscg()

					strCondicion = ""
					If Trim(intGJ) <> "111" Then
						strCondicion = " AND IDGJUDICIAL = " & intGJ
					Else
						strCondicion = " AND IDGJUDICIAL NOT IN (12,13)"
					End if

					strSql = "SELECT RUTDEUDOR, SUM(SALDO) as MONTO, COUNT(*) FROM CUOTA WHERE CODCLIENTE = '" & strCliente & "'"

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
					strSql = strSql & strCondicion & " AND DATEDIFF(DAY,FECHAVENC,GETDATE()) > 30 GROUP BY RUTDEUDOR "

					If intTipoInforme = "1" or intTipoInforme = "" then
						strSql = strSql & " HAVING SUM(SALDO) >= 100000 "
					End If



					If trim(strProbCobro) <> "T" Then
						strSql = strSql & " AND RUTDEUDOR IN (SELECT RUTDEUDOR FROM CUOTA_ENC WHERE PROB_COBRO = '" & strProbCobro & "')"
					End if



					strSql = strSql & " AND RUTDEUDOR IN ('99557440-3','96983490-1','79609290-4','78787220-4','78713180-8','78706590-2','78169520-3','78093390-9','77956060-0','77614730-3','77400520-K','77277570-9','77267340-K','77192730-0','77180810-7','77161990-8','77149920-1','76739640-6','76619710-8','76511680-5','76488140-0','76419140-4','76326710-5','76195000-2','76074250-3','76029300-8','77288820-1','77020460-7','76601080-6','82618400-0','76392100-K','76182670-0','77688990-3','77623070-7','77159520-0','52001366-0','76446460-5','77286980-0','76613470-K','76333480-5','76246560-4','77348410-4','76727700-8','76454190-1','76278590-0')"

					'Response.write "strSql = " & strSql
					'Response.End
					set rsGTC= Conn.execute(strSql)
					if not rsGTC.eof then
						intConRegistros="S"

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
							Do while not rsCuotaEnc.eof
								strNombre = Trim(rsCuotaEnc("NOMBRE"))
								strProbabilidad = strProbabilidad & ", " & rsCuotaEnc("NRODOC")
								''intSaldo = intSaldo + rsCuotaEnc("SALDO")

								If intTipoInforme = "1" or intTipoInforme = "" Then
									intSaldo = intSaldo + rsCuotaEnc("SALDO")
								Else
									intSaldo = intSaldo + rsCuotaEnc("VALORCUOTA")
								End if
								rsCuotaEnc.movenext

							Loop
							rsCuotaEnc.close
							set rsCuotaEnc=nothing
							intCorre = intCorre + 1

							strSql="SELECT PROB_COBRO FROM CUOTA_ENC WHERE RUTDEUDOR='" & rsGTC("RUTDEUDOR") &"' AND CODCLIENTE = '" & strCliente & "'"
							set RsDeudor=Conn.execute(strSql)
							If not RsDeudor.eof then
								strProbCobro = RsDeudor("PROB_COBRO")
							Else
								strProbCobro = "&nbsp;"
							End if


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


							strSql = "SELECT TOP 1 USUARIO_ASIG , CODREMESA, LOGIN FROM CUOTA, USUARIO WHERE CUOTA.USUARIO_ASIG = USUARIO.ID_USUARIO AND CODCLIENTE = '" & strCliente & "' AND RUTDEUDOR = '" & rsGTC("RUTDEUDOR") & "'"
							set rsUsAsig= Conn.execute(strSql)
							if not rsUsAsig.eof then
								strUsuarioAsig = rsUsAsig("LOGIN")
								strAsignacion = rsUsAsig("CODREMESA")
							Else
								strUsuarioAsig = ""
								strAsignacion = ""
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
								<td ALIGN="LEFT"><%=strProbCobro%></td>
								<% If intTipoInforme = "1" or intTipoInforme = "2" or intTipoInforme = "3" Then %>
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
			datos.action='informe_generico_2.asp?strRefrescar=R';
		}else{
			datos.action='informe_generico_2.asp';
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
