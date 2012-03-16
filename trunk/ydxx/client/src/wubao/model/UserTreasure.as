package wubao.model
{
	import shop.model.Treasure;
	
	import utils.FormatText;
	
	/**
	 * 玩家购买的道具 
	 * @author StarX
	 * 
	 */	
	public class UserTreasure
	{
		//数据库ID
		private var _uniqID:int = 0;
		
		//道具ID
		private var _treasureID:int = 0;
		
		//所属武将ID
		private var _generalID:int = 0;
		
		//是否使用  0：否，1：是
		private var _isUsed:int = 0;
		
		//用户ID
		private var _userID:int = 0;
		
		//道具使用时间 
		private var _useTime:int = 0;
		
		//玩家拥有的数量
		private var _num:int = 0;
		
		//图片地址
		private var _url:String = "";
		
		//提示信息
		private var _tip:String = "";
		
		//对应的道具信息
		private var _treasure:Treasure = null;
		
		public function update(ut:UserTreasure):void
		{
			uniqID = ut.uniqID;
			treasureID = ut.treasureID;
			generalID = ut.generalID;
			isUsed = ut.isUsed;
			userID = ut.userID;
			useTime = ut.useTime;
		}

		public var equal:Function = function (source:UserTreasure):Boolean
		{
			if (source == null) return false;
			
			if (source.treasureID == treasureID)
				return true
			
			return false;
		}
		
		public function set uniqID(param:int):void
		{
			this._uniqID = param;
		}

		public function get uniqID():int
		{
			return this._uniqID;
		}

		public function set treasureID(param:int):void
		{
			this._treasureID = param;
		}

		public function get treasureID():int
		{
			return this._treasureID;
		}
		
		public function get generalID():int
		{
			return _generalID;
		}
		
		public function set generalID(param:int):void
		{
			this._generalID = param;
		}
		
		public function get isUsed():int
		{
			return _isUsed;
		}
		
		public function set isUsed(param:int):void
		{
			this._isUsed = param;
		}
		
		public function get userID():int
		{
			return _userID;
		}
		
		public function set userID(param:int):void
		{
			this._userID = param;
		}
		
		public function get useTime():int
		{
			return _useTime;
		}
		
		public function set useTime(param:int):void
		{
			this._useTime = param;
		}
		
		public function get num():int
		{
			return _num;
		}
		
		public function set num(param:int):void
		{
			this._num = param;
		}
		
		public function get url():String
		{
			_url = treasure.url;
			return _url;
		}
		
		public function set url(param:String):void
		{
			this._url = param;
		}
		
		public function get tip():String
		{
			_tip = FormatText.packegText(treasure.name) + "\n" + 
			       FormatText.packegText(treasure.description);
			
			return _tip;
		}
		
		public function set tip(param:String):void
		{
			this._tip = param;
		}
		
		public function get treasure():Treasure
		{
			return _treasure;
		}
		
		public function set treasure(param:Treasure):void
		{
			this._treasure = param;
		}
		
	}
}