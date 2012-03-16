package city.ui.events
{
	import flash.events.Event;

	public class SendEvent extends Event
	{
		public static const SEND:String = "send";
		
		public function SendEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
	}
}