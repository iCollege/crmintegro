<% @LCID = 1034 %>
<!--#include file="arch_utils.asp"-->
<!--#include file="../lib/comunes/rutinas/funciones.inc" -->
<!--#include file="lib.asp"-->
<%
rut = request.QueryString("rut")
%>
<title>EMPRESA S.A.</title>
<style type="text/css">
<!--
.Estilo35 {color: #333333}
.Estilo36 {
	color: #<%=session("COLTABBG")%>;
	font-weight: bold;
}
.Estilo37 {color: #000000}
-->
</style>
<form action="" method="post" name="datos">
<table width="720" height="420" border="0">
  <tr>
    <td height="20"><img src="../lib/TITULO_MAS_COR.gif" width="740" height="22"></td>
  </tr>
  <tr>
    <td valign="top" background="../images/fondo_coventa.jpg">
	  <%
	    abrirscg()
		ssql=""
		ssql="SELECT FechaIngreso,Email,Correlativo,Estado,FechaRevision FROM DEUDOR_EMAIL WHERE RUTDEUDOR='"&rut&"' ORDER BY FechaIngreso"
		set rsDIR=Conn.execute(ssql)
		if not rsDIR.eof then
	  %>
	  <input name="rut" type="hidden" id="rut" value="<%=rut%>">
	  <table width="100%" border="0" bordercolor="#FFFFFF">
        <tr bordercolor="#FFFFFF" class="Estilo13">
          <td width="29%" bgcolor="#<%=session("COLTABBG")%>">DIRECCI&Oacute;N DE CORREO </td>
          <td width="19%" bgcolor="#<%=session("COLTABBG")%>">FECHA DE INGRESO</td>
          <td width="18%" bgcolor="#<%=session("COLTABBG")%>">FECHA DE AUDITORIA</td>
          <td width="23%" bgcolor="#<%=session("COLTABBG")%>">ESTADO CORREO </td>
        </tr>
		<%
		sinauditar=0
		novalida=0
		valida=0
		do until rsDIR.eof
			FechaIngreso=rsDIR("FechaIngreso")
			if isNULL(FechaIngreso) then
			FechaIngreso=""
			end if
			Email=rsDIR("Email")

			FechaRevision=rsDIR("FechaRevision")
			if isNULL(FechaRevision) then
			FechaRevision=""
			end if

			correlativo_deudor=rsDIR("Correlativo")
			Estado=rsDIR("Estado")
			if estado="0" then
			estado_direccion="SIN AUDITAR"
			elseif estado="1" then
			estado_direccion="VALIDO"
			elseif estado="2" then
			estado_direccion="NO VALIDO"
			end if
		%>

        <tr bordercolor="#FFFFFF">
          <td><div align="left"></div>
            <div align="left"><%=Email%></div></td>
          <td><div align="left"></div>
            <div align="left"><%=MID(Cstr(FechaIngreso),1,10)%></div></td>
          <td><div align="right"><%=MID(Cstr(FechaRevision),1,10)%></div></td>
          <td><div align="right"><span class="Estilo35">
              <input name="radiomail<%=correlativo_deudor%>" type="radio" value="1"
			  <%if estado_direccion="VALIDO" then
			   Response.Write("checked")
			   valida=valida+1
			   end if%>>
              VA
			  <input name="radiomail<%=correlativo_deudor%>" type="radio" value="2"
			  <%if estado_direccion="NO VALIDO" then
			  Response.Write("checked")
			  novalida=novalida+1
			  end if%>>
			  NV
              <input name="radiomail<%=correlativo_deudor%>" type="radio" value="0"
			  <%if estado_direccion="SIN AUDITAR" then
			  Response.Write("checked")
			  sinauditar=sinauditar+1
			  end if%>>
              SA
		    </span></div></td>
        </tr>
	<%
	rsDIR.movenext
	loop
	   %>
        <tr bordercolor="#FFFFFF" bgcolor="#<%=session("COLTABBG")%>">
          <td bgcolor="#<%=session("COLTABBG2")%>"><span class="Estilo37"><span class="Estilo36">TOTALES :</span> V&Aacute;LIDOS : <%=valida%></span></td>
          <td bgcolor="#<%=session("COLTABBG2")%>"><span class="Estilo37">NO V&Aacute;LIDOS : <%=novalida%></span></td>
          <td bgcolor="#<%=session("COLTABBG2")%>"><span class="Estilo37">SIN AUDITAR : <%=sinauditar%></span></td>
          <td bgcolor="#<%=session("COLTABBG2")%>"><span class="Estilo37">TOTAL CORREOS : <%=(valida+novalida+sinauditar)%></span></td>
        </tr>

      </table>
	  <%
		end if
		rsDIR.close
		set rsDIR=nothing
		cerrarscg()

	  %>        <br><br>
        <span class="Estilo35">
        <input name="Submit" type="button" class="Estilo8" onClick="envia();" value="Guardar Cambios Realizados">
      </span> </td>
  </tr>
</table>
</form>

<script language="JavaScript" type="text/JavaScript">
function envia(){
datos.action='audita_cor.asp';
datos.submit();
}

</script>

