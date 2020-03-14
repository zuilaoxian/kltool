<!--#include file="../inc/config.asp"-->
<%
kltool_head("柯林工具箱-回复语设置")
kltool_quanxian
	pg=Request.QueryString("pg")
	content=Request.QueryString("content")
	xy=Request.QueryString("xy")
	id=Request.QueryString("id")
if pg="" then
	Response.write"<div class=""tip"">"
	Response.write"<form method=""get"" action=""?"">"&vbcrlf
	Response.write"<input name=""siteid"" type=""hidden"" value="""&siteid&""">"&vbcrlf
	Response.write"<input name=""pg"" type=""hidden"" value=""tj"">"&vbcrlf
	Response.write"<textarea name=""content"" rows=""3"" type=""text"" value="""" placeholder=""新增一条回复语!""></textarea><br/>"&vbcrlf
	Response.write"<select name=""xy""><option value=""1"">启用</option><option value=""2"">停用</option></select>"
	Response.write"<input name=""g"" type=""submit"" value=""确定添加"">"&vbcrlf&"<span class=""right""><a href=""bbs1.asp?siteid="&siteid&""">返回帖子管理</a></span></form></div>"&vbcrlf
	'-----
	set rs=server.CreateObject("adodb.recordset")
	rs.open "select * from [kltool_re] order by id desc",kltool,1,1
	If Not rs.eof Then
		gopage="?"
		Count=rs.recordcount
		pagecount=(count+pagesize-1)\pagesize	
		if page>pagecount then page=pagecount
		rs.move(pagesize*(page-1))
	call kltool_page(1)
		For i=1 To PageSize
		If rs.eof Then Exit For
	if (i mod 2)=0 then Response.write"<div class=line1>" else Response.write"<div class=line2>"
	if clng(rs("xy"))=1 then xy="√" else xy="×"
	Response.write"(<a href='"&gopage&"siteid="&siteid&"&amp;pg=xy&amp;id="&rs("id")&"&amp;page="&page&"'>"&xy&"</a>)"
	Response.write""&page*PageSize+i-PageSize&"."&rs("content")&"<span class='right'><a href='"&gopage&"siteid="&siteid&"&amp;pg=sc&amp;id="&rs("id")&"&amp;page="&page&"'>-Del-</a></span></div>"&vbcrlf
	rs.movenext
		Next
	call kltool_page(2)
	else
	Response.write "<div class=tip>暂时没有记录！</div>"
	end if
	rs.close
	set rs=nothing
'-----
elseif pg="tj" then
	if content="" then call kltool_msge("回复语不能为空!")
	set rs=server.CreateObject("adodb.recordset")
	rs.open "select * from [kltool_re]",kltool,1,2
	rs.addnew
	rs("content")=content
	rs("xy")=xy
	rs.update
	rs.close
	set rs=nothing
	call kltool_write_log("(帖子)新增回复语:"&content)
	response.redirect "?siteid="&siteid&"&page="&page
'-----
elseif pg="sc" then
	set rs=server.CreateObject("adodb.recordset")
	rs.open "select * from [kltool_re] where id="&id,kltool,1,2
	if rs.eof then call kltool_msge("不存在此记录")
	rs.delete
	rs.close
	set rs=nothing
	call kltool_write_log("(帖子)删除回复语:"&content)
	response.redirect "?siteid="&siteid&"&page="&page
'-----
elseif pg="xy" then
	set rs=server.CreateObject("adodb.recordset")
	rs.open "select * from [kltool_re] where id="&id,kltool,1,2
	if rs.eof then call kltool_msge("不存在此记录")
	content=rs("content")
	if clng(rs("xy"))=1 then
	rs("xy")=2
	call kltool_write_log("(帖子)停用回复语:"&content)
	else
	rs("xy")=1
	call kltool_write_log("(帖子)启用回复语:"&content)
	end if
	rs.update
	rs.close
	set rs=nothing
	response.redirect "?siteid="&siteid&"&page="&page
end if

kltool_end
%>