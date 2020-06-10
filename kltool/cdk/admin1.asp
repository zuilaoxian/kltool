<!--#include file="../inc/config.asp"-->
<!--#include file="../inc/keycdksc.asp"-->
<%
kltool_head("柯林工具箱-CDK后台")
kltool_quanxian
kltool_sql("cdk")

pg=request("pg")
if pg="" then
	Response.Write "<div class=line2><a href='?siteid="&siteid&"&amp;pg=c1'>半自动生产16位随机cdk</a></div>"
	Response.Write "<div class=tip><a href='admin2.asp?siteid="&siteid&"'>CDK查看及管理</a></div>"
	Response.Write "<div class=line2><a href='index.asp?siteid="&siteid&"'>前台查看</a></div>"
	Response.Write "<div class=line1><a href='?siteid="&siteid&"&amp;pg=chong'>检查cdk重复值并删除</a></div>"
	Response.Write "<div class=line2><a href='?siteid="&siteid&"&amp;pg=c6'>商城设置</a></div>"
	Response.Write "<div class=line2><a href='admin4.asp?siteid="&siteid&"'>商城购买日志</a></div>"
'-----cdk重复值检查
elseif pg="chong" then
	Response.Write "<div class=tip>若成功，则提示，失败可能会显示错误页面，只对重复性cdk进行删除，使用与否不管</div>"
	Response.Write "<div class=title><a href='?siteid="&siteid&"&amp;pg=chongfu'>确认执行</a></div>"
	Response.Write "<div class=tip>若不检查，请<a href='?siteid="&siteid&"'>返回</a></div>"
'-----cdk重复值检查
elseif pg="chongfu" then
	conn.Execute("select min(id) from [cdk] group by cdk having count(*) >1 delete from [cdk] where id not in(select min(id) from [cdk] group by cdk)")
	closeconn()
	call kltool_write_log("(cdk)检查重复cdk")
	Response.Write "<div class=tip>成功执行命令<br/><a href='?siteid="&siteid&"'>返回</a></div>"
'-------------------'
elseif pg="c1" then
	Response.Write "<div class=tip><a href='?siteid="&siteid&"'>cdk后台</a>>生产CDK(1)</div>"
	Response.Write "<form method='post' action='?siteid="&siteid&"&amp;pg=c2'>"
	Response.Write "<div class=tip>第一步：选择cdk类型：</div>"
	Response.Write "<div class=line2><select name='lx' value='1'><option value='1'>1."&sitemoneyname&"奖励</option><option value='2'>2.经验奖励</option><option value='3'>3."&sitemoneyname&"和经验奖励</option><option value='4'>4.vip奖励</option><option value='5'>5.积时奖励</option><option value='6'>6.勋章奖励</option></select></div>"
	Response.Write "<div class=line1><input type='submit' value='下一步'></form></div>"
