package net.tcp.model.war
{
	/**
	 * 宣战攻城
	 * @author StarX
	 * 
	 */	
	public class TcpAttack
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