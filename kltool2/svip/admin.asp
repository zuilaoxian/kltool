<!--#include file="../config.asp"-->
<%
kltool_admin(1)

action=Request.QueryString("action")
select case action
	case ""
		call index()
	case "vipset"
		call vipset()
	case "prize"
		call prize()
	case "prizeset"
		call prizeset()
	case "log"
		call log()
	case "delvip"
		call delvip()
	case "delprize"
		call delprize()
	case "install"
		call install()
	case "uninstall"
		call uninstall()
end select

sub index()
	kltool_use(2)
	kltool_sql("svip")
	html=kltool_head("柯林工具箱-VIP抽奖-vip设定",1)&_
	"<ul class=""breadcrumb"">"&vbcrlf&_
	"	<li><a href=""?siteid="&siteid&"&action=log"">查看日志</a></li>"&vbcrlf&_
	"	<li>vip设定</li>"&vbcrlf&_
	"	<li><a href=""?siteid="&siteid&"&action=prize"">奖品设定</a></li>"&vbcrlf&_
	"	<li><a href=""./?siteid="&siteid&""">前台</a></li>"&vbcrlf&_
	"</ul>"&vbcrlf
			html=html&"<li class=""list-group-item"">"&vbcrlf&_
			" <div role=""form"" class=""bs-example bs-example-form"">"&vbcrlf&_
			"  <div class=""form-group"">"&vbcrlf&_
			"	<label for=""name"">选择Vip</label>"&vbcrlf&_
			kltool_get_viplist("s_vip0")&_
			"  </div>"&vbcrlf&_
			"  <div class=""form-group input-group"">"&vbcrlf&_
			"    <span class=""input-group-addon"">抽奖次数<br>(每日)</span>"&vbcrlf&_
			"  <input type=""text"" name=""s_num0"" id=""s_num0"" value="""" class=""form-control"">"&vbcrlf&_
			"	<button name=""kltool"" vipid=""0"" type=""button"" class=""btn btn-default btn-block"" id=""Svip_Set"" data-loading-text=""Loading..."">添加</button>"&vbcrlf&_
			"  </div>"&vbcrlf&_
			" </div>"&vbcrlf&_
			"</li>"&vbcrlf
	str=kltool_GetRow("select s_vip,s_num from [svip]",0,30)
	if str(0) then
		count=str(0)
		pagecount=str(1)
		if page>pagecount then page=pagecount
		html=html&kltool_page(1,count,pagecount,gopage)
		For i=0 To ubound(str(2),2)
		s_vip=str(2)(0,i)
		s_num=str(2)(1,i)
			html=html&"<li class=""list-group-item"">"&vbcrlf&_
			" <div role=""form"" class=""bs-example bs-example-form"">"&vbcrlf&_
			"  <div class=""form-group"">"&vbcrlf&_
			"	<label for=""name"">"&s_vip&"."&kltool_get_vip(s_vip,1)&"</label>"&vbcrlf&_
			"  </div>"&vbcrlf&_
			"  <div class=""form-group input-group"">"&vbcrlf&_
			"    <span class=""input-group-addon"">Vip Id</span>"&vbcrlf&_
			"    <input type=""text"" name=""s_vip"&s_vip&""" id=""s_vip"&s_vip&""" value="""&s_vip&""" class=""form-control"">"&vbcrlf&_
			"  </div>"&vbcrlf&_
			"  <div class=""form-group input-group"">"&vbcrlf&_
			"    <span class=""input-group-addon"">日抽奖次数</span>"&vbcrlf&_
			"  <input type=""text"" name=""s_num"&s_vip&""" id=""s_num"&s_vip&""" value="""&s_num&""" class=""form-control"">"&vbcrlf&_
			"  </div>"&vbcrlf&_
			"  <div class=""row"">"&vbcrlf&_
			"    <div class=""col-md-6"">"&vbcrlf&_
			"      <button name=""kltool"" vipid="""&s_vip&""" type=""button"" class=""btn btn-default btn-block"" id=""Svip_Set"" data-loading-text=""Loading..."">修改</button>"&vbcrlf&_
			"    </div>"&vbcrlf&_
			"    <div class=""col-md-6"">"&vbcrlf&_
			"      <a href=""?action=delvip&s_vip="&s_vip&""" id=""tips"" tiptext=""确定要删除吗？"" class=""btn btn-default btn-block"" style=""border-color: #da3131;"">删除</a>"&vbcrlf&_
			"    </div>"&vbcrlf&_
			"  </div>"&vbcrlf&_
			" </div>"&vbcrlf&_
			"</li>"&vbcrlf
		next
		html=html&kltool_page(2,count,pagecount,gopage)
	else
		html=html&"<div class=""alert alert-danger"">暂时没有记录</div>"
	end if
	Response.write kltool_code(html&kltool_end(1))
