<!--#include file="../inc/head.asp"-->
<title>网站币互转</title>
<%
'数据库检测代码
conn.execute("select * from [money_set]")
If Err Then 
err.Clear
call kltool_err_msg("请等待站长配置本功能")
end if

if kltool_yunxu=1 then Response.Write "<div class=tip><a href='admin1.asp?siteid="&siteid&"'>管理后台</a></div>"
'''''''''''''''''''''''开始
%>
<div class="line1">您的身份:<%=kltool_get_uservip(userid,1)%></div>
<div class="line2">您的<%=sitemoneyname%>:<%=money%>　经验:<%=expr%>　RMB:<%=rmb%></div>
<%
if clng(SessionTimeout)>0 then
	set rs=server.CreateObject("adodb.recordset")
	rs.open "select * from [money_set] where vip="&SessionTimeout,conn,1,1
	if rs.eof then
	rs.close
	set rs=nothing

	set rs=server.CreateObject("adodb.recordset")
	rs.open "select * from [money_set] where id=1",conn,1,1
	end if
else
	set rs=server.CreateObject("adodb.recordset")
	rs.open "select * from [money_set] where id=1",conn,1,1
end if
	jia1=rs("jin1")
	jia2=rs("jin2")
	rs.close
	set rs=nothing
if (isnull(jia1) or jia1 ="") or (isnull(jia2) or jia2="") then call kltool_err_msg("请等待管理员配置参数")

pg=request("pg")
if pg="" then
Response.Write "<div class='tip'>兑换比例：</div>"
Response.Write "<div class='line1'>"&sitemoneyname&"兑换RMB比例：<font color=red>"&jia1&"</font>(可兑换"&Round(money/jia1,2)&"RMB)</div>"
Response.Write "<div class='line2'>RMB兑换"&sitemoneyname&"比例：<font color=red>"&jia2&"</font>(可兑换"&clng(rmb*jia2)&sitemoneyname&")</div>"

Response.Write "<div class='content'><form method='post' action='?'>"
Response.Write "<input type='hidden' name='siteid' value='"&siteid&"'>"
Response.Write "<input type='hidden' name='pg' value='dh'>"

Response.Write "<input type='radio' name='lx' value='1' checked>"&sitemoneyname&"兑换RMB</input>"
Response.Write "<input type='radio' name='lx' value='2'>RMB兑换"&sitemoneyname&"</input><br/>"
Response.Write "将要兑换的数量<br/><input type='text' name='jin' value='' size='15'>"
Response.Write "<input type='submit' value='确定兑换' name='submit' onClick=""ConfirmDel('是否确定？');return false""></form></div>"
'-----
elseif pg="dh" then
jin=request("jin")
lx=clng(request("lx"))
if jin="" then call kltool_err_msg("不能为空")
if not Isnumeric(jin) then call kltool_err_msg("必须是数字")
if lx=1 then
if clng(jin*jia1)>clng(money) then call kltool_err_msg(""&sitemoneyname&"不足，需要"&jin*jia1&"")
	set rs=server.CreateObject("adodb.recordset")
	rs.open "select siteid,money,rmb from [user] where siteid="&siteid&" and userid="&userid,conn,1,2
	rs("money")=money-jin*jia1
	newrmb=rs("rmb")+Round(jin,2)
	rs("rmb")=Round(newrmb,2)
	rs.update
	rs.close
	set rs=nothing

	set rs=server.CreateObject("adodb.recordset")
	rs.open "select * from [money_log]",conn,1,2
	rs.addnew
	rs("userid")=userid
	rs("lx")=lx
	rs("jin1")=Round(jin,2)
	rs("jin2")=jin*jia1
	rs("mtime")=now()
	rs.update
	rs.close
	set rs=nothing
Response.Write "<div class='tip'>兑换了"&Round(jin,2)&"RMB，花费"&clng(jin*jia1)&sitemoneyname&"</div>"
elseif lx=2 then
if Round(jin/jia2,2)>rmb then call kltool_err_msg("RMB不足，需要"&Round(jin/jia2,2)&"")
	set rs=server.CreateObject("adodb.recordset")
	rs.open "select siteid,money,rmb from [user] where siteid="&siteid&" and userid="&userid,conn,1,2
	rs("money")=money+"&jin&"
	newrmb=rs("rmb")-Round(jin/jia2,2)
	rs("rmb")=Round(newrmb,2)
	rs.update
	rs.close
	set rs=nothing

	set rs=server.CreateObject("adodb.recordset")
	rs.open "select * from [money_log]",conn,1,2
	rs.addnew
	rs("userid")=userid
	rs("lx")=lx
	rs("jin1")=jin
	rs("jin2")=Round(jin/jia2,2)
	rs("mtime")=now()
	rs.update
	rs.close
	set rs=nothing
Response.Write "<div class='tip'>兑换了"&jin&sitemoneyname&"，花费"&Round(jin/jia2,2)&"RMB</div>"
end if

end if

call kltool_end
%>