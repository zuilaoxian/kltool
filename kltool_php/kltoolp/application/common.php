<?php
// +----------------------------------------------------------------------
// | ThinkPHP [ WE CAN DO IT JUST THINK ]
// +----------------------------------------------------------------------
// | Copyright (c) 2006-2016 http://thinkphp.cn All rights reserved.
// +----------------------------------------------------------------------
// | Licensed ( http://www.apache.org/licenses/LICENSE-2.0 )
// +----------------------------------------------------------------------
// | Author: 流年 <liu21st@gmail.com>
// +----------------------------------------------------------------------


/*
use think\Session;
use think\Cookie;
use think\Db;
*/
use think\Db;
use think\Controller;
use think\Request;
use think\Session;
// 应用公共文件
function getmydata(){
    return '555555....';
}
function show_user_nick($uid){
		$data=Db('user')->alias('a')
		->join(['[wap2_smallType]'=>'b'],'a.SessionTimeout=b.id','left')
		->field('a.userid,a.nickname,a.SessionTimeout,b.id as vip,b.subclassName as vipstr')
		->where('a.userid',$uid)
		//a.userid=1000 and (b.id is null or a.SessionTimeout=b.id)
		->where(function($query){
            $query->whereNUll('b.id')
                  ->whereOr('a.SessionTimeout',Db::raw('b.id'));
        })
		->find();
		$nick='';
		if ($data['SessionTimeout']){
		    $vip_str = decode_vip($data['vipstr']);
		    if ($vip_str['type']=='img'){
		        $nick.=$vip_str['vip'];
		    }
		    if (isset($vip_str['color']) && $vip_str['color']!=''){
		       $nick.='<font color="#'.$vip_str['color'].'">'.$data['nickname'].'</font>';
		    }
		}
		if (!$data['nickname']) $nick='无名会员';
    return $nick?$nick:$data['nickname'];
}

function decode_vip($str){
    // 示例 : 白银会员#ff0000_1_1 /NetImages/vip.gif#ff0000_1_1 名称/图标#颜色_发帖币加成_回帖经验加成_价格
    $vip_str=[];
    $str_s = explode('#',$str);
    
    $vip_str['vip']=$str_s[0];
    $vip_str['type']='word';
    if (preg_match('/.*\.(jpg|png|gif|bmp|jpeg|webp)$/i', $str_s[0])){
        $vip_str['vip']='<img src="'.$str.'">';
        $vip_str['type']='img';
    }
    if (isset($str_s[1])){
        $str2_2=explode('_',$str_s[1]);
        $vip_str['color']=$str2_2[0]??'';
        $vip_str['post']=$str2_2[1]??'';
        $vip_str['reply']=$str2_2[2]??'';
        $vip_str['price']=$str2_2[3]??'';
    }
    return $vip_str;
}

function show_user_headimg($uid){
	$headimg = Db('user')->field('headimg')->where('userid',$uid)->find()['headimg'];
	if (stristr($headimg,'ximg/')) return '<img decoding="async" src="/'.$headimg.'" class="img-circle" width="60">';
	if (!stristr($headimg,'/')) return '<img decoding="async" src="/bbs/head/'.$headimg.'" class="img-circle" width="70">';
	if (stristr($headimg,'http')) return '<img decoding="async" src="'.$headimg.'" class="img-circle" width="60">';
}

function get_user_headimg($uid){
	$headimg = Db('user')->field('headimg')->where('userid',$uid)->find()['headimg'];
	if (stristr($headimg,'ximg/')) return '/'.$headimg;
	if (!stristr($headimg,'/')) return '/bbs/head/'.$headimg;
	if (stristr($headimg,'http')) return $headimg;
}
function cut_str($param){
    return explode($param['e'],explode($param['s'],$param['str'])[1])[0];
}

//字节转MB
function fileSizeConvert($bytes) {
  $_retval=$bytes;
  if ($bytes < 1024) {
    $_retval=round($bytes, 0)."B";
  }
  elseif ($bytes >= 1024 && $bytes < 1048576) {
    $_retval=round($bytes / 1024, 1)."KB";
  }
  elseif ($bytes >= 1048576) {
    $_retval=round(($bytes / 1024) / 1024, 2)."MB";
  }elseif ($bytes >= 1073741824) {
    $_retval = round($bytes / 1024 / 1024 / 1024, 2) . 'GB';
  }
  return $_retval;
}