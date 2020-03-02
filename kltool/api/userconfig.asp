<!--#include file="cookies.asp"--><!--#include file="md5.asp"-->
<%
if siteid="" then siteid=1000
userid=clng(userid)
siteid=clng(siteid)
if userid="" then userid=0
if userid=0 then Response.redirect"/waplogin.aspx?siteid="&siteid
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

set rs=conn.execute("select * from [user] where userid="&siteid)
sitemoneyname=rs("sitemoneyname")	'取币名
rs.close
set rs=nothing
%>