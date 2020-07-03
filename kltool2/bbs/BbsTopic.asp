<!--#include file="../config.asp"-->
<%
kltool_use(12)
kltool_admin(1)
action=Request.QueryString("action")
select case action
	case ""
		call index()
	case else
		call index1()
end select
sub index()
	html=kltool_head("柯林工具箱-贴子带专题发布通道",1)
	html=html&"<div role=""form"" class=""form-horizontal"">"&vbcrlf&_
	"	<div class=""form-group"">"&vbcrlf&_
	"		<label for=""bbs_title"" class=""col-sm-2 control-label"">帖子标题</label>"&vbcrlf&_
	"		<div class=""col-sm-10"">"&vbcrlf&_
	"			<textarea class=""form-control"" rows=""3"" name=""bbs_title"" id=""bbs_title"" placeholder=""""></textarea>"&vbcrlf&_
	"		</div>"&vbcrlf&_
	"	</div>"&vbcrlf&_

	"	<div class=""form-group"">"&vbcrlf&_
	"		<label for=""bbs_content"" class=""col-sm-2 control-label"">帖子内容</label>"&vbcrlf&_
	"		<div class=""col-sm-10"">"&vbcrlf&_
	"			<textarea class=""form-control"" rows=""10"" name=""bbs_content"" id=""bbs_content"" placeholder=""""></textarea>"&vbcrlf&_
	"		</div>"&vbcrlf&_
	"	</div>"&vbcrlf&_
	
	"	<label for=""Class"" class=""col-sm-2 control-label"">论坛</label>"&vbcrlf&_
	"	<div>"&vbcrlf&_
	kltool_get_classlist(16)&_
	"	</div>"&vbcrlf&_

	"	<label for=""Topic"" class=""col-sm-2 control-label"">专题</label>"&vbcrlf&_
	"	<div>"&vbcrlf&_
	kltool_get_topiclist()&_
	"	</div>"&vbcrlf&_

	"	<div class=""form-group"">"&vbcrlf&_
	"		<label for=""bbs_author"" class=""col-sm-2 control-label"">作者</label>"&vbcrlf&_
	"		<div class=""col-sm-10"">"&vbcrlf&_
	"			<input type=""text"" class=""form-control"" name=""bbs_author"" id=""bbs_author"" value="""&nickname&""" >"&vbcrlf&_
	"		</div>"&vbcrlf&_
	"	</div>"&vbcrlf&_
	
	"	<div class=""form-group"">"&vbcrlf&_
	"		<label for=""bbs_pub"" class=""col-sm-2 control-label"">ID</label>"&vbcrlf&_
	"		<div class=""col-sm-10"">"&vbcrlf&_
	"			<input type=""text"" class=""form-control"" name=""bbs_pub"" id=""bbs_pub"" value="""&userid&""" >"&vbcrlf&_
	"		</div>"&vbcrlf&_
	"	</div>"&vbcrlf&_
	
	"	  <button name=""kltool"" type=""button"" class=""btn btn-default btn-block"" id=""BbsTopic"" data-loading-text=""Loading..."">提交</button>"&vbcrlf&_
	"</div>"&vbcrlf
	response.write kltool_code(html&kltool_end(1))
end sub
sub index1()
	bbs_title=Request.Form("bbs_title")
	bbs_content=Request.Form("bbs_content")
	bbs_classid=Request.Form("bbs_classid")
	bbs_topic=Request.Form("bbs_topic")
	bbs_author=Request.Form("bbs_author")
	bbs_pub=Request.Form("bbs_pub")
	if bbs_title="" or bbs_content="" or bbs_author="" or bbs_pub="" or bbs_classid="" then
		Response.write "发表帖子失败"
		Response.End()
	end if

		set rs=Server.CreateObject("ADODB.Recordset")
		rs.open"select * from [wap_bbs]",conn,1,2
		rs.addnew
			rs("book_title")=bbs_title
			rs("book_content")=bbs_content
			rs("book_classid")=bbs_classid
			if bbs_topic<>"" then rs("topic")=bbs_topic
			rs("userid")=siteid
			rs("book_author")=bbs_author
			rs("book_pub")=bbs_pub
		rs.update
		rs.close
		set rs=nothing
	Response.Write "发表成功帖子:"&bbs_title
end sub
%>