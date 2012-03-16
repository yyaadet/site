package net.tcp.model
{
	/**
	 * 购买道具
	 * @author StarX
	 * 
	 */	
	public class TcpBuy
	{
		//坞堡ID
		private var _wbID:int = 0;
		
		//道具ID
		private var _treasureID:int = 0;
		
		public function get wbID():int
		{
			return _wbID;
		}
		
		public function set wbID(param:int):void
		{
			_wbID = param;
		}
		
		public function get treasureID():int
		{
			return _treasureID;
		}
		
		public function set treasureID(param:int):void
		{
			_treasureID = param;
		}
		
	}
}