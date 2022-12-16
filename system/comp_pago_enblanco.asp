<% @LCID = 1034 %>
<!--#include file="arch_utils.asp"-->
<!--#include file="../lib/comunes/rutinas/funciones.inc" -->
<!--#include file="../lib/comunes/rutinas/rutinasFecha.inc" -->
<!--#include file="lib.asp"-->
<!--#include file="asp/comunes/general/RutinasVarias.inc" -->
<!--#include file="../lib/comunes/rutinas/TraeCampo.inc" -->

<%

intNroComp=request("intNroComp")
strImprime=request("strImprime")

intCodRemesa = request("CB_REMESA")
intCodUsuario = request("CB_COBRADOR")

intCliente=session("ses_codcli")

If Trim(intCliente) = "" Then intCliente = "1000"

%>
<title></title>

<style type="text/css">
<!--
.Estilo37 {color: #FFFFFF}
.Estilo370 {color: #000000}
-->
</style>

<table width="600" align="CENTER" border="0">

<tr>
    <td valign="top">


		<table width="600" border="0">
			<tr>
				<td><img src="../images/reintegra.jpg" width="154" height="50"></td>
				<td><span class="Estilo370"><B>COMPROBANTE DE PAGO</B></td>
				<td width="154">
					<table border="0">
						<tr>
							<td><span class="Estilo370">Nro.Comprob. :</td>
							<td align="RIGHT"><span class="Estilo370"><%=strCompPago%></td>
						</tr>
						<tr>
							<td><span class="Estilo370">Fecha :</td>
							<td align="RIGHT"><span class="Estilo370"><%=Mid(Now,1,10)%></td>
						</tr>
					</table>
				</td>
			</tr>
		</table>
		<table width="600" border="0">
			<tr>
				<td colspan=4>&nbsp</td>
			</tr>
			<tr>
				<td colspan=4><span class="Estilo370"><b>Datos Deudor</b></td>
			</tr>
			<tr>
				<td width="100"><span class="Estilo370">Nombre :</td>
				<td width="300"><span class="Estilo370"><%=strNombreDeudor%></td>
				<td width="100"><span class="Estilo370">Rut :</td>
				<td width="100"><span class="Estilo370"><%=strRut%></td>
			</tr>
			<tr>
				<td><span class="Estilo370">Direccion :</td>
				<td><span class="Estilo370"><%=strDirDeudor%></td>
				<td><span class="Estilo370">Telefono red fija :</td>
				<td><span class="Estilo370"><%=strFono%></td>
			</tr>
			<tr>
				<td><span class="Estilo370">Telefono celular :</td>
				<td><span class="Estilo370"><%=strFonoCelular%></td>
				<td><span class="Estilo370">Email :</td>
				<td><span class="Estilo370"><%=strEmail%></td>
			</tr>
		</table>


		<table width="600" border="0">
			<tr>
				<td colspan=4>&nbsp</td>
			</tr>
			<tr>
				<td colspan=4><span class="Estilo370"><b>Datos Deuda</b></td>
			</tr>
			<tr>
				<td width="100"><span class="Estilo370">Cedente :</td>
				<td width="300"><span class="Estilo370"><%=strNomCliente%></td>
				<td width="100"><span class="Estilo370">Asignación :</td>
				<td width="100"><span class="Estilo370"><%=strAsignacion%></td>
			</tr>
		</table>

		<table width="600" border="0">
			<tr>
				<td>&nbsp</td>
			</tr>
			<tr>
				<td colspan=4><span class="Estilo370"><b>Detalle Pago</b></td>
			</tr>
			<tr>
				<td width="100"><span class="Estilo370">Forma de Pago :</td>
				<td width="300"><span class="Estilo370"><%=strFormaPago%></td>
				<td width="100"><span class="Estilo370">Tipo de Pago :</td>
				<td width="100"><span class="Estilo370"><%=strDescTipoPago%></td>
			</tr>
			<tr>
				<td>&nbsp</td>
			</tr>
		</table>


<table width="600" border="1" bordercolor = "#000000" cellSpacing=0 cellPadding=1>
	<tr>
		<td><span class="Estilo370">BANCO</span></td>
		<td><span class="Estilo370">CTA CTE NRO.</span></td>
		<td><span class="Estilo370">CHEQUE</span></td>
		<td><span class="Estilo370">MONTO</span></td>
		<td><span class="Estilo370">FECHA.</span></td>
	</tr>

	<%
		For I = 1 to 8
	%>

		<tr>
			<td>&nbsp;</td>
			<td>&nbsp;</td>
			<td>&nbsp;</td>
			<td ALIGN="RIGHT">&nbsp;</td>
			<td>&nbsp;</td>
		</tr>

	<%

		Next



	%>
</table>

<table width="600">
	<tr>
		<td>&nbsp</td>
	</tr>
</table>

<table width="400" border="1" bordercolor = "#000000" cellSpacing=0 cellPadding=1>
	<tr>
		<td colspan=2><span class="Estilo370"><b>Detalle Deuda</b></td>
	</tr>
	<tr>
		<td><span class="Estilo370" width="125">CAPITAL</span></td>
		<td ALIGN="RIGHT" width="125">&nbsp;</td>
	</tr>
	<tr>
		<td><span class="Estilo370">INTERESES</span></td>
		<td ALIGN="RIGHT">&nbsp;</td>
	</tr>
	<tr>
		<td><span class="Estilo370">GASTOS JUDICIALES</span></td>
		<td ALIGN="RIGHT">&nbsp;</td>
	</tr>
	<tr>
		<td><span class="Estilo370">INDEMNIZACION</span></td>
		<td ALIGN="RIGHT">&nbsp;</td>
	</tr>
	<tr>
		<td><span class="Estilo370">HONORARIOS</span></td>
		<td ALIGN="RIGHT">&nbsp;</td>
	</tr>
	<tr>
		<td><span class="Estilo370">&nbsp;</span></td>
		<td ALIGN="RIGHT">&nbsp;</td>
	</tr>
</table>

<%


%>


<table width="600">
	<tr>
		<td>&nbsp</td>
	</tr>
</table>


<table width="600" border="0">
	<tr>
		<TD VALIGN = "TOP">

			<TABLE VALIGN = "TOP" width="400" border="1" bordercolor = "#000000" cellSpacing=0 cellPadding=1>
				<tr>
					<td><span class="Estilo370"><b>Facturas en pago</b></td>
				</tr>
				<tr>
					<td HEIGHT="100"><span class="Estilo370" width="125">&nbsp;</td>
				</tr>
			</table>

		</td>
		<td VALIGN = "TOP">

			<TABLE width="200" border="1" bordercolor = "#000000" cellSpacing=0 cellPadding=1>
				<tr>
					<td width="100"><span class="Estilo370"><b>Caja:</b></td>
					<td width="100"><span class="Estilo370" width="125">&nbsp;</td>
				</tr>
				<tr>
					<td><span class="Estilo370"><b>Ejecutivo :</b></td>
					<td><span class="Estilo370" width="125">&nbsp;</td>
				</tr>
			</table>



		</td>
	</tr>
</table>


<%If Trim(strTipoPago) = "CO" Then%>
<br>
<br>
<TABLE WIDTH="600" border="0">
	<TR>
		<TD VALIGN = "TOP"><b>
				</b>
		</TD>
	</TR>
</TABLE>
<br>
<%End If%>




<table width="600">
	<tr>
		<td>&nbsp</td>
	</tr>
</table>

<table width="600" border="1" bordercolor = "#000000" cellSpacing=0 cellPadding=1>
		<tr>
		<td class="Estilo370" ALIGN="CENTER">

		Compañia 1390 Of.415 Santiago Centro<br>
		Telefonos 697-1562 672-6629 672-9490<br>
		www.reintegra.cl
		</td>
	</tr>
</table>



	</td>
	</tr>
	</table>


	</td>



</table>
