<!--#include file="./inc/head.asp"-->
<title>柯林工具箱-sql语句执行</title>
<%call kltool_quanxian
pg=request("pg")
if pg="" then
%>
<div class="line2">请填写信息</div>
<div class="content">
<form method="post" action="?">
<input name="siteid" type="hidden" value="<%=siteid%>">
<input name="pg" type="hidden" value="yes1">
<textarea name="sql" rows="8" type="text" placeholder="输入sql语句"></textarea><br/>
<input name="g" type="submit" value="马上执行" onClick="ConfirmDel('是否确定？');return false">
</form>
</div>
<%
elseif pg="yes1" then
sql=request("sql")
if sql="" then call kltool_err_msg("不能为空")
conn.execute(""&sql&"")
closeconn()
call kltool_write_log("(sql执行)"&sql)
response.redirect"?siteid="&siteid&"&pg=yes2"
elseif pg="yes2" then
%>
<div class="title">执行sql成功</div>
<%end if%>
<div class="tip">基础语句示例</div>
<div class="line2">插入语句: insert into 表名(字段1,字段2)values('内容1','内容2')</div>
<div class="line1">更新语句: update 表名 set 字段1='内容1',字段2='内容2' where 字段3='内容3'</div>
<div class="line2">删除语句: delete from 表名 where 字段='内容'</div>
<div class="tip">本插件无法显示查询内容，不可做查询操作，柯林api文件会阻截，安全狗也会拦截，如果会使用的站长请提前设置好</div>

<%
call kltool_end
%>