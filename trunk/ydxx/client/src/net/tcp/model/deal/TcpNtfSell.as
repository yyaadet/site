package net.tcp.model.deal
{
	/**
	 * 销售武器通知
	 * @author StarX
	 * 
	 */	
	public class TcpNtfSell
	{
		//唯一标识
		private var _uniqID:int = 0;
		
		//用户ID
		private var _userID:int = 0;
		
		//武器类型 
		private var _type:int = 0;
		
		//武器等级
		private var _level:int = 0;
		
		//武器数量
		private var _num:int = 0;
		
		//销售价格
		private var _price:int = 0;
		
		//武器售卖时间戳
		private var _sellTime:int = 0;
		
		//是否删除 0--否 1--是
		private var _isDel:int = 0;
		
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
		
		public function get isDel():int
		{
			return _isDel;
		}
		
		public function set isDel(param:int):void
		{
			_isDel = param;
		}
		
	}
}