<!--#include file="../config.asp"-->
<%
kltool_admin(1)
action=Request.QueryString("action")
select case action
	case ""
		call index()
	case "shoplog"
		call shoplog()
	case "shoplogdel"
		call shoplogdel()
	case "install"
		call install()
	case "uninstall"
		call uninstall()
	case "cdkzs"
		call cdkzs()
	case "cdksy"
		call cdksy()
	case "cdkdel"
		call cdkdel()
	case "cdksend"
		call cdksend()
	case "cdksendyes"
		call cdksendyes()
	case "shopset"
		call shopset()
	case "shopsetyes"
		call shopsetyes()
	case "cdkadd"
		call cdkadd()
	case "cdkaddyes"
		call cdkaddyes()
end select

sub index()
	kltool_use(3)
	kltool_sql("cdk")
	c_uid=Request.QueryString("c_uid")
	c_lx=Request.QueryString("c_lx")
	
	html=kltool_head("柯林工具箱-CDK管理",1)&_
	
	"<ul class=""breadcrumb"">"&vbcrlf&_
	"	<li>cdk管理</li>"&vbcrlf&_
	"	<li><a href='?siteid="&siteid&"&action=shopset'>商城设置</a></li>"&vbcrlf&_
	"	<li><a href='?siteid="&siteid&"&action=shoplog'>商城日志</a></li>"&vbcrlf&_
	"	<li><a href='?siteid="&siteid&"&action=cdkadd'>生产cdk</a></li>"&vbcrlf&_
	"	<li><a href='index.asp?siteid="&siteid&"'>前台</a></li>"&vbcrlf&_
	"</ul>"&vbcrlf&_
	"<ul class=""breadcrumb"">"&vbcrlf&_
	"	<li><a href='?siteid="&siteid&"'>全部CDK</a></li>"&vbcrlf&_
	"	<li><a href='?siteid="&siteid&"&c_lx=syn'>未使用</a></li>"&vbcrlf&_
	"	<li><a href='?siteid="&siteid&"&c_lx=sy'>已使用</a></li>"&vbcrlf&_
	"	<li><a href='?siteid="&siteid&"&c_lx=repeat'>重复cdk</a></li>"&vbcrlf&_
	"	<li><a href='?siteid="&siteid&"&c_lx=shou'>出售中</a></li>"&vbcrlf&_
	"</ul>"&vbcrlf&_
	"<ul class=""breadcrumb"">"&vbcrlf&_
	"	<li><a href='?siteid="&siteid&"&c_lx=1'>金</a></li>"&vbcrlf&_
	"	<li><a href='?siteid="&siteid&"&c_lx=2'>经</a></li>"&vbcrlf&_
	"	<li><a href='?siteid="&siteid&"&c_lx=3'>双</a></li>"&vbcrlf&_
	"	<li><a href='?siteid="&siteid&"&c_lx=4'>rmb</a></li>"&vbcrlf&_
	"	<li><a href='?siteid="&siteid&"&c_lx=5'>身</a></li>"&vbcrlf&_
	"	<li><a href='?siteid="&siteid&"&c_lx=6'>积</a></li>"&vbcrlf&_
	"	<li><a href='?siteid="&siteid&"&c_lx=7'>勋</a></li>"&vbcrlf&_
	"</ul>"&vbcrlf&_

	"<li class=""list-group-item"">"&vbcrlf&_
	"	<form method=""get"" action=""?"" class=""form-inline"" role=""form"">"&vbcrlf&_
	"		<input name=""siteid"" type=""hidden"" value="""&siteid&""">"&vbcrlf&_
	"		<input name=""c_lx"" type=""hidden"" value="""&c_lx&""">"&vbcrlf&_
	"	<div>"&vbcrlf&_
	"	<label for=""name"" class=""control-label"">如果需要在分类下搜索，先点击上面分类</label>"&vbcrlf&_
	"	</div>"&vbcrlf&_
	"		<div class=""row"">"&vbcrlf&_
	"			<div class=""col-lg-6"">"&vbcrlf&_
	"				<div class=""input-group col-xs-8"">"&vbcrlf&_
	"					<input name=""c_uid"" type=""text"" value="""" placeholder=""输入用户ID或cdk"" class=""form-control"">"&vbcrlf&_
	"					<span class=""input-group-btn"">"&vbcrlf&_
	"						<button class=""btn btn-default"" type=""submit"">"&vbcrlf&_
	"						搜索!"&vbcrlf&_
	"						</button>"&vbcrlf&_
	"					</span>"&vbcrlf&_
	"				</div>"&vbcrlf&_
	"			</div>"&vbcrlf&_
	"		</div>"&vbcrlf&_
	"	</form>"&vbcrlf&_
	"</li>"&vbcrlf
	
	sql="select id,cdk,lx,sy,time,userid,zs,chushou,jiage from [cdk]"
	gopage="?"
	if c_uid<>"" or c_lx<>"" then sql=sql&" where "
	if c_uid<>"" then
		if Isnumeric(c_uid) then sql=sql&"userid="&c_uid else sql=sql&"cdk='"&c_uid&"'"
		gopage="c_uid="&c_uid&"&"
	end if
	if c_uid<>"" and c_lx<>"" then sql=sql&" and "
	if c_lx<>"" then
		if c_lx="sy" then
			sql=sql&"sy=2"
		elseif c_lx="syn" then
			sql=sql&"sy=1"
		elseif c_lx="shou" then
			sql=sql&"chushou=1"
		else
			sql=sql&"lx="&c_lx
		end if
	end if
	sql=sql&" Order by id desc"
	if c_lx="repeat" then sql="select id,cdk,lx,sy,time,userid,zs,chushou,jiage from [cdk] where cdk in (select max(cdk) from [cdk] group by cdk having count(cdk) >1) order by cdk"
	str=kltool_GetRow(sql,0,pagesize)
	If str(0) Then
		count=str(0)
		pagecount=str(1)
		if page>pagecount then page=pagecount
		html=html&kltool_page(1,count,pagecount,gopage)

		For i=0 To ubound(str(2),2)
			c_id=str(2)(0,i)
			cdk=str(2)(1,i)
			c_lx=str(2)(2,i)
			c_sy=str(2)(3,i)
			c_time=str(2)(4,i)
			c_userid=str(2)(5,i)
			c_zs=str(2)(6,i)
			c_chushou=str(2)(7,i)
			c_jiage=str(2)(8,i)
			if c_zs="1" then c_zs_c="可赠" else c_zs_c="不可赠"
			if c_sy="1" then c_sy_c="未用" else c_sy_c="已用"
			html=html&_
			"<li class=""list-group-item"">"&vbcrlf&_
			"<h4><input type=""checkbox"" class=""kid"" id=""kid"" value="""&c_id&"""> "&c_id&" cdk:"&cdk&"</h4>"&vbcrlf&_
			"cdk内容:"&kltool_get_cdkinfo(c_id)&"<br/>"&vbcrlf
			
			if c_userid<>"" then html=html&"<a href=""?c_uid=1000"">"&c_userid&"</a> " else html=html&"<a c_id="""&c_id&""" id=""cdk_send""  data-toggle=""modal"" data-target=""#myModal"">发放</a> "
			html=html&_
			"<a href=""?action=cdksy&c_id="&c_id&""" id=""tips"" tiptext=""转换状态<br/>当前："&c_sy_c&""">"&c_sy_c&"</a> "&vbcrlf&_
			"<a href=""?action=cdkzs&c_id="&c_id&""" id=""tips"" tiptext=""转换状态<br/>当前："&c_zs_c&""">"&c_zs_c&"</a> "&vbcrlf&_
			"<a href=""?action=cdkdel&c_id="&c_id&""" id=""tips"" tiptext=""确定删除吗<br/>"&cdk&""">删除</a> "&vbcrlf
			if c_chushou="1" and c_userid="" then html=html&"出售中 价格"&c_jiage
			html=html&"</li>"&vbcrlf
			
		Next
		html=html&"<li class=""list-group-item"">"&vbcrlf&_
			"<a id=""chose"" class=""btn btn-default"">反选</a> <a id=""choseall"" class=""btn btn-default"">全选</a>"&vbcrlf&_
			"<button name=""kltool"" id=""Cdk_Del"" class=""btn btn-default"" data-loading-text=""Loading..."">选择完毕,删除</button>"&vbcrlf&_
			"</li>"&vbcrlf&_
		kltool_page(2,count,pagecount,gopage)
	else
		html=html&"<div class=""alert alert-danger"">暂时没有记录</div>"
	end if
	Response.write kltool_code(html&kltool_end(1))
