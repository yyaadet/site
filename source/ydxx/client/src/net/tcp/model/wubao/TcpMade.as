package net.tcp.model.wubao
{
	/**
	 * 生产装备
	 * @author StarX
	 * 
	 */	
	public class TcpMade
	{
		//坞堡ID
		private var _wbID:int = 0;
		
		//装备类型
		private var _type:int = 0;
		
		//数量
		private var _num:int = 0;
		
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
		
		public function get num():int
		{
			return _num;
		}
		
		public function set num(param:int):void
		{
			_num = param;
		}
		
	}
}