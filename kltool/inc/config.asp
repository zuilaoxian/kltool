﻿<%
kltool_execution_startime=timer()
On Error Resume Next

if ObjTest("Scripting.FileSystemObject",0)=False then
	kltool_msg("<div class=""tip"">FSO文件系统(文件操作):<br/>"&ObjTest("Scripting.FileSystemObject",1)&"</div>"&vbcrlf)
	Response.End()
end if

if ObjTest("adodb.recordset",0)=False then
	kltool_msg("<div class=""tip"">adodb系统,数据库操作:<br/>"&ObjTest("Scripting.FileSystemObject",1)&"</div>"&vbcrlf)
	Response.End()
end if

'-----连接工具箱数据库
'数据库文件
klmdb=kltool_path&"datakltool/#kltool.mdb"
'检测工具箱数据库是否存在
set fso = server.CreateObject("Scripting.FileSystemObject")
if not fso.FileExists(server.mappath(klmdb)) then
	kltool_msg("not find DB file !\n柯林工具箱数据文件不存在<br/>"&klmdb)
	Response.End()
end if
set fso=nothing
'连接数据库
'connstr="DBQ="+server.mappath(klmdb)+";DefaultDir=;DRIVER={Microsoft Access Driver (*.mdb)};"
connstr="provider=microsoft.jet.oledb.4.0;data source="&server.mappath(klmdb)
Set kltool = Server.CreateObject("ADODB.Connection") 
kltool.open connstr
If Err Then
	Err.Clear
	kltool_msge("DBQ ERROR ! 工具箱数据库错误")
	Response.End()
end if
sub closekltool()
	 kltool.close
	 set kltool=nothing
end sub

''''''''''''''''''''''''读柯林数据库配置文件'''''''''''''''''''''''
dim SourceFile
SourceFile = Server.MapPath("/")  
SourceFile=SourceFile&"\web.config"


Const ForReading = 1, ForWriting = 2 
Dim objFSO
Set objFSO=Server.CreateObject("Scripting.FileSystemObject")
Dim f, content 
Set f = objFSO.OpenTextFile(SourceFile, ForReading) 
content = f.ReadAll()
f.Close 
content=replace(content,chr(34),"")
content=replace(content,chr(32),"")
dim s1,o1,KL_Main_DatabaseName,KL_SQL_SERVERIP,KL_SQL_UserName,KL_SQL_PassWord

s1=InStr(content, "KL_DatabaseNamevalue=")
o1 = InStr(s1, content, "/>")
KL_Main_DatabaseName = Mid(content, s1 + 21, o1 - s1 - 21)

s1=InStr(content, "KL_SQL_UserNamevalue=")
o1 = InStr(s1, content, "/>")
KL_SQL_UserName = Mid(content, s1 + 21, o1 - s1 - 21)
s1=InStr(content, "KL_SQL_PassWordvalue=")
o1 = InStr(s1, content, "/>")
KL_SQL_PassWord = Mid(content, s1 + 21, o1 - s1 - 21)

s1=InStr(content, "KL_SQL_SERVERIPvalue=")
o1 = InStr(s1, content, "/>")
KL_SQL_SERVERIP = Mid(content, s1 + 21, o1 - s1 - 21)

set conn=Server.CreateObject("ADODB.Connection")
'conn.open "driver={SQL Server};database="&KL_Main_DatabaseName&";Server="&KL_SQL_SERVERIP&";uid="&KL_SQL_UserName&";pwd="&KL_SQL_PassWord 
conn.open "PROVIDER=SQLOLEDB;DATA SOURCE="&KL_SQL_SERVERIP&";UID="&KL_SQL_UserName&";PWD="&KL_SQL_PassWord&";DATABASE="&KL_Main_DatabaseName
if Err then
   Err.Clear
   kltool_msg("kelink数据库连接错误")
   Response.End()
End if
'关数据库
sub closeConn()
	 conn.close
	 set conn=nothing
end sub
''''''''''''''''''''''''读柯林数据库配置结束'''''''''''''''''''''''
%>
<!--#include file="cookies.asp"--><!--#include file="md5.asp"-->
<%
'-----读会员数据
if siteid="" then siteid=1000
if userid="" then userid=0
if userid=0 then Response.redirect"/waplogin.aspx?siteid="&siteid
userid=clng(userid)
siteid=clng(siteid)
	set siters=conn.execute("select username,nickname,password,managerlvl,money,moneyname,logintimes,lockuser,sessiontimeout,endtime,SidTimeOut,mybankmoney,mybanktime,DATEDIFF(dd, mybanktime, GETDATE())  as dtimes,expR,RMB from [user] where  userid="&userid &" and siteid="&siteid)	
	if not siters.eof then      	
		getusername=siters("username")
		nickname=siters("nickname")
		password=siters("password")
		managerlvl=clng(siters("managerlvl"))
		money=cdbl(siters("money"))
		moneyname=siters("moneyname")	'勋章
		logintimes=cdbl(siters("logintimes"))
		lockuser=clng(siters("lockuser"))
		sessiontimeout=clng(siters("sessiontimeout")) ' 会员身份
		endtime=siters("endTime")	'过期时间
		SidTimeOut=siters("SidTimeOut")       
		mybankmoney=cdbl(siters("mybankmoney"))
		mybanktime=siters("mybanktime")
		dtimes=siters("dtimes") 
		expR=siters("expR")
		RMB=Round(siters("RMB"),2)
		if isNull(dtimes) then dtimes=0 end if
      end if
	siters.close()
	set siters=nothing
'-----查询部分设置
set rs=server.CreateObject("adodb.recordset")
rs.open "select * from [yanzheng] where id=1",kltool,1,1
If not rs.eof then
kltool_yanzheng=rs("yanzheng")
kltool_admintimes=rs("timelong")
kltool_listsize=rs("listsize")
kltool_listsize2=rs("listsize2")
end if
rs.close
set rs=nothing
'-----取币名
set rs=conn.execute("select * from [user] where userid="&siteid)
	sitemoneyname=rs("sitemoneyname")
rs.close
set rs=nothing
'-----
dim pagesize,page
pagesize=15
if Request.QueryString("pagesize") then
	if Isnumeric(Request.QueryString("pagesize")) then
		if  Request.QueryString("pagesize")>0 then pagesize=int(Request.QueryString("pagesize"))
	end if
end if
page=1
if Request.QueryString("page") then
	if Isnumeric(Request.QueryString("page")) then
		if  Request.QueryString("page")>0 then page=int(Request.QueryString("page"))
	end if
end if
if page<=0 or page="" then page=1	
if pagesize<=0 or pagesize="" then pagesize=15

'-----顶部左上角logo
kltool_logo=""&kltool_path&"inc/2017-1-20.png"
'-----顶部左上角logo-普通会员显示
if kltool_yunxu<>1 then kltool_logo=""&kltool_path&"inc/2017-1-20.png"

'-----管理员操作日志【删除】开关，1允许，其他否(默认其他，推荐其他)
kltool_admin_log_del=2

'-----防止部分空间未登录也可以看到页面
if not kltool_login then
	kltool_msge("没有登录的你\n看不到我")
	Response.End()
end if
%>
<!--#include file="function.asp"-->