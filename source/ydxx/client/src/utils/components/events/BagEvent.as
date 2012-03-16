package utils.components.events
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import utils.components.item.BagItem;

	public class BagEvent extends Event
	{
		public static const ItemClick:String = "item_click";
		
		private var _bagItem:BagItem = null;
		
		private var _itemObj:Object;
		
		private var _mouseEvent:MouseEvent = null;
		
		public function BagEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
		public function get itemObj():Object
		{
			return _itemObj;
		}
		
		public function set itemObj(param:Object):void
		{
			_itemObj = param;
		}
		
		public function get bagItem():BagItem
		{
			return _bagItem;
		}
		
		public function set bagItem(param:BagItem):void
		{
			_bagItem = param;
		}
		
		public function get mouseEvent():MouseEvent
		{
			return _mouseEvent;
		}
		
		public function set mouseEvent(param:MouseEvent):void
		{
			_mouseEvent = param;
		}
		
	}
}