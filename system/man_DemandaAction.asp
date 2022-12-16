<%@ LANGUAGE="VBScript" %>

<% ' Capa 1 ' %>
<!--#include file="asp/comunes/odbc/ADOVBS.INC" -->
<!--#include file="arch_utils.asp"-->
<!--#include file="sesion.asp"-->
<!--#include file="asp/comunes/odbc/insertUpdate.inc"-->
<!--#include file="asp/comunes/odbc/ObtenerRecordset.inc"-->
<!--#include file="../lib/comunes/rutinas/GrabaAuditoria.inc" -->

<% ' Capa 2 ' %>
<!--#include file="asp/comunes/insert/Demanda.inc"-->
<!--#include file="asp/comunes/recordset/Demanda.inc"-->
<!--#include file="asp/comunes/general/funciones.inc"-->
<%

AbrirSCG()




If Request("strFormMode") = "Nuevo" Then
	If Trim(request("IDDEMANDA")) <> "" Then
		recordset_abogado Conn, srsRegistro, request("IDDEMANDA")
		If Not srsRegistro.EOF Then
			Response.Write "<P>Ya existe un registro con el código " &  request("IDDEMANDA")
			Response.Write "<P>Debe asignarle otro código si desea crear un registro nuevo"
			Response.Write "<FORM><INPUT VALUE=Volver TYPE=BUTTON onClick='javascript:history.back()'></FORM>"
			Response.End
		End If
	End If
End If
'Response.write "hola"
'Response.write "CB_BANCO" & request("CB_BANCO")
'Response.End

Set dicDemanda = CreateObject("Scripting.Dictionary")

dicDemanda.Add "IDDEMANDA", request("IDDEMANDA")
dicDemanda.Add "RUTDEUDOR", ValNulo(request("RUTDEUDOR"),"C")
dicDemanda.Add "CODCLIENTE", ValNulo(request("CB_CLIENTE"),"C")
dicDemanda.Add "IDTRIBUNAL", ValNulo(request("CB_TRIBUNAL"),"N")
dicDemanda.Add "ROLANO", ValNulo(request("ROLANO"),"C")
dicDemanda.Add "FECHA_INGRESO", ValNulo(request("FECHA_INGRESO"),"C")
dicDemanda.Add "FECHA_CADUCIDAD", ValNulo(request("FECHA_CADUCIDAD"),"C")
dicDemanda.Add "FECHA_PRES_ESCRITO", ValNulo(request("FECHA_PRES_ESCRITO"),"C")
dicDemanda.Add "TIPO_DEMANDA", ValNulo(request("CB_TIPO_DDA"),"C")
dicDemanda.Add "IDPROCURADOR", ValNulo(request("CB_PROCURADOR"),"C")
dicDemanda.Add "IDABOGADO", ValNulo(request("CB_ABOGADO"),"C")
dicDemanda.Add "IDACTUARIO", ValNulo(request("CB_ACTUARIO"),"C")
dicDemanda.Add "MONTO", ValNulo(request("MONTO"),"N")
dicDemanda.Add "FECHA_COMPARENDO", ValNulo(request("FECHA_COMPARENDO"),"C")
dicDemanda.Add "HORA_COMPARENDO", ValNulo(request("HORA_COMPARENDO"),"C")
dicDemanda.Add "RAZON_TERMINO", ValNulo(request("CB_RAZONTERMINO"),"N")
dicDemanda.Add "GASTOS_JUDICIALES", ValNulo(request("GASTOS_JUDICIALES"),"N")
dicDemanda.Add "HONORARIOS", ValNulo(request("HONORARIOS"),"N")
dicDemanda.Add "INTERESES", ValNulo(request("INTERESES"),"N")
dicDemanda.Add "INDEM_COMPENSATORIA", ValNulo(request("INDEM_COMPENSATORIA"),"N")
dicDemanda.Add "TOTAL_APAGAR", ValNulo(request("TOTAL_APAGAR"),"N")
dicDemanda.Add "IDESTADO", ValNulo(request("CB_ESTADODEMANDA"),"N")

insert_Demanda Conn, dicDemanda



aa = GrabaAuditoria("INSERTAR-MODIFICAR", "IDDEMANDA=" & request("IDDEMANDA"), "man_demandaAction.asp","DEMANDA")

'If Request("strFormMode") = "Nuevo" Then

	If Trim(request("IDDEMANDA")) = "" Then
		strSql="SELECT MAX(IDDEMANDA) as MAXIDDEMANDA FROM DEMANDA"
		set rsPropiedad=Conn.execute(strSql)
		If Not rsPropiedad.Eof Then
			intIDDEMANDA=rsPropiedad("MAXIDDEMANDA")
		End if
		rsPropiedad.close
		set rsPropiedad=nothing
	Else
		intIDDEMANDA=Trim(request("IDDEMANDA"))

	End If

	'Response.write "intIDDEMANDA= " & intIDDEMANDA
	'Response.write "prods= " & request("prods")
	'Response.End

	deudas = Split(request("prods"), "*")
	n=0
	For Each XX in deudas
			strSql=" UPDATE CUOTA SET IDDEMANDA = " & intIDDEMANDA
			strSql= strSql & " WHERE IDCUOTA = " & deudas(n)
			'Response.write(strSql)
			'Response.End
			Conn.execute(strSql)
		  n=n+1
	Next

'End If
CerrarSCG()
Response.Redirect "man_Demanda.asp"
%>
