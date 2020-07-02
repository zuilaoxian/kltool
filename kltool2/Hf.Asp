<!--#include file="config.asp"-->
<%
kltool_use(17)
kltool_admin(1)
action=Request.QueryString("action")
select case action
	case ""
		call index()
	case else
		call index1()
end select

response.write kltool_code(kltool_head("柯林工具箱-恢复功能指向",1))

sub index()
	response.write"<div class=line1>恢复插件功能指向</div>"
	response.write"<div class=line2>点击【<a href=""?siteid="&siteid&"&action=yes"" id=""tip"" tiptext=""确定？"">恢复插件功能指向</a>】</div>"
	response.write"<div class=content>如果点击栏目跳到柯林总站，请使用此功能(无法恢复自定义功能)</div>"
end sub

sub index1()
	str=array(array("article/index.aspx","4"),array("picture/index.aspx","7"),array("download/index.aspx","13"),array("bbs/index.aspx","16"),array("null/index.aspx","25"),array("guessbook/index.aspx","49"),array("link/index.aspx","62"),array("search/index.aspx","65"),array("version.aspx","80"),array("fun/index.asp","104"),array("clan/index.aspx","105"),array("album/index.aspx","106"),array("yuehui/index.aspx","107"),array("NongChang/index.asp","109"),array("zhidao/index.asp","110"),array("XinZhang/index.aspx","111"),array("rizhi/index.aspx","112"),array("utility/chengyu/index.aspx","113"),array("utility/mobile/index.aspx","114"),array("utility/ip/index.aspx","115"),array("utility/id/index.asp","116"),array("video/index.aspx","117"),array("ring/index.aspx","118"),array("utility/phone/index.aspx","119"),array("utility/post/index.aspx","120"),array("chat/index.aspx","121"),array("shop/index.aspx","122"),array("utility/baike/index.aspx","123"),array("utility/weather/index.aspx","124"),array("paimai/index.aspx","125"),array("hotel/index.aspx","126"),array("airplane/index.aspx","127"),array("wml/index.aspx","128"),array("card/index.aspx","129"),array("class/index.aspx","130"),array("visiteCount/index.aspx","131"),array("gongqiu/index.aspx","132"),array("Utility/qiche/index.aspx","133"),array("Utility/fangzi/index.aspx","134"),array("Utility/tiZhong/index.asp","136"),array("guangbo/index.aspx","137"),array("myaccount/index.aspx","138"),array("games/index.aspx","139"),array("novel/index.aspx","140"),array("wabao/index.aspx","141"),array("Signin/index.aspx","142"),array("FormEdit/index.aspx","143"),array("action/index.aspx","144"),array("adlink/index.aspx","98"))

	response.write "恢复成功<br>"
	for I=0 to ubound(str)
		conn.execute("update [systype] set typepath='" & str(I)(0) & "' where typeid="& str(I)(1))
		response.write ""& str(I)(1) &" - " & str(I)(0) & "<br>" & vbCrLf
	next
	kltool_write_log("恢复了插件功能指向")
end sub

response.write kltool_code(kltool_end(1))
%>