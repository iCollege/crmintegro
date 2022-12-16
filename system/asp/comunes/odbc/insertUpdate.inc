<SCRIPT LANGUAGE="VBScript" RUNAT="Server">
Sub insertUpdate ( ByRef Conn, ByRef dicRegistro, ByVal strSQLQuery)
  ' On Error Resume Next
 '  Response.Write "<pre>" & replace(strSQLQuery,"'","") & "</pre>"

 'Response.Write "<pre>" & ("exec sp_inserta_auditoria " & Session("intCodUsuario") & ", 'INSERTUPDATE', '" & strSQLQuery & "', '" & Request.ServerVariables("REMOTE_ADDR") & "', '" & Request.ServerVariables("REMOTE_USER") & "', '" & Request.ServerVariables("PATH_INFO") & "'")

  ' Realiza el UPDATE o INSERT segun el resultado anterior
  Set RS = Server.CreateObject("ADODB.Recordset")
  RS.ActiveConnection = Conn
  RS.CursorType = adOpenKeyset
  RS.LockType = adLockOptimistic
  RS.Open strSQLQuery, Conn
  If RS.EOF Then RS.AddNew
  For Each fldLoop In RS.Fields
 ' Response.Write "<pre>" & UCASE( fldLoop.Name ) & "=" & Trim(dicRegistro.Item( UCASE( fldLoop.Name ) )) & "</pre>"
    If Trim(dicRegistro.Item( UCASE( fldLoop.Name ) )) = "" Then
        fldLoop.Value = NULL
    ElseIf IsNull( dicRegistro.Item( UCASE( fldLoop.Name ) ) ) Then
        fldLoop.Value = NULL
    Else
    	strValor = dicRegistro.Item( UCASE( fldLoop.Name ) )
		If CInt( fldLoop.Type ) = 4 or CInt( fldLoop.Type ) = 5 or CInt( fldLoop.Type ) = 6 Then
			strValor = Replace(strValor , ".", ",")
		End If
		fldLoop.Value = strValor
    End If
  Next
  RS.Update()
  RS.Close
  Set RS = nothing
End Sub
</SCRIPT>