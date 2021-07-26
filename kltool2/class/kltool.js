$(function() {
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
			async:true,
				success:function(data){
					layer.alert(
						data,{closeBtn: 0,shadeClose:true,title:''}
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
//功能-工具箱功能设定
	$("button#tool_set").click(function(){
		t_id=$(this).attr('t_id');
		t_name=$('#t_name'+t_id).val();
		t_title=$('#t_title'+t_id).val();
		t_content=$('#t_content'+t_id).val();
		t_t=$('#t_t'+t_id+':checked').val();
		t_show=$('#t_show'+t_id+':checked').val();
		layer.confirm("确定?", {
		  btn: ['确定','取消']
		  ,shadeClose:true
		  ,title:''
		}, function(){
			$.ajax({
			url:'?action=tool_set',
			type:'post',
			data:{
				t_id:t_id,
				t_name:t_name,
				t_title:t_title,
				t_content:t_content,
				t_t:t_t,
				t_show:t_show
				},
			timeout:'15000',
			async:true,
				success:function(data){
					layer.alert(data,{shadeClose:true,title:''});
				}
			})
		});		
	});
//功能-cdk-cdk兑换前校验
	$("input[name=c_cdkjy]").bind("input propertychange",function(event){
		if ($(this).val().length==16){
			$.ajax({
				url:'?action=cdk&c_cdk='+$(this).val(),
				type:'get',
				timeout:'15000',
				async:true,
					success:function(data){
						$('label#c_cdkjy').html(data);
					}
			})
		}else{
			$('label#c_cdkjy').html("输入cdk");
		}
	});
//功能-cdk-cdk兑换
	$("#c_cdkdh").click(function(){
		c_cdk=$("input[name=c_cdkjy]").val();
		if (!c_cdk) {layer.tips('不能为空', '#c_cdk', {tips: [1, '#0FA6D8']}); return;}
		layer.confirm("确定?", {
		  btn: ['确定','取消']
		  ,shadeClose:true
		  ,title:''
		}, function(){
			$.ajax({
				url:'?action=cdkdh&c_cdk='+c_cdk,
				type:'get',
				timeout:'15000',
				async:true,
					success:function(data){
						layer.alert(data,{shadeClose:true,title:''});
					}
			})
		});
	});
//功能-cdk-cdk赠送
	$("a#cdk_give").click(function(){
		$('.btn.btn-primary').show();
		c_cdk=$(this).attr('c_cdk');
		$.ajax({
			url:'?action=cdkzs&c_cdk='+c_cdk,
			type:'get',
			timeout:'15000',
			async:true,
				success:function(data){
					$(".modal-title").html("cdk赠送");
					$(".modal-body").html(data);
				}
		})
		$('.btn.btn-primary').click(function(){
			c_cdk=$('#c_cdk').val();
			c_userid=$('#c_userid').val();
			c_msg=$('#c_msg:checked').val();
			if (!c_userid) {layer.tips('不能为空', '#c_userid', {tips: [1, '#0FA6D8']}); return;}
			$.ajax({
				url:'?action=cdkzsyes',
				type:'post',
				data:{
					c_cdk:c_cdk,
					c_userid:c_userid,
					c_msg:c_msg
					},
				timeout:'15000',
				async:true,
					success:function(data){
						layer.alert(data,{shadeClose:true,title:''});
					}
			});
			$('#myModal').modal('hide')
		})
	});
	
//功能-cdk-一键购买
	$('#Cdk_Fast_buy').click(function(){
		layer.confirm("确定?", {
		  btn: ['确定','取消']
		  ,shadeClose:true
		  ,title:''
		}, function(){
			layer.msg('loading...',{time:1000,anim:6});
			if ($('a.cdk_buy').length){
				$('a.cdk_buy').each(function(index){
					$.get($(this).attr('href'), function (data) {
					 $('#Cdk_Fast_buy').before('<li class="list-group-item">'+data+'</li>');
					})
				})
			}else{
				$('#Cdk_Fast_buy').before('<li class="list-group-item">本页没有可购买的cdk</li>');
			}
		});
	});
//功能-cdk-一键使用
	$('#Cdk_Fast_Use').click(function(){
		layer.confirm("确定?", {
		  btn: ['确定','取消']
		  ,shadeClose:true
		  ,title:''
		}, function(){
			layer.msg('loading...',{time:1000,anim:6});
			if ($('a.nouse').length){
				$('a.nouse').each(function(index){
					$.get($(this).attr('href'), function (data) {
					 $('#Cdk_Fast_Use').before('<li class="list-group-item">'+data+'</li>');
					})
				})
			}else{
				$('#Cdk_Fast_Use').before('<li class="list-group-item">本页没有未使用的cdk</li>');
			}
		});
	});
//功能-cdk-生产cdk
	$('input#c_chushou').click(function(){
		if ($(this).val()==1){$('#c_chushou_div').fadeIn(500);}else{$('#c_chushou_div').fadeOut(500);}
	});
	$('input#c_lx').click(function(){
		if ($(this).val()==3 || $(this).val()==5){$('#c_money2_div').fadeIn(500);}else{$('#c_money2_div').fadeOut(500);}
	});
	$("button#Cdk_add").click(function(){
		c_num=$('#c_num').val();
		c_lx=$('#c_lx:checked').val();
		c_money1=$('#c_money1').val();
		c_money2=$('#c_money2').val();
		c_uid=$('#c_uid').val();
		c_msg=$('#c_msg:checked').val();
		c_zs=$('#c_zs:checked').val();
		c_chushou=$('#c_chushou:checked').val();
		c_money3=$('#c_money3').val();
		c_money4=$('#c_money4').val();
		if (!c_num) {layer.tips('不能为空', '#c_num', {tips: [1, '#0FA6D8']}); return;}
		if (!c_lx) {layer.tips('不能为空', '#c_lx', {tips: [1, '#0FA6D8']}); return;}
		if (!c_money1) {layer.tips('不能为空', '#c_money1', {tips: [1, '#0FA6D8']}); return;}
		if ((c_lx==3 || c_lx==5) && !c_money2) {layer.tips('不能为空', '#c_money2', {tips: [1, '#0FA6D8']}); return;}
		if (c_chushou==1 && !c_money3 && !c_money4) {layer.tips('至少填写一项', '#c_money3', {tips: [1, '#0FA6D8']}); return;}
		layer.confirm("确定?", {
		  btn: ['确定','取消']
		  ,shadeClose:true
		  ,title:''
		}, function(){
			$.ajax({
			url:'?action=cdkaddyes',
			type:'post',
			data:{
				c_num:c_num,
				c_lx:c_lx,
				c_money1:c_money1,
				c_money2:c_money2,
				c_uid:c_uid,
				c_msg:c_msg,
				c_zs:c_zs,
				c_chushou:c_chushou,
				c_money3:c_money3,
				c_money4:c_money4
				},
			timeout:'15000',
			async:true,
				success:function(data){
					layer.alert(data,{shadeClose:true,title:''});
				}
			})
		});
	});
//功能-cdk-商城设定
	$("button#Cdk_shop_Set").click(function(){
		r_id=$(this).attr('shopsetid');
		r_yh=$('#r_yh'+r_id).val();
		r_sl=$('#r_sl'+r_id).val();
		r_vsl=$('#r_vsl'+r_id).val();
		layer.confirm("确定?", {
		  btn: ['确定','取消']
		  ,shadeClose:true
		  ,title:''
		}, function(){
			$.ajax({
			url:'?action=shopsetyes',
			type:'post',
			data:{
				r_id:r_id,
				r_yh:r_yh,
				r_sl:r_sl,
				r_vsl:r_vsl
				},
			timeout:'15000',
			async:true,
				success:function(data){
					layer.alert(data,{shadeClose:true,title:''});
				}
			})
		});	
	});
//功能-cdk-cdk批量删除
	$("#Cdk_Del").click(function(){
		if ($('input#kid:checked').length<1){layer.alert('请至少选择一条',{shadeClose:true,title:''}); return;}
		var kid=[];
		$('input#kid:checked').each(function(){
			kid.push($(this).val());
		})
		layer.confirm("确定?", {
		  btn: ['确定','取消']
		  ,shadeClose:true
		  ,title:''
		}, function(){
			$.ajax({
			url:'?action=cdkdel',
			type:'get',
			data:{
				c_id:kid.join(',')
				},
			timeout:'15000',
			async:true,
				success:function(data){
					layer.alert(data,{shadeClose:true,title:''});
				}
			})
		});	
	});
//功能-cdk-cdk发放
	$("a#cdk_send").click(function(){
		$('.btn.btn-primary').show();
		c_id=$(this).attr('c_id');
		$.ajax({
			url:'?action=cdksend&c_id='+c_id,
			type:'get',
			timeout:'15000',
			async:true,
				success:function(data){
					$(".modal-title").html("cdk发放");
					$(".modal-body").html(data);
				}
		})
		$('.btn.btn-primary').click(function(){
			c_id=$('#c_id').val();
			c_userid=$('#c_userid').val();
			c_msg=$('#c_msg:checked').val();
			$.ajax({
				url:'?action=cdksendyes',
				type:'post',
				data:{
					c_id:c_id,
					c_userid:c_userid,
					c_msg:c_msg
					},
				timeout:'15000',
				async:true,
					success:function(data){
						layer.alert(data,{shadeClose:true,title:''});
					}
			});
			$('#myModal').modal('hide')
		})
	});
//功能-帖子管理-回复语设定
	$("button#Bbs_Re_Set").click(function(){
		re_id=$(this).attr('reid');
		re_qt=$('#re_qt'+re_id+':checked').val();
		re_word=$('#re_word'+re_id).val();
		if (!re_word) {layer.tips('不能为空', '#re_word'+re_id, {tips: [1, '#0FA6D8']}); return;}
		if (!re_qt) {layer.tips('不能为空', '#re_qt'+re_id, {tips: [1, '#0FA6D8']}); return;}
		layer.confirm("确定?", {
		  btn: ['确定','取消']
		  ,shadeClose:true
		  ,title:''
		}, function(){
			$.ajax({
			url:'?action=bbsrewordset',
			type:'post',
			data:{
				re_id:re_id,
				re_qt:re_qt,
				re_word:re_word
				},
			timeout:'15000',
			async:true,
				success:function(data){
					layer.alert(data,{shadeClose:true,title:''});
				}
			})
		});		
	});
//功能-帖子管理-关键词替换
	$("#bbsreplace").click(function(){
		$('.btn.btn-primary').show();
		$.ajax({
			url:'?action=bbsreplace',
			type:'get',
			timeout:'15000',
			async:true,
				success:function(data){
					$(".modal-title").html("关键词替换");
					$(".modal-body").html(data);
				}
		})
		$('.btn.btn-primary').click(function(){
			re_id=$('#Class:checked').val();
			re_word1=$('#bbsreplaceword1').val();
			re_word2=$('#bbsreplaceword2').val();
			$.ajax({
				url:'?action=bbsreplaceyes',
				type:'post',
				data:{
					re_id:re_id,
					re_word1:re_word1,
					re_word2:re_word2
					},
				timeout:'15000',
				async:true,
					success:function(data){
						layer.alert(data,{shadeClose:true,title:''});
					}
			});
			$('#myModal').modal('hide')
		})
	});
//功能-帖子管理-帖子修改
	$("a#bbsrecontent").click(function(){
		tid=$(this).attr("tid")
		$('.btn.btn-primary').show();
		$.ajax({
			url:'?action=bbsrecontent&tid='+tid,
			type:'get',
			timeout:'15000',
			async:true,
				success:function(data){
					$(".modal-title").html("帖子修改");
					$(".modal-body").html(data);
				}
		})
		$('.btn.btn-primary').click(function(){
			rec_id=$('#Class:checked').val();
			ret_id=$('#Topic:checked').val();
			re_title=$('#title').val();
			re_content=$('#content').val();
			$.ajax({
				url:'?action=bbsrecontentyes',
				type:'post',
				data:{
					tid:tid,
					rec_id:rec_id,
					ret_id:ret_id,
					re_title:re_title,
					re_content:re_content
					},
				timeout:'15000',
				async:true,
					success:function(data){
						layer.alert(data,{shadeClose:true,title:''});
					}
			});
			$('#myModal').modal('hide')
		})
	});

//功能-帖子管理-操作
	$("#bbsdoselect").change(function(){
		r_do=$('#bbsdoselect option:selected').val();
		switch(r_do){
			case '1': case '2': case '3': case '4': case '11':
			$('input#r_num').hide();
			$('#r_class').hide();
			break;
			case '5': case '6': case '7': case '8': case '9':
				$('input#r_num').show();
				$('#r_class').hide();
			break;
			case '10':
				$('input#r_num').hide();
				$('#r_class').show();
			break;
		}
	});
	$("button#bbsdo").click(function(){
		r_do=$('#bbsdoselect option:selected').val();
		if (r_do==0){layer.tips('请选择操作', '#bbsdoselect', {tips: [1, '#0FA6D8']}); return;}
		var r_num,r_class;
		switch(r_do){
			case '1': case '2': case '3': case '4': case '11':
			$('input#r_num').hide();
			$('#r_class').hide();
			break;
			case '5': case '6': case '7': case '8': case '9':
				$('input#r_num').show();
				$('#r_class').hide();
				r_num=$('input#r_num').val();
				if (!r_num){layer.tips('输入数量', 'input#r_num', {tips: [1, '#0FA6D8']}); return;}
			break;
			case '10':
				$('input#r_num').hide();
				$('#r_class').show();
				r_class=$('#r_class input:checked').val();
				if (!r_class){layer.tips('没有选择栏目', '#r_class', {tips: [1, '#0FA6D8']}); return;}
			break;
		}
		if ($('input#kid:checked').length<1){layer.alert('请至少选择一条',{shadeClose:true,title:''}); return;}
		var kid=[];
		$('input#kid:checked').each(function(){
			kid.push($(this).val());
		})
		layer.confirm("确定?", {
		  btn: ['确定','取消']
		  ,shadeClose:true
		  ,title:''
		}, function(){
			layer.msg('操作执行中', {
			  icon: 16
			  ,shade: 0.1
			  ,time:3600000
			});
			$.ajax({
					url:'?action=bbsdo',
					type:'post',
					data:{
						r_do:r_do,
						kid:kid.join(','),
						r_num:r_num,
						r_class:r_class
						},
					async:true,
						success:function(data){
							layer.alert(data,{shadeClose:true,title:'操作结果'});
						}
			});
		});
	});
//功能-Vip每日抽奖-vip设定
	$("button#Svip_Set").click(function(){
		vip_id=$(this).attr('vipid');
		if (vip_id==0){
			vipid=$('#s_vip'+vip_id+':checked').val();
		}else{
			vipid=$('#s_vip'+vip_id).val();
		}
		s_num=$('#s_num'+vip_id).val();
		if (!vipid) {layer.tips('不能为空', '#s_vip'+vip_id, {tips: [1, '#0FA6D8']}); return;}
		if (!s_num) {layer.tips('不能为空', '#s_num'+vip_id, {tips: [1, '#0FA6D8']}); return;}
		layer.confirm("确定?", {
		  btn: ['确定','取消']
		  ,shadeClose:true
		  ,title:''
		}, function(){
			$.ajax({
			url:'?action=vipset',
			type:'post',
			data:{
				vipid:vipid,
				s_num:s_num
				},
			timeout:'15000',
			async:true,
				success:function(data){
					layer.alert(data,{shadeClose:true,title:''});
				}
			})
		});		
	});
//功能-Vip每日抽奖-奖品设定
	$("button#Prize_Set").click(function(){
		s_id=$(this).attr('s_id');
		if (s_id==0){
			prize1=$('#prize1'+s_id).val();
			prize2=$('#prize2'+s_id).val();
			s_prize=$('#vip_prize'+s_id+':checked').val();
			s_id2=s_id;
		}else{
			s_id2=s_id;
			s_prize=$('#vip_prize'+s_id).val();
			prize1=$('#prize1'+s_id).val();
			prize2=$('#prize2'+s_id).val();
		}
		if (!s_prize) {layer.tips('不能为空', '#vip_prize'+s_id, {tips: [1, '#0FA6D8']}); return;}
		if (!prize1) {layer.tips('不能为空', '#prize1'+s_id, {tips: [1, '#0FA6D8']}); return;}
		if (!prize2) {layer.tips('不能为空', '#prize2'+s_id, {tips: [1, '#0FA6D8']}); return;}
		layer.confirm("确定?", {
		  btn: ['确定','取消']
		  ,shadeClose:true
		  ,title:''
		}, function(){
			$.ajax({
			url:'?action=prizeset',
			type:'post',
			data:{
				s_id:s_id2,
				s_prize:s_prize,
				prize1:prize1,
				prize2:prize2
				},
			timeout:'15000',
			async:true,
				success:function(data){
					layer.alert(data,{shadeClose:true,title:''});
				}
			})
		});		
	});
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
					$(".modal-title").html('资料查看');
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
					$(".modal-title").html('修改权限');
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
					$(".modal-title").html('修改VIP');
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
			$('#myModal').modal('hide')
		})
	});
