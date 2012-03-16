package net.tcp.model.wubao
{
	/**
	 * 赐予
	 * @author StarX
	 * 
	 */	
	public class TcpGrant
	{
		//坞堡ID
		private var _wbID:int = 0;
		
		//类型  1--赐予  2--收回  3--使用
		private var _type:int = 0;
		
		//赠送武将的类型  0--己方武将  1--在野武将(结交)
		private var _genSide:int = 0;
		
		//武将ID
		private var _generalID:int = 0;
		
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
		
		public function get type():int
		{
			return _type;
		}
		
		public function set type(param:int):void
		{
			_type = param;
		}
		
		public function get genSide():int
		{
			return _genSide;
		}
		
		public function set genSide(param:int):void
		{
			_genSide = param;
		}
		
		public function get generalID():int
		{
			return _generalID;
		}
		
		public function set generalID(param:int):void
		{
			_generalID = param;
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