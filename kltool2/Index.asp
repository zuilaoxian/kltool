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
	case "edtool"
		call edtool()
	case "tool_set"
		call tool_set()
	case "deltool"
		call deltool()
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
		"<div class=""alert alert-danger alert-dismissible"" role=""alert"" id=""linkhide2"" style=""display:none;"">"&vbcrlf&_
		"	<button type=""button"" class=""close"" data-dismiss=""alert"" aria-label=""Close""><span aria-hidden=""true"">×</span></button>"&vbcrlf&_
		"	<a href=""?action=edtool"">功能编辑</a>"&vbcrlf&_
		"</div>"&vbcrlf&_
		
		"<div class=""alert alert-danger alert-dismissible"" role=""alert"" id=""linkhide"" style=""display:none;"">"&vbcrlf&_
		"	<button type=""button"" class=""close"" data-dismiss=""alert"" aria-label=""Close""><span aria-hidden=""true"">×</span></button>"&vbcrlf&_
		"	点击完成排序"&vbcrlf&_
		"</div>"&vbcrlf&_
		
		"<div id=""linkshow"" class=""alert alert-danger alert-dismissible"" role=""alert"">"&vbcrlf&_
		"	<button type=""button"" class=""close"" data-dismiss=""alert"" aria-label=""Close""><span aria-hidden=""true"">×</span></button>"&vbcrlf&_
		"	点击进入排序和功能编辑"&vbcrlf&_
		"</div>"&vbcrlf&_
		
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
		
		"	$('#linkshow').click(function(){"&vbcrlf&_
		"		$(this).hide();"&vbcrlf&_
		"		$('input#kltool_order,#linkhide,#linkhide2,div.panel').show();"&vbcrlf&_
		" 	});"&vbcrlf&_
		"	$('#linkhide').click(function(){"&vbcrlf&_
		"			$('input#kltool_order,#linkhide2').hide();"&vbcrlf&_
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

