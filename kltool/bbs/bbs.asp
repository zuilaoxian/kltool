<!--#include file="../inc/head.asp"-->
<title>柯林工具箱-贴子带专题发布通道</title>
<%
call kltool_quanxian
pg=request("pg")
if pg="" then
Response.Write "<form method=""post"" action=""?"">"&vbcrlf
Response.Write "<input name=""siteid"" type=""hidden"" value="""&siteid&""">"&vbcrlf
Response.Write "<input name=""pg"" type=""hidden"" value=""yes"">"&vbcrlf
Response.Write "<div class=""line1"">帖子标题：</div>"&vbcrlf
Response.Write "<div class=""line2""><textarea name=""title"" rows=""5"" value=""""></textarea></div>"&vbcrlf
Response.Write "<div class=""line1"">帖子内容：</div>"&vbcrlf
Response.Write "<div class=""line2""><textarea name=""content"" rows=""10"" value=""""></textarea></div>"&vbcrlf
Response.Write "<div class=""line1"">选择论坛：</div>"&vbcrlf
'-----
set rs=server.CreateObject("adodb.recordset")
rs.open "select * from [class] where userid="&siteid&" and typeid=16",conn,1,1
Response.write "<div class=""line2""><select name=""classid"">"&vbcrlf
If rs.eof and rs.bof Then
Response.Write "<option value="""">请先添加论坛</option>"&vbcrlf
else
For i=1 To rs.recordcount
If rs.eof Then Exit For
Response.Write "<option value="""&rs("classid")&""">"&rs("classid")&"-"&rs("classname")&"</option>" &vbcrlf
rs.movenext
Next
end if
rs.close
set rs=nothing
Response.Write "</select></div>"&vbcrlf
Response.Write "<div class=line1>选择专题：</div>"&vbcrlf
set rs=server.CreateObject("adodb.recordset")
rs.open "select * from [wap2_smallType] where siteid="&siteid&" and systype like '%bbs%'",conn,1,1
Response.write "<div class=""line2""><select name=""topic"">"&vbcrlf
If rs.eof and rs.bof Then
Response.Write "<option value="""">请先添加专题</option>"&vbcrlf
else
For i=1 To rs.recordcount
If rs.eof Then Exit For
Response.Write "<option value='"&rs("id")&"'>"&rs("systype")&"-"&rs("subclassName")&"</option>"&vbcrlf
rs.movenext
Next
end if
rs.close
set rs=nothing

Response.Write "</select></div>"
Response.Write "<input name=""author"" type=""hidden"" value="""&nickname&""">"&vbcrlf
Response.Write "<input name=""pub"" type=""hidden"" value="""&userid&""">"&vbcrlf
Response.Write "<div class=""line1""><input name=""g"" type=""submit"" value=""马上增加"">"&vbcrlf
Response.Write "</form></div>"

'----
elseif pg="yes" then
title=request("title")
content=request("content")
classid=request("classid")
topic=request("topic")
author=request("author")
pub=request("pub")

if title="" then call kltool_err_msg("标题不能为空")
if content="" then call kltool_err_msg("内容不能为空")
if pub="" then call kltool_err_msg("作者不能为空")
if classid="" then call kltool_err_msg("请选择一个论坛")

set rs=Server.CreateObject("ADODB.Recordset")
rs.open"select * from [wap_bbs]",conn,1,2
rs.addnew
rs("book_title")=title
rs("book_content")=content
rs("book_classid")=classid
if topic<>"" then rs("topic")=topic
rs("userid")=siteid
rs("book_author")=author
rs("book_pub")=pub
rs.update
rs.close
set rs=nothing
call kltool_write_log("(帖子发布)新增帖子："&title)
Response.Write "<div class=tip>帖子:"&title&"，发表成功。<a href=""./bbs1.asp?siteid="&siteid&""">进入帖子管理</a></div>"
end if

call kltool_end
%>