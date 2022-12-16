<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<title>CHOOSE</title>
</head>

<body>
<form name="datos" method="post">
  <select name="ruta">
    <option value="0" selected>SELECCIONE</option>
    <option value="1">SISTEMA DE GESTION</option>
    <option value="2">SISTEMA DE INFORMES</option>
  </select> 
  <input type="button" name="Submit" value="Aceptar" onClick="vamos();">
</form>
</body>
</html>
<script language="JavaScript" type="text/JavaScript">
function vamos(){
if (datos.ruta.value=='0'){
alert('DEBE SELECCIONAR UN SISTENA');
}else if(datos.ruta.value=='1'){
window.navigate('scg_web.asp');
}else if(datos.ruta.value=='2'){
window.navigate('scg_sup.asp');
}
}

</script>

