<!--#include file="inc/config.asp"-->
<%
kltool_head("柯林工具箱-论坛加黑会员")
kltool_quanxian
pg=request("pg")
if pg="" then
%>
<div class="tip"><a href="?siteid=<%=siteid%>&pg=ck">全部加黑信息</a></div>
<form method="post" action="?">
<input name="siteid" type="hidden" value="<%=siteid%>">
<input name="pg" type="hidden" value="yes">
<div class="line1">请输入会员ID:</div>
<div class="line2"><input name="uid" type="text" size="20" value=""></div>
<div class="line1">选择论坛：</div>
<%
set rs=server.CreateObject("adodb.recordset")
rs.open "select * from [class] where userid="&siteid&" and typeid=16",conn,1,1
Response.write "<div class=line><select name='cid'><option value='0'>所有栏目</option>"
Do While Not RS.EOF
	Response.Write "<option value='"&rs("classid")&"'>"&rs("classid")&"-"&rs("classname")&"</option>" 
RS.MoveNext 
Loop 
rs.close
set rs=nothing
%>
</select></div>
<div class="line1">加黑天数:(0为无期限)</div>
<div class="line2"><input name="ti" type="text" size="20" value="0"></div>
<div class="content"><input name="g" type="submit" value="确认操作" onClick="ConfirmDel("是否确定？");return false"><br/>
</form>
</div>

<%
elseif pg="yes" then
	uid=request("uid")
	cid=request("cid")
	ti=request("ti")

	if uid="" then call kltool_msge("目标ID不能为空")
	if not Isnumeric(uid) and not Isnumeric(ti) then call kltool_msge("目标ID和天数必须为数字")
	if int(uid)=siteid then call kltool_msge("非法操作")

	set rs=conn.execute("select lockuserid from [user_lock] where lockuserid="&uid)
	if not (rs.bof and rs.eof) then call kltool_msge("目标ID已存在")
	rs.close
	set rs=nothing

	set rs=conn.execute("select userid from [user] where userid="&uid)
	If rs.eof Then call kltool_msge("目标ID不存在")

	conn.execute("insert into [user_lock] (siteid,lockuserid,lockdate,operdate,operuserid,classid)values('"&siteid&"','"&uid&"','"&ti&"','"&now&"','"&userid&"','"&cid&"') ")
	rs.close
	set rs=nothing

	Response.write"<div class=""tip"">操作成功！</div>"
	Response.write"<div class=""line1"">锁定<b>ID</b>:"&kltool_get_usernickname(uid,1)&"("&uid&")</div>"

	if cid=0 then
	Response.write"<div class=""line2"">锁定论坛:全部</div>"
	call kltool_write_log("(小黑屋)全坛加黑"&kltool_get_usernickname(uid,1)&"("&uid&")，"&ti&"天(0表示永久)")
	else
	Response.write"<div class=""line2"">锁定论坛:"&cid&"</div>"
	call kltool_write_log("(小黑屋)栏目加黑"&kltool_get_usernickname(uid,1)&"("&uid&")，在"&cid&"，"&ti&"天(0表示永久)")
	end if

	if ti=0 then
	Response.write"<div class=""line1"">锁定时间:永久</div>"
	else
	Response.write"<div class=""line1"">锁定时间:"&ti&"天</div>"
	end if
	Response.write "<div class='tip'>【<a href='?siteid="&siteid&"&pg=ck'>查看全部加黑信息</a>】</div>"
'-----
elseif pg="ck" then
	Response.write "<div class='tip'>【<a href='?siteid="&siteid&"'>返回加黑操作</a>】</div>"
	Response.write"<div class=""tip""><form method=""post"" action=""?""><input name=""pg"" type=""hidden"" value=""ck""><input name=""siteid"" type=""hidden"" value="""&siteid&""">输入ID(模糊查询)<br/><input name=""ksearch"" type=""text"" value="""" placeholder=""查询仅限于本站""><input type=""submit"" value=""查询""></form></div>"
	ksearch=request("ksearch")
	set rs=server.CreateObject("adodb.recordset")
	if ksearch<>"" then
	rs.open "select * from [user_lock] where siteid="&siteid&" and lockuserid like '%"&ksearch&"%'",conn,1,1
	else
	rs.open "select * from [user_lock] where siteid="&siteid,conn,1,1
	end if
	If Not rs.eof Then				
		if ksearch<>"" then gopage="?pg=ck&amp;ksearch="&ksearch&"&amp;" else gopage="?pg=ck&amp;"
		Count=rs.recordcount
		pagecount=(count+pagesize-1)\pagesize
		if page>pagecount then page=pagecount
		rs.move(pagesize*(page-1))
	call kltool_page(1)
		For i=1 To PageSize
		If rs.eof Then Exit For
	Response.write "<div class=line1>　"&kltool_get_usernickname(rs("lockuserid"),1)&"("&rs("lockuserid")&")　<a href=""?siteid="&siteid&"&amp;id="&rs("id")&"&amp;pg=jc&amp;page="&page&""" onClick=""ConfirmDel('是否确定？');return false"">解除</a></div>"
	Response.write "<div class=line1>　操作人:"&kltool_get_usernickname(rs("operuserid"),1)&"("&rs("operuserid")&")　时间:"&rs("operdate")&"</div>"
	lockclassid=rs("classid")
	if lockclassid="0" then
	Response.write"<div class=line2>　全部论坛"
	else
	Response.write"<div class=line2>　栏目:"&lockclassid
	end if
	lockdate=rs("lockdate")
	if lockdate="0" then
	Response.write"　永久加黑</div>"
	else
	Response.write"　加黑"&lockdate&"天</div>"
	end if
		rs.movenext
		Next
	call kltool_page(2)
	else
	   Response.write"<div class=tip>暂时没有记录！</div>"
	end if
	rs.close
	set rs=nothing
'''''''''''''''''''''''''''''''''''''''''''''''''''
elseif pg="jc" then
	id=request("id")
	set rs=server.CreateObject("adodb.recordset")
	rs.open "select * from [user_lock] where siteid="&siteid&" and id="&id,conn,1,2
	if rs.eof then call kltool_msge("此ID不存在")
	lockuserid=rs("lockuserid")
	rs.delete
	rs.close
	set rs=nothing
	call kltool_write_log("(小黑屋)解除加黑："&kltool_get_usernickname(lockuserid,1)&"("&lockuserid&")")
	response.redirect "?siteid="&siteid&"&pg=ck&page="&page
end if

Response.write"<div class=""tip"">小提示：</div><div class=""content"">1、可对任意会员加黑或解黑<br/>2、本插件论坛加黑或解黑，用户仍然可以浏览内容</div>"

kltool_end
%>
