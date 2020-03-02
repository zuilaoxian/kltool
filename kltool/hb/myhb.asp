<!--#include file="../inc/head.asp"-->
<!--#include file="./Function.asp"-->
<title>互动红包-红包记录</title>
<%
'数据库检测代码
conn.execute("select * from [kltool_hb]")
If Err Then 
err.Clear
call kltool_err_msg("请等待站长配置本功能")
end if
Response.Write"<div class=""tip"">"
if kltool_yunxu=1 then Response.Write"<a href='admin1.asp?siteid="&siteid&"'>管理后台</a>&nbsp;"
Response.Write"<a href=""./?siteid="&siteid&""">您的"&sitemoneyname&":"&money&"</a>"
Response.Write"<span class=""right"" id=""hb_pic1""><button onclick=""display(hb_pic2);display(hb_pic1);return false;"">我要发个红包</button></div>"
%>
<span id="hb_pic2" style="display:none">
<div class="line1">
<span class="right"><button onclick="display(hb_pic1);display(hb_pic2);return false;">取消</button></span>
<form method="post" action="./?">
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
lx=request("lx")
sf1=kltool_hb_sf(1)
sf2=kltool_hb_sf(2)
if sf1="" then sf1=0
if sf2="" or isnull(sf2) then sf2=0
Response.Write"<div class=""tip"">"
a="<a href=""?siteid="&siteid&""">我抢到的</a>("&kltool_hb_sfsl(1)&"个/"&sf1&")"
b="<a href=""?siteid="&siteid&"&lx=2""> 我发出的</a>("&kltool_hb_sfsl(2)&"个/"&sf2&")"
if lx="" or lx="1" then Response.Write a else Response.Write b
Response.Write"<span class=""right"">"
if lx="" or lx="1" then Response.Write b else Response.Write a
Response.Write"</span>"
Response.Write"</div>"

pg=request("pg")
if pg="" then
lx=request("lx")
if lx="" or lx="1" then
sql="select * from [kltool_hb_log] where hb_userid="&userid&" order by hb_date desc"
elseif lx="2" then
sql="select * from [kltool_hb] where hb_userid="&userid&" order by hb_date desc"
end if
set rs=server.CreateObject("adodb.recordset")
rs.open sql,conn,1,1
If Not rs.eof Then
	gopage="?lx="&lx&"&amp;"
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
if lx="" or lx="1" then
Response.write kltool_hb_ly(rs("hb_ly"))&"的"&kltool_hb_lx(rs("hb_lx"))
elseif lx="2" then
response.write"我发出的"&kltool_hb_lx(rs("hb_lx"))
end if
Response.write"<small><small>(金额"&rs("hb_money")&")</small></small>"
Response.write"<span class=""right"">"
Response.write"<a href=""./?siteid="&siteid&"&hbly="&rs("hb_ly")&"&pg=yes2"">⊙</a>"
Response.write"</span></div>"
	rs.movenext
 	Next
call kltool_page(2)
else
   Response.write "<div class=tip>暂时没有记录！</div>"
end if
rs.close
set rs=nothing

end if
call kltool_end
%>