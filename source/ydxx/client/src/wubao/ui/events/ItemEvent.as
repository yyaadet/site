package wubao.ui.events
{
	import flash.events.Event;

	public class ItemEvent extends Event
	{
		public static const ITEM_CLICK:String = "item_click"; 
		
		private var _item:Object = null;
		
		public function ItemEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
		public function get item():Object
		{
			return _item;
		}
		
		public function set item(param:Object):void
		{
			_item = param;
		}
		
	}
}