<%@ LANGUAGE="VBScript" %>
<% ' Capa 1 ' %>


<%
	Set ConexionOra = Server.CreateObject("ADOdb.Connection")
	ConexionOra.Open "Provider=OraOLEDB.Oracle;Data Source=net_orion;User Id=SCC;PASSWORD=andromeda;"
	''ConexionOra.Open "Provider=OraOLEDB.Oracle;Data Source=net_sadi;User Id=bde34;PASSWORD=netlle;"

	Response.write "HOLA intranet"

	Set rs = Server.CreateObject("ADODB.Recordset")
	strSql = "SELECT * FROM T_JUICIO WHERE JUICIO = 538786"
	Response.write "strSql="&strSql
	rs.Open strSql , ConexionOra
	If Not rs.EOF Then
		TraeDatosDeudorSinClienteSCP = rs("RUT")
	Else
		TraeDatosDeudorSinClienteSCP = ""
	End If

	Response.write "rut="&TraeDatosDeudorSinClienteSCP
%>

