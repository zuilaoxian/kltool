<!--#include file="config.asp"-->
<%
kltool_use(11)
kltool_admin(1)

action=Request.QueryString("action")
select case action
	case ""
		call index()
	case "yes"
		call index1()
	case "yes2"
		call index2()
end select

sub index2()
	set rs=Server.CreateObject("ADODB.Recordset")
	rs.open"select top 1 userid from [user] order by userid desc",conn,1,1
		Response.write clng(rs("userid"))+1
	rs.close
	set rs=nothing
end sub

sub index()
	set rs=Server.CreateObject("ADODB.Recordset")
	rs.open"select top 1 userid from [user] order by userid desc",conn,1,1
		last_userid=clng(rs("userid"))+1
	rs.close
	set rs=nothing
	html=kltool_head("柯林工具箱-批量会员",1)&_
	"<div role=""form"">"&vbcrlf&_
	"	<input name=""siteid"" type=""hidden"" value="""&siteid&""">"&vbcrlf&_
	"	<div class=""form-group"">"&vbcrlf&_
	"		<label for=""name"">要注册的ID</label>"&vbcrlf&_
	"		<input type=""text"" class=""form-control"" name=""r_uid"" id=""r_uid"" placeholder="""" value="""&last_userid&""">"&vbcrlf&_
	"	</div>"&vbcrlf&_
	"	<div class=""form-group"">"&vbcrlf&_
	"		<label for=""name"">所属网站ID(一般为1000)</label>"&vbcrlf&_
	"		<input type=""text"" class=""form-control"" name=""r_siteid"" id=""r_siteid"" placeholder="""" value="""&siteid&""">"&vbcrlf&_
	"	</div>"&vbcrlf&_
	"	<div class=""form-group"">"&vbcrlf&_
	"		<label for=""name"">用户登录名(英/数)(留空则使用ID)</label>"&vbcrlf&_
	"		<input type=""text"" class=""form-control"" name=""r_username"" id=""r_username"" placeholder="""" value="""">"&vbcrlf&_
	"	</div>"&vbcrlf&_
	"	<div class=""form-group"">"&vbcrlf&_
	"		<label for=""name"">昵称(汉/英/数)(留空则随机)</label>"&vbcrlf&_
	"		<input type=""text"" class=""form-control"" name=""r_nick"" id=""r_nick"" placeholder=""示例:"&kltool_rndnick_s&""" value="""">"&vbcrlf&_
	"	</div>"&vbcrlf&_
	"	<div class=""form-group"">"&vbcrlf&_
	"		<label for=""name"">密码-(英/数)(留空则随机)</label>"&vbcrlf&_
	"		<input type=""text"" class=""form-control"" name=""r_pass"" id=""r_pass"" placeholder="""" value="""">"&vbcrlf&_
	"	</div>"&vbcrlf&_
	"	<label for=""name"">权限</label>"&vbcrlf&_
	"	<div class=""form-group"">"&vbcrlf&_
	"    <label class=""radio-inline"">"&vbcrlf&_
	"        <input type=""radio"" name=""r_lvl"" id=""r_lvl"" value=""02"" checked> 普通会员"&vbcrlf&_
	"    </label>"&vbcrlf&_
	"    <label class=""radio-inline"">"&vbcrlf&_
	"        <input type=""radio"" name=""r_lvl"" id=""r_lvl"" value=""01""> 副管"&vbcrlf&_
	"    </label>"&vbcrlf&_
	"    <label class=""radio-inline"">"&vbcrlf&_
	"        <input type=""radio"" name=""r_lvl"" id=""r_lvl"" value=""00""> 超管"&vbcrlf&_
	"    </label>"&vbcrlf&_
	"	</div>"&vbcrlf&_
	"	<label for=""name"">性别</label>"&vbcrlf&_
	"	<div class=""form-group"">"&vbcrlf&_
	"    <label class=""radio-inline"">"&vbcrlf&_
	"        <input type=""radio"" name=""r_sex"" id=""r_sex""  value=""1"" checked> 男"&vbcrlf&_
	"    </label>"&vbcrlf&_
	"    <label class=""radio-inline"">"&vbcrlf&_
	"        <input type=""radio"" name=""r_sex"" id=""r_sex""  value=""0""> 女"&vbcrlf&_
	"    </label>"&vbcrlf&_
	"	</div>"&vbcrlf&_
	"	<button name=""kltool"" type=""button"" class=""btn btn-default btn-block"" id=""RegisterId"" data-loading-text=""Loading..."">提交</button>"&vbcrlf&_
	"</div>"&vbcrlf
	Response.write kltool_code(html&kltool_end(1))
end sub

sub index1()
	r_uid=Request.Form("r_uid")
	r_username=Request.Form("r_username")
	r_siteid=Request.Form("r_siteid")
	r_nick=Request.Form("r_nick")
	r_pass=Request.Form("r_pass")
	r_lvl=Request.Form("r_lvl")
	r_sex=Request.Form("r_sex")
	r_sex=clng(r_sex)
	if r_uid="" then
		Response.write "不能为空"
		Response.End()
	end if
	if not Isnumeric(r_uid) or not Isnumeric(r_siteid) then
		Response.write "必须是数字"
		Response.End()
	end if
		num=clng(r_last_userid)+clng(r_num)-1
	conn.execute("SET IDENTITY_INSERT [USER] ON")
		set rs=Server.CreateObject("ADODB.Recordset")
		rs.open"select * from [user] where userid="&r_uid,conn,1,3
			if not (rs.bof or rs.eof) then
				Response.write "已存在"
				Response.End()
			end if
			rs.addnew
			rs("userid")=r_uid
			rs("siteid")=r_siteid
			if r_username="" then rs("username")=r_uid else rs("username")=r_username
			if r_nick="" then
				rs("nickname")=kltool_rndnick_s
			else
				rs("nickname")=r_nick
			end if
			if r_pass="" then rs("password")=Generate_Key  else rs("password")=r_pass
			rs("managerlvl")=r_lvl
			if r_sex=1 then rs("headimg")=""&RndNumber(30,1)&".gif" else rs("headimg")=""&RndNumber(64,31)&".gif"
			rs("sex")=r_sex
			rs.update
		rs.close
		set rs=nothing
		conn.execute("SET IDENTITY_INSERT [USER] OFF")
		Response.write "成功注册ID："&r_uid
end sub
%>
