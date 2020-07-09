<!--#include file="../config.asp"-->
<%
kltool_use(3)
kltool_sql("cdk")
action=Request.QueryString("action")
select case action
	case ""
		call index()
	case "cdkdh"
		call cdkdh()
	case "cdk"
		call cdk()
	case "cdkzs"
		call cdkzs()
	case "cdkzsyes"
		call cdkzsyes()
end select
sub index()
	html=kltool_head("CDK兑换系统",1)&_
	"<!-- 模态框（Modal） -->"&vbcrlf&_
	"<div class=""modal fade"" id=""myModal"" tabindex=""-1"" role=""dialog"" aria-labelledby=""myModalLabel"" aria-hidden=""true"">"&vbcrlf&_
	"	<div class=""modal-dialog"">"&vbcrlf&_
	"		<div class=""modal-content"">"&vbcrlf&_
	"			<div class=""modal-header"">"&vbcrlf&_
	"				<button type=""button"" class=""close"" data-dismiss=""modal"" aria-hidden=""true"">&times;</button>"&vbcrlf&_
	"				<h4 class=""modal-title"" id=""myModalLabel"">模态框（Modal）标题</h4>"&vbcrlf&_
	"			</div>"&vbcrlf&_
	"			<div class=""modal-body"">在这里添加一些文本</div>"&vbcrlf&_
	"			<div class=""modal-footer"">"&vbcrlf&_
	"				<button type=""button"" class=""btn btn-default"" data-dismiss=""modal"">关闭</button>"&vbcrlf&_
	"				<button type=""button"" class=""btn btn-primary"" style=""display:none;"">提交更改</button>"&vbcrlf&_
	"			</div>"&vbcrlf&_
	"		</div><!-- /.modal-content -->"&vbcrlf&_
	"	</div><!-- /.modal -->"&vbcrlf&_
	"</div>"&vbcrlf&_
	
	"<ul class=""breadcrumb"">"&vbcrlf&_
	"	<li>cdk管理</li>"&vbcrlf&_
	"	<li><a href='?'>我的CDK</a></li>"&vbcrlf&_
	"	<li><a href='?siteid="&siteid&"&action=shoplog'>CDK商城</a></li>"&vbcrlf&_
	"	<li><a href='?siteid="&siteid&"&action=cdkadd'>生产cdk</a></li>"&vbcrlf&_
	"	<li><a href='index.asp?siteid="&siteid&"'>前台</a></li>"&vbcrlf&_
	"</ul>"&vbcrlf&_

	"<li class=""list-group-item"">"&vbcrlf&_
	"	<div class=""form-inline"" role=""form"">"&vbcrlf&_
	"	<div>"&vbcrlf&_
	"	<label for=""c_cdk"" id=""c_cdkjy"" class=""control-label"">输入cdk</label>"&vbcrlf&_
	"	</div>"&vbcrlf&_
	"		<div class=""row"">"&vbcrlf&_
	"			<div class=""col-lg-6"">"&vbcrlf&_
	"				<div class=""input-group col-xs-8"">"&vbcrlf&_
	"					<input name=""c_cdkjy"" id=""c_cdk"" type=""text"" value="""" placeholder=""输入cdk"" class=""form-control"">"&vbcrlf&_
	"					<span class=""input-group-btn"">"&vbcrlf&_
	"						<button class=""btn btn-default"" type=""button"" id=""c_cdkdh"">"&vbcrlf&_
	"						兑换!"&vbcrlf&_
	"						</button>"&vbcrlf&_
	"					</span>"&vbcrlf&_
	"				</div>"&vbcrlf&_
	"			</div>"&vbcrlf&_
	"		</div>"&vbcrlf&_
	"	</div>"&vbcrlf&_
	"</li>"&vbcrlf
	
	sql="select id,cdk,lx,sy,time,zs,chushou,jiage from [cdk] where userid="&userid&" Order by id desc"
	gopage="?"
	str=kltool_GetRow(sql,0,pagesize)
	If str(0) Then
		count=str(0)
		pagecount=str(1)
		if page>pagecount then page=pagecount
		html=html&kltool_page(1,count,pagecount,gopage)
		For i=0 To ubound(str(2),2)
			c_id=str(2)(0,i)
			c_cdk=str(2)(1,i)
			c_lx=str(2)(2,i)
			c_sy=str(2)(3,i)
			c_time=str(2)(4,i)
			c_zs=str(2)(5,i)
			if c_zs="1" and c_sy="1" then c_zs_c="<a c_cdk="""&c_cdk&""" id=""cdk_give""  data-toggle=""modal"" data-target=""#myModal"">赠送</a> " else c_zs_c="赠送"
			if c_sy="1" then c_sy_c="<a href=""?action=cdkdh&c_cdk="&c_cdk&""" class=""nouse"" id=""tips"" tiptext=""确定？"">使用</a>" else c_sy_c="使用"
			html=html&_
			"<li class=""list-group-item"">"&vbcrlf&_
			"<h4>"&kltool_get_cdklx(c_lx)&" cdk:"&c_cdk&"</h4>"&vbcrlf&_
			"cdk内容:"&kltool_get_cdkinfo(c_id)&"<br/>"&vbcrlf&_
			c_sy_c&" "&_
			c_zs_c&_
			"</li>"&vbcrlf
		Next
		html=html&"<button name=""kltool"" id=""Cdk_Fast_Use"" class=""btn btn-default"" data-loading-text=""Loading..."">本页cdk一键使用</button>"&vbcrlf&_
			"</li>"&vbcrlf&_
		kltool_page(2,count,pagecount,gopage)
	else
		html=html&"<div class=""alert alert-danger"">暂时没有记录</div>"
	end if
	Response.write kltool_code(html&kltool_end(1))
