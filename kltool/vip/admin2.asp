<!--#include file="../inc/config.asp"-->
<%
kltool_head("柯林工具箱-vip开通记录")
kltool_quanxian
kltool_sql("wap2_smallType_log")

Response.Write "<div class=tip><a href='admin1.asp?siteid="&siteid&"'>vip管理后台</a>/<a href='index.asp?siteid="&siteid&"'>前台查看</a></div>"
pg=request("pg")
if pg="" then
Response.Write "<div class=line1><form method='post' action='?'><input type='hidden'  name='siteid' value='"&siteid&"'><input type='hidden'  name='lx' value='cx'>"
Response.Write "<input type='text'  name='uid' value='' size='15' placeholder='用户id'><br/>"
Response.Write "<input type='text' name='vyear' value='' size='5' placeholder='"&year(now)&"'><input type='text' name='vmonth' value='' placeholder='"&month(now)&"' size='4'><input type='text' name='vday' value='' placeholder='"&day(now)&"' size='4'>"
Response.Write "<input type='submit' value='查询'></form></div>"
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
rs.open "select * from [wap2_smallType_log] order by id desc",conn,1,1

elseif lx="cx" then

 if uid<>"" then
  if vyear<>"" and vmonth="" and vday="" then
rs.open "select * from [wap2_smallType_log] where userid="&uid&" and year(vtime)="&vyear&" order by id desc",conn,1,1
  elseif vyear<>"" and vmonth<>"" and vday="" then
rs.open "select * from [wap2_smallType_log] where userid="&uid&" and year(vtime)="&vyear&" and month(vtime)="&vmonth&" order by id desc",conn,1,1
  elseif vyear<>"" and vmonth<>"" and vday<>"" then
rs.open "select * from [wap2_smallType_log] where userid="&uid&" and year(vtime)="&vyear&" and month(vtime)="&vmonth&" and day(vtime)="&vday&" order by id desc",conn,1,1
  elseif vyear="" and vmonth<>"" and vday<>"" then
rs.open "select * from [wap2_smallType_log] where userid="&uid&" and month(vtime)="&vmonth&" and day(vtime)="&vday&" order by id desc",conn,1,1
  elseif vyear="" and vmonth="" and vday<>"" then
rs.open "select * from [wap2_smallType_log] where userid="&uid&" and day(vtime)="&vday&" order by id desc",conn,1,1
  elseif vyear="" and vmonth="" and vday="" then
rs.open "select * from [wap2_smallType_log] where userid="&uid&" order by id desc",conn,1,1
  elseif vyear="" and vmonth<>"" and vday="" then
rs.open "select * from [wap2_smallType_log] where userid="&uid&" and  month(vtime)="&vmonth&" order by id desc",conn,1,1
  end if

 elseif uid="" then

  if vyear<>"" and vmonth="" and vday="" then
rs.open "select * from [wap2_smallType_log] where year(vtime)="&vyear&" order by id desc",conn,1,1
  elseif vyear<>"" and vmonth<>"" and vday="" then
rs.open "select * from [wap2_smallType_log] where year(vtime)="&vyear&" and month(vtime)="&vmonth&" order by id desc",conn,1,1
  elseif vyear<>"" and vmonth<>"" and vday<>"" then
rs.open "select * from [wap2_smallType_log] where year(vtime)="&vyear&" and month(vtime)="&vmonth&" and day(vtime)="&vday&" order by id desc",conn,1,1
  elseif vyear="" and vmonth<>"" and vday<>"" then
rs.open "select * from [wap2_smallType_log] where month(vtime)="&vmonth&" and day(vtime)="&vday&" order by id desc",conn,1,1
  elseif vyear="" and vmonth="" and vday<>"" then
rs.open "select * from [wap2_smallType_log] where day(vtime)="&vday&" order by id desc",conn,1,1
  elseif vyear="" and vmonth<>"" and vday="" then
rs.open "select * from [wap2_smallType_log] where month(vtime)="&vmonth&" order by id desc",conn,1,1
  elseif vyear=""and vmonth="" and vday="" then
response.redirect "?siteid="&siteid&""
  end if

 end if

end if
If Not rs.eof Then
	gopage="?lx="&lx&"&amp;uid="&uid&"&amp;vyear="&vyear&"&amp;vmonth="&vmonth&"&amp;vday="&vday&"&amp;"
	Count=rs.recordcount
	pagecount=(count+pagesize-1)\pagesize
	if page>pagecount then page=pagecount
	rs.move(pagesize*(page-1))
call kltool_page(1)
Response.Write"<form name=""formDel"" action="""&gopage&"pg=del&amp;siteid="&siteid&""" method=""post"">"
	For i=1 To PageSize
	If rs.eof Then Exit For
lx=clng(rs("lx"))
if lx=1 then
clx="开通"
elseif lx=2 then
clx="续期"
elseif lx=3 then
clx="解除"
end if

if i mod 2 = 0 then response.write"<div class=""line1"">" else response.write"<div class=""line2"">"
Response.write page*PageSize+i-PageSize&".(<input type=""checkbox"" name=""ids"" value="""&rs("id")&""">)"
Response.write kltool_get_usernickname(rs("userid"),1)
if lx<>3 then
Response.write clx&"了"&rs("yue")&"个月VIP("&kltool_get_vip(rs("vip"),1)&")(<small><small>"&month(rs("vtime"))&"-"&day(rs("vtime"))&"&nbsp;"&hour(rs("vtime"))&":"&minute(rs("vtime"))&"</small></small>)(花费"&rs("jin")&sitemoneyname&"/"&rs("yan")&"经验)"
else
Response.write clx&"了VIP(<small>"&month(rs("vtime"))&"-"&day(rs("vtime"))&"&nbsp;"&hour(rs("vtime"))&":"&minute(rs("vtime"))&"</small></small>)"
end if
Response.write"</div>"
	rs.movenext
 	Next
Response.write "<div class=tip><span><input type=""checkbox"" name=""all"" onclick=""check_all(this,'ids')"">全选/反选</span> "
Response.write"<input type=""submit"" value=""选择完毕,删除"" onClick=""ConfirmDel('是否确定删除？删除后不能恢复！');return false"">"
Response.write"</form></div>"
call kltool_page(2)
else
response.write"<div class=tip>暂无记录！</div>"
end if
rs.close
set rs=nothing


elseif pg="del" then
	ids=request("ids")
	conn.Execute("DELETE FROM [wap2_smallType_log] where id in("&ids&")")
	call kltool_write_log("(vip开通)删除了vip开通日志:"&ids&"")
	response.redirect "?siteid="&siteid&""

end if
kltool_end
%>