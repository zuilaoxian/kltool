<!--#include file="../inc/head.asp"-->
<title>CDK兑换系统-商城</title>
<%
conn.execute("select * from [cdk_set]")
If Err Then 
err.Clear
call kltool_err_msg("请先等待站长配置")
end if
myzsl=10	'限制购买总量
Response.write "<div class=line1>您的"&sitemoneyname&":"&money&"/经验:"&expr&"</div>"
if kltool_yunxu=1 then Response.Write "<div class=tip><a href='admin1.asp?siteid="&siteid&"'>后台管理</a></div>"
Response.Write "<div class=title><a href='index.asp?siteid="&siteid&"'>兑换CDK</a>　<a href='index.asp?siteid="&siteid&"&amp;pg=mycdk'>我的CDK</a></div>"

pg=request("pg")
if pg="" then
'-----查询各种CDK数量
Function cdkcount(lx,chushou)
set rs=server.CreateObject("adodb.recordset")
rs.open "select * from [cdk] where lx="&lx&" and chushou="&chushou,conn,1,1
cdkcount=rs.recordcount
rs.close
set rs=nothing
End Function
'-----显示
Response.Write "<div class=tip>商城出售以下商品　<br/><a href='?siteid="&siteid&"&amp;pg=gou'>查看每日限购信息</a></div>"
Response.write "<div class=line1><a href='?siteid="&siteid&"&amp;lx=lx1&amp;pg=shop'>"&sitemoneyname&"CDK</a>/剩余("&cdkcount(1,1)&")</div>"
Response.write "<div class=line2><a href='?siteid="&siteid&"&amp;lx=lx2&amp;pg=shop'>经验CDK</a>/剩余("&cdkcount(2,1)&")</div>"
Response.write "<div class=line1><a href='?siteid="&siteid&"&amp;lx=lx3&amp;pg=shop'>"&sitemoneyname&"+经验</a>/剩余("&cdkcount(3,1)&")</div>"
Response.write "<div class=line2><a href='?siteid="&siteid&"&amp;lx=lx4&amp;pg=shop'>VIP身份</a>/剩余("&cdkcount(4,1)&")</div>"
Response.write "<div class=line1><a href='?siteid="&siteid&"&amp;lx=lx5&amp;pg=shop'>在线积时</a>/剩余("&cdkcount(5,1)&")</div>"
Response.write "<div class=line2><a href='?siteid="&siteid&"&amp;lx=lx6&amp;pg=shop'>勋章类</a>/剩余("&cdkcount(6,1)&")</div>"

set rs=server.CreateObject("adodb.recordset")
rs.open "select * from [cdk_log] where year(ltime)="&year(now)&" and month(ltime)="&month(now)&" and day(ltime)="&day(now)&" order by ltime desc",conn,1,1
If Not rs.eof Then
	gopage="?"
	Count=rs.recordcount
	page=int(request("page"))
	if page<=0 or page="" then page=1
	pagecount=(count+pagesize-1)\pagesize
	if page>pagecount then page=pagecount
	rs.move(pagesize*(page-1))
call kltool_page(1)
	For i=1 To PageSize
	If rs.eof Then Exit For
lx=clng(rs("lx"))
if lx=1 then
clx=""&sitemoneyname&""
elseif lx=2 then
clx="经验"
elseif lx=3 then
clx=""&sitemoneyname&"+经验"
elseif lx=4 then
clx="Vip"
elseif lx=5 then
clx="积时"
elseif lx=6 then
clx="勋章"
end if

if i mod 2 = 0 then Response.Write"<div class=""line1"">" else Response.Write"<div class=""line2"">"
Response.Write page*PageSize+i-PageSize&"."&kltool_get_usernickname(rs("userid"),1)&"("&rs("userid")&")"
mytime=kltool_DateDiff(rs("ltime"),now(),"n")
if mytime<60 then
Response.Write mytime&"分钟前购买了<font color=""#FF2D2D"">"&clx&"</font>cdk"
else
Response.Write"购买了<font color=""#FF2D2D"">"&clx&"</font>cdk(<small><small>"&month(rs("ltime"))&"-"&day(rs("ltime"))&"&nbsp;"&hour(rs("ltime"))&":"&minute(rs("ltime"))&"</small></small>)"
end if
Response.Write"</div>"
	rs.movenext
 	Next
