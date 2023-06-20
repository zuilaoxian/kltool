<?php
namespace app\index\controller;
use app\index\controller\Base;
use think\Db;
use think\File;
class Index extends Base
{
    public function phpinfo()
    {
        phpinfo();
    }
    /*工具箱首页*/
    public function index()
    {
		$this->isadmin();
		$r = Db('kltool')->order('[use] desc,show desc,[order]')->select();
		$this->assign('list', $r);
        return view('/index',['title'=>'柯林工具箱']);
    }
    public function k_use()
    {
        $this->isadmin();
		$tid=input('post.id');
		$k_use=Db('kltool')->where('id',$tid)->update(['use'=>Db::raw('1-[use]')]);
		$msg=Db('kltool')->find($tid)['use']!=1?'停用':'启用';
        $this->success($msg.'-成功','',$msg);
    }
    /*权限管理*/
    public function k_admins()
    {
		$this->isadmin();
		$r = Db('kltool_admin')->select();
		$this->assign('list', $r);
        return view('/admins',['title'=>'柯林工具箱-权限管理']);
    }
    public function k_admin()
    {
        $this->isadmin();
		$tid=input('post.tid');
		$action=input('post.action');
		    $auserid=Db('user')->where('userid',$tid)->find();
		    $buserid=Db('kltool_admin')->where('userid',$tid)->find();
		if ($action=='submit'){
		    if ($buserid) return $this->error('已存在的ID:'.show_user_nick($tid));
		    if (!$auserid) return $this->error('不存在的ID:'.$tid);
		    Db('kltool_admin')->insert(['userid'=>$tid]);
		    return $this->success('添加:'.show_user_nick($tid));
		}else{
		    if (!$buserid) return $this->error('不存在的ID:'.$tid);
    		if ($tid>1 && $tid!=$this->k_data['siteid']){
    		    Db('kltool_admin')->where('userid',$tid)->delete();
    		    return $this->success('删除管理:'.show_user_nick($tid));
    		}
    		return $this->error('受保护的ID:'.show_user_nick($tid));
		}
    }
    public function backup()
    {
        $this->isadmin();
        $path = ROOT_PATH.'backup\\';
        if (!is_dir($path)) return $this->error('目录错误');
        $files = glob($path . "*");
            $data=[];
        if ($files){
            foreach ($files as $r){
                $data[]=[
                    'file'=>$r,
                    'size'=>filesize($r),//文件大小
                    'ctime'=>filectime($r),//创建时间
                    'mtime'=>filemtime($r),//修改时间
                    //'info'=>pathinfo($r)
                    ];
            }
        }
        return view('/backup',['title'=>'柯林工具箱-数据库备份','list'=>$data]);
    }
    public function k_backup()
    {
        $this->isadmin();
        $action=input('post.action');
        $name=input('post.name');
        $fixow=input('post.fixow');
        $sapassword=input('post.sapassword');
        $kelink_config=@file_get_contents($_SERVER['DOCUMENT_ROOT'].'/web.config');
        $kelink_dbname=@cut_str([
                's'=>'KL_DatabaseName" value="',
                'e'=>'"',
                'str'=>$kelink_config,
            ]);
        $kelink_dbuser=@cut_str([
                's'=>'KL_SQL_UserName" value="',
                'e'=>'"',
                'str'=>$kelink_config,
            ]);
        if ($action=='submit'){
            $name = time();
            $path = ROOT_PATH.'backup\\'.$name.'.bak';
            $a = Db::execute("backup database [{$kelink_dbname}] to disk='{$path}' WITH NOFORMAT, INIT, NAME = N'备份{$name}', SKIP, NOREWIND, NOUNLOAD");
            if (is_file($path)){
                return $this->success('备份成功');
            }else{
                return $this->error('失败');
            }
        }elseif ($action=='del'){
            $path = ROOT_PATH.'backup\\'.$name;
            if (!is_file($path)) return $this->success('备份文件不存在'.$path);
            @unlink($path);
            if (is_file($path)){
                return $this->error('删除失败');
            }else{
                return $this->success('删除成功');
            }
        }elseif ($action=='back'){
            $path = ROOT_PATH.'backup\\'.$name;
            $config= [
                    'type'        => 'sqlsrv',
                    'hostname'    => '127.0.0.1',
                    'database'    => 'master',
                    'username'    => 'sa',
                    'password'    => $sapassword,
                    'charset'     => 'utf8',
                    'prefix'          => '',
                    'auto_timestamp'  => true,
                ];
                $r= Db::connect($config);
                $b=$r->execute('ALTER DATABASE ['.$kelink_dbname.'] SET OFFLINE WITH ROLLBACK IMMEDIATE;');//使数据库离线
                $b=$r->execute('RESTORE DATABASE ['.$kelink_dbname.'] FROM DISK = N\''.$path.'\' WITH FILE = 1,RECOVERY,NOUNLOAD,REPLACE;');//还原数据库，从文件覆盖
                sleep(1);//等待1秒，否则出错
                $b=$r->execute('use ['.$kelink_dbuser.'];execute Sp_changedbowner \''.$kelink_dbuser.'\',true');//设置ow权限
                return $this->success('还原成功');
        }
    }

