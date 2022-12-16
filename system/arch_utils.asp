<%

Set Conn = Server.CreateObject("ADODB.Connection")
Set Conn1 = Server.CreateObject("ADODB.Connection")
Set Conn2 = Server.CreateObject("ADODB.Connection")

Sub AbrirSCG()
	Set Conn = Server.CreateObject("ADODB.Connection")
	Conn.Open "driver=Sql server;Uid=crm;Pwd=Integro.329*;Database=bd_crmintegrocorp;App=Sistema Operativo Microsoft Windows;Server=SQL-ALTERNATIVO"
End Sub

Sub CerrarSCG()
	Conn.close
	set Conn = nothing
End Sub

Sub AbrirSCG1()
	Set Conn1 = Server.CreateObject("ADODB.Connection")
	Conn1.Open "driver=Sql server;Uid=crm;Pwd=Integro.329*;Database=bd_crmintegrocorp;App=Sistema Operativo Microsoft Windows;Server=SQL-ALTERNATIVO"
End Sub

Sub CerrarSCG1()
	Conn1.close
	set Conn1 = nothing
End Sub

Sub AbrirSCG2()
	Set Conn2 = Server.CreateObject("ADODB.Connection")
	Conn2.Open "driver=Sql server;Uid=crm;Pwd=Integro.329*;Database=bd_crmintegrocorp;App=Sistema Operativo Microsoft Windows;Server=SQL-ALTERNATIVO"
End SuB

Sub CerrarSCG2()
	Conn2.close
	set Conn2 = nothing
End Sub


%>