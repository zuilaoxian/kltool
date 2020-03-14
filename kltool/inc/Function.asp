<%
Function kltool_head(str)
%>
<!DOCTYPE html><html>
<head>
<meta http-equiv="Content-Type" content="application/xhtml+xml; charset=utf-8"/>
<meta http-equiv="Cache-Control" content="max-age=0"/>
<meta name="viewport" content="width=device-width,initial-scale=1.0, minimum-scale=1.0, maximum-scale=0">
<link rel="stylesheet" href="<%=kltool_path%>Template/default.css?v=<%=year(now)%><%=month(now)%><%=minute(now)%>" type="text/css" />
<script src="<%=kltool_path%>Template/common.js?v=<%=year(now)%><%=month(now)%><%=minute(now)%>" type="text/javascript"></script>
<script src="<%=kltool_path%>inc/kltool.js?v=<%=year(now)%><%=month(now)%><%=minute(now)%>" type="text/javascript"></script>
<title><%=str%></title>
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
<%
End Function
'-----定义底部
Function kltool_end
kltool_execution_endtime=timer()
kltool_execution_time=FormatNumber((kltool_execution_endtime-kltool_execution_startime)*1000,3)
if kltool_execution_time<1 then kltool_execution_time="0"&kltool_execution_time
Response.write""&vbcrlf&"</div>"&vbcrlf&"<footet>"
Response.write"<div class=""xk_quandibg"">"&vbcrlf&"<div class=""xk_quandi"">"&vbcrlf
Response.write"<h1><a href=""/myfile.aspx?siteid="&siteid&""">地盘</a>|<a href=""/wapindex.aspx?siteid="&siteid&"&backurl="&kltool_path&""">首页</a>|<a href=""/bbs/userinfo.aspx?touserid="&userid&"&siteid="&siteid&""">空间</a>"
if kltool_yunxu=1 then Response.Write"|<a href="""&kltool_path&"index.asp?siteid="&siteid&""">工具箱首页</a>" else Response.Write"|<a href=""/wapstyle/skin.aspx?siteid="&siteid&"&backurl="&kltool_path&""">切换</a>"
Response.write"</h1>"&vbcrlf&"<p>"
if kltool_yunxu=1 then Response.Write"柯林工具箱  2013-"&year(now)&"  版本"&kltool_version&"<br/>"&vbcrlf
Response.write date()&" "&time()&" "&weekdayname(weekday(now))&" "&kltool_execution_time&"毫秒</p>"&vbcrlf
Response.write"</div>"&vbcrlf&"</div>"&vbcrlf&"</footet>"&vbcrlf&"<aside class=""aside"" id=""aside"">"&vbcrlf&"<div class=""xk_userbg"">"&vbcrlf&"<div class=""xk_user"">"&vbcrlf&"<li>"&vbcrlf&"<a href=""/myfile.aspx?siteid="&siteid&""">"&vbcrlf&"<div>"&vbcrlf
Response.write"<span class=""tx"">"&kltool_get_userheadimg(userid)&"</span>"&vbcrlf&"<span class=""name"">"&vbcrlf
Response.write"<p1>"&kltool_get_usernickname(userid,1)&"</p1>"&vbcrlf
Response.write"<p2>"&userid&"/"&kltool_get_usersex(userid)&"/金"&kltool_get_usermoney(userid,1)&"/经"&kltool_get_usermoney(userid,2)&"</p2>"&vbcrlf
Response.write"</span>"&vbcrlf&"</div>"&vbcrlf&"</a>"&vbcrlf&"</li>"&vbcrlf&"<y><a href=""/waplogout.aspx?siteid="&siteid&"""></a></y>"&vbcrlf&"</div>"&vbcrlf&"<div class=""xk_usercd"">"&vbcrlf
Response.write"<li><a href=""/bbs/userinfo.aspx?siteid="&siteid&"&touserid="&userid&"&backurl="&kltool_path&""">空间</a></li>"&vbcrlf
Response.write"<li><a href=""/bbs/book_list.aspx?action=search&siteid="&siteid&"&classid=0&key="&userid&"&type=pub"">帖子</a></li>"&vbcrlf
Response.write"<li><a href=""/bbs/book_re_my.aspx?action=class&siteid="&siteid&"&classid=0&touserid="&userid&""">回帖</a></li>"&vbcrlf
Response.write"<li><a href=""/rizhi/myrizhi.aspx?siteid="&siteid&"&touserid="&userid&"&backurl="&kltool_path&""">微博</a></li>"&vbcrlf
Response.write"<li><a href=""/album/myalbum.aspx?siteid="&siteid&"&touserid="&userid&"&backurl="&kltool_path&""">相册</a></li>"&vbcrlf
Response.write"</div>"&vbcrlf&"</div>"&vbcrlf&"  <div class=""nv"">"&vbcrlf&"    <ul>"&vbcrlf
Response.write"      <li><a href=""/wapindex-"&siteid&"-0.html"">网站首页</a></li>"&vbcrlf
Response.write"      <li><a href="""&kltool_path&"cdk/?siteid="&siteid&""">CDK兑换系统</a></li>"&vbcrlf
Response.write"      <li><a href="""&kltool_path&"vip/?siteid="&siteid&""">自助开通vip</a></li>"&vbcrlf
Response.write"      <li><a href="""&kltool_path&"svip/?siteid="&siteid&""">VIP每日抽奖</a></li>"&vbcrlf
Response.write"    </ul>"&vbcrlf&"  </div>"&vbcrlf&"</aside>"&vbcrlf&"</body>"&vbcrlf&"</html>"
End Function
'-----组件检测函数
function ObjTest(strObj,str)
  on error resume next
  set TestObj=server.CreateObject (strObj)
	If -2147221005 <> Err then
if str=1 then ObjTest =strObj&"：支持<br/>"&vbcrlf else ObjTest = True
	else
ObjTest=strObj&"：不支持<br/>"&vbcrlf
'ObjTest=ObjTest&"错误号:"&Err.Number&"<br/>"&vbcrlf
'ObjTest=ObjTest&"错误源:"&Err.Source&"<br/>"&vbcrlf
'ObjTest=ObjTest&"错误信息:"&Err.Description&"<hr>"&vbcrlf
if str=1 then ObjTest=ObjTest else ObjTest=false
	end if
  set TestObj=nothing
End function
'-----随机数运算，最大值最小值
Function RndNumber(MaxNum,MinNum)
	Randomize 
	RndNumber=int((MaxNum-MinNum+1)*rnd+MinNum)
	RndNumber=RndNumber
End Function
'-----查询部分设置
set rs=server.CreateObject("adodb.recordset")
rs.open "select * from [yanzheng] where id=1",kltool,1,1
If not rs.eof then
kltool_yanzheng=rs("yanzheng")
kltool_admintimes=rs("timelong")
kltool_listsize=rs("listsize")
kltool_listsize2=rs("listsize2")
end if
rs.close
set rs=nothing

'-----查询操作权限
Function kltool_yunxu
kltool_yunxu=0
set rs=server.CreateObject("adodb.recordset")
rs.open "select * from [quanxian] where userid="&userid,kltool,1,1
If not rs.eof then kltool_yunxu=1
rs.close
set rs=nothing
End Function

'-----查询验证时间
Function kltool_logintimes
if clng(kltool_yanzheng)=1 and session("kltool_logintime")<>"" then kltool_logintimes=kltool_DateDiff(session("kltool_logintime"),now(),"n") else kltool_logintimes=kltool_admintimes+1
End Function

'-----用户IP获取
Function kltool_userip
kltool_userip = Request.ServerVariables("HTTP_X_FORWARDED_FOR") 
If kltool_userip="" Then kltool_userip=Request.ServerVariables("REMOTE_ADDR")
End Function

'-----用户登录状态判断
Function kltool_login
kltool_login=false
if userid<>"" and userid>0 then
if sidtimeout=sessionid then kltool_login=true
end if
end Function

'-----函数名:getname
'-----作用:获取日期
public Function Getname()
'on error resume next
    Dim y,m,d,h,mm,S
    y = Year(Now)
    m = Month(Now): If m < 10 Then m = "0" & m
    d = Day(Now): If d < 10 Then d = "0" & d
    h = Hour(Now): If h < 10 Then h = "0" & h
    mm = Minute(Now): If mm < 10 Then mm = "0" & mm
    S = Second(Now): If S < 10 Then S = "0" & S
    Getname = y & m & d & h & mm & S
End Function
'-----获取随机数字
public Function GetnameR()
Dim  r
    Randomize
    r = 0
    r = CInt(Rnd() * 1000)
    If r < 10 Then r = r &"00" 
    If r < 100 And r >= 10 Then r = r &"0"  
GetnameR=r
End Function
'-----数组数字相加，cs为分割字符
Function numsum(str,cs)
y=0
arrstr_numsum=split(str,cs)
for i=0 to ubound(arrstr_numsum)
if arrstr_numsum(i)="" then y=y else y=y+arrstr_numsum(i)
next
numsum=y
end Function
'-----数组数字取最大值，cs为分割字符
Function numax(str,cs)
arrstr_numax =split(str,cs)
if arrstr_numax(0)<>"" then x=arrstr_numax(0)
for i=1 to ubound(arrstr_numax)
if arrstr_numax(i)="" then arrstr_numax(i)=0
if arrstr_numax(i)-x>0 then
x=arrstr_numax(i)
end if
next
numax=x
end Function
'-----字节大小转换MB
function mysize(num)
	mysize=num
	If num<1024 Then
		mysize=round(num,0)&"B"
	ElseIf num>=1024 and num<1048576 Then
		mysize=round(num/1024,1)&"KB"
	ElseIf num>=1048576 Then
		mysize=round((num/1024)/1024,2)&"MB"
	End If
end function

'-----后台操作权限
Function kltool_quanxian
if clng(kltool_yunxu)<>1 then
	kltool_msge("你没有浏览本页的权限！")
else
'-----后台二次验证密码过期
If clng(kltool_yanzheng)=1 then
if session("kltool_logintime")="" then Response.redirect""&kltool_path&"inc/login.asp?siteid="&siteid
if clng(kltool_logintimes)>=clng(kltool_admintimes) then Response.redirect""&kltool_path&"inc/login.asp?siteid="&siteid
end if
end if
End Function

'部分字符替换
function kltool_code(strContent)
	strContent=trim(strContent)
	if IsNull(strContent) then exit function
	kltool_code=strContent
	strContent=replace(strContent,"sitemoneyname",sitemoneyname)
	strContent=replace(strContent,"[kltool_path]",kltool_path)
	strContent=replace(strContent,"///","<br/>")
	strContent=replace(strContent,"//","　")
	strContent=replace(strContent,"  ","　")
	kltool_code=strContent
end function

'上一页 下一页 跳转
sub kltool_page(things)
if pagecount>1 then Response.Write"<div class=line1>"
if page>1 then Response.Write"<a href='"&gopage&"siteid="&siteid&"'>[首页]</a> "
if page>1 then Response.Write"<a href='"&gopage&"page="&page-1&"&amp;siteid="&siteid&"'>[上页]</a> "
if page<pagecount then Response.Write"<a href='"&gopage&"page="&page+1&"&amp;siteid="&siteid&"'>[下页]</a> "
if page>=1 and page<pagecount then Response.Write"<a href='"&gopage&"page="&pagecount&"&amp;siteid="&siteid&"'>[尾页]</a>"
if pagecount>1 then Response.Write"</div>"
if things=2 then
Response.Write"<div class=line2>共<b>"&page&"</b>/"&pagecount&"页/"&Count&"条 "
if pagecount>1 then
Response.Write"<form method=""get"" action="""&gopage&""">"
Response.Write"<input name=""siteid"" type=""hidden"" value="""&siteid&""">"
if pagecount>1 and page<pagecount then page=""&page+1&"" else pgae=""&page-1&""
Response.Write"<input name=""page"" type=""text"" size=""5"" value="""&page&""">"
Response.Write"<input name=""g"" type=""submit"" value=""跳转""></form></div>"
else
Response.Write"</div>"
end if
end if
end sub

'-----录入操作日志
Sub kltool_write_log(things)
	if things<>"" then
		set rs_kltool_log=Server.CreateObject("ADODB.Recordset")
		rs_kltool_log.open"select * from [kltool_log]",kltool,1,2
		rs_kltool_log.addnew
		rs_kltool_log("userid")=userid
		rs_kltool_log("things")=things
		rs_kltool_log("time")=now
		rs_kltool_log("uip")=kltool_userip
		rs_kltool_log.update
		rs_kltool_log.close
		set rs_kltool_log=nothing
	end if
End Sub
'时间差计算
function kltool_DateDiff(dt1,dt2,dt3)
'dt3 可选
'yyyy	年
'q	季度
'm	月
'y	一年的日数
'd	日
'w	一周的日数
'ww	周
'h	小时
'n	分钟
's	秒
kltool_DateDiff=DateDiff(dt3,dt1,dt2)
end function
'-----取信息，uid为用户ID，things为1不带链接
Function kltool_get_usermsg(uid,things)
set rsk=conn.execute("select count(id) from [wap_message] where isnew=1 and siteid="&siteid&" and touserid="&uid)
if not rsk.eof then
if things=1 then kltool_get_usermsg=rsk(0) else kltool_get_usermsg="<a href='/bbs/messagelist.aspx?siteid="&siteid&"&classid=0&types=0'>"&rsk(0)&"</a>"
end if
rsk.Close
set rsk=nothing
End Function
'-----取头像
Function kltool_get_userheadimg(uid)
set rsk=conn.execute("select headimg from [user] where userid="&uid)
if not rsk.eof then
	ktx=rsk("headimg")
if ktx<>"" then
	if instr(ktx,"http")>0 then
	kltool_get_userheadimg="<img src="""&ktx
	elseif len(ktx)>7 then
	kltool_get_userheadimg="<img src=""/"&ktx
	elseif len(ktx)<=7 then
	kltool_get_userheadimg="<img src=""/bbs/head/"&ktx
	end if
