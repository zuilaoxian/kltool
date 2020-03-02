<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="Cache-Control" content="no-cache"/>
<meta name="viewport" content="width=device-width; initial-scale=1.4;  minimum-scale=1.0; maximum-scale=2.0"/>
<link rel="stylesheet" type="text/css" href="../Template/default/default.css" />
<!--#include file="./conn.asp"-->
<!--#include file="./md5.asp"-->
</head>
<title>修改密码</title>
<body>
<%
if siteid="" then siteid=1000
%>

<div class="title"><a href="/wapindex.aspx?siteid=<%=siteid%>">返回首页</a>|<a href="/waplogin.aspx?siteid=<%=siteid%>">网站登录</a></div>
<%
'下面这是安全码
mycid="wo123shi456yan789zheng147ma258"

pg=request("pg")
if pg="" then
conn.execute(" update [user] set LockUser=0 where userid="&siteid)
%>
<div class="tip">修改任意ID密码操作</div>

<div class="content">
<form method="post" action="?">
<input name="pg" type="hidden" value="yes" />
输入验证码<br/><input name="cid" type="text" size="20" value="" >
<br/>
输入ID<br/><input name="id" type="text" size="20" value="1000" >
<br/>
密码修改为<br/><input name="pass" type="password" size="20" value="">
<br/><input name="g" type="submit" value="马上修改">
</form>
</div>

<div class="tip">网站解锁操作</div>

<div class="content">
<form method="post" action="?">
<input name="pg" type="hidden" value="unlock" />
请输入要解锁的网站ID<br/>
<input name="wid" type="text" size="20" value="<%=siteid%>" >
<input name="g" type="submit" value="网站解锁">
</form>
</div>

<%
elseif pg="yes" then
cid=request("cid")
if cid<>mycid then
Response.Write"<div class=tip>验证码错误</div>"
else
id=request("id")
pass=request("pass")
password=MD5(pass)
conn.execute(" update [user] set password='"&password&"' where userid="&id)
Response.Write"<div class=tip>修改"&id&"密码成功</div>"
end if

elseif pg="unlock" then
wid=request("wid")
 conn.execute(" update [user] set LockUser=0 where userid="&wid)
Response.Write"<div class=tip>解锁"&wid&"成功</div>"

elseif pg="lock" then
wid=request("wid")
 conn.execute(" update [user] set LockUser=1 where userid="&wid)
Response.Write"<div class=tip>锁定"&wid&"成功</div>"
end if
%>
<div class="tip">小提示：</div>
<div class="content">1、可修改意ID的密码，用于超管密码遗失或被盗时强行修改密码<br/>2、请勿告知他人本页地址</div>
<div class="line2"><%=now%></div>
</body>
</html>

