package deal.model
{
	import utils.GameManager;
	import utils.PubUnit;
	
	/**
	 * 挂单
	 * @author StarX
	 * 
	 */	
	public class Bill
	{
		//唯一标识
		private var _uniqID:int = 0;
		
		//用户ID
		private var _userID:int = 0;
		
		//挂单类型  1--买 2--卖
		private var _type:int = 0;
		
		private var _typeName:String = "";
		
		//资源类型
		private var _resType:int = 0;
		
		//资源名称
		private var _resName:String = "";
		
		//资源数量
		private var _resNum:int = 0;
		
		//成交数量
		private var _dealNum:int = 0;
		
		//剩余数量
		private var _leftNum:int = 0;
		
		//挂单价格
		private var _price:int = 0;
		
		//挂单时间戳
		private var _billTime:int = 0;
		
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
			_typeName = type == 1 ? "买" : "卖"; 
					
			return _typeName;
		}
		
		public function set typeName(param:String):void
		{
			_typeName = param;
		}
		
		public function get resType():int
		{
			return _resType;
		}
		
		public function set resType(param:int):void
		{
			_resType = param;
		}
		
		public function get resName():String
		{
			_resName = PubUnit.resList[resType];
			
			return _resName;
		}
		
		public function set resName(param:String):void
		{
			_resName = param;
		}
		
		public function get resNum():int
		{
			return _resNum;
		}
		
		public function set resNum(param:int):void
		{
			_resNum = param;
		}
		
		public function get dealNum():int
		{
			return _dealNum;
		}
		
		public function set dealNum(param:int):void
		{
			_dealNum = param;
		}
		
		public function get leftNum():int
		{
			_leftNum = resNum - dealNum;
			
			return _leftNum;
		}
		
		public function set leftNum(param:int):void
		{
			_leftNum = param;
		}
		
		public function get price():int
		{
			return _price;
		}
		
		public function set price(param:int):void
		{
			_price = param;
		}
		
		public function get billTime():int
		{
			return _billTime;
		}
		
		public function set billTime(param:int):void
		{
			_billTime = param;
		}
		
		public function get leftTime():String
		{
			_leftTime = PubUnit.getGameDate(billTime + PubUnit.hourOfYear - GameManager.gameMgr.gameTime); 
			
			return _leftTime;
		}
		
		public function set leftTime(param:String):void
		{
			_leftTime = param;
		}
		
	}
}