package net.http.events
{
	import flash.events.Event;

	public class HttpRespEvent extends Event
	{
		public static const GIFT:String = "gift";
		
		public static const SET_LOCK_PW:String = "set_lock_pw";
		
		public static const MODI_LOCK_PW:String = "modi_lock_pw";
		
		public static const FIND_LOCK_PW:String = "find_lock_pw";
		
		public static const CHECK_LOCK_PW:String = "check_lock_pw";
		
		public static const TRANS_COIN:String = "trans_coin";
		
		public static const CHAT_FILTER:String = "chat_filter";
		
		private var _isSuccess:int = 0;
		
		private var _msg:String = "";

		public function HttpRespEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
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

		public function set msg(param:String):void
		{
			this._msg = param;
		}

		public function get msg():String
		{
			return this._msg;
		}
		
	}
}