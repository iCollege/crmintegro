<% 
If InStr(Request.ServerVariables ("PATH_TRANSLATED"), "login.asp") <= 0  Then
	If Session("intCodUsuario") = "" Then %>
	<SCRIPT LANGUAGE=JavaScript>
		alert('Su sesi?n ha expirado');
		parent.self.close()
	</SCRIPT>
	<%
	Response.End
	End If
End If
%>