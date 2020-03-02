<!--#include file="./inc/head.asp"-->
<title>数据库在线备份还原</title>
<%call kltool_quanxian
set rs=server.CreateObject("adodb.recordset")
rs.open "select * from [yanzheng]",kltool,1,1
If not rs.eof Then mydb=rs("mydb")
rs.close
set rs=nothing
filepath=kltool_path&mydb&"/"
call Create_Folder(filepath)
filename=year(now())&"-"&month(now())&"-"&day(now())&"-"&hour(now())&"-"&minute(now())&"-"&second(now())&".bak"
pg=request("pg")
if pg="" then
%>
<title>数据库在线备份</title>
<div class="line2">请填写信息</div>
<div class="content">
过大的数据库备份有可能超时，建议在访问量少的时候操作<br/>
<form method="post" action="?">
<input name="siteid" type="hidden" value="<%=siteid%>">
<input name="pg" type="hidden" value="yes">
填写备份数据库位置及文件名：<a href="?siteid=<%=siteid%>&pg=mydb">配置文件夹</a><br/>
<textarea name="dbpath" rows="5" type="text"><%=filepath&filename%></textarea><br/>
<input type="submit" class="btn" value="开始备份" onClick="ConfirmDel('是否确定？');return false">
</form>
</div>
<div class="tip">已备份的数据(<%=filepath%>)</div>
<%
Set fso = Server.CreateObject("Scripting.FileSystemObject")
Set fileobj = fso.GetFolder(server.mappath(filepath))
Set fsofolders = fileobj.SubFolders
Set fsofile = fileobj.Files

For Each folder in fsofolders
   response.Write"<div class='line1'>文件夹:"&folder.name&"("&mysize(folder.size)&")<br/>"&folder.datelastmodified&" <a href=""?siteid="&siteid&"&amp;db1="&folder.name&"&pg=scdb"" onClick=""ConfirmDel('是否确定？');return false"">del</a></div>"
Next 

For Each file in fsofile
   response.Write"<div class='line1'>"&file.name&"("&mysize(file.size)&")<br/>"&file.datelastmodified&" <a href=""?siteid="&siteid&"&amp;db2="&file.name&"&pg=scdb"" onClick=""ConfirmDel('是否确定？');return false"">del</a></div>"
Next
Set fso = nothing
'------------------------------
elseif pg="scdb" then
	Set fso = CreateObject("Scripting.FileSystemObject")
If Request("db1")<>"" then
	db1=filepath&Request("db1")
	if not fso.FolderExists(Server.mappath(db1)) Then
	Response.Write"<div class='tip'>没有找到该文件夹</div>"
	Else
	fso.DeleteFolder(Server.mappath(db1))
	if Err.number<>0 then 
	Err.Clear()
	response.write"<div class='tip'>删除文件夹失败，可能权限不足</div>"
	else
	Response.Write"<div class='tip'>成功删除"&Request("db1")&"</div>"
	call kltool_write_log("(数据库)删除文件夹："&Request("db1"))
	end if
	end if
elseif Request("db2")<>"" then
	db2=filepath&Request("db2")
	if not fso.FileExists(Server.mappath(db2)) Then
	Response.Write"<div class='tip'>没有找到该文件</div>"
	Else
	fso.DeleteFile(Server.mappath(db2))
	if Err.number<>0 then 
	Err.Clear()
	response.write"<div class='tip'>删除文件失败，可能权限不足</div>"
	else
	Response.Write"<div class='tip'>成功删除"&Request("db2")&"</div>"
	call kltool_write_log("(数据库)删除文件："&Request("db2"))
	end if
	end if

	Set fso = nothing
