<!--#include file="../config.asp"-->
<%
kltool_use(2)
kltool_sql("svip")

action=Request.QueryString("action")
select case action
	case ""
		call index()
	case "yes"
		call yes()
	case "log"
		call log()
end select

function get_num
	get_num=0
	if SessionTimeout="" or SessionTimeout<=0 or isnull(SessionTimeout) then
		get_num=0
	else
		set rs_getnum=server.CreateObject("adodb.recordset")
		rs_getnum.open "select * from [svip] where s_vip="&SessionTimeout,conn,1,1
		if not (rs_getnum.bof and rs_getnum.eof) then get_num=rs_getnum("s_num")
		rs_getnum.close
		set rs_getnum=nothing
	end if
end function

function get_num2
	get_num2=0
	if get_num then
		set rs_getnum2=Server.CreateObject("ADODB.Recordset")
		rs_getnum2.open "select * from [svip_log] where s_userid="&userid&" and DateDiff(day,s_time,getdate())=0",conn,1,1
		if rs_getnum2.recordcount<clng(get_num) then get_num2=clng(get_num)-rs_getnum2.recordcount
		rs_getnum2.close
		set rs_getnum2=nothing
	end if
end function


sub index()
	html=kltool_head("vip每日抽奖",1)&_
	"<ul class=""breadcrumb"">"&vbcrlf&_
	"	<li>vip抽奖</li>"&vbcrlf&_
	"	<li><a href=""?siteid="&siteid&"&action=log"">查看抽奖记录</a></li>"&vbcrlf&_
	"</ul>"&vbcrlf&_
	"<li class=""list-group-item"">"&vbcrlf&_
	"	您的身份:"&kltool_get_uservip(userid,1)&kltool_get_uservip(userid,2)&vbcrlf&_
	"	<br/>您的vip可抽奖次数为:"&get_num&" 今日剩余:<span id=""ss_num"">"&get_num2&"</span>"&vbcrlf&_
	"</li>"&vbcrlf

	Response.write kltool_code(html&kltool_end(1))
end sub

sub yes()
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
end sub


sub log()
kltool_sql("svip_log")
	html=kltool_head("VIP抽奖-抽奖记录",1)&_
	"<ul class=""breadcrumb"">"&vbcrlf&_
	"	<li><a href=""?siteid="&siteid&""">vip抽奖</a></li>"&vbcrlf&_
	"	<li>查看抽奖记录</li>"&vbcrlf&_
	"</ul>"&vbcrlf
	sql="select * from [svip_log]"
	if r_search<>"" then sql=sql&" where s_userid="&r_search else sql=sql&" where s_userid="&userid
	sql=sql&" order by s_time desc"
	str=kltool_GetRow(sql,0,10)
	If str(0) Then
		gopage="?action=log&"
		if r_search<>"" then gopage="?action=log&r_search="&r_search&"&"
		Count=str(0)
		pagecount=str(1)
		if page>pagecount then page=pagecount
		html=html&kltool_page(1,count,pagecount,gopage)
		For i=0 To ubound(str(2),2)
		id=str(2)(0,i)
		s_userid=str(2)(1,i)
		s_content=str(2)(2,i)
		s_time=str(2)(3,i)
		html=html&"<li class=""list-group-item"">"&vbcrlf&_
			" "&page*PageSize+i-PageSize+1&"."&kltool_get_usernickname(s_userid,2)&"("&s_userid&")"&vbcrlf&_
			" <br/>"&s_content&_
			" <br/><span style=""color: #a0a0a0;font-size:12px;"">("&s_time&")</span>"&vbcrlf&_
			"</li>"&vbcrlf
		Next
		html=html&kltool_page(2,count,pagecount,gopage)
	else
		html=html&"<div class=""alert alert-danger"">暂时没有记录</div>"
	end if
	Response.write kltool_code(html&kltool_end(1))
end sub
%>