kltool_get_userheadimg=kltool_get_userheadimg&""" style=""max-width:100px;max-height:100px;border-radius:45px;"" alt=""头像"">"
end if
end if
rsk.Close
set rsk=nothing

End Function
'-----取性别
Function kltool_get_usersex(uid)
set rsk=conn.execute("select sex from [user] where userid="&uid)
if not rsk.eof then
ksex=clng(rsk("sex"))
if ksex=1 then kltool_get_usersex="男" else kltool_get_usersex="女"
end if
rsk.Close
set rsk=nothing
End Function
'-----取权限
Function kltool_get_usermanagerlvl(uid)
set rsk=conn.execute("select managerlvl,siteid from [user] where userid="&uid)
if not rsk.eof then
	kmanagerlvl=clng(rsk("managerlvl"))
	if kmanagerlvl=00 Then
		kltool_get_usermanagerlvl="超级管理员"
	elseif kmanagerlvl=01 Then
		kltool_get_usermanagerlvl="副管理员"
	elseif kmanagerlvl=02 Then
		kltool_get_usermanagerlvl="普通会员"
	elseif kmanagerlvl=03 Then
		kltool_get_usermanagerlvl="总编辑"
	elseif kmanagerlvl=04 Then
		kltool_get_usermanagerlvl="总版主"
	end if
if clng(siteid)<>clng(rsk("siteid")) then kltool_get_usermanagerlvl="副级管理员"
end if
rsk.Close
set rsk=nothing
End Function
'-----取金钱积分,1金币，2经验，3存款，4RMB，5积时
Function kltool_get_usermoney(uid,things)
set rsk=conn.execute("select money,expr,mybankmoney,rmb,logintimes from [user] where userid="&uid)
if not rsk.eof then
kmoney=clng(rsk("money"))
kexpr=clng(rsk("expr"))
kmybankmoney=clng(rsk("mybankmoney"))
krmb=rsk("rmb")
klogintimes=clng(rsk("logintimes"))
if things=1 then kltool_get_usermoney=kmoney
if things=2 then kltool_get_usermoney=kexpr
if things=3 then kltool_get_usermoney=kmybankmoney
if things=4 then kltool_get_usermoney=krmb
if things=5 then kltool_get_usermoney=klogintimes
end if
rsk.Close
set rsk=nothing
End Function
'-----取昵称,1显示vip图标颜色，2直接显示昵称
Function kltool_get_usernickname(uid,things)
kltool_get_usernickname=""
if uid<>"" then
set rsk=conn.execute("select siteid,nickname,SessionTimeout,endTime from [user] where userid="&uid)
if not rsk.eof then
knickname=rsk("nickname")
kvip=clng(rsk("SessionTimeout"))
kvipt=rsk("endTime")
rsk.close
set rsk=nothing
	if kvip>0 then
	set rskvip=conn.execute("select subclassName from [wap2_smallType] where id="&kvip)
	if not rskvip.eof then vip_arrstr=rskvip("subclassName")
	rskvip.close
	set rskvip=nothing
	end if
	if vip_arrstr<>"" then
		'-----图片
		if instr(vip_arrstr,"#") then
		vip_arrstr_Split=Split(vip_arrstr,"#")
		else
		vip_arrstr_Split=Split(vip_arrstr&"#","#")
		end if
		pic_arrstr="gif|jpg|png|jepg|bmp"
		pic_arrstr_Split=Split(pic_arrstr,"|")
			for vipfor=0 to Ubound(pic_arrstr_Split)
			if instr(vip_arrstr_Split(0),pic_arrstr_Split(vipfor))>0 then
			kltool_get_usernickname="<img src="""&vip_arrstr_Split(0)&""" alt=""图片"">"
			Exit For
			end if
			next
		'-----颜色
		if vip_arrstr_Split(1)<>"" then
		color_arrstr_Split=Split(vip_arrstr_Split(1),"_")
		color_vip=color_arrstr_Split(0)
		end if
if things=2 then
kltool_get_usernickname=knickname
else
	if color_vip<>"" then kltool_get_usernickname=kltool_get_usernickname&"<font color=""#"&color_vip&""">"
	kltool_get_usernickname=kltool_get_usernickname&knickname
	if color_vip<>"" then kltool_get_usernickname=kltool_get_usernickname&"</font>"
