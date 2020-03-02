<!--#include file="./inc/head.asp"-->
<title>柯林工具箱-修改会员签名</title>
<%
call kltool_quanxian
pg=request("pg")
if pg="" then
%>
<div class="tip">请输入ID(留空修改全站)</div>
<div class="content">
<form method="post" action="?">
<input name="siteid" type="hidden" value="<%=siteid%>">
<input name="pg" type="hidden" value="yes">
<input name="uid" type="text" size="15" value="">
</div>
<div class="tip">签名修改为</div>
<div class="content">
<textarea name="remark" rows="10" type="text"></textarea><br/>
<input name="g" type="submit" value="马上修改" onClick="ConfirmDel('是否确定？');return false">
</form>
</div>

<%
elseif pg="yes" then
uid=request("uid")
remark=request("remark")
if remark="" then call kltool_err_msg("签名请勿留空")
if uid<>"" and not Isnumeric(uid) then call kltool_err_msg("ID必须是数字")
if uid="" then
ms="全站"
conn.execute("update [user] set remark='"&remark&"' where siteid="&siteid)
else
ms=kltool_get_usernickname(uid,1)&"("&uid&")"
set rs=conn.execute("select userid from [user] where siteid="&siteid&" and userid="&uid)
If rs.eof Then call kltool_err_msg("此ID不存在")
rs.close
set rs=nothing
conn.execute("update [user] set remark='"&remark&"' where siteid="&siteid&" and userid="&uid)
end if

Response.write"<div class=""content"">修改成功<br/>"&ms&"的签名修改为:<br/>"&remark&"</div>"
call kltool_write_log("(签名)修改"&ms&"的签名为："&remark)
end if
call kltool_end
%>