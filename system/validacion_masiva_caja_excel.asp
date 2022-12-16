<% @LCID = 1034 %>
<!--#include file="../../comunes/bdatos/ConectarSCG.inc"-->
<!--#include file="../../comunes/rutinas/funciones.inc" -->
<!--#include file="../../comunes/rutinas/rutinasSCG.inc" -->
<!--#include file="../../comunes/bdatos/ConectarINTRACPS.inc"-->
<%

	Response.Buffer = TRUE
	Response.ContentType = "application/csv"
	Response.AddHeader "Content-Disposition", "filename=caja_web.csv;"
	'cod_caja=71
	cod_caja=Session("intCodUsuario")
	strsql="select * from usuario where cod_usuario = " & cod_caja & ""
	set rsUsu=Conn.execute(strsql)
	if not rsUsu.eof then
		perfil=rsUsu("per_cajaweb")
		if perfil = "caja_modif" or perfil = "caja_listado" then
			sucursal = request("sucursal")
		else
			sucursal = rsUsu("sucursal")
		end if
	end if
	if sucursal="" then sucursal="0"
	termino = request("termino")
	inicio = request("inicio")
	cliente = request("CLIENTE")

top ="COD. PAGO;FECHA PAGO;SUCURSAL;CLIENTE;RUT DEUDOR;COMP. INGRESO;NRO. BOLETA;TIPO PAGO;Q DOC;DESTINO;MONTO;FOR. PAGO;NRO. DEPOSITO;BANCO;DESC. CLIENTE;COSTAS INTER.;CONVENIOS;DEP. CLIENTE;DEP. INTER.;CHEQUES;COMP. INGRESO;BOLETA;FECHA DEP;RENDICION;OBSERVACIONES;EST. PAGO"
response.write top
Response.write vbNewLine
SQL = "select cwc.id_pago,cwc.rendido, CONVERT(varchar(10), cwc.fecha_pago, 103)AS fecha_pago, s.des_suc, cc.desc_cliente as nombre, cwc.rutdeudor, cwc.comp_ingreso, cwc.nro_boleta, cwc.monto_capital, cwc.monto_cps, ctp.desc_tipo_pago, cwc.nro_deposito_cliente, cwc.nro_deposito_cps, cwc.bco_deposito_cliente, cwc.bco_deposito_cps, cwc.usringreso, cwc.desc_cliente, cwc.desc_cps, cwc.total_cliente, cwc.total_cps, cwc.interes_plazo, cwc.costas_cps, cwc.estado_caja from caja_web_cps cwc,caja_cliente cc,caja_tipo_pago ctp,sucursal s where cc.id_cliente =cwc.cod_cliente and ctp.id_tipo_pago = cwc.tipo_pago and s.cod_suc = cwc.sucursal "
IF SUCURSAL <> "0" THEN
SQL = SQL & "and sucursal='" & sucursal & "'"
end if

if cliente <> "0" then
	SQL = SQL & "and  cwc.cod_cliente='" & cliente & "'"
