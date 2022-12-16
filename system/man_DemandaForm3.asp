<%@ LANGUAGE = "VBScript" %>
<!--#include file="asp/comunes/General/MostrarRegistro.inc"-->
<!--#include file="asp/comunes/general/JavaEfectoBotones.inc"-->
<!--#include file="asp/comunes/general/rutinasTraeCampo.inc"-->
<!--#include file="asp/comunes/general/rutinasVarias.inc"-->

<% ' Capa 1 ' %>
<!--#include file="asp/comunes/odbc/AdoVbs.inc"-->
<!--#include file="arch_utils.asp"-->
<!--#include file="asp/comunes/odbc/ObtenerRecordSet.inc"-->
<!--#include file="asp/comunes/odbc/ObtenerRegistros.inc"-->

<% ' Capa 2 ' %>
<!--#include file="asp/comunes/recordset/Demanda.inc"-->
<!--#include file="asp/comunes/select/RazonTermino.inc"-->
<!--#include file="asp/comunes/select/ClienteQry.inc"-->
<!--#include file="asp/comunes/select/Tribunal.inc"-->
<!--#include file="asp/comunes/select/Abogado.inc"-->
<!--#include file="asp/comunes/select/Actuario.inc"-->
<!--#include file="asp/comunes/select/UsuarioProcurador.inc"-->
<!--#include file="asp/comunes/select/EstadoDemanda.inc"-->


<%

	sintNuevo = request("sintNuevo")
    IntId= request("IDDEMANDA")
    strRut = request("rut")

    AbrirSCG()

	'Response.Write ("***" & IntId & "***")
	'Response.End

    If sintNuevo = 1 Then
        strFormMode="Nuevo"
        IntId=0
        strDisabled=""
    Else
        strFormMode="Edit"
        strDisabled="DISABLED"
    End If

    ''strFormMode="Nuevo"

    intIdCliente = request("intIdCliente")

    intIdCliente=session("ses_codcli")



	recordset_Demanda Conn, srsRegistro, IntId
	If Not srsRegistro.Eof Then
		intIdTribunal = Trim(srsRegistro("IDTRIBUNAL"))
		intIdRazonTermino = Trim(srsRegistro("RAZON_TERMINO"))
		intIdEstadoDemanda = Trim(srsRegistro("IDESTADO"))
		intIdAbogado = Trim(srsRegistro("IDABOGADO"))
		intIdProcurador = Trim(srsRegistro("IDPROCURADOR"))
		intIdActuario = Trim(srsRegistro("IDACTUARIO"))
		intIdCodCliente = Trim(srsRegistro("CODCLIENTE"))
		strRut=Trim(srsRegistro("RUTDEUDOR"))
		intMonto=srsRegistro("MONTO")
		intGastosJudiciales=srsRegistro("GASTOS_JUDICIALES")
		intHonorarios=srsRegistro("HONORARIOS")
		intIntereses=srsRegistro("INTERESES")
		intIndemComp=srsRegistro("INDEM_COMPENSATORIA")
		intTotalAPagar=srsRegistro("TOTAL_APAGAR")
	Else
		intIdTribunal = ""
		intIdRazonTermino = ""
		intIdEstadoDemanda = ""
		intIdAbogado = ""
		intIdProcurador = ""
		intIdActuario = ""
		intIdCodCliente = ""
		intMonto = "0"
		intGastosJudiciales="0"
		intHonorarios="0"
		intIntereses="0"
		intIndemComp="0"
		intTotalAPagar="0"
	End If

	''Response.Write ("***" & intIdProcurador & "***")

    'Response.Write ("***intIdCliente***")
    'Response.Write ("***" & intIdCliente & "***")

%>

<HTML>
<HEAD><TITLE>Mantenedor de Demandas</TITLE>
<LINK rel="stylesheet" TYPE="text/css" HREF="isk_style.css">
</HEAD>

<BODY BGCOLOR='FFFFFF'>

<SCRIPT Language=JavaScript>
function Continuar() {
    //if ( document.forms[0].ID.value == '' || esNumero('tinyint',document.forms[0].ID.value)=="false") {
    //    alert( "Debe ingresar en código un dato numerico entero entre 0 y 255" );
    //    return false
    //}

    JuntaDetalle();

	document.forms[0].submit()
    return false
}
</SCRIPT>


