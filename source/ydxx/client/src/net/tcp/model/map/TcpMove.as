package net.tcp.model.map
{
	/**
	 * 军团移动包 
	 * @author bxl
	 * 
	 */	
	public class TcpMove
	{
		//军团ID
		private var _armyID:int = 0;
		
		//移动目标
		//0--普通 1--回坞堡 2--回城
		private var _target:int = 0;
		
		//城池ID
		private var _cityID:int = 0;

		//路径序列
		private var _coorList:Array = null;
		
		public function TcpMove()
		{
		}

		public function set armyID(param:int):void
		{
			this._armyID = param;
		}

		public function get armyID():int
		{
			return this._armyID;
		}

		public function set target(param:int):void
		{
			this._target = param;
		}

		public function get target():int
		{
			return this._target;
		}

		public function set cityID(param:int):void
		{
			this._cityID = param;
		}

		public function get cityID():int
		{
			return this._cityID;
		}

		public function set coorList(param:Array):void
		{
			this._coorList = param;
		}

		public function get coorList():Array
		{
			return this._coorList;
		}

	}
}