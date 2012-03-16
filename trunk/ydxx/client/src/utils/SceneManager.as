package utils
{
	import battle.ui.SceneBattle;
	import battle.ui.SceneFight;
	
	import city.ui.SceneArea;
	import city.ui.SceneAttackCity;
	
	import flash.utils.setTimeout;
	
	import map.MapManager;
	import map.ui.SceneMap;
	
	import net.tcp.model.fight.TcpFightNtf;
	
	import wubao.ui.SceneWubao;
	
	/**
	 * 场景管理器，用来管理游戏场景的显示 
	 * @author bxl
	 * 
	 */	
	public class SceneManager
	{
		//定义静态场景管理器，用来实现场景管理器的单例模式
		private static var _sceneMgr:SceneManager = null;
		
		public static const SCENE_WUBAO:int = 1;
		
		public static const SCENE_MAP:int = SCENE_WUBAO + 1;
		
		public static const SCENE_FIGHT:int = SCENE_MAP + 1;
		
		public static const SCENE_AREA:int = SCENE_FIGHT + 1;
		
		public static const SCENE_BATTLE:int = SCENE_AREA + 1;
		
		public static const SCENE_ATTACK_CITY:int = SCENE_BATTLE + 1;
		
		//坞堡场景
		private var _sceneWubao:SceneWubao = null;
		
		//地图场景
		private var _sceneMap:SceneMap = null;
		
		//打擂场景
		private var _sceneFight:SceneFight = null;
		
		//地区场景
		private var _sceneArea:SceneArea = null;
		
		//攻打城池场景
		private var _sceneAttackCity:SceneAttackCity = null;
		
		//战役场景
		private var _sceneBattle:SceneBattle = null;
		
		//当前进入的场景
		private var _curScene:int = 0;
		
		public function SceneManager()
		{
			if (_sceneMgr != null)
				throw new Error("不能多次创建scenesMangager的实例!");
		}

		/**
		 * 管理器初始化 
		 * 
		 */		
		public static function init():void
		{
			if (_sceneMgr == null)
				_sceneMgr = new SceneManager();
		}
		
		/**
		 * 获取场景管理器单例 
		 * @return 
		 * 
		 */		
		public static function get sceneMgr():SceneManager
		{
			return _sceneMgr;
		}
		
		/**
		 * 隐藏所有的场景 
		 * 
		 */		
		private function hideAllScene():void
		{
			sceneMap.visible = false;
			sceneMap.includeInLayout = false;
			sceneWubao.visible = false;
			sceneWubao.includeInLayout = false;
			sceneFight.visible = false;
			sceneFight.includeInLayout = false;
			sceneArea.visible = false;
			sceneArea.includeInLayout = false;
			sceneBattle.visible = false;
			sceneBattle.includeInLayout = false;
			sceneAttackCity.visible = false;
			sceneAttackCity.includeInLayout = false;
			
			WinManager.winMgr.hideAllWin();
		}
		
		/**
		 * 进入坞堡场景 
		 * 
		 */		
		public function enterWubao():void
		{
			if (curScene == SCENE_WUBAO) return;
			
			hideAllScene();
			sceneWubao.visible = true;
			sceneWubao.includeInLayout = true;
			curScene = SCENE_WUBAO;
			GameManager.gameMgr.gameApp.panelTip.refresh();
			GameManager.gameMgr.showTitle(true, true, true, true, false, true);
		}
		
		//是否第一次进入地图场景
		private var firstInMap:Boolean = true;
		
		/**
		 * 进入背景大地图场景 
		 * @param isPosCity  true--定位坞堡所在的城池  false--根据传入的参数定位地图
		 * @param mapX
		 * @param mapY
		 * 
		 */		
		public function enterMap(isPosCity:Boolean, mapX:int = 0, mapY:int = 0):void
		{
			hideAllScene();
			sceneMap.smallMap.visible = false;
			sceneMap.smallMap.includeInLayout = false;
			sceneMap.visible = true;
			sceneMap.includeInLayout = true;
			
			if (firstInMap)
			{
				WinManager.winMgr.showLoadingIntf("正在为第一次进入地图初始化数据,请稍候...");
				setTimeout(refreshMap, 200, isPosCity, mapX, mapY);
			}
			else
			{
				if (isPosCity)
					MapManager.mapMgr.posSelfCity();
				else
					MapManager.mapMgr.posMap(mapX, mapY);
				MapManager.mapMgr.hideCityMenu();
				
				sceneMap.createArmy();
				
				curScene = SCENE_MAP;
				sceneMap.smallMap.x = sceneMap.width - sceneMap.smallMap.width;
				sceneMap.smallMap.y = 0;
				sceneMap.smallMap.visible = true;
				sceneMap.smallMap.includeInLayout = true;
				GameManager.gameMgr.showTitle(true, true, false, true, false, true);
			}
		}
		
		private function refreshMap(isPosCity:Boolean, mapX:int, mapY:int):void
		{
			if (firstInMap)
			{
				sceneMap.width = GameManager.gameMgr.gameWidth;
				sceneMap.height = GameManager.gameMgr.gameHeight;
				sceneMap.initMap();
				firstInMap = false;
				WinManager.winMgr.winLoading.visible = false;
				WinManager.winMgr.winLoading.includeInLayout = false;
			}
			
			if (isPosCity)
				MapManager.mapMgr.posSelfCity();
			else
				MapManager.mapMgr.posMap(mapX, mapY);
			MapManager.mapMgr.hideCityMenu();
			
			sceneMap.createArmy();
			
			curScene = SCENE_MAP;
			sceneMap.smallMap.x = sceneMap.width - sceneMap.smallMap.width;
			sceneMap.smallMap.y = 0;
			sceneMap.smallMap.visible = true;
			sceneMap.smallMap.includeInLayout = true;
			GameManager.gameMgr.showTitle(true, true, false, true, false, true);
		}
		
		/**
		 * 进入战斗场景 
		 * @param xiuEnter
		 * 
		 */		
		public function enterFight(tcpFight:TcpFightNtf):void
		{
			sceneFight.width = GameManager.gameMgr.gameWidth;
			sceneFight.height = GameManager.gameMgr.gameHeight;
			
			WinManager.winMgr.hideAllWin();
			sceneFight.visible = true;
			sceneFight.includeInLayout = true;
			
			if (!sceneFight.isInit)
				sceneFight.init();
			
			sceneFight.fight = tcpFight;	
			sceneFight.showFight();
		}
		
		/**
		 * 进入地区场景 
		 * @param cityID
		 * 
		 */	
		private var isInitArea:Boolean = false;
			
		public function enterArea(cityID:int):void
		{
			if (!isInitArea)
			{
				sceneArea.initUI();
				isInitArea = true;
			}
			
			sceneArea.cityID = cityID;
			hideAllScene();
			sceneArea.visible = true;
			sceneArea.includeInLayout = true;
			sceneArea.show();
			curScene = SCENE_AREA;
			GameManager.gameMgr.gameApp.lblPlace1.text = sceneArea.gameCity.upName;
			GameManager.gameMgr.showTitle(true, true, false, true, false, true);
		}
		
		private var isInitBattle:Boolean = false;
		
		/**
		 * 进入战役场景 
		 * @param forceRefresh  是否强制刷新战役场景
		 * 
		 */			
		public function enterBattle(forceRefresh:Boolean = false):void
		{
			if (!isInitBattle)
			{
				sceneBattle.initUI();
				isInitBattle = true;
			}
			
			if (!forceRefresh && curScene == SCENE_BATTLE) return;
			
			hideAllScene();
			sceneBattle.visible = true;
			sceneBattle.includeInLayout = true;
			curScene = SCENE_BATTLE;
			sceneBattle.show();
			GameManager.gameMgr.showTitle(true, true, false, true, false, true);
		}
		
		private var isInitAttack:Boolean = false;
		
		/**
		 * 进入城战场景 
		 * 
		 */			
		public function enterAttack(warID:int):void
		{
			if (!isInitAttack)
			{
				sceneAttackCity.initUI();
				isInitAttack = true;
			}
			
			WinManager.winMgr.hideAllWin();
			sceneAttackCity.warID = warID;
			sceneAttackCity.visible = true;
			sceneAttackCity.includeInLayout = true;
			curScene = SCENE_ATTACK_CITY;
			sceneAttackCity.show();
		}
		
		/**
		 * 刷新邮件，请求提示框 
		 * 
		 */		
		public function refreshPanelTip():void
		{
			GameManager.gameMgr.gameApp.panelTip.refresh();
		}
		
		//=================================================================================
		// 属性
		//=================================================================================
		
		public function get sceneWubao():SceneWubao
		{
			return _sceneWubao;
		}
		
		public function set sceneWubao(param:SceneWubao):void
		{
			_sceneWubao = param;
		}

		public function get sceneMap():SceneMap
		{
			return _sceneMap;
		}
		
		public function set sceneMap(param:SceneMap):void
		{
			_sceneMap = param;
		}

		public function get sceneFight():SceneFight
		{
			return _sceneFight;
		}
		
		public function set sceneFight(param:SceneFight):void
		{
			_sceneFight = param;
		}

		public function get sceneArea():SceneArea
		{
			return _sceneArea;
		}
		
		public function set sceneArea(param:SceneArea):void
		{
			_sceneArea = param;
		}

		public function get sceneAttackCity():SceneAttackCity
		{
			return _sceneAttackCity;
		}
		
		public function set sceneAttackCity(param:SceneAttackCity):void
		{
			_sceneAttackCity = param;
		}

		public function get sceneBattle():SceneBattle
		{
			return _sceneBattle;
		}
		
		public function set sceneBattle(param:SceneBattle):void
		{
			_sceneBattle = param;
		}

		public function get curScene():int
		{
			return _curScene;
		}
		
		public function set curScene(param:int):void
		{
			_curScene = param;
		}

	}
}