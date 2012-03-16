package utils.events
{
	import flash.events.Event;
	
	/**
	 * 玩家点击确定事件 
	 * @author StarX
	 * 
	 */	
	public class ConfirmEvent extends Event
	{
		public static const CONFIRM:String = "confirm";
		
		public function ConfirmEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
		public override function clone():Event
		{
			var evt:ConfirmEvent = new ConfirmEvent(CONFIRM);
			
			return evt;
		}
		
	}
}