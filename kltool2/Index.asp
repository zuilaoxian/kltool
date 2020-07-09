<!--#include file="config.asp"-->
<%
kltool_admin(1)
function rndpanel()
	select case (RndNumber(4,1))
		 case 4
			rndpanel="success"
		 case 3
			rndpanel="info"
		 case 2
			rndpanel="warning"
		 case 1
			rndpanel="danger"
	end select
end function

action=Request.QueryString("action")
select case action
	case ""
		call index()
	case "reqt"
		call reqt()
	case "reorder"
		call reorder()
end select

sub index()
	html=kltool_head("柯林工具箱",1)
	str=kltool_GetRow("select * from [kltool] order by kltool_order",1,30)
	if str(0) then
		html=html&_
		"<div class=""panel-group"" id=""accordion"">"&vbcrlf
		for i=0 to ubound(str(2),2)
			x=page*PageSize+i-PageSize+1
			id=str(2)(0,i)
			name=str(2)(1,i)
			title=str(2)(2,i)
			content=str(2)(3,i)
			t=str(2)(5,i)
			kltool_order=str(2)(4,i)
			kltool_show=str(2)(6,i)
			if t=1 then tstr="启用" else tstr="停用"
			if kltool_show=0 then kltool_show_t="style=""display:none;""" else kltool_show_t=""
			html=html&_
			"<div class=""panel panel-"&rndpanel&""" "&kltool_show_t&">"&vbcrlf&_
			"	<div class=""panel-heading"">"&vbcrlf&_
			"	<span data-toggle=""collapse"" data-parent=""#accordion"" href=""#collapse"&id&""">"&vbcrlf&_
			"		<div class=""panel-title"">"&name&"</div>"&vbcrlf&_
			"	</span>"&vbcrlf&_
			"</div>"&vbcrlf&_
			"<div class=""panel-body"">"&vbcrlf&_
			"	<input name=""kltool_order"" id=""kltool_order"" kid="""&id&""" type=""text"" value="""&kltool_order&""" size=""1"" style=""display:none;"">"&vbcrlf&_
			"	"&title&"<span class=""badge"" id="""&id&""">"&tstr&"</span></div>"&vbcrlf&_
			"	<div id=""collapse"&id&""" class=""list-group panel-collapse collapse"">"&vbcrlf&_
			"	"&content&vbcrlf&_
			"	</div>"&vbcrlf&_
			"</div>"&vbcrlf&vbcrlf
		Next
	end if
		html=html&"</div>"&vbcrlf&_
		"<script>"&vbcrlf&_
		"$(function(){"&vbcrlf&_
		"	$('.badge').click(function(){"&vbcrlf&_
		"		id=$(this).attr('id');"&vbcrlf&_
		"		$.ajax({"&vbcrlf&_
		"		url:'?action=reqt',"&vbcrlf&_
		"		type:'get',"&vbcrlf&_
		"		data:{"&vbcrlf&_
		"			id:id"&vbcrlf&_
		"			},"&vbcrlf&_
		"		timeout:'15000',"&vbcrlf&_
		"			success:function(data){"&vbcrlf&_
		"				layer.msg(data,{time:2000,anim:6});"&vbcrlf&_
		"				if ($('span#'+id).text()=='启用'){"&vbcrlf&_
		"					$('span#'+id).text('停用');"&vbcrlf&_
		"				}else if ($('span#'+id).text()=='停用'){"&vbcrlf&_
		"					$('span#'+id).text('启用');"&vbcrlf&_
		"				}else{"&vbcrlf&_
		"				}"&vbcrlf&_
		"			}"&vbcrlf&_
		"		})"&vbcrlf&_
		"	});"&vbcrlf&_
		
		"	$(document).keyup(function(event){"&vbcrlf&_
		"		keycode=event.which;"&vbcrlf&_
		"		if(keycode==13){"&vbcrlf&_
		"			$('input#kltool_order').show();"&vbcrlf&_
		"		} "&vbcrlf&_
		"		if(keycode == 27){"&vbcrlf&_
		"			$('input#kltool_order').hide();"&vbcrlf&_
		"			$('input#kltool_order').each(function(){"&vbcrlf&_
		"				orderid=$(this).val();"&vbcrlf&_
		"				id=$(this).attr('kid');"&vbcrlf&_
		"				$.ajax({"&vbcrlf&_
		"					url:'?action=reorder&orderid='+orderid+'&id='+id,"&vbcrlf&_
		"					type:'get',"&vbcrlf&_
		"					timeout:'15000',"&vbcrlf&_
		"					async:true,"&vbcrlf&_
		"					success:function(data){"&vbcrlf&_
		"						console.log(data)"&vbcrlf&_
		"					}"&vbcrlf&_
		"				})"&vbcrlf&_
		"			})"&vbcrlf&_
		"		}"&vbcrlf&_
		" 	});"&vbcrlf&_
		
		"});"&vbcrlf&_
		"</script>"&vbcrlf
	Response.write kltool_code(html&kltool_end(1))
	
end sub

sub reqt()
	id=Request.QueryString("id")
	set rs=Server.CreateObject("ADODB.Recordset")
	rs.open "select * from [kltool] where id="&id,kltool,1,2
	if rs.bof and rs.eof then
		Response.write "无此id记录"
		Response.End()
	end if
		if rs("kltool_use")=1 then
			rs("kltool_use")=0
			Response.write "停用"
		else
			rs("kltool_use")=1
			Response.write "启用"
		end if
	rs.update
	rs.close
	set rs=nothing
end sub
sub reorder()
	id=Request.QueryString("id")
	orderid=Request.QueryString("orderid")
	set rs=Server.CreateObject("ADODB.Recordset")
	rs.open "select * from [kltool] where id="&id,kltool,1,2
	if rs.bof and rs.eof then
		Response.write "无此id记录"
		Response.End()
	end if
	rs("kltool_order")=orderid
	rs.update
	rs.close
	set rs=nothing
	Response.write id&","&orderid
end sub
%>