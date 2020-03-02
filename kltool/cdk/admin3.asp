<!--#include file="../inc/head.asp"-->
<title>柯林工具箱-CDK数据库字段安装删除</title>
<%call kltool_quanxian
pg=request("pg")
if pg="" then
elseif pg="az" then
conn.Execute("CREATE TABLE [dbo].[cdk] (ID int IDENTITY (1,1) not null PRIMARY key)")
conn.Execute("ALTER TABLE [cdk] ADD [cdk] varchar")
conn.Execute("ALTER TABLE [cdk] ALTER COLUMN [cdk] varchar(50)")
conn.Execute("ALTER TABLE [cdk] ADD [jinbi] bigint")
conn.Execute("ALTER TABLE [cdk] ADD [jingyan] bigint")
conn.Execute("ALTER TABLE [cdk] ADD [sf] bigint")
conn.Execute("ALTER TABLE [cdk] ADD [sff] bigint")
conn.Execute("ALTER TABLE [cdk] ADD [lg] bigint")
conn.Execute("ALTER TABLE [cdk] ADD [xg] ntext")
conn.Execute("ALTER TABLE [cdk] ADD [lx] bigint")
conn.Execute("ALTER TABLE [cdk] ADD [sy] bigint")
conn.Execute("ALTER TABLE [cdk] ADD [time] datetime") 
conn.Execute("ALTER TABLE [cdk] ADD [userid] bigint")
conn.Execute("ALTER TABLE [cdk] ADD [zs] bigint")
conn.Execute("ALTER TABLE [cdk] ADD [chushou] bigint")
conn.Execute("ALTER TABLE [cdk] ADD [jiage] bigint")

conn.Execute("CREATE TABLE [dbo].[cdk_set] (ID int IDENTITY (1,1) not null PRIMARY key)")
conn.Execute("ALTER TABLE [cdk_set] ADD [yh] bigint")
conn.Execute("ALTER TABLE [cdk_set] ADD [lx] bigint")
conn.Execute("ALTER TABLE [cdk_set] ADD [sl] bigint")
conn.Execute("ALTER TABLE [cdk_set] ADD [vsl] bigint")

conn.Execute("CREATE TABLE [dbo].[cdk_log] (ID int IDENTITY (1,1) not null PRIMARY key)")
conn.Execute("ALTER TABLE [cdk_log] ADD [userid] bigint")
conn.Execute("ALTER TABLE [cdk_log] ADD [lx] bigint")
conn.Execute("ALTER TABLE [cdk_log] ADD [cdk] varchar(50)")
conn.Execute("ALTER TABLE [cdk_log] ADD [jia] bigint")
conn.Execute("ALTER TABLE [cdk_log] ADD [ltime] datetime")

for i=1 to 7
set rs=Server.CreateObject("ADODB.Recordset")
rs.open"select * from [cdk_set] where lx="&i,conn,1,2
if rs.bof then conn.Execute("INSERT INTO [cdk_set] (lx) VALUES ('"&i&"')")
rs.close
set rs=nothing
next
call kltool_write_log("(cdk系统)安装数据库字段")
response.redirect "admin1.asp?siteid="&siteid&""

elseif pg="del" then
conn.Execute("DROP TABLE [cdk]")
conn.Execute("DROP TABLE [cdk_set]")
conn.Execute("DROP TABLE [cdk_log]")
call kerr("成功删除cdk数据库字段")
call kltool_write_log("(cdk系统)删除数据库字段")
end if
call kltool_end
%>