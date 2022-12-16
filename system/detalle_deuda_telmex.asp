<% @LCID = 1034 %>
<!--#include file="arch_utils.asp"-->
<!--#include file="../lib/comunes/rutinas/funciones.inc" -->
<!--#include file="lib.asp"-->

<%
	rut = request.QueryString("rut")
	cliente=request.QueryString("cliente")
    abrirscg()
	ssql=""
	ssql="SELECT razon_social_cliente FROM CLIENTE WHERE codigo_cliente='"&cliente&"'"
	set rsCLI=Conn.execute(ssql)
	if not rsCLI.eof then
	nombre_cliente=rsCLI("razon_social_cliente")
	end if
	rsCLI.close
	set rsCLI=nothing
	cerrarscg()

	%>
<title>DETALLE DE DEUDA</title>
<table width="640" height="420" border="0">
  <tr>
    <td height="20" class="Estilo20"><img src="../lib/DETALLE_DEUDA.gif" width="640" height="22"></td>
  </tr>
  <tr>
    <td height="20" class="Estilo20"><img src="../lib/<%=cliente%>.gif" width="640" height="22"></td>
  </tr>
  <tr>
    <td valign="top" background="../images/fondo_coventa.jpg">
	<%
	if not rut="" then
	abrirscg()
	ssql=""
	ssql="SELECT FECHAVENC,NRODOC,VALORCUOTA,SALDO,isnull(GASTOSCOBRANZAS,0) as GASTOSCOBRANZAS,FECHAEMISION,CODCOBRADOR,NROCUOTA FROM CUOTA WHERE RUTDEUDOR='"&rut&"' AND CODCLIENTE='"&cliente&"'"
	'response.Write(ssql)
	'response.End()
	set rsDET=Conn.execute(ssql)
	if not rsDET.eof then
	%>
	  <table width="100%" border="0" bordercolor="#FFFFFF">
        <tr bordercolor="#999999" bgcolor="#<%=session("COLTABBG")%>" class="Estilo13">
          <td width="15%">DOCUMENTO</td>
		  <td width="8%">EMPRESA</td>
          <td width="8%">T.DOC</td>
		  <td width="8%">FECHA EMI</td>
		  <td width="8%">FECHA VENC</td>
          <td width="12%">MONTO</td>
          <td width="12%">SALDO</td>
          <td width="12%">G.COBRANZAS</td>
          <td width="12%">COBRADOR</td>

        </tr>
		<%do until rsDET.eof
		%>

		<%

	ssql=""
	ssql="select top 1 * from car_telmex where rutdeudor='"&rut&"' and nrodoc= " & rsDET("NRODOC")
	'response.Write(ssql)
	'response.End()
	set rsDET1=Conn.execute(ssql)
	if not rsDET1.eof then
	tipo_doc=rsDET1("desc_tipo_doc")
		if tipo_doc = "FACT" then
			tipo_fac = "FACTURA INTERNET"
		end if
		if tipo_doc = "FAMU" then
			tipo_fac = "FACTURA MULTICARRIER"
		end if
		if tipo_doc = "FACM" then
			tipo_fac = "FACTURA MANUAL"
		end if
		if tipo_doc = "FTEL" then
			tipo_fac = "FACTURA TELEFONIA FIJA"
		end if
		if tipo_doc = "FEXE" then
			tipo_fac = "FACTURA EXENTA DE IMPUESTO"
		end if

		if rsDET1("cod_emp_cob")= 1 then
			empresa="TELMEX CORP"
		end if

		if rsDET1("cod_emp_cob")= 2 then
			empresa="TELMEX SA"
		end if

		if rsDET1("cod_emp_cob")= 3 then
			empresa="TELMEX SERVICIOS EMPRESARIALES "
		end if

		if rsDET1("cod_emp_cob")= 11 then
			empresa="TELMEX LONG DISTANCE"
		end if

		if rsDET1("cod_emp_cob")= 12 then
			empresa="TELMEX INTERNET"
		end if

		if rsDET1("cod_emp_cob")= 13 then
			empresa="TELMEX NETWORK"
		end if
	end if
	rsDET1.close
	set rsDET1=nothing


		%>
		<tr bordercolor="#999999" >
          <td>N&ordm; <%=rsDET("NRODOC")%></td>
		  <td><%=empresa%></td>
		  <td><%=tipo_fac%></td>
		  <td><div align="left" >  <%=FormatDateTime(rsDET("FECHAEMISION"),2)%></div></td>
          <td><div align="left" >  <%=FormatDateTime(rsDET("FECHAVENC"),2)%></div></td>

          <td><div align="right">$ <%=FN(rsDET("VALORCUOTA"),0)%></div></td>
          <td><div align="right">$ <%=FN(rsDET("SALDO"),0)%></div></td>
          <td><div align="right" >$ <%
		  if not isnull(rsDET("GASTOSCOBRANZAS")) then
		  response.Write(FN(rsDET("GASTOSCOBRANZAS"),0))
		  else
		  response.Write("0")
		  end if
		  %></div></td>
          <td><div align="right" ><%If Not rsDET("CODCOBRADOR")="0" Then %>
		  <%=rsDET("CODCOBRADOR")%>
		  <%else%>
		  <%="SIN COBRADOR"%>
		  <%End If%>
		  </div></td>
		 <%
			total= total + clng(rsDET("VALORCUOTA"))
		total_saldo = total_saldo + clng(rsDET("SALDO"))
		total_gc = total_gc + clng(rsDET("GASTOSCOBRANZAS"))
		total_docs = total_docs + 1
			%></tr>
		 <%rsDET.movenext
		 loop
		 %>
		 <tr>
          <td  bgcolor="#<%=session("COLTABBG2")%>"><span class="Estilo27">DOCUMENTOS : <%=total_docs%></span></td>
          <td  bgcolor="#<%=session("COLTABBG")%>"><div align="right"><span class="Estilo28"></span></div></td>
		  <td  bgcolor="#<%=session("COLTABBG")%>"><div align="right"><span class="Estilo28"></span></div></td>
		  <td  bgcolor="#<%=session("COLTABBG")%>"><div align="right"><span class="Estilo28"></span></div></td>
		  <td  bgcolor="#<%=session("COLTABBG")%>"><div align="right"><span class="Estilo28"></span></div></td>
          <td  bgcolor="#<%=session("COLTABBG2")%>"><div align="right"><span class="Estilo28">$ <%=FN(total,0)%></span></div></td>
		  <td  bgcolor="#<%=session("COLTABBG2")%>"><div align="right"><span class="Estilo27">$ <%=FN(total_saldo,0)%></span></div></td>
          <td  bgcolor="#<%=session("COLTABBG2")%>"><div align="right"><span class="Estilo28">$ <%=FN(total_gc,0)%></span></div></td>
          <td  bgcolor="#<%=session("COLTABBG")%>"><div align="right"><span class="Estilo28"></span></div></td>
        </tr>

      </table>
	  <%end if
	  rsDET.close
	  set rsDET=nothing
	  cerrarscg()
	  %>
	  <%end if%>
    </td>
  </tr>
  <tr>
<td>
<input name="imp" type="button" onClick="window.print();" value="Imprimir Ficha">
</td>
</tr>
</table>
<script language="JavaScript" type="text/JavaScript">
function ventanaMas (URL){
window.open(URL,"DATOS","width=200, height=300, scrollbars=no, menubar=no, location=no, resizable=yes")
}
</script>
