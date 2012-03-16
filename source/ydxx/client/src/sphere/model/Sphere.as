package sphere.model
{
	import city.list.CityList;
	
	import utils.GameManager;
	
	import wubao.list.UserList;
	import wubao.model.User;
	
	/**
	 * 势力 
	 * @author bxl
	 * 
	 */	
	public class Sphere
	{
		//势力ID
		private var _uniqID:int = 0;
		
		//排名
		private var _rank:int = 0;
		
		//用户ID(君主ID)
		private var _userID:int = 0;
		
		//君主名称
		private var _userName:String = "";
		
		//势力名称
		private var _sphereName:String = "";
		
		//势力等级
		private var _level:int = 0;
		
		//等级名称
		private var _levelName:String = "";
		
		//用户数
		private var _userNum:int = 0;
		
		//最大用户数
		private var _maxUser:int = 0;
		
		//界面显示势力玩家数，如20/30
		private var _showNum:String = "";
		
		//是否满员
		private var _isFull:Boolean = false;
		
		//城池数
		private var _cityNum:int = 0;
		
		//威望
		private var _prestige:int = 0;
		
		//势力介绍
		private var _description:String = "";
		
		//是否NPC
		private var _isNPC:Boolean = false;
		
		//在势力分布图上的颜色
		private var _mapColor:uint = 0xFFFFFF;
		
		private var _userList:UserList = new UserList();
		
		private var _cityList:CityList = new CityList();
		
		public function Sphere()
		{
			
		}
		
		/**
		 * 设置玩家的势力为空 
		 * @param userID
		 * 
		 */		
		public function setUserDefault(userID:int = 0):void
		{
			var i:int = 0;
			var gameUser:User = null;
			
			if (userID == 0)
			{
				for (i = 0; i < userList.length; i++)
				{
					gameUser = userList.getObjByIndex(i) as User;
					if (gameUser != null)
						gameUser.sphereID = 0;
				}
			}
			else
			{
				for (i = 0; i < userList.length; i++)
				{
					gameUser = userList.getObjByIndex(i) as User;
					if (gameUser != null && gameUser.uniqID == userID)
						gameUser.sphereID = 0;
				}
			}
		}
		
		public function get uniqID():int
		{
			return _uniqID;
		}
		
		public function set uniqID(param:int):void
		{
			_uniqID = param;
		}

		public function get rank():int
		{
			return _rank;
		}
		
		public function set rank(param:int):void
		{
			_rank = param;
		}

		public function get userID():int
		{
			return _userID;
		}
		
		public function set userID(param:int):void
		{
			_userID = param;
		}

		public function get userName():String
		{
			var gameUser:User = userList.getObjByID(userID) as User;
			if (gameUser != null)
				_userName = gameUser.userName;  
			
			return _userName;
		}
		
		public function set userName(param:String):void
		{
			_userName = param;
		}

		public function get sphereName():String
		{
			return _sphereName;
		}
		
		public function set sphereName(param:String):void
		{
			_sphereName = param;
		}

		public function get level():int
		{
			return _level;
		}
		
		public function set level(param:int):void
		{
			_level = param;
		}

		public function get levelName():String
		{
			var sphLev:SphLevel = GameManager.gameMgr.slList.getObjByID(level) as SphLevel;
			if (sphLev != null)
				_levelName = sphLev.levName;
				
			return _levelName;
		}
		
		public function set levelName(param:String):void
		{
			_levelName = param;
		}

		public function get userNum():int
		{
			_userNum = userList.length;
			
			return _userNum;
		}
		
		public function set userNum(param:int):void
		{
			_userNum = param;
		}

		public function get maxUser():int
		{
			var sphLev:SphLevel = GameManager.gameMgr.slList.getObjByID(level) as SphLevel;
			if (sphLev != null)
				_maxUser = sphLev.userNum;
				
			return _maxUser;
		}
		
		public function set maxUser(param:int):void
		{
			_maxUser = param;
		}

		public function get showNum():String
		{
			_showNum = userNum.toString() + "/" + maxUser.toString();
				
			return _showNum;
		}
		
		public function set showNum(param:String):void
		{
			_showNum = param;
		}

		public function get isFull():Boolean
		{
			_isFull = userNum >= maxUser ? true : false;
			
			return _isFull;
		}
		
		public function set isFull(param:Boolean):void
		{
			_isFull = param;
		}

		public function get cityNum():int
		{
			_cityNum = cityList.length;
			
			return _cityNum;
		}
		
		public function set cityNum(param:int):void
		{
			_cityNum = param;
		}

		public function get prestige():int
		{
			return _prestige;
		}
		
		public function set prestige(param:int):void
		{
			_prestige = param;
		}

		public function get description():String
		{
			return _description;
		}
		
		public function set description(param:String):void
		{
			_description = param;
		}

		public function get isNPC():Boolean
		{
			_isNPC = userID < 22 ? true : false;
			
			return _isNPC;
		}
		
		public function set isNPC(param:Boolean):void
		{
			_isNPC = param;
		}

		public function get mapColor():int
		{
			return _mapColor;
		}
		
		public function set mapColor(param:int):void
		{
			_mapColor = param;
		}

		public function get userList():UserList
		{
			return _userList;
		}
		
		public function set userList(param:UserList):void
		{
			_userList = param;
		}

		public function get cityList():CityList
		{
			return _cityList;
		}
		
		public function set cityList(param:CityList):void
		{
			_cityList = param;
		}

	}
}