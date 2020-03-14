<!--#include file="./inc/config.asp"-->
<%
kltool_head("柯林工具箱-域名绑定信息")
kltool_quanxian
pg=request("pg")
if pg="" then
	Response.write"<div class=""tip""><button onclick=""display(pic1);return false;"">点击此处,展开新增表单</button></div>"
	Response.write"<span id=""pic1"" style=""display:none"">"
	Response.write"<div class=""content""><form method=""post"" action=""?""><input name=""siteid"" type=""hidden"" value="""&siteid&"""><input name=""pg"" type=""hidden"" value=""tj"">"
	Response.write"输入域名(如baidu.com),不带http://<br/><input type=""text"" name=""ym"" placeholder=""中文域名请先转码""><br/>转向:输入网站ID或输入一个网址,如：baidu.com/wapindex.aspx?siteid=1000,不需要带http://<br/><textarea name=""hid"" rows=""5"" type=""text"" value="""" placeholder=""1000""></textarea><br/>"
	Response.write"<input name=""g"" type=""submit"" value=""添加域名绑定"" onClick=""ConfirmDel(""是否确定？"");return false""></form></div></span>"
	set rs=server.CreateObject("adodb.recordset")
	rs.open "select * from [DomainName]",conn,1,1
	If Not rs.eof Then
		gopage="?"
		Count=rs.recordcount
		pagecount=(count+pagesize-1)\pagesize
		if page>pagecount then page=pagecount
		rs.move(pagesize*(page-1))
	call kltool_page(1)
		For i=1 To PageSize				
		If rs.eof Then Exit For
	Response.write"<div class=""line1"">"&i&"."
	Response.write"域名:[<b>"&rs("domain")&"</b>]"
	if not rs("id")=1 then Response.write"(<a href='"&gopage&"siteid="&siteid&"&amp;wid="&rs("id")&"&amp;pg=sc&amp;page="&page&"' onClick=""ConfirmDel('是否确定删除？删除后不能恢复！');return false"">删除</a>/<a href='"&gopage&"siteid="&siteid&"&amp;wid="&rs("id")&"&amp;pg=xg&amp;page="&page&"'>修改</a>)"
	Response.write"</div><div class=""line2"">　　指向:<a href='"&rs("realpath")&"'>"&rs("realpath")&"</a></div>"
		rs.movenext
		Next
	call kltool_page(2)
	else
	   Response.write "<div class=""tip"">暂时没有记录！</div>"
	end if
	rs.close
	set rs=nothing
''''''''''''''''''''''''''''
elseif pg="sc" then
	wid=request("wid")
	page=request("page")
	if wid=1 then call kltool_msge("无法删除")
	set rs=server.CreateObject("adodb.recordset")
	rs.open "select * from [DomainName] where id="&wid,conn,1,1
	If Not rs.eof Then
	kdomain=rs("domain")
	conn.execute("delete from [DomainName] where id="&wid)
	end if
	rs.close
	set rs=nothing
	call kltool_write_log("删除了域名指向："&kdomain)
	response.redirect "?siteid="&siteid&"&page="&page
''''''''''''''''''''''''''''
elseif pg="xg" then
	wid=request("wid")
	page=request("page")
	if wid=1 then call kltool_msge("无法修改")
	set rs=server.CreateObject("adodb.recordset")
	rs.open "select * from [DomainName] where id="&wid,conn,1,1
	If rs.eof Then call kltool_msge("无此记录")
%>
<div class="line2">请填写信息</div>
<div class="content">
<form method="post" action="?">
<input name="siteid" type="hidden" value="<%=siteid%>">
<input name="pg" type="hidden" value="xg1">
<input name="wid" type="hidden" value="<%=wid%>">
<input name="page" type="hidden" value="<%=page%>">
将要修改的域名:<br/>
<input type="text" name="ym" value="<%=rs("domain")%>"/><br/>
转向:<br/>
<textarea name="hid" rows="5" type="text" value=""><%=rs("realpath")%></textarea><br/>
<input type="submit" value="确认修改" onClick="ConfirmDel('是否确定？');return false">
</form>
</div>
<%
rs.close
set rs=nothing
''''''''''''''''''''''''''''
elseif pg="xg1" then
	ym=request("ym")
	wid=request("wid")
	hid=request("hid")
	page=request("page")
	if ym="" or hid="" then call kltool_msge("域名或转向不能为空")
	if wid=1 then call kltool_msge("无法修改")
	if Isnumeric(hid) then
	conn.execute("update [DomainName] set domain='"&ym&"',realpath='http://"&ym&"/wapindex.aspx?siteid="&hid&"',title="&userid&",siteid="&hid&" where id="&wid&"")
	else
	conn.execute("insert into [DomainName] (domain,realpath,title,siteid) values ('"&ym&"','http://"&hid&"',"&userid&","&userid&") ")
	end if
	call kltool_write_log("(域名)修改了域名指向：新("&ym&")")
	response.redirect "?siteid="&siteid&"&page="&page
''''''''''''''''''''''''''''
elseif pg="tj" then
	ym=request("ym")
	hid=request("hid")
	if ym="" or hid="" then call kltool_msge("域名或转向不能为空")

	set rs=server.CreateObject("adodb.recordset")
	rs.open "select * from [DomainName] where domain='"&ym&"'",conn,1,1
	If Not rs.eof Then call kltool_msge("此域名已存在")
	rs.close
	set rs=nothing

	if Isnumeric(hid) then
	conn.execute("insert into [DomainName] (domain,realpath,title,siteid) values ('"&ym&"','http://"&ym&"/wapindex.aspx?siteid="&hid&"',"&userid&","&hid&") ")
	else
	conn.execute("insert into [DomainName] (domain,realpath,title,siteid) values ('"&ym&"','http://"&hid&"',"&userid&","&userid&") ")
	end if
	call kltool_write_log("(域名)添加了新的域名指向："&ym)
	response.redirect "?siteid="&siteid
end if
call kltool_end
%>