<!--#include file="../inc/config.asp"-->
<%
kltool_head("柯林工具箱-VIP抽奖后台")
kltool_quanxian
kltool_sql("vip_lx")
kltool_sql("vip_jp")

Response.Write"<div class=""line1""><a href=""?siteid="&siteid&""">抽奖记录</a>/<a href=""?siteid="&siteid&"&pg=jp"">设定奖品</a>/<a href=""?siteid="&siteid&"&pg=sf"">设定身份</a>/<a href=""./index.asp?siteid="&siteid&""">前台查看</a></div>"
pg=request("pg")
if pg="" then
Response.Write"<div class=line1><form method=""post"" action=""?"">"
Response.Write"<input type=""hidden""  name=""siteid"" value="""&siteid&""">"
Response.Write"<input type=""hidden""  name=""lx"" value=""cx"">"
Response.Write"<input type=""text""  name=""uid"" value="""" size=""15"" placeholder=""用户id""><br/>"
Response.Write"<input type=""text"" name=""vyear"" value="""" size=""5"" placeholder="""&year(now)&""">"
Response.Write"<input type=""text"" name=""vmonth"" value="""" placeholder="""&month(now)&""" size=""4"">"
Response.Write"<input type=""text"" name=""vday"" value="""" placeholder="""&day(now)&""" size=""4"">"
Response.Write"<input type=""submit"" value=""查询""></form></div>"
lx=request("lx")
vyear=request("vyear")
vmonth=request("vmonth")
vday=request("vday")
uid=request("uid")
if uid<>"" and not Isnumeric(uid) then response.redirect "?siteid="&siteid&""
if vyear<>"" and not Isnumeric(vyear) then response.redirect "?siteid="&siteid&""
if vmonth<>"" and not Isnumeric(vmonth) then response.redirect "?siteid="&siteid&""
if vday<>"" and not Isnumeric(vday) then response.redirect "?siteid="&siteid&""

set rs=server.CreateObject("adodb.recordset")
if lx="" then
rs.open "select * from [vip_log] order by id desc",conn,1,1

elseif lx="cx" then

 if uid<>"" then
  if vyear<>"" and vmonth="" and vday="" then
rs.open "select * from [vip_log] where userid="&uid&" and year(vtime)="&vyear&" order by id desc",conn,1,1
  elseif vyear<>"" and vmonth<>"" and vday="" then
rs.open "select * from [vip_log] where userid="&uid&" and year(vtime)="&vyear&" and month(vtime)="&vmonth&" order by id desc",conn,1,1
  elseif vyear<>"" and vmonth<>"" and vday<>"" then
rs.open "select * from [vip_log] where userid="&uid&" and year(vtime)="&vyear&" and month(vtime)="&vmonth&" and day(vtime)="&vday&" order by id desc",conn,1,1
  elseif vyear="" and vmonth<>"" and vday<>"" then
rs.open "select * from [vip_log] where userid="&uid&" and month(vtime)="&vmonth&" and day(vtime)="&vday&" order by id desc",conn,1,1
  elseif vyear="" and vmonth="" and vday<>"" then
rs.open "select * from [vip_log] where userid="&uid&" and day(vtime)="&vday&" order by id desc",conn,1,1
  elseif vyear="" and vmonth="" and vday="" then
rs.open "select * from [vip_log] where userid="&uid&" order by id desc",conn,1,1
  elseif vyear="" and vmonth<>"" and vday="" then
rs.open "select * from [vip_log] where userid="&uid&" and  month(vtime)="&vmonth&" order by id desc",conn,1,1
  end if

 elseif uid="" then

  if vyear<>"" and vmonth="" and vday="" then
rs.open "select * from [vip_log] where year(vtime)="&vyear&" order by id desc",conn,1,1
  elseif vyear<>"" and vmonth<>"" and vday="" then
rs.open "select * from [vip_log] where year(vtime)="&vyear&" and month(vtime)="&vmonth&" order by id desc",conn,1,1
  elseif vyear<>"" and vmonth<>"" and vday<>"" then
rs.open "select * from [vip_log] where year(vtime)="&vyear&" and month(vtime)="&vmonth&" and day(vtime)="&vday&" order by id desc",conn,1,1
  elseif vyear="" and vmonth<>"" and vday<>"" then
rs.open "select * from [vip_log] where month(vtime)="&vmonth&" and day(vtime)="&vday&" order by id desc",conn,1,1
  elseif vyear="" and vmonth="" and vday<>"" then
rs.open "select * from [vip_log] where day(vtime)="&vday&" order by id desc",conn,1,1
  elseif vyear="" and vmonth<>"" and vday="" then
rs.open "select * from [vip_log] where month(vtime)="&vmonth&" order by id desc",conn,1,1
  elseif vyear=""and vmonth="" and vday="" then
response.redirect "?siteid="&siteid&""
  end if

 end if

end if

If Not rs.eof then
gopage="?lx="&lx&"&amp;uid="&uid&"&amp;vyear="&vyear&"&amp;vmonth="&vmonth&"&amp;vday="&vday&"&amp;"
	Count=rs.recordcount	
	pagecount=(count+pagesize-1)\pagesize	
	if page>pagecount then page=pagecount
	rs.move(pagesize*(page-1))
call kltool_page(1)
Response.Write"<form name=""formDel"" action="""&gopage&"pg=cjscdx&amp;siteid="&siteid&""" method=""post"">"
	For i=1 To PageSize 
	If rs.eof Then Exit For
if i mod 2 = 0 then Response.Write"<div class=""line2"">" else Response.Write"<div class=""line1"">"
Response.write page*PageSize+i-PageSize&".(<input type=""checkbox"" name=""ids"" value="""&rs("id")&""">)"
Response.write"<a href=""/bbs/userinfo.aspx?siteid="&siteid&"&touserid="&rs("userid")&""">"&kltool_get_usernickname(rs("userid"),1)&"</a>"
Response.write"(<a href=""?siteid="&siteid&"&lx=cx&uid="&rs("userid")&"""><small><small>"&rs("userid")&"</small></small></a>)"
Response.write rs("content")
Response.write"(<small>"&month(rs("vtime"))&"-"&day(rs("vtime"))&" <small>"&hour(rs("vtime"))&"-"&minute(rs("vtime"))&"</small></small>)"
Response.write"</div>"

	rs.movenext
 	Next
Response.write "<div class=tip><span><input type=""checkbox"" name=""all"" onclick=""check_all(this,'ids')"">全选/反选</span> "
Response.write"<input type=""submit"" value=""选择完毕,删除"" onClick=""ConfirmDel('是否确定删除？删除后不能恢复！');return false"">"
Response.write"</form></div>"
call kltool_page(2)
else
   Response.Write"<div class=""tip"">暂时没有抽奖记录！</div>"
end if
rs.close
set rs=nothing
''''''''''''''''''''''''''''''''''''''''''
elseif pg="jp" then
	Response.Write"<div class=""title"">最小值-最大值-是否参与抽奖</div>"
	set rs=server.CreateObject("adodb.recordset")
	rs.open "select top 8 * from [vip_jp]",conn,1,1
	If Not rs.eof Then
		gopage="?pg=jp&amp;"
		Count=rs.recordcount	
		pagecount=(count+pagesize-1)\pagesize	
		if page>pagecount then page=pagecount
		rs.move(pagesize*(page-1))
	call kltool_page(1)
		For i=1 To PageSize
		If rs.eof Then Exit For
	Response.Write"<div class=line2>"&rs("lx")&"."
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
	Response.Write"奖品类型:"&jp&"</div>"
	Response.Write"<form method='post' action='?siteid="&siteid&"&amp;pg=jpxg'>"
	 Response.Write"<div class=line1><input type='text' name='jp1' value='"&rs("jp1")&"' size='6'>"
	 Response.Write"<input type='text' name='jp2' value='"&rs("jp2")&"' size='8'>"

	xy=rs("xy")
	if xy="1" then xyz="显示" else xyz="隐藏"
	 Response.Write"<select name='xy'><option value='"&rs("xy")&"'>"&xyz&"</option><option value='1'>1-显示</option><option value='0'>0-隐藏</option></select>"
	Response.Write"<input type='hidden' name='vid' value='"&rs("lx")&"'>"
	Response.Write"<input type='submit' value='修改' name='submit'></form></div>"

		rs.movenext
		Next
	call kltool_page(2)
	else
	Response.Write"<div class=""tip"">暂时没有奖品类型记录！</div>"
	end if
	rs.close
	set rs=nothing
''''''''''''''''''''''''''''''''''''''''''
elseif pg="jpxg" then
	jp1=request("jp1")
	jp2=request("jp2")
	xy=request("xy")
	vid=request("vid")
	if jp1="" or jp2="" then response.redirect "?siteid="&siteid&"&pg=jp"
	if not Isnumeric(jp1) or not Isnumeric(jp2) then response.redirect "?siteid="&siteid&"&pg=jp"
	set rs=server.CreateObject("adodb.recordset")
	rs.open "select * from [vip_jp] where lx="&vid,conn,1,2
	if rs.eof then response.redirect "?siteid="&siteid&"&pg=jp"
	rs("jp1")=jp1
	rs("jp2")=jp2
	rs("xy")=xy
	rs.update
	rs.close
	set rs=nothing

	vid=clng(request("vid"))
	if vid=1 then
	jpname=""&sitemoneyname&""
	elseif vid=2 then
	jpname="经验"
	elseif vid=3 then
	jpname=""&sitemoneyname&"和经验"
	elseif vid=4 then
	jpname="vip延期(天)"
	elseif vid=5 then
	jpname="在线积时(秒)"
	elseif vid=6 then
	jpname="空间人气"
	elseif vid=7 then
	jpname="人民币(元)"
	elseif vid=8 then
	jpname="银行存款"
	end if
	if xy=1 then jpxy=",启用" else jpxy=",停用"
	call kltool_write_log("(vip每日抽奖)设置:"&jpname&",范围("&jp1&"-"&jp2&")"&jpxy)
	response.redirect "?siteid="&siteid&"&pg=jp"
	''''''''''''''''''''''''''''''''''''''''''
	elseif pg="sf" then
	Response.Write"<form method='post' action='?siteid="&siteid&"'>"
	Response.Write"<input name='pg' type='hidden' value='sftj'>"
	set rs=Server.CreateObject("ADODB.Recordset")
	rs.open "select * from [wap2_smallType] where siteid="&siteid&" and systype='card'",conn,1,1
	Response.Write"<div class=line2>选择:"
	call kltool_get_viplist("vip")
	Response.Write"</select><input type='text'  name='sci' value='' size='15' placeholder='可抽奖次数'>"
	Response.Write"<input type='submit' value='Add'></form>&nbsp;<a href='/bbs/smalltypelist.aspx?siteid="&siteid&"&systype=card'>查看编号</a></div>"


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
	Response.Write"<div class=""line2"">"&rs("svip")&"."&kltool_get_vip(rs("svip"),1)
	Response.Write"[次数:"&rs("sci")&"]-<a href='?siteid="&siteid&"&amp;vip="&rs("svip")&"&amp;pg=sfsc'>del</a>-</div>"
		rs.movenext
		Next
	call kltool_page(2)
	else
	Response.Write"<div class=""tip"">暂时没有身份类型记录！</div>"
	end if
	rs.close
	set rs=nothing
''''''''''''''''''''''''''''''''''''''''''
elseif pg="sftj" then
	vip=clng(request("vip"))
	sci=clng(request("sci"))
	if vip="" or sci="" then call kltool_msge("抽奖次数不能为空")
	set rs=server.CreateObject("adodb.recordset")
	rs.open "select * from [vip_lx] where svip="&vip,conn,1,1
	if not rs.eof then
	conn.Execute("update [vip_lx] set sci="&sci&" where svip="&vip)
	else
	conn.Execute("insert into [vip_lx] (svip,sci)values("&vip&","&sci&")")
	end if
	rs.close
	set rs=nothing
	call kltool_write_log("(vip每日抽奖)设置:vip("&kltool_get_vip(vip,1)&")每日抽奖次数("&sci&")")
	response.redirect "?siteid="&siteid&"&pg=sf"
	''''''''''''''''''''''''''''''''''''''''''
	elseif pg="sfsc" then
	vip=clng(request("vip"))
	set rs=server.CreateObject("adodb.recordset")
	rs.open "select * from [vip_lx] where svip="&vip,conn,1,2
	if rs.eof then call kltool_msge("不存在的记录")
	rs.delete
	rs.close
	set rs=nothing
	call kltool_write_log("(vip每日抽奖)删除:vip("&kltool_get_vip(vip,1)&")抽奖权限")
	response.redirect "?siteid="&siteid&"&pg=sf"

	elseif pg="cjscdx" then
	ids=request("ids")
	conn.Execute("DELETE FROM [vip_log] where id in("&ids&")")
	call kltool_write_log("(vip每日抽奖)删除:抽奖记录("&ids&")")
	response.redirect "?siteid="&siteid
''''''''''''''''''''''''''''''''''''''''''
end if
kltool_end
%>