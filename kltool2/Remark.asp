<!--#include file="config.asp"-->
<%
kltool_use(14)
kltool_admin(1)
action=Request.QueryString("action")
select case action
	case ""
		call index()
	case else
		call index1()
end select

sub index()
	html=kltool_head("柯林工具箱-修改会员签名",1)&_
	"<div role=""form"">"&vbcrlf&_
	"  <div class=""form-group"">"&vbcrlf&_
	"	<label for=""name"">请输入ID(留空修改全站)</label>"&vbcrlf&_
	"	<input type=""text"" class=""form-control"" id=""uid"" placeholder="""">"&vbcrlf&_
	"  </div>"&vbcrlf&_
	"  <div class=""form-group"">"&vbcrlf&_
	"	<label for=""remark"">签名修改为</label>"&vbcrlf&_
	"	<textarea class=""form-control"" rows=""3"" id=""remark""></textarea>"&vbcrlf&_
	"  </div>"&vbcrlf&_
	"  <button name=""kltool"" type=""button"" id=""re-mark"" class=""btn btn-default btn-block"" data-loading-text=""Loading..."">提交</button>"&vbcrlf&_
	"</div>"&vbcrlf
	Response.write kltool_code(html&kltool_end(1))
end sub

sub index1()
	uid=Request.Form("uid")
	remarks=Request.Form("remark")
	if remarks="" or (uid<>"" and not isnum(uid)) then
		Response.write"修改失败"
		Response.End()
	end if
	if uid="" then
		ms="全站"
		conn.execute("update [user] set remark='"&remarks&"' where siteid="&siteid)
	else
		ms=kltool_get_usernickname(uid,1)&"("&uid&")"
		set rs=server.CreateObject("adodb.recordset")
		rs.open "select userid,remark from [user] where siteid="&siteid&" and userid="&uid,conn,1,2
		If rs.eof Then
			Response.write"修改失败"
			Response.End()
		end if
		rs("remark")=remarks
		rs.update
		rs.close
		set rs=nothing
	end if
	Response.write ms&" 签名:<br/>"&remarks
end sub
%>