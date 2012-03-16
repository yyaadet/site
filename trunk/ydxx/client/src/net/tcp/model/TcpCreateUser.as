package net.tcp.model
{
	/**
	 * 创建角色消息包 
	 * @author StarX
	 * 
	 */	
	public class TcpCreateUser
	{
		//用户名
		private var _userName:String = "";
		
		//城池ID
		private var _cityID:int = 0;
		
		public function get userName():String
		{
			return _userName;
		}
		
		public function set userName(param:String):void
		{
			_userName = param;
		}
		
		public function get cityID():int
		{
			return _cityID;
		}
		
		public function set cityID(param:int):void
		{
			_cityID = param;
		}
		
	}
}