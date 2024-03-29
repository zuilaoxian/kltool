SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[kltool](
	[id] [int] IDENTITY (1,1) not null PRIMARY key,
	[name] [ntext] NULL,
	[title] [ntext] NULL,
	[content] [ntext] NULL,
	[order] [int] NULL,
	[use] [int] NULL,
	[show] [int] NULL,
	[kaction] varchar(50) NULL,
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET IDENTITY_INSERT [dbo].[kltool] ON
GO
INSERT [dbo].[kltool] ([id], [name], [title], [content], [order], [use], [show] ,[kaction]) VALUES (1,N'互动红包', N'<a href="[kltool_path]RedBag/index.asp">互动红包</a><br/><a href="[kltool_path]RedBag/admin.asp">后台</a>', N'', 25, 0, 0,N'redbag'),(2,N'vip每日抽奖', N'<a href="[kltool_path]Svip/index.asp">vip每日抽奖</a><br/><a href="[kltool_path]Svip/admin.asp">后台</a>  <a href="[kltool_path]Svip/admin.asp?action=log">日志</a>', N'', 30, 1, 1,N'svip'),(3,N'CDK兑换系统', N'<a href="[kltool_path]Cdk/index.asp">CDK兑换系统</a><br/><a href="[kltool_path]Cdk/admin.asp">后台</a>', N'', 5, 1, 1,N'cdk'),(4,N'自助开通VIP', N'<a href="[kltool_path]Vip/index.asp">自助开通VIP</a><br/><a href="[kltool_path]Vip/admin.asp">后台</a>  <a href="[kltool_path]Vip/admin.asp?action=log">日志</a>', N'', 20, 1, 1,N'vip'),(5,N'帖子管理', N'<a href="[kltool_path]bbs/Bbs.Asp">帖子管理</a><br/><a href="[kltool_path]bbs/bbs.Asp?action=bbsreword">回复语设置</a>', N'帖子管理，一键增加回复等', 35, 1, 1,N'bbs'),(6,N'网站币互转', N'<a href="[kltool_path]money/index.asp">网站币互转</a><br/><a href="[kltool_path]money/admin.asp">后台</a>  <a href="[kltool_path]money/admin.asp?action=log">日志</a>', N'', 100, 0, 0,N'money'),(9,N'修改起始id', N'<a href="restartID.Asp">修改起始id</a>', N'修改各种起始id,还可以自定义表。', 40, 1, 1, N'money'),(10,N'网站会员管理', N'<a href="hy.asp">网站会员管理</a>', N'网站会员便捷管理', 10, 1, 1, N'userlist'),(11,N'注册任意ID', N'<a href="RegisterId.asp">注册任意ID</a>', N'批量注册任意ID', 15, 1, 1, N'registeid'),(12,N'帖子带专题发布通道', N'<a href="[kltool_path]bbs/BbsTopic.Asp">帖子带专题发布通道</a>', N'帖子带专题发布', 55, 1, 1, N'bbstopic'),(13,N'头像裁剪上传', N'<a href="[kltool_path]HeadImg/index.asp">头像裁剪上传</a>', N'头像在线裁剪上传<br/>前台链接:<b>[url=[kltool_path]HeadImg/index.asp]头像裁剪上传[/url]</b>', 60, 1, 1, N'headimg'),(14,N'修改会员签名', N'<a href="remark.Asp">修改会员签名</a>', N'修改会员签名', 65, 1, 1, N'remark'),(15,N'删除会员', N'<a href="delID.asp">删除会员</a>', N'删除会员', 70, 1, 1, N'delid'),(16,N'修改会员资料', N'<a href="UserData.asp">修改会员资料</a>', N'修改会员资料', 75, 1, 0, N'userdata'),(17,N'恢复插件功能指向', N'<a href="hf.Asp">恢复插件功能指向</a>', N'恢复插件功能指向', 80, 1, 1, N'hf'),(20,N'数据库备份', N'<a href="backup.Asp">数据库备份恢复</a>', N'数据库备份恢复', 85, 1, 1, N'backup'),(21,N'会员ID转移', N'<a href="moveid.Asp">会员ID转移</a>', N'会员ID转移', 87, 1, 1, N'moveid'),(22,N'Sql语句执行', N'<a href="ExecSql.Asp">Sql语句执行</a>', N'Sql语句执行', 89, 1, 1, N'execsql'),(23,N'网站域名转发', N'<a href="[kltool_path]Site.asp">网站域名转发</a>', N'网站域名转发', 105, 1, 1, N'site'),(24,N'会员加黑解黑', N'<a href="[kltool_path]LockUser.asp">会员加黑解黑</a>', N'会员加黑解黑', 110, 1, 1, N'lockuser')
GO
SET IDENTITY_INSERT [dbo].[kltool] OFF
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[kltool_logs](
	[id] [int] IDENTITY (1,1) not null PRIMARY key,
	[userid] [int] NULL,
	[things] [ntext] NULL,
	[time] [datetime] NULL,
	[uip] [ntext] NULL,
	[zt] [int] NULL,
	[type] [int] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[kltool_reply_words](
	[id] [int] IDENTITY (1,1) not null PRIMARY key,
	[content] [ntext] NULL,
	[xy] [int] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
INSERT [dbo].[kltool_reply_words] ([content], [xy]) VALUES (N'天下武功出少林，自古楼主出好贴', 1),(N'代表月亮消灭你', 1),(N'加油，么么哒！', 1),(N'楼主好帖！', 1),(N'难得一见的好贴。。。', 1),(N'我对楼猪的景仰犹如滔滔江水。。。绵绵不绝。。。又如黄河泛滥。。。一发。。。而不可收拾。。。', 1),(N'看完楼主的帖子，俺陷入了深深的不安与徘徊之中，这几天俺一直在思索一个比较严肃的问题，洗手还是不洗手？洗完手顶，还是不洗手就顶？我学了下子奥特曼，左手问了下右手，右手说，顶啊', 1),(N'楼主，是你让我深深地理解了‘人外有人，天外有天’这句话。谢谢侬！', 1),(N'我知道无论用多么华丽的辞藻来形容楼主您帖子的精彩程度都是不够的，都是虚伪的，所以我只想说一句：您的帖子太好看了！我愿意一辈子的看下去！', 1),(N'这篇帖子构思新颖，题材独具匠心，段落清晰，情节诡异，跌宕起伏，主线分明，引人入胜，平淡中显示出不凡的文学功底，可谓是字字珠玑，句句经典，是我辈应当学习之典范', 1),(N'现在终于明白我缺乏的是什么了，正是楼主那种对真理的执着追求和楼主那种对理想的艰苦实践所产生的厚重感。面对楼主的帖子，我震惊得几乎不能动弹了，楼主那种裂纸欲出的大手笔，竟使我忍不住一次次的翻开楼主的帖子，每看一次，赞赏之情就激长数分，我总在想，是否有神灵活在它灵秀的外表下，以至能使人三月不知肉味，使人有余音穿梁，三日不绝的感受。楼主，你写得实在是太好了。我唯一能做的，就只有把这个帖子顶上去这件事了。', 1),(N'楼主，你写得实在是太好了。我唯一能做的，就只有把这个帖子顶上去这件事了', 1)
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[kltool_admin](
	[id] [int] IDENTITY (1,1) not null PRIMARY key,
	[userid] [int] NULL
) ON [PRIMARY]
GO
INSERT [dbo].[kltool_admin] ([userid]) VALUES (1000)
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[kltool_svip](
	[id] [int] IDENTITY (1,1) not null PRIMARY key,
	[vip] [bigint] NULL,
	[num] [bigint] NULL
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[kltool_svip_prize](
	[id] [int] IDENTITY (1,1) not null PRIMARY key,
	[type] [bigint] NULL,
	[prize1] [money] NULL,
	[prize2] [money] NULL,
	[state] [bigint] NULL
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[kltool_cdk] (
	[id] [int] IDENTITY (1,1) not null PRIMARY key,
	[cdk] varchar(50) NULL,
	[jinbi] bigint NULL,
	[jingyan] bigint NULL,
	[rmb] money NULL,
	[sf] bigint NULL,
	[sff] bigint NULL,
	[lg] bigint NULL,
	[xg] ntext NULL,
	[lx] bigint NULL,
	[sy] bigint NULL,
	[time] datetime NULL,
	[userid] bigint NULL,
	[zs] bigint NULL,
	[chushou] bigint NULL,
	[jiage] bigint NULL,
	[jiage2] money NULL,
	[usetime] datetime NULL,
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[kltool_cdk_set] (
	ID int IDENTITY (1,1) not null PRIMARY key,
	[yh] bigint NULL,
	[lx] bigint NULL,
	[sl] bigint NULL,
	[vsl] bigint NULL
) ON [PRIMARY]
GO
INSERT [dbo].[kltool_cdk_set] ([lx]) VALUES (1),(2),(3),(4),(5),(6),(7)
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[kltool_cdk_log] (
	ID int IDENTITY (1,1) not null PRIMARY key,
	[userid] bigint NULL,
	[lx] bigint NULL,
	[cdk] varchar(50) NULL,
	[jia] bigint NULL,
	[jia2] money NULL,
	[ltime] datetime NULL
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER TABLE [dbo].[wap2_smallType] Add
	[jinbi] bigint NULL,
	[jinyan] bigint NULL,
	[rmb] money NULL,
	[xian] bigint NULL
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[wap2_smallType_log] (
	[id] int IDENTITY (1,1) not null PRIMARY key,
	[userid] bigint NULL,
	[lx] bigint NULL,
	[vip] bigint NULL,
	[yue] bigint NULL,
	[jinbi] bigint NULL,
	[jinyan] bigint NULL,
	[rmb] money NULL,
	[time] datetime NULL
) ON [PRIMARY]