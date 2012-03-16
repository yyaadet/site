package city.model
{
	import sphere.model.Sphere;
	
	import utils.GameManager;
	
	import wubao.list.UserList;
	import wubao.model.User;
	
	/**
	 * 攻打城池战场 
	 * @author bxl
	 * 
	 */	
	public class AttackCity
	{
		//战场ID
		private var _uniqID:int = 0;
		
		//攻方势力ID
		private var _atkSphereID:int = 0;
		
		private var _atkSphereName:String = "";
		
		//守方势力ID
		private var _dfsSphereID:int = 0;
		
		private var _dfsSphereName:String = "";
		
		//城池ID
		private var _cityID:int = 0;
		
		private var _cityName:String = "";
		
		//开战时间
		private var _warTime:int = 0;
		
		//攻方玩家
		private var _atkUserList:UserList = new UserList();
		
		//守方玩家
		private var _dfsUserList:UserList = new UserList();
		
		public function AttackCity()
		{
			
		}
		
		public function hasUser(userID:int):Boolean
		{
			var i:int = 0;
			var gameUser:User = null;
			
			for (i = 0; i < atkUserList.length; i++)
			{
				gameUser = atkUserList.getObjByIndex(i) as User;
				if (gameUser != null && gameUser.uniqID == userID)
					return true;
			}
			
			for (i = 0; i < dfsUserList.length; i++)
			{
				gameUser = dfsUserList.getObjByIndex(i) as User;
				if (gameUser != null && gameUser.uniqID == userID)
					return true;
			}
			
			return false;
		}
		
		public function get uniqID():int
		{
			return _uniqID;
		}
		
		public function set uniqID(param:int):void
		{
			_uniqID = param;
		}

		public function get atkSphereID():int
		{
			return _atkSphereID;
		}
		
		public function set atkSphereID(param:int):void
		{
			_atkSphereID = param;
		}

		public function get atkSphereName():String
		{
			var gameSphere:Sphere = GameManager.gameMgr.sphereList.getObjByID(atkSphereID) as Sphere;
			if (gameSphere != null) 
				_atkSphereName = gameSphere.sphereName;
				 
			return _atkSphereName;
		}
		
		public function set atkSphereName(param:String):void
		{
			_atkSphereName = param;
		}

		public function get dfsSphereID():int
		{
			return _dfsSphereID;
		}
		
		public function set dfsSphereID(param:int):void
		{
			_dfsSphereID = param;
		}

		public function get dfsSphereName():String
		{
			var gameSphere:Sphere = GameManager.gameMgr.sphereList.getObjByID(dfsSphereID) as Sphere;
			if (gameSphere != null) 
				_dfsSphereName = gameSphere.sphereName;
			else
				_dfsSphereName = "NPC";
				 
			return _dfsSphereName;
		}
		
		public function set dfsSphereName(param:String):void
		{
			_dfsSphereName = param;
		}

		public function get cityID():int
		{
			return _cityID;
		}
		
		public function set cityID(param:int):void
		{
			_cityID = param;
		}

		public function get cityName():String
		{
			var gameCity:City = GameManager.gameMgr.cityList.getObjByID(cityID) as City;
			if (gameCity != null) 
				_cityName = gameCity.cityName;
				 
			return _cityName;
		}
		
		public function set cityName(param:String):void
		{
			_cityName = param;
		}

		public function get warTime():int
		{
			return _warTime;
		}
		
		public function set warTime(param:int):void
		{
			_warTime = param;
		}

		public function get atkUserList():UserList
		{
			return _atkUserList;
		}
		
		public function set atkUserList(param:UserList):void
		{
			_atkUserList = param;
		}

		public function get dfsUserList():UserList
		{
			return _dfsUserList;
		}
		
		public function set dfsUserList(param:UserList):void
		{
			_dfsUserList = param;
		}

	}
}