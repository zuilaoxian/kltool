<!--#include file="../inc/config.asp"-->
<%
kltool_use(2)
kltool_head("vip每日抽奖")
kltool_sql("vip_lx")
if kltool_yunxu=1 then Response.write "<div class=tip><a href='admin1.asp?siteid="&siteid&"'>管理后台</a></div>"
%>
<div class=line2>您的身份:<%=kltool_get_uservip(userid,1)%><%=kltool_get_uservip(userid,2)%></div>
<%
Response.Write"<div class=line2><a href='?siteid="&siteid&"&amp;lx=day'>今日排行</a>/<a href='?siteid="&siteid&"&amp;pg=sf'>抽奖身份</a>/<a href='?siteid="&siteid&"&amp;pg=jp'>奖品类型</a>/<a href='?siteid="&siteid&"&amp;lx=my'>我的记录</a></div>"

set rs=server.CreateObject("adodb.recordset")
rs.open "select * from [vip_lx] where svip="&SessionTimeout,conn,1,1
if rs.bof and rs.eof then
	Response.Write "<div class=tip>sorry，你没有抽奖权限</div>"
else
	sci=clng(rs("sci"))
end if
rs.close
set rs=nothing

if sci>0 then
set rs=Server.CreateObject("ADODB.Recordset")
rs.open "select * from [vip_log] where userid="&userid&" and DateDiff(day,vtime,getdate())=0",conn,1,1
if rs.recordcount>=sci then
Response.Write "<div class=tip>sorry，您今天抽奖次数已经用完，请明天再来</div>"
else
Response.Write "<div class=tip><a href='?siteid="&siteid&"&amp;pg=star'>点击抽奖</a>(剩余:"&sci-rs.recordcount&")</div>"
end if
rs.close
set rs=nothing
end if
''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
pg=request("pg")
	if pg="" then
	Response.Write "<div class=line1><form method='post' action='?'><input type='hidden'  name='siteid' value='"&siteid&"'><input type='hidden'  name='lx' value='cx'>"
	Response.Write "<input type='text'  name='uid' value='' size='13' placeholder='用户id'>"
	Response.Write "<input type='text'  name='vday' value='' size='17' placeholder='日期,限本月'>"
	Response.Write "<input type='submit' value='查询'></form></div>"
	lx=request("lx")
	vday=request("vday")
	uid=request("uid")
	if uid<>"" and not Isnumeric(uid) then response.redirect "?siteid="&siteid
	if vday<>"" and not Isnumeric(vday) then response.redirect "?siteid="&siteid

	set rs=server.CreateObject("adodb.recordset")
	if lx="" then
	rs.open "select * from [vip_log] order by id desc",conn,1,1

	elseif lx="day" then
	rs.open "select * from [vip_log] where DateDiff(day,vtime,getdate())=0 order by jp1,jp2 desc",conn,1,1

	elseif lx="my" then
	rs.open "select * from [vip_log] where userid="&userid&" order by id desc",conn,1,1

	elseif lx="cx" and uid<>"" and vday<>"" then
	rs.open "select * from [vip_log] where userid="&uid&" and year(vtime)="&year(now)&" and month(vtime)="&month(now)&" and day(vtime)="&vday&" order by id desc",conn,1,1

	elseif lx="cx" and uid="" and vday<>"" then
	rs.open "select * from [vip_log] where year(vtime)="&year(now)&" and month(vtime)="&month(now)&" and day(vtime)="&vday&" order by id desc",conn,1,1

	elseif lx="cx" and uid<>"" and vday="" then
	rs.open "select * from [vip_log] where userid="&uid&" order by id desc",conn,1,1
	else
	response.redirect "?siteid="&siteid&""
	end if

	If Not rs.eof Then
	gopage="?lx="&lx&"&amp;uid="&uid&"&amp;vday="&vday&"&amp;"
	Count=rs.recordcount
	pagecount=(count+pagesize-1)\pagesize
	if page>pagecount then page=pagecount
	rs.move(pagesize*(page-1))
	call kltool_page(1)
	For i=1 To PageSize
	If rs.eof Then Exit For
	if year(rs("vtime"))=year(now) and month(rs("vtime"))=month(now) and day(rs("vtime"))=day(now) then
	Response.write "<div class=""tip"">"&i&"."
	elseif i mod 2 =0 then
	Response.write "<div class=""line2"">"&i&"."
	else
	Response.write "<div class=""line1"">"&i&"."
	end if
	uid=""&rs("userid")&""
	Response.write "<a href=""/bbs/userinfo.aspx?siteid="&siteid&"&amp;touserid="&rs("userid")&""">"
	%><%=kltool_get_usernickname(rs("userid"),1)%><%
	Response.write "</a>(<a href=""?siteid="&siteid&"&amp;lx=cx&amp;uid="&rs("userid")&"""><small><small>"&rs("userid")&"</small></small></a>)"&rs("content")&"(<small>"&month(rs("vtime"))&"-"&day(rs("vtime"))&" <small>"&hour(rs("vtime"))&":"&minute(rs("vtime"))&"</small></small>)"
	Response.write "</div>"
		rs.movenext
		Next
	call kltool_page(2)
	else
	   Response.write "<div class=""tip"">暂时没有抽奖记录！</div>"
	end if
	rs.close
	set rs=nothing