end sub

sub prize()
	kltool_use(2)
	kltool_sql("svip_prize")
	html=kltool_head("柯林工具箱-VIP抽奖-奖品设定",1)&_
	"<ul class=""breadcrumb"">"&vbcrlf&_
	"	<li><a href=""?siteid="&siteid&"&action=log"">查看日志</a></li>"&vbcrlf&_
	"	<li><a href=""?siteid="&siteid&""">vip设定</a></li>"&vbcrlf&_
	"	<li>奖品设定</li>"&vbcrlf&_
	"	<li><a href=""./?siteid="&siteid&""">前台</a></li>"&vbcrlf&_
	"</ul>"&vbcrlf
			html=html&"<li class=""list-group-item"">"&vbcrlf&_
			" <div role=""form"" class=""bs-example bs-example-form"">"&vbcrlf&_
			"  <div class=""form-group"">"&vbcrlf&_
			"	<label for=""name"">选择奖品</label>"&vbcrlf&_
			kltool_get_prizelist("vip_prize0")&_
			"  </div>"&vbcrlf&_
			"  <div class=""form-group input-group"">"&vbcrlf&_
			"    <span class=""input-group-addon"">奖品最小值</span>"&vbcrlf&_
			"    <input type=""text"" name=""prize10"" id=""prize10"" value="""" class=""form-control"">"&vbcrlf&_
			"  </div>"&vbcrlf&_
			"  <div class=""form-group input-group"">"&vbcrlf&_
			"    <span class=""input-group-addon"">奖品最大值</span>"&vbcrlf&_
			"    <input type=""text"" name=""prize20"" id=""prize20"" value="""" class=""form-control"">"&vbcrlf&_
			"  </div>"&vbcrlf&_
			"	<button name=""kltool"" s_id=""0"" type=""button"" class=""btn btn-default btn-block"" id=""Prize_Set"" data-loading-text=""Loading..."">添加</button>"&vbcrlf&_
			" </div>"&vbcrlf&_
			"</li>"&vbcrlf
	str=kltool_GetRow("select id,s_lx,s_prize1,s_prize2 from [svip_prize]",0,30)
	if str(0) then
		count=str(0)
		pagecount=str(1)
		if page>pagecount then page=pagecount
		html=html&kltool_page(1,count,pagecount,gopage)
		For i=0 To ubound(str(2),2)
		s_id=str(2)(0,i)
		s_lx=str(2)(1,i)
		s_prize1=str(2)(2,i)
		s_prize2=str(2)(3,i)
			html=html&"<li class=""list-group-item"">"&vbcrlf&_
			" <div role=""form"" class=""bs-example bs-example-form"">"&vbcrlf&_
			"  <div class=""form-group"">"&vbcrlf&_
			"	<label for=""name"">奖品"&kltool_get_prize(s_lx)&"</label>"&vbcrlf&_
			"	<input type=""hidden"" name=""vip_prize"&s_id&""" id=""vip_prize"&s_id&""" value="""&s_lx&""" class=""form-control"">"&vbcrlf&_
			"  </div>"&vbcrlf&_
			"  <div class=""form-group input-group"">"&vbcrlf&_
			"    <span class=""input-group-addon"">奖品最小值</span>"&vbcrlf&_
			"    <input type=""text"" name=""prize1"&s_id&""" id=""prize1"&s_id&""" value="""&s_prize1&""" class=""form-control"">"&vbcrlf&_
			"  </div>"&vbcrlf&_
			"  <div class=""form-group input-group"">"&vbcrlf&_
			"    <span class=""input-group-addon"">奖品最大值</span>"&vbcrlf&_
			"    <input type=""text"" name=""prize2"&s_id&""" id=""prize2"&s_id&""" value="""&s_prize2&""" class=""form-control"">"&vbcrlf&_
			"  </div>"&vbcrlf&_

			"  <div class=""row"">"&vbcrlf&_
			"    <div class=""col-md-6"">"&vbcrlf&_
			"      <button name=""kltool"" s_id="""&s_id&""" type=""button"" class=""btn btn-default btn-block"" id=""Prize_Set"" data-loading-text=""Loading..."">修改</button>"&vbcrlf&_
			"    </div>"&vbcrlf&_
			"    <div class=""col-md-6"">"&vbcrlf&_
			"      <a href=""?action=delprize&s_prize="&s_id&""" id=""tips"" tiptext=""确定要删除吗？"" class=""btn btn-default btn-block"" style=""border-color: #da3131;"">删除</a>"&vbcrlf&_
			"    </div>"&vbcrlf&_
			"  </div>"&vbcrlf&_
			
			" </div>"&vbcrlf&_
			"</li>"&vbcrlf
		next
		html=html&kltool_page(2,count,pagecount,gopage)
	else
		html=html&"<div class=""alert alert-danger"">暂时没有记录</div>"
	end if
	Response.write kltool_code(html&kltool_end(1))
