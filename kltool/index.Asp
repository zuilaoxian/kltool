<!--#include file="inc/config.asp"-->
<%
kltool_head("柯林工具箱")
kltool_quanxian
pg=Request("pg")
if pg="" then
set rs=server.CreateObject("adodb.recordset")
rs.open "select * from [kltool] where kltool_show=1 order by kltool_order",kltool,1,1
If Not rs.eof Then
	gopage="?"
	Count=rs.recordcount	
	pagecount=(count+pagesize-1)\pagesize	
	if page>pagecount then page=pagecount
	rs.move(pagesize*(page-1))
call kltool_page(1)
	For i=1 To PageSize 
	If rs.eof Then Exit For
if (i mod 2)=0 then Response.write "<div class=""line2"">" else Response.write "<div class=""line1"">"
Response.write page*PageSize+i-PageSize&"."
Response.write"<a href=""?siteid="&siteid&"&pg=action&page="&page&"&id="&rs("id")&""">"&rs("kltool_name")&"</a>"
Response.write "</div>"
	rs.movenext
	Next
call kltool_page(2)
	else
	Response.write"<div class=""tip"">暂时没有记录！</div>"
	end if
rs.close
set rs=nothing
'-----
elseif pg="action" then
id=request("id")
Response.write"<div class='tip'><button onclick='display(pic1);return false;'>新增功能</button>"
Response.write"<a href='"&kltool_path&"admin/admin1.asp'>功能排序</a>"
if id<>"" and Isnumeric(id) then Response.write"<span class='right'><button onclick='display(pic2);return false;'>修改此功能</button></span>"
Response.write"</div>"

if id<>"" and Isnumeric(id) then
set rs=server.CreateObject("adodb.recordset")
rs.open "select * from [kltool] where id="&id,kltool,1,1
if not rs.eof then
Response.write kltool_code(rs("kltool_title"))
Response.write kltool_code(rs("kltool_content"))
Response.write"<span id='pic2' style='display:none'>"
Response.Write"<div class=content>"
Response.Write"<form method='post' action='?'>"
Response.Write"<input type='hidden' name='siteid' value='"&siteid&"'>"
Response.Write"<input type='hidden' name='pg' value='yes'>"
Response.Write"<input type='hidden' name='action' value='2'>"
Response.write"<input type='hidden' name='id' value='"&id&"' size='18'/>"
Response.write"名称<input type='text' name='k1' value='"&rs("kltool_name")&"' size='18'/><br/>"
Response.Write"功能<textarea name='k2' rows='5'>"&rs("kltool_title")&"</textarea><br/>"
Response.Write"介绍<textarea name='k3' rows='5'>"&rs("kltool_content")&"</textarea><br/>"
Response.write"<select name='k4'>"
Response.write"<option value='"&rs("kltool_show")&"'>"&rs("kltool_show")&"</option>"
Response.write"<option value='1'>1-显示</option>"
Response.write"<option value='2'>2-隐藏</option>"
Response.write"</select>"
Response.Write"<input type='submit' value='修改' name='submit' onClick=""ConfirmDel('是否确定？');return false""></form>"
Response.Write"</div></span>"
end if
rs.close
set rs=nothing
end if
Response.write"<span id='pic1' style='display:none'>"
Response.write"<div class=""content"">"
Response.Write"<form method='post' action='?'>"
Response.Write"<input type='hidden' name='siteid' value='"&siteid&"'>"
Response.Write"<input type='hidden' name='pg' value='yes'>"
Response.Write"<input type='hidden' name='action' value='1'>"
Response.Write"功能名称<input type='text' name='k1' value=''><br/>"
Response.Write"功能标题<textarea name='k2' rows='5'></textarea><br/>"
Response.Write"功能介绍<textarea name='k3' rows='5'></textarea><br/>"
Response.write"<select name='k4'><option value='1'>显示</option><option value='2'>隐藏</option></select>"
Response.Write"<input type='submit' value='新增功能' name='g' onClick='ConfirmDel('是否确定？');return false'></form>"
Response.Write"</div></span>"
'-----
elseif pg="yes" then
id=request("id")
if page="" then page=1
action=request("action")
k1=request("k1")
k2=request("k2")
k3=request("k3")
k4=request("k4")

if action="1" then
sql="select * from [kltool]"
else
sql="select * from [kltool] where id="&id
end if
set rs=server.CreateObject("adodb.recordset")
rs.open sql,kltool,1,2
if action="1" then rs.addnew
rs("kltool_name")=k1
rs("kltool_title")=k2
rs("kltool_content")=k3
rs("kltool_show")=k4
rs.update
rs.close
set rs=nothing
if action="1" then call kltool_write_log("(功能)添加:"&k1) else call kltool_write_log("(功能)修改:"&k1)
kltool_msg("成功")
end if
kltool_end
%>