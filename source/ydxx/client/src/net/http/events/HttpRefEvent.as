package net.http.events
{
	import flash.events.Event;

	public class HttpRefEvent extends Event
	{
		public static const REF:String = "ref";
		
		private var _isSuccess:int = 0;
		
		private var _gold:int = 0;
		
		private var _msg:String = "";

		public function HttpRefEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
		public function set isSuccess(param:int):void
		{
			this._isSuccess = param;
		}

		public function get isSuccess():int
		{
			return this._isSuccess;
		}

		public function set gold(param:int):void
		{
			this._gold = param;
		}

		public function get gold():int
		{
			return this._gold;
		}

		public function set msg(param:String):void
		{
			this._msg = param;
		}

		public function get msg():String
		{
			return this._msg;
		}
		
		override public function clone():Event
		{
			var e:HttpRefEvent = new HttpRefEvent(HttpRefEvent.REF);
			e.isSuccess = isSuccess;
			e.gold = gold;
			e.msg = msg;
			
			return e;
		}

	}
}