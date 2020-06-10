<!--#include file="../inc/config.asp"-->
<%
kltool_head("柯林工具箱-帖子管理")
kltool_quanxian

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
'-----
pg=request("pg")
	if pg="" then
	uid=request("uid")
	cid=request("cid")
	if uid<>"" and not Isnumeric(uid) then response.redirect "?siteid="&siteid
	if cid<>"" and not Isnumeric(cid) then response.redirect "?siteid="&siteid
	Response.write "<div class=""tip"">联合查询：<span class=""right""><a href=""admin1.asp?siteid="&siteid&""">回复语设置</a></span><br/>"&vbcrlf
	Response.write "<form method=""post"" action=""?"">"&vbcrlf
	Response.write "<input name=""siteid"" type=""hidden"" value="""&siteid&""">"&vbcrlf
	set rs=conn.execute("select * from [class] where userid="&siteid&" and typeid=16")
	Response.write "<select name='cid'><option value=''>查看全部</option>"&vbcrlf
	Do While Not rs.EOF
	Response.Write"<option value='"&rs("classid")&"'"
	if cid<>"" then
	if clng(rs("classid"))=clng(cid) then Response.Write" selected"
	end if
	Response.Write">"&rs("classid")&"-"&rs("classname")&"</option>"&vbcrlf
	rs.MoveNext 
	Loop
	Response.write "</select>"&vbcrlf
	rs.close
	set rs=nothing
	Response.write "<input name=""uid"" type=""text"" value="""" size=""12"" placeholder=""输入会员ID"">"&vbcrlf
	Response.write "<input name=""g"" type=""submit"" value=""确定""></form></div>"&vbcrlf
	
	Response.write "<div class=""tip"">替换帖子内容 输入 关键词:<br/><form method=""post"" action=""keyword.asp"">"&vbcrlf
	Response.write "<input name=""siteid"" type=""hidden"" value="""&siteid&""">"&vbcrlf
	set rs=conn.execute("select * from [class] where userid="&siteid&" and typeid=16")
	Response.write "<select name='cid'><option value=''>查看全部</option>"&vbcrlf
	Do While Not rs.EOF
	Response.Write"<option value='"&rs("classid")&"'"
	if cid<>"" then
	if clng(rs("classid"))=clng(cid) then Response.Write" selected"
	end if
	Response.Write">"&rs("classid")&"-"&rs("classname")&"</option>"&vbcrlf
	rs.MoveNext 
	Loop
	Response.write "</select>"&vbcrlf
	rs.close
	set rs=nothing
	Response.write "<input name=""keyword1"" type=""text"" value="""" size=""12"" placeholder=""原字符串"">"&vbcrlf
	Response.write "<input name=""keyword2"" type=""text"" value="""" size=""12"" placeholder=""将要替换"">"&vbcrlf
	Response.write "<input name=""g"" type=""submit"" value=""确定""></form></div>"&vbcrlf
	
	set rs=Server.CreateObject("ADODB.Recordset")
	if uid<>"" and cid<>"" then
	rs.open"select * from [wap_bbs] where book_classid="&cid&" and book_pub="&uid&" and userid="&siteid&" Order by id desc",conn,1,1
	elseif uid="" and cid<>"" then
	rs.open"select * from [wap_bbs] where book_classid="&cid&" and userid="&siteid&" Order by id desc",conn,1,1
	elseif uid<>"" and cid="" then
	rs.open"select * from [wap_bbs] where book_pub="&uid&" and userid="&siteid&" Order by id desc",conn,1,1
	else
	rs.open"select * from [wap_bbs] where userid="&siteid&" Order by id desc",conn,1,1
	end if
	If Not rs.eof Then
		gopage="?cid="&cid&"&amp;uid="&uid&"&amp;"
		Count=rs.recordcount
		pagecount=(count+pagesize-1)\pagesize
		if page>pagecount then page=pagecount
		rs.move(pagesize*(page-1))
	call kltool_page(1)
	Response.write "<form name=""formDel"" method=""post"" action="""&gopage&"siteid="&siteid&"&amp;page="&page&"&amp;pg=bbs"">"&vbcrlf
		For i=1 To PageSize
		If rs.eof Then Exit For
	if (i mod 2)=0 then Response.write "<div class=line1>" else Response.write "<div class=line2>"
	Response.write rs("id")&":(<input type=""checkbox"" name=""tid"" value="""&rs("id")&""">)"
	if rs("isCheck")=2 then Response.write"(已删)"
	Response.write"<a href=""/bbs/book_view.aspx?siteid="&siteid&"&amp;classid="&rs("book_classid")&"&amp;id="&rs("id")&""">"&rs("book_title")&"</a>"
	set rs1=conn.execute("select * from [class] where classid="&rs("book_classid"))
	if not rs1.eof then Response.write"("&rs("book_classid")&"<a href=""?siteid="&siteid&"&amp;cid="&rs("book_classid")&""">"&rs1("classname")&"</a>)" else Response.write"("&rs("book_classid")&"栏目不存在)"
	rs1.close
	set rs1=nothing
	Response.write "<br/>　　(作者:<a href=""/bbs/userinfo.aspx?siteid="&siteid&"&amp;touserid="&rs("book_pub")&""">"&kltool_get_usernickname(rs("book_pub"),1)&"</a>"
	Response.write "/<a href=""?siteid="&siteid&"&amp;uid="&rs("book_pub")&""">"&rs("book_pub")&"</a>)(<a href="""&gopage&"siteid="&siteid&"&amp;page="&page&"&amp;tid="&rs("id")&"&amp;pg=rebbs"">修改</a>)</div>"
	
	Response.write "<div class=tip>(阅:"&rs("book_click")&")"
	Response.write "/(回:"&rs("book_re")&")"
	Response.write "/(赞"&rs("suport")&")"
	Response.write"</div>"&vbcrlf
	rs.movenext
	Next
	Response.write"<div class=tip><span><input type=""checkbox"" name=""all"" onclick=""check_all(this,'tid')"">全选/反选</span> "
	Response.write "<select name='action' onchange=""getValues('Re',this.value,'3458');getValues('Re2',this.value,'7')""><option value='0'>可选操作</option>"
	Response.Write"<option value='1'>删除</option>"
	Response.Write"<option value='2'>恢复</option>"
	Response.Write"<option value='3'>增加阅读量</option>"
	Response.Write"<option value='4'>减少阅读量</option>"
	Response.Write"<option value='5'>增加回复</option>"
	Response.Write"<option value='6'>彻底删除</option>"
	Response.Write"<option value='7'>转移栏目</option>"
	Response.Write"<option value='8'>增加点赞数</option>"
	Response.write"</select><span id=""Re"" style=""display:none"">数量:<input type=""text"" name=""click"" maxlength=""2"" size=""5""></span><span id=""Re2"" style=""display:none"">"
	Set rs1=Server.CreateObject("ADODB.Recordset")
	rs1.open "Select * from [class] where userid="&siteid&" and typeid=16",conn,1,1
	Response.write "转移栏目:<select name='clid'>"
	Do While Not rs1.EOF
	Response.Write "<option value='"&rs1("classid")&"' checked>"&rs1("classid")&"-"&rs1("classname")&"</option>" 
	rs1.MoveNext 
	Loop
	Response.Write "</select></span>"
	rs1.close
	set rs1=nothing

	Response.write "<input type=""submit"" value=""确定操作"" onClick=""ConfirmDel('是否确定?');return false""></form></div>"
	call kltool_page(2)
		else
	Response.write "<div class=tip>暂时没有记录！</div>"
		end if
	rs.close
	set rs=nothing
