package utils
{
	import city.model.City;
	
	import flash.display.DisplayObject;
	import flash.filters.GlowFilter;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	
	import general.model.General;
	import general.model.Zhen;
	
	import mx.core.UIComponent;
	
	import sphere.model.Sphere;
	
	import wubao.model.Build;
	import wubao.model.Official;
	import wubao.model.Tech;
	import wubao.model.User;
	import wubao.model.UserTreasure;
	import wubao.model.Weapon;
	import wubao.model.WuBao;
	
	/**
	 * 游戏公共单元
	 * @author StarX
	 * 
	 */	
	public class PubUnit
	{
		//==============================================================================
		// 颜色类型定义
		//==============================================================================
		
		//黑
		public static const BLACK:uint = 0x000000;
		
		//白
		public static const WHITE:uint = 0xFFFFFF;
		
		//红
		public static const RED:uint = 0xFF0000;
		
		//绿
		public static const GREEN:uint = 0x00FF00;
		
		//蓝
		public static const BLUE:int = 0x0000FF;
		
		//黄
		public static const YELLOW:int = 0xffce70;
		
		//灰
		public static const GRAY:int = 0x333333;
		
		//血条中的青色
		public static const CYAN:int = 0xC8DD38;
		
		//天蓝色
		public static const SKY:int = 0x00BBFF;
		
		//同盟颜色
		public static const UNION:int = 0xFFAE00;
		
		//金色 
		public static const GOLD:int = 0xBD9E61;
		
		//==============================================================================
		// 其他定义
		//==============================================================================
		
		//客户端版本号
		public static const version:int = 202;
		
		//一年的月份数
		public static const monOfYear:int = 12;
		
		//一月的天数
		public static const dayOfMon:int = 30;
		
		//一天的小时数
		public static const hourOfDay:int = 12;
		
		public static const hourOfYear:int = hourOfDay * dayOfMon * monOfYear;
		
		//任务执行间隔时间
		public static const workInterval:int = 1000;
		
		//游戏每时辰秒数
		public static const secGameHour:int = 20;
		
		//每天修炼的最大次数
		public static const xiuMax:int = 100;
		
		//允许进入地区所需等级
		public static const AreaLimit:int = 10;
		
		//允许进入寻访所需等级
		public static const FindLimit:int = 10;
		
		//允许进入世界所需等级
		public static const WorldLimit:int = 10; 
		
		//装备等级单位
		public static const wpLevelUnit:String = "星";
		
		//资源
		public static const resList:Array = ["资源", "粮食", "木料", "矿石", "马匹", "皮革", "钱币"];
		
		//装备
		public static const weaponList:Array = ["装备", "铁剑", "长戟", "手弩", "木盾", "皮甲", "铁甲", "甲车", "弩车", "战马", "百炼刀", "点钢枪", "诸葛弩", "虎纹盾", "鱼鳞甲", "乌孙马"];
		
		//坞堡建筑
		public static const buildList:Array = ["建筑", "书院", "民居", "库房", "工坊", "农田", "伐木场", "矿山", "牧场", "革坊", "集市", "议事堂", "医馆", "军营"];
		
		//书院科技
		public static const techList:Array = ["技术", "铸剑", "制戟", "机括", "制盾", "鞣皮", "浇铸", "木工", "机械", "驯马", "种植", "伐木", "采矿", "放牧", "制革", "贸易"];
		
		//城池等级
		public static const cityLevelList:Array = ["", "县城", "郡城", "州城", "都城"];

		//玩家排名
		public static const userLevelList:Array = ["", "太尉", "司徒", "司空", "太常", "光禄勋", "卫尉", "太仆", "廷尉", "大鸿胪", "宗正", "大司农", "少府"];
		
		//道具类型
		public static const tsList:Array = ["道具", "武器", "经论", "典籍", "坐骑", "财宝", "VIP"];
		
		//道具属性类型
		public static const tsPropList:Array = ["道具属性", "武力", "智力", "政治", "移动", "友好度", "时辰"];
		
		//职位(势力等级)
		public static const sphLevelList:Array = [{id:0, name:"白身", user_num:10, city_num:0},
		                                          {id:1, name:"县令", user_num:20, city_num:1},
		                                          {id:2, name:"太守", user_num:30, city_num:5},
		                                          {id:3, name:"州牧", user_num:50, city_num:15},
		                                          {id:4, name:"九卿", user_num:80, city_num:30},
		                                          {id:5, name:"丞相", user_num:120, city_num:50},
		                                          {id:6, name:"皇帝", user_num:200, city_num:143}
											   ];	
		
		//爵位
		public static const dignitieList:Array = [{id:0, name:"平民", prestige:0, general_num:1},
		                                          {id:1, name:"男", prestige:2000, general_num:2},
		                                          {id:2, name:"子", prestige:4000, general_num:3},
		                                          {id:3, name:"伯", prestige:6000, general_num:4},
		                                          {id:4, name:"侯", prestige:8000, general_num:5},
		                                          {id:5, name:"公", prestige:9000, general_num:6},
		                                          {id:6, name:"王", prestige:10000, general_num:6}
											   ];
		
		//官位(授予武将)
		public static const officialList:Array = [
		                            {id:0, name:"校尉", level:0, type:0, follows:2000, kongfu:0, speed:0, polity:0, intelligence:0, salary:500, dig:0},
									{id:1, name:"威东将军", level:1, type:0, follows:2200, kongfu:1, speed:0, polity:0, intelligence:0, salary:800, dig:1},
									{id:2, name:"威南将军", level:1, type:0, follows:2200, kongfu:1, speed:0, polity:0, intelligence:0, salary:800, dig:1},
									{id:3, name:"威西将军", level:1, type:0, follows:2200, kongfu:1, speed:0, polity:0, intelligence:0, salary:800, dig:1},
									{id:4, name:"威北将军", level:1, type:0, follows:2200, kongfu:1, speed:0, polity:0, intelligence:0, salary:800, dig:1},
									{id:5, name:"郎中", level:1, type:1, follows:2200, kongfu:0, speed:0, polity:1, intelligence:0, salary:800, dig:1},
									{id:6, name:"从事郎中", level:1, type:1, follows:2200, kongfu:0, speed:0, polity:1, intelligence:0, salary:800, dig:1},
									{id:7, name:"长史", level:1, type:1, follows:2200, kongfu:0, speed:0, polity:0, intelligence:1, salary:800, dig:1},
									{id:8, name:"司马", level:1, type:1, follows:2200, kongfu:0, speed:0, polity:0, intelligence:1, salary:800, dig:1},
									{id:9, name:"军师将军", level:2, type:0, follows:2400, kongfu:2, speed:0, polity:0, intelligence:0, salary:1000, dig:2},
									{id:10, name:"安国将军", level:2, type:0, follows:2400, kongfu:2, speed:0, polity:0, intelligence:0, salary:1000, dig:2},
									{id:11, name:"破虏将军", level:2, type:0, follows:2400, kongfu:2, speed:0, polity:0, intelligence:0, salary:1000, dig:2},
									{id:12, name:"讨逆将军", level:2, type:0, follows:2400, kongfu:2, speed:0, polity:0, intelligence:0, salary:1000, dig:2},
									{id:13, name:"谒者仆射", level:2, type:1, follows:2400, kongfu:0, speed:0, polity:2, intelligence:0, salary:1000, dig:2},
									{id:14, name:"都尉", level:2, type:1, follows:2400, kongfu:0, speed:0, polity:2, intelligence:0, salary:1000, dig:2},
									{id:15, name:"黄门侍郎", level:2, type:1, follows:2400, kongfu:0, speed:0, polity:0, intelligence:2, salary:1000, dig:2},
									{id:16, name:"太史令", level:2, type:1, follows:2400, kongfu:0, speed:0, polity:0, intelligence:2, salary:1000, dig:2},
									{id:17, name:"左将军", level:3, type:0, follows:2600, kongfu:3, speed:0, polity:0, intelligence:0, salary:1200, dig:3},
									{id:18, name:"右将军", level:3, type:0, follows:2600, kongfu:3, speed:0, polity:0, intelligence:0, salary:1200, dig:3},
									{id:19, name:"前将军", level:3, type:0, follows:2600, kongfu:3, speed:0, polity:0, intelligence:0, salary:1200, dig:3},
									{id:20, name:"后将军", level:3, type:0, follows:2600, kongfu:3, speed:0, polity:0, intelligence:0, salary:1200, dig:3},
									{id:21, name:"秘书令", level:3, type:1, follows:2600, kongfu:0, speed:0, polity:3, intelligence:0, salary:1200, dig:3},
									{id:22, name:"侍中", level:3, type:1, follows:2600, kongfu:0, speed:0, polity:3, intelligence:0, salary:1200, dig:3},
									{id:23, name:"留府长史", level:3, type:1, follows:2600, kongfu:0, speed:0, polity:0, intelligence:3, salary:1200, dig:3},
									{id:24, name:"太学博士", level:3, type:1, follows:2600, kongfu:0, speed:0, polity:0, intelligence:3, salary:1200, dig:3},
									{id:25, name:"安东将军", level:4, type:0, follows:2800, kongfu:4, speed:0, polity:0, intelligence:0, salary:1400, dig:4},
									{id:26, name:"安南将军", level:4, type:0, follows:2800, kongfu:4, speed:0, polity:0, intelligence:0, salary:1400, dig:4},
									{id:27, name:"安西将军", level:4, type:0, follows:2800, kongfu:4, speed:0, polity:0, intelligence:0, salary:1400, dig:4},
									{id:28, name:"安北将军", level:4, type:0, follows:2800, kongfu:4, speed:0, polity:0, intelligence:0, salary:1400, dig:4},
									{id:29, name:"中书令", level:4, type:1, follows:2800, kongfu:0, speed:0, polity:4, intelligence:0, salary:1400, dig:4},
									{id:30, name:"御史中丞", level:4, type:1, follows:2800, kongfu:0, speed:0, polity:4, intelligence:0, salary:1400, dig:4},
									{id:31, name:"执金吾", level:4, type:1, follows:2800, kongfu:0, speed:0, polity:0, intelligence:4, salary:1400, dig:4},
									{id:32, name:"少府", level:4, type:1, follows:2800, kongfu:0, speed:0, polity:0, intelligence:4, salary:1400, dig:4},
									{id:33, name:"镇东将军", level:5, type:0, follows:3000, kongfu:5, speed:0, polity:0, intelligence:0, salary:1800, dig:5},
									{id:34, name:"镇南将军", level:5, type:0, follows:3000, kongfu:5, speed:0, polity:0, intelligence:0, salary:1800, dig:5},
									{id:35, name:"镇西将军", level:5, type:0, follows:3000, kongfu:5, speed:0, polity:0, intelligence:0, salary:1800, dig:5},
									{id:36, name:"镇北将军", level:5, type:0, follows:3000, kongfu:5, speed:0, polity:0, intelligence:0, salary:1800, dig:5},
									{id:37, name:"尚书令", level:5, type:1, follows:3000, kongfu:0, speed:0, polity:5, intelligence:0, salary:1800, dig:5},
									{id:38, name:"太仆", level:5, type:1, follows:3000, kongfu:0, speed:0, polity:5, intelligence:0, salary:1800, dig:5},
									{id:39, name:"太常", level:5, type:1, follows:3000, kongfu:0, speed:0, polity:0, intelligence:5, salary:1800, dig:5},
									{id:40, name:"光禄大夫", level:5, type:1, follows:3000, kongfu:0, speed:0, polity:0, intelligence:5, salary:1800, dig:5},
									{id:41, name:"征东将军", level:6, type:0, follows:4000, kongfu:6, speed:0, polity:0, intelligence:0, salary:2200, dig:6},
									{id:42, name:"征南将军", level:6, type:0, follows:4000, kongfu:6, speed:0, polity:0, intelligence:0, salary:2200, dig:6},
									{id:43, name:"征西将军", level:6, type:0, follows:4000, kongfu:6, speed:0, polity:0, intelligence:0, salary:2200, dig:6},
									{id:44, name:"征北将军", level:6, type:0, follows:4000, kongfu:6, speed:0, polity:0, intelligence:0, salary:2200, dig:6},
									{id:45, name:"光禄勋", level:6, type:1, follows:4000, kongfu:0, speed:0, polity:6, intelligence:0, salary:2200, dig:6},
									{id:46, name:"大司农", level:6, type:1, follows:4000, kongfu:0, speed:0, polity:6, intelligence:0, salary:2200, dig:6},
									{id:47, name:"卫尉", level:6, type:1, follows:4000, kongfu:0, speed:0, polity:0, intelligence:6, salary:2200, dig:6},
									{id:48, name:"延尉", level:6, type:1, follows:4000, kongfu:0, speed:0, polity:0, intelligence:6, salary:2200, dig:6}];
		
		//修炼类型
		public static const studyType:Array = ["武略", "阵法"];
		
		//兵种系类型
		public static const soliderType:Array = ["特殊", "骑兵", "弩兵", "步兵", "骑射", "弩车", "甲车"];
		
		//兵种数据列表
		public static const soliderList:Array = [{id:0, speed:5,distance:1},
		                                         {id:1, speed:20,distance:1}, 
		                                         {id:2, speed:10,distance:2}, 
		                                         {id:3, speed:10,distance:1}, 
		                                         {id:4, speed:20,distance:2}, 
		                                         {id:5, speed:5,distance:1}, 
		                                         {id:6, speed:25,distance:2}];   
		
		//修炼兵种数据
		public static const xiuSoliderList:Array = [{soliderID:1, soliderName:"剑盾骑兵", attack:10, defense:20, speed:20},
		                                            {soliderID:2, soliderName:"弩兵", attack:20, defense:16, speed:10},
		                                            {soliderID:3, soliderName:"戟兵", attack:16, defense:20, speed:10},
		                                            {soliderID:4, soliderName:"弩骑兵", attack:15, defense:15, speed:20}
		                                           ];
 
		//技能类型
		public static const skillType:Array = ["", "统率技能", "战斗技能", "特殊技能"];
		
		//技能列表 
		// type 兵种系类型  1--骑兵  2--弩兵  3--步兵  4--弓骑  5--攻城  6--水战 0--特殊
		// skill_type  技能类型  1--军略  2--武略   3--特殊
		public static const skillList:Array = [ 
		{id:1,  type:1, type_name:"骑兵系", skill_type:1, name:"突破", min1:65, max1:74, min2:0, max2:200, min3:0, max3:200, condi:"武力65-74", pre:"300", info:"能够提升骑兵20%的攻击力"},
		{id:2,  type:1, type_name:"骑兵系", skill_type:1, name:"突进", min1:75, max1:84, min2:0, max2:200, min3:0, max3:200, condi:"武力75-84", pre:"600", info:"能够提升骑兵40%的攻击力"},
		{id:3,  type:1, type_name:"骑兵系", skill_type:1, name:"突击", min1:85, max1:200, min2:0, max2:200, min3:0, max3:200, condi:"武力85以上", pre:"900", info:"能够提升骑兵60%的攻击力"},
		{id:4,  type:1, type_name:"骑兵系", skill_type:2, name:"速攻", min1:90, max1:200, min2:0, max2:200, min3:0, max3:200, condi:"武力90以上", pre:"1200", pre:"100", info:"骑兵武略，增加骑兵基础攻击力20%。"},
		{id:5,  type:2, type_name:"弩兵系", skill_type:1, name:"速射", min1:0, max1:200, min2:65, max2:74, min3:0, max3:200, condi:"智力65-74", pre:"200", info:"能够提升弩兵20%的攻击力"},
		{id:6,  type:2, type_name:"弩兵系", skill_type:1, name:"连射", min1:0, max1:200, min2:75, max2:84, min3:0, max3:200, condi:"智力75-84", pre:"400", info:"能够提升弩兵40%的攻击力"},
		{id:7,  type:2, type_name:"弩兵系", skill_type:1, name:"齐射", min1:0, max1:200, min2:85, max2:200, min3:0, max3:200, condi:"智力85以上", pre:"600", info:"能够提升弩兵60%的攻击力"},
		{id:8,  type:2, type_name:"弩兵系", skill_type:2, name:"火箭", min1:0, max1:200, min2:90, max2:200, min3:0, max3:200, condi:"智力90以上", pre:"800", info:"弩兵武略，增加弩兵基础攻击力20%。"},
		{id:9,  type:3, type_name:"步兵系", skill_type:1, name:"奋战", min1:0, max1:200, min2:0, max2:200, min3:65, max3:74, condi:"政治65-74", pre:"100", info:"能够提升步兵20%的攻击力"},
		{id:10, type:3, type_name:"步兵系", skill_type:1, name:"奋斗", min1:0, max1:200, min2:0, max2:200, min3:75, max3:84, condi:"政治75-84", pre:"200", info:"能够提升步兵40%的攻击力"},
		{id:11, type:3, type_name:"步兵系", skill_type:1, name:"奋迅", min1:0, max1:200, min2:0, max2:200, min3:85, max3:200, condi:"政治85以上", pre:"300", info:"能够提升步兵60%的攻击力"},
		{id:12, type:3, type_name:"步兵系", skill_type:2, name:"乱战", min1:0, max1:200, min2:0, max2:200, min3:90, max3:200, condi:"政治90以上", pre:"400", info:"步兵武略，增加步兵基础攻击力20%。"},
		{id:13, type:4, type_name:"骑射系", skill_type:1, name:"骑射", min1:65, max1:74, min2:50, max2:200, min3:0, max3:200, condi:"武力65-74并且智力50以上", pre:"400", info:"能够提升弩骑兵20%的攻击力"},
		{id:14, type:4, type_name:"骑射系", skill_type:1, name:"奔射", min1:75, max1:84, min2:60, max2:200, min3:0, max3:200, condi:"武力75-84并且智力60以上", pre:"800", info:"能够提升弩骑兵40%的攻击力"},
		{id:15, type:4, type_name:"骑射系", skill_type:1, name:"飞射", min1:85, max1:200, min2:70, max2:200, min3:0, max3:200, condi:"武力85以上并且智力70以上", pre:"1200", info:"能够提升弩骑兵60%的攻击力"},
		{id:16, type:4, type_name:"骑射系", skill_type:2, name:"回射", min1:90, max1:200, min2:80, max2:200, min3:0, max3:200, condi:"武力90以上并且智力80以上", pre:"1600", info:"弩骑兵武略，增加弩骑兵基础攻击力20%。"},
		{id:17, type:5, type_name:"弩车系", skill_type:1, name:"抛射", min1:0, max1:200, min2:65, max2:74, min3:50, max3:200, condi:"智力65-74并且政治50以上", pre:"600", info:"能够提升弩车兵20%的攻击力"},
		{id:18, type:5, type_name:"弩车系", skill_type:1, name:"连弩", min1:0, max1:200, min2:75, max2:84, min3:60, max3:200, condi:"智力75-84并且政治60以上", pre:"1200", info:"能够提升弩车兵40%的攻击力"},
		{id:19, type:5, type_name:"弩车系", skill_type:1, name:"联发", min1:0, max1:200, min2:85, max2:200, min3:70, max3:200, condi:"智力85以上并且政治70以上", pre:"1800", info:"能够提升弩车兵60%的攻击力"},
		{id:20, type:5, type_name:"弩车系", skill_type:2, name:"弹道", min1:0, max1:200, min2:90, max2:200, min3:80, max3:200, condi:"智力90以上并且政治80以上", pre:"2400", info:"弩车兵武略，提高弩车兵基础攻击力20%。"},
		{id:21, type:6, type_name:"甲车系", skill_type:1, name:"防护", min1:50, max1:200, min2:0, max2:200, min3:65, max3:74, condi:"政治65-74并且武力50以上", pre:"500", info:"能够提升甲车兵20%的防御力"},
		{id:22, type:6, type_name:"甲车系", skill_type:1, name:"护甲", min1:60, max1:200, min2:0, max2:200, min3:75, max3:84, condi:"政治75-84并且武力60以上", pre:"1000", info:"能够提升甲车兵40%的防御力"},
		{id:23, type:6, type_name:"甲车系", skill_type:1, name:"盾甲", min1:70, max1:200, min2:0, max2:200, min3:85, max3:200, condi:"政治85以上并且武力70以上", pre:"1500", info:"能够提升甲车兵60%的防御力"},
		{id:24, type:6, type_name:"甲车系", skill_type:2, name:"连环", min1:80, max1:200, min2:0, max2:200, min3:90, max3:200, condi:"政治90以上并且武力80以上", pre:"2000", info:"甲车兵武略，提高甲车兵基础防御力20%。"},
		{id:25, type:0, type_name:"特殊", skill_type:3, name:"无双", min1:98, max1:200, min2:0, max2:200, min3:0, max3:200, condi:"武力98以上", pre:"50000", info:"绝世猛将的爆发！士气高昂时可使军团攻击力翻倍。"},
		{id:26, type:0, type_name:"特殊", skill_type:3, name:"破阵", min1:0, max1:200, min2:98, max2:200, min3:0, max3:200, condi:"智力98以上", pre:"50000", info:"士气高昂时可通过巧妙的攻击使敌军无法列成阵势。"},
		{id:27, type:0, type_name:"特殊", skill_type:3, name:"坚守", min1:0, max1:200, min2:0, max2:200, min3:98, max3:200, condi:"政治98以上", pre:"50000", info:"布下钢铁般的防线！士气高昂时坚守阵地，获得双倍防御力。"},
		{id:28, type:0, type_name:"特殊", skill_type:3, name:"奇袭", min1:90, max1:200, min2:80, max2:200, min3:80, max3:200, condi:"武力90以上且智力或政治80以上", pre:"30000", info:"每轮战斗都有5%的机会安排一支奇兵在战斗中袭击敌军后方，可增加30%的杀伤。"},
		{id:29, type:0, type_name:"特殊", skill_type:3, name:"混乱", min1:80, max1:200, min2:90, max2:200, min3:80, max3:200, condi:"智力90以上且武力或政治80以上", pre:"30000", info:"士气高昂时攻击可使敌军混乱，无法组织反击和防御。"},
		{id:30, type:0, type_name:"特殊", skill_type:3, name:"沉着", min1:80, max1:200, min2:80, max2:200, min3:90, max3:200, condi:"政治90以上且武力或智力80以上", pre:"30000", info:"可使军团避免陷入混乱和士气低落。"},
		{id:31, type:0, type_name:"特殊", skill_type:3, name:"骂阵", min1:85, max1:75, min2:85, max2:75, min3:85, max3:75, condi:"武力85以上且智力75以上;或智力85以上且政治75以上;或政治85以上且武力75以上", pre:"10000", info:"士气高昂时通过阵前辱骂敌军主将，降低敌军士气10。"},
		{id:32, type:0, type_name:"特殊", skill_type:3, name:"鼓舞", min1:75, max1:85, min2:75, max2:85, min3:75, max3:85, condi:"武力75以上且智力85以上;或智力75以上且政治85以上;或政治75以上且武力85以上", pre:"10000", info:"每轮战斗都有5%几率士气高涨，每次鼓舞提升军团士气3。"},
	  ];
		
		//阵法列表
		//type 兵种系类型  1--骑兵  2--弩兵  3--步兵  4--弓骑
		//攻击，防御，速度加成: (value + 4) / 4
		public static const zhenList:Array = [
		  {id:1,  type1:1, type2:1, name:"锥形", attack:3, defense:0, speed:1, min1:80, max1:200, min2:0, max2:200, min3:0, max3:200, condi:"武力80以上", pre:"200", info:"攻击高，是迂回到敌人背后发动攻击等情况下的最佳阵形。攻击 +75%，机动 +25%（骑兵专用）"},
          {id:2,  type1:2, type2:2, name:"鹤翼", attack:3, defense:1, speed:0, min1:0, max1:200, min2:80, max2:200, min3:0, max3:200, condi:"智力80以上", pre:"200", info:"摆开阵势，待敌进入攻击范围后万箭齐发，攻击效果显著。攻击 +75%，防御 +25%（弩兵专用）"},
          {id:3,  type1:3, type2:3, name:"鱼鳞", attack:1, defense:3, speed:0, min1:0, max1:200, min2:0, max2:200, min3:80, max3:200, condi:"政治80以上", pre:"200", info:"防御较强的阵形。可以深入敌阵，切断敌军。攻击 +25%，防御 +75%（步兵专用）"},
          {id:4,  type1:4, type2:4, name:"雁行", attack:0, defense:3, speed:1, min1:80, max1:200, min2:70, max2:200, min3:0, max3:200, condi:"武力80以上并且智力70以上", pre:"200", info:"防御高，最适合进行快速远程攻击。防御 +75%，机动 +25%（弩骑兵专用）"},
          {id:5,  type1:1, type2:3, name:"锋矢", attack:4, defense:0, speed:0, min1:80, max1:200, min2:0, max2:200, min3:80, max3:200, condi:"武力或政治80以上", pre:"200", info:"攻击力最高的阵形！放弃防御和机动直击敌军核心。攻击 +100%（步兵和骑兵专用）"},
          {id:6,  type1:0, type2:0, name:"长蛇", attack:0, defense:0, speed:4, min1:70, max1:200, min2:70, max2:200, min3:70, max3:200, condi:"武力、智力或政治70以上", pre:"100", info:"完全放弃攻防，机动力最高的阵型，适合于长途行军。机动 +100%（所有兵种适用）"},
          {id:7,  type1:0, type2:0, name:"衡轭", attack:2, defense:2, speed:0, min1:80, max1:200, min2:80, max2:200, min3:0, max3:200, condi:"武力和智力各80以上", pre:"100", info:"攻攻守平衡的阵型，机动略有不足。攻击 +50%，防御 +50%（所有兵种适用）"},
          {id:8,  type1:0, type2:0, name:"箕形", attack:0, defense:2, speed:2, min1:0, max1:200, min2:80, max2:200, min3:80, max3:200, condi:"政治和智力各80以上", pre:"100", info:"防守和机动兼备的阵形，攻击稍有不足。防御 +50%，机动 +50%（所有兵种适用）"},
          {id:9,  type1:0, type2:0, name:"偃月", attack:2, defense:0, speed:2, min1:80, max1:200, min2:0, max2:200, min3:80, max3:200, condi:"武力和政治各80以上", pre:"100", info:"攻击与机动兼备的阵型，防御稍有不足。攻击 +50%，机动 +50%（所有兵种适用）"},
          {id:10, type1:0, type2:0, name:"方圆", attack:0, defense:4, speed:0, min1:70, max1:200, min2:70, max2:500, min3:70, max3:200, condi:"武力、智力和政治全部70以上", pre:"100", info:"完全放弃攻击和机动，防御最高的阵形，可以有效地抵御各个方向的进攻。防御 +100%（所有兵种适用）"}
         ];		
		
		//建筑树
		//type      建筑类型
		//needType  前提建筑类型
		//money     所需钱
		//max       最高等级
		public static const buildTree:Array = [
		                             {type:1, needType:11, money:8, max:100},
		                             {type:2, needType:11, money:8, max:100},
		                             {type:3, needType:11, money:8, max:100},
		                             {type:4, needType:2, money:8, max:100},
		                             {type:5, needType:2, money:4, max:100},
		                             {type:6, needType:2, money:4, max:100},
		                             {type:7, needType:2, money:4, max:100},
		                             {type:8, needType:2, money:4, max:100},
		                             {type:9, needType:2, money:4, max:100},
		                             {type:10, needType:2, money:4, max:100},
		                             {type:11, needType:0, money:4, max:100},
		                             {type:12, needType:11, money:8, max:100},
		                             {type:13, needType:11, money:8, max:100}
									]
		
		//科技树
		//type  科技类型
		//money 所需钱
		public static const techTree:Array = [
		                             {type:1, money:4, max:10}, {type:2, money:4, max:10}, {type:3, money:4, max:10},
		                             {type:4, money:4, max:10}, {type:5, money:4, max:10}, {type:6, money:4, max:10},
		                             {type:7, money:4, max:10}, {type:8, money:4, max:10}, {type:9, money:4, max:10},
		                             {type:10, money:3, max:20}, {type:11, money:3, max:20}, {type:12, money:3, max:20},
		                             {type:13, money:3, max:20}, {type:14, money:3, max:20}, {type:15, money:3, max:20}
		                             ];
		
		//装备列表
		//factory 装备所需工坊最低等级
		//attack  攻击
		//defense 防御
		//speed   机动
		//"铁剑", "长戟", "手弩", "木盾", "皮甲", "铁甲", "甲车", "弩车", "战马", "百炼刀", "点钢枪", "诸葛弩", "虎纹盾", "鱼鳞甲", "乌孙马"
		public static const weaponPropList:Array = [
		                             {type:1, factory:0, attack:5, defense:0, speed:0, food:0, wood:0, iron:20, horse:0, skin:0, money:1000, made:25},
		                             {type:2, factory:15, attack:10, defense:0, speed:0, food:0, wood:2, iron:10, horse:0, skin:0, money:1000, made:50},
		                             {type:3, factory:30, attack:10, defense:0, speed:0, food:0, wood:2, iron:5, horse:0, skin:0, money:1500, made:50},
		                             {type:4, factory:15, attack:0, defense:5, speed:0, food:0, wood:1, iron:5, horse:0, skin:0, money:500, made:25},
		                             {type:5, factory:30, attack:0, defense:10, speed:0, food:0, wood:0, iron:5, horse:0, skin:5, money:500, made:50},
		                             {type:6, factory:45, attack:0, defense:20, speed:-5, food:0, wood:0, iron:80, horse:0, skin:2, money:2000, made:100},
		                             {type:7, factory:60, attack:10, defense:30, speed:0, food:0, wood:5, iron:20, horse:0, skin:2, money:10000, made:200},
		                             {type:8, factory:60, attack:20, defense:20, speed:0, food:0, wood:5, iron:20, horse:0, skin:2, money:10000, made:200},
		                             {type:9, factory:45, attack:10, defense:10, speed:10, food:0, wood:1, iron:10, horse:1, skin:2, money:5000, made:200},
		                             {type:10, factory:1000, attack:10, defense:0, speed:0, food:0, wood:0, iron:0, horse:0, skin:0, money:0, made:0},
		                             {type:11, factory:1000, attack:20, defense:0, speed:0, food:0, wood:0, iron:0, horse:0, skin:0, money:0, made:0},
		                             {type:12, factory:1000, attack:20, defense:0, speed:0, food:0, wood:0, iron:0, horse:0, skin:0, money:0, made:0},
		                             {type:13, factory:1000, attack:0, defense:10, speed:0, food:0, wood:0, iron:0, horse:0, skin:0, money:0, made:0},
		                             {type:14, factory:1000, attack:0, defense:30, speed:0, food:0, wood:0, iron:0, horse:0, skin:0, money:0, made:0},
		                             {type:15, factory:1000, attack:15, defense:15, speed:10, food:0, wood:0, iron:0, horse:0, skin:0, money:0, made:0},
		                             ];
		
		//资源系数表
		//1 粮食；2 木料；3 矿石；4 马匹；5 皮革；6 钱币；
		public static const resFactorList:Array = [0, 2000, 25, 500, 1, 50, 50000];
		
		public static const mibaoList:Array = [{id:0, ques:"请选择密保问题"}, {id:1, ques:"您的出生地是？"}, {id:2, ques:"你父亲的姓名是？"}, {id:3, ques:"您母亲的姓名是？"}, 
		                               {id:4, ques:"您配偶的姓名是？"}, {id:5, ques:"您最喜欢的老师姓名是？"}, {id:6, ques:"您最好的朋友的姓名是？"}, 
		                               {id:7, ques:"您最熟悉的童年好友姓名是？"}, {id:8, ques:"对您影响最大的人名字是？"}, {id:9, ques:"您最喜欢的球队名字是？"},
		                               {id:10, ques:"您最喜欢的游戏是？"}, {id:11, ques:"您的宠物名字是？"}];
		
		//聊天敏感词替换语句
		public static const chatReplaceList:Array = ["这游戏挺好玩的", "这游戏不错，你懂的", "这游戏值得推荐", "这游戏太给力了", "无与伦比的游戏，堪称巅峰之作", 
		                                             "爱坞堡,爱武将,也爱充值,我不是五毛党,和你一样,我爱玩这游戏", "不坑爹!这游戏就是这么好玩", "神马游戏在这游戏面前都是浮云"];
			
		public function PubUnit()
		{
			
		}
		
		/**
		 * 给对象添加滤镜 
		 * @param obj
		 * @param objColor
		 * 
		 */		
		public static function addGlow(obj:Object, objColor:uint = 0xFFFFFF):void
		{
			var glowFT:GlowFilter = new GlowFilter();
			
			glowFT.color = objColor;
			glowFT.alpha = 1;
			glowFT.strength = 3;
	
			obj.filters = [glowFT];
		}
		
		/**
		 * 清除对象的滤镜 
		 * @param obj
		 * 
		 */		
		public static function clearGlow(obj:Object):void
		{
			if (obj == null) return;
			
			obj.filters = null;
		}
		
		/**
		 * 
		 * @param mc
		 * 
		 */		
		public static function addColor(obj:Object, green:int = 50, red:int = 50, blue:int = 50):void
		{
			var color:ColorTransform = obj.transform.colorTransform;
			color.greenOffset = green;
			color.redOffset = red;
			color.blueOffset = blue;
			obj.transform.colorTransform = color;
		}
		
		/**
		 * 
		 * @param mc
		 * 
		 */		
		public static function clearColor(obj:Object):void
		{
			var color:ColorTransform = obj.transform.colorTransform;
			color.greenOffset = 0;
			color.redOffset = 0;
			color.blueOffset = 0;
			obj.transform.colorTransform = color;
		}
		
		/**
		 * 获取随即数 
		 * @param min
		 * @param max
		 * @return 
		 * 
		 */			
		public static function getRandom(min:Number, max:Number):Number
		{
			var randomNum:Number = 0;
			randomNum = Math.floor(Math.random() * (max - min + 1)) + min;
			
			return randomNum;
		}
		
		/**
		 * 格式化数字 
		 * @param num
		 * @param nAfterDot  小数点位数
		 * @return 
		 * 
		 */		
		public static function formatNumber(num:Number, nAfterDot:int):String
		{
			var srcStr:String;
		  	var resultStr:String;
		  	var dotPos:int;
		  	
		  	srcStr = num.toString();
		  	srcStr = "" + srcStr + "";
		  	
		  	var strLen:uint = srcStr.length;
		  	dotPos = srcStr.indexOf(".", 0);
		  	
		  	if (dotPos == -1)
		  	{
			    resultStr = srcStr + ".";
			    for (var i:uint = 0; i < nAfterDot;i++)
			    {
			    	resultStr = resultStr + "0";
		    	}
		    
		    	return resultStr;
		  	}
		  	else
		  	{
		    	if ((strLen - dotPos - 1) >= nAfterDot)
		    	{
			    	var nAfter:int = dotPos + nAfterDot + 1;
			    	var nTen:int = 1;
			    	
			    	for(var j:uint=0;j<nAfterDot;j++)
			    	{
			      		nTen = nTen*10;
		    		}
		    		
		    		var resultnum:Number = Math.round(num * nTen) / nTen;
		    		resultStr = resultnum.toString();
		    		
		    		return resultStr;
		    	}
		    	else
		    	{
		    		resultStr = srcStr;
		    		for (i = 0; i < (nAfterDot - strLen + dotPos + 1);i++)
		    		{
		      			resultStr = resultStr + "0";
		    		}
		    	
		    		return resultStr;
		    	}
		  	}
		  	
		  	return "";
		}
		
		/**
		 * 在图片的中心按角度旋转
		 * @param target
		 * @param angel
		 * 
		 */		
		public static function rotate(target:UIComponent, angel:int):void
		{
			var m1:Matrix = target.transform.matrix;
			var p:Point = m1.transformPoint(new Point(target.width/2, target.height/2));
			
            m1.translate(-p.x, -p.y);
			m1.rotate(degreesToRadians(angel));
			m1.translate(p.x, p.y);
			
			target.transform.matrix = m1;
		}
			
		private static function degreesToRadians(degrees:Number):Number
		{
        	var radians:Number = degrees * (Math.PI / 180);
            return radians;
        }
         
        private static function radiansToDegrees(radians:Number):Number
        {
        	var degrees:Number = radians * (180 / Math.PI);
            return degrees;
        }
        
		/**
		 * 跳转到首页 
		 * 
		 */		
		public static function gotoIndex():void
		{
			var companyURL:String = GameManager.gameMgr.gotoURL;
			var companyRequest:URLRequest = new URLRequest(companyURL);
			
			navigateToURL(companyRequest, "_self");					
		}
		
		/**
		 * 根据时间戳获取游戏当前日期 
		 * @param hours
		 * @return 
		 * 
		 */		
		public static function getDate(hours:int):Array
		{
			var ret:Array = [];
			var year:int = 0;
			var month:int = 0;
			var day:int = 0;
			var hour:int = 0;
			var left:int = 0; 
			
			var hourOfYear:int = monOfYear * dayOfMon * hourOfDay;
			year = Math.floor(hours / hourOfYear);
			
			left = hours - year * hourOfYear;
			
			var hoursOfMoth:int = hourOfDay * dayOfMon;
			month = Math.floor(left / hoursOfMoth);
			
			left = left - month * hoursOfMoth;
			
			day = Math.floor(left / hourOfDay);
			
			left = left - day * hourOfDay;
			
			hour = left;
			
			ret.push(year + 1);
			ret.push(month + 1);
			ret.push(day + 1);
			ret.push(hour + 1);
			
			return ret;
		}
		
		public static function getDateStr(hours:int):String
		{
			var ret:String = "";
			var ary:Array = getDate(hours);
			
			ret = ary[0] + "年" + ary[1] + "月" + ary[2] + "日" + ary[3] + "时";
			
			return ret;
		}
		
		/**
		 * 根据日期获取时间戳 
		 * @param year
		 * @param month
		 * @param day
		 * @return 
		 * 
		 */		
		public static function getTimeStamp(year:int, month:int, day:int):int
		{
			var ret:int = 0;
			var hourOfYear:int = monOfYear * dayOfMon * hourOfDay;
			var hourOfMonth:int = dayOfMon * hourOfDay;
			
			ret = (year - 1) * hourOfYear + (month - 1) * hourOfMonth + (day - 1) * hourOfDay;
			
			return ret;
		} 
		
		/**
		 * 根据游戏中时间戳获取游戏的时间长度
		 * @param hours
		 * @return 
		 * 
		 */		
		public static function getGameDate(hours:int):String
		{
			return getActGameDate(hours * 20);
		}
		
		/**
		 * 根据显示中时间戳获取时间长度
		 * @param hours
		 * @return 
		 * 
		 */		
		public static function getActGameDate(secTotal:int):String
		{
			if (secTotal <= 0)
				return "00:00";
			
			var hour:int = 0;
			var minutes:int = 0;
			var seconds:int = 0;
			var left:int = 0;
			var ret:String = "";
			
			hour = Math.floor(secTotal / (60 * 60));
			left = secTotal - hour * 60 * 60;
			
			minutes = Math.floor(left / 60);
			left = left - minutes * 60;
			
			seconds = left;
			
			if (hour > 0)
			{
				if (hour < 10)
					ret += "0";
				ret += hour.toString() + ":";
			}
			
			if (minutes > 0)
			{
				if (minutes < 10)
					ret += "0";
				ret += minutes.toString() + ":";
			}
			else
				ret += "00:";
			
			if (seconds > 0)
			{
				if (seconds < 10)
					ret += "0";
				ret += seconds.toString();
			}
			else
				ret += "00";
				
			return ret;
		}
		
		/**
		 * 获取数组中的最小值 
		 * @param ary
		 * @return 
		 * 
		 */		
		public static function getMinNum(ary:Array):int
		{
			if (ary == null || ary.length < 1) return 0;
			
			var i:int = 0;
			var len:int = 0;
			var ret:int = 0;
			
			len = ary.length;
			ret = ary[0];
			for (i = 1; i < len; i++)
			{
				if (ret > ary[i])
					ret = ary[i]; 
			}
			
			return ret;
		}
		
		/**
		 * 获取数组中的最大值 
		 * @param ary
		 * @return 
		 * 
		 */		
		public static function getMaxNum(ary:Array):int
		{
			if (ary == null || ary.length < 1) return 0;
			
			var i:int = 0;
			var len:int = 0;
			var ret:int = 0;
			
			len = ary.length;
			ret = ary[0];
			for (i = 1; i < len; i++)
			{
				if (ret < ary[i])
					ret = ary[i]; 
			}
			
			return ret;
		}
		
		/**
		 * 根据秒数获取实际的时间 
		 * @param seconds
		 * @return 
		 * 
		 */		
		public static function getActDate(seconds:int):String
		{
			var ret:String = "";
			var dt1:Date = new Date();
			
			dt1.setTime(seconds * 1000);
			
			var year:int = dt1.getFullYear();
			var month:int = dt1.getMonth() + 1;
			var day:int = dt1.getDate();
			
			ret = year.toString() + "年" + month.toString() + "月" + day.toString() + "日";  
			
			return ret;
		}
		
		/**
		 * 给组件绘制背景色
		 * @param ui
		 * @param color
		 * @param alpha
		 * 
		 */		
		public static function drawBackground(ui:UIComponent, color:uint = GRAY, alpha:Number = 0.5):void
		{
			ui.graphics.clear();
			ui.graphics.beginFill(color, alpha);
			ui.graphics.drawRect(0, 0, ui.width, ui.height);
			ui.graphics.endFill();
		}
		
		/**
		 * 判断obj是否在数组ary中 
		 * @param obj
		 * @param ary
		 * @return 
		 * 
		 */		
		public static function isObjInArray(obj:Object, ary:Array):Boolean
		{
			var ret:Boolean = false;
			var i:int = 0;
			var len:int = ary.length;
			var objTemp:Object;
			
			for (i = 0; i < len; i++)
			{
				objTemp = ary[i];
				if (objTemp == obj)
					return true;
			}
			
			return ret;
		}
		
		/**
		 * 获取数组ary中最大值 
		 * @param ary
		 * @return 
		 * 
		 */		
		public static function getMax(ary:Array):Object
		{
			var ret:Object;
			var i:int = 0;
			var len:int = ary.length;
			
			ret = ary[i];
			
			for (i = 1; i < len; i++)
			{
				if (ret < ary[i])
					ret = ary[i];
			}
			
			return ret;
		}
		
	    /**
	     * 水平翻转对象 
	     * @param dsp
	     * 
	     */		
	    public static function flipHorizontal(dsp:DisplayObject):void
	    {
		    var matrix:Matrix = dsp.transform.matrix;
		    matrix.a= -1;
		    matrix.tx = dsp.width + dsp.x;
		    dsp.transform.matrix = matrix;
	    }
	    
	    /**
	     * 垂直翻转对象 
	     * @param dsp
	     * 
	     */	    
	    public static function flipVertical(dsp:DisplayObject):void
	    {
	    	var matrix:Matrix = dsp.transform.matrix;
	    	matrix.d = -1;
	    	matrix.ty = dsp.height + dsp.y;
	    	dsp.transform.matrix = matrix;
	    }
	    
		//=================================================================================
		// AI
		//=================================================================================
		
		/**
		 * 获取所需建筑前提 
		 * 如果是议事堂，返回所需声望值
		 * 否则返回 所需建筑类型，所需建筑等级
		 * 
		 * 所需钱
		 * 所需时间
		 * 
		 * @param buildType  升级建筑的当前类型
		 * @param buildLevel 升级建筑的当前等级 
		 * @return
		 * 
		 */		
		public static function getBuildNeed(buildType:int, buildLevel:int):Array
		{
			var ret:Array = [];
			
			var i:int = 0;
			var obj:Object;
			var needBuildType:int = 0;
			var needBuildLevel:int = 0;
			var needMoney:int = 0;
			var needTime:int = 0;
			var needPrestige:int = 0;
			
			for (i = 0; i < buildTree.length; i++)
			{
				obj = buildTree[i];
				if (obj.type == buildType)
					break;
			}
			
			if (buildType == 11)
			{
				needPrestige = int(100 * (buildLevel + 1));
				ret.push(needPrestige);
			}
			else
			{
				needBuildType = obj.needType;
				needBuildLevel = buildLevel + 1;
				ret.push(needBuildType);
				ret.push(needBuildLevel);
			}
			
			needMoney = obj.money * 500 * (buildLevel + 1) * Math.pow(1.6, Math.ceil((buildLevel + 1) / 10));
			needTime = Math.ceil(needMoney / 3200);
			ret.push(needMoney);
			ret.push(needTime);
			
			return ret;
		}
		
		/**
		 * 获取建筑的最高等级 
		 * @param buildType
		 * @return 
		 * 
		 */		
		public static function getBuildMax(buildType:int):int
		{
			var ret:int = 0;
			
			var i:int = 0;
			var obj:Object;
			
			for (i = 0; i < buildTree.length; i++)
			{
				obj = buildTree[i];
				if (obj.type == buildType)
					return obj.max;
			}
			
			return ret;
		}
			
		/**
		 * 获取升级科技所需前提 
		 * 
		 * 返回
		 * 所需建筑类型
		 * 所需建筑等级
		 * 所需钱
		 * 所需时间
		 * 
		 * @param techType  升级科技的当前类型
		 * @param techLevel 升级科技的当前等级
		 * @return 
		 * 
		 */		
		public static function getTechNeed(techType:int, techLevel:int):Array
		{
			var ret:Array = [];
			
			var i:int = 0;
			var obj:Object;
			var needBuildType:int = 0;
			var needBuildLevel:int = 0;
			var needMoney:int = 0;
			var needTime:int = 0;
			
			for (i = 0; i < techTree.length; i++)
			{
				obj = techTree[i];
				if (obj.type == techType)
					break;
			}
			
			var gameWubao:WuBao = GameManager.gameMgr.wubao;
			var school:Build = gameWubao.buildList.getObjByID(Build.SCHOOL) as Build;
			
			needBuildType = 1;
			if (techType <= 9)
				needBuildLevel = techLevel * 10;
			else
				needBuildLevel = techLevel * 5;
			needMoney = 6400 * Math.pow((techLevel + 1),obj.money);
			needTime = Math.ceil(needMoney / 3200 / (Math.log(school.level + 10) * Math.LOG10E));
			
			ret.push(needBuildType);
			ret.push(needBuildLevel);
			ret.push(needMoney);
			ret.push(needTime);
			
			return ret;
		}
		
		/**
		 * 获取科技的最高等级 
		 * @param buildType
		 * @return 
		 * 
		 */		
		public static function getTechMax(techType:int):int
		{
			var ret:int = 0;
			
			var i:int = 0;
			var obj:Object;
			
			for (i = 0; i < techTree.length; i++)
			{
				obj = techTree[i];
				if (obj.type == techType)
					return obj.max;
			}
			
			return ret;
		}
			
		/**
		 * 获取户口上限 
		 * @param roomLevel  民居等级
		 * @return 
		 * 
		 */		
		public static function getFamilyMax(roomLevel:int):int
		{
			var ret:int = 0;
			
			if (roomLevel == 0)
				ret = 50;
			else
				ret = roomLevel * 100;
			
			return ret;
		}
		
		/**
		 * 获取库房的装备种类上限 
		 * @param storeLevel  库房等级
		 * @return 
		 * 
		 */		
		public static function getStoreMax():int
		{
			var storeLevel:int = 0;
			var ret:int = 0;
			var gameWubao:WuBao = GameManager.gameMgr.wubao;
			
			if (gameWubao != null)
			{
				var build:Build = gameWubao.buildList.getObjByID(Build.STORE) as Build;
				if (build != null)
					storeLevel = build.level;
			}
			
			ret = storeLevel + 4;
			
			return ret;
		}
		
		/**
		 * 获取每天恢复伤兵数量 
		 * @param hosLevel  医馆等级
		 * @return 
		 * 
		 */		
		public static function getCureMax(hosLevel:int):int
		{
			var ret:int = 0;
			
			ret = hosLevel * 20 + 500;
			
			return ret;
		}
		
		/**
		 * 获取兵源上限 
		 * @param armylevel  军营等级
		 * 
		 */		
		public static function getSolMax(armylevel:int):int
		{
			var ret:int = 0;
			
			ret = armylevel * 20 + 500;
			
			return ret;
		}
		
		/**
		 * 获取资源产量 
		 * 
		 * @param buildType  资源建筑类型
		 * @param buildLevel 资源建筑等级
		 * @return 
		 * 
		 */		
		public static function getResProduct(buildType:int, buildLevel:int):int
		{
			var ret:Number = 0;
			var tech:Tech = null;
			var techAdd:Number = 0;
			var techType:int = 0;
			var techLevel:int = 0;
			var user:User = null;
			var isVip:Boolean = false;
			
			techType = buildType + 5;
			tech = GameManager.gameMgr.wubao.techList.getObjByID(techType) as Tech;
			if (tech != null)
				techLevel = tech.level;
				
			user = GameManager.gameMgr.user;
			if (user != null)
				isVip = user.isVip;
			
			techAdd = techLevel * 0.05 + 1;
			ret = 0.4 * buildLevel * resFactorList[buildType - 4] * techAdd;
			
			if (buildType == 5)
				ret = ret * 12;
			
			if (isVip)
				ret = ret * 1.2;
			
			return int(ret);
		}
		
		/**
		 * 获取资源的最大上限值 
		 * @param buildType
		 * @param buildLevel
		 * @return 
		 * 
		 */		
		public static function getResMax(buildType:int, buildLevel:int):int
		{
			var resMax:int = 0;
			
			if (buildLevel == 0)
				resMax = resFactorList[buildType - 4] * 0.4 * 60;
			else
				resMax = resFactorList[buildType - 4] * buildLevel * 0.4 * 120;
			
			return resMax;
		}
		
		/**
		 * 根据工坊等级获取可生产的装备 
		 * @param factoryLevel
		 * @return 
		 * 
		 */		
		public static function getCanMadeWeanpon(factoryLevel:int):Array
		{
			var i:int = 0;
			var obj:Object;
			var weapon:Weapon = null;
			var ret:Array = [];
			
			for (i = 0; i < weaponPropList.length; i++)
			{
				obj = weaponPropList[i];
				
				if (obj.factory <= factoryLevel)
				{
					weapon = new Weapon();
					weapon.type = obj.type;
					weapon.level = 1;
					ret.push(weapon);
				}
			}
			
			return ret;
		}
		
		/**
		 * 获取工坊最大工时 
		 * @return 
		 * 
		 */		
		public static function getMaxMade():int
		{
			var gameWubao:WuBao = GameManager.gameMgr.wubao;
			var build:Build = gameWubao.buildList.getObjByID(Build.FACTORY) as Build
			var ret:int = 0;
			
			if (build.level == 0)
				ret = 1000; 
			else
				ret = build.level * 1500;
			
			return ret;
		}
		
		/**
		 * 获取剩余工时 
		 * @return 
		 * 
		 */		
		public static function getLeftMade():int
		{
			var gameWubao:WuBao = GameManager.gameMgr.wubao;
			var max:int = getMaxMade();
			var useMade:int = gameWubao.useMade;
			var ret:int = 0;
			
			ret = max - useMade;
			
			return ret;
		}
		
		/**
		 * 获取生产装备所需的资源 
		 * @param weaponType
		 * @return 
		 * 
		 */		
		public static function getWeaponReq(weaponType:int):Array
		{
			var i:int = 0;
			var obj:Object;
			var ret:Array = [];
			
			for (i = 0; i < weaponPropList.length; i++)
			{
				obj = weaponPropList[i];
				
				if (obj.type == weaponType)
				{
					ret.push(obj.wood);
					ret.push(obj.iron);
					ret.push(obj.horse);
					ret.push(obj.skin);
					ret.push(obj.money);
					ret.push(obj.made);
				}
			}
			
			return ret;
		}
		
		/**
		 * 获取装备的攻防值 
		 * @param weaponType
		 * @param weaponLevel
		 * @return 
		 * 
		 */		
		public static function getWeaponProp(weaponType:int, weaponLevel:int):Array
		{
			var i:int = 0;
			var obj:Object;
			var ret:Array = [];
			var attack:int = 0;
			var defense:int = 0;
			var speed:int = 0;
			
			for (i = 0; i < weaponPropList.length; i++)
			{
				obj = weaponPropList[i];
				
				if (obj.type == weaponType)
				{
					attack = obj.attack * (1 + weaponLevel);
					defense = obj.defense * (1 + weaponLevel);
					speed = obj.speed;
				}
			}
			
			ret.push(attack);
			ret.push(defense);
			ret.push(speed);
			
			return ret;
		}
		
		/**
		 * 获取士兵装备的总攻防 
		 * 
		 * @param w1Type
		 * @param w1Level
		 * @param w2Type
		 * @param w2Level
		 * @param w3Type
		 * @param w3Level
		 * @param w4Type
		 * @param w4Level
		 * @return 
		 * 攻击力
		 * 防御力
		 * 机动力
		 * 
		 */		
		public static function getWeaponTotal(w1Type:int, w1Level:int, w2Type:int, w2Level:int, w3Type:int, w3Level:int, w4Type:int, w4Level:int, horsePer:int):Array
		{
			var ret:Array = [];
			var ar:Array = [];
			var attack:int = 5;
			var defense:int = 5;
			var speed:Number = 10;
			
			ar = getWeaponProp(w1Type, w1Level);
			attack += ar[0];
			defense += ar[1];
			speed += ar[2];
			
			ar = getWeaponProp(w2Type, w2Level);
			attack += ar[0];
			defense += ar[1];
			speed += ar[2];
			
			ar = getWeaponProp(w3Type, w3Level);
			attack += ar[0];
			defense += ar[1];
			speed += ar[2];
			
			ar = getWeaponProp(w4Type, w4Level);
			attack += ar[0];
			defense += ar[1];
			speed += ar[2];
			
			//武将的坐骑加成
			if (horsePer > 0)
				speed = speed * (1 + horsePer / 100);
				
			ret.push(attack);
			ret.push(defense);
			ret.push(speed);
			
			return ret;
		}
		
		/**
		 * 获取武将所带兵的部曲类型
		 * @param generalID
		 * @return 
		 * 
		 */		
		public static function getSoliderType(gameGeneral:General):int
		{
			var ret:int = 0;
			
			if (gameGeneral != null)
			{
				//弩车
				if (gameGeneral.w4Type == Weapon.NUCHE)
				{
					ret = General.NUCHE;
					return ret;
				}
				
				//甲车
				if (gameGeneral.w4Type == Weapon.JIACHE)
				{
					ret = General.JIACHE;
					return ret;
				}
				
				//有战马
				if (gameGeneral.w4Type == Weapon.MA || gameGeneral.w4Type == Weapon.WUSUN)
				{
					//骑射系
					if (gameGeneral.w1Type == Weapon.NU || gameGeneral.w1Type == Weapon.SHENBI)
						ret = General.GONGQI;
					//骑兵系
					else
						ret = General.QI;
				}
				else
				{
					//弩兵系
					if (gameGeneral.w1Type == Weapon.NU || gameGeneral.w1Type == Weapon.SHENBI)
						ret = General.NU;
					//步兵系
					else
						ret = General.BU;
				}
				
			}
			
			return ret;
		}
		
		/**
		 * 获取武将所带兵的部曲名称以及动画名称
		 * @param generalID
		 * @return 
		 * 
		 */		
		public static function getSoliderName(gameGeneral:General):Array
		{
			var ret:Array = [];
			var soliderName:String = "";
			var swfName:String = "";
			var wList:Array = ["步卒","剑","戟","弩","盾","轻甲","重甲","甲车","弩车","骑","刀","枪","弩","盾","鳞甲","骑"]
			
			if (gameGeneral != null && gameGeneral.soliderTotal > 0)
			{
				swfName = gameGeneral.w1Type.toString() + gameGeneral.w2Type.toString() + gameGeneral.w3Type.toString() + gameGeneral.w4Type.toString();
				
				if (gameGeneral.w4Type == Weapon.NUCHE)
				{
					soliderName = wList[gameGeneral.w4Type];
					ret.push(soliderName);
					ret.push(swfName);
					return ret;
				}
				
				if (gameGeneral.w4Type == Weapon.JIACHE)
				{
					soliderName = wList[gameGeneral.w4Type];
					ret.push(soliderName);
					ret.push(swfName);
					return ret;
				}
				
				if (gameGeneral.w1Type == 0 && gameGeneral.w2Type == 0 && gameGeneral.w3Type == 0 && gameGeneral.w4Type == 0)
				{
					soliderName = wList[0];
					ret.push(soliderName);
					ret.push(swfName);
					return ret;
				}
				
				if (gameGeneral.w3Type == Weapon.PI || gameGeneral.w3Type == Weapon.TIE || gameGeneral.w3Type == Weapon.YULIN)
					soliderName += wList[gameGeneral.w3Type];
				
				if (gameGeneral.w1Type == Weapon.JIAN || gameGeneral.w1Type == Weapon.JI || gameGeneral.w1Type == Weapon.NU ||
				    gameGeneral.w1Type == Weapon.DAO || gameGeneral.w1Type == Weapon.QIANG || gameGeneral.w1Type == Weapon.SHENBI )
					soliderName += wList[gameGeneral.w1Type];
				
				if (gameGeneral.w2Type == Weapon.DUN || gameGeneral.w2Type == Weapon.HUWEN)
					soliderName += wList[gameGeneral.w2Type];
				
				if (gameGeneral.w4Type == Weapon.MA || gameGeneral.w4Type == Weapon.WUSUN)
				{
					soliderName += wList[gameGeneral.w4Type];
				}
				
				if (gameGeneral.w4Type == 0)
				{
					soliderName += "";
				}
				
				soliderName += "兵";
				
				ret.push(soliderName);
				ret.push(swfName);	
			}
			
			return ret;
		}
		
		/**
		 * 获取武将的攻击，防御，速度加成值 
		 * soliderID == 0 根据武将的装备判断兵种类型
		 * soliderID != 0 指定兵种类型(修炼时的兵种选择)
		 * 
		 * @param generalID
		 * @param zhenID
		 * @param soliderID
		 * @return 
		 * 
		 */		
		public static function getGeneralAdd(generalID:int, zhenID:int, soliderID:int = 0):Array
		{
			var ret:Array = [];
			var gameGeneral:General = GameManager.gameMgr.generalList.getObjByID(generalID) as General;
			
			var attackAdd:Number = 1;
			var defenseAdd:Number = 1;
			var speedAdd:Number = 1;
			
			var obj:Object;
			var gameZhen:Zhen = null;
			
			if (gameGeneral != null)
				attackAdd = gameGeneral.getAdd(soliderID);
			
			if (gameGeneral != null && zhenID > 0)
			{
				gameZhen = GameManager.gameMgr.zhenList.getObjByID(zhenID) as Zhen;
				obj = zhenList[gameZhen.uniqID - 1];
				attackAdd = attackAdd * (obj.attack + 4) / 4;
				defenseAdd = defenseAdd * (obj.defense + 4) / 4;
				speedAdd = speedAdd * (obj.speed + 4) / 4;
			}
			
			ret.push(attackAdd / 10);
			ret.push(defenseAdd / 10);
			ret.push(speedAdd);
			
			return ret;
		}
		
		/**
		 * 获取武将的攻击，防御，机动信息 
		 * @param gameGeneral
		 * @return 
		 * 
		 */		
		public static function getGeneralInfo(gameGeneral:General):Array
		{
			var ret:Array = [];
			var horsePer:int = 0;
			
			if (gameGeneral != null)
			{
				var horseID:int = gameGeneral.horseID;
				var treasure:UserTreasure = GameManager.gameMgr.userTsList.getObjByID(horseID) as UserTreasure;
				if (treasure != null)
					horsePer = treasure.treasure.propNum;
			}
			
			var ary:Array = getWeaponTotal(gameGeneral.w1Type, gameGeneral.w1Level, gameGeneral.w2Type, gameGeneral.w2Level, gameGeneral.w3Type, 
			                                       gameGeneral.w3Level, gameGeneral.w4Type, gameGeneral.w4Level, horsePer);
			var ary1:Array = getGeneralAdd(gameGeneral.uniqID, gameGeneral.useZhen) 
			
			//武将属性加成
			var attackAdd:Number = Math.log((gameGeneral.kongfuCur - 30) / 20) * Math.LOG10E + 1;
			var defenseAdd:Number = Math.log((gameGeneral.intelligenceCur - 30) / 20) * Math.LOG10E + 1;
			var speedAdd:Number = Math.log((gameGeneral.polityCur - 30) / 20) * Math.LOG10E + 1;
			
			var attack:String = formatNumber(ary[0] * ary1[0] * (gameGeneral.soliderTrain + 5) / 10 * attackAdd, 1);
			var defense:String = formatNumber(ary[1] * ary1[1] * (gameGeneral.soliderTrain + 5) / 10 * defenseAdd, 1);
			var speed:String = formatNumber(ary[2] * ary1[2] * speedAdd, 1);
			
			ret.push(attack);
			ret.push(defense);
			ret.push(speed);
			
			return ret;
		}
		
		/**
		 * 获取出征消耗的钱粮 
		 * @param days
		 * @param solNum
		 * @return 
		 * 
		 */		
		public static function getArmyCost(days:int, solNum:int):Array
		{
			var ret:Array = [];
			
			ret.push(Math.ceil(solNum * days / 4  * 10));
			ret.push(Math.ceil(solNum * days / 4 * 0.1));
			
			return ret;
		}
		
		/**
		 * 获取修炼时的战斗参数 
		 * @param soliderID
		 * @param zhenID
		 * @return 
		 * 
		 */		
		public static function getWarFactor(soliderID:int, zhenID:int):Array
		{
			var ret:Array = [];
			var speed:int = 0;
			var distance:int = 0;
			var obj:Object;
			var zhenSpeed:int = 0;
			
			for each(obj in soliderList)
			{
				if (obj.id == soliderID)
				{
					speed = obj.speed;
					distance = obj.distance;
					
					break;
				}
			}
			
			for each(obj in zhenList)
			{
				if (obj.id == zhenID)
				{
					zhenSpeed = obj.speed;
					
					break;
				}
			}
			
			var action:int = 0;
			action = speed * 2 * (4 + zhenSpeed);
			
			ret.push(action);
			ret.push(distance);
			
			return ret;
		}
		
		/**
		 * 获取加速需要花费的金币 
		 * @param hours
		 * @return 
		 * 
		 */		
		public static function getAcceCoin(hours:Number):int
		{
			var ret:int = 0;
			
			ret = Math.ceil(hours / 12);
			
			return ret;
		}
		
		/**
		 * 获取CD加速花费的金币 
		 * @param hours
		 * @return 
		 * 
		 */		
		public static function getAcceCDCoin(hours:Number):int
		{
			var ret:int = 0;
			
			ret = Math.ceil(hours / 3);
			
			return ret;
		}
		
		/**
		 * 获取购买库房空间花费的金币 
		 * @return 
		 * 
		 */		
		public static function getStoreCoin():int
		{
			var gameWubao:WuBao = GameManager.gameMgr.wubao;
			var build:Build = gameWubao.buildList.getObjByID(Build.STORE) as Build
			var ret:int = 0;
			
			ret = 5 + build.level * 5;
			
			return ret;
		}
		
		/**
		 * 获取到达城池所需的时间 
		 * @param gameGeneral
		 * @param toCityID
		 * @param type  0--派遣  1--掠夺
		 * @return 
		 * 
		 */		
		public static function getTranTime(gameGeneral:General, toCityID:int, type:int = 0):int
		{
			if (gameGeneral == null || toCityID <= 0) return tranTime;
			
			var tranTime:int = 0;
			var fromCity:City = null;
			var toCity:City = null;
			var fromX:int = 0;
			var fromY:int = 0;
			var toX:int = 0;
			var toY:int = 0;
			
			toCity = GameManager.gameMgr.cityList.getObjByID(toCityID) as City;
			if (toCity == null) return tranTime;
			
			if (gameGeneral.place == 1)
			{
				fromCity = GameManager.gameMgr.cityList.getObjByID(GameManager.gameMgr.wubao.cityID) as City;
				if (fromCity == null)
					return tranTime;
			}
			else if (gameGeneral.place == 2)
			{
				fromCity = GameManager.gameMgr.cityList.getObjByID(gameGeneral.placeID) as City;
				if (fromCity == null)
					return tranTime;
			}
			
			fromX = fromCity.mapX;
			fromY = fromCity.mapY;
			toX = toCity.mapX;
			toY = toCity.mapY;
			
			var speed:Number = 0;
			if (type == 0)
				speed = 15;
			else if (type == 1)
				speed = 2;
			
			tranTime = Math.ceil((Math.abs(fromX - toX) + Math.abs(fromY - toY)) / speed);
			if (tranTime == 0)
				tranTime = 1;
			
			return tranTime;
		}
		
		/**
		 * 资源转换钱币(资源卖给系统) 
		 * @param type
		 * @return 返回单个资源钱币数量 
		 * 
		 */		
		public static function resToMoney(type:int):Number
		{
			return resFactorList[6] / resFactorList[type] / 2;
		}
		
		/**
		 * 钱币转换资源（向系统购买资源）
		 * @param type
		 * @return 返回单个资源钱币数量
		 * 
		 */		
		public static function moneyToRes(type:int):int
		{
			return resFactorList[6] / resFactorList[type];
		}
		
		/**
		 * 物资转换钱币（回收物资） 
		 * @param type
		 * @param level
		 * @return 单个物资的钱币数量
		 * 
		 */		
		public static function weaponToMoney(type:int, level:int):int
		{
			var obj:Object = weaponPropList[type - 1];
			var money:int = 0;
			
			money += obj.food * resToMoney(1);
			money += obj.wood * resToMoney(2);
			money += obj.iron * resToMoney(3);
			money += obj.horse * resToMoney(4);
			money += obj.skin * resToMoney(5);
			money += obj.money;
			
			money = money * Math.pow(2, level);
			
			return money;
		}
		
		/**
		 * 势力领取俸禄
		 * 公式：所有城池的等级累加 * 官位俸禄（500） * 资源系数 * 0.02 * 爵位等级
		 * @return 
		 * 
		 */		
		public static function getSalary():Array
		{
			var gameUser:User = GameManager.gameMgr.user;
			var gameWubao:WuBao = GameManager.gameMgr.wubao;
			var gameSphere:Sphere = null;
			var gameOff:Official = null;
			var ret:Array = [];
			var cityAdd:int = 0;
			var salary:int = 0;
			var i:int = 0;
			var len:int = 0;
			
			if (gameUser.sphereID > 0)
			{
				gameSphere = GameManager.gameMgr.sphereList.getObjByID(gameUser.sphereID) as Sphere;
				if (gameSphere != null)
				{
					len = gameSphere.cityNum;
					
					for (i = 0; i < len; i++)
					{
						var gameCity:City = gameSphere.cityList.getObjByIndex(i) as City;
						if (gameCity != null)
							cityAdd += gameCity.level;
					} 
				}	
			}
			
			gameOff = GameManager.gameMgr.offList.getObjByID(gameUser.offID) as Official;
			if (gameOff != null)
				salary = gameOff.salary;
			
			for (i = 1; i <= 6; i++)
			{
				ret.push(int(cityAdd * salary * resFactorList[i] * 0.02 * gameWubao.digID)); 
			}			
			
			return ret;
		}
		
		/**
		 * 训练增加武将的经验值 
		 * @return 
		 * 
		 */		
		public static function getTrainExp():int
		{
			var ret:int = 0;
			var gameWubao:WuBao = GameManager.gameMgr.wubao; 
			var build:Build = gameWubao.buildList.getObjByID(Build.CAMP) as Build;
			
			ret = 500 + build.level * 100;
			
			return ret;
		}
		
		/**
		 * 获取武将升级所需经验值
		 * @param level  武将当前等级
		 * @return 
		 * 
		 */		
		public static function getExpExchange(level:int):int
		{
			var ret:int = 0;
			ret = 500 * (level + 1) * Math.pow(1.2, int((level + 1) / 10));
			
			return ret;
		}
		
		
		
		
		
		
		
		
		
		
		
		
		
	}
}