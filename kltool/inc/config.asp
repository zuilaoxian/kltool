<!--#include file="../api/conn.asp"-->
<!--#include file="../api/userconfig.asp"-->
<!--#include file="./conn.asp"-->
<!--#include file="./Function.asp"-->

<%
'-----顶部左上角logo
kltool_logo=""&kltool_path&"inc/2017-1-20.png"
'-----顶部左上角logo-普通会员显示
if kltool_yunxu<>1 then kltool_logo=""&kltool_path&"inc/2017-1-20.png"
'-----版本
kltool_version="2017-1-20"

'-----页面列表数量(上下页)
'管理员用
if kltool_yunxu=1 then
if kltool_listsize<>"" then PageSize=kltool_listsize else PageSize=15
'普通会员
else
if kltool_listsize2<>"" then PageSize=kltool_listsize2 else PageSize=10
end if

'-----管理员操作日志【删除】开关，1允许，其他否(默认其他，推荐其他)
kltool_admin_log_del=2

'-----容错过滤，1是，其他否(默认1，推荐1)
kltool_err_top=1
if kltool_err_top=1 then On Error Resume Next

'-----错误提醒,底部显示,1为弹窗提醒，2为显示提醒(默认1，推荐1)
kltool_err_msg_way=2

'-----防止部分空间未登录也可以看到页面
if not kltool_login then call kltool_err_msg("没有登录的你\n看不到我！")
%>