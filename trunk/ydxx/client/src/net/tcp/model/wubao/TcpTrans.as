package net.tcp.model.wubao
{
	/**
	 * 输送武将
	 * @author StarX
	 * 
	 */	
	public class TcpTrans
	{
		//武将ID
		private var _generalID:int = 0;
		
		//输送类型
		//1. 坞堡--城池
		//出发ID：坞堡ID
		//目的ID：城池ID
		//
		//2.城池1--城池2
		//出发ID：城池1ID
		//目的ID：城池2ID
		//
		//3.城池--坞堡
		//出发ID：城池ID
		//目的ID：坞堡ID
		private var _type:int = 0;
		
		//目的ID
		private var _toID:int = 0;
		
		//是否加速
		private var _isAcce:int = 0;
		
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
		
		public function get toID():int
		{
			return _toID;
		}
		
		public function set toID(param:int):void
		{
			_toID = param;
		}
		
		public function get isAcce():int
		{
			return _isAcce;
		}
		
		public function set isAcce(param:int):void
		{
			_isAcce = param;
		}
		
	}
}