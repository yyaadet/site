package net.tcp.events
{
	import flash.events.Event;
	
	/**
	 * Tcp连接成功事件 
	 * @author StarX
	 * 
	 */	
	public class TcpSucEvent extends Event
	{
		public static const SUCCESS:String = "tcp_success";
		
		public function TcpSucEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
		/**
		 * 克隆Tcp连接成功事件对象 
		 * @return 
		 * 
		 */		
		public override function clone():Event
		{
			var ret:TcpSucEvent = new TcpSucEvent(SUCCESS);
			
			return ret;
		}
		
	}
}