<!--#include file="../inc/config.asp"-->
<%
kltool_head("柯林工具箱-功能管理")
kltool_quanxian
'-----
pg=request("pg")
if pg="xg" then
	id=request("id")
	k1=request("k1")
	k2=request("k2")
	id_Split=Split(id,",")
	k1_Split=Split(k1,",")
	k2_Split=Split(k2,",")
	for i=0 to ubound(id_Split)
	kltool.execute("update kltool set kltool_order="&k1_Split(i)&",kltool_show="&k2_Split(i)&" where id="&id_Split(i))
	next
	kltool_write_log("(功能)排序显隐管理")
	kltool_msg("操作成功")
end if

	set rs=server.CreateObject("adodb.recordset")
	rs.open "select * from [kltool]",kltool,1,1
	If Not rs.eof Then
		Response.Write"<form method='post' action='?'>"
		Response.Write"<input type='hidden' name='siteid' value='"&siteid&"'>"
		Response.Write"<input type='hidden' name='pg' value='xg'>"
			For i=1 To rs.recordcount
			If rs.eof Then Exit For
			Response.Write"<input type='hidden' name='id' value='"&rs("id")&"'>"
				Response.write"<div class=""line1"">"
				Response.write"<a href="""&kltool_path&"index.asp?siteid="&siteid&"&pg=action&id="&rs("id")&""">"&rs("kltool_name")&"</a>"
				Response.Write"<span class='right'>排序号<input type='text' name='k1' value='"&rs("kltool_order")&"' size='5'>"
				Response.write"显隐<select name='k2'>"
				Response.write"<option value='1'"
				if rs("kltool_show")="1" then Response.write" selected"
				Response.write">显示</option>"
				Response.write"<option value='2'"
				if rs("kltool_show")="2" then Response.write" selected"
				Response.write">隐藏</option>"
				Response.write"</select></span></div>"
			rs.movenext
			Next
		Response.Write"<input type='submit' value='确定' name='g' onClick='ConfirmDel('是否确定？');return false'></form>"
	else
		Response.write"<div class=tip>暂时没有记录！</div>"
	end if
	rs.close
	set rs=nothing
kltool_end
%>