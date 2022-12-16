<%@ LANGUAGE="VBScript" %>

<% ' Capa 1 ' %>
<!--#include file="asp/comunes/odbc/ADOVBS.INC" -->
<!--#include file="arch_utils.asp"-->
<!--#include file="asp/comunes/odbc/insertUpdate.inc"-->
<!--#include file="asp/comunes/odbc/ObtenerRecordset.inc"-->

<% ' Capa 2 ' %>
<!--#include file="asp/comunes/insert/Notificacion.inc"-->
<!--#include file="asp/comunes/recordset/Notificacion.inc"-->
<!--#include file="asp/comunes/general/funciones.inc"-->
<%

AbrirSCG()

If Request("strFormMode") = "Nuevo" Then
	If Trim(request("IDDEMANDA")) <> "" AND  Trim(request("IDNOTIFICACION")) <> "" Then
		recordset_Notificacion Conn, srsRegistro, request("IDDEMANDA"), request("IDNOTIFICACION")
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

If Trim(request("IDDEMANDA")) = "" Then
	IntIdDemanda = request("IntIdDemanda")
Else
	IntIdDemanda = request("IDDEMANDA")
End if


If request("IDNOTIFICACION") <> "" Then
	IntIdNotificacion = request("IDNOTIFICACION")
Else
	strSql=""
	strSql="SELECT MAX(IDNOTIFICACION)+1 AS IDNOTIFICACION FROM DEMANDA_NOTIF WHERE IDDEMANDA = " & IntIdDemanda
	set rsCOR = Conn.execute(strSql)
	If not rsCOR.eof then
		IntIdNotificacion = rsCOR("IDNOTIFICACION")
		if isNULL(IntIdNotificacion) THEN
			IntIdNotificacion= "1"
		end if
	Else
		IntIdNotificacion= "1"
	End if
End if

Set dicNotificacion = CreateObject("Scripting.Dictionary")
dicNotificacion.Add "IDDEMANDA", IntIdDemanda
dicNotificacion.Add "IDNOTIFICACION", IntIdNotificacion
dicNotificacion.Add "IDUSUARIO", session("session_idusuario")
dicNotificacion.Add "FECHA", ValNulo(request("FECHA"),"C")
dicNotificacion.Add "BOLETA", ValNulo(request("BOLETA"),"C")
dicNotificacion.Add "PATENTE", ValNulo(request("PATENTE"),"C")
dicNotificacion.Add "OBSERVACIONES", ValNulo(request("OBSERVACIONES"),"C")
dicNotificacion.Add "VALOR", ValNulo(request("VALOR"),"N")
dicNotificacion.Add "IDESTADONOTIF", ValNulo(request("CB_TIPONOTIF"),"N")

insert_Notificacion Conn, dicNotificacion


'strSql=""
'strSql="SELECT IsNull(GASTOS_JUDICIALES,0) as GASTOS_JUDICIALES FROM DEMANDA WHERE IDDEMANDA = " & IntIdDemanda
'set rsGastosJud = Conn.execute(strSql)
'If not rsGastosJud.Eof then
'	If rsGastosJud("GASTOS_JUDICIALES") = 0 Then
		strSql="SELECT IsNull(Sum(Valor),0) as TOTAL FROM DEMANDA_NOTIF WHERE IDDEMANDA = " & IntIdDemanda
		set rsTotal = Conn.execute(strSql)
		if not rsTotal.Eof Then
			strSql="UPDATE DEMANDA SET GASTOS_JUDICIALES = " & rsTotal("TOTAL") & ", TOTAL_APAGAR = MONTO + GASTOS_JUDICIALES + HONORARIOS + INTERESES + INDEM_COMPENSATORIA WHERE IDDEMANDA = " & IntIdDemanda
			set rsExec=Conn.execute(strSql)
		End if
'	End if
'End if

CerrarSCG()
Response.Redirect "man_DemandaForm.asp?IDDEMANDA=" & IntIdDemanda
%>