<FORM NAME="mantenedorForm"  action="man_DemandaAction.asp" method="POST" onmouseover="highlightButton('start')" onmouseout="highlightButton('')">
	<INPUT TYPE="HIDDEN" NAME="prods">
	<INPUT TYPE="HIDDEN" NAME="strFormMode" VALUE="<%=strFormMode%>">
	<INPUT TYPE="HIDDEN" NAME="intIdCliente" VALUE="<%=intIdCliente%>">
	<INPUT TYPE="HIDDEN" NAME="intIdPropiedad" VALUE="<%=intIdPropiedad%>">
	<INPUT TYPE="HIDDEN" NAME="sintNuevo" VALUE="<%=sintNuevo%>">

<TABLE WIDTH="550" BORDER="0" CELLPADDING=0 CELLSPACING=0 ALIGN="CENTER">
    <TR>
     <TD>
<TABLE width="100%" CLASS="tabla1">
    <TR HEIGHT=50>
    	<TD width="100%" ALIGN=CENTER>
            <B>MANTENEDOR DE DEMANDAS</B>
        </TD>
    </TR>
</TABLE>


<table width="100%" border="0" cellpadding=2 cellspacing=0>
    <tr>
     <td  width="26%" align=center>
		<%
		If strFormMode = "Nuevo" Then
        	'general_MostrarCampo "IDDEMANDA", False, Null, Null, srsRegistro

        Else
            'Response.Write srsRegistro("IDDEMANDA")
            Response.Write "<INPUT TYPE=HIDDEN NAME=IDDEMANDA VALUE=""" & srsRegistro("IDDEMANDA") & """>"

        End If%>
	</td>
    </tr>
 </Table>

 <table width="100%" border="0" CLASS="tabla1">
    	<TR BGCOLOR="#FFFFFF">
    		<td class="hdr_i"><img src='../images/boton_no_1.gif' align='absmiddle'>&nbspINGRESO DEMANDA</Font></td>
     </tr>
</Table>


<table width="100%" border="0" CLASS="tabla1">
	<TR BGCOLOR="#FFFFFF">
		<td class="hdr_i">Rut Demandado</Font></td>
		<td class="td_t">
			<input name="RUTDEUDOR" type="text" value="<%=strRut%>" size="12" maxlength="12" onChange="Refrescar(this.value);">
		</td>
	</TR>
	<TR BGCOLOR="#FFFFFF">
		<td class="hdr_i">Cliente</Font></td>
		<td class="td_t">
			<%
			strQuery = " WHERE CODCLIENTE = '" & intIdCliente & "'"
			select_ClienteQry Conn, strQuery, sarrTemp, sintTotalReg %>

			<SELECT NAME="CB_CLIENTE">
				<OPTION VALUE="0">SELECCIONE</OPTION>
				<% For intRow = 0 To sintTotalReg%>
				<OPTION VALUE="<%=Trim(sarrTemp(intRow).Item("CODCLIENTE"))%>"
				<% If Trim(sarrTemp(intRow).Item("CODCLIENTE"))  = intIdCodCliente Then Response.Write "SELECTED" %>><%=Trim(sarrTemp(intRow).Item("DESCRIPCION"))%>
				</OPTION>
				<% Next %>
			</SELECT>
		</td>
	</tr>
	<TR BGCOLOR="#FFFFFF">
		<td class="hdr_i">Tribunal</Font></td>
		<td class="td_t">
			<% select_Tribunal Conn, sarrTemp, sintTotalReg %>
			<SELECT NAME="CB_TRIBUNAL">
				<OPTION VALUE="0">SELECCIONE</OPTION>
				<% For intRow = 0 To sintTotalReg%>
				<OPTION VALUE="<%=Trim(sarrTemp(intRow).Item("IDTRIBUNAL"))%>"
				<% If Trim(sarrTemp(intRow).Item("IDTRIBUNAL"))  = intIdTribunal Then Response.Write "SELECTED" %>><%=Trim(sarrTemp(intRow).Item("NOMTRIBUNAL"))%>
				</OPTION>
				<% Next %>
			</SELECT>
		</td>
	</tr>

	<TR BGCOLOR="#FFFFFF">
		<td class="hdr_i">Rol - Año</Font></td>
		<td class="td_t"><% general_MostrarCampo "ROLANO", False, Null, Null,srsRegistro %></td>
	</TR>
	<TR BGCOLOR="#FFFFFF">
		<td class="hdr_i">Fecha Ingreso</Font></td>
		<td class="td_t"><% general_MostrarCampo "FECHA_INGRESO", False, Null, Null,srsRegistro %></td>
	</TR>
	<TR BGCOLOR="#FFFFFF">
		<td class="hdr_i">Fecha Caducidad</Font></td>
		<td class="td_t"><% general_MostrarCampo "FECHA_CADUCIDAD", False, Null, Null,srsRegistro %></td>
	</TR>


	<TR BGCOLOR="#FFFFFF">
		<td class="hdr_i">Procurador</Font></td>
		<td class="td_t">
			<%
			select_UsuarioProcurador Conn, sarrTemp, sintTotalReg
			%>
			<SELECT NAME="CB_PROCURADOR">
				<OPTION VALUE="0">SELECCIONE</OPTION>
				<% For intRow = 0 To sintTotalReg%>
				<OPTION VALUE="<%=Trim(sarrTemp(intRow).Item("ID_USUARIO"))%>"
				<% If Trim(sarrTemp(intRow).Item("ID_USUARIO")) = Trim(intIdProcurador) Then Response.Write "SELECTED" %>><%=Trim(sarrTemp(intRow).Item("NOMBRES_USUARIO")) & " " & Trim(sarrTemp(intRow).Item("APELLIDOS_USUARIO"))%>
				</OPTION>
				<% Next %>
			</SELECT>
		</td>
	</tr>

	<TR BGCOLOR="#FFFFFF">
		<td class="hdr_i">Abogado</Font></td>
		<td class="td_t">
			<% select_Abogado Conn, sarrTemp, sintTotalReg %>
			<SELECT NAME="CB_ABOGADO">
				<OPTION VALUE="0">SELECCIONE</OPTION>
				<% For intRow = 0 To sintTotalReg%>
				<OPTION VALUE="<%=Trim(sarrTemp(intRow).Item("IDABOGADO"))%>"
				<% If Trim(sarrTemp(intRow).Item("IDABOGADO")) = intIDABOGADO Then Response.Write "SELECTED" %>><%=Trim(sarrTemp(intRow).Item("IDABOGADO")) & " - " & Trim(sarrTemp(intRow).Item("NOMABOGADO"))%>
				</OPTION>
				<% Next %>
			</SELECT>
		</td>
	</tr>

	<TR BGCOLOR="#FFFFFF">
		<td class="hdr_i">Actuario</Font></td>
		<td class="td_t">
			<% select_Actuario Conn, sarrTemp, sintTotalReg %>
			<SELECT NAME="CB_ACTUARIO">
				<OPTION VALUE="0">SELECCIONE</OPTION>
				<% For intRow = 0 To sintTotalReg%>
				<OPTION VALUE="<%=Trim(sarrTemp(intRow).Item("IDACTUARIO"))%>"
				<% If Trim(sarrTemp(intRow).Item("IDACTUARIO")) = intIDActuario Then Response.Write "SELECTED" %>><%=Trim(sarrTemp(intRow).Item("IDACTUARIO")) & " - " & Trim(sarrTemp(intRow).Item("NOMACTUARIO"))%>
				</OPTION>
				<% Next %>
			</SELECT>
		</td>
	</tr>

	<TR BGCOLOR="#FFFFFF">
		<td class="hdr_i">Monto</Font></td>
		<!--td class="td_t"><% general_MostrarCampo "MONTO", False, Null, Null,srsRegistro %></td-->

		<td class="td_t"><input name="MONTO" type="text" value="<%=intMonto%>" size="10" maxlength="10" onchange="solonumero(MONTO);suma_total_general(1);"></td>

	</TR>
	<TR BGCOLOR="#FFFFFF">
		<td class="hdr_i">Fecha Comparendo</Font></td>
		<td class="td_t"><% general_MostrarCampo "FECHA_COMPARENDO", False, Null, Null,srsRegistro %></td>
	</TR>

	<TR BGCOLOR="#FFFFFF">
			<td class="hdr_i">Razon de Termino</Font></td>
			<td class="td_t">
				<% select_RazonTermino Conn, sarrTemp, sintTotalReg%>
				<SELECT NAME="CB_RAZONTERMINO">
					<OPTION VALUE="0">SELECCIONE</OPTION>
					<% For intRow = 0 To sintTotalReg%>
					<OPTION VALUE="<%=Trim(sarrTemp(intRow).Item("IDRAZONTERMINO"))%>"
					<% If Trim(sarrTemp(intRow).Item("IDRAZONTERMINO"))  = intIdRazonTermino Then Response.Write "SELECTED" %>><%=Trim(sarrTemp(intRow).Item("NOMRAZONTERMINO"))%>
					</OPTION>
					<% Next %>
				</SELECT>
			</td>
	</tr>


	<TR BGCOLOR="#FFFFFF">
		<td class="hdr_i">Gastos Judiciales</Font></td>
		<!--td class="td_t"><% general_MostrarCampo "GASTOS_JUDICIALES", False, Null, Null,srsRegistro %></td-->
		<td class="td_t"><input name="GASTOS_JUDICIALES" type="text" value="<%=intGastosJudiciales%>" size="10" maxlength="10" onchange="solonumero(GASTOS_JUDICIALES);suma_total_general(1);"></td>
	</TR>


	<TR BGCOLOR="#FFFFFF">
		<td class="hdr_i">Honorarios</Font></td>
		<!--td class="td_t"><% general_MostrarCampo "HONORARIOS", False, Null, Null,srsRegistro %></td-->
		<td class="td_t"><input name="HONORARIOS" type="text" value="<%=intHonorarios%>" size="10" maxlength="10" onchange="solonumero(HONORARIOS);suma_total_general(1);"></td>
	</TR>
	<TR BGCOLOR="#FFFFFF">
		<td class="hdr_i">Intereses</Font></td>
		<!--td class="td_t"><% general_MostrarCampo "INTERESES", False, Null, Null,srsRegistro %></td-->
		<td class="td_t"><input name="INTERESES" type="text" value="<%=intIntereses%>" size="10" maxlength="10" onchange="solonumero(INTERESES);suma_total_general(1);"></td>
	</TR>
	<TR BGCOLOR="#FFFFFF">
		<td class="hdr_i">Indemnizacion Compensatoria</Font></td>
		<!--td class="td_t"><% general_MostrarCampo "INDEM_COMPENSATORIA", False, Null, Null,srsRegistro %></td-->
		<td class="td_t"><input name="INDEM_COMPENSATORIA" type="text" value="<%=intIndemComp%>" size="10" maxlength="10" onchange="solonumero(INDEM_COMPENSATORIA);suma_total_general(1);"></td>
	</TR>
	<TR BGCOLOR="#FFFFFF">
		<td class="hdr_i">Total A Pagar</Font></td>
		<!--td class="td_t"><% general_MostrarCampo "TOTAL_APAGAR", False, Null, Null,srsRegistro %></td-->
		<td class="td_t"><input name="TOTAL_APAGAR" READONLY type="text" value="<%=intTotalAPagar%>" size="10" maxlength="10" onchange="solonumero(TOTAL_APAGAR);suma_total_general(1);"></td>
	</TR>
	<!--TR BGCOLOR="#FFFFFF">
		<td class="hdr_i">Estado Demanda</Font></td>
		<td class="td_t">
			<% select_EstadoDemanda Conn, sarrTemp, sintTotalReg %>
			<SELECT NAME="CB_ESTADODEMANDA">
				<OPTION VALUE="0">SELECCIONE</OPTION>
				<% For intRow = 0 To sintTotalReg%>
				<OPTION VALUE="<%=Trim(sarrTemp(intRow).Item("IDESTADODEMANDA"))%>"
				<% If Trim(sarrTemp(intRow).Item("IDESTADODEMANDA")) = intIdEstadoDemanda Then Response.Write "SELECTED" %>><%=Trim(sarrTemp(intRow).Item("IDESTADODEMANDA")) & " - " & Trim(sarrTemp(intRow).Item("NOMESTADODEMANDA"))%>
				</OPTION>
				<% Next %>
			</SELECT>
		</TD>
	</TR-->

	<TR>
		<td colspan=2>
		<table width="100%" border="0" CLASS="tabla1">
			<TR BGCOLOR="#FFFFFF">
			<TD>
				<select name="ls_deudas">
					<option value="0">SELECCIONE</option>
					<%

					strSql="SELECT IDCUOTA, SALDO, CODREMESA FROM CUOTA WHERE RUTDEUDOR = '" & strRut & "' AND IDDEMANDA IS NULL"
					set rsDeuda=Conn.execute(strSql)
					if not rsDeuda.eof then
					do until rsDeuda.eof
					'intSaldo = String(1, FN(rsDeuda("SALDO"),0))
					'intSaldo = Mid(intSaldo,1,20)
					intSaldo = FN(rsDeuda("SALDO"),0)
					%>
					<option value="<%=rsDeuda("IDCUOTA")%>"> <%=" Monto Deuda : " & intSaldo & " , Remesa : " & rsDeuda("CODREMESA")%></option>
					<%
					rsDeuda.movenext
					loop
					end if
					rsDeuda.close
					set rsDeuda=nothing
					%>
				</select>
				<input name="AGREGAR" type="button" value="Agregar"  onClick="meteitem();">
				<input name="AGREGAR_TODOS" type="button" value="Agregar Todos"  onClick="metetodos();">
			</TD>
			</TR>

			<TR>
				<TD>
					<select name="ls_item" size="7" ondblClick=" borra_combos(this.selectedIndex);" onChange="select_combos(this.selectedIndex);"></select>
				</td>
				<td>
					<!--select name="ls_cantidad" size="7" ondblClick=" borra_combos(this.selectedIndex);" onChange="select_combos(this.selectedIndex);"></select-->
				</td>
			</tr>
		</table>


		</td>

	</TR>
</table>



<% If strFormMode = "Edit" Then %>
<table width="100%" border="0" CLASS="tabla1">
	<TR>
		<td class="hdr_i" width="50%">
			Visitas Ingresadas
		</TD>
		<td class="hdr_i">

				<A HREF="man_notificacionForm.asp?sintNuevo=1&IDLLAMADO=<%=IntId%>">
					Nueva Visita
				</A>
		</TD>
    </TR>

	<TR>
		<TD ALIGN=LEFT colspan=2>
			<TABLE BORDER=0 CELLSPACING=0 CELLPADDING=0 WIDTH="100%" CLASS="tabla1">
			<TR BGCOLOR="#F3F3F3">
				<TD WIDTH="20"><b>Id</TD>
				<TD WIDTH="80"><b>Fecha</TD>
				<TD WIDTH="40"><b>Tipo</TD>
				<TD WIDTH="40"><b>Valor</TD>
				<TD WIDTH="70">&nbsp</TD>
			</TR>

			<%
				strSql="SELECT IDNOTIFICACION , CONVERT(VARCHAR(10),FECHA,103) AS FECHA, IDESTADONOTIF, VALOR ,OBSERVACIONES FROM DEMANDA_NOTIF WHERE IDDEMANDA = " & IntId
				set rsNotificacion=sObjDbConnection.execute(strSql)
				if not rsNotificacion.eof then
				do until rsNotificacion.eof
				%>

				<TR BGCOLOR="#FFFFFF">
						<td class="td_t"><%=rsNotificacion("IDNOTIFICACION")%></td>
						<td class="td_t"><%=rsNotificacion("FECHA")%></td>
						<td class="td_t"><%=rsNotificacion("IDESTADONOTIF")%></td>
						<td class="td_t"><%=rsNotificacion("VALOR")%></td>
						<td class="td_t">
						<A HREF="man_notificacionForm.asp?sintNuevo=0&IDLLAMADO=<%=IntId%>&IDVISITA=<%=rsNotificacion("IDVISITA")%>">
							Ver Visita
						</A>
						</td>
				</TR>
			<%
				rsNotificacion.movenext
				loop
				end if
				rsNotificacion.close
				set rsNotificacion=nothing
			%>
			</TABLE>
		</TD>
    </TR>
</table>

<% End If%>



<table width="100%" border="0">
     <TR>
	  <td align=center  width="25%">
	   <INPUT TYPE="BUTTON" value="Guardar" name="B1" onClick="Continuar();return false;">
	   <input type="BUTTON" value="Terminar" name="terminar" onClick="Terminar('man_Demanda.asp');return false;"></TD>
	  </TD>
    </TR>
    <%If sintNuevo = 1 Then %>
    <TR>
    <TD align=center >
     	<IMG BORDER="0" src="../images/bolita.jpg" WIDTH=10>=Campo requerido
     </TD>
    </TR>
	<%End If %>
</table>

    </TD>
    </TR>
</TABLE>
</FORM>


<%CerrarSCG()%>

</BODY>

<script language="JavaScript" type="text/JavaScript">

function metetodos(){
	//alert(mantenedorForm.ls_deudas.options.length-1);
	for (var e=1; e<= mantenedorForm.ls_deudas.options.length-1; e++) {
		//if(!revisa_elementos_repetidos(mantenedorForm.ls_deudas, mantenedorForm.ls_item)){
			apilar_item(e,mantenedorForm.ls_deudas, mantenedorForm.ls_item);
		//}else{
		//	alert("La deuda ya está ingresada");
		//}

	}
	mantenedorForm.ls_deudas.selectedIndex=0;
}


function meteitem(){

	if (mantenedorForm.ls_deudas.selectedIndex!=0){
				if(!revisa_elementos_repetidos(mantenedorForm.ls_deudas, mantenedorForm.ls_item)){
					apilar_combo_combo(mantenedorForm.ls_deudas, mantenedorForm.ls_item);
					//apilar_textbox_combo(mantenedorForm.TX_CANTIDAD, mantenedorForm.ls_cantidad);
				}else{
					alert("La deuda ya está ingresada");
				}
	}else{
		alert("Debe seleccionar una deuda ");
	}
	mantenedorForm.ls_deudas.selectedIndex=0;
}

function revisa_elementos_repetidos(origen, destino){

		for (var e=0; e<= destino.options.length-1; e++) {
			if( destino.options[e].text == origen.options[origen.selectedIndex].text ){
				return(true);
			}
		}
		return(false)
}

function apilar_textbox_combo(origen, destino){
	var ok=false;
	i=destino.length;
	valor=origen.value.length ;
	if (valor>=0){
		texto=origen.value;
			var el = new Option(texto,origen.value);
			destino.options[i] = el;
	}else
		alert("ingrese un valor para agregar.");
}
//------------------------------------------------------------------
function apilar_combo_combo(origen, destino){
	var ok=false;
	i=destino.length;
	valor=origen.selectedIndex ;
	if (valor>=0){
		texto=origen.options[valor].text;
			var el = new Option(texto,origen.options[valor].value);
			destino.options[i] = el;
	}else
		alert("Seleccione un valor para agregar.");
}
//------------------------------------------------------------------
function apilar_item(item,origen, destino){
	var ok=false;
	i=destino.length;
	origen.selectedIndex=item;
	//alert(origen.selectedIndex);
	valor=origen.selectedIndex ;
	if (valor>=0){
		texto=origen.options[valor].text;
			var el = new Option(texto,origen.options[valor].value);
			destino.options[i] = el;
	}else
		alert("Seleccione un valor para agregar.");
}
function borra_combos(indice){
	borra_opcion(mantenedorForm.ls_item,indice);
}

function borra_opcion(combo,indice){
	if (combo.options.length>0){
	//	combo.options[indice]=null;
		for (var e=indice; e< combo.options.length-1; e++) {
			//alert(e);
			combo.options[e].text=combo.options[e+1].text;
			combo.options[e].value=combo.options[e+1].value;
		}
		combo.options[combo.options.length-1]=null;
	}
}

function select_combos(indice){
	mantenedorForm.ls_item.selectedIndex=indice;
}

function JuntaDetalle(){

 	mantenedorForm.prods.value=""
	for (var e=0; e<mantenedorForm.ls_item.options.length;e++){
		if (e!=0) {
		//poner la coma
			mantenedorForm.prods.value=mantenedorForm.prods.value+"*"	;
		}
		//concatenar
		mantenedorForm.prods.value=mantenedorForm.prods.value+mantenedorForm.ls_item.options[e].value;
		//alert(mantenedorForm.prods.value);
	}
}

function Refrescar(strTipo){

	mantenedorForm.action='man_DemandaForm.asp?rut=' + strTipo;
	if (mantenedorForm.strFormMode.value == 'Nuevo') {
		location.href="man_DemandaForm.asp?sintNuevo=1&rut=" + strTipo;
		}
	else {
	 	mantenedorForm.submit();
	}
}

function suma_total_general(){
	mantenedorForm.TOTAL_APAGAR.value = eval(mantenedorForm.MONTO.value) + eval(mantenedorForm.GASTOS_JUDICIALES.value) + eval(mantenedorForm.HONORARIOS.value) + eval(mantenedorForm.INTERESES.value) + eval(mantenedorForm.INDEM_COMPENSATORIA.value)
}

function solonumero(valor){
     //Compruebo si es un valor numérico

 if (valor.value.length >0){
      if (isNaN(valor.value)) {
            //entonces (no es numero) devuelvo el valor cadena vacia
            ////valor.value="0";
			//alert(valor.value)
			//valor.focus();
			return ""
      }else{
            //En caso contrario (Si era un número) devuelvo el valor
			valor.value
			return valor.value
      }
	  }
}

</script>
</HTML>

