<!--#include file="../inc/config.asp"-->
<!--#include file="Function.asp"-->
<%
call kltool_quanxian
kltool_head("柯林工具箱-远程图片本地化")

if ObjTest("Persits.Jpeg",0)=False then kltool_msge("<div class=""tip"">Asp Jpeg图片处理(图片操作):<br/>"&ObjTest("Persits.Jpeg",1)&"</div>"&vbcrlf)

if ObjTest("Microsoft.XMLHTTP",0)=False then kltool_msge("<div class=""tip"">Http 组件(并非很重要):<br/>"&ObjTest("Microsoft.XMLHTTP",1)&"</div>"&vbcrlf)

%>
        <style> 
        .black_overlay{ 
            display: none;
            position: fixed; 
            top: 0%; 
            left: 0%; 
            width: 100%; 
            height: 100%; 
            background-color: black; 
            z-index:1001; 
            -moz-opacity: 0.8; 
            opacity:.30; 
            filter: alpha(opacity=88); 
        } 
        .white_content { 
            display: none;
            position: fixed;
            border-radius: 15px;
            margin:0 auto;
            top: 5%; 
            left: 5%; 
            width: 80%;
            height: 80%; 
            padding: 15px; 
            border: 3px solid green; 
            background-color: white; 
            z-index:1002; 
            overflow: auto; 
        }
    </style>
<%
pg=request("pg")
if pg="" then
	set rs=server.CreateObject("adodb.recordset")
	rs.open "select * from [wap_picture] where userid="&siteid&" order by id desc",conn,1,1
	If Not rs.eof Then
	gopage="?"
	Count=rs.recordcount
	pagecount=(count+pagesize-1)\pagesize
	if page>pagecount then page=pagecount
	rs.move(pagesize*(page-1))
	call kltool_page(1)
	For i=1 To PageSize
	If rs.eof Then Exit For
	if (i mod 2)=0 then Response.write "<div class=line1>" else Response.write "<div class=line2>"
	%>
	<%=rs("id")%>
	<a href="javascript:void(0)" onclick="document.getElementById('light<%=rs("id")%>').style.display='block';document.getElementById('fade<%=rs("id")%>').style.display='block';return ajaxQuerySetDom('<%=rs("id")%>','../inc/key.asp?action=picture&','q','result<%=rs("id")%>');"><%=rs("book_title")%></a>
	<div id="fade<%=rs("id")%>" class="black_overlay" onclick ="document.getElementById('light<%=rs("id")%>').style.display='none';document.getElementById('fade<%=rs("id")%>').style.display='none'"></div>
	<div id="light<%=rs("id")%>" class="white_content">
	<br/><span id="result<%=rs("id")%>">载入中…</span>
	</div>
	<%

	%>
	<span class="right"><a href="?pg=yes&id=<%=rs("id")%>&page=<%=page%>">
	<%if instr(rs("book_img"),"http://")>0 then Response.write"A"
	if instr(rs("book_file"),"http://")>0 then Response.write"B"
	%>
	</a></span>
	</div>
	<%
	rs.movenext
	Next
	call kltool_page(2)
	else
	Response.write "<div class=tip>暂时没有记录！</div>"
	end if
	rs.close
	set rs=nothing

'-------------------------------------------
elseif pg="yes" then
	Server.ScriptTimeOut = 9999
	id=request("id")
	'----路径
	pic_path1="/picture/"
	pic_path2="upload/"&siteid&"/"&year(now)&"/"&month(now)&"/"&day(now)&"/"&id&"/"
	'----路径创建
	call Create_Folder(pic_path1&pic_path2)

	set rs=server.CreateObject("adodb.recordset")
	rs.open "select * from [wap_picture] where id="&id,conn,1,1
	If Not rs.eof Then
	picfile=rs("book_file")

	'-----图片组本地化
		picstr = Split(picfile,"|")
		for i=0 to ubound(picstr)
	if instr(picstr(i),"http")>0 then
		picfileNameSplit = Split(picstr(i),"/")
		picName = picfileNameSplit(Ubound(picfileNameSplit))
		call downFile(picstr(i),pic_path1&pic_path2)
		piccontent=replace(rs("book_file"),picstr(i),pic_path2&picName)
		conn.execute("UPDATE [wap_picture] SET book_file='"&piccontent&"' where id="&id)
	end if
		next
	picimg=rs("book_img")
		if picimg="" then picimg=picstr(0) else picimg=picstr(1)
		'----缩略图本地化
		if instr(picimg,"http")>0 then call downFile(picimg,pic_path1&pic_path2)
		'----文件名获取
			fileNameSplit = Split(picimg,"/")
			fileName = fileNameSplit(Ubound(fileNameSplit))
		'----缩略图缩放
		call CreatePic(pic_path1&pic_path2&fileName,pic_path1&pic_path2&"s_"&fileName)
		'----缩略图数据修改
		conn.execute("UPDATE [wap_picture] SET book_img='"&pic_path2&"s_"&fileName&"' where id="&id)
		end if
	rs.close
	set rs=nothing
	Response.write "<div class=tip>成功本地化图片</div>"
end if
call kltool_end
%>