end sub
sub cdkdh()
	c_cdk=Request.QueryString("c_cdk")
		Response.Write "CDK:["&c_cdk&"]<br/>"
	set rs=Server.CreateObject("ADODB.Recordset")
	rs.open"select * from [cdk] where cdk='"&c_cdk&"' and chushou=2",conn,1,2
	if rs.eof then
		Response.Write"不存在，请核对"
		Response.End()
	end if
	c_lx=rs("lx")
	c_sy=rs("sy")
	c_jinbi=rs("jinbi")
	c_jingyan=rs("jingyan")
	c_rmb=rs("rmb")
	c_sff=rs("sff")
	c_sf=rs("sf")
	c_lg=rs("lg")
	c_xg=rs("xg")
	c_uid=rs("userid")
	c_chushou=rs("chushou")
	rs.close
	set rs=nothing
	
	if c_uid<>"" then
		if clng(c_uid)<>userid then
			Response.Write"不属于你，不可以兑换"
			Response.End()
		end if
	end if
	if c_sy="2" then
		Response.Write"已被使用"
		Response.End()
	end if
	 
		response.write "使用成功,类型:"&kltool_get_cdklx(c_lx)&"<br/>"
	
	if c_lx="1" then
		conn.Execute("update [user] set money=money+"&c_jinbi&" where userid="&userid)
		response.write "你的"&sitemoneyname&"增加了"&c_jinbi
	end if
	
	if c_lx="2" then
		conn.Execute("update [user] set expR=expR+"&c_jingyan&" where userid="&userid)
		response.write "你的经验增加了"&c_jingyan
	end if
	
	if c_lx="3" then
		conn.Execute("update [user] set money=money+"&c_jinbi&",expR=expR+"&c_jingyan&" where userid="&userid)
		response.write "你的"&sitemoneyname&"增加了"&c_jinbi&"<br/>经验增加了"&c_jingyan
	end if
	
	if c_lx="4" then
		conn.Execute("update [user] set rmb=rmb+"&c_rmb&" where userid="&userid)
		response.write "你的rmb增加了"&c_rmb
	end if
	
	if c_lx="5" then
		if clng(c_sf)=sessiontimeout then
			if userid<>siteid then
				ti1=DateAdd("m",""&c_sff&"",""&endtime&"")
				conn.Execute("update [user] set endTime='"&ti1&"' where userid="&userid&"")
				response.write "你的VIP时长已增加"&c_sff&"个月<br/>截止到"&ti1
			else
				Response.Write"已有此vip，不予兑换"
				Response.End()
			end if
		else
			conn.Execute("update [user] set SessionTimeout="&c_sf&" where userid="&userid)
			if userid<>siteid then
				ti=DateAdd("m",""&c_sff&"",now())
				conn.Execute("update [user] set endTime='"&ti&"' where userid="&userid&"")
				response.write "兑换了"&c_sff&"个月VIP("&kltool_get_vip(c_sf,1)&")<br/>截止到"&ti&"</div>"
			else
				response.write "兑换了VIP("&kltool_get_vip(c_sf,1)&")"
			end if
		end if
	end if
	if c_lx="6" then
		conn.Execute("update [user] set LoginTimes=LoginTimes+"&c_lg&" where userid="&userid)
		response.write "你的在线积时增加了："&c_lg&"秒"
	end if
	
	if c_lx="7" then
		if instr("|"&moneyname&"|","|"&c_xg&"|")>=1 then
			Response.Write"你已经拥有此勋章"
			Response.End()
		end if
		c_xg_xg=moneyname&"|"&c_xg
		if Instr(c_xg_xg,"||")>0 then c_xg_xg=replace(c_xg_xg,"||","|")
		conn.Execute("update [user] set moneyname='"&c_xg_xg&"' where userid="&userid)
		response.write "你获得了勋章"&kltool_get_xunzhang(c_xg)
	end if
	
	conn.Execute("update [cdk] set sy=2,userid="&userid&",usetime='"&now()&"' Where cdk='"&c_cdk&"'")
	if c_lx="1" or c_lx="2" or c_lx="3" then
		conn.execute"insert into [wap_bankLog](siteid,userid,actionName,money,leftMoney,opera_userid,opera_nickname,remark,ip,addtime)values("&siteid&","&userid&",'CDK兑换',"&c_jinbi&","&money&","&userid&",'"&nickname&"','CDK使用:"&c_cdk&"','"&Request.ServerVariables("REMOTE_ADDR")&"','"&now&"')"
	End if
