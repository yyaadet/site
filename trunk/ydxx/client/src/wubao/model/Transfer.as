package wubao.model
{
	/**
	 * 输送指令
	 * @author bxl
	 * 
	 */	
	public class Transfer
	{
		private var _uniqID:int = 0;
		
		//势力ID
		private var _sphereID:int = 0;
		
		//输送物品类型 1，武将；2，资源
		private var _objType:int = 0;
		
		//输送物品ID
		private var _objID:int = 0;
		
		//输送物品数量
		private var _objNum:int = 0;
		
		//类型
		//1，坞堡到城池；2，城池到城池；3，城池到坞堡
		private var _type:int = 0;
		
		//出发
		private var _fromID:int = 0;
		
		//目的
		private var _toID:int = 0;
		
		//所需时间
		private var _endTime:int = 0;
		
		public function Transfer()
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

		public function get type():int
		{
			return _type;
		}
		
		public function set type(param:int):void
		{
			_type = param;
		}

		public function get sphereID():int
		{
			return _sphereID;
		}
		
		public function set sphereID(param:int):void
		{
			_sphereID = param;
		}

		public function get objType():int
		{
			return _objType;
		}
		
		public function set objType(param:int):void
		{
			_objType = param;
		}

		public function get objID():int
		{
			return _objID;
		}
		
		public function set objID(param:int):void
		{
			_objID = param;
		}

		public function get objNum():int
		{
			return _objNum;
		}
		
		public function set objNum(param:int):void
		{
			_objNum = param;
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