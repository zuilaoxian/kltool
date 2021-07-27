<!--#include file="config.asp"-->
<%
kltool_use(22)
kltool_admin(1)
action=Request.QueryString("action")
select case action
	case ""
		call index()
	case "execsql"
		call execsql()
end select

sub index()
Response.write kltool_code(kltool_head("柯林工具箱-Sql语句执行","1"))
%>
<div role="form">
	<div class="form-group">
		<label>选择数据库</label>
		<div class="checkbox">
			<label><input type="radio" name="Edata" id="Edata" value="1" checked> 柯林</label>
			<label><input type="radio" name="Edata" id="Edata" value="2"> 工具箱</label>
		</div>
	</div>
	<div class="form-group"">
		<label>Sql语句</label>
		<div class="form-group">
			<textarea class="form-control" rows="3" name="Esql" id="Esql" placeholder=""></textarea>
		</div>
	</div>
	<div class="form-group"">
		<button name="Exec_Sql_click" type="button" class="btn btn-default btn-block" id="Exec_Sql_click" data-loading-text="Loading...">提交</button>
	</div>
</div>
<div class="well well-sm">执行增删改查，只返回成功与否，不返回查询结果</div>
<div class="well well-sm">示例：用户ID1000的金币+1000<br/>update [user] set money=money+1000 where userid=1000</div>
<%
Response.write kltool_code(kltool_end(1))
end sub

sub execsql()
	Edata=Request.Form("Edata")
	Esql=Request.Form("Esql")
	On Error Resume Next
	select case Edata
		case "1"
			conn.execute(Esql)
			case "2"
			kltool.execute(Esql)
	end select
	if err<>0 then
		response.write Err.Description
	else
		response.write "Sql语句成功执行"
	end if
end sub
%>
