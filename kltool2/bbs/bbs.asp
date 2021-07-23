<!--#include file="../config.asp"-->
<%
kltool_use(5)
kltool_admin(1)
'-----查询一条回复语
Function kltool_bbs_reyu
	kltool_bbs_reyu=""
	Randomize
	set rs=server.CreateObject("adodb.recordset")
	rs.open "select top 1 * from [kltool_re] where xy=1 order by rnd(-(id)+"&rnd()&")",kltool,1,1
	if not (rs.bof and rs.eof) then kltool_bbs_reyu=rs("content")
	rs.close
	set rs=nothing
End Function
'-----查询一条用户信息
Function kltool_bbs_reuser
	kltool_bbs_reuser=""
	set rs=server.CreateObject("adodb.recordset")
	rs.open "select top 1 * from [user] where siteid="&siteid&" order by newid()",conn,1,1
	if not (rs.bof and rs.eof) then kltool_bbs_reuser=rs("userid")&"|kltool|"&rs("nickname")
	rs.close
	set rs=nothing
End Function
'-----查询帖子所属栏目ID
Function kltool_bbs_tclassid(uid)
	kltool_bbs_tclassid="不存在的栏目"
	set rs=server.CreateObject("adodb.recordset")
	rs.open "select id,book_classid from [wap_bbs] where id="&uid,conn,1,1
	if not (rs.bof and rs.eof) then kltool_bbs_tclassid=rs("book_classid")
	rs.close
	set rs=nothing
End Function

