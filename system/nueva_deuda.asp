<!--#include file="arch_utils.asp"-->
<!--#include file="lib.asp"-->
<!--#include file="../lib/comunes/rutinas/funciones.inc" -->
<!--#include file="../lib/comunes/rutinas/TraeCampo.inc" -->
<%
rut = request.QueryString("rut")
%>
<title>BACKOFFICE NUEVA DEUDA</title>
<style type="text/css">
<!--
.Estilo27 {color: #FFFFFF}
.Estilo32 {color: #FFFFFF; font-size: x-small; }
-->
</style>
<form name="datos" method="post">
<table width="100" border="0">
  <tr>
    <td height="20"></td>
  </tr>
  <tr>
    <td valign="top" background="" width="100">
			<table border="0" bordercolor="#FFFFFF">
      			<tr  bordercolor="#FFFFFF" bgcolor="black" class="Estilo13">
        			<td width="20%">N°DOCUMENTO</td>
					<td width="20%">MONTO</td>
					<td width="20%">BANCO</td>
        			<td width="20%">COBRADOR</td>
					<td width="20%">USUARIO INGRESO</td>
       			</tr>
      			<tr bordercolor="#FFFFFF">
       				<td><input name="nrodoc" type="text" id="nrodoc" size="10" maxlength="15"></td>
        			<td><input name="monto" type="text" id="monto" size="20"></td>
        			<td><input name="banco" type="text" id="banco" size="20" maxlength="20"></td>
					<td><select name="cobrador" id="cobrador">
            			<option value="0">SIN ASIGNAR</option>
		    <%
		abrirscg()
		ssql="select cod_usuario from usuario where grupo='COBRADOR' order by cod_usuario"
		set rsUSU= Conn.execute(ssql)
		  do until rsUSU.eof%>
		    			<option value="<%=rsUSU("cod_usuario")%>"><%=rsUSU("cod_usuario")%></option>
		    <%
		  rsUSU.movenext
		  loop
		  rsUSU.close
		  set rsUSU=nothing
		  cerrarscg()
		  %>
           				</select></td>
        			<td>
          <%response.Write(UCASE(session("session_login")))%>
          <input name="rut" type="hidden" id="rut" value="<%=rut%>">
        			</td>

				</tr>
     			<tr bordercolor="#FFFFFF" bgcolor="black" class="Estilo13">
        			<td>CLIENTE</td>
        			<td>FECHA EMISION</td>
					<td>FECHA PROTESTO</td>
					<td>CAUSAL DE PROTESTO</td>

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
        			<td valign="top"><input name="inicio" type="text" id="inicio" value="<%=inicio%>" size="10" maxlength="10">
						<a href="javascript:showCal('Calendar7');"><img src="../lib/calendario.gif" border="0"></a></td>
        			<td valign="top"><input name="termino" type="text" id="termino" value="<%=termino%>" size="10" maxlength="10">
          				<a href="javascript:showCal('Calendar6');"><img src="../lib/calendario.gif" border="0"></a>
		 			</td>
         			<td>
		 <select name="causal" id="causal">
		 	<option value="0">SELECCIONE</option>
		 	<option value="ENMENDADO">ENMENDADO</option>
			<option value="FALTA TIMBRE">FALTA TIMBRE</option>
			<option value="FALTA DE FONDOS">FALTA DE FONDOS</option>
			<option value="FIMA DISCONFORME">FIRMA DISCONFORME</option>
			<option value="ENDOSO IRREGULAR">ENDOSO IRREGULAR</option>
			<option value="CADUCADO">CADUCADO</option>
			<option value="MAL EXTENDIDO">MAL EXTENDIDO</option>
			<option value="FIRMA NO CORRESPONDE A TITULAR">FIRMA NO CORRESPONDE A TITULAR</option>
			<option value="FECHA GIRO INCOMPLETA">FECHA GIRO INCOMPLETA</option>
			<option value="CUENTA CERRADA">CUENTA CERRADA</option>
			<option value="ONP - EXTRAVIO">ONP - EXTRAVIO</option>
			<option value="FALTA FIRMA">FALTA FIRMA</option>
			<option value="INCUMPLIMIENTO DE CONTRATO">INCUMPLIMIENTO DE CONTRATO</option>
			<option value="SIN INFORMACION">SIN INFORMACION</option>
			<option value="FIRMA AUTORIZADA NO VIGENTE">FIRMA AUTORIZADA NO VIGENTE</option>
			<option value="FIRMA NO REGISTRADA">FIRMA NO REGISTRADA</option>
			<option value="FECHA INEXISTENTE">FECHA INEXISTENTE</option>
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
}else if(datos.monto.value==''){
alert('DEBE INGRESAR UN MONTO,sin puntos');
}else if(datos.cobrador.value==''){
alert('DEBE INGRESAR UN COBRADOR');
}else if(datos.cliente.value=='0'){
alert('DEBE SELECCIONAR UN CLIENTE');
}else if((datos.causal.value=='0')&&(datos.cliente.value!='49')){
alert('DEBE SELECCIONAR UNA CAUSAL');
}else if((datos.banco.value=='')&&(datos.cliente.value!='49')){
alert('DEBE SELECCIONAR UN BANCO');
}else{
datos.action='graba_deuda.asp';
datos.submit();
}
}

</script>