end sub
sub cdksend()
	c_id=Request.QueryString("c_id")
	set rs=server.CreateObject("adodb.recordset")
	rs.open "select * from [cdk] where id="&c_id,conn,1,1
	if rs.eof then
		Response.Write"不存在的记录"
		Response.End()
	end if
	cdk=rs("cdk")
	rs.close
	set rs=nothing
	Response.Write ""&_
	"<li class=""list-group-item"">"&vbcrlf&_
	"	<div class=""form-group"">"&vbcrlf&_
	"		<label for=""r_search"">cdk:"&cdk&"<br/>"&kltool_get_cdkinfo(c_id)&"</label><br>"&vbcrlf&_
	"	</div>"&vbcrlf&_
	"		<input name=""c_id"" id=""c_id"" type=""hidden"" value="""&c_id&""">"&vbcrlf&_
	"		<div class=""row"">"&vbcrlf&_
	"			<div class=""col-lg-6"">"&vbcrlf&_
	"				<div class=""input-group col-xs-8"">"&vbcrlf&_
	"					<input name=""c_userid"" id=""c_userid"" type=""text"" value="""" placeholder=""输入用户ID"" class=""form-control"">"&vbcrlf&_
	"				</div>"&vbcrlf&_
	"			</div>"&vbcrlf&_
	"		</div>"&vbcrlf&_
	
	"	<label for=""c_msg"" class=""col-sm-2 control-label"">是否通知</label>"&vbcrlf&_
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
sub cdksendyes()
	c_id=Request.Form("c_id")
	c_userid=Request.Form("c_userid")
	c_msg=Request.Form("c_msg")
	conn.Execute("update [cdk] set userid="&c_userid&" where id in("&c_id&")")
	response.write "成功发放cdk给ID:"&c_userid
	if c_msg="1" then conn.execute("insert into [wap_message](siteid,userid,nickname,title,content,touserid,isnew,issystem,addtime,HangBiaoShi)values("&siteid&","&siteid&",'系统','来自CDK的发放信息','系统大神发放了CDK给您，请[url="&kltool_path&"cdk/index.asp?siteid=[siteid]]前往查看[/url]',"&c_userid&",1,1,'"&now()&"',0)")
