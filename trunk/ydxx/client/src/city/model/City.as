package city.model
{
	import general.list.GeneralList;
	
	import sphere.model.Sphere;
	
	import utils.GameManager;
	import utils.PubUnit;
	
	import wubao.list.UserList;
	
	/**
	 * 城池
	 * @author StarX
	 * 
	 */	
	public class City
	{
		//城池ID
		private var _uniqID:int;
		
		//所属势力ID
		private var _sphereID:int;
		
		//所属势力名称
		private var _sphereName:String = "";
		
		//城池状态  1--正常  2--战争
		private var _cityState:int = 0;

		//城池名称
		private var _cityName:String = "";
		
		//城防
		private var _defense:int;
		
		//城防名称
		private var _defenseName:String = "";

		//城池等级, 2郡城；3州城；4都城
		private var _level:int;
		
		//城池等级名称
		private var _levelName:String = "";

		//所属城池ID
		private var _upID:int;
		
		//所属城池名称
		private var _upName:String = "";
		
		//所在郡名称
		private var _junName:String = "";
		
		//所在州名称
		private var _zhouName:String = "";

		//城池介绍
		private var _description:String;

		//X坐标
		private var _mapX:int;

		//Y坐标
		private var _mapY:int;
		
		//是否可分配
		private var _isAlloted:int = 0;
		
		//剩余可分配坞堡数目
		private var _wubaoNum:int = 0;
		
		//可创建坞堡数
		private var _wubaoTotal:int = 0;
		
		//郡代码
		private var _junCode:int = 0;
		
		//州代码
		private var _zhouCode:int = 0;
		
		//武将数量
		private var _generalNum:int = 0;
		
		//民兵兵力
		private var _solNum:int = 0;
		
		//总兵力
		private var _totalSol:int = 0;
		
		//伤兵
		private var _totalHurt:int = 0;
		
		//武将列表
		private var _generalList:GeneralList = new GeneralList();
		
		//玩家列表
		private var _userList:UserList = new UserList();

		public function City()
		{
		}

		public function set uniqID(param:int):void
		{
			this._uniqID = param;
		}

		public function get uniqID():int
		{
			return this._uniqID;
		}

		public function set sphereID(param:int):void
		{
			this._sphereID = param;
		}

		public function get sphereID():int
		{
			return this._sphereID;
		}

		public function set sphereName(param:String):void
		{
			this._sphereName = param;
		}

		public function get sphereName():String
		{
			var gameSphere:Sphere = GameManager.gameMgr.sphereList.getObjByID(sphereID) as Sphere;
			if (gameSphere != null)
				_sphereName = gameSphere.sphereName;
				
			return _sphereName
		}

		public function set cityState(param:int):void
		{
			this._cityState = param;
		}

		public function get cityState():int
		{
			return this._cityState;
		}

		public function set defense(param:int):void
		{
			this._defense = param;
		}

		public function get defense():int
		{
			return this._defense;
		}

		public function set defenseName(param:String):void
		{
			this._defenseName = param;
		}

		public function get defenseName():String
		{
			return this._defenseName;
		}

		public function set cityName(param:String):void
		{
			this._cityName = param;
		}

		public function get cityName():String
		{
			return this._cityName;
		}

		public function set level(param:int):void
		{
			this._level = param;
		}

		public function get level():int
		{
			return this._level;
		}

		public function set levelName(param:String):void
		{
			this._levelName = param;
		}

		public function get levelName():String
		{
			_levelName = PubUnit.cityLevelList[_level];
			return this._levelName;
		}

		public function set upID(param:int):void
		{
			this._upID = param;
		}

		public function get upID():int
		{
			return this._upID;
		}

		public function set upName(param:String):void
		{
			this._upName = param;
		}

		public function get upName():String
		{
			_upName = zhouName + junName;
				
			return this._upName;
		}

		public function set junName(param:String):void
		{
			this._junName = param;
		}

		public function get junName():String
		{
			return this._junName;
		}

		public function set zhouName(param:String):void
		{
			this._zhouName = param;
		}

		public function get zhouName():String
		{
			return this._zhouName;
		}

		public function set description(param:String):void
		{
			this._description = param;
		}

		public function get description():String
		{
			return this._description;
		}

		public function set mapX(param:int):void
		{
			this._mapX = param;
		}

		public function get mapX():int
		{
			return this._mapX;
		}

		public function set mapY(param:int):void
		{
			this._mapY = param;
		}

		public function get mapY():int
		{
			return this._mapY;
		}
		
		public function set isAlloted(param:int):void
		{
			this._isAlloted = param;
		}

		public function get isAlloted():int
		{
			return this._isAlloted;
		}
		
		public function set wubaoNum(param:int):void
		{
			this._wubaoNum = param;
		}

		public function get wubaoNum():int
		{
			return this._wubaoNum;
		}
		
		public function set wubaoTotal(param:int):void
		{
			this._wubaoTotal = param;
		}

		public function get wubaoTotal():int
		{
			return this._wubaoTotal;
		}
		
		public function set junCode(param:int):void
		{
			this._junCode = param;
		}

		public function get junCode():int
		{
			return this._junCode;
		}
		
		public function set zhouCode(param:int):void
		{
			this._zhouCode = param;
		}

		public function get zhouCode():int
		{
			return this._zhouCode;
		}
		
		public function set generalNum(param:int):void
		{
			this._generalNum = param;
		}

		public function get generalNum():int
		{
			_generalNum = generalList.getVisitList().length;
			
			return this._generalNum;
		}
		
		public function set solNum(param:int):void
		{
			this._solNum = param;
		}

		public function get solNum():int
		{
			return this._solNum;
		}
		
		public function set totalSol(param:int):void
		{
			this._totalSol = param;
		}

		public function get totalSol():int
		{
			_totalSol = solNum + generalList.getTotalSolider(sphereID); 
			
			return this._totalSol;
		}
		
		public function set totalHurt(param:int):void
		{
			this._totalHurt = param;
		}

		public function get totalHurt():int
		{
			_totalHurt = generalList.getTotalHurt(sphereID);
			
			return this._totalHurt;
		}
		
		public function set generalList(param:GeneralList):void
		{
			this._generalList = param;
		}

		public function get generalList():GeneralList
		{
			return this._generalList;
		}
		
		public function set userList(param:UserList):void
		{
			this._userList = param;
		}

		public function get userList():UserList
		{
			return this._userList;
		}
		
	}
}