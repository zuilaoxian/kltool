<!--#include file="config.asp"-->
<%
kltool_use(23)
kltool_admin(1)
action=Request.QueryString("action")

select case action
	case ""
		call index()
	case "yes"
		call yes()
	case "sc"
		call sc()
	case "xg"
		call xg()
end select

sub index()
	Response.write kltool_code(kltool_head("域名绑定转发","1"))
%>
<form role="form">
	<div class="form-group">
		<label for="name">域名(如baidu.com)</label>
		<input type="text" class="form-control" name="s_str1" id="s_str1" placeholder="" value="">
	</div>
	<div class="form-group">
		<label for="name">转向:网站ID或网址</label>
		<input type="text" class="form-control" name="s_str2" id="s_str2" placeholder="" value="">
	</div>
	<button name="kltool" type="button" class="btn btn-default btn-block" id="BbsTopic" data-loading-text="Loading...">提交</button>
</form>
<%
	set rs=server.CreateObject("adodb.recordset")
	rs.open "select * from [DomainName] order by id",conn,1,1
	If Not rs.eof Then
		gopage="?"
		Count=rs.recordcount
		pagecount=(count+pagesize-1)\pagesize
		if page>pagecount then page=pagecount
		rs.move(pagesize*(page-1))
		html=html&kltool_page(1,count,pagecount,gopage)
		For i=1 To PageSize				
		If rs.eof Then Exit For
	html=html&"<div class=""list-group-item"">"&i&"."&vbcrlf&_
	"域名:[<b>"&rs("domain")&"</b>]"&vbcrlf&_
	"<br/>指向:<a href='"&rs("realpath")&"'>"&rs("realpath")&"</a>"&vbcrlf&_
	"<br/><a href="""&gopage&"siteid="&siteid&"&s_str0="&rs("id")&"&action=sc"" id=""tips"" tiptext=""删除"&rs("domain")&""">删除</a>"&vbcrlf&_
	" <a id=""s_xg"" s_str0="""&rs("id")&""" data-toggle=""modal"" data-target=""#myModal"">修改</a>"&vbcrlf&_
	"</div>"&vbcrlf
		rs.movenext
		Next
	html=html&kltool_page(1,count,pagecount,gopage)
	else
	   html=html&"<div class=""alert alert-danger"">暂时没有记录！</div>"
	end if
	rs.close
	set rs=nothing
	Response.write kltool_code(html&kltool_end(1))
end sub

sub sc()
	s_str0=Request.QueryString("s_str0")
	if s_str0="" or not isnum(s_str0) or s_str0="1" then
		response.write "无法删除"
		response.end
	end if
	set rs=server.CreateObject("adodb.recordset")
	rs.open "select * from [DomainName] where id="&s_str0,conn,1,2
	If Not rs.eof Then
		kdomain=rs("domain")
		rs.delete
	else
		response.write "不存在的记录"
		response.end
	end if
	rs.close
	set rs=nothing
	response.write "删除："&kdomain
end sub

sub xg()
	s_str0=Request.QueryString("s_str0")
	if s_str0="" or not isnum(s_str0) or s_str0="1" then
		response.write "无法修改"
		response.end
	end if

	set rs=server.CreateObject("adodb.recordset")
	rs.open "select * from [DomainName] where id="&s_str0,conn,1,1
	If rs.eof Then
		response.write "不存在的记录"
		response.end
	end if
%>
<form role="form" id="s_xg">
	<div class="form-group">
		<label for="name">域名(如baidu.com)</label>
		<input type="text" class="form-control" name="s_str1" id="s_str1" placeholder="" value="<%=rs("domain")%>">
	</div>
	<div class="form-group">
		<label for="name">转向:网站ID或网址</label>
		<input type="text" class="form-control" name="s_str2" id="s_str2" placeholder="" value="<%=rs("realpath")%>">
	</div>
</form>
<%
rs.close
set rs=nothing
end sub

sub yes()
	s_str1=Request.Form("s_str1")
	s_str2=Request.Form("s_str2")
	if s_str1="" or s_str2="" then
		response.write "域名或转向不能为空"
		response.end
	end if

	s_str1=replace(s_str1,"http://","")
	s_str1=replace(s_str1,"https://","")
	
	if isnum(s_str2) then
		realpath="http://"&s_str1&"/wapindex.aspx?siteid="&s_str2
	else
		s_str2=replace(s_str2,"http://","")
		s_str2=replace(s_str2,"https://","")
		realpath="http://"&s_str2
	end if
	
	set rs=server.CreateObject("adodb.recordset")
	rs.open "select * from [DomainName] where domain='"&s_str1&"'",conn,1,2
	If rs.bof and rs.eof Then
		rs.addnew
		response.write "添加域名："&s_str1
	else
		response.write "修改域名："&s_str1
	end if
		rs("domain")=s_str1
		rs("realpath")=realpath
		rs("title")=userid
		rs("siteid")=userid
		rs.update
	rs.close
	set rs=nothing
end sub
%>