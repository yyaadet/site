package net.tcp.model.wubao
{
	/**
	 * 武将中止巡视
	 * @author StarX
	 * 
	 */	
	public class TcpStopView
	{
		//武将ID
		private var _generalID:int = 0;
		
		public function get generalID():int
		{
			return _generalID;
		}
		
		public function set generalID(param:int):void
		{
			_generalID = param;
		}
		
	}
}