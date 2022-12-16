<%

Function TraeCantGestiones (strConex, dtmInicio, dtmFin, intCat, intSubCat, intGestion, intCliente)
	strSql = "select count(*) as cant from gestiones where codcliente = '" & intCliente & "' and fechaingreso >= '" & dtmInicio & "' and fechaingreso <= '" & dtmFin & "' and codcategoria = " & intCat & " and codsubcategoria = " & intSubCat & " and codgestion = " & intGestion
	
	set rsTmp = strConex.execute(strSql)
	if not rsTmp.eof then
		TraeCantGestiones = rsTmp("cant")
	else
		TraeCantGestiones = 0
	End if
	rsTmp.close
	set rsTmp=nothing
End Function

Function TraeCantGestionesUG2 (strConex, dtmInicio, dtmFin, intCat, intSubCat, intGestion, intCliente)
	strSql = "SELECT COUNT(*) AS CANT FROM DEUDOR WHERE CODCLIENTE = '" & intCliente & "' AND ULTIMA_GESTION = '" & intCat & "-" & intSubCat & "-" & intGestion & "'"
	
	set rsTmp = strConex.execute(strSql)
	if not rsTmp.eof then
		TraeCantGestionesUG2 = rsTmp("cant")
	else
		TraeCantGestionesUG2 = 0
	End if
	rsTmp.close
	set rsTmp=nothing
End Function


Function TraeSaldoGestiones (strConex, dtmInicio, dtmFin, intCat, intSubCat, intGestion, intCliente)
	strSql = "select IsNull(sum(saldo),0) as saldo from cuota where codcliente = '" & Trim(intCliente) & "' and saldo > 0 and estado_deuda = '1' "
	strSql = strSql & " and rutdeudor in (select distinct rutdeudor from gestiones where codcliente = '" & Trim(intCliente) 
	strSql = strSql & "' and fechaingreso >= '" & Trim(dtmInicio) & "' and fechaingreso <= '" & Trim(dtmFin) 
	strSql = strSql & "' and codcategoria = " & Trim(intCat) 
	strSql = strSql & " and codsubcategoria = " & Trim(intSubCat) 
	strSql = strSql & " and codgestion = " & Trim(intGestion) & ")"
	
	'Response.write "strSql=" & strSql
	
	set rsTmp = strConex.execute(strSql)
	if not rsTmp.eof then
		TraeSaldoGestiones = rsTmp("saldo")
	else
		TraeSaldoGestiones = 0
	End if
	rsTmp.close
	set rsTmp=nothing
End Function

Function TraeCantGestionesUsuario (strConex, dtmInicio, dtmFin, intCat, intSubCat, intGestion, intCliente, intUsuario)
	strSql = "select count(*) as cant from gestiones where codcliente = '" & Trim(intCliente) & "' and fechaingreso >= '" & dtmInicio & "' and fechaingreso <= '" & dtmFin & "' and codcategoria = " & intCat & " and codsubcategoria = " & intSubCat & " and codgestion = " & intGestion & " and idusuario = " & intUsuario
	set rsTmp = strConex.execute(strSql)
	if not rsTmp.eof then
		TraeCantGestionesUsuario = rsTmp("cant")
	else
		TraeCantGestionesUsuario = 0
	End if
	rsTmp.close
	set rsTmp=nothing
End Function

Function TraeSaldoGestionesUsuario (strConex, dtmInicio, dtmFin, intCat, intSubCat, intGestion, intCliente, intUsuario)
	strSql = "select IsNull(sum(saldo),0) as saldo from cuota where codcliente = '" & intCliente & "' and saldo > 0 and estado_deuda = '1' and rutdeudor in (select distinct rutdeudor from gestiones where codcliente = '" & intCliente & "' and fechaingreso >= '" & dtmInicio & "' and fechaingreso <= '" & dtmFin & "' and codcategoria = " & intCat & " and codsubcategoria = " & intSubCat & " and codgestion = " & intGestion & " and idusuario = " & intUsuario & ")"
	set rsTmp = strConex.execute(strSql)
	if not rsTmp.eof then
		TraeSaldoGestionesUsuario = rsTmp("saldo")
	else
		TraeSaldoGestionesUsuario = 0
	End if
	rsTmp.close
	set rsTmp=nothing
End Function

Function TraeSaldoGestionesUsuarioCampana (strConex, intCat, intSubCat, intGestion, intCliente, intUsuario, intCampana, dtmInicio, dtmFin)
	strSql = "SELECT ISNULL(SUM(SALDO),0) AS SALDO FROM CUOTA WHERE CODCLIENTE = '" & intCliente & "' AND SALDO > 0 AND ESTADO_DEUDA IN ('1','6') AND RUTDEUDOR IN (SELECT DISTINCT RUTDEUDOR FROM GESTIONES WHERE CODCLIENTE = '" & intCliente & "' AND IDCAMPANA = " & intCampana & " AND CODCATEGORIA = " & intCat & " AND CODSUBCATEGORIA = " & intSubCat & " AND CODGESTION = " & intGestion & " AND IDUSUARIO = " & intUsuario & " AND FECHAINGRESO >= '" & dtmInicio & "' AND FECHAINGRESO <= '" & dtmFin & "')"
	set rsTmp = strConex.execute(strSql)
	if not rsTmp.eof then
		TraeSaldoGestionesUsuarioCampana = rsTmp("saldo")
	else
		TraeSaldoGestionesUsuarioCampana = 0
	End if
	rsTmp.close
	set rsTmp=nothing
