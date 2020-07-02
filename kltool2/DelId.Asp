<!--#include file="config.asp"-->
<%
kltool_use(15)
kltool_admin(1)
action=Request.QueryString("action")
select case action
	case ""
		call index()
	case else
		call index1()
end select

sub index()
	html=kltool_head("删除会员",1)&_
	"<div class=""well well-sm"">单个格式:1000</div>"&vbcrlf&_
	"<div class=""well well-sm"">连续格式:1000-2000</div>"&vbcrlf&_
	"<div class=""well well-sm"">乱序格式:1000,1002,1003</div>"&vbcrlf&_

	"<div class=""form-group"">"&vbcrlf&_
	"	<label for=""name"">Delete IDs</label>"&vbcrlf&_
	"	<input type=""text"" class=""form-control"" id=""uid"" placeholder="""">"&vbcrlf&_
	"</div>"&vbcrlf&_
	"<div id=""myButtons3"" class=""bs-example"">"&vbcrlf&_
	"	<button name=""kltool"" type=""button"" id=""T-DelId"" class=""btn btn-primary btn-block"" data-loading-text=""Loading..."">提交</button>"&vbcrlf&_
	"</div>"&vbcrlf&_
	  
	"<div id=""myAlert2"" class=""alert alert-warning"">"&vbcrlf&_
	"	<a href=""#"" class=""close"" data-dismiss=""alert"">&times;</a>"&vbcrlf&_
	"	<strong>提醒！</strong>删除后不可恢复.帖子、站内信等不删除"&vbcrlf&_
	"</div>"&vbcrlf
	Response.write kltool_code(html&kltool_end(1))
end sub

sub index1()
uid=Request.Form("uid")
if Isnumeric(uid) then
	if instr(uid,",") then
		uids=split(uid,",")
		for i=0 to ubound(uids)
			if not Isnumeric(uids(i)) or clng(uids(i))<=1000 then
				Response.write"未能删除"&uid
				Response.End()
				Exit For
			end if
		next
		kltool_write_log("删除id:"&uid)
		Response.write"成功删除"&uid
		conn.execute("delete from [user] where siteid="&siteid&" and userid in ("&uid&")")
	else
		set rs=server.CreateObject("adodb.recordset")
		rs.open "select userid from [user] where siteid="&siteid&" and userid="&uid,conn,1,2
			If not rs.eof and clng(uid)>1000 then
			rs.delete
				kltool_write_log("删除id:"&uid)
				Response.write"成功删除"&uid
			else
				Response.write"未能删除"&uid
			end if
		rs.close
		set rs=nothing
	end if
elseif instr(uid,"-") then
		uids=split(uid,"-")
		if uids(0)<=1000 or not Isnumeric(uids(1)) then
			Response.write"未能删除"&uid&""
		else
			kltool_write_log("删除id:"&uid)
			conn.execute("delete from [user] where siteid="&siteid&" and userid between "&uids(0)&" and "&uids(1))
			Response.write"成功删除"&uid
		end if
end if
end sub
%>