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
	Response.write kltool_code(html)
%>
	<div class="panel-group" id="accordion">
		<div class="panel panel-default">
			<div class="panel-heading">
				<a data-toggle="collapse" data-parent="#accordion" href="#collapseOne" class="collapsed" aria-expanded="false">
					查看VIP
				</a>
				<a data-toggle="collapse" data-parent="#accordion" href="#collapseTwo" class="collapsed" aria-expanded="false">
					查看奖品
				</a>
				<a href="?action=yes&siteid=<%=siteid%>" id="tips" tiptext="确定？">点击抽奖</a>
			</div>
			<div id="collapseOne" class="panel-collapse collapse">
				<%=kltool_get_viplist_show%>
			</div>
			<div id="collapseTwo" class="panel-collapse collapse">
				<%=kltool_get_prizelist_show%>
			</div>
		</div>
	</div>
	<%
	Response.write kltool_code(kltool_end(1))
end sub

sub yes()
	if clng(get_num)=0 or clng(get_num2)=0 then
		Response.write "您没有抽奖次数"
		Response.End()
	end if
	set rs=server.CreateObject("adodb.recordset")
	rs.open "select top 1 * from [svip_prize] order by newid()",conn,1,1
	if rs.eof then
		Response.write "请等待管理员设置奖品"
		Response.End()
	end if
		s_lx=rs("s_lx")
		s_prize1=rs("s_prize1")
		s_prize2=rs("s_prize2")
	rs.close
	set rs=nothing
	if s_lx<>"" then s_lx=clng(s_lx)
	prize=RndNumber(s_prize2,s_prize1)
	s_tip="抽到了"&s_lx&"号奖品,"
	if s_lx=1 then
		s_tip=s_tip&sitemoneyname&"增加"&prize&""
		conn.Execute("update [user] set money=money+"&prize&" where userid="&userid)
	elseif s_lx=2 then
		s_tip=s_tip&"经验增加"&prize&""
		conn.Execute("update [user] set expr=expr+"&prize&" where userid="&userid)
	elseif s_lx=3 then
		prize=RndNumberDouble(s_prize1,s_prize2)'随机最大值小数溢出自身，反转变量
		s_tip=s_tip&"RMB增加"&prize&""
		conn.Execute("update [user] set rmb=rmb+"&prize&" where userid="&userid)
	elseif s_lx=4 then
		s_tip=s_tip&"存款增加"&prize&""
		conn.Execute("update [user] set mybankmoney=mybankmoney+"&prize&" where userid="&userid)
	elseif s_lx=5 then
		s_tip=s_tip&"身份时长增加"&prize&"天"
		if userid<>siteid and not isnull(SessionTimeout) and SessionTimeout<>"" and SessionTimeout>0 then
			conn.Execute("update [user] set endTime=dateadd(day,+"&prize&",endTime) where userid="&userid)
		end if
	elseif s_lx=6 then
		s_tip=s_tip&"空间人气增加"&prize&""
		conn.Execute("update [user] set ZoneCount=ZoneCount+"&prize&" where userid="&userid)
	elseif s_lx=7 then
		s_tip=s_tip&"积时增加"&prize&"秒"
		conn.Execute("update [user] set LoginTimes=LoginTimes+"&prize&" where userid="&userid)
	end if
	set rs=server.CreateObject("adodb.recordset")
	rs.open "select * from [svip_log]",conn,1,2
		rs.addnew
		rs("s_userid")=userid
		rs("s_content")=s_tip
		rs("s_time")=now()
		rs.update
	rs.close
	set rs=nothing
	conn.execute("insert into [wap_message](siteid,userid,nickname,title,content,touserid,isnew,issystem,addtime,HangBiaoShi)values("&siteid&",0,'系统','您"&s_tip&"','来自系统大神的消息:恭喜您在vip每日抽奖中"&s_tip&"','"&userid&"',1,1,'"&now()&"',0)")
	Response.write "恭喜您"&s_tip
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
			" "&page*PageSize+i-PageSize+1&"."&kltool_get_usernickname(s_userid,1)&"("&s_userid&")"&vbcrlf&_
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