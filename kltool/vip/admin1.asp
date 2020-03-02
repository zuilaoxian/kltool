<!--#include file="../inc/head.asp"-->
<title>柯林工具箱-Vip自助开通管理后台</title>
<%
call kltool_quanxian
conn.execute("select jinbi,jinyan,xian from [wap2_smallType]")
If Err Then 
err.Clear
call kltool_err_msg("请先安装数据库字段")
end if

Response.write "<div class=""tip""><a href='admin2.asp?siteid="&siteid&"'>vip开通日志查看</a>/<a href='index.asp?siteid="&siteid&"'>前台查看</a></div>"
pg=request("pg")
if pg="" then
set rs=server.CreateObject("adodb.recordset")
rs.open "select * from [wap2_smallType] where siteid="&siteid&" and systype='card'",conn,1,1
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
Response.write "<div class=tip>"&rs("id")&"."&kltool_get_vip(rs("id"),1)&"</div>"
Response.Write "<div class=line1><form method='post' action='?'>"&vbcrlf
Response.Write"<input type='hidden' name='siteid' value='"&siteid&"'>"&vbcrlf
Response.Write"<input type='hidden' name='id' value='"&rs("id")&"'>"&vbcrlf
Response.Write"<input type='hidden' name='pg' value='xg'>"&vbcrlf
Response.Write"<input type='hidden' name='page' value='"&page&"'>"&vbcrlf
Response.Write "　"&sitemoneyname&"<input type='text' name='jin' value='"&rs("jinbi")&"' size='5'>"&vbcrlf
Response.Write "经验<input type='text' name='yan' value='"&rs("jinyan")&"' size='5'>"&vbcrlf
Response.Write "<select name='xian' ><option value='0'"
if rs("xian")=0 then Response.Write " selected"
Response.Write ">不显</option>"&vbcrlf
Response.Write "<option value='1'"
if rs("xian")=1 then Response.Write " selected"
Response.Write ">显示</option></select>"&vbcrlf
Response.Write "<input name='g' type='submit' value='修改' name='submit'></form></div>"&vbcrlf

	rs.movenext
 	Next
call kltool_page(2)
else
   Response.write "<div class=tip>暂时没有记录！</div>"
end if

'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
elseif pg="xg" then
id=request("id")
jin=request("jin")
yan=request("yan")
xian=request("xian")
page=request("page")
if jin<>"" and not Isnumeric(jin) then call kltool_err_msg("必须是数字")
if yan<>"" and not Isnumeric(yan) then call kltool_err_msg("必须是数字")
conn.Execute("update [wap2_smallType] set jinbi='"&jin&"',jinyan='"&yan&"',xian='"&xian&"' where id="&id&" and siteid="&siteid&"")
call kltool_write_log("(vip开通)设置id为"&id&"的vip("&kltool_get_vip(id,1)&")售价为"&jin&sitemoneyname&",经验"&yan)
response.redirect "?siteid="&siteid&"&pgae="&page

end if
call kltool_end
%>