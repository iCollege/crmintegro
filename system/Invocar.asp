<%@LANGUAGE="VBSCRIPT" CODEPAGE="1252"%>
<!-- #include file = "funcion.asp" -->
<%
strFecha = Request.Form("fecha")
strSoap = "<?xml version='1.0' encoding='utf-8'?>"& _
"<soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'>"& _
"<soap:Body>"& _
"<Indicadores xmlns='Indicadores'>"& _
"<Fecha>"&strFecha&"</Fecha>"& _
"</Indicadores>"& _
"</soap:Body>"& _
"</soap:Envelope>"
strSOAPAction = "Indicadores/Indicadores"
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>http://turboprogramacion.blogspot.com</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
</head>
<body>
<%
Dim xmlResponse
If InvocarWebService (strSoap, strSOAPAction, "http://www.desachile.com/webservice.asmx?WSDL", xmlResponse) Then
 Response.Write(LeeXml(xmlResponse))
Else
    Response.Write "*** Ha ocurrido un Error ***"
End If
Set xmlResponse = Nothing
%>
</body>
</html>