'-----
elseif pg="c2" then
	lx=clng(request("lx"))
	Response.Write "<div class=tip><a href='?siteid="&siteid&"'>cdk后台</a>><a href='?siteid="&siteid&"&amp;pg=c1'>生产CDK(1)</a>>生产CDK(2)</div>"
	Response.Write "<div class=tip>第二步：填写奖励：</div>"
	Response.Write "<form method='post' action='?siteid="&siteid&"&amp;pg=c3'><input type='hidden' name='lx' value='"&lx&"'>"
	Response.Write "<div class=line1>生产的数量：</div>"
	Response.Write "<div class=line2><input type='text' name='cdk' value=''></div>"

	if lx=1 or lx=3 then
	Response.Write "<div class=line1>"&sitemoneyname&"奖励数量：</div><div class=line2><input type='text'  name='jinbi' value=''></div>"

	if lx=3 then Response.Write "<div class=line1>经验奖励数量：</div><div class=line2><input type='text'  name='jingyan' value=''></div>"

	elseif lx=2 then
	Response.Write "<div class=line1>经验奖励数量：</div><div class=line2><input type='text'  name='jingyan' value=''></div>"


	elseif lx=4 then
	Response.Write "<div class=line1>vip奖励：</div>"
	set rs=server.CreateObject("adodb.recordset")
	rs.open "select * from [wap2_smallType] where siteid="&siteid&" and systype='card' ",conn,1,1
	Response.write "<div class=line2><select name='sf'><option value=''>"
	Do While Not RS.EOF
	Response.Write "</option><option value='"&rs("id")&"'>"&kltool_get_vip(rs("id"),2)&"</option>" 
	RS.MoveNext 
	Loop 
	Response.Write "</select><a href='?siteid="&siteid&"&amp;pg=c4'>查看编号</a></div>" 
	Response.Write "<div class=line1>身份奖励时间(月)：</div>"
	Response.Write "<div class=line2><input type='text'  name='sff' value=''></div>"

	elseif lx=5 then
	Response.Write "<div class=line1>积时奖励(秒)：</div>"
	Response.Write "<div class=line2><input type='text'  name='lg' value='' ></div>"

	elseif lx=6 then
	Response.Write "<div class=line1>6.勋章奖励：<a href='?siteid="&siteid&"&amp;pg=c5'>查看种类</a></div>"
	Response.Write "<div class=line1>填写图片地址如:1.gif</div>"
	Response.Write "<div class=line2><input type='text'  name='xg' value=''></div>"
	end if
	Response.Write "<div class=line1>指定使用人,将全部发给此ID(不指定留空)</div>"
	Response.Write "<div class=line2><input type='text'  name='uid' value='' ></div>"
	Response.Write "<div class=line1>是否允许转增</div>"
	Response.Write "<div class=line2><select name='zs'><option value='1'>1-允许</option><option value='2'>2-不允许</option></select></div>"

	Response.Write "<div class=line1>是否出售(如果指定使用人则无效)</div>"
	Response.Write "<div class=line2><select name='cs'><option value='2'>不出售</option><option value='1'>出售</option></select></div>"
	Response.Write "<div class=line1>若出售，填写价格</div>"
	Response.Write "<div class=line2><input type='text'  name='jia' value='' ></div>"

	Response.Write "<div class=line1><input type='submit' value='马上生产'></form></div>"

'-----
elseif pg="c3" then
	lx=request("lx")
	cdk=request("cdk")
	jinbi=request("jinbi")
	jingyan=request("jingyan")
	sf=request("sf")
	sff=request("sff")
	lg=request("lg")
	xg=request("xg")
	uid=request("uid")
	zs=request("zs")
	cs=request("cs")
	jia=request("jia")
	set rs=Server.CreateObject("ADODB.Recordset")
	rs.open"select * from [cdk]",conn,1,3
	for i=1 to cdk
	rs.addnew
	rs("cdk")=Generate_Key
	rs("jinbi")=clng(jinbi)
	rs("jingyan")=clng(jingyan)
	rs("lx")=clng(lx)
	rs("sy")=1
	rs("sf")=clng(sf)
	rs("sff")=clng(sff)
	rs("lg")=clng(lg)
	rs("xg")=xg
	rs("time")=now()
	rs("zs")=zs

	if uid<>"" then
		rs("userid")=clng(uid)
		rs("chushou")=2
	elseif uid="" and cs="2" then
		rs("chushou")=2
	elseif uid="" and cs="1" then
		rs("chushou")=1
		if jia<>"" then
		rs("jiage")=clng(jia)
		else
		call kltool_msge("价格不能为空")
		end if
	end if

	rs.update
	next
	rs.close
	set rs=nothing
	lx=clng(lx)
	if lx="1" then
		clx=""&sitemoneyname&"奖励:"&jinbi
	elseif lx="2" then
		clx="经验奖励:"&jingyan
	elseif lx="3" then
		clx=""&sitemoneyname&"+经验:"&jinbi&"/"&jingyan
	elseif lx="4" then
		clx="身份:"&kltool_get_vip(sf,1)
	elseif lx="5" then
		clx="积时:"&lg
	elseif lx="6" then
		clx="勋章:"&kltool_get_xunzhang(xg)
	end if

	call kltool_write_log("(cdk生产)生产"&cdk&"个cdk,类型:"&clx)
	Response.Write "<div class=tip><a href='?siteid="&siteid&"'>cdk后台</a>><a href='?siteid="&siteid&"&amp;pg=c1'>生产CDK(1)</a>><a href='?siteid="&siteid&"&amp;pg=c2&amp;lx="&lx&"'>生产CDK(2)</a>>生产CDK(3)</div>"
	Response.Write "<div class=title>批量生产"&cdk&"个cdk成功,类型:"&clx&"</div>"
	if not uid="" then  Response.Write "<div class=line2>已批量发号给ID："&kltool_get_usernickname(uid,1)&"("&uid&")</div>"
