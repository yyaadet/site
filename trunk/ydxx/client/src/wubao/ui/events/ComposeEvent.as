package wubao.ui.events
{
	import flash.events.Event;

	public class ComposeEvent extends Event
	{
		public static const COMPOSE:String = "compose"; 
		
		public function ComposeEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
	}
}