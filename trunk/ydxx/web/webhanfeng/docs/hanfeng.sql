/*
CREATE DATABASE `hanfeng`;

USE `hanfeng`;

*/

/*Table structure for table `hf_user` */
DROP TABLE IF EXISTS `hf_user`;

CREATE TABLE `hf_user` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `hash_id` char(32) NOT NULL NULL DEFAULT '',
  `oid` varchar(128) NOT NULL NULL DEFAULT '',
  `name` varchar(20) NOT NULL NULL DEFAULT '',
  `money` int(10) NOT NULL NULL DEFAULT '0',
  `last_login_time` int(11) NOT NULL NULL DEFAULT '0',
  `last_login_ip` char(16) NOT NULL NULL DEFAULT '',
  `first_login_time` int(11) NOT NULL NULL DEFAULT '0',
  `consume` int(10) NOT NULL NULL DEFAULT '0',
  `isonline` tinyint(3) NOT NULL NULL DEFAULT '0',
  `is_locked` tinyint(3) NOT NULL NULL DEFAULT '0',
  `vip_total_hour` int(10) NOT NULL NULL DEFAULT '0',
  `vip_used_hour` int(10) NOT NULL NULL DEFAULT '0',
  `online_second` int(10) NOT NULL NULL DEFAULT '0',
  `wid` int(10) NOT NULL NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

/*Data for the table `hf_user` */


/*Table structure for table `hf_wubao` */
DROP TABLE IF EXISTS `hf_wubao`;

CREATE TABLE `hf_wubao` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` int(10) NOT NULL NULL DEFAULT '0',
  `people` int(10) NOT NULL NULL DEFAULT '0',
  `family` int(10) NOT NULL NULL DEFAULT '0',
  `prestige` int(10) NOT NULL NULL DEFAULT '0',
  `city_id` int(10) NOT NULL NULL DEFAULT '0',
  `x` int(10) NOT NULL NULL DEFAULT '0',
  `y` int(10) NOT NULL NULL DEFAULT '0',
  `sphere_id` int(10) NOT NULL NULL DEFAULT '0',
  `dig_id` int(10) NOT NULL NULL DEFAULT '0',
  `off_id` int(10) NOT NULL NULL DEFAULT '0',
  `sol_num` int(10) NOT NULL NULL DEFAULT '0',
  `money` int(10) NOT NULL NULL DEFAULT '0',
  `food` int(10) NOT NULL NULL DEFAULT '0',
  `wood` int(10) NOT NULL NULL DEFAULT '0',
  `iron` int(10) NOT NULL NULL DEFAULT '0',
  `skin` int(10) NOT NULL NULL DEFAULT '0',
  `horse` int(10) NOT NULL NULL DEFAULT '0',
  `get_sol` int(10) NOT NULL NULL DEFAULT '0',
  `used_made` int(10) NOT NULL NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

/*Data for the table `hf_wubao` */


/*Table structure for table `hf_store` */
DROP TABLE IF EXISTS `hf_store`;

CREATE TABLE `hf_store` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `wubao_id` int(10) NOT NULL NULL DEFAULT '0',
  `type` int(10) NOT NULL NULL DEFAULT '0',
  `level` int(10) NOT NULL NULL DEFAULT '0',
  `num` int(10) NOT NULL NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

/*Data for the table `hf_store` */


/*Table structure for table `hf_building` */
DROP TABLE IF EXISTS `hf_building`;

CREATE TABLE `hf_building` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `wubao_id` int(10) NOT NULL NULL DEFAULT '0',
  `type` int(10) NOT NULL NULL DEFAULT '0',
  `level` int(10) NOT NULL NULL DEFAULT '0',
  `end_time` int(10) NOT NULL NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

/*Data for the table `hf_building` */


/*Table structure for table `hf_tech` */
DROP TABLE IF EXISTS `hf_tech`;

CREATE TABLE `hf_tech` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `wubao_id` int(10) NOT NULL NULL DEFAULT '0',
  `type` int(10) NOT NULL NULL DEFAULT '0',
  `level` int(10) NOT NULL NULL DEFAULT '0',
  `end_time` int(10) NOT NULL NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

/*Data for the table `hf_tech` */


/*Table structure for table `hf_sphere` */
DROP TABLE IF EXISTS `hf_sphere`;

CREATE TABLE `hf_sphere` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` int(10) DEFAULT '0',
  `name` varchar(64) DEFAULT '',
  `level` int(10) DEFAULT '0',
  `prestige` int(10) DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

/*Data for the table `hf_sphere` */



/*Table structure for table `hf_city` */
DROP TABLE IF EXISTS `hf_city`;

CREATE TABLE `hf_city` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `sphere_id` int(10) DEFAULT '0',
  `defense` float(14,4) DEFAULT '0',
  `name` varchar(64) DEFAULT '',
  `level` tinyint(3) DEFAULT '0',
  `jun_name` varchar(64) DEFAULT '',
  `zhou_name` varchar(64) DEFAULT '',
  `description` varchar(250) DEFAULT '',
  `general_id` int(10) DEFAULT '0',
  `family` int(10) DEFAULT '0',
  `people` int(10) DEFAULT '0',
  `peace` float(14,4) DEFAULT '0',
  `x` int(10) DEFAULT '0',
  `y` int(10) DEFAULT '0',
  `is_alloted` tinyint(3) DEFAULT '0',
  `jun_code` int(10) DEFAULT '0',
  `zhou_code` int(10) DEFAULT '0',
  `get_sol` int(10) DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

/*Data for the table `hf_city` */



/*Table structure for table `hf_general` */
DROP TABLE IF EXISTS `hf_general`;

