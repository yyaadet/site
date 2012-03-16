CREATE DATABASE `starpass`;

USE `starpass`;

/*Table structure for table `sp_user` */

DROP TABLE IF EXISTS `sp_user`;

CREATE TABLE `sp_user` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `hash_id` char(32) NOT NULL DEFAULT '',
  `name` varchar(64) NOT NULL DEFAULT '',
  `regdate` int(10) NOT NULL DEFAULT '0',
  `email` varchar(128) NOT NULL DEFAULT '',
  `password` char(32) NOT NULL DEFAULT '',
  `sex` tinyint(3) NOT NULL DEFAULT '0',
  `flag` tinyint(3) NOT NULL DEFAULT '0',
  `verifystr` char(32) NOT NULL DEFAULT '',
  `group_id` int(10) NOT NULL DEFAULT '0',
  `password_level` int(10) NOT NULL DEFAULT '0',
  `star_coin` int(10) NOT NULL DEFAULT '0',
  `reg_ip` char(32) NOT NULL DEFAULT '',
  `last_ip` char(32) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

/*Data for the table `sp_user` */
insert  into `sp_user`(id,hash_id,name,regdate,email,password,sex,flag,verifystr,group_id,password_level,star_coin,reg_ip,last_ip) values 
(1,'0fca2ec9227c595fd0ff2694daba2e4d','admin',1236225061,'yyaadet2002@gmail.com','5e5e40a90c20853691830778b21efc21',1,1,'c00c6c5edcb841eca4ad747617374023',2,2,0,'222.131.244.94','222.131.244.94'),
(2,'af2e40c04962f4f519d8d2636ad80030','eastnx',1237120287,'eastnx@163.com','f06e1c5f3b7f7d4841a98dd73b826122',1,1,'c00c6c5edcb841eca4ad747617374023',2,2,0,'123.114.123.36','123.114.123.36'),
(3,'3cb1e5fe329ee62410b31527386296db','test1',1240392285,'ww@eee.com','698d51a19d8a121ce581499d7b701668',1,1,'c00c6c5edcb841eca4ad747617374023',2,2,0,'127.0.0.1','127.0.0.1'),
(4,'d567d318bc11d8657de10df4a71ba994','abc',1239256055,'abc@abc.com','900150983cd24fb0d6963f7d28e17f72',1,1,'c00c6c5edcb841eca4ad747617374023',2,2,0,'221.218.160.63','221.218.160.63'),
(5,'935e76357f333e7f25d9e382e25dbcdd','lqs',1239435112,'lqs.buaa@gmail.com','755f85c2723bb39381c7379a604160d8',1,1,'c00c6c5edcb841eca4ad747617374023',2,2,0,'219.239.227.38','219.239.227.38'),
(6,'1c47b04f8b30d3726b655c6fa7a1bac3','xuanbg',1239788023,'xuan_bingan@hotmail.com','41d01a1fc6fd4bd5960c1a5a6c542a90',1,1,'c00c6c5edcb841eca4ad747617374023',2,2,0,'123.113.113.201','123.113.113.201'),
(7,'4f22dacbc95ef8cd393ba8129ae339ae','aa',1239790281,'aa@aa.com','47bce5c74f589f4867dbd57e9ca9f808',1,1,'c00c6c5edcb841eca4ad747617374023',2,2,0,'123.113.113.201','123.113.113.201'),
(8,'8948fba4c22784474830d6bfeeeed7af','Test123',1239793700,'temo456@163.com','098f6bcd4621d373cade4e832627b4f6',1,1,'c00c6c5edcb841eca4ad747617374023',2,2,0,'203.86.43.186','203.86.43.186'),
(9,'2875b493fc8405f4b311157bde90a5bf','xiaotao',1240648881,'yyaadet2002@gmail.com','b25f8889fe20d2951383e68d5705264d',1,1,'c00c6c5edcb841eca4ad747617374023',2,2,0,'127.0.0.1','127.0.0.1'),
(10,'0873d82b346324b06276d2e8de96853a','nolibobo',1240726636,'xiaobopeng@yeah.net','9b6ec964ae89e563761834e4c610f6d7',1,1,'c00c6c5edcb841eca4ad747617374023',2,2,0,'127.0.0.1','127.0.0.1'),
(11,'e17be49dc5acc9f4c4af3bb09c8c1232','就是8说',1240823785,'sssims2@126.com','d8bf50f0935b8252615bdcc05f54bc3e',1,1,'c00c6c5edcb841eca4ad747617374023',2,2,0,'127.0.0.1','127.0.0.1'),
(12,'d7e6b1be1873b0c0c44828e89360c65b','xuchuanhang',1246234429,'xuchuanhang@163.com','d3786ec2413a8cd9413bfcb24be95a73',1,1,'c00c6c5edcb841eca4ad747617374023',2,2,0,'122.193.9.38','122.193.9.38'),
(13,'0d6aea6455b77d7726b4cbf5baf5c890','hi1985',1242962102,'hi1985@163.com','fad320735c03f8448a770520692ad3d1',1,1,'c00c6c5edcb841eca4ad747617374023',2,2,0,'222.131.242.134','222.131.242.134'),
(14,'677421434c99c1718c4c2f19e833f475','testt',1240913767,'test@test.com','dc0fa7df3d07904a09288bd2d2bb5f40',1,1,'c00c6c5edcb841eca4ad747617374023',2,2,0,'123.112.65.234','123.112.65.234'),
(15,'722aa1a171a94ef4a04b56802d86231c','776121383',1242842811,'sadness94@qq.com','4bd2a6fe23dff63d5c31f82cfbbb5d60',1,1,'c00c6c5edcb841eca4ad747617374023',2,2,0,'117.42.151.173','117.42.151.173'),
(16,'d051cdaeb2a335af747591427b261125','ghiewa',1241100103,'ghiewa@126.com','4dd56c2370b876bc19403adec6b12402',1,1,'c00c6c5edcb841eca4ad747617374023',2,2,0,'114.217.205.32','114.217.205.32'),
(17,'9cf9e0b2c5cc88da9c8c332c6e6e178c','杜文山',1247214827,'du@baow.com','550fc004c6af2c3ae5953798f8e238d9',1,1,'c00c6c5edcb841eca4ad747617374023',2,2,0,'117.136.0.190','117.136.0.190'),
(18,'844b0264a1ea666f2ace4b37fa2d699a','imouren',1247235011,'mouren11@163.com','2ff01bc98f6fb10b55f7af066b561578',1,1,'c00c6c5edcb841eca4ad747617374023',2,2,0,'221.221.166.25','221.221.166.25'),
(19,'8f056c8d4a6da97e6eb77fa51b0a57f2','bjhongda',1247936373,'hongdazuanye@163.com','7815058943fcaccc35088e65335f30f2',1,1,'c00c6c5edcb841eca4ad747617374023',2,2,0,'123.114.102.193','123.114.102.193'),
(20,'3d1c9e52259e61c0bc1f396dafe97bdb','爱恋樱花下',1248361940,'807247302@qq.com','e96b29534e726645bf19618a3dab919d',1,1,'c00c6c5edcb841eca4ad747617374023',2,2,0,'124.248.29.205','124.248.29.205'),
(21,'1f03f464030df7a9d9138ccc58ccdc05','wwxxw',1251552046,'zhengminshi@163.com','6740c777ec93e3b829c3c39ed6e40716',1,1,'c00c6c5edcb841eca4ad747617374023',2,2,0,'114.82.89.254','114.82.89.254'),
(22,'9f14eed68ee5b6c1d377d63db828f881','info000000',1251600927,'info00@163.com','aaa9f3bac65c0385a13dc0f948f7b4a4',1,1,'c00c6c5edcb841eca4ad747617374023',2,2,0,'123.128.242.0','123.128.242.0'),
(23,'65f8fa9f7e0d88e0a9fe9a33954642e2','bushiren',1252405627,'1996ss8668aa@sina.com','feaa16dd4384c7539df96f8a83d36f6d',1,1,'c00c6c5edcb841eca4ad747617374023',2,2,0,'123.90.145.189','123.90.145.189'),
(24,'2568d0056165f09d05120958a6eb51d8','神的赠礼',1252813123,'672308845@qq.com','8729d2d849aee48de3f908d175780841',1,1,'c00c6c5edcb841eca4ad747617374023',2,2,0,'121.14.6.104','121.14.6.104'),
(25,'fd3c8729be9d4456377f1b4a581203fe','yanpengma',1253179611,'yanpengma@163.com','3403371df86b7e603c066544bbeef219',1,1,'c00c6c5edcb841eca4ad747617374023',2,2,0,'221.192.236.70','221.192.236.70');

