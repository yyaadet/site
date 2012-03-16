package net.tcp.model.deal
{
	/**
	 * 购买武器 
	 * @author bxl
	 * 
	 */	
	public class TcpBuyWeapon
	{
		//销售单ID
		private var _uniqID:int = 0;
		
		public function TcpBuyWeapon()
		{
		}

		public function get uniqID():int
		{
			return _uniqID;
		}
		
		public function set uniqID(param:int):void
		{
			_uniqID = param;
		}
		
	}
}