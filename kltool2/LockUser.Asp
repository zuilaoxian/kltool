<!--#include file="config.asp"-->
<%
kltool_use(24)
kltool_admin(1)
function get_classinfo(uid)
	set rs1=conn.execute("select * from [class] where classid="&uid)
	if not rs1.eof then get_classinfo="栏目:<a href=""?siteid="&siteid&"&Class="&uid&""">"&rs1("classname")&"("&uid&")</a>" else get_classinfo="栏目("&uid&")不存在"
	rs1.close
	set rs1=nothing
end function

action=Request.QueryString("action")

select case action
	case ""
		call index()
	case "unlock"
		call unlock()
	case "yes"
		call yes()
	case "cdkdel"
		call unlockuser()
end select

sub index()
Response.write kltool_code(kltool_head("柯林工具箱-论坛加黑会员","1"))

%>
<form role="form" class="bs-example bs-example-form">
	<div class="form-group">
		<label for="name" class="col-sm-2 control-label">会员ID</label>
		<div class="col-sm-10">
			<input type="text" class="form-control" name="s_str1" id="s_str1" placeholder="" value="">
		</div>
	</div>
	<div class="form-group">
		<label for="Class" class="col-sm-2 control-label">选择论坛</label>
		<div class="col-sm-offset-2">
			<%=kltool_get_classlist(16)%>
		</div>
	</div>
	<div class="form-group">
		<label for="name" class="col-sm-2 control-label">加黑天数</label>
		<div class="col-sm-10">
			<input type="text" class="form-control" name="s_str2" id="s_str2" placeholder="0为无期限" value="">
		</div>
	</div>
	
	<div class="row">
		<div class="col-md-6">
			<button name="kltool" type="button" class="btn btn-default btn-block" id="lockuser_search" data-loading-text="Loading...">查找</button>
		</div>
		<div class="col-md-6">
			<button name="kltool" type="button" class="btn btn-default btn-block" id="BbsTopic" data-loading-text="Loading..." style="border-color: #da3131;">提交</button>
		</div>
	</div>
</form>
<%
	ksearch=request.QueryString("ksearch")
	set rs=server.CreateObject("adodb.recordset")
	if ksearch<>"" then
		rs.open "select * from [user_lock] where siteid="&siteid&" and lockuserid='"&ksearch&"'",conn,1,1
	else
		rs.open "select * from [user_lock] where siteid="&siteid,conn,1,1
	end if
	If Not rs.eof Then			
		if ksearch<>"" then gopage="?ksearch="&ksearch&"&" else gopage="?"
		Count=rs.recordcount
		pagecount=(count+pagesize-1)\pagesize
		if page>pagecount then page=pagecount
		rs.move(pagesize*(page-1))
		html=html&kltool_page(1,count,pagecount,gopage)
		For i=1 To PageSize
		If rs.eof Then Exit For
		html=html&"<div class=""list-group-item"">"&vbcrlf&_
		
		"<h4><label><input type=""checkbox"" class=""kid"" id=""kid"" value="""&rs("id")&"""> "&kltool_get_usernickname(rs("lockuserid"),1)&"("&rs("lockuserid")&")</label></h4>"&vbcrlf&_
		
		"时间:"&rs("operdate")&"<br/>"&vbcrlf&_
		
		"操作人:"&kltool_get_usernickname(rs("operuserid"),1)&"("&rs("operuserid")&")<br/>"&vbcrlf
		
		lockclassid=rs("classid")
		if lockclassid="0" then html=html&"栏目:全部论坛<br/>"&vbcrlf else html=html&get_classinfo(lockclassid)&"<br/>"&vbcrlf
		lockdate=rs("lockdate")
		if lockdate="0" then html=html&"永久加黑"&vbcrlf else html=html&"加黑:"&lockdate&"天("&DateAdd("d",rs("operdate"),lockdate)&")"&vbcrlf

		html=html&"	<a href=""?siteid="&siteid&"&id="&rs("id")&"&action=unlock"" id=""tips"" tiptext=""解除加黑？"">解除</a>"&vbcrlf&_

		"</div>"&vbcrlf

		
		rs.movenext
		Next
		html=html&kltool_page(1,count,pagecount,gopage)&vbcrlf&_
		"<li class=""list-group-item"">"&vbcrlf&_
		"	<a id=""chose"" class=""btn btn-default"">反选</a> <a id=""choseall"" class=""btn btn-default"">全选</a>"&vbcrlf&_
		"	<button name=""kltool"" id=""Cdk_Del"" class=""btn btn-default"" data-loading-text=""Loading..."">选择完毕,删除</button>"&vbcrlf&_
		"</li>"&vbcrlf
		
	
	else
	   html=html&"<div class=""alert alert-danger"">暂时没有记录！</div>"
	end if
	rs.close
	set rs=nothing
	
html=html&"<div class=""alert alert-danger"">"&vbcrlf&_
"	1、可对任意会员加黑或解黑<br/>"&vbcrlf&_
"	2、本插件论坛加黑或解黑，用户仍然可以浏览内容<br/>"&vbcrlf&_
"	3、如需拉黑会员请前往会员管理锁定"&vbcrlf&_
"</div>"&vbcrlf

	Response.write kltool_code(html&kltool_end(1))
end sub

sub yes()
	s_str1=request("s_str1")
	s_str3=request("Class")
	s_str2=request("s_str2")

	if s_str1="" or not isnum(s_str1) or s_str1="1000" or s_str1=siteid or (s_str2<>"" and not Isnumeric(s_str2)) then 
		Response.write "填写错误"
		Response.end
	end if
	if s_str2="" then s_str2=0
	if s_str3="" then s_str3=0

	set rs=server.CreateObject("adodb.recordset")
	rs.open "select * from [user_lock]",conn,1,2
	rs.addnew
	rs("siteid")=siteid
	rs("lockuserid")=s_str1
	rs("lockdate")=s_str2
	rs("operdate")=now()
	rs("operuserid")=userid
	rs("classid")=s_str3
	rs.update
	rs.close
	set rs=nothing
	Response.write "加黑："&kltool_get_usernickname(s_str1,1)&"("&s_str1&")"
end sub
sub unlock()
	id=request.QueryString("id")
	set rs=server.CreateObject("adodb.recordset")
	rs.open "select * from [user_lock] where siteid="&siteid&" and id="&id,conn,1,2
	if rs.eof then
		Response.write "不存在的记录"
		response.end
	end if
	lockuserid=rs("lockuserid")
	rs.delete
	rs.close
	set rs=nothing
	Response.write "解除加黑："&kltool_get_usernickname(lockuserid,1)&"("&lockuserid&")"
end sub
sub unlockuser()
	id=request.form("c_id")
	conn.execute("delete from [user_lock] where siteid="&siteid&" and id in ("&id&")")
	Response.write "批量解除加黑成功"
end sub
%>