function get_classinfo(uid)
	set rs1=conn.execute("select * from [class] where classid="&uid)
	if not rs1.eof then get_classinfo="栏目:<a href=""?siteid="&siteid&"&r_class="&uid&""">"&rs1("classname")&"("&uid&")</a>" else get_classinfo="栏目("&uid&")不存在"
	rs1.close
	set rs1=nothing
end function
function get_topicinfo(uid,cid)
	get_topicinfo=""
	if uid then
		set rs2=conn.execute("select id,subclassName from [wap2_smallType] where siteid="&siteid&" and systype='bbs"&cid&"' and id="&uid)
		if not rs2.eof then get_topicinfo="专题:<a cid="""&cid&""" tid="""&uid&""" id=""re_topic""  data-toggle=""modals"" data-target=""#myModal"">"&rs2("subclassName")&"("&uid&")</a>"
		rs2.close
		set rs2=nothing
	end if
end function

action=Request.QueryString("action")
select case action
	case ""
		call index()
	case "bbsreword"
		call bbsreword()
	case "bbsrewordset"
		call bbsrewordset()
	case "bbsreworddel"
		call bbsreworddel()
	case "bbsreplace"
		call bbsreplace()
	case "bbsreplaceyes"
		call bbsreplaceyes()
	case "bbsdel"
		call bbsdel()
	case "bbslock"
		call bbslock()
	case "bbsrecontent"
		call bbsrecontent()
	case "bbsrecontentyes"
		call bbsrecontentyes()
	case "bbsdo"
		call bbsdo()
end select

sub index()
	html=kltool_head("柯林工具箱-帖子管理",1)&_
	"<ul class=""breadcrumb"">"&vbcrlf&_
	"	<li>帖子管理</li>"&vbcrlf&_
	"	<li><a href=""?action=bbsreword"">回复语设置</a></li>"&vbcrlf&_
	"	<li><a id=""bbsreplace"" data-toggle=""modal"" data-target=""#myModal"">关键词替换</a></li>"&vbcrlf&_
	"</ul>"&vbcrlf&_
	
	"<li class=""list-group-item"">"&vbcrlf&_
	"<div class=""form-group"">"&vbcrlf&_
	" <label for=""r_search""></label><br>"&vbcrlf&_
	"</div>"&vbcrlf&_
	"<form method=""get"" action=""?"" class=""form-horizontal"" role=""form"">"&vbcrlf&_
	"	<input name=""siteid"" type=""hidden"" value="""&siteid&""">"&vbcrlf&_
	"	<div class=""form-group"">"&vbcrlf&_
	"		<label for=""r_search"" class=""col-sm-2 control-label"">会员ID</label>"&vbcrlf&_
	"		<div class=""col-sm-10"">"&vbcrlf&_
	"			<input type=""text"" name=""r_search"" class=""form-control"" id=""r_search"" placeholder="""">"&vbcrlf&_
	"		</div>"&vbcrlf&_
	"	</div>"&vbcrlf&_
	"	<div class=""form-group"">"&vbcrlf&_
	"		<label for=""Class"" class=""col-sm-2 control-label"">选择论坛</label>"&vbcrlf&_
	"		<div class=""col-sm-offset-2"">"&vbcrlf&_
	kltool_get_classlist(16)&_
	"		</div>"&vbcrlf&_
	"	</div>"&vbcrlf&_
	"	<div class=""form-group"">"&vbcrlf&_
	"		<button type=""submit"" class=""btn btn-default btn-sm btn-block"">搜索</button>"&vbcrlf&_
	"	</div>"&vbcrlf&_
	"</form>"&vbcrlf&_
	"</li>"&vbcrlf
	
	r_search=Request.QueryString("r_search")
	r_class=Request.QueryString("Class")
	if r_search<>"" then r_search=clng(r_search) else r_search=0
	if r_class<>"" then r_class=clng(r_class) else r_class=0
	sql="select id,userid,book_classid,book_title,book_author,book_pub,book_re,book_click,book_date,book_good,suport,topic,islock,isCheck from [wap_bbs] where userid="&siteid
	gopage="?"
	if r_search and r_class then
		sql=sql&" and book_pub="&r_search&" and book_classid="&r_class
		gopage="?r_search="&r_search&"&r_class="&r_class&"&"
	elseif r_search and not r_class then
		sql=sql&" and book_pub="&r_search
		gopage="?r_search="&r_search&"&"
	elseif not r_search and r_class then
		sql=sql&" and book_classid="&r_class
		gopage="?r_class="&r_class&"&"
	end if
	sql=sql&" Order by id desc"
	str=kltool_GetRow(sql,0,pagesize)
	If str(0) Then
		count=str(0)
		pagecount=str(1)
		pagecount=(count+pagesize-1)\pagesize
		if page>pagecount then page=pagecount
		html=html&kltool_page(1,count,pagecount,gopage)&_
		"<ul class=""list-group"">"&vbcrlf
		For i=0 To ubound(str(2),2)
			b_id=str(2)(0,i)
			b_userid=str(2)(1,i)
			b_book_classid=str(2)(2,i)
			b_book_title=str(2)(3,i)
			b_book_author=str(2)(4,i)
			b_book_pub=str(2)(5,i)
			b_book_re=str(2)(6,i)
			b_book_click=str(2)(7,i)
			b_book_date=str(2)(8,i)
			b_book_good=str(2)(9,i)
			b_suport=str(2)(10,i)
			b_topic=str(2)(11,i)
			b_islock=str(2)(12,i)
			b_isCheck=str(2)(13,i)
			if b_isCheck=2 then b_isCheck_=" style=""text-decoration:line-through;""" else b_isCheck_=""
			if b_isCheck=2 then b_isCheck_c="恢复" else b_isCheck_c="删除"
			if b_islock=1 then b_islock_c="<span class=""glyphicon glyphicon-remove-circle""></span>解锁" else b_islock_c="<span class=""glyphicon glyphicon-ok-circle""></span>锁定"
			if b_islock=1 then b_islock_cc="解锁" else b_islock_cc="锁定"
			html=html&"<li class=""list-group-item"""&b_isCheck_&">"&vbcrlf&_
			" <h4><input type=""checkbox"" class=""kid"" id=""kid"" value="""&b_id&"""> "&b_id&" <a href=""/bbs/book_view.aspx?siteid="&siteid&"&classid="&b_book_classid&"&id="&b_id&""">"&b_book_title&"</a></h4>"&vbcrlf&_
			
			" (作者:<a href=""/bbs/userinfo.aspx?siteid="&siteid&"&touserid="&b_book_pub&""">"&kltool_get_usernickname(b_book_pub,1)&"</a>)"&vbcrlf&_
			" (<a href=""?siteid="&siteid&"&r_search="&b_book_pub&""">"&b_book_pub&"</a>)<br/>"&vbcrlf&_
			
			" "&get_classinfo(b_book_classid)&vbcrlf&_
			
			" "&get_topicinfo(b_topic,b_book_classid)&vbcrlf&_
			
			" <br/><a tid="""&b_id&""" id=""bbsrecontent"" data-toggle=""modal"" data-target=""#myModal""><span class=""glyphicon glyphicon-edit""></span>修改</a>"&vbcrlf&_
			
			" <a href=""?action=bbsdel&tid="&b_id&"&lx="&b_isCheck&""" id=""tips"" tiptext=""确定"&b_isCheck_c&"吗?<br/>"&b_book_title&""">"&b_isCheck_c&"</a>"&vbcrlf&_
			
			" <a href=""?action=bbslock&tid="&b_id&"&lx="&b_islock&""" id=""tips"" tiptext=""确定"&b_islock_cc&"吗?<br/>"&b_book_title&""">"&b_islock_c&"</a>"&vbcrlf&_
			" 阅:"&b_book_click&""&vbcrlf&_
			" 回:"&b_book_re&""&vbcrlf&_
			" 赞"&b_suport&""&vbcrlf&_
			"</li>"&vbcrlf
			Next
			html=html&"<li class=""list-group-item"">"&vbcrlf&_
			"<a id=""chose"" class=""btn btn-default"">反选</a> <a id=""choseall"" class=""btn btn-default"">全选</a><br/>"&vbcrlf&_
			"<div class=""row"">"&vbcrlf&_
			"	<div class=""col-xs-7"">"&vbcrlf&_
			"		<div class=""input-group"">"&vbcrlf&_
			"			<span class=""input-group-btn"">"&vbcrlf&_
			"				<select id=""bbsdoselect"" class=""btn btn-default"">"&vbcrlf&_
			"				  <option value=""0"">选择操作</option>"&vbcrlf&_
			"				  <option value=""1"">删除</option>"&vbcrlf&_
			"				  <option value=""2"">恢复</option>"&vbcrlf&_
			"				  <option value=""3"">锁定</option>"&vbcrlf&_
			"				  <option value=""4"">解锁</option>"&vbcrlf&_
			"				  <option value=""5"">增加阅读量</option>"&vbcrlf&_
			"				  <option value=""6"">减少阅读量</option>"&vbcrlf&_
			"				  <option value=""7"">增加回复</option>"&vbcrlf&_
			"				  <option value=""8"">增加点赞</option>"&vbcrlf&_
			"				  <option value=""9"">减少点赞</option>"&vbcrlf&_
			"				  <option value=""10"">转移栏目</option>"&vbcrlf&_
			"				  <option value=""11"">彻底删除</option>"&vbcrlf&_
			"				</select>"&vbcrlf&_
			"			</span>"&vbcrlf&_
			"			<input type=""text"" class=""form-control"" name=""r_num"" id=""r_num"" placeholder=""输入数量"" style=""display:none;"">"&vbcrlf&_
			"		</div><!-- /input-group -->"&vbcrlf&_
			"	</div><!-- /.col-lg-6 -->"&vbcrlf&_
			"</div><!-- /.row -->"&vbcrlf&_
	"	<div class=""form-group"" id=""r_class"" style=""display:none;"">"&vbcrlf&_
	"		<label for=""Class"" class=""col-sm-2 control-label"">选择论坛</label>"&vbcrlf&_
	"		<div class=""col-sm-offset-2"">"&vbcrlf&_
	kltool_get_classlist(16)&_
	"		</div>"&vbcrlf&_
	"	</div>"&vbcrlf&_
			"<button name=""kltool"" id=""bbsdo"" class=""btn btn-default btn-block"" data-loading-text=""Loading..."">确定</button>"&vbcrlf&_
			"</li>"&vbcrlf&_
			kltool_page(2,count,pagecount,gopage)
		else
			html=html&"<div class=""alert alert-danger"">暂时没有记录</div>"
		end if
		Response.write kltool_code(html&kltool_end(1))
