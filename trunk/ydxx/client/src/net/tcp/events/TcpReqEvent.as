package net.tcp.events
{
	import flash.events.Event;

	public class TcpReqEvent extends Event
	{
		public static const RECEIVE:String = "tcp_receive"; 
		
		//消息包列表
		private var _reqList:Array = null;
		
		public function TcpReqEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
		public function get reqList():Array
		{
			return _reqList;
		}
		
		public function set reqList(param:Array):void
		{
			if (param == null) return;
			
			_reqList = param;
		}
		
	}
}