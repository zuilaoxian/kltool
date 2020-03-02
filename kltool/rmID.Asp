<!--#include file="./inc/head.asp"-->
<title>柯林工具箱-注册任意ID</title>
<%
call kltool_quanxian
pg=request("pg")
if pg="" then
%>
<div class="tip">首次使用，不明白的，请注意看底部提示</div>
<div class="line2">请填写信息</div>
<div class="content">
<form method="post" action="?">
<input name="siteid" type="hidden" value="<%=siteid%>">
<input name="pg" type="hidden" value="yes">
要注册的ID(数)<br/>
<input name="kltool_userid" type="text" size="20" value="" id="q1" onkeyup="return ajaxQuerySetDom(this.value,'./inc/key.asp?action=reg&','q','result1')"><span id="result1"></span><br/>
所属网站ID(一般为1000)<br/>
<input name="kltool_siteid" type="text" size="20" value="<%=siteid%>"><br/>
用户名(英/数)登录名<br/>
<input name="kltool_username" type="text" size="20" value="" id="q2" onkeyup="return ajaxQuerySetDom(this.value,'./inc/key.asp?action=uname&','q','result2')"><span id="result2"></span><br/>
昵称(汉/英/数)<br/>
<input name="kltool_nickname" type="text" size="20" value=""><br/>
密码(英/数)<br/>
<input name="kltool_password" type="text" size="20" value=""><br/>
权限<br/>
<select name="kltool_lvl">
<option value="02">02-普通会员</option>
<option value="01">01-副管</option>
<option value="00">00-超管</option>
</select><br/>
性别<br/>
<select name="kltool_sex">
<option value="1">1-男</option>
<option value="0">0-女</option>
</select><br/>
<input name="g" type="submit" value="马上增加" onClick="ConfirmDel('是否确定？');return false"><br/>
</form>
</div>
<%
elseif pg="yes" then
kltool_userid=request("kltool_userid")
kltool_siteid=request("kltool_siteid")
kltool_username=request("kltool_username")
kltool_nickname=request("kltool_nickname")
kltool_password=request("kltool_password")
kltool_lvl=request("kltool_lvl")
kltool_sex=request("kltool_sex")
if kltool_userid="" or kltool_username="" or kltool_nickname="" or kltool_password="" then call kltool_err_msg("各项不能为空")
if not (Isnumeric(kltool_userid) or Isnumeric(kltool_siteid))then call kltool_err_msg("ID和网站ID必须是数字")

set rs=conn.execute("select userid from [user] where userid="&kltool_userid)
if not (rs.bof and rs.eof) then call kltool_err_msg("此ID已存在")
rs.close
set rs=nothing
conn.execute("SET IDENTITY_INSERT [USER] ON INSERT INTO [user] (userid,siteid,username,nickname,password,managerlvl,sex) VALUES ('"&kltool_userid&"','"&kltool_siteid&"','"&kltool_username&"','"&kltool_nickname&"','"&MD5(kltool_password)&"','"&kltool_lvl&"','"&kltool_sex&"') SET IDENTITY_INSERT [USER] OFF")
if kltool_lvl="00" then 
qx="超管"
elseif kltool_lvl="01" then
qx="副管"
elseif kltool_lvl="02" then
qx="普通会员"
end if
if kltool_sex="0" then
xb="女"
elseif kltool_sex="1" then
xb="男"
end if
call kltool_write_log("注册了ID:"&kltool_userid)
call kltool_err_msg("注册成功!\n注册ID:"&kltool_userid&"\n所属网站:"&kltool_siteid&"\n用户名:"&kltool_username&"\n昵称:"&kltool_nickname&"\n密码:"&kltool_password&"\n权限:"&qx&"\n性别："&xb)
end if
Response.write"<div class=""tip"">小提示：</div>"
Response.write"<div class=""line2"">用户ID，注册后不可修改，可删除后重新注册<br/>网站ID，一般为1000，多用户网站请根据情况填写<br/>用户名，一般为英文数字<br/>昵称，可以用汉字<br/>密码，可用英文数字或符号<br/></div><div class=""line1"">若网站起始ID为10000，建议只注册10000以内的ID，若注册了10000以上的ID，比如15000，那么起始ID将被直接修改为15000</div>"
call kltool_end
%>