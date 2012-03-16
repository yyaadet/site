package net.tcp.model.fight
{
	/**
	 * 打擂消息 
	 * @author bxl
	 * 
	 */	
	public class TcpFight
	{
		//关卡ID
		private var _gateID:int = 0;
		
		//武将数目
		private var _generalNum:int = 0;
		
		private var _generalList:Array = [];
		
		private var _isAcce:int = 0;
		
		public function TcpFight()
		{
		}

		public function get gateID():int
		{
			return _gateID;
		}

		public function set gateID(value:int):void
		{
			_gateID = value;
		}

		public function get generalNum():int
		{
			return _generalNum;
		}

		public function set generalNum(value:int):void
		{
			_generalNum = value;
		}

		public function get generalList():Array
		{
			return _generalList;
		}

		public function set generalList(value:Array):void
		{
			_generalList = value;
		}

		public function get isAcce():int
		{
			return _isAcce;
		}

		public function set isAcce(value:int):void
		{
			_isAcce = value;
		}

	}
}