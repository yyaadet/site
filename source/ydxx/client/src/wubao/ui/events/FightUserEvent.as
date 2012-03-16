package wubao.ui.events
{
	import flash.events.Event;
	
	/**
	 * 挑战玩家事件 
	 * @author bxl
	 * 
	 */	
	public class FightUserEvent extends Event
	{
		public static const FIGHT_USER:String = "fight_user";
		
		private var _user:Object;
		
		public function FightUserEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
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