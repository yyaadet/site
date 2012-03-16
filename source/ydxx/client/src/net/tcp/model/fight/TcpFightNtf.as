package net.tcp.model.fight
{
	/**
	 * 战况通知包 
	 * @author bxl
	 * 
	 */	
	public class TcpFightNtf
	{
		private var _warID:int = 0; 
		
		private var _gateID:int = 0;
		
		private var _selfName:String = "";
		
		private var _selfNum:int = 0;
		
		private var _selfID:int = 0;
		
		private var _selfList:Array = [];
		
		private var _eneName:String = "";
		
		private var _eneNum:int = 0;
		
		private var _eneID:int = 0;
		
		private var _eneList:Array = [];
		
		//总回合数
		private var _roundNum:int = 0;
		
		//每个回合的数据
		private var _roundList:Array = [];
		
		private var _isWin:int = 0;
		
		private var _selfDie:int = 0;
		
		private var _eneDie:int = 0;
		
		private var _pre:int = 0;
		
		private var _weaponID:int = 0;
		
		private var _weaponLevel:int = 0;
		
		private var _weaponNum:int = 0;
		
		public function get gateID():int
		{
			return _gateID;
		}

		public function set gateID(value:int):void
		{
			_gateID = value;
		}

		public function get warID():int
		{
			return _warID;
		}

		public function set warID(value:int):void
		{
			_warID = value;
		}

		public function get selfName():String
		{
			return _selfName;
		}

		public function set selfName(value:String):void
		{
			_selfName = value;
		}

		public function get selfNum():int
		{
			return _selfNum;
		}

		public function set selfNum(value:int):void
		{
			_selfNum = value;
		}

		public function get selfID():int
		{
			return _selfID;
		}

		public function set selfID(value:int):void
		{
			_selfID = value;
		}

		public function get selfList():Array
		{
			return _selfList;
		}

		public function set selfList(value:Array):void
		{
			_selfList = value;
		}

		public function get eneName():String
		{
			return _eneName;
		}

		public function set eneName(value:String):void
		{
			_eneName = value;
		}

		public function get eneNum():int
		{
			return _eneNum;
		}

		public function set eneNum(value:int):void
		{
			_eneNum = value;
		}

		public function get eneID():int
		{
			return _eneID;
		}

		public function set eneID(value:int):void
		{
			_eneID = value;
		}

		public function get eneList():Array
		{
			return _eneList;
		}

		public function set eneList(value:Array):void
		{
			_eneList = value;
		}

		public function get roundNum():int
		{
			return _roundNum;
		}

		public function set roundNum(value:int):void
		{
			_roundNum = value;
		}

		public function get roundList():Array
		{
			return _roundList;
		}

		public function set roundList(value:Array):void
		{
			_roundList = value;
		}

		public function get isWin():int
		{
			return _isWin;
		}

		public function set isWin(value:int):void
		{
			_isWin = value;
		}

		public function get selfDie():int
		{
			return _selfDie;
		}

		public function set selfDie(value:int):void
		{
			_selfDie = value;
		}

		public function get eneDie():int
		{
			return _eneDie;
		}

		public function set eneDie(value:int):void
		{
			_eneDie = value;
		}

		public function get pre():int
		{
			return _pre;
		}

		public function set pre(value:int):void
		{
			_pre = value;
		}

		public function get weaponID():int
		{
			return _weaponID;
		}

		public function set weaponID(value:int):void
		{
			_weaponID = value;
		}

		public function get weaponLevel():int
		{
			return _weaponLevel;
		}

		public function set weaponLevel(value:int):void
		{
			_weaponLevel = value;
		}

		public function get weaponNum():int
		{
			return _weaponNum;
		}

		public function set weaponNum(value:int):void
		{
			_weaponNum = value;
		}

	}
}