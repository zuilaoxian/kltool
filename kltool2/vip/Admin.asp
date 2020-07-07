<!--#include file="../config.asp"-->
<%
kltool_use(4)
kltool_admin(1)
action=Request.QueryString("action")
select case action
	case ""
		call index()
	case "yes"
		call yes()
	case "log"
		call log()
	case "install"
		call install()
	case "uninstall"
		call uninstall()
end select
sub index()
	kltool_sql("wap2_smallType_log")
	html=kltool_head("柯林工具箱-Vip自助开通管理后台",1)&_
	"<ul class=""breadcrumb"">"&vbcrlf&_
	"	<li><a href=""admin.asp?siteid="&siteid&"&action=log"">查看日志</a></li>"&vbcrlf&_
	"	<li><a href=""index.asp?siteid="&siteid&""">前台</a></li>"&vbcrlf&_
	"	<li><a href=""/bbs/smalltypelist.aspx?siteid="&siteid&"&systype=card"">设置vip</a></li>"&vbcrlf&_
	"</ul>"&vbcrlf
	str=kltool_GetRow("select id,jinbi,jinyan,rmb,xian from [wap2_smallType] where siteid="&siteid&" and systype='card'",0,pagesize)
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
		if jinbi="" or isnull(jinbi) then jinbi=0
		if jinyan="" or isnull(jinyan) then jinyan=0
		if rmb="" or isnull(rmb) then rmb=0
		if xian="" or isnull(xian) then xian=0 else xian=clng(xian)
			html=html&"<li class=""list-group-item"">"&vbcrlf&_
			" <div role=""form"" class=""bs-example bs-example-form"">"&vbcrlf&_
			"  <div class=""form-group"">"&vbcrlf&_
			"	<label for=""name"">"&id&"."&kltool_get_vip(id,1)&"</label>"&vbcrlf&_
			"  </div>"&vbcrlf&_
			"  <div class=""form-group input-group"">"&vbcrlf&_
			"    <span class=""input-group-addon"">"&sitemoneyname&"</span>"&vbcrlf&_
			"    <input type=""text"" name=""r_jinbi"&id&""" id=""r_jinbi"&id&""" value="""&jinbi&""" class=""form-control"">"&vbcrlf&_
			"  </div>"&vbcrlf&_
			"  <div class=""form-group input-group"">"&vbcrlf&_
			"    <span class=""input-group-addon"">经验</span>"&vbcrlf&_
			"  <input type=""text"" name=""r_jinyan"&id&""" id=""r_jinyan"&id&""" value="""&jinyan&""" class=""form-control"">"&vbcrlf&_
			"  </div>"&vbcrlf&_
			"  <div class=""form-group input-group"">"&vbcrlf&_
			"    <span class=""input-group-addon"">RMB</span>"&vbcrlf&_
			"    <input type=""text"" name=""r_rmb"&id&""" id=""r_rmb"&id&""" value="""&rmb&""" class=""form-control"">"&vbcrlf&_
			"  </div>"&vbcrlf&_
			"  <div class=""form-group"">"&vbcrlf&_
			"    <label class=""checkbox-inline"">"&vbcrlf&_
			"      <input type=""radio"" name=""r_xian"&id&""" id=""r_xian"&id&""" value=""1"""
		if xian=1 then html=html&" checked"
			html=html&"> 开启"&vbcrlf&_
			"    </label>"&vbcrlf&_
			"    <label class=""checkbox-inline"">"&vbcrlf&_
			"      <input type=""radio"" name=""r_xian"&id&""" id=""r_xian"&id&""" value=""0"""
		if xian=0 then html=html&" checked"
			html=html&"> 关闭"&vbcrlf&_
			"    </label>"&vbcrlf&_
			"  </div>"&vbcrlf&_
			"	<button name=""kltool"" vipid="""&id&""" type=""button"" class=""btn btn-default btn-block"" id=""Vip_Set"" data-loading-text=""Loading..."">提交</button>"&vbcrlf&_
			" </div>"&vbcrlf&_
			"</li>"&vbcrlf
		Next
		html=html&kltool_page(2,count,pagecount,gopage)
	else
		html=html&"<div class=""alert alert-danger"">暂时没有记录</div>"
	end if
	Response.write kltool_code(html&kltool_end(1))
end sub

sub yes()
	r_id=Request.Form("r_id")
	r_jinbi=Request.Form("r_jinbi")
	r_jinyan=Request.Form("r_jinyan")
	r_rmb=Request.Form("r_rmb")
	r_xian=Request.Form("r_xian")
	Response.write "修改成功<br/>"&r_id&":"&kltool_get_vip(r_id,1)
	conn.Execute("update [wap2_smallType] set jinbi="&r_jinbi&",jinyan="&r_jinyan&",rmb="&r_rmb&",xian="&r_xian&" where id="&r_id&" and siteid="&siteid)
end sub

sub log()
	kltool_sql("wap2_smallType_log")
	r_search=Request.QueryString("r_search")
	Response.Write kltool_code(kltool_head("柯林工具箱-vip开通记录",1))&_
	"<ul class=""breadcrumb"">"&vbcrlf&_
	"	<li><a href=""admin.asp?siteid="&siteid&""">管理后台</a></li>"&vbcrlf&_
	"	<li><a href=""index.asp?siteid="&siteid&""">前台</a></li>"&vbcrlf&_
	"	<li><a href=""/bbs/smalltypelist.aspx?siteid="&siteid&"&systype=card"">设置vip</a></li>"&vbcrlf&_
	"</ul>"&vbcrlf&_
	"<li class=""list-group-item"">"&vbcrlf&_
	"	<div class=""form-group"">"&vbcrlf&_
	"		<label for=""ksearch"">搜索:输入ID,留空为全部</label><br>"&vbcrlf&_
	"	</div>"&vbcrlf&_
	"	<form method=""get"" action=""?"" class=""form-inline"" role=""form"">"&vbcrlf&_
	"		<input name=""action"" type=""hidden"" value=""log"">"&vbcrlf&_
	"		<input name=""siteid"" type=""hidden"" value="""&siteid&""">"&vbcrlf&_
	"		<div class=""row"">"&vbcrlf&_
	"			<div class=""col-lg-6"">"&vbcrlf&_
	"				<div class=""input-group col-xs-8"">"&vbcrlf&_
	"					<input name=""r_search"" type=""text"" value="""" placeholder=""查询仅限于本站"" class=""form-control"">"&vbcrlf&_
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
	
	sql="select id,userid,lx,vip,yue,jinbi,jinyan,rmb,time from [wap2_smallType_log]"
	if r_search<>"" then sql=sql&" where userid="&r_search
	sql=sql&" order by time desc"
	str=kltool_GetRow(sql,0,10)
	If str(0) Then
		gopage="?action=log&"
		if r_search<>"" then gopage="?action=log&r_search="&r_search&"&"
		Count=str(0)
		pagecount=str(1)
		if page>pagecount then page=pagecount
		html=html&kltool_page(1,count,pagecount,gopage)
		For i=0 To ubound(str(2),2)
		id=str(2)(0,i)
		r_userid=str(2)(1,i)
		lx=str(2)(2,i)
		vip=str(2)(3,i)
		yue=str(2)(4,i)
		jinbi=str(2)(5,i)
		jinyan=str(2)(6,i)
		rmb=str(2)(7,i)
		r_time=str(2)(8,i)
		if vip="" or isnull(vip) then vip=0 else vip=clng(vip)
		if yue="" or isnull(yue) then yue=0 else yue=clng(yue)
		if jinbi="" or isnull(jinbi) then jinbi=0 else jinbi=clng(jinbi)
		if jinyan="" or isnull(jinyan) then jinyan=0 else jinyan=clng(jinyan)
		if rmb="" or isnull(rmb) then rmb=0 else rmb=clng(rmb)
		if xian="" or isnull(xian) then xian=0 else xian=clng(xian)
		lx=clng(lx)
		if lx=1 then lxtip="开通"
		if lx=2 then lxtip="续期"
		if lx=3 then
			lxtip="解除"
		else
			html2=""
			if jinbi>0 then html2=html2&sitemoneyname&":"&jinbi&" "
			if jinyan>0 then html2=html2&"经验:"&jinyan&" "
			if rmb>0 then html2=html2&"rmb:"&rmb
		end if
		if html2<>"" then html2=" <br/>花费:"&html2
		if yue>0 then yuetip=yue&"个月"
		if vip>0 then viptip="("&vip&")"&kltool_get_vip(vip,1)

		html=html&"<li class=""list-group-item"">"&vbcrlf&_
			" "&page*PageSize+i-PageSize+1&"."&kltool_get_usernickname(r_userid,2)&"("&r_userid&")"&vbcrlf&_
			" <br/>"&lxtip&"了"&yuetip&"Vip:"&viptip&vbcrlf&html2&_
			" <br/><span style=""color: #a0a0a0;font-size:12px;"">("&r_time&")</span>"&vbcrlf&_
			"</li>"&vbcrlf
		Next
		html=html&kltool_page(2,count,pagecount,gopage)
	else
		html=html&"<div class=""alert alert-danger"">暂时没有记录</div>"
	end if
	Response.write kltool_code(html&kltool_end(1))
