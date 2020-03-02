<!--#include file="../inc/head.asp"-->
<title>网站币互转-安装</title>
<%call kltool_quanxian
pg=request("pg")
if pg="" then
elseif pg="az" then

conn.Execute("CREATE TABLE [dbo].[money_set] (ID int IDENTITY (1,1) not null PRIMARY key)")
conn.Execute("ALTER TABLE [money_set] ADD [vip] bigint")
conn.Execute("ALTER TABLE [money_set] ADD [jin1] money")
conn.Execute("ALTER TABLE [money_set] ADD [jin2] money")


conn.Execute("CREATE TABLE [dbo].[money_log] (ID int IDENTITY (1,1) not null PRIMARY key)")
conn.Execute("ALTER TABLE [money_log] ADD [userid] bigint")
conn.Execute("ALTER TABLE [money_log] ADD [lx] bigint")
conn.Execute("ALTER TABLE [money_log] ADD [jin1] money")
conn.Execute("ALTER TABLE [money_log] ADD [jin2] money")
conn.Execute("ALTER TABLE [money_log] ADD [mtime] datetime")

set rs=server.CreateObject("adodb.recordset")
rs.open "select * from [money_set]",conn,1,1
if rs.recordcount<=0 then conn.Execute("INSERT INTO [money_set] (vip) VALUES ('')")
rs.close
set rs=nothing

call kltool_write_log("(网站币互转)安装数据库字段")
response.redirect "admin1.asp?siteid="&siteid

'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
elseif pg="del" then
conn.Execute("DROP TABLE [money_set]")
conn.Execute("DROP TABLE [money_log]")

call kltool_write_log("(网站币互转)删除数据库字段")
response.redirect "admin1.asp?siteid="&siteid

end if
call kltool_end
%>