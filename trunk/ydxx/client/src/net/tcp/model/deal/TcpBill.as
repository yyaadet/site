package net.tcp.model.deal
{
	/**
	 * 挂单交易
	 * @author StarX
	 * 
	 */	
	public class TcpBill
	{
		//坞堡ID
		private var _wbID:int = 0;
		
		//挂单类型  1--买 2--卖
		private var _type:int = 0;
		
		//资源类型
		private var _resType:int = 0;
		
		//资源数量
		private var _resNum:int = 0;
		
		//单价
		private var _price:int = 0;
		
		public function get wbID():int
		{
			return _wbID;
		}
		
		public function set wbID(param:int):void
		{
			_wbID = param;
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
		
		public function get price():int
		{
			return _price;
		}
		
		public function set price(param:int):void
		{
			_price = param;
		}
		
	}
}