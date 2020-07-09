<%
kltool_execution_startime=timer()
'On Error Resume Next
'-----设置每页条数和页数
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

'-----管理员操作日志【删除】开关，1允许，其他否(默认其他，推荐其他)
kltool_admin_log_del=2
'-----
if ObjTest("Scripting.FileSystemObject",0)=False then
	Response.write kltool_code(kltool_head("FSO文件系统不支持",0)&kltool_alert("FSO文件系统(文件操作):<br/>"&ObjTest("Scripting.FileSystemObject",1))&kltool_end(0))
	Response.End()
end if

if ObjTest("adodb.recordset",0)=False then
	Response.write kltool_code(kltool_head("adodb系统不支持",0)&kltool_alert("adodb系统,数据库操作:<br/>"&ObjTest("adodb.recordset",1))&kltool_end(0))
	Response.End()
end if

'-----连接工具箱数据库
'数据库文件
klmdb=kltool_path&"datakltool/#kltool.mdb"
'检测工具箱数据库是否存在
set fso = server.CreateObject("Scripting.FileSystemObject")
if not fso.FileExists(server.mappath(klmdb)) then
	Response.write kltool_code(kltool_head("柯林工具箱数据文件不存在",0)&kltool_alert("柯林工具箱数据文件不存在")&kltool_end(0))
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
	Response.write kltool_code(kltool_head("工具箱数据库错误",0)&kltool_alert("工具箱数据库错误")&kltool_end(0))
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
	Response.write kltool_code(kltool_head("kelink数据库连接错误",0)&kltool_alert("kelink数据库连接错误")&kltool_end(0))
   Response.End()
End if
'关数据库
sub closeConn()
	 conn.close
	 set conn=nothing
