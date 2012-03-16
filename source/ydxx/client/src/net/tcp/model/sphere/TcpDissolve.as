package net.tcp.model.sphere
{
	/**
	 * 解散势力
	 * @author StarX
	 * 
	 */	
	public class TcpDissolve
	{
		//势力ID 
		private var _sphereID:int = 0;
		
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