package net.tcp.model.sphere
{
	/**
	 * 请求结盟
	 * @author StarX
	 * 
	 */	
	public class TcpAlli
	{
		//发起势力ID
		private var _fromID:int = 0;
		
		//目标势力ID 
		private var _toID:int = 0;
		
		//结盟时间
		private var _alliTime:int = 0;
		
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
		
		public function get alliTime():int
		{
			return _alliTime;
		}
		
		public function set alliTime(param:int):void
		{
			_alliTime = param;
		}
		
	}
}