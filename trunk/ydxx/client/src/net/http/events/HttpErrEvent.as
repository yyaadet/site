package net.http.events
{
	import flash.events.Event;
	
	/**
	 * http连接错误事件 
	 * @author StarX
	 * 
	 */	
	public class HttpErrEvent extends Event
	{
		public static const ERROR:String = "http_error";
		
		//错误信息
		private var _errorInfo:String = "";
		
		public function HttpErrEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
		public function get errorInfo():String
		{
			return _errorInfo;
		}
		
		public function set errorInfo(param:String):void
		{
			_errorInfo = param;
		}
		
		public override function clone():Event
		{
			var evt:HttpErrEvent = new HttpErrEvent(ERROR);
			
			evt.errorInfo = errorInfo;
			
			return evt;
		}
		
	}
}