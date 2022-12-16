<%@ Language=VBScript %>
<%Response.ContentType = "application/vnd.ms-excel"%>
<!--#include file="arch_utils.asp"-->
<!--#include file="../lib/comunes/rutinas/funciones.inc" -->
<!--#include file="lib.asp"-->


<%
inicio= request.Form("inicio")
termino= request.Form("termino")
cliente = request.Form("cliente")
%>
<title>EMPRESA S.A.</title>

<style type="text/css">
<!--
.Estilo27 {color: #FFFFFF}
.Estilo28 {color: #000000}
-->
</style>
<table width="680" height="300" border="0">
  <tr>
    <td height="242" valign="top">
	<BR>

	<%
	IF not cliente="" then
	abrirscg()
	ssql="SELECT FechaIngreso,CodCategoria,CodSubCategoria,CodGestion,CodCliente,RutDeudor,FechaCompromiso,telefono_asociado FROM GESTIONES WHERE CodCobrador='"&session("session_login")&"' and codcliente='"&cliente&"' and  FechaIngreso>='"&inicio&"' and FechaIngreso<='"&termino&"' order by CodCategoria,CodSubCategoria,CodGestion"
	set rsDET=Conn.execute(ssql)
	if not rsDET.eof then
	compromisos = 0
	gestiones = 0
	telefonos = 0
	%>

	  <table width="100%" border="1" bordercolor="#FFFFFF">
        <tr bordercolor="#FFFFFF" bgcolor="#003399" class="Estilo13">
          <td width="15%" class="Estilo4">FECHA GESTION</td>
          <td width="15%" class="Estilo4">RUT DEUDOR </td>
          <td width="14%" class="Estilo4">COD. GESTION </td>
          <td width="19%" class="Estilo4">FECHA COMPROMISO</td>
          <td width="24%" class="Estilo4">CLIENTE</td>
          <td width="13%" class="Estilo4">FONO</td>
          </tr>
		  <%
		  do until rsDET.eof
		  %>
        <tr bordercolor="#FFFFFF" bgcolor="#FFFFFF" class="Estilo8">
          <td class="Estilo4"><%=rsDET("FechaIngreso")%></td>
          <td class="Estilo4"><%=rsDET("Rutdeudor")%></td>
          <td class="Estilo4"><%=rsDET("CodCategoria")%><%=rsDET("CodSubCategoria")%><%=rsDET("CodGestion")%></td>
          <td class="Estilo4"><%=rsDET("FechaCompromiso")%></td>
          <td class="Estilo4"><%
		  ssql_2="SELECT razon_social_cliente FROM CLIENTE WHERE codigo_cliente='"&rsDET("CodCliente")&"'"
		  set rsN=Conn.execute(ssql_2)
		  if not rsN.eof then
		  response.Write(rsN("razon_social_cliente"))
		  end if
		  rsN.close
		  set rsN=nothing

		  %></td>
          <td class="Estilo4"><%=rsDET("telefono_asociado")%></td>
        </tr>

		<%
		gestiones=gestiones + 1
		if rsDET("CodCategoria")= "1" and rsDET("CodSubCategoria")="2" and rsDET("CodGestion")="3" Then
		compromisos = compromisos + 1
		end if

		if not rsDET("telefono_asociado")="" then
		telefono = telefono + 1
		end if

		rsDET.movenext
		loop
		%>

      </table>
	  <%else%>
	  <%="NO EXISTEN GESTIONES ASOCIADAS AL COBRADOR"%>
	  <%END IF
	  rsDET.close
	  set rsDET=nothing
	  cerrarscg()
	  %>
	  <%end if%>
    </td>
  </tr>
</table>

