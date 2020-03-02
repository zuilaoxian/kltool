<!--#include file="../inc/head.asp"-->
<title>柯林工具箱-网站币互转-记录</title>
<%call kltool_quanxian
conn.execute("select * from [money_log]")
If Err Then 
err.Clear
call kltool_err_msg("请先安装数据库字段")
end if
Response.Write "<div class=tip><a href='admin1.asp?siteid="&siteid&"'>管理后台</a>/<a href='index.asp?siteid="&siteid&"'>前台查看</a></div>"
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
rs.open "select * from [money_log] order by id desc",conn,1,1

elseif lx="cx" then

 if uid<>"" then
  if vyear<>"" and vmonth="" and vday="" then
rs.open "select * from [money_log] where userid="&uid&" and year(mtime)="&vyear&" order by id desc",conn,1,1
  elseif vyear<>"" and vmonth<>"" and vday="" then
rs.open "select * from [money_log] where userid="&uid&" and year(mtime)="&vyear&" and month(mtime)="&vmonth&" order by id desc",conn,1,1
  elseif vyear<>"" and vmonth<>"" and vday<>"" then
rs.open "select * from [money_log] where userid="&uid&" and year(mtime)="&vyear&" and month(mtime)="&vmonth&" and day(mtime)="&vday&" order by id desc",conn,1,1
  elseif vyear="" and vmonth<>"" and vday<>"" then
rs.open "select * from [money_log] where userid="&uid&" and month(mtime)="&vmonth&" and day(mtime)="&vday&" order by id desc",conn,1,1
  elseif vyear="" and vmonth="" and vday<>"" then
rs.open "select * from [money_log] where userid="&uid&" and day(mtime)="&vday&" order by id desc",conn,1,1
  elseif vyear="" and vmonth="" and vday="" then
rs.open "select * from [money_log] where userid="&uid&" order by id desc",conn,1,1
  elseif vyear="" and vmonth<>"" and vday="" then
rs.open "select * from [money_log] where userid="&uid&" and  month(mtime)="&vmonth&" order by id desc",conn,1,1
  end if

 elseif uid="" then

  if vyear<>"" and vmonth="" and vday="" then
rs.open "select * from [money_log] where year(mtime)="&vyear&" order by id desc",conn,1,1
  elseif vyear<>"" and vmonth<>"" and vday="" then
rs.open "select * from [money_log] where year(mtime)="&vyear&" and month(mtime)="&vmonth&" order by id desc",conn,1,1
  elseif vyear<>"" and vmonth<>"" and vday<>"" then
rs.open "select * from [money_log] where year(mtime)="&vyear&" and month(mtime)="&vmonth&" and day(mtime)="&vday&" order by id desc",conn,1,1
  elseif vyear="" and vmonth<>"" and vday<>"" then
rs.open "select * from [money_log] where month(mtime)="&vmonth&" and day(mtime)="&vday&" order by id desc",conn,1,1
  elseif vyear="" and vmonth="" and vday<>"" then
rs.open "select * from [money_log] where day(mtime)="&vday&" order by id desc",conn,1,1
  elseif vyear="" and vmonth<>"" and vday="" then
rs.open "select * from [money_log] where month(mtime)="&vmonth&" order by id desc",conn,1,1
  elseif vyear=""and vmonth="" and vday="" then
response.redirect "?siteid="&siteid&""
  end if

 end if

end if
If Not rs.eof Then
gopage="?lx="&lx&"&amp;uid="&uid&"&amp;vyear="&vyear&"&amp;vmonth="&vmonth&"&amp;vday="&vday&"&amp;"
	Count=rs.recordcount
	page=int(request("page"))
	if page<=0 or page="" then page=1
	pagecount=(count+pagesize-1)\pagesize
	if page>pagecount then page=pagecount
	rs.move(pagesize*(page-1))
call kltool_page(1)
response.write"<form name=""formDel"" action="""&gopage&"pg=del&amp;siteid="&siteid&""" method=""post"">"
	For i=1 To PageSize
	If rs.eof Then Exit For
set rs1=server.CreateObject("adodb.recordset")
rs1.open "select nickname from [user] where userid="&rs("userid"),conn,1,1
If Not rs1.eof Then
name=rs1("nickname")
end if
rs1.close
set rs1=nothing
if i mod 2 = 0 then response.write"<div class=""line1"">" else response.write"<div class=""line2"">"
response.write page*PageSize+i-PageSize&".(<input type=""checkbox"" name=""ids"" value="""&rs("id")&""">)"
response.write kltool_get_usernickname(rs("userid"),1)&"("&rs("userid")&")兑换了"
if rs("lx")="1" then
response.write rs("jin1")&"RMB(<small><small>"&month(rs("mtime"))&"-"&day(rs("mtime"))&"&nbsp;"&hour(rs("mtime"))&":"&minute(rs("mtime"))&"</small></small>)(花费"&rs("jin2")&sitemoneyname&")"
elseif rs("lx")="2" then
response.write rs("jin1")&sitemoneyname&"(<small><small>"&month(rs("mtime"))&"-"&day(rs("mtime"))&"&nbsp;"&hour(rs("mtime"))&":"&minute(rs("mtime"))&"</small></small>)(花费"&rs("jin2")&"RMB)"
end if
response.write"</div>"
	rs.movenext
 	Next
Response.write "<div class=tip><span><input type=""checkbox"" name=""all"" onclick=""check_all(this,'ids')"">全选/反选</span> "
response.write"<input type=""submit"" value=""选择完毕,删除"" onClick=""ConfirmDel('是否确定删除？删除后不能恢复！');return false"">"
response.write"</form></div>"
call kltool_page(2)
else
response.write"<div class=tip>暂无记录！</div>"
end if
rs.close
set rs=nothing


elseif pg="del" then
ids=request("ids")
conn.Execute("DELETE FROM [money_log] where id in("&ids&")")
call kltool_write_log("(网站币互转)删除了转换记录:"&ids)
response.redirect "?siteid="&siteid&""

end if
call kltool_end
%>