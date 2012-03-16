package net.tcp.model.wubao
{
	/**
	 * 武将训练
	 * @author StarX
	 * 
	 */	
	public class TcpView
	{
		//武将ID
		private var _generalID:int = 0;
		
		//训练类型
		private var _type:int = 0;
		
		public function get generalID():int
		{
			return _generalID;
		}
		
		public function set generalID(param:int):void
		{
			_generalID = param;
		}
		
		public function get type():int
		{
			return _type;
		}
		
		public function set type(param:int):void
		{
			_type = param;
		}
		
	}
}