call kltool_page(2)
end if
rs.close
set rs=nothing
'---出售页
elseif pg="shop" then
lx=request("lx")
if lx="" then response.redirect "?siteid="&siteid&""
Response.Write "<div class=tip>选购商品　<a href='?siteid="&siteid&"'>查看其他</a></div>"
'总量
set rs=server.CreateObject("adodb.recordset")
rs.open "select * from [cdk_log] where userid="&userid&" and year(ltime)="&year(now)&" and month(ltime)="&month(now)&" and day(ltime)="&day(now),conn,1,1
jtzsl=rs.recordcount '今天购买数量
sl1=myzsl-jtzsl
if sl1>0 then Response.Write"<div class=""content"">您今天还可购买的总量为"&sl1&"</div>" else Response.Write"<div class=""content"">您今天还可购买的总量为0</div>"
rs.close
set rs=nothing

'分类总量
set rs1=server.CreateObject("adodb.recordset")
if lx="lx1" then
rs1.open "select * from [cdk_log] where userid='"&userid&"' and lx=1 and year(ltime)="&year(now)&" and month(ltime)="&month(now)&" and day(ltime)="&day(now),conn,1,1
elseif lx="lx2" then
rs1.open "select * from [cdk_log] where userid='"&userid&"' and lx=2 and year(ltime)="&year(now)&" and month(ltime)="&month(now)&" and day(ltime)="&day(now),conn,1,1
elseif lx="lx3" then
rs1.open "select * from [cdk_log] where userid='"&userid&"' and lx=3 and year(ltime)="&year(now)&" and month(ltime)="&month(now)&" and day(ltime)="&day(now),conn,1,1
elseif lx="lx4" then
rs1.open "select * from [cdk_log] where userid='"&userid&"' and lx=4 and year(ltime)="&year(now)&" and month(ltime)="&month(now)&" and day(ltime)="&day(now),conn,1,1
elseif lx="lx5" then
rs1.open "select * from [cdk_log] where userid='"&userid&"' and lx=5 and year(ltime)="&year(now)&" and month(ltime)="&month(now)&" and day(ltime)="&day(now),conn,1,1
elseif lx="lx6" then
rs1.open "select * from [cdk_log] where userid='"&userid&"' and lx=6 and year(ltime)="&year(now)&" and month(ltime)="&month(now)&" and day(ltime)="&day(now),conn,1,1
end if
If Not rs1.eof Then
flsl=rs1.recordcount
end if
rs1.close
set rs1=nothing

set rs2=server.CreateObject("adodb.recordset")
if lx="lx1" then
rs2.open "select * from [cdk_set] where lx=1",conn,1,1
elseif lx="lx2" then
rs2.open "select * from [cdk_set] where lx=2",conn,1,1
elseif lx="lx3" then
rs2.open "select * from [cdk_set] where lx=3",conn,1,1
elseif lx="lx4" then
rs2.open "select * from [cdk_set] where lx=4",conn,1,1
elseif lx="lx5" then
rs2.open "select * from [cdk_set] where lx=5",conn,1,1
elseif lx="lx6" then
rs2.open "select * from [cdk_set] where lx=6",conn,1,1
end if
if SessionTimeout>0 then
if rs2("vsl")<>"" then mysl=clng(rs2("vsl")) else mysl=0
else
if rs2("sl")<>"" then mysl=clng(rs2("sl")) else mysl=0
end if
rs2.close
set rs2=nothing

sl2=mysl-flsl

if sl2>0 then Response.Write"<div class=""content"">本商品:您可购买的数量为"&sl2&"</div>" else Response.Write"<div class=""content"">本商品:您可购买的数量为0</div>"

set rs=server.CreateObject("adodb.recordset")
if lx="" then
rs.open "select * from [cdk]",conn,1,1
elseif lx="lx1" then
rs.open "select * from [cdk] where lx=1 and chushou=1",conn,1,1
elseif lx="lx2" then
rs.open "select * from [cdk] where lx=2 and chushou=1",conn,1,1
elseif lx="lx3" then
rs.open "select * from [cdk] where lx=3 and chushou=1",conn,1,1
elseif lx="lx4" then
rs.open "select * from [cdk] where lx=4 and chushou=1",conn,1,1
elseif lx="lx5" then
rs.open "select * from [cdk] where lx=5 and chushou=1",conn,1,1
elseif lx="lx6" then
rs.open "select * from [cdk] where lx=6 and chushou=1",conn,1,1
end if
If Not rs.eof Then
	PageSize=10
	gopage="?lx="&lx&"&amp;pg=shop&amp;"
	Count=rs.recordcount	
	page=int(request("page"))
	if page<=0 or page="" then page=1	
	pagecount=(count+pagesize-1)\pagesize
	if page>pagecount then page=pagecount
	rs.move(pagesize*(page-1))
call kltool_page(1)
	For i=1 To PageSize
	If rs.eof Then Exit For
