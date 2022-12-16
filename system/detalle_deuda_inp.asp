<% @LCID = 1034 %>
<!--#include file="arch_utils.asp"-->
<!--#include file="arch_utils_carga.asp"-->
<!--#include file="lib.asp"-->
<!--#include file="sesion.asp"-->
<!--#include file="../lib/comunes/rutinas/funciones.inc" -->
<%
	rut = request.QueryString("rut")
	cliente=request.QueryString("cliente")

	rut_ora = REPLACE(cstr(rut),"-","")
	if LEN(cstr(rut_ora)) = 9 then
	rut_ora = MID(cstr(rut_ora),1,8)
	elseif LEN(cstr(rut_ora)) = 8 Then
	rut_ora = MID(cstr(rut_ora),1,7)
	elseif LEN(cstr(rut_ora)) = 7 Then
	rut_ora = MID(cstr(rut_ora),1,6)
	elseif LEN(cstr(rut_ora)) = 6 Then
	rut_ora = MID(cstr(rut_ora),1,5)
	elseif LEN(cstr(rut_ora)) = 5 Then
	rut_ora = MID(cstr(rut_ora),1,4)
	end if


	AbrirCG()
	ssql=""
	ssql="SELECT razon_social_cliente FROM CLIENTE WHERE codigo_cliente='"&cliente&"'"
	set rsCLI=ConnCG.execute(ssql)
	if not rsCLI.eof then
	nombre_cliente=rsCLI("razon_social_cliente")
	end if
	rsCLI.close
	set rsCLI=nothing
	CerrarCG()

	%>
