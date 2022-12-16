<% @LCID = 1034 %>
<!--#include file="arch_utils.asp"-->
<!--#include file="sesion.asp"-->
<!--#include file="../lib/comunes/rutinas/funciones.inc" -->
<!--#include file="../lib/comunes/rutinas/TraeCampo.inc" -->
<!--#include file="lib.asp"-->
<%
rut = request("rut")

AbrirSCG()
	strEnPantallaPpal = TraeCampoId(Conn, "NOM_ADIC1", 1, "CLIENTE", "CODCLIENTE")
CerrarSCG()

AbrirSCG()
	strSql="SELECT TOP 1 NOMBREDEUDOR,RUTDEUDOR FROM DEUDOR WHERE RUTDEUDOR='" & rut & "' AND NOMBREDEUDOR IS NOT NULL AND LTRIM(RTRIM(NOMBREDEUDOR)) <> '' "
	set rsDEU=Conn.execute(strSql)
	if not rsDEU.eof then
		nombre_deudor = rsDEU("NOMBREDEUDOR")
	else
		nombre_deudor = "SIN NOMBRE"
	end if
	rsDEU.close
	set rsDEU=nothing
cerrarSCG()

%>
<title>BACKOFFICE NUEVA DEUDA</title>
<style type="text/css">
<!--
.Estilo27 {color: #FFFFFF}
.Estilo32 {color: #FFFFFF; font-size: x-small; }
-->
</style>
<form name="datos" method="post">


<table width="100%" border="1" bordercolor="#FFFFFF">
	<tr>
		<TD height="20" ALIGN=LEFT class="pasos2_i">
			<B>INGRESO NUEVA DEUDA</B>
		</TD>
	</tr>
</table>

<table width="100" border="0">
  <tr>
    <td height="10"></td>
  </tr>
  <tr>
    <td valign="top" background="" width="100">
			<table border="0" bordercolor="#FFFFFF">
				<tr  bordercolor="#FFFFFF" bgcolor="#<%=session("COLTABBG")%>" class="Estilo13">
					<td>RUT</td>
					<td colspan=4>NOMBRE</td>
       			</tr>
       			<tr bordercolor="#FFFFFF">
       				<td>
						<%=UCASE(rut)%>
					</td>
					<td colspan=4>
						<%=UCASE(nombre_deudor)%>
					</td>
        		</tr>
				<tr  bordercolor="#FFFFFF" bgcolor="#<%=session("COLTABBG")%>" class="Estilo13">
					<td>CLIENTE</td>
					<td>USUARIO INGRESO</td>
					<td colspan=3>GLOSA</td>
       			</tr>
       			<tr bordercolor="#FFFFFF">
					<td>
						<select name="cliente" id="cliente">
							<option value="0">SELECCIONE</option>
							<%
							abrirscg()
							ssql="SELECT CODCLIENTE,DESCRIPCION FROM CLIENTE ORDER BY DESCRIPCION"
							set rscli= Conn.execute(ssql)
							do until rscli.eof%>
							<option value="<%=rscli("CODCLIENTE")%>"><%=rscli("DESCRIPCION")%></option>
							<%
							rscli.movenext
							loop
							rscli.close
							set rscli=nothing
							cerrarscg()
							%>
						</select>
					</td>
					<td>
						<%=UCASE(session("session_login"))%>
						<input name="rut" type="hidden" value="<%=rut%>">
					</td>
					<td colspan=3>
						<input name="glosa" type="text" size="70" maxlength="200">
					</td>

        		</tr>
      			<tr  bordercolor="#FFFFFF" bgcolor="#<%=session("COLTABBG")%>" class="Estilo13">
        			<td width="20%">N°DOCUMENTO</td>
					<td width="20%">VIGENTE</td>
					<td width="20%">VENCIDA</td>
					<td width="20%">MORA</td>
					<td width="20%">CASTIGO</td>
       			</tr>
      			<tr bordercolor="#FFFFFF">
       				<td><input name="nrodoc" type="text" size="10" maxlength="15"></td>
        			<td><input name="vigente" type="text" size="20"></td>
        			<td><input name="vencida" type="text" size="20" maxlength="20"></td>
        			<td><input name="mora" type="text" size="20" maxlength="20"></td>
        			<td><input name="castigo" type="text" size="20" maxlength="20"></td>


				</tr>
     			<tr bordercolor="#FFFFFF" bgcolor="#<%=session("COLTABBG")%>" class="Estilo13">
        			<td>NUM CLIENTE</td>
        			<td>CENTRO COSTO</td>
					<td>SUCURSAL</td>
        			<td>FECHA VENCIMIENTO	</td>
					<td>EJECUTIVO</td>
        		</tr>
      			<tr bordercolor="#FFFFFF">
        			<td><input name="numcliente" type="text" size="15" maxlength="15"></td>
        			<td><input name="centrocosto" type="text" size="15" maxlength="15"></td>
        			<td><input name="sucursal" type="text" size="15" maxlength="15"></td>
        			<td valign="top"><input name="inicio" type="text" id="inicio" value="<%=inicio%>" size="10" maxlength="10">
						<a href="javascript:showCal('Calendar7');"><img src="../lib/calendario.gif" border="0"></a></td>
        			<td>
						<select name="cobrador" id="cobrador">
							<option value="0">SIN ASIGNAR</option>
							<%
							abrirscg()
							strSql = "SELECT ID_USUARIO, LOGIN FROM USUARIO ORDER BY LOGIN"
							set rsUSU= Conn.execute(strSql)
							Do until rsUSU.eof%>
							<option value="<%=rsUSU("ID_USUARIO")%>"><%=rsUSU("LOGIN")%></option>
							<%
							rsUSU.movenext
							loop
							rsUSU.close
							set rsUSU=nothing
							cerrarscg()
							%>
						</select>
					</td>

        		</tr>
				<tr>
					<td>
						<input name="Submit" type="button" value="Grabar" onClick="envia();">
					</td>
				</tr>
    	</table>
    </td>
  </tr>
</table>
</form>
<script language="JavaScript" type="text/JavaScript">
function envia(){
if(datos.nrodoc.value==''){
		alert('DEBE INGRESAR UN NUMERO DOC');
	}else if(datos.vencida.value==''){
		alert('DEBE INGRESAR DEUDA VENCIDA');
	}else if(datos.cobrador.value==''){
		alert('DEBE INGRESAR UN COBRADOR');
	}else if(datos.cliente.value=='0'){
		alert('DEBE SELECCIONAR UN CLIENTE');
	}else if(datos.vigente.value=='0'){
		alert('DEBE INGRESAR DEUDA VIGENTE');
	}else if(datos.mora.value==''){
		alert('DEBE INGRESAR MORA');
	}else{
		datos.action='graba_deuda.asp';
		datos.submit();
	}
}

</script>