Response.write "<div class=line1>"&rs("id")&"."
Response.write ""&rs("cdk")&""
if rs("zs")="1" then Response.write "  {可转增}"
if rs("zs")="2" then Response.write "  {不可转增}"
Response.write "</div><div class=line2>"
clx=""&rs("lx")&""
if clx=1 then
Response.write "此CDK奖励为:"&sitemoneyname&""&rs("jinbi")&""
elseif clx=2 then
Response.write "此CDK奖励为:经验"&rs("jingyan")&""
elseif clx=3 then
Response.write "此CDK奖励为:"&sitemoneyname&""&rs("jinbi")&",经验"&rs("jingyan")&""
elseif clx=4 then
Response.write "此CDK奖励为:"&rs("sff")&"个月VIP"&kltool_get_vip(rs("sf"),1)
elseif clx=5 then
Response.write "此CDK奖励为:"&rs("lg")&"秒积时"
elseif clx=6 then
Response.write "此CDK奖励为:勋章奖励"&kltool_get_xunzhang(rs("xg"))
end if
Response.write "</div>"
if rs("chushou")="1" then Response.write "<div class=line2>　出售中　价格:"&rs("jiage")&"　<a href='?siteid="&siteid&"&amp;pg=shoping&amp;id="&rs("id")&"'>购买</a></div>"
	rs.movenext
 	Next
call kltool_page(2)
else
   Response.write "<div class=tip>暂时没有记录！</div>"
end if
rs.close
set rs=nothing
'---购买
elseif pg="shoping" then
id=clng(request("id"))
set rs=server.CreateObject("adodb.recordset")
rs.open "select * from [cdk] where id="&id&" and chushou=1",conn,1,1
If rs.eof Then call kltool_err_msg("错误，不存在此记录")
lx=clng(rs("lx"))
jiage=clng(rs("jiage"))
rs.close
set rs=nothing
'检测今日购买数量及折扣
'总量
set rs=server.CreateObject("adodb.recordset")
rs.open "select * from [cdk_log] where userid="&userid&" and year(ltime)="&year(now)&" and month(ltime)="&month(now)&" and day(ltime)="&day(now),conn,1,1
jtzsl=rs.recordcount
if jtzsl>=myzsl then call kltool_err_msg("对不起，您今日购买的CDK总数量达到上限！")
rs.close
set rs=nothing
'分类量
set rs=server.CreateObject("adodb.recordset")
rs.open "select * from [cdk_log] where userid="&userid&" and lx="&lx&"  and year(ltime)="&year(now)&" and month(ltime)="&month(now)&" and day(ltime)="&day(now),conn,1,1
flsl=rs.recordcount
rs.close
set rs=nothing
	set rs=server.CreateObject("adodb.recordset")
	rs.open "select * from [cdk_set] where lx="&lx,conn,1,1
		if SessionTimeout>0 then
		mysl=clng(rs("vsl"))
		else
		mysl=clng(rs("sl"))
		end if
	zhekou=clng(rs("yh"))'折扣
	rs.close
	set rs=nothing
if flsl>=mysl then call kltool_err_msg("对不起，您今日购买的本类CDK总数量达到上限！")

if clng(money)<jiage then Response.write "<div class=line2>提醒:您的"&sitemoneyname&"不足够支付此CDK</div>"
if SessionTimeout>0 and zhekou>0 then
Response.write "<div class=tip>购买将花费"&sitemoneyname&":"&clng(jiage-jiage*zhekou/100)&"<br/>(原价:"&jiage&" 享受会员折扣{优惠"&zhekou&"%})</div><div class=line2>计算公式:原价-原价×优惠÷100</div>"
else
Response.write "<div class=tip>购买将花费"&sitemoneyname&":"&jiage&"</div>"
end if

Response.write "<form method='post' action='?siteid="&siteid&"&amp;pg=buy'>"
Response.write "<input type='hidden' name='id' value='"&id&"'/>"
Response.write "<div class=title><input type='submit' value='确定购买'></form>　<a href='?siteid="&siteid&"'>返回</a></div>"

'---支付
elseif pg="buy" then
id=request("id")

