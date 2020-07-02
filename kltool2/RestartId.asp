<!--#include file="config.asp"-->
<%
kltool_use(9)
kltool_admin(1)
action=Request.QueryString("action")
select case action
	case ""
		call index()
	case else
		call index1()
end select
sub index()
	html=kltool_head("柯林工具箱-自定义表修改起始ID",1)&_
	
	"<div role=""form"">"&vbcrlf&_
	"	<label for=""name"">已支持的表名</label>"&vbcrlf&_
	"	<div>"&vbcrlf&_
	"    <label class=""radio-inline"">"&vbcrlf&_
	"        <input type=""radio"" name=""r_table"" id=""r_table""  value=""user"" checked>用户表user"&vbcrlf&_
	"    </label>"&vbcrlf&_
	"    <label class=""radio-inline"">"&vbcrlf&_
	"        <input type=""radio"" name=""r_table"" id=""r_table""  value=""class"">栏目表class"&vbcrlf&_
	"    </label>"&vbcrlf&_
	"    <label class=""radio-inline"">"&vbcrlf&_
	"        <input type=""radio"" name=""r_table"" id=""r_table""  value=""wap_bbs"">帖子wap_bbs"&vbcrlf&_
	"    </label>"&vbcrlf&_
	"    <label class=""radio-inline"">"&vbcrlf&_
	"        <input type=""radio"" name=""r_table"" id=""r_table""  value=""wap_bbsre"">回帖wap_bbsre"&vbcrlf&_
	"    </label>"&vbcrlf&_
	"	</div>"&vbcrlf&_
	"	<div class=""form-group"">"&vbcrlf&_
	"		<label for=""name"">自定义:(优先,填写以后上面的选择无效)</label>"&vbcrlf&_
	"		<input type=""text"" class=""form-control"" name=""r_table2"" id=""r_table2"" placeholder="""" value="""&last_userid&""">"&vbcrlf&_
	"	</div>"&vbcrlf&_
	"	<div class=""form-group"">"&vbcrlf&_
	"		<label for=""name"">起始ID(如:10000，那么新的将从10001开始)</label>"&vbcrlf&_
	"		<input type=""text"" class=""form-control"" name=""RestartId"" id=""RestartId"" placeholder="""" value="""">"&vbcrlf&_
	"	</div>"&vbcrlf&_
	"	<button name=""kltool"" type=""button"" class=""btn btn-default btn-block"" id=""Restart_Id"" data-loading-text=""Loading..."">提交</button>"&vbcrlf&_
	"</div>"&vbcrlf
	Response.write kltool_code(html&kltool_end(1))
end sub
sub index1()
	r_table=Request.Form("r_table")
	r_table2=Request.Form("r_table2")
	RestartId=Request.Form("RestartId")
	if RestartId="" or (RestartId<>"" and not Isnumeric(RestartId)) then 
		Response.write "修改失败"
		Response.End()
	end if
	if r_table2<>"" then r_table=r_table2
	conn.execute(" dbcc checkident('"&r_table&"',reseed,"&RestartId&")")
	Response.write r_table&"表起始ID修改为:"&RestartId
end sub
%>