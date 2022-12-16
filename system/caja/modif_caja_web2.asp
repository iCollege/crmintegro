<% @LCID = 1034 %>
<!--#include file="../arch_utils.asp"-->
<!--#include file="../../lib/comunes/rutinas/funciones.inc" -->
<!--#include file="../../lib/comunes/rutinas/TraeCampo.inc" -->
<!--#include file="../asp/comunes/general/rutinasSCG.inc" -->
<!--#include file="../lib.asp"-->
<%
	cod_pago=request("cod_pago")

	intIdPago=request("cod_pago")

	strOrigen=request("strOrigen")


	AbrirSCG()


		strSql = "SELECT RENDIDO,CONVERT(VARCHAR(10),FECHA_PAGO,103) AS FECHA_PAGO,COD_CLIENTE,RUTDEUDOR,COMP_INGRESO,NRO_BOLETA,MONTO_CAPITAL,MONTO_EMP,TIPO_PAGO,NRO_DEPOSITO_CLIENTE,NRO_DEPOSITO_EMP,DESC_CLIENTE,DESC_EMP,TOTAL_CLIENTE,TOTAL_EMP,BCO_DEPOSITO_CLIENTE,BCO_DEPOSITO_EMP,OBSERVACIONES,INTERES_PLAZO,INDEM_COMP, GASTOSJUDICIALES, GASTOSOTROS "
		strSql = strSql & " FROM CAJA_WEB_EMP WHERE ID_PAGO=" & cod_pago

		'Response.write "strSql=" & strSql
		'Response.End
		set rsInserta=Conn.execute(strSql)
		if not rsInserta.eof then
			rut = rsInserta("RUTDEUDOR")
			'response.write(rut)
			dtmFechaPago=rsInserta("FECHA_PAGO")
			cliente=rsInserta("COD_CLIENTE")
			intNroBoleta = rsInserta("NRO_BOLETA")
			intCompIngreso = rsInserta("COMP_INGRESO")
			intMontoCliente = rsInserta("MONTO_CAPITAL")
			intMontoEmp = rsInserta("MONTO_EMP")
			intTipoPago = rsInserta("TIPO_PAGO")
			descliente = rsInserta("DESC_CLIENTE")
			desemp = rsInserta("DESC_EMP")
			ttcliente = rsInserta("TOTAL_CLIENTE")
			ttemp = rsInserta("TOTAL_EMP")
			bancocliente=rsInserta("BCO_DEPOSITO_CLIENTE")
			sql="SELECT * FROM BANCOS WHERE CODIGO='" & bancocliente & "'"
			set rsBC=Conn.execute(SQL)
			if not rsBC.eof then
				badescripcli=rsBC("nombre_b")
			else
				badescripcli=""
			end if

			bancoemp=rsInserta("BCO_DEPOSITO_EMP")
			sql="select * from bancos where codigo='" & bancoemp & "'"
			set rsBEmp=Conn.execute(SQL)
			if not rsBEmp.eof then
				badescripemp=rsBEmp("NOMBRE_B")
			else
				badescripemp=""
			end if
			strNroDepositoCliente = rsInserta("NRO_DEPOSITO_CLIENTE")
			if strNroDepositoCliente="NULL" then
				strNroDepositoCliente=""
			end if
			strNroDepositoEMP = rsInserta("NRO_DEPOSITO_EMP")
			if strNroDepositoEMP="NULL" then
				strNroDepositoEMP=""
			end if
			sql2="select nro_liquidacion from caja_web_emp_detalle where id_pago=" & cod_pago & ""
			set rsLiq=Conn.execute(SQL2)
			if not rsLiq.eof then
				if rsLiq("NRO_LIQUIDACION")=0 then
					strNroLiquidacion=""
				else
					strNroLiquidacion=rsLiq("NRO_LIQUIDACION")
				end if
			end if
			observaciones = rsInserta("OBSERVACIONES")
			ipcliente = rsInserta("INTERES_PLAZO")
			intIndComp = rsInserta("INDEM_COMP")
			intGastosJud = rsInserta("GASTOSJUDICIALES")
			intGastosOtros = rsInserta("GASTOSOTROS")



			intTotalGeneral = ttcliente + ttemp

			cemp = ""
			'strNroLiquidacion = rsInserta("nro_liquidacion")
		end if
		rsInserta.close
		set rsInserta=nothing