end sub

sub bbsreplace()
	Response.write"论坛(可选)<br/>"&kltool_get_classlist(16)&_
	"<br/><input name=""bbsreplaceword1"" id=""bbsreplaceword1"" type=""text"" value="""" size=""12"" placeholder=""原字符串"">"&vbcrlf&_
	"<input name=""bbsreplaceword2"" id=""bbsreplaceword2"" type=""text"" value="""" size=""12"" placeholder=""将要替换"">"&vbcrlf
end sub

sub bbsreword()
	html=kltool_head("柯林工具箱-回复语管理",1)&_
	"<ul class=""breadcrumb"">"&vbcrlf&_
	"	<li><a href=""/kltool2/bbs/Bbs.Asp"">帖子管理</a></li>"&vbcrlf&_
	"	<li>回复语设置</li>"&vbcrlf&_
	"</ul>"&vbcrlf&_
	"<li class=""list-group-item"">"&vbcrlf&_
	" <div role=""form"" class=""bs-example bs-example-form"">"&vbcrlf&_
	"		<label for=""re_word"" class=""col-sm-2 control-label"">回复语</label>"&vbcrlf&_
	"		<div class=""col-sm-10"">"&vbcrlf&_
	"			<textarea class=""form-control"" rows=""3"" name=""re_word0"" id=""re_word0"" placeholder=""""></textarea>"&vbcrlf&_
	"		</div>"&vbcrlf&_
	"	<label for=""re_qt"" class=""col-sm-2 control-label"">启停</label>"&vbcrlf&_
	"	<div>"&vbcrlf&_
	"    <label class=""radio-inline"">"&vbcrlf&_
	"        <input type=""radio"" name=""re_qt0"" id=""re_qt0""  value=""1""> 启用"&vbcrlf&_
	"    </label>"&vbcrlf&_
	"    <label class=""radio-inline"">"&vbcrlf&_
	"        <input type=""radio"" name=""re_qt0"" id=""re_qt0""  value=""0""> 停用"&vbcrlf&_
	"    </label>"&vbcrlf&_
	"	</div>"&vbcrlf&_
	"	<button name=""kltool"" reid=""0"" type=""button"" class=""btn btn-default btn-block"" id=""Bbs_Re_Set"" data-loading-text=""Loading..."">添加</button>"&vbcrlf&_
	" </div>"&vbcrlf&_
	"</li>"&vbcrlf
	
	str=kltool_GetRow("select * from [kltool_re] order by id desc",1,pagesize)
	If str(0) Then
		count=str(0)
		pagecount=str(1)
		if page>pagecount then page=pagecount
		gopage="?action=bbsreword&"
		html=html&kltool_page(1,count,pagecount,gopage)&_
		"<div role=""form"" class=""form-horizontal"">"&vbcrlf
		For i=0 To ubound(str(2),2)
			re_id=str(2)(0,i)
			re_content=str(2)(1,i)
			re_qt=str(2)(2,i)
			if re_qt="1" then recheck1="checked" else recheck2="checked"
		html=html&"<li class=""list-group-item"">"&vbcrlf&_
		"		<label for=""re_word"" class=""col-sm-2 control-label"">"&re_id&"</label>"&vbcrlf&_
		"		<div class=""col-sm-10"">"&vbcrlf&_
		"			<textarea class=""form-control"" rows=""3"" name=""re_word"&re_id&""" id=""re_word"&re_id&""" placeholder="""">"&re_content&"</textarea>"&vbcrlf&_
		"		</div>"&vbcrlf&_
		"	<label for=""re_qt"" class=""col-sm-2 control-label"">启停</label>"&vbcrlf&_
		"	<div>"&vbcrlf&_
		"    <label class=""radio-inline"">"&vbcrlf&_
		"        <input type=""radio"" name=""re_qt"&re_id&""" id=""re_qt"&re_id&"""  value=""1"" "&recheck1&"> 启用"&vbcrlf&_
		"    </label>"&vbcrlf&_
		"    <label class=""radio-inline"">"&vbcrlf&_
		"        <input type=""radio"" name=""re_qt"&re_id&""" id=""re_qt"&re_id&"""  value=""0"" "&recheck2&"> 停用"&vbcrlf&_
		"    </label>"&vbcrlf&_
		"	</div>"&vbcrlf&_

		"  <div class=""row"">"&vbcrlf&_
		"    <div class=""col-md-6"">"&vbcrlf&_
		"      <button name=""kltool"" reid="""&re_id&""" type=""button"" class=""btn btn-default btn-block"" id=""Bbs_Re_Set"" data-loading-text=""Loading..."">修改</button>"&vbcrlf&_
		"    </div>"&vbcrlf&_
		"    <div class=""col-md-6"">"&vbcrlf&_
		"      <a href=""?action=bbsreworddel&reid="&re_id&""" id=""tips"" tiptext=""确定要删除吗？"" class=""btn btn-default btn-block"" style=""border-color: #da3131;"">删除</a>"&vbcrlf&_
		"    </div>"&vbcrlf&_
		"  </div>"&vbcrlf
		Next
		html=html&"  </div>"&vbcrlf&_
		kltool_page(2,count,pagecount,gopage)
	else
		html=html&"<div class=""alert alert-danger"">暂时没有记录</div>"
	end if
	Response.write kltool_code(html&kltool_end(1))