end sub
sub cdkzs()
	c_id=Request.QueryString("c_id")
	set rs=server.CreateObject("adodb.recordset")
	rs.open "select * from [cdk] where id="&c_id,conn,1,2
	if rs.eof then
		Response.Write"不存在的记录"
		Response.End()
	end if
	if rs("zs")="1" then rs("zs")="2" else rs("zs")="1"
	rs.update
	rs.close
	set rs=nothing
	response.write "成功转换赠送状态"
end sub
sub cdksy()
	c_id=Request.QueryString("c_id")
	set rs=server.CreateObject("adodb.recordset")
	rs.open "select * from [cdk] where id="&c_id,conn,1,2
	if rs.eof then
		Response.Write"不存在的记录"
		Response.End()
	end if
	if rs("sy")="1" then rs("sy")="2" else rs("sy")="1"
	rs.update
	rs.close
	set rs=nothing
	response.write "成功转换使用状态"
end sub
sub cdkdel()
	c_id=Request.QueryString("c_id")
	conn.Execute("delete from [cdk] where id in("&c_id&")")
	Response.write "删除cdk成功"
end sub
sub cdkadd()
	kltool_use(3)
	kltool_sql("cdk")
	html=kltool_head("柯林工具箱-生产cdk",1)&_
	"<div role=""form"">"&vbcrlf&_
	"<ul class=""breadcrumb"">"&vbcrlf&_
	"	<li><a href='?siteid="&siteid&"'>cdk管理</a></li>"&vbcrlf&_
	"	<li><a href='?siteid="&siteid&"&action=shopset'>商城设置</a></li>"&vbcrlf&_
	"	<li><a href='?siteid="&siteid&"&action=shoplog'>商城日志</a></li>"&vbcrlf&_
	"	<li>生产cdk</li>"&vbcrlf&_
	"	<li><a href='index.asp?siteid="&siteid&"'>前台</a></li>"&vbcrlf&_
	"</ul>"&vbcrlf&_
	"	<div class=""form-group"">"&vbcrlf&_
	"		<label for=""c_num"">输入数量</label>"&vbcrlf&_
	"			<input type=""text"" class=""form-control"" name=""c_num"" id=""c_num"" placeholder="""">"&vbcrlf&_
	"	</div>"&vbcrlf&_
	
	"	<div class=""form-group"">"&vbcrlf&_
	"		<label for=""c_lx"">选择cdk类型</label><br/>"&vbcrlf
	for i=1 to 7
		html=html&"		<label class=""checkbox-inline""><input type=""radio"" name=""c_lx"" id=""c_lx"" value="""&i&""">"&i&" "&kltool_get_cdklx(i)&"</label>"&vbcrlf
	next
	html=html&_
	"	</div>"&vbcrlf&_
	
	"	<div class=""form-group"">"&vbcrlf&_
	"		<label for=""c_money1"" >奖励1(单项奖励输入)</label>"&vbcrlf&_
	"			<input type=""text"" class=""form-control"" name=""c_money1"" id=""c_money1"" placeholder="""">"&vbcrlf&_
	"	</div>"&vbcrlf&_
	"	<div class=""form-group"" id=""c_money2_div"" style=""display:none;"">"&vbcrlf&_
	"		<label for=""c_money2"">奖励2(经验或Vip时长)</label>"&vbcrlf&_
	"			<input type=""text"" class=""form-control"" name=""c_money2"" id=""c_money2"" placeholder="""">"&vbcrlf&_
	"	</div>"&vbcrlf&_

	"	<div class=""form-group"">"&vbcrlf&_
	"		<label for=""c_uid"">直接发放</label>"&vbcrlf&_
	"			<input type=""text"" class=""form-control"" name=""c_uid"" id=""c_uid"" placeholder=""输入用户ID"">"&vbcrlf&_
	"	</div>"&vbcrlf&_

	"	<div class=""form-group"">"&vbcrlf&_
	"		<label for=""c_msg"">是否通知</label>"&vbcrlf&_
	"		<label class=""radio-inline"">"&vbcrlf&_
	"			<input type=""radio"" name=""c_msg"" id=""c_msg"" value=""1""> 内信通知"&vbcrlf&_
	"		</label>"&vbcrlf&_
	"		<label class=""radio-inline"">"&vbcrlf&_
	"			<input type=""radio"" name=""c_msg"" id=""c_msg""  value=""0"" checked> 不通知他"&vbcrlf&_
	"		</label>"&vbcrlf&_
	"	</div>"&vbcrlf&_
	"	<div class=""form-group"">"&vbcrlf&_
	"		<label for=""c_zs"">可否转增</label>"&vbcrlf&_
	"		<label class=""radio-inline"">"&vbcrlf&_
	"			<input type=""radio"" name=""c_zs"" id=""c_zs"" value=""1"" checked> 可转增"&vbcrlf&_
	"		</label>"&vbcrlf&_
	"		<label class=""radio-inline"">"&vbcrlf&_
	"			<input type=""radio"" name=""c_zs"" id=""c_zs""  value=""2""> 不可转增"&vbcrlf&_
	"		</label>"&vbcrlf&_
	"	</div>"&vbcrlf&_
	"	<div class=""form-group"">"&vbcrlf&_
	"		<label for=""c_chushou"">是否出售</label>"&vbcrlf&_
	"		<label class=""radio-inline"">"&vbcrlf&_
	"			<input type=""radio"" name=""c_chushou"" id=""c_chushou"" value=""1""> 出售"&vbcrlf&_
	"		</label>"&vbcrlf&_
	"		<label class=""radio-inline"">"&vbcrlf&_
	"			<input type=""radio"" name=""c_chushou"" id=""c_chushou""  value=""2"" checked> 不出售"&vbcrlf&_
	"		</label>"&vbcrlf&_
	"	</div>"&vbcrlf&_
	
	"	<div class=""form-group"" id=""c_chushou_div"" style=""display:none;"">"&vbcrlf&_
	"		<label for=""c_money3"">出售价格</label>"&vbcrlf&_
	"			<input type=""text"" class=""form-control"" name=""c_money3"" id=""c_money3"" placeholder="""&sitemoneyname&"类型"">"&vbcrlf&_
	"		<input type=""text"" class=""form-control"" name=""c_money4"" id=""c_money4"" placeholder=""rmb类型"">"&vbcrlf&_
	"	</div>"&vbcrlf&_
	
	"	<button name=""kltool"" type=""button"" class=""btn btn-default btn-block"" id=""Cdk_add"" data-loading-text=""Loading..."">提交</button>"&vbcrlf&_
	"</div>"&vbcrlf
	
	Response.write kltool_code(html&kltool_end(1))