CREATE TABLE `hf_general` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` int(10) DEFAULT '0',
  `type` tinyint(3) DEFAULT '0',
  `first_name` varchar(64) DEFAULT '',
  `last_name` varchar(64) DEFAULT '',
  `zi` varchar(64) DEFAULT '',
  `sex` tinyint(3) DEFAULT '0',
  `born_year` int(10) DEFAULT '0',
  `init_year` int(10) DEFAULT '0',
  `place` tinyint(3) DEFAULT '0',
  `place_id` int(10) DEFAULT '0',
  `kongfu` int(10) DEFAULT '0',
  `intelligence` int(10) DEFAULT '0',
  `polity` int(10) DEFAULT '0',
  `speed` int(10) DEFAULT '0',
  `faith` int(10) DEFAULT '0',
  `face_id` int(10) DEFAULT '0',
  `is_dead` tinyint(3) DEFAULT '0',
  `mission_type` int(10) DEFAULT '0',
  `skill` int(10) unsigned DEFAULT '0',
  `zhen` int(10) DEFAULT '0',
  `cur_learn_skill` int(10) DEFAULT '0',
  `cur_skill_percent` int(10) DEFAULT '0',
  `cur_learn_zhen` int(10) DEFAULT '0',
  `cur_zhen_percent` int(10) DEFAULT '0',
  `cur_used_zhen` int(10) DEFAULT '0',
  `solider_num` int(10) DEFAULT '0',
  `hurt_num` int(10) DEFAULT '0',
  `solider_train` float(14,4) DEFAULT '0',
  `solider_spirit` float(14,4) DEFAULT '0',
  `killed_solider` int(10) DEFAULT '0',
  `description` varchar(250) DEFAULT '',
  `w1_type` int(10) DEFAULT '0',
  `w1_level` int(10) DEFAULT '0',
  `w2_type` int(10) DEFAULT '0',
  `w2_level` int(10) DEFAULT '0',
  `w3_type` int(10) DEFAULT '0',
  `w3_level` int(10) DEFAULT '0',
  `w4_type` int(10) DEFAULT '0',
  `w4_level` int(10) DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

/*Data for the table `hf_general` */


/*Table structure for table `hf_army` */
DROP TABLE IF EXISTS `hf_army`;

CREATE TABLE `hf_army` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(64) DEFAULT '',
  `general_id` int(10) DEFAULT '0',
  `x` int(10) DEFAULT '0',
  `y` int(10) DEFAULT '0',
  `money` int(10) DEFAULT '0',
  `food` int(10) DEFAULT '0',
  `original` int(10) DEFAULT '0',
  `expedition_type` tinyint(3) DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

/*Data for the table `hf_army` */



/*Table structure for table `hf_diplomacy` */
DROP TABLE IF EXISTS `hf_diplomacy`;

CREATE TABLE `hf_diplomacy` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `type` tinyint(3) DEFAULT '0',
  `self_id` int(10) DEFAULT '0',
  `target_id` int(10) DEFAULT '0',
  `value` int(10) DEFAULT '0',
  `life` int(10) DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

/*Data for the table `hf_diplomacy` */


/*Table structure for table `hf_treasure` */
DROP TABLE IF EXISTS `hf_treasure`;

CREATE TABLE `hf_treasure` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `treasure_id` int(10) DEFAULT '0',
  `general_id` int(10) DEFAULT '0',
  `is_used` tinyint(3) DEFAULT '0',
  `user_id` int(10) DEFAULT '0',
  `use_time` int(10) DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

/*Data for the table `hf_treasure` */



/*Table structure for table `hf_message` */
DROP TABLE IF EXISTS `hf_message`;

CREATE TABLE `hf_message` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `receive_id` int(10) DEFAULT '0',
  `timestamp` int(10) DEFAULT '0',
  `content` text(1000) NOT NULL NULL DEFAULT '',
  `is_read` tinyint(3) NOT NULL NULL DEFAULT '0',
  `flag` tinyint(3) NOT NULL NULL DEFAULT '0',
  `msg_type` tinyint(3) NOT NULL NULL DEFAULT '0',
  `msg_title` varchar(64) NOT NULL NULL DEFAULT '',
  `city_name` varchar(64) NOT NULL NULL DEFAULT '',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

/*Data for the table `hf_message` */


/*Table structure for table `hf_mail` */
DROP TABLE IF EXISTS `hf_mail`;

CREATE TABLE `hf_mail` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `sender_id` int(10) NOT NULL NULL DEFAULT '0',
  `sender_name` varchar(64) NOT NULL NULL DEFAULT '',
  `receive_id` int(10) NOT NULL NULL DEFAULT '0',
  `receive_name` varchar(64) NOT NULL NULL DEFAULT '',
  `title` varchar(64) NOT NULL NULL DEFAULT '',
  `content` text(1000) NOT NULL NULL DEFAULT '',
  `is_read` tinyint(3) NOT NULL NULL DEFAULT '0',
  `mail_type` tinyint(3) NOT NULL NULL DEFAULT '0',
  `sender_del` tinyint(3) NOT NULL NULL DEFAULT '0',
  `receive_del` tinyint(3) NOT NULL NULL DEFAULT '0',
  `receive_timestamp` int(10) NOT NULL NULL DEFAULT '0',
  `send_timestamp` int(10) NOT NULL NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

/*Data for the table `hf_mail` */



/*Table structure for table `hf_cmd_transfer` */
DROP TABLE IF EXISTS `hf_cmd_transfer`;

CREATE TABLE `hf_cmd_transfer` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `from_city_id` int(10) NOT NULL NULL DEFAULT '0',
  `to_city_id` int(10) NOT NULL NULL DEFAULT '0',
  `type` int(10) NOT NULL NULL DEFAULT '0',
  `sphere_id` int(10) NOT NULL NULL DEFAULT '0',
  `num1` int(10) NOT NULL NULL DEFAULT '0',
  `num2` int(10) NOT NULL NULL DEFAULT '0',
  `num3` int(10) NOT NULL NULL DEFAULT '0',
  `num4` int(10) NOT NULL NULL DEFAULT '0',
  `num5` int(10) NOT NULL NULL DEFAULT '0',
  `num6` int(10) NOT NULL NULL DEFAULT '0',
  `num7` int(10) NOT NULL NULL DEFAULT '0',
  `num8` int(10) NOT NULL NULL DEFAULT '0',
  `num9` int(10) NOT NULL NULL DEFAULT '0',
  `num10` int(10) NOT NULL NULL DEFAULT '0',
  `num11` int(10) NOT NULL NULL DEFAULT '0',
  `num12` int(10) NOT NULL NULL DEFAULT '0',
  `num13` int(10) NOT NULL NULL DEFAULT '0',
  `num14` int(10) NOT NULL NULL DEFAULT '0',
  `num15` int(10) NOT NULL NULL DEFAULT '0',
  `num16` int(10) NOT NULL NULL DEFAULT '0',
  `num17` int(10) NOT NULL NULL DEFAULT '0',
  `num18` int(10) NOT NULL NULL DEFAULT '0',
  `num19` int(10) NOT NULL NULL DEFAULT '0',
  `num20` int(10) NOT NULL NULL DEFAULT '0',
  `extra1` int(10) NOT NULL NULL DEFAULT '0',
  `extra2` int(10) NOT NULL NULL DEFAULT '0',
  `extra3` int(10) NOT NULL NULL DEFAULT '0',
  `extra4` int(10) NOT NULL NULL DEFAULT '0',
  `extra5` int(10) NOT NULL NULL DEFAULT '0',
  `extra6` int(10) NOT NULL NULL DEFAULT '0',
  `extra7` int(10) NOT NULL NULL DEFAULT '0',
  `extra8` int(10) NOT NULL NULL DEFAULT '0',
  `extra9` int(10) NOT NULL NULL DEFAULT '0',
  `extra10` int(10) NOT NULL NULL DEFAULT '0',
  `extra11` int(10) NOT NULL NULL DEFAULT '0',
  `extra12` int(10) NOT NULL NULL DEFAULT '0',
  `extra13` int(10) NOT NULL NULL DEFAULT '0',
  `extra14` int(10) NOT NULL NULL DEFAULT '0',
  `extra15` int(10) NOT NULL NULL DEFAULT '0',
  `extra16` int(10) NOT NULL NULL DEFAULT '0',
  `extra17` int(10) NOT NULL NULL DEFAULT '0',
  `extra18` int(10) NOT NULL NULL DEFAULT '0',
  `extra19` int(10) NOT NULL NULL DEFAULT '0',
  `extra20` int(10) NOT NULL NULL DEFAULT '0',
  `extra21` int(10) NOT NULL NULL DEFAULT '0',
  `extra22` int(10) NOT NULL NULL DEFAULT '0',
  `extra23` int(10) NOT NULL NULL DEFAULT '0',
  `extra24` int(10) NOT NULL NULL DEFAULT '0',
  `extra25` int(10) NOT NULL NULL DEFAULT '0',
  `extra26` int(10) NOT NULL NULL DEFAULT '0',
  `start_timestamp` int(10) NOT NULL NULL DEFAULT '0',
  `end_timestamp` int(10) NOT NULL NULL DEFAULT '0',
  `speed_count` int(10) NOT NULL NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

/*Data for the table `hf_cmd_transfer` */


/*Table structure for table `hf_face` */
DROP TABLE IF EXISTS `hf_face`;

CREATE TABLE `hf_face` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `sex` tinyint(3) NOT NULL NULL DEFAULT '0',
  `is_show` tinyint(3) NOT NULL NULL DEFAULT '0',
  `url` varchar(250) NOT NULL NULL DEFAULT '',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

/*Data for the table `hf_face` */
insert  into `hf_face`(id,sex,is_show,url) values (1,1,0,'1.png'),(2,1,0,'2.png'),(3,1,0,'3.png'),(4,1,0,'4.png'),(5,1,0,'5.png'),(6,1,0,'6.png'),(7,1,0,'7.png'),(8,1,0,'8.png'),(9,1,0,'9.png'),(10,1,0,'10.png'),(11,1,0,'11.png'),(12,1,0,'12.png'),(13,1,0,'13.png'),(14,1,0,'14.png'),(15,1,0,'15.png'),(16,1,0,'16.png'),(17,1,0,'17.png'),(18,1,0,'18.png'),(19,1,0,'19.png'),(20,1,0,'20.png'),(21,1,0,'21.png'),(22,1,0,'22.png'),(23,1,0,'23.png'),(24,1,0,'24.png'),(25,1,0,'25.png'),(26,1,0,'26.png'),(27,1,0,'27.png'),(28,1,0,'28.png'),(29,1,0,'29.png'),(30,1,0,'30.png'),(31,1,0,'31.png'),(32,1,0,'32.png'),(33,1,0,'33.png'),(34,1,0,'34.png'),(35,1,0,'35.png'),(36,1,0,'36.png'),(37,1,0,'37.png'),(38,1,0,'38.png'),(39,1,0,'39.png'),(40,1,0,'40.png'),(41,1,0,'41.png'),(42,1,0,'42.png'),(43,1,0,'43.png'),(44,1,0,'44.png'),(45,1,0,'45.png'),(46,1,0,'46.png'),(47,1,0,'47.png'),(48,1,0,'48.png'),(49,1,0,'49.png'),(50,1,0,'50.png'),(51,1,0,'51.png'),(52,1,0,'52.png'),(53,1,0,'53.png'),(54,1,0,'54.png'),(55,1,0,'55.png'),(56,1,0,'56.png'),(57,1,0,'57.png'),(58,1,0,'58.png'),(59,1,0,'59.png'),(60,1,0,'60.png'),(61,1,0,'61.png'),(62,1,0,'62.png'),(63,1,0,'63.png'),(64,1,0,'64.png'),(65,1,0,'65.png'),(66,1,0,'66.png'),(67,1,0,'67.png'),(68,1,0,'68.png'),(69,1,0,'69.png'),(70,1,0,'70.png'),(71,1,0,'71.png'),(72,1,0,'72.png'),(73,1,0,'73.png'),(74,1,0,'74.png'),(75,1,0,'75.png'),(76,1,0,'76.png'),(77,1,0,'77.png'),(78,1,0,'78.png'),(79,1,0,'79.png'),(80,1,0,'80.png'),(81,1,0,'81.png'),(82,1,0,'82.png'),(83,1,0,'83.png'),(84,1,0,'84.png'),(85,1,0,'85.png'),(86,1,0,'86.png'),(87,1,0,'87.png'),(88,1,0,'88.png'),(89,1,0,'89.png'),(90,1,0,'90.png'),(91,1,0,'91.png'),(92,1,0,'92.png'),(93,1,0,'93.png'),(94,1,0,'94.png'),(95,1,0,'95.png'),(96,1,0,'96.png'),(97,1,0,'97.png'),(98,1,0,'98.png'),(99,1,0,'99.png'),(100,1,0,'100.png'),(101,1,0,'101.png'),(102,1,0,'102.png'),(103,1,0,'103.png'),(104,1,0,'104.png'),(105,1,0,'105.png'),(106,1,0,'106.png'),(107,1,0,'107.png'),(108,1,0,'108.png'),(109,1,0,'109.png'),(110,1,0,'110.png'),(111,1,0,'111.png'),(112,1,0,'112.png'),(113,1,0,'113.png'),(114,1,0,'114.png'),(115,1,0,'115.png'),(116,1,0,'116.png'),(117,1,0,'117.png'),(118,1,0,'118.png'),(119,1,0,'119.png'),(120,1,0,'120.png'),(121,1,0,'121.png'),(122,1,0,'122.png'),(123,1,0,'123.png'),(124,1,0,'124.png'),(125,1,0,'125.png'),(126,1,0,'126.png'),(127,1,0,'127.png'),(128,1,0,'128.png'),(129,1,0,'129.png'),(130,1,0,'130.png'),(131,1,0,'131.png'),(132,1,0,'132.png'),(133,1,0,'133.png'),(134,1,0,'134.png'),(135,1,0,'135.png'),(136,1,0,'136.png'),(137,1,0,'137.png'),(138,1,0,'138.png'),(139,1,0,'139.png'),(140,1,0,'140.png'),(141,1,0,'141.png'),(142,1,0,'142.png'),(143,1,0,'143.png'),(144,1,0,'144.png'),(145,1,0,'145.png'),(146,1,0,'146.png'),(147,1,0,'147.png'),(148,1,0,'148.png'),(149,1,0,'149.png'),(150,1,0,'150.png'),(151,1,0,'151.png'),(152,1,0,'152.png'),(153,1,0,'153.png'),(154,1,0,'154.png'),(155,1,0,'155.png'),(156,1,0,'156.png'),(157,1,0,'157.png'),(158,1,0,'158.png'),(159,1,0,'159.png'),(160,1,0,'160.png'),(161,1,0,'161.png'),(162,1,0,'162.png'),(163,1,0,'163.png'),(164,1,0,'164.png'),(165,1,0,'165.png'),(166,1,0,'166.png'),(167,1,0,'167.png'),(168,1,0,'168.png'),(169,1,0,'169.png'),(170,1,0,'170.png'),(171,1,0,'171.png'),(172,1,0,'172.png'),(173,1,0,'173.png'),(174,1,0,'174.png'),(175,1,0,'175.png'),(176,1,0,'176.png'),(177,1,0,'177.png'),(178,1,0,'178.png'),(179,1,0,'179.png'),(180,1,0,'180.png'),(181,1,0,'181.png'),(182,1,0,'182.png'),(183,1,0,'183.png'),(184,1,0,'184.png'),(185,1,0,'185.png'),(186,1,0,'186.png'),(187,1,0,'187.png'),(188,1,0,'188.png'),(189,1,0,'189.png'),(190,1,0,'190.png'),(191,1,0,'191.png'),(192,1,0,'192.png'),(193,1,0,'193.png'),(194,1,0,'194.png'),(195,1,0,'195.png'),(196,1,0,'196.png'),(197,1,0,'197.png'),(198,1,0,'198.png'),(199,1,0,'199.png'),(200,1,0,'200.png'),(201,1,0,'201.png'),(202,1,0,'202.png'),(203,1,0,'203.png'),(204,1,0,'204.png'),(205,1,0,'205.png'),(206,1,0,'206.png'),(207,1,0,'207.png'),(208,1,0,'208.png'),(209,1,0,'209.png'),(210,1,0,'210.png'),(211,1,0,'211.png'),(212,1,0,'212.png'),(213,1,0,'213.png'),(214,1,0,'214.png'),(215,1,0,'215.png'),(216,1,0,'216.png'),(217,1,0,'217.png'),(218,1,0,'218.png'),(219,1,0,'219.png'),(220,1,0,'220.png'),(221,1,0,'221.png'),(222,1,0,'222.png'),(223,1,0,'223.png'),(224,1,0,'224.png'),(225,1,0,'225.png'),(226,1,0,'226.png'),(227,1,0,'227.png'),(228,1,0,'228.png'),(229,1,0,'229.png'),(230,1,0,'230.png'),(231,1,0,'231.png'),(232,1,0,'232.png'),(233,1,0,'233.png'),(234,1,0,'234.png'),(235,1,0,'235.png'),(236,1,0,'236.png'),(237,1,0,'237.png'),(238,1,0,'238.png'),(239,1,0,'239.png'),(240,1,0,'240.png'),(241,1,0,'241.png'),(242,1,0,'242.png'),(243,1,0,'243.png'),(244,1,0,'244.png'),(245,1,0,'245.png'),(246,1,0,'246.png'),(247,1,0,'247.png'),(248,1,0,'248.png'),(249,1,0,'249.png'),(250,1,0,'250.png'),(251,1,0,'251.png'),(252,1,0,'252.png'),(253,1,0,'253.png'),(254,1,0,'254.png'),(255,1,0,'255.png'),(256,1,0,'256.png'),(257,1,0,'257.png'),(258,1,0,'258.png'),(259,1,0,'259.png'),(260,1,0,'260.png'),(261,1,0,'261.png'),(262,1,0,'262.png'),(263,1,0,'263.png'),(264,1,0,'264.png'),(265,1,0,'265.png'),(266,1,0,'266.png'),(267,1,0,'267.png'),(268,1,0,'268.png'),(269,1,0,'269.png'),(270,1,0,'270.png'),(271,1,0,'271.png'),(272,1,0,'272.png'),(273,1,0,'273.png'),(274,1,0,'274.png'),(275,1,0,'275.png'),(276,1,0,'276.png'),(277,1,0,'277.png'),(278,1,0,'278.png'),(279,1,0,'279.png'),(280,1,0,'280.png'),(281,1,0,'281.png'),(282,1,0,'282.png'),(283,1,0,'283.png'),(284,1,0,'284.png'),(285,1,0,'285.png'),(286,1,0,'286.png'),(287,1,0,'287.png'),(288,1,0,'288.png'),(289,1,0,'289.png'),(290,1,0,'290.png'),(291,1,0,'291.png'),(292,1,0,'292.png'),(293,1,0,'293.png'),(294,1,0,'294.png'),(295,1,0,'295.png'),(296,1,0,'296.png'),(297,1,0,'297.png'),(298,1,0,'298.png'),(299,1,0,'299.png'),(300,1,0,'300.png'),(301,1,0,'301.png'),(302,1,0,'302.png'),(303,1,0,'303.png'),(304,1,0,'304.png'),(305,1,0,'305.png'),(306,1,0,'306.png'),(307,1,0,'307.png'),(308,1,0,'308.png'),(309,1,0,'309.png'),(310,1,0,'310.png'),(311,1,0,'311.png'),(312,1,0,'312.png'),(313,1,0,'313.png'),(314,1,0,'314.png'),(315,1,0,'315.png'),(316,1,0,'316.png'),(317,1,0,'317.png'),(318,1,0,'318.png'),(319,1,0,'319.png'),(320,1,0,'320.png'),(321,1,0,'321.png'),(322,1,0,'322.png'),(323,1,0,'323.png'),(324,1,0,'324.png'),(325,1,0,'325.png'),(326,1,0,'326.png'),(327,1,0,'327.png'),(328,1,0,'328.png'),(329,1,0,'329.png'),(330,1,0,'330.png'),(331,1,0,'331.png'),(332,1,0,'332.png'),(333,1,0,'333.png'),(334,1,0,'334.png'),(335,1,0,'335.png'),(336,1,0,'336.png'),(337,1,0,'337.png'),(338,1,0,'338.png'),(339,1,0,'339.png'),(340,1,0,'340.png'),(341,1,0,'341.png'),(342,1,0,'342.png'),(343,1,0,'343.png'),(344,1,0,'344.png'),(345,1,0,'345.png'),(346,1,0,'346.png'),(347,1,0,'347.png'),(348,1,0,'348.png'),(349,1,0,'349.png'),(350,1,0,'350.png'),(351,1,0,'351.png'),(352,1,0,'352.png'),(353,1,0,'353.png'),(354,1,0,'354.png'),(355,1,0,'355.png'),(356,1,0,'356.png'),(357,1,0,'357.png'),(358,1,0,'358.png'),(359,1,0,'359.png'),(360,1,0,'360.png'),(361,1,0,'361.png'),(362,1,0,'362.png'),(363,1,0,'363.png'),(364,1,0,'364.png'),(365,1,0,'365.png'),(366,1,0,'366.png'),(367,1,0,'367.png'),(368,1,0,'368.png'),(369,1,0,'369.png'),(370,1,0,'370.png'),(371,1,0,'371.png'),(372,1,0,'372.png'),(373,1,0,'373.png'),(374,1,0,'374.png'),(375,1,0,'375.png'),(376,1,0,'376.png'),(377,1,0,'377.png'),(378,1,0,'378.png'),(379,1,0,'379.png'),(380,1,0,'380.png'),(381,1,0,'381.png'),(382,1,0,'382.png'),(383,1,0,'383.png'),(384,1,0,'384.png'),(385,1,0,'385.png'),(386,1,0,'386.png'),(387,1,0,'387.png'),(388,1,0,'388.png'),(389,1,0,'389.png'),(390,1,0,'390.png'),(391,1,0,'391.png'),(392,1,0,'392.png'),(393,1,0,'393.png'),(394,1,0,'394.png'),(395,1,0,'395.png'),(396,1,0,'396.png'),(397,1,0,'397.png'),(398,1,0,'398.png'),(399,1,0,'399.png'),(400,1,0,'400.png'),(401,1,0,'401.png'),(402,1,0,'402.png'),(403,1,0,'403.png'),(404,1,0,'404.png'),(405,1,0,'405.png'),(406,1,0,'406.png'),(407,1,0,'407.png'),(408,1,0,'408.png'),(409,1,0,'409.png'),(410,1,0,'410.png'),(411,1,0,'411.png'),(412,1,0,'412.png'),(413,1,0,'413.png'),(414,1,0,'414.png'),(415,1,0,'415.png'),(416,1,0,'416.png'),(417,1,0,'417.png'),(418,1,0,'418.png'),(419,1,0,'419.png'),(420,1,0,'420.png'),(421,1,0,'421.png'),(422,1,0,'422.png'),(423,1,0,'423.png'),(424,1,0,'424.png'),(425,1,0,'425.png'),(426,1,0,'426.png'),(427,1,0,'427.png'),(428,1,0,'428.png'),(429,1,0,'429.png'),(430,1,0,'430.png'),(431,1,0,'431.png'),(432,1,0,'432.png'),(433,1,0,'433.png'),(434,1,0,'434.png'),(435,1,0,'435.png'),(436,1,0,'436.png'),(437,1,0,'437.png'),(438,1,0,'438.png'),(439,1,0,'439.png'),(440,1,0,'440.png'),(441,1,0,'441.png'),(442,1,0,'442.png'),(443,1,0,'443.png'),(444,1,0,'444.png'),(445,1,0,'445.png'),(446,1,0,'446.png'),(447,1,0,'447.png'),(448,1,0,'448.png'),(449,1,0,'449.png'),(450,1,0,'450.png'),(451,1,0,'451.png'),(452,1,0,'452.png'),(453,1,0,'453.png'),(454,1,0,'454.png'),(455,1,0,'455.png'),(456,1,0,'456.png'),(457,1,0,'457.png'),(458,1,0,'458.png'),(459,1,0,'459.png'),(460,1,0,'460.png'),(461,1,0,'461.png'),(462,1,0,'462.png'),(463,1,0,'463.png'),(464,1,0,'464.png'),(465,1,0,'465.png'),(466,1,0,'466.png'),(467,1,0,'467.png'),(468,1,0,'468.png'),(469,1,0,'469.png'),(470,1,0,'470.png'),(471,1,0,'471.png'),(472,1,0,'472.png'),(473,1,0,'473.png'),(474,1,0,'474.png'),(475,1,0,'475.png'),(476,1,0,'476.png'),(477,1,0,'477.png'),(478,1,0,'478.png'),(479,1,0,'479.png'),(480,1,0,'480.png'),(481,1,0,'481.png'),(482,1,0,'482.png'),(483,1,0,'483.png'),(484,1,0,'484.png'),(485,1,0,'485.png'),(486,1,0,'486.png'),(487,1,0,'487.png'),(488,1,0,'488.png'),(489,1,0,'489.png'),(490,1,0,'490.png'),(491,1,0,'491.png'),(492,1,0,'492.png'),(493,1,0,'493.png'),(494,1,0,'494.png'),(495,1,0,'495.png'),(496,1,0,'496.png'),(497,1,0,'497.png'),(498,1,0,'498.png'),(499,1,0,'499.png'),(500,1,0,'500.png'),(501,1,0,'501.png'),(502,1,0,'502.png'),(503,1,0,'503.png'),(504,1,0,'504.png'),(505,1,0,'505.png'),(506,1,0,'506.png'),(507,1,0,'507.png'),(508,1,0,'508.png'),(509,1,0,'509.png'),(510,1,0,'510.png'),(511,1,0,'511.png'),(512,1,0,'512.png'),(513,1,0,'513.png'),(514,1,0,'514.png'),(515,1,0,'515.png'),(516,1,0,'516.png'),(517,1,0,'517.png'),(518,1,0,'518.png'),(519,1,0,'519.png'),(520,1,0,'520.png'),(521,1,0,'521.png'),(522,1,0,'522.png'),(523,1,0,'523.png'),(524,1,0,'524.png'),(525,1,0,'525.png'),(526,1,0,'526.png'),(527,1,0,'527.png'),(528,1,0,'528.png'),(529,1,0,'529.png'),(530,1,0,'530.png'),(531,1,0,'531.png'),(532,1,0,'532.png'),(533,1,0,'533.png'),(534,1,0,'534.png'),(535,1,0,'535.png'),(536,1,0,'536.png'),(537,1,0,'537.png'),(538,1,0,'538.png'),(539,1,0,'539.png'),(540,1,0,'540.png'),(541,1,0,'541.png'),(542,1,0,'542.png'),(543,1,0,'543.png'),(544,1,0,'544.png'),(545,1,0,'545.png'),(546,1,0,'546.png'),(547,1,0,'547.png'),(548,1,0,'548.png'),(549,1,0,'549.png'),(550,1,0,'550.png'),(551,1,0,'551.png'),(552,1,0,'552.png'),(553,1,0,'553.png'),(554,1,0,'554.png'),(555,1,0,'555.png'),(556,1,0,'556.png'),(557,1,0,'557.png'),(558,1,0,'558.png'),(559,1,0,'559.png'),(560,1,0,'560.png'),(561,1,0,'561.png'),(562,1,0,'562.png'),(563,1,0,'563.png'),(564,1,0,'564.png'),(565,1,0,'565.png'),(566,1,0,'566.png'),(567,1,0,'567.png'),(568,1,0,'568.png'),(569,1,0,'569.png'),(570,1,0,'570.png'),(571,1,0,'571.png'),(572,1,0,'572.png'),(573,1,0,'573.png'),(574,1,0,'574.png'),(575,1,0,'575.png'),(576,1,0,'576.png'),(577,1,0,'577.png'),(578,1,0,'578.png'),(579,1,0,'579.png'),(580,1,0,'580.png'),(581,1,0,'581.png'),(582,1,0,'582.png'),(583,1,0,'583.png'),(584,1,0,'584.png'),(585,1,0,'585.png'),(586,1,0,'586.png'),(587,1,0,'587.png'),(588,1,0,'588.png'),(589,1,0,'589.png'),(590,1,0,'590.png'),(591,1,0,'591.png'),(592,1,0,'592.png'),(593,1,0,'593.png'),(594,1,0,'594.png'),(595,1,0,'595.png'),(596,1,0,'596.png'),(597,1,0,'597.png'),(598,1,0,'598.png'),(599,1,0,'599.png'),(600,1,0,'600.png'),(601,1,0,'601.png'),(602,1,0,'602.png'),(603,1,0,'603.png'),(604,1,0,'604.png'),(605,1,0,'605.png'),(606,1,0,'606.png'),(607,1,0,'607.png'),(608,1,0,'608.png'),(609,1,0,'609.png'),(610,1,0,'610.png'),(611,1,0,'611.png'),(612,1,0,'612.png'),(613,1,0,'613.png'),(614,1,0,'614.png'),(615,1,0,'615.png'),(616,1,0,'616.png'),(617,1,0,'617.png'),(618,1,0,'618.png'),(619,1,0,'619.png'),(620,1,0,'620.png'),(621,1,0,'621.png'),(622,1,0,'622.png'),(623,1,0,'623.png'),(624,1,0,'624.png'),(625,1,0,'625.png'),(626,1,0,'626.png'),(627,1,0,'627.png'),(628,1,0,'628.png'),(629,1,0,'629.png'),(630,1,0,'630.png'),(631,1,0,'631.png'),(632,1,0,'632.png'),(633,1,0,'633.png'),(634,1,0,'634.png'),(635,1,0,'635.png'),(636,1,0,'636.png'),(637,1,0,'637.png'),(638,1,0,'638.png'),(639,1,0,'639.png'),(640,1,0,'640.png'),(641,1,0,'641.png'),(642,1,0,'642.png'),(643,1,0,'643.png'),(644,1,0,'644.png'),(645,1,0,'645.png'),(646,1,0,'646.png'),(647,1,0,'647.png'),(648,1,0,'648.png'),(649,1,0,'649.png'),(650,1,0,'650.png'),(651,1,0,'651.png'),(652,1,0,'652.png'),(653,1,0,'653.png'),(654,1,0,'654.png'),(655,1,0,'655.png'),(656,1,0,'656.png'),(657,1,1,'general_1.png'),(658,1,1,'general_2.png'),(659,1,1,'general_3.png'),(660,1,1,'general_4.png'),(661,1,1,'general_5.png'),(662,1,1,'general_6.png'),(663,1,1,'general_7.png'),(664,1,1,'general_8.png'),(665,1,1,'general_9.png'),(666,1,1,'general_10.png'),(667,1,1,'general_11.png'),(668,1,1,'general_12.png'),(669,1,1,'general_13.png'),(670,1,1,'general_14.png'),(671,1,1,'general_15.png'),(672,1,1,'general_16.png'),(673,1,1,'general_17.png'),(674,1,1,'general_18.png'),(675,1,1,'general_19.png'),(676,1,1,'general_20.png'),(677,1,1,'general_21.png'),(678,1,1,'general_22.png'),(679,1,1,'general_23.png'),(680,1,1,'general_24.png'),(681,1,1,'general_25.png'),(682,1,1,'general_26.png'),(683,1,1,'general_27.png'),(684,0,1,'girl_1.png'),(685,0,1,'girl_2.png'),(686,0,1,'girl_3.png'),(687,0,1,'girl_4.png'),(688,0,1,'girl_5.png'),(689,0,1,'girl_6.png'),(690,0,1,'girl_7.png'),(691,0,1,'girl_8.png'),(692,0,1,'girl_9.png'),(693,0,1,'girl_10.png'),(694,0,1,'girl_11.png'),(695,0,1,'girl_12.png'),(696,0,1,'girl_13.png'),(697,0,1,'girl_14.png'),(698,0,1,'girl_15.png'),(699,0,1,'girl_16.png'),(700,0,1,'girl_17.png'),(701,0,1,'girl_18.png'),(702,0,1,'girl_19.png'),(703,0,1,'girl_20.png'),(704,0,1,'girl_21.png'),(705,0,1,'girl_22.png'),(706,0,1,'girl_23.png'),(707,0,1,'girl_24.png'),(708,0,1,'girl_25.png'),(709,0,1,'girl_26.png'),(710,0,1,'girl_27.png'),(711,0,1,'girl_28.png'),(712,0,1,'girl_29.png'),(713,0,1,'girl_30.png'),(714,0,1,'girl_31.png');



/*Table structure for table `hf_treasure_pic` */
DROP TABLE IF EXISTS `hf_treasure_pic`;

CREATE TABLE `hf_treasure_pic` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `url_big` varchar(250) NOT NULL NULL DEFAULT '',
  `url` varchar(250) NOT NULL NULL DEFAULT '',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

/*Data for the table `hf_treasure_pic` */

insert  into `hf_treasure_pic`(id,url_big,url) values (1,'treasure_1.png','t_1.png'),(2,'treasure_2.png','t_2.png'),(3,'treasure_3.png','t_3.png'),(4,'treasure_4.png','t_4.png'),(5,'treasure_5.png','t_5.png'),(6,'treasure_6.png','t_6.png'),(7,'treasure_7.png','t_7.png'),(8,'treasure_8.png','t_8.png'),(9,'treasure_9.png','t_9.png'),(10,'treasure_10.png','t_10.png'),(11,'treasure_11.png','t_11.png'),(12,'treasure_12.png','t_12.png'),(13,'treasure_13.png','t_13.png'),(14,'treasure_14.png','t_14.png'),(15,'treasure_15.png','t_15.png'),(16,'treasure_16.png','t_16.png'),(17,'treasure_17.png','t_17.png'),(18,'treasure_18.png','t_18.png'),(19,'treasure_19.png','t_19.png'),(20,'treasure_20.png','t_20.png'),(21,'treasure_21.png','t_21.png'),(22,'treasure_22.png','t_22.png'),(23,'treasure_23.png','t_23.png'),(24,'treasure_24.png','t_24.png'),(25,'treasure_25.png','t_25.png'),(26,'treasure_26.png','t_26.png'),(27,'treasure_27.png','t_27.png'),(28,'treasure_28.png','t_28.png'),(29,'treasure_29.png','t_29.png'),(30,'treasure_30.png','t_30.png'),(31,'treasure_31.png','t_31.png'),(32,'treasure_32.png','t_32.png'),(33,'treasure_33.png','t_33.png'),(34,'treasure_34.png','t_34.png'),(35,'treasure_35.png','t_35.png'),(36,'treasure_36.png','t_36.png'),(37,'treasure_37.png','t_37.png'),(38,'treasure_38.png','t_38.png'),(39,'treasure_39.png','t_39.png'),(40,'treasure_40.png','t_40.png'),(41,'treasure_41.png','t_41.png'),(42,'treasure_42.png','t_42.png'),(43,'treasure_43.png','t_43.png'),(44,'treasure_44.png','t_44.png'),(45,'treasure_45.png','t_45.png'),(46,'treasure_46.png','t_46.png'),(47,'treasure_47.png','t_47.png'),(48,'treasure_48.png','t_48.png'),(49,'treasure_49.png','t_49.png'),(50,'treasure_50.png','t_50.png'),(51,'treasure_51.png','t_51.png'),(52,'treasure_52.png','t_52.png'),(53,'treasure_53.png','t_53.png'),(54,'treasure_54.png','t_54.png'),(55,'treasure_55.png','t_55.png'),(56,'treasure_56.png','t_56.png'),(57,'treasure_57.png','t_57.png'),(58,'treasure_58.png','t_58.png'),(59,'treasure_59.png','t_59.png'),(60,'treasure_60.png','t_60.png'),(61,'treasure_61.png','t_61.png'),(62,'treasure_62.png','t_62.png'),(63,'treasure_63.png','t_63.png'),(64,'treasure_64.png','t_64.png'),(65,'treasure_65.png','t_65.png'),(66,'treasure_66.png','t_66.png'),(67,'treasure_67.png','t_67.png'),(68,'treasure_68.png','t_68.png'),(69,'treasure_69.png','t_69.png'),(70,'treasure_70.png','t_70.png'),(71,'treasure_71.png','t_71.png'),(72,'treasure_72.png','t_72.png'),(73,'treasure_73.png','t_73.png'),(74,'treasure_74.png','t_74.png'),(75,'treasure_75.png','t_75.png'),(76,'treasure_76.png','t_76.png'),(77,'treasure_77.png','t_77.png'),(78,'treasure_78.png','t_78.png'),(79,'treasure_79.png','t_79.png'),(80,'treasure_80.png','t_80.png'),(81,'treasure_81.png','t_81.png'),(82,'treasure_82.png','t_82.png'),(83,'treasure_83.png','t_83.png'),(84,'treasure_84.png','t_84.png'),(85,'treasure_85.png','t_85.png'),(86,'treasure_86.png','t_86.png'),(87,'treasure_87.png','t_87.png'),(88,'treasure_88.png','t_88.png'),(89,'treasure_89.png','t_89.png'),(90,'treasure_90.png','t_90.png'),(91,'treasure_91.png','t_91.png'),(92,'treasure_92.png','t_92.png'),(93,'treasure_93.png','t_93.png');



/*Table structure for table `hf_shop` */
DROP TABLE IF EXISTS `hf_shop`;

CREATE TABLE `hf_shop` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `pic_id` int(10) NOT NULL NULL DEFAULT '0',
  `type` int(10) NOT NULL NULL DEFAULT '0',
  `level` int(10) NOT NULL NULL DEFAULT '0',
  `name` varchar(64) NOT NULL NULL DEFAULT '',
  `prop_type` int(10) NOT NULL NULL DEFAULT '0',
  `num` int(10) NOT NULL NULL DEFAULT '0',
  `coins` int(10) NOT NULL NULL DEFAULT '0',
  `sold` int(10) NOT NULL NULL DEFAULT '0',
  `description` varchar(100) NOT NULL NULL DEFAULT '',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

/*Data for the table `hf_shop` */

insert  into `hf_shop`(id,pic_id,type,level,name,prop_type,num,coins,sold,description) values (1,1,5,0,'玉玺',0,0,10,0,'可将此物送与袁术，换取训练度/士气80的骑兵500'),(2,2,5,0,'令箭',0,0,10,0,'可预先安排3年内指令，每条指令消耗1枚令箭'),(3,3,1,1,'铜锤',1,3,30,0,'增加武将武力属性3点'),(4,4,1,1,'大斧',1,3,30,0,'增加武将武力属性3点'),(5,5,1,1,'手戟',1,3,30,0,'增加武将武力属性3点'),(6,6,1,1,'铁鞭',1,3,30,0,'增加武将武力属性3点'),(7,7,1,1,'袖箭',1,3,30,0,'增加武将武力属性3点'),(8,8,1,2,'双铁戟',1,6,60,0,'增加武将武力属性6点'),(9,9,1,2,'流星锤',1,6,60,2,'增加武将武力属性6点'),(10,10,1,2,'铁蒺藜骨朵',1,6,60,0,'增加武将武力属性6点'),(11,11,1,2,'眉尖刀',1,6,60,0,'增加武将武力属性6点'),(12,12,1,2,'李广弓',1,6,60,0,'增加武将武力属性6点'),(13,13,1,3,'三尖刀',1,9,90,0,'增加武将武力属性9点'),(14,14,1,3,'铁脊蛇矛',1,9,90,0,'增加武将武力属性9点'),(15,15,1,3,'古锭刀',1,9,90,0,'增加武将武力属性9点'),(16,16,1,3,'七星宝刀',1,9,90,0,'增加武将武力属性9点'),(17,17,1,3,'养由基弓',1,9,90,0,'增加武将武力属性9点'),(18,18,1,4,'方天画戟',1,12,120,0,'增加武将武力属性12点'),(19,19,1,4,'青龙偃月刀',1,12,120,0,'增加武将武力属性12点'),(20,20,1,4,'雌雄一对剑',1,12,120,0,'增加武将武力属性12点'),(21,21,1,4,'蛇矛',1,12,120,0,'增加武将武力属性12点'),(22,22,1,4,'倚天剑',1,12,120,0,'增加武将武力属性12点'),(23,23,1,4,'青釭剑',1,12,120,0,'增加武将武力属性12点'),(24,24,3,1,'黄骠马',2,5,50,0,'增加武将移动属性5点'),(25,25,3,2,'大宛马',2,10,100,0,'增加武将移动属性10点'),(26,26,3,3,'汗血马',2,15,150,0,'增加武将移动属性15点'),(27,27,3,4,'的卢',2,20,200,0,'增加武将移动属性20点'),(28,28,3,4,'绝影',2,20,200,0,'增加武将移动属性20点'),(29,29,3,4,'爪黄飞电',2,20,200,0,'增加武将移动属性20点'),(30,30,3,4,'赤兔',2,20,200,2,'增加武将移动属性20点'),(31,31,2,1,'司马法',3,3,30,0,'增加武将政治属性3点'),(32,32,2,1,'四民月令',3,3,30,0,'增加武将政治属性3点'),(33,33,2,1,'仇国论',3,3,30,0,'增加武将政治属性3点'),(34,34,2,1,'时要论',3,3,30,0,'增加武将政治属性3点'),(35,35,2,1,'干象历注',3,3,30,0,'增加武将政治属性3点'),(36,36,2,2,'商君书',3,6,60,0,'增加武将政治属性6点'),(37,37,2,2,'汉书',3,6,60,0,'增加武将政治属性6点'),(38,38,2,2,'典论',3,6,60,0,'增加武将政治属性6点'),(39,39,2,2,'治论',3,6,60,0,'增加武将政治属性6点'),(40,40,2,2,'吴越春秋',3,6,60,0,'增加武将政治属性6点'),(41,41,2,3,'管子',3,9,90,0,'增加武将政治属性9点'),(42,42,2,3,'墨子',3,9,90,0,'增加武将政治属性9点'),(43,43,2,3,'吴子',3,9,90,0,'增加武将政治属性9点'),(44,44,2,3,'韩非子',3,9,90,0,'增加武将政治属性9点'),(45,45,2,3,'淮南子',3,9,90,0,'增加武将政治属性9点'),(46,46,2,4,'春秋',3,12,120,7,'增加武将政治属性12点'),(47,47,2,4,'战国策',3,12,120,0,'增加武将政治属性12点'),(48,48,2,4,'礼记',3,12,120,0,'增加武将政治属性12点'),(49,49,2,4,'史记',3,12,120,0,'增加武将政治属性12点'),(50,50,2,4,'三略',3,12,120,0,'增加武将政治属性12点'),(51,51,8,1,'辩道论',4,3,30,0,'增加武将智力属性3点'),(52,52,8,1,'博弈论',4,3,30,0,'增加武将智力属性3点'),(53,53,8,1,'伤寒杂病论',4,3,30,0,'增加武将智力属性3点'),(54,54,8,1,'孟德新书',4,3,30,0,'增加武将智力属性3点'),(55,55,8,1,'兵法二十四编',4,3,30,0,'增加武将智力属性3点'),(56,56,8,2,'青囊书',4,6,60,0,'增加武将智力属性6点'),(57,57,8,2,'孙膑兵法',4,6,60,0,'增加武将智力属性6点'),(58,58,8,2,'山海经',4,6,60,0,'增加武将智力属性6点'),(59,59,8,2,'论语集解',4,6,60,0,'增加武将智力属性6点'),(60,60,8,2,'尉缭子',4,6,60,0,'增加武将智力属性6点'),(61,61,8,3,'六韬',4,9,90,0,'增加武将智力属性9点'),(62,62,8,3,'论语',4,9,90,0,'增加武将智力属性9点'),(63,63,8,3,'书经',4,9,90,0,'增加武将智力属性9点'),(64,64,8,3,'诗经',4,9,90,0,'增加武将智力属性9点'),(65,65,8,3,'尚书',4,9,90,0,'增加武将智力属性9点'),(66,66,8,4,'老子',4,12,120,0,'增加武将智力属性12点'),(67,67,8,4,'易经',4,12,120,0,'增加武将智力属性12点'),(68,68,8,4,'庄子',4,12,120,0,'增加武将智力属性12点'),(69,69,8,4,'孙子兵法',4,12,120,0,'增加武将智力属性12点'),(70,70,8,4,'九章算术',4,12,120,0,'增加武将智力属性12点'),(71,71,4,1,'金耳墜',5,1,10,0,'增加友好度1点'),(72,72,4,1,'玉佩',5,1,10,0,'增加友好度1点'),(73,73,4,1,'玉环',5,1,10,0,'增加友好度1点'),(74,74,4,1,'珍珠',5,1,10,0,'增加友好度1点'),(75,75,4,1,'金珠',5,1,10,0,'增加友好度1点'),(76,76,4,2,'罗绮香囊',5,2,20,0,'增加友好度2点'),(77,77,4,2,'羽扇',5,2,20,0,'增加友好度2点'),(78,78,4,2,'博山炉',5,2,20,0,'增加友好度2点'),(79,79,4,2,'吕氏镜',5,2,20,0,'增加友好度2点'),(80,80,4,2,'牛灯',5,2,20,0,'增加友好度2点'),(81,81,4,3,'青釉谷仓罐',5,3,30,0,'增加友好度3点'),(82,82,4,3,'涂漆鼎',5,3,30,0,'增加友好度3点'),(83,83,4,3,'龙方壶',5,3,30,0,'增加友好度3点'),(84,84,4,3,'夜光杯',5,3,30,0,'增加友好度3点'),(85,85,4,3,'夜明珠',5,3,30,0,'增加友好度3点'),(86,86,4,4,'玉龙纹壁',5,4,40,0,'增加友好度4点'),(87,87,4,4,'长信宫灯',5,4,40,0,'增加友好度4点'),(88,88,4,4,'神兽砚',5,4,40,0,'增加友好度4点'),(89,89,4,4,'和氏璧',5,4,40,0,'增加友好度4点'),(90,90,4,4,'焦尾琴',5,4,40,0,'增加友好度4点'),(91,91,6,1,'木牛',6,10,3,20,'缩短任务时间10天'),(92,92,6,2,'流马',6,20,6,5,'缩短任务时间20天'),(93,93,7,0,'虎符',7,4,10,4,'武将持之可率领大型军团出战');

/*Table structure for table `hf_sys_setting` */
DROP TABLE IF EXISTS `hf_sys_setting`;

CREATE TABLE `hf_sys_setting` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(64) NOT NULL NULL DEFAULT '',
  `value` varchar(64) NOT NULL NULL DEFAULT '',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

/*Data for the table `hf_sys_setting` */

insert  into `hf_sys_setting`(id,name,value) values (1,'resource_center','http://192.168.36.12');
insert  into `hf_sys_setting`(id,name,value) values (2,'is_opened','1');
insert  into `hf_sys_setting`(id,name,value) values (3,'default_open_days','3');
insert  into `hf_sys_setting`(id,name,value) values (4,'cache_flag','0');
insert  into `hf_sys_setting`(id,name,value) values (5,'memcached_url','192.168.36.12:11211');
insert  into `hf_sys_setting`(id,name,value) values (6,'mail_add','admin@51zhi.com');
insert  into `hf_sys_setting`(id,name,value) values (7,'mail_sign','hehe');
insert  into `hf_sys_setting`(id,name,value) values (8,'auto_load_game','1');
insert  into `hf_sys_setting`(id,name,value) values (9,'need_invite_code','0');
insert  into `hf_sys_setting`(id,name,value) values (10,'invite_award','10');
insert  into `hf_sys_setting`(id,name,value) values (11,'pay_key','hehe');
insert  into `hf_sys_setting`(id,name,value) values (12,'is_maintenance','0');
insert  into `hf_sys_setting`(id,name,value) values (13,'valid_url','http://member.51zhi.com/api/valid_password');
insert  into `hf_sys_setting`(id,name,value) values (14,'mail_content','your mail content');
insert  into `hf_sys_setting`(id,name,value) values (15,'mail_subject','your mail subject');
insert  into `hf_sys_setting`(id,name,value) values (16,'help_url','http://www.51zhi.com/help.html');
insert  into `hf_sys_setting`(id,name,value) values (17,'vip_price','3000');
insert  into `hf_sys_setting`(id,name,value) values (18,'vip_time','129600');


/*Table structure for table `hf_admin` */
DROP TABLE IF EXISTS `hf_admin`;

CREATE TABLE `hf_admin` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `username` varchar(64) NOT NULL NULL DEFAULT '',
  `password` char(32) NOT NULL NULL DEFAULT '',
  `group_id` int(10) NOT NULL NULL DEFAULT 0,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

/*Data for the table `hf_admin` */

insert  into `hf_admin`(id,username,password,group_id) values (1,'admin','21232f297a57a5a743894a0e4a801fc3',1);

/*Table structure for table `hf_group` */
DROP TABLE IF EXISTS `hf_group`;

CREATE TABLE `hf_group` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(64) NOT NULL NULL DEFAULT '',
  `description` varchar(250) NOT NULL NULL DEFAULT '',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

insert into hf_group values(1,'admin','admin');

/*Table structure for table `hf_buy_log` */
DROP TABLE IF EXISTS `hf_buy_log`;

CREATE TABLE `hf_buy_log` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` int(10) NOT NULL NULL DEFAULT '0',
  `total` int(10) NOT NULL NULL DEFAULT '0',
  `buy_date` int(11) NOT NULL NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

