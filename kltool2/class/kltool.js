﻿$(function() {
//通用提醒
	$("a#tips").on('click',function(){
		event.preventDefault();
		tipword=$(this).attr("tiptext");
		tiplink=$(this).attr("href");
		layer.confirm(tipword, {
		  btn: ['确定','取消']
		  ,shadeClose:true
		  ,title:''
		}, function(){
			$.ajax({
			url:tiplink,
			type:'get',
			timeout:'15000',
			async:true,
				success:function(data){
					layer.alert(
						data,{closeBtn: 0,title:''}
					);
				}
			})
		});		
	});
	$("a#tip").click(function(){
		event.preventDefault();
		tipword=$(this).attr("tiptext");
		tiplink=$(this).attr("href");
		layer.confirm(tipword, {
		  btn: ['确定','取消']
		  ,shadeClose:true
		  ,title:''
		}, function(){
			self.location.href=tiplink;
		});		
	});
	$('button[name=kltool]').click(function(){
		$(this).button('loading').delay(1000).queue(function() {
			$(this).button('reset').dequeue();
		});
	});
	path=location.pathname.toLowerCase().split('/');
	thispath=path.length>2?path[2]:Null;
//功能-发表帖子带专题
	$("#BbsTopic").click(function(){
		bbs_title=$('#bbs_title').val();
		bbs_content=$('#bbs_content').val();
		bbs_classid=$('#Class:checked').val();
		bbs_topic=$('#Topic:checked').val();
		bbs_author=$('#bbs_author').val();
		bbs_pub=$('#bbs_pub').val();
		if (!bbs_title) {layer.tips('不能为空', '#bbs_title', {tips: [1, '#0FA6D8']}); return;}
		if (!bbs_content) {layer.tips('不能为空', '#bbs_content', {tips: [1, '#0FA6D8']}); return;}
		if (!bbs_classid) {layer.tips('不能为空', '#Class', {tips: [1, '#0FA6D8']}); return;}
		if (!bbs_author) {layer.tips('不能为空', '#bbs_author', {tips: [1, '#0FA6D8']}); return;}
		if (!bbs_pub) {layer.tips('不能为空', '#bbs_pub', {tips: [1, '#0FA6D8']}); return;}
		layer.confirm("确定?", {
		  btn: ['确定','取消']
		  ,shadeClose:true
		  ,title:''
		}, function(){
			$.ajax({
			url:'?action=yes',
			type:'post',
			data:{
				bbs_title:bbs_title,
				bbs_content:bbs_content,
				bbs_classid:bbs_classid,
				bbs_topic:bbs_topic,
				bbs_author:bbs_author,
				bbs_pub:bbs_pub
				},
			timeout:'15000',
			async:true,
				success:function(data){
					layer.alert(data,{shadeClose:true,title:''});
				}
			})
		});		
	});
//功能-vip自助开通设置
	$("button#Vip_Set").click(function(){
		r_id=$(this).attr('vipid');
		r_jinbi=$('#r_jinbi'+r_id).val();
		r_jinyan=$('#r_jinyan'+r_id).val();
		r_rmb=$('#r_rmb'+r_id).val();
		r_xian=$('#r_xian'+r_id+':checked').val();
		layer.confirm("确定?", {
		  btn: ['确定','取消']
		  ,shadeClose:true
		  ,title:''
		}, function(){
			$.ajax({
			url:'?action=yes',
			type:'post',
			data:{
				r_id:r_id,
				r_jinbi:r_jinbi,
				r_jinyan:r_jinyan,
				r_rmb:r_rmb,
				r_xian:r_xian
				},
			timeout:'15000',
			async:true,
				success:function(data){
					layer.alert(data,{shadeClose:true,title:''});
				}
			})
		});		
	});
//功能-vip自助开通
	$("button#Vip_pay").click(function(){
		r_id=$(this).attr('vipid');
		r_num=$('#r_num'+r_id).val();
		if (!r_num) {
			layer.tips('不能为空', '#r_num'+r_id, {tips: [1, '#0FA6D8']});
			return;
		}
		layer.confirm("确定?", {
		  btn: ['确定','取消']
		  ,shadeClose:true
		  ,title:''
		}, function(){
			$.ajax({
			url:'?action=ktvip',
			type:'post',
			data:{
				r_id:r_id,
				r_num:r_num
				},
			timeout:'15000',
			async:true,
				success:function(data){
					layer.alert(
						data,
						{
							closeBtn: 0,
							title:''
							,btn: ['确定']
							,yes: function(index){
								layer.close(index);
								$.get("?action=getvip&r_id="+r_id,function(data){$("#r_vip").html(data).fadeOut(200).fadeIn(300).fadeOut(200).fadeIn(300);});
							}
						}
					);
				},
				error:function(xhr){
					layer.msg('网络错误，请重试',{time: 60000,anim:6})
				}
			})
		});		
	});
//功能-用户资料
	if (thispath=='userdata.asp'){
		r_uid=$("#r_uid").val();
		$("#r_uid").on('blur',function(){
			if(r_uid!=$("#r_uid").val()) window.location.href="?uid="+$("#r_uid").val();
		})
	}
	$("#UserData").click(function(){
		r_uid=$("#r_uid").val();
		r_siteid=$("#r_siteid").val();
		r_username=$("#r_username").val();
		r_nick=$("#r_nick").val();
		r_pass=$("#r_pass").val();
		r_money=$("#r_money").val();
		r_exp=$("#r_exp").val();
		r_rmb=$("#r_rmb").val();
		r_bankmoney=$("#r_bankmoney").val();
		r_logintimes=$("#r_logintimes").val();
		r_zone=$("#r_zone").val();
		r_remake=$("#r_remake").val();
		r_lvl=$("#r_lvl:checked").val();
		r_sex=$("#r_sex:checked").val();
		r_lock=$("#r_lock:checked").val();
		layer.confirm("确定?", {
		  btn: ['确定','取消']
		  ,shadeClose:true
		  ,title:''
		}, function(){
			$.ajax({
			url:'?action=yes',
			type:'post',
			data:{
				r_uid:r_uid,
				r_siteid:r_siteid,
				r_username:r_username,
				r_nick:r_nick,
				r_pass:r_pass,
				r_money:r_money,
				r_exp:r_exp,
				r_rmb:r_rmb,
				r_bankmoney:r_bankmoney,
				r_logintimes:r_logintimes,
				r_zone:r_zone,
				r_remake:r_remake,
				r_lvl:r_lvl,
				r_sex:r_sex,
				r_lock:r_lock
				},
			timeout:'15000',
			async:true,
				success:function(data){
					layer.alert(
						data,
						{
							closeBtn: 0,
							title:''
							,btn: ['确定','关闭']
							,yes: function(index){
								location.reload();
								layer.close(index);
							}
						}
					);
				}
			})
		});		
	});
//功能-注册ID
	$("#RegisterIds").click(function(){
		r_num=$("#r_num").val();
		r_last_userid=$("#r_last_userid").val();
		r_siteid=$("#r_siteid").val();
		r_nick=$("#r_nick").val();
		r_lvl=$("#r_lvl:checked").val();
		r_sex=$("#r_sex:checked").val();
		if (!r_num) {
			layer.tips('不能为空', '#r_num', {tips: [1, '#0FA6D8']});
			return;
		}
		layer.confirm("确定?", {
		  btn: ['确定','取消']
		  ,shadeClose:true
		  ,title:''
		}, function(){
			$.ajax({
			url:'?action=yes',
			type:'post',
			data:{
				r_num:r_num,
				r_last_userid:r_last_userid,
				r_siteid:r_siteid,
				r_nick:r_nick,
				r_lvl:r_lvl,
				r_sex:r_sex
				},
			timeout:'15000',
			async:true,
				success:function(data){
					layer.alert(
						data,
						{
							closeBtn: 0,
							title:''
							,btn: ['了解']
							,yes: function(index){
								layer.close(index);
								$.get("?action=yes2",function(data){$("#r_last_userid").val(data).fadeOut(200).fadeIn(300).fadeOut(200).fadeIn(300);});
							}
						}
					);
				}
			})
		});		
	});
//
	$("#RegisterId").click(function(){
		r_uid=$("#r_uid").val();
		r_siteid=$("#r_siteid").val();
		r_username=$("#r_username").val();
		r_nick=$("#r_nick").val();
		r_pass=$("#r_pass").val();
		r_lvl=$("#r_lvl:checked").val();
		r_sex=$("#r_sex:checked").val();
		if (!r_uid) {
			layer.tips('不能为空', '#r_uid', {tips: [1, '#0FA6D8']});
			return;
		}
		layer.confirm("确定?", {
		  btn: ['确定','取消']
		  ,shadeClose:true
		  ,title:''
		}, function(){
			$.ajax({
			url:'?action=yes',
			type:'post',
			data:{
				r_uid:r_uid,
				r_username:r_username,
				r_siteid:r_siteid,
				r_nick:r_nick,
				r_pass:r_pass,
				r_lvl:r_lvl,
				r_sex:r_sex
				},
			timeout:'15000',
			async:true,
				success:function(data){
					layer.alert(
						data,
						{
							closeBtn: 0,
							title:''
							,btn: ['了解']
							,yes: function(index){
								layer.close(index);
								$.get("?action=yes2",function(data){$("#r_uid").val(data).fadeOut(200).fadeIn(300).fadeOut(200).fadeIn(300);});
							}
						}
					);
				}
			})
		});		
	});
//功能-修改起始ID
	$("#Restart_Id").click(function(){
		r_table=$("#r_table:checked").val();
		r_table2=$("#r_table2").val();
		RestartId=$("#RestartId").val();
		if (!RestartId) {
			layer.tips('不能为空', '#RestartId', {tips: [1, '#0FA6D8']});
			return;
		}
		layer.confirm("确定?", {
		  btn: ['确定','取消']
		  ,shadeClose:true
		  ,title:''
		}, function(){
			$.ajax({
			url:'?action=yes',
			type:'post',
			data:{
				r_table:r_table,
				r_table2:r_table2,
				RestartId:RestartId
				},
			timeout:'15000',
			async:true,
				success:function(data){
					layer.alert(data,{shadeClose:true,title:''});
				}
			})
		});		
	});
//功能-删除ID
	$("#T-DelId").click(function(){
		if (!$("#uid").val()) {
			layer.tips('不能为空', '#uid', {tips: [1, '#0FA6D8']});
			return;
		}
		layer.confirm("确定删除<br/>"+$("#uid").val()+"?", {
		  btn: ['确定','取消']
		  ,shadeClose:true
		  ,title:''
		}, function(){
			$.ajax({
			url:'?action=del',
			type:'post',
			data:{
				uid:$("#uid").val()
				},
			timeout:'15000',
			async:true,
				success:function(data){
					layer.alert(data,{shadeClose:true,title:''});
				}
			})
		});		
	});
//签名
	$("#re-mark").click(function(){
		uid=$('#uid').val();
		remark=$('#remark').val();
		if (!remark) {
			layer.tips('不能为空', '#remark', {tips: [1, '#0FA6D8']});
			return;
		}
		layer.confirm('确定?', {
		  btn: ['确定','取消']
		  ,shadeClose:true
		  ,title:''
		}, function(){
			$.ajax({
				url:'?action=yes',
				type:'post',
				data:{
					uid:uid,
					remark:remark
					},
				timeout:'15000',
				async:false,
					success:function(data){
						layer.alert(data,{shadeClose:true,title:''});
					}
			})
		});		
	});
//会员管理-删除ID
	$(".DelId").click(function(){
		tipword=$(this).attr("tiptext");
		uid=$(this).attr("id")
		layer.confirm(tipword, {
		  btn: ['确定','取消']
		  ,shadeClose:true
		  ,title:''
		}, function(){
			$.ajax({
				url:'delID.Asp?action=dels',
				type:'post',
				data:{
					uid:uid
					},
				timeout:'15000',
				async:true,
					success:function(data){
						layer.msg(data,{time:2000,anim:6});
						//layer.alert(data,{shadeClose:true,title:''});
						if (data.indexOf('成功')>=0) $("a#"+uid).parent().parent().parent().fadeOut(300).fadeIn(300).fadeOut(500);
					}
			})
		});	
	});
//会员管理-锁ID
	$(".LockId").click(function(){
		tipword=$(this).text()+$(this).attr("tiptext");
		uid=$(this).attr("id")
		layer.confirm(tipword, {
		  btn: ['确定','取消']
		  ,shadeClose:true
		  ,title:''
		}, function(){
			$.ajax({
				url:'?action=LockId',
				type:'post',
				data:{
					uid:uid
					},
				timeout:'15000',
				async:true,
				dataType:'json',
					success:function(data){
						layer.msg(data.b,{time:2000,anim:6});
						//layer.alert(data.b,{shadeClose:true,title:''});
						$("a#"+uid+".LockId").html(data.a).fadeOut(300).fadeIn(300);
					}
			})
		});	
	});
//会员管理-会员资料
	$(".DataId").click(function(){
		$('.btn.btn-primary').hide();
		uid=$(this).attr("id");
		$.ajax({
			url:'?action=DataId',
			type:'post',
			data:{
				uid:uid
				},
			timeout:'15000',
			async:false,
				success:function(data){
					$(".modal-title").html(uid);
					$(".modal-body").html(data);
				}
		})
	});
//会员管理-会员权限
	$(".LvlId").click(function(){
		$('.btn.btn-primary').show();
		uid=$(this).attr("id");
		$.ajax({
			url:'?action=LvlId',
			type:'post',
			data:{
				uid:uid
				},
			timeout:'15000',
			async:false,
				success:function(data){
					$(".modal-title").html(uid);
					$(".modal-body").html(data);
				}
		})
		$('.btn.btn-primary').click(function(){
			Lvl=$('input#Lvl:checked').val();
			$.ajax({
				url:'?action=LvlId2',
				type:'post',
				data:{
					uid:uid,
					Lvl:Lvl
					},
				timeout:'15000',
				async:false,
					success:function(data){
						$("a#"+uid+".LvlId").html(data).fadeOut(300).fadeIn(300);
					}
			});
			$('.btn.btn-primary').off("click");//解除绑定事件
			$('#myModal').modal('hide')
		});
	});
//会员管理-会员Vip
	$(".VipId").click(function(){
		$('.btn.btn-primary').show();
		uid=$(this).attr("id");
		$.ajax({
			url:'?action=VipId',
			type:'post',
			data:{
				uid:uid
				},
			timeout:'15000',
			async:false,
				success:function(data){
					$(".modal-title").html(uid);
					$(".modal-body").html(data);
				}
		})
		$('.btn.btn-primary').click(function(){
			Vip=$('input#Vip:checked').val();
			VipTime=$('input#VipTime').val();
			$.ajax({
				url:'?action=VipId2',
				type:'post',
				data:{
					uid:uid,
					Vip:Vip,
					VipTime:VipTime
					},
				timeout:'15000',
				async:false,
					success:function(data){
						$("a#"+uid+".Nick").html(data).fadeOut(300).fadeIn(300);
					}
			});
			$('.btn.btn-primary').off("click");
			$('#myModal').modal('hide')
		})
	});
//模态框监测，关闭后清除内容，解除事件绑定
	 $('#myModal').on('hide.bs.modal', function () {
		$('.btn.btn-primary').off("click");//解除绑定事件
		$(".modal-title,.modal-body").html("");
	})
	
  setInterval(clock,1000);
});
function clock(){
  now = new Date();
  year = now.getFullYear();
  month = now.getMonth() + 1;
  day = now.getDate();
  today = ['星期日','星期一','星期二','星期三','星期四','星期五','星期六'];
  week = today[now.getDay()];
  hour = now.getHours();
  min = now.getMinutes();
  sec = now.getSeconds();
  msec = now.getMilliseconds();
  month=month>9?month:"0"+month;
  day=day>9?day:"0"+day;
  hour=hour>9?hour:"0"+hour;
  min=min>9?min:"0"+min;
  sec=sec>9?sec:"0"+sec;
  $("#times").html(" "+ year + "-" + month + "-" + day + " " + hour + ":" + min + ":" + sec +" "+ week);
}
//全选反选
function check_all(obj,cName) 
{
    var checkboxs = document.getElementsByName(cName); 
    for(var i=0;i<checkboxs.length;i++){checkboxs[i].checked = obj.checked;} 
}
//点击提示内容
function ConfirmDel(message)
{
   if (confirm(message))
   {
   document.formDel.submit();
   }else{
   //history.go(0);
   }
}
//隐藏部分内容,点击显示
function display(obj)
{
  if (obj.style.display=='none') 
    obj.style.display='';
  else
    obj.style.display='none';
}

function getValues(obj,val,arr){
var Dom=document.getElementById(obj);
	if (arr.indexOf(val)<0){
		Dom.style.display='none';
	}else{
		Dom.style.display='';
	}
}