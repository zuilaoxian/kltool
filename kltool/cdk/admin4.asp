<!--#include file="../inc/head.asp"-->
<title>柯林工具箱-cdk商城购买记录</title>
<%call kltool_quanxian
conn.execute("select * from [cdk]")
If Err Then 
err.Clear
call kltool_err_msg("请先安装数据库字段")
end if
Response.Write "<div class=tip><a href='admin1.asp?siteid="&siteid&"'>管理后台</a></div>"
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
rs.open "select * from [cdk_log] order by id desc",conn,1,1

elseif lx="cx" then

 if uid<>"" then
  if vyear<>"" and vmonth="" and vday="" then
rs.open "select * from [cdk_log] where userid="&uid&" and year(ltime)="&vyear&" order by id desc",conn,1,1
  elseif vyear<>"" and vmonth<>"" and vday="" then
rs.open "select * from [cdk_log] where userid="&uid&" and year(ltime)="&vyear&" and month(ltime)="&vmonth&" order by id desc",conn,1,1
  elseif vyear<>"" and vmonth<>"" and vday<>"" then
rs.open "select * from [cdk_log] where userid="&uid&" and year(ltime)="&vyear&" and month(ltime)="&vmonth&" and day(ltime)="&vday&" order by id desc",conn,1,1
  elseif vyear="" and vmonth<>"" and vday<>"" then
rs.open "select * from [cdk_log] where userid="&uid&" and month(ltime)="&vmonth&" and day(ltime)="&vday&" order by id desc",conn,1,1
  elseif vyear="" and vmonth="" and vday<>"" then
rs.open "select * from [cdk_log] where userid="&uid&" and day(ltime)="&vday&" order by id desc",conn,1,1
  elseif vyear="" and vmonth="" and vday="" then
rs.open "select * from [cdk_log] where userid="&uid&" order by id desc",conn,1,1
  elseif vyear="" and vmonth<>"" and vday="" then
rs.open "select * from [cdk_log] where userid="&uid&" and  month(ltime)="&vmonth&" order by id desc",conn,1,1
  end if

 elseif uid="" then

  if vyear<>"" and vmonth="" and vday="" then
rs.open "select * from [cdk_log] where year(ltime)="&vyear&" order by id desc",conn,1,1
  elseif vyear<>"" and vmonth<>"" and vday="" then
rs.open "select * from [cdk_log] where year(ltime)="&vyear&" and month(ltime)="&vmonth&" order by id desc",conn,1,1
  elseif vyear<>"" and vmonth<>"" and vday<>"" then
rs.open "select * from [cdk_log] where year(ltime)="&vyear&" and month(ltime)="&vmonth&" and day(ltime)="&vday&" order by id desc",conn,1,1
  elseif vyear="" and vmonth<>"" and vday<>"" then
rs.open "select * from [cdk_log] where month(ltime)="&vmonth&" and day(ltime)="&vday&" order by id desc",conn,1,1
  elseif vyear="" and vmonth="" and vday<>"" then
rs.open "select * from [cdk_log] where day(ltime)="&vday&" order by id desc",conn,1,1
  elseif vyear="" and vmonth<>"" and vday="" then
rs.open "select * from [cdk_log] where month(ltime)="&vmonth&" order by id desc",conn,1,1
  elseif vyear=""and vmonth="" and vday="" then
response.redirect "?siteid="&siteid&""
  end if

 end if

end if
If Not rs.eof Then
	PageSize=10
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
lx=rs("lx")
if lx="1" then
clx=""&sitemoneyname&""
elseif lx="2" then
clx="经验"
elseif lx="3" then
clx=""&sitemoneyname&"+经验"
elseif lx="4" then
clx="vip"
elseif lx="5" then
clx="积时"
elseif lx="6" then
clx="勋章"
end if

if i mod 2 = 0 then response.write"<div class=""line1"">" else response.write"<div class=""line2"">"
response.write page*PageSize+i-PageSize&"."
response.write"(<input type=""checkbox"" name=""ids"" value="""&rs("id")&""">)"
response.write kltool_get_usernickname(rs("userid"),1)&"("&rs("userid")&")"
	mytime=DateDiff("n",rs("ltime"),now())
	if mytime<60 then
response.write mytime&"分钟前购买了<font color=""#FF2D2D"">"&clx&"</font>cdk"
else
response.write"购买了<font color=""#FF2D2D"">"&clx&"</font>cdk(<small><small>"&month(rs("ltime"))&"-"&day(rs("ltime"))&"&nbsp;"&hour(rs("ltime"))&":"&minute(rs("ltime"))&"</small></small>)(花费"&rs("jia")&sitemoneyname&")"
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

'-----
elseif pg="del" then
ids=request("ids")
conn.Execute("DELETE FROM [cdk_log] where id in("&ids&")")
call kltool_write_log("(cdk商城)删除购买记录："&ids)
response.redirect "?siteid="&siteid&""

end if
call kltool_end
%>