# kltool
 柯林工具箱php版
 - 这个版本依然采用了嵌入柯林系统本身的写法，不过采用了thinkphp框架，版本是`5.0.24`
 
### php支持说明

配置sqlsrv支持，在windows下使用宝塔，目前php版本自带驱动，但需要自己安装OBDC驱动，我提供的`msodbcsql.msi`版本13，如果还是不行，请阅读`安装pdo_sqlsrv扩展.txt`

###  柯林配置文件
使用了宝塔配置，归类在web_config文件夹中
着重说明以下嵌入后的伪静态问题
在rewrite.config的最后加入以下伪静态

```
<rule name="OrgPage_rewrite" stopProcessing="true">
	<match url="^kltoolp(.*)$"/>
	<conditions logicalGrouping="MatchAll">
		<add input="{HTTP_HOST}" pattern="^(.*)$"/>
		<add input="{REQUEST_FILENAME}" matchType="IsFile" negate="true"/>
		<add input="{REQUEST_FILENAME}" matchType="IsDirectory" negate="true"/>
	</conditions>
	<action type="Rewrite" url="kltoolp/index.php/{R:1}"/>
</rule>
```

更改tp5的入口文件`\public\index.php`到`kltoolp`目录
并修改为以下

```
// 定义应用目录
define('APP_PATH', __DIR__ . '/application/');
// 加载框架引导文件
require __DIR__ . '/thinkphp/start.php';
```


### 目录说明

- application\config.php 配置文件
- application\database.php 配置数据库连接
- application\route.php 路由规则
- application\common.php 公共函数
- application\index\controller\Base.php 全局引用文件，包含全局变量k_data
- application\index\controller\Index.php 应用文件
- \backup 备份目录
- \uploads 上传目录
- \template 模板目录

### 使用说明

- 在需要限制admin权限的地方使用$this->isadmin(),判断是否admin:$this->admin()，默认admin：1000
- 在需要限制登录权限的地方使用$this->islogin(),判断是否登录:$this->login()
- k_data包含众多当前登录用户信息以及站点信息，个人站内信数量等等，后端使用$this->k_data['siteid'],前端使用{$k_data['siteid']}
- common.php中写了公共函数，在模板中：{$k_data['userid']|show_user_nick} , 单独的函数：{:getmydata()}
- 模板中的页面标题为后端传值，如：return view('/index',['title'=>'柯林工具箱']);
- 简单写了几个页面，等待更新