'-----
elseif pg="c4"then
	set rs=server.CreateObject("adodb.recordset")
	rs.open "select * from [wap2_smallType] where siteid="&siteid&" and systype='card'",conn,1,1
	If Not rs.eof Then
		gopage="?pg=c8&amp;"
		Count=rs.recordcount
		pagecount=(count+pagesize-1)\pagesize
		if page>pagecount then page=pagecount
		rs.move(pagesize*(page-1))
	call kltool_page(1)
		For i=1 To PageSize
		If rs.eof Then Exit For
	Response.write "<div class=""line1"">"&rs("id")&"."&kltool_get_vip(rs("id"),1)&"</div>"
		rs.movenext
		Next
	call kltool_page(2)
	else
	Response.write "<div class=tip>暂时没有记录！</div>"
	end if
	rs.close
	set rs=nothing
'-----
elseif pg="c5" then
	Response.write "<div class=title><a href='?siteid="&siteid&"&amp;pg=c5'>论坛</a>/<a href='?siteid="&siteid&"&amp;pg=da'>大图</a>/<a href='?siteid="&siteid&"&amp;pg=xo'>小图</a>/<a href='?siteid="&siteid&"&amp;pg=qq'>QQ</a></div>"

	Response.write "<div class=tip>以下是勋章购买栏目中的</div>"
	set rs=server.CreateObject("adodb.recordset")
	rs.open "select * from [XinZhang] where siteid="&siteid&"",conn,1,1
	If Not rs.eof Then
		gopage="?pg=c5&amp;"
		Count=rs.recordcount
		pagecount=(count+pagesize-1)\pagesize	
		if page>pagecount then page=pagecount
		rs.move(pagesize*(page-1))
	call kltool_page(1)
		For i=1 To PageSize
		If rs.eof Then Exit For
	Response.write "<div class=line1>"&rs("id")&"."
	Response.write "<img src='/"&rs("XinZhangTuPian")&"' alt='图片' />"&rs("XinZhangMingChen")&"<br/>"&rs("XinZhangTuPian")&"</div>"
	rs.movenext
		Next
	call kltool_page(2)
	else
	Response.write "<div class=tip>暂时没有记录！</div>"
	end if
	rs.close
	set rs=nothing
'-------------------'
elseif pg="da" then
	Response.write "<div class=title><a href='?siteid="&siteid&"&amp;pg=c5'>论坛</a>/<a href='?siteid="&siteid&"&amp;pg=da'>大图</a>/<a href='?siteid="&siteid&"&amp;pg=xo'>小图</a>/<a href='?siteid="&siteid&"&amp;pg=qq'>QQ</a></div>"
	Response.write "<div class=content>"
	for d=1 to 22
	Response.write "<img src='/bbs/medal/"&d&".gif' alt='"&d&".gif'/>["&d&".gif]"
	e=d mod 4
	if e=0 then Response.write "<br/>"
	next
	Response.write "</div>"
'-----
elseif pg="xo" then
	Response.write "<div class=title><a href='?siteid="&siteid&"&amp;pg=c5'>论坛</a>/<a href='?siteid="&siteid&"&amp;pg=da'>大图</a>/<a href='?siteid="&siteid&"&amp;pg=xo'>小图</a>/<a href='?siteid="&siteid&"&amp;pg=qq'>QQ</a></div>"

	Response.write "<div class=content>"
	for d=23 to 40
	Response.write "<img src='/bbs/medal/"&d&".gif' alt='"&d&".gif'/>["&d&".gif]"
	e=d mod 4
	if e=0 then Response.write "<br/>"
	next
	Response.write "</div>"
