<!--#include file="./inc/head.asp"-->
<!--#include file="./inc/keycdksc.asp"-->
<!--#include file="./inc/kltool_rndnick_s.asp"-->
<title>批量注册会员</title>
<%
call kltool_quanxian
pg=request("pg")
if pg="" then
Response.write"<div class=""line2"">请填写信息</div>"
Response.write"<div class=""content"">"
Response.write"<form method=""post"" action=""?"">"
Response.write"<input name=""siteid"" type=""hidden"" value="""&siteid&""">"
Response.write"<input name=""pg"" type=""hidden"" value=""yes1"">"
Response.write"要注册的ID数量<br/>"
Response.write"<input name=""uids"" type=""text"" size=""20"" value=""""><br/>"
	set rs=Server.CreateObject("ADODB.Recordset")
	rs.open"select userid from [user] where userid in(select max(userid) from [user])",conn,1,1
Response.write"开始ID(数)↓最大ID已填写↓<br/>"
Response.write"<input name=""uid"" type=""text"" size=""20"" value="""&clng(rs("userid"))+1&"""><br/>"
	rs.close
	set rs=nothing
Response.write"所属网站ID(一般为1000)<br/>"
Response.write"<input name=""ssid"" type=""text"" size=""20"" value="""&siteid&"""><br/>"
Response.write"昵称(汉/英/数)(留空则随机，示例:<font color=""red"">"&kltool_rndnick_s&"</font>)<br/>"
Response.write"<input name=""name"" type=""text"" size=""20"" value=""""><br/>"
Response.write"密码-已随机-可手动修改<br/>"
Response.write"权限<br/>"
Response.write"<select name=""lvl"">"
Response.write"<option value=""02"">02-普通会员</option>"
Response.write"<option value=""01"">01-副管</option>"
Response.write"<option value=""00"">00-超管</option>"
Response.write"</select><br/>"
Response.write"性别<br/>"
Response.write"<select name=""sx"">"
Response.write"<option value=""1"">1-男</option>"
Response.write"<option value=""0"">0-女</option>"
Response.write"</select><br/>"
Response.write"<input type=""submit"" value=""马上增加"" onClick=""ConfirmDel('是否确定？');return false""><br/>"
Response.write"</form>"
Response.write"</div>"
Response.write"<div class=""tip""><a href=""hy.asp?siteid="&siteid&""">前往会员管理</a></div>"

elseif pg="yes1" then
uids=request("uids")
uid=request("uid")
ssid=request("ssid")
name=request("name")
lvl=request("lvl")
sx=request("sx")
if uids="" or uid=""then call kltool_err_msg("各项不能为空")
if not Isnumeric(uids) or not Isnumeric(uid) or not Isnumeric(ssid) then call kltool_err_msg("ID和网站ID必须是数字")
	uid2=CInt(uid)+CInt(uids)-1
conn.execute("SET IDENTITY_INSERT [USER] ON")
	For i=uid To uid2
	set rs=Server.CreateObject("ADODB.Recordset")
	rs.open"select * from [user] where userid="&i,conn,1,3
	if rs.bof or rs.eof then
	rs.addnew
	rs("userid")=i
	rs("siteid")=ssid
	rs("username")=i
if name="" then
rs("nickname")=kltool_rndnick_s
else
rs("nickname")=name
end if
	rs("password")=Generate_Key
	rs("managerlvl")=lvl
if sx="1" then rs("headimg")=""&RndNumber(30,1)&".gif" else rs("headimg")=""&RndNumber(64,31)&".gif" end if
	rs("sex")=sx
	rs.update
	end if
	rs.close
	set rs=nothing
	next
conn.execute("SET IDENTITY_INSERT [USER] OFF")
call kltool_write_log("注册了"&uids&"个ID："&uid&"-"&uid2)
call kltool_err_msg("批量注册了"&uids&"个ID："&uid&"-"&uid2)
end if
call kltool_end
%>
