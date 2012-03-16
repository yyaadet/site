package net.tcp.model.map
{
	/**
	 * 军团变阵
	 * @author bxl
	 * 
	 */	
	public class TcpZhen
	{
		//军团ID
		private var _armyID:int = 0;
		
		//阵型ID 
		private var _zhenID:int = 0;

		public function set armyID(param:int):void
		{
			this._armyID = param;
		}

		public function get armyID():int
		{
			return this._armyID;
		}

		public function set zhenID(param:int):void
		{
			this._zhenID = param;
		}

		public function get zhenID():int
		{
			return this._zhenID;
		}

	}
}