//备份恢复-备份
	$("#backup").click(function(){
		ss1=$(this);
		ss1.button('loading');
		layer.msg('努力备份中', {
		  icon: 16
		  ,shade: 0.1
		  ,time:3600000
		});
		$.ajax({
			url:'?action=backup',
			type:'get',
			async:true,
				success:function(data){
					layer.msg(data,{time:2000,anim:6});
					ss1.button('reset');
				}
		})
		$('.content:eq(0)').load("? .content",function(){
			deldata();
			restore();
		});
		
	});
var deldata = function(){
//备份恢复-删除备份
	$("a#deldata").on('click',function(){
		tipword=$(this).attr("tiptext");
		dbname=$(this).attr("dbname")
		layer.confirm(tipword, {
		  btn: ['确定','取消']
		  ,shadeClose:true
		  ,title:''
		}, function(){
			$.ajax({
				url:'?action=deldata',
				type:'get',
				data:{
					dbname:dbname
					},
				async:true,
					success:function(data){
						layer.msg(data,{time:2000,anim:6});
						if (data.indexOf('成功')>=0) $("a[dbname='"+dbname+"']").parent().fadeOut(300).fadeIn(300).fadeOut(500);
						
					}
			})
		});	
	});
}
deldata();
var restore = function(){
//备份恢复-恢复备份
	$("a#restore").click(function(){
		ss=$(this);
		tipword=$(this).attr("tiptext");
		dbname=$(this).attr("dbname");
		fixow=$('#fixow').is(':checked')?1:0;
		layer.confirm(tipword, {
		  btn: ['确定','取消']
		  ,shadeClose:true
		  ,title:'恢复备份文件'
		}, function(){
			ss.button('loading');
			layer.msg('努力还原中，请稍后', {
			  icon: 16
			  ,shade: 0.1
			  ,title:'',
			  time:3600000
			});
			$.ajax({
				url:'?action=restore',
				type:'get',
				data:{
					dbname:dbname,
					fixow:fixow
					},
				async:true,
					success:function(data){
						if (data.indexOf('成功')>=0){
							$("a[dbname='"+dbname+"']").parent().fadeOut(300).fadeIn(300);
							layer.alert(data, {
							  icon: 1
							  ,shade: 0.1
							  ,title:'还原数据文件'
							});
						}else{
							layer.alert(data, {
							  icon: 2
							  ,shade: 0.1
							  ,title:'还原数据文件'
							});
						}
						ss.button('reset');
					}
			})
			
		});
	});
}
restore();