end sub

sub cdkaddyes
	c_num=Request.Form("c_num")
	c_lx=Request.Form("c_lx")
	c_money1=Request.Form("c_money1")
	c_money2=Request.Form("c_money2")
	c_uid=Request.Form("c_uid")
	c_msg=Request.Form("c_msg")
	c_zs=Request.Form("c_zs")
	c_chushou=Request.Form("c_chushou")
	c_money3=Request.Form("c_money3")
	c_money4=Request.Form("c_money4")
	set rs=server.CreateObject("adodb.recordset")
	rs.open "select * from [cdk]",conn,1,2
	
	for i=1 to c_num
	rs.addnew
		rs("cdk")=Generate_Key
		rs("lx")=c_lx
		rs("time")=now()
		rs("zs")=c_zs
		rs("sy")=1
		if c_uid<>"" then rs("userid")=c_uid
		rs("chushou")=c_chushou
		if c_chushou=1 then
			if c_money3<>"" then rs("jiage")=c_money3 else rs("jiage")=0
			if c_money4<>"" then rs("jiage2")=c_money4 else rs("jiage2")=0
		end if
		if c_lx="1" or c_lx="3" then rs("jinbi")=c_money1
		if c_lx="3" then rs("jingyan")=c_money2
		if c_lx="2" then rs("jingyan")=c_money1
		if c_lx="4" then rs("rmb")=c_money1
		if c_lx="5" then
			rs("sf")=c_money1
			rs("sff")=c_money2
		end if
		if c_lx="6" then rs("lg")=c_money1
		if c_lx="7" then rs("xg")=c_money1
	rs.update
	next
	
	rs.close
	set rs=nothing
	Response.Write "生产"&c_num&"个cdk成功"
	if c_uid<>"" then
		Response.Write "<br/>已发号给ID："&kltool_get_usernickname(c_uid,1)&"("&c_uid&")"
		if c_msg=1 then conn.execute("insert into [wap_message](siteid,userid,nickname,title,content,touserid,isnew,issystem,addtime,HangBiaoShi)values("&siteid&","&siteid&",'系统','来自CDK的发放信息','系统大神发放了"&c_num&"个CDK给您，请[url="&kltool_path&"cdk/index.asp?siteid=[siteid]]前往查看[/url]',"&c_uid&",1,1,'"&nonw()&"',0)")
	end if
