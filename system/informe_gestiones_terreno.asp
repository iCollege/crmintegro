<% @LCID = 1034 %>
<!--#include file="arch_utils.asp"-->
<!--#include file="../lib/comunes/rutinas/funciones.inc" -->
<!--#include file="lib.asp"-->

<%
inicio= request.Form("inicio")
if inicio="" then
inicio=request.QueryString("inicio")
end if

termino= request.Form("termino")
if termino="" then
termino=request.QueryString("termino")
end if

cliente = request.Form("cliente")
if cliente="" then
cliente = request.querystring("cliente")
end if

sucursal = request.Form("sucursal")
if sucursal="" then
sucursal = request.querystring("sucursal")

end if

ejecutivo= request.Form("ejecutivo")
if ejecutivo="" then
ejecutivo=request.QueryString("ejecutivo")
end if

hora=request.Form("hora")
if hora="" then
hora=request.QueryString("hora")
end if
%>
<title>INFORME DE BALANCE DE CARTERA</title>

<style type="text/css">
<!--
.Estilo37 {color: #FFFFFF}
-->
</style>


<form name="datos" method="post">
<table width="885" height="420" border="0">
  <tr>
    <td width="827" height="20" class="Estilo20"><img src="../lib/TIT_INFORME_BALANCECARTERA.gif" width="740" height="22"></td>
  </tr>
  <tr>
    <td height="242" valign="top" background="../images/fondo_coventa.jpg">
	<BR>

	<table width="100%" border="0">
      <tr bgcolor="#<%=session("COLTABBG")%>" class="Estilo13">
        <td width="25%">CLIENTE</td>
		<td width="11%">SUCURSAL</td>
        <td width="10%">EJECUTIVO</td>
        <td width="16%">FECHA INICIO </td>
        <td width="16%" bgcolor="#<%=session("COLTABBG")%>">FECHA TERMINO </td>
        <td width="22%" bgcolor="#<%=session("COLTABBG")%>">HORA</td>
        </tr>
      <tr>
        <td height="26" valign="top">
		<select name="cliente" id="cliente" onchange="envia3();" multiple="true" >
		<option value="0">SELECCIONE</option>
		<%
		if cliente<> "" then
				sw=0
				Arraycliente=split(cliente,",")
				for each clienteenarray in arraycliente
					if clienteenarray =69 then
						sw=1
					end if
				next
				if sw =1 then
					cliente = "69"
				end if
			else
			sw=1
				cliente=""
			end if
		%>
		<option value="69" <%if cliente="69" then response.Write("Selected") end if%>>TODOS</option>
			<%

			abrirscg()
			ssql="SELECT codigo_cliente,razon_social_cliente FROM CLIENTE where scg_web= 1 and activo = 1 order by razon_social_cliente"
			set rsCLI= Conn.execute(ssql)
			if not rsCLI.eof then
				do until rsCLI.eof%>
			<option value="<%=rsCLI("codigo_cliente")%>"<%
			if sw <> 1 then
			Arraycliente=split(cliente,",")
			for each clienteenarray in arraycliente
				if cint(clienteenarray)=rsCLI("codigo_cliente") then response.Write("Selected") End If
			next
			end if
			%>><%=rsCLI("razon_social_cliente")%></option>
			<%
				rsCLI.movenext
				loop
				end if
				rsCLI.close
				set rsCLI=nothing
				cerrarscg()

			%>
        </select></td>
		<td valign="top"><select name="sucursal" id="sucursal" onchange="envia4();" multiple="true">
		<%
		if sucursal<> "" then
			Arraysucursal=split(sucursal,",")
			sw=0
			for each sucursalenarray in Arraysucursal
				if sucursalenarray = "1" then
					sw = 1
				end if
			next
			if sw = 1 then
				sucursal = 1
			end if
		end if
		response.write(sucursal)
		%>
		<option value="0" <%if sucursal="0" then response.Write("Selected") end if%>>SELECCIONE</option>
		<option value="1" <%if sucursal="1" then response.Write("Selected") end if%>>TODAS</option>
		<%
		abrirscg()
		if cliente = "" then
			ssql="select distinct(sucursal) as sucursal from cobrador_cliente where cast(codigo_cliente as varchar(5)) in ('" & cliente & "') and sucursal is not NULL and tipo = 'TER'"
		else
		ssql="select distinct(sucursal) as sucursal from cobrador_cliente where cast(codigo_cliente as varchar(5)) in (" & cliente & ") and sucursal is not NULL and tipo = 'TER'"
		end if
		set rsSUC=Conn.execute(ssql)

		if not rsSUC.eof then
			do until rsSUC.eof
		%>
          <option value="<%=rsSUC("sucursal")%>" <%
		  if sw <> 1 then
		  Arraysucursal=split(sucursal,",")
			for each sucursalenarray in Arraysucursal
				if trim(sucursalenarray)=rsSUC("sucursal") then response.Write("Selected") end if
			next
			end if
				%>><%=rsSUC("sucursal")%></option>
		 <%
		 	rsSUC.movenext
			loop
		End If
		rsSUC.close
		set rsSUC=Nothing

		cerrarscg()
		 %>
        </select></td>
<%

		if sucursal<> "" then
			Arraysucursal=split(sucursal,",")
			sucursal=empty
			for each sucursalenarray in Arraysucursal
				sucursal = sucursal &"'"&trim(sucursalenarray)&"',"
			next
			sucursal=mid(sucursal,1,len(sucursal)-1)
		else
			sucursal="'"&sucursal&"'"
		end if
%>
        <td valign="top"><select name="ejecutivo" id="ejecutivo" onchange="envia();" multiple="true" >
		<%
		if ejecutivo <> "" then
		ejec=empty
			ejec=ejecutivo
			 Arrayejecutivo=split(ejecutivo,",")
			 sw= 0
			  for each ejecutivoenarray in Arrayejecutivo
				if ejecutivoenarray = "1" then
					sw=1
				end if
				'ejecutivo = ejecutivo &"'"&trim(ejecutivoenarray)&"',"
			  next
			  if sw = 1 then
				ejecutivo = "1"
			  end if
			  'ejecutivo=mid(ejecutivo,1,len(ejecutivo)-1)
		end if
		%>
		<option value="0" <%if ejecutivo="0" then response.Write("Selected") end if%>>SELECCIONE</option>
		<option value="1" <%if ejecutivo="1" then response.Write("Selected") end if%>>TODOS</option>
		<%
		abrirscg()
		if cliente = "" then
		ssql="SELECT distinct (login) FROM COBRADOR_CLIENTE WHERE cast(codigo_cliente as varchar(5)) in ('"&cliente&"') and sucursal in ("&sucursal&") and tipo = 'TER'"
		else
		ssql="SELECT distinct (login) FROM COBRADOR_CLIENTE WHERE cast(codigo_cliente as varchar(5)) in ("&cliente&") and sucursal in ("&sucursal&") and tipo = 'TER'"
		end if
		set rsCOB=Conn.execute(ssql)
		if not rsCOB.eof then
			do until rsCOB.eof
		%>
          <option value="<%=rsCOB("login")%>"
		  <%
		  Arrayejecutivo=split(ejecutivo,",")
		  for each ejecutivoenarray in Arrayejecutivo
			if trim(ejecutivoenarray)=rsCOB("login") then response.Write("Selected") end if
		  next
		  %>>

		  <%=rsCOB("login")%></option>
		 <%
		 	rsCOB.movenext
			loop
		End If
		rsCOB.close
		set rsCOB=Nothing
		cerrarscg()
		 %>
        </select>
		<%
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

		'response.write(cliente)
		'response.write(sucursal)
		'response.write(ejecutivo)
		  %>
		</td>
        <td valign="top"><input name="inicio" type="text" id="inicio" value="<%=inicio%>" size="10" maxlength="10">
		<a href="javascript:showCal('Calendar7');"><img src="../lib/calendario.gif" border="0"></a></td>
        <td valign="top"><input name="termino" type="text" id="termino" value="<%=termino%>" size="10" maxlength="10">
          <a href="javascript:showCal('Calendar6');"><img src="../lib/calendario.gif" border="0"></a>
		  </td>
        <td valign="top"><select name="hora" id="hora">
          <option value="0" <%if hora="0" then%>Selected<%End If%>>TODAS</option>
          <option value="9" <%if hora="9" then%>Selected<%End If%>>09:00</option>
          <option value="10" <%if hora="10" then%>Selected<%End If%>>10:00</option>
          <option value="11" <%if hora="11" then%>Selected<%End If%>>11:00</option>
          <option value="12" <%if hora="12" then%>Selected<%End If%>>12:00</option>
          <option value="13" <%if hora="13" then%>Selected<%End If%>>13:00</option>
          <option value="14" <%if hora="14" then%>Selected<%End If%>>14:00</option>
          <option value="15" <%if hora="15" then%>Selected<%End If%>>15:00</option>
          <option value="16" <%if hora="16" then%>Selected<%End If%>>16:00</option>
          <option value="17" <%if hora="17" then%>Selected<%End If%>>17:00</option>
          <option value="18" <%if hora="18" then%>Selected<%End If%>>18:00</option>
          <option value="19" <%if hora="19" then%>Selected<%End If%>>19:00</option>
          <option value="20" <%if hora="20" then%>Selected<%End If%>>20:00</option>
        </select>&nbsp;&nbsp; <input type="submit" name="Submit" value="Ver" onClick="envia2();">
        <input type="submit" name="Submit" value="Detalle" onClick="javascript:Planilla('informe_gestiones_terreno_xls.asp?cliente=<%=cliente%>&ejecutivo=<%=ejec%>&inicio=<%=inicio%>&termino=<%=termino%>&hora=<%=hora%>');"></td>
        </tr>
     </table>

<%
	IF not cliente="" and not ejecutivo="" and not inicio ="" and not termino = ""  then

	G111 = 0
	G112 = 0
	G121 = 0
	G122 = 0
	G123 = 0
	G124 = 0
	G125 = 0
	G131 = 0
	G132 = 0
	G133 = 0
	G134 = 0
	G140 = 0
	G150 = 0
	G210 = 0
	G220 = 0
	G230 = 0
	G240 = 0
	G250 = 0
	G310 = 0
	G320 = 0
	G330 = 0
	G411 = 0
	G412 = 0
	G421 = 0
	G422 = 0
	G423 = 0
	G424 = 0
	G431 = 0
	G432 = 0
	G433 = 0
	G434 = 0
	G440 = 0
	G450 = 0
	G510 = 0
	G520 = 0
	G530 = 0
	G540 = 0
	G550 = 0
	G126 = 0
	G127 = 0


	if cliente="69" Then
		if ejecutivo="1" then
				if hora="0" then
						ssql="SELECT COUNT(*) as CANT,CODCATEGORIA,CODSUBCATEGORIA,IsNull(CODGESTION,0) CODGESTION FROM GESTIONES WHERE FechaIngreso>='"&inicio&"' and FechaIngreso<='"&termino&"' and codcategoria in (4,5) GROUP BY CODCATEGORIA,CODSUBCATEGORIA,IsNull(CODGESTION,0) ORDER BY CODCATEGORIA,CODSUBCATEGORIA,IsNull(CODGESTION,0)"

						sq= "SELECT COUNT(DISTINCT RUTDEUDOR) AS RUTS,CODCATEGORIA,CODSUBCATEGORIA,IsNull(CODGESTION,0) CODGESTION FROM GESTIONES WHERE FechaIngreso>='"&inicio&"' and FechaIngreso<='"&termino&"' GROUP BY CODCATEGORIA,CODSUBCATEGORIA,IsNull(CODGESTION,0) ORDER BY CODCATEGORIA,CODSUBCATEGORIA,IsNull(CODGESTION,0)"
				else
						ssql="SELECT COUNT(*) as CANT,CODCATEGORIA,CODSUBCATEGORIA,IsNull(CODGESTION,0) CODGESTION FROM GESTIONES WHERE FechaIngreso>='"&inicio&"' and FechaIngreso<='"&termino&"' and datepart(hour,HoraIngreso)='"&hora&"' and codcategoria in (4,5) GROUP BY CODCATEGORIA,CODSUBCATEGORIA,IsNull(CODGESTION,0) ORDER BY CODCATEGORIA,CODSUBCATEGORIA,IsNull(CODGESTION,0)"

						sq= "SELECT COUNT(DISTINCT RUTDEUDOR) AS RUTS,CODCATEGORIA,CODSUBCATEGORIA,IsNull(CODGESTION,0) CODGESTION FROM GESTIONES WHERE FechaIngreso>='"&inicio&"' and FechaIngreso<='"&termino&"' and datepart(hour,HoraIngreso)='"&hora&"' GROUP BY CODCATEGORIA,CODSUBCATEGORIA,IsNull(CODGESTION,0) ORDER BY CODCATEGORIA,CODSUBCATEGORIA,IsNull(CODGESTION,0)"
				end if
		else
				if hora="0" then
						ssql="SELECT COUNT(*) as CANT,CODCATEGORIA,CODSUBCATEGORIA,IsNull(CODGESTION,0) CODGESTION FROM GESTIONES WHERE CodCobrador in ("&ejecutivo&") and FechaIngreso>='"&inicio&"' and FechaIngreso<='"&termino&"' and codcategoria in (4,5) GROUP BY CODCATEGORIA,CODSUBCATEGORIA,IsNull(CODGESTION,0) ORDER BY CODCATEGORIA,CODSUBCATEGORIA,IsNull(CODGESTION,0)"

						sq= "SELECT COUNT(DISTINCT RUTDEUDOR) AS RUTS,CODCATEGORIA,CODSUBCATEGORIA,IsNull(CODGESTION,0) CODGESTION FROM GESTIONES WHERE CodCobrador in ("&ejecutivo&") and FechaIngreso>='"&inicio&"' and FechaIngreso<='"&termino&"' GROUP BY CODCATEGORIA,CODSUBCATEGORIA,IsNull(CODGESTION,0) ORDER BY CODCATEGORIA,CODSUBCATEGORIA,IsNull(CODGESTION,0)"
				else
						ssql="SELECT COUNT(*) as CANT,CODCATEGORIA,CODSUBCATEGORIA,IsNull(CODGESTION,0) CODGESTION FROM GESTIONES WHERE CodCobrador in ("&ejecutivo&") and FechaIngreso>='"&inicio&"' and FechaIngreso<='"&termino&"' and datepart(hour,HoraIngreso)='"&hora&"' and codcategoria in (4,5) GROUP BY CODCATEGORIA,CODSUBCATEGORIA,IsNull(CODGESTION,0) ORDER BY CODCATEGORIA,CODSUBCATEGORIA,IsNull(CODGESTION,0)"

						sq= "SELECT COUNT(DISTINCT RUTDEUDOR) AS RUTS,CODCATEGORIA,CODSUBCATEGORIA,IsNull(CODGESTION,0) CODGESTION FROM GESTIONES WHERE CodCobrador in ("&ejecutivo&") and FechaIngreso>='"&inicio&"' and FechaIngreso<='"&termino&"' and datepart(hour,HoraIngreso)='"&hora&"'GROUP BY CODCATEGORIA,CODSUBCATEGORIA,IsNull(CODGESTION,0) ORDER BY CODCATEGORIA,CODSUBCATEGORIA,IsNull(CODGESTION,0)"
				end if
		end if
	else
		if ejecutivo="1" then
				if hora="0" then
						ssql="SELECT COUNT(*) as CANT,CODCATEGORIA,CODSUBCATEGORIA,IsNull(CODGESTION,0) CODGESTION FROM GESTIONES WHERE codcliente in ("&cliente&") and  FechaIngreso>='"&inicio&"' and FechaIngreso<='"&termino&"' and codcategoria in (4,5) GROUP BY CODCATEGORIA,CODSUBCATEGORIA,IsNull(CODGESTION,0) ORDER BY CODCATEGORIA,CODSUBCATEGORIA,IsNull(CODGESTION,0)"

						sq= "SELECT COUNT(DISTINCT RUTDEUDOR) AS RUTS,CODCATEGORIA,CODSUBCATEGORIA,IsNull(CODGESTION,0) CODGESTION FROM GESTIONES WHERE codcliente in ("&cliente&") and  FechaIngreso>='"&inicio&"' and FechaIngreso<='"&termino&"' GROUP BY CODCATEGORIA,CODSUBCATEGORIA,IsNull(CODGESTION,0) ORDER BY CODCATEGORIA,CODSUBCATEGORIA,IsNull(CODGESTION,0)"
				else
						ssql="SELECT COUNT(*) as CANT,CODCATEGORIA,CODSUBCATEGORIA,IsNull(CODGESTION,0) CODGESTION FROM GESTIONES WHERE codcliente in ("&cliente&") and  FechaIngreso>='"&inicio&"' and FechaIngreso<='"&termino&"' and datepart(hour,HoraIngreso)='"&hora&"' and codcategoria in (4,5) GROUP BY CODCATEGORIA,CODSUBCATEGORIA,IsNull(CODGESTION,0) ORDER BY CODCATEGORIA,CODSUBCATEGORIA,IsNull(CODGESTION,0)"

						sq= "SELECT COUNT(DISTINCT RUTDEUDOR) AS RUTS,CODCATEGORIA,CODSUBCATEGORIA,IsNull(CODGESTION,0) CODGESTION FROM GESTIONES WHERE codcliente in ("&cliente&") and  FechaIngreso>='"&inicio&"' and FechaIngreso<='"&termino&"' and datepart(hour,HoraIngreso)='"&hora&"' GROUP BY CODCATEGORIA,CODSUBCATEGORIA,IsNull(CODGESTION,0) ORDER BY CODCATEGORIA,CODSUBCATEGORIA,IsNull(CODGESTION,0)"
				end if
		else
			if hora="0" then
				ssql="SELECT COUNT(*) as CANT,CODCATEGORIA,CODSUBCATEGORIA,IsNull(CODGESTION,0) CODGESTION FROM GESTIONES WHERE CodCobrador in ("&ejecutivo&") and codcliente in ("&cliente&") and  FechaIngreso>='"&inicio&"' and FechaIngreso<='"&termino&"' and codcategoria in (4,5) GROUP BY CODCATEGORIA,CODSUBCATEGORIA,IsNull(CODGESTION,0) ORDER BY CODCATEGORIA,CODSUBCATEGORIA,IsNull(CODGESTION,0)"

				sq= "SELECT COUNT(DISTINCT RUTDEUDOR) AS RUTS,CODCATEGORIA,CODSUBCATEGORIA,IsNull(CODGESTION,0) CODGESTION FROM GESTIONES WHERE CodCobrador in ("&ejecutivo&") and codcliente in ("&cliente&") and  FechaIngreso>='"&inicio&"' and FechaIngreso<='"&termino&"' GROUP BY CODCATEGORIA,CODSUBCATEGORIA,IsNull(CODGESTION,0) ORDER BY CODCATEGORIA,CODSUBCATEGORIA,IsNull(CODGESTION,0)"
			else
				ssql="SELECT COUNT(*) as CANT,CODCATEGORIA,CODSUBCATEGORIA,IsNull(CODGESTION,0) CODGESTION FROM GESTIONES WHERE CodCobrador in ("&ejecutivo&") and codcliente in ("&cliente&") and  FechaIngreso>='"&inicio&"' and FechaIngreso<='"&termino&"' and datepart(hour,HoraIngreso)='"&hora&"' and codcategoria in (4,5) GROUP BY CODCATEGORIA,CODSUBCATEGORIA,IsNull(CODGESTION,0) ORDER BY CODCATEGORIA,CODSUBCATEGORIA,IsNull(CODGESTION,0)"

				sq= "SELECT COUNT(DISTINCT RUTDEUDOR) AS RUTS,CODCATEGORIA,CODSUBCATEGORIA,IsNull(CODGESTION,0) CODGESTION FROM GESTIONES WHERE CodCobrador  ("&ejecutivo&") and codcliente in ("&cliente&") and  FechaIngreso>='"&inicio&"' and FechaIngreso<='"&termino&"' and datepart(hour,HoraIngreso)='"&hora&"' GROUP BY CODCATEGORIA,CODSUBCATEGORIA,IsNull(CODGESTION,0) ORDER BY CODCATEGORIA,CODSUBCATEGORIA,IsNull(CODGESTION,0)"
			end if
		end if
	end if

	abrirscg()
	'RESPONSE.WRITE(SSQL)
	'RESPONSE.End()
	set rsDET=Conn.execute(ssql)
	'if not rsDET.eof then
		intCantidad411 = 0
		intCantidad412 = 0
		intCantidad421 = 0
		intCantidad422 = 0
		intCantidad423 = 0
		intCantidad424 = 0
		intCantidad431 = 0
		intCantidad432 = 0
		intCantidad433 = 0
		intCantidad434 = 0
		intCantidad440 = 0
		intCantidad450 = 0
		intCantidad510 = 0
		intCantidad520 = 0
		intCantidad530 = 0
		intCantidad540 = 0
		intCantidad550 = 0
		Do While Not rsDET.EOF
		strGestion=Trim(rsDET("CODCATEGORIA")&rsDET("CODSUBCATEGORIA")&rsDET("CODGESTION"))

		Select Case strGestion
			Case "411":
				intCantidad411 = rsDET("CANT")
			Case "412":
				intCantidad412 = rsDET("CANT")
			Case "421":
				intCantidad421 = rsDET("CANT")
			Case "422":
				intCantidad422 = rsDET("CANT")
			Case "423":
				intCantidad423 = rsDET("CANT")
			Case "424":
				intCantidad424 = rsDET("CANT")
			Case "431":
				intCantidad431 = rsDET("CANT")
			Case "432":
				intCantidad432 = rsDET("CANT")
			Case "433":
				intCantidad433 = rsDET("CANT")
			Case "434":
				intCantidad434 = rsDET("CANT")
			Case "440":
				intCantidad440 = rsDET("CANT")
			Case "450":
				intCantidad450 = rsDET("CANT")
			Case "510":
				intCantidad510 = rsDET("CANT")
			Case "520":
				intCantidad520 = rsDET("CANT")
			Case "530":
				intCantidad530 = rsDET("CANT")
			Case "540":
				intCantidad540 = rsDET("CANT")
			Case "550":
				intCantidad550 = rsDET("CANT")
		End Select

	rsDET.MoveNext

	Loop
	'response.write(sq)
	set rsA = Conn.execute(sq)
	'if not rsA.eof then
		intRut411 = 0
		intRut412 = 0
		intRut421 = 0
		intRut422 = 0
		intRut423 = 0
		intRut424 = 0
		intRut431 = 0
		intRut432 = 0
		intRut433 = 0
		intRut434 = 0
		intRut440 = 0
		intRut450 = 0
		intRut510 = 0
		intRut520 = 0
		intRut530 = 0
		intRut540 = 0
		intRut550 = 0
		Do While Not rsA.EOF
		strRut=Trim(rsA("CODCATEGORIA")&rsA("CODSUBCATEGORIA")&rsA("CODGESTION"))

		Select Case strRut
			Case "411":
					intRut411 = rsA("RUTS")
			Case "412":
					intRut412 = rsA("RUTS")
			Case "421":
					intRut421 = rsA("RUTS")
			Case "422":
					intRut422 = rsA("RUTS")
			Case "423":
					intRut423 = rsA("RUTS")
			Case "424":
					intRut424 = rsA("RUTS")
			Case "431":
					intRut431 = rsA("RUTS")
			Case "432":
					intRut432 = rsA("RUTS")
			Case "433":
					intRut433 = rsA("RUTS")
			Case "434":
					intRut434 = rsA("RUTS")
			Case "440":
					intRut440 = rsA("RUTS")
			Case "450":
					intRut450 = rsA("RUTS")
			Case "510":
					intRut510 = rsA("RUTS")
			Case "520":
					intRut520 = rsA("RUTS")
			Case "530":
					intRut530 = rsA("RUTS")
			Case "540":
					intRut540 = rsA("RUTS")
			Case "550":
					intRut550 = rsA("RUTS")
		End Select

	rsA.MoveNext

	Loop
	RUTS = intRut411 + intRut412 + intRut421 + intRut422 + intRut423 + intRut424 + intRut431 + intRut432 + intRut433 + intRut434 + intRut440 + intRut450 + intRut510 + intRut520 + intRut530 + intRut540 + intRut550
	'end if
	TT = intCantidad411 + intCantidad412 + intCantidad421 + intCantidad422 + intCantidad423 + intCantidad424 + intCantidad431 + intCantidad432 + intCantidad433 +  intCantidad434 +  intCantidad440 + intCantidad450 + intCantidad510 + intCantidad520 + intCantidad530 + intCantidad540 + intCantidad550
	'end if
	%>
	<table width="100%" border="0">
      <tr bgcolor="#<%=session("COLTABBG")%>" class="Estilo13">
        <td width="23%">CATEGORIA</td>
        <td width="31%">SUBCATEGORIA</td>
        <td width="36%">GESTION</td>
        <td width="10%"><div align="left">GESTIONES</div></td>
        <td width="10%"><div align="left">RUT</div></td>
      </tr>

      <tr>
        <td>1. DIRECCI&Oacute;N EXISTE </td>
        <td>1. DEUDOR NO RESIDE </td>
        <td>1. DATOS ADICIONALES </td>
        <td><div align="right"><%=intCantidad411%></div></td>
        <td>              <div align="right"><%=intRut411%>
       </div></td>
      </tr>
      <tr>
        <td>&nbsp;</td>
        <td>&nbsp;</td>
        <td>2. SIN DATOS ADICIONALES </td>
        <td><div align="right"><%=intCantidad412%></div></td>
        <td>              <div align="right"><%=intRut412%>
        </div></td>
      </tr>
      <tr>
        <td>&nbsp;</td>
        <td>2. ENTREVISTA CON EL DEUDOR </td>
        <td>1. SIN INTENCI&Oacute;N DE PAGO DEMANDABLE </td>
        <td><div align="right"><%=intCantidad421%></div></td>
        <td>              <div align="right"><%=intRut421%>
        </div></td>
      </tr>
      <tr>
        <td>&nbsp;</td>
        <td>&nbsp;</td>
        <td>2. SIN INTENCI&Oacute;N DE PAGO NO DEMANDABLE </td>
        <td><div align="right"><%=intCantidad422%></div></td>
        <td>              <div align="right"><%=intRut422%>
        </div></td>
      </tr>
      <tr>
        <td>&nbsp;</td>
        <td>&nbsp;</td>
        <td>3. CESANTE </td>
        <td><div align="right"><%=intCantidad423%></div></td>
        <td><div align="right"><%=intRut423%>
        </div></td>
      </tr>
      <tr>
        <td>&nbsp;</td>
        <td>&nbsp;</td>
        <td>4. COMPROMISO DE PAGO </td>
        <td><div align="right"><%=intCantidad424%></div></td>
        <td>              <div align="right"><%=intRut424%>
        </div></td>
      </tr>
      <tr>
        <td>&nbsp;</td>
        <td>3. DEUDOR NO RECONOCE DEUDA </td>
        <td>1. DEUDA CANCELADA </td>
        <td><div align="right"><%=intCantidad431%></div></td>
        <td>              <div align="right"><%=intRut431%>
        </div></td>
      </tr>
      <tr>
        <td>&nbsp;</td>
        <td>&nbsp;</td>
        <td>2. RECLAMO PENDIENTE </td>
        <td><div align="right"><%=intCantidad432%></div></td>
        <td>              <div align="right"><%=intRut432%>
        </div></td>
      </tr>
      <tr>
        <td>&nbsp;</td>
        <td>&nbsp;</td>
        <td>3. DEUDA POR NORMALIZAR (COMPROBANTE) </td>
        <td><div align="right"><%=intCantidad433%></div></td>
        <td>              <div align="right"><%=intRut433%>
        </div></td>
      </tr>
      <tr>
        <td>&nbsp;</td>
        <td>&nbsp;</td>
        <td>4. DEUDOR CON CONVENIO DE PAGO </td>
        <td><div align="right"><%=intCantidad434%></div></td>
        <td>              <div align="right"><%=intRut434%>
        </div></td>
      </tr>
      <tr>
        <td>&nbsp;</td>
        <td>4. DEUDOR FALLECIDO </td>
        <td>&nbsp;</td>
        <td><div align="right"><%=intCantidad440%></div></td>
        <td>              <div align="right"><%=intRut440%>
        </div></td>
      </tr>
      <tr>
        <td>&nbsp;</td>
        <td>5. CONTACTO CON TERCEROS - NOTIF.</td>
        <td>&nbsp;</td>
        <td><div align="right"><%=intCantidad450%></div></td>
        <td>              <div align="right"><%=intRut450%>
        </div></td>
      </tr>
      <tr>
        <td>2. DIRECCI&Oacute;N NO UBICADA </td>
        <td>1. NUMERO MUNICIPAL NO EXISTE </td>
        <td>&nbsp;</td>
        <td><div align="right"><%=intCantidad510%></div></td>
        <td> <div align="right"><%=intRut510%>
        </div></td>
      </tr>
      <tr>
        <td>&nbsp;</td>
        <td>2. CALLE NO EXISTE </td>
        <td>&nbsp;</td>
        <td><div align="right"><%=intCantidad520%></div></td>
        <td>              <div align="right"><%=intRut520%>
        </div></td>
      </tr>
      <tr>
        <td>&nbsp;</td>
        <td>3. SITIO ERIAZO </td>
        <td>&nbsp;</td>
        <td><div align="right"><%=intCantidad530%></div></td>
        <td>              <div align="right"><%=intRut530%>
        </div></td>
      </tr>
      <tr>
        <td>&nbsp;</td>
        <td>4. CONSTRUCCI&Oacute;N </td>
        <td>&nbsp;</td>
        <td><div align="right"><%=intCantidad540%></div></td>
        <td><div align="right"><%=intRut540%>
        </div></td>
      </tr>
      <tr>
        <td>&nbsp;</td>
        <td>5. FALTA INFORMACI&Oacute;N </td>
        <td>&nbsp;</td>
        <td><div align="right"><%=intCantidad550%></div></td>
        <td>              <div align="right"><%=intRut550%>
        </div></td>
      </tr>
      <tr bgcolor="#<%=session("COLTABBG")%>">
        <td><span class="Estilo37"></span></td>
        <td><span class="Estilo37"></span></td>
        <td><span class="Estilo37">TOTAL DE GESTIONES REALIZADAS</span></td>
        <td><div align="right" class="Estilo37"><%=TT%></div></td>
        <td><div align="right" class="Estilo37"><%=RUTS%></div></td>
      </tr>
      <tr bgcolor="#<%=session("COLTABBG")%>">
        <td>&nbsp;</td>
        <td>&nbsp;</td>
        <td><span class="Estilo37">TOTAL DEUDORES ACTIVOS </span></td>
        <td>&nbsp;</td>
        <td><div align="right" class="Estilo37">
		<%
		cantidad_activa = 0
		abrirscg()
		ssql="SELECT rut_activos FROM SCG_WEB_INFORME_RECUPERACION WHERE CODIGO_CLIENTE in ("&cliente&") AND MES=DATEPART(MONTH,GETDATE()) AND ANNO=DATEPART(YEAR,GETDATE())"
		set rsACT=Conn.execute(ssql)
		if not rsACT.eof then
		cantidad_activa = CLNG(rsACT("rut_activos"))

		end if
		rsACT.close
		set rsACT=nothing
		cerrarscg()
		response.Write(cantidad_Activa)
		'porcentaje_recorrido=(cantidad_Activa/RUTS)*100
		%>
		</div></td>
      </tr>
      <tr bgcolor="#<%=session("COLTABBG")%>">
        <td>&nbsp;</td>
        <td>&nbsp;</td>
        <td><span class="Estilo37">PORCENTAJE GESTIONADO</span></td>
        <td>&nbsp;</td>
        <td><div align="right" class="Estilo37">
		<%response.Write(FN(porcentaje_recorrido,0))%> %
		</div></td>
      </tr>
    </table>
	<% end if %>
	  </td>
  </tr>
</table>
</form>

<script language="JavaScript1.2">
function envia(){
datos.inicio.value=''
datos.termino.value=''
datos.action='informe_gestiones_terreno.asp';
datos.submit();
}

function envia2(){
if (datos.cliente.value=='0'){
alert('DEBE SELECCIONAR UN CLIENTE');
}else{
datos.action='informe_cargando_gestiones_t2.asp';
datos.submit();
}
}

function envia3(){
if (datos.cliente.value=='0'){
alert('DEBE SELECCIONAR UN CLIENTE');
}else{
datos.sucursal.value='0'
datos.ejecutivo.value='0'
datos.action='informe_gestiones_terreno.asp';
datos.submit();
}
}
function envia4(){
if (datos.cliente.value=='0'){
alert('DEBE SELECCIONAR UN CLIENTE');
}else{
datos.ejecutivo.value='0'
datos.action='informe_gestiones_terreno.asp';
datos.submit();
}
}
function excel(){
if (datos.cliente.value=='0'){
alert('DEBE SELECCIONAR UN CLIENTE');
}else if(datos.inicio.value==''){
alert('DEBE SELECCIONAR FECHA DE INICIO');
}else if(datos.termino.value==''){
alert('DEBES SELECCIONAR FECHA DE TERMINO');
}else{
window.open("'informe_gestiones_terreno_xls.asp?cliente=<%=cliente%>&ejecutivo=<%=ejecutivo%>&inicio=<%=inicio%>&termino=<%=termino%>&hora=<%=hora%>'","INFORMACION")
}
}
function Planilla(URL){
	window.open(URL,"INFORMACION","width=200, height=200, scrollbars=yes, menubar=yes, location=yes, resizable=yes")
}

</script>