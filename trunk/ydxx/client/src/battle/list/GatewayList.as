package battle.list
{
	import battle.model.Gateway;
	
	import utils.GameManager;
	import utils.list.GameList;
	
	import wubao.model.User;

	public class GatewayList extends GameList
	{
		public function GatewayList()
		{
			super();
		}
		
		public function getListByBattleID(battleID:int):GatewayList
		{
			var gate:Gateway = null;
			var ret:GatewayList = new GatewayList();
			var i:int = 0;
			var len:int = 0;
			
			len = this.length;
			for (i = 0; i < len; i++)
			{
				gate = getObjByIndex(i) as Gateway;
				if (gate != null && gate.battleID == battleID)
					ret.add(gate);
			}
			
			return ret;
		}
		
	}
}