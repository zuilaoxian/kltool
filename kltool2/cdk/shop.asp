<!--#include file="../config.asp"-->
<%
kltool_use(3)
kltool_sql("cdk")
kltool_sql("cdk_set")
'单日购买总量
	daynum=15
'查询今日已购买数量
	set rs=server.CreateObject("adodb.recordset")
	rs.open "select * from [cdk_log] where userid="&userid&" and year(ltime)="&year(now)&" and month(ltime)="&month(now)&" and day(ltime)="&day(now),conn,1,1
	todaynum=rs.recordcount '今天已购买数量
	rs.close
	set rs=nothing
'今日购买剩余，单日-今日
	lastnum=daynum-todaynum
	if lastnum<=0 then lastnum=0
'分类上限
function kltool_get_typemaxnum(lx)
	kltool_get_typemaxnum=0
	set rsmaxnum=server.CreateObject("adodb.recordset")
	rsmaxnum.open "select * from [cdk_set] where lx="&lx,conn,1,1
	if not rsmaxnum.eof then
		if SessionTimeout>0 then
			if rsmaxnum("vsl")<>"" then kltool_get_typemaxnum=clng(rsmaxnum("vsl"))
		else
			if rsmaxnum("sl")<>"" then kltool_get_typemaxnum=clng(rsmaxnum("sl"))
		end if
	end if
	rsmaxnum.close
	set rsmaxnum=nothing
end function
'分类剩余
function kltool_get_typenum(lx)
	kltool_get_typenum=0
	set rs=server.CreateObject("adodb.recordset")
	rs.open "select * from [cdk_log] where userid="&userid&" and lx="&lx&" and year(ltime)="&year(now)&" and month(ltime)="&month(now)&" and day(ltime)="&day(now),conn,1,1
	If Not rs.eof Then
	kltool_get_typenum=rs.recordcount
	end if
	rs.close
	set rs=nothing
end function

'分类优惠
function kltool_get_typeyh(lx)
	kltool_get_typeyh=0
	set rsyh=server.CreateObject("adodb.recordset")
	rsyh.open "select * from [cdk_set] where lx="&lx,conn,1,1
	if not rsyh.eof then
		if rsyh("yh")<>"" then kltool_get_typeyh=clng(rsyh("yh"))
	end if
	rsyh.close
	set rsyh=nothing
end function

'-----查询各种CDK数量
Function kltool_get_cdkcount(lx)
	set rs=server.CreateObject("adodb.recordset")
	rs.open "select * from [cdk] where lx="&lx&" and chushou=1",conn,1,1
	kltool_get_cdkcount=rs.recordcount
	rs.close
	set rs=nothing
End Function




action=Request.QueryString("action")
select case action
	case ""
		call index()
	case "cdkbuy"
		call cdkbuy()
