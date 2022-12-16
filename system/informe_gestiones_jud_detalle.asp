<% @LCID = 1034 %>
<!--#include file="arch_utils.asp"-->
<!--#include file="../lib/comunes/rutinas/funciones.inc" -->
<!--#include file="../lib/comunes/rutinas/rutinasFecha.inc" -->
<!--#include file="../lib/comunes/rutinas/funcionesBD.inc" -->
<!--#include file="../lib/comunes/rutinas/TraeCampo.inc" -->
<!--#include file="lib.asp"-->

<%

intTipoGestion=Request("intTipoGestion")
intDia=Request("intDia")
intMes=Request("intMes")
intAno=Request("intAno")
intEjecutivo=Request("intEjecutivo")
strCliente=Request("strCliente")

'Response.write "<br>intDia= " & intDia
'Response.End

codcategoria = Mid(request("GESTION"),1,1)
codsubcategoria = Mid(request("GESTION"),2,1)
codgestion = Mid(request("GESTION"),3,1)

abrirscg()
If Trim(intTipoGestion) = "P" Then
	strSql = "SELECT rutdeudor,codcategoria,codsubcategoria,IsNull(codgestion,0) as "
	strSql = strSql & " codgestion,fechaingreso,horaingreso,codcobrador,IsNull(fechacompromiso,'') as fechacompromiso,IsNull(observaciones,'&nbsp') as observaciones, isnull(dbo.fun_trae_deuda_vigente (codcliente,rutdeudor),'') as deuda_vigente , dbo.fun_EstapaCobranzaDeudor (rutdeudor,codcliente) as etapa_cobranza , "
	strSql = strSql & " convert(varchar(2),codcategoria) + convert(varchar(2),codsubcategoria) + "
	strSql = strSql & " convert(varchar(2),IsNull(codgestion,0)) as CODGESTION, IDUSUARIO , TELEFONO_ASOCIADO FROM GESTIONES "
	If Trim(strCliente) <> "" Then
		strSql = strSql & " WHERE CODCLIENTE='" & strCliente & "' AND"
	Else
		strSql = strSql & " WHERE"
	End If
	strSql = strSql & " DAY(FECHAINGRESO) = " & intDia & " AND MONTH(FECHAINGRESO) = " & intMes & " AND YEAR(FECHAINGRESO) = " & intAno

	If Trim(intEjecutivo) <> "" Then
		strSql = strSql & " AND IDUSUARIO = " & intEjecutivo
	End If

	'strSql = strSql & " GROUP BY RUTDEUDOR,CODCATEGORIA,CODSUBCATEGORIA,ISNULL(CODGESTION,0), "
	'strSql = strSql & " FECHAINGRESO,HORAINGRESO,CODCOBRADOR,FECHACOMPROMISO,OBSERVACIONES ,CODGESTION, IDUSUARIO, TELEFONO_ASOCIADO "
	'strSql = strSql & " ORDER BY RUTDEUDOR,CODCATEGORIA,CODSUBCATEGORIA,ISNULL(CODGESTION,0),FECHAINGRESO,HORAINGRESO,CODCOBRADOR,FECHACOMPROMISO,OBSERVACIONES,IDUSUARIO "

Else
	strSql = "SELECT rutdeudor,nomgestion,fechaingreso,horaingreso,IsNull(fechacompromiso,'') as fechacompromiso,IsNull(observaciones,'&nbsp') as observaciones, '' AS TELEFONO_ASOCIADO, isnull(usr_cob.fun_trae_deuda_vigente (codcliente,rutdeudor),'') as deuda_vigente, usr_cob.fun_EstapaCobranzaDeudor (rutdeudor,codcliente) as etapa_cobranza, "
	strSql = strSql & " IdUsuario FROM GESTIONES_JUDICIAL G, GESTION_JUDICIAL J"
	If Trim(strCliente) <> "" Then
		strSql = strSql & " WHERE G.IDGESTIONJUDICIAL = J.IDGESTION AND G.CODCLIENTE='" & strCliente & "' AND"
	Else
		strSql = strSql & " WHERE G.IDGESTIONJUDICIAL = J.IDGESTION AND"
	End If
	strSql = strSql & " DAY(FECHAINGRESO) = " & intDia & " AND MONTH(FECHAINGRESO) = " & intMes & " AND YEAR(FECHAINGRESO) = " & intAno


	If Trim(intEjecutivo) <> "" Then
		strSql = strSql & " AND G.IDUSUARIO = " & intEjecutivo
	End If



