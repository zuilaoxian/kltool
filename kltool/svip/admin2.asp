<!--#include file="../inc/head.asp"-->
<title>vip每日抽奖-安装</title>
<%call kltool_quanxian
pg=request("pg")
if pg="" then
elseif pg="az" then

conn.Execute("CREATE TABLE [dbo].[vip_lx] (ID int IDENTITY (1,1) not null PRIMARY key)")
conn.Execute("ALTER TABLE [vip_lx] ADD [svip] bigint")
conn.Execute("ALTER TABLE [vip_lx] Add [sci] bigint")

conn.Execute("CREATE TABLE [dbo].[vip_log] (ID int IDENTITY (1,1) not null PRIMARY key)")
conn.Execute("ALTER TABLE [vip_log] ADD [userid] bigint")
conn.Execute("ALTER TABLE [vip_log] ADD [name] ntext")
conn.Execute("ALTER TABLE [vip_log] ADD [content] ntext")
conn.Execute("ALTER TABLE [vip_log] ADD [jp1] bigint")
conn.Execute("ALTER TABLE [vip_log] ADD [jp2] bigint")
conn.Execute("ALTER TABLE [vip_log] ADD [vtime] datetime")

conn.Execute("CREATE TABLE [dbo].[vip_jp] (ID int IDENTITY (1,1) not null PRIMARY key)")
conn.Execute("ALTER TABLE [vip_jp] ADD [lx] bigint")
conn.Execute("ALTER TABLE [vip_jp] ADD [jp1] bigint")
conn.Execute("ALTER TABLE [vip_jp] ADD [jp2] bigint")
conn.Execute("ALTER TABLE [vip_jp] ADD [xy] bigint")

for i=1 to 9
set rs=conn.Execute("select * from [vip_jp] where lx="&i)
if rs.bof then
conn.Execute("INSERT INTO [vip_jp] (lx) VALUES ('"&i&"')")
end if
next
call kltool_write_log("(vip每日抽奖)安装数据库字段")
response.redirect "admin1.asp?siteid="&siteid

'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
elseif pg="del" then
conn.Execute("DROP TABLE [vip_lx]")
conn.Execute("DROP TABLE [vip_log]")
conn.Execute("DROP TABLE [vip_jp]")
call kltool_write_log("(vip每日抽奖)删除数据库字段")
response.redirect "admin1.asp?siteid="&siteid

end if
call kltool_end
%>