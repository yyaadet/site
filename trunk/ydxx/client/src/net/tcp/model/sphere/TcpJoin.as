package net.tcp.model.sphere
{
	/**
	 * 加入势力
	 * @author StarX
	 * 
	 */	
	public class TcpJoin
	{
		//坞堡ID
		private var _wbID:int = 0;
		
		//势力ID 
		private var _sphereID:int = 0;
		
		public function get wbID():int
		{
			return _wbID;
		}
		
		public function set wbID(param:int):void
		{
			_wbID = param;
		}
		
		public function get sphereID():int
		{
			return _sphereID;
		}
		
		public function set sphereID(param:int):void
		{
			_sphereID = param;
		}
		
	}
}