End If


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
	<td>Deuda vigente</td>
	<td>Etapa Cobranza</td>
	<td>Observaciones</td>
</tr>
<%
Do while not rsGES.eof

If Trim(rsges("observaciones"))="" Then strObservaciones = "&nbsp;" Else strObservaciones = rsges("observaciones")
If Trim(rsges("deuda_vigente"))="" Then strDeudaVigente = "0" Else strDeudaVigente = rsges("deuda_vigente")

If Trim(Mid(rsges("fechacompromiso"),1,10))="01/01/1900" Then strFecComp = "&nbsp;" Else strFecComp = rsges("fechacompromiso")

strEjecutivo = TraeCampoId(Conn, "NOMBRES_USUARIO", Trim(rsges("IDUSUARIO")), "USUARIO", "ID_USUARIO") & "-" & TraeCampoId(Conn, "APELLIDOS_USUARIO", Trim(rsges("IDUSUARIO")), "USUARIO", "ID_USUARIO")

If Trim(intTipoGestion) = "P" Then
	strSql = "SELECT G.CODCATEGORIA, G.CODSUBCATEGORIA, G.CODGESTION,C.DESCRIPCION + ' ' + S.DESCRIPCION + ' ' +  G.DESCRIPCION as DESCRIP"
	strSql = strSql & " FROM GESTIONES_TIPO_CATEGORIA C, GESTIONES_TIPO_SUBCATEGORIA S, GESTIONES_TIPO_GESTION G"
	strSql = strSql & " WHERE C.CODCATEGORIA = S.CODCATEGORIA"
	strSql = strSql & " AND C.CODCATEGORIA = G.CODCATEGORIA"
	strSql = strSql & " AND S.CODSUBCATEGORIA = G.CODSUBCATEGORIA"
	strSql = strSql & " AND CAST(G.CODCATEGORIA AS VARCHAR(2)) + CAST(G.CODSUBCATEGORIA AS VARCHAR(2)) + CAST(G.CODGESTION AS VARCHAR(2)) = '" & rsges("CODGESTION") & "'"

	'Response.write "strSql="&strSql
	'Response.End

	SET rsNomGestion=Conn.execute(strSql)
	If Not rsNomGestion.Eof Then
		strNomGestion = rsNomGestion("DESCRIP")
	Else
		strNomGestion = ""
	End If
Else
	strNomGestion=rsges("nomgestion")
End If

%>

<tr>
	<td class="DatosDeudorTexto" ><a href='principal.asp?RUT=<%= rsges("rutdeudor") %>'><font class="TextoDatos"><%= rsges("rutdeudor") %></font></a></td>
	<td class="DatosDeudorTexto" ><font class="TextoDatos"><%= rsges("fechaingreso") %></font></td>
	<td class="DatosDeudorTexto"><font class="TextoDatos"><%= rsges("horaingreso") %></font></td>
	<td class="DatosDeudorTexto"><font class="TextoDatos"><%= rsges("telefono_asociado") %></font></td>
	<td class="DatosDeudorTexto" align="">
	<font class="TextoDatos">
	<%= Trim(strNomGestion) %>
	</font></td>
	<td class="DatosDeudorTexto"><font class="TextoDatos"><%= strEjecutivo %></font></td>
	<td class="DatosDeudorTexto"><font class="TextoDatos"><%= strFecComp %></font></td>
	<td class="DatosDeudorTexto"><font class="TextoDatos">$ <%= FN ((strDeudaVigente),0) %></font></td>
	<td class="DatosDeudorTexto"><CENTER><font class="TextoDatos"><%= rsges("etapa_cobranza") %></CENTER></font></td>
	<td class="DatosDeudorTexto" ><font class="TextoDatos"><%= strObservaciones %></font></td>

</tr>

<%
	rsGES.movenext
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
