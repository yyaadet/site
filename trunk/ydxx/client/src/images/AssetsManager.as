package images
{
	/**
	 * assets管理器,用来存储程序中用到的图片资源 
	 * @author StarX
	 * 
	 */	
	public class AssetsManager
	{
		//定义静态assets管理器，用来实现assets管理器的单例模式
		private static var _assetsMgr:AssetsManager = null;
		
		public function AssetsManager()
		{
			if(_assetsMgr != null)
				throw new Error("不能多次创建AssetsManager的实例!");
		}
		
		/**
		 * 管理器初始化 
		 * 
		 */		
		public static function init():void
		{
			if (_assetsMgr == null)
				_assetsMgr = new AssetsManager();
		}
		
		/**
		 * 获取assets管理器单例 
		 * @return 
		 * 
		 */		
		public static function get assetsMgr():AssetsManager
		{
			return _assetsMgr;
		}
		
		//=============================================================
		//游戏鼠标图标
		//=============================================================
		
		[Embed(source="assets/cursor/attack.swf")]
	    public const CUR_ATTACK:Class;
		
		[Embed(source="assets/cursor/enterCity.swf")]
	    public const CUR_ENTER_CITY:Class;
		
		[Embed(source="assets/cursor/drag.png")]
	    public const CUR_DRAG:Class;
		
		//=============================================================
		//游戏主界面图片
		//=============================================================
		
		[Embed(source="assets/main/area.png")]
	    public const MAIN_AREA:Class;
		
		[Embed(source="assets/main/area_d.png")]
	    public const MAIN_AREA_D:Class;
		
		[Embed(source="assets/main/world.png")]
	    public const MAIN_WORLD:Class;
		
		[Embed(source="assets/main/world_d.png")]
	    public const MAIN_WORLD_D:Class;
		
		[Embed(source="assets/main/ld.png")]
	    public const MAIN_LD:Class;
		
		[Embed(source="assets/main/ld_d.png")]
	    public const MAIN_LD_D:Class;
		
		[Embed(source="assets/main/xf.png")]
	    public const MAIN_XF:Class;
		
		[Embed(source="assets/main/xf_d.png")]
	    public const MAIN_XF_D:Class;
		
		[Embed(source="assets/main/guid.swf")]
	    public const MAIN_GUID:Class;
		
		[Embed(source="assets/main/guid.png")]
	    public const MAIN_GUID_FACE:Class;
		
		[Embed(source="assets/main/lock.png")]
	    public const MAIN_LOCK:Class;
		
		[Embed(source="assets/main/lock1.png")]
	    public const MAIN_LOCK1:Class;
		
		[Embed(source="assets/main/attack.png")]
	    public const MAIN_ATTACK:Class;
		
		//=============================================================
		//战斗场景图片
		//=============================================================
		
		[Embed(source="assets/fight/flag1.png")]
	    public const FIGHT_FLAG1:Class;
		
		[Embed(source="assets/fight/flag2.png")]
	    public const FIGHT_FLAG2:Class;
		
		[Embed(source="assets/fight/ws.png")]
	    public const FIGHT_WUSHUANG:Class;
		
		[Embed(source="assets/fight/gw.png")]
	    public const FIGHT_GUWU:Class;
		
		[Embed(source="assets/fight/mz.png")]
	    public const FIGHT_MAZHEN:Class;
		
		[Embed(source="assets/fight/pz.png")]
	    public const FIGHT_POZHEN:Class;
		
		[Embed(source="assets/fight/hl.png")]
	    public const FIGHT_HUNLUAN:Class;
		
		[Embed(source="assets/fight/js.png")]
	    public const FIGHT_JIANSHOU:Class;
		
		[Embed(source="assets/fight/qx.png")]
	    public const FIGHT_QIXI:Class;
		
		[Embed(source="assets/fight/sl.png")]
	    public const FIGHT_SL:Class;
		
		[Embed(source="assets/fight/bb.png")]
	    public const FIGHT_BB:Class;
		
		[Embed(source="assets/fight/bg.png")]
	    public const FIGHT_BG:Class;
		
		[Embed(source="assets/fight/gate1.png")]
	    public const FIGHT_GATE1:Class;
		
		[Embed(source="assets/fight/gate2.png")]
	    public const FIGHT_GATE2:Class;
		
		[Embed(source="assets/fight/gate1_j.png")]
	    public const FIGHT_GATE1_J:Class;
		
		[Embed(source="assets/fight/gate2_j.png")]
	    public const FIGHT_GATE2_J:Class;
		
		[Embed(source="assets/fight/bomb.swf")]
	    public const FIGHT_BOMB:Class;
		
		//=============================================================
		//游戏窗口图片
		//=============================================================
		
		[Embed(source="assets/win/left.png")]
	    public const WIN_LEFT:Class;
	    
		[Embed(source="assets/win/left_top.png")]
	    public const WIN_LEFT_TOP:Class;
	    
		[Embed(source="assets/win/left_bottom.png")]
	    public const WIN_LEFT_BOTTOM:Class;
	    
		[Embed(source="assets/win/right.png")]
	    public const WIN_RIGHT:Class;
	    
		[Embed(source="assets/win/right_top.png")]
	    public const WIN_RIGHT_TOP:Class;
	    
		[Embed(source="assets/win/right_bottom.png")]
	    public const WIN_RIGHT_BOTTOM:Class;
	    
		[Embed(source="assets/win/top.png")]
	    public const WIN_TOP:Class;
	    
		[Embed(source="assets/win/bottom.png")]
	    public const WIN_BOTTOM:Class;
	    
		//=============================================================
		//坞堡场景图片
		//=============================================================
		
		[Embed(source="assets/wubao/farm.png")]
	    public const WUBAO_FARM:Class;
		
		[Embed(source="assets/wubao/ranch.png")]
	    public const WUBAO_RANCH:Class;
		
		[Embed(source="assets/wubao/mine.png")]
	    public const WUBAO_MINE:Class;
		
		[Embed(source="assets/wubao/wood.png")]
	    public const WUBAO_WOOD:Class;
		
		[Embed(source="assets/wubao/market.png")]
	    public const WUBAO_MARKET:Class;
		
		[Embed(source="assets/wubao/skin.png")]
	    public const WUBAO_SKIN:Class;
		
		[Embed(source="assets/wubao/yst.png")]
	    public const WUBAO_YST:Class;
		
		[Embed(source="assets/wubao/room.png")]
	    public const WUBAO_ROOM:Class;
		
		[Embed(source="assets/wubao/school.png")]
	    public const WUBAO_SCHOOL:Class;
		
		[Embed(source="assets/wubao/inn.png")]
	    public const WUBAO_INN:Class;
		
		[Embed(source="assets/wubao/factory.png")]
	    public const WUBAO_FACTORY:Class;
		
		[Embed(source="assets/wubao/store.png")]
	    public const WUBAO_STORE:Class;
		
		[Embed(source="assets/wubao/camp.png")]
	    public const WUBAO_CAMP:Class;
		
		[Embed(source="assets/wubao/hospital.png")]
	    public const WUBAO_HOSPITAL:Class;
		
		[Embed(source="assets/wubao/chui.swf")]
	    public const WUBAO_CHUI:Class;

		//=============================================================
		//游戏地图图片
		//=============================================================
		
		[Embed(source="assets/map/bg.png")]
	    public const MAP_BG:Class;
		
		[Embed(source="assets/map/dou.png")]
	    public const MAP_DOU:Class;
	    
		[Embed(source="assets/map/zhou.png")]
	    public const MAP_ZHOU:Class;
	    
		[Embed(source="assets/map/jun.png")]
	    public const MAP_JUN:Class;
	    
		[Embed(source="assets/map/spring.png")]
	    public const MAP_SPRING:Class;
	    
		[Embed(source="assets/map/summer.png")]
	    public const MAP_SUMMER:Class;
	    
		[Embed(source="assets/map/autumn.png")]
	    public const MAP_AUTUMN:Class;
	    
		[Embed(source="assets/map/winter.png")]
	    public const MAP_WINTER:Class;
	    
		[Embed(source="assets/map/flag.png")]
	    public const MAP_FLAG:Class;
	    
		[Embed(source="assets/map/gong.png")]
	    public const MAP_GONG:Class;
	    
		[Embed(source="assets/map/shou.png")]
	    public const MAP_SHOU:Class;
	    
		//=============================================================
		//游戏装备图标
		//=============================================================
	    
		[Embed(source="assets/weapon/default.png")]
	    public const WPN_DEFAULT:Class;
	    
		[Embed(source="assets/weapon/default_l.png")]
	    public const WPN_DEFAULT_L:Class;
	    
		[Embed(source="assets/weapon/sword.png")]
	    public const WPN_SWORD:Class;
	    
		[Embed(source="assets/weapon/halberd.png")]
	    public const WPN_HALBERD:Class;
	    
		[Embed(source="assets/weapon/hnaid.png")]
	    public const WPN_HNAID:Class;
	    
		[Embed(source="assets/weapon/shield.png")]
	    public const WPN_SHIELD:Class;
	    
		[Embed(source="assets/weapon/leather.png")]
	    public const WPN_LEATHER:Class;
	    
		[Embed(source="assets/weapon/armour.png")]
	    public const WPN_ARMOUR:Class;
	    
		[Embed(source="assets/weapon/blowing.png")]
	    public const WPN_BLOWING:Class;
	    
		[Embed(source="assets/weapon/ship.png")]
	    public const WPN_SHIP:Class;
	    
		[Embed(source="assets/weapon/horse.png")]
	    public const WPN_HORSE:Class;
	    
		[Embed(source="assets/weapon/dao.png")]
	    public const WPN_DAO:Class;
	    
		[Embed(source="assets/weapon/qiang.png")]
	    public const WPN_QIANG:Class;
	    
		[Embed(source="assets/weapon/shenbi.png")]
	    public const WPN_SHENBI:Class;
	    
		[Embed(source="assets/weapon/huwen.png")]
	    public const WPN_HUWEN:Class;
	    
		[Embed(source="assets/weapon/yulin.png")]
	    public const WPN_YULIN:Class;
	    
		[Embed(source="assets/weapon/wusun.png")]
	    public const WPN_WUSUN:Class;
	    
		[Embed(source="assets/weapon/default_s.png")]
	    public const WPN_DEFAULT_S:Class;
	    
		[Embed(source="assets/weapon/sword_s.png")]
	    public const WPN_SWORD_S:Class;
	    
		[Embed(source="assets/weapon/halberd_s.png")]
	    public const WPN_HALBERD_S:Class;
	    
		[Embed(source="assets/weapon/hnaid_s.png")]
	    public const WPN_HNAID_S:Class;
	    
		[Embed(source="assets/weapon/shield_s.png")]
	    public const WPN_SHIELD_S:Class;
	    
		[Embed(source="assets/weapon/leather_s.png")]
	    public const WPN_LEATHER_S:Class;
	    
		[Embed(source="assets/weapon/armour_s.png")]
	    public const WPN_ARMOUR_S:Class;
	    
		[Embed(source="assets/weapon/blowing_s.png")]
	    public const WPN_BLOWING_S:Class;
	    
		[Embed(source="assets/weapon/ship_s.png")]
	    public const WPN_SHIP_S:Class;
	    
		[Embed(source="assets/weapon/horse_s.png")]
	    public const WPN_HORSE_S:Class;
	    
		[Embed(source="assets/weapon/dao_s.png")]
	    public const WPN_DAO_S:Class;
	    
		[Embed(source="assets/weapon/qiang_s.png")]
	    public const WPN_QIANG_S:Class;
	    
		[Embed(source="assets/weapon/shenbi_s.png")]
	    public const WPN_SHENBI_S:Class;
	    
		[Embed(source="assets/weapon/huwen_s.png")]
	    public const WPN_HUWEN_S:Class;
	    
		[Embed(source="assets/weapon/yulin_s.png")]
	    public const WPN_YULIN_S:Class;
	    
		[Embed(source="assets/weapon/wusun_s.png")]
	    public const WPN_WUSUN_S:Class;	    
	    
		//=============================================================
		//游戏资源图标
		//=============================================================
	    
		[Embed(source="assets/res/money.png")]
	    public const RES_MONEY:Class;
	    
		[Embed(source="assets/res/food.png")]
	    public const RES_FOOD:Class;
	    
		[Embed(source="assets/res/wood.png")]
	    public const RES_WOOD:Class;
	    
		[Embed(source="assets/res/iron.png")]
	    public const RES_IRON:Class;
	    
		[Embed(source="assets/res/skin.png")]
	    public const RES_SKIN:Class;
	    
		[Embed(source="assets/res/horse.png")]
	    public const RES_HORSE:Class;
	    
		//=============================================================
		//游戏书院科技图标
		//=============================================================
	    
		[Embed(source="assets/wubao/school/zhujian.swf")]
	    public const TECH_ZHUJIAN:Class;
	    
		[Embed(source="assets/wubao/school/zhiji.swf")]
	    public const TECH_ZHIJI:Class;
	    
		[Embed(source="assets/wubao/school/jikuo.swf")]
	    public const TECH_JIKUO:Class;
	    
		[Embed(source="assets/wubao/school/zhidun.swf")]
	    public const TECH_ZHIDUN:Class;
	    
		[Embed(source="assets/wubao/school/roupi.swf")]
	    public const TECH_ROUPI:Class;
	    
		[Embed(source="assets/wubao/school/jiaozhu.swf")]
	    public const TECH_JIAOZHU:Class;
	    
		[Embed(source="assets/wubao/school/mugong.swf")]
	    public const TECH_MUGONG:Class;
	    
		[Embed(source="assets/wubao/school/jixie.swf")]
	    public const TECH_JIXIE:Class;
	    
		[Embed(source="assets/wubao/school/xunma.swf")]
	    public const TECH_XUNMA:Class;
	    
		[Embed(source="assets/wubao/school/zhongzhi.swf")]
	    public const TECH_ZHONGZHI:Class;
	    
		[Embed(source="assets/wubao/school/famu.swf")]
	    public const TECH_FAMU:Class;
	    
		[Embed(source="assets/wubao/school/caikuang.swf")]
	    public const TECH_CAIKUANG:Class;
	    
		[Embed(source="assets/wubao/school/fangmu.swf")]
	    public const TECH_FANGMU:Class;
	    
		[Embed(source="assets/wubao/school/zhige.swf")]
	    public const TECH_ZHIGE:Class;
	    
		[Embed(source="assets/wubao/school/maoyi.swf")]
	    public const TECH_MAOYI:Class;
	    
	}
}