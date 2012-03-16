package battle.model
{
	import general.model.General;
	
	/**
	 * 关卡详细信息 
	 * @author bxl
	 * 
	 */	
	public class GateGeneral
	{
		//ID
		private var _uniqID:int = 0;
		
		//对应关卡ID
		private var _gateID:int = 0;
		
		//擂主武将
		private var _general:General = new General();
		
		public function GateGeneral()
		{
		}

		public function set uniqID(param:int):void
		{
			this._uniqID = param;
		}

		public function get uniqID():int
		{
			return this._uniqID;
		}

		public function set gateID(param:int):void
		{
			this._gateID = param;
		}

		public function get gateID():int
		{
			return this._gateID;
		}

		public function set general(param:General):void
		{
			this._general = param;
		}

		public function get general():General
		{
			return this._general;
		}

	}
}