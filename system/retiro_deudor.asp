<% @LCID = 1034 %>
<!--#include file="arch_utils.asp"-->
<!--#include file="../lib/comunes/rutinas/funciones.inc" -->
<!--#include file="../lib/comunes/rutinas/funcionesBD.inc" -->
<!--#include file="lib.asp"-->
<!--#include file="../lib/comunes/rutinas/TraeCampo.inc" -->
<!--#include file="asp/comunes/general/rutinasBooleano.inc" -->

<script language="JavaScript">
function ventanaSecundaria (URL){
window.open(URL,"DETALLE","width=200, height=200, scrollbars=no, menubar=no, location=no, resizable=no")
}
</script>

<%


strCliente=Request("CB_CLIENTE")
intCodRemesa=Request("CB_REMESA")
intGJ=Request("CB_GJUDICIAL")
strProbCobro=Request("CB_PROBABILIDAD")
intEjecutivo=Request("intEjecutivo")
intParaCarta=Request("intParaCarta")

strObservaciones = Trim(Request("observaciones"))

'Response.write "<br>observacion = " & Request("observaciones")

vObservaciones = split(strObservaciones,CHR(13))

'Response.write "<br>UBOUND = " & UBOUND(vObservaciones)

'Response.write "<br>V1 = " & vObservaciones(0)
'Response.write "<br>V2 = " & vObservaciones(1)

'Response.write "<br>ASC = " & ASC(MID(Request("observaciones"),11,1))



If Trim(intParaCarta) <> "1" Then
	strTitulo = "DEMANDAS"
Else
	strTitulo = "CARTAS"
End if
intDias=30

strRefrescar = Request("strRefrescar")

If Trim(strCliente) = "" Then strCliente = "1000"
'If Trim(intCodRemesa)	 = "" Then intCodRemesa = 100


''Response.write "<br>strRefrescar" & strRefrescar

If Trim(strRefrescar) = "C" AND Trim(strCliente) <> "" Then
	AbrirSCG()
	For indice = 0 to ubound(vObservaciones)

		strSql = "UPDATE CUOTA SET SALDO = 0, ESTADO_DEUDA = 2, FECHA_ESTADO = GETDATE() WHERE CODCLIENTE = '" & strCliente & "' AND ESTADO_DEUDA = 1 AND RUTDEUDOR = '" & vObservaciones(indice) & "'"
		set rsUpdate = Conn.execute(strSql)
		'Response.write "<BR>" & strSql

	Next
	CerrarSCG()

	%>
	<script>
			alert('Caso(s), retirados correctamente');
	</script>
	<%

End if

%>
<title>Estatus Cartera</title>

<style type="text/css">
<!--
.Estilo37 {color: #FFFFFF}
-->
</style>
<form name="datos" method="post">
<INPUT TYPE="HIDDEN" NAME="intGestion" VALUE="<%=intGestion%>">
<INPUT TYPE="HIDDEN" NAME="intParaCarta" VALUE="<%=intParaCarta%>">



<table width="100%" border="1" bordercolor="#FFFFFF">
	<tr>
		<TD height="20" ALIGN=LEFT class="pasos1_i">
			<B>RETIRO (DESASIGNACIONES MANUALES)</B>
		</TD>
	</tr>
</table>


<table width="100%" border="1" bordercolor="#FFFFFF">
	<tr>
				<td>
				Cliente
				</td>
				<td>
					<select name="CB_CLIENTE" OnChange="envia('R')">
						<%
						abrirscg()
						ssql="SELECT CODCLIENTE,RAZON_SOCIAL FROM CLIENTE ORDER BY RAZON_SOCIAL"
						set rsTemp= Conn.execute(ssql)
						if not rsTemp.eof then
							do until rsTemp.eof%>
							<option value="<%=rsTemp("CODCLIENTE")%>"<%if Trim(strCliente)=rsTemp("CODCLIENTE") then response.Write("Selected") End If%>><%=rsTemp("RAZON_SOCIAL")%></option>
							<%
							rsTemp.movenext
							loop
						end if
						rsTemp.close
						set rsTemp=nothing
						cerrarscg()
						%>
					</select>
				</td>
	</tr>
	<tr>
		<td>
			Rut deudor
		</td>
		<TD>

			<TEXTAREA NAME="observaciones" ROWS=30 COLS=20></TEXTAREA>


		</TD>
	</tr>

	<tr>
		<td>
			&nbsp;
		</td>
		<TD>
			<INPUT TYPE="BUTTON" value="Procesar" name="B1" onClick="envia('C');return false;">
		</TD>
	</tr>




</table>








<script language="JavaScript1.2">
function envia(intTipo)	{
	if (datos.CB_CLIENTE.value=='0'){
		alert('DEBE SELECCIONAR UN CLIENTE');
	}else{
		if (intTipo=='R'){
			datos.action='retiro_deudor.asp?strRefrescar=R';
		}else{
			datos.action='retiro_deudor.asp?strRefrescar=C';
		}
		datos.submit();
	}
}

function excel(){
	if (datos.CB_CLIENTE.value=='0'){
		alert('DEBE SELECCIONAR UN CLIENTE');
	}else{
		datos.action='informe_demandas_xls.asp';
		datos.submit();
	}
}
function ventanaDetalle (URL){
window.open(URL,"DETALLEGESTION","width=800, height=300, scrollbars=yes, menubar=no, location=no, resizable=yes")
}

</script>
