package net.tcp.model.sphere
{
	/**
	 * 确认加入势力
	 * @author StarX
	 * 
	 */	
	public class TcpConfJoin
	{
		private var _mailID:int = 0;
		
		//申请加入的用户ID
		private var _userID:int = 0;
		
		//是否同意  0--否  1--是
		private var _isConf:int = 0;
		
		public function get mailID():int
		{
			return _mailID;
		}
		
		public function set mailID(param:int):void
		{
			_mailID = param;
		}
		
		public function get userID():int
		{
			return _userID;
		}
		
		public function set userID(param:int):void
		{
			_userID = param;
		}
		
		public function get isConf():int
		{
			return _isConf;
		}
		
		public function set isConf(param:int):void
		{
			_isConf = param;
		}
		
	}
}