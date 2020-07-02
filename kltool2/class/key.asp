<!--#include file="./keyFunction.asp"-->
<%
action=request("action")
response.expires=-1
q=request("q")
if action="reg" then
response.write kltool_key_reg(q)
elseif action="uname" then
response.write kltool_key_uname(q)
elseif action="cdk" then
response.write kltool_key_cdk(q)
elseif action="user" then
response.write kltool_key_hy(q)
elseif action="picture" then
response.write kltool_key_picture(q)
end if
%>