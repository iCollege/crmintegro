<% @LCID = 1034 %>
<!--#include file="arch_utils.asp"-->
<html>
<!--#include file="sesion_inicio.asp"-->

<style type="text/css">
<!--
.Estilo36 {
	color: #FF0000;
	font-weight: bold;
	font-size: 18px;
}
.Estilo37 {font-size: x-small; color: #000066; font-family: tahoma; }
body {
	background-image: url();
}
-->
</style>

<%
	AbrirSCG()
		strSql="SELECT DESCRIPCION, TIPO_CLIENTE, ISNULL(COD_MONEDA,0) AS COD_MONEDA FROM CLIENTE WHERE CODCLIENTE='" & session("ses_codcli") & "'"
		set rsCOR = Conn.execute(strSql)
		If not rsCOR.eof then
			strNomCliente = Trim(rsCOR("DESCRIPCION"))
			strCodMoneda = Trim(rsCOR("COD_MONEDA"))
			session("tipo_cliente")=rsCOR("TIPO_CLIENTE")
		Else
			strNomCliente = ""
			strCodMoneda = ""
			session("tipo_cliente") = ""
		End if

		If Trim(strCodMoneda) <> 2 Then
			strParamMoneda="N"
			session("valor_moneda") = 1
		Else
			session("valor_moneda") = session("valor_uf")
			strSql="SELECT * FROM MONEDA WHERE COD_MONEDA = " & strCodMoneda
			set rsMon = Conn.execute(strSql)
			If not rsMon.eof then
				session("COD_MONEDA") = Trim(rsMon("COD_MONEDA"))
				session("strSimboloMoneda") = Trim(rsMon("SIMBOLO"))
			Else
				strParamMoneda="N"
			End If
		End If

		strSql="SELECT * FROM PARAMETROS"
		set rsParam = Conn.execute(strSql)
		If not rsParam.eof then
			strNomLogo = Trim(rsParam("NOMBRE_LOGO_TOP_IZQ"))
			strNomSistema = Trim(rsParam("NOMBRE_SISTEMA"))
		End if

%>

<form name="datos" method="post">
 <INPUT TYPE='hidden' NAME="HD_CLIENTE" VALUE="">
<table width="100%" border="0" cellpadding="0" cellspacing="0" bgcolor="#FFFFFF">
	<tr height="70" valign=TOP style="background: #FFF url(../images/top_nuevo.jpg) no-repeat left top">
		<td height="43" align="RIGHT" class="Estilo37">
			<table width="100%" border="0">
				<tr>
					<td height="35" class="Estilo37" align="RIGHT">
						<select name="CB_CLIENTE" onChange="Refrescar(this.value)">
							<%
							ssql="SELECT CODCLIENTE,RAZON_SOCIAL FROM CLIENTE WHERE ACTIVO = 1 AND CODCLIENTE IN (SELECT CODCLIENTE FROM USUARIO_CLIENTE WHERE ID_USUARIO = " & session("session_idusuario") & ") ORDER BY CODCLIENTE,RAZON_SOCIAL ASC"
							set rsTemp= Conn.execute(ssql)
							if not rsTemp.eof then
								do until rsTemp.eof%>
								<option value="<%=rsTemp("CODCLIENTE")%>"<%if Trim(session("ses_codcli"))=rsTemp("CODCLIENTE") then response.Write("Selected") End If%>><%=rsTemp("RAZON_SOCIAL")%></option>
								<%
								rsTemp.movenext
								loop
							end if
							rsTemp.close
							set rsTemp=nothing
							%>
						</select>
						<span class="Estilo36"><%=strNomCliente%>&nbsp;&nbsp;&nbsp;</span>

					</td>
				</tr>
				<tr>
					<td height="35" align="RIGHT" class="Estilo37">
						<%=strNomSistema%>&nbsp;&nbsp;&nbsp;
						Usuario: <%=UCASE(session("nombre_user"))%>&nbsp;&nbsp;&nbsp;
						Inicio de sesion: <%=UCASE(session("iniciosesion"))%>&nbsp;&nbsp;&nbsp;
					</td>
				</tr>
			</table>
		</td>
	</tr>

</table>
</form>

<% CerrarSCG() %>

<SCRIPT>
function Refrescar(strCliente){
	datos.HD_CLIENTE.value = strCliente;
	//datos.action='default.asp?CB_CLIENTE=' + strCliente;
	datos.action='default.asp';
	datos.target='_parent';
	datos.submit();
}
</SCRIPT>
