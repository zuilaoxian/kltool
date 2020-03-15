<!--#include file="../inc/config.asp"-->
<%
kltool_head("柯林工具箱-验证管理")
kltool_quanxian
pg=request("pg")
if pg="" then
	if userid=siteid then response.write"<div class=""title""><a href='?pg=log&amp;siteid="&siteid&"&lx=1'>登录日志</a>/<a href='?pg=log&amp;siteid="&siteid&"&lx=2'>操作日志</a></div>"
	set rs=server.CreateObject("adodb.recordset")
	rs.open "select * from [yanzheng] where id=1",kltool,1,1
	response.write"<div class=""tip"">此处设置进入工具箱是否需要验证密码</div>"
	if kltool_yanzheng=1 then Response.write "<div class=""title"">已进行：("&kltool_logintimes&"/"&kltool_admintimes&")分钟</div>"
	response.write"<div class=""line2"">是否需要:"
	if rs("yanzheng")=1 then response.write"√" else response.write"×"
	if rs("yanzheng")=1 then response.write"<br/>验证时长:"&rs("timelong")&"分钟"
	response.write"</div>"
	rs.close
	set rs=nothing
	response.write"<div class=""tip"">修改验证状态</div>"
	response.write"<div class=""content"">"
	response.write"<form method=""post"" action=""?"">"
	response.write"<input name=""siteid"" type=""hidden"" value="""&siteid&""">"
	response.write"<input name=""pg"" type=""hidden"" value=""xg"">"
	response.write"是否验证:"
	response.write"<select name=""y"">"
	response.write"<option value=""1"">√</option>"
	response.write"<option value=""0"">×</option>"
	response.write"</select><br/>"
	response.write"验证时长(不验证则不管)</small><br/>"
	response.write"<input type=""text"" name=""z"" value="""&kltool_admintimes&""" size=""10""><br/>"
	response.write"<div class=""tip"">列表数量</div>"
	response.write"管理专用<input type=""text"" name=""listsize"" size=""10"" value="""&kltool_listsize&"""><br/>"
	response.write"会员专用<input type=""text"" name=""listsize2"" size=""10"" value="""&kltool_listsize2&"""><br/>"
	response.write"<input name=""g"" type=""submit"" value=""确定"" onClick=""ConfirmDel('是否确定？');return false""></form>"
	response.write"</div>"
'-----
elseif pg="xg" then
	y=request("y")
	z=request("z")
	listsize=request("listsize")
	listsize2=request("listsize2")
	if not Isnumeric(z) or z<1 then call kltool_msge("验证时长必须为数字且不能小于1分钟")
	if not Isnumeric(listsize) or not Isnumeric(listsize2) then call kltool_msge("列表数量必须为数字")

	if listsize="" or listsize<0 then call kltool_msge("不能为空或小于0")
	if listsize2="" or listsize2<0 then call kltool_msge("不能为空或小于0")
	set rs=server.CreateObject("adodb.recordset")
	rs.open "select * from [yanzheng] where id=1",kltool,1,2
	rs("listsize")=listsize
	rs("listsize2")=listsize2

		if int(y)=1 then
	rs("yanzheng")=y
	rs("timelong")=z
	call kltool_write_log("设置进入后台需验证，超时为"&z&"分钟;列表数量：管理"&listsize&",普通"&listsize2)
		elseif int(y)=0 then
	rs("yanzheng")=y
	rs("timelong")=z
	call kltool_write_log("修改进入后台无需验证;列表数量：管理"&listsize&",普通"&listsize2)

		end if
	rs.update
	rs.close
	set rs=nothing
	if int(y)=1 then Response.redirect""&kltool_path&"login.asp?siteid="&siteid else response.redirect "?siteid="&siteid
'-----
elseif pg="log" then
	Response.write "<div class=""title""><a href=""?siteid="&siteid&""">返回验证管理</a>/<a href='?pg=log&amp;siteid="&siteid&"&lx=1'>登录日志</a>/<a href='?pg=log&amp;siteid="&siteid&"&lx=2'>操作日志</a></div>"
	lx=clng(request("lx"))
	if lx="" or lx<=0 then lx=1
	set rs=Server.CreateObject("ADODB.Recordset")
	if lx=1 then
	rs.open"select * from [kltool_log] where things is null order by id desc",kltool,1,1
	elseif lx=2 then
	rs.open"select * from [kltool_log] where things is not null order by id desc",kltool,1,1
	end if
	If Not rs.eof Then
		gopage="?pg=log&amp;lx="&lx&"&amp;"
		Count=rs.recordcount
		pagecount=(count+pagesize-1)\pagesize
		if page>pagecount then page=pagecount
		rs.move(pagesize*(page-1))
	Response.write "<form name=""formDel"" method=""post"" action=""?pg=del_log&amp;siteid="&siteid&"&amp;page="&page&"&amp;lx="&lx&""">"
	call kltool_page(1)
		For i=1 To PageSize
		If rs.eof Then Exit For
	if (i mod 2)=0 then Response.write"<div class=""line2"">" else Response.write "<div class=""line1"">"
	Response.write""&page*PageSize+i-PageSize&"."
	Response.write"<input type=""checkbox"" name=""cid"" value="""&rs("id")&""">"&kltool_get_usernickname(rs("userid"),1)&"("&rs("userid")&")"
	if lx=1 then
	Response.write"/"&rs("userid")
	if rs("zt")=1 then Response.write "/√"
	if rs("zt")=0 then Response.write "/×"
	else
	Response.write rs("things")
	end if
	Response.write "</div><div class=line1>　"&rs("time")&"/"&rs("uip")&"</div>"
		rs.movenext
		Next
	Response.write "<div class=tip><span><input type=""checkbox"" name=""all"" onclick=""check_all(this,'cid')"">全选/反选</span> "
	Response.write "<input type=""submit"" value=""选择完毕,删除"" onClick=""ConfirmDel('是否确定删除？删除后不能恢复！');return false""></form></div>"
	call kltool_page(2)
	else
	   Response.write "<div class=tip>暂时没有记录！</div>"
	end if
	rs.close
	set rs=nothing
'''''''''''''''''''''''''''''''''''
elseif pg="del_log" then
	cid=request("cid")
	page=request("page")
	lx=request("lx")
	if kltool_admin_log_del<>1 then call kltool_msge("不允许删除操作日志\n请在"&kltool_path&"inc/config.asp中配置")
	kltool.Execute("delete from [kltool_log] Where id in("&cid&")")
	if lx=1 then call kltool_write_log("删除了登录日志："&cid)
	if lx=2 then call kltool_write_log("删除了操作日志："&cid)
	response.redirect "?siteid="&siteid&"&pg=log&page="&page&"&lx="&lx
end if

kltool_end
%>