<title>DETALLE DE DEUDA</title>
<style type="text/css">
<!--
.Estilo27 {color: #FFFFFF}
.Estilo32 {color: #FFFFFF; font-size: x-small; }
-->
</style>
<table width="760" height="420" border="0">
  <tr>
    <td height="20"><img src="../lib/DETALLE_DEUDA.gif" width="740" height="22"></td>
  </tr>
  <tr>
    <td height="20"><img src="../lib/7.gif" width="740" height="22"></td>
  </tr>
  <tr>
    <td valign="top" background="../images/fondo_coventa.jpg">
	<p align="right">
	  <%if not rut="" then%>
      <%
		abrirSCG()
		sORA = "SELECT TOP 1 NOMBRE,RUT,DIGV FROM  T_JUICIO WHERE RUT = '"&cstr(rut_ora)&"'"
					set rsDEU_o = Conn.execute(sORA)
					if not rsDEU_o.eof then
						nombre_deudor = rsDEU_o("nombre")
						rut_deudor = rut
					end if
					rsDEU_o.close
	     set rsDEU_o = nothing
		 cerrarSCG()

		abrirSCG()
		ssql=""
		ssql="SELECT TOP 1 Calle,Numero,Comuna,Correlativo FROM DEUDOR_DIRECCION WHERE RUTDEUDOR='"&rut_deudor&"' ORDER BY Correlativo DESC"
		set rsDIR=Conn.execute(ssql)
		if not rsDIR.eof then
			calle_deudor=rsDIR("Calle")
			numero_deudor=rsDIR("Numero")
			comuna_deudor=rsDIR("Comuna")
			correlativo_deudor=rsDIR("Correlativo")
		end if
		rsDIR.close
		set rsDIR=nothing
		cerrarSCG()

		abrirSCG()
		ssql=""
		ssql="SELECT TOP 1 CodArea,Telefono,Correlativo FROM DEUDOR_TELEFONO WHERE  RUTDEUDOR='"&rut_deudor&"' ORDER BY Correlativo DESC"
		set rsFON=Conn.execute(ssql)
		if not rsFON.eof then
			codarea_deudor = rsFON("CodArea")
			Telefono_deudor = rsFON("Telefono")
			Correlativo_deudor2 = rsFON("Correlativo")
		end if
		rsFON.close
		set rsFON=nothing
		cerrarSCG()

		%>
      <br>
      <strong>EJECUTIVO :</strong> <%=response.Write(session("session_login"))%>
	<table width="100%" border="0" bordercolor="#FFFFFF">
      <tr bordercolor="#999999" bgcolor="#<%=session("COLTABBG")%>" class="Estilo13">
        <td width="31%">RUT</td>
        <td width="50%">NOMBRE O RAZ&Oacute;N SOCIAL </td>
      </tr>
      <tr class="Estilo8">
        <td><%=rut_deudor%></td>
        <td><%=nombre_deudor%></td>
      </tr>
    </table>
	<table width="100%" border="0" bordercolor="#FFFFFF">
      <tr bordercolor="#999999" bgcolor="#<%=session("COLTABBG")%>" class="Estilo13">
        <td width="70%">DIRECCION</td>
        <td width="30%">TELEFONO</td>
      </tr>
      <tr class="Estilo8">
        <td>
		<%if not calle_deudor="" then%>
		<%=calle_deudor%> N&ordm; <%=numero_deudor%> - <%=comuna_deudor%>
		<%end if%>
		</td>
        <td><%if not telefono_deudor="" then%>
            <%=codarea_deudor%>-<%=telefono_deudor%>
            <%end if%></td>
      </tr>
    </table>
        <%
	abrirSCG()
	ssql=""
	ssql="select t_ddaafp.MULTAS_UF,t_ddaafp.RESOLUCION,t_juicio.CLAVIDEUDOR,t_ddaafp.FCHDECLARA,t_ddaafp.CODTASA,t_ddaafp.NROPAPELE,t_ddaafp.MES,t_ddaafp.ANO,t_ddaafp.NROMATRI,t_ddaafp.MONTO,t_juicio.DVCLA,t_ddaafp.DVMATRI from t_juicio, t_ddaafp where t_juicio.juicio = t_ddaafp.juicio and t_ddaafp.estado_deuda = '00' and T_JUICIO.RUT = '"&cstr(rut_ora)&"' and t_ddaafp.MONTO > 0"
	set rsDET=Conn.execute(ssql)
	if not rsDET.eof then
	total=0
	total_saldo=0
	total_docs=0
	total_gc=0
	intereses_t = 0
     reajustes_t = 0
	%>
      </p>
	<table width="100%" border="0" bordercolor="#FFFFFF">
        <tr bordercolor="#999999" bgcolor="#<%=session("COLTABBG")%>" class="Estilo13">
          <td width="13%"><div align="left">CLAVE ID </div></td>
          <td width="14%"><div align="left">MATRICULA</div></td>
          <td width="8%"><div align="left">DECLARA</div></td>
          <td width="6%"><div align="left">TASA</div></td>
          <td width="7%"><div align="left">SERIE</div></td>
          <td width="10%"><div align="left">PERIODO</div></td>
          <td width="10%"><div align="left">NOMINAL</div></td>
          <td width="9%"><div align="left">INTERES</div></td>
          <td width="9%"><div align="left">REAJUSTE</div></td>
          <td width="5%"><div align="left">MULTA</div></td>
          <td width="9%"><div align="left">TOTAL</div></td>
        </tr>
		<%do until rsDET.eof
		%>
        <tr bordercolor="#999999" bgcolor="#FFFFFF" >
          <td><%=rsDET("CLAVIDEUDOR")%> -<%=rsDET("DVCLA")%></td>
          <td><%=rsDET("NROMATRI")%> -<%=rsDET("DVMATRI")%></td>
          <td><%=rsDET("FCHDECLARA")%></td>
          <td><div align="center"><%=rsDET("CODTASA")%></div></td>
          <td><div align="right"><%=rsDET("NROPAPELE")%></div></td>
          <td><div align="right"><%=rsDET("MES")%> / <%=rsDET("ANO")%></div></td>
          <td><div align="right">$ <%=FN(rsDET("MONTO"),0)%></div></td>
          <td><div align="right">
		  <%

			  SORA2="SELECT TOP 1 REAJUSTE,INTERES FROM T_INTINP WHERE MES='"&rsDET("MES")&"' AND ANO='"&rsDET("ANO")&"'  ORDER BY FECHA DESC "
			  set rsINT = Conn.execute(SORA2)
			  if not rsINT.eof Then
				  reajuste = rsINT("REAJUSTE")
				  interes = rsINT("INTERES")
			  end if
			  rsINT.close
			  set rsINT = Nothing

		  inte = (Cdbl(interes) * clng(rsDET("MONTO"))/100)
		  rea =  (Cdbl(reajuste) * clng(rsDET("MONTO"))/100)

		  response.Write("$ ")
		  response.Write(FN(clng(inte),0))

		  totaldoc =clng(rsDET("MONTO")) + clng(inte) + clng(rea)
		  %>

		  </div></td>
          <td><div align="right">$ <%=FN(rea,0)%></div></td>
          <td><div align="right">$ <%=FN(CLNG(rsDET("MULTAS_UF")),0)%></div></td>
          <td bgcolor="#<%=session("COLTABBG2")%>"><div align="right">$ <%=FN(CLNG(totaldoc),0)

		  %></div></td>
        </tr>
		<%
		total= total + clng(rsDET("MONTO"))
		intereses_t = intereses_t + inte
		reajustes_t = reajustes_t + rea
		multas_t = multas_t + CLNG(rsDET("MULTAS_UF"))
		 rsDET.movenext
		 loop
		 todo = total + intereses_t + reajustes_t
		 %>

      </table>
	 	<table width="100%" border="0">
          <tr>
            <td width="27%" bgcolor="#<%=session("COLTABBG")%>">&nbsp;</td>
            <td width="31%" bgcolor="#<%=session("COLTABBG")%>"><span class="Estilo27">TOTALES</span></td>
            <td width="10%" bgcolor="#<%=session("COLTABBG2")%>"><div align="right">$ <%=FN(clng(total),0)%></div></td>
            <td width="9%" bgcolor="#<%=session("COLTABBG2")%>"><div align="right">$ <%=FN(clng(intereses_t),0)%></div></td>
            <td width="9%" bgcolor="#<%=session("COLTABBG2")%>"><div align="right">$ <%=FN(clng(reajustes_t),0)%></div></td>
            <td width="5%" bgcolor="#<%=session("COLTABBG2")%>"><div align="right">$ <%=FN(CLNG(multas_t),0)%></div></td>
            <td width="9%" bgcolor="#<%=session("COLTABBG2")%>"><div align="right">$ <%=FN(CLNG(todo),0)%></div></td>
          </tr>
        </table>
	 	<br><br>
	    <p>
 		<div align="right">
	      <%end if
	  rsDET.close
	  set rsDET=nothing
	  cerrarSCG()
	  %>
	      <br>
	      <br>
	      <strong>FECHA : <%=DATE%> HORA : <%=TIME%>
	      <%end if%>
	      </p>
          </strong>
	      <p align="left"><span class="Estilo20">
	      <input name="imp" type="button" onClick="window.print();" value="Imprimir Ficha">
	    </span>
    </div></td>
  </tr>
</table>

