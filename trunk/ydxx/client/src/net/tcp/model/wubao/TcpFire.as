package net.tcp.model.wubao
{
	/**
	 * 解雇武将
	 * @author StarX
	 * 
	 */	
	public class TcpFire
	{
		//坞堡ID
		private var _wbID:int = 0;
		
		//武将ID
		private var _generalID:int = 0;
		
		public function get wbID():int
		{
			return _wbID;
		}
		
		public function set wbID(param:int):void
		{
			_wbID = param;
		}
		
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