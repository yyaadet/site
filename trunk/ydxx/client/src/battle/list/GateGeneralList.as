package battle.list
{
	import battle.model.GateGeneral;
	
	import utils.list.GameList;
	
	public class GateGeneralList extends GameList
	{
		public function GateGeneralList()
		{
			super();
		}
		
		public function getByGateID(gateID:int):GateGeneralList
		{
			var gateGeneral:GateGeneral = null;
			var ret:GateGeneralList = new GateGeneralList();
			var i:int = 0;
			var len:int = 0;
			
			len = this.length;
			for (i = 0; i < len; i++)
			{
				gateGeneral = getObjByIndex(i) as GateGeneral;
				if (gateGeneral != null && gateGeneral.gateID == gateID)
					ret.add(gateGeneral);
			}
			
			return ret;
		}

	}
}