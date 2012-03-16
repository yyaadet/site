package net.tcp.events
{
	import flash.events.Event;
	
	/**
	 * Tcp连接错误事件 
	 * @author StarX
	 * 
	 */	
	public class TcpErrEvent extends Event
	{
		public static const ERROR:String = "tcp_error";
		
		//错误信息
		private var _errorInfo:String = "";
		
		public function TcpErrEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
		public function get errorInfo():String
		{
			return _errorInfo;
		}
		
		public function set errorInfo(param:String):void
		{
			_errorInfo = param;
		}
		
		/**
		 * 克隆Tcp连接错误事件对象
		 * @return 
		 * 
		 */		
		public override function clone():Event
		{
			var ret:TcpErrEvent = new TcpErrEvent(ERROR);
			
			ret.errorInfo = errorInfo;
			
			return ret;
		}
		
	}
}