end sub


sub log()
	kltool_use(2)
	kltool_sql("svip_log")
	r_search=Request.QueryString("r_search")
	html=kltool_head("柯林工具箱-VIP抽奖-日志",1)&_
	"<ul class=""breadcrumb"">"&vbcrlf&_
	"	<li>查看日志</li>"&vbcrlf&_
	"	<li><a href=""?siteid="&siteid&""">vip设定</a></li>"&vbcrlf&_
	"	<li><a href=""?siteid="&siteid&"&action=prize"">奖品设定</a></li>"&vbcrlf&_
	"	<li><a href=""./?siteid="&siteid&""">前台</a></li>"&vbcrlf&_
	"</ul>"&vbcrlf&_
	"<li class=""list-group-item"">"&vbcrlf&_
	"	<div class=""form-group"">"&vbcrlf&_
	"		<label for=""ksearch"">搜索:输入ID,留空为全部</label><br>"&vbcrlf&_
	"	</div>"&vbcrlf&_
	"	<form method=""get"" action=""?"" class=""form-inline"" role=""form"">"&vbcrlf&_
	"		<input name=""action"" type=""hidden"" value=""log"">"&vbcrlf&_
	"		<input name=""siteid"" type=""hidden"" value="""&siteid&""">"&vbcrlf&_
	"		<div class=""row"">"&vbcrlf&_
	"			<div class=""col-lg-6"">"&vbcrlf&_
	"				<div class=""input-group col-xs-8"">"&vbcrlf&_
	"					<input name=""r_search"" type=""text"" value="""" placeholder="""" class=""form-control"">"&vbcrlf&_
	"					<span class=""input-group-btn"">"&vbcrlf&_
	"						<button class=""btn btn-default"" type=""submit"">"&vbcrlf&_
	"						搜索!"&vbcrlf&_
	"						</button>"&vbcrlf&_
	"					</span>"&vbcrlf&_
	"				</div>"&vbcrlf&_
	"			</div>"&vbcrlf&_
	"		</div>"&vbcrlf&_
	"	</form>"&vbcrlf&_
	"</li>"&vbcrlf
	
	sql="select * from [svip_log]"
	if r_search<>"" then sql=sql&" where s_userid="&r_search
	sql=sql&" order by s_time desc"
	str=kltool_GetRow(sql,0,10)
	If str(0) Then
		gopage="?action=log&"
		if r_search<>"" then gopage="?action=log&r_search="&r_search&"&"
		Count=str(0)
		pagecount=str(1)
		if page>pagecount then page=pagecount
		html=html&kltool_page(1,count,pagecount,gopage)
		For i=0 To ubound(str(2),2)
		id=str(2)(0,i)
		s_userid=str(2)(1,i)
		s_content=str(2)(2,i)
		s_time=str(2)(3,i)
		html=html&"<li class=""list-group-item"">"&vbcrlf&_
			" "&page*PageSize+i-PageSize+1&"."&kltool_get_usernickname(s_userid,2)&"("&s_userid&")"&vbcrlf&_
			" <br/>"&s_content&_
			" <br/><span style=""color: #a0a0a0;font-size:12px;"">("&s_time&")</span>"&vbcrlf&_
			"</li>"&vbcrlf
		Next
		html=html&kltool_page(2,count,pagecount,gopage)
	else
		html=html&"<div class=""alert alert-danger"">暂时没有记录</div>"
	end if
	Response.write kltool_code(html&kltool_end(1))
end sub

sub prizeset()
	s_id=Request.Form("s_id")
	prizeid=Request.Form("s_prize")
	prize1=Request.Form("prize1")
	prize2=Request.Form("prize2")
	if s_id="" or not Isnumeric(s_id) or prizeid="" or not Isnumeric(prizeid) or prize1="" or not Isnumeric(prize1) or prize2="" or not Isnumeric(prize2) then
		Response.write "错误"
		Response.End()
	end if
	set rs=server.CreateObject("adodb.recordset")
	rs.open "select * from [svip_prize] where id="&s_id,conn,1,2
	if rs.eof then
		rs.addnew
		Response.write "新增成功"
	else
		Response.write "修改成功"
	end if
		rs("s_lx")=prizeid
		rs("s_prize1")=prize1
		rs("s_prize2")=prize2
	rs.update
	rs.close
	set rs=nothing
end sub

sub vipset()
	vipid=Request.Form("vipid")
	s_num=Request.Form("s_num")
	if vipid="" or not Isnumeric(vipid) or s_num="" or not Isnumeric(s_num) then
		Response.write "错误"
		Response.End()
	end if
	set rs=server.CreateObject("adodb.recordset")
	rs.open "select * from [svip] where s_vip="&vipid,conn,1,2
	if rs.eof then
		rs.addnew
		Response.write "新增成功"
	else
		Response.write "修改成功"
	end if
		rs("s_vip")=vipid
		rs("s_num")=s_num
	rs.update
	rs.close
	set rs=nothing
end sub

sub delvip()
	s_vip=Request.QueryString("s_vip")
	set rs=server.CreateObject("adodb.recordset")
	rs.open "select * from [svip] where s_vip="&s_vip,conn,1,2
	if rs.eof then
		Response.write "无此记录"
	else
		rs.delete
		Response.write "成功删除"

	end if
	rs.close
	set rs=nothing
end sub
sub delprize()
	s_prize=Request.QueryString("s_prize")
	set rs=server.CreateObject("adodb.recordset")
	rs.open "select * from [svip_prize] where id="&s_prize,conn,1,2
	if rs.eof then
		Response.write "无此记录"
	else
		rs.delete
		Response.write "成功删除"
	end if
	rs.close
	set rs=nothing
end sub
sub install()
	conn.Execute("CREATE TABLE [dbo].[svip] (ID int IDENTITY (1,1) not null PRIMARY key)")
	conn.Execute("ALTER TABLE [svip] ADD [s_vip] bigint")
	conn.Execute("ALTER TABLE [svip] Add [s_num] bigint")

	conn.Execute("CREATE TABLE [dbo].[svip_log] (ID int IDENTITY (1,1) not null PRIMARY key)")
	conn.Execute("ALTER TABLE [svip_log] ADD [s_userid] bigint")
	conn.Execute("ALTER TABLE [svip_log] ADD [s_content] ntext")
	conn.Execute("ALTER TABLE [svip_log] ADD [s_time] datetime")

	conn.Execute("CREATE TABLE [dbo].[svip_prize] (ID int IDENTITY (1,1) not null PRIMARY key)")
	conn.Execute("ALTER TABLE [svip_prize] ADD [s_lx] bigint")
	conn.Execute("ALTER TABLE [svip_prize] ADD [s_prize1] money")
	conn.Execute("ALTER TABLE [svip_prize] ADD [s_prize2] money")
	conn.Execute("ALTER TABLE [svip_prize] ADD [s_state] bigint")
	Response.Write"安装数据库字段成功"
end sub
sub uninstall()
	conn.Execute("DROP TABLE [svip]")
	conn.Execute("DROP TABLE [svip_prize]")
	conn.Execute("DROP TABLE [svip_log]")
	Response.Write"删除数据库字段成功"
end sub
%>