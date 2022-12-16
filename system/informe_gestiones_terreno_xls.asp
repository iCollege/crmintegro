<%@ Language=VBScript %>
<%Response.ContentType = "application/vnd.ms-excel"%>
<!--#include file="arch_utils.asp"-->
<!--#include file="../lib/comunes/rutinas/funciones.inc" -->
<%
inicio= request("inicio")
termino= request("termino")
cliente = request("cliente")
ejecutivo= request("ejecutivo")
if ejecutivo <> "" then
	if ejecutivo <> "1" then
		Arrayejecutivo=split(ejecutivo,",")
		ejecutivo=empty
	  for each ejecutivoenarray in Arrayejecutivo
		ejecutivo = ejecutivo &"'"&trim(ejecutivoenarray)&"',"
	  next
	  ejecutivo=mid(ejecutivo,1,len(ejecutivo)-1)
	end if
else
	ejecutivo = ""
end if
'response.write(ejecutivo)
'response.end
hora=request("hora")
%>
<title>EMPRESA S.A.</title>
<style type="text/css">
<!--
.Estilo32 {font-family: Arial, Helvetica, sans-serif}
.Estilo33 {color: #000000}
.Estilo34 {font-size: 9px}
-->
</style>
	<%
	IF not cliente="" and not ejecutivo="0" then

		if cliente="100" Then
		if ejecutivo="1" then
				if hora="0" then
						ssql="SELECT HoraIngreso,FechaIngreso,CodCategoria,CodSubCategoria,CodGestion,CodCliente,RutDeudor,FechaCompromiso,telefono_asociado,codcobrador FROM GESTIONES WHERE FechaIngreso>='"&inicio&"' and FechaIngreso<='"&termino&"'  and codcategoria in (4,5)"
				else
						ssql="SELECT HoraIngreso,FechaIngreso,CodCategoria,CodSubCategoria,CodGestion,CodCliente,RutDeudor,FechaCompromiso,telefono_asociado,codcobrador FROM GESTIONES WHERE FechaIngreso>='"&inicio&"' and FechaIngreso<='"&termino&"' and datepart(hour,HoraIngreso)='"&hora&"' and codcategoria in (4,5)"
				end if
		else
				if hora="0" then
						ssql="SELECT HoraIngreso,FechaIngreso,CodCategoria,CodSubCategoria,CodGestion,CodCliente,RutDeudor,FechaCompromiso,telefono_asociado,codcobrador FROM GESTIONES WHERE CodCobrador in ("&ejecutivo&") and FechaIngreso>='"&inicio&"' and FechaIngreso<='"&termino&"' and codcategoria in (4,5)"
				else
						ssql="SELECT HoraIngreso,FechaIngreso,CodCategoria,CodSubCategoria,CodGestion,CodCliente,RutDeudor,FechaCompromiso,telefono_asociado,codcobrador FROM GESTIONES WHERE CodCobrador in ("&ejecutivo&") and FechaIngreso>='"&inicio&"' and FechaIngreso<='"&termino&"' and datepart(hour,HoraIngreso)='"&hora&"' and codcategoria in (4,5)"
				end if
		end if
	else
		if ejecutivo="1" then
				if hora="0" then
						ssql="SELECT HoraIngreso,FechaIngreso,CodCategoria,CodSubCategoria,CodGestion,CodCliente,RutDeudor,FechaCompromiso,telefono_asociado,codcobrador FROM GESTIONES WHERE codcliente in ("&cliente&") and  FechaIngreso>='"&inicio&"' and FechaIngreso<='"&termino&"' and codcategoria in (4,5)"
				else
						ssql="SELECT HoraIngreso,FechaIngreso,CodCategoria,CodSubCategoria,CodGestion,CodCliente,RutDeudor,FechaCompromiso,telefono_asociado,codcobrador FROM GESTIONES WHERE codcliente in ("&cliente&") and  FechaIngreso>='"&inicio&"' and FechaIngreso<='"&termino&"' and datepart(hour,HoraIngreso)='"&hora&"' and codcategoria in (4,5)"
				end if
		else
			if hora="0" then
				ssql="SELECT HoraIngreso,FechaIngreso,CodCategoria,CodSubCategoria,CodGestion,CodCliente,RutDeudor,FechaCompromiso,telefono_asociado,codcobrador FROM GESTIONES WHERE CodCobrador in ("&ejecutivo&") and codcliente in ("&cliente&") and  FechaIngreso>='"&inicio&"' and FechaIngreso<='"&termino&"' and codcategoria in (4,5)"
			else
				ssql="SELECT HoraIngreso,FechaIngreso,CodCategoria,CodSubCategoria,CodGestion,CodCliente,RutDeudor,FechaCompromiso,telefono_asociado,codcobrador FROM GESTIONES WHERE CodCobrador in ("&ejecutivo&") and codcliente in ("&cliente&") and  FechaIngreso>='"&inicio&"' and FechaIngreso<='"&termino&"' and datepart(hour,HoraIngreso)='"&hora&"' and codcategoria in (4,5)"
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
        <tr>
          <td>COBRADOR</td>
          <td>FECHA GESTION</td>
          <td>HORA</td>
          <td>RUT DEUDOR </td>
          <td>GESTION</td>
          <td >FECHA COMPROMISO</td>
          <td>CLIENTE</td>
          <td>FONO</td>
          </tr>
		  <%
		  do until rsDET.eof
		  %>
        <tr bgcolor="#FFFFFF">
          <td ><%=rsDET("codcobrador")%></td>
          <td><%=rsDET("FechaIngreso")%></td>
          <td><%=rsDET("HoraIngreso")%></td>
          <td><%=rsDET("Rutdeudor")%></td>
          <td><%=rsDET("CodCategoria")%><%=rsDET("CodSubCategoria")%><%=rsDET("CodGestion")%></td>
          <td ><%=rsDET("FechaCompromiso")%></td>
          <td ><%
		  ssql_2="SELECT razon_social_cliente FROM CLIENTE WHERE codigo_cliente='"&rsDET("CodCliente")&"'"
		  set rsN=Conn.execute(ssql_2)
		  if not rsN.eof then
		  response.Write(rsN("razon_social_cliente"))
		  end if
		  rsN.close
		  set rsN=nothing

		  %></td>
          <td><%=rsDET("telefono_asociado")%></td>
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


