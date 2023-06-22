<?php
namespace app\index\controller;
use app\index\controller\Base;
use think\Db;
class Lockuser extends Base
{
    public function show_class_select($classname='class_select',$selectname='s_class'){
    	$data=Db('class')
    	->field('classid,classname')
    	->where(['userid'=>$this->k_data['siteid'],'typeid'=>16])
    	->select();
    	$d='<select name="'.$selectname.'" id="'.$classname.'" class="form-control">
    	<option value="">选择一个论坛</option>';
    	foreach ($data as $r){
    	    $d.='<option value="'.$r['classid'].'">'.$r['classname'].'('.$r['classid'].')</option>';
    	}
    	$d.='</select>';
    	return $d;
    }
    public function lockuser()
    {
        $this->isadmin();
        $s_class=input('get.s_class');
        $s_userid=input('get.s_userid');
        $s=['a.siteid'=>$this->k_data['siteid']];
        $s2=[];
        if ($s_class){
            $s['a.classid']=$s_class;
            $s2['s_class']=$s_class;
        }
        if ($s_userid){
            $s['a.lockuserid']=$s_userid;
            $s2['s_userid']=$s_userid;
        }
        $this->assign('show_class_select', [$this,'show_class_select']);
		$data=Db('[user_lock]')->alias('a')
		->join(['[class]'=>'b'],'a.classid=b.classid','left')
		->field('a.*,b.classname,DATEDIFF(dd, a.operdate, GETDATE()) as dtimes')
		->where($s)
		->order('id desc')
		->paginate(15,false,['query'=>$s2]);
        return view('/lockuser',['title'=>'柯林工具箱-小黑屋','list'=>$data]);
    }
    
    public function lockuserdo()
    {
        $this->isadmin();
        $r_do=input('post.r_do');
        switch ($r_do) {
          case 1:
            $tid=input('post.tid');
            Db('user_lock')->where('id','in',$tid)->delete();
            $msg='删除';
            break;
          case 2:
            $s_class=input('post.s_class');
            $s_days=input('post.s_days');
            $s_userid=input('post.s_userid');
            $r = Db('user')->where('userid',$s_userid)->where('siteid',$this->k_data['siteid'])->find();
            if (!$r) return $this->success('不存在的会员');
            $do=true;
            $msg='添加';

            $r2 = Db('user_lock')
            ->where('lockuserid',$s_userid)
            ->where('siteid',$this->k_data['siteid'])
            ->where('classid','0')
            ->where('lockdate','0')
            ->find();
            if ($r2){
                $do=false;
                $msg='全站永久加黑，无需重复添加';
            }else{
                $r2 = Db('user_lock')
                ->field('*,DATEDIFF(second, GETDATE(), DATEADD(day, [lockdate], [operdate])) as ss')
                ->where('lockuserid',$s_userid)
                ->where('siteid',$this->k_data['siteid'])
                ->where('classid','0')
                ->find();
                if ($r2 && $r2['ss']>0){
                    $do=false;
                    $msg='全站加黑未到期，无需重复添加';
                }else{
                    if ($s_class!=0 && $s_days!=0){
                        $r2 = Db('user_lock')
                        ->field('*,DATEDIFF(second, GETDATE(), DATEADD(day, [lockdate], [operdate])) as ss')
                        ->where('lockuserid',$s_userid)
                        ->where('siteid',$this->k_data['siteid'])
                        ->where('classid',$s_class)
                        ->find();
                        if ($r2 && $r2['ss']>0){
                            $do=false;
                            $msg='在'.$s_class.' 的加黑未到期，无需重复添加';
                        }
                    }elseif($s_class!=0 && $s_days==0){
                        $r2 = Db('user_lock')
                        ->where('lockuserid',$s_userid)
                        ->where('siteid',$this->k_data['siteid'])
                        ->where('classid',$s_class)
                        ->where('lockdate','0')
                        ->find();
                        if ($r2){
                            $do=false;
                            $msg='在'.$s_class.' 已永久加黑，无需重复添加';
                        }
                    }
                }
            }
            $datas=[
              'siteid'=>$this->k_data['siteid'],
              'lockuserid'=>$s_userid,
              'lockdate'=>$s_days,
              'operdate'=>''.date('Y-m-d H:i:s').'',
              'operuserid'=>$this->k_data['userid'],
              'classid'=>$s_class,
                ];
            if ($do){
                Db('user_lock')->insert($datas);
            }
            break;
        }
        return $this->success($msg);
    }
}