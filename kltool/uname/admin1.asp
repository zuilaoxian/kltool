<!--#include file="../inc/config.asp"-->
<title>柯林工具箱-用户名自助更改插件</title>
<%
call kltool_quanxian
kltool_head("柯林工具箱-用户名自助更改插件")
kltool_sql("uname")

Response.write "<div class=""tip""><a href='index.asp?siteid="&siteid&"'>前台查看</a></div>"
pg=request("pg")
%>
<div class="title"><a href="?siteid=<%=siteid%>&lx=0">全部</a>/<a href="?siteid=<%=siteid%>&lx=1">待审核</a>/<a href="?siteid=<%=siteid%>&lx=2">已审核</a>/<a href="?siteid=<%=siteid%>&lx=3">未更改</a>/<a href="?siteid=<%=siteid%>&lx=4">已更改</a>/<a href="?siteid=<%=siteid%>&lx=5">其他</a></div>
<%
if pg="" then
lx=request("lx")
if lx<>"" then lx=clng(request("lx")) else lx=0
set rs=server.CreateObject("adodb.recordset")
if lx=0 then
rs.open "select * from [uname] where siteid="&siteid&" order by time1 desc",conn,1,1
elseif lx=1 then
rs.open "select * from [uname] where siteid="&siteid&" and type1=0 order by time1 desc",conn,1,1
elseif lx=2 then
rs.open "select * from [uname] where siteid="&siteid&" and type1<>0 order by time1 desc",conn,1,1
elseif lx=3 then
rs.open "select * from [uname] where siteid="&siteid&" and type1=2 and type2=1 order by time1 desc",conn,1,1
elseif lx=4 then
rs.open "select * from [uname] where siteid="&siteid&" and type1=2 and type2=2 order by time1 desc",conn,1,1
elseif lx=5 then
rs.open "select * from [uname] where siteid="&siteid&" and type1=2 and type2<>2 and type2<>0 order by time1 desc",conn,1,1
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
id=rs("id")
uid=rs("userid")
if rs("shou")<>"" then shou=clng(rs("shou"))
oname=rs("oname")
nname=rs("nname")
type1=clng(rs("type1"))
type2=clng(rs("type2"))
content1=rs("content1")
content2=rs("content2")
time1=rs("time1")
time2=rs("time2")
shou=clng(rs("shou"))
jinbi=rs("jinbi")
jingyan=rs("jingyan")
Response.write "<div class=""tip"">"&id&"."&kltool_get_usernickname(uid,1)&"("&uid&")申请更改用户名("
if type1=0 then Response.write"<a href=""?siteid="&siteid&"&amp;pg=kt&amp;id="&id&"&amp;page="&page&"&amp;lx="&lx&""">"
if type1=2 then
Response.write"√"
elseif type1=1 then
Response.write"×"
elseif type1=0 then
Response.write"⊙"
end if
if type1=0 then Response.write"</a>"
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

Response.write"<span class='right'><a href=""?siteid="&siteid&"&amp;id="&id&"&amp;&page="&page&"&amp;lx="&lx&"&amp;pg=sc"" onClick=""ConfirmDel('是否确定？\n删除后不能恢复');return false"">删除</a></span>"

Response.write"</div><div class=""line2"">原用户名:"&oname&"&nbsp;新用户名:"&nname&"</div>"
Response.write"<div class=""line1"">申请时间:"&time1&"</div>"
if content1<>"" then Response.write"<div class=""line2"">申请说明:"&content1&"</div>"
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
	rs.movenext
 	Next
call kltool_page(2)
else
   Response.write "<div class=tip>暂时没有记录！</div>"
end if
rs.close
set rs=nothing

elseif pg="kt" then
id=request("id")
page=request("page")
lx=request("lx")
set rs=server.CreateObject("adodb.recordset")
rs.open"select * from [uname] where siteid="&siteid&" and id="&id,conn,1,1
if rs.eof then call kltool_msge("无此记录")
uid=rs("userid")
oname=rs("oname")
nname=rs("nname")
content=rs("content1")
if content="" then content="无"
time1=rs("time1")
rs.close
set rs=nothing

Response.write"<div class=""tip"">"&id&"."&kltool_get_usernickname(uid,1)&"("&uid&")申请更改用户名</div>"
Response.write"<div class=""line2"">原用户名:"&oname&"&nbsp;新用户名:"&nname&"</div>"
Response.write"<div class=""line1"">申请时间:"&time1&"</div>"
Response.write"<div class=""line2"">申请说明:"&content&"</div>"
Response.Write "<form method='post' action='?'>"
Response.Write "<input type='hidden' name='siteid' value='"&siteid&"'>"
Response.Write "<input type='hidden' name='pg' value='yes'>"
Response.Write "<input type='hidden' name='lx' value='"&lx&"'>"
Response.Write "<input type='hidden' name='uid' value='"&uid&"'>"
Response.Write "<input type='hidden' name='id' value='"&id&"'>"
Response.Write "<input type='hidden' name='page' value='"&page&"'>"
Response.Write "<div class='line2'><select name='type1'><option value='1'>不同意</option><option value='2'>同意</option></select></br>"

Response.Write "原因<textarea name='content' rows='3' type='text'></textarea></div>"
Response.Write "<div class='line1'><select name='shou'><option value='1'>不收费</option><option value='2'>收费</option></select>若收费，请填写数额</br>"
Response.Write "<input type='text' name='jin' value='' size='20' placeholder='TA有"&sitemoneyname&""&kltool_get_usermoney(uid,1)&"'></br>"
Response.Write "<input type='text' name='yan' value='' size='20' placeholder='TA有经验"&kltool_get_usermoney(uid,2)&"'></div>"
Response.Write "<div class='line2'>是否限制使用时间，限制后过期无效，若限制请填写(天数)<br/><input type='text' name='time2' value='' size='20' placeholder=''></br>"
Response.Write "<input type='submit' value='确定' name='g' onClick=""ConfirmDel('是否确定？');return false""></form></div>"

elseif pg="yes" then
id=request("id")
uid=request("uid")
page=request("page")
lx=request("lx")
content=request("content")
type1=clng(request("type1"))
if request("shou")<>"" then shou=clng(request("shou"))
if request("jin")<>"" then jin=clng(request("jin"))
if request("yan")<>"" then yan=clng(request("yan"))
if request("time2")<>"" then time2=clng(request("time2"))
if time2<>"" and not Isnumeric(time2) then call kltool_msge("天数必须是数字")
if shou=2 then
if jin<>"" and not Isnumeric(jin) then call kltool_msge("收费金额请填写数字")
if yan<>"" and not Isnumeric(yan) then call kltool_msge("收费经验请填写数字")
if jin="" and yan="" then call kltool_msge("收费后请填写一项")
end if

set rs=server.CreateObject("adodb.recordset")
rs.open"select * from [uname] where siteid="&siteid&" and id="&id,conn,1,2
if rs.eof then call kltool_msge("无此记录")
rs("type1")=type1
if type1=2 then rs("type2")=1
rs("shou")=shou
if shou=2 then
if jin<>"" then rs("jinbi")=jin
if yan<>"" then rs("jingyan")=yan
end if
if content<>"" then rs("content2")=content
if time2<>"" then
time2=dateAdd("d",time2,now())
rs("time2")=time2
end if
rs.update
rs.close
set rs=nothing
if type1=1 then
mm="不同意"
elseif type1=2 then
mm="同意"
end if
conn.execute("insert into [wap_message](siteid,userid,nickname,title,content,touserid,isnew,issystem,addtime)values('"&siteid&"','"&siteid&"','系统','来自用户名更改系统的处理信息','您的用户名申请已经处理，处理结果为:"&mm&"！请[url="&kltool_path&"uname/index.asp?siteid=[siteid]&lx=my]前往查看[/url]','"&uid&"','1','1','"&date()&" "&time()&"')")

Response.Write"<div class='tip'>处理成功<a href='?siteid="&siteid&"&amp;lx="&lx&"&amp;page="&page&"'>返回</a></div>"


elseif pg="sc" then
id=request("id")
page=request("page")
if page="" then page=1
lx=request("lx")
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