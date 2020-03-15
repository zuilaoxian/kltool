<!--#include file="../inc/config.asp"-->
<%
kltool_head("互动红包-安装")
kltool_quanxian
pg=request("pg")
if pg="" then
elseif pg="az" then
	conn.Execute("CREATE TABLE [dbo].[kltool_hb] (ID int IDENTITY (1,1) not null PRIMARY key)")
	conn.Execute("ALTER TABLE [kltool_hb] ADD [hb_userid] bigint")
	conn.Execute("ALTER TABLE [kltool_hb] ADD [hb_ly] varchar(50)")
	conn.Execute("ALTER TABLE [kltool_hb] ADD [hb_lx] bigint")
	conn.Execute("ALTER TABLE [kltool_hb] ADD [hb_sl] bigint")
	conn.Execute("ALTER TABLE [kltool_hb] ADD [hb_money] bigint")
	conn.Execute("ALTER TABLE [kltool_hb] ADD [hb_ay] ntext")
	conn.Execute("ALTER TABLE [kltool_hb] ADD [hb_open] bigint")
	conn.Execute("ALTER TABLE [kltool_hb] ADD [hb_date] datetime")

	conn.Execute("CREATE TABLE [dbo].[kltool_hb_set] (ID int IDENTITY (1,1) not null PRIMARY key)")
	conn.Execute("ALTER TABLE [kltool_hb_set] ADD [hb_lx] bigint")
	conn.Execute("ALTER TABLE [kltool_hb_set] ADD [hb_open] bigint")

	for i=1 to 4
	set rs=Server.CreateObject("ADODB.Recordset")
	rs.open"select * from [kltool_hb_set] where hb_lx="&i,conn,1,2
	if rs.bof then conn.Execute("INSERT INTO [kltool_hb_set] (hb_lx,hb_open) VALUES ('"&i&"','1')")
	rs.close
	set rs=nothing
	next
	conn.Execute("update [kltool_hb_set] set hb_lx=100,hb_open=500 where id=4")

	conn.Execute("CREATE TABLE [dbo].[kltool_hb_log] (ID int IDENTITY (1,1) not null PRIMARY key)")
	conn.Execute("ALTER TABLE [kltool_hb_log] ADD [hb_userid] bigint")
	conn.Execute("ALTER TABLE [kltool_hb_log] ADD [hb_lx] bigint")
	conn.Execute("ALTER TABLE [kltool_hb_log] ADD [hb_ly] varchar(50)")
	conn.Execute("ALTER TABLE [kltool_hb_log] ADD [hb_money] bigint")
	conn.Execute("ALTER TABLE [kltool_hb_log] ADD [hb_date] datetime")
	call kltool_write_log("(互动红包插件)安装数据库字段")
	

	'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
elseif pg="del" then
	conn.Execute("DROP TABLE [kltool_hb]")
	conn.Execute("DROP TABLE [kltool_hb_set]")
	conn.Execute("DROP TABLE [kltool_hb_log]")
	call kltool_write_log("(互动红包插件)删除数据库字段")
end if
response.redirect "admin1.asp?siteid="&siteid
kltool_end
%>