<!--#include file="./inc/head.asp"-->
<title>柯林工具箱-自定义表修改起始ID</title>
<%call kltool_quanxian
pg=request("pg")
if pg="" then
%>
<div class="content">
<form method="post" action="?">
<input name="siteid" type="hidden" value="<%=siteid%>">
<input name="pg" type="hidden" value="yes">
已支持的表名<br/>
<select name="sname1">
<option value="user">user-userid-用户表</option>
<option value="class">class-classid-栏目表</option>
</select><br/>
自定义:(优先,填写以后上面的选择无效)<br/>
<input name="sname2" type="text" size="10" value=""><br/>
起始ID(如:10000，那么新的将从10001开始)<br/>
<input name="startID" type="text" value="" ><br/>
<input name="g" type="submit" value="马上修改" onClick="ConfirmDel('是否确定？');return false">
</form>
</div>
<%
elseif pg="yes" then
sname1=request("sname1")
sname2=request("sname2")
startID=request("startID")
if sname2<>"" then sname=sname2 else sname=sname1
if sname="" or startID="" then call kltool_err_msg("表名和起始ID不能为空")
if not Isnumeric(startID) then call kltool_err_msg("起始ID必须为数字")
conn.execute(" dbcc checkident('"&sname&"',reseed,"&startID&")")
call kltool_write_log("(起始ID修改)表"&sname&"："&startID)
Response.write"修改起始id成功<br/>"&sname&"表起始ID修改为:"&startID
end if
call kltool_end
%>