end sub
sub shopset()
	kltool_use(3)
	kltool_sql("cdk")
	html=kltool_head("柯林工具箱-商城设置",1)&_
	"<ul class=""breadcrumb"">"&vbcrlf&_
	"	<li><a href='?siteid="&siteid&"'>CDK管理</a></li>"&vbcrlf&_
	"	<li>商城设置</li>"&vbcrlf&_
	"	<li><a href='?siteid="&siteid&"&action=shoplog'>商城日志</a></li>"&vbcrlf&_
	"	<li><a href='?siteid="&siteid&"&action=cdkadd'>生产cdk</a></li>"&vbcrlf&_
	"	<li><a href='index.asp?siteid="&siteid&"'>前台</a></li>"&vbcrlf&_
	"</ul>"&vbcrlf
	
	sql="select * from [cdk_set]"
	str=kltool_GetRow(sql,0,pagesize)
	If str(0) Then
		For i=0 To ubound(str(2),2)
			id=str(2)(0,i)
			yh=str(2)(1,i)'优惠%
			lx=str(2)(2,i)'cdk类型
			sl=str(2)(3,i)'每日购买数量
			vsl=str(2)(4,i)'vip每日可购买数量
			html=html&"<li class=""list-group-item"">"&vbcrlf&_
			" <div role=""form"" class=""bs-example bs-example-form"">"&vbcrlf&_
			"  <div class=""form-group"">"&vbcrlf&_
			"	<label for=""name"">"&lx&"."&kltool_get_cdklx(lx)&"</label>"&vbcrlf&_
			"  </div>"&vbcrlf&_
			"  <div class=""form-group input-group"">"&vbcrlf&_
			"    <span class=""input-group-addon"">优惠(%)</span>"&vbcrlf&_
			"    <input type=""text"" name=""r_yh"&id&""" id=""r_yh"&id&""" value="""&yh&""" class=""form-control"">"&vbcrlf&_
			"  </div>"&vbcrlf&_
			"  <div class=""form-group input-group"">"&vbcrlf&_
			"    <span class=""input-group-addon"">每日数量</span>"&vbcrlf&_
			"  <input type=""text"" name=""r_sl"&id&""" id=""r_sl"&id&""" value="""&sl&""" class=""form-control"">"&vbcrlf&_
			"  </div>"&vbcrlf&_
			"  <div class=""form-group input-group"">"&vbcrlf&_
			"    <span class=""input-group-addon"">vip每日买数量</span>"&vbcrlf&_
			"    <input type=""text"" name=""r_vsl"&id&""" id=""r_vsl"&id&""" value="""&vsl&""" class=""form-control"">"&vbcrlf&_
			"  </div>"&vbcrlf&_
			"	<button name=""kltool"" shopsetid="""&id&""" type=""button"" class=""btn btn-default btn-block"" id=""Cdk_shop_Set"" data-loading-text=""Loading..."">提交</button>"&vbcrlf&_
			" </div>"&vbcrlf&_
			"</li>"&vbcrlf
		Next
	else
		html=html&"<div class=""alert alert-danger"">暂时没有记录</div>"
	end if
	Response.write kltool_code(html&kltool_end(1))
end sub
sub shopsetyes()
	r_id=Request.Form("r_id")
	r_yh=Request.Form("r_yh")
	r_sl=Request.Form("r_sl")
	r_vsl=Request.Form("r_vsl")
	if r_yh="" then r_yh=0
	conn.Execute("update [cdk_set] set yh="&r_yh&",sl="&r_sl&",vsl="&r_vsl&" where id="&r_id)
	Response.write "修改成功"
end sub
sub shoplog()
	kltool_use(3)
	kltool_sql("cdk")
	r_search=Request.QueryString("r_search")
	html=kltool_head("柯林工具箱-商城日志",1)&_
	"<ul class=""breadcrumb"">"&vbcrlf&_
	"	<li><a href='?siteid="&siteid&"'>CDK管理</a></li>"&vbcrlf&_
	"	<li><a href='?siteid="&siteid&"&action=shopset'>商城设置</a></li>"&vbcrlf&_
	"	<li>商城日志</li>"&vbcrlf&_
	"	<li><a href='?siteid="&siteid&"&action=cdkadd'>生产cdk</a></li>"&vbcrlf&_
	"	<li><a href='index.asp?siteid="&siteid&"'>前台</a></li>"&vbcrlf&_
	"</ul>"&vbcrlf&_
	"<li class=""list-group-item"">"&vbcrlf&_
	"	<div class=""form-group"">"&vbcrlf&_
	"		<label for=""ksearch"">搜索:输入ID,留空为全部</label><br>"&vbcrlf&_
	"	</div>"&vbcrlf&_
	"	<form method=""get"" action=""?"" class=""form-inline"" role=""form"">"&vbcrlf&_
	"		<input name=""action"" type=""hidden"" value=""shoplog"">"&vbcrlf&_
	"		<input name=""siteid"" type=""hidden"" value="""&siteid&""">"&vbcrlf&_
	"		<div class=""row"">"&vbcrlf&_
	"			<div class=""col-lg-6"">"&vbcrlf&_
	"				<div class=""input-group col-xs-8"">"&vbcrlf&_
	"					<input name=""r_search"" type=""text"" value="""" placeholder="""" class=""form-control"">"&vbcrlf&_
	"					<span class=""input-group-btn"">"&vbcrlf&_
	"						<button class=""btn btn-default"" type=""submit"">"&vbcrlf&_
	"						搜索!"&vbcrlf&_
	"						</button>"&vbcrlf&_
	"					</span>"&vbcrlf&_
	"				</div>"&vbcrlf&_
	"			</div>"&vbcrlf&_
	"		</div>"&vbcrlf&_
	"	</form>"&vbcrlf&_
	"</li>"&vbcrlf
	sql="select * from [cdk_log]"
	if r_search<>"" then sql=sql&" where userid="&r_search
	sql=sql&" order by ltime desc"
		gopage="?action=shoplog&"
		if r_search<>"" then gopage="?action=shoplog&r_search="&r_search&"&"
	str=kltool_GetRow(sql,0,10)
	If str(0) Then
		Count=str(0)
		pagecount=str(1)
		if page>pagecount then page=pagecount
		html=html&kltool_page(1,count,pagecount,gopage)
		For i=0 To ubound(str(2),2)
		id=str(2)(0,i)
		s_userid=str(2)(1,i)
		s_lx=str(2)(2,i)
		s_cdk=str(2)(3,i)
		s_jia1=str(2)(4,i)
		s_jia2=str(2)(5,i)
		s_time=str(2)(6,i)
			html=html&_
			"<li class=""list-group-item"">"&vbcrlf&_
			" "&page*PageSize+i-PageSize+1&"."&kltool_get_usernickname(s_userid,2)&"("&s_userid&")"&vbcrlf&_
			" <br/>购买了"&s_cdk&_
			" <br/><span style=""color: #a0a0a0;font-size:12px;"">("&s_time&")</span>"&vbcrlf&_
			"</li>"&vbcrlf
		Next
	else
		html=html&"<div class=""alert alert-danger"">暂时没有记录</div>"
	end if
	Response.write kltool_code(html&kltool_end(1))
end sub
sub shoplogdel()
	ids=request.Form("ids")
	conn.Execute("DELETE FROM [cdk_log] where id in("&ids&")")
	Response.write "删除商城日志成功"
end sub
sub install()
	conn.Execute("CREATE TABLE [dbo].[cdk] (ID int IDENTITY (1,1) not null PRIMARY key)")
	conn.Execute("ALTER TABLE [cdk] ADD [cdk] varchar")
	conn.Execute("ALTER TABLE [cdk] ALTER COLUMN [cdk] varchar(50)")
	conn.Execute("ALTER TABLE [cdk] ADD [jinbi] bigint")
	conn.Execute("ALTER TABLE [cdk] ADD [jingyan] bigint")
	conn.Execute("ALTER TABLE [cdk] ADD [rmb] money")
	conn.Execute("ALTER TABLE [cdk] ADD [sf] bigint")
	conn.Execute("ALTER TABLE [cdk] ADD [sff] bigint")
	conn.Execute("ALTER TABLE [cdk] ADD [lg] bigint")
	conn.Execute("ALTER TABLE [cdk] ADD [xg] ntext")
	conn.Execute("ALTER TABLE [cdk] ADD [lx] bigint")
	conn.Execute("ALTER TABLE [cdk] ADD [sy] bigint")
	conn.Execute("ALTER TABLE [cdk] ADD [time] datetime") 
	conn.Execute("ALTER TABLE [cdk] ADD [userid] bigint")
	conn.Execute("ALTER TABLE [cdk] ADD [zs] bigint")
	conn.Execute("ALTER TABLE [cdk] ADD [chushou] bigint")
	conn.Execute("ALTER TABLE [cdk] ADD [jiage] bigint")
	conn.Execute("ALTER TABLE [cdk] ADD [jiage2] money")
	conn.Execute("ALTER TABLE [cdk] ADD [usetime] datetime")

	conn.Execute("CREATE TABLE [dbo].[cdk_set] (ID int IDENTITY (1,1) not null PRIMARY key)")
	conn.Execute("ALTER TABLE [cdk_set] ADD [yh] bigint")
	conn.Execute("ALTER TABLE [cdk_set] ADD [lx] bigint")
	conn.Execute("ALTER TABLE [cdk_set] ADD [sl] bigint")
	conn.Execute("ALTER TABLE [cdk_set] ADD [vsl] bigint")

	conn.Execute("CREATE TABLE [dbo].[cdk_log] (ID int IDENTITY (1,1) not null PRIMARY key)")
	conn.Execute("ALTER TABLE [cdk_log] ADD [userid] bigint")
	conn.Execute("ALTER TABLE [cdk_log] ADD [lx] bigint")
	conn.Execute("ALTER TABLE [cdk_log] ADD [cdk] varchar(50)")
	conn.Execute("ALTER TABLE [cdk_log] ADD [jia] bigint")
	conn.Execute("ALTER TABLE [cdk_log] ADD [jia2] money")
	conn.Execute("ALTER TABLE [cdk_log] ADD [ltime] datetime")

	for i=1 to 7
		set rs=Server.CreateObject("ADODB.Recordset")
		rs.open"select * from [cdk_set] where lx="&i,conn,1,2
		if rs.bof then conn.Execute("INSERT INTO [cdk_set] (lx) VALUES ('"&i&"')")
		rs.close
		set rs=nothing
	next
	response.write "成功安装cdk数据库字段"
end sub
sub uninstall()
	conn.Execute("DROP TABLE [cdk]")
	conn.Execute("DROP TABLE [cdk_set]")
	conn.Execute("DROP TABLE [cdk_log]")
	response.write "成功删除cdk数据库字段"
end sub
%>