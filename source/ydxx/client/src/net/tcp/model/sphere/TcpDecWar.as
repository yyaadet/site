package net.tcp.model.sphere
{
	/**
	 * 宣战
	 * @author StarX
	 * 
	 */	
	public class TcpDecWar
	{
		//发起势力ID
		private var _fromID:int = 0;
		
		//目标势力ID 
		private var _toID:int = 0;
		
		public function get fromID():int
		{
			return _fromID;
		}
		
		public function set fromID(param:int):void
		{
			_fromID = param;
		}
		
		public function get toID():int
		{
			return _toID;
		}
		
		public function set toID(param:int):void
		{
			_toID = param;
		}
		
	}
}