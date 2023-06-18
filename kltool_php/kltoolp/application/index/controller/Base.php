<?php
namespace app\Index\controller;
use think\Controller;
use think\Session;
use think\Cookie;
use think\Db;
use think\Request;
class Base extends Controller
{
    protected $k_data = [];
    protected function _initialize()
    {
		$weekarray = ["日","一","二","三","四","五","六"];
		$mytime = date('Y-m-d H:i:s').' 星期'.$weekarray[date("w")];
		$mytime2 = date('i');
		$kltool_path = '/kltoolp/';
		$siteid=1000;
		$userid=0;
		$sessionid=NULL;
		$kdata=[];
		if ($this->getsid()){
			$sid1 = explode('-',$this->getsid())[0];
			$sid_str = explode('_',$this->decode_sid($sid1));
			$siteid=$sid_str[0];
			$userid=$sid_str[2];
			$sessionid=$sid_str[4];
			$login_r = Db('user')->field('username,nickname,password,managerlvl,money,moneyname,logintimes,lockuser,headimg,sessiontimeout,endtime,SidTimeOut,mybankmoney,mybanktime,DATEDIFF(dd, mybanktime, GETDATE()) as dtimes,expR,RMB')->where('userid',$userid)->where('siteid',$siteid)->find();
			if ($login_r){
				$kdata=[
					'getusername'=>$login_r['username'],
					'nickname'=>$login_r['nickname'],
					'password'=>$login_r['password'],
					'managerlvl'=>$login_r['managerlvl'],
					'money'=>$login_r['money'],
					'moneyname'=>$login_r['moneyname'],//勋章
					'logintimes'=>$login_r['logintimes'],
					'lockuser'=>$login_r['lockuser'],
					'headimg'=>$login_r['headimg'],//头像
					'sessiontimeout'=>$login_r['sessiontimeout'],//会员身份
					'endtime'=>$login_r['endtime'],//过期时间
					'SidTimeOut'=>$login_r['SidTimeOut'],
					'mybankmoney'=>$login_r['mybankmoney'],
					'mybanktime'=>$login_r['mybanktime'],
					'dtimes'=>$login_r['dtimes'],
					'expR'=>$login_r['expR'],
					'RMB'=>number_format($login_r['RMB'], 2, '.', '')
				];
				if (!$login_r['dtimes']) $kdata['dtimes']=0;
				$login_m=Db('wap_message')->where('isnew',1)->where('siteid',$siteid)->where('touserid',$userid)->count();
				$kdata['message']=$login_m;
			}
			
		}
		$r = Db('user')->where('siteid',$siteid)->find();
		$sitemoneyname = $r['sitemoneyname'];
		$kdata=array_merge($kdata,
			['siteid'=>$siteid,
			'userid'=>$userid,
			'mytime'=>$mytime,
			'mytime2'=>$mytime2,
			'kltool_path'=>$kltool_path,
			'sitemoneyname'=>$sitemoneyname,
			'sessionid'=>$sessionid,
		]);
        $this->k_data = $kdata;
        $this->assign('k_data', $this->k_data);
    }
    protected function getsid()
    {
		$domain = explode('.',input('server.SERVER_NAME'))[0];
		$sidx = "sid".$domain;
		return Cookie::has($sidx) ? Cookie::get($sidx) : NULL;
    }
    protected function kltooluse()
    {
        $namephp=request()->action();
		$kltooluse = Db('kltool')->where('kaction',''.explode('_',$namephp)[0].'')->find();
		return $kltooluse && $kltooluse['use']==1?'':$this->error('功能未启用','/');
    }
    //判断是否登录,返回真假
    protected function login()
    {
		if (!$this->getsid()) return false;
		if (!$this->k_data['userid']) return false;
		if (!$this->k_data['sessionid']) return false;
		$login_r = Db('user')->where('userid',$this->k_data['userid'])->find();
		if ($login_r['SidTimeOut'] != $this->k_data['sessionid']) return false;
		return true;
    }
    //判断是否管理员,返回真假
    protected function admin()
    {
		$login_a=Db('kltool_admin')->where('userid',$this->k_data['userid'])->find();
		return $login_a?true:false;
    }
    //判断是否登录
    protected function islogin()
    {
		if (!$this->login()){
			return $this->error('未登录,请登录后访问','/');
		}
    }
    //判断是否管理员
    protected function isadmin()
    {
		if (!$this->login() || !$this->admin() ){
			return $this->error('你不是管理员','',0,300);
		}
    }
	protected function decode_sid($sid) {
	  $x=$sid;
	  $lens=strlen($x);
	  $mykey=intval(substr($x,$lens-1,1));
	  $x=substr($x,0,$lens-1);
	  if ($mykey == 0 || $mykey == 2) {
		$lens=strlen($x);
	  }
	  if ($lens % 2 == 0) {
		$key=2;
	  }
	  else {
		$key=3;
	  }
	  $str='';
	  for ($i=1; $i<=$lens; $i+=$key) {
		$TempNum=substr($x,$i-1,$key);
		if ($i == 1) {
		  if ($mykey == 1) {
			$TempNum=substr($TempNum,-2);
		  }
		  elseif ($mykey == 2) {
			$TempNum=substr($TempNum,-1);
		  }
		}
		$str=$TempNum.$str;
	  }
	  return $str;
	}
}