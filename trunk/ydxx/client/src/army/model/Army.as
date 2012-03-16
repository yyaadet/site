package army.model
{
	import general.model.General;
	
	import map.MapUtil;
	
	import utils.GameManager;
	
	import wubao.model.User;
	
	/**
	 * 军团 
	 * @author bxl
	 * 
	 */	
	public class Army
	{
		//军团ID
		private var _uniqID:int = 0;
		
		//军团名称
		private var _armyName:String = "";
		
		//军团类型  1，急袭；2，普通
		private var _type:int = 0;
		
		//武将ID
		private var _generalID:int = 0;
		
		//武将名称
		private var _generalName:String = "";
		
		//武将
		private var _gameGeneral:General = null;
		
		//坐标
		private var _mapX:int = 0;
		
		//
		private var _mapY:int = 0;
		
		//钱
		private var _money:int = 0;
		
		//粮
		private var _food:int = 0;
		
		//原始兵力
		private var _original:int = 0;
		
		//现有兵力
		private var _num:int = 0;
		
		//移动序列
		private var _moveList:Array = [];
		
		//军团所处的地形
		private var _landStr:String = "";
		
		//是否己方的军团
		private var _isSelf:Boolean = false;
		
		//是否敌对势力军团
		private var _isEne:Boolean = false;
		
		public function Army()
		{
			
		}
		
		public function get uniqID():int
		{
			return _uniqID;
		}
		
		public function set uniqID(param:int):void
		{
			_uniqID = param;
		}

		public function get armyName():String
		{
			_armyName = generalName; 
			
			return _armyName;
		}
		
		public function set armyName(param:String):void
		{
			_armyName = param;
		}

		public function get type():int
		{
			return _type;
		}
		
		public function set type(param:int):void
		{
			_type = param;
		}

		public function get generalID():int
		{
			return _generalID;
		}
		
		public function set generalID(param:int):void
		{
			_generalID = param;
			
			gameGeneral = GameManager.gameMgr.generalList.getObjByID(_generalID) as General;
		}

		public function get generalName():String
		{
			if (gameGeneral != null)
				_generalName = gameGeneral.generalName;
				
			return _generalName;
		}
		
		public function set generalName(param:String):void
		{
			_generalName = param;
		}

		public function get gameGeneral():General
		{
			return _gameGeneral;
		}
		
		public function set gameGeneral(param:General):void
		{
			_gameGeneral = param;
		}
		
		public function get mapX():int
		{
			return _mapX;
		}
		
		public function set mapX(param:int):void
		{
			_mapX = param;
		}

		public function get mapY():int
		{
			return _mapY;
		}
		
		public function set mapY(param:int):void
		{
			_mapY = param;
		}

		public function get money():int
		{
			return _money;
		}
		
		public function set money(param:int):void
		{
			_money = param;
		}

		public function get food():int
		{
			return _food;
		}
		
		public function set food(param:int):void
		{
			_food = param;
		}

		public function get original():int
		{
			return _original;
		}
		
		public function set original(param:int):void
		{
			_original = param;
		}

		public function get num():int
		{
			if (gameGeneral != null)
				_num = gameGeneral.soliderNum;
				
			return _num;
		}
		
		public function set num(param:int):void
		{
			_num = param;
		}

		public function get moveList():Array
		{
			return _moveList;
		}
		
		public function set moveList(param:Array):void
		{
			_moveList = param;
		}

		public function get landStr():String
		{
			return _landStr;
		}
		
		public function set landStr(param:String):void
		{
			_landStr = param;
		}

		public function get isSelf():Boolean
		{
			if (gameGeneral != null)
			{
				var userID:int = gameGeneral.userID;
				if (userID == GameManager.gameMgr.userID)
					_isSelf = true;
				else
					_isSelf = false;
			}
			
			return _isSelf;
		}
		
		public function set isSelf(param:Boolean):void
		{
			_isSelf = param;
		}
		
		public function get isEne():Boolean
		{
			var selfID:int = 0;
			selfID = GameManager.gameMgr.wubao.sphereID;
			if (selfID <= 0) return false;
			
			if (gameGeneral == null) return false;
			
			var userID:int = gameGeneral.userID;
			if (userID <= 0)
				return false;
				
			var gameUser:User = GameManager.gameMgr.userList.getObjByID(userID) as User;
			var sphereID:int = gameUser.sphereID;
			
			if (GameManager.gameMgr.dipList.isEne(selfID, sphereID))
				_isEne = true;
			else
				_isEne = false;
			
			return _isEne;
		}
		
		public function set isEne(param:Boolean):void
		{
			_isEne = param;
		}
		
	}
}