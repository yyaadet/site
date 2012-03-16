package sphere.list
{
	import sphere.model.Diplomacy;
	
	import utils.GameManager;
	import utils.list.GameList;
	
	/**
	 * 外交关系列表 
	 * @author bxl
	 * 
	 */	
	public class DipList extends GameList
	{
		public function DipList()
		{
			super();
		}
		
		/**
		 * 根据类型获取外交关系列表 
		 * @param type
		 * @return 
		 * 
		 */		
		public function getListByType(type:int):DipList
		{
			var i:int = 0;
			var len:int = 0;
			var gameDip:Diplomacy = null;
			var ret:DipList = new DipList();
			
			len = this.length;
			
			var sphereID:int = GameManager.gameMgr.wubao.sphereID;
			
			for (i = 0; i < len; i++)
			{
				gameDip = getObjByIndex(i) as Diplomacy;
				if (gameDip != null && gameDip.type == type && (gameDip.selfID == sphereID || gameDip.targetID == sphereID))
					ret.add(gameDip);
			}
			
			return ret;
		}
		
		/**
		 * 判断两个势力是否存在外交关系 
		 * @param selfID
		 * @param targetID
		 * @return 
		 * 
		 */		
		public function hasDip(selfID:int, targetID:int):Boolean
		{
			var i:int = 0;
			var len:int = 0;
			var gameDip:Diplomacy = null;
			
			len = this.length;
			
			for (i = 0; i < len; i++)
			{
				gameDip = getObjByIndex(i) as Diplomacy;
				if (gameDip != null && gameDip.selfID == selfID && gameDip.targetID == targetID)
					return true;
					
				if (gameDip != null && gameDip.selfID == targetID && gameDip.targetID == selfID)
					return true;
			}
			
			return false;
		}
		
		/**
		 * 判断两个势力是否同盟 
		 * @param selfID
		 * @param targetID
		 * @return 
		 * 
		 */		
		public function isAlli(selfID:int, targetID:int):Boolean
		{
			var i:int = 0;
			var len:int = 0;
			var gameDip:Diplomacy = null;
			
			len = this.length;
			
			for (i = 0; i < len; i++)
			{
				gameDip = getObjByIndex(i) as Diplomacy;
				if (gameDip != null && gameDip.type == 1 && gameDip.selfID == selfID && gameDip.targetID == targetID)
					return true;
					
				if (gameDip != null && gameDip.type == 1 && gameDip.selfID == targetID && gameDip.targetID == selfID)
					return true;
			}
			
			return false;
		}
		
		/**
		 * 判断两个势力是否敌对
		 * @param selfID
		 * @param targetID
		 * @return 
		 * 
		 */		
		public function isEne(selfID:int, targetID:int):Boolean
		{
			var i:int = 0;
			var len:int = 0;
			var gameDip:Diplomacy = null;
			
			len = this.length;
			
			for (i = 0; i < len; i++)
			{
				gameDip = getObjByIndex(i) as Diplomacy;
				if (gameDip != null && gameDip.type == 2 && gameDip.selfID == selfID && gameDip.targetID == targetID)
					return true;
					
				if (gameDip != null && gameDip.type == 2 && gameDip.selfID == targetID && gameDip.targetID == selfID)
					return true;
			}
			
			return false;
		}
		
		/**
		 * 清除过时的关系 
		 * 
		 */		
		public function clearOut():void
		{
			var i:int = 0;
			var len:int = 0;
			var gameDip:Diplomacy = null;
			
			len = this.length;
			
			for (i = 0; i < len; i++)
			{
				gameDip = getObjByIndex(i) as Diplomacy;
				if (gameDip != null && gameDip.endTime < GameManager.gameMgr.gameTime)
					removeObjByID(gameDip.uniqID)
			}
		}
		
	}
}