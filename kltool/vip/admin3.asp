<!--#include file="../inc/config.asp"-->
<title>Vip自助开通-安装</title>
<%
kltool_head("vip每日抽奖")
kltool_quanxian
pg=request("pg")
if pg="" then
elseif pg="az" then
	conn.Execute("ALTER TABLE [wap2_smallType] ADD [jinbi] bigint")
	conn.Execute("ALTER TABLE [wap2_smallType] ADD [jinyan] bigint")
	conn.Execute("ALTER TABLE [wap2_smallType] ADD [xian] bigint")
	conn.Execute("CREATE TABLE [dbo].[wap2_smallType_log] (ID int IDENTITY (1,1) not null PRIMARY key)")
	conn.Execute("ALTER TABLE [wap2_smallType_log] ADD [userid] bigint")
	conn.Execute("ALTER TABLE [wap2_smallType_log] ADD [lx] bigint")
	conn.Execute("ALTER TABLE [wap2_smallType_log] ADD [vip] bigint")
	conn.Execute("ALTER TABLE [wap2_smallType_log] ADD [yue] bigint")
	conn.Execute("ALTER TABLE [wap2_smallType_log] ADD [jin] bigint")
	conn.Execute("ALTER TABLE [wap2_smallType_log] ADD [yan] bigint")
	conn.Execute("ALTER TABLE [wap2_smallType_log] ADD [vtime] datetime")
	call kltool_write_log("(vip开通)安装数据库字段")
elseif pg="del" then
	conn.Execute("ALTER TABLE [wap2_smallType] drop column [jinbi]")
	conn.Execute("ALTER TABLE [wap2_smallType] drop column [jinyan]")
	conn.Execute("ALTER TABLE [wap2_smallType] drop column [xian]")
	conn.Execute("DROP TABLE [wap2_smallType_log]")
	response.redirect "admin1.asp?siteid="&siteid
	call kltool_write_log("(vip开通)删除数据库字段") 
end if
response.redirect "admin1.asp?siteid="&siteid&""
kltool_end
%>