End Function


Function TraeCantGestionesJud (strConex, dtmInicio, dtmFin, intCat, intSubCat, intGestion, intCliente)
	strSql = "select count(*) as cant from gestiones_nuevas_judicial where codcliente = '" & intCliente & "' and fechaingreso >= '" & dtmInicio & " 00:00:00' and fechaingreso <= '" & dtmFin & " 23:59:59' and codcategoria = " & intCat & " and codsubcategoria = " & intSubCat & " and codgestion = " & intGestion
	
	set rsTmp = strConex.execute(strSql)
	if not rsTmp.eof then
		TraeCantGestionesJud = rsTmp("cant")
	else
		TraeCantGestionesJud = 0
	End if
	rsTmp.close
	set rsTmp=nothing
End Function

Function TraeCantGestionesCampana(strConex, intCampana, intCat, intSubCat, intGestion, intCliente, dtmFecIni, dtmFecFin)
	strSql = "select count(*) as cant from gestiones where codcliente = '" & intCliente & "' and idcampana = " & intCampana & " and codcategoria = " & intCat & " and codsubcategoria = " & intSubCat & " and codgestion = " & intGestion & " AND FECHAINGRESO >= '" & dtmFecIni & " 00:00:00' AND FECHAINGRESO <= '" & dtmFecFin & " 23:59:59'"
	'Response.write "<BR>"&strSql
	set rsTmp = strConex.execute(strSql)
	if not rsTmp.eof then
		TraeCantGestionesCampana = rsTmp("cant")
	else
		TraeCantGestionesCampana = 0
	End if
	rsTmp.close
	set rsTmp=nothing
End Function

Function TraeCantGestionesUG(strConex, strGestion, intCliente, intCampana)
	strSql = "SELECT COUNT(*) AS CANT FROM DEUDOR WHERE CODCLIENTE = '" & intCliente & "' AND ULTIMA_GESTION = '" & strGestion & "'"
	If Trim(intCampana) <> "0" Then
		strSql = strSql & " AND IDCAMPANA = " & intCampana
	End if
	'If Trim(intUsuario) <> "" Then
	'	strSql = strSql & " AND COD_EJECUTIVO = " & SESSION("session_cod_ejecutivo") 
	'End if
	strSql = strSql & " and rutdeudor in (select rutdeudor from gestiones where codcliente = '" & intCliente & "' and idcampana = " & intCampana & " and codcategoria + '-' +  codsubcategoria + '-' + codgestion = " & intGestion & ")"
	'Response.write "<BR>"&strSql
	'Response.eND
	
	
	set rsTmp = strConex.execute(strSql)
	if not rsTmp.eof then
		TraeCantGestionesUG = rsTmp("cant")
	else
		TraeCantGestionesUG = 0
	End if
	rsTmp.close
	set rsTmp=nothing
End Function

Function TraeCantGestionesCampanaUG(strConex, strGestion, intCliente, intCampana, dtmInicio, dtmFin)
	strSql = "SELECT COUNT(*) AS CANT FROM DEUDOR WHERE CODCLIENTE = '" & intCliente & "' AND ULTIMA_GESTION = '" & strGestion & "'"
	If Trim(intCampana) <> "0" Then
		strSql = strSql & " AND IDCAMPANA = " & intCampana
	End if
	'If Trim(intUsuario) <> "" Then
	'	strSql = strSql & " AND COD_EJECUTIVO = " & SESSION("session_cod_ejecutivo") 
	'End if
	strSql = strSql & " AND RUTDEUDOR IN (SELECT RUTDEUDOR FROM GESTIONES WHERE CODCLIENTE = '" & intCliente & "' AND IDCAMPANA = " & intCampana & " AND cast(CODCATEGORIA as varchar(2)) + '-' + cast(CODSUBCATEGORIA  as varchar(2))+ '-' + cast(CODGESTION  as varchar(2)) = '" & strGestion & "' and fechaingreso >= '" & dtmInicio & " 00:00:00' and fechaingreso <= '" & dtmFin & " 23:59:59')"
	'Response.write "<BR>"&strSql
	'Response.eND
	
	
	set rsTmp = strConex.execute(strSql)
	if not rsTmp.eof then
		TraeCantGestionesCampanaUG = rsTmp("cant")
	else
		TraeCantGestionesCampanaUG = 0
	End if
	'Response.write "--TraeCantGestionesCampanaUG="&TraeCantGestionesCampanaUG
	rsTmp.close
	set rsTmp=nothing
End Function


%>