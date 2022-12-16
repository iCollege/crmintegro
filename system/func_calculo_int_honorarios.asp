<% @LCID = 1034 %>
<!--#include file="arch_utils.asp"-->
<!--#include file="../lib/comunes/rutinas/funciones.inc" -->
<!--#include file="../lib/comunes/rutinas/TraeCampo.inc" -->
<!--#include file="lib.asp"-->

<%
rut = request.QueryString("rut")
cliente=request.QueryString("cliente")

%>
	If Trim(rut) <> "" then
	abrirscg()
	ssql="SELECT IDCUOTA,RUTDEUDOR, IsNull(FECHAVENC,'01/01/1900') as FECHAVENC, IsNull(datediff(d,fechavenc,getdate()),0) as ANTIGUEDAD, NRODOC,IsNull(VIGENTE,0) as VIGENTE, IsNull(VALORCUOTA,0) as VALORCUOTA,IsNull(SALDO,0) as SALDO,isnull(GASTOSCOBRANZAS,0) as GASTOSCOBRANZAS,IsNull(USUARIO_ASIG,0) as USUARIO_ASIG,NROCUOTA, VIGENTE, IsNull(MORA,0) as MORA, IsNull(VENCIDA,0) as VENCIDA, IsNull(CASTIGO,0) as CASTIGO, CENTRO_COSTO, SUCURSAL , ESTADO_DEUDA, CODREMESA, CUENTA, NRODOC, TIPODOCUMENTO, CONVERT(VARCHAR(10),FECHA_ESTADO,103) AS FEC_ESTADO, ADIC1 FROM CUOTA WHERE RUTDEUDOR='"&rut&"' AND CODCLIENTE='"&cliente&"' ORDER BY CODREMESA,FECHAVENC DESC"
		set rsDET=Conn.execute(ssql)
		if not rsDET.eof then
			intSaldo = 0
			intValorCuota = 0
			total_ValorCuota = 0
			do until rsDET.eof
			intSaldo = ValNulo(rsDET("SALDO"),"N")
			intValorCuota = ValNulo(rsDET("VALORCUOTA"),"N")
			strNroDoc = Trim(rsDET("NRODOC"))
			strNroCuota = Trim(rsDET("NROCUOTA"))
			strSucursal = Trim(rsDET("SUCURSAL"))
			strEstadoDeuda = Trim(rsDET("ESTADO_DEUDA"))
			strCodRemesa = Trim(rsDET("CODREMESA"))
			strAdic1 = Trim(rsDET("ADIC1"))
			intTasaMensual = 2/100
			intTasaDiaria = intTasaMensual/30
			intAntiguedad = ValNulo(rsDET("ANTIGUEDAD"),"N")
			intIntereses = intTasaDiaria * intAntiguedad * intSaldo

			If intSaldo <= 10 * session("valor_uf")  Then
				intIntHon = 9/100
			ElseIf intSaldo > 10 * session("valor_uf") and  intSaldo <= 50 * session("valor_uf") Then
				intIntHon = 6/100
			ElseIf intSaldo > 50 * session("valor_uf") Then
				intIntHon = 3/100
			End if

			intHonorarios = intIntHon * intSaldo

			
				total_saldo = total_saldo + clng(intSaldo)
				total_interes = total_interes + clng(intIntereses)
				total_honorarios = total_honorarios + clng(intHonorarios)
				total_ValorCuota = total_ValorCuota + intValorCuota
				total_docs = total_docs + 1



				rsDET.movenext
			 loop
			end if
		  rsDET.close
		  set rsDET=nothing

		end if
cerrarSCG()
%>

