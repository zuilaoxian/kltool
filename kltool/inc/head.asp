<!DOCTYPE html><html>
<head><!--#include file="./config.asp"-->
<meta http-equiv="Content-Type" content="application/xhtml+xml; charset=utf-8"/>
<meta http-equiv="Cache-Control" content="max-age=0"/>
<meta name="viewport" content="width=device-width,initial-scale=1.0, minimum-scale=1.0, maximum-scale=0">
<link rel="stylesheet" href="<%=kltool_path%>Template/default.css?v=<%=year(now)%><%=month(now)%><%=minute(now)%>" type="text/css" />
<script src="<%=kltool_path%>Template/common.js?v=<%=year(now)%><%=month(now)%><%=minute(now)%>" type="text/javascript"></script>
<script src="<%=kltool_path%>inc/kltool.js?v=<%=year(now)%><%=month(now)%><%=minute(now)%>" type="text/javascript"></script>
</head>
<body>
<style type="text/css">
textarea{width:100%;}
.line1{font-size:11px;}
</style>
<header class="aside-left header" id="header">
  <div class="logo"><a href="<%if kltool_yunxu=1 then Response.write kltool_path&"index.asp?siteid="&siteid else Response.write"/wapindex.aspx?siteid="&siteid%>"><img src="<%=kltool_logo%>" alt="logo"></a></div>
  <div class="menu-btn">
<a id="menu-js" href="javascript:;"><img src="<%=kltool_path%>Template/img/menu-btn.png" alt="菜单按钮"></a>


<a id="search-js" href="javascript:;">
    <div class="search-box" id="search-box">
<%if kltool_yunxu=1 then%>
      <form id="search-form" name="g" method="get" action="<%=kltool_path%>ziliao.Asp">
        <div class="search-box-text"><input type="text" name="uid" placeholder="输入用户ID或用户名"></div>
<%else%>
      <form id="search-form" name="g" method="get" action="/article/book_list.aspx">
        <div class="search-box-text"><input type="text" name="uid" placeholder="请输入关键字"></div>
<%end if%>
        <input type="hidden" name="siteid" value="<%=siteid%>">
      </form>
      <img src="<%=kltool_path%>Template/img/search-btn.png" alt="菜单按钮"></div>
</a>
<div class="Mail"><%=kltool_get_usermsg(userid,2)%></div>
</div>
</header>
<div class="mains">
<div class="xk_nav">
<%
if kltool_yunxu=1 then
Response.write"<a href='"&kltool_path&"admin/admin2.asp?siteid="&siteid&"'>权限管理</a><a href='"&kltool_path&"admin/admin3.asp?siteid="&siteid&"'>验证&log</a>"
else
Response.write"<a href='/myfile.aspx?siteid="&siteid&"'>我的地盘</a><a href='/bbs/userinfo.aspx?siteid="&siteid&"&touserid="&userid&"&backurl="&kltool_path&"'>我的空间</a><a href='/wapindex.aspx?siteid="&siteid&"&backurl="&kltool_path&"'>网站首页</a>"
end if
Response.write "<a href=""javascript:window.history.back();"">页面后退</a>"
if kltool_yanzheng=1 and kltool_logintimes<kltool_admintimes then Response.write "<a href=""#"">("&kltool_logintimes&"/"&kltool_admintimes&")</a>"
%>
</div>

