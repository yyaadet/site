package net.tcp.model.wubao
{
	/**
	 * 迁城
	 * @author StarX
	 * 
	 */	
	public class TcpChangeCity
	{
		//城池ID
		private var _cityID:int = 0;
		
		public function get cityID():int
		{
			return _cityID;
		}
		
		public function set cityID(param:int):void
		{
			_cityID = param;
		}
		
	}
}