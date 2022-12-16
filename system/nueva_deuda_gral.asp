<% @LCID = 1034 %>
<!--#include file="arch_utils.asp"-->
<!--#include file="sesion.asp"-->
<!--#include file="../lib/comunes/rutinas/funciones.inc" -->
<!--#include file="../lib/comunes/rutinas/TraeCampo.inc" -->
<!--#include file="lib.asp"-->
<%
rut = request("rut")

intCliente = request("cliente")

If intCliente = "" Then intCliente = session("ses_codcli")

AbrirSCG()
	strEnPantallaPpal = TraeCampoId2(Conn, "NOM_ADIC1", 1, "CLIENTE", "CODCLIENTE")
	strNomMoneda = TraeCampoId2(Conn, "NOM_MONEDA", session("COD_MONEDA"), "MONEDA", "COD_MONEDA")
CerrarSCG()

AbrirSCG()
	strSql="SELECT TOP 1 NOMBREDEUDOR,RUTDEUDOR FROM DEUDOR WHERE RUTDEUDOR='" & rut & "' AND NOMBREDEUDOR IS NOT NULL AND LTRIM(RTRIM(NOMBREDEUDOR)) <> '' "
	set rsDEU=Conn.execute(strSql)
	if not rsDEU.eof then
		nombre_deudor = rsDEU("NOMBREDEUDOR")
	else
		nombre_deudor = "SIN NOMBRE"
	end if
	rsDEU.close
	set rsDEU=nothing
cerrarSCG()

