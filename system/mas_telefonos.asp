<% @LCID = 1034 %>
<!--#include file="arch_utils.asp"-->
<!--#include file="../lib/comunes/rutinas/funciones.inc" -->
<!--#include file="lib.asp"-->
<!--#include file="asp/comunes/general/SoloNumeros.inc" -->
<%
rut = request.QueryString("rut")
If session("permite_no_validar_fonos") = "S" Then
	strNoValida = "disabled"
	strNoValida = ""
End If
%>
<title>TELEFONOS DEL DEUDOR</title>
<style type="text/css">
<!--
.Estilo35 {color: #333333}
.Estilo36 {color: #FFFFFF}
.Estilo37 {color: #000000}
-->
</style>
<form action="" method="post" name="datos">
<table width="720" border="0">
  <tr>
    <td height="20" colspan=2><img src="../lib/TITULO_MAS_TEL.gif" width="740" height="22"></td>
  </tr>
  <tr>
    <td valign="top" colspan=2>
	  <%

		abrirscg()
		ssql=""
		ssql="SELECT IDTELEFONO,CODAREA,TELEFONO,CORRELATIVO,ESTADO,FECHAINGRESO, ISNULL(TELEFONODAL,0) AS TELEFONODAL FROM DEUDOR_TELEFONO WHERE RUTDEUDOR='"&rut&"' ORDER BY FechaIngreso"
		set rsDIR=Conn.execute(ssql)
		if not rsDIR.eof then
	  %>
	  <input name="rut" type="hidden" id="rut" value="<%=rut%>">
	  <table width="100%" border="0" bordercolor="#FFFFFF">
        <tr bordercolor="#FFFFFF" bgcolor="#<%=session("COLTABBG")%>" class="Estilo13">
          <td>ID</td>
          <td>TIPO DE TEL&Eacute;FONO </td>
          <td>CODIGO DE &Aacute;REA </td>
          <td bgcolor="#<%=session("COLTABBG")%>">N&Uacute;MERO DE T&Eacute;LEFONO </td>
          <td>FECHA DE INGRESO </td>
          <td>ESTADO TEL&Eacute;FONO </td>
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
			CodArea=rsDIR("CodArea")
			Telefono=rsDIR("Telefono")
			correlativo_deudor=rsDIR("Correlativo")
			strTelefonoDal=rsDIR("TELEFONODAL")
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
        	<td><%=rsDIR("IDTELEFONO")%></td>
          <td>
		  <%
		  if CodArea="9" then
		  	response.Write("CELULAR")
		  Elseif CodArea="0" then
		  	response.Write("SIN ESPECIF.")
		  else
		  	response.Write("RED FIJA")
		  end if

		  %>
		  </td>
          <td><div align="left"><%=CodArea%></div></td>
          <td><div align="left">
             &nbsp;<a href="sip:<%=SoloNumeros(strTelefonoDal)%>"><%=Telefono%></a>
            </div></td>
          <td><div align="right"><%=MID(Cstr(FechaRevision),1,10)%></div></td>
          <td><div align="right"><span class="Estilo35">
          	  <input name="radiofon<%=correlativo_deudor%>" type="radio" value="1"
			  <%if estado_direccion="VALIDO" then
			   Response.Write("checked")
			   valida=valida+1
			   end if%>>
              VA
              <input name="radiofon<%=correlativo_deudor%>" <%=strNoValida%> type="radio" value="2"
			  <%if estado_direccion="NO VALIDO" then
			  Response.Write("checked")
			  novalida=novalida+1
			  end if%>>
			  NV
			  <input name="radiofon<%=correlativo_deudor%>" type="radio" value="0"
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
          <td bgcolor="#<%=session("COLTABBG2")%>"><span class="Estilo37">V&Aacute;LIDOS : <%=valida%></span></td>
          <td bgcolor="#<%=session("COLTABBG2")%>"><span class="Estilo37">NO V&Aacute;LIDOS : <%=novalida%></span></td>
          <td bgcolor="#<%=session("COLTABBG2")%>"><span class="Estilo37">SIN AUDITAR : <%=sinauditar%></span></td>
          <td bgcolor="#<%=session("COLTABBG2")%>" colspan=2><span class="Estilo37">TOTAL TELÉFONOS : <%=(valida+novalida+sinauditar)%></span></td>
        </tr>

      </table>
	  <%
		end if
		rsDIR.close
		set rsDIR=nothing
		cerrarscg()
	  %>
    </td>
  </tr>

   <tr bordercolor="#FFFFFF">
	<td align="LEFT"><input name="Submit" type="button" class="Estilo8" onClick="envia();" value="Guardar Cambios Realizados"></td>
	<td align="RIGHT"><input name="Volver" type="button" class="Estilo8" onClick="history.back();" value="Volver"></td>
	</tr>
</table>
</form>

<script language="JavaScript" type="text/JavaScript">
function envia(){
datos.action='audita_fon.asp';
datos.submit();
}

</script>

