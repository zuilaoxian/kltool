<!--#include file="./inc/head.asp"-->
<title>柯林工具箱-会员会员资料</title>
<%call kltool_quanxian
pg=request("pg")
if pg="" then
uid=request("uid")
if uid="" then call kltool_err_msg("不能为空")
sql="select * from [user] where "
if Isnumeric(uid) then sql=sql&"userid="&uid else sql=sql&"username='"&uid&"'"
set rs=server.CreateObject("adodb.recordset")
rs.open sql,conn,1,1
If rs.eof Then call kltool_err_msg("查无此ID")
%>
<div class="line1">
<form method="post" action="?">
<input name="siteid" type="hidden" value="<%=siteid%>">
<input name="pg" type="hidden" value="">
查询的会员<br/>
<input name="uid" type="text" value="<%=uid%>" <br/>
<input type="submit" value="查询"><br/>
</form>
</div>
<div class="tip">不修改请不要动,或留空</div>
<div class="line1">
<form method="post" action="?">
<input name="siteid" type="hidden" value="<%=siteid%>">
<input name="pg" type="hidden" value="yes">
<input name="uid" type="hidden" value="<%=rs("userid")%>">
他的id:<%=rs("userid")%><br/>
归属站<br/>
<input name="wid" type="text" size="20" value="" placeholder="<%=rs("siteid")%>"><br/>
密码<br/>
<input name="password" type="text" size="20" value="" placeholder="<%=rs("password")%>"><br/>
用户名<br/>
<input name="name" type="text" size="20" value="" placeholder="<%=rs("username")%>"><br/>
昵称<br/>
<input name="nick" type="text" size="20" value="" placeholder="<%=rs("nickname")%>"><br/>
性别
<select name="sx1">
<option value="<%=rs("sex")%>"><%=rs("sex")%></option>
<option value="1">1-男</option>
<option value="0">0-女</option>
</select><br/>
<%=sitemoneyname%><br/>
<input name="mo" type="text" size="20" value="" placeholder="<%=rs("money")%>"><br/>
存款<br/>
<input name="bankmoney" type="text" size="20" value="" placeholder="<%=rs("mybankmoney")%>"><br/>
人民币<br/>
<input name="RMB1" type="text" size="20" value="" placeholder="<%=rs("RMB")%>"><br/>
经验<br/>
<input name="exp1" type="text" size="20" value="" placeholder="<%=rs("expr")%>"><br/>
签名<br/>
<textarea name="re" rows="8" type="text" value="" placeholder="<%=rs("remark")%>"></textarea><br/>
积时<br/>
<input name="lt" type="text" size="20" value="" placeholder="<%=rs("LoginTimes")%>"><br/>
空间人气<br/>
<input name="Zone" type="text" size="20" value="" placeholder="<%=rs("ZoneCount")%>"><br/>
权限<br/>
<select name="lvl">
<option value="<%=rs("managerlvl")%>"><%=rs("managerlvl")%></option>
<option value="04">04-总版主</option>
<option value="03">03-总编辑</option>
<option value="02">02-普通会员</option>
<option value="01">01-副管</option>
<option value="00">00-超管</option>
</select><br/>
锁定?<br/>
<select name="Lock">
<option value="<%=rs("LockUser")%>"><%=rs("LockUser")%></option>
<option value="0">0-正常</option>
<option value="1">1-锁定</option>
</select><br/>
<input type="submit" value="马上修改" onClick="ConfirmDel('是否确定？');return false">
</form>
</div>
<%
rs.close
set rs=nothing	

elseif pg="yes" then
uid=clng(request("uid"))
name=request("name")
nick=request("nick")
pass=request("password")
sx1=request("sx1")
mo=request("mo")
bankmoney=request("bankmoney")
exp1=request("exp1")
RMB1=request("RMB1")
re=request("re")
lt=request("lt")
lvl=request("lvl")
Lock=request("Lock")
Zone=request("Zone")
wid=request("wid")

set rs=Server.CreateObject("ADODB.Recordset")
rs.open"select * from [user] where userid="&uid&"",conn,1,2
if name<>"" then rs("username")=name
if nick<>"" then rs("nickname")=nick
if sx1<>"" then rs("sex")=sx1
	if pass<>"" then
	password=MD5(pass)
	if uid<>siteid then rs("password")=password
	end if
if mo<>"" then rs("money")=mo
if bankmoney<>"" then rs("mybankmoney")=bankmoney
if exp1<>"" then rs("expR")=exp1
if RMB1<>"" then rs("RMB")=RMB1
if re<>"" then rs("remark")=re
if lt<>"" then rs("LoginTimes")=lt
if uid<>siteid then
if wid<>"" and isnumeric(wid) then rs("siteid")=wid
if lvl<>"" then rs("managerlvl")=lvl
if lock<>"" then rs("LockUser")=Lock
end if
if Zone<>"" then rs("ZoneCount")=Zone
rs.update
rs.close
set rs=nothing

user_msg=""
if name<>"" then user_msg=user_msg&"用户名:"&name&"。"
if nick<>"" then user_msg=user_msg&"昵称:"&nick&"。"
if cint(sx1)=1 then sex="男" else sex="女"
if sx1<>"" then user_msg=user_msg&"性别:"&sex&"。"
if mo<>"" then user_msg=user_msg&sitemoneyname&":"&mo&"。"
if bankmoney<>"" then user_msg=user_msg&"存款:"&bankmoney&"。"
if exp1<>"" then user_msg=user_msg&"经验:"&exp1&"。"
if RMB1<>"" then  user_msg=user_msg&"RMB:"&RMB1&"。"
if re<>"" then user_msg=user_msg&"签名:"&re&"。"
if lt<>"" then user_msg=user_msg&"积时:"&lt&"。"
if uid<>siteid and wid<>"" then user_msg=user_msg&"归属站:"&wid&"。"
klvl=cint(lvl)
if klvl=0 Then 
lvl="超管"
elseif klvl=1 Then 
lvl="副管"
elseif klvl=2 Then 
lvl="普通会员"
elseif klvl=3 Then 
lvl="总编"
elseif klvl=4 Then 
lvl="总版"
end if
if lvl<>"" then user_msg=user_msg&"权限:"&lvl&"。"
if cint(lock)=0 then lock="正常" else lock="锁定"
if lock<>"" then user_msg=user_msg&"状态:"&lock&"。"
if Zone<>"" then user_msg=user_msg&"空间人气:"&Zone&"。"
call kltool_write_log("(会员资料)修改了"&kltool_get_usernickname(uid,1)&"("&uid&")的资料:"&user_msg)
response.redirect "?siteid="&siteid&"&uid="&uid

end if
call kltool_end
%>