<%@ Language=VBScript %>
<%Response.ContentType = "application/vnd.ms-excel"%>
<!--#include file="arch_utils.asp"-->
<!--#include file="../lib/comunes/rutinas/funciones.inc" -->
<%
inicio= request.Form("inicio")
termino= request.Form("termino")
cliente = request.Form("cliente")
ejecutivo= request.Form("ejecutivo")
hora=request.Form("hora")
%>
<title>EMPRESA S.A.</title>
<style type="text/css">
<!--
.Estilo32 {font-family: Arial, Helvetica, sans-serif}
.Estilo33 {color: #000000}
.Estilo34 {font-size: 9px}
-->
</style>
<table width="720" height="300" border="0">
  <tr>
    <td height="242" valign="top">
	<BR>

	<%
	IF not cliente="" and not ejecutivo="0" then

		if cliente="100" Then
		if ejecutivo="1" then
				if hora="0" then
						ssql="SELECT HoraIngreso,FechaIngreso,CodCategoria,CodSubCategoria,CodGestion,CodCliente,RutDeudor,FechaCompromiso,telefono_asociado,codcobrador FROM GESTIONES WHERE FechaIngreso>='"&inicio&"' and FechaIngreso<='"&termino&"'"
				else
						ssql="SELECT HoraIngreso,FechaIngreso,CodCategoria,CodSubCategoria,CodGestion,CodCliente,RutDeudor,FechaCompromiso,telefono_asociado,codcobrador FROM GESTIONES WHERE FechaIngreso>='"&inicio&"' and FechaIngreso<='"&termino&"' and datepart(hour,HoraIngreso)='"&hora&"'"
				end if
		else
				if hora="0" then
						ssql="SELECT HoraIngreso,FechaIngreso,CodCategoria,CodSubCategoria,CodGestion,CodCliente,RutDeudor,FechaCompromiso,telefono_asociado,codcobrador FROM GESTIONES WHERE CodCobrador='"&ejecutivo&"' and FechaIngreso>='"&inicio&"' and FechaIngreso<='"&termino&"'"
				else
						ssql="SELECT HoraIngreso,FechaIngreso,CodCategoria,CodSubCategoria,CodGestion,CodCliente,RutDeudor,FechaCompromiso,telefono_asociado,codcobrador FROM GESTIONES WHERE CodCobrador='"&ejecutivo&"' and FechaIngreso>='"&inicio&"' and FechaIngreso<='"&termino&"' and datepart(hour,HoraIngreso)='"&hora&"'"
				end if
		end if
	else
		if ejecutivo="1" then
				if hora="0" then
						ssql="SELECT HoraIngreso,FechaIngreso,CodCategoria,CodSubCategoria,CodGestion,CodCliente,RutDeudor,FechaCompromiso,telefono_asociado,codcobrador FROM GESTIONES WHERE codcliente='"&cliente&"' and  FechaIngreso>='"&inicio&"' and FechaIngreso<='"&termino&"'"
				else
						ssql="SELECT HoraIngreso,FechaIngreso,CodCategoria,CodSubCategoria,CodGestion,CodCliente,RutDeudor,FechaCompromiso,telefono_asociado,codcobrador FROM GESTIONES WHERE codcliente='"&cliente&"' and  FechaIngreso>='"&inicio&"' and FechaIngreso<='"&termino&"' and datepart(hour,HoraIngreso)='"&hora&"'"
				end if
		else
			if hora="0" then
				ssql="SELECT HoraIngreso,FechaIngreso,CodCategoria,CodSubCategoria,CodGestion,CodCliente,RutDeudor,FechaCompromiso,telefono_asociado,codcobrador FROM GESTIONES WHERE CodCobrador='"&ejecutivo&"' and codcliente='"&cliente&"' and  FechaIngreso>='"&inicio&"' and FechaIngreso<='"&termino&"'"
			else
				ssql="SELECT HoraIngreso,FechaIngreso,CodCategoria,CodSubCategoria,CodGestion,CodCliente,RutDeudor,FechaCompromiso,telefono_asociado,codcobrador FROM GESTIONES WHERE CodCobrador='"&ejecutivo&"' and codcliente='"&cliente&"' and  FechaIngreso>='"&inicio&"' and FechaIngreso<='"&termino&"' and datepart(hour,HoraIngreso)='"&hora&"'"
			end if
		end if
	end if

	abrirscg()
	set rsDET=Conn.execute(ssql)
	if not rsDET.eof then
	compromisos = 0
	gestiones = 0
	telefonos = 0
	%>

	  <table width="100%" border="1">
        <tr class="Estilo13">
          <td width="13%" class="Estilo4 Estilo29 Estilo31 Estilo32 Estilo33 Estilo34">COBRADOR</td>
          <td width="13%" class="Estilo4 Estilo29 Estilo31 Estilo32 Estilo33 Estilo34">FECHA GESTION</td>
          <td width="13%" class="Estilo4 Estilo29 Estilo31 Estilo32 Estilo33 Estilo34">HORA</td>
          <td width="13%" class="Estilo4 Estilo29 Estilo31 Estilo32 Estilo33 Estilo34">RUT DEUDOR </td>
          <td width="8%" class="Estilo4 Estilo29 Estilo31 Estilo32 Estilo33 Estilo34">GESTION</td>
          <td width="15%" class="Estilo4 Estilo29 Estilo31 Estilo32 Estilo33 Estilo34">FECHA COMPROMISO</td>
          <td width="14%" class="Estilo4 Estilo29 Estilo31 Estilo32 Estilo33 Estilo34">CLIENTE</td>
          <td width="24%" class="Estilo4 Estilo29 Estilo31 Estilo32 Estilo33 Estilo34">FONO</td>
          </tr>
		  <%
		  do until rsDET.eof
		  %>
        <tr bgcolor="#FFFFFF" class="Estilo8">
          <td class="Estilo4 Estilo29 Estilo31 Estilo32 Estilo33 Estilo34"><%=rsDET("codcobrador")%></td>
          <td class="Estilo4 Estilo29 Estilo31 Estilo32 Estilo33 Estilo34"><%=rsDET("FechaIngreso")%></td>
          <td class="Estilo4 Estilo29 Estilo31 Estilo32 Estilo33 Estilo34"><%=rsDET("HoraIngreso")%></td>
          <td class="Estilo4 Estilo29 Estilo31 Estilo32 Estilo33 Estilo34"><%=rsDET("Rutdeudor")%></td>
          <td class="Estilo4 Estilo29 Estilo31 Estilo32 Estilo33 Estilo34"><%=rsDET("CodCategoria")%><%=rsDET("CodSubCategoria")%><%=rsDET("CodGestion")%></td>
          <td class="Estilo4 Estilo29 Estilo31 Estilo32 Estilo33 Estilo34"><%=rsDET("FechaCompromiso")%></td>
          <td class="Estilo4 Estilo29 Estilo31 Estilo32 Estilo33 Estilo34"><%
		  ssql_2="SELECT razon_social_cliente FROM CLIENTE WHERE codigo_cliente='"&rsDET("CodCliente")&"'"
		  set rsN=Conn.execute(ssql_2)
		  if not rsN.eof then
		  response.Write(rsN("razon_social_cliente"))
		  end if
		  rsN.close
		  set rsN=nothing

		  %></td>
          <td class="Estilo4 Estilo29 Estilo31 Estilo32 Estilo33 Estilo34"><%=rsDET("telefono_asociado")%></td>
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

