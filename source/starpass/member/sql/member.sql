CREATE DATABASE `member`;

USE `member`;

/*Table structure for table `user` */


DROP TABLE IF EXISTS `user`;

CREATE TABLE `user` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `hash_id` char(32) NOT NULL DEFAULT '',
  `name` varchar(64) NOT NULL DEFAULT '',
  `email` varchar(128) NOT NULL DEFAULT '',
  `password` varchar(32) NOT NULL DEFAULT '',
  `sex` int(10) NOT NULL DEFAULT '0',
  `real_name` varchar(64) NOT NULL DEFAULT '',
  `id_card` varchar(64) NOT NULL DEFAULT '',
  `reg_time` int(10) NOT NULL DEFAULT '0',
  `reg_ip` char(32) NOT NULL DEFAULT '',
  `last_ip` char(32) NOT NULL DEFAULT '',
  `referer` varchar(256) NOT NULL DEFAULT '',
  `gold` int(10) NOT NULL DEFAULT '0',
  `total_rmb` int(10) NOT NULL DEFAULT '0',
  `state` int(10) NOT NULL DEFAULT '0',
  `score` int(10) NOT NULL DEFAULT '0',
  `last_game` int(10) NOT NULL DEFAULT '0',
  `last_server` int(10) NOT NULL DEFAULT '0',
  `expand_id` int(10) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;



/*Table structure for table `game` */

DROP TABLE IF EXISTS `game`;

CREATE TABLE `game` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(64) NOT NULL DEFAULT '',
  `developer` varchar(128) NOT NULL DEFAULT '',
  `access_time` int(10) NOT NULL DEFAULT '0',
  `website` varchar(256) NOT NULL DEFAULT '',
  `description` varchar(256) NOT NULL DEFAULT '',
  `pic_url` varchar(256) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;


/*Table structure for table `line` */

DROP TABLE IF EXISTS `line`;

CREATE TABLE `line` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(64) NOT NULL DEFAULT '',
  `game_id` int(10) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

/*Table structure for table `server` */

DROP TABLE IF EXISTS `server`;

CREATE TABLE `server` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(64) NOT NULL DEFAULT '',
  `game_id` int(10) NOT NULL DEFAULT '0',
  `url` varchar(256) NOT NULL DEFAULT '',
  `recharge_url` varchar(256) NOT NULL DEFAULT '',
  `rate` int(10) NOT NULL DEFAULT '0',
  `pay_key` varchar(64) NOT NULL DEFAULT '',
  `line` int(10) NOT NULL DEFAULT '0',
  `start_time` int(10) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;


/*Table structure for table `recharge_log` */

DROP TABLE IF EXISTS `recharge_log`;

CREATE TABLE `recharge_log` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `uid` int(10) NOT NULL DEFAULT '0',
  `come_from` int(10) NOT NULL DEFAULT '0',
  `rmb` int(10) NOT NULL DEFAULT '0',
  `gold` int(10) NOT NULL DEFAULT '0',
  `state` int(10) NOT NULL DEFAULT '0',
  `time` int(10) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;


/*Table structure for table `recharge_log` */

DROP TABLE IF EXISTS `exchange_log`;

CREATE TABLE `exchange_log` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `uid` int(10) NOT NULL DEFAULT '0',
  `game_id` int(10) NOT NULL DEFAULT '0',
  `server_id` int(10) NOT NULL DEFAULT '0',
  `gold` int(10) NOT NULL DEFAULT '0',
  `game_money` int(10) NOT NULL DEFAULT '0',
  `time` int(10) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;


/*Table structure for table `admin` */

DROP TABLE IF EXISTS `admin`;

CREATE TABLE `admin` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(64) NOT NULL DEFAULT '',
  `password` varchar(32) NOT NULL DEFAULT '',
  `level` int(10) NOT NULL DEFAULT '0',
  `game_id` int(10) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

INSERT INTO admin (id, name, password, level,game_id) VALUES (1, 'admin', '21232f297a57a5a743894a0e4a801fc3', 1,0);

/*Table structure for table `operation_log` */

DROP TABLE IF EXISTS `operation_log`;

CREATE TABLE `operation_log` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `admin_id` int(10) NOT NULL DEFAULT '0',
  `admin_name` varchar(64) NOT NULL DEFAULT '',
  `time` int(10) NOT NULL DEFAULT '0',
  `description` varchar(32) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;


/*Table structure for table `hf_sys_setting` */

DROP TABLE IF EXISTS `sys_setting`;

CREATE TABLE `sys_setting` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(64) NOT NULL NULL DEFAULT '',
  `value` varchar(250) NOT NULL NULL DEFAULT '',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

insert  into `sys_setting`(id,name,value) values (1,'mer_id','10004455234');
insert  into `sys_setting`(id,name,value) values (2,'md5_key','474ggr90ef1h8904Ta6L14IQ9K39j89v0o9pH51WBoZsWIa583F6Z9h4P9jy');
insert  into `sys_setting`(id,name,value) values (3,'callback_url','http://192.168.36.88:5000/home/recharge_callback');
insert  into `sys_setting`(id,name,value) values (4,'expand_txt','');
insert  into `sys_setting`(id,name,value) values (5,'expand_rate','5');
insert  into `sys_setting`(id,name,value) values (6,'expand_return','');
insert  into `sys_setting`(id,name,value) values (7,'aliapy_security_code','w6q192l3hbjljmm6ix0evg8t43cbcdqo');
insert  into `sys_setting`(id,name,value) values (8,'aliapy_seller_email','xuan_bingan@yahoo.com.cn');
insert  into `sys_setting`(id,name,value) values (9,'aliapy_partner_id','2088201457844050');
insert  into `sys_setting`(id,name,value) values (10,'home_url','http://www.51zhi.com');
insert  into `sys_setting`(id,name,value) values (11,'interface_key','key_hehe');
insert  into `sys_setting`(id,name,value) values (12,'interface_ip','192.168.36.88');
insert  into `sys_setting`(id,name,value) values (13,'alipay_used','1');



/*Table structure for table `expand_people` */

DROP TABLE IF EXISTS `expand_people`;

CREATE TABLE `expand_people` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `uid` int(10) NOT NULL DEFAULT '0',
  `code` varchar(32) NOT NULL DEFAULT '',
  `rmb` int(10) NOT NULL DEFAULT '0',
  `email` varchar(128) NOT NULL DEFAULT '',
  `real_name` varchar(64) NOT NULL DEFAULT '',
  `id_card` varchar(64) NOT NULL DEFAULT '',
  `alipay` varchar(128) NOT NULL DEFAULT '',
  `reg_time` int(10) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

/*Table structure for table `expand_log` */

DROP TABLE IF EXISTS `expand_log`;

CREATE TABLE `expand_log` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `uid` int(10) NOT NULL DEFAULT '0',
  `expand_id` int(10) NOT NULL DEFAULT '0',
  `rmb` int(10) NOT NULL DEFAULT '0',
  `time` int(10) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;




/*Table structure for table `game_gift` */

DROP TABLE IF EXISTS `game_gift`;

CREATE TABLE `game_gift` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `uid` int(10) NOT NULL DEFAULT '0',
  `game_id` int(10) NOT NULL DEFAULT '0',
  `server_id` int(10) NOT NULL DEFAULT '0',
  `code` varchar(32) NOT NULL DEFAULT '',
  `is_oneoff` int(10) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;


/*Table structure for table `recharge_rate` */
DROP TABLE IF EXISTS `recharge_rate`;

CREATE TABLE `recharge_rate` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `rmb` int(10) NOT NULL DEFAULT '0',
  `rate` int(10) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;