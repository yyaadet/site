package battle.events
{
	import flash.events.Event;

	public class MoveFadeEvent extends Event
	{
		public static const MOVE_FADE_END:String = "move_fade_end"; 
		
		public function MoveFadeEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
	}
}