end if
	else
	kltool_get_usernickname=knickname
	end if
else
kltool_get_usernickname="无记录的会员"
end if
end if
End Function
'-----取用户vip,0显示vip源代码，1显示图，2显示到期时间
Function kltool_get_uservip(uid,things)
set rsk=conn.execute("select nickname,SessionTimeout,endTime from [user] where userid="&uid)
if not rsk.eof then
kvip=clng(rsk("SessionTimeout"))
kvipt=rsk("endTime")
rsk.close
set rsk=nothing
	if things=0 then
	if kvip>0 then kltool_get_uservip=kvip
	elseif things=1 then
		if kvip>0 then
		set rskvip=conn.execute("select subclassName from [wap2_smallType] where id="&kvip)
		if not rskvip.eof then vip_arrstr=rskvip("subclassName")
		rskvip.close
		set rskvip=nothing
		end if
	if vip_arrstr<>"" then
		if instr(vip_arrstr,"#") then
		vip_arrstr_Split=Split(vip_arrstr,"#")
		else
		vip_arrstr_Split=Split(vip_arrstr&"#","#")
		end if
		pic_arrstr="gif|jpg|png|jepg|bmp"
		pic_arrstr_Split=Split(pic_arrstr,"|")
			for picfor=0 to Ubound(pic_arrstr_Split)
			if instr(vip_arrstr_Split(0),pic_arrstr_Split(picfor))>0 then
			kltool_get_uservip="<img src="""&vip_arrstr_Split(0)&""" alt=""图片"">"
			Exit For
			else
			kltool_get_uservip=vip_arrstr_Split(0)
			end if
			next
	else
	kltool_get_uservip="普通会员"
	end if
	elseif things=2 then
	if vip>=0 then
	if isnull(kvipt) or instr(kvipt,"999")>0 then kltool_get_uservip="<br/>过期时间:无限期" else kltool_get_uservip="<br/>过期时间:"&kvipt&"(剩余"&kltool_DateDiff(now(),kvipt,"d")&"天)"
	end if
	end if
end if
End Function

'-----取vip，1显示图，2显示图源代码以及颜色源代码
Function kltool_get_vip(uid,things)
if uid<>"" then
	set rs_vip=conn.execute("select siteid,subclassName from [wap2_smallType] where siteid="&siteid&" and id="&uid)
	if not rs_vip.eof then vip_str=rs_vip("subclassName")
	rs_vip.close
	set rs_vip=nothing
if vip_str<>"" then
	'旧版与新版不同，判断一下，防止出错
	'得到#前面的内容，是图片图标或文字
	if instr(vip_str,"#") then
	vip_str_Split=Split(vip_str,"#")
	else
	vip_str_Split=Split(vip_str&"#","#")
	end if
	'vip颜色
	if vip_str_Split(1)<>"" then
	vip_color_str_Split=Split(vip_str_Split(1),"_")
	vip_color=vip_color_str_Split(0)
	end if
	'图片/文字
	vip_pic=vip_str_Split(0)
	pics_str=".png|.jpg|.bmp|.gif"
	pics_str_Split=Split(pics_str,"|")
	'循环图片格式
	for i=0 to Ubound(pics_str_Split)
		if instr(vip_pic,pics_str_Split(i))>0 then
			'如果包含
			'things为1，显示图片
			if things=1 then
			kltool_get_vip="<img src="""&vip_pic&""" alt=""图片"">"&vbcrlf
			'things不为1直接显示，跟上颜色
			else
			kltool_get_vip=vip_pic&"_#"&vip_color&vbcrlf
			end if
		Exit For

		else
			kltool_get_vip="<font color=""#"&vip_color&vbcrlf&""">"&vip_pic&"</font>"
		end if
	next'循环下一条
	end if