end sub

sub bbsrecontent()
	tid=Request.QueryString("tid")
	set rs=Server.CreateObject("ADODB.Recordset")
	rs.open"select * from [wap_bbs] where userid="&siteid&" and id="&tid,conn,1,1
	if rs.eof then
		Response.Write"不存在的记录"
		Response.End()
	end if
	Response.write "<input name=""siteid"" type=""hidden"" value="""&siteid&""">"
	Response.write "<input name=""pg"" type=""hidden"" value=""rebbsyes"">"
	Response.write "<input name=""tid"" type=""hidden"" value="""&tid&""">"

	Response.write"<div class=line2>栏目（不修改则留空）:<br/>"&kltool_get_classlist(16)
	
	Response.write "<div class=line1>专题（留空则取消）:<br/>"&kltool_get_topiclist()

	Response.write "<div class=""title"">标题:<br/><textarea name=""title"" id=""title"" rows=""3"">"&rs("book_title")&"</textarea></div>"
	Response.write "<div class=""content"">内容:<br/><textarea name=""content"" id=""content"" rows=""5"">"&rs("book_content")&"</textarea></div>"
	Response.write "<div class=""line1"">作者:<input name=""pub"" type=""text"" value="""&rs("book_pub")&"""></div>"
	rs.close
	set rs=nothing
end sub
sub bbsrecontentyes()
	tid=Request.Form("tid")
	rec_id=Request.Form("rec_id")
	ret_id=Request.Form("ret_id")
	re_title=Request.Form("re_title")
	re_content=Request.Form("re_content")
	set rs=Server.CreateObject("ADODB.Recordset")
	rs.open"select * from [wap_bbs] where id="&tid,conn,1,2
	if rs.bof or rs.eof then
		Response.Write"不存在的记录"
		Response.End()
	end if
	response.write "操作成功"
	if rec_id then rs("book_classid")=rec_id
	rs("topic")=ret_id
	rs("book_title")=re_title
	rs("book_content")=re_content
	rs.update
	rs.close
	set rs=nothing
end sub

sub bbsdel()
	tid=Request.QueryString("tid")
	lx=Request.QueryString("lx")
	if lx=2 then rlx=0 else rlx=2
	conn.Execute("update [wap_bbs] set isCheck="&rlx&" where userid="&siteid&" and id in("&tid&")")
	response.write "操作成功"
end sub
sub bbslock()
	tid=Request.QueryString("tid")
	lx=Request.QueryString("lx")
	if lx=1 then rlx=0 else rlx=1
		conn.Execute("update [wap_bbs] set islock="&rlx&" where id in("&tid&")")
		response.write "操作成功"
end sub

sub bbsrewordset()
	re_id=Request.Form("re_id")
	re_word=Request.Form("re_word")
	re_qt=Request.Form("re_qt")
	set rs=server.CreateObject("adodb.recordset")
	rs.open "select * from [kltool_re] where id="&re_id,kltool,1,2
		if rs.eof then
			rs.addnew
			response.write "成功添加"
		else
			response.write "成功修改"
		end if
	rs("content")=re_word
	rs("xy")=re_qt
	rs.update
	rs.close
	set rs=nothing

end sub
sub bbsreworddel()
	re_id=Request.QueryString("reid")
	set rs=server.CreateObject("adodb.recordset")
	rs.open "select * from [kltool_re] where id="&re_id,kltool,1,2
	if rs.eof then
		Response.Write"不存在的记录"
		Response.End()
	end if
	rs.delete
	rs.close
	set rs=nothing
	response.write "成功删除"
end sub
sub bbsreplaceyes()
	re_id=Request.Form("re_id")
	re_word1=Request.Form("re_word1")
	re_word2=Request.Form("re_word2")
	Response.write "执行成功"
	sql="update [wap_bbs] set [book_content]=REPLACE(cast ([book_content] as varchar(max)),'"&re_word1&"','"&re_word2&"') where userid="&siteid
	if re_id then sql=sql&" and book_classid="&re_id
	conn.Execute(sql)
end sub
sub bbsdo()
	r_do=Request.Form("r_do")
	kid=Request.Form("kid")
	r_num=Request.Form("r_num")
	r_class=Request.Form("r_class")
	if kid="" then
		Response.Write"请至少选择一条记录"
		Response.End()
	end if
	kid=replace(kid&",",",,","")
	select case r_do
		case "1","2","3","4","11"
			if r_do="1" then
				conn.Execute("update [wap_bbs] set isCheck=2 where id in("&kid&")")
				Response.Write"帖子标记删除"
			end if
			if r_do="2" then
				conn.Execute("update [wap_bbs] set isCheck=0 where id in("&kid&")")
				Response.Write"帖子标记恢复"
			end if
			if r_do="3" then
				conn.Execute("update [wap_bbs] set islock=1 where id in("&kid&")")
				Response.Write"帖子锁定"
			end if
			if r_do="4" then
				conn.Execute("update [wap_bbs] set islock=0 where id in("&kid&")")
				Response.Write"帖子解锁"
			end if
			if r_do="11" then
				conn.Execute("delete from [wap_bbs] where id in("&kid&")")
				Response.Write"帖子彻底删除"
			end if
		case "5","6","7","8","9"
			if r_num="" then
				Response.Write"数量不能为空"
				Response.End()
			end if
			r_num=clng(r_num)
			if r_do="5" then
				conn.Execute("update [wap_bbs] set book_click=book_click+"&r_num&" where id in("&kid&")")
				Response.Write"帖子增加阅读量"
			end if
			if r_do="6" then
				conn.Execute("update [wap_bbs] set book_click=book_click-"&r_num&" where id in("&kid&")")
				Response.Write"帖子减少阅读量"
			end if
			if r_do="7" then
				rearrtid=split(kid,",")
				for d=0 to ubound(rearrtid)
					if rearrtid(d)<>"" then
						for i=1 to r_num
							thistid=rearrtid(d)
							retid=kltool_bbs_tclassid(thistid)
							recontent=kltool_bbs_reyu
							reuser=kltool_bbs_reuser
							if recontent="" then
								Response.Write"没有查询到回复语"
								Response.End()
							end if
							if reuser="" then
								Response.Write"没有查询到用户"
								Response.End()
							end if
							rearruser=split(reuser,"|kltool|")
							reuserid=rearruser(0)
							renickname=rearruser(1)
							if recontent<>"" and reuserid<>"" then
								set rs=Server.CreateObject("ADODB.Recordset")
								rs.open"select * from [wap_bbsre]",conn,1,2
									rs.addnew
									rs("devid")=siteid
									rs("userid")=reuserid
									rs("nickname")=renickname
									rs("classid")=retid
									rs("content")=recontent
									rs("bookid")=thistid
									rs("myGetMoney")=0
									rs("book_top")=0
									rs("isCheck")=0
									rs("HangBiaoShi")=0
									rs("isdown")=0
									rs("reply")=0
									rs.update
								rs.close
								set rs=nothing
								conn.execute("update [wap_bbs] set book_re=book_re+1 where id="&rearrtid(d))
							end if
						next
					end if
				next
				Response.Write"帖子增加回复"
			end if
			if r_do="8" then
				conn.Execute("update [wap_bbs] set suport=suport+"&r_num&" where id in("&kid&")")
				Response.Write"帖子增加点赞"
			end if
			if r_do="9" then
				conn.Execute("update [wap_bbs] set suport=suport+"&r_num&" where id in("&kid&")")
				Response.Write"帖子减少点赞"
			end if
		case "10"
			if r_class="" then
				Response.Write"栏目不能为空"
				Response.End()
			end if
			conn.Execute("update [wap_bbs] set book_classid="&r_class&" where id in("&kid&")")
			Response.Write"帖子转移栏目"
	end select
end sub
%>
