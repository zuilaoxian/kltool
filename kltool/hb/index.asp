<!--#include file="../inc/head.asp"-->
<!--#include file="./Function.asp"-->
<!--#include file="../inc/keycdksc.asp"-->
<title>互动红包</title>
<%
'数据库检测代码
conn.execute("select * from [kltool_hb]")
If Err Then 
err.Clear
call kltool_err_msg("请等待站长配置本功能")
end if
Response.Write"<div class=""tip"">"
if kltool_yunxu=1 then Response.Write"<a href='admin1.asp?siteid="&siteid&"'>管理后台</a>&nbsp;"
Response.Write"<a href=""?siteid="&siteid&""">您的"&sitemoneyname&":"&money&"</a>"
Response.Write"<span class=""right""><a href=""myhb.asp?siteid="&siteid&""">⊙</a></span>"
Response.Write"<span class=""right"" id=""hb_pic1""><button onclick=""display(hb_pic2);display(hb_pic1);return false;"">我要发个红包</button></div>"
%>
<span id="hb_pic2" style="display:none">
<div class="line1">
<span class="right"><button onclick="display(hb_pic1);display(hb_pic2);return false;">取消</button></span>
<form method="post" action="?">
<input name="siteid" type="hidden" value="<%=siteid%>">
<input name="pg" type="hidden" value="yes">
<%
set rs=server.CreateObject("adodb.recordset")
rs.open "select top 3 * from [kltool_hb_set] where hb_open=1",conn,1,1
	For i=1 To PageSize
	If rs.eof Then Exit For
