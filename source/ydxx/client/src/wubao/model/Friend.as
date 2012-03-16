package wubao.model
{
	/**
	 * 友好度 
	 * @author bxl
	 * 
	 */	
	public class Friend
	{
		//对方武将ID
		private var _uniqID:int = 0;
		
		//友好度值
		private var _value:int = 0; 
		
		public function Friend()
		{
		}

		public function set uniqID(param:int):void
		{
			this._uniqID = param;
		}

		public function get uniqID():int
		{
			return this._uniqID;
		}

		public function set value(param:int):void
		{
			this._value = param;
		}

		public function get value():int
		{
			return this._value;
		}

	}
}