''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
elseif pg="star" then
	set rs=Server.CreateObject("ADODB.Recordset")
	rs.open "select * from [vip_log] where userid="&userid&" and DateDiff(day,vtime,getdate())=0",conn,1,1
	if rs.recordcount>=sci then Response.redirect"?siteid="&siteid&""
	rs.close
	set rs=nothing

	set rs=server.CreateObject("adodb.recordset")
	rs.open "select top 1 * from [vip_jp] where xy=1 order by newid()",conn,1,1
	if rs.eof then call kltool_msge("没有可用的奖品")
	lx=clng(rs("lx"))
	vjp1=clng(rs("jp1"))
	vjp2=clng(rs("jp2"))
	rs.close
	set rs=nothing

	jp1=RndNumber(vjp2,vjp1)
	jp2=RndNumber(vjp2,vjp1)
	if lx=1 then
		ct="抽到了1号奖品,"&sitemoneyname&"增加"&jp1&""
		   conn.Execute("update [user] set money=money+"&jp1&" where userid="&userid)
	elseif lx=2 then
		ct="抽到了2号奖品,经验增加"&jp1&""
		   conn.Execute("update [user] set expr=expr+"&jp1&" where userid="&userid)
	elseif lx=3 then
		ct="抽到了3号奖品,"&sitemoneyname&"增加"&jp1&"/经验增加"&jp2&""
		   conn.Execute("update [user] set money=money+"&jp1&",expr=expr+"&jp2&" where userid="&userid)
	elseif lx=4 then
		ct="抽到了4号奖品,身份时长增加"&jp1&"天"
	if not instr(vt,"999") then
		   conn.Execute("update [user] set endTime=dateadd(day,+"&jp1&",endTime) where userid="&userid)
	end if
	elseif lx=5 then
		ct="抽到了5号奖品,积时增加"&jp1&"秒"
		   conn.Execute("update [user] set LoginTimes=LoginTimes+"&jp1&" where userid="&userid)
	elseif lx=6 then
		ct="抽到了6号奖品,空间人气增加"&jp1&""
		   conn.Execute("update [user] set ZoneCount=ZoneCount+"&jp1&" where userid="&userid)
	elseif lx=7 then
		ct="抽到了7号奖品,人民币增加"&jp1&""
		   conn.Execute("update [user] set rmb=rmb+"&jp1&" where userid="&userid)
	elseif lx=8 then
		ct="抽到了8号奖品,存款增加"&jp1&""
		   conn.Execute("update [user] set mybankmoney=mybankmoney+"&jp1&" where userid="&userid)
	end if
	set rs=server.CreateObject("adodb.recordset")
	rs.open "select * from [vip_log]",conn,1,2
	rs.addnew
	rs("userid")=userid
	rs("name")=nickname
	rs("jp1")=jp1
	if lx=3 then rs("jp2")=jp2
	rs("content")=ct
	rs("vtime")=now()
	rs.update
	rs.close
	set rs=nothing

	conn.execute("insert into [wap_message](siteid,userid,nickname,title,content,touserid,isnew,issystem,addtime,HangBiaoShi)values('"&siteid&"','0','系统','您"&ct&"','来自系统大神的消息:恭喜您在vip每日抽奖中"&ct&"','"&userid&"','1','1','"&date()&" "&time()&"','0')")

	Response.redirect"?siteid="&siteid&"&lx=my"
''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
elseif pg="sf" then
	set rs=server.CreateObject("adodb.recordset")
	rs.open "select * from [vip_lx]",conn,1,1
	If Not rs.eof Then
		gopage="?pg=sf&amp;"
		Count=rs.recordcount
		pagecount=(count+pagesize-1)\pagesize	
		if page>pagecount then page=pagecount
		rs.move(pagesize*(page-1))
	call kltool_page(1)
		For i=1 To PageSize
		If rs.eof Then Exit For
	Response.write"<div class=""line2"">"&rs("svip")&"."
	Response.write kltool_get_vip(rs("svip"),1)
	Response.write "[可抽奖次数:"&rs("sci")&"]</div>"
		rs.movenext
		Next
	call kltool_page(2)
	else
	Response.write "<div class=""tip"">暂时没有身份类型记录！</div>"
	end if
	rs.close
	set rs=nothing
''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
elseif pg="jp" then
	set rs=server.CreateObject("adodb.recordset")
	rs.open "select * from [vip_jp] where xy=1",conn,1,1
	If Not rs.eof Then
		gopage="?pg=jp&amp;"
		Count=rs.recordcount
		pagecount=(count+pagesize-1)\pagesize	
		if page>pagecount then page=pagecount
		rs.move(pagesize*(page-1))
	call kltool_page(1)
		For i=1 To PageSize
		If rs.eof Then Exit For
	lx=clng(rs("lx"))
	if lx=1 then
		jp=""&sitemoneyname&""
	elseif lx=2 then
		jp="经验"
	elseif lx=3 then
		jp=""&sitemoneyname&"和经验"
	elseif lx=4 then
		jp="vip延期(天)"
	elseif lx=5 then
		jp="在线积时(秒)"
	elseif lx=6 then
		jp="空间人气"
	elseif lx=7 then
		jp="人民币(元)"
	elseif lx=8 then
		jp="银行存款"
	end if
	Response.write "<div class=line2>"&i&".奖品类型:"&jp&"</div>"
	Response.write "<div class=line1>　"&rs("jp1")&"-"&rs("jp2")&"</div>"
		rs.movenext
		Next
	call kltool_page(2)
	else
	Response.write "<div class=""tip"">暂时没有奖品类型记录！</div>"
	end if
	rs.close
	set rs=nothing

end if
kltool_end
%>