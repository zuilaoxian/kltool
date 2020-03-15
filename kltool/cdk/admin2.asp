<!--#include file="../inc/config.asp"-->
<%
kltool_head("柯林工具箱-CDK管理")
kltool_quanxian
kltool_sql("cdk")

Response.write "<div class=title><a href='?siteid="&siteid&"'>全部CDK</a>/<a href='?siteid="&siteid&"&amp;lx=sy'>未使用</a>/<a href='?siteid="&siteid&"&amp;lx=sy1'>已使用</a>/<a href='admin1.asp?siteid="&siteid&"'>生产后台</a>/<a href='index.asp?siteid="&siteid&"'>前台</a></div>"

Response.write "<div class=tip>→<a href='?siteid="&siteid&"&amp;lx=lx1'>金</a>/<a href='?siteid="&siteid&"&amp;lx=lx2'>经</a>/<a href='?siteid="&siteid&"&amp;lx=lx3'>双</a>/<a href='?siteid="&siteid&"&amp;lx=lx4'>身</a>/<a href='?siteid="&siteid&"&amp;lx=lx5'>积</a>/<a href='?siteid="&siteid&"&amp;lx=lx6'>勋</a>/<a href='?siteid="&siteid&"&amp;lx=lx7'>售</a></div>"

pg=request("pg")
if pg="" then
	uid=request("uid")
	lx=request("lx")
	set rs=server.CreateObject("adodb.recordset")
	if lx="" then
	rs.open "select * from [cdk] Order by time desc",conn,1,1
	elseif lx="id" then
	rs.open "select * from [cdk] where userid="&uid&" Order by time desc",conn,1,1
	elseif lx="sy" then
	rs.open "select * from [cdk] where sy=1 Order by time desc",conn,1,1
	elseif lx="sy1" then
	rs.open "select * from [cdk] where sy=2 Order by time desc",conn,1,1
	elseif lx="lx1" then
	rs.open "select * from [cdk] where lx=1 Order by time desc",conn,1,1
	elseif lx="lx2" then
	rs.open "select * from [cdk] where lx=2 Order by time desc",conn,1,1
	elseif lx="lx3" then
	rs.open "select * from [cdk] where lx=3 Order by time desc",conn,1,1
	elseif lx="lx4" then
	rs.open "select * from [cdk] where lx=4 Order by time desc",conn,1,1
	elseif lx="lx5" then
	rs.open "select * from [cdk] where lx=5 Order by time desc",conn,1,1
	elseif lx="lx6" then
	rs.open "select * from [cdk] where lx=6 Order by time desc",conn,1,1
	elseif lx="lx7" then
	rs.open "select * from [cdk] where chushou=1 Order by time desc",conn,1,1
	end if
	If Not rs.eof Then	
		gopage="?lx="&lx&"&amp;uid="&uid&"&amp;"
		Count=rs.recordcount
		pagecount=(count+pagesize-1)\pagesize	
		if page>pagecount then page=pagecount
		rs.move(pagesize*(page-1))
	call kltool_page(1)
	Response.write"<form name=""formDel"" method=""post"" action="""&gopage&"pg=cdksc&amp;siteid="&siteid&"&amp;page="&page&""">"
		For i=1 To PageSize 
		If rs.eof Then Exit For
	Response.write "<div class=line2>"&page*PageSize+i-PageSize&"."
	sy=clng(rs("sy"))
	zs=clng(rs("zs"))
	if sy=1 then Response.write "(未" else Response.write "(已"
	if rs("userid")<>"" then Response.write "<a href='?siteid="&siteid&"&amp;lx=id&amp;uid="&rs("userid")&"'>"&rs("userid")&"</a>"
	Response.write ")"

	clx=clng(rs("lx"))
	if clx=1 then
	Response.write "(<a href='?siteid="&siteid&"&amp;lx=lx1'>金</a>)"
	elseif clx=2 then
	Response.write "(<a href='?siteid="&siteid&"&amp;lx=lx2'>经</a>)"
	elseif clx=3 then
	Response.write "(<a href='?siteid="&siteid&"&amp;lx=lx2'>双</a>)"
	elseif clx=4 then
	Response.write "(<a href='?siteid="&siteid&"&amp;lx=lx4'>身</a>)"
	elseif clx=5 then
	Response.write "(<a href='?siteid="&siteid&"&amp;lx=lx5'>积</a>)"
	elseif clx=6 then
	Response.write "(<a href='?siteid="&siteid&"&amp;lx=lx6'>勋</a>)"
	end if

	if rs("chushou")="1" then Response.write "(<a href='?siteid="&siteid&"&amp;lx=lx7'>售</a>)"

	Response.write "CDK:"&rs("cdk")&""
	cuid=""&rs("userid")&""
	if cuid="" and sy=1 then
	Response.write "(<a href='"&gopage&"page="&page&"&amp;siteid="&siteid&"&amp;pg=xg&amp;id="&rs("id")&"'>发</a>)"
	end if
	Response.write "(<a href='"&gopage&"page="&page&"&amp;siteid="&siteid&"&amp;pg=sc&amp;id="&rs("id")&"'>删</a>)"
	if sy=1 then yy="未用"
	if sy=2 then yy="已用"
	Response.write "(<a href='"&gopage&"page="&page&"&amp;siteid="&siteid&"&amp;pg=zt&amp;id="&rs("id")&"'>"&yy&"</a>)"
	if zs=1 then zz="可赠"
	if zs=2 then zz="不可赠"
	Response.write "(<a href='"&gopage&"page="&page&"&amp;siteid="&siteid&"&amp;pg=zs&amp;id="&rs("id")&"'>"&zz&"</a>)</div>"
	Response.write "<div class=line1>(<input type=""checkbox"" name=""cid"" value="""&rs("id")&""">)"
	if clx=1 then
	Response.write "此CDK奖励为:"&sitemoneyname&""&rs("jinbi")
	elseif clx=2 then
	Response.write "此CDK奖励为:经验"&rs("jingyan")
	elseif clx=3 then
	Response.write "此CDK奖励为:"&sitemoneyname&rs("jinbi")&",经验"&rs("jingyan")
	elseif clx=4 then
	Response.write "此CDK奖励为:"&rs("sff")&"个月VIP"&kltool_get_vip(rs("sf"),1)
	elseif clx=5 then
	Response.write "此CDK奖励为:"&rs("lg")&"秒积时"
	elseif clx=6 then
	Response.write "此CDK奖励为:勋章奖励"&kltool_get_xunzhang(rs("xg"))
	end if
	Response.write "</div>"
	if rs("chushou")="1" then Response.write "<div class=line2>　　出售中　价格:"&rs("jiage")&"</div>"
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
'''''''''''''''''''''''''
elseif pg="xg" then
	id=request("id")
	lx=request("lx")
	Response.Write "<div class=tip>发给指定id</div>"
	Response.Write "<form method='post' action='?'>"
	Response.Write "<input type='hidden' name='siteid' value='"&siteid&"'>"
	Response.Write "<input type='hidden' name='pg' value='xg1'>"
	Response.Write "<input type='hidden' name='id' value='"&id&"'>"
	Response.Write "<input type='hidden' name='page' value='"&page&"'>"
	Response.Write "<input type='hidden' name='lx' value='"&lx&"'>"
	Response.Write "<div class=line1><input type='text' name='uid' value=''></div>"
	Response.Write "<div class=line2><input type='submit' value='发放' name='g'></div>"

'''''''''''''''''''''''''
elseif pg="xg1" then
	uid=request("uid")
	id=request("id")
	lx=request("lx")
	set rs=server.CreateObject("adodb.recordset")
	rs.open "select * from [cdk] where id="&id,conn,1,2
	if rs.eof then call kltool_msge("没有此CDK")
	cdk=rs("cdk")
	rs("userid")=uid
	rs("chushou")=2
	rs("jiage")=null
	rs.update
	rs.close
	set rs=nothing
	'发信息给目标id
	call kltool_write_log("(cdk管理)发cdk("&cdk&")给"&kltool_get_usernickname(uid,1)&"("&uid&")")
	conn.execute("insert into [wap_message](siteid,userid,nickname,title,content,touserid,isnew,issystem,addtime,HangBiaoShi)values('"&siteid&"','"&siteid&"','系统','来自CDK的发放信息','系统大神发放了一个CDK给您，请[url="&kltool_path&"cdk/index.asp?siteid=[siteid]&pg=mycdk]前往查看[/url]','"&uid&"','1','1','"&date()&" "&time()&"','0')")
	Response.redirect"?siteid="&siteid&"&lx="&lx&"&page="&page&""
''''''''''''''''''''''''''
elseif pg="sc" then
	id=request("id")
	lx=request("lx")
	set rs=server.CreateObject("adodb.recordset")
	rs.open "select * from [cdk] where id="&id,conn,1,2
	if rs.eof then call kltool_msge("没有此CDK")
	cdk=rs("cdk")
	rs.delete
	rs.close
	set rs=nothing
	call kltool_write_log("(cdk管理)删除CDK："&cdk)
	Response.redirect"?siteid="&siteid&"&page="&page&"&lx="&lx
	''''''''''''''''''''''''''
	elseif pg="cdksc" then
	cid=request("cid")
	lx=request("lx")
	conn.Execute("delete from [cdk] Where id in("&cid&")")
	call kltool_write_log("(cdk管理)批量删除CDK："&cid)
	Response.redirect"?siteid="&siteid&"&page="&page&"&lx="&lx

elseif pg="zt" then
	id=request("id")
	lx=request("lx")
	set rs=conn.Execute("SELECT * from [cdk] Where id="&id)
	sy=clng(rs("sy"))
	cdk=rs("cdk")
	rs.close
	set rs=nothing
	if sy=1 then
		   conn.Execute"update [cdk] set sy=2 Where id="&id
	call kltool_write_log("(cdk管理)修改CDK为已用："&cdk)
	else
		   conn.Execute"update [cdk] set sy=1 Where id="&id
	call kltool_write_log("(cdk管理)修改CDK为未用："&cdk)
	end if
	Response.redirect"?siteid="&siteid&"&page="&page&"&lx="&lx
''''''''''''''''''''''''''
elseif pg="zs" then
	id=request("id")
	lx=request("lx")
	set rs=conn.Execute("SELECT * from [cdk] Where id="&id)
	cdk=rs("cdk")
	zs=clng(rs("zs"))
	rs.close
	set rs=nothing
	if zs=1 then
		   conn.Execute"update [cdk] set zs=2 Where id="&id
	call kltool_write_log("(cdk管理)修改CDK为不可赠送："&cdk)
	else
		   conn.Execute"update [cdk] set zs=1 Where id="&id
	call kltool_write_log("(cdk管理)修改CDK为可赠送："&cdk)
	end if
	Response.redirect"?siteid="&siteid&"&page="&page&"&lx="&lx

end if
kltool_end
%>