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
        }elseif ($action=='back'){
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
            $name=input('post.name');
            $path = ROOT_PATH.'backup\\'.$name;
            $sapassword = input('post.sapassword');
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
                //$b=$r->execute('RESTORE DATABASE ['.$kelink_dbname.'] WITH RECOVERY;');
                sleep(1);//等待1秒，否则出错
                $b=$r->execute('use ['.$kelink_dbuser.'];execute Sp_changedbowner \''.$kelink_dbuser.'\',true');//设置ow权限
                return $this->success('还原成功');
        }
    }
}
