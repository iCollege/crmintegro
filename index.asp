<% @LCID = 1034 %>
<!--#include file="system/arch_utils.asp"-->
<!--#include file="lib/comunes/rutinas/funciones.inc" -->
<!--#include file="system/lib.asp"-->
<%
AbrirSCG()
strSql="SELECT * FROM PARAMETROS"
set rsParam = Conn.execute(strSql)
If not rsParam.eof then
	strNomLogo = Trim(rsParam("NOMBRE_LOGO_PRINCIPAL"))
	strDirEmpresa = Trim(rsParam("DIRECCION_EMPRESA"))
	strSitioWebEmpresa = Trim(rsParam("SITIO_WEB_EMPRESA"))
	strTelEmpresa = Trim(rsParam("TELEFONOS_EMPRESA"))
End if
CerrarSCG()
%>
<!DOCTYPE html>
<head>
<meta charset="iso-8859-1">
<title>Login</title>
<meta http-equiv="Content-Type" content="text/html;">

 <link rel="stylesheet" href="assets/bootstrap/bootstrap.minv2.css">

        <link rel="stylesheet" href="assets/font-awesome/css/font-awesome.min.css">
        <link rel="stylesheet" href="assets/normalize/normalize.css">
        <!--page specific css styles-->
        <link rel="stylesheet" href="assets/jquery-ui/jquery-ui.min.css">

        <!--flaty css styles-->
        <link rel="stylesheet" href="css/flaty.css">
        <link rel="stylesheet" href="css/flaty-responsive.css">

	 <link href="css/animate.min.css" rel="stylesheet"> <!-- Animated CSS  -->
	 <link href="css/flexslider.css" rel="stylesheet"> <!-- Flexslider CSS  -->

<style type="text/css">

body {
	background-image: url(texturafondo.jpg);
	background-repeat: repeat-x;
	background-color: #FFFFFF;
	margin-left: 0px;
	margin-top: 0px;
	margin-right: 0px;
	margin-bottom: 0px;
}

</style>
<script type="text/javascript">
<!--
function MM_preloadImages() { //v3.0
  var d=document; if(d.images){ if(!d.MM_p) d.MM_p=new Array();
    var i,j=d.MM_p.length,a=MM_preloadImages.arguments; for(i=0; i<a.length; i++)
    if (a[i].indexOf("#")!=0){ d.MM_p[j]=new Image; d.MM_p[j++].src=a[i];}}
}
//-->
</script>
</head>

<body>
<!--<div style="position:absolute;top:50px;align="center"">//-->
<table width="643" height="373" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td valign="top" background="base.jpg"><table width="100%" border="0" cellspacing="0" cellpadding="0">
      <tr>
        <td height="200">&nbsp;</td>
      </tr>
      <tr>

        <td height="90"><div align="center">
          <table width="250" height="90" border="0" cellpadding="0" cellspacing="0">
            <tr>
              <td>

              <FORM name="datos" method="post">
              	<div class="headbanner-form animated fadeInUp">	
			  		<TABLE height="100" cellSpacing="0" width="300" align=right border="0" valign="top">
			            <TR>
			              <TD><span class="Estilo23"><b>Usuario</b></span></TD>
			              <TD><input name="login" class="Estilo23" type="text" size="12" maxlength="15"></TD>
			            </TR>
			            <TR>
			              <TD><span class="Estilo23"><b>Contraseña</b></span></TD>
			              <TD><input name="clave" class="Estilo23" type="password" size="12" maxlength="15"></TD>
			            </TR>
			            <TR>
						  <TD COLSPAN=2 ALIGN="CENTER">&nbsp;</TD>
						</TR>
			            <TR>
						  <TD COLSPAN=2 ALIGN="CENTER"><input name="Submit" class="btn btn-info" type="button" class="boton" id="Submit" onClick="envia();" value="Ingresar"></TD>
						</TR>

			            <!--TR>
			              <TD colSpan=2 align="CENTER"> <p><a href="http://<%=strSitioWebEmpresa%>"><%=strSitioWebEmpresa%></a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
			              <%=strDirEmpresa%>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Telefonos <%=strTelEmpresa%>
			                </p>
			                </TD>
			            </TR-->
			          </TABLE>
			      </div>
		</FORM>


              </td>
            </tr>
          </table>
        </div></td>
      </tr>
    </table></td>
  </tr>
</table>

</body>
</html>

<script language="JavaScript" type="text/JavaScript">
function envia(){
	if(datos.login.value==''){
		alert('DEBE INGRESAR SU NOMBRE DE USUARIO');
		datos.login.focus();
	}else if(datos.clave.value==''){
		alert('DEBE INGRESAR SU CONTRASEÑA');
		datos.clave.focus();
	}else{
			datos.action='system/cbdd01_prev.asp';
			datos.submit();
		}
}

function inicio(){
	window.navigate('');
}
</script>