/*Table structure for table `sp_group` */
DROP TABLE IF EXISTS `sp_group`;

CREATE TABLE `sp_group` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(64) NOT NULL DEFAULT '',
  `level` int(10) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

/*Data for the table `sp_group` */
insert  into `sp_group`(id,name,level) values (1,'超级管理员组',9);
insert  into `sp_group`(id,name,level) values (2,'普通用户组',1);

/*Table structure for table `sp_pay_log` */
DROP TABLE IF EXISTS `sp_pay_log`;

CREATE TABLE `sp_pay_log` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `uid` int(10) NOT NULL DEFAULT '0',
  `dateline` int(10) NOT NULL DEFAULT '0',
  `money` int(10) NOT NULL DEFAULT '0',
  `ip` char(32) NOT NULL DEFAULT '',
  `description` varchar(50) NOT NULL DEFAULT '',
  `flag` int(10) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

/*Data for the table `sp_pay_log` */

/*Table structure for table `sp_consume_log` */
DROP TABLE IF EXISTS `sp_consume_log`;

CREATE TABLE `sp_consume_log` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `uid` int(10) NOT NULL DEFAULT '0',
  `dateline` int(10) NOT NULL DEFAULT '0',
  `star_coin` int(10) NOT NULL DEFAULT '0',
  `ip` char(32) NOT NULL DEFAULT '',
  `description` varchar(50) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

/*Data for the table `sp_consume_log` */