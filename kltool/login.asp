<!--#include file="inc/config.asp"-->
<%
kltool_head("柯林工具箱-验证")
if clng(kltool_logintimes)<clng(kltool_admintimes) then Response.redirect""&kltool_path&"?siteid="&siteid
pg=request("pg")
if pg="" then
%>
<div class="content">
<form method="post" action="?">
<input name="siteid" type="hidden" value="<%=siteid%>">
<input name="pg" type="hidden" value="login">
请输入你的登陆密码
<br/>
<input name="kelink_loginpass" type="password" value="" size="15">
<br/>
<input name="g" type="submit" value="确认">
</form>
</div>
<%
elseif pg="login" then
	kelink_loginpass=request("kelink_loginpass")
	set rs=Server.CreateObject("ADODB.Recordset")
	rs.open"select password,siteid from [user] where siteid="&siteid&" and userid="&userid,conn,1,1
	if MD5(kelink_loginpass)=rs("password") or UCase(MD5(kelink_loginpass))=rs("password") then 
		session("kltool_logintime")=now
		rs.close
		set rs=nothing
		'----
		set rs=Server.CreateObject("ADODB.Recordset")
		rs.open"select * from [kltool_log]",kltool,1,2
		rs.addnew
		rs("userid")=userid
		rs("time")=now
		rs("uip")=kltool_userip
			if kltool_yunxu=1 then
				rs("zt")=1
			else
				rs("zt")=0
			end if
		rs.update
		rs.close
		set rs=nothing
	'---正确，跳转首页
		Response.redirect""&kltool_path&"index.asp?siteid="&siteid
	else
	'---错误，回到本页
		session("kltool_logintime")=""
		Response.redirect"?siteid="&siteid
	end if

end if
kltool_end
%>