<!--#include file="../config.asp"-->
<%
kltool_use(4)
kltool_sql("wap2_smallType_log")
action=Request.QueryString("action")
select case action
	case ""
		call index()
	case "ktvip"
		call ktvip()
	case "jcvip"
		call jcvip()
	case "getvip"
		call getvip()
end select
sub index()
	html=kltool_head("vip自助开通",1)&_
	"<li class=""list-group-item has-warning"" id=""r_vip"">"&vbcrlf&_
	"	您的身份:"&kltool_get_uservip(userid,1)&vbcrlf
	if SessionTimeout>0 then 
		html=html&"	<a href=""?action=jcvip&siteid="&siteid&""" id=""tips"" tiptext=""确定解除？"">解除</a>"&vbcrlf&_
		kltool_get_uservip(userid,2)&vbcrlf
	end if
	html=html&"</li>"&vbcrlf
	str=kltool_GetRow("select id,jinbi,jinyan,rmb,xian from [wap2_smallType] where siteid="&siteid&" and systype='card' and xian=1",0,20)
	If str(0) Then
		gopage="?"
		Count=str(0)
		pagecount=str(1)
		if page>pagecount then page=pagecount
		html=html&kltool_page(1,count,pagecount,gopage)
		For i=0 To ubound(str(2),2)
			id=str(2)(0,i)
			jinbi=str(2)(1,i)
			jinyan=str(2)(2,i)
			rmb=str(2)(3,i)
			xian=str(2)(4,i)
			shoptip=""
			vip=kltool_get_vip(id,0)
			if instr(vip,"_")>0 then
				vip_Split=Split(vip,"_")
				bbs_grow1=vip_Split(1)
				bbs_grow2=vip_Split(2)
				bbs_grow_tip=""
				if bbs_grow1<>"" then bbs_grow_tip="发帖币递增:"&bbs_grow1&"% "
				if bbs_grow2<>"" then bbs_grow_tip=bbs_grow_tip&"回帖经验递增:"&bbs_grow2&"%"
			end if
			if bbs_grow_tip<>"" then bbs_grow_tip="<br>效果:"&bbs_grow_tip
			if jinbi<>"" and not isnull(jinbi) and clng(jinbi)>0 then
				shoptip=shoptip&sitemoneyname&":"&jinbi&" "
				jinbi=clng(jinbi)
			end if
			if jinyan<>"" and not isnull(jinyan) and clng(jinyan)>0 then
				shoptip=shoptip&"经验:"&jinyan&" "
				jinyan=clng(jinyan)
			end if
			if rmb<>"" and not isnull(rmb) and rmb>0 then
				shoptip=shoptip&"rmb:"&rmb&" "
				rmb=rmb
			end if
			if clng(id)=SessionTimeout then cs="续期" else cs="开通"
			html=html&"<li class=""list-group-item"">"&vbcrlf&_
			" <div role=""form"" class=""bs-example bs-example-form"">"&vbcrlf&_
			"  <div class=""form-group"">"&vbcrlf&_
			"	<label for=""name"">"&id&"."&kltool_get_vip(id,1)&"</label>"&vbcrlf&_
			"  </div>"&vbcrlf&_
			"  <div class=""form-group"">"&vbcrlf&_
			"	<label for=""name"">"&shoptip&bbs_grow_tip&"</label>"&vbcrlf&_
			"  </div>"&vbcrlf&_
			"  <div class=""form-group input-group"">"&vbcrlf&_
			"    <span class=""input-group-addon"">"&cs&"</span>"&vbcrlf&_
			"    <input type=""text"" name=""r_num"&id&""" id=""r_num"&id&""" value="""" class=""form-control"">"&vbcrlf&_
			"    <span class=""input-group-addon"">月</span>"&vbcrlf&_
			"  </div>"&vbcrlf&_
			"	<button name=""kltool"" vipid="""&id&""" type=""button"" class=""btn btn-default btn-block"" id=""Vip_pay"" data-loading-text=""Loading..."">确定</button>"&vbcrlf&_
			" </div>"&vbcrlf&_
			"</li>"&vbcrlf
		Next
		html=html&kltool_page(2,count,pagecount,gopage)
	else
		html=html&"<div class=""alert alert-danger"">暂时没有VIP销售，请等待站长配置！</div>"
	end if
	Response.write kltool_code(html&kltool_end(1))
end sub

sub ktvip()
	r_id=Request.Form("r_id")
	r_num=Request.Form("r_num")

	if r_num="" or not Isnumeric(r_num) then
		Response.Write"操作失败"
		Response.End()
	else
		r_num=clng(r_num)
	end if
	if r_id then r_id=clng(r_id)

	if SessionTimeout<>r_id and SessionTimeout>0 and userid<>siteid then
		Response.Write "当前有vip，请先解除"
		Response.End()
	end if
	set rs=server.CreateObject("adodb.recordset")
	rs.open "select * from [wap2_smallType] where siteid="&siteid&" and id="&r_id&" and xian=1",conn,1,1
	if rs.eof then
		Response.Write"错误的vip"
		Response.End()
	end if
		r_jinbi=rs("jinbi")
		r_jinyan=rs("jinyan")
		r_rmb=rs("rmb")
		
		if r_jinbi="" or isnull(r_jinbi) then
			r_jinbi=0
			r_jinbi_jia=0
			sql1=""
		else
			r_jinbi=clng(r_jinbi)
			r_jinbi_jia=r_jinbi*r_num
			sql1="update [user] set money=money-"&r_jinbi_jia&" where siteid="&siteid&" and userid="&userid
		end if
		
		if r_jinyan="" or isnull(r_jinyan) then
			r_jinyan=0
			r_jinyan_jia=0
			sql2=""
		else
			r_jinyan=clng(r_jinyan)
			r_jinyan_jia=r_jinyan*r_num
			sql2="update [user] set expr=expr-"&r_jinyan_jia&" where siteid="&siteid&" and userid="&userid
		end if
		
		if r_rmb="" or isnull(r_rmb) then
			r_rmb=0
			r_rmb_jia=0
			sql3=""
		else
			r_rmb_jia=r_rmb*r_num
			sql3="update [user] set rmb=rmb-"&r_rmb_jia&" where siteid="&siteid&" and userid="&userid
		end if
		
		if clng(money)<r_jinbi_jia and userid<>siteid then
			Response.Write sitemoneyname&"不足 需要"&r_jinbi_jia
			Response.End()
		end if
		if clng(expr)<r_jinyan_jia and userid<>siteid then
			Response.Write "经验不足 需要"&r_jinyan_jia
			Response.End()
		end if
		if rmb<r_rmb_jia and userid<>siteid then
			Response.Write "rmb不足 需要"&r_rmb_jia
			Response.End()
		end if
		
	rs.close
	set rs=nothing
		'续期
		if SessionTimeout=r_id then
			if userid=siteid then
				Response.Write "成功续期vip("&kltool_get_vip(r_id,1)&")"
				conn.Execute"update [user] set endTime=null where siteid="&siteid&" and userid="&userid
				conn.execute"insert into [wap2_smallType_log] (userid,lx,vip,time) values ("&userid&",2,"&r_id&",'"&now()&"')"
			else
				ti=DateAdd("m",r_num,endtime)
				if sql1<>"" then conn.Execute(sql1)
				if sql2<>"" then conn.Execute(sql2)
				if sql3<>"" then conn.Execute(sql3)
				conn.Execute"update [user] set endTime='"&ti&"' where siteid="&siteid&" and userid="&userid
				if sql1<>"" then conn.execute"insert into [wap_bankLog](siteid,userid,actionName,money,leftMoney,opera_userid,opera_nickname,remark,ip,addtime)values("&siteid&","&userid&",'VIP自助开通',"&r_jinbi_jia&","&money&","&userid&",'"&nickname&"','VIP自助开通','"&Request.ServerVariables("REMOTE_ADDR")&"','"&now()&"')"
				conn.execute"insert into [wap2_smallType_log] (userid,lx,vip,yue,jinbi,jinyan,rmb,time) values ("&userid&",2,"&r_id&","&r_num&","&r_jinbi_jia&","&r_jinyan_jia&","&r_rmb_jia&",'"&now()&"')"
			Response.Write "成功续期vip("&kltool_get_vip(r_id,1)&")"&r_num&"个月<br/>截止到"&ti
			end if
		'开通
		else
			if userid=siteid then
				Response.Write "成功开通vip("&kltool_get_vip(r_id,1)&")"
				conn.Execute"update [user] set SessionTimeout="&r_id&",endTime=null where siteid="&siteid&" and userid="&userid
				conn.execute"insert into [wap2_smallType_log] (userid,lx,vip,time) values ("&userid&",1,"&r_id&",'"&now()&"')"
			else
				ti=DateAdd("m",r_num,now())
				if sql1<>"" then conn.Execute(sql1)
				if sql2<>"" then conn.Execute(sql2)
				if sql3<>"" then conn.Execute(sql3)
				conn.Execute"update [user] set SessionTimeout="&r_id&",endTime='"&ti&"' where siteid="&siteid&" and userid="&userid
				if sql1<>"" then conn.execute"insert into [wap_bankLog](siteid,userid,actionName,money,leftMoney,opera_userid,opera_nickname,remark,ip,addtime)values("&siteid&","&userid&",'VIP自助开通',"&r_jinbi_jia&","&money&","&userid&",'"&nickname&"','VIP自助开通','"&Request.ServerVariables("REMOTE_ADDR")&"','"&now()&"')"
				conn.execute"insert into [wap2_smallType_log] (userid,lx,vip,yue,jinbi,jinyan,rmb,time) values ("&userid&",1,"&r_id&","&r_num&","&r_jinbi_jia&","&r_jinyan_jia&","&r_rmb_jia&",'"&now()&"')"
				Response.Write "成功开通vip("&kltool_get_vip(r_id,1)&")"&r_num&"个月<br/>截止到"&ti
			end if
		end if
end sub

sub jcvip()
	conn.execute"insert into [wap2_smallType_log] (userid,lx,vip,time) values ("&userid&",3,"&SessionTimeout&",'"&now()&"')"
	conn.Execute"update [user] set SessionTimeout=0,endTime=null where siteid="&siteid&" and userid="&userid
	if userid<>siteid then conn.Execute"update [user] set endTime=null where siteid="&siteid&" and userid="&userid
	response.write "你已经解除当前vip，可以重新开通"
end sub
sub getvip()
	response.write "	您的身份:"&kltool_get_uservip(userid,1)&vbcrlf
	if SessionTimeout>0 then 
		'response.write"	<a href=""?action=jcvip&siteid="&siteid&""" id=""tips"" tiptext=""确定解除？"">解除</a>"&vbcrlf
		response.write kltool_get_uservip(userid,2)&vbcrlf
	end if
end sub
%>