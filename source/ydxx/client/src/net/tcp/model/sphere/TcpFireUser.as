package net.tcp.model.sphere
{
	/**
	 * 开除成员
	 * @author StarX
	 * 
	 */	
	public class TcpFireUser
	{
		//势力ID 
		private var _sphereID:int = 0;
		
		//用户ID
		private var _userID:int = 0;
		
		public function get sphereID():int
		{
			return _sphereID;
		}
		
		public function set sphereID(param:int):void
		{
			_sphereID = param;
		}
		
		public function get userID():int
		{
			return _userID;
		}
		
		public function set userID(param:int):void
		{
			_userID = param;
		}
		
	}
}