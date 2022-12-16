<% @LCID = 1034 %>
<!--#include file="arch_utils.asp"-->
<!--#include file="../lib/comunes/rutinas/funciones.inc" -->
<!--#include file="../lib/comunes/rutinas/TraeCampo.inc" -->
<!--#include file="asp/comunes/general/rutinasBooleano.inc"-->
<!--#include file="lib.asp"-->

<!DOCTYPE html>
<head>
<title>EMPRESA S.A.</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
</head>

<body>


<%
login=request("login")
clave=request("clave")
AbrirSCG()

strSql =" SELECT CODCLIENTE FROM USUARIO A,  USUARIO_CLIENTE B "
strSql = strSql & " WHERE A.ID_USUARIO = B.ID_USUARIO "
strSql = strSql & " AND LOGIN = '" & login & "' AND CLAVE = '" & clave & "'"

strCodClientes = ""

set rsUSU=Conn.execute(strSql)
If not rsUSU.eof then
	existe=1
	Do While not rsUSU.Eof
		strCodClientes = strCodClientes & "'" & rsUSU("CODCLIENTE") & "',"
		rsUSU.movenext
	Loop
	strCodClientes = Mid(strCodClientes,1,len(strCodClientes)-1)
Else
	existe=0
End if

rsUSU.close
set rsUSU=nothing



cerrarSCG()
%>
<head>
        <meta charset="utf-8">
        <title>Login CRM Cobros</title>
        <meta name="description" content="">
        <meta name="viewport" content="width=device-width">
		
<style type="text/css">
<!--
body {
	background-image: url(../texturafondo.jpg);
	background-repeat: repeat-x;
	background-color: #FFFFFF;
	margin-left: 0px;
	margin-top: 0px;
	margin-right: 0px;
	margin-bottom: 0px;
}
-->
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
<% If trim(strCodClientes) <> "" Then %>
<table width="643" height="373" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td valign="top" background="../base.jpg"><table width="100%" border="0" cellspacing="0" cellpadding="0">
      <tr>
        <td height="200">&nbsp;</td>
      </tr>
      <tr>
        <td height="90"><div align="center">
          <table width="250" height="90" border="0" cellpadding="0" cellspacing="0">
            <tr>
              <td>

              <FORM name="datos" method="post">
              	<INPUT TYPE="hidden" NAME="login" value="<%=login%>">
              	<INPUT TYPE="hidden" NAME="clave" value="<%=clave%>">
			  		<TABLE height=100 cellSpacing=0 width=300 align=right border=0 valign="top">
			  			<TR>
							<TD ALIGN="CENTER"><span class="Estilo22"> SELECIONE MANDANTE </span></TD>
						</TR>
			             <TR>

			  				<TD ALIGN="CENTER">
			  				<select name="CB_CLIENTE" onChange="">
			  					<%
			  					abrirscg()
			  					ssql="SELECT CODCLIENTE,RAZON_SOCIAL FROM CLIENTE WHERE ACTIVO = 1 AND CODCLIENTE IN (" & strCodClientes & ") ORDER BY RAZON_SOCIAL"
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
			  				</TD>
			            </TR>
			            <TR>
						  <TD ALIGN="CENTER"><input name="Submit" type="button" class="boton" id="Submit" onClick="envia();" value="Ingresar"></TD>
						</TR>

			            <!--TR>
			              <TD colSpan=2 align="CENTER"> <p><a href="http://<%=strSitioWebEmpresa%>"><%=strSitioWebEmpresa%></a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
			              <%=strDirEmpresa%>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Telefonos <%=strTelEmpresa%>
			                </p>
			                </TD>
			            </TR-->
			          </TABLE>

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
<% End If%>
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
			datos.action='cbdd01.asp';
			datos.submit();
		}
}

function inicio(){
	window.location.href = '';
}
</script>


</body>
<script language="JavaScript">
existe=<%=existe%>;
if(existe=='0'){
alert('USUARIO INVALIDO, CONTRASEÑA INCORRECTA O NO TIENE ASIGNADO MANDANTES');
window.location.href = '../index.asp';
}
</script>
</html>
