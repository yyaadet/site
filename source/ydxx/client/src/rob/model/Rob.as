package rob.model
{
	/**
	 * 掠夺 
	 * @author bxl
	 * 
	 */	
	public class Rob
	{
		private var _uniqID:int = 0;
		
		//掠夺者用户ID
		private var _fromID:int = 0;
		
		//被掠夺者用户ID
		private var _toID:int = 0;
		
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
		
		//开始时间
		private var _startTime:int = 0;
		
		//结束时间
		private var _endTime:int = 0;
		
		public function Rob()
		{
		}

		public function get uniqID():int
		{
			return _uniqID;
		}
		
		public function set uniqID(param:int):void
		{
			_uniqID = param;
		}
		
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
		
		public function get startTime():int
		{
			return _startTime;
		}
		
		public function set startTime(param:int):void
		{
			_startTime = param;
		}
		
		public function get endTime():int
		{
			return _endTime;
		}
		
		public function set endTime(param:int):void
		{
			_endTime = param;
		}
		
	}
}