//权限管理管理-删除ID
	$(".DelId2").click(function(){
		tipword=$(this).attr("tiptext");
		uid=$(this).attr("id")
		layer.confirm(tipword, {
		  btn: ['确定','取消']
		  ,shadeClose:true
		  ,title:''
		}, function(){
			$.ajax({
				url:'?action=del',
				type:'post',
				data:{
					uid:uid
					},
				timeout:'15000',
				async:true,
					success:function(data){
						layer.msg(data,{time:2000,anim:6});
						if (data.indexOf('成功')>=0) $("a#"+uid).parent().parent().parent().fadeOut(300).fadeIn(300).fadeOut(500);
					}
			})
		});	
	});

//权限管理管理-添加ID
	$("button#maddid").click(function(){
		uid=$('#r_search').val();
		if (!uid) {
			layer.tips('不能为空', '#r_search', {tips: [1, '#0FA6D8']});
			return;
		}
		layer.confirm("添加"+uid, {
		  btn: ['确定','取消']
		  ,shadeClose:true
		  ,title:''
		}, function(){
			$.ajax({
				url:'?action=add',
				type:'post',
				data:{
					uid:uid
					},
				timeout:'15000',
				async:true,
					success:function(data){
						layer.msg(data,{time:2000,anim:6});
						if (data.indexOf('成功')>=0) $("a#"+uid).parent().parent().parent().fadeOut(300).fadeIn(300).fadeOut(500);
					}
			})
		});	
	});
