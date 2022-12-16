<%@LANGUAGE="VBSCRIPT" CODEPAGE="1252"%>
<%
Response.Buffer = TRUE
Response.ContentType = "application/vnd.ms-excel"
'Response.ContentType = "text/plain"
%>
<html>
<link href="style.css" rel="stylesheet" type="text/css">




<head>
<title>Detalle convenios DyS</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">

</head>

<body>
<style type="text/css">
<!--
.Estilo33 {color: #FF0000}
.Estilo34 {font-size: xx-small}
.Estilo35 {color: #FFFFFF}
-->
</style>
<%

Set Conn = Server.CreateObject("ADODB.Connection")
Set Conn = Server.CreateObject("ADODB.Connection")
Conn.Open "driver=Sql server;Uid=scgweb;Pwd=scgweb;Database=SCG;App=SCG-WEB ingreso convenios DyS;Server=ICARUS"

if isnull(request("cobrador")) or request("cobrador")="" then
	cobrador=""
else
	cobrador=request("cobrador")
end if


if isnull(fecha=request("fecha")) or fecha=request("fecha")="" then
	fecha=date()
else
	fecha=request("fecha")
end if

FechaPartida = Split(Fecha, "/")
dd = cint(FechaPartida(0))
mm = cint(FechaPartida(1))
aa = cint(FechaPartida(2))
'response.write(dd+mm+aa)
'response.end



conta=0
ssql="SELECT * FROM consolidadosconveniosdys "
ssql=ssql+"WHERE "
IF (NOT ISNULL(cobrador)) AND (cobrador<>"") THEN
SSQL=SSQL + "CODCOBRADOR='" & cobrador & "' AND "
END IF
ssql=ssql+" datepart(year,fechaGESTION)="& aa
ssql=ssql+" and datepart(month,fechaGESTION)="& mm
ssql=ssql+" and datepart(day,fechaGESTION)="& dd & " ORDER BY CODCOBRADOR"
'RESPONSE.Write(SSQL)
'RESPONSE.End()
set rsCLI=Conn.execute(ssql)

%>

<div align="center">
<form name="datos" method="post" action="detalleconveniosdys_devel.asp">
    <table width="810"  border="1" cellspacing="2">
  <tr bordercolor="#999999" bgcolor="#<%=session("COLTABBG")%>" class="Estilo13">
    <td width=100% ><div align="center"> <STRONG>DETALLE CONVENIOS 	<% if cobrador<>"" then
		response.write("de " + cobrador)
	else
				response.write("del :" + fecha)
	end if

    %>



	</STRONG></div></td>
  </tr>
 </table>
<table width="810" border="1" cellspacing="2" background="../images/fondo_coventa.jpg">
  <tr bordercolor="#999999" bgcolor="#<%=session("COLTABBG")%>" class="Estilo13">
  <STRONG>
    <td width="21" height="23">N&ordm;</td>
<%	IF (ISNULL(cobrador)) OR (cobrador="") THEN %>
	<td width="71">COBRADOR</td>
<%END IF%>
    <td width="70">RUTDEUDOR</td>
    <td width="71">TELEFONO</td>
    <td width="82">FECHA CONV.</td>
    <td width="49">CUOTAS</td>
    <td width="90">VALORCUOTA</td>
    <td width="84">TOTAL</td>
    <td width="97">FOLIO</td>
    <td width="111">PRODUCTO</td>
	 <td width="111">REPETICION</td>
  </STRONG>
  </tr>
<%  WHILE not (rsCLI.eof) %>
  <tr>
    <td height="22" bordercolor="#999999" bgcolor="#<%=session("COLTABBG")%>" class="Estilo13"><STRONG>
      <%conta=conta+1
	response.write(conta)%>
      </STRONG></td>

<%	IF (ISNULL(cobrador)) OR (cobrador="") THEN %>
	<td><%=UCASE(rsCLI("CODCOBRADOR"))%></td>
<%END IF%>

    <td><%=rsCLI("rutdeudor")%></td>
    <td><%=rsCLI("telefono")%></td>
    <td><%=rsCLI("fechaconvenida")%></td>
    <td><%=rsCLI("nrocuotas")%></td>
    <td><%=rsCLI("valorcuotas")%></td>
    <td><%=rsCLI("total")%></td>
    <td><%=rsCLI("folio")%></td>
    <td><%=rsCLI("producto")%></td>
	<td><%=rsCLI("repeticion")%></td>
<% rsCLI.movenext
	wend
%>
  </tr>


</table>
  <br>
  </form>
  <p>&nbsp;</p>
</div>
</body>
<%
Conn.close
set Conn = nothing
%>
</html>