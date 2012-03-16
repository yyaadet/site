
/*Table structure for table `hf_sphere` */
DROP TABLE IF EXISTS `hf_sphere`;

CREATE TABLE `hf_sphere` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` int(10) DEFAULT '0',
  `name` varchar(64) DEFAULT '',
  `level` int(10) DEFAULT '0',
  `prestige` int(10) DEFAULT '0',
  `is_npc` int(10) DEFAULT '0',
  `description` varchar(250) DEFAULT '',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

/*Data for the table `hf_sphere` */
insert  into `hf_sphere` (id,user_id,name,level,prestige,is_npc) values (1,1,'²Ü²Ù',4,236000,1);
insert  into `hf_sphere` (id,user_id,name,level,prestige,is_npc) values (2,2,'¿×Æ',2,44000,1);
insert  into `hf_sphere` (id,user_id,name,level,prestige,is_npc) values (3,3,'ÂÀ²¼',4,216000,1);
insert  into `hf_sphere` (id,user_id,name,level,prestige,is_npc) values (4,4,'Ô¬ÉÜ',4,196000,1);
insert  into `hf_sphere` (id,user_id,name,level,prestige,is_npc) values (5,5,'Àî‚à',4,256000,1);
insert  into `hf_sphere` (id,user_id,name,level,prestige,is_npc) values (6,6,'ÍõÀÊ',1,22000,1);
insert  into `hf_sphere` (id,user_id,name,level,prestige,is_npc) values (7,7,'Ëï²ß',2,74000,1);
insert  into `hf_sphere` (id,user_id,name,level,prestige,is_npc) values (8,8,'ÂíÌÚ',2,80000,1);
insert  into `hf_sphere` (id,user_id,name,level,prestige,is_npc) values (9,9,'Ô¬Êõ',4,176000,1);
insert  into `hf_sphere` (id,user_id,name,level,prestige,is_npc) values (10,10,'Áõ±¸',2,68000,1);
insert  into `hf_sphere` (id,user_id,name,level,prestige,is_npc) values (11,11,'Áõ±í',3,118000,1);
insert  into `hf_sphere` (id,user_id,name,level,prestige,is_npc) values (12,12,'Áõè°',3,108000,1);
insert  into `hf_sphere` (id,user_id,name,level,prestige,is_npc) values (13,13,'ÕÅÂ³',2,62000,1);
insert  into `hf_sphere` (id,user_id,name,level,prestige,is_npc) values (14,14,'¿×ÈÚ',2,56000,1);
insert  into `hf_sphere` (id,user_id,name,level,prestige,is_npc) values (15,15,'ÕÅÑà',1,25000,1);
insert  into `hf_sphere` (id,user_id,name,level,prestige,is_npc) values (16,16,'ÌÕÇ«',3,98000,1);
insert  into `hf_sphere` (id,user_id,name,level,prestige,is_npc) values (17,17,'¹«Ëïè¶',3,128000,1);
insert  into `hf_sphere` (id,user_id,name,level,prestige,is_npc) values (18,18,'Áõôí',2,50000,1);
insert  into `hf_sphere` (id,user_id,name,level,prestige,is_npc) values (19,19,'ÕÅÑî',1,28000,1);
insert  into `hf_sphere` (id,user_id,name,level,prestige,is_npc) values (20,20,'¹«Ëï¶È',3,88000,1);
insert  into `hf_sphere` (id,user_id,name,level,prestige,is_npc) values (21,21,'ÑÏ°×»¢',1,31000,1);



delete from hf_treasure;
delete from hf_diplomacy;
delete from hf_mail;
update hf_user set name = "", wid = 0, vip_total_hour=0,vip_used_hour=0,online_second=0 where wid != -1;