%>
<title>BACKOFFICE NUEVA DEUDA</title>
<style type="text/css">
<!--
.Estilo27 {color: #FFFFFF}
.Estilo32 {color: #FFFFFF; font-size: x-small; }
-->
</style>
<form name="datos" method="post">
<input name="rut" type="hidden" value="<%=rut%>">


<table width="100%" border="1" bordercolor="#FFFFFF">
	<tr>
		<TD height="20" ALIGN=LEFT class="pasos2_i">
			<B>INGRESO NUEVA DEUDA</B>
		</TD>
	</tr>
</table>

<table width="800">
  <tr height="10">
    <td></td>
  </tr>
  <% If Trim(strNomMoneda) <> "" Then %>
	 <tr height="20">
	  <td>
	  	<b>DEBE INGRESAR LOS VALORES EN <%=strNomMoneda%></b>
	  </td>
	</tr>
  <% End If%>
  <tr>
    <td valign="top" background="" width="100">
			<table border="0" bordercolor="#FFFFFF">
				<tr  bordercolor="#FFFFFF" bgcolor="#<%=session("COLTABBG")%>" class="Estilo13">
					<td>RUT</td>
					<td colspan=3>NOMBRE</td>
					<td>Fecha Creacion</td>
       			</tr>
       			<tr bordercolor="#FFFFFF">
       				<td>
						<%=UCASE(rut)%>
					</td>
					<td colspan=3>
						<%=UCASE(nombre_deudor)%>
					</td>
					<td>
					<input name="TX_FEC_CREACION" type="text" id="TX_FEC_CREACION" value="<%=dtmFecCreacion%>" size="10" maxlength="10">
						<a href="javascript:showCal('Cal_TX_FEC_CREACION');"><img src="../lib/calendario.gif" border="0"></a>
					</td>
        		</tr>
				<tr  bordercolor="#FFFFFF" bgcolor="#<%=session("COLTABBG")%>" class="Estilo13">
					<td>CLIENTE</td>
					<td colspan=3>GLOSA</td>
					<td>N°DOC</td>
       			</tr>
       			<tr bordercolor="#FFFFFF">
					<td>
						<select name="cliente" id="cliente" OnChange="Refrescar()">
							<%
							abrirscg()
							ssql="SELECT CODCLIENTE,DESCRIPCION FROM CLIENTE WHERE ACTIVO = 1 ORDER BY DESCRIPCION"
							set rscli= Conn.execute(ssql)
							do until rscli.eof
							If Trim(intCliente)=Trim(rscli("CODCLIENTE")) Then strSelCliente = "SELECTED" Else strSelCliente = ""
							%>
							<option value="<%=rscli("CODCLIENTE")%>" <%=strSelCliente%>><%=rscli("DESCRIPCION")%></option>
							<%
							rscli.movenext
							loop
							rscli.close
							set rscli=nothing
							cerrarscg()
							%>
						</select>
					</td>
					<td colspan=3><input name="glosa" type="text" size="70" maxlength="200"></td>
					<td><input name="nrodoc" type="text" size="10" maxlength="15"></td>

        		</tr>
      			<tr  bordercolor="#FFFFFF" bgcolor="#<%=session("COLTABBG")%>" class="Estilo13">
        			<td width="20%">N°CUOTA</td>
					<td width="20%">SALDO CAPITAL</td>
					<td width="20%">TIPO DOC</td>
					<td width="20%">CARTERA</td>
					<td width="20%">GASTOS PROTESTO</td>
       			</tr>
      			<tr bordercolor="#FFFFFF">
       				<td><input name="TX_NROCUOTA" type="text" size="10" maxlength="15"></td>
        			<td><input name="TX_SALDO" type="text" size="20"></td>
        			<td><input name="TX_TIPODOC" type="text" size="20" maxlength="20"></td>
        			<td>
						<select name="CB_REMESA">
							<%
							AbrirSCG()
								strSql="SELECT * FROM REMESA WHERE CODREMESA >= 100 AND CODCLIENTE = '" & intCliente & "'"
								set rsRemesa=Conn.execute(strSql)
								Do While not rsRemesa.eof
								If Trim(intCodRemesa)=Trim(rsRemesa("CODREMESA")) Then strSelRem = "SELECTED" Else strSelRem = ""
								%>
								<option value="<%=rsRemesa("CODREMESA")%>" <%=strSelRem%>> <%=rsRemesa("CODREMESA") & " - " & rsRemesa("FECHA_LLEGADA")%></option>
								<%
								rsRemesa.movenext
								Loop
								rsRemesa.close
								set rsRemesa=nothing
							CerrarSCG()
							''Response.End
							%>
						</select>
					</td>
        			<td><input name="protesto" type="text" size="20" maxlength="20"></td>


				</tr>
     			<tr bordercolor="#FFFFFF" bgcolor="#<%=session("COLTABBG")%>" class="Estilo13">
        			<td>NUM CLIENTE</td>
        			<td>CUENTA</td>
					<td>SUCURSAL</td>
        			<td>FECHA VENCIMIENTO	</td>
					<td>EJECUTIVO</td>
        		</tr>
      			<tr bordercolor="#FFFFFF">
        			<td><input name="numcliente" type="text" size="15" maxlength="15"></td>
        			<td><input name="TX_CUENTA" type="text" size="15" maxlength="15"></td>
        			<td><input name="sucursal" type="text" size="15" maxlength="15"></td>
        			<td valign="top"><input name="inicio" type="text" id="inicio" value="<%=inicio%>" size="10" maxlength="10">
						<a href="javascript:showCal('Calendar7');"><img src="../lib/calendario.gif" border="0"></a></td>
        			<td>
						<select name="cobrador" id="cobrador">
							<option value="0">SIN ASIGNAR</option>
							<%
							abrirscg()
							strSql = "SELECT ID_USUARIO, LOGIN FROM USUARIO ORDER BY LOGIN"
							set rsUSU= Conn.execute(strSql)
							Do until rsUSU.eof%>
							<option value="<%=rsUSU("ID_USUARIO")%>"><%=rsUSU("LOGIN")%></option>
							<%
							rsUSU.movenext
							loop
							rsUSU.close
							set rsUSU=nothing
							cerrarscg()
							%>
						</select>
					</td>

        		</tr>
        		<tr bordercolor="#FFFFFF" bgcolor="#<%=session("COLTABBG")%>" class="Estilo13">
					<td>ADICIONAL 1</td>
					<td>ADICIONAL 2</td>
					<td>ADICIONAL 3</td>
					<td>ADICIONAL 4</td>
					<td>ADICIONAL 5</td>
        		</tr>
        		<tr bordercolor="#FFFFFF">
       				<td><input name="TX_ADIC1" type="text" size="15" maxlength="50"></td>
       				<td><input name="TX_ADIC2" type="text" size="15" maxlength="50"></td>
       				<td><input name="TX_ADIC3" type="text" size="15" maxlength="50"></td>
       				<td><input name="TX_ADIC4" type="text" size="15" maxlength="50"></td>
       				<td><input name="TX_ADIC5" type="text" size="15" maxlength="50"></td>
       			</tr>
				<tr>
					<td>
						<input name="Submit" type="button" value="Grabar" onClick="envia();">
					</td>
				</tr>
    	</table>
    </td>
  </tr>
</table>
</form>

<%
abrirscg()
	ssql="SELECT IDCUOTA,RUTDEUDOR, IsNull(FECHAVENC,'01/01/1900') as FECHAVENC, IsNull(datediff(d,fechavenc,getdate()),0) as ANTIGUEDAD, NRODOC,IsNull(VIGENTE,0) as VIGENTE, IsNull(VALORCUOTA,0) as VALORCUOTA,IsNull(SALDO,0) as SALDO,isnull(GASTOSCOBRANZAS,0) as GASTOSCOBRANZAS,IsNull(USUARIO_ASIG,0) as USUARIO_ASIG,NROCUOTA, VIGENTE, IsNull(MORA,0) as MORA, IsNull(VENCIDA,0) as VENCIDA, IsNull(GASTOSPROTESTOS,0) as PROTESTO, CENTRO_COSTO, SUCURSAL , ESTADO_DEUDA, CODREMESA, CUENTA, NRODOC, TIPODOCUMENTO, CONVERT(VARCHAR(10),FECHA_ESTADO,103) AS FEC_ESTADO FROM CUOTA WHERE RUTDEUDOR='"& rut &"' AND CODCLIENTE='"& intCliente &"' ORDER BY CODREMESA,FECHAVENC DESC"
		'response.Write(ssql)
		'response.End()
		set rsDET=Conn.execute(ssql)
		if not rsDET.eof then
		%>
		  <table width="800" border="0" bordercolor="#FFFFFF">
	        <tr bordercolor="#999999" bgcolor="#<%=session("COLTABBG")%>" class="Estilo13">
	          <td>RUT</td>
	          <td>CUENTA</td>
	          <td>NRO. DOC</td>
	          <td>F.VENCIM.</td>
	          <td>ANTIG.</td>
	          <td>TIPO DOC</td>
	          <td>ASIG.</td>
	          <td>DEUDA ORIG.</td>
	          <td>PROTESTOS</td>
	          <td>SALDO</td>
	          <td>EJECUTIVO</td>
	          <td>ESTADO</td>
	          <td>F.ESTADO</td>
	        </tr>
			<%
			intSaldo = 0
			intValorCuota = 0
			total_ValorCuota = 0
			do until rsDET.eof
			intSaldo = ValNulo(rsDET("SALDO"),"N")
			intValorCuota = ValNulo(rsDET("VALORCUOTA"),"N")
			intValorProtesto = ValNulo(rsDET("PROTESTO"),"N")
			strNroDoc = Trim(rsDET("NRODOC"))
			strNroCuota = Trim(rsDET("NROCUOTA"))
			strSucursal = Trim(rsDET("SUCURSAL"))
			strEstadoDeuda = Trim(rsDET("ESTADO_DEUDA"))
			strCodRemesa = Trim(rsDET("CODREMESA"))

			If trim(cliente)="1001" Then
				strDetCuota="mas_datos_deuda_vne.asp"
			Else
				strDetCuota="mas_datos_deuda_bbva.asp"
			End if

			%>
	        <tr bordercolor="#999999" >
	          <!--td><div align="left">&nbsp</div></td-->
	          <td><div align="right"><%=rsDET("RUTDEUDOR")%></div></td>
	          <td><div align="right"><%=rsDET("CUENTA")%></div></td>
	          <td><div align="right"><%=rsDET("NRODOC")%></div></td>
	          <td><div align="right"><%=rsDET("FECHAVENC")%></div></td>
	          <td><div align="right"><%=rsDET("ANTIGUEDAD")%></div></td>
	          <td><div align="right"><%=rsDET("TIPODOCUMENTO")%></div></td>
	          <td><div align="right"><%=rsDET("CODREMESA")%></div></td>
	          <td align="right" >$ <%=FN((intValorCuota),0)%></td>
	          <td align="right" >$ <%=FN((intValorProtesto),0)%></td>
	          <td align="right" >$ <%=FN((intSaldo),0)%></td>
	          <td align="right" >
	          <%If Not rsDET("USUARIO_ASIG")="0" Then %>
			  	<%=TraeCampoId(Conn, "LOGIN", rsDET("USUARIO_ASIG"), "USUARIO", "ID_USUARIO")%>
			  <%else%>
			  	<%="SIN ASIG."%>
			  <%End If%>
			  </td>
			  <td><%=TraeCampoId(Conn, "DESCRIPCION", strEstadoDeuda, "ESTADO_DEUDA", "CODIGO")%></td>
			  <td><div align="right"><%=rsDET("FEC_ESTADO")%></div></td>

			 <%
				''total_vigente= total_vigente + clng(rsDET("VIGENTE"))
				''total_mora = total_mora + clng(rsDET("MORA"))
				total_vencida = total_vencida + clng(rsDET("VENCIDA"))
				total_protesto = total_protesto + clng(rsDET("PROTESTO"))
				total_saldo = total_saldo + clng(intSaldo)
				total_ValorCuota = total_ValorCuota + intValorCuota
				total_gc = total_gc + clng(rsDET("GASTOSCOBRANZAS"))
				total_docs = total_docs + 1



			 %>
			 </tr>
			 <%rsDET.movenext
			 loop
			 %>
			<tr>
				<td bgcolor="#<%=session("COLTABBG")%>">&nbsp</td>
				<td bgcolor="#<%=session("COLTABBG")%>"><span class="Estilo13">Docs : <%=total_docs%></span></td>
				<!--td bgcolor="#<%=session("COLTABBG")%>"><span class="Estilo13"></span></td-->
				<td bgcolor="#<%=session("COLTABBG2")%>"><div align="right"><span class="Estilo28">&nbsp</span></div></td>
				<td bgcolor="#<%=session("COLTABBG2")%>"><div align="right"><span class="Estilo27">&nbsp</span></div></td>
				<td bgcolor="#<%=session("COLTABBG2")%>"><div align="right"><span class="Estilo27">&nbsp</span></div></td>
				<td bgcolor="#<%=session("COLTABBG2")%>"><div align="right"><span class="Estilo27">&nbsp</span></div></td>
				<td bgcolor="#<%=session("COLTABBG2")%>"><div align="right"><span class="Estilo27">&nbsp</span></div></td>
				<td bgcolor="#<%=session("COLTABBG2")%>"><div align="right"><span class="Estilo28">$ <%=FN(total_ValorCuota,0)%></span></div></td>
				<td bgcolor="#<%=session("COLTABBG2")%>"><div align="right"><span class="Estilo28">$ <%=FN(total_protesto,0)%></span></div></td>
				<td bgcolor="#<%=session("COLTABBG2")%>"><div align="right"><span class="Estilo28">$ <%=FN(total_saldo,0)%></span></div></td>
				<td bgcolor="#<%=session("COLTABBG2")%>"><div align="right"><span class="Estilo28"></span></div></td>
				<td bgcolor="#<%=session("COLTABBG2")%>"><div align="right"><span class="Estilo28"></span></div></td>
				<td bgcolor="#<%=session("COLTABBG2")%>"><div align="right"><span class="Estilo28"></span></div></td>
			</tr>

	      </table>
		  <%end if
		  rsDET.close
		  set rsDET=nothing
%>

<script language="JavaScript" type="text/JavaScript">
function envia(){
if(datos.nrodoc.value==''){
		alert('DEBE INGRESAR UN NUMERO DOC');
	}else if(datos.TX_CUENTA.value==''){
		alert('DEBE INGRESAR CUENTA');
	}else if(datos.cobrador.value==''){
		alert('DEBE INGRESAR UN COBRADOR');
	}else if(datos.cliente.value=='0'){
		alert('DEBE SELECCIONAR UN CLIENTE');
	}else if(datos.TX_SALDO.value=='0'){
		alert('DEBE INGRESAR SALDO CAPITAL');
	}else if(datos.inicio.value==''){
		alert('DEBE INGRESAR FECHA VENCIMIENTO');
	}else{
		datos.action='graba_deuda.asp';
		datos.submit();
	}
}

function Refrescar(){
	datos.action='nueva_deuda_gral.asp';
	datos.submit();
}

</script>