sub edtool()
	html=kltool_head("柯林工具箱-功能管理",1)&_
	"<ul class=""breadcrumb"">"&vbcrlf&_
	"	<li><a href=""?siteid="&siteid&""">工具箱</a></li>"&vbcrlf&_
	"	<li>功能管理</li>"&vbcrlf&_
	"</ul>"&vbcrlf
			html=html&"<li class=""list-group-item"">"&vbcrlf&_
			"	<div role=""form"" class=""bs-example bs-example-form"">"&vbcrlf&_
			"		<div class=""form-group input-group"">"&vbcrlf&_
			"			<span class=""input-group-addon"">一级标题</span>"&vbcrlf&_
			"				<textarea class=""form-control"" rows=""2"" name=""t_name0"" id=""t_name0"" placeholder=""""></textarea>"&vbcrlf&_
			"		</div>"&vbcrlf&_
			
			"		<div class=""form-group input-group"">"&vbcrlf&_
			"			<span class=""input-group-addon"">二级标题</span>"&vbcrlf&_
			"				<textarea class=""form-control"" rows=""3"" name=""t_title0"" id=""t_title0"" placeholder=""""></textarea>"&vbcrlf&_
			"		</div>"&vbcrlf&_
			
			"		<div class=""form-group input-group"">"&vbcrlf&_
			"			<span class=""input-group-addon"">三级标题</span>"&vbcrlf&_
			"				<textarea class=""form-control"" rows=""2"" name=""t_content0"" id=""t_content0"" placeholder=""""></textarea>"&vbcrlf&_
			"		</div>"&vbcrlf&_
			
			"		<div class=""form-group"">"&vbcrlf&_
			"			<label for=""t_t0"" class=""col-sm-2 control-label"">启停</label>"&vbcrlf&_
			"			<div>"&vbcrlf&_
			"				<label class=""radio-inline"">"&vbcrlf&_
			"					<input type=""radio"" name=""t_t"&id&""" id=""t_t0""  value=""1"" checked> 启用"&vbcrlf&_
			"				</label>"&vbcrlf&_
			"				<label class=""radio-inline"">"&vbcrlf&_
			"					<input type=""radio"" name=""t_t"&id&""" id=""t_t0""  value=""0""> 停用"&vbcrlf&_
			" 				</label>"&vbcrlf&_
			"			</div>"&vbcrlf&_
			"		</div>"&vbcrlf&_
			
			"		<div class=""form-group"">"&vbcrlf&_
			"			<label for=""t_show0"" class=""col-sm-2 control-label"">显隐</label>"&vbcrlf&_
			"			<div>"&vbcrlf&_
			"				<label class=""radio-inline"">"&vbcrlf&_
			"					<input type=""radio"" name=""t_show0"" id=""t_show0""  value=""1"" checked> 显示"&vbcrlf&_
			"				</label>"&vbcrlf&_
			"				<label class=""radio-inline"">"&vbcrlf&_
			"					<input type=""radio"" name=""t_show0"" id=""t_show0""  value=""0""> 隐藏"&vbcrlf&_
			"				</label>"&vbcrlf&_
			"			</div>"&vbcrlf&_
			"		</div>"&vbcrlf&_
			
			"		<button name=""kltool"" t_id=""0"" type=""button"" class=""btn btn-default btn-block"" id=""tool_set"" data-loading-text=""Loading..."">添加</button>"&vbcrlf&_
			"	</div>"&vbcrlf&_
			"</li>"&vbcrlf
	str=kltool_GetRow("select * from [kltool] order by kltool_order",1,30)
	if str(0) then
		count=str(0)
		pagecount=str(1)
		if page>pagecount then page=pagecount
		html=html&kltool_page(1,count,pagecount,gopage)
		For i=0 To ubound(str(2),2)
			x=page*PageSize+i-PageSize+1
			id=str(2)(0,i)
			name=str(2)(1,i)
			title=str(2)(2,i)
			content=str(2)(3,i)
			t=str(2)(5,i)
			kltool_order=str(2)(4,i)
			kltool_show=str(2)(6,i)
			if t=1 then tstr1="checked" else tstr0="checked"
			if kltool_show then tshow1="checked" else tshow0="checked"
			html=html&"<li class=""list-group-item"">"&vbcrlf&_
			"	<div role=""form"" class=""bs-example bs-example-form"">"&vbcrlf&_
			
			"		<div class=""form-group input-group"">"&vbcrlf&_
			"			<span class=""input-group-addon"">一级标题</span>"&vbcrlf&_
			"				<textarea class=""form-control"" rows=""2"" name=""t_name"&id&""" id=""t_name"&id&""" placeholder="""">"&name&"</textarea>"&vbcrlf&_
			"		</div>"&vbcrlf&_
			
			"		<div class=""form-group input-group"">"&vbcrlf&_
			"			<span class=""input-group-addon"">二级标题</span>"&vbcrlf&_
			"				<textarea class=""form-control"" rows=""3"" name=""t_title"&id&""" id=""t_title"&id&""" placeholder="""">"&title&"</textarea>"&vbcrlf&_
			"		</div>"&vbcrlf&_
			
			"		<div class=""form-group input-group"">"&vbcrlf&_
			"			<span class=""input-group-addon"">三级标题</span>"&vbcrlf&_
			"				<textarea class=""form-control"" rows=""2"" name=""t_content"&id&""" id=""t_content"&id&""" placeholder="""">"&content&"</textarea>"&vbcrlf&_
			"		</div>"&vbcrlf&_
			
			"		<div class=""form-group"">"&vbcrlf&_
			"			<label for=""t_t"&id&""" class=""col-sm-2 control-label"">启停</label>"&vbcrlf&_
			"			<div>"&vbcrlf&_
			"				<label class=""radio-inline"">"&vbcrlf&_
			"					<input type=""radio"" name=""t_t"&id&""" id=""t_t"&id&"""  value=""1"" "&tstr1&"> 启用"&vbcrlf&_
			"				</label>"&vbcrlf&_
			"				<label class=""radio-inline"">"&vbcrlf&_
			"					<input type=""radio"" name=""t_t"&id&""" id=""t_t"&id&"""  value=""0"" "&tstr0&"> 停用"&vbcrlf&_
			" 				</label>"&vbcrlf&_
			"			</div>"&vbcrlf&_
			"		</div>"&vbcrlf&_
			
			"		<div class=""form-group"">"&vbcrlf&_
			"			<label for=""t_show"&id&""" class=""col-sm-2 control-label"">显隐</label>"&vbcrlf&_
			"			<div>"&vbcrlf&_
			"				<label class=""radio-inline"">"&vbcrlf&_
			"					<input type=""radio"" name=""t_show"&id&""" id=""t_show"&id&"""  value=""1"" "&tshow1&"> 显示"&vbcrlf&_
			"				</label>"&vbcrlf&_
			"				<label class=""radio-inline"">"&vbcrlf&_
			"					<input type=""radio"" name=""t_show"&id&""" id=""t_show"&id&"""  value=""0"" "&tshow0&"> 隐藏"&vbcrlf&_
			"				</label>"&vbcrlf&_
			"			</div>"&vbcrlf&_
			"		</div>"&vbcrlf&_
			
			"		<div class=""row"">"&vbcrlf&_
			"			<div class=""col-md-6"">"&vbcrlf&_
			"				<button name=""kltool"" t_id="""&id&""" type=""button"" class=""btn btn-default btn-block"" id=""tool_set"" data-loading-text=""Loading..."">修改</button>"&vbcrlf&_
			"			</div>"&vbcrlf&_
			"			<div class=""col-md-6"">"&vbcrlf&_
			"				<a href=""?action=deltool&t_id="&id&""" id=""tips"" tiptext=""确定要删除吗？"" class=""btn btn-default btn-block"" style=""border-color: #da3131;"">删除</a>"&vbcrlf&_
			"			</div>"&vbcrlf&_
			"		</div>"&vbcrlf&_
			
			"	</div>"&vbcrlf&_
			"</li>"&vbcrlf
		next
		html=html&kltool_page(2,count,pagecount,gopage)
	else
		html=html&"<div class=""alert alert-danger"">暂时没有记录</div>"
	end if
	Response.write kltool_code(html&kltool_end(1))
end sub

sub tool_set()
	t_id=Request.Form("t_id")
	t_name=Request.Form("t_name")
	t_title=Request.Form("t_title")
	t_content=Request.Form("t_content")
	t_t=Request.Form("t_t")
	t_show=Request.Form("t_show")
	set rs=Server.CreateObject("ADODB.Recordset")
	if t_id then
		rs.open "select * from [kltool] where id="&t_id,kltool,1,2
		if rs.bof and rs.eof then
			Response.write "无此id记录"
			Response.End()
		end if
	else
		rs.open "select * from [kltool]",kltool,1,2
		rs.addnew
	end if
	rs("kltool_name")=t_name
	rs("kltool_title")=t_title
	rs("kltool_content")=t_content
	rs("kltool_use")=t_t
	rs("kltool_show")=t_show
	rs.update
	rs.close
	set rs=nothing
	Response.write "操作成功-"&t_name
end sub
sub deltool()
	t_id=Request.QueryString("t_id")
	set rs=Server.CreateObject("ADODB.Recordset")
	rs.open "select * from [kltool] where id="&t_id,kltool,1,2
	if rs.bof and rs.eof then
		Response.write "无此id记录"
		Response.End()
	end if
	rs.delete
	rs.close
	set rs=nothing
	Response.write "删除成功"
end sub
%>