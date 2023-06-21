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
            $datas=[
              'siteid'=>$this->k_data['siteid'],
              'lockuserid'=>$s_userid,
              'lockdate'=>$s_days,
              'operdate'=>''.date('Y-m-d H:i:s').'',
              'operuserid'=>$this->k_data['userid'],
              'classid'=>$s_class,
                ];
            Db('user_lock')->insert($datas);
            $msg='添加';
            break;
        }
        return $this->success($msg);
    }
}