Response.Write"<input name=""hblx"" type=""radio"" value="""&rs("hb_lx")&""" onClick="""
if rs("hb_lx")<>"3" then Response.Write"hb.style.display='none';" else Response.Write"hb.style.display='';"
if rs("hb_lx")<>"1" then Response.Write"hb2.style.display='none';" else Response.Write";hb2.style.display='';"
if rs("hb_lx")="1" then Response.Write"hb3.style.display='none';" else Response.Write";hb3.style.display='';"
Response.Write""""
if rs("hb_lx")="1" then Response.Write"checked"
Response.Write">"
Response.Write kltool_hb_lx(rs("hb_lx"))&"&nbsp;&nbsp;"
	rs.movenext
 	Next
%>
<br/>红包(个数)<input name="hbsl" type="text" value="">上限<%=kltool_hb_sx(1)%><br/>
<span id="hb3" style="display:none"><%=sitemoneyname%>(总量)</span>
<span id="hb2" style="display:"><%=sitemoneyname%>(单个)</span>
<input name="moneysl" type="text" value="" placeholder="<%=money%>">上限<%=kltool_hb_sx(2)%><br/>
<span id="hb" style="display:none">红包暗语<input name="hbay" type="text" value="" placeholder="不能为空,不大于16字"><br/></span>
<input name="hbyk" type="radio" value="1">预看模式,提前看每份金额
<span class=right><input name="g" type="submit" value="确定" onClick="ConfirmDel('是否确定？');return false"></span>

</form>
</div>
</span>
<%
pg=request("pg")
if pg="" then
set rs=server.CreateObject("adodb.recordset")
rs.open "select * from [kltool_hb] order by id desc",conn,1,1
If Not rs.eof Then
	gopage="?"
	Count=rs.recordcount
	page=int(request("page"))
	if page<=0 or page="" then page=1
	pagecount=(count+pagesize-1)\pagesize
	if page>pagecount then page=pagecount
	rs.move(pagesize*(page-1))
call kltool_page(1)
	For i=1 To PageSize
	If rs.eof Then Exit For
Response.write"<div class=tip>"&page*PageSize+i-PageSize&"."
Response.write kltool_get_usernickname(rs("hb_userid"),1)&"<small><small>("&rs("hb_userid")&")</small></small>的"&kltool_hb_lx(rs("hb_lx"))
Response.write"<small><small>(剩余"&kltool_hb_last(rs("hb_ly"))&")</small></small>"
if clng(rs("hb_open"))=1 then Response.write"◎"
Response.write"<span class=""right"">"
if kltool_hb_yes(rs("hb_ly"))>=1 then response.write"✔"
Response.write"<a href=""?siteid="&siteid&"&hbly="&rs("hb_ly")&"&pg=yes2"">⊙</a>"
Response.write"</span></div>"
	rs.movenext
 	Next
call kltool_page(2)
else
   Response.write "<div class=tip>暂时没有记录！</div>"
end if
rs.close
set rs=nothing
'-----
elseif pg="yes" then
hblx=clng(request("hblx"))
hbsl=clng(request("hbsl"))
moneysl=clng(request("moneysl"))
hbay=request("hbay")
hbyk=clng(request("hbyk"))
if hbyk="" then hbyk=2
'-----红包ID
id_hbly=Generate_Key
'-----各种判断
if hblx="" or (not Isnumeric(hblx)) then call kltool_err_msg("请选择红包类型")
if hbsl="" or (not Isnumeric(hbsl)) or hbsl<1 then call kltool_err_msg("红包个数不能为空\n大于1\n且必须是数字")
if moneysl="" or (not Isnumeric(moneysl)) or moneysl<1 then call kltool_err_msg(""&sitemoneyname&"数量不能为空\n大于1\n且必须是数字")
if clng(moneysl)>clng(money) then call kltool_err_msg("您的"&sitemoneyname&"不够哦")
if hbsl>clng(kltool_hb_sx(1)) then call kltool_err_msg("超出红包个数上限")
if moneysl>clng(kltool_hb_sx(2)) then call kltool_err_msg("超出红包金额上限")
if hblx=1 then
	if clng(hbsl*moneysl)>clng(money) then call kltool_err_msg("您的"&sitemoneyname&"不够")
elseif hblx=2 then
	if int(moneysl/hbsl)<1 then call kltool_err_msg("分配"&sitemoneyname&"失败\n因为"&sitemoneyname&"过少")
elseif hblx=3 then
	if hbay="" or len(hbay)>16 then call kltool_err_msg("暗语不能为空\n且不能大于16字符")
end if
'-----写入红包1
	set rs=server.CreateObject("adodb.recordset")
	rs.open "select * from [kltool_hb]",conn,1,2
	rs.addnew
	rs("hb_userid")=userid
	rs("hb_ly")=id_hbly
	rs("hb_lx")=hblx
	rs("hb_sl")=hbsl
	if hblx=1 then rs("hb_money")=int(hbsl*moneysl) else rs("hb_money")=moneysl
	rs("hb_ay")=hbay
	rs("hb_open")=hbyk
	rs("hb_date")=now()
	rs.update
	rs.close
	set rs=nothing
	'-----扣币
	set rs=server.CreateObject("adodb.recordset")
	rs.open "select * from [user] where userid="&userid,conn,1,2
	if hblx=1 then rs("money")=clng(rs("money"))-clng(hbsl*moneysl) else rs("money")=clng(rs("money"))-clng(moneysl)
	rs.update
	rs.close
	set rs=nothing
'-----写入红包2
if hblx=1 then
	for i=1 to hbsl
		set rs=server.CreateObject("adodb.recordset")
		rs.open "select * from [kltool_hb_log]",conn,1,2
		rs.addnew
		rs("hb_lx")=hblx
		rs("hb_ly")=id_hbly
		rs("hb_money")=moneysl
		rs("hb_userid")=0
		rs.update
		rs.close
		set rs=nothing	
	next
elseif (hblx=2 or hblx=3) then
	if hb_sl=1 then
		set rs=server.CreateObject("adodb.recordset")
		rs.open "select * from [kltool_hb_log]",conn,1,2
		rs.addnew
		rs("hb_lx")=hblx
		rs("hb_ly")=id_hbly
		rs("hb_money")=moneysl
		rs("hb_userid")=0
		rs.update
		rs.close
		set rs=nothing
	else
		for i=1 to hbsl-1
		min=1	'最低可以抢到1
		safe_total=(moneysl-(hbsl-i)*min)/(hbsl-i)	'随机安全上限
		hbmoneys=RndNumber(safe_total,min)	'随机一次
		moneysl=moneysl-hbmoneys
		set rs=server.CreateObject("adodb.recordset")
		rs.open "select * from [kltool_hb_log]",conn,1,2
		rs.addnew
		rs("hb_lx")=hblx
		rs("hb_ly")=id_hbly
		rs("hb_money")=hbmoneys
		rs("hb_userid")=0
		rs.update
		rs.close
		set rs=nothing	
		next
		set rs=server.CreateObject("adodb.recordset")
		rs.open "select * from [kltool_hb_log]",conn,1,2
		rs.addnew
		rs("hb_lx")=hblx
		rs("hb_ly")=id_hbly
		rs("hb_money")=moneysl
		rs("hb_userid")=0
		rs.update
		rs.close
		set rs=nothing
	end if
end if
	Response.write"<div class=tip>您发了一个"&kltool_hb_lx(hblx)&"。"
	Response.write"<a href=""?siteid="&siteid&"&hbly="&id_hbly&"&pg=yes2"">立即前往</a></div>"
'-----
elseif pg="yes2" then
yes2_hbly=request("hbly")
'显示红包来源-红包总额
Response.write"<div class=""tip"">"&kltool_hb_ly(yes2_hbly)&"<small><small>("&kltool_hb_lyuid(yes2_hbly)&")</small></small>的"&kltool_hb_lx(kltool_hb_lylx(yes2_hbly))&"！<span class=""right"">总额:"&kltool_hb_lyje(yes2_hbly)&"</span></div>"
'显示红包余量-抢红包按钮与暗语表单
Response.write"<div class=""tip"">"
if kltool_hb_last(yes2_hbly)>0 then Response.write"剩余"&kltool_hb_last(yes2_hbly)&"个" else Response.write"来迟一步，毛都不剩"
Response.write"<span class=""right"">"
if kltool_hb_last(yes2_hbly)>0 then '剩余数量大于0继续
if kltool_hb_yes(yes2_hbly)<1 then '已抢次数小于1继续
	if kltool_hb_lylx(yes2_hbly)="3" then
%>
<script>
function addhbay(_hbay){
 document.getElementById("hbay").value=_hbay;
 }
</script>
<a href="javascript:addhbay('<%=kltool_hb_ay(yes2_hbly)%>');">红包暗语</a>
<%
		Response.write"<form method=""post"" action=""?"">"
		Response.write"<input name=""siteid"" type=""hidden"" value="""&siteid&""">"
		Response.write"<input name=""pg"" type=""hidden"" value=""yes3"">"
		Response.write"<input name=""hbly"" type=""hidden"" value="""&yes2_hbly&""">"
		Response.write"<input name=""hbay"" id=""hbay"" type=""text"" value="""" size=""8"">"
		Response.write"<input name=""g"" type=""submit"" value=""确定""></form>"
	else
		if kltool_hb_last(yes2_hbly)>0 then
		Response.write"<a href=""?siteid="&siteid&"&hbly="&yes2_hbly&"&pg=yes3"">⊙</a>"
		else
		Response.write"⊙"
		end if
	end if