/*Data for the table `hf_buy_log` */


/*Table structure for table `hf_authority` */
DROP TABLE IF EXISTS `hf_authority`;

CREATE TABLE `hf_authority` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `group_id` int(10) NOT NULL NULL DEFAULT 0,
  `show_user` tinyint(3) DEFAULT '0',
  `lock_user` tinyint(3) DEFAULT '0',
  `show_pay_log` tinyint(3) DEFAULT '0',
  `show_consume_log` tinyint(3) DEFAULT '0',
  `show_treasure` tinyint(3) DEFAULT '0',
  `edit_treasure` tinyint(3) DEFAULT '0',
  `del_treasure` tinyint(3) DEFAULT '0',
  `show_game` tinyint(3) DEFAULT '0',
  `edit_game` tinyint(3) DEFAULT '0',
  `del_game` tinyint(3) DEFAULT '0',
  `show_maintainer` tinyint(3) DEFAULT '0',
  `add_maintainer` tinyint(3) DEFAULT '0',
  `del_maintainer` tinyint(3) DEFAULT '0',
  `show_server` tinyint(3) DEFAULT '0',
  `add_server` tinyint(3) DEFAULT '0',
  `edit_server` tinyint(3) DEFAULT '0',
  `del_server` tinyint(3) DEFAULT '0',
  `show_cache` tinyint(3) DEFAULT '0',
  `del_cache` tinyint(3) DEFAULT '0',
  `edit_resource` tinyint(3) DEFAULT '0',
  `edit_memcached` tinyint(3) DEFAULT '0',
  `edit_mail` tinyint(3) DEFAULT '0',
  `edit_logsetting` tinyint(3) DEFAULT '0',
  `edit_invite` tinyint(3) DEFAULT '0',
  `edit_pay_key` tinyint(3) DEFAULT '0',
  `show_group` tinyint(3) DEFAULT '0',
  `edit_group` tinyint(3) DEFAULT '0',
  `del_group` tinyint(3) DEFAULT '0',
  `show_invite_code` tinyint(3) DEFAULT '0',
  `add_invite_code` tinyint(3) DEFAULT '0',
  `edit_maintenance` tinyint(3) DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

insert  into `hf_authority`(id,group_id,show_user,lock_user,show_pay_log,show_consume_log,show_treasure,edit_treasure,del_treasure,show_game,edit_game,del_game,show_maintainer,add_maintainer,del_maintainer,show_server,add_server,edit_server,del_server,show_cache,del_cache,edit_resource,edit_memcached,edit_mail,edit_logsetting,edit_invite,edit_pay_key,show_group,edit_group,del_group,show_invite_code,add_invite_code,edit_maintenance) values (1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1);
