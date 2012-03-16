package net.tcp.model.sphere
{
	/**
	 * 确认同盟
	 * @author StarX
	 * 
	 */	
	public class TcpConfAlli
	{
		private var _mailID:int = 0;
		
		//发起势力ID
		private var _sphereID:int = 0;
		
		//同盟时间
		private var _years:int = 0;
		
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
		
		public function get sphereID():int
		{
			return _sphereID;
		}
		
		public function set sphereID(param:int):void
		{
			_sphereID = param;
		}
		
		public function get years():int
		{
			return _years;
		}
		
		public function set years(param:int):void
		{
			_years = param;
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