end if
SQL = SQL & "and rendido between '" & inicio & "' and '" & termino & "' order by rendido"

		if sql <> "" then
		'RESPONSE.WRITE SQL
		'RESPONSE.END
		set rsDet=ConexionSCG.execute(SQL)

		if not rsDet.eof then
		i=1
		x=0
		COD_ANT = 0
			do while not rsDet.eof
				cod_pago=rsDet("id_pago")
				ssql="select * from usuario where cod_usuario = " & rsDet("usringreso") & ""
				set rsUsuIng=Conn.execute(ssql)
				if not rsUsuIng.eof then
					usringreso= rsUsuIng("login")
				end if


				if rsDet("nro_deposito_cliente")="NULL" then
					ndc=""
				else
					ndc=rsDet("nro_deposito_cliente")
				end if

				if rsDet("nro_deposito_cps")="NULL" then
					ndcps=""
				else
					ndcps=rsDet("nro_deposito_cps")
				end if
				if rsDet("nro_boleta")= "0" then
					boleta = ""
				else
					boleta = rsDet("nro_boleta")
				end if
				if color="#99FFCC" then
						color="#BBFFDD"
					else
						color="#99FFCC"
					end if
				strSql = "select count(*) as q,max(correlativo) as correlativo,id_pago,sum(monto) as monto,tipo_pago,forma_pago from caja_web_cps_doc_pago where id_pago = " & cod_pago & " group by id_pago,tipo_pago,forma_pago order by id_pago,tipo_pago"
				set rsDoc = ConexionSCG.execute(strSql)
				if not rsDoc.eof then
				do while not rsDoc.eof

				strsql = "select * from t_bancos where ba_codigo='" & rsDet("bco_deposito_cliente") & "'"
				set rsbc=ConexionSCG.execute(strsql)
				if not rsbc.eof then
					bc=rsbc("ba_descripcion")
				else
					bc=""
				end if


				stsql = "select * from t_bancos where ba_codigo='" & rsDet("bco_deposito_cps") & "'"
				set rsbcps=ConexionSCG.execute(stsql)
				if not rsbcps.eof then
					bcps=rsbcps("ba_descripcion")
				else
					bcps=""
				end if

				if cint(rsDoc("tipo_pago")) = 1 then
					if bcps = "" then
						nd = ndcps
						banc = ""
					else
						banc = rsbcps("ba_descripcion")
						nd = ndcps
					end if
					destino = "G"
				else
					banc = bc
					nd = ndc
					destino = "C"
				end if
				IF cint(COD_ANT) = cint(cod_pago) THEN X = X + 1
				IF cint(COD_ANT) <> cint(cod_pago) THEN X = 0
				sq="select fecha_deposito,replace(nro_rendicion,0,'') as nro_rendicion,replace(deposito_cliente,0,'') as deposito_cliente,replace(deposito_cps,0,'') as deposito_cps,replace(cheques,0,'') as cheques,replace(comp_ingreso,0,'') as comp_ingreso,replace(boleta,0,'') as boleta,replace(convenio,0,'') as convenio,replace(observaciones,0,'') as observaciones from CAJA_WEB_VALIDACION where id_pago=" & cod_pago & " and correlativo = " & X & ""

				set rsCWV=ConexionSCG.execute(sq)
				if not rsCWV.eof then
					strconvenio = rsCWV("convenio")
					strdep_cli = rsCWV("deposito_cliente")
					strdep_cps = rsCWV("deposito_cps")
					strcheques = rsCWV("cheques")
					strcom_ing = rsCWV("comp_ingreso")
					strboleta = rsCWV("boleta")
					fecha_dep = rsCWV("fecha_deposito")
					strRendicion = rsCWV("nro_rendicion")
				else
					strconvenio = ""
					strdep_cli = ""
					strdep_cps = ""
					strcheques = ""
					strcom_ing = ""
					strboleta = ""
					fecha_dep = ""
					strRendicion = ""
				end if

				if rsDoc("tipo_pago") = "1" then formap = rsDoc("forma_pago")
					if rsDoc("forma_pago") = "CF" or rsDoc("forma_pago") = "CD" then
						q = rsDoc("q")
					else
						q = 0
					end if
			if rsDet("estado_caja")="N" then estado="NULO"
			if rsDet("estado_caja")="CN" then estado="COMPROBANTE NULO"
			if rsDet("estado_caja")="BN" then estado="BOLETA NULA"
			if rsDet("estado_caja")="A" then estado=""
			IF CINT(COD_ANT) = CINT(cod_pago) THEN
				cuerpo = " ;"&rsDet("fecha_pago")&";"&rsDet("des_suc")&";"&rsDet("nombre")&";"&rsDet("rutdeudor")&";"&rsDet("comp_ingreso")&";"&boleta&";"&rsDet("desc_tipo_pago")&";"&q&";"&DESTINO&";"&rsDoc("monto")&";"&rsDoc("forma_pago")&";"&nd&";"&banc&";"&rsDet("desc_cliente")&";"&rsDet("costas_cps")&";"&strconvenio&";"&strdep_cli&";"&strdep_cps&";"&strcheques&";"&strcom_ing&";"&strboleta&";"&fecha_dep&";"&strRendicion&";"&observaciones&";"&estado
			ELSE
				cuerpo = rsDet("id_pago")&";"&rsDet("fecha_pago")&";"&rsDet("des_suc")&";"&rsDet("nombre")&";"&rsDet("rutdeudor")&";"&rsDet("comp_ingreso")&";"&boleta&";"&rsDet("desc_tipo_pago")&";"&q&";"&DESTINO&";"&rsDoc("monto")&";"&rsDoc("forma_pago")&";"&nd&";"&banc&";"&rsDet("desc_cliente")&";"&rsDet("costas_cps")&";"&strconvenio&";"&strdep_cli&";"&strdep_cps&";"&strcheques&";"&strcom_ing&";"&strboleta&";"&fecha_dep&";"&strRendicion&";"&observaciones&";"&estado

			END IF
			response.write cuerpo
			Response.write vbNewLine
			bc=""
			bcps=""
			i = i + 1
			COD_ANT = cod_pago
			rsDoc.movenext

			loop
			end if

			rsDet.movenext
			loop
		end if
	end if
%>
