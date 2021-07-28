<!--#include file="config.asp"-->
<%
kltool_use(10)
kltool_admin(1)
action=Request.QueryString("action")
select case action
	case ""
		call index()
	case else
		call index1()
end select

sub index()
	uid=Request.QueryString("uid")
	html=kltool_head("柯林工具箱-会员会员资料",1)
	html2=""&_
		"<div role=""form"" class=""form-horizontal"">"&vbcrlf&_
		"	<div class=""form-group"">"&vbcrlf&_
		"		<label for=""r_uid"" class=""col-sm-2 control-label"">请输入ID</label>"&vbcrlf&_
		"		<div class=""col-sm-10"">"&vbcrlf&_
		"			<input type=""text"" class=""form-control"" name=""r_uid"" id=""r_uid"" value="""" placeholder=""输入后点击空白处"">"&vbcrlf&_
		"		</div>"&vbcrlf&_
		"	</div>"&vbcrlf&_
		"</div>"&vbcrlf
	if uid="" then

		Response.write kltool_code(html&html2&kltool_alert("会员ID不能为空")&kltool_end(1))
		Response.End()
	end if
	sql="select * from [user] where "
	if Isnumeric(uid) then sql=sql&"userid="&uid else sql=sql&"username='"&uid&"'"
	set rs=server.CreateObject("adodb.recordset")
	rs.open sql,conn,1,1
		If rs.eof Then
			Response.write kltool_code(html&html2&kltool_alert("查无此ID")&kltool_end(1))
			Response.End()
		end if
	if rs("sex")="1" then sexcheck1="checked" else sexcheck2="checked"
	if rs("LockUser")="1" then lockcheck1="checked" else lockcheck2="checked"
	if rs("managerlvl")="00" then lvlcheck0="checked"
	if rs("managerlvl")="01" then lvlcheck1="checked"
	if rs("managerlvl")="02" then lvlcheck2="checked"
	if rs("managerlvl")="03" then lvlcheck3="checked"
	if rs("managerlvl")="04" then lvlcheck4="checked"
	html=html&"<form role=""form"" class=""form-horizontal"" id=""reuserdata"">"&vbcrlf&_
	"	<div class=""form-group"">"&vbcrlf&_
	"		<label for=""r_uid"" class=""col-sm-2 control-label"">他的ID</label>"&vbcrlf&_
	"		<div class=""col-sm-10"">"&vbcrlf&_
	"			<input type=""text"" class=""form-control"" name=""r_uid"" id=""r_uid"" value="""&uid&""" >"&vbcrlf&_
	"		</div>"&vbcrlf&_
	"	</div>"&vbcrlf&_
	"	<div class=""form-group"">"&vbcrlf&_
	"		<label for=""r_siteid"" class=""col-sm-2 control-label"">所属网站ID</label>"&vbcrlf&_
	"		<div class=""col-sm-10"">"&vbcrlf&_
	"			<input type=""text"" class=""form-control"" name=""r_siteid"" id=""r_siteid"" value="""&rs("siteid")&""">"&vbcrlf&_
	"		</div>"&vbcrlf&_
	"	</div>"&vbcrlf&_
	"	<div class=""form-group"">"&vbcrlf&_
	"		<label for=""r_username"" class=""col-sm-2 control-label"">用户登录名(英/数)</label>"&vbcrlf&_
	"		<div class=""col-sm-10"">"&vbcrlf&_
	"			<input type=""text"" class=""form-control"" name=""r_username"" id=""r_username"" value="""&rs("username")&""">"&vbcrlf&_
	"		</div>"&vbcrlf&_
	"	</div>"&vbcrlf&_
	"	<div class=""form-group"">"&vbcrlf&_
	"		<label for=""r_nick"" class=""col-sm-2 control-label"">昵称(汉/英/数)</label>"&vbcrlf&_
	"		<div class=""col-sm-10"">"&vbcrlf&_
	"			<input type=""text"" class=""form-control"" name=""r_nick"" id=""r_nick"" value="""&rs("nickname")&""">"&vbcrlf&_
	"		</div>"&vbcrlf&_
	"	</div>"&vbcrlf&_
	"	<div class=""form-group"">"&vbcrlf&_
	"		<label for=""r_pass""  class=""col-sm-2 control-label"">密码-(英/数)</label>"&vbcrlf&_
	"		<div class=""col-sm-10"">"&vbcrlf&_
	"			<input type=""text"" class=""form-control"" name=""r_pass"" id=""r_pass"" placeholder=""不修改则留空"">"&vbcrlf&_
	"		</div>"&vbcrlf&_
	"	</div>"&vbcrlf&_
	"	<div class=""form-group"" class=""col-sm-2 control-label"">"&vbcrlf&_
	"		<label for=""r_money"" class=""col-sm-2 control-label"">[sitemoneyname]</label>"&vbcrlf&_
	"		<div class=""col-sm-10"">"&vbcrlf&_
	"			<input type=""text"" class=""form-control"" name=""r_money"" id=""r_money"" value="""&rs("money")&""">"&vbcrlf&_
	"		</div>"&vbcrlf&_
	"	</div>"&vbcrlf&_
	"	<div class=""form-group"">"&vbcrlf&_
	"		<label for=""r_exp"" class=""col-sm-2 control-label"">经验</label>"&vbcrlf&_
	"		<div class=""col-sm-10"">"&vbcrlf&_
	"			<input type=""text"" class=""form-control"" name=""r_exp"" id=""r_exp"" value="""&rs("expr")&""">"&vbcrlf&_
	"		</div>"&vbcrlf&_
	"	</div>"&vbcrlf&_
	"	<div class=""form-group"">"&vbcrlf&_
	"		<label for=""r_rmb"" class=""col-sm-2 control-label"">RMB</label>"&vbcrlf&_
	"		<div class=""col-sm-10"">"&vbcrlf&_
	"			<input type=""text"" class=""form-control"" name=""r_rmb"" id=""r_rmb"" value="""&rs("rmb")&""">"&vbcrlf&_
	"		</div>"&vbcrlf&_
	"	</div>"&vbcrlf&_
	"	<div class=""form-group"">"&vbcrlf&_
	"		<label for=""r_bankmoney"" class=""col-sm-2 control-label"">存款</label>"&vbcrlf&_
	"		<div class=""col-sm-10"">"&vbcrlf&_
	"			<input type=""text"" class=""form-control"" name=""r_bankmoney"" id=""r_bankmoney"" value="""&rs("mybankmoney")&""">"&vbcrlf&_
	"		</div>"&vbcrlf&_
	"	</div>"&vbcrlf&_
	"	<div class=""form-group"">"&vbcrlf&_
	"		<label for=""r_logintimes"" class=""col-sm-2 control-label"">在线积时</label>"&vbcrlf&_
	"		<div class=""col-sm-10"">"&vbcrlf&_
	"			<input type=""text"" class=""form-control"" name=""r_logintimes"" id=""r_logintimes"" value="""&rs("logintimes")&""">"&vbcrlf&_
	"		</div>"&vbcrlf&_
	"	</div>"&vbcrlf&_
	"	<div class=""form-group"">"&vbcrlf&_
	"		<label for=""r_zone"" class=""col-sm-2 control-label"">空间人气</label>"&vbcrlf&_
	"		<div class=""col-sm-10"">"&vbcrlf&_
	"			<input type=""text"" class=""form-control"" name=""r_zone"" id=""r_zone"" value="""&rs("ZoneCount")&""">"&vbcrlf&_
	"		</div>"&vbcrlf&_
	"	</div>"&vbcrlf&_
	"	<div class=""form-group"">"&vbcrlf&_
	"		<label for=""r_remake"" class=""col-sm-2 control-label"">个性签名</label>"&vbcrlf&_
	"		<div class=""col-sm-10"">"&vbcrlf&_
	"			<textarea class=""form-control"" rows=""3"" name=""r_remake"" id=""r_remake"">"&rs("remark")&"</textarea>"&vbcrlf&_
	"		</div>"&vbcrlf&_
	"	</div>"&vbcrlf&_
	"	<label for=""r_lvl"" class=""col-sm-2 control-label"">权限</label>"&vbcrlf&_
	"	<div>"&vbcrlf&_
	"    <label class=""radio-inline"">"&vbcrlf&_
	"        <input type=""radio"" name=""r_lvl"" id=""r_lvl"" value=""02"" "&lvlcheck2&"> 普通会员"&vbcrlf&_
	"    </label>"&vbcrlf&_
	"    <label class=""radio-inline"">"&vbcrlf&_
	"        <input type=""radio"" name=""r_lvl"" id=""r_lvl"" value=""01"" "&lvlcheck1&"> 副管"&vbcrlf&_
	"    </label>"&vbcrlf&_
	"    <label class=""radio-inline"">"&vbcrlf&_
	"        <input type=""radio"" name=""r_lvl"" id=""r_lvl"" value=""00"" "&lvlcheck0&"> 超管"&vbcrlf&_
	"    </label>"&vbcrlf&_
	"    <label class=""radio-inline"">"&vbcrlf&_
	"        <input type=""radio"" name=""r_lvl"" id=""r_lvl"" value=""03"" "&lvlcheck3&"> 总编辑"&vbcrlf&_
	"    </label>"&vbcrlf&_
	"    <label class=""radio-inline"">"&vbcrlf&_
	"        <input type=""radio"" name=""r_lvl"" id=""r_lvl"" value=""04"" "&lvlcheck4&"> 总版主"&vbcrlf&_
	"    </label>"&vbcrlf&_
	"	</div>"&vbcrlf&_
	"	<label for=""r_sex"" class=""col-sm-2 control-label"">性别</label>"&vbcrlf&_
	"	<div>"&vbcrlf&_
	"    <label class=""radio-inline"">"&vbcrlf&_
	"        <input type=""radio"" name=""r_sex"" id=""r_sex""  value=""1"" "&sexcheck1&"> 男"&vbcrlf&_
	"    </label>"&vbcrlf&_
	"    <label class=""radio-inline"">"&vbcrlf&_
	"        <input type=""radio"" name=""r_sex"" id=""r_sex""  value=""0"" "&sexcheck2&"> 女"&vbcrlf&_
	"    </label>"&vbcrlf&_
	"	</div>"&vbcrlf&_
	"	<label for=""r_lock"" class=""col-sm-2 control-label"">状态</label>"&vbcrlf&_
	"	<div>"&vbcrlf&_
	"    <label class=""radio-inline"">"&vbcrlf&_
	"        <input type=""radio"" name=""r_lock"" id=""r_lock""  value=""1"" "&lockcheck1&"> 已锁定"&vbcrlf&_
	"    </label>"&vbcrlf&_
	"    <label class=""radio-inline"">"&vbcrlf&_
	"        <input type=""radio"" name=""r_lock"" id=""r_lock""  value=""0"" "&lockcheck2&"> 正常"&vbcrlf&_
	"    </label>"&vbcrlf&_
	"	</div>"&vbcrlf&_
	"	  <button name=""kltool"" type=""button"" class=""btn btn-default btn-block"" id=""UserData"" data-loading-text=""Loading..."">提交</button>"&vbcrlf&_
	"</form>"&vbcrlf
	rs.close
	set rs=nothing
	Response.write kltool_code(html&kltool_end(1))
end sub
sub index1()
	r_uid=Request.Form("r_uid")
	r_siteid=Request.Form("r_siteid")
	r_username=Request.Form("r_username")
	r_nick=Request.Form("r_nick")
	r_pass=Request.Form("r_pass")
	r_money=Request.Form("r_money")
	r_exp=Request.Form("r_exp")
	r_rmb=Request.Form("r_rmb")
	r_bankmoney=Request.Form("r_bankmoney")
	r_logintimes=Request.Form("r_logintimes")
	r_zone=Request.Form("r_zone")
	r_remake=Request.Form("r_remake")
	r_lvl=Request.Form("r_lvl")
	r_sex=Request.Form("r_sex")
	r_lock=Request.Form("r_lock")
	
	set rs=Server.CreateObject("ADODB.Recordset")
	rs.open"select * from [user] where userid="&r_uid,conn,1,2
	if rs.eof then
		Response.write "会员不存在"
		Response.End()
	end if
	if clng(r_uid)<>siteid then 
		if r_siteid<>"" then rs("siteid")=r_siteid
		if r_lvl<>"" then rs("managerlvl")=r_lvl
		if r_lock<>"" then rs("LockUser")=r_lock
	end if
		if r_username<>"" then rs("username")=r_username
		if r_nick<>"" then rs("nickname")=r_nick
		if r_pass<>"" then rs("password")=MD5(r_pass)
		if r_money<>"" then rs("money")=r_money
		if r_exp<>"" then rs("expR")=r_exp
		if r_rmb<>"" then rs("RMB")=r_rmb
		if r_bankmoney<>"" then rs("mybankmoney")=r_bankmoney
		if r_logintimes<>"" then rs("LoginTimes")=r_logintimes
		if r_zone<>"" then rs("ZoneCount")=r_zone
		if r_remake<>"" then rs("remark")=r_remake
		if r_sex<>"" then rs("sex")=r_sex
	rs.update
	rs.close
	set rs=nothing
	Response.write "修改成功"
end sub 
%>