<% @LCID = 1034 %>
<!--#include file="arch_utils.asp"-->
<!--#include file="asp/comunes/general/rutinasBooleano.inc"-->
<!--#include file="../lib/comunes/rutinas/funciones.inc" -->
<!--#include file="../lib/comunes/rutinas/rutinasFecha.inc" -->
<!--#include file="../lib/comunes/rutinas/funcionesBD.inc" -->
<!--#include file="../lib/comunes/rutinas/TraeCampo.inc" -->
<!--#include file="lib.asp"-->

<%
hdd_cod_cliente = request("cmb_cliente")
txt_FechaIni = request("txt_FechaIni")
txt_FechaFin = request("txt_FechaFin")

'Response.write "<br>GESTION=" & request("GESTION")
'Response.End

intCodEjecutivo = request("intCodEjecutivo")
intCodCampana = request("intCodCampana")
If Trim(request("GESTION")) <> "" Then
	arrGestion = split(request("GESTION"),"-")
	codcategoria = arrGestion(0)
	codsubcategoria = arrGestion(1)
	codgestion = arrGestion(2)
End If




'codcategoria = Mid(request("GESTION"),1,1)
'codsubcategoria = Mid(request("GESTION"),2,1)
'codgestion = Mid(request("GESTION"),3,1)

abrirscg()


strSql = "SELECT rutdeudor,codcategoria,codsubcategoria,ISnull(codgestion,0) as "
strSql = strSql & " codgestion,fechaingreso,horaingreso,codcobrador,IsNull(fechacompromiso,'') as fechacompromiso,IsNull(observaciones,'&nbsp') as observaciones, "
strSql = strSql & " convert(varchar(2),codcategoria) + convert(varchar(2),codsubcategoria) + "
strSql = strSql & "	convert(varchar(2),IsNull(codgestion,0)) as CODGESTION, IDUSUARIO , TELEFONO_ASOCIADO FROM GESTIONES "
strSql = strSql & "	WHERE CODCLIENTE='" & hdd_cod_cliente & "'"


If Trim(codcategoria) <> "" and Trim(codsubcategoria) <> "" and Trim(codgestion) <> "" Then
	strSql = strSql & "	AND  CodCategoria='" & codcategoria & "'"
	strSql = strSql & "	AND CodSubCategoria='" & codsubcategoria & "'"
	strSql = strSql & "	AND  CodGestion='" & codgestion & "'"
End if





If Trim(codcategoria) <> "" and Trim(codsubcategoria) <> "" and Trim(codgestion) <> "" Then
	strSql = strSql & "	AND  CodCategoria='" & codcategoria & "'"
	strSql = strSql & "	AND CodSubCategoria='" & codsubcategoria & "'"
	strSql = strSql & "	AND  CodGestion='" & codgestion & "'"
End if

strSql = strSql & " AND RUTDEUDOR IN (SELECT RUTDEUDOR FROM DEUDOR "
strSql = strSql & "	WHERE CODCLIENTE='" & hdd_cod_cliente & "' AND ULTIMA_GESTION = '" & request("GESTION") & "')"


'strSql = strSql & "	AND FechaIngreso>='" & txt_FechaIni & "'"
'strSql = strSql & "	AND FechaIngreso<='" & txt_FechaFin & "'"

If TraeSiNo(session("perfil_adm"))="Si" or TraeSiNo(session("perfil_sup"))="Si" Then
	If Trim(intCodEjecutivo) <> "" Then
			strSql = strSql & "	AND IDUSUARIO = " & intCodEjecutivo
	End If

Else
	If Trim(intCodEjecutivo) <> "" Then
		strSql = strSql & "	AND IDUSUARIO = " & intCodEjecutivo
	Else
		strSql = strSql & "	AND IDUSUARIO = " & session("session_idusuario")
	End If
End If

If Trim(intCodCampana) <> "" Then
	strSql = strSql & "	AND IDCAMPANA = " & intCodCampana
End If


strSql = strSql & "	group by rutdeudor,codcategoria,codsubcategoria,ISnull(codgestion,0), "
strSql = strSql & "	fechaingreso,horaingreso,codcobrador,fechacompromiso,observaciones ,CODGESTION, IDUSUARIO , TELEFONO_ASOCIADO  "
strSql = strSql & " order by rutdeudor,codcategoria,codsubcategoria,ISnull(codgestion,0), "
strSql = strSql & " fechaingreso,horaingreso,codcobrador,fechacompromiso,observaciones,IDUSUARIO , TELEFONO_ASOCIADO "
'Response.write strSql
'Response.End


