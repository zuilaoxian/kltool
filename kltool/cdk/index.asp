<!--#include file="../inc/config.asp"-->
<%
kltool_head("CDK兑换系统")
kltool_sql("cdk")
jieshu=endTime
Response.write "<div class=line1>您的"&sitemoneyname&":"&money&"/经验:"&expr&"</div>"
if kltool_yunxu=1 then Response.Write "<div class=tip><a href='admin1.asp?siteid="&siteid&"'>后台管理</a></div>"
Response.Write "<div class=title><a href='?siteid="&siteid&"&amp;pg=mycdk'>我的CDK</a>　<a href='shop.asp?siteid="&siteid&"'>CDK商城</a></div>"


pg=request("pg")
if pg="" then

Response.Write "<div class=tip>兑换cdk</div>"
Response.Write "<form method='post' action='?siteid="&siteid&"&amp;pg=dh'>"
Response.Write "<div class=line1>输入要兑换的cdk：</div>"
Response.Write "<div class=line2><input name='cdk' type='text' size='20' value='' id='q'>"
Response.Write "<a onClick=""return ajaxQuerySetDom(document.getElementById('q').value,'../inc/key.asp?action=cdk&','q','result')"">校验</a><span id=""result""></span>"
Response.Write "<div class=line1><input type='submit' value='马上兑换' class='btn' onClick=""ConfirmDel('是否确定？');return false""></form>"
Response.Write "</div>"
'''''''''''''''''''''''兑换CDK
elseif pg="dh"  then
clx=request("clx")
cdk=request("cdk")
set rs=Server.CreateObject("ADODB.Recordset")
rs.open"select * from [cdk] where cdk='"&cdk&"' and chushou=2",conn,1,1
if rs.eof then call kltool_msge("CDK:["&cdk&"] 不存在，请核对")
lx=Clng(rs("lx"))
sy=Clng(rs("sy"))
jinbi=Clng(rs("jinbi"))
jingyan=Clng(rs("jingyan"))
sff=Clng(rs("sff"))
sf=Clng(rs("sf"))
lg=Clng(rs("lg"))
xg=""&rs("xg")&""
uid=Clng(rs("userid"))
chushou=clng(rs("chushou"))
rs.close
set rs=nothing

if uid<>"" and uid<>clng(userid) then call kltool_msge("CDK:["&cdk&"] 不属于你，不可以兑换")
if sy=2 then call kltool_msge("CDK:["&cdk&"] 已被使用")
response.write "<div class=line1>你使用了CDK:["&cdk&"]</div>"
	if lx=1 then
	conn.Execute("update [user] set money=money+"&jinbi&" where userid="&userid)
	response.write "<div class=tip>你的"&sitemoneyname&"增加了"&jinbi&"个</div>"

	elseif lx=2 then
	conn.Execute("update [user] set expR=expR+"&jingyan&" where userid="&userid)
	response.write "<div class=tip>你的经验增加了"&jingyan&"点</div>"

	elseif lx=3 then
	conn.Execute("update [user] set money=money+"&jinbi&",expR=expR+"&jingyan&" where userid="&userid)
	response.write "<div class=tip>你的"&sitemoneyname&"增加了"&jinbi&"个,经验增加了"&jingyan&"</div>"

	elseif lx=4 then
	if clng(sf)=clng(sessiontimeout) then
	 if userid<>siteid then
	 ti1=DateAdd("m",""&sff&"",""&jieshu&"")
	conn.Execute("update [user] set endTime='"&ti1&"' where userid="&userid&"")
	 response.write "<div class=tip>兑换CDK成功，VIP时长已增加"&sff&"个月,截止到"&ti1&"</div>"
	 else
	 response.write "<div class=tip>兑换CDK成功</div>"
	 end if
	else
	 conn.Execute("update [user] set SessionTimeout="&sf&" where userid="&userid)
	 if userid<>siteid then
	ti=DateAdd("m",""&sff&"",date())
	conn.Execute("update [user] set endTime='"&ti&"' where userid="&userid&"")
	 response.write "<div class=tip>兑换了"&sff&"个月VIP("&kltool_get_vip(sf,1)&") 截止到"&ti&"</div>"
	 else
	 response.write "<div class=tip>兑换CDK成功</div>"
	 end if
	end if

	elseif lx=5 then
	conn.Execute("update [user] set LoginTimes=LoginTimes+"&lg&" where userid="&userid)
	response.write "<div class=tip>你的在线积时增加了："&lg&"秒</div>"

	elseif lx=6 then
	arrstr=Split(moneyname,"|")
	For i=0 To UBound(arrstr)
	if arrstr(i)=xg then
	kltool_msge("您已经拥有此勋章！")
	Exit For
	end if
	next
	 conn.Execute("update [user] set moneyname='"&moneyname&"|"&xg&"|' where userid="&userid)
	 if Instr(moneyname,"||")>0 then conn.Execute("update [user] set moneyname=replace(cast(moneyname as varchar(8000)),'||','|')")
	response.write "<div class=tip>成功兑换了勋章奖励"&kltool_get_xunzhang(xg)&"</div>"
	end if
	conn.Execute("update [cdk] set sy=2,userid="&userid&" Where cdk='"&cdk&"'")
	if lx=1 or lx=2 or lx=3 then
	conn.execute"insert into [wap_bankLog](siteid,userid,actionName,money,leftMoney,opera_userid,opera_nickname,remark,ip,addtime)values('"&siteid&"','"&userid&"','CDK兑换','"&jinbi&"','"&money&"','"&userid&"','"&nickname&"','CDK使用:"&cdk&"','"&Request.ServerVariables("REMOTE_ADDR")&"','"&date()&" "&time()&"')"
	End if

	response.write "<div class=line1>立即进入<a href='/myfile.aspx?siteid="&siteid&"'>我的地盘查看</a></div>"
'''''''''''''''''''''''我的CDK
elseif pg="mycdk"  then
Response.Write "<div class=tip>我的CDK　<a href='?siteid="&siteid&"'>兑换CDK</a></div>"
set rs=server.CreateObject("adodb.recordset")
rs.open "select * from [cdk] where userid="&userid&" and chushou=2 order by time desc",conn,1,1
If Not rs.eof Then
	gopage="?pg=mycdk&amp;"
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
zs=clng(rs("zs"))
sy=clng(rs("sy"))
if sy=1 then
Response.write "<div class=line1>【未使用】"
else
Response.write "<div class=line1>【已使用】"
end if
Response.write ""&page*PageSize+i-PageSize&"_CDK:"&rs("cdk")&"</div>"

