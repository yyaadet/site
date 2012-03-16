
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
insert  into `hf_sphere` (id,user_id,name,level,prestige,is_npc) values (1,1,'�ܲ�',4,236000,1);
insert  into `hf_sphere` (id,user_id,name,level,prestige,is_npc) values (2,2,'�ׁ�',2,44000,1);
insert  into `hf_sphere` (id,user_id,name,level,prestige,is_npc) values (3,3,'����',4,216000,1);
insert  into `hf_sphere` (id,user_id,name,level,prestige,is_npc) values (4,4,'Ԭ��',4,196000,1);
insert  into `hf_sphere` (id,user_id,name,level,prestige,is_npc) values (5,5,'���',4,256000,1);
insert  into `hf_sphere` (id,user_id,name,level,prestige,is_npc) values (6,6,'����',1,22000,1);
insert  into `hf_sphere` (id,user_id,name,level,prestige,is_npc) values (7,7,'���',2,74000,1);
insert  into `hf_sphere` (id,user_id,name,level,prestige,is_npc) values (8,8,'����',2,80000,1);
insert  into `hf_sphere` (id,user_id,name,level,prestige,is_npc) values (9,9,'Ԭ��',4,176000,1);
insert  into `hf_sphere` (id,user_id,name,level,prestige,is_npc) values (10,10,'����',2,68000,1);
insert  into `hf_sphere` (id,user_id,name,level,prestige,is_npc) values (11,11,'����',3,118000,1);
insert  into `hf_sphere` (id,user_id,name,level,prestige,is_npc) values (12,12,'���',3,108000,1);
insert  into `hf_sphere` (id,user_id,name,level,prestige,is_npc) values (13,13,'��³',2,62000,1);
insert  into `hf_sphere` (id,user_id,name,level,prestige,is_npc) values (14,14,'����',2,56000,1);
insert  into `hf_sphere` (id,user_id,name,level,prestige,is_npc) values (15,15,'����',1,25000,1);
insert  into `hf_sphere` (id,user_id,name,level,prestige,is_npc) values (16,16,'��ǫ',3,98000,1);
insert  into `hf_sphere` (id,user_id,name,level,prestige,is_npc) values (17,17,'�����',3,128000,1);
insert  into `hf_sphere` (id,user_id,name,level,prestige,is_npc) values (18,18,'����',2,50000,1);
insert  into `hf_sphere` (id,user_id,name,level,prestige,is_npc) values (19,19,'����',1,28000,1);
insert  into `hf_sphere` (id,user_id,name,level,prestige,is_npc) values (20,20,'�����',3,88000,1);
insert  into `hf_sphere` (id,user_id,name,level,prestige,is_npc) values (21,21,'�ϰ׻�',1,31000,1);



delete from hf_treasure;
delete from hf_diplomacy;
delete from hf_mail;
update hf_user set name = "", wid = 0, vip_total_hour=0,vip_used_hour=0,online_second=0 where wid != -1;


