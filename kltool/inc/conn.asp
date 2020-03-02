<%
kltool_execution_startime=timer()
'-----数据库连接
klmdb=kltool_path&"datakltool/#kltool.mdb"
set fso = server.CreateObject("Scripting.FileSystemObject")
if not fso.FileExists(server.mappath(klmdb)) then call kltool_err_msg("not find DB file !\n柯林工具箱数据文件不存在")
set fso=nothing
connstr="DBQ="+klmdb+";DefaultDir=;DRIVER={Microsoft Access Driver (*.mdb)};"
connstr="provider=microsoft.jet.oledb.4.0;data source="&server.mappath(klmdb)
Set kltool = Server.CreateObject("ADODB.Connection") 
kltool.open connstr
If Err Then 
err.Clear 
Set kltool = Nothing 
call kltool_err_msg("DBQ ERROR !\n数据库错误")
end if
%>