end sub
sub cdk()
	c_cdk=Request.QueryString("c_cdk")
		Response.Write "CDK:["&c_cdk&"]<br/>"
	set rs=Server.CreateObject("ADODB.Recordset")
	rs.open"select * from [cdk] where cdk='"&c_cdk&"' and chushou=2",conn,1,2
	if rs.eof then
		Response.Write"不存在，请核对"
		Response.End()
	end if
	c_id=rs("id")
	c_lx=rs("lx")
	c_userid=rs("userid")
	c_sy=rs("sy")
	rs.close
	set rs=nothing
	if c_userid<>"" then Response.Write "所有人："&c_userid
	if c_sy="1" then Response.Write " 未使用 " else Response.Write" 已使用 "
	Response.Write "类型："&kltool_get_cdklx(c_lx)&"<br>"&kltool_get_cdkinfo(c_id)
end sub

sub cdkzs()
	c_cdk=Request.QueryString("c_cdk")
	set rs=server.CreateObject("adodb.recordset")
	rs.open "select * from [cdk] where cdk='"&c_cdk&"' and chushou=2 and sy=1 and userid="&userid,conn,1,1
	if rs.eof then
		Response.Write"不存在的记录"
		Response.End()
	end if
	c_id=rs("id")
	rs.close
	set rs=nothing
	Response.Write ""&_
	"<li class=""list-group-item"">"&vbcrlf&_
	"	<div class=""form-group"">"&vbcrlf&_
	"		<label for=""r_search"">cdk:"&c_cdk&"<br/>"&kltool_get_cdkinfo(c_id)&"</label><br>"&vbcrlf&_
	"	</div>"&vbcrlf&_
	"		<input name=""c_cdk"" id=""c_cdk"" type=""hidden"" value="""&c_cdk&""">"&vbcrlf&_
	"		<div class=""row"">"&vbcrlf&_
	"			<div class=""col-lg-6"">"&vbcrlf&_
	"				<div class=""input-group col-xs-8"">"&vbcrlf&_
	"					<input name=""c_userid"" id=""c_userid"" type=""text"" value="""" placeholder=""输入对方ID"" class=""form-control"">"&vbcrlf&_
	"				</div>"&vbcrlf&_
	"			</div>"&vbcrlf&_
	"		</div>"&vbcrlf&_
	
	"	<label for=""c_msg"" class=""col-sm-2 control-label"">是否通知他</label>"&vbcrlf&_
	"	<div>"&vbcrlf&_
	"    <label class=""radio-inline"">"&vbcrlf&_
	"        <input type=""radio"" name=""c_msg"" id=""c_msg""  value=""1"" checked> 通知"&vbcrlf&_
	"    </label>"&vbcrlf&_
	"    <label class=""radio-inline"">"&vbcrlf&_
	"        <input type=""radio"" name=""c_msg"" id=""c_msg""  value=""0""> 不通知"&vbcrlf&_
	"    </label>"&vbcrlf&_
	"	</div>"&vbcrlf&_
	
	"</li>"&vbcrlf
end sub
sub cdkzsyes()
	c_cdk=Request.Form("c_cdk")
	c_userid=Request.Form("c_userid")
	c_msg=Request.Form("c_msg")
	
	if c_userid="" or clng(c_userid)=userid then
		Response.Write"必须输入对方ID"
		Response.End()
	end if

	set rs=conn.execute("select userid from [user] where userid="&c_userid)
	If rs.eof Then
		Response.Write c_userid&"不存在，请核对"
		Response.End()
	end if
	rs.close
	set rs=nothing

	set rs=server.CreateObject("adodb.recordset")
	rs.open "select * from [cdk] where cdk='"&c_cdk&"' and chushou=2 and sy=1 and userid="&userid,conn,1,2
	if rs.eof then
		Response.Write"不存在的记录"
		Response.End()
	end if
	rs("userid")=c_userid
	rs.update
	rs.close
	set rs=nothing
	   Response.write "转增cdk："&c_cdk&"<br/>给"&kltool_get_usernickname(c_userid,1)&"("&c_userid&")"
	if c_msg="1" then
		 Response.write "<br/>并使用内信通知对方!"
		conn.execute("insert into [wap_message](siteid,userid,nickname,title,content,touserid,isnew,issystem,addtime,HangBiaoShi)values("&siteid&","&userid&",'"&nickname&"','来自CDK的转赠信息','您的朋友："&nickname&"赠送了一个CDK给您，请[url="&kltool_path&"cdk/index.asp?siteid=[siteid]]前往查看[/url]','"&c_userid&"',1,0,'"&now()&"',0)")
		conn.execute("insert into [wap_message](siteid,userid,nickname,title,content,touserid,isnew,issystem,addtime,HangBiaoShi)values("&siteid&","&c_userid&",'"&nickname&"','CDK的赠送信息','您赠送了一个CDK给您的好友{"&c_userid&"},"&c_cdk&"','"&userid&"',2,0,'"&now()&"',0)")
	end if
end sub
%>