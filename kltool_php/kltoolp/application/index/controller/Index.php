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
    public function redbag_admin()
    {
        $this->kltooluse();
    }
    public function cdk()
    {
        
        $path = ROOT_PATH .  DS .'backup/';
        $files = File::readDir($path);
        print_r($files);
        //return view('/backup',['title'=>'柯林工具箱-数据库备份','list'=>$files]);
    }
    public function backup()
    {
        $path = ROOT_PATH.'backup\\';
        if (!is_dir($path)) $this->error('目录错误');
        $files = glob($path . "*");
        return view('/backup',['title'=>'柯林工具箱-数据库备份','list'=>$files]);
    }
    public function k_backup()
    {
        $action=input('post.action');
        $name=input('post.name');
        $fixow=input('post.fixow');
        $sapassword=input('post.sapassword');
        if ($action=='submit'){
            $name = time();
            $path = ROOT_PATH.'backup\\'.$name.'.bak';
            $a = Db::execute("backup database aaaaa to disk='{$path}' WITH NOFORMAT, INIT, NAME = N'备份{$name}', SKIP, NOREWIND, NOUNLOAD");
            if (is_file($path)){
                return $this->success('备份成功');
            }else{
                return $this->success('失败');
            }
        }elseif ($action=='del'){
            $path = ROOT_PATH.'backup\\'.$name;
            if (!is_file($path)) return $this->success('备份文件不存在'.$path);
            @unlink($path);
            if (is_file($path)){
                return $this->success('删除失败');
            }else{
                return $this->success('删除成功');
            }
        }
    }
}
