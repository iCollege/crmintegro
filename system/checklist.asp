<!--#include file="arch_utils.asp"-->
<!--#include file="lib.asp"-->
<!--#include file="../lib/comunes/rutinas/funciones.inc" -->

<script language="JavaScript">
	function ventanaSecundaria (URL)
	{
		window.open(URL,"DETALLE","width=200, height=200, scrollbars=no, menubar=no, location=no, resizable=no")
	}
</script>
<%
	rut = request("rut")
	cliente=request("cliente")
	fono_con = request("fono_con")
	strTipo =request("CB_TIPO")
%>
<title>CHECKLIST</title>
<style type="text/css">
	<!--
	.Estilo33 {color: #FF0000}
	.Estilo34 {font-size: xx-small}
	.Estilo35 {color: #FFFFFF}
	-->
</style>
<form name="datos" method="post">
<table width="600" border="0">
  <tr>
  	<TD width="100%" height="30" ALIGN=LEFT class="pasos">
		<B>Checklist Documentacion Ingreso de Gestiones</B>
	</TD>
  </tr>
 </table>
   	<%
		rut = request("rut")
		cliente=request("cliente")
	%>
	  <%
	  if not rut="" then
		  %>
		  <input name="rut" type="hidden" value="<%=rut%>">
		  <input name="cliente" type="hidden" value="<%=cliente%>">
		  <%
		  if not session("session_login") = "" then
		  %>
			<table width="600" border="10" bordercolor="#FFFFFF">
			<tr bordercolor="#999999" bgcolor="#<%=session("COLTABBG")%>" class="Estilo13">
			  <td width="33%">TIPO</td>
			  <td width="67%">&nbsp</td>
			</tr>
			<tr bordercolor="#999999">
			  <TD width="33%" VALIGN="TOP">
			  <select name="CB_TIPO" onChange="Refrescar( this.form );">
			  <option value="0">SELECCIONE</option>
			<%
			  	AbrirSCG()
					strSql="SELECT DISTINCT TIPO FROM CHECKLIST"
					set rsGestCat=Conn.execute(strSql)
					Do While not rsGestCat.eof
						If Trim(strTipo) = Trim(rsGestCat("TIPO")) Then strSel = "SELECTED" Else strSel = ""
				%>
						<option value="<%=rsGestCat("TIPO")%>" <%=strSel%>><%=rsGestCat("TIPO")%></option>
				<%
						rsGestCat.movenext
					Loop
					rsGestCat.close
					set rsGestCat=nothing
				CerrarSCG()
			%>
			  </select>
			  </td>
			  <td width="66%">

				  <table width="100%" border="0" bordercolor="#FFFFFF">
					<tr bordercolor="#999999" bgcolor="#<%=session("COLTABBG")%>" class="Estilo13">
							<td width="">ID</td>
							<td width="">&nbsp</td>
							<td width="">DESCRIPCION</td>
							<td width="">Titular</td>
							<td width="">Aval</td>
					</tr>
					<%
					If Trim(strTipo) <> "" Then
						AbrirSCG()
							strSql="SELECT ID_CHECKLIST, DESCRIPCION FROM CHECKLIST WHERE TIPO = '" & Trim(strTipo) & "'"
							set rsDesc=Conn.execute(strSql)
							Do While not rsDesc.eof
							%>
							<tr>
								<td><%=rsDesc("ID_CHECKLIST")%></td>
								<td><INPUT TYPE=CHECKBOX NAME="CH_GRAL<%=rsDesc("ID_CHECKLIST")%>" VALUE=""></td>
								<td><%=rsDesc("DESCRIPCION")%></td>
								<td>
									<INPUT TYPE=CHECKBOX NAME="CH_TITULAR<%=rsDesc("ID_CHECKLIST")%>" VALUE="">
								</td>
								<td>
									<INPUT TYPE=CHECKBOX NAME="CH_AVAL<%=rsDesc("ID_CHECKLIST")%>" VALUE="">
								</td>
							<tr>
							<%
							rsDesc.movenext
							Loop
							rsDesc.close
							set rsDesc=nothing
						CerrarSCG()
					End If
					%>
				   </table>
			  </td>
			</tr>
			<tr>
				<td align="CENTER" colspan="2">
					<input name="ingresar" type="button" onClick="nueva();" value="Ingresar CheckList">
				</td>
		 	</tr>
			 <%
			 End if
		End if
	%>
</table>
</form>

<script language="JavaScript1.2">


function Refrescar(){
	datos.action='checklist.asp?intFiltro=1';
	datos.submit();
}

function valida_largo(campo, minimo){
//alert(datos.fono_aportado_area.value)
	//if (datos.fono_aportado_area.value!="0"){
		if(campo.value.length != minimo) {
			alert("Fono debe tener " + minimo + " digitos")
			campo.select()
			campo.focus()
			return(true)
		}
	//}
	return(false)
}

function solonumero(valor){
     //Compruebo si es un valor numérico
      if (isNaN(valor.value)) {
            //entonces (no es numero) devuelvo el valor cadena vacia
            valor.value=""
			return ""
      }else{
            //En caso contrario (Si era un número) devuelvo el valor
			valor.value
			return valor.value
      }
}

function nueva(){
	if(datos.ingresar.disabled = false)
	{
		alert('Favor Espere');
	}
	else
	{

		datos.ingresar.disabled=true
		datos.action='checklist.asp';
		datos.submit();
	}
}

</script>




































