if lx=1 then
Response.write "<div class=line2>　此CDK奖励为:"&sitemoneyname&""&rs("jinbi")&"</div>"
elseif lx=2 then
Response.write "<div class=line2>　此CDK奖励为:经验"&rs("jingyan")&"</div>"
elseif lx=3 then
Response.write "<div class=line2>　此CDK奖励为:"&sitemoneyname&""&rs("jinbi")&",经验"&rs("jingyan")&"</div>"
elseif lx=4 then
Response.write "<div class=line2>　此CDK奖励为:"&rs("sff")&"个月VIP("&kltool_get_vip(rs("sf"),1)&")"
if clng(sy)=1 and clng(rs("sf"))=clng(sessiontimeout) then
Response.Write "<br/>　{与当前身份相同，使用后将进行延期操作}"
elseif clng(sy)=1 and Clng(sessiontimeout)>0 then
Response.Write "<br/>　{与当前身份不相同，使用后将顶替当前身份}"
end if
Response.write "</div>"
elseif lx=5 then
Response.write "<div class=line2>　此CDK奖励为:"&rs("lg")&"秒积时</div>"
elseif lx=6 then
Response.write "<div class=line2>　此CDK奖励为:勋章奖励"&kltool_get_xunzhang(rs("xg"))&"</div>"
end if
if sy=1 or zs=1 then Response.write "<div class=content>"
if sy=1 then
Response.write "　<a href='?siteid="&siteid&"&amp;pg=dh&amp;cdk="&rs("cdk")&"&amp;clx=dh' onClick=""ConfirmDel('是否确定？');return false"">点击使用</a>"
if zs=1 then Response.write " <a href='?siteid="&siteid&"&amp;pg=zengsong&amp;id="&rs("id")&"'>赠予他人</a>"
end if
if sy=1 or zs=1 then Response.write "</div>"
	rs.movenext
 	Next
call kltool_page(2)
else
   Response.write "<div class=tip>暂时没有记录！</div>"
end if
rs.close
set rs=nothing
''''''''''''''''''''''''''''转增操作
elseif pg="zengsong"  then
id=request("id")
Response.Write "<div class=tip>CDK转增</div>"
Response.Write "<form method='post' action='?siteid="&siteid&"'>"
Response.Write "<input type='hidden' name='id' value='"&id&"'>"
Response.Write "<input type='hidden' name='pg' value='zengsong1'>"
Response.Write "<div class=line1><input type='text' name='uid' value=''></div>"
Response.Write "<div class=line2><input type='submit' value='转增' onClick=""ConfirmDel('是否确定？');return false""></div>"

elseif pg="zengsong1"  then
id=request("id")
uid=request("uid")
if uid="" then call kltool_msge("错误,id不能为空")
if not Isnumeric(uid) then call kltool_msge("id必须是数字")
if clng(uid)=clng(userid) then call kltool_msge("这本来就是你的CDK好吧")

set rs=conn.execute("select userid from [user] where userid="&uid)
If rs.eof Then call kltool_msge("错误,ID:"&uid&"不存在，请核对")
rs.close
set rs=nothing

set rs=server.CreateObject("adodb.recordset")
rs.open "select * from [cdk] where id="&id&" and userid="&userid&" and chushou=2",conn,1,2
if rs.eof then call kltool_msge("错误,CDK不存在")
zcdk=rs("cdk")
if clng(rs("zs"))=2 then call kltool_msge("错误,此cdk不允许转增")
if clng(rs("sy"))=2 then call kltool_msge("对不起，已使用过的CDK无法转增")
rs("userid")=uid
rs.update
rs.close
set rs=nothing
   Response.write "<div class=tip>转增成功!已经使用内信通知对方!</div>"
conn.execute("insert into [wap_message](siteid,userid,nickname,title,content,touserid,isnew,issystem,addtime,HangBiaoShi)values('"&siteid&"','"&userid&"','"&nickname&"','来自CDK的转赠信息','您的朋友："&nickname&"赠送了一个CDK给您，请[url="&kltool_path&"cdk/index.asp?siteid=[siteid]&pg=mycdk]前往查看[/url]','"&uid&"','1','0','"&date()&" "&time()&"','0')")
conn.execute("insert into [wap_message](siteid,userid,nickname,title,content,touserid,isnew,issystem,addtime,HangBiaoShi)values('"&siteid&"','"&uid&"','"&nickname&"','CDK的赠送信息','您赠送了一个CDK给您的好友{"&uid&"},"&zcdk&"','"&userid&"','2','0','"&date()&" "&time()&"','0')")

end if
call kltool_end
%>