package wubao.model
{
	import sphere.model.SphLevel;
	
	import utils.GameManager;
	
	/**
	 * 官位 
	 * @author StarX
	 * 
	 */	
	[Bindable]
	public class Official
	{
		//官位ID
		private var _uniqID:int = 0;

		//官位名称
		private var _offName:String;

		//前提势力等级
		private var _levelID:int = 0;
		
		private var _levelName:String = "";

		//官位类型
		//0：武职，1：文职
		private var _type:int = 0;
		
		//类型名称
		private var _typeName:String;

		//可率领士兵
		private var _follows:int = 0;

		//武力增加值
		private var _kongfu:int = 0;

		//移动增加值
		private var _speed:int = 0;

		//政治增加值
		private var _polity:int = 0;

		//智力增加值
		private var _intelligence:int = 0;
		
		//工资
		private var _salary:int = 0;
		
		//前提爵位
		private var _dig:int = 0;
		
		//是否已授予
		private var _isGrant:Boolean = false;
		
		//被授予者的用户ID
		private var _grantID:int = 0;
		
		//被授予者的名称
		private var _grantName:String = "";
		
		public function Official()
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

		public function set offName(param:String):void
		{
			this._offName = param;
		}

		public function get offName():String
		{
			return this._offName;
		}

		public function set levelID(param:int):void
		{
			this._levelID = param;
		}

		public function get levelID():int
		{
			return this._levelID;
		}

		public function set levelName(param:String):void
		{
			this._levelName = param;
		}

		public function get levelName():String
		{
			var sphLevel:SphLevel = GameManager.gameMgr.slList.getObjByID(levelID) as SphLevel;
			if (sphLevel != null) 
				_levelName = sphLevel.levName;
				  
			return this._levelName;
		}

		public function set type(param:int):void
		{
			this._type = param;
		}

		public function get type():int
		{
			return this._type;
		}

		public function set typeName(param:String):void
		{
			this._typeName = param;
		}
		
		public function get typeName():String
		{
			return this._typeName;
		}
		
		public function set follows(param:int):void
		{
			this._follows = param;
		}

		public function get follows():int
		{
			return this._follows;
		}

		public function set kongfu(param:int):void
		{
			this._kongfu = param;
		}

		public function get kongfu():int
		{
			return this._kongfu;
		}

		public function set speed(param:int):void
		{
			this._speed = param;
		}

		public function get speed():int
		{
			return this._speed;
		}

		public function set polity(param:int):void
		{
			this._polity = param;
		}

		public function get polity():int
		{
			return this._polity;
		}

		public function set intelligence(param:int):void
		{
			this._intelligence = param;
		}

		public function get intelligence():int
		{
			return this._intelligence;
		}
		
		public function set salary(param:int):void
		{
			this._salary = param;
		}

		public function get salary():int
		{
			return this._salary;
		}
		
		public function set dig(param:int):void
		{
			this._dig = param;
		}

		public function get dig():int
		{
			return this._dig;
		}
		
		public function set isGrant(param:Boolean):void
		{
			this._isGrant = param;
		}

		public function get isGrant():Boolean
		{
			return this._isGrant;
		}
				
		public function set grantID(param:int):void
		{
			this._grantID = param;
		}

		public function get grantID():int
		{
			return this._grantID;
		}
		
		public function set grantName(param:String):void
		{
			this._grantName = param;
		}

		public function get grantName():String
		{
			_grantName = "无";
			
			var gameUser:User = GameManager.gameMgr.userList.getObjByID(grantID) as User;
			if (gameUser != null) 
				_grantName = gameUser.userName;
			
			return this._grantName;
		}
		
	}
	
}