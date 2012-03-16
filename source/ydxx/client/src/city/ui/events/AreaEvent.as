package city.ui.events
{
	import flash.events.Event;
	
	public class AreaEvent extends Event
	{
		public static const ROB:String = "rob";
		
		public static const MAIL:String = "mail";
	
		public function AreaEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
	}
}