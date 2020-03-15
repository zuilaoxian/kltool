<!--#include file="../inc/config.asp"-->
<%
kltool_head("会员自助更改用户名")
kltool_sql("uname")

money=clng(money)
expr=clng(expr)
if kltool_yunxu=1 then Response.Write "<div class=tip><a href='admin1.asp?siteid="&siteid&"'>后台管理</a></div>"
pg=request("pg")
if pg="" then
	Response.Write "<div class=line2>我的用户名(即登录名)：("&getusername&")</div>"
	Response.Write "<div class=line1><form method='post' action='?'>"
	Response.Write "<input type='hidden' name='siteid' value='"&siteid&"'>"
	Response.Write "<input type='hidden' name='pg' value='kt'>"
	Response.Write "新用户名<input type='text' name='nname' value='' size='20' placeholder='英文或数字' id=""txt1"" onkeyup=""return ajaxQuerySetDom(this.value,'../inc/key.asp?action=uname&','q','result')""><span id=""result""></span><br/>"
	Response.Write "申请说明<textarea name='content' rows='3' type='text'></textarea>"
	Response.Write "<input type='submit' value='申请' name='submit' onClick=""ConfirmDel('是否确定？');return false""></form><span class='right'><a href='?siteid="&siteid&"&amp;lx=my'>我的申请</a></span></div>"
	lx=request("lx")
	if lx="my" then Response.Write"<div class='tip'>我的申请</div>"
	set rs=server.CreateObject("adodb.recordset")
	if lx="" then
	rs.open "select * from [uname] where siteid="&siteid&" order by time1 desc",conn,1,1
	elseif lx="my" then
	rs.open "select * from [uname] where siteid="&siteid&" and userid="&userid&" order by time1 desc",conn,1,1
	end if
	If Not rs.eof Then	
		gopage="?lx="&lx&"&amp;"
		Count=rs.recordcount
		pagecount=(count+pagesize-1)\pagesize	
		if page>pagecount then page=pagecount
		rs.move(pagesize*(page-1))
	call kltool_page(1)
		For i=1 To PageSize
		If rs.eof Then Exit For
	if i mod 2 = 0 then response.write"<div class=""line1"">" else response.write"<div class=""line2"">"
	response.write""&page*PageSize+i-PageSize&"."
	id=rs("id")
	uid=clng(rs("userid"))
	type1=clng(rs("type1"))
	type2=clng(rs("type2"))
	Response.write kltool_get_usernickname(uid,1)&"("&uid&")申请更改用户名("
	if kltool_yunxu=1 or uid=clng(userid) then response.write"<a href='?siteid="&siteid&"&amp;pg=lu&amp;id="&id&"&amp;page="&page&"&amp;lx="&lx&"'>"
	if type1=2 then
	Response.write"√"
	elseif type1=1 then
	Response.write"×"
	elseif type1=0 then
	Response.write"⊙"
	end if
	if kltool_yunxu=1 or uid=clng(userid) then Response.write"</a>"
	Response.write")"
	if type1=2 then
	Response.write"(同意)"
	elseif type1=1 then
	Response.write"(不同意)"
	elseif type1=0 then
	Response.write"(待审)"
	end if
	if type2=3 then
	Response.write"(已放弃)"
	elseif type2=1 then
	Response.write"(未更改)"
	elseif type2=2 then
	Response.write"(已更改)"
	elseif type2=4 then
	Response.write"(已过期)"
	end if
	if kltool_yunxu=1 then Response.write"<a href=""?siteid="&siteid&"&amp;id="&id&"&amp;&page="&page&"&amp;lx="&lx&"&amp;pg=sc"" onClick=""ConfirmDel('是否确定？\n删除后不能恢复');return false"">删除</a>"
	Response.write"</div>"
		rs.movenext
		Next
	call kltool_page(2)
	else
	   Response.write "<div class=tip>暂时没有记录</div>"
	end if
	rs.close
	set rs=nothing
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
elseif pg="kt" then
	nname=Trim(request("nname"))
	content=request("content")
	nname=LCASE(nname)
	if len(nname)<3 then call kltool_msge("新用户名不能小于3个字符")
	if len(nname)>16 then call kltool_msge("新用户名不能超过16个字符")
	if nname=getusername then call kltool_msge("不能与原用户名相同")
	set rs=server.CreateObject("adodb.recordset")
	rs.open "select * from [user] where username='"&nname&"'",conn,1,1
	if not rs.eof then call kltool_msge("已存在此用户名")
	rs.close
	set rs=nothing

	set rs=server.CreateObject("adodb.recordset")
	rs.open "select * from [uname] where siteid="&siteid&" and userid="&userid&" and type1=0",conn,1,1
	if not rs.eof then call kltool_msge("你还有未审核的申请")
	rs.close
	set rs=nothing

	set rs=server.CreateObject("adodb.recordset")
	rs.open "select * from [uname] where siteid="&siteid&" and userid="&userid&" and type2=1",conn,1,2
	if not rs.eof then call kltool_msge("你还有已审核的申请未操作")
	rs.addnew
	rs("siteid")=siteid
	rs("userid")=userid
	rs("oname")=getusername
	rs("nname")=nname
	rs("content1")=content
	rs("type1")=0
	rs("type2")=0
	rs("time1")=now()
	rs("shou")=1
	rs.update
	rs.close
	set rs=nothing

	set rs=server.CreateObject("adodb.recordset")
	rs.open "select * from [quanxian]",kltool,1,1
	if rs.eof then call kltool_msge("查询内信对象失败\n未能发送审核内信给管理员")
	For i=1 To rs.recordcount
	If rs.eof Then Exit For
	gid=rs("userid")
	conn.execute("insert into [wap_message](siteid,userid,nickname,title,content,touserid,isnew,issystem,addtime)values('"&siteid&"','"&siteid&"','系统','来自用户名更改系统的申请信息','"&nickname&"("&userid&")申请更改用户名，请及时[url="&kltool_path&"uname/admin1.asp?siteid=[siteid]]前往处理[/url]','"&gid&"','1','1','"&date()&" "&time()&"')")

	rs.movenext
	Next

	Response.Write "<div class=tip>你的申请已经受理，请等待审核，审核后会以站内信通知！</div>"

