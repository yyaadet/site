package net.tcp.model.deal
{
	/**
	 * 挂单交易通知
	 * @author StarX
	 * 
	 */	
	public class TcpNtfBill
	{
		//唯一标识
		private var _uniqID:int = 0;
		
		//用户ID
		private var _userID:int = 0;
		
		//挂单类型  1--买 2--卖
		private var _type:int = 0;
		
		//资源类型
		private var _resType:int = 0;
		
		//资源数量
		private var _resNum:int = 0;
		
		//已经成交数据
		private var _dealNum:int = 0;
		
		//挂单价格
		private var _price:int = 0;
		
		//挂单时间戳
		private var _billTime:int = 0;
		
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
		
		public function get resType():int
		{
			return _resType;
		}
		
		public function set resType(param:int):void
		{
			_resType = param;
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