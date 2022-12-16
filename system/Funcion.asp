<%
Function LeeXml(responseText)
 Dim xmlResponse
 Dim xnodelist
 Dim indicadores
 Dim id, uf, usd, euro, utm, tcm, fecha

 indicadores = ""
 If Len(responseText) <> 0 Then
  Set xmlResponse = CreateObject("MSXML2.DOMDocument")
  xmlResponse.async = false
  xmlResponse.loadXml responseText
  Set xnodelist = xmlResponse.documentElement.selectNodes("/soap:Envelope/soap:Body/IndicadoresResponse/IndicadoresResult/diffgr:diffgram/NewDataSet/indicadores")
  Dim objItem

  For Each objItem In xnodelist
   id = objItem.selectSingleNode("id").Text
   uf = objItem.selectSingleNode("uf").Text
   usd = objItem.selectSingleNode("usd").Text
   euro = objItem.selectSingleNode("euro").Text
   utm = objItem.selectSingleNode("utm").Text
   tcm = objItem.selectSingleNode("tcm").Text
   fecha = objItem.selectSingleNode("fecha").Text
  Next

  indicadores = "<TABLE CELLSPACING='1' bgcolor='#dedede' ALIGN=CENTER WIDTH='250'>" & _
      "<TR bgcolor='#f0f0f0'>" & _
      "<TD>UF</TD>" & _
      "<TD align='right'>"&uf&"</TD>" & _
      "</TR>" & _
      "<TR bgcolor='#f0f0f0'>" & _
      "<TD>UTM</TD>" & _
      "<TD align='right'>"&utm&"</TD>" & _
      "</TR>" & _
      "<TR bgcolor='#f0f0f0'>" & _
      "<TD>D&oacute;lar Observado</TD>" & _
      "<TD align='right'>"&usd&"</TD>" & _
      "</TR>" & _
      "<TR bgcolor='#f0f0f0'>" & _
      "<TD>Euro</a></TD>" & _
      "<TD align='right'>"&euro&"</TD>" & _
      "</TR>" & _
      "</TABLE>"
 End If

 LeeXml = indicadores
End Function

Function InvocarWebService (strSoap, strSOAPAction, strURL, ByRef xmlResponse)
    Dim xmlhttp
    Dim blnSuccess

  Set xmlhttp = server.CreateObject("WinHttp.WinHttpRequest.5.1")
        xmlhttp.Open "POST", strURL
        xmlhttp.setRequestHeader "Man", "POST " & strURL & " HTTP/1.1"
        xmlhttp.setRequestHeader "Content-Type", "text/xml; charset=utf-8"
        xmlhttp.setRequestHeader "SOAPAction", strSOAPAction
        call xmlhttp.send(strSoap)

        If xmlhttp.Status = 200 Then
            blnSuccess = True
        Else
           blnSuccess = False
        End If

  xmlResponse = xmlhttp.ResponseText
        InvocarWebService = blnSuccess
        Set xmlhttp = Nothing
End Function
%>