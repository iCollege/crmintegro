<% @LCID = 1034 %>
<!--#include file="system/arch_utils.asp"-->
<!--#include file="lib/comunes/rutinas/funciones.inc" -->
<!--#include file="system/lib.asp"-->

<HTML>
<HEAD>
<TITLE>Sistema de Cobranzas</TITLE>
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

</HEAD>
<BODY>
<TABLE style="MARGIN-TOP: 10px" cellSpacing=0 align=center border=0 valign="middle" WIDTH="600">
	<TR>
	<TD VALIGN=TOP ALIGN="CENTER" valign="middle">
		<img src="images\<%=strNomLogo%>">
      </TD>
	</TR>
</TABLE>
<TABLE cellSpacing=0 borderColorDark=#bebebe cellPadding=0 bgColor=#ffffff borderColorLight=#bebebe border=1 align=center WIDTH="600">
	<TR>
		<TD style="PADDING-LEFT: 10px; PADDING-TOP: 10px" vAlign=top borderColor=#ffffff align=left bgColor=#e9e9e9>
		<FORM name="datos" method="post">
		<TABLE height=100 cellSpacing=0 width=600 align=right border=0 valign="top">
          <TR>
            <TD colSpan=7 height=24></TD>
          </TR>
          <TR>
          	<TD width=70 height=20>&nbsp;</TD>
            <TD width=80 height=20 ALIGN="RIGHT"> <span class="Estilo22"> Usuario </span>
            &nbsp;&nbsp;&nbsp;</TD>
            <TD width=100 height=20><input name="login" type="text" size="12" maxlength="15"></TD>
            <TD width=100 height=20 ALIGN="RIGHT"> <span class="Estilo22"> Contraseña </span>
            </span>&nbsp;&nbsp;&nbsp;</TD>
            <TD width=100><input name="clave" type="password" size="12" maxlength="15"></TD>
            <TD width=80 height=20>&nbsp;&nbsp;&nbsp;<input name="Submit" type="button" class="boton" id="Submit" onClick="envia();" value="Ingresar"></TD>
            <TD width=70 height=20>&nbsp;</TD>
          </TR>

          <TR>
				<TD width=70 height=20>&nbsp;</TD>
				<TD width=80 height=20 ALIGN="RIGHT"> <span class="Estilo22"> Cedente </span>
				&nbsp;&nbsp;&nbsp;</TD>
				<TD COLSPAN=5>

				<select name="CB_CLIENTE" onChange="">
					<%
					abrirscg()
					ssql="SELECT CODCLIENTE,RAZON_SOCIAL FROM CLIENTE WHERE ACTIVO = 1 ORDER BY RAZON_SOCIAL"
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
            <TD colSpan=7 height=50>&nbsp; </TD>
          </TR>
          <TR>
            <TD colSpan=7 align="CENTER"> <p><a href="http://<%=strSitioWebEmpresa%>"><%=strSitioWebEmpresa%></a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
            <%=strDirEmpresa%>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Telefonos <%=strTelEmpresa%>
              </p>
              </TD>
          </TR>
          <TR>
            <TD align=left bgColor=#e9e9e9 colSpan=2> </TD>
          </TR>
        </TABLE>

		</FORM>
		</TD>
	</TR>
</TABLE>
</BODY>
</HTML>
<script language="JavaScript" type="text/JavaScript">
function envia(){
	if(datos.login.value==''){
		alert('DEBE INGRESAR SU NOMBRE DE USUARIO');
		datos.login.focus();
	}else if(datos.clave.value==''){
		alert('DEBE INGRESAR SU CONTRASEÑA');
		datos.clave.focus();
	}else{
			datos.action='system/cbdd01.asp';
			datos.submit();
		}
}

function inicio(){
	window.navigate('');
}
</script>

