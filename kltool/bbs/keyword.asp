<!--#include file="../inc/config.asp"-->
<%
kltool_head("柯林工具箱-内容替换")
kltool_quanxian
cid=request("cid")
keyword1=request("keyword1")
keyword2=request("keyword2")
Response.write "<div class=""tip"">执行成功</div>"
conn.Execute("update [wap_bbs] set [book_content]=REPLACE(cast ([book_content] as varchar(max)),'"&keyword1&"','"&keyword2&"') where book_classid="&cid&"")

kltool_end
%>