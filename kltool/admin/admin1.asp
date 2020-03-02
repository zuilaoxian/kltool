<!--#include file="../inc/head.asp"-->
<title>柯林工具箱-功能管理</title>
<%
call kltool_quanxian
	set rs=server.CreateObject("adodb.recordset")
	rs.open "select * from [kltool]",kltool,1,1
	If Not rs.eof Then
Response.Write"<form method='post' action='?'>"
Response.Write"<input type='hidden' name='siteid' value='"&siteid&"'>"
Response.Write"<input type='hidden' name='pg' value='xg'>"
	For i=1 To rs.recordcount
	If rs.eof Then Exit For
Response.write"<div class=""line1"">"
Response.write"<a href="""&kltool_path&"index.asp?siteid="&siteid&"&pg=action&page="&page&"&id="&rs("id")&""">"&rs("kltool_name")&"</a>"
Response.Write"<span class='right'>排序号<input type='text' name='k1' value='"&rs("kltool_order")&"' size='5'>"
Response.write"显隐<select name='k2'>"
Response.write"<option value='1'"
if rs("kltool_show")="1" then Response.write" selected"
Response.write">显示</option>"
Response.write"<option value='2'"
if rs("kltool_show")="2" then Response.write" selected"
Response.write">隐藏</option>"
Response.write"</select></span></div>"
	rs.movenext
 	Next
Response.Write"<input type='submit' value='确定' name='g' onClick='ConfirmDel('是否确定？');return false'></form>"
else
Response.write"<div class=tip>暂时没有记录！</div>"
end if
	rs.close
	set rs=nothing
'-----
pg=request("pg")
'-----
if pg="xg" then
k1=request("k1")
k2=request("k2")
k1=replace(k1,chr(32),"")
k2=replace(k2,chr(32),"")
k1_Split=Split(k1,",")
k2_Split=Split(k2,",")

set rs=server.CreateObject("adodb.recordset")
rs.open "select * from [kltool]",kltool,1,1
	for i=1 to rs.recordcount
	count=count&rs("id")&","
	rs.movenext
	Next
rs.close
set rs=nothing
count_Split=Split(count,",")

for i=0 to ubound(count_Split)
if count_Split(i)<>"" and Isnumeric(count_Split(i)) then
set rs=server.CreateObject("adodb.recordset")
rs.open "select * from [kltool] where id="&count_Split(i),kltool,1,2
	if not rs.bof then
	rs("kltool_order")=k1_Split(i)
	rs("kltool_show")=k2_Split(i)
	rs.update
	end if
rs.close
set rs=nothing
end if
next
call kltool_write_log("(功能)排序显隐管理")
call kltool_err_msg("成功")
end if

call kltool_end
%>