'----详细界面
elseif pg="lu" then
	id=request("id")
	lx=request("lx")
	set rs=server.CreateObject("adodb.recordset")
	if yunxu=1 then
	rs.open"select * from [uname] where siteid="&siteid&" and id="&id,conn,1,1
	else
	rs.open"select * from [uname] where siteid="&siteid&" and userid="&userid&" and id="&id,conn,1,1
	end if
	if rs.eof then call kltool_msge("无此记录")
	uid=clng(rs("userid"))
	oname=rs("oname")
	nname=rs("nname")
	content1=rs("content1")
	content2=rs("content2")
	shou=clng(rs("shou"))
	jinbi=rs("jinbi")
	jingyan=rs("jingyan")
	type1=clng(rs("type1"))
	type2=clng(rs("type2"))
	time1=rs("time1")
	time2=rs("time2")
	rs.close
	set rs=nothing

	Response.write"<div class=""tip"">申请更改用户名数据如下</div>"
	Response.write"<div class=""line2"">原用户名:"&oname&"&nbsp;新用户名:"&nname&"</div>"
	Response.write"<div class=""line1"">申请时间:"&time1&"</div>"
	if content1<>"" then Response.write"<div class=""line2"">申请说明:"&content1&"</div>"

	Response.write"<div class='tip'>审核状态:"
	if type1=2 then
	Response.write"(同意)"
	elseif type1=1 then
	Response.write"(不同意)"
	elseif type1=0 then
	Response.write"(待审)"
	end if
	Response.write"</div>"

	if type1<>0 and content2<>"" then Response.write"<div class=""line2"">审核说明:"&content2&"</div>"

	if type1=2 then
		if time2<>"" then Response.write"<div class=""content"">过期时间:"&time2&"("&-dateDiff("d",time2,now())&")</div>"
			if shou=2 then
			Response.write"<div class=""line2"">收费:"
			if jinbi<>"" then Response.write""&sitemoneyname&"("&jinbi&")"
			if jingyan<>"" then Response.write"&nbsp;经验("&jingyan&")"
			Response.write"</div>"
			end if
	end if

	if type1=2 then
		Response.write"<div class='tip'>操作状态:"
			if type2=1 then Response.write"未更改"
			if type2=2 then Response.write"已更改"
			if type2=3 then Response.write"已放弃"
			if type2=4 then Response.write"已过期"
		Response.write"</div>"
	end if

	if uid=clng(userid) and type1=2 and type2=1 then Response.write"<div class=""tip""><a href='?siteid="&siteid&"&amp;pg=in&amp;lx="&lx&"&amp;page="&page&"&amp;inu=1&amp;id="&id&"'>放弃更改</a>--<a href='?siteid="&siteid&"&amp;pg=in&amp;lx="&lx&"&amp;page="&page&"&amp;inu=2&amp;id="&id&"'>确定更改</a></div>"