'-----
elseif pg="qq" then
	Response.write "<div class=title><a href='?siteid="&siteid&"&amp;pg=c5'>论坛</a>/<a href='?siteid="&siteid&"&amp;pg=da'>大图</a>/<a href='?siteid="&siteid&"&amp;pg=xo'>小图</a>/<a href='?siteid="&siteid&"&amp;pg=qq'>QQ</a></div>"

	Response.write "<div class=content>"
	for d=41 to 60
	Response.write "<img src='/bbs/medal/"&d&".gif' alt='"&d&".gif'/>["&d&".gif]"
	e=d mod 4
	if e=0 then Response.write "<br/>"
	next
	Response.write "</div>"
'-------------------'
elseif pg="c6" then
	set rs=server.CreateObject("adodb.recordset")
	rs.open "select top 6 * from [cdk_set]",conn,1,1
	If Not rs.eof Then
		gopage="?pg=c6&amp;"
		Count=rs.recordcount
		pagecount=(count+pagesize-1)\pagesize
		if page>pagecount then page=pagecount
		rs.move(pagesize*(page-1))
	call kltool_page(1)
		For i=1 To PageSize
		If rs.eof Then Exit For
	lx=rs("lx")
	if lx="1" then
		clx=""&sitemoneyname&"奖励"
	elseif lx="2" then
		clx="经验奖励"
	elseif lx="3" then
		clx=""&sitemoneyname&"+经验"
	elseif lx="4" then
		clx="身份奖励"
	elseif lx="5" then
		clx="积时奖励"
	elseif lx="6" then
		clx="勋章奖励"
	end if
	%>
	<form method="post" action="?">
	<input name="siteid" type="hidden" value="<%=siteid%>">
	<input name="pg" type="hidden" value="c7">
	<input type="hidden"  name="cid" value="<%=rs("id")%>">
	<div class="line1"><%=rs("id")%>.<%=clx%>:优惠<input type="text"  name="cyh" value="<%=rs("yh")%>" size="4" >%</div>
	<div class="line2">可购数:<input type="text"  name="csl" value="<%=rs("sl")%>" size="4" >　vip可购数<input type="text"  name="cvsl" value="<%=rs("vsl")%>" size="4">
	<input name="g" type="submit" value="更改" >
	</form></div>
	<%
	rs.movenext
		Next
	call kltool_page(2)
	else
	Response.write "<div class=tip>暂时没有记录！</div>"
	end if
	rs.close
	set rs=nothing

'-----
elseif pg="c7" then
	if not (Isnumeric(request("cyh")) and Isnumeric(request("csl")) and Isnumeric(request("cvsl"))) then call kltool_msge("各项必须是数字")
	set rs=server.CreateObject("adodb.recordset")
	rs.open "select * from [cdk_set] where id="&request("cid"),conn,1,2
	If Not rs.eof Then
	rs("yh")=request("cyh")
	rs("sl")=request("csl")
	rs("vsl")=request("cvsl")
	rs.update
	rs.close
	set rs=nothing

	lx=clng(request("cid"))
	if lx="1" then
		clx=""&sitemoneyname&"奖励"
	elseif lx="2" then
		clx="经验奖励"
	elseif lx="3" then
		clx=""&sitemoneyname&"+经验"
	elseif lx="4" then
		clx="身份奖励"
	elseif lx="5" then
		clx="积时奖励"
	elseif lx="6" then
		clx="勋章奖励"
	end if

	call kltool_write_log("(cdk商城)设置:"&clx&",(优惠/可购/vip可购)("&request("cyh")&"/"&request("csl")&"/"&request("cvsl")&")")
	response.redirect "?siteid="&siteid&"&pg=c6"
	else
		Response.write "<div class=""tip"">记录错误！</div>"
	end if


end if
kltool_end
%>