end select
sub index()

	c_lx=request.querystring("c_lx")
	if c_lx="" then c_lx=1
	
	html=kltool_head("CDK兑换系统-商城",1)&_
	
	"<ul class=""breadcrumb"">"&vbcrlf&_
	"	<li><a href='index.asp'>CDK兑换</a></li>"&vbcrlf&_
	"	<li><a href='?siteid="&siteid&"'>->CDK商城</a></li>"&vbcrlf&_
	"</ul>"&vbcrlf&_
	"<ul class=""breadcrumb"">"&vbcrlf
	for i=1 to 7
	if clng(c_lx)<>i then html=html&"	<li><a href='shop.asp?c_lx="&i&"'>"&kltool_get_cdklx(i)&"("&kltool_get_cdkcount(i)&")</a></li>"&vbcrlf else html=html&"	<li>"&kltool_get_cdklx(i)&"("&kltool_get_cdkcount(i)&")</li>"&vbcrlf
	next
	html=html&"</ul>"&vbcrlf
	sl2=kltool_get_typemaxnum(c_lx)-kltool_get_typenum(c_lx)
	if sl2<=0 then sl2=0
	html=html&_
	"<li class=""list-group-item"">"&vbcrlf&_
	"今天剩余："&lastnum&"/"&daynum&vbcrlf&_
	"<br/>本类型剩余："&sl2&vbcrlf
	yh=kltool_get_typeyh(c_lx)
	if yh>0 then html=html&"<br/>本类cdk优惠"&yh&"%"&vbcrlf
	html=html&"</li>"&vbcrlf
	sql="select id,cdk,zs,jiage,jiage2 from [cdk] where lx="&c_lx&" and chushou=1"
	str=kltool_GetRow(sql,0,pagesize)
	If str(0) Then
		count=str(0)
		pagecount=str(1)
		if page>pagecount then page=pagecount
		html=html&kltool_page(1,count,pagecount,gopage)
		For i=0 To ubound(str(2),2)
			c_id=str(2)(0,i)
			cdk=str(2)(1,i)
			zs=str(2)(2,i)
			jiage=str(2)(3,i)
			jiage2=str(2)(4,i)
			if zs="1" then zs_c="  {可转增}" else zs_c="  {不可转增}"
			html=html&_
			"<li class=""list-group-item"">"&vbcrlf&_
			cdk&zs_c&"<br/>cdk内容："&kltool_get_cdkinfo(c_id)&vbcrlf&_
			"<br/>价格 "
			if jiage<>"" and clng(jiage)>0 then html=html&sitemoneyname&":"&jiage
			if jiage2<>"" and jiage2>0 then html=html&" rmb:"&jiage2
			html=html&"　<a href='?siteid="&siteid&"&action=cdkbuy&c_id="&c_id&"' class=""cdk_buy"" id=""tips"" tiptext=""确定购买？<br/>"&cdk&"<br/>cdk内容"&kltool_get_cdkinfo(c_id)&""">购买</a>"&vbcrlf&_
			"</li>"&vbcrlf
		Next
		html=html&"<li class=""list-group-item"">"&vbcrlf&_
			"<button name=""kltool"" id=""Cdk_Fast_buy"" class=""btn btn-default"" data-loading-text=""Loading..."">一键购买本页cdk</button>"&vbcrlf&_
			"</li>"&vbcrlf&_
		kltool_page(2,count,pagecount,gopage)
	else
		html=html&"<div class=""alert alert-danger"">本分类暂时没有cdk出售</div>"
	end if
	Response.write kltool_code(html&kltool_end(1))
end sub

sub cdkbuy()
	c_id=request.querystring("c_id")
	set rs=server.CreateObject("adodb.recordset")
	rs.open "select * from [cdk] where id="&c_id&" and chushou=1",conn,1,2
	If rs.eof Then
		Response.Write"错误，不存在此记录"
		Response.End()
	end if
	cdk=rs("cdk")
	jiage=rs("jiage")
	jiage2=rs("jiage2")
	lx=rs("lx")
	rs.close
	set rs=nothing
	Response.Write"购买cdk:"&cdk&"<br/>"
	if lastnum<=0 then
		Response.Write"今日购买数量达到上限"
		Response.End()
	end if
	sl2=kltool_get_typemaxnum(lx)-kltool_get_typenum(lx)
	if sl2<=0 then
		Response.Write"本分类购买数量达到上限"
		Response.End()
	end if
	yh=kltool_get_typeyh(lx)
	last_jiage=0
	if jiage<>"" then
		last_jiage=jiage
		jiageyh=clng(jiage)*yh/100
		last_jiage=int(clng(jiage)-jiageyh)
		if money<last_jiage then
			Response.Write sitemoneyname&"不足,需要"&last_jiage
			Response.End()
		end if
	end if
	last_jiage2=0
	if rmb<>"" then
		 last_jiage2=jiage2
		jiage2yh=jiage2*yh/100
		last_jiage2=jiage2-jiage2yh
		if rmb<last_jiage2 then
			Response.Write "rmb不足,需要"&last_jiage2
			Response.End()
		end if
	end if
	conn.Execute("update [cdk] set chushou=2,userid="&userid&" where id="&c_id)
	Response.Write "购买成功 "
	if yh then Response.Write "优惠:"&yh&"%<br/>"
	if last_jiage then
		conn.Execute("update [user] set money=money-"&last_jiage&" where userid="&userid)
		Response.Write sitemoneyname&"-"&last_jiage&"<br/>"
		conn.execute"insert into [wap_bankLog](siteid,userid,actionName,money,leftMoney,opera_userid,opera_nickname,remark,ip,addtime)values("&siteid&","&userid&",'CDK购买','-"&last_jiage&"',"&money&","&userid&",'"&nickname&"','CDK购买','"&Request.ServerVariables("REMOTE_ADDR")&"','"&now&"')"
	end if
	if last_jiage2 then
		conn.Execute("update [user] set rmb=rmb-"&last_jiage2&" where userid="&userid)
		Response.Write "rmb-"&last_jiage2&"<br/>"
	end if
	conn.Execute("insert into [cdk_log] (userid,lx,cdk,jia,jia2,ltime)values("&userid&","&lx&",'"&cdk&"',"&last_jiage&","&last_jiage2&",'"&now()&"')")
end sub
%>