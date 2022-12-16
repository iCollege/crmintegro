
<SCRIPT RUNAT=Server LANGUAGE="VBScript">

'-------------------------------------------------------------------------------
' Propósito:
' Entradas:
' Returns:
'-------------------------------------------------------------------------------

Function FN(Valor, Cant)
	If IsNull(Valor) or Trim(Valor)="" Then Valor=0
	FN=Trim(FormatNumber(Valor, Cant))
End Function

Function SacaFN(Valor)
	SacaFN = Valor
	SacaFN=Trim(Replace(SacaFN,",",""))
	SacaFN=Trim(Replace(SacaFN,".",""))
End Function

Function Saca1900(intFecha)
	If intFecha = "01/01/1900" Then
		Saca1900 = ""
	Else
		Saca1900 = intFecha
	End if
End Function

Function ValNulo(Valor, Tipo)
    If IsNull(Valor) Or Trim(Valor) = "" Then
        Select Case Tipo
            Case "N" 'Numerico
               ValNulo = 0
            Case "C" 'Caracteres
                ValNulo = ""
            Case "F" 'Fecha
               ValNulo = Format("01-01-1900", "DD-MM-YYYY")
       End Select
    Else
        If Tipo = "N" Then
             ValNulo = Valor
        ElseIf Tipo = "F" Then
            ValNulo = Valor
        ElseIf Tipo = "C" Then
            ValNulo = Trim(Valor)
        End If
    End If
End Function


Function GastosCobranzas(intSaldo)
	If intSaldo <= 10 * session("valor_uf")  Then
		intIntHon = 9/100
		intIntHono1 = intIntHon * intSaldo
		intRemanente = 0
	Elseif intSaldo > 10 * session("valor_uf")  Then
		intIntHon = 9/100
		intIntHono1 = intIntHon * 10 * session("valor_uf")
		intRemanente = intSaldo-(10 * session("valor_uf"))
	End If

	If intRemanente > 0 Then
		If intRemanente > 10 * session("valor_uf") and intRemanente <= 50 * session("valor_uf") Then
			intIntHon = 6/100
			intIntHono2 = intIntHon * intRemanente
			intRemanente = 0
			
		ElseIf intRemanente > 50 * session("valor_uf") Then
			intIntHon = 6/100
			intIntHono2 = intIntHon * (40 * session("valor_uf") )
			intRemanente = intRemanente - 40 * session("valor_uf")
		Else
			intIntHon = 6/100
			intIntHono2 = intIntHon * intRemanente
			intRemanente = intRemanente - 50 * session("valor_uf")

		End If
	End If

	If intRemanente > 0 Then
		If intRemanente >= 50 * session("valor_uf") Then
			'intIntHon = 3/100
			'intRemanente = intRemanente - 50 * session("valor_uf")
			'intIntHono3 = intIntHon * intRemanente
			intIntHon = 3/100
			intIntHono3 = intIntHon * intRemanente
			intRemanente = 0
		Else
			intIntHon = 3/100
			intIntHono3 = intIntHon * intRemanente
			intRemanente = 0
		End If
	End If
	'Response.write "intIntHono1=" & intIntHono1
	'Response.write "intIntHono2=" & intIntHono2
	'Response.write "intIntHono3=" & intIntHono3
	GastosCobranzas = intIntHono1 + intIntHono2 + intIntHono3

End Function


Function HonorariosEspeciales1(intCapital,intMeses)
	If intMeses <= 10 Then
		intIntHon = (intCapital/10)*intMeses
	Else
		
		intIntHon = intCapital
	End If
	
	HonorariosEspeciales1 = intIntHon

End Function


</SCRIPT>