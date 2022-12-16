<% @LCID = 1034 %>
<!--#include file="arch_utils.asp"-->
<!--#include file="asp/comunes/general/RutinasVarias.inc" -->
<!--#include file="../lib/comunes/rutinas/TraeCampo.inc" -->
<!--#include file="lib.asp"-->

<%
	rut = request.QueryString("rut")
	cliente=request.QueryString("cliente")
	intCodEstado = request.QueryString("intCodEstado")
%>
<title>DETALLE DE DEUDA</title>

<%
AbrirSCG()

	'cliente=rsClienteDeuda("CODCLIENTE")
	'nombre_cliente=rsClienteDeuda("DESCRIPCION")
%>
<table width="1140" border="0" ALIGN="CENTER">
  <tr>
    <tr height="30" bordercolor="#999999" bgcolor="#<%=session("COLTABBG")%>" class="Estilo13">
    <TD ALIGN="center">
		<B>DETALLE DEUDA&nbsp&nbsp&nbsp&nbsp<%=nombre_cliente%></B>
	</TD>
  </tr>
  <tr>
    <td valign="top">
	<%
	If Trim(rut) <> "" then
	abrirscg()



	strSql="SELECT IsNull(ADIC1,'ADIC1') as ADIC1, IsNull(ADIC2,'ADIC2') as ADIC2, IsNull(ADIC3,'ADIC3') as ADIC3, IsNull(ADIC4,'ADIC4') as ADIC4, IsNull(ADIC5,'ADIC5') as ADIC5, IsNull(ADIC91,'ADIC91') as ADIC91, IsNull(ADIC92,'ADIC92') as ADIC92, IsNull(ADIC93,'ADIC93') as ADIC93, IsNull(ADIC94,'ADIC94') as ADIC94, IsNull(ADIC95,'ADIC95') as ADIC95, USA_CUSTODIO, IsNull(COLOR_CUSTODIO,'FFFFFF') as COLOR_CUSTODIO, INTERES_MORA, COD_TIPODOCUMENTO_HON FROM CLIENTE WHERE CODCLIENTE = '" & cliente & "'"
	'response.write "strSql=" & strSql
	'Response.End
	set rsDET=Conn.execute(strSql)
	if Not rsDET.eof Then
		strNombreAdic1 = Mid(rsDET("ADIC1"),1,10)
		strNombreAdic2 = Mid(rsDET("ADIC2"),1,10)
		strNombreAdic3 = Mid(rsDET("ADIC3"),1,10)
		strUsaCustodio = rsDET("USA_CUSTODIO")
		intTasaMensual = ValNulo(rsDET("INTERES_MORA"),"C")
		intTipoDocHono = ValNulo(rsDET("COD_TIPODOCUMENTO_HON"),"C")
		strNoHon = "S"
		strNoInt = "S"
	end if
	If intTasaMensual = "" Then
		%>
		<SCRIPT>alert('No se ha definido tasa de interes de mora, se ocupara una tasa del 2%, favor parametrizar')</SCRIPT>
		<%
		intTasaMensual = "2"
	End If

	ssql=""
	ssql = "SELECT IDCUOTA,RUTDEUDOR, DATEDIFF(MONTH,FECHAVENC,GETDATE()) AS ANT_MESES, IsNull(FECHAVENC,'01/01/1900') as FECHAVENC, IsNull(datediff(d,fechavenc,getdate()),0) as ANTIGUEDAD, NRODOC,IsNull(VIGENTE,0) as VIGENTE, IsNull(VALORCUOTA,0) as VALORCUOTA,IsNull(SALDO,0) as SALDO,isnull(GASTOSCOBRANZAS,0) as GASTOSCOBRANZAS,IsNull(USUARIO_ASIG,0) as USUARIO_ASIG,NROCUOTA, VIGENTE, IsNull(GASTOSPROTESTOS,0) as GASTOSPROTESTOS, IsNull(VENCIDA,0) as VENCIDA, IsNull(CASTIGO,0) as CASTIGO, CENTRO_COSTO, SUCURSAL , ESTADO_DEUDA, CODREMESA, CUENTA, NRODOC, TIPODOCUMENTO, CONVERT(VARCHAR(10),FECHA_ESTADO,103) AS FEC_ESTADO, ADIC1, ADIC2, ADIC3, IsNull(CUSTODIO,'') as CUSTODIO, NOM_TIPO_DOCUMENTO FROM CUOTA, TIPO_DOCUMENTO WHERE RUTDEUDOR='"&rut&"' AND CODCLIENTE='"&cliente&"' AND CUOTA.TIPODOCUMENTO = TIPO_DOCUMENTO.COD_TIPO_DOCUMENTO "
	If Trim(intCodEstado) <> "" Then
		ssql = ssql & " AND ESTADO_DEUDA = " & intCodEstado
	End If

	ssql = ssql & " ORDER BY FECHAVENC DESC"
		'response.Write(ssql)
		'response.End()
		set rsDET=Conn.execute(ssql)
		if not rsDET.eof then
		%>
		  <table width="100%" border="0" bordercolor="#FFFFFF">
	        <tr bordercolor="#999999" bgcolor="#<%=session("COLTABBG")%>" class="Estilo13">
	          <td>ID</td>
	          <td>RUT</td>
	          <td>CUENTA</td>
	          <td>NRO. DOC</td>
	          <td>F.VENCIM.</td>
	          <td>ANTIG.</td>
	          <td>TIPO DOC</td>
	          <td>ASIG.</td>
	          <td>CAPITAL</td>
	          <td>INTERES</td>
	          <td>HONORARIOS</td>
	          <td>PROTESTO</td>
	          <td>SALDO</td>
	          <td>EJECUT.</td>
	          <td>ESTADO</td>
	          <td>F.ESTADO</td>
	          <% If Trim(strUsaCustodio) = "S" Then %>
	          <td>CUSTODIO</td>
	          <% End If%>
	          <td><%=strNombreAdic1%></td>
	          <td><%=strNombreAdic2%></td>
	          <!--td><%=strNombreAdic3%></td-->
	          <td></td>


	        </tr>
			<%
			intSaldo = 0
			intValorCuota = 0
			total_ValorCuota = 0
			intTasaMensual = intTasaMensual/100
			intTasaDiaria = intTasaMensual/30

			Do until rsDET.eof
			intSaldo = Round(session("valor_moneda") * ValNulo(rsDET("SALDO"),"N"),0)
			intValorCuota = Round(session("valor_moneda") * ValNulo(rsDET("VALORCUOTA"),"N"),0)
			intProtesto = Round(session("valor_moneda") * ValNulo(rsDET("GASTOSPROTESTOS"),"N"),0)
			strNroDoc = Trim(rsDET("NRODOC"))
			strNroCuota = Trim(rsDET("NROCUOTA"))
			strSucursal = Trim(rsDET("SUCURSAL"))
			strEstadoDeuda = Trim(rsDET("ESTADO_DEUDA"))
			strCodRemesa = Trim(rsDET("CODREMESA"))
			strAdic1 = Trim(rsDET("ADIC1"))
			strAdic2 = Trim(rsDET("ADIC2"))
			strAdic3 = Trim(rsDET("ADIC3"))

			''Response.write "intProtesto = " & intProtesto

			If Trim(strEstadoDeuda) = "1"  Then

				intAntiguedad = ValNulo(rsDET("ANTIGUEDAD"),"N")
				If intAntiguedad > 0 Then
					intIntereses = intTasaDiaria * intAntiguedad * intSaldo
					If Trim(intTipoDocHono) = Trim(rsDET("TIPODOCUMENTO")) Then
						intCMeses = rsDET("ANT_MESES")
						intHonorarios = GastosCobranzas(HonorariosEspeciales1(intSaldo,intCMeses))
					Else
						intHonorarios = GastosCobranzas(intSaldo)
					End If
				Else
					intIntereses = 0
					intHonorarios = 0
					intProtesto = 0
				End If
			ElseIf (Trim(strEstadoDeuda) = "7" or Trim(strEstadoDeuda) = "8") Then
				''Response.write "intSaldo = " & intSaldo

				If intSaldo <> 0 Then
					intProtesto = 0
				End If
				intIntereses = 0
				intHonorarios = 0
			Else
				intIntereses = 0
				intHonorarios = 0
				intProtesto = 0
				intSaldo = 0
			End If

			If Trim(strNoHon) = "S" Then
				intHonorarios = 0
			End If
			If Trim(strNoInt) = "S" Then
				intIntereses = 0
			End If

			''Response.write "intProtesto = " & intProtesto

			If Trim(strUsaCustodio) = "S" and Trim(rsDET("CUSTODIO")) <> "" Then
				intHonorarios = 0
				strBgColor="#" & strColorCustodio
			Else
				strBgColor="#FFFFFF"
			End if




			strDetCuota="mas_datos_adicionales.asp"

			intTotalPorDoc = intHonorarios + intIntereses + intProtesto + intSaldo

			%>
	        <tr bordercolor="#999999" bgcolor="<%=strBgColor%>">
	          <!--td><div align="left">&nbsp</div></td-->
	          <td><div align="right"><%=rsDET("IDCUOTA")%></div></td>
	          <td><div align="right"><%=rsDET("RUTDEUDOR")%></div></td>
	          <td><div align="right"><%=rsDET("CUENTA")%></div></td>
	          <td><div align="right"><%=rsDET("NRODOC")%></div></td>
	          <td><div align="right"><%=rsDET("FECHAVENC")%></div></td>
	          <td><div align="right"><%=rsDET("ANTIGUEDAD")%></div></td>
	          <td><div align="left"><%=Mid(rsDET("NOM_TIPO_DOCUMENTO"),1,10)%></div></td>
	          <td><div align="right"><%=rsDET("CODREMESA")%></div></td>
	          <td align="right" >$ <%=FN((intValorCuota),0)%></td>
	          <td align="right" >$ <%=FN((intIntereses),0)%></td>
	          <td align="right" >$ <%=FN((intHonorarios),0)%></td>
	          <td align="right" >$ <%=FN((intProtesto),0)%></td>
	          <td align="right" >$ <%=FN((intTotalPorDoc),0)%></td>
	          <td align="right" >
	          <%If Not rsDET("USUARIO_ASIG")="0" Then %>
			  	<%=TraeCampoId(Conn, "LOGIN", rsDET("USUARIO_ASIG"), "USUARIO", "ID_USUARIO")%>
			  <%else%>
			  	<%="SIN ASIG."%>
			  <%End If%>
			  </td>
			  <td><%=TraeCampoId(Conn, "DESCRIPCION", strEstadoDeuda, "ESTADO_DEUDA", "CODIGO")%></td>
			  <td><div align="left"><%=rsDET("FEC_ESTADO")%></div></td>
			  <% If Trim(strUsaCustodio) = "S" Then %>
				  <% If Trim(rsDET("CUSTODIO")) = "" Then%>
					<td><div align="left">&nbsp;</td>
				  <% Else%>
					<td><div align="left"><img src="../images/bolita7x8.jpg" border="0">&nbsp;<%=rsDET("CUSTODIO")%></div></td>
				  <% End If%>
			  <% End If%>
			  <td><div align="left"><%=Mid(strAdic1,1,10)%></div></td>
			  <td><div align="left"><%=Mid(strAdic2,1,10)%></div></td>
			  <!--td><div align="left"><%=Mid(strAdic3,1,10)%></div></td-->


			  <td><a href="javascript:ventanaMas('<%=strDetCuota%>?idcuota=<%=trim(rsDET("IDCUOTA"))%>&nrodoc=<%=trim(rsDET("NRODOC"))%>&cliente=<%=cliente%>&strNroDoc=<%=strNroDoc%>&strNroCuota=<%=strNroCuota%>&strSucursal=<%=strSucursal%>&strRutDeudor=<%=rsDET("RUTDEUDOR")%>')">VER</a></td>

			 <%
				''total_vigente= total_vigente + clng(rsDET("VIGENTE"))
				''total_mora = total_mora + clng(rsDET("MORA"))
				total_vencida = total_vencida + clng(rsDET("VENCIDA"))
				total_castigo = total_castigo + clng(rsDET("CASTIGO"))
				total_saldo = total_saldo + ValNulo(intSaldo,"N")
				total_interes = total_interes + ValNulo(intIntereses,"N")
				total_protestos = total_protestos + ValNulo(intProtesto,"N")
				total_honorarios = total_honorarios + ValNulo(intHonorarios,"N")
				total_TotalPorDoc = total_TotalPorDoc + ValNulo(intTotalPorDoc,"N")



				total_ValorCuota = total_ValorCuota + intValorCuota
				total_gc = total_gc + clng(rsDET("GASTOSCOBRANZAS"))
				total_docs = total_docs + 1



			 %>
			 </tr>
			 <%rsDET.movenext
			 loop
			 %>
			<tr>
				<td bgcolor="#<%=session("COLTABBG")%>">&nbsp</td>
				<td bgcolor="#<%=session("COLTABBG")%>"><span class="Estilo13">Docs : <%=total_docs%></span></td>
				<!--td bgcolor="#<%=session("COLTABBG")%>"><span class="Estilo13"></span></td-->
				<td bgcolor="#<%=session("COLTABBG2")%>"><div align="right"><span class="Estilo28">&nbsp</span></div></td>
				<td bgcolor="#<%=session("COLTABBG2")%>"><div align="right"><span class="Estilo27">&nbsp</span></div></td>
				<td bgcolor="#<%=session("COLTABBG2")%>"><div align="right"><span class="Estilo27">&nbsp</span></div></td>
				<td bgcolor="#<%=session("COLTABBG2")%>"><div align="right"><span class="Estilo27">&nbsp</span></div></td>
				<td bgcolor="#<%=session("COLTABBG2")%>"><div align="right"><span class="Estilo27">&nbsp</span></div></td>
				<td bgcolor="#<%=session("COLTABBG2")%>"><div align="right"><span class="Estilo28">$ <%=FN(total_ValorCuota,0)%></span></div></td>
				<td bgcolor="#<%=session("COLTABBG2")%>"><div align="right"><span class="Estilo28">$ <%=FN(total_interes,0)%></span></div></td>
				<td bgcolor="#<%=session("COLTABBG2")%>"><div align="right"><span class="Estilo28">$ <%=FN(total_honorarios,0)%></span></div></td>
				<td bgcolor="#<%=session("COLTABBG2")%>"><div align="right"><span class="Estilo28">$ <%=FN(total_protestos,0)%></span></div></td>
				<td bgcolor="#<%=session("COLTABBG2")%>"><div align="right"><span class="Estilo28">$ <%=FN(total_TotalPorDoc,0)%></span></div></td>
				<td bgcolor="#<%=session("COLTABBG2")%>"><div align="right"><span class="Estilo28"></span></div></td>
				<td bgcolor="#<%=session("COLTABBG2")%>"><div align="right"><span class="Estilo28"></span></div></td>
				<td bgcolor="#<%=session("COLTABBG2")%>"><div align="right"><span class="Estilo28"></span></div></td>
				<td bgcolor="#<%=session("COLTABBG2")%>"><div align="right"><span class="Estilo28"></span></div></td>
				<td bgcolor="#<%=session("COLTABBG2")%>"><div align="right"><span class="Estilo28"></span></div></td>
				<td bgcolor="#<%=session("COLTABBG2")%>"><div align="right"><span class="Estilo28"></span></div></td>
				<% If Trim(strUsaCustodio) = "S" Then %>
					<td bgcolor="#<%=session("COLTABBG2")%>"><div align="right"><span class="Estilo28"></span></div></td>
				<% End If%>
				<td bgcolor="#<%=session("COLTABBG2")%>"><div align="right"><span class="Estilo28"></span></div></td>

			</tr>

	      </table>
		  <%end if
		  rsDET.close
		  set rsDET=nothing

	  %>
	  <%end if%>
    </td>
  </tr>
  <tr>
<td ALIGN="center">
<input name="imp" type="button" onClick="window.print();" value="Imprimir Ficha">
</td>
</tr>
</table>

<%
cerrarSCG()
%>





<script language="JavaScript" type="text/JavaScript">
function ventanaMas (URL){
window.open(URL,"DATOS","width=400, height=400, scrollbars=no, menubar=no, location=no, resizable=yes")
}
</script>
