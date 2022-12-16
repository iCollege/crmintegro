<% @LCID = 1034 %>
<!--#include file="arch_utils.asp"-->
<!--#include file="../lib/comunes/rutinas/funciones.inc" -->
<!--#include file="lib.asp"-->

<%
rut = request.QueryString("rut")
%>
<title>NUEVO CORREO ELECTRONICO</title>
<style type="text/css">
<!--
.Estilo32 {color: #FFFFFF; font-size: x-small; }
-->
</style>
<form name="datos" method="post">
<table width="760" height="420" border="0">
  <tr>
    <td height="20"><img src="../lib/TITULO_NUEVO_COR.gif" width="740" height="22"></td>
  </tr>
  <tr>
    <td valign="top" background="../images/fondo_coventa.jpg"><table width="100%" border="0" bordercolor="#FFFFFF">
      <tr bordercolor="#FFFFFF" bgcolor="#<%=session("COLTABBG")%>" class="Estilo13">
        <td width="47%">CORREO</td>
        <td width="30%">FECHA INGRESO </td>
        <td width="23%">USUARIO </td>
        </tr>
      <tr bordercolor="#FFFFFF">
        <td><input name="EMAIL" type="text" id="EMAIL" size="40" maxlength="50">
          <input name="Submit" type="button" value="Aceptar" onClick="envia();"></td>
        <td><%=date%></td>
        <td>
              <%response.Write(session("session_login"))%>
              <input name="rut" type="hidden" id="rut" value="<%=rut%>">
</td>
      </tr>
    </table>
    </td>
  </tr>
</table>
</form>
<script language="JavaScript" type="text/JavaScript">
function envia(){

if(datos.EMAIL.value==''){
	alert('DEBE INGRESAR UN CORREO');
}
else
	{
		if( checkEmail() ) {
			datos.action='scg_cor.asp';
			datos.submit();
		}
	}
}
</script>

<script languaje="javascript1.2">
function ValidarCorreo(strmail){
     var Email = strmail
     //var Formato = /^([\w-\.])+@([\w-]+\.)+([a-z]){2,4}$/;
     var Formato = /^([\w-\.])+([\w-]+\.)+([a-z]){2,4}$/;
	 var Comparacion = Formato.test(Email);
     if(Comparacion == false){
          alert("CORREO ELECTRÓNICO NO VALIDO");
          return false;
     }
}

function checkEmail()
{
var EMAILCorrect = false

for (var i = 0; i <= document.forms[0].EMAIL.value.length; i++)
 {
 if (document.forms[0].EMAIL.value.charAt(i) == "@") {EMAILCorrect = true}
 }
var EMLength = document.forms[0].EMAIL.value.length
if (document.forms[0].EMAIL.value.substring(EMLength - 4, EMLength-3) != "." &&
    document.forms[0].EMAIL.value.substring(EMLength - 3, EMLength-2) != "." &&
    document.forms[0].EMAIL.value.substring(EMLength - 2, EMLength-1) != "." &&
    document.forms[0].EMAIL.value.substring(EMLength - 1, EMLength) != ".") {EMAILCorrect = false}
if (EMAILCorrect == false){alert("El e-mail ingresado es invalido!"); correct= false}
if (EMAILCorrect == true) {return true;}

}
</script>

