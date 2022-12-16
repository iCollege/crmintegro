<% @LCID = 1034 %>
<!--#include file="arch_utils.asp"-->
<!--#include file="../lib/comunes/rutinas/funciones.inc" -->
<!--#include file="../lib/comunes/rutinas/TraeCampo.inc" -->
<!--#include file="lib.asp"-->

<%
	rut = request.QueryString("rut")
	cliente=request.QueryString("cliente")
%>
<title>DETALLE DE CHEQUES PROTESTADOS</title>

<%
AbrirSCG()
%>
<table width="900" border="0" ALIGN="CENTER">
  <tr>
    <TD height="30" ALIGN=LEFT class="pasos">
		<B>Detalle Cheques Protestados&nbsp&nbsp&nbsp&nbsp<%=nombre_cliente%></B>
	</TD>
  </tr>
  <tr>
    <td valign="top">
	<%
	If Trim(rut) <> "" then
	abrirscg()
	ssql=""
	ssql="SELECT IDCUOTA,RUTDEUDOR, IsNull(FECHAVENC,'01/01/1900') as FECHAVENC, IsNull(datediff(d,fechavenc,getdate()),0) as ANTIGUEDAD, NRODOC,IsNull(VIGENTE,0) as VIGENTE, IsNull(VALORCUOTA,0) as VALORCUOTA,IsNull(SALDO,0) as SALDO,isnull(GASTOSCOBRANZAS,0) as GASTOSCOBRANZAS,IsNull(USUARIO_ASIG,0) as USUARIO_ASIG,NROCUOTA, VIGENTE, IsNull(MORA,0) as MORA, IsNull(VENCIDA,0) as VENCIDA, IsNull(CASTIGO,0) as CASTIGO, CENTRO_COSTO, SUCURSAL , ESTADO_DEUDA, CODREMESA, CUENTA, NRODOC, TIPODOCUMENTO, CONVERT(VARCHAR(10),FECHA_ESTADO,103) AS FEC_ESTADO, ADIC1 AS PROTESTO,FECHA_PROTESTO,ADIC2 AS BANCO,ADIC3 AS RUT_DEUDOR, ADIC4 AS TIPO_CHEQUE FROM CUOTA WHERE RUTDEUDOR='"&rut&"' AND CODCLIENTE='"&cliente&"' ORDER BY CODREMESA,FECHAVENC DESC"
		'response.Write(ssql)
		'response.End()
		set rsDET=Conn.execute(ssql)
		if not rsDET.eof then
		%>
		  <table width="100%" border="0" bordercolor="#FFFFFF">
	        <tr bordercolor="#999999" bgcolor="#<%=session("COLTABBG")%>" class="Estilo13">
	          <td width="6%">RUT</td>
	          <td width="6%">NRO. DOC</td>
	          <td width="6%">F.VENCIM.</td>
	          <td width="6%">F.PROTESTO</td>
	          <td width="10%">MOTIVO PROTESTO</td>
	          <td width="6%">BANCO</td>
	          <td width="6%">RUT DEUDA</td>
	          <td width="6%">TIPO</td>
	          <td width="6%">ANTIG.</td>
	          <td width="6%">TIPO DOC.</td>
	          <td width="6%">ASIG.</td>
	          <td width="6%">DEUDA ORIG.</td>
			  <td width="6%">SALDO</td>
			  <td width="6%">EJECUTIVO</td>
			  <td width="6%">ESTADO</td>
			  <td width="6%">F.ESTADO</td>

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

			strDetCuota="mas_datos_cheques_protestado.asp"
			
			%>
	        <tr bordercolor="#999999">
	          <td align="right"><a href="javascript:ventanaMas('<%=strDetCuota%>?idcuota=<%=trim(rsDET("IDCUOTA"))%>&nrodoc=<%=trim(rsDET("NRODOC"))%>&cliente=<%=cliente%>&strNroDoc=<%=strNroDoc%>&strNroCuota=<%=strNroCuota%>&strSucursal=<%=strSucursal%>&strRutDeudor=<%=rsDET("RUTDEUDOR")%>')"><%=rsDET("RUTDEUDOR")%></a></td>
	          <td align="right"><%=rsDET("NRODOC")%></td>
	          <td align="right"><%=rsDET("FECHAVENC")%></td>
	          <td align="right"><%=rsDET("FECHA_PROTESTO")%></td>
	          <td align="right"><%=rsDET("PROTESTO")%></td>
	          <td align="right"><%=rsDET("BANCO")%></td>
			  <td align="right"><%=rsDET("RUT_DEUDOR")%></td>
			  <td align="right"><%=rsDET("TIPO_CHEQUE")%></td>
			  <td align="right"><%=rsDET("ANTIGUEDAD")%></td>
	          <td align="right"><%=rsDET("TIPO_CHEQUE")%></td>
	          <td align="right"><%=rsDET("CODREMESA")%></td>
	          <td align="right">$ <%=FN((intValorCuota),0)%></td>
			  <td align="right">$ <%=FN((intSaldo),0)%></td>
			  <td align="right">
			  <%If Not rsDET("USUARIO_ASIG")="0" Then %>
			  	<%=TraeCampoId(Conn, "LOGIN", rsDET("USUARIO_ASIG"), "USUARIO", "ID_USUARIO")%>
			  <%else%>
			  	<%="SIN ASIG."%>
			  <%End If%></td>
			  <td align="right"><%=TraeCampoId(Conn, "DESCRIPCION", strEstadoDeuda, "ESTADO_DEUDA", "CODIGO")%></td>
			  <td align="center"><%=rsDET("FEC_ESTADO")%></td>
			 <%
				total_vencida = total_vencida + clng(rsDET("VENCIDA"))
				total_castigo = total_castigo + clng(rsDET("CASTIGO"))
				total_saldo = total_saldo + clng(intSaldo)
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
				<td bgcolor="#<%=session("COLTABBG2")%>"><div align="right"><span class="Estilo28">&nbsp</span></div></td>
				<td bgcolor="#<%=session("COLTABBG2")%>"><div align="right"><span class="Estilo27">&nbsp</span></div></td>
				<td bgcolor="#<%=session("COLTABBG2")%>"><div align="right"><span class="Estilo27">&nbsp</span></div></td>
				<td bgcolor="#<%=session("COLTABBG2")%>"><div align="right"><span class="Estilo27">&nbsp</span></div></td>
				<td bgcolor="#<%=session("COLTABBG2")%>"><div align="right"><span class="Estilo27">&nbsp</span></div></td>
				<td bgcolor="#<%=session("COLTABBG2")%>"><div align="right"><span class="Estilo28">$ <%=FN(total_ValorCuota,0)%></span></div></td>
				<td bgcolor="#<%=session("COLTABBG2")%>"><div align="right"><span class="Estilo28">$ <%=FN(total_saldo,0)%></span></div></td>
				<td bgcolor="#<%=session("COLTABBG2")%>"><div align="right"><span class="Estilo28"></span></div></td>
				<td bgcolor="#<%=session("COLTABBG2")%>"><div align="right"><span class="Estilo28"></span></div></td>
				<td bgcolor="#<%=session("COLTABBG2")%>"><div align="right"><span class="Estilo28"></span></div></td>
				<td bgcolor="#<%=session("COLTABBG2")%>"><div align="right"><span class="Estilo28"></span></div></td>
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