set rs=server.CreateObject("adodb.recordset")
rs.open "select * from [cdk] where id="&id&" and chushou=1",conn,1,2
If rs.eof Then call kltool_err_msg("错误，不存在此记录")
jiage=clng(rs("jiage"))
lx=clng(rs("lx"))
'检测今日购买数量及折扣
'总量
set rs0=server.CreateObject("adodb.recordset")
rs0.open "select * from [cdk_log] where userid="&userid&" and year(ltime)="&year(now)&" and month(ltime)="&month(now)&" and day(ltime)="&day(now),conn,1,1
jtzsl=rs0.recordcount
if jtzsl>=myzsl then call kltool_err_msg("对不起，您今日购买的CDK总数量达到上限！")
rs0.close
set rs0=nothing
'分类量
set rs1=server.CreateObject("adodb.recordset")
rs1.open "select * from [cdk_log] where userid="&userid&" and lx="&lx&"  and year(ltime)="&year(now)&" and month(ltime)="&month(now)&" and day(ltime)="&day(now),conn,1,1
flsl=rs1.recordcount
	set rs2=server.CreateObject("adodb.recordset")
	rs2.open "select * from [cdk_set] where lx="&lx,conn,1,1
		if SessionTimeout>0 then
		mysl=clng(rs2("vsl"))
		else
		mysl=clng(rs2("sl"))
		end if
	zhekou=clng(rs2("yh"))'折扣
	rs2.close
	set rs2=nothing
if flsl>=mysl then call kltool_err_msg("对不起，您今日购买的本类CDK总数量达到上限！")
rs1.close
set rs1=nothing

if userid<>siteid and clng(money)<jiage then Response.redirect"?siteid="&siteid&"&pg=buycuo"
rs("chushou")=2
rs("userid")=userid
rs.update
	if userid=siteid then
	elseif SessionTimeout>99 then 
	conn.Execute("update [user] set money=money-"&clng(jiage-jiage*zhekou/100)&" where userid="&userid)
conn.execute"insert into [wap_bankLog](siteid,userid,actionName,money,leftMoney,opera_userid,opera_nickname,remark,ip,addtime)values('"&siteid&"','"&userid&"','CDK购买(半价)','-"&clng(jiage-jiage*zhekou/100)&"','"&money&"','"&userid&"','"&nickname&"','CDK购买','"&Request.ServerVariables("REMOTE_ADDR")&"','"&date()&" "&time()&"')"
	else
	conn.Execute("update [user] set money=money-"&rs("jiage")&" where userid="&userid)
conn.execute"insert into [wap_bankLog](siteid,userid,actionName,money,leftMoney,opera_userid,opera_nickname,remark,ip,addtime)values('"&siteid&"','"&userid&"','CDK购买','-"&rs("jiage")&"','"&money&"','"&userid&"','"&nickname&"','CDK购买','"&Request.ServerVariables("REMOTE_ADDR")&"','"&date()&" "&time()&"')"
	end if
	conn.Execute("insert into [cdk_log] (userid,lx,cdk,jia,ltime)values('"&userid&"','"&rs("lx")&"','"&rs("cdk")&"','"&clng(jiage-jiage*zhekou/100)&"','"&date()&" "&time()&"')")

rs.close
set rs=nothing
Response.redirect"?siteid="&siteid&"&pg=buyok"
'---购买状态
elseif pg="buyok" then
   Response.write "<div class=tip>购买成功，进入我的CDK仓库查看吧</div>"
elseif pg="buycuo" then
   Response.write "<div class=tip>购买失败，身上"&sitemoneyname&"余额不足</div>"
'-------------------------------------
elseif pg="gou" then
Response.write "<div class=tip><a href='?siteid="&siteid&"'>前往购买</a></div>"
Response.write "<div class=content>每人限制总量为:"&myzsl&"<br/>下面是单个类型可购买上限以及优惠信息</div>"

set rs=server.CreateObject("adodb.recordset")
rs.open "select top 6 * from [cdk_set]",conn,1,1
If Not rs.eof	Then
	gopage="?pg=gou&amp;"
	Count=rs.recordcount	
	page=int(request("page"))
	if page<=0 or page="" then page=1		
	pagecount=(count+pagesize-1)\pagesize	
   if page>pagecount then page=pagecount
	rs.move(pagesize*(page-1))
call kltool_page(1)
	For i=1 To PageSize 
	If rs.eof Then Exit For
lx=clng(rs("lx"))
if lx=1 then
clx=""&sitemoneyname&"类CDK"
elseif lx=2 then
clx="经验类CDK"
elseif lx=3 then
clx=""&sitemoneyname&"+经验类CDK"
elseif lx=4 then
clx="Vip类CDK"
elseif lx=5 then
clx="积时类CDK"
elseif lx=6 then
clx="勋章类CDK"
end if
Response.write"<div class=""line1"">"&rs("id")&"."&clx&":VIP会员优惠"&clng(rs("yh"))&"%</div>"
Response.write"<div class=""line2"">　可购数:"&clng(rs("sl"))&"　vip可购数"&clng(rs("vsl"))&"</div>"
rs.movenext
 	Next
call kltool_page(2)
else
Response.write"<div class=tip>暂时没有记录！</div>"
end if
rs.close
set rs=nothing

end if
call kltool_end
%>