SET rsGES=Conn.execute(strSql)
%>
<title>Detalle Gestiones</title>
<style type="text/css">
<!--
.Estilo37 {color: #FFFFFF}
-->
</style>
<body>
<form name="Free" method="post">
<center>

<table width="100%" border="0" cellspacing="0" cellpadding="0" class="Estilo13">
<tr  class="Estilo20">
<td width="100%" align="LEFT"><a href="javascript:history.back();">Volver</a></td>
<!--td ><a href="javascript:goExportarExcel();"><img src="../images/exportarex.gif" alt=""  border="0"></a></td-->
</tr>
</table>

<table width="100%" border="1" bordercolor = "#<%=session("COLTABBG")%>" cellSpacing=0 cellPadding=2>

<tr bgcolor="#<%=session("COLTABBG")%>" class="Estilo13">
	<td>Rut&nbsp;&nbsp;Deudor</td>
	<td>Fecha Ingreso</td>
	<td>Hora Ingreso</td>
	<td>Fono</td>
	<td>Gestión</td>
	<td>Ejecutivo</td>
	<td>Fecha Compromiso</td>
	<td>Observaciones</td>
</tr>
<%Do while not rsGES.eof

If Trim(rsges("observaciones"))="" Then strObservaciones = "&nbsp;" Else strObservaciones = rsges("observaciones")
If Trim(Mid(rsges("fechacompromiso"),1,10))="01/01/1900" Then strFecComp = "&nbsp;" Else strFecComp = rsges("fechacompromiso")

strEjecutivo = TraeCampoId(Conn, "NOMBRES_USUARIO", Trim(rsges("IDUSUARIO")), "USUARIO", "ID_USUARIO") & "-" & TraeCampoId(Conn, "APELLIDOS_USUARIO", Trim(rsges("IDUSUARIO")), "USUARIO", "ID_USUARIO")

strSql = "SELECT G.CODCATEGORIA, G.CODSUBCATEGORIA, G.CODGESTION,C.DESCRIPCION + ' ' + S.DESCRIPCION + ' ' +  G.DESCRIPCION as DESCRIP"
strSql = strSql & " FROM GESTIONES_TIPO_CATEGORIA C, GESTIONES_TIPO_SUBCATEGORIA S, GESTIONES_TIPO_GESTION G"
strSql = strSql & " WHERE C.CODCATEGORIA = S.CODCATEGORIA"
strSql = strSql & " AND C.CODCATEGORIA = G.CODCATEGORIA"
strSql = strSql & " AND S.CODSUBCATEGORIA = G.CODSUBCATEGORIA"
strSql = strSql & " AND CAST(G.CODCATEGORIA AS VARCHAR(2)) + CAST(G.CODSUBCATEGORIA AS VARCHAR(2)) + CAST(G.CODGESTION AS VARCHAR(2)) = '" & rsges("CODGESTION") & "'"

SET rsNomGestion=Conn.execute(strSql)
If Not rsNomGestion.Eof Then
	strNomGestion = rsNomGestion("DESCRIP")
Else
	strNomGestion = ""
End If

%>

<tr>
	<td class="DatosDeudorTexto" ><font class="TextoDatos">
	<A HREF="principal.asp?rut=<%=rsges("rutdeudor")%>"><acronym title="Llevar a pantalla de selección"><%=rsges("rutdeudor")%></acronym></A>
	</font></td>
	<td class="DatosDeudorTexto" ><font class="TextoDatos"><%= rsges("fechaingreso") %></font></td>
	<td class="DatosDeudorTexto"><font class="TextoDatos"><%= rsges("horaingreso") %></font></td>
	<td class="DatosDeudorTexto"><font class="TextoDatos"><%= rsges("telefono_asociado") %></font></td>
	<td class="DatosDeudorTexto" align="">
	<font class="TextoDatos">
	<%= Trim(strNomGestion) %>
	</font></td>
	<td class="DatosDeudorTexto"><font class="TextoDatos"><%= strEjecutivo %></font></td>
	<td class="DatosDeudorTexto"><font class="TextoDatos"><%= strFecComp %></font></td>
	<td class="DatosDeudorTexto" ><font class="TextoDatos"><%= strObservaciones %></font></td>

</tr>

<%rsGES.movenext
	Loop%>
</table>
<form>
<input type="Hidden" name="cmb_cliente">
</form>

</body>


</html>

<%
rsGES.close
set rsGES=nothing
cerrarscg()
%>

<script language="javascript">
function goPagina()
{	with( document.Free )
	{	action = goPagina.arguments[0];
		submit()
	}
}
function goCambiaMes()
{	with( document.Free)
	{	action = "../informes/cargando.asp?strEnlace='mis_gestiones.asp'";
		submit();
	}
}

function goExportarExcel()
{   with( document.Free)
    {
        open("detalle_excel.asp?cmb_cliente=<%=hdd_cod_cliente%>&codcategoria=<%=codcategoria%>&codsubcategoria=<%=codsubcategoria%>&codgestion=<%=codgestion%>&txt_FechaIni=<%=txt_FechaIni%>&txt_FechaFin=<%=txt_FechaFin%>");
        //submit();
    }
}
function Refrescar()
{

	if(!chkFecha(document.Free.txt_FechaIni))
	{
		document.Free.txt_FechaIni.focus()
		document.Free.txt_FechaIni.select()
		return
	}

	if(!chkFecha(document.Free.txt_FechaFin))
	{
		document.Free.txt_FechaFin.focus()
		document.Free.txt_FechaFin.select()
		return
	}

	with( document.Free )
	{
		//action = 'cons_gestion_consolidado.asp';
		action = "cargando.asp?strEnlace='cons_gestion_consolidado_intranet1.asp'";
		submit();
	}
}

</script>