end if
'''''''''''''''''''''''''''''''''''
elseif pg="mydb" then%>
<div class="content">
<form method="post" action="?">
<input name="siteid" type="hidden" value="<%=siteid%>">
<input name="pg" type="hidden" value="mydb1">
填写备份数据库位置(此处填写的路径为工具箱内路径)：<a href="?siteid=<%=siteid%>">返回备份</a><br/>
<textarea name="db1" rows="5" type="text" style="width:100%"><%=mydb%></textarea><br/>
<input type="submit" class="btn" value="确定" onClick="ConfirmDel('是否确定？');return false">
</form>
</div>
<% elseif pg="mydb1" then
db1=request("db1")
set rs=server.CreateObject("adodb.recordset")
rs.open "select * from [yanzheng] where id=1",kltool,1,2
rs("mydb")=db1
rs.update
rs.close
set rs=nothing
call kltool_write_log("(数据库)修改备份文件夹："&db1)
response.redirect "?siteid="&siteid&"&pg=mydb"
''''''''''''''''''''''''''''''''
elseif pg="yes" then
        dbpath = trim(Request.Form("dbpath"))
        If dbpath <> "" Then
'检测文件夹是否存在
db=Left(dbpath,InStrRev(dbpath,"/"))
call Create_Folder(db)
            Set fso = CreateObject("Scripting.FileSystemObject")
            If fso.FileExists(Server.MapPath(dbpath)) Then
                Response.Write "<div class=tip>该命名的备份数据库已经存在，请删除或更换备份文件名进行备份</div>"
            Else
                Response.Write "<div class=content>正在备份到:"&dbpath&"<br/>"
				Response.Write "完整路径："&Server.MapPath(dbpath)&"<br>"
				Response.Write "请稍候...&nbsp;<br/>备份时间按数据库大小决定</div>"
                Response.Flush
                dim srv,bak
                server.ScriptTimeout = 3600
                Set srv=Server.CreateObject("SQLDMO.SQLServer")
                srv.LoginTimeout = 3600
                srv.Connect KL_SQL_SERVERIP,KL_SQL_UserName,KL_SQL_PassWord
                Set bak = Server.CreateObject("SQLDMO.Backup")
                bak.Database=KL_Main_DatabaseName
                bak.Devices=Files
                bak.Files=Server.MapPath(dbpath)
                bak.SQLBackup srv
                if err.number>0 then
                    response.write err.number&"<font color=""red""><br>"
                    response.write err.description&"</font>"
                else
                    Response.Write "<div class=tip>你的数据库已经备份成功</div>"
                end if
            End If
        End If
Set fso = nothing
call kltool_write_log("(数据库)备份数据库："&dbpath)
'---------------------------------
elseif pg="hy" then
%>
<title>数据库在线还原</title>
<div class="line2">请填写信息</div>
<div class="content">
过大的数据库还原有可能超时，建议在访问量少的时候操作<br/>还原路径应该是你数据库服务器的路径<br/>
<form method="post" action='?siteid=<%=siteid%>'>
<input name="pg" type="hidden" value="yes1" />
还原数据库位置及文件名：<br/>
<textarea name="dbpath" rows="5" type="text" style="width:100%"><%=filepath&filename%></textarea><br/>
<input type="submit" value="开始还原" onClick="ConfirmDel('是否确定？');return false">
</form><br/>请确定文件存在
</div>

<% elseif pg="yes1" then
        dbpath = trim(Request.Form("dbpath"))
        If dbpath <> "" Then
            Set fso = CreateObject("Scripting.FileSystemObject")
            If not fso.FileExists(Server.MapPath(dbPath)) Then
                Response.Write "<br>没有找到该数据库的备份文件,检查数据库路径或名称输入是否有误!(注意路径为数据库服务器的路径)"
            Else
                Response.Write "<br><br>正在从"&Server.MapPath(dbPath)&"还原,请稍候...&nbsp;还原时间按数据库大小决定<br><br>"
                Response.Flush
                server.ScriptTimeout = 3600
                Set srv=Server.CreateObject("SQLDMO.SQLServer")
                srv.LoginTimeout = 3600
                srv.Connect KL_SQL_SERVERIP,KL_SQL_UserName,KL_SQL_PassWord
                Set bak = Server.CreateObject("SQLDMO.Restore")
                bak.Action=0
                bak.Database=KL_Main_DatabaseName
                bak.Devices=Files
                bak.Files=Server.MapPath(dbpath)
                bak.ReplaceDatabase=True
                bak.SQLRestore srv
                if err.number<>0 then
                    response.write "<font color=""red"">错误："&err.number&"<br>"
                    response.write err.description
					response.write "</font>"
                else
                    Response.Write "你的数据库还原成功"
                end if
            End If
        End If
end if
call kltool_end
%>
