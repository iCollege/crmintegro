<% @LCID = 1034 %>
<!--#include file="arch_utils.asp"-->
<!--#include file="../lib/comunes/rutinas/funciones.inc" -->
<!--#include file="lib.asp"-->
<%
rut = request.QueryString("rut")
%>
<title>DIRECCIONES DEL DEUDOR</title>
<style type="text/css">
<!--
.Estilo35 {color: #333333}
.Estilo36 {color: #FFFFFF}
.Estilo37 {color: #000000}
-->
</style>
<form action="" method="post" name="datos">
<table width="720" height="420" border="0">
  <tr>
    <td height="20"><img src="../lib/TITULO_MAS_DIR.gif" width="740" height="22"></td>
  </tr>
  <tr>
    <td valign="top" background="../images/fondo_coventa.jpg">
	  <%

		abrirscg()
		ssql=""
		ssql="SELECT Calle,Numero,Comuna,Correlativo,Resto,Estado,FechaIngreso FROM DEUDOR_DIRECCION WHERE RUTDEUDOR='"&rut&"' ORDER BY FechaIngreso"
		set rsDIR=Conn.execute(ssql)
		if not rsDIR.eof then
	  %>
	  <input name="rut" type="hidden" id="rut" value="<%=rut%>">
	  <table width="100%" border="0" bordercolor="#FFFFFF">
        <tr bordercolor="#FFFFFF" bgcolor="#<%=session("COLTABBG")%>" class="Estilo13">
          <td width="32%">CALLE</td>
          <td width="7%">NUMERO</td>
          <td width="12%" bgcolor="#<%=session("COLTABBG")%>">RESTO</td>
          <td width="14%">COMUNA</td>
          <td width="15%">FECHA DE INGRESO </td>
          <td width="20%">ESTADO DIRECCI&Oacute;N </td>
        </tr>
		<%
		sinauditar=0
		novalida=0
		valida=0
		do until rsDIR.eof
			FechaRevision=rsDIR("FechaIngreso")
			if isNULL(FechaRevision) then
			FechaRevision=""
			end if
			calle_deudor=rsDIR("Calle")
			numero_deudor=rsDIR("Numero")
			comuna_deudor=rsDIR("Comuna")
			correlativo_deudor=rsDIR("Correlativo")
			Resto=rsDIR("Resto")
			Estado=rsDIR("Estado")
			if estado="0" then
			estado_direccion="SIN AUDITAR"
			elseif estado="1" then
			estado_direccion="VALIDA"
			elseif estado="2" then
			estado_direccion="NO VALIDA"
			end if
		%>

        <tr bordercolor="#FFFFFF">
          <td><%=calle_deudor%></td>
          <td><div align="left"></div>
            <div align="left"><%=numero_deudor%></div></td>
          <td><div align="left"></div>
            <div align="left"><%=Resto%></div></td>
          <td><div align="left"></div>
            <div align="left"><%=comuna_deudor%></div></td>
          <td><div align="right"><%=MID(Cstr(FechaRevision),1,10)%></div></td>
          <td><div align="right"><span class="Estilo35">
              <input name="radiodir<%=correlativo_deudor%>" type="radio" value="1"
			  <%if estado_direccion="VALIDA" then
			   Response.Write("checked")
			   valida=valida+1
			   end if%>>
              VA
			  <input name="radiodir<%=correlativo_deudor%>" type="radio" value="2"
			  <%if estado_direccion="NO VALIDA" then
			  Response.Write("checked")
			  novalida=novalida+1
			  end if%>>
			  NV
              <input name="radiodir<%=correlativo_deudor%>" type="radio" value="0"
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
          <td bgcolor="#<%=session("COLTABBG")%>"><span class="Estilo36">TOTALES</span></td>
          <td></td>
          <td bgcolor="#<%=session("COLTABBG2")%>"><span class="Estilo37">V&Aacute;LIDAS : <%=valida%></span></td>
          <td bgcolor="#<%=session("COLTABBG2")%>"><span class="Estilo37">NO V&Aacute;LIDAS : <%=novalida%></span></td>
          <td bgcolor="#<%=session("COLTABBG2")%>"><span class="Estilo37">SIN AUDITAR : <%=sinauditar%></span></td>
          <td bgcolor="#<%=session("COLTABBG2")%>"><span class="Estilo37">TOTAL DIRECCIONES : <%=(valida+novalida+sinauditar)%></span></td>
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
datos.action='audita_dir.asp';
datos.submit();
}

</script>

