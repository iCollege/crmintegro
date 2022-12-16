<%@LANGUAGE="VBSCRIPT" CODEPAGE="1252"%>
<html>
<link href="style.css" rel="stylesheet" type="text/css">

<head>
<title>Documento sin t&iacute;tulo</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<script language="javascript">

    function goExportarExcel(datos)    {
		//with( document.Free){
		//alert(datos);
		  open("DETALLECONVENIOSDYS_excel.ASP?" + datos);
		  //action = "cons_recaudacion_consolidado_excel_sdr.asp?";
		  //submit();
	//	}
    }
 </script>
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


cobrador=request("cobrador")
fecha=request("fecha")

conta=0
ssql="SELECT * FROM consolidadosconveniosdys "
ssql=ssql+"WHERE "
IF (NOT ISNULL(cobrador)) AND (cobrador<>"") THEN
SSQL=SSQL + "CODCOBRADOR='" & cobrador & "' AND "
END IF
ssql=ssql+" datepart(year,fechaGESTION)="& year(fecha)
ssql=ssql+" and datepart(month,fechaGESTION)="& month(fecha)
ssql=ssql+" and datepart(day,fechaGESTION)="& DAY(fecha) & " ORDER BY CODCOBRADOR"
'RESPONSE.Write(SSQL)
'RESPONSE.End()
set rsCLI=Conn.execute(ssql)

%>

<div align="center">
<form name="form1" method="post" action="">
<table width="810"  border="1" cellspacing="2">
  <tr bordercolor="#999999" bgcolor="#<%=session("COLTABBG")%>" class="Estilo13">
    <td width=100% ><div align="center"> <STRONG>DETALLE CONVENIOS DE : <%=ucase(COBRADOR)%> </STRONG></div></td>
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
<% rsCLI.movenext
	wend
%>
  </tr>


</table>
  <br>
   <a href="javascript:goExportarExcel('<% if session("session_tipo")<>"COB_GER" then
   		response.write("cobrador="+ trim(session("session_login")) + "&")
	end if
		response.write("fecha=" & date())
    %>');"><img src="../images/exportarex.gif" width="120" height="16"></a>
  </form>
  <p>&nbsp;</p>
</div>
</body>
<%
Conn.close
set Conn = nothing
%>
</html>
