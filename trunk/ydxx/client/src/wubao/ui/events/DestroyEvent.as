package wubao.ui.events
{
	import flash.events.Event;

	public class DestroyEvent extends Event
	{
		public static const DESTROY:String = "destroy";
		
		public function DestroyEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
	}
}