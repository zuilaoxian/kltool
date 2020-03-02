<!--#include file="./conn.asp"-->
<!--#include file="./Function.asp"-->
<!--#include file="../api/conn.asp"-->
<!--#include file="../api/userconfig.asp"-->
<%
Function kltool_key_reg(q)
if not Isnumeric(q) then
	kltool_key_reg="必须是数字"
else
	set rs=server.CreateObject("adodb.recordset")
	rs.open "select * from [user] where userid="&q,conn,1,1
	if not rs.eof then
	kltool_key_reg="×"
	else
	kltool_key_reg="√"
	end if
	rs.close
	set rs=nothing
end if
End Function

Function RegExpTest(patrn, strng)   
    Dim regEx, retVal ' 建立变量。   
    Set regEx = New RegExp ' 建立正则表达式。   
    regEx.Pattern = patrn ' 设置模式。   
    regEx.IgnoreCase = False ' 设置是否区分大小写。   
    retVal = regEx.Test(strng) ' 执行搜索测试。   
    If retVal Then   
        RegExpTest = True  
    Else   
        RegExpTest = False  
    End If   
End Function

Function kltool_key_uname(q)
if len(q)<3 or len(q)>16 then
kltool_key_uname="×"
elseif RegExpTest("[\u4e00-\u9fa5]", q) Then
kltool_key_uname="×"
else
set rs=server.CreateObject("adodb.recordset")
rs.open "select username from [user] where username='"&q&"'",conn,1,1
if not rs.eof then
kltool_key_uname="×"
else
kltool_key_uname="√"
end if
rs.close
set rs=nothing
end if
End Function

Function kltool_key_cdk(q)
kltool_key_cdk="<div class=""content"">"
set rs=Server.CreateObject("ADODB.Recordset")
rs.open"select * from [cdk] where cdk='"&q&"'",conn,1,1
if rs.eof then
	kltool_key_cdk=kltool_key_cdk&"不存在的CDK"
else
	lx=Clng(rs("lx"))
	sy=Clng(rs("sy"))
	jinbi=rs("jinbi")
	jingyan=rs("jingyan")
	sff=rs("sff")
	sf=rs("sf")
	lg=rs("lg")
	xg=""&rs("xg")&""
	uid=rs("userid")
	chushou=clng(rs("chushou"))
rs.close
set rs=nothing

if sy=2 then
	shiyong="【已被"&kltool_get_usernickname(uid,1)&"("&uid&")使用】"
elseif sy=1 then
	if uid<>"" then
	shiyong="【未使用,属"&kltool_get_usernickname(uid,1)&"("&uid&")】"
	else
		if chushou=1 then
		shiyong="【未使用,出售中】"
		else
		shiyong="【未使用】"
		end if
	end if
end if
if lx=1 then
kltool_key_cdk=kltool_key_cdk&"CDK正确，"&shiyong&"<br/>此CDK的奖励为"&sitemoneyname&":"&jinbi&"<br/>"
	elseif lx=2 then
kltool_key_cdk=kltool_key_cdk&"CDK正确，"&shiyong&"<br/>此CDK的奖励为经验:"&jingyan&"<br/>"
	elseif lx=3 then
kltool_key_cdk=kltool_key_cdk&"CDK正确，"&shiyong&"<br/>此CDK的奖励为"&sitemoneyname&":"&jinbi&"个,经验:"&jingyan&"<br/>"
	elseif lx=4 then
kltool_key_cdk=kltool_key_cdk&"CDK正确，"&shiyong&"<br/>此CDK奖励为:VIP("&kltool_get_vip(sf,1)&")"&sff&"个月<br/>"
	elseif lx=5 then
kltool_key_cdk=kltool_key_cdk&"CDK正确，"&shiyong&"<br/>此CDK奖励为:"&lg&"秒积时<br/>"
	elseif lx=6 then
kltool_key_cdk=kltool_key_cdk&"CDK正确，"&shiyong&"<br/>此CDK奖励为:勋章奖励"&kltool_get_xunzhang(xg)&"<br/>"
end if

end if
kltool_key_cdk=kltool_key_cdk&"</div>"
End Function

Function kltool_key_hy(q)
str="<div class=""line1"">"&kltool_get_userheadimg(q)&"</div>"
str=str&"<div class=""line2"">昵称:"&kltool_get_usernickname(q,1)&"</div>"
str=str&"<div class=""line1"">VIP:"&kltool_get_uservip(q,1)&kltool_get_uservip(q,2)&"</div>"
set rs=server.CreateObject("adodb.recordset")
rs.open "select * from [user] where userid="&q,conn,1,1
If not rs.eof Then
str=str&"<div class=""line1"">ＩＤ:"&rs("userid")&"</div>"
str=str&"<div class=""line2"">归属站:"&rs("siteid")&"</div>"
str=str&"<div class=""line1"">性别:"&kltool_get_usersex(q)&"</div>"
str=str&"<div class=""line2"">用户名:"&rs("username")&"</div>"
str=str&"<div class=""line1"">"&sitemoneyname&":"&rs("money")&"</div>"
str=str&"<div class=""line2"">银行存款:"&rs("myBankMoney")&"</div>"
str=str&"<div class=""line1"">经验:"&rs("expr")&"</div>"
str=str&"<div class=""line2"">空间人气:"&rs("ZoneCount")&"</div>"
str=str&"<div class=""line1"">发帖量:"&int(rs("bbsCount"))&"</div>"
str=str&"<div class=""line2"">回帖量:"&rs("bbsReCount")&"</div>"
str=str&"<div class=""line1"">注册时间:"&rs("regtime")&"</div>"
str=str&"<div class=""line2"">离线时间:"&rs("LastLoginTime")&"</div>"
str=str&"<div class=""line1"">网站积时:"&rs("LoginTimes")&"秒</div>"
str=str&"<div class=""line2"">他的权限:"&kltool_get_usermanagerlvl(q)&"</div>"
LockUser=rs("LockUser")
if lockUser=0 Then str=str&"<div class=""line2"">状态:正常</div>"
if lockUser=1 Then str=str&"<div class=""line2"">此ID已经被锁定,无法进入本站</div>"
rs.close
set rs=nothing
else
str="<div class=""tip"">没有此会员记录！</div>"
end if
kltool_key_hy=str
End Function

Function kltool_key_picture(q)
set rs=server.CreateObject("adodb.recordset")
rs.open "select * from [wap_picture] where id="&q,conn,1,1
If not rs.eof Then
picstr=rs("book_file")
picarrstr=Split(picstr,"|")
str=rs("id")&"."&rs("book_title")&"<hr>缩略图:"&rs("book_img")&"<br/>"
if rs("book_img")="" or isnull(rs("book_img")) then
else
if instr(rs("book_img"),"http") then str=str&"<img src="""&rs("book_img")&""" alt=""""><br/>" else str=str&"<img src=""http://"&Request.ServerVariables("http_host")&"/picture/"&rs("book_img")&""" alt=""""><br/>"
end if
str=str&"图片："&rs("book_file")&"<br/>"

	for i=0 to ubound(picarrstr)
if picarrstr(i)="" or isnull(picarrstr(i)) then
else
	if instr(picarrstr(i),"http") then str=str&"<img src="""&picarrstr(i)&""" alt="""">" else str=str&"<img src=""http://"&Request.ServerVariables("http_host")&"/picture/"&picarrstr(i)&""" alt="""">"

end if
if i<>ubound(picarrstr) then str=str&"<br/>"
	next
rs.close
set rs=nothing
else
str="<div class=tip>没有此记录！</div>"
end if
kltool_key_picture=str
End Function
%>