    public function show_topic_select($classname='topic_select',$selectname='s_topic'){
    	$data=Db('[wap2_smalltype]')
    	->where('siteid',$this->k_data['siteid'])
    	->where('systype','like','bbs%')
    	->select();
    	$d='<select name="'.$selectname.'" id="'.$classname.'" class="form-control">
    	<option value="0">所有专题</option>';
    	foreach ($data as $r){
    	    $d.='<option value="'.$r['id'].'">class:'.str_replace('bbs','',$r['systype']).' - 专题:'.$r['subclassName'].'('.$r['id'].')</option>';
    	}
    	$d.='</select>';
    	return $d;
    }
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
    public function bbs()
    {
        $this->isadmin();
        $this->assign('show_class_select', [$this,'show_class_select']);
        $this->assign('show_topic_select', [$this,'show_topic_select']);
        $s_class=input('get.s_class');
        $s_userid=input('get.s_userid');
        $s=['a.userid'=>$this->k_data['siteid']];
        $s2=[];
        if ($s_class){
            $s['a.book_classid']=$s_class;
            $s2['s_class']=$s_class;
        }
        if ($s_userid){
            $s['a.book_pub']=$s_userid;
            $s2['s_userid']=$s_userid;
        }
		$data=Db('wap_bbs')->alias('a')
		->join(['[class]'=>'b'],'a.book_classid=b.classid','left')
		->field('a.id,a.userid,a.book_classid,b.classname,a.book_title,a.book_content,a.book_author,a.book_pub,a.book_re,a.book_click,a.book_date,a.book_good,a.suport,a.topic,a.islock,a.isCheck')
		->where($s)
		->order('id desc')
		->paginate(15,false,['query'=>$s2]);
        return view('/bbs',['title'=>'柯林工具箱-帖子管理','list'=>$data]);
    }
    public function bbsdo()
    {
        $this->isadmin();
        $r_do = input('post.r_do');
        $tid = input('post.tid');
        $r_num = input('post.r_num');
        $r_class = input('post.r_class');
        if ($r_num && !is_numeric($r_num)) return $this->error('数量必须是数字');
        switch ($r_do) {
          case 1:
            Db('wap_bbs')->where('id','in',$tid)->update(['isCheck'=>2]);
            $msg='删除帖子';
            break;
          case 2:
            Db('wap_bbs')->where('id','in',$tid)->update(['isCheck'=>0]);
            $msg='恢复帖子';
            break;
          case 3:
            Db('wap_bbs')->where('id','in',$tid)->update(['islock'=>1]);
            $msg='锁定帖子';
            break;
          case 4:
            Db('wap_bbs')->where('id','in',$tid)->update(['islock'=>0]);
            $msg='解锁帖子';
            break;
          case 11:
            Db('wap_bbs')->where('id','in',$tid)->delete();
            $msg='彻底删除帖子';
            break;
          case 5:
            Db('wap_bbs')->where('id','in',$tid)->update(['book_click'=>Db::raw('[book_click]+'.$r_num)]);
            $msg='帖子增加阅读量';
            break;
          case 6:
            Db('wap_bbs')->where('id','in',$tid)->update(['book_click'=>Db::raw('[book_click]-'.$r_num)]);
            $msg='帖子减少阅读量';
            break;
          case 8:
            Db('wap_bbs')->where('id','in',$tid)->update(['suport'=>Db::raw('[suport]+'.$r_num)]);
            $msg='帖子增加点赞量';
            break;
          case 9:
            Db('wap_bbs')->where('id','in',$tid)->update(['suport'=>Db::raw('[suport]-'.$r_num)]);
            $msg='帖子减少点赞量';
            break;
          case 10:
            Db('wap_bbs')->where('id','in',$tid)->update(['book_classid'=>$r_class]);
            $msg='转移栏目';
            break;
          case 7:
            foreach(explode(',',$tid) as $r){
                if ($r){
                    $datas=[];
                    for($i=0;$i<$r_num;$i++){
                        $v = Db('kltool_reply_words')->where('xy',1)->order('NewID()')->find();
                        $vv = Db('user')->where('siteid',$this->k_data['siteid'])->order('NewID()')->find();
                        $cid= db('wap_bbs')->where('id',$r)->find()['book_classid'];
                        $datas[]=[
							'devid'=>$this->k_data['siteid'],
							'userid'=>$vv['userid'],
							'nickname'=>$vv['nickname'],
							'classid'=>$cid,
							'content'=>$v['content'],
							'bookid'=>$r,
							'myGetMoney'=>'0',
							'book_top'=>'0',
							'isCheck'=>'0',
							'HangBiaoShi'=>'0',
							'isdown'=>'0',
							'reply'=>'0',
                            ];
                    }
                    $result = Db::name('wap_bbsre')->insertAll($datas);
                    Db('wap_bbs')->where('id',$r)->update(['book_re'=>db::raw('[book_re]+'.$r_num)]);
                }
            }
            $msg='增加回复';
            break;
        }
        return $this->success($msg);
    }
    public function postdo()
    {
        $this->isadmin();
        $r_do=input('post.r_do');
        $tid=input('post.tid');
        if ($r_do=='getpost'){
            return Db('wap_bbs')->where('id',$tid)->find();
        }elseif($r_do=='editpost'){
            $r_id=input('post.r_id');
            $r=[
                'book_title'=>input('post.r_title'),
                'book_classid'=>input('post.s_class'),
                'book_content'=>input('post.r_content'),
                'topic'=>input('post.r_topic')
                ];
            Db('wap_bbs')->where('id',$r_id)->update($r);
            return $this->success('修改成功');
        }
    }
    public function bbsre()
    {
        $this->isadmin();
		$data=Db('[kltool_reply_words]')
		->order('id desc')
		->paginate(15);
        return view('/bbsre',['title'=>'柯林工具箱-回复语管理','list'=>$data]);
    }
    public function bbsredo()
    {
        $this->isadmin();
        $r_do=input('post.r_do');
        $tid=input('post.tid');
        switch ($r_do) {
          case 1:
            Db('kltool_reply_words')->where('id','in',$tid)->delete();
            $msg='删除';
            break;
          case 2:
            Db('kltool_reply_words')->where('id','in',$tid)->update(['xy'=>1]);
            $msg='启用';
            break;
          case 3:
            Db('kltool_reply_words')->where('id','in',$tid)->update(['xy'=>0]);
            $msg='停用';
            break;
          case 4:
            return Db('kltool_reply_words')->where('id',$tid)->find();
            break;
          case 5:
            $r_content=input('post.r_content');
            $r_xy=input('post.r_xy');
            $r_id=input('post.r_id');
            Db('kltool_reply_words')->where('id',$r_id)->update(['content'=>$r_content,'xy'=>$r_xy]);
            $msg='修改成功';
            break;
          case 6:
            $r_content=input('post.r_content');
            $r_xy=input('post.r_xy');
            Db('kltool_reply_words')->insert(['content'=>$r_content,'xy'=>$r_xy]);
            $msg='新增成功';
            break;
        }
        return $this->success($msg);
    }
}
