package net.tcp.model
{
	public class TcpGuid
	{
		private var _guidIndex:int = 0;
		
		public function TcpGuid()
		{
		}
		
		public function get guidIndex():int
		{
			return _guidIndex;
		}
		
		public function set guidIndex(param:int):void
		{
			_guidIndex = param;
		}

	}
}