'-----
elseif pg="bbs" then
	click=request("click")
	page=request("page")
	if page="" then page=1
	uid=request("uid")
	cid=request("cid")
	tid=trim(request("tid"))
	action=request("action")
	clid=request("clid")
	if (action="3" or action="4") and click="" then call kltool_msge("点击量不能为空")
	if click<>"" and not Isnumeric(click) then call kltool_msge("点击量必须为数字")
	if tid="" then call kltool_msge("未选择任何记录")
	if action="1" then
		conn.Execute("update [wap_bbs] set isCheck=2 where id in("&tid&")")
		call kltool_write_log("(帖子)标记删除，帖子ID"&tid)
	elseif action="2" then
		conn.Execute("update [wap_bbs] set isCheck=0 where id in("&tid&")")
		call kltool_write_log("(帖子)标记恢复，帖子ID"&tid)
	elseif action="3" then
		conn.Execute("update [wap_bbs] set book_click=book_click+"&clng(click)&" where id in("&tid&")")
		call kltool_write_log("(帖子)增加阅读量("&click&")，，帖子ID"&tid)
	elseif action="4" then
		conn.Execute("update [wap_bbs] set book_click=book_click-"&clng(click)&" where id in("&tid&")")
		call kltool_write_log("(帖子)减少阅读量("&click&")，，帖子ID"&tid)
	elseif action="5" then
	rearrtid=split(tid,",")
	for d=0 to ubound(rearrtid)
	if rearrtid(d)<>"" then
		for i=1 to click
			thistid=rearrtid(d)
			retid=kltool_bbs_tclassid(thistid)
			recontent=kltool_bbs_reyu
			if recontent="" then call kltool_msge("没有查询到回复语！")
				reuser=kltool_bbs_reuser
			if reuser="" then call kltool_msge("没有查询到用户！")
				rearruser=split(reuser,"|kltool|")
				reuserid=rearruser(0)
				renickname=rearruser(1)
		if content<>"" and reuserid<>"" then
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
		conn.execute("update [wap_bbs] set book_re=book_re+1 where id="&rearrtid(d))
		end if
		next
	end if
	next
		call kltool_write_log("(帖子)一键回复，帖子ID:"&tid)
	elseif action="6" then
		conn.Execute("delete from [wap_bbs] where id in("&tid&")")
		call kltool_write_log("(帖子)彻底删除，帖子ID:"&tid)
	elseif action="7" then
		conn.Execute("update [wap_bbs] set book_classid="&clid&" where id in("&tid&")")
		call kltool_write_log("(帖子)转移栏目("&clid&")，帖子ID:"&tid)
	elseif action="8" then
		conn.Execute("update [wap_bbs] set suport=suport+"&clng(click)&" where id in("&tid&")")
		call kltool_write_log("(帖子)增加点赞数("&click&")，帖子ID:"&tid)
	else

	end if
		response.redirect "?siteid="&siteid&"&page="&page&"&uid="&uid&"&cid="&cid
