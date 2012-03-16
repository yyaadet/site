package net.tcp.model.wubao
{
	/**
	 * 出征
	 * @author StarX
	 * 
	 */	
	public class TcpMarch
	{
		//坞堡ID
		private var _wbID:int = 0;
		
		//武将ID
		private var _generalID:int = 0;
		
		//出征类型 1--急袭  2--出征
		private var _type:int = 0;
		
		//出征天数
		private var _days:int = 0;
		
		//阵型
		private var _zhen:int = 0;
		
		//出发地  1--坞堡  2--城池
		// (这两个字段发包时用不到，为了解决出征时定位的问题)
		private var _place:int = 0;
		
		private var _placeID:int = 0;
		
		public function get wbID():int
		{
			return _wbID;
		}
		
		public function set wbID(param:int):void
		{
			_wbID = param;
		}
		
		public function get generalID():int
		{
			return _generalID;
		}
		
		public function set generalID(param:int):void
		{
			_generalID = param;
		}
		
		public function get type():int
		{
			return _type;
		}
		
		public function set type(param:int):void
		{
			_type = param;
		}
		
		public function get days():int
		{
			return _days;
		}

		public function set days(value:int):void
		{
			_days = value;
		}
		
		public function get zhen():int
		{
			return _zhen;
		}

		public function set zhen(value:int):void
		{
			_zhen = value;
		}
		
		public function get place():int
		{
			return _place;
		}

		public function set place(value:int):void
		{
			_place = value;
		}
		
		public function get placeID():int
		{
			return _placeID;
		}

		public function set placeID(value:int):void
		{
			_placeID = value;
		}
		
	}
}