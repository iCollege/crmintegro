}<%@ LANGUAGE="VBScript" %>

<% ' Capa 1 ' %>
<!--#include file="arch_utils.asp"-->
<!--#include file="asp/comunes/odbc/insertUpdateA.inc"-->
<!--#include file="asp/comunes/odbc/ObtenerRecordset.inc"-->

<% ' Capa 2 ' %>
<!--#include file="asp/comunes/insert/Usuario.inc"-->
<!--#include file="asp/comunes/recordset/Usuario.inc"-->
<!--#include file="asp/comunes/general/funciones.inc"-->
<%

strUsuario = session("session_idusuario")
AbrirSCG()

	strClave = Trim(Request("CLAVE_NEW1"))
	strSql="UPDATE USUARIO SET CLAVE = '" & strClave &"' WHERE ID_USUARIO = " & strUsuario
	Conn.execute(strSql)


CerrarSCG()
%>
<FORM name=mantenedorForm method=post>
</FORM>
<SCRIPT Language=JavaScript>
	alert ('Cambio de clave exitoso');
	mantenedorForm.action = "man_CambioClave.asp";
	mantenedorForm.submit();
</SCRIPT>

