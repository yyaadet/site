package wubao.ui.events
{
	import flash.events.Event;

	public class SellEvent extends Event
	{
		public static const SELL:String = "sell";
		
		public function SellEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
	}
}