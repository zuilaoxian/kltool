<!--#include file="../inc/head.asp"-->
<title>柯林工具箱-网站币互转-后台</title>
<%call kltool_quanxian
conn.execute("select * from [money_set]")
If Err Then 
err.Clear
call kltool_err_msg("请先安装数据库字段")
end if
Response.Write "<div class=tip>兑换比例(无vip或无匹配vip时)</div>"
Response.Write "<div class=content><form method='post' action='?'>"
Response.Write "<input name='siteid' type='hidden' value='"&siteid&"'>"
Response.Write "<input name='pg' type='hidden' value='cz1'>"
set rs=Server.CreateObject("ADODB.Recordset")
rs.open "select * from [money_set] where id=1",conn,1,1
Response.Write "<input type='text'  name='m1' value='' size='10' placeholder='"&rs("jin1")&"'>"
Response.Write "<input type='text'  name='m2' value='' size='10' placeholder='"&rs("jin2")&"'>"
Response.Write "<input type='submit' value='确定修改'></form></div>"
rs.close
set rs=nothing

Response.write "<div class=""tip""><a href='admin2.asp?siteid="&siteid&"'>转换日志查看</a>/<a href='index.asp?siteid="&siteid&"'>前台查看</a></div>"
pg=request("pg")
if pg="" then

Response.Write "<form method='post' action='?'>"
Response.Write "<input name='siteid' type='hidden' value='"&siteid&"'>"
Response.Write "<input name='pg' type='hidden' value='cz'>"
Response.write "<div class=line2>选择:"
call kltool_get_viplist("vip")
Response.Write "<input type='text'  name='m1' value='' size='15' placeholder='金币兑换RMB比例'>"
Response.Write "<input type='text'  name='m2' value='' size='15' placeholder='RMB兑换金币比例'><br/>"
Response.Write "<input type='submit' value='提交'></form>金币兑换RMB比例建议使用整数，小数会五舍</div>"

set rs=server.CreateObject("adodb.recordset")
rs.open "select * from [money_set] where id<>1",conn,1,1
If Not rs.eof Then
	gopage="?"
	Count=rs.recordcount
	page=int(request("page"))
	if page<=0 or page="" then page=1
	pagecount=(count+pagesize-1)\pagesize
	if page>pagecount then page=pagecount
	rs.move(pagesize*(page-1))
call kltool_page(1)
	For i=1 To PageSize
	If rs.eof Then Exit For
Response.write "<div class=tip>"&rs("vip")&"."&kltool_get_vip(rs("vip"),1)
Response.Write "</div><div class=line2>("&rs("jin1")&")/("&rs("jin2")&")(<a href='?siteid="&siteid&"&amp;pg=del&amp;vip="&rs("vip")&"' onClick=""ConfirmDel('是否确定？');return false"">del</a>)</div>"
	rs.movenext
 	Next
call kltool_page(2)
else
   Response.write "<div class=tip>暂时没有记录！</div>"
end if
rs.close
set rs=nothing
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
elseif pg="cz" then
vip=request("vip")
m1=request("m1")
m2=request("m2")
set rs=server.CreateObject("adodb.recordset")
rs.open "select * from [money_set] where vip="&clng(vip),conn,1,2
if rs.eof then rs.addnew
rs("vip")=vip
rs("jin1")=m1
rs("jin2")=m2
rs.update
rs.close
set rs=nothing
call kltool_write_log("(网站币互转)设置了ID为"&vip&"的vip("&kltool_get_vip(vip,1)&")的转换价格("&m1&":"&m2&")")
response.redirect "?siteid="&siteid
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
elseif pg="cz1" then
m1=request("m1")
m2=request("m2")
set rs=server.CreateObject("adodb.recordset")
rs.open "select * from [money_set] where id=1",conn,1,2
rs("jin1")=m1
rs("jin2")=m2
rs.update
rs.close
set rs=nothing
call kltool_write_log("(网站币互转)设置了无vip或无匹配vip时的转换价格("&m1&":"&m2&")")
response.redirect "?siteid="&siteid
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
elseif pg="del" then
vip=request("vip")
set rs=server.CreateObject("adodb.recordset")
rs.open "select * from [money_set] where vip="&vip,conn,1,2
rs.delete
rs.close
set rs=nothing
call kltool_write_log("(网站币互转)删除了ID为"&vip&"的vip("&kltool_get_vip(vip,1)&")的转换价格")
response.redirect "?siteid="&siteid


end if
call kltool_end
%>