%>
<title>Modificacion de pagos</title>
<style type="text/css">
<!--
.Estilo13 {color: #FFFFFF}
.Estilo27 {color: #FFFFFF}
-->
</style>

<script language="JavaScript" src="../../comunes/lib/cal2.js"></script>
<script language="JavaScript" src="../../comunes/lib/cal_conf2.js"></script>
<script language="JavaScript" src="../../comunes/lib/validaciones.js"></script>
<script src="../../comunes/general/SelCombox.js"></script>
<script src="../../comunes/general/OpenWindow.js"></script>


<script language="JavaScript " type="text/JavaScript">

function Refrescar(rut)
{
//alert(rut)
	if(rut == '')
	{
		return
	}
	//else{
		//with( document.datos )
		//{
//			alert(rut)
			datos.action = "caja_web2.asp?rut=" + rut + "&tipo=1";
			//alert(action)
			datos.submit();
		//}
	//}
}

function Ingresa(rut)
{

	if(rut == '')
	{
		return
	}

	with( document.datos )
	{
		action = "caja_web2.asp?rut=" + rut + "&tipo=2";
		submit();
	}
}

function IngresaP(rut)
{

	if(rut == '')
	{
		return
	}

	with( document.datos )
	{
		action = "caja_web2.asp?rut=" + rut + "&strGraba=SI&intSeq=<%=intSeq%>";
		submit();
	}
}

function fonload(){

}
</script>


<link href="style.css" rel="Stylesheet">
<body onload = "{ fonload(); }">
<form name="datos" method="post">

<INPUT TYPE="hidden" NAME="intIdPago" value="<%=intIdPago%>">


<table width="600" height="500" border="1">
  <tr>
    <td height="20" bordercolor="#999999"  bgcolor="<%=session("COLTABBG")%>" class="Estilo27" align="center"><strong>Módulo de Modificación de Pagos</strong></td>
  </tr>
  <tr>
    <td valign="top">
	  <%

		if rut <> "" then
			strNombreDeudor = TraeNombreDeudor(Conn,rut)
		end if

	%>
	<table width="100%" border="0" bordercolor="#FFFFFF">
	      <tr bordercolor="#999999" class="Estilo8">
	        <td ALIGN="LEFT">
	        RUT :
	        <input name="TX_RUT" type="text" value="<%=rut%>" size="10" maxlength="10" onChange="Valida_Rut(this.value)">
	        </td>
	        <td>
	        NOMBRE O RAZON SOCIAL: &nbsp;<%=strNombreDeudor%>
	        <INPUT TYPE="hidden" NAME="rut" value="<%=rut%>">
	        </td>
	        <td ALIGN="RIGHT">USUARIO : <%=session("session_login")%></td><td>FECHA: <%=dtmFechaPago%></td>
	      </tr>
    </table>
	</td>
	</tr>
	<tr>
	<td bordercolor="#999999"  bgcolor="<%=session("COLTABBG")%>">
	<font class="Estilo27"><strong>&nbsp;Resumen Pago</strong></font>
	</td>
	</tr>
	<tr>
	<td>
	<table width="100%" border="0">
      <tr bordercolor="#999999"  bgcolor="<%=session("COLTABBG")%>">
        <td><span class="Estilo27">CLIENTE</span></td>
        <td><span class="Estilo27">Fec.Pago</span></td>
        <td><span class="Estilo27">N° Comprobante</span></td>
		<td><span class="Estilo27">N° Boleta</span></td>
		<td><span class="Estilo27">Tipo Pago</span></td>
       </tr>
      <tr class="Estilo8">
        <td>
		<select DISABLED name="CB_CLIENTE" id = "CB_CLIENTE" width="15" onchange="tipopago()">
		<option value="0">SELECCIONAR</option>
		<%
		ssql="SELECT * FROM CLIENTE WHERE ACTIVO=1"
		set rsCLI=Conn.execute(ssql)
		if not rsCLI.eof then
			do until rsCLI.eof
			%>
			<option value="<%=rsCLI("CODCLIENTE")%>"
			<%if Trim(cliente)=Trim(rsCLI("CODCLIENTE")) then
				response.Write("Selected")
			end if%>
			><%=ucase(rsCLI("CODCLIENTE") & " - " & rsCLI("DESCRIPCION"))%></option>

			<%rsCLI.movenext
			loop
		end if
		rsCLI.close
		set rsCLI=nothing
		%>
        </select>
        </td>
		<td><input name="TX_FECHAPAGO" type="text" value="<%=dtmFechaPago%>" size="10" maxlength="10"></td>
	    <td><input DISABLED name="TX_COMPINGRESO" type="text" value="<%=intCompIngreso%>" size="10" maxlength="10"></td>
		<td><input name="TX_BOLETA" type="text" value="<%=intNroBoleta%>" size="10" maxlength="10"></td>
		<td>
		<select name="CB_TIPOPAGO" id="CB_TIPOPAGO" width="10" onchange="tipopago();">
				<option value="" width="10">SELECCIONAR</option>
				<%
				ssql="SELECT * FROM CAJA_TIPO_PAGO"
				set rsTP=Conn.execute(ssql)
				if not rsTP.eof then
					do until rsTP.eof
					%>
					<option value="<%=rsTP("ID_TIPO_PAGO")%>"width="10"<%if intTipoPago=rsTP("ID_TIPO_PAGO") then response.write("selected")%>><%=ucase(rsTP("ID_TIPO_PAGO") & " - " & rsTP("DESC_TIPO_PAGO"))%></option>

					<%rsTP.movenext
					loop
				end if
				rsTP.close
				set rsTP=nothing
				%>
		</select>
		</td>
        </tr>
    </table>
	</td>
	</tr>
	<tr>
	<td>
	<table width="100%" border="0">
	  <tr bordercolor="#999999"  bgcolor="<%=session("COLTABBG")%>">
		<td><span class="Estilo27">Monto Cliente</span></td>
		<td><span class="Estilo27">Nro.Dep.Cliente</span></td>
		<td><span class="Estilo27">Banco</span></td>
		<td><span class="Estilo27">Intereses</span></td>

		<td><span class="Estilo27">Ind.Comp</span></td>
		<td><span class="Estilo27">Gastos Jud</span></td>
		<td><span class="Estilo27">Otros gastos</span></td>

		<!--td><span class="Estilo27">Desc. Cliente</span></td-->
		<td><span class="Estilo27">Total Cliente</span></td>
	</tr>
	<tr class="Estilo8">
		<td><input name="TX_MONTOCLIENTE" type="text" value="<%=intMontoCliente%>" size="10" maxlength="10" DISABLED></td>
		<td><input name="TX_NRODEPCLIENTE" type="text" value="<%=strNroDepositoCliente%>" size="10" maxlength="10"></td>
		<td>
			<select name="CB_BCLIENTE" class="Estilo8">
			<option value="">SELECCIONAR</option>
			<%
			ssql="SELECT * FROM BANCOS"
			set rsBANC=Conn.execute(ssql)
			if not rsBANC.eof then
				do until rsBANC.eof
				%>
				<option value="<%=rsBANC("CODIGO")%>"
				<%if Trim(bancocliente)=Trim(rsBANC("CODIGO")) then
					response.Write("Selected")
				end if%>
				><%=ucase(rsBANC("CODIGO") & " - " & Mid(rsBANC("NOMBRE_B"),1,15))%></option>

				<%rsBANC.movenext
				loop
			end if
			rsBANC.close
			set rsBANC=nothing
			%>
			</select>
		</td>
		<td><input name="TX_IPCLIENTE" type="text" value="<%=ipcliente%>" size="10" maxlength="10" value="" onchange="solonumero(TX_IPCLIENTE);montocliente()"></td>
		<td><input name="TX_INDEM_COMP" type="text" value="<%=intIndComp%>" size="10" maxlength="10" value="" onchange="solonumero(TX_INDEM_COMP);montocliente()"></td>
		<td><input name="TX_GASTOSJUDICIALES" type="text" value="<%=intGastosJud%>" size="10" maxlength="10" value="" onchange="solonumero(TX_GASTOSJUDICIALES);montocliente()"></td>
		<td><input DISABLED name="TX_GASTOSOTROS" type="text" value="<%=intGastosOtros%>" size="10" maxlength="10" value="" onchange="solonumero(TX_GASTOSOTROS);montocliente()"></td>

		<!--td><input name="TX_DESCLIENTE" type="text" value="<%=descliente%>" size="10" maxlength="10" onchange="solonumero(TX_DESCLIENTE);montocliente()"></td-->
		<td><input name="TX_TOTALCLIENTE" type="text" value="<%=ttcliente%>" size="10" maxlength="10" disabled></td>
	</tr>
	<tr bordercolor="#999999"  bgcolor="<%=session("COLTABBG")%>">
		<td><span class="Estilo27">Honorarios</span></td>
		<td><span class="Estilo27">Nro.Dep. Empresa</span></td>
		<td><span class="Estilo27">Banco</span></td>
		<!--td><span class="Estilo27">Costas Empresa</span></td-->
		<!--td><span class="Estilo27">Descuento Empresa</span></td-->
		<td><span class="Estilo27">Total Honorarios</span></td>
		<td><span class="Estilo27">Total General</span></td>
	  </tr>
	  <tr class="Estilo8">
		<td><input name="TX_MONTOEMP" type="text" value="<%=intMontoEmp%>" size="10" maxlength="10" onchange="solonumero(TX_MONTOEMP);montocliente()"></td>
		<td><input name="TX_NRODEPEMP" type="text" value="<%=strNroDepositoEMP%>" size="10" maxlength="10"></td>
		<td><select name="CB_BEMP" class="Estilo8">
		<option value="">SELECCIONAR</option>
		<%
		ssql="SELECT * FROM BANCOS"
		set rsBANC=Conn.execute(ssql)
		if not rsBANC.eof then
			do until rsBANC.eof
			%>
			<option value="<%=rsBANC("CODIGO")%>"
			<%if Trim(bancoemp)=Trim(rsBANC("CODIGO")) then
				response.Write("Selected")
			end if%>
			><%=ucase(rsBANC("CODIGO") & " - " & Mid(rsBANC("NOMBRE_B"),1,15))%></option>

			<%rsBANC.movenext
			loop
		end if
		rsBANC.close
		set rsBANC=nothing
		%>
		</select></td>
		<!--td><input name="TX_CEMP" type="text" value="<%=cemp%>" size="10" maxlength="10" onchange="solonumero(TX_CEMP);montocliente()"></td-->
		<!--td><input name="TX_DESCUENTO" type="text" value="<%=desemp%>" size="10" maxlength="10" onchange="solonumero(TX_DESCUENTO);montocliente()"></td-->
		<td><input DISABLED name="TX_TOTALEMP" type="text" value="<%=ttemp%>" size="10" maxlength="10" disabled></td>
		<td><input DISABLED name="TX_TOTAL" type="text" value="<%=ttcliente + ttemp%>" size="10" maxlength="10" disabled></td>
	  </tr>
	</table>
	<table>
		<tr>
			<td>OBSERVACIONES (MOTIVO DE LA MODIFICACION): </td>
		</tr>
		<tr>
			<td><INPUT TYPE="text" NAME="TX_OBSERVACION" size="126" value="<%=observaciones%>"></td>
		</tr>
	</table>
</td>
</tr>

<tr>
<td>

<tr bordercolor="#999999"  bgcolor="<%=session("COLTABBG")%>">
<td>
	<font class="Estilo27"><strong>&nbsp;Detalle de Documentos</strong></font>
</td>
</tr>
<tr>
<td>
	<table width="100%" border="0">
	<tr bordercolor="#999999"  bgcolor="<%=session("COLTABBG")%>">
		<td><span class="Estilo27">Destino Pago</span></td>
		<td><span class="Estilo27">Forma Pago</span></td>
        <td><span class="Estilo27">Rut Cheque</span></td>
        <td><span class="Estilo27">Monto</span></td>
        <td><span class="Estilo27">Fecha Venc</span></td>
		<td><span class="Estilo27">Banco</span></td>
		<td><span class="Estilo27">Plaza</span></td>
		<td><span class="Estilo27">N° Cheque</span></td>
		<td><span class="Estilo27">Cta. Cte.</span></td>
		<TD></TD>
       </tr>

       <%
	   	strsql="SELECT * FROM CAJA_WEB_EMP_DOC_PAGO WHERE ID_PAGO= " & cod_pago & " ORDER BY ID_PAGO,CORRELATIVO"
	   	set rsdetpg=Conn.execute(strsql)
	   	if not rsdetpg.eof then
	   			do while not rsdetpg.eof
	   				strmonto=rsdetpg("monto")
	   				if isnull(rsdetpg("vencimiento")) then
	   					strvencimiento=""
	   				else
	   					strvencimiento=rsdetpg("vencimiento")
	   				end if
	   				banco= ""
	   				strcodbanco=rsdetpg("cod_banco")
	   				if strcodbanco="NULL" then strcodbanco="0"
	   				if strcodbanco<>"" and strcodbanco<> "0" then
	   					sql="select * from bancos where codigo='" & strcodbanco & "'"
	   					set rsba=Conn.execute(sql)
	   					if not rsba.eof then
	   						strbanco=rsba("nombre_b")
	   					end if
	   					banco= strcodbanco &" - "& strbanco
	   				end if


	   				if rsdetpg("nro_cheque")="NULL" then
	   					nrocheque=""
	   				else
	   					nrocheque=rsdetpg("nro_cheque")
	   				end if
	   				if rsdetpg("nro_ctacte")="NULL" then
	   					nroctacte=""
	   				else
	   					nroctacte=rsdetpg("nro_ctacte")
	   				end if
	   				codplaza=rsdetpg("codigo_plaza")
	   				plaza = ""
	   				if codplaza <> "" and codplaza <>"0" then
	   				sql="select * from plazas where codigo='" & codplaza & "'"
	   				set rspl=Conn.execute(sql)
	   				if not rspl.eof then
	   					strplaza=rspl("nombre_p")
	   				end if
	   				plaza=codplaza &" - "& strplaza
	   				end if

	   				codtp=rsdetpg("tipo_pago")
	   				if Trim(codtp)="0" then
	   					tipopago="CLIENTE"
	   				else
	   					tipopago="EMPRESA"
	   				end if
	   				if rsdetpg("rut_cheque")="NULL" then
	   					rutcheque=""
	   				else
	   					rutcheque=rsdetpg("rut_cheque")
	   				end if
	   				fromapago=rsdetpg("forma_pago")
	   				sql="select * from caja_forma_pago where id_forma_pago='" & fromapago & "'"
	   				set rsfp=Conn.execute(sql)
	   				if not rsfp.eof then
	   				desformapago=rsfp("desc_forma_pago")
	   				end if
	   				fpago = fromapago &" - "& desformapago

	   				if strvencimiento = "01/01/1900" then
	   					strvencimiento= ""
	   				end if
	   				%>

	   				  <tr>
							<td>
							<select name="CB_DESTINO_<%=rsdetpg("correlativo")%>" class="Estilo8">
							<option value="">SELECCIONAR</option>
							<option value="0" <%If codtp = "0" Then Response.write "SELECTED"%>>CLIENTE</option>
							<option value="1" <%If codtp = "1" Then Response.write "SELECTED"%>>EMPRESA</option>
							</select>
							</td>
							<td>
							<select name="CB_FPAGO_<%=rsdetpg("correlativo")%>" width="10" maxlength="10" class="Estilo8">
							<option value="">SELECCIONAR</option>
							<%
							ssql="SELECT * FROM CAJA_FORMA_PAGO"
							set rsCLI=Conn.execute(ssql)
							if not rsCLI.eof then
								do until rsCLI.eof
								%>
								<option value="<%=rsCLI("ID_FORMA_PAGO")%>"
								<%if Trim(fromapago)=Trim(rsCLI("ID_FORMA_PAGO")) then
									response.Write("Selected")
								end if%>
								><%=ucase(rsCLI("ID_FORMA_PAGO") & " - " & rsCLI("DESC_FORMA_PAGO"))%></option>

								<%rsCLI.movenext
								loop
							end if
							rsCLI.close
							set rsCLI=nothing
							%>
							</select>
					        </td>

					        <td><input name="TX_RUTCLI_<%=rsdetpg("correlativo")%>" type="text" value="<%=rutcheque%>" size="10" maxlength="10" class="Estilo8" onchange="Valida_Rut(this.value)"></td>
							<td><input name="TX_MONTOCLI_<%=rsdetpg("correlativo")%>" type="text" value="<%=strmonto%>" size="8" maxlength="10" class="Estilo8" onchange="solonumero(TX_MONTOCLI);"></td>
						    <td><input name="TX_VENC_<%=rsdetpg("correlativo")%>" type="text" value="<%=strvencimiento%>" size="8" maxlength="10" class="Estilo8"></td>
							<td><select name="CB_BANCO_CLIENTE_<%=rsdetpg("correlativo")%>" class="Estilo8">
							<option value="0">SELECCIONAR</option>
							<%
							ssql="SELECT * FROM BANCOS where codigo>0"
							set rsBANC=Conn.execute(ssql)
							if not rsBANC.eof then
								do until rsBANC.eof
								%>
								<option value="<%=rsBANC("CODIGO")%>"
								<%if Trim(strcodbanco)=Trim(rsBANC("CODIGO")) then
									response.Write("Selected")
								end if%>
								><%=ucase(rsBANC("CODIGO") & " - " & Mid(rsBANC("NOMBRE_B"),1,15))%></option>

								<%rsBANC.movenext
								loop
							end if
							rsBANC.close
							set rsBANC=nothing
							%>
							</select>
							</td>
							<td><select name="CB_PLAZA_CLIENTE_<%=rsdetpg("correlativo")%>" class="Estilo8">
							<option value="0">SELECCIONAR</option>
							<%
							ssql="SELECT * FROM PLAZAS where codigo>0"
							set rsPLA=Conn.execute(ssql)
							if not rsPLA.eof then
								do until rsPLA.eof
								%>
								<option value="<%=rsPLA("CODIGO")%>"
								<%if Trim(strplaza)=Trim(rsPLA("CODIGO")) then
									response.Write("Selected")
								end if%>
								><%=ucase(rsPLA("CODIGO") & " - " & Mid(rsPLA("NOMBRE_P"),1,15))%></option>

								<%rsPLA.movenext
								loop
							end if
							rsPLA.close
							set rsPLA=nothing
							%>
							</select></td>
							<td><input name="TX_NROCHEQUECLI_<%=rsdetpg("correlativo")%>" type="text" value="<%=nrocheque%>" size="8" maxlength="20" class="Estilo8"></td>
							<td><input name="TX_NROCTACTECLI_<%=rsdetpg("correlativo")%>" type="text" value="<%=nroctacte%>" size="8" maxlength="20" class="Estilo8"></td>
							<td>&nbsp</td>
        				</tr>

	   				<%
	   					intMaxCorr = rsdetpg("correlativo")
	   					strmonto=""
	   					strvencimiento=""
	   					banco=""
	   					strcodbanco=""
	   					nrocheque=""
	   					nroctacte=""
	   					codplaza=""
	   					plaza=""
	   					codtp=""
	   					rutcheque=""
	   					fromapago=""
	   					strplaza=""
	   				rsdetpg.movenext
	   			loop

				intMaxCorrMas1 = intMaxCorr + 1

	   			End if
	   %>



		<tr>
			<td>
			<select name="CB_DESTINO_<%=intMaxCorrMas1%>" class="Estilo8">
			<option value="">SELECCIONAR</option>
			<option value="0" <%If codtp = "0" Then Response.write "SELECTED"%>>CLIENTE</option>
			<option value="1" <%If codtp = "1" Then Response.write "SELECTED"%>>EMPRESA</option>
			</select>
			</td>
			<td>
			<select name="CB_FPAGO_<%=intMaxCorrMas1%>" width="10" maxlength="10" class="Estilo8">
			<option value="">SELECCIONAR</option>
			<%
			ssql="SELECT * FROM CAJA_FORMA_PAGO"
			set rsCLI=Conn.execute(ssql)
			if not rsCLI.eof then
				do until rsCLI.eof
				%>
				<option value="<%=rsCLI("ID_FORMA_PAGO")%>"
				<%if Trim(fromapago)=Trim(rsCLI("ID_FORMA_PAGO")) then
					response.Write("Selected")
				end if%>
				><%=ucase(rsCLI("ID_FORMA_PAGO") & " - " & rsCLI("DESC_FORMA_PAGO"))%></option>

				<%rsCLI.movenext
				loop
			end if
			rsCLI.close
			set rsCLI=nothing
			%>
			</select>
			</td>

			<td><input name="TX_RUTCLI_<%=intMaxCorrMas1%>" type="text" value="<%=rutcheque%>" size="10" maxlength="10" class="Estilo8" onchange="Valida_Rut(this.value)"></td>
			<td><input name="TX_MONTOCLI_<%=intMaxCorrMas1%>" type="text" value="<%=strmonto%>" size="8" maxlength="10" class="Estilo8" onchange="solonumero(TX_MONTOCLI);"></td>
			<td><input name="TX_VENC_<%=intMaxCorrMas1%>" type="text" value="<%=strvencimiento%>" size="8" maxlength="10" class="Estilo8"></td>
			<td><select name="CB_BANCO_CLIENTE_<%=intMaxCorrMas1%>" class="Estilo8">
			<option value="0">SELECCIONAR</option>
			<%
			ssql="SELECT * FROM BANCOS where codigo>0"
			set rsBANC=Conn.execute(ssql)
			if not rsBANC.eof then
				do until rsBANC.eof
				%>
				<option value="<%=rsBANC("CODIGO")%>"
				<%if Trim(strcodbanco)=Trim(rsBANC("CODIGO")) then
					response.Write("Selected")
				end if%>
				><%=ucase(rsBANC("CODIGO") & " - " & Mid(rsBANC("NOMBRE_B"),1,15))%></option>

				<%rsBANC.movenext
				loop
			end if
			rsBANC.close
			set rsBANC=nothing
			%>
			</select>
			</td>
			<td><select name="CB_PLAZA_CLIENTE_<%=intMaxCorrMas1%>" class="Estilo8">
			<option value="0">SELECCIONAR</option>
			<%
			ssql="SELECT * FROM PLAZAS where codigo>0"
			set rsPLA=Conn.execute(ssql)
			if not rsPLA.eof then
				do until rsPLA.eof
				%>
				<option value="<%=rsPLA("CODIGO")%>"
				<%if Trim(strplaza)=Trim(rsPLA("CODIGO")) then
					response.Write("Selected")
				end if%>
				><%=ucase(rsPLA("CODIGO") & " - " & Mid(rsPLA("NOMBRE_P"),1,15))%></option>

				<%rsPLA.movenext
				loop
			end if
			rsPLA.close
			set rsPLA=nothing
			%>
			</select></td>
			<td><input name="TX_NROCHEQUECLI_<%=intMaxCorrMas1%>" type="text" value="<%=nrocheque%>" size="8" maxlength="20" class="Estilo8"></td>
			<td><input name="TX_NROCTACTECLI_<%=intMaxCorrMas1%>" type="text" value="<%=nroctacte%>" size="8" maxlength="20" class="Estilo8"></td>
			<td>&nbsp</td>
		</tr>



		<!--tr>
			<td>&nbsp</td>
			<td>&nbsp</td>
			<td>&nbsp</td>
			<td><input name="TX_MONTOCLI_TOTAL" type="text" value="<%=intTotalGeneral%>" size="8" maxlength="10" class="Estilo8" onchange="solonumero(TX_MONTOCLI);"></td>
			<td>&nbsp</td>
			<td>&nbsp</td>
			<td>&nbsp</td>
			<td>&nbsp</td>
			<td>&nbsp</td>
			<td>&nbsp</td>
		</tr-->



	    <tr>

			<td colspan="10">
				<input type="button" name="Submit" value="Modificar" onClick="envia();" class="Estilo8">
			</td>
		</tr>
		<tr>
			<td>
			<INPUT TYPE="hidden" NAME="cod_pago" id ="cod_pago" value="<%=cod_pago%>">

			<INPUT TYPE="hidden" NAME="TXFPAGO" id="TXFPAGO">
			<INPUT TYPE="hidden" NAME="TXDESTINO" id="TXDESTINO">
			<INPUT TYPE="hidden" NAME="TXCUOTA" id="TXCUOTA">
			<INPUT TYPE="hidden" NAME="TXRUTCLI" id="TXRUTCLI">
			<INPUT TYPE="hidden" NAME="TXMONTOCLI" id="TXMONTOCLI">
			<INPUT TYPE="hidden" NAME="TXFECVENCLI" id="TXFECVENCLI">
			<INPUT TYPE="hidden" NAME="TXBANCOCLIENTE" id="TXBANCOCLIENTE">
			<INPUT TYPE="hidden" NAME="TXPLAZACLIENTE" id="TXPLAZACLIENTE">
			<INPUT TYPE="hidden" NAME="TXNROCHEQUECLI" id="TXNROCHEQUECLI">
			<INPUT TYPE="hidden" NAME="TXNROCTACTECLI" id="TXNROCTACTECLI">
			<%hoy=date%>
			<INPUT TYPE="hidden" NAME="TXFECHAACTUAL" id="TXFECHAACTUAL" value="<%=hoy%>">
			<INPUT TYPE="hidden" NAME="TXRUTEMP" id="TXRUTEMP">
			<INPUT TYPE="hidden" NAME="TXMONTOEMP" id="TXMONTOEMP">
			<INPUT TYPE="hidden" NAME="TXFECVENEMP" id="TXFECVENEMP">
			<INPUT TYPE="hidden" NAME="TXBANCOEMP" id="TXBANCOEMP">
			<INPUT TYPE="hidden" NAME="TXPLAZAEMP" id="TXPLAZAEMP">
			<INPUT TYPE="hidden" NAME="TXNROCHEQUEEMP" id="TXNROCHEQUEEMP">
			<INPUT TYPE="hidden" NAME="TXNROCTACTEEMP" id="TXNROCTACTEEMP">
			</td>

		</tr>
	</table>
</td>
</tr>

	<%'end if%>
	</td>
   </tr>
  </table>

  <INPUT TYPE="hidden" NAME="intMaxCorr" value="<%=intMaxCorr%>">
  <INPUT TYPE="hidden" NAME="intMaxCorrMas1" value="<%=intMaxCorrMas1%>">
  <INPUT TYPE="hidden" NAME="strOrigen" value="<%=strOrigen%>">



</form>
</body>
<script language="JavaScript" type="text/JavaScript">
////////////----------------/////////////////----------------//////////////////////

function solonumero(valor){
     //Compruebo si es un valor numérico
      if (isNaN(valor.value)) {
            //entonces (no es numero) devuelvo el valor cadena vacia
            valor.value=""
			valor.focus();
			//return ""
      }else{
            //En caso contrario (Si era un número) devuelvo el valor
			valor.value
			return valor.value
      }
}


function resta_capital(valor){
	datos.TX_MONTOCLIENTE.disabled = false;
	datos.TX_TOTAL.disabled = false;
	if (valor==''){
		valor=0;
	}
	datos.TX_MONTOCLIENTE.value = eval(datos.TX_MONTOCLIENTE.value) - eval(valor);
	datos.TX_TOTALCLIENTE.value = (eval(datos.TX_MONTOCLIENTE.value) + eval(datos.TX_IPCLIENTE.value)) - eval(datos.TX_DESCLIENTE.value)
	if (datos.TX_DESCUENTO.value == ""){
		datos.TX_DESCUENTO.value = 0;
	}
	if (datos.TX_MONTOEMP.value == ""){
		datos.TX_MONTOEMP.value = 0;
	}
	datos.TX_TOTALEMP.value = ((eval(datos.TX_MONTOEMP.value) + eval(datos.TX_CEMP.value)) - eval(datos.TX_DESCUENTO.value))
	datos.TX_TOTAL.value = (eval(datos.TX_TOTALCLIENTE.value) + eval(datos.TX_TOTALEMP.value));
	datos.TX_MONTOCLIENTE.disabled = true;
	datos.TX_TOTAL.disabled = true;
}


function borra_opcion(combo,indice){
	if (combo.options.length>0){
		for (var e=indice; e< combo.options.length-1; e++) {
			combo.options[e].text=combo.options[e+1].text;
			combo.options[e].value=combo.options[e+1].value;
		}
		combo.options[combo.options.length-1]=null;
	}
}

function muestra_seleccion(valor,destino){
	i=destino.length;
	for (var e=0; e<i;e++){
		if(destino.options[e].value==valor){
		destino.options[e].selected = true;
		}else{
		destino.options[e].selected = false;
		}
	}
}
//-------------------------------
function asigna_minimo(campo){
	if (campo.value!=0)	{
		if(campo.value.length==1){
			minimo1=7;
		}else {
			minimo1=6;
		}
	}else{minimo1=0;}
	return(minimo1);
}



function valida_largo(campo, minimo){
		if(campo.value.length != minimo) {
			alert("Fono debe tener " + minimo + " digitos");
			campo.select();
			campo.focus();
			return(false);
		}
	return(true);
}

function tipopago(){

}

function montocliente(){
	datos.TX_MONTOCLIENTE.disabled = false;
	datos.TX_TOTALEMP.disabled = false;
	datos.TX_TOTALCLIENTE.disabled = false;
	datos.TX_TOTAL.disabled = false;
	if (datos.TX_MONTOCLIENTE.value == ""){
		datos.TX_MONTOCLIENTE.value = 0
	}
	if (datos.TX_MONTOEMP.value == ""){
		datos.TX_MONTOEMP.value = 0
	}
	if (datos.TX_REAJUSTE.value == ""){
		datos.TX_REAJUSTE.value = 0
	}
	if (datos.TX_INTERES.value == ""){
		datos.TX_INTERES.value = 0
	}
	if (datos.TX_GRAVAMENES.value == ""){
		datos.TX_GRAVAMENES.value = 0
	}
	if (datos.TX_MULTAS.value == ""){
		datos.TX_MULTAS.value = 0
	}
	if (datos.TX_CARGOS.value == ""){
		datos.TX_CARGOS.value = 0
	}
	if (datos.TX_COSTAS.value == ""){
		datos.TX_COSTAS.value = 0
	}
	//if (datos.TX_OTROS.value == ""){
	//	datos.TX_OTROS.value = 0
	//}

	if (datos.TX_DESCLIENTE.value == ""){
		datos.TX_DESCLIENTE.value = 0
	}

	capital = eval(datos.TX_REAJUSTE.value) + eval(datos.TX_INTERES.value) + eval(datos.TX_GRAVAMENES.value) + eval(datos.TX_MULTAS.value) + eval(datos.TX_CARGOS.value)+ eval(datos.TX_COSTAS.value) + eval(datos.TX_MONTOCLIENTE.value);

	datos.TX_MONTOCLIENTE.value = eval(capital);

	if (datos.TX_DESCUENTO.value == ""){
		datos.TX_DESCUENTO.value = 0
	}
	if (datos.TX_IPCLIENTE.value == ""){
		datos.TX_IPCLIENTE.value = 0
	}
	if (datos.TX_CEMP.value == ""){
		datos.TX_CEMP.value = 0
	}

	totalcliente = (eval(capital) + eval(datos.TX_IPCLIENTE.value) + + eval(datos.TX_INDEM_COMP.value) + eval(datos.TX_GASTOSJUDICIALES.value) + eval(datos.TX_GASTOSOTROS.value) - eval(datos.TX_DESCLIENTE.value));



	totalemp = ((eval(datos.TX_MONTOEMP.value) + eval(datos.TX_CEMP.value)) - eval(datos.TX_DESCUENTO.value))
	total = (eval(totalcliente) + eval(totalemp));
	datos.TX_TOTAL.value = eval(total);
	datos.TX_TOTALCLIENTE.value = eval(totalcliente);
	datos.TX_TOTALEMP.value=eval(totalemp);
	datos.TX_MONTOCLIENTE.disabled = true;
	datos.TX_TOTALEMP.disabled = true;
	datos.TX_TOTALCLIENTE.disabled = true;
	datos.TX_TOTAL.disabled = true;
	datos.TX_REAJUSTE.value = "";
	datos.TX_INTERES.value = "";
	datos.TX_GRAVAMENES.value = "";
	datos.TX_MULTAS.value = "";
	datos.TX_CARGOS.value = "";
	datos.TX_COSTAS.value = "";
	//datos.TX_OTROS.value = "";
	//datos.TX_MONTOCLIENTE.disabled = true;
	//datos.TX_TOTAL.disabled = true;
}


function apilar_textbox_combo(origen, destino, indice){
	var ok=false;
	i=destino.length;
	valor=origen.value.length ;
	if (valor>0){
		texto=origen.value;
		valor2=origen.value;
	}else{
		texto='';
		valor2='';
	}
	if (indice < 0 ){
			var el = new Option(texto,valor2);
			destino.options[i] = el;
		}else{
			destino.options[indice].text=texto;
			destino.options[indice].value=valor2;
		}

}

function envia(){

	if(datos.intIdPago.value=='') {
		alert("Debe ingresar el Identificador del pago")
		datos.TX_RUT.focus();
	}else if (datos.CB_TIPOPAGO.value == ''){
		alert("Debe seleccionar el Tipo de Pago");
	}else if ('' == <%=intTotalGeneral%>){
		montcli=0
		monttotal=0
		for (var e=0; e<<%=intMaxCorrMas1%>;e++){
			monttotal = eval(monttotal) + eval(datos.MONTOCLI.options[e].value);
		}
		alert('Total = ' + monttotal);
		//if (eval(datos.TX_TOTALGRAL.value) != eval(monttotal)) {
		//	alert("Los montos ingresados en el detalle de documentos no son correctos : Total General :" + eval(datos.TX_TOTALGRAL.value) + " , Total Detalle = " + eval(monttotal));
		//	disa();
		//}
	}else{
		datos.action='modifica.asp';
		datos.submit();
	}
}


function ventanaSecundaria (URL){
window.open(URL,"INFORMACION","width=800, height=400, scrollbars=yes, menubar=no, location=no, resizable=yes")
}


function ventanaDetalle (URL){
window.open(URL,"DETALLEGESTION","width=800, height=300, scrollbars=yes, menubar=no, location=no, resizable=yes")
}

function chkFecha(f) {
  str = f.value
  if (str.length<10){
  	alert("Error - Ingresó una fecha no válida");
  	f.value=''
	f.focus();
  //	f.select();
  }else{
	if ( !formatoFecha(str) ) {
		alert("Debe indicar la Fecha en formato DD/MM/AAAA. Ejemplo: 'Para 20 de Diciembre de 2008 se debe ingresar 20/12/2008'");
    //f.select()
		f.value=''
		f.focus()
		return false
	}
	if ( !validarFecha(str) ) {
    // Los mensajes de error están dentro de validarFecha.
    //f.select()
   f.value=''
	f.focus()
    return false
  }
  }

  // validacion de la fecha


  return true
}

//-----------------------------------------------------------
  function validarFecha(str_fecha){

  var sl1=str_fecha.indexOf("/")
  var sl2=str_fecha.lastIndexOf("/")
  var inday = parseFloat(str_fecha.substring(0,sl1))
  var inmonth = parseFloat(str_fecha.substring(sl1+1,sl2))
  var inyear = parseFloat(str_fecha.substring(sl2+1,str_fecha.length))

  //alert("day:" + inday + ", mes:" + inmonth + ", agno: " + inyear)

  if (inmonth < 1 || inmonth > 12) {
    alert("Mes inválido en la fecha");
    return false;
  }
  if (inday < 1 || inday > diasEnMes(inmonth, inyear)) {
    alert("Día inválido en la fecha");
    return false;
  }

  return true
}


//------------------------------------------------------------------

function formatoFecha(str) {
  var sl1, sl2, ui, ddstr, mmstr, aaaastr;

  // El formato debe ser d/m/aaaa, d/mm/aaaa, dd/m/aaaa, dd/mm/aaaa,
  // Las posiciones son a partir de 0
  if (str.length < 8 &&  str.length > 10)    // el tamagno es fijo de 8, 9 o 10
    return false


  sl1=str.indexOf("/")
  if (sl1 < 1 && sl1 > 2 )    // el primer slash debe estar en la 1 o 2
    return false

  sl2=str.lastIndexOf("/")
  if (sl2 < 3 &&  sl2 > 5)    // el último slash debe estar en la 3, 4 o 5
    return false

  ddstr = str.substring(0,sl1)
  mmstr = str.substring(sl1+1,sl2)
  aaaastr = str.substring(sl2+1,str.length)

  if ( !sonDigitos(ddstr) || !sonDigitos(mmstr) || !sonDigitos(aaaastr) )
    return false

  return true
}
function sonDigitos(str) {
  var l, car

  l = str.length
  if ( l<1 )
    return false

  for ( i=0; i<l; i++) {
    car = str.substring(i,i+1)
    if ( "0" <= car &&  car <= "9" )
      continue
    else
      return false
  }
  return true
}

function diasEnMes (month, year)
{
  if (month == 1 || month == 3 || month == 5 || month == 7 || month == 8 || month == 10 || month == 12)
    return 31;
  else if (month == 2)
    // February has 29 days in any year evenly divisible by four,
      // EXCEPT for centurial years which are not also divisible by 400.
      return (  ((year % 4 == 0) && ( (!(year % 100 == 0)) || (year % 400 == 0) ) ) ? 29 : 28 );
  else if (month == 4 || month == 6 || month == 9 || month == 11)
    return 30;
  // En caso contrario:
  alert("diasEnMes: Mes inválido");
  return -1;
}
function Valida_Rut(Vrut)
{
	var dig
	Vrut = Vrut.split("-");

	if (!isNaN(Vrut[0]))
	{
		largo_rut = Vrut[0].length;
		if ((largo_rut >= 7 ) && (largo_rut <= 8))
		{
			if (largo_rut > 7)
			{
				multiplicador = 3;
			}
			else
			{
				multiplicador = 2;
			}
			suma = 0;
			contador = 0;
				do
				{
					digito = Vrut[0].charAt(contador);
					digito = Number(digito);
						if (multiplicador == 1)
						{
							multiplicador = 7;
						}

					suma = suma + (digito * multiplicador);
					multiplicador --;
					contador ++;
				}
				while (contador < largo_rut);
			resto = suma % 11
			dig_verificador = 11 - resto;

				if (dig_verificador == 10)
				{
					dig = "k";
				}
				else if (dig_verificador == 11)
				{
					dig = 0
				}
				else
				{
					dig = dig_verificador;
				}

				if (dig != Vrut[1])
				{
					alert ("El Rut es invalido !");
					datos.TX_RUT.value="";
					datos.TX_RUT.focus();
					//return 0;
				}
		}
		else
		{
			datos.TX_RUT.value="";
			datos.TX_RUT.focus();
			alert("El Rut es invalido ! ");

			//return 0;
		}
	}
	else
	{
		alert("El Rut es invalido ! ");
		datos.TX_RUT.value="";
		datos.TX_RUT.focus();
		//return 0;
	}
		//return 1;
}


function muestra_dia(){
//alert(getCurrentDate())
//alert("hola")
	var diferencia=DiferenciaFechas(datos.inicio.value)
	//alert(diferencia)
	if(datos.inicio.value!=''){
		if ((diferencia>=0)) {
			//alert('Ok')
		}else{
			alert('la fecha de compromiso debe ser mayor a la \nfecha actual')
			datos.inicio.value=''
			datos.inicio.focus()
		}
	}
}


function DiferenciaFechas (CadenaFecha1) {


   fecha_hoy = getCurrentDate() //hoy


   //Obtiene dia, mes y año
   var fecha1 = new fecha( CadenaFecha1 )
   var fecha2 = new fecha(fecha_hoy)

   //Obtiene objetos Date
   var miFecha1 = new Date( fecha1.anio, fecha1.mes, fecha1.dia )
   var miFecha2 = new Date( fecha2.anio, fecha2.mes, fecha2.dia )

   //Resta fechas y redondea
   var diferencia = miFecha1.getTime() - miFecha2.getTime()
   var dias = Math.floor(diferencia / (1000 * 60 * 60 * 24))
   var segundos = Math.floor(diferencia / 1000)
   //alert ('La diferencia es de ' + dias + ' dias,\no ' + segundos + ' segundos.')

   return dias //false
}
//---------------------------------------------------------------------
function fecha( cadena ) {

   //Separador para la introduccion de las fechas
   var separador = "/"

   //Separa por dia, mes y año
   if ( cadena.indexOf( separador ) != -1 ) {
        var posi1 = 0
        var posi2 = cadena.indexOf( separador, posi1 + 1 )
        var posi3 = cadena.indexOf( separador, posi2 + 1 )
        this.dia = cadena.substring( posi1, posi2 )
        this.mes = cadena.substring( posi2 + 1, posi3 )
        this.anio = cadena.substring( posi3 + 1, cadena.length )
   } else {
        this.dia = 0
        this.mes = 0
        this.anio = 0
   }
}
///----------------------------------------
function ValidarCorreo(strmail){
     var Email = strmail
     var Formato = /^([\w-\.])+@([\w-]+\.)+([a-z]){2,4}$/;
	 var Comparacion = Formato.test(Email);
     if(Comparacion == false){
          alert("CORREO ELECTRÓNICO NO VALIDO");
          return false;
     }
}
function asigna_minimo(campo, minimo1){
	if (campo.value!=0)	{
		if(campo.value.length==1){
			minimo1=7;
		}else if(campo.value==41 || campo.value==32){
			minimo1=7;
		}else {
			minimo1=6;
		}
	}else{minimo1=0}
	return(minimo1)
}



function valida_largo(campo, minimo){
		if(campo.value.length != minimo) {
			alert("Fono debe tener " + minimo + " digitos")
			campo.value = ""
			//campo.select()
			campo.focus()
			return(true)
		}

	return(false)
}

function asigna_minimo2(campo, minimo2){
	if (campo.value!=0)	{
		if(campo.value.length==1){
			minimo2=7;
		}else if(campo.value==41 || campo.value==32){
			minimo2=7;
		}else {
			minimo2=6;
		}
	}else{minimo2=0}
	//alert(minimo2)
	return(minimo2)
}



function valida_largo2(campo, minimo){
		if(campo.value.length != minimo) {
			alert("Fono debe tener " + minimo + " digitos")
			campo.value = ""
			//campo.select()
			campo.focus()
			return(true)
		}

	return(false)
}

function llena(valor,destino){
	i=destino.length;
	if (valor.length>0){
		if(valor=='0'){
			texto='';
		}else{
			texto=valor;
		}
	}else{
		texto='';
	}

	var el = new Option(texto,texto);
	destino.options[i] = el;
}

function llena2(texto,valor,destino){
alert(texto);
	i=destino.length;
		if (texto==''){
			texto='';
			valor='';
		}
			var el = new Option(texto,valor);
			destino.options[i] = el;
}
</script>

















