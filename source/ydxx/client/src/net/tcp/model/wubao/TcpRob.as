package net.tcp.model.wubao
{
	/**
	 * 掠夺 
	 * @author bxl
	 * 
	 */	
	public class TcpRob
	{
		//被掠夺者的用户ID
		private var _userID:int = 0;
		
		//武将ID
		private var _generalID:int = 0;
		
		//资源1ID
		private var _res1ID:int = 0;
		
		//资源2ID
		private var _res2ID:int = 0;
		
		//资源3ID
		private var _res3ID:int = 0;
		
		//资源4ID
		private var _res4ID:int = 0;
		
		//资源5ID
		private var _res5ID:int = 0;
		
		//资源6ID
		private var _res6ID:int = 0;
		
		//是否加速
		private var _isAcce:int = 0;
		
		public function TcpRob()
		{
		}

		public function get userID():int
		{
			return _userID;
		}
		
		public function set userID(param:int):void
		{
			_userID = param;
		}
		
		public function get generalID():int
		{
			return _generalID;
		}
		
		public function set generalID(param:int):void
		{
			_generalID = param;
		}
		
		public function get res1ID():int
		{
			return _res1ID;
		}
		
		public function set res1ID(param:int):void
		{
			_res1ID = param;
		}
		
		public function get res2ID():int
		{
			return _res2ID;
		}
		
		public function set res2ID(param:int):void
		{
			_res2ID = param;
		}
		
		public function get res3ID():int
		{
			return _res3ID;
		}
		
		public function set res3ID(param:int):void
		{
			_res3ID = param;
		}
		
		public function get res4ID():int
		{
			return _res4ID;
		}
		
		public function set res4ID(param:int):void
		{
			_res4ID = param;
		}
		
		public function get res5ID():int
		{
			return _res5ID;
		}
		
		public function set res5ID(param:int):void
		{
			_res5ID = param;
		}
		
		public function get res6ID():int
		{
			return _res6ID;
		}
		
		public function set res6ID(param:int):void
		{
			_res6ID = param;
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