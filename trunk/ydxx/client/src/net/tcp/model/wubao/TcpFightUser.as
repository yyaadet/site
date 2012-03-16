package net.tcp.model.wubao
{
	/**
	 * 挑战玩家消息包 
	 * @author bxl
	 * 
	 */	
	public class TcpFightUser
	{
		//用户ID
		private var _userID:int = 0;
		
		//是否加速
		private var _isAcce:int = 0;
		
		public function get userID():int
		{
			return _userID;
		}
		
		public function set userID(param:int):void
		{
			_userID = param;
		}
		
		public function get isAcce():int
		{
			return _isAcce;
		}
		
		public function set isAcce(param:int):void
		{
			_isAcce = param;
		}
		
	}
}