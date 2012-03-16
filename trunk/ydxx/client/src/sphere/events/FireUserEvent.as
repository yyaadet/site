package sphere.events
{
	import flash.events.Event;
	
	/**
	 * 开除成员事件 
	 * @author bxl
	 * 
	 */	
	public class FireUserEvent extends Event
	{
		public static const FIRE_USER:String = "fire_user";
		
		private var _user:Object;
		
		public function FireUserEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
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