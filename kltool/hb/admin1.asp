<!--#include file="../inc/head.asp"-->
<!--#include file="./Function.asp"-->
<title>柯林工具箱-互动红包-后台</title>
<%call kltool_quanxian
conn.execute("select * from [kltool_hb_set]")
If Err Then 
err.Clear
call kltool_err_msg("请先安装数据库字段")
end if

Response.write "<div class=""tip""><a href='index.asp?siteid="&siteid&"'>前台查看</a></div>"

set rs=server.CreateObject("adodb.recordset")
rs.open "select * from [kltool_hb_set] where id=4",conn,1,1
If Not rs.eof Then
Response.Write"<div class=""tip""><form method='post' action='?'>"
Response.Write"<input type='hidden' name='siteid' value='"&siteid&"'>"
Response.Write"<input type='hidden' name='pg' value='yes2'>"
 Response.Write"红包个数上限<input type='text' name='hb_gs' value='' placeholder="""&rs("hb_lx")&"""><br/>"
 Response.Write"红包金额上限<input type='text' name='hb_je' value='' placeholder="""&rs("hb_open")&""">"
Response.Write"<input type='submit' value='修改' name='submit'></form></div>"
end if
rs.close
set rs=nothing
'-----
pg=request("pg")
if pg="" then
set rs=server.CreateObject("adodb.recordset")
rs.open "select top 3 * from [kltool_hb_set]",conn,1,1
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
Response.write "<div class=tip>"&rs("hb_lx")&"."&kltool_hb_lx(rs("hb_lx"))&"_"&kltool_hb_openzt(rs("hb_open"))&"<span class=""right""><a href=""?siteid="&siteid&"&pg=yes&lx="&rs("hb_lx")&""">⊙</a></span></div>"
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
lx=request("lx")
set rs=server.CreateObject("adodb.recordset")
rs.open "select * from [kltool_hb_set] where hb_lx="&lx,conn,1,2
if rs.eof then call kltool_err_msg("不存在的记录")
kltool_hbopen=rs("hb_open")
if kltool_hbopen="1" then
rs("hb_open")=2
openzt=2
else
rs("hb_open")=1
openzt=1
end if
rs.update
rs.close
set rs=nothing
call kltool_write_log("(互动红包)设置类型:"&kltool_hb_lx(lx)&"—状态:"&kltool_hb_open(openzt))
response.redirect "?siteid="&siteid
'-----
elseif pg="yes2" then
hb_gs=request("hb_gs")
hb_je=request("hb_je")
set rs=server.CreateObject("adodb.recordset")
rs.open "select * from [kltool_hb_set] where id=4",conn,1,2
if rs.eof then call kltool_err_msg("记录不存在")
rs("hb_lx")=hb_gs
rs("hb_open")=hb_je
rs.update
rs.close
set rs=nothing
response.redirect "?siteid="&siteid

end if
call kltool_end
%>