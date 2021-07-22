<!--#include file="config.asp"-->
<%
kltool_use(10)
kltool_admin(1)
	function getmanagername(str)
		if str=0 then getmanagername="全部"
		if str=1 then getmanagername="超管"
		if str=2 then getmanagername="副管"
		if str=3 then getmanagername="普通"
		if str=4 then getmanagername="总编辑"
		if str=5 then getmanagername="总版主"
		if str=6 then getmanagername="非本站"
	end function
action=Request.QueryString("action")
select case action
	case ""
		call index()
	case "LockId"
		call LockId()
	case "DataId"
		call DataId()
	case "VipId"
		call VipId()
	case "VipId2"
		call VipId2()
	case "LvlId"
		call LvlId()
	case "LvlId2"
		call LvlId2()
	case "LockId2"
		call LockId2()
	case "LockId2Lock"
		call LockId2Lock()
	case "LockId2UnLock"
		call LockId2UnLock()
end select
sub index()
	lx=Request.QueryString("lx")
	if lx="" then lx=0 else lx=clng(lx)
	r_search=Request.QueryString("r_search")
	html=kltool_head("柯林工具箱-会员管理",1)&_
	"<li class=""list-group-item"">"&vbcrlf&_
	"	<div class=""form-group"">"&vbcrlf&_
	"		<label for=""r_search"">模糊搜索:输入ID、用户名、昵称、关键词</label><br>"&vbcrlf&_
	"	</div>"&vbcrlf&_
	"	<form method=""get"" action=""?"" class=""form-inline"" role=""form"">"&vbcrlf&_
	"		<input name=""lx"" type=""hidden"" value=""7"">"&vbcrlf&_
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
	"</li>"&vbcrlf&_
	"<ul class=""breadcrumb"">"&vbcrlf
	for i=0 to 6
		if lx=i then html=html&"<li>"&getmanagername(i)&"</li>"&vbcrlf else html=html&"<li><a href='?siteid="&siteid&"&lx="&i&"'>"&getmanagername(i)&"</a></li>"&vbcrlf
	next
	html=html&"</ul>"
	sql= "select userid,siteid,LockUser,managerlvl from [user] where "
	if lx=0 then
		sql=sql&"siteid="&siteid
	elseif lx=1 then
		sql=sql&"siteid="&siteid&" and managerlvl=0"
	elseif lx=2 then
		sql=sql&"siteid="&siteid&" and managerlvl=1"
	elseif lx=3 then
		sql=sql&"siteid="&siteid&" and managerlvl=2"
	elseif lx=4 then
		sql=sql&"siteid="&siteid&" and managerlvl=3"
	elseif lx=5 then
		sql=sql&"siteid="&siteid&" and managerlvl=4"
	elseif lx=6 then
		sql=sql&"siteid<>"&siteid
	elseif lx=7 then
		sql=sql&"siteid="&siteid&" and (userid like '%"&r_search&"%' or username like '%"&r_search&"%' or nickname like '%"&r_search&"%')"
	end if
		str=kltool_GetRow(sql,0,pagesize)
		If str(0) Then
			count=str(0)
			pagecount=str(1)
			if page>pagecount then page=pagecount
			if lx=7 then gopage="?lx="&lx&"&r_search="&r_search&"&" else gopage="?lx="&lx&"&"
			html=html&kltool_page(1,count,pagecount,gopage)
			'"<ul class=""list-group"">"
			For i=0 To ubound(str(2),2)
				uid=str(2)(0,i)
				usiteid=str(2)(1,i)
				LockUser=str(2)(2,i)
				managerlvl=str(2)(3,i)
					if clng(LockUser)=0 then lu="锁定" else lu="解锁"
					if kltool_get_userlock(uid,0) then Lock="解黑" else Lock="加黑"
					html1=html&"<li class=""list-group-item"">"&vbcrlf&_
					page*PageSize+i-PageSize+1&"."&_
					"<a href=""/bbs/userinfo.aspx?siteid="&siteid&"&touserid="&uid&""" class=""Nick"" id="""&uid&""">"&kltool_get_usernickname(uid,1)&"</a>"&vbcrlf&_
					" (ID:<a href=""ziliao.asp?siteid="&siteid&"&uid="&uid&""">"&uid&"</a>)"&vbcrlf&_
					" <br/><a class=""LockId"" id="""&uid&""" tiptext=""ID"&uid&""">"&lu&"</a>"&vbcrlf&_
					" <a class=""DelId"" id="""&uid&""" tiptext=""删除ID"&uid&""">删除</a>"&vbcrlf&_
					" <a class=""DataId"" id="""&uid&""" data-toggle=""modal"" data-target=""#myModal"">详细</a>"&vbcrlf&_
					" <a class=""VipId"" id="""&uid&""" data-toggle=""modal"" data-target=""#myModal"">vip</a>"&vbcrlf&_
					" <a class=""LvlId"" id="""&uid&""" data-toggle=""modal"" data-target=""#myModal"">"&kltool_get_managername(managerlvl)&"</a>"&vbcrlf&_
					"</li>"&vbcrlf
					
					html=html&_
					"	<div class=""media list-group-item"">"&vbcrlf&_
					"	  <div class=""media-left media-middle"">"&vbcrlf&_
							kltool_get_userheadimg(uid,1)&vbcrlf&_
					"	  </div>"&vbcrlf&_
					"	  <div class=""media-body"">"&vbcrlf&_
					"		<h4 class=""media-heading"">"&vbcrlf&_
					"		 <a href=""/bbs/userinfo.aspx?siteid="&siteid&"&touserid="&uid&""" class=""Nick"" id="""&uid&""">"&kltool_get_usernickname(uid,1)&"</a>"&vbcrlf&_
					"		 (ID:<a href=""UserData.asp?siteid="&siteid&"&uid="&uid&""">"&uid&"</a>)"&vbcrlf&_
					"		 </h4>"&vbcrlf&_
					"		<h5>"&vbcrlf&_
					"		 <a class=""LockId"" id="""&uid&""" tiptext=""ID"&uid&""">"&lu&"</a>"&vbcrlf&_
					"		 <a class=""DelId"" id="""&uid&""" tiptext=""删除ID"&uid&""">删除</a>"&vbcrlf&_
					"		 <a class=""DataId"" id="""&uid&""" data-toggle=""modal"" data-target=""#myModal"">详细</a>"&vbcrlf&_
					"		 <a class=""VipId"" id="""&uid&""" data-toggle=""modal"" data-target=""#myModal"">vip</a>"&vbcrlf&_
					"		 <a class=""LvlId"" id="""&uid&""" data-toggle=""modal"" data-target=""#myModal"">"&kltool_get_managername(managerlvl)&"</a>"&vbcrlf&_
					"		</h5>"&vbcrlf&_
					"	  </div>"&vbcrlf&_
					"	</div>"&vbcrlf&_
					""&vbcrlf
					
			Next
			html=html&kltool_page(2,count,pagecount,gopage)
		else
			html=html&"<div class=""alert alert-danger"">暂时没有记录</div>"
		end if
		Response.write kltool_code(html&kltool_end(1))
end sub

sub LockId()
uid=Request.Form("uid")
	if clng(uid)=siteid then
		Response.write "{""a"":"""",""b"":""操作失败""}"
		Response.End()
	end if
	set rs=server.CreateObject("adodb.recordset")
	rs.open "select * from [user] where siteid="&siteid&" and userid="&uid,conn,1,2
	If not rs.eof Then
		if rs("LockUser")=1 then
			rs("LockUser")=0
			Response.write "{""a"":""锁定"",""b"":""解锁成功""}"
			'kltool_write_log("(会员管理)解锁ID： "&kltool_get_usernickname(uid,1)&"("&uid&")")
		else
			rs("LockUser")=1
			Response.write "{""a"":""解锁"",""b"":""锁定成功""}"
			'kltool_write_log("(会员管理)锁定ID： "&kltool_get_usernickname(uid,1)&"("&uid&")")
		end if
	end if
	rs.update
	rs.close
	set rs=nothing
end sub

sub DataId()
	uid=Request.Form("uid")
	str="<ul class=""list-group"">"&vbcrlf&_
	"<li class=""list-group-item"">"&kltool_get_userheadimg(uid,1)&"</li>"&vbcrlf&_
	"<li class=""list-group-item"">昵称:"&kltool_get_usernickname(uid,1)&"</li>"&vbcrlf&_
	"<li class=""list-group-item"">VIP:"&kltool_get_uservip(uid,1)&kltool_get_uservip(uid,2)&"</li>"&vbcrlf
	set rs=server.CreateObject("adodb.recordset")
	rs.open "select * from [user] where userid="&uid,conn,1,1
		If not rs.eof Then
			str=str&"<li class=""list-group-item"">ＩＤ:"&rs("userid")&"</li>"&vbcrlf&_
			"<li class=""list-group-item"">归属站:"&rs("siteid")&"</li>"&vbcrlf&_
			"<li class=""list-group-item"">性别:"&kltool_get_usersex(uid)&"</li>"&vbcrlf&_
			"<li class=""list-group-item"">用户名:"&rs("username")&"</li>"&vbcrlf&_
			"<li class=""list-group-item"">"&sitemoneyname&":"&rs("money")&"</li>"&vbcrlf&_
			"<li class=""list-group-item"">银行存款:"&rs("myBankMoney")&"</li>"&vbcrlf&_
			"<li class=""list-group-item"">经验:"&rs("expr")&"</li>"&vbcrlf&_
			"<li class=""list-group-item"">空间人气:"&rs("ZoneCount")&"</li>"&vbcrlf&_
			"<li class=""list-group-item"">发帖量:"&int(rs("bbsCount"))&"</li>"&vbcrlf&_
			"<li class=""list-group-item"">回帖量:"&rs("bbsReCount")&"</li>"&vbcrlf&_
			"<li class=""list-group-item"">注册时间:"&rs("regtime")&"</li>"&vbcrlf&_
			"<li class=""list-group-item"">离线时间:"&rs("LastLoginTime")&"</li>"&vbcrlf&_
			"<li class=""list-group-item"">网站积时:"&rs("LoginTimes")&"秒</li>"&vbcrlf&_
			"<li class=""list-group-item"">他的权限:"&kltool_get_managername(rs("managerlvl"))&"</li>"&vbcrlf
			LockUser=rs("LockUser")
			if lockUser=0 Then str=str&"<li class=""list-group-item"">状态:正常</li>"&vbcrlf
			if lockUser=1 Then str=str&"<li class=""list-group-item"">此ID已经被锁定,无法进入本站</li>"&vbcrlf
		else
			str="<li class=""list-group-item"">没有此会员记录！</li>"&vbcrlf
		end if
	rs.close
	set rs=nothing
		str=str&"<ul>"
	Response.Write str
end sub

sub VipId()
	uid=Request.Form("uid")
	Response.Write"<li class=""list-group-item"">"&_
	"他的身份："&kltool_get_uservip(uid,1)&kltool_get_uservip(uid,2)& vbcrlf &_
	"<br/>更改(非延期)，身份留空则取消VIP<br/>时间留空则为无限期，如填写，从现在算起</li>"&vbcrlf&_
	"<li class=""list-group-item"">"&vbcrlf&_
	kltool_get_viplist("Vip")&vbcrlf&_
	"</li>"&vbcrlf&_
	"<li class=""list-group-item"">"&vbcrlf&_
	"	<div class=""row"">"&vbcrlf&_
	"		<div class=""col-lg-6"">"&vbcrlf&_
	"			<div class=""input-group col-xs-6"">"&vbcrlf&_
	"				<input name=""VipTime"" id=""VipTime""type=""text"" value="""" placeholder=""时长"" class=""form-control"">"&vbcrlf&_
	"				<span class=""input-group-btn"">"&vbcrlf&_
	"					<button class=""btn btn-default"" type=""button"">"&vbcrlf&_
	"					月"&vbcrlf&_
	"					</button>"&vbcrlf&_
	"				</span>"&vbcrlf&_
	"			</div>"&vbcrlf&_
	"		</div>"&vbcrlf&_
	"	</div>"&vbcrlf&_
	"</li>"&vbcrlf
end sub

sub VipId2()
	uid=Request.Form("uid")
	Vip=Request.Form("Vip")
	VipTime=Request.Form("VipTime")
	if clng(uid)=siteid or VipTime="" then
		conn.Execute("update [user] set endTime=null where siteid="&siteid&" and userid="&uid)
	elseif VipTime<>"" and Isnumeric(VipTime) then
		ti=DateAdd("m",VipTime,date())
		conn.Execute("update [user] set endTime='"&ti&"' where siteid="&siteid&" and userid="&uid)
	end if

	if Vip="" then
		conn.Execute("update [user] set SessionTimeout=0 where siteid="&siteid&" and userid="&uid)
	else
		conn.Execute("update [user] set SessionTimeout="&Vip&" where siteid="&siteid&" and userid="&uid)
	end if
	Response.Write kltool_get_usernickname(uid,1)
end sub


sub LvlId()
	uid=Request.Form("uid")
	if clng(uid)=siteid then
		Response.Write("不能操作ID1000")
		Response.End()
	end if
	Response.Write"修改"&kltool_get_usernickname(uid,1)&"("&uid&")的权限<br>"&vbcrlf&_
    "<label class=""checkbox-inline"">"&vbcrlf&_
    "    <input type=""radio"" name=""Lvl"" id=""Lvl"" value=""04"" checked> 总版主"&vbcrlf&_
    "</label>"&vbcrlf&_
    "<label class=""checkbox-inline"">"&vbcrlf&_
    "    <input type=""radio"" name=""Lvl"" id=""Lvl"" value=""03""> 总编辑"&vbcrlf&_
    "</label>"&vbcrlf&_
    "<label class=""checkbox-inline"">"&vbcrlf&_
    "    <input type=""radio"" name=""Lvl"" id=""Lvl"" value=""02""> 普通会员"&vbcrlf&_
    "</label>"&vbcrlf&_
    "<label class=""checkbox-inline"">"&vbcrlf&_
    "    <input type=""radio"" name=""Lvl"" id=""Lvl"" value=""01""> 副管"&vbcrlf&_
    "</label>"&vbcrlf&_
    "<label class=""checkbox-inline"">"&vbcrlf&_
    "    <input type=""radio"" name=""Lvl"" id=""Lvl"" value=""00""> 超管"&vbcrlf&_
    "</label>"&vbcrlf
end sub
sub LvlId2()
	uid=Request.Form("uid")
	Lvl=Request.Form("Lvl")
	if clng(uid)=siteid then
		Response.Write"不能操作ID1000"
		Response.End()
	end if
	set rs=server.CreateObject("adodb.recordset")
	rs.open "select * from [user] where siteid="&siteid&" and userid="&uid,conn,1,2
		If rs.eof Then
			Response.Write"不能操作ID1000"
			Response.End()
		end if
	rs("managerlvl")=Lvl
	rs.update
	rs.close
	set rs=nothing
	Response.Write kltool_get_managername(clng(Lvl))
end sub
%>