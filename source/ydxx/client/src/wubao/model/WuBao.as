package wubao.model
{
	import general.list.GeneralList;
	import general.model.General;
	
	import sphere.model.Sphere;
	
	import utils.GameManager;
	import utils.PubUnit;
	
	import wubao.list.BuildList;
	import wubao.list.TechList;
	
	/**
	 * 坞堡类 
	 * @author bxl
	 * 
	 */	
	[Bindable]
	public class WuBao
	{
		//粮
		public static const FOOD:int = 1;
		
		//木
		public static const WOOD:int = FOOD + 1;
		
		//铁
		public static const IRON:int = WOOD + 1;
		
		//马
		public static const HORSE:int = IRON + 1;
		
		//皮
		public static const SKIN:int = HORSE + 1;
		
		//钱
		public static const MONEY:int = SKIN + 1;
		
		//坞堡ID
		private var _uniqID:int = 0;
		
		//用户ID
		private var _userID:int = 0;
		
		//所在城池ID
		private var _cityID:int = 0;
		
		//所属势力ID
		private var _sphereID:int = 0;
		
		//所属势力名称
		private var _sphereName:String = "无";
		
		//爵位ID
		private var _digID:int = 0;
		
		//爵位名称
		private var _digName:String = "";
		
		//官位ID
		private var _offID:int = 0;
		
		//官位名称
		private var _offName:String = "";
		
		//人口
		private var _people:int = 0;
		
		//户数
		private var _family:int = 0;
		
		//声望
		private var _prestige:int = 0;
		
		//步卒(兵源)
		private var _solNum:int = 0;
		
		//钱
		private var _money:int = 0;
		
		//粮
		private var _food:int = 0;
		
		//木
		private var _wood:int = 0;
		
		//铁
		private var _iron:int = 0;
		
		//皮革
		private var _skin:int = 0;
		
		//战马
		private var _horse:int = 0;
		
		//已募兵人数
		private var _gotSol:int = 0;
		
		//当月已使用制造力
		private var _useMade:int = 0;
		
		//当月还剩的制造力
		private var _leftMade:int = 0;
		
		//当天已治疗伤兵数目
		private var _cureSol:int = 0;
		
		//仓库
		private var _store:Store = new Store();
		
		//建筑列表
		private var _buildList:BuildList = new BuildList();
		
		//科技列表
		private var _techList:TechList = new TechList();
		
		//属于玩家的武将列表
		private var _generalList:GeneralList = new GeneralList();
		
		//酒馆中的武将
		private var _generalStand:General = null;
		
		public function WuBao()
		{
			
		}

		public function get uniqID():int
		{
			return _uniqID;
		}

		public function set uniqID(value:int):void
		{
			_uniqID = value;
		}

		public function get userID():int
		{
			return _userID;
		}

		public function set userID(value:int):void
		{
			_userID = value;
		}

		public function get cityID():int
		{
			return _cityID;
		}

		public function set cityID(value:int):void
		{
			_cityID = value;
		}

		public function get sphereID():int
		{
			return _sphereID;
		}

		public function set sphereID(value:int):void
		{
			_sphereID = value;
		}

		public function get sphereName():String
		{
			var gameSphere:Sphere = GameManager.gameMgr.sphereList.getObjByID(sphereID) as Sphere;
			if (gameSphere != null)
				_sphereName = gameSphere.sphereName;
				
			return _sphereName;
		}

		public function set sphereName(value:String):void
		{
			_sphereName = value;
		}

		public function get digID():int
		{
			return _digID;
		}

		public function set digID(value:int):void
		{
			_digID = value;
		}

		public function get digName():String
		{
			var dig:Dignitie = GameManager.gameMgr.digList.getObjByID(digID) as Dignitie;
			if (dig != null)
				_digName = dig.digName;
				
			return _digName;
		}

		public function set digName(value:String):void
		{
			_digName = value;
		}

		public function get offID():int
		{
			return _offID;
		}

		public function set offID(value:int):void
		{
			_offID = value;
		}

		public function get offName():String
		{
			var off:Official = GameManager.gameMgr.offList.getObjByID(offID) as Official;
			if (off != null)
				_offName = off.offName;
				
			return _offName;
		}

		public function set offName(value:String):void
		{
			_offName = value;
		}

		public function get people():int
		{
			return _people;
		}

		public function set people(value:int):void
		{
			_people = value;
		}

		public function get family():int
		{
			return _family;
		}

		public function set family(value:int):void
		{
			_family = value;
		}

		public function get prestige():int
		{
			return _prestige;
		}

		public function set prestige(value:int):void
		{
			_prestige = value;
		}

		public function get solNum():int
		{
			return _solNum;
		}

		public function set solNum(value:int):void
		{
			_solNum = value;
		}

		public function get money():int
		{
			return _money;
		}

		public function set money(value:int):void
		{
			_money = value;
		}

		public function get food():int
		{
			return _food;
		}

		public function set food(value:int):void
		{
			_food = value;
		}

		public function get wood():int
		{
			return _wood;
		}

		public function set wood(value:int):void
		{
			_wood = value;
		}

		public function get iron():int
		{
			return _iron;
		}

		public function set iron(value:int):void
		{
			_iron = value;
		}

		public function get skin():int
		{
			return _skin;
		}

		public function set skin(value:int):void
		{
			_skin = value;
		}

		public function get horse():int
		{
			return _horse;
		}

		public function set horse(value:int):void
		{
			_horse = value;
		}

		public function get gotSol():int
		{
			return _gotSol;
		}

		public function set gotSol(value:int):void
		{
			_gotSol = value;
		}

		public function get useMade():int
		{
			return _useMade;
		}

		public function set useMade(value:int):void
		{
			_useMade = value;
		}

		public function get leftMade():int
		{
			_leftMade = PubUnit.getLeftMade();
			
			return _leftMade;
		}

		public function set leftMade(value:int):void
		{
			_leftMade = value;
		}

		public function get cureSol():int
		{
			return _cureSol;
		}

		public function set cureSol(value:int):void
		{
			_cureSol = value;
		}

		public function get store():Store
		{
			return _store;
		}

		public function set store(value:Store):void
		{
			_store = value;
		}

		public function get buildList():BuildList
		{
			return _buildList;
		}

		public function set buildList(value:BuildList):void
		{
			_buildList = value;
		}

		public function get techList():TechList
		{
			return _techList;
		}

		public function set techList(value:TechList):void
		{
			_techList = value;
		}

		public function get generalList():GeneralList
		{
			return _generalList;
		}

		public function set generalList(value:GeneralList):void
		{
			_generalList = value;
		}

		public function get generalStand():General
		{
			return _generalStand;
		}

		public function set generalStand(value:General):void
		{
			_generalStand = value;
		}

	}
}