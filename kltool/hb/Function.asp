<%
function kltool_hb_lx(uid)
if uid="1" then
kltool_hb_lx="普通红包"
elseif uid="2" then
kltool_hb_lx="拼手气红包"
elseif uid="3" then
kltool_hb_lx="暗语红包"
elseif uid="4" then
kltool_hb_lx="密码红包"
end if
end function

function kltool_hb_openzt(uid)
if uid="1" then kltool_hb_openzt="开启" else kltool_hb_openzt="关闭"
end function

function kltool_hb_last(uid)
kltool_hb_last=0
set rsk=server.CreateObject("adodb.recordset")
rsk.open "select * from [kltool_hb_log] where hb_ly='"&uid&"' and hb_userid=0",conn,1,1
If Not rsk.eof then kltool_hb_last=rsk.recordcount
rsk.close
set rsk=nothing
end function

function kltool_hb_sx(uid)
set rs_hb=server.CreateObject("adodb.recordset")
rs_hb.open "select * from [kltool_hb_set] where id=4",conn,1,1
If Not rs_hb.eof then
	if uid=1 then
	kltool_hb_sx=rs_hb("hb_lx")
	elseif uid=2 then
	kltool_hb_sx=rs_hb("hb_open")
	end if
end if
rs_hb.close
set rs_hb=nothing
end function


function kltool_hb_open(uid)
kltool_hb_open=0
set rs_hb=server.CreateObject("adodb.recordset")
rs_hb.open "select * from [kltool_hb] where hb_ly='"&uid&"'",conn,1,1
If Not rs_hb.eof then kltool_hb_open=rs_hb("hb_open")
rs_hb.close
set rs_hb=nothing
end function

function kltool_hb_ay(uid)
set rs_hb=server.CreateObject("adodb.recordset")
rs_hb.open "select * from [kltool_hb] where hb_ly='"&uid&"'",conn,1,1
If Not rs_hb.eof then kltool_hb_ay=rs_hb("hb_ay")
rs_hb.close
set rs_hb=nothing
end function

function kltool_hb_yes(uid)
set rs_hb=server.CreateObject("adodb.recordset")
rs_hb.open "select * from [kltool_hb_log] where hb_ly='"&uid&"' and hb_userid="&userid,conn,1,1
If Not rs_hb.eof then kltool_hb_yes=1
rs_hb.close
set rs_hb=nothing
end function

function kltool_hb_ly(uid)
set rs_hb=server.CreateObject("adodb.recordset")
rs_hb.open "select * from [kltool_hb] where hb_ly='"&uid&"'",conn,1,1
If Not rs_hb.eof then kltool_hb_ly=kltool_get_usernickname(rs_hb("hb_userid"),1)
rs_hb.close
set rs_hb=nothing
end function

function kltool_hb_lyuid(uid)
set rs_hb=server.CreateObject("adodb.recordset")
rs_hb.open "select * from [kltool_hb] where hb_ly='"&uid&"'",conn,1,1
If Not rs_hb.eof then kltool_hb_lyuid=rs_hb("hb_userid")
rs_hb.close
set rs_hb=nothing
end function

function kltool_hb_lylx(uid)
set rs_hb=server.CreateObject("adodb.recordset")
rs_hb.open "select * from [kltool_hb] where hb_ly='"&uid&"'",conn,1,1
If Not rs_hb.eof then kltool_hb_lylx=rs_hb("hb_lx")
rs_hb.close
set rs_hb=nothing
end function

function kltool_hb_lyje(uid)
set rs_hb=server.CreateObject("adodb.recordset")
rs_hb.open "select * from [kltool_hb] where hb_ly='"&uid&"'",conn,1,1
If Not rs_hb.eof then kltool_hb_lyje=rs_hb("hb_money")
rs_hb.close
set rs_hb=nothing
end function

function kltool_hb_sf(uid)
if uid=1 then
sql="select sum(hb_money) from [kltool_hb_log] where hb_userid="&userid
elseif uid=2 then
sql="select sum(hb_money) from [kltool_hb] where hb_userid="&userid
end if
set rs_hb=server.CreateObject("adodb.recordset")
rs_hb.open sql,conn,1,1
kltool_hb_sf=rs_hb(0)
rs_hb.close
set rs_hb=nothing
end function

function kltool_hb_sfsl(uid)
if uid=1 then
sql="select * from [kltool_hb_log] where hb_userid="&userid
elseif uid=2 then
sql="select * from [kltool_hb] where hb_userid="&userid
end if
set rs_hb=server.CreateObject("adodb.recordset")
rs_hb.open sql,conn,1,1
kltool_hb_sfsl=rs_hb.recordcount
rs_hb.close
set rs_hb=nothing
end function

Function RndNumber(MaxNum,MinNum)
Randomize 
RndNumber=int((MaxNum-MinNum+1)*rnd+MinNum)
RndNumber=RndNumber
End Function
%>
