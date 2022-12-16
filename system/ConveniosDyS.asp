<% @LCID = 1034 %>
<html>
<link href="style.css" rel="stylesheet" type="text/css">

<head>
<title>CONVENIOS DYS REALIZADOS HOY</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
</head>

<body>
<%
'ABRIR BD
Set Conn = Server.CreateObject("ADODB.Connection")
Set Conn = Server.CreateObject("ADODB.Connection")
Conn.Open "driver=Sql server;Uid=scgweb;Pwd=scgweb;Database=SCG;App=SCG-WEB ingreso convenios DyS;Server=ICARUS"


FECHALISTADO=request("FECHA")
IF (ISNULL(FECHALISTADO)) OR (FECHALISTADO="") THEN
FECHALISTADO=DATE()
END IF


SSQL="select UPPER(CODCOBRADOR) AS COB,COUNT(*) AS CANT, SUM(TOTAL) AS MONTO "
SSQL= SSQL + "from   consolidadosconveniosdys "
SSQL= SSQL + "WHERE datepart(year,fechaGESTION)= "& YEAR(FECHALISTADO)
SSQL= SSQL + " and datepart(month,fechaGESTION)= "& MONTH(FECHALISTADO)
SSQL= SSQL + " and datepart(day,fechaGESTION)="& DAY(FECHALISTADO)
SSQL= SSQL + " GROUP BY CODCOBRADOR ORDER BY SUM(TOTAL) DESC,CODCOBRADOR ASC"
'RESPONSE.Write(SSQL)
'RESPONSE.End()
set rsCLI=Conn.execute(ssql)

%>

<style type="text/css">
<!--
.Estilo33 {color: #FF0000}
.Estilo34 {font-size: xx-small}
.Estilo35 {color: #FFFFFF}
-->
</style><font face="Arial, Helvetica, sans-serif">
<div align="center">
<form name="form1" method="post" action="">
  <table width="530" border="1" cellspacing="2">
  	<tr  bordercolor="#999999" bgcolor="#<%=session("COLTABBG")%>" class="Estilo13">
      <td width=100%><div align="center"><strong>CONVENIOS
          DEL DIA</strong></div></td>
	</TR>
</table>
	<table width="530" border="1" cellspacing="2" background="../images/fondo_coventa.jpg">
    <tr  bordercolor="#999999" bgcolor="#<%=session("COLTABBG")%>" class="Estilo13">
      <td width="28" height="21"><font color="#FFFFFF"><strong>N&ordm;</strong></font></td>
      <td width="154"><div align="center"><font color="#FFFFFF"><strong>COBRADOR</strong></font></div></td>
      <td width="166"><div align="center"><font color="#FFFFFF"><strong>CONVENIOS</strong></font></div></td>
	  <td width="154" bordercolor="#FFFFFF"><div align="center"><font color="#FFFFFF"><strong>MONTO</strong></font></div></td>
	  <td width="154" bordercolor="#FFFFFF"><div align="center"><font color="#FFFFFF"><strong>DETALLES</strong></font></div></td>
    </tr>
	<% CONT=0
		CONV=0
		CANT=0
	WHILE not (rsCLI.eof)
	%>
    <tr>
      <td bordercolor="#999999" bgcolor="#<%=session("COLTABBG")%>" class="Estilo13"><strong><%CONT=CONT+1
	  RESPONSE.WRITE(CONT)%></strong></td>
      <td ><STRONG><%=rsCLI("COB")%></STRONG></td>
      <td><div align="center"><%CONV=CONV + rsCLI("CANT")
	  RESPONSE.WRITE(rsCLI("CANT")) %></div></td>
	  <td><div align="center"><%CANT=CANT + CDBL(rsCLI("MONTO"))
	  RESPONSE.WRITE(CDBL(rsCLI("MONTO")))%></div></td>
	  <td><div align="center"><A HREF="DETALLECONVENIOSDYS.ASP?cobrador=<%=TRIM(rsCLI("COB"))%>&fecha=<%=fechalistado%>">VER</A></div></td>

    </tr>
	<%rsCLI.MOVENEXT
	WEND%>

    <tr>
      <td bordercolor="#999999" bgcolor="#<%=session("COLTABBG")%>" class="Estilo13">&nbsp;</td>
      <td bordercolor="#999999" bgcolor="#<%=session("COLTABBG")%>" class="Estilo13"><strong>TOTALES</strong></td>
      <td><div align="center"><STRONG><%=CONV%></STRONG></div></td>
	  <td><div align="center"><STRONG><%=CANT%></STRONG></div></td>
	    <td><div align="center"><A HREF="DETALLECONVENIOSDYS.ASP?fecha=<%=fechalistado%>"><font color="#FF0000">VER TODOS</font></A></div></td>
    </tr>
    <tr>
	      <td bordercolor="#999999" bgcolor="#<%=session("COLTABBG")%>" class="Estilo13">&nbsp;</td>
	      <td bordercolor="#999999" bgcolor="#<%=session("COLTABBG")%>" class="Estilo13"><strong>TOTALES</strong></td>
	      <td><div align="center"><STRONG><%=CONV%></STRONG></div></td>
		  <td><div align="center"><STRONG><%=CANT%></STRONG></div></td>
		    <td><div align="center"><A HREF="DETALLECONVENIOSDYS2.ASP?fecha=<%=fechalistado%>"><font color="#FF0000">VER TODOS (SOLO CONVENIOS)</font></A></div></td>
    </tr>
  </table>
</form></div>
</font>

<%
Conn.close
set Conn = nothing
%>
</body>
</html>
