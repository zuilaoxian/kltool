<!--#include file="inc/config.asp"-->
<%
kltool_quanxian
kltool_head("柯林工具箱-会员转移")
pg=request("pg")
if pg="" then
%>
<div class="tip">功能说明&注意事项</div>
<div class="line1">源ID的帖子/内信/回帖转移到目标ID，资料方面有/权限/密码/昵称/金币/头像/勋章/身份/空间人气等等</div>
<div class="line2"><b>因用户名不能重复，所以默认转移后的用户名为：用户名02，需要手动更改</b><br/>转移后源ID仍然存在，但失去帖子/内信/回帖</div>
<div class="line1">请填写信息</div>
<div class="line2">
<form method="post" action="?">
<input name="siteid" type="hidden" value="<%=siteid%>">
<input name="pg" type="hidden" value="yes1">
请输入源ID<br/>
<input name="uid1" type="text" size="20" value=""><br/>
请输入目标ID<br/>
<input name="uid2" type="text" size="20" value=""><br/>
<input type="submit" value="马上转移" onClick="ConfirmDel('是否确定？');return false">
</form>
</div>

<%
elseif pg="yes1" then
uid1=request("uid1")
uid2=request("uid2")

if uid1="" or uid2="" then call kltool_msge("ID不能为空")
if not Isnumeric(uid1) or not Isnumeric(uid2) or uid1=uid2 then call kltool_msge("ID必须为数字，且不能相同")
if int(uid1)=siteid or uid2=siteid then call kltool_msge("ID不能为1000")

set rs=conn.execute("select userid from [user] where siteid="&siteid&" and userid="&uid1)
If rs.eof Then call kltool_msge("源ID不存在")
rs.close
set rs=nothing

set rs=conn.execute("select userid from [user] where siteid="&siteid&" and userid="&uid2)
If rs.eof Then
	set rs1=server.CreateObject("adodb.recordset")
	rs1.open "select * from [user] where siteid="&siteid&" and userid="&uid1,conn,1,1
	conn.execute("SET IDENTITY_INSERT [USER] ON INSERT INTO [user] (userid,siteid,username,nickname,password,managerlvl,remark,sex,money,moneyname,RegTime,LoginTimes,headimg,SessionTimeout,myBankMoney,expR,endTime,RMB,ZoneCount,TJCount)VALUES('"&uid2&"','"&rs1("siteid")&"','"&rs1("username")&"02','"&rs1("nickname")&"','"&rs1("password")&"','"&rs1("managerlvl")&"','"&rs1("remark")&"','"&rs1("sex")&"','"&rs1("money")&"','"&rs1("moneyname")&"','"&rs1("RegTime")&"','"&rs1("LoginTimes")&"','"&rs1("headimg")&"','"&rs1("SessionTimeout")&"','"&rs1("myBankMoney")&"','"&rs1("expR")&"','"&rs1("endTime")&"','"&rs1("RMB")&"','"&rs1("ZoneCount")&"','"&rs1("TJCount")&"') SET IDENTITY_INSERT [USER] OFF")
	rs1.close
	set rs1=nothing
else
	set rs1=server.CreateObject("adodb.recordset")
	rs1.open "select * from [user] where siteid="&siteid&" and userid="&uid1,conn,1,1
	conn.execute("UPDATE [user] set siteid='"&rs1("siteid")&"',username='"&rs1("username")&"02',nickname='"&rs1("nickname")&"',password='"&rs1("password")&"',managerlvl='"&rs1("managerlvl")&"',remark='"&rs1("remark")&"',sex='"&rs1("sex")&"',money='"&rs1("money")&"',moneyname='"&rs1("moneyname")&"',RegTime='"&rs1("RegTime")&"',LoginTimes='"&rs1("LoginTimes")&"',headimg='"&rs1("headimg")&"',SessionTimeout='"&rs1("SessionTimeout")&"',myBankMoney='"&rs1("myBankMoney")&"',expR='"&rs1("expR")&"',endTime='"&rs1("endTime")&"',RMB='"&rs1("RMB")&"',ZoneCount='"&rs1("ZoneCount")&"',TJCount='"&rs1("TJCount")&"' where userid="&uid2&"")
	rs1.close
	set rs1=nothing
end if
rs.close
set rs=nothing

set rs=conn.execute("select * from [user] where siteid="&siteid&" and userid="&uid1)
conn.execute(" update [wap_bbs] set whylock=null,book_pub="&uid2&" where book_pub="&uid1)
conn.execute(" update [wap_bbsre] set nickname='"&rs("nickname")&"',userid="&uid2&" where userid="&uid1)
conn.execute(" update [wap_message] set nickname='"&rs("nickname")&"',userid="&uid2&" where userid="&uid1)
rs.close
set rs=nothing
call kltool_write_log("(会员转移)从:"&uid1&" 到:"&uid2)
Response.redirect"?siteid="&siteid&"&pg=yes2&uid1="&uid1&"&uid2="&uid2
elseif pg="yes2" then
%>
<script>alert('源ID:<%=request("uid1")%>\n目标ID:<%=request("uid2")%>');history.go(-1);</script>
<div class="tip">转移结果</div>
<%
end if
kltool_end
%>