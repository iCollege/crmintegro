<% @LCID = 1034 %>
<!--#include file="arch_utils.asp"-->
<!--#include file="../lib/comunes/rutinas/funciones.inc" -->
<!--#include file="../lib/comunes/rutinas/TraeCampo.inc" -->
<!--#include file="lib.asp"-->

<%
	rut = request.QueryString("rut")
	cliente=request.QueryString("cliente")
%>
<title>DETALLE DE DEUDA</title>

<%
AbrirSCG()

	'cliente=rsClienteDeuda("CODCLIENTE")
	'nombre_cliente=rsClienteDeuda("DESCRIPCION")
%>
<table width="793" border="0" ALIGN="CENTER">
  <tr>
    <TD height="30" ALIGN=LEFT class="pasos">
		<B>Detalle Deuda&nbsp&nbsp&nbsp&nbsp<%=nombre_cliente%></B>
	</TD>
  </tr>
  <tr>
    <td valign="top">
	<%
	If Trim(rut) <> "" then
	abrirscg()
	ssql=""
	ssql="SELECT IDCUOTA,RUTDEUDOR, IsNull(FECHAVENC,'01/01/1900') as FECHAVENC, IsNull(datediff(d,fechavenc,getdate()),0) as ANTIGUEDAD, NRODOC,IsNull(VIGENTE,0) as VIGENTE, IsNull(VALORCUOTA,0) as VALORCUOTA,IsNull(SALDO,0) as SALDO,isnull(GASTOSCOBRANZAS,0) as GASTOSCOBRANZAS,IsNull(USUARIO_ASIG,0) as USUARIO_ASIG,NROCUOTA, VIGENTE, IsNull(MORA,0) as MORA, IsNull(VENCIDA,0) as VENCIDA, IsNull(CASTIGO,0) as CASTIGO, CENTRO_COSTO, SUCURSAL , ESTADO_DEUDA, CODREMESA, CUENTA, NRODOC, TIPODOCUMENTO, CONVERT(VARCHAR(10),FECHA_ESTADO,103) AS FEC_ESTADO, ADIC1 FROM CUOTA WHERE RUTDEUDOR='"&rut&"' AND CODCLIENTE='"&cliente&"' ORDER BY CODREMESA,FECHAVENC DESC"
		'response.Write(ssql)
		'response.End()
		set rsDET=Conn.execute(ssql)
		if not rsDET.eof then
		%>
		  <table width="100%" border="0" bordercolor="#FFFFFF">
	        <tr bordercolor="#999999" bgcolor="#<%=session("COLTABBG")%>" class="Estilo13">
	          <td>RUT</td>
	          <td>SEDE</td>
	          <td>NRO. DOC</td>
	          <td>F.VENCIM.</td>
	          <td>ANTIG.</td>
	          <td>TIPO DOC</td>
	          <td>ASIG.</td>
	          <td>CAPITAL</td>
	          <td>INTERES</td>
	          <td>HONORARIOS</td>
	          <td>SALDO</td>
	          <td>EJECUT.</td>
	          <td>ESTADO</td>
	          <td>F.ESTADO</td>
	          <td></td>

	        </tr>
			<%
			intSaldo = 0
			intValorCuota = 0
			total_ValorCuota = 0
			do until rsDET.eof
			intSaldo = ValNulo(rsDET("SALDO"),"N")
			intValorCuota = ValNulo(rsDET("VALORCUOTA"),"N")
			strNroDoc = Trim(rsDET("NRODOC"))
			strNroCuota = Trim(rsDET("NROCUOTA"))
			strSucursal = Trim(rsDET("SUCURSAL"))
			strEstadoDeuda = Trim(rsDET("ESTADO_DEUDA"))
			strCodRemesa = Trim(rsDET("CODREMESA"))
			strAdic1 = Trim(rsDET("ADIC1"))
			intTasaMensual = 2/100
			intTasaDiaria = intTasaMensual/30
			intAntiguedad = ValNulo(rsDET("ANTIGUEDAD"),"N")
			intIntereses = intTasaDiaria * intAntiguedad * intSaldo




			If intSaldo <= 10 * session("valor_uf")  Then
				intIntHon = 9/100
				intRemanente = intSaldo-(10 * session("valor_uf"))
				intIntHon1 = intIntHon * 10 * session("valor_uf")
			ElseIf intSaldo > 10 * session("valor_uf") and  intSaldo <= 50 * session("valor_uf") Then
				intIntHon = 6/100
				intRemanente = intSaldo-(10 * session("valor_uf"))
				intIntHon1 = intIntHon * 10 * session("valor_uf")
			ElseIf intSaldo > 50 * session("valor_uf") Then
				intIntHon = 3/100
				intRemanente = intSaldo-(10 * session("valor_uf"))
				intIntHon1 = intIntHon * 10 * session("valor_uf")
			End if




			If intRemanente <= 10 * session("valor_uf")  Then
				intIntHon = 9/100
				intRemanente2 = intRemanente-(10 * session("valor_uf"))
				intIntHon2 = intIntHon * 10 * session("valor_uf")
			ElseIf intRemanente > 10 * session("valor_uf") and  intSaldo <= 50 * session("valor_uf") Then
				intIntHon = 6/100
				intRemanente2 = intRemanente-(10 * session("valor_uf"))
				intIntHon2 = intIntHon * 10 * session("valor_uf")
			ElseIf intRemanente > 50 * session("valor_uf") Then
				intIntHon = 3/100
				intRemanente2 = intRemanente-(10 * session("valor_uf"))
				intIntHon2 = intIntHon * 10 * session("valor_uf")
			End if

			If intRemanente2 <= 10 * session("valor_uf")  Then
				intIntHon = 9/100
				intRemanente3 = intRemanente2-(10 * session("valor_uf"))
				intIntHon3 = intIntHon * 10 * session("valor_uf")
			ElseIf intRemanente2 > 10 * session("valor_uf") and  intSaldo <= 50 * session("valor_uf") Then
				intIntHon = 6/100
				intRemanente3 = intRemanente2-(10 * session("valor_uf"))
				intIntHon3 = intIntHon * 10 * session("valor_uf")
			ElseIf intRemanente2 > 50 * session("valor_uf") Then
				intIntHon = 3/100
				intRemanente3 = intRemanente2-(10 * session("valor_uf"))
				intIntHon3 = intIntHon * 10 * session("valor_uf")
			End if

			intHonorarios = intIntHon1 + intIntHon2 + intIntHon3

			Response.write "<br>intIntHon1=" & intIntHon1
			Response.write "<br>intIntHon2=" & intIntHon2
			Response.write "<br>intIntHon3=" & intIntHon3
			Response.write "<br>intRemanente=" & intRemanente
			Response.write "<br>intRemanente2=" & intRemanente2
			Response.write "<br>intRemanente3=" & intRemanente3
			Response.write "<br>intIntHon=" & intIntHon
			Response.write "<br>intSaldo=" & intSaldo

			''intHonorarios = intIntHon * intSaldo

			If trim(cliente)="1001" Then
				strDetCuota="mas_datos_deuda_vne.asp"
			Else
				strDetCuota="mas_datos_deuda_avs.asp"
			End if

			intTotalPorDoc = intHonorarios + intIntereses + intSaldo

			%>
	        <tr bordercolor="#999999" >
	          <!--td><div align="left">&nbsp</div></td-->
	          <td><div align="right"><%=rsDET("RUTDEUDOR")%></div></td>
	          <td><div align="right"><%=strAdic1%></div></td>
	          <td><div align="right"><%=rsDET("NRODOC")%></div></td>
	          <td><div align="right"><%=rsDET("FECHAVENC")%></div></td>
	          <td><div align="right"><%=rsDET("ANTIGUEDAD")%></div></td>
	          <td><div align="left"><%=rsDET("TIPODOCUMENTO")%></div></td>
	          <td><div align="right"><%=rsDET("CODREMESA")%></div></td>
	          <td align="right" >$ <%=FN((intValorCuota),0)%></td>
	          <td align="right" >$ <%=FN((intIntereses),0)%></td>
	          <td align="right" >$ <%=FN((intHonorarios),0)%></td>
	          <td align="right" >$ <%=FN((intTotalPorDoc),0)%></td>
	          <td align="right" >
	          <%If Not rsDET("USUARIO_ASIG")="0" Then %>
			  	<%=TraeCampoId(Conn, "LOGIN", rsDET("USUARIO_ASIG"), "USUARIO", "ID_USUARIO")%>
			  <%else%>
			  	<%="SIN ASIG."%>
			  <%End If%>
			  </td>
			  <td><%=TraeCampoId(Conn, "DESCRIPCION", strEstadoDeuda, "ESTADO_DEUDA", "CODIGO")%></td>
			  <td><div align="right"><%=rsDET("FEC_ESTADO")%></div></td>
			  <!--td><a href="javascript:ventanaMas('<%=strDetCuota%>?idcuota=<%=trim(rsDET("IDCUOTA"))%>&nrodoc=<%=trim(rsDET("NRODOC"))%>&cliente=<%=cliente%>&strNroDoc=<%=strNroDoc%>&strNroCuota=<%=strNroCuota%>&strSucursal=<%=strSucursal%>&strCodRemesa=<%=strCodRemesa%>')">VER</a></td-->

			  <td><a href="javascript:ventanaMas('<%=strDetCuota%>?idcuota=<%=trim(rsDET("IDCUOTA"))%>&nrodoc=<%=trim(rsDET("NRODOC"))%>&cliente=<%=cliente%>&strNroDoc=<%=strNroDoc%>&strNroCuota=<%=strNroCuota%>&strSucursal=<%=strSucursal%>&strRutDeudor=<%=rsDET("RUTDEUDOR")%>')">VER</a></td>

			 <%
				''total_vigente= total_vigente + clng(rsDET("VIGENTE"))
				''total_mora = total_mora + clng(rsDET("MORA"))
				total_vencida = total_vencida + clng(rsDET("VENCIDA"))
				total_castigo = total_castigo + clng(rsDET("CASTIGO"))
				total_saldo = total_saldo + clng(intSaldo)
				total_interes = total_interes + clng(intIntereses)
				total_honorarios = total_honorarios + clng(intHonorarios)
				total_TotalPorDoc = total_TotalPorDoc + clng(intTotalPorDoc)



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
				<td bgcolor="#<%=session("COLTABBG2")%>"><div align="right"><span class="Estilo28">$ <%=FN(total_TotalPorDoc,0)%></span></div></td>
				<td bgcolor="#<%=session("COLTABBG2")%>"><div align="right"><span class="Estilo28"></span></div></td>
				<td bgcolor="#<%=session("COLTABBG2")%>"><div align="right"><span class="Estilo28"></span></div></td>
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
window.open(URL,"DATOS","width=400, height=300, scrollbars=no, menubar=no, location=no, resizable=yes")
}
</script>