//功能-会员ID转移
	$("#M-Id").click(function(){
		ss=$(this);
		r_id1=$('#uid1').val();
		r_id2=$('#uid2').val();
		if (!r_id1) {
			layer.tips('不能为空', '#uid1', {tips: [1, '#0FA6D8']});
			return;
		}
		if (!r_id2) {
			layer.tips('不能为空', '#uid2', {tips: [1, '#0FA6D8']});
			return;
		}
		layer.confirm("确定?", {
		  btn: ['确定','取消']
		  ,shadeClose:true
		  ,title:''
		}, function(){
			ss.button('loading');
			$.ajax({
			url:'?action=moveid',
			type:'post',
			data:{
				uid1:r_id1,
				uid2:r_id2
				},
			async:true,
				success:function(data){
					ss.button('reset');
					layer.alert(data,{shadeClose:true,title:''});
				}
			})
		});	
	});
//功能-sql语句执行
	$("#Exec_Sql_click").click(function(){
		ss=$(this);
		Edata=$('input#Edata:checked').val();
		Esql=$('#Esql').val();
		if (!Edata) {
			layer.tips('请至少选择一项', '#Edata', {tips: [1, '#0FA6D8']});
			return;
		}
		if (!Esql) {
			layer.tips('sql语句不能为空', '#Esql', {tips: [1, '#0FA6D8']});
			return;
		}
		layer.confirm("确定执行?", {
		  btn: ['确定','取消']
		  ,shadeClose:true
		  ,title:''
		}, function(){
			ss.button('loading');
			$.ajax({
			url:'?action=execsql',
			type:'post',
			data:{
				Edata:Edata,
				Esql:Esql
				},
			async:true,
				success:function(data){
					ss.button('reset');
					layer.alert(data,{shadeClose:true,title:''});
				}
			})
		});	
	});
//模态框监测，关闭后清除内容，解除事件绑定
	 $('#myModal').on('hide.bs.modal', function () {
		$('.btn.btn-primary').off("click");
		$(".modal-title,.modal-body").html("");
	})
//反选
	$("#chose").click(function(){
		$('input#kid').each(function(){
			$(this).prop("checked", $(this).is(':checked')?false:true);
		})
	})
//全选，取消
	$("#choseall").click(function(){
		if ($('input#kid').length!=$('input#kid:checked').length){
			$('input#kid').prop("checked", true);
		}else{
			$('input#kid').prop("checked", false);
		}
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