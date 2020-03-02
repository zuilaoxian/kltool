<!--#include file="../inc/head.asp"-->
<title>用户名更改插件-安装</title>
<%call kltool_quanxian
pg=request("pg")
if pg="" then
elseif pg="az" then

conn.Execute("CREATE TABLE [dbo].[uname] (ID int IDENTITY (1,1) not null PRIMARY key)")
conn.Execute("ALTER TABLE [uname] ADD [siteid] bigint")
conn.Execute("ALTER TABLE [uname] Add [userid] bigint")
conn.Execute("ALTER TABLE [uname] Add [oname] varchar(50)")
'旧用户名
conn.Execute("ALTER TABLE [uname] Add [nname] varchar(50)")
'新用户名
conn.Execute("ALTER TABLE [uname] ADD [shou] bigint")
'是否出售/收费 1否 2是
conn.Execute("ALTER TABLE [uname] ADD [jinbi] bigint")
conn.Execute("ALTER TABLE [uname] ADD [jingyan] bigint")

conn.Execute("ALTER TABLE [uname] ADD [time1] datetime")
conn.Execute("ALTER TABLE [uname] ADD [time2] datetime")

conn.Execute("ALTER TABLE [uname] ADD [content1] ntext")
'申请说明
conn.Execute("ALTER TABLE [uname] ADD [content2] ntext")
'审核说明
conn.Execute("ALTER TABLE [uname] ADD [type1] bigint")
'用户状态 0待审核 1不同意 2同意
conn.Execute("ALTER TABLE [uname] ADD [type2] bigint")
'用户状态 0未知状态 1未更改 2已更改 3已放弃 4过期

call kltool_write_log("(用户名更改)安装数据库字段")
response.redirect "admin1.asp?siteid="&siteid

'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
elseif pg="del" then
conn.Execute("DROP TABLE [uname]")
call kltool_write_log("(用户名更改)删除数据库字段")
response.redirect "admin1.asp?siteid="&siteid

end if
call kltool_end
%>