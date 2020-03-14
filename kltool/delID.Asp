<!--#include file="./inc/config.asp"-->
<%
kltool_head("删除会员")
call kltool_quanxian
pg=request("pg")
if pg="" then
%>
<div class="tip">方式1：单个删除</div>
<div class="content">
<form method="post" action="?">
<input name="siteid" type="hidden" value="<%=siteid%>">
<input name="pg" type="hidden" value="yes1">
<input name="lx" type="hidden" value="1">
请输入要删除的ID<br/>
<input name="uid" type="text" size="20" value=""><br/>
<input name="g" type="submit" value="马上删除" onClick="ConfirmDel('是否确定？删除后无法恢复');return false"><br/>
</form>
</div>

<div class="tip">方式2：顺序多个删除</div>
<div class="content">
<form method="post" action="?">
<input name="siteid" type="hidden" value="<%=siteid%>">
<input name="pg" type="hidden" value="yes1">
<input name="lx" type="hidden" value="2">
从ID<br/>
<input name="uid" type="text" size="20" value=""><br/>
删除到ID<br/>
<input name="uid2" type="text" size="20" value=""><br/>
<input name="g" type="submit" value="马上删除" onClick="ConfirmDel('是否确定？删除后无法恢复');return false"><br/>
</form>
</div>

<div class="tip">方式3：乱序多个删除</div>
<div class="content">
<form method="post" action="?">
<input name="siteid" type="hidden" value="<%=siteid%>">
<input name="pg" type="hidden" value="yes1">
<input name="lx" type="hidden" value="3">
要删除的ID，多个用,隔开<br/>
<input name="uid" type="text" size="20" value=""><br/>
<input name="g" type="submit" value="马上删除" onClick="ConfirmDel('是否确定？删除后无法恢复');return false"><br/>
</form>
</div>
<%
elseif pg="yes1" then
lx=cint(request("lx"))
uid=request("uid")
uid2=request("uid2")
if uid="" then call kltool_msge("ID不能为空")
if (lx=1 or lx=2) and clng(uid)=clng(siteid) then call kltool_msge("1.不能操作ID1000")

if lx=1 then
	set rs=conn.execute("select userid from [user] where siteid="&siteid&" and userid="&uid)
	If rs.eof Then call kltool_msge("此ID不存在")
	rs.close
	set rs=nothing
	conn.execute("delete from [user] where siteid="&siteid&" and userid="&uid)
ms="已删除ID："&uid&""
call kltool_write_log("1.删除了ID："&uid)
end if

if lx=2 then
if uid2="" then call kltool_msge("ID不能为空")
if clng(uid2)=clng(siteid) then call kltool_msge("2.不能操作ID1000")
	conn.execute("delete from [user] where siteid="&siteid&" and userid between "&uid&" and "&uid2)
ms="已删除ID："&uid&"-"&uid2&""
call kltool_write_log("2.删除了多个ID："&uid&"-"&uid2)
end if

if lx=3 then
if instr(uid,",")<=0 then uid=uid&","
uid_str=split(uid,",")
for i=0 to ubound(uid_str)
if clng(trim(uid_str(i)))=clng(siteid) then call kltool_msge("多个id中包含ID1000，请修改")
next
	conn.execute("delete from [user] where siteid="&siteid&" and userid in ("&uid&")")
ms="已删除ID："&uid&""
call kltool_write_log("3.删除了多个ID："&uid)
end if
kltool_msg(ms)
end if
Response.write"<div class=""tip"">提醒：</div>"
Response.write"<div class=""line2"">删除后不可恢复,请勿胡乱删除会员，帖子、站内信等不删除</div>"

kltool_end
%>