<!--#include file="../inc/config.asp"-->
<title>Vip自助开通</title>
<%
kltool_head("vip每日抽奖")
conn.execute("select jinbi,jinyan,xian from [wap2_smallType]")
If Err Then 
	err.Clear
	kltool_msge("请等待站长配置本功能")
end if
Response.Write"<div class=""line2"">您的"&sitemoneyname&":"&money&"　经验:"&expr&"</div>"
if kltool_yunxu=1 then Response.Write"<div class=tip><a href='admin1.asp?siteid="&siteid&"'>管理后台</a></div>"
pg=request("pg")
if pg="" then
	Response.Write"<div class=""line2"">您的身份:"&kltool_get_uservip(userid,1)&"&nbsp;<a href=""?pg=qx&siteid="&siteid&""">解除</a>"&kltool_get_uservip(userid,2)&"</div>"
	'-----
	set rs=server.CreateObject("adodb.recordset")
	rs.open "select * from [wap2_smallType] where siteid="&siteid&" and systype='card' and xian=1",conn,1,1
	If Not rs.eof	Then	
		gopage="?"
		Count=rs.recordcount
		pagecount=(count+pagesize-1)\pagesize	
		if page>pagecount then page=pagecount
		rs.move(pagesize*(page-1))
	call kltool_page(1)
		For i=1 To PageSize
		If rs.eof Then Exit For
	id=clng(rs("id"))
	jin=clng(rs("jinbi"))
	yan=clng(rs("jinyan"))
	Response.write "<div class=tip>"&id&"."
	if id=SessionTimeout then cs="续期" else cs="开通"
	Response.write kltool_get_vip(id,1)&"</div><div class=line1>此VIP每月需"&sitemoneyname&""&jin&" 经验"&yan&"</div>"
	Response.Write "<div class=line1>("&cs&"<form method='post' action='?'>"
	Response.Write "<input type='hidden' name='siteid' value='"&siteid&"'>"
	Response.Write "<input type='hidden' name='pg' value='kt'>"
	Response.Write "<input type='hidden' name='id' value='"&id&"'>"
	Response.Write "<input type='hidden' name='page' value='"&page&"'>"
	Response.Write "<input type='text' name='my' value='' size='3'>"
	Response.Write "<input type='submit' value='个月' name='submit' onClick=""ConfirmDel('是否确定？');return false"">)</form>"
	if int(clng(expr)-clng(yan))>0 and int(clng(money)-clng(jin))>0 then
	if int(clng(money)/clng(jin))>int(clng(expr)/clng(yan)) then Response.Write"可以"&cs&int(clng(money)/clng(jin))&"个月"
	end if
	Response.Write"</div>"
		rs.movenext
		Next
	call kltool_page(2)
	else
	   Response.write "<div class=tip>暂时没有VIP销售，请等待站长配置！</div>"
	end if
	rs.close
	set rs=nothing
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
elseif pg="kt" then
	my=clng(request("my"))
	id=clng(request("id"))
	page=clng(request("page"))

	set rs=server.CreateObject("adodb.recordset")
	rs.open "select * from [wap2_smallType] where siteid="&siteid&" and id="&id,conn,1,1
	if rs.eof then call kltool_msge("错误的vip")
	jin=clng(rs("jinbi"))
	yan=clng(rs("jinyan"))
	xian=clng(rs("xian"))
	rs.close
	set rs=nothing

	if xian<>1 then call kltool_msge("请不要钻空子")
	if my="" then call kltool_msge("请填写开通月份")
	if not Isnumeric(my) then call kltool_msge("必须是数字")
	if clng(money)<(jin*my) then call kltool_msge("金币不足,需"&jin*my)
	if clng(expr)<(yan*my) then call kltool_msge("经验不足,需"&yan*my)
	if clng(SessionTimeout)<>clng(id) and clng(SessionTimeout)>0 then call kltool_msge("当前有vip，请先解除")
		if clng(SessionTimeout)=clng(id) then
		if clng(userid)=clng(siteid) then
		Response.Write "<div class=line2>你已经成功续期此vip("&kltool_get_vip(id,1)&")，请进入地盘查看</div>"
		else
		xti=DateAdd("m",my,endtime)
		conn.Execute"update [user] set money=money-"&jin*my&",expR=expR-"&yan*my&",endTime='"&xti&"' where siteid="&siteid&" and userid="&userid
		conn.execute"insert into [wap_bankLog](siteid,userid,actionName,money,leftMoney,opera_userid,opera_nickname,remark,ip,addtime)values('"&siteid&"','"&userid&"','VIP自助开通','"&jin*my&"','"&money&"','"&userid&"','"&nickname&"','VIP自助开通','"&Request.ServerVariables("REMOTE_ADDR")&"','"&date()&" "&time()&"')"
		conn.execute"insert into [wap2_smallType_log] (userid,lx,vip,yue,jin,yan,vtime) values ('"&userid&"','2','"&id&"','"&my&"','"&jin*my&"','"&yan*my&"','"&date()&" "&time()&"')"
	Response.Write "<div class=line2>你已经成功续期此vip("&kltool_get_vip(id,1)&")"&my&"个月，截止到"&xti&"，请进入地盘查看</div>"
		end if
		else
		if clng(userid)=clng(siteid) then
		Response.Write "<div class=line2>你已经成功开通此vip("&kltool_get_vip(id,1)&")，请在地盘查看</div>"
		conn.Execute"update [user] set SessionTimeout="&id&" where siteid="&siteid&" and userid="&userid
		else
		ti=DateAdd("m",my,date())
		conn.Execute"update [user] set SessionTimeout="&id&",money=money-"&jin*my&",expR=expR-"&yan*my&",endTime='"&ti&"' where siteid="&siteid&" and userid="&userid
		conn.execute"insert into [wap_bankLog](siteid,userid,actionName,money,leftMoney,opera_userid,opera_nickname,remark,ip,addtime)values('"&siteid&"','"&userid&"','VIP自助开通','"&jin*my&"','"&money&"','"&userid&"','"&nickname&"','VIP自助开通','"&Request.ServerVariables("REMOTE_ADDR")&"','"&date()&" "&time()&"')"
		conn.execute"insert into [wap2_smallType_log] (userid,lx,vip,yue,jin,yan,vtime) values ('"&userid&"','1','"&id&"','"&my&"','"&jin*my&"','"&yan*my&"','"&date()&" "&time()&"')"
		Response.Write "<div class=line2>你已经成功开通此vip("&kltool_get_vip(id,1)&")"&my&"个月，截止到"&ti&"，请进入地盘查看</div>"
		end if
		end if
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
elseif pg="qx" then
	conn.Execute"update [user] set SessionTimeout=0 where siteid="&siteid&" and userid="&userid
	if clng(userid)<>clng(siteid) then conn.Execute"update [user] set endTime=null where siteid="&siteid&" and userid="&userid
	conn.execute"insert into [wap2_smallType_log] (userid,lx,vip,yue,jin,yan,vtime) values ('"&userid&"','3','0','0','0','0','"&date()&" "&time()&"')"
	response.write "<div class=tip>你已经解除当前vip，可以重新开通</div>"
end if
kltool_end
%>