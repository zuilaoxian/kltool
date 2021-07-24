<!--#include file="config.asp"-->
<%
kltool_use(20)
kltool_admin(1)
action=Request.QueryString("action")
filename=year(now)&Right("0"&month(now),2)&Right("0"&day(now),2)&Right("0"&hour(now),2)&Right("0"&minute(now),2)&Right("0"&second(now),2)&".bak"
filepath=kltool_path&"backup/"
'sa密码
bdbpass="OWAXAR8JWSe2i910evto706"

select case action
	case ""
		call index()
	case "backup"
		call backup()
	case "restore"
		call restore()
	case "deldata"
		call deldata()
end select

sub index()
	html=kltool_head("数据库备份与恢复",1)&vbcrlf&_
	"<div role=""form"">"&vbcrlf&_
	"	1.过大的数据库备份有可能超时<br/>"&vbcrlf&_
	"	2.建议在访问量少的时候操作<br/>"&vbcrlf&_
	"	3.恢复备份需要sa权限，先打开此文件修改sa密码<br/>"&vbcrlf&_
	"	<button type=""button"" name=""backup"" class=""btn btn-default btn-block "" id=""backup"" data-loading-text=""Loading..."">立刻备份</button>"&vbcrlf&_
	"</div>"&vbcrlf&_
	"<div class=""content"">"&vbcrlf
	Set fso = Server.CreateObject("Scripting.FileSystemObject")
	If not fso.folderExists(server.mappath(filepath)) Then
		html=html&"<div class='list-group-item'>文件夹"&filepath&"不存在，首次备份将自动创建</div>"&vbcrlf
	else
		Set fileobj = fso.GetFolder(server.mappath(filepath))
		Set fsofolders = fileobj.SubFolders
		Set fsofile = fileobj.Files
		For Each file in fsofile
		   html=html&"	<li class=""list-group-item"">"&vbcrlf&_
		   "		<big><strong>"&file.name&"</strong></big>("&int(file.size/1024000)&"M)<br/>"&vbcrlf&_
		   "		"&file.datelastmodified&vbcrlf&_
		   "		<a dbname="""&file.name&""" id=""deldata"" name=""deldata"" tiptext=""删除"&file.name&""">删除</a>"&vbcrlf&_
		   "		<a dbname="""&file.name&""" id=""restore"" name=""restore"" tiptext=""恢复备份"&file.name&""" data-loading-text=""恢复中..."">恢复</a>"&vbcrlf&_
		   "	</li>"&vbcrlf
		Next
		
	end if
	html=html&"<div>"&vbcrlf
	Set fso = nothing
	Response.write kltool_code(html&kltool_end(1))
end sub

sub backup()
	dbpath=filepath&filename
	On Error Resume Next
	If filepath <> "" Then
		Set fso = CreateObject("Scripting.FileSystemObject")
		'检测文件夹是否存在,不存在则创建
		If not fso.folderExists(server.mappath(filepath)) Then fso.CreateFolder server.mappath(filepath)
		'检测文件是否存在,存在则不备份
		If fso.FileExists(Server.MapPath(dbpath)) Then
			Response.Write "该命名的备份已存在，请删除或重命名"
		Else
			SQL="backup database "&KL_Main_DatabaseName&" to disk='"&Server.MapPath(dbpath)&"'"
			conn.execute(SQL)
			if err<>0 then
			   response.write "错误,数据备份失败"
			else
			   response.write "数据备份成功！"
			end if
		End If
		Set fso = nothing
	Else
		Response.Write "错误，备份文件夹为空"
	End If
end sub

sub restore()
	dbname=Request.QueryString("dbname")
	dbpath=filepath&dbname
	if dbname="" then
		response.write "错误的备份文件"
		response.end
	end if
	Set fso = CreateObject("Scripting.FileSystemObject")
	If not fso.FileExists(Server.MapPath(dbpath)) Then
			Response.Write "备份不存在"
		Else
		On Error Resume Next
			set cnn=Server.createobject("adodb.connection")
			cnn.open "PROVIDER=SQLOLEDB;DATA SOURCE="&KL_SQL_SERVERIP&";UID=sa;PWD="&bdbpass
			if err<>0 then
				response.write "错误，无法登陆sa，请检查密码"
				response.end
			end if
			cnn.execute("ALTER DATABASE "&KL_Main_DatabaseName&" SET OFFLINE WITH ROLLBACK IMMEDIATE")
			cnn.execute("Restore database "&KL_Main_DatabaseName&" from disk='"&Server.MapPath(dbpath)&"'")
			cnn.execute("ALTER database "&KL_Main_DatabaseName&" set online")
			'修复文件所有者发生变化导致无法访问数据
			cnn.execute("use "&KL_Main_DatabaseName&"	execute Sp_changedbowner '"&KL_SQL_UserName&"',true")
			if err<>0 then
			   response.write "错误,数据恢复失败"
			else
			   response.write "数据恢复成功！"
			end if
	End If
	Set fso = nothing
end sub

sub deldata()
	dbname=Request.QueryString("dbname")
	dbpath=filepath&dbname
	if dbname="" then
		response.write "错误的备份文件"
		response.end
	end if
	Set fso = CreateObject("Scripting.FileSystemObject")
	If not fso.FileExists(Server.MapPath(dbpath)) Then
		Response.Write "备份不存在"
	Else
	On Error Resume Next
		fso.DeleteFile(Server.mappath(dbpath))
		if err<>0 then
		   response.write "错误,备份删除失败"
		else
		   response.write "备份删除成功！"
		end if
	End If
	Set fso = nothing
end sub 

%>