else
Response.write"⊙"&kltool_hb_ay(yes2_hbly)
end if
end if
	Response.write"</span></div>"

if kltool_hb_open(yes2_hbly)="1" then	'预看模式
sql="select * from [kltool_hb_log] where hb_ly='"&yes2_hbly&"'"
else	'非预看模式
sql="select * from [kltool_hb_log] where hb_ly='"&yes2_hbly&"' and hb_userid>0"
end if
set rs=server.CreateObject("adodb.recordset")
rs.open sql,conn,1,1
If Not rs.eof Then
	gopage="?pg=yes2&amp;hbly="&yes2_hbly&"&amp;"
	Count=rs.recordcount
	page=int(request("page"))
	if page<=0 or page="" then page=1
	pagecount=(count+pagesize-1)\pagesize
	if page>pagecount then page=pagecount
	rs.move(pagesize*(page-1))
call kltool_page(1)
	For i=1 To PageSize
	If rs.eof Then Exit For
Response.write"<div class=""tip"">"
if kltool_hb_open(yes2_hbly)="1" then
if rs("hb_userid")<>"0" then Response.write rs("hb_money")&sitemoneyname&"_"&kltool_get_usernickname(rs("hb_userid"),1)&"<small><small>("&rs("hb_userid")&")</small></small>抢到了这个红包" else Response.write rs("hb_money")&sitemoneyname
else
if rs("hb_userid")<>"0" then Response.write kltool_get_usernickname(rs("hb_userid"),1)&"<small><small>("&rs("hb_userid")&")</small></small>抢到了"&rs("hb_money")&sitemoneyname
end if
Response.write"</div>"
	rs.movenext
 	Next
call kltool_page(2)
else
   Response.write "<div class=""tip"">没有开抢记录！</div>"
end if
rs.close
set rs=nothing
'-----
elseif pg="yes3" then
yes3_hbly=request("hbly")
yes3_hbay=request("hbay")
if kltool_hb_last(yes3_hbly)<=0 then call kltool_err_msg("来迟一步，毛都不剩")
if kltool_hb_yes(yes3_hbly)>=1 then call kltool_err_msg("贪心不足蛇吞象")
if yes3_hbay<>"" and yes3_hbay<>kltool_hb_ay(yes3_hbly) then call kltool_err_msg("暗语不正确哟")

sql="select top 1 * from [kltool_hb_log] where hb_ly='"&yes3_hbly&"' and hb_userid=0 order by newid()"
set rs=server.CreateObject("adodb.recordset")
rs.open sql,conn,1,2
if rs.bof or rs.eof then call kltool_err_msg("来迟一步，毛都不剩")
moneysl=rs("hb_money")
rs("hb_userid")=userid
rs("hb_date")=now()
rs.update
rs.close
set rs=nothing

set rs=server.CreateObject("adodb.recordset")
rs.open "select * from [user] where userid="&userid,conn,1,2
rs("money")=clng(rs("money"))+clng(moneysl)
rs.update
rs.close
set rs=nothing

	Response.write"<div class=""tip"">您抢到了"&kltool_hb_ly(yes3_hbly)&"的"&kltool_hb_lx(kltool_hb_lylx(yes3_hbly))&"！</div>"
	Response.write"<div class=""tip""> 金额："&moneysl&"</div>"
 	Response.write"<div class=""tip""> <a href=""?siteid="&siteid&"&hbly="&yes3_hbly&"&pg=yes2"">返回红包页面</a></div>"
end if
call kltool_end
%>