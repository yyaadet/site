package net.http.events
{
	import flash.events.Event;

	public class HttpSucEvent extends Event
	{
		public static const SUCCESS:String = "http_success";
		
		public function HttpSucEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
		override public function clone():Event
		{
			var e:HttpSucEvent = new HttpSucEvent(SUCCESS);
			return e;
		}
		
	}
}