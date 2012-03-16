package rob.list
{
	import rob.model.Rob;
	
	import utils.list.GameList;

	/**
	 * 掠夺列表 
	 * @author bxl
	 * 
	 */	
	public class RobList extends GameList
	{
		public function RobList()
		{
			super();
		}
		
		/**
		 * 根据武将ID获取对应的掠夺记录 
		 * @param generalID
		 * @return 
		 * 
		 */		
		public function getByGeneralID(generalID:int):Rob
		{
			var i:int = 0;
			var len:int = 0;
			var gameRob:Rob = null;
			
			len = this.length;
			
			for (i = 0; i < len; i++)
			{
				gameRob = getObjByIndex(i) as Rob;
				if (gameRob != null && gameRob.generalID == generalID)
					return gameRob;
			}
			
			return gameRob;
		}
		
		/**
		 * 根据武将ID删除对应的掠夺记录 
		 * @param generalID
		 * 
		 */		
		public function removeByGeneralID(generalID:int):void
		{
			var i:int = 0;
			var len:int = 0;
			var gameRob:Rob = null;
			
			len = this.length;
			
			for (i = 0; i < len; i++)
			{
				gameRob = getObjByIndex(i) as Rob;
				if (gameRob != null && gameRob.generalID == generalID)
					removeObjByID(gameRob.uniqID);
			}
		}
		
	}
}