<% @LCID = 1034 %>
<!--#include file="arch_utils.asp"-->
<!--#include file="../lib/comunes/rutinas/funciones.inc" -->
<!--#include file="lib.asp"-->

<%
rut = request.QueryString("rut")
%>
<title>NUEVO TELEFONO</title>
<style type="text/css">
<!--
.Estilo32 {color: #FFFFFF; font-size: x-small; }
-->
</style>
<form name="datos" method="post">
<table width="700" height="420" border="0">
  <tr>
    <td height="20"><img src="../lib/TITULO_NUEVO_TEL.gif" width="740" height="22"></td>
  </tr>
  <tr>
    <td valign="top" background="../images/fondo_coventa.jpg"><table width="100%" border="0" bordercolor="#FFFFFF">
      <tr bordercolor="#FFFFFF" bgcolor="#<%=session("COLTABBG")%>" class="Estilo13">
        <td width="23%">CODIGO AREA </td>
        <td width="30%">TELEFONO </td>
        <td width="19%">FECHA INGRESO </td>
        <td width="28%">USUARIO </td>
        </tr>
      <tr bordercolor="#FFFFFF">
	   <input name="num_min" type="hidden" value="0">
            <td> <select name="codarea" id="codarea" onblur="num_min.value=asigna_minimo(codarea,num_min)">>
                <%
         abrirscg()
         ssql="SELECT DISTINCT codigo_area FROM COMUNA where id_sadi<>0 union select 9 as codigo_area  ORDER BY codigo_area desc"
	 	 set rsCOM= Conn.execute(ssql)
		 do until rsCOM.eof%>
                <option value="<%=rsCOM("codigo_area")%>" selected><%=rsCOM("codigo_area")%></option>
                <%
		  rsCOM.movenext
		  loop
		  rsCOM.close
		  set rsCOM=nothing
		  cerrarscg()
		  %>
		   <option value="0" selected>--</option>
              </select>
              (CELULAR 9)</td>
        <td>
		  <input name="numero" type="text" id="numero" size="10" maxlength="8" onKeyUp="numero.value=solonumero(numero)"   >
		&nbsp;&nbsp;  <input name="Submit" type="button" value="Aceptar" onClick="envia();" >
        </td>
        <td><%=date%></td>
        <td>
              <%response.Write(session("session_login"))%>
              <input name="rut" type="hidden" id="rut" value="<%=rut%>">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
              <input name="volver" type="button" onClick="history.back();" value="Volver">
        </td>
      </tr>
    </table>
    </td>
  </tr>
</table>
</form>
<script language="JavaScript" type="text/JavaScript">


///------x-x-x-x--x-x-x-x-x-x*x-x*x-x*x-x*x-x*x-x*x*-*-*-*

function asigna_minimo(campo, minimo1){
	if (campo.value!=0)	{
		if(campo.value==41 || campo.value==32 || campo.value==2){
			minimo1=8;
		}else if(campo.value.length==1){
			minimo1=8;
		}else {
			minimo1=6;
		}
	}else{minimo1=0}
	return(minimo1)
}



function valida_largo(campo, minimo){
//alert(datos.fono_aportado_area.value)
	//if (datos.fono_aportado_area.value!="0"){
		if(campo.value.length != minimo) {
			alert("Fono debe tener " + minimo + " digitos")
			campo.select()
			campo.focus()
			return(true)
		}
	//}
	return(false)
}

function solonumero(valor){
     //Compruebo si es un valor numérico
      if (isNaN(valor.value)) {
            //entonces (no es numero) devuelvo el valor cadena vacia
            valor.value=""
			return ""
      }else{
            //En caso contrario (Si era un número) devuelvo el valor
			valor.value
			return valor.value
      }
}
function envia(){
	if(datos.numero.value==''){
		alert('DEBE INGRESAR UN NUMERO');
	}else if (valida_largo(datos.numero, datos.num_min.value)){
	}else{
		datos.Submit.disabled=true;
		datos.action='scg_tel.asp';
		datos.submit();
	}
}

</script>

