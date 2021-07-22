<!--#include file="config.asp"-->
<%
kltool_admin(1)
action=Request.QueryString("action")
select case action
	case ""
		call index()
	case "add"
		call add()
	case "del"
		call del()
end select

sub index()
	html=kltool_head("权限管理",1)&vbcrlf&_
	"<li class=""list-group-item"">"&vbcrlf&_
	"	<div class=""form-group"">"&vbcrlf&_
	"		<label for=""r_search"">输入用户ID</label><br>"&vbcrlf&_
	"	</div>"&vbcrlf&_
	"	<div class=""form-inline"" role=""form"">"&vbcrlf&_
	"		<input name=""siteid"" type=""hidden"" value="""&siteid&""">"&vbcrlf&_
	"		<div class=""row"">"&vbcrlf&_
	"			<div class=""col-lg-6"">"&vbcrlf&_
	"				<div class=""input-group col-xs-8"">"&vbcrlf&_
	"					<input name=""r_search"" id=""r_search"" type=""text"" value="""" placeholder=""输入用户ID"" class=""form-control"">"&vbcrlf&_
	"					<span class=""input-group-btn"">"&vbcrlf&_
	"						<button class=""btn btn-default"" type=""submit"" id=""maddid"">"&vbcrlf&_
	"						添加!"&vbcrlf&_
	"						</button>"&vbcrlf&_
	"					</span>"&vbcrlf&_
	"				</div>"&vbcrlf&_
	"			</div>"&vbcrlf&_
	"		</div>"&vbcrlf&_
	"	</div>"&vbcrlf&_
	"</li>"&vbcrlf

	set rs=server.CreateObject("adodb.recordset")
	rs.open "select * from [quanxian]",kltool,1,1
	If Not rs.eof Then
		gopage="?"
		Count=rs.recordcount
		pagecount=(count+pagesize-1)\pagesize	
		if page>pagecount then page=pagecount
		rs.move(pagesize*(page-1))
	
		For i=1 To PageSize 
		If rs.eof Then Exit For
		
		html=html&"<div class=""media list-group-item"">"&vbcrlf&_
		  "<div class=""media-left media-middle"">"&vbcrlf&_
			kltool_get_userheadimg(rs("userid"),1)&vbcrlf&_
		 " </div>"&vbcrlf&_
		 " <div class=""media-body"">"&vbcrlf&_
		"	<h4 class=""media-heading"">"&vbcrlf&_
		"	 <a href=""/bbs/userinfo.aspx?siteid="&siteid&"&touserid="&rs("userid")&""" class=""Nick"" id="""&rs("userid")&""">"&kltool_get_usernickname(rs("userid"),1)&"</a>"&vbcrlf&_
		"	 (ID:<a href=""UserData.asp?siteid="&siteid&"&uid="&rs("userid")&""">"&rs("userid")&"</a>)"&vbcrlf&_
		"	 </h4>"&vbcrlf&_
		"	<h5>"&vbcrlf&_
		"	 <a class=""DelId2"" id="""&rs("userid")&""" tiptext=""删除ID"&rs("userid")&""">删除</a>"&vbcrlf&_
		"	</h5>"&vbcrlf&_
		 " </div>"&vbcrlf&_
		"</div>"&vbcrlf
		
	rs.movenext
		Next
	Response.write"</table>"
	
	else
	   Response.write "<div class=tip>暂时没有记录！</div>"
	end if
	rs.close
	set rs=nothing
	
	Response.write kltool_code(html&kltool_end(1))
end sub
sub add()
	uid=Request.Form("uid")
	if not Isnumeric(uid) then
		response.write "id必须是数字"
		response.end
	end if
	set rs=conn.execute("select userid from [user] where siteid="&siteid&" and userid="&uid)
	if rs.eof then
		response.write "此id不存在"
	rs.close
	set rs=nothing
		response.end
	end if
	set rs=server.CreateObject("adodb.recordset")
	rs.open "select * from [quanxian] where userid="&uid,kltool,1,2
	if not rs.eof then
		response.write "此id已存在"
		response.end
	else
		rs.addnew
		rs("userid")=uid
		rs.update
		rs.close
		set rs=nothing
	end if
	response.write "添加成功"
end sub
sub del()
	uid=Request.Form("uid")
	if clng(uid)=clng(siteid) or clng(uid)=1000 then 
		response.write "保护ID 无法删除"
		response.end
	end if
	set rs=Server.CreateObject("ADODB.Recordset")
	rs.open "select * from [quanxian] where userid="&uid,kltool,1,2
	if rs.bof and rs.eof then
		response.write "无此id记录"
		response.end
	else
		rs.delete
	rs.close
	set rs=nothing
	end if
	response.write "删除成功"
end sub
%>