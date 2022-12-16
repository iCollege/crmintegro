	<title></title>
<%
Session.abandon

%>
<SCRIPT ID=clientEventHandlersJS LANGUAGE=JavaScript>
//alert('HA FINALIZADO SU SESION EN EL SISTEMA');
var pagina="http://10.11.10.30/crmintegro/index.asp"
function redireccionar() 
{
location.href=pagina
} 
setTimeout ("redireccionar()", 1);
</Script>