end sub
''''''''''''''''''''''''读柯林数据库配置结束'''''''''''''''''''''''
%>
<!--#include file="class/cookies.asp"-->
<!--#include file="class/md5.asp"-->
<!--#include file="class/kltool_rndnick_s.asp"-->
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
		if isNull(dtimes) then dtimes=0
      end if
	siters.close()
	set siters=nothing
'-----取币名
set rs=conn.execute("select * from [user] where userid="&siteid)
	sitemoneyname=rs("sitemoneyname")
rs.close
set rs=nothing
'-----工具箱权限判断
Function kltool_admin(kltool_admin_str)
	set adminrs=server.CreateObject("adodb.recordset")
	adminrs.open "select top 1 userid from [quanxian]",kltool,1,1
		If not adminrs.eof then
			kltool_admin_userid="|"&adminrs("userid")&"|"
			kltool_userid="|"&userid&"|"
			if instr(kltool_admin_userid,kltool_userid) then
				kltool_admin=true
			else
				kltool_admin=False
			end if
		end if
	adminrs.close
	set adminrs=nothing
	if kltool_admin_str>0 and not kltool_admin then
		Response.write kltool_code(kltool_head("没有权限",0)&kltool_alert("没有权限")&kltool_end(0))
		Response.End()
	end if
End Function
'-----工具开关判断
Function kltool_use(kltool_use_id)
	set kltool_use_rs=server.CreateObject("adodb.recordset")
	kltool_use_rs.open "select kltool_use from [kltool] where id="&kltool_use_id,kltool,1,1
		If not kltool_use_rs.eof then
			if kltool_use_rs("kltool_use")=0 then
				Response.write kltool_code(kltool_head("本插件状态为停用",0)&kltool_alert("本插件状态为停用")&kltool_end(0))
				Response.End()
			end if
		end if
	kltool_use_rs.close
	set kltool_use_rs=nothing

End Function
'-----数据表检测
Function kltool_sql(str)
	On Error Resume Next
	set kltool_sql_rs=conn.execute("select * from "&str)
	If Err Then 
		err.Clear
		Response.write kltool_code(kltool_head("请等待管理员配置此功能",0)&kltool_alert("请等待管理员配置此功能")&kltool_end(0))
		Response.End()
	end if
	kltool_sql_rs.close
	set kltool_sql_rs=nothing
End Function

'-----路径检测，常量无法赋值，以此来实现无限级目录
Function kltool_path
	kltool_path=Lcase(Left(Request.ServerVariables("script_name"),InStrRev(Request.ServerVariables("script_name"),"/")))
	kltool_folder=array("bbs","cdk","redbag","picture","svip","vip","headimg")
	str1=split(kltool_path,"/")
	str2=str1(ubound(str1)-1)
	for each ipath in kltool_folder
		if ipath=str2 then
			kltool_path=left(kltool_path,InStrRev(kltool_path,ipath)-1)
			exit for
		end if
	next
end function
'-----提醒
function kltool_alert(kltool_alert_str)
	kltool_alert=vbcrlf&kltool_alert&"<script>"&vbcrlf&_
	"$(function(){"&vbcrlf&_
	"	layer.alert('"&kltool_alert_str&"',{shadeClose:true,title:''});"&vbcrlf&_
	"});"&vbcrlf&_
	"</script>"&vbcrlf
End function
'-----顶部内容
function kltool_head(head_str1,head_str2)
	kltool_head="<!DOCTYPE html><html>"&vbcrlf&_
	"<head>"&_
	"<meta http-equiv=""Content-Type"" content=""application/xhtml+xml; charset=utf-8""/>"&vbcrlf&_
	"<meta http-equiv=""Cache-Control"" content=""max-age=0""/>"&vbcrlf&_
	"<meta name=""viewport"" content=""width=device-width,initial-scale=1.0, minimum-scale=1.0, maximum-scale=0"">"&vbcrlf&_
	"<link rel=""stylesheet"" href=""[kltool_path]class/bootstrap-3.4.1/css/bootstrap.min.css"">"&vbcrlf&_
	"<script src=""[kltool_path]class/jquery.min.1.12.3.js""></script>"&vbcrlf&_
	"<script src=""[kltool_path]class/bootstrap-3.4.1/js/bootstrap.min.js""></script>"&vbcrlf&_
	"<script src=""[kltool_path]class/layer-v3.1.1/layer.js"" type=""text/javascript""></script>"&vbcrlf&_
	"<script src=""[kltool_path]class/kltool.js"" type=""text/javascript""></script>"&vbcrlf&_
	"<title>"& head_str1 &"</title>"&vbcrlf&_
	"</head>"&vbcrlf&_
	"<body>"&vbcrlf
		if head_str2>0 then
			if kltool_admin(0) then
				homelink="[kltool_path]"
				hometext="柯林工具箱"
			else
				homelink="/"
				hometext="Kelink"
			end if
			kltool_head=kltool_head&"<nav class=""navbar navbar-default"" role=""navigation"">"&vbcrlf&_
			"	<div class=""container-fluid"">"&vbcrlf&_
			"	<div class=""navbar-header"">"&vbcrlf&_
			"		<button type=""button"" class=""navbar-toggle"" data-toggle=""collapse"""&vbcrlf&_
			"				data-target=""#example-navbar-collapse"">"&vbcrlf&_
			"			<span class=""sr-only"">切换导航</span>"&vbcrlf&_
			"			<span class=""icon-bar""></span>"&vbcrlf&_
			"			<span class=""icon-bar""></span>"&vbcrlf&_
			"			<span class=""icon-bar""></span>"&vbcrlf&_
			"		</button>"&vbcrlf&_
			"		<a class=""navbar-brand"" href="""&homelink&""">"&hometext&"</a>"&vbcrlf&_
			"	</div>"&vbcrlf&_
			"	<div class=""collapse navbar-collapse"" id=""example-navbar-collapse"">"&vbcrlf&_
			"		<ul class=""nav navbar-nav"">"&vbcrlf&_
			"			<li class=""active""><a href=""/myfile.aspx?siteid="&siteid&"""><span class=""glyphicon glyphicon-user""></span> "&kltool_get_usernickname(userid,1)&"("&userid&")</a></li>"&vbcrlf&_
			"			<li><a><span class=""glyphicon glyphicon-leaf""></span> [sitemoneyname] "&kltool_get_usermoney(userid,1)&"</a></li>"&vbcrlf&_
			"			<li><a><span class=""glyphicon glyphicon-flash""></span> 经验 "&kltool_get_usermoney(userid,2)&"</a></li>"&vbcrlf&_
			"			<li><a><span class=""glyphicon glyphicon-th-list""></span> RMB "&kltool_get_usermoney(userid,4)&"</a></li>"&vbcrlf&_
			"			<li><a><span class=""glyphicon glyphicon-credit-card""></span> 存款 "&kltool_get_usermoney(userid,3)&"</a></li>"&vbcrlf&_
			"		</ul>"&vbcrlf&_
			"		<ul class=""nav navbar-nav navbar-right"">"&vbcrlf&_
			"		<li><a href=""/bbs/messagelist.aspx?siteid=[siteid]&classid=0&types=0""><span class=""glyphicon glyphicon-envelope""></span> 消息 "&kltool_get_usermsg(userid,1)&"</a></li>"&vbcrlf&_
			"		<li><a href=""/waplogout.aspx?siteid=[siteid]""><span class=""glyphicon glyphicon-off""></span> 注销登录</a></li>"&vbcrlf&_
			"		</ul>"&vbcrlf&_
			"	</div>"&vbcrlf&_
			"	</div>"&vbcrlf&_
			"</nav>"&vbcrlf&_
			"<style>"&vbcrlf&_
			"  .container{max-width:600px;}"&vbcrlf&_
			"  .badge{float:right;}"&vbcrlf&_
			"</style>"&vbcrlf
		end if
		kltool_head=kltool_head&"<div class=""container container-small"">"&vbcrlf
End function
'-----底部内容
Function kltool_end(kltool_end_str1)
	kltool_end=""
	if kltool_end_str1=1 then
		kltool_end=kltool_end&vbcrlf&_
		"<div class=""well well-sm""><span id=""times"" class=""glyphicon glyphicon-time""><span></div>"
	end if
	kltool_end=kltool_end&vbcrlf&"</div>"&_
	vbcrlf&"</body>"&_
	vbcrlf&"</html>"
End Function
'-----查询sql生成数组，测试性
function kltool_GetRow(sql,dbconn,list)
	if list="" then list=pagesize
	kltool_GetRow=array(0,0,"")
	set Rowrs=server.CreateObject("adodb.recordset")
	if dbconn=1 then Rowrs.open sql,kltool,1,1 else Rowrs.open sql,conn,1,1
	If Not Rowrs.eof Then
		count=Rowrs.recordcount
		pagecount=(count+list-1)\list
		if page>pagecount then page=pagecount
		Rowrs.move(list*(page-1))
		kltool_GetRow=array(count,pagecount,Rowrs.GetRows(list))
	end if
	Rowrs.close
	set Rowrs=nothing
end function

'部分字符替换
function kltool_code(strContent)
	strContent=trim(strContent)
	if IsNull(strContent) then exit function
	kltool_code=strContent
	strContent=replace(strContent,"[sitemoneyname]",sitemoneyname)
	strContent=replace(strContent,"[kltool_path]",kltool_path)
	strContent=replace(strContent,"[siteid]",siteid)
	strContent=replace(strContent,"[userid]",userid)
	strContent=replace(strContent,"///","<br/>")
	strContent=replace(strContent,"//","　")
	kltool_code=strContent
end function
'上一页 下一页 跳转
function kltool_page(things,count,pagecount,gopage)
	kltool_page=""
if pagecount>1 then
	kltool_page=vbcrlf&_
	"<li class=""list-group-item"">"&vbcrlf&_
	"	<ul class=""pagination"">"&vbcrlf
		if page>1 then
			kltool_page=kltool_page&_
			"		<li><a href='"&gopage&"siteid="&siteid&"&pagesize="&pagesize&"'><<</a></li>"&vbcrlf&_
			"		<li><a href='"&gopage&"page="&page-1&"&siteid="&siteid&"&pagesize="&pagesize&"'><</a></li>"&vbcrlf
		else
			kltool_page=kltool_page&_
			"		<li class=""disabled""><a><<</a></li>"&vbcrlf&_
			"		<li class=""disabled""><a><</a></li>"&vbcrlf
		end if
		kltool_page=kltool_page&_
		"			<li class=""disabled""><a><b>"&page&"</b>/"&pagecount&"页/"&count&"条</a></li>"&vbcrlf
		if page<pagecount then
			kltool_page=kltool_page&_
			"		<li><a href='"&gopage&"page="&page+1&"&siteid="&siteid&"&pagesize="&pagesize&"'>></a></li>"&vbcrlf&_
			"		<li><a href='"&gopage&"page="&pagecount&"&siteid="&siteid&"&pagesize="&pagesize&"'>>></a></li>"&vbcrlf
		else
			kltool_page=kltool_page&_
			"    <li class=""disabled""><a>></a></li>"&vbcrlf&_
			"    <li class=""disabled""><a>>></a></li>"&vbcrlf
		end if
	kltool_page=kltool_page&_
	"	</ul>"&vbcrlf&_
	"</li>"&vbcrlf
	if things=2 then
		kltool_page=kltool_page&_
		"<li class=""list-group-item"">"&vbcrlf&_
		"	<form class=""form-inline"" method=""get"" action=""?"" role=""form"">"&vbcrlf
			gopage=replace(gopage,"&amp;","&")
			gopage_arr=Split(gopage,"?")
			gopage_arr1=gopage_arr(1)
			if gopage_arr1<>"" then gopage_arr2=Split(gopage_arr1,"&") else gopage_arr2=Split(gopage,"&")
			if Ubound(gopage_arr2)>0 then
				for igopage=0 to Ubound(gopage_arr2)
					if gopage_arr2(igopage)<>"" and gopage_arr2(igopage)<>"page" and gopage_arr2(igopage)<>"pagesize" then
						gopage_arr3=Split(gopage_arr2(igopage),"=")
						kltool_page=kltool_page&_
						"		<input name="""&gopage_arr3(0)&""" type=""hidden"" value="""&gopage_arr3(1)&""">"&vbcrlf
					end if
				next
			end if
		if page<pagecount then page=page+1 else pgae=page-1
			kltool_page=kltool_page&_
			"		<input name=""siteid"" type=""hidden"" value="""&siteid&""">"&vbcrlf&_
			"		<input name=""pagesize"" type=""hidden"" value="""&pagesize&""">"&vbcrlf&_
    		"		<div class=""row"">"&vbcrlf&_
			"			<div class=""col-lg-6"">"&vbcrlf&_
			"				<div class=""input-group col-xs-7"">"&vbcrlf&_
			"					<input name=""page"" type=""text"" value="""&page&""" class=""form-control"">"&vbcrlf&_
			"					<span class=""input-group-btn"">"&vbcrlf&_
			"						<button class=""btn btn-default"" type=""submit"">"&vbcrlf&_
			"						跳转!"&vbcrlf&_
			"						</button>"&vbcrlf&_
			"					</span>"&vbcrlf&_
			"				</div>"&vbcrlf&_
			"			</div>"&vbcrlf&_
			"		</div>"&vbcrlf&_
			"	</form>"&vbcrlf&_
			"</li>"&vbcrlf
		end if
	kltool_page=kltool_page
end if
end function
'-----组件检测函数
function ObjTest(strObj,str)
  on error resume next
  set TestObj=server.CreateObject (strObj)
	If -2147221005 <> Err then
if str=1 then ObjTest =strObj&"：支持<br/>" else ObjTest = True
	else
ObjTest=strObj&"：不支持<br/>"
if str=1 then ObjTest=ObjTest else ObjTest=false
	end if
  set TestObj=nothing
End function
'-----随机数运算，最大值最小值
Function RndNumber(MaxNum,MinNum)
	Randomize 
	RndNumber=int(((MaxNum-MinNum+1)*rnd+MinNum))
	RndNumber=RndNumber
End Function
'-----随机数运算，双精度
Function RndNumberDouble(MaxNum,MinNum)
	Randomize 
	RndNumberDouble=((MaxNum-MinNum+1)*rnd+MinNum)
	RndNumberDouble=FormatNumber(RndNumberDouble,2)
End Function
'-----用户IP获取
Function kltool_userip
	kltool_userip = Request.ServerVariables("HTTP_X_FORWARDED_FOR") 
	If kltool_userip="" Then kltool_userip=Request.ServerVariables("REMOTE_ADDR")
End Function

'-----函数名:getname
'-----作用:获取日期
public Function Getname()
'on error resume next
    Dim y,m,d,h,mm,S
    y = Year(Now)
    m = Month(Now): If m < 10 Then m = "0" & m
    d = Day(Now): If d < 10 Then d = "0" & d
    h = Hour(Now): If h < 10 Then h = "0" & h
    mm = Minute(Now): If mm < 10 Then mm = "0" & mm
    S = Second(Now): If S < 10 Then S = "0" & S
    Getname = y & m & d & h & mm & S
End Function
'-----获取随机数字
public Function GetnameR()
Dim  r
    Randomize
    r = 0
    r = CInt(Rnd() * 1000)
    If r < 10 Then r = r &"00" 
    If r < 100 And r >= 10 Then r = r &"0"  
GetnameR=r
End Function
'-----数组数字相加，cs为分割字符
Function numsum(str,cs)
	y=0
	arrstr_numsum=split(str,cs)
	for i=0 to ubound(arrstr_numsum)
	if arrstr_numsum(i)="" then y=y else y=y+arrstr_numsum(i)
	next
	numsum=y
end Function
'-----数组数字取最大值，cs为分割字符
Function numax(str,cs)
	arrstr_numax =split(str,cs)
	if arrstr_numax(0)<>"" then x=arrstr_numax(0)
	for i=1 to ubound(arrstr_numax)
	if arrstr_numax(i)="" then arrstr_numax(i)=0
	if arrstr_numax(i)-x>0 then
	x=arrstr_numax(i)
	end if
	next
	numax=x
end Function
'-----字节大小转换MB
function mysize(num)
	mysize=num
	If num<1024 Then
		mysize=round(num,0)&"B"
	ElseIf num>=1024 and num<1048576 Then
		mysize=round(num/1024,1)&"KB"
	ElseIf num>=1048576 Then
		mysize=round((num/1024)/1024,2)&"MB"
	End If
end function

'-----录入操作日志
function kltool_write_log(things)
	if things<>"" then
		set rs_kltool_log=Server.CreateObject("ADODB.Recordset")
		rs_kltool_log.open"select * from [kltool_log]",kltool,1,2
		rs_kltool_log.addnew
		rs_kltool_log("userid")=userid
		rs_kltool_log("things")=things
		rs_kltool_log("time")=now
		rs_kltool_log("uip")=kltool_userip
		rs_kltool_log.update
		rs_kltool_log.close
		set rs_kltool_log=nothing
	end if
End function
'时间差计算
function kltool_DateDiff(dt1,dt2,dt3)
'dt3 可选
'yyyy	年
'q	季度
'm	月
'y	一年的日数
'd	日
'w	一周的日数
'ww	周
'h	小时
'n	分钟
's	秒
kltool_DateDiff=DateDiff(dt3,dt1,dt2)
end function
'-----延迟函数
function sleep(stime)
	stimes = timer
	do
	loop until timer - stimes > stime
end function
'-----VIP每日抽奖，奖品设定
function kltool_get_prizelist(things)
prize_lx="1|2|3|4|5|6|7"
prize_name=sitemoneyname&"|经验|RMB(元)|银行存款|VIP延期(天)|空间人气|在线积时"
prize_lx_=split(prize_lx,"|")
prize_name_=split(prize_name,"|")
			For i=0 To ubound(prize_name_)
				kltool_get_prizelist=kltool_get_prizelist&"  <label class=""checkbox-inline""><input type=""radio"" name="""&things&""" id="""&things&""" value="""&prize_lx_(i)&"""> "&prize_lx_(i)&" "&prize_name_(i)&"</label>"&vbcrlf
			Next
end function
'-----VIP每日抽奖，奖品
function kltool_get_prize(things)
prize_lx_str="1|2|3|4|5|6|7"
prize_name_str=sitemoneyname&"|经验|RMB(元)|银行存款|VIP延期(天)|空间人气|在线积时"
prize_lx_g=split(prize_lx_str,"|")
prize_name_g=split(prize_name_str,"|")
			For prize_i=0 To ubound(prize_name_g)
				if clng(things)=clng(prize_lx_g(prize_i)) then
					kltool_get_prize=prize_lx_g(prize_i)&":"&prize_name_g(prize_i)&vbcrlf
					'Exit For
				end if
			Next
end function
'-----VIP每日抽奖，获取vip列表，展示性
function kltool_get_viplist_show
	str=kltool_GetRow("select s_vip,s_num from [svip]",0,300)
	if str(0) then
		count=str(0)
		For i=0 To ubound(str(2),2)
		s_vip=str(2)(0,i)
		s_num=str(2)(1,i)
			kltool_get_viplist_show=kltool_get_viplist_show&"<li class=""list-group-item"">"&s_vip&"."&kltool_get_vip(s_vip,1)&"<br/>"&vbcrlf&_
			"日抽奖次数:"&s_num&vbcrlf&_
			"</li>"&vbcrlf
		next
	else
		kltool_get_viplist_show=kltool_get_viplist_show&"暂时没有记录"
	end if
end function
'-----VIP每日抽奖，获取奖品列表，展示性
function kltool_get_prizelist_show
	str=kltool_GetRow("select id,s_lx,s_prize1,s_prize2 from [svip_prize]",0,30)
	if str(0) then
		For i=0 To ubound(str(2),2)
		s_lx=str(2)(1,i)
		s_prize1=str(2)(2,i)
		s_prize2=str(2)(3,i)
			kltool_get_prizelist_show=kltool_get_prizelist_show&"<li class=""list-group-item"">奖品"&kltool_get_prize(s_lx)&"<br/>"&vbcrlf&_
			""&s_prize1&"--"&s_prize2&vbcrlf&_
			"</li>"&vbcrlf
		next
	else
		kltool_get_prizelist_show=kltool_get_prizelist_show&"暂时没有记录"
	end if
end function
'-----获取class列表
Function kltool_get_classlist(things)
	kltool_get_classlist=""
	set rsclasslist=Server.CreateObject("ADODB.Recordset")
	rsclasslist.open "select * from [class] where userid="&siteid&" and typeid="&clng(things),conn,1,1
		If rsclasslist.eof Then
			kltool_get_classlist=kltool_get_classlist&"  <label class=""checkbox-inline""><input type=""radio"" name=""Class"" id=""Class"" value=""0""> 没有Class</label>"&vbcrlf
		else
			For i=0 To rsclasslist.recordcount
			If rsclasslist.eof Then Exit For
				kltool_get_classlist=kltool_get_classlist&"  <label class=""checkbox-inline""><input type=""radio"" name=""Class"" id=""Class"" value="""&rsclasslist("classid")&"""> "&rsclasslist("classname")&"("&rsclasslist("classid")&")</label>"&vbcrlf
			rsclasslist.movenext
			Next
		end if
	rsclasslist.close
	set rsclasslist=nothing
end Function
'-----获取专题列表
Function kltool_get_topiclist()
	kltool_get_topiclist=""
	set rstopiclist=Server.CreateObject("ADODB.Recordset")
	rstopiclist.open "select id,subclassName from [wap2_smallType] where siteid="&siteid&" and systype like '%bbs%'",conn,1,1
		If rstopiclist.eof Then
			kltool_get_topiclist=kltool_get_topiclist&"  <label class=""checkbox-inline""><input type=""radio"" name=""Topic"" id=""Topic"" value=""0""> 没有专题</label>"&vbcrlf
		else
			For i=0 To rstopiclist.recordcount
			If rstopiclist.eof Then Exit For
				kltool_get_topiclist=kltool_get_topiclist&"  <label class=""checkbox-inline""><input type=""radio"" name=""Topic"" id=""Topic"" value="""&rstopiclist("id")&"""> "&rstopiclist("subclassName")&"</label>"&vbcrlf
			rstopiclist.movenext
			Next
		end if
	rstopiclist.close
	set rstopiclist=nothing
end Function
'-----取权限名称
function kltool_get_managername(str)
	if str=0 then kltool_get_managername="超管"
	if str=1 then kltool_get_managername="副管"
	if str=2 then kltool_get_managername="普通"
	if str=3 then kltool_get_managername="总编辑"
	if str=4 then kltool_get_managername="总版主"
end function
'-----获取用户加黑状态,加黑天数，操作时间，操作人,加黑栏目
Function kltool_get_userlock(uid,things)
	set rsuserlock=conn.execute("select * from [user_lock] where lockuserid="&uid)
	if not (rsuserlock.bof and rsuserlock.eof) then kltool_get_userlock=true else kltool_get_userlock=false
	if things=2 then kltool_get_userlock=rsuserlock("lockdate")
	if things=3 then kltool_get_userlock=rsuserlock("operdate")
	if things=4 then kltool_get_userlock=rsuserlock("operuserid")
	if things=5 then kltool_get_userlock=rsuserlock("classid")
	rsuserlock.close
	set rsuserlock=nothing
End Function
'-----取信息，uid为用户ID，things为1不带链接
Function kltool_get_usermsg(uid,things)
	set rsk=conn.execute("select count(id) from [wap_message] where isnew=1 and siteid="&siteid&" and touserid="&uid)
	if not rsk.eof then
	if things=1 then kltool_get_usermsg=rsk(0) else kltool_get_usermsg="<a href='/bbs/messagelist.aspx?siteid="&siteid&"&classid=0&types=0'>"&rsk(0)&"</a>"
	end if
	rsk.Close
	set rsk=nothing
End Function
'-----取头像
Function kltool_get_userheadimg(uid,things)
	kltool_get_userheadimg=""
	set rsk=conn.execute("select headimg from [user] where userid="&uid)
	if not rsk.eof then
		ktx=rsk("headimg")
		if things=1 then kltool_get_userheadimg=kltool_get_userheadimg&"		<img src="""
		if instr(ktx,"http")=1 or instr(ktx,"/")=1 then
			kltool_get_userheadimg=kltool_get_userheadimg&ktx
		else
			kltool_get_userheadimg=kltool_get_userheadimg&"/bbs/head/"&ktx
		end if
		if things=1 then kltool_get_userheadimg=kltool_get_userheadimg&""" class=""media-object"" style=""max-width:100px;max-height:45px;border-radius:45px;"" alt=""头像"">"
	end if
	rsk.Close
	set rsk=nothing
End Function
'-----取性别
Function kltool_get_usersex(uid)
	set rsk=conn.execute("select sex from [user] where userid="&uid)
	if not rsk.eof then
		ksex=clng(rsk("sex"))
		if ksex=1 then kltool_get_usersex="男" else kltool_get_usersex="女"
	end if
	rsk.Close
	set rsk=nothing
End Function
'-----取权限
Function kltool_get_usermanagerlvl(uid)
	set rsk=conn.execute("select managerlvl,siteid from [user] where userid="&uid)
	if not rsk.eof then
		kmanagerlvl=clng(rsk("managerlvl"))
		if kmanagerlvl=00 Then
			kltool_get_usermanagerlvl="超级管理员"
		elseif kmanagerlvl=01 Then
			kltool_get_usermanagerlvl="副管理员"
		elseif kmanagerlvl=02 Then
			kltool_get_usermanagerlvl="普通会员"
		elseif kmanagerlvl=03 Then
			kltool_get_usermanagerlvl="总编辑"
		elseif kmanagerlvl=04 Then
			kltool_get_usermanagerlvl="总版主"
		end if
	if clng(siteid)<>clng(rsk("siteid")) then kltool_get_usermanagerlvl="副级管理员"
	end if
	rsk.Close
	set rsk=nothing
End Function
'-----取金钱积分,1金币，2经验，3存款，4RMB，5积时
Function kltool_get_usermoney(uid,things)
	set rsk=conn.execute("select money,expr,mybankmoney,rmb,logintimes from [user] where userid="&uid)
	if not rsk.eof then
	kmoney=clng(rsk("money"))
	kexpr=clng(rsk("expr"))
	kmybankmoney=clng(rsk("mybankmoney"))
	krmb=rsk("rmb")
	klogintimes=clng(rsk("logintimes"))
		if things=1 then kltool_get_usermoney=kmoney
		if things=2 then kltool_get_usermoney=kexpr
		if things=3 then kltool_get_usermoney=kmybankmoney
		if things=4 then kltool_get_usermoney=krmb
		if things=5 then kltool_get_usermoney=klogintimes
	end if
	rsk.Close
	set rsk=nothing
End Function
'-----取昵称,1显示vip图标颜色，2直接显示昵称
Function kltool_get_usernickname(uid,things)
	set rsusernick=conn.execute("select nickname,SessionTimeout,endTime from [user] where userid="&uid)
	if not rsusernick.eof then
		user_nickname=rsusernick("nickname")
		user_vip=rsusernick("SessionTimeout")
		user_vip_time=rsusernick("endTime")
		if user_vip="" or isnull(user_vip) then user_vip=0 else user_vip=clng(user_vip)
		rsusernick.close
		set rsusernick=nothing
		
		uservip_str=""
		if user_vip>0 then
			set rs_get_uservip=conn.execute("select subclassName from [wap2_smallType] where siteid="&siteid&" and id="&user_vip)
				if not rs_get_uservip.eof then uservip_str=rs_get_uservip("subclassName")
			rs_get_uservip.close
			set rs_get_uservip=nothing
		end if
		if things=1 then
			kltool_get_usernickname=user_nickname
			if uservip_str<>"" then
				if instr(uservip_str,"#") then
					uservip_str_Split=Split(uservip_str,"#")
					uservip_namevip_str=uservip_str_Split(0)
					uservip_color_str=uservip_str_Split(1)
					if instr(uservip_namevip_str,".")>0 then
						kltool_get_usernickname="<img src="""&uservip_namevip_str&""" alt=""图片"">"
					end if
					if uservip_color_str<>"" and instr(uservip_color_str,"_")>0 then
						uservip_color_Split=Split(uservip_color_str,"_")
						uservip_color=uservip_color_Split(0)
						kltool_get_usernickname=kltool_get_usernickname&"<font color=""#"&uservip_color&""">"&user_nickname&"</font>"
					else
						kltool_get_usernickname=kltool_get_usernickname&user_nickname
					end if
				end if
			end if
		end if
		if things=2 then kltool_get_usernickname=user_nickname
	else
		kltool_get_usernickname="无记录的会员"
	end if
End Function
'-----取用户vip,0显示vip源代码，1显示图，2显示到期时间
Function kltool_get_uservip(uid,things)
	set rsuservip=conn.execute("select nickname,SessionTimeout,endTime from [user] where userid="&uid)
	if not rsuservip.eof then
		user_vip=rsuservip("SessionTimeout")
		user_vip_time=rsuservip("endTime")
		if user_vip="" or isnull(user_vip) then user_vip=0 else user_vip=clng(user_vip)
	rsuservip.close
	set rsuservip=nothing
	end if
	
	uservip_str=""
	if user_vip>0 then
		set rs_get_vip=conn.execute("select subclassName from [wap2_smallType] where siteid="&siteid&" and id="&user_vip)
			if not rs_get_vip.eof then uservip_str=rs_get_vip("subclassName")
		rs_get_vip.close
		set rs_get_vip=nothing
	end if
	if things=0 and uservip_str<>"" then kltool_get_uservip=uservip_str
	if things=1 then
		kltool_get_uservip="普通会员"
		if uservip_str<>"" then
			if instr(uservip_str,"#") then
				uservip_str_Split=Split(uservip_str,"#")
				uservip_namevip_str=uservip_str_Split(0)
				uservip_color_str=uservip_str_Split(1)
				if instr(uservip_namevip_str,".")>0 then
					kltool_get_uservip="<img src="""&uservip_namevip_str&""" alt=""图片"">"
				else
					kltool_get_uservip=uservip_namevip_str
					if uservip_color_str<>"" and instr(uservip_color_str,"_")>0 then
						uservip_color_Split=Split(uservip_color_str,"_")
						uservip_color=uservip_color_Split(0)
						kltool_get_uservip="<font color=""#"&uservip_color&""">"&uservip_namevip_str&"</font>"
					end if
				end if
			else
				kltool_get_uservip=uservip_str
			end if
		end if
	end if
	if things=2 then
			if user_vip_time="" or isnull(user_vip_time) or instr(user_vip_time,"999")>0 then kltool_get_uservip="<br/>过期时间:无限期" else kltool_get_uservip="<br/>过期时间:"&user_vip_time&"(剩余"&kltool_DateDiff(now(),user_vip_time,"d")&"天)"
	end if
End Function

'-----取vip,0显示vip源代码，1显示图
Function kltool_get_vip(uid,things)
	kltool_get_vip=""
	set rs_get_vip=conn.execute("select subclassName from [wap2_smallType] where siteid="&siteid&" and id="&uid)
		if not rs_get_vip.eof then
			uservip_str=rs_get_vip("subclassName")
			rs_get_vip.close
			set rs_get_vip=nothing
			if things=0 then kltool_get_vip=uservip_str
			if things=1 then
				if instr(uservip_str,"#") then uservip_str_Split=Split(uservip_str,"#") else uservip_str_Split=Split(uservip_str&"#","#")
				uservip_namevip_str=uservip_str_Split(0)
				uservip_color_str=uservip_str_Split(1)
			kltool_get_vip=uservip_namevip_str
				if uservip_color_str<>"" and instr(uservip_color_str,"_")>0 then
					uservip_color_Split=Split(uservip_color_str,"_")
					uservip_color=uservip_color_Split(0)
				end if
				if instr(uservip_namevip_str,".")>0 then
					kltool_get_vip_pic="<img src="""&uservip_namevip_str&""" alt=""图片"">"
				end if
				if uservip_color<>"" then
					if kltool_get_vip_pic<>"" then kltool_get_vip=kltool_get_vip_pic&"<font color=""#"&uservip_color&""">颜色示例</font>" else kltool_get_vip="<font color=""#"&uservip_color&""">"&uservip_namevip_str&"</font>"
				end if
			end if
		end if
End Function
'-----显示勋章
Function kltool_get_xunzhang(img)
if img<>"" then
	if len(img)<=6 then
		kltool_get_xunzhang="<img src='/bbs/medal/"&img&"' alt=''>"
	elseif instr(img,"/")=1 then
		kltool_get_xunzhang="<img src='"&img&"' alt=''>"
	else
		kltool_get_xunzhang="<img src='/"&img&"' alt=''>"
	end if
end if
End Function
'-----获取vip列表
Function kltool_get_viplist(things)
	kltool_get_viplist=""
	set rsviplist=Server.CreateObject("ADODB.Recordset")
	rsviplist.open "select * from [wap2_smallType] where siteid="&siteid&" and systype='card'",conn,1,1
		If rsviplist.eof Then
			kltool_get_viplist=kltool_get_viplist&"<input type=""radio"" name="""&things&""" id="""&things&""" value=""0""> 没有VIP"
		else
			For i=0 To rsviplist.recordcount
			If rsviplist.eof Then Exit For
				kltool_get_viplist=kltool_get_viplist&"<label class=""checkbox-inline""><input type=""radio"" name="""&things&""" id="""&things&""" value="""&rsviplist("id")&"""> "&rsviplist("id")&" "&kltool_get_vip(rsviplist("id"),1)&"</label>"&vbcrlf
			rsviplist.movenext
			Next
		end if
	rsviplist.close
	set rsviplist=nothing
end Function
'-----创建文件夹
'-----path_str="upload/"&year(now)&"/"&month(now)&"/"&day(now)
'-----call Create_Folder(path_str)
sub Create_Folder(path_str)
	Set fso_f = Server.CreateObject("Scripting.FileSystemObject")
	path_str_split=split(path_str,"/")
		for i=0 to ubound(path_str_split)
			if i=0 and path_str_split(i)="" then cpath="/" else cpath=cpath&path_str_split(i)&"/"
			If not fso_f.folderExists(server.mappath(cpath)) then fso_f.CreateFolder server.mappath(cpath)
		next
	Set fso_f = nothing
end sub

public function Generate_Key()
 Randomize
 do
 num  =  Int((75  *  Rnd)+48)
 found  =  false
 if  num  >=  58  and  num  <=  64  then 
 found  =  true
 else
 if  num  >=91  and  num  <=96  then
 found  =  true
 end  if
 end  if
 if  found  =  false  then
 RSKey  =  RSKey+Chr(num)
 end  if
 loop  until  len(RSKey)=16
 Generate_Key=RSKey
 end  function
%>