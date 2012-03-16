package deal.model
{
	import utils.GameManager;
	import utils.PubUnit;
	
	import wubao.model.User;
	
	/**
	 * 销售武器
	 * @author StarX
	 * 
	 */	
	public class Sell
	{
		//唯一标识
		private var _uniqID:int = 0;
		
		//用户ID
		private var _userID:int = 0;
		
		private var _userName:String = "";
		
		//武器类型 
		private var _type:int = 0;
		
		private var _typeName:String = "";
		
		//武器等级
		private var _level:int = 0;
		
		//武器数量
		private var _num:int = 0;
		
		//单价
		private var _dan:String = "";
		
		//销售价格
		private var _price:int = 0;
		
		//武器售卖时间戳
		private var _sellTime:int = 0;
		
		//剩余时间
		private var _leftTime:String = "";
		
		public function get uniqID():int
		{
			return _uniqID;
		}
		
		public function set uniqID(param:int):void
		{
			_uniqID = param;
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
			var gameUser:User = GameManager.gameMgr.userList.getObjByID(userID) as User;
			if (gameUser != null)
				_userName = gameUser.userName; 
			
			return _userName;
		}
		
		public function set userName(param:String):void
		{
			_userName = param;
		}
		
		public function get type():int
		{
			return _type;
		}
		
		public function set type(param:int):void
		{
			_type = param;
		}
		
		public function get typeName():String
		{
			if (type > 100)
				_typeName = PubUnit.resList[type - 100];
			else
				_typeName = PubUnit.weaponList[type]; 
			
			return _typeName;
		}
		
		public function set typeName(param:String):void
		{
			_typeName = param;
		}
		
		public function get level():int
		{
			return _level;
		}
		
		public function set level(param:int):void
		{
			_level = param;
		}
		
		public function get num():int
		{
			return _num;
		}
		
		public function set num(param:int):void
		{
			_num = param;
		}
		
		public function get dan():String
		{
			_dan = PubUnit.formatNumber(price / num, 2);
			
			return _dan;
		}
		
		public function set dan(param:String):void
		{
			_dan = param;
		}
		
		public function get price():int
		{
			return _price;
		}
		
		public function set price(param:int):void
		{
			_price = param;
		}
		
		public function get sellTime():int
		{
			return _sellTime;
		}
		
		public function set sellTime(param:int):void
		{
			_sellTime = param;
		}
		
		public function get leftTime():String
		{
			_leftTime = PubUnit.getGameDate(sellTime + PubUnit.hourOfYear * 5 - GameManager.gameMgr.gameTime); 
			
			return _leftTime;
		}
		
		public function set leftTime(param:String):void
		{
			_leftTime = param;
		}
	}
}