'----开始更改
elseif pg="in" then
	inu=request("inu")
	id=request("id")
	lx=request("lx")
	set rs=server.CreateObject("adodb.recordset")
	rs.open"select * from [uname] where siteid="&siteid&" and userid="&userid&" and id="&id,conn,1,1
	if rs.eof then call kltool_msge("无此记录")
	uid=clng(rs("userid"))
	oname=rs("oname")
	nname=rs("nname")
	content1=rs("content1")
	content2=rs("content2")
	shou=clng(rs("shou"))
	jinbi=rs("jinbi")
	jingyan=rs("jingyan")
	type1=clng(rs("type1"))
	type2=clng(rs("type2"))
	time1=rs("time1")
	time2=rs("time2")
	rs.close
	set rs=nothing

	if type2=2 then call kltool_msge("此申请已操作完毕\n请勿重复操作")
	if type2=3 then call kltool_msge("已经放弃本次申请\n请勿重复操作")
	if type1=0 then call kltool_msge("未审核无法修改")
	if type1=1 then call kltool_msge("审核未通过，无法修改")

	if time2<>"" then time2=-dateDiff("d",time2,now())
		if time2<0 then
		conn.execute("update [uname] set type2=4 where siteid="&siteid&" and userid="&uid&" and id="&id)
		call kltool_msge("已过期的申请无法操作")
		end if
		set rs=server.CreateObject("adodb.recordset")
		rs.open"select * from [user] where siteid="&siteid&" and userid="&uid,conn,1,1
		if rs.eof then call kltool_msge("无此ID")
		name=rs("nickname")
		jin=rs("money")
		yan=rs("expr")
		rs.close
		set rs=nothing
	if inu=1 then
	conn.execute("update [uname] set type2=3 where siteid="&siteid&" and userid="&uid&" and id="&id)
	Response.write"<div class='tip'>你已经成功处理此次申请更改用户名，处理结果为不同意！没有更改用户名！</div>"

	elseif inu=2 then
	conn.execute("update [user] set username='"&nname&"' where siteid="&siteid&" and userid="&uid)
	Response.write"<div class='tip'>你已经成功处理此次申请更改用户名，处理结果为同意！成功更改用户名为"&nname&"！</div>"
	 if shou=2 then
		Response.write"<div class='content'>扣除:"
		if jinbi<>"" then
		conn.execute("update [user] set money=money-"&jinbi&" where siteid="&siteid&" and userid="&uid)
		Response.write""&sitemoneyname&"("&jinbi&")"
		end if
		if jingyan<>"" then
		conn.execute("update [user] set expr=expr-"&jingyan&" where siteid="&siteid&" and userid="&uid)
		Response.write" 经验("&jingyan&")"
		end if
		Response.write" </div>"
	 end if
	 conn.execute("update [uname] set type2=2 where siteid="&siteid&" and userid="&uid&" and id="&id)
	end if

elseif pg="sc" then
	id=request("id")
	if page="" then page=1
	lx=request("lx")
	if kltool_yunxu<>1 then call kltool_msge("没有权限，无法进行删除操作")
	set rs=server.CreateObject("adodb.recordset")
	rs.open"select * from [uname] where siteid="&siteid&" and id="&id,conn,1,3
	if rs.eof then call kltool_msge("无此记录")
	rs.delete
	rs.close
	set rs=nothing
	Response.redirect"?siteid="&siteid&"&page="&page&"&lx="&lx

end if
kltool_end
%>