'-----
elseif pg="rebbs" then
	page=request("page")
	uid=request("uid")
	cid=request("cid")
	tid=request("tid")
	if page="" then page=1

	if tid="" then call kltool_msge("id不能为空")
	if not Isnumeric(tid) then call kltool_msge("必须为数字")
	set rs=Server.CreateObject("ADODB.Recordset")
	rs.open"select * from [wap_bbs] where id="&tid,conn,1,1
	if rs.eof then call kltool_msge("无此记录")
	Response.write "<form method=""post"" action=""?page="&page&"&uid="&uid&"&cid="&cid&""">"
	Response.write "<input name=""siteid"" type=""hidden"" value="""&siteid&""">"
	Response.write "<input name=""pg"" type=""hidden"" value=""rebbsyes"">"
	Response.write "<input name=""tid"" type=""hidden"" value="""&tid&""">"

	Set rs1=Server.CreateObject("ADODB.Recordset")
	rs1.open "Select * from [class] where userid="&siteid&" and typeid=16",conn,1,1
	Response.write"<div class=line2>所属栏目:<select name='clid'>"
	Do While Not rs1.EOF
	Response.Write"<option value='"&rs1("classid")&"'"
	if clng(rs1("classid"))=clng(rs("book_classid")) then Response.Write" selected"
	Response.Write">"&rs1("classid")&"-"&rs1("classname")&"</option>" 
	rs1.MoveNext 
	Loop
	Response.Write "</select></div>"
	rs1.close
	set rs1=nothing

	set rs2=server.CreateObject("adodb.recordset")
	rs2.open "select * from [wap2_smallType] where siteid="&siteid&" and systype like '%bbs%'",conn,1,1
	Response.write "<div class=line1>所属专题:<select name='topic'><option value='"&rs("topic")&"'>"&rs("topic")&"</option>"
	Do While Not RS2.EOF
	Response.Write "<option value='"&rs2("id")&"'>"&rs2("systype")&"-"&rs2("subclassName")&"</option>" 
	RS2.MoveNext 
	Loop
	Response.Write "</select></div>"
	rs2.close
	set rs2=nothing

	Response.write "<div class=""title"">标题:<br/><textarea name=""title"" rows=""5"">"&rs("book_title")&"</textarea></div>"
	Response.write "<div class=""content"">内容:<br/><textarea name=""content"" rows=""8"">"&rs("book_content")&"</textarea></div>"
	Response.write "<div class=""line1"">作者:<input name=""pub"" type=""text"" value="""&rs("book_pub")&"""></div>"
	Response.write "<div class=""line2""><input type=""submit"" value=""确定修改"" onClick=""ConfirmDel('是否确定？');return false""></form> <a href=""?siteid="&siteid&"&page="&page&"&uid="&uid&"&cid="&cid&""">返回帖子管理</a>/<a href=""/bbs/view.aspx?id="&tid&""">查看帖子</a></div>"
	rs.close
	set rs=nothing

'-----
elseif pg="rebbsyes" then
	page=request("page")
	uid=request("uid")
	cid=request("cid")
	tid=request("tid")
	clid=request("clid")
	topic=request("topic")
	title=request("title")
	content=request("content")
	pub=request("pub")
	if page="" then page=1

	if tid="" or not Isnumeric(tid) then call kltool_msge("不能为空且必须为数字")
	if pub="" or not Isnumeric(pub) then call kltool_msge("不能为空且必须为数字")
	set rs=Server.CreateObject("ADODB.Recordset")
	rs.open"select * from [wap_bbs] where id="&tid,conn,1,2
	if rs.bof or rs.eof then call kltool_msge("无此记录")
	rs("book_classid")=clid
	if topic<>"" and Isnumeric(topic) then rs("topic")=topic
	rs("book_title")=title
	rs("book_content")=content
	rs("book_pub")=pub
	rs.update
	rs.close
	set rs=nothing
	call kltool_write_log("(帖子)修改帖子，ID:"&tid&",标题:"&title)
	response.redirect "?siteid="&siteid&"&pg=rebbs&tid="&tid&"&page="&page&"&uid="&uid&"&cid="&cid
end if

kltool_end
%>
