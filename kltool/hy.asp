<!--#include file="inc/config.asp"-->
<%
kltool_quanxian
kltool_head("柯林工具箱-会员管理")
%>
        <style> 
        .black_overlay{ 
            display: none;
            position: fixed; 
            top: 0%; 
            left: 0%; 
            width: 100%; 
            height: 100%; 
            background-color: black; 
            z-index:1001; 
            -moz-opacity: 0.8; 
            opacity:.30; 
            filter: alpha(opacity=88); 
        } 
        .white_content { 
            display: none;
            position: fixed;
            border-radius: 15px;
            margin:0 auto;
            top: 5%; 
            left: 5%; 
            width: 80%;
            height: 80%; 
            padding: 15px; 
            border: 3px solid green; 
            background-color: white; 
            z-index:1002; 
            overflow: auto;
	}
    </style>
<%


Response.write"<div class=""tip""><form method=""post"" action=""?""><input name=""lx"" type=""hidden"" value=""7""><input name=""siteid"" type=""hidden"" value="""&siteid&""">输入ID、用户名或昵称 关键词<br/><input name=""ksearch"" type=""text"" value="""" placeholder=""查询仅限于本站""><input type=""submit"" value=""查询""></form></div>"

Response.write"<div class=title>"
for lx=0 to 6
Response.write"<a href='?siteid="&siteid&"&lx="&lx&"'>"
if lx=0 then lx2="全部"
if lx=1 then lx2="超管"
if lx=2 then lx2="副管"
if lx=3 then lx2="普通"
if lx=4 then lx2="总编辑"
if lx=5 then lx2="总版主"
if lx=6 then lx2="非本站"
Response.write lx2&"</a>&nbsp;"
next
Response.write"</div>"
'-----
ksearch=request("ksearch")
pg=request("pg")
if pg="" then
	lx=cint(request("lx"))
	sql= "select userid,siteid,LockUser,managerlvl,SessionTimeout from [user] where "
	if lx=0 then
	sql=sql&"siteid="&siteid
	elseif lx=1 then
	sql=sql&"siteid="&siteid&" and managerlvl=00"
	elseif lx=2 then
	sql=sql&"siteid="&siteid&" and managerlvl=01"
	elseif lx=3 then
	sql=sql&"siteid="&siteid&" and managerlvl=02"
	elseif lx=4 then
	sql=sql&"siteid="&siteid&" and managerlvl=03"
	elseif lx=5 then
	sql=sql&"siteid="&siteid&" and managerlvl=04"
	elseif lx=6 then
	sql=sql&"siteid<>"&siteid
	elseif lx=7 then
	sql=sql&"siteid="&siteid&" and (userid like '%"&ksearch&"%' or username like '%"&ksearch&"%' or nickname like '%"&ksearch&"%')"
	end if
	set rs=server.CreateObject("adodb.recordset")
	rs.open sql,conn,1,1
	If Not rs.eof Then
		if lx=7 then gopage="?lx="&lx&"&amp;ksearch="&ksearch&"&amp;" else gopage="?lx="&lx&"&amp;"
		Count=rs.recordcount
		pagecount=(count+pagesize-1)\pagesize
		if page>pagecount then page=pagecount
		rs.move(pagesize*(page-1))
	call kltool_page(1)
		For i=1 To PageSize     						
		If rs.eof Then Exit For
	idd=rs("userid")
	if (i mod 2)=0 then Response.write"<div class=line2>" else Response.write"<div class=line1>"
	Response.write""&page*PageSize+i-PageSize&"."
	Response.write"昵称:<a href=""/bbs/userinfo.aspx?siteid="&siteid&"&amp;touserid="&idd&""">"&kltool_get_usernickname(idd,1)&"</a>"
	Response.write"(ID:<a href=""ziliao.asp?siteid="&siteid&"&amp;uid="&idd&""">"&idd&"</a>)</div><div class=line1>"

	lockuser=clng(rs("lockuser"))
	if LockUser=0 then lu="锁定" else lu="解锁"
	Response.write"　<a href='"&gopage&"page="&page&"&amp;pg=lock&amp;siteid="&siteid&"&amp;idd="&idd&"' onClick=""ConfirmDel('是否确定？');return false"">"&lu&"</a>"

	Response.write"/<a href='"&gopage&"page="&page&"&amp;pg=sc&amp;siteid="&siteid&"&amp;idd="&idd&"' onClick=""ConfirmDel('是否确定删除？删除后不能恢复！');return false"">删除</a>/"
	Response.write"<a href=""javascript:void(0)"" onclick=""document.getElementById('light"&idd&"').style.display='block';document.getElementById('fade"&idd&"').style.display='block';return ajaxQuerySetDom('"&idd&"','./inc/key.asp?action=user&','q','result"&idd&"');"">详细</a>"

	Response.write"<div id=""fade"&idd&""" class=""black_overlay"" onclick =""document.getElementById('light"&idd&"').style.display='none';document.getElementById('fade"&idd&"').style.display='none'""></div>"

	Response.write"<div id=""light"&idd&""" class=""white_content"">"
	Response.write"<span id=""result"&idd&""">载入中…</span>"
	Response.write"</div>"

	if clng(rs("SessionTimeout"))>0 then Response.write"/<a href='"&gopage&"page="&page&"&amp;pg=vip&amp;siteid="&siteid&"&amp;idd="&idd&"'>vip</a>"

	klvl=clng(rs("managerlvl"))
	if klvl=0 Then 
	lvl="*****撤超"
	elseif klvl=1 Then 
	lvl="****撤副"
	elseif klvl=2 Then 
	lvl="加权"
	elseif klvl=3 Then 
	lvl="***撤编"
	elseif klvl=4 Then 
	lvl="**撤版"
	end if
	if klvl=2 then lvl2="gll" else lvl2="gl"
	Response.write"/<a href='"&gopage&"page="&page&"&amp;pg="&lvl2&"&amp;siteid="&siteid&"&amp;idd="&idd&"'>"&lvl&"</a>"
	Response.write"</div>"
		rs.movenext
		Next
	call kltool_page(2)
		else
		Response.write "<div class=tip>暂时没有记录！</div>"
		end if
	rs.close
	set rs=nothing
'-----
elseif pg="lock" then
	idd=request("idd")
	if clng(idd)=clng(siteid) then call kltool_msge("不能操作ID1000")
	set rs=server.CreateObject("adodb.recordset")
	rs.open "select * from [user] where siteid="&siteid&" and userid="&idd,conn,1,2
	If rs.eof Then call kltool_msge("没有此ID")
	if rs("LockUser")=1 then
	rs("LockUser")=0
	call kltool_write_log("(会员管理)解锁ID： "&kltool_get_usernickname(idd,1)&"("&idd&")")
	else
	rs("LockUser")=1
	call kltool_write_log("(会员管理)锁定ID： "&kltool_get_usernickname(idd,1)&"("&idd&")")
	end if
	rs.update
	rs.close
	set rs=nothing
	Response.redirect"?siteid="&siteid&"&page="&request("page")&"&lx="&request("lx")
'-----
elseif pg="sc" then
	idd=request("idd")
	if clng(idd)=clng(siteid) then call kltool_msge("不能操作ID1000")
	set rs=server.CreateObject("adodb.recordset")
	rs.open "select * from [user] where siteid="&siteid&" and userid="&idd,conn,1,2
	If rs.eof Then call kltool_msge("没有此ID")
	rs.delete
	rs.close
	set rs=nothing
	call kltool_write_log("(会员管理)删除ID： "&kltool_get_usernickname(idd,1)&"("&idd&")")
	Response.redirect"?siteid="&siteid&"&page="&request("page")&"&lx="&request("lx")
'-----
elseif pg="gl" then
	idd=request("idd")
	if clng(idd)=clng(siteid) then call kltool_msge("不能操作ID1000")
	set rs=server.CreateObject("adodb.recordset")
	rs.open "select * from [user] where siteid="&siteid&" and userid="&idd,conn,1,2
	If rs.eof Then call kltool_msge("没有此ID")
	rs("managerlvl")=02
	rs.update
	rs.close
	set rs=nothing
	call kltool_write_log("(会员管理)撤销权限： "&kltool_get_usernickname(idd,1)&"("&idd&")")
	Response.redirect"?siteid="&siteid&"&page="&request("page")&"&lx="&request("lx")
'-----
elseif pg="gll" then
	idd=request("idd")
	if clng(idd)=clng(siteid) then call kltool_msge("不能操作ID1000")
	Response.Write"<div class=""line1"">修改"&kltool_get_usernickname(idd,1)&"("&idd&")的权限</div><div class=""line2""><form method=""post"" action=""?""><input name=""siteid"" type=""hidden"" value="""&siteid&"""><input name=""pg"" type=""hidden"" value=""glll""><input name=""idd"" type=""hidden"" value="""&idd&"""><input name=""page"" type=""hidden"" value="""&request("page")&"""><input name=""lx"" type=""hidden"" value="""&request("lx")&"""><select name=""lvl""><option value=""04"">04-总版主</option><option value=""03"">03-总编辑</option><option value=""02"">02-普通会员</option><option value=""01"">01-副管</option><option value=""00"">00-超管</option></select></div><div class=""line1""><input name=""g"" type=""submit"" value=""马上修改""></form></div>"
'-----
elseif pg="glll" then
	idd=request("idd")
	lvl=request("lvl")
	if clng(idd)=clng(siteid) then call kltool_msge("不能操作ID1000")
	set rs=server.CreateObject("adodb.recordset")
	rs.open "select * from [user] where siteid="&siteid&" and userid="&idd,conn,1,2
	If rs.eof Then call kltool_msge("没有此ID")
	rs("managerlvl")=lvl
	rs.update
	rs.close
	set rs=nothing
	klvl=cint(lvl)
	if klvl=0 Then 
	lvl="超管"
	elseif klvl=1 Then 
	lvl="副管"
	elseif klvl=2 Then 
	lvl="普通会员"
	elseif klvl=3 Then 
	lvl="总编"
	elseif klvl=4 Then 
	lvl="总版"
	end if
	call kltool_write_log("(会员管理)修改权限:"&kltool_get_usernickname(idd,1)&"("&idd&")(新:"&lvl&")")
	Response.redirect"?siteid="&siteid&"&page="&request("page")&"&lx="&request("lx")
	'-----
	elseif pg="vip" then
	idd=request("idd")
	Response.Write"<div class=line2>他的身份："&kltool_get_uservip(idd,1)&kltool_get_uservip(idd,0)&kltool_get_uservip(idd,2)&"</div><div class=line1>更改(非延期)，身份留空则取消VIP，时间留空则为无限期，如填写，从现在算起</div><div class=line2><form method='post' action='?siteid="&siteid&"&amp;pg=vipxg&amp;idd="&idd&"&amp;page="&request("page")&"&amp;lx="&request("lx")&"'>身份"
	call kltool_get_viplist("vip1")
	Response.Write "时长(月)<input type='text' name='my' value='' size='5'><input name='g' type='submit' value='确定' name='submit'></form></div>"
'-----
elseif pg="vipxg" then
	idd=request("idd")
	my=request("my")
	vip1=request("vip1")
	if my="" then
		conn.Execute("update [user] set endTime=null where siteid="&siteid&" and userid="&idd)
	else
		ti=DateAdd("m",my,date())
	if clng(idd)<>clng(siteid) then conn.Execute("update [user] set endTime='"&ti&"' where siteid="&siteid&" and userid="&idd)
	end if

	if vip1="" then
		conn.Execute("update [user] set SessionTimeout=0 where siteid="&siteid&" and userid="&idd)
	else
		conn.Execute("update [user] set SessionTimeout="&vip1&" where siteid="&siteid&" and userid="&idd)
	end if
	call kltool_write_log("(会员管理)修改"&idd&"的vip为"&vip1&"("&kltool_get_vip(vip1,1)&"),时长："&my&"(为空表示永久,id1000默认永久)")
	Response.redirect"?siteid="&siteid&"&page="&request("page")&"&lx="&request("lx")
end if
kltool_end
%>