package general.ui.events
{
	import flash.events.Event;

	public class PosEvent extends Event
	{
		public static const POS_GENERAL:String = "posGeneral";
		
		private var _obj:Object;
		
		public function PosEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
		public function get obj():Object
		{
			return _obj;
		}
		
		public function set obj(param:Object):void
		{
			_obj = param;
		}
		
	}
}