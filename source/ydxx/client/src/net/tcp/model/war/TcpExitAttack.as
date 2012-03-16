package net.tcp.model.war
{
	/**
	 * 退出攻城
	 * @author StarX
	 * 
	 */	
	public class TcpExitAttack
	{
		//战场ID
		private var _warID:int = 0;
		
		public function get warID():int
		{
			return _warID;
		}
		
		public function set warID(param:int):void
		{
			_warID = param;
		}
		
	}
}