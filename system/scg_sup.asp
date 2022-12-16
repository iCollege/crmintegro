<% @LCID = 1034 %>
<!--#include file="arch_utils.asp"-->
<!--#include file="lib.asp"-->
<!--#include file="sesion.asp"-->
<!--#include file="../lib/comunes/rutinas/funciones.inc" -->
<html>
<style type="text/css">
<!--
.Estilo30 {color: #FFFFFF}
a:link {
	color: #000000;
	text-decoration: none;
}
a:visited {
	color: #000000;
	text-decoration: none;
}
a:hover {
	text-decoration: none;
}
a:active {
	text-decoration: none;
	color: #FFFFFF;
}
-->
</style>
<head>
<title>PANEL DE CONTROL</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
</head>
<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<table width="100%" height="100%" border="0" cellpadding="0" cellspacing="0">
  <tr>
    <td valign="top">
      <table width="793" border="0" align="center" cellpadding="0" cellspacing="0">

		<tr>
          <td bgcolor="#FFFFFF"><img src="../system/top.jpg" width="720" height="48"></td>
        </tr>
        <tr>
          <td width="758" bgcolor="#FFFFFF">
			  <table width="100%" height="431" border="0" cellpadding="0" cellspacing="0" bgcolor="#FFFFFF"><script type="text/javascript" language="JavaScript1.2" src="frameset/stm31.js"></script>
			    <tr valign=TOP>
				  <td height="431" colspan="3"><p align="right">Usuario: <%=UCASE(session("nombre_user"))%> | <a href="cbdd02.asp"> <acronym title="SALIR DEL SISTEMA">CERRAR SESI&Oacute;N</acronym></a></p>
					  <table width="100%" height="420" border="0">
						  <tr><td height="379" valign="top" background="../images/fondo_coventa.jpg"><p><img src="../lib/TIT_PANEL_DE_CONTROL.gif" width="740" height="22"></p>
						    <p>&nbsp;</p>
						    <table width="100%" border="0">
                              <tr>
                                <td width="25%" height="21" bgcolor="#<%=session("COLTABBG")%>"><span class="Estilo30"> INFORMES </span></td>
                                <td width="25%" bgcolor="#<%=session("COLTABBG")%>"><span class="Estilo30">PLATAFORMA DAL </span></td>
                                <td width="25%">&nbsp;</td>
                                <td width="25%">&nbsp;</td>
                              </tr>
                              <tr>
                                <td bgcolor="#FF9900"><a href="javascript:ventanaInformes('informe_recupero_consolidado.asp')">1.1.- RECUPERACI&Oacute;N CALL CENTER </a></td>
                                <td bgcolor="#FF9900"><a href="javascript:ventanaInformes('informe_ivr_agendamiento.asp')">INFORME DE AGENDAMIENTOS</a></td>
                                <td>&nbsp;</td>
                                <td>&nbsp;</td>
                              </tr>
                              <tr>
                                <td bgcolor="#FF9900"><a href="javascript:ventanaInformes('informe_recupero_terreno.asp')">1.2.- RECUPERACI&Oacute;N TERRENO</a> </td>
                                <td>&nbsp;</td>
                                <td>&nbsp;</td>
                                <td>&nbsp;</td>
                              </tr>
                              <tr>
                                <td bgcolor="#FF9900"><a href="javascript:ventanaInformes('informe_gestiones.asp')">2.1- BALANCE DE CARTERA </a></td>
                                <td>&nbsp;</td>
                                <td>&nbsp;</td>
                                <td>&nbsp;</td>
                              </tr>
							  <tr>
                                <td bgcolor="#FF9900"><a href="javascript:ventanaInformes('informe_gestiones_terreno.asp')">2.2- BALANCE DE

								CARTERA DE TERRENO </a></td>
                                <td>&nbsp;</td>
                                <td>&nbsp;</td>
                                <td>&nbsp;</td>
                              </tr>
                              <tr>
                                <td bgcolor="#FF9900"><a href="javascript:ventanaInformes('informe_gestiones_consolidado.asp')">3.- PRODUCTIVIDAD</a></td>
                                <td>&nbsp;</td>
                                <td>&nbsp;</td>
                                <td>&nbsp;</td>
                              </tr>
                              <tr>
                                <td bgcolor="#FF9900"><a href="javascript:ventanaInformes('informe_recuperacion_m.asp')">4.- VENTAS</a></td>
                                <td>&nbsp;</td>
                                <td>&nbsp;</td>
                                <td>&nbsp;</td>
                              </tr>
                              <tr>
                                <td bgcolor="#FF9900"><a href="javascript:ventanaInformes('informe_gestiones_compromisos.asp')">4.1.- PROYECCIONES</a></td>
                                <td>&nbsp;</td>
                                <td>&nbsp;</td>
                                <td>&nbsp;</td>
                              </tr>
                              <tr>
                                <td height="21" bgcolor="#FF9900"><a href="javascript:ventanaInformes('informe_compromisos_caidos.asp')">4.2.- COMPROMISOS CA&Iacute;DOS </a></td>
                                <td>&nbsp;</td>
                                <td>&nbsp;</td>
                                <td>&nbsp;</td>
                              </tr>
                            </table></td>
						  </tr>
				    </table>
			      </td>
			    </tr>
		      </table>
			  </td>
        </tr>
      </table>
    </td>
  </tr>

</table>
</body>
</html>


<script language="JavaScript" type="text/JavaScript">

function ventanaInformes (URL){
window.open(URL,"INFORMACION","width=800, height=400, scrollbars=yes, menubar=no, location=no, resizable=yes")
}

</script>
