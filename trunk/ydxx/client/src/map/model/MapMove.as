package map.model
{
	public class MapMove
	{
		//军团ID
		private var _uniqID:int = 0;
		
		private var _pointList:Array = [];
		
		public function MapMove()
		{
			
		}

		//=============================================================
		//属性
		//=============================================================
		
		public function get uniqID():int
		{
			return _uniqID;
		}
		
		public function set uniqID(param:int):void
		{
			_uniqID = param;
		}
		
		public function get pointList():Array
		{
			return _pointList;
		}
		
		public function set pointList(param:Array):void
		{
			_pointList = param;
		}
		
	}
}