end sub
sub dellog()
	ids=request("ids")
	response.write"成功删除日志"
	conn.Execute("DELETE FROM [wap2_smallType_log] where id in("&ids&")")
end sub
sub install()
	Response.Write"Vip自助开通安装成功"
	conn.Execute("ALTER TABLE [wap2_smallType] ADD [jinbi] bigint")
	conn.Execute("ALTER TABLE [wap2_smallType] ADD [jinyan] bigint")
	conn.Execute("ALTER TABLE [wap2_smallType] ADD [rmb] money")
	conn.Execute("ALTER TABLE [wap2_smallType] ADD [xian] bigint")
	conn.Execute("CREATE TABLE [dbo].[wap2_smallType_log] (ID int IDENTITY (1,1) not null PRIMARY key)")
	conn.Execute("ALTER TABLE [wap2_smallType_log] ADD [userid] bigint")
	conn.Execute("ALTER TABLE [wap2_smallType_log] ADD [lx] bigint")
	conn.Execute("ALTER TABLE [wap2_smallType_log] ADD [vip] bigint")
	conn.Execute("ALTER TABLE [wap2_smallType_log] ADD [yue] bigint")
	conn.Execute("ALTER TABLE [wap2_smallType_log] ADD [jinbi] bigint")
	conn.Execute("ALTER TABLE [wap2_smallType_log] ADD [jinyan] bigint")
	conn.Execute("ALTER TABLE [wap2_smallType_log] ADD [rmb] money")
	conn.Execute("ALTER TABLE [wap2_smallType_log] ADD [time] datetime")
end sub
sub uninstall()
	Response.Write"Vip自助开通数据删除成功"
	conn.Execute("ALTER TABLE [wap2_smallType] drop column [jinbi]")
	conn.Execute("ALTER TABLE [wap2_smallType] drop column [jinyan]")
	conn.Execute("ALTER TABLE [wap2_smallType] drop column [rmb]")
	conn.Execute("ALTER TABLE [wap2_smallType] drop column [xian]")
	conn.Execute("DROP TABLE [wap2_smallType_log]")
end sub
%>