end if
End Function
'-----显示勋章
Function kltool_get_xunzhang(img)
if img<>"" then
	if len(img)<=6 then
	kltool_get_xunzhang="<img src='/bbs/medal/"&img&"' alt=''>"
	else
	kltool_get_xunzhang="<img src='/"&img&"' alt=''>"
	end if
end if
End Function
'-----获取vip列表，things为表单name
Sub kltool_get_viplist(things)
	Response.Write"<select name="""&things&""">"
	set rsviplist=Server.CreateObject("ADODB.Recordset")
	rsviplist.open "select * from [wap2_smallType] where siteid="&siteid&" and systype='card'",conn,1,1
		If rsviplist.eof Then
			Response.write"<option value=""0"">并没有VIP</option>"
		else
			For i=1 To rsviplist.recordcount
			If rsviplist.eof Then Exit For
				Response.Write"<option value="""&rsviplist("id")&""">"&rsviplist("id")&"</option>" 
			rsviplist.movenext
			Next
		end if
	Response.Write "</select><br/>"
	rsviplist.close
	set rsviplist=nothing
end sub
'-----创建文件夹
'-----path_str="upload/"&year(now)&"/"&month(now)&"/"&day(now)
'-----call Create_Folder(path_str)
sub Create_Folder(path_str)
	Set fso_f = Server.CreateObject("Scripting.FileSystemObject")
	path_str_split=split(path_str,"/")
		for i=0 to ubound(path_str_split)
			if i=0 and path_str_split(i)="" then cpath="/" else cpath=cpath&path_str_split(i)&"/"
			If not fso_f.folderExists(server.mappath(cpath)) then fso_f.CreateFolder server.mappath(cpath)
		next
	Set fso_f = nothing
end sub
%>
