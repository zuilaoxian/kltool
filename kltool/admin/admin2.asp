<!--#include file="../inc/config.asp"-->
<%
kltool_head("柯林工具箱-权限管理")
kltool_quanxian
%>
<style type="text/css">
	span.headimg{height:50px;}
	.headimg img{height:50px;}
	table{width:100%;max-width:100%; height:auto; text-align:center;} 
	td{height:50px;}
</style>
<form method="post" action="?">
<input name="siteid" type="hidden" value="<%=siteid%>">
<input name="pg" type="hidden" value="tj">
<div class="tip">允许进入并操作工具箱的ID</div>
<div class="line2">
<input type="text" name="uid" value="" size="13">
<input name="g" type="submit" value="Add">
</form></div>
<%
pg=request("pg")
if pg="" then
	set rs=server.CreateObject("adodb.recordset")
	rs.open "select * from [quanxian]",kltool,1,1
	If Not rs.eof Then
		gopage="?"
		Count=rs.recordcount
		pagecount=(count+pagesize-1)\pagesize	
		if page>pagecount then page=pagecount
		rs.move(pagesize*(page-1))
	call kltool_page(1)
	Response.write"<table border=1 rules=all>"
		For i=1 To PageSize 
		If rs.eof Then Exit For
	'if (i mod 2) = 0 then Response.write "<div class=""line1"">" else Response.write "<div class=""line2"">"
	Response.write "<div><tr>"
	Response.write "<td width=""10%"">"&page*PageSize+i-PageSize&"</td>"
	Response.write "<td width=""20%""><span class=""headimg"">"&kltool_get_userheadimg(rs("userid"))&"</span></td>"
	Response.write "<td width=""55%"">"&kltool_get_usernickname(rs("userid"),1)&"("&rs("userid")&")</td>"
	if rs("userid")<>siteid then Response.write"<td width=""15%""><a href='?pg=sc&amp;siteid="&siteid&"&amp;uid="&rs("userid")&"'>[Del]</a></td>"
	Response.write"</tr></div>"&vbcrlf&vbcrlf
	rs.movenext
		Next
	Response.write"</table>"
	call kltool_page(2)
	else
	   Response.write "<div class=tip>暂时没有记录！</div>"
	end if
	rs.close
	set rs=nothing
''''''''''''''''''''''''''''''
elseif pg="tj" then
	uid=request("uid")
	if not Isnumeric(uid) then call kltool_msge("id必须是数字")
	set rs=conn.execute("select userid from [user] where userid="&uid)
	if rs.eof then call kltool_msge("此id不存在")
	rs.close
	set rs=nothing

	set rs=server.CreateObject("adodb.recordset")
	rs.open "select * from [quanxian] where userid="&uid,kltool,1,2
	if not rs.eof then kltool_msge("此id已存在")
	rs.addnew
	rs("userid")=uid
	rs.update
	rs.close
	set rs=nothing
	call kltool_write_log("(权限)新增工具箱操作人："&kltool_get_usernickname(uid,1)&"("&uid&")")
	response.redirect "?siteid="&siteid
'''''''''''''''''''''''''''''''''''
elseif pg="sc" then
	uid=request("uid")
	if clng(uid)=siteid then call kltool_msge("无法删除此记录")
	set rs=Server.CreateObject("ADODB.Recordset")
	rs.open "select * from [quanxian] where userid="&uid,kltool,1,2
	if rs.bof and rs.eof then call kltool_msge("无此id记录")
	rs.delete
	rs.close
	set rs=nothing
	call kltool_write_log("(权限)删除工具箱操作人："&kltool_get_usernickname(uid,1)&"("&uid&")")
	response.redirect "?siteid="&siteid
end if

kltool_end
%>