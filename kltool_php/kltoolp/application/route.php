<?php
// +----------------------------------------------------------------------
// | ThinkPHP [ WE CAN DO IT JUST THINK ]
// +----------------------------------------------------------------------
// | Copyright (c) 2006~2018 http://thinkphp.cn All rights reserved.
// +----------------------------------------------------------------------
// | Licensed ( http://www.apache.org/licenses/LICENSE-2.0 )
// +----------------------------------------------------------------------
// | Author: liu21st <liu21st@gmail.com>
// +----------------------------------------------------------------------
use think\Route;
Route::group('',function(){
    Route::post('kuse','index/k_use');
    
    Route::get('admins','index/k_admins');
    Route::post('madmin','index/k_admin');
    
    Route::get('redbag','index/redbag');
    Route::get('redbag_admin','index/redbag_admin');
    
    Route::get('backup','index/backup');
    Route::post('kbackup','index/k_backup');
    
    Route::get('bbs','index/bbs');
    Route::post('bbsdo','index/bbsdo');
    Route::post('postdo','index/postdo');
    
    Route::get('bbsre','index/bbsre');
    Route::post('bbsredo','index/bbsredo');
    
    
    
    
    
});
return [
    '__pattern__' => [
        'name' => '\w+',
    ],
    '[phpinfo]'     => [
        '/'   => ['index/phpinfo'],
    ],
    /*
    '[test]'     => [
        '/'   => ['index/test'],
    ],
    '[kadmin]'     => [
        '/'   => ['index/k_admin',['method' => 'post']],
    ],
    */
];
