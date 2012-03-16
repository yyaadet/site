package rob.events
{
	import flash.events.Event;

	/**
	 * 掠夺玩家事件 
	 * @author bxl
	 * 
	 */	
	public class RobEvent extends Event
	{
		public static const ROB_USER:String = "rob_user"; 
		
		private var _user:Object;
		
		public function RobEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
		public function get user():Object
		{
			return _user; 
		}
		
		public function set user(param:Object):void
		{
			_user = param;
		}
		
	}
}