<!--#include file="config.asp"-->
<%
kltool_use(21)
kltool_admin(1)
action=Request.QueryString("action")

select case action
	case ""
		call index()
	case "moveid"
		call moveid()
end select

sub index()
Response.write kltool_code(kltool_head("柯林工具箱-会员ID转移","1"))

%>
<div class="well well-sm">源ID保留，源用户名改为：用户名a02</div>
<div class="well well-sm">源ID丢失内信、好友、收藏、空间背景、空间留言、帖子、回帖、相册</div>
<div class="form-group">
	<label for="name">源ID</label>
	<input type="text" class="form-control" id="uid1" placeholder="">
</div>
<div class="form-group">
	<label for="name">目标ID</label>
	<input type="text" class="form-control" id="uid2" placeholder="">
</div>
<div id="myButtons3" class="bs-example">
	<button name="M-Id" type="button" id="M-Id" class="btn btn-default btn-block" data-loading-text="Loading...">立刻转移</button>
</div>
<div id="myAlert2" class="alert alert-warning">
	<a href="#" class="close" data-dismiss="alert">&times;</a>
	<strong>提醒！</strong>不可恢复，谨慎操作
</div>

<%
Response.write kltool_code(kltool_end(1))
end sub

sub moveid()
	uid1=Request.Form("uid1")
	uid2=Request.Form("uid2")
	On Error Resume Next
	if uid1="" or uid2="" or not Isnumeric(uid1) or not Isnumeric(uid2) or uid1=uid2 or clng(uid1)=clng(siteid) or clng(uid2)=clng(siteid) then 
		Response.write "错误的转移id,无法操作"
		Response.end
	end if


	set rs=conn.execute("select * from [user] where siteid="&siteid&" and userid="&uid1)
	If rs.eof Then 
		Response.write "源ID不存在"
		Response.end
	end if

	set rs2=conn.execute("select userid from [user] where siteid="&siteid&" and userid="&uid2)
	If rs2.eof Then 
		Response.write "目标ID不存在"
		Response.end
	end if
	rs2.close
	set rs2=nothing


	'数据复制
	conn.execute("update [kelin_com].[dbo].[user] set [user].[siteid]=d.[siteid],[user].[nickname]=d.[nickname],[user].[password]=d.[password],[user].[managerlvl]=d.[managerlvl],[user].[sex]=d.[sex],[user].[age]=d.[age],[user].[shenggao]=d.[shenggao],[user].[tizhong]=d.[tizhong],[user].[xingzuo]=d.[xingzuo],[user].[aihao]=d.[aihao],[user].[fenfuo]=d.[fenfuo],[user].[zhiye]=d.[zhiye],[user].[city]=d.[city],[user].[mobile]=d.[mobile],[user].[email]=d.[email],[user].[money]=d.[money],[user].[moneyname]=d.[moneyname],[user].[moneyregular]=d.[moneyregular],[user].[RegTime]=d.[RegTime],[user].[LastLoginIP]=d.[LastLoginIP],[user].[LastLoginTime]=d.[LastLoginTime],[user].[LoginTimes]=d.[LoginTimes],[user].[LockUser]=d.[LockUser],[user].[headimg]=d.[headimg],[user].[remark]=d.[remark],[user].[sitename]=d.[sitename],[user].[siteimg]=d.[siteimg],[user].[siteuptip]=d.[siteuptip],[user].[sitedowntip]=d.[sitedowntip],[user].[siteposition]=d.[siteposition],[user].[siterowremark]=d.[siterowremark],[user].[sitelistflag]=d.[sitelistflag],[user].[sitelist]=d.[sitelist],[user].[sitetype]=d.[sitetype],[user].[MaxPerPage_Default]=d.[MaxPerPage_Default],[user].[MaxPerPage_Content]=d.[MaxPerPage_Content],[user].[MaxFileSize]=d.[MaxFileSize],[user].[SaveUpFilesPath]=d.[SaveUpFilesPath],[user].[UpFileType]=d.[UpFileType],[user].[CharFilter]=d.[CharFilter],[user].[UAFilter]=d.[UAFilter],[user].[SessionTimeout]=d.[SessionTimeout],[user].[MailServer]=d.[MailServer],[user].[MailServerUserName]=d.[MailServerUserName],[user].[MailServerPassWord]=d.[MailServerPassWord],[user].[sitemoneyname]=d.[sitemoneyname],[user].[sitespace]=d.[sitespace],[user].[myspace]=d.[myspace],[user].[siteRight]=d.[siteRight],[user].[SidTimeOut]=d.[SidTimeOut],[user].[lvlNumer]=d.[lvlNumer],[user].[lvlTimeImg]=d.[lvlTimeImg],[user].[lvlRegular]=d.[lvlRegular],[user].[myBankMoney]=d.[myBankMoney],[user].[myBankTime]=d.[myBankTime],[user].[chuiNiu]=d.[chuiNiu],[user].[expR]=d.[expR],[user].[endTime]=d.[endTime],[user].[version]=d.[version],[user].[RMB]=d.[RMB],[user].[siteVIP]=d.[siteVIP],[user].[ZoneCount]=d.[ZoneCount],[user].[HangBiaoShi]=d.[HangBiaoShi],[user].[isCheck]=d.[isCheck],[user].[bbsCount]=d.[bbsCount],[user].[bbsReCount]=d.[bbsReCount],[user].[actionTime]=d.[actionTime],[user].[actionState]=d.[actionState],[user].[TJCount]=d.[TJCount] from [user] left join [user] d on d.[userid] = "&uid1&" where [user].[userid] = "&uid2&"")

	'因为username登录名不可重复，单独修改
	'修改源ID用户名为：用户名02
	conn.execute("update [user] set username='"&rs("username")&"a02' where siteid="&siteid&" and userid="&uid1)
	'修改目标ID用户名为源用户名
	conn.execute("update [user] set username='"&rs("username")&"' where siteid="&siteid&" and userid="&uid2)
	'修改帖子归属为目标ID
	conn.execute("update [wap_bbs] set whylock=null,book_pub="&uid2&",book_author='"&rs("nickname")&"' where book_pub="&uid1)
	'修改回帖
	conn.execute("update [wap_bbsre] set nickname='"&rs("nickname")&"',userid="&uid2&" where userid="&uid1)
	'修改内信
	conn.execute("update [wap_message] set nickname='"&rs("nickname")&"',userid="&uid2&" where userid="&uid1)
	'好友
	conn.execute("update [wap_friends] set userid="&uid2&" where userid="&uid1)
	'收藏
	conn.execute("update [favdetail] set userid="&uid2&" where userid="&uid1)
	'财产日志
	conn.execute("update [wap_bankLog] set userid="&uid2&",opera_userid="&uid2&",opera_nickname='"&rs("nickname")&"' where userid="&uid1)
	'空间背景
	conn.execute("update [user_Info] set userid="&uid2&" where userid="&uid1)
	'空间留言
	conn.execute("update [wap2_userGuessBook] set userid="&uid2&",fromuserid="&uid2&",fromnickname='"&rs("nickname")&"' where userid="&uid1)
	'相册分类
	conn.execute("update [wap_albumSubject] set userid="&uid2&" where userid="&uid1)
	'相册照片
	conn.execute("update [wap_album] set userid="&uid2&",book_author='"&rs("nickname")&"',MakerID="&uid2&" where userid="&uid1)
	'相册照片评论
	conn.execute("update [wap_albumre] set userid="&uid2&",nickname='"&rs("nickname")&"' where userid="&uid1)
	rs.close
	set rs=nothing
	response.write "转移成功："&uid1&"->"&uid2
end sub
%>