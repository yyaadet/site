package army.list
{
	import army.model.Army;
	
	import general.model.General;
	
	import utils.GameManager;
	import utils.list.GameList;
	
	/**
	 * 军团列表类 
	 * @author bxl
	 * 
	 */	
	public class ArmyList extends GameList
	{
		public function ArmyList()
		{
			super();
		}
		
		/**
		 * 获取己方军团列表 
		 * @return 
		 * 
		 */		
		public function getSelfArmy():ArmyList
		{
			var i:int = 0;
			var len:int = 0;
			var gameArmy:Army = null;
			var ret:ArmyList = new ArmyList();
			
			len = this.length;
			for (i = 0; i < len; i++)
			{
				gameArmy = getObjByIndex(i) as Army;
				if (gameArmy != null)
				{
					var gameGenera:General = GameManager.gameMgr.generalList.getObjByID(gameArmy.generalID) as General;
					if (gameGenera != null && gameGenera.userID == GameManager.gameMgr.userID)
						ret.add(gameArmy);
				}
			}
			
			return ret;
		}
		
	}
}