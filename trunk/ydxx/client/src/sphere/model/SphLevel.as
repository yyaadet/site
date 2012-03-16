package sphere.model
{
	/**
	 * 势力等级 
	 * @author bxl
	 * 
	 */	
	public class SphLevel
	{
		private var _uniqID:int = 0;
		
		private var _levName:String = "";
		
		private var _userNum:int = 0;
		
		private var _cityNum:int = 0;
		
		public function SphLevel()
		{
		}

		public function get uniqID():int
		{
			return _uniqID;
		}

		public function set uniqID(value:int):void
		{
			_uniqID = value;
		}

		public function get levName():String
		{
			return _levName;
		}

		public function set levName(value:String):void
		{
			_levName = value;
		}

		public function get userNum():int
		{
			return _userNum;
		}

		public function set userNum(value:int):void
		{
			_userNum = value;
		}

		public function get cityNum():int
		{
			return _cityNum;
		}

		public function set cityNum(value:int):void
		{
			_cityNum = value;
		}

	}
}