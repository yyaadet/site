package wubao.list
{
	import utils.GameManager;
	import utils.list.GameList;
	
	import wubao.model.UserTreasure;
	
	/**
	 * 玩家的道具列表 
	 * @author bxl
	 * 
	 */	
	public class UserTsList extends GameList
	{
		private var flagList:Array = []; 
		
		public function UserTsList()
		{
			super();
		}
		
		/**
		 * 已集合过的道具列表
		 * @param treasureID
		 * @return 
		 * 
		 */		
		private function isFlag(treasureID:int):Boolean
		{
			var i:int = 0;
			var ret:Boolean = false;
			
			for (i = 0; i < flagList.length; i++)
			{
				if (flagList[i] == treasureID)
				{
					ret = true;
					break;
				}
			}
			
			return ret;
		}
		
		/**
		 * 获取道具的数量
		 * @param treasureID
		 * @return 
		 * 
		 */		
		private function getTreasureNum(treasureID:int):int
		{
			var i:int = 0;
			var ret:int = 0;
			var treasure:UserTreasure = null;
			
			for (i = 0; i < this.length; i++)
			{
				treasure = getObjByIndex(i) as UserTreasure;
				if (treasure != null && treasure.treasureID == treasureID && treasure.isUsed == 0 && treasure.generalID == 0)
					ret ++;
			}
			
			return ret;
		}
		
		/**
		 * 玩家拥有的所有道具集合在一起，并显示数量
		 * 返回新的道具列表 
		 * @param type
		 * @return 
		 * 
		 */		
		public function getAllBagInfo():UserTsList
		{
			var i:int = 0;
			var ut:UserTreasure = null;
			var ut1:UserTreasure = null;
			var bag:UserTsList = new UserTsList();
			
			bag.removeAll();
			flagList.length = 0;
			
			for (i = 0; i < this.length; i++)
			{
				ut = getObjByIndex(i) as UserTreasure;
				if (ut != null && ut.generalID == 0 && ut.isUsed == 0 && 
				    ut.userID == GameManager.gameMgr.userID && !isFlag(ut.treasureID))
				{
					ut1 = new UserTreasure();
					ut1.update(ut);
					ut1.num = getTreasureNum(ut.treasureID);
					ut1.treasure = ut.treasure;
					bag.add(ut1);
					flagList.push(ut.treasureID);
				}
			}
			
			return bag;
		}
		
		/**
		 * 玩家拥有的且能赐予武将的所有道具集合在一起，并显示数量
		 * 返回新的道具列表 
		 * @param type
		 * @return 
		 * 
		 */		
		public function getAllGeneralBagInfo():UserTsList
		{
			var i:int = 0;
			var ut:UserTreasure = null;
			var ut1:UserTreasure = null;
			var bag:UserTsList = new UserTsList();
			
			bag.removeAll();
			flagList.length = 0;
			
			for (i = 0; i < this.length; i++)
			{
				ut = getObjByIndex(i) as UserTreasure;
				if (ut != null && (ut.treasure.type <= 4 || ut.treasure.type == 7) && ut.generalID == 0 && ut.isUsed == 0 && 
				    ut.userID == GameManager.gameMgr.userID && !isFlag(ut.treasureID))
				{
					ut1 = new UserTreasure();
					ut1.update(ut);
					ut1.num = getTreasureNum(ut.treasureID);
					ut1.treasure = ut.treasure;
					bag.add(ut1);
					flagList.push(ut.treasureID);
				}
			}
			
			return bag;
		}
		
		/**
		 * 玩家拥有的道具中把同样的道具集合在一起，并显示数量(前五种道具)
		 * 返回新的道具列表 
		 * @param type
		 * @return 
		 * 
		 */		
		public function getBagInfo(type:int = 0):UserTsList
		{
			var i:int = 0;
			var ut:UserTreasure = null;
			var ut1:UserTreasure = null;
			var bag:UserTsList = new UserTsList();
			
			bag.removeAll();
			flagList.length = 0;
			
			for (i = 0; i < this.length; i++)
			{
				ut = getObjByIndex(i) as UserTreasure;
				if (ut != null && ut.treasure.type == type && ut.generalID == 0 &&
				    ut.isUsed == 0 && ut.userID == GameManager.gameMgr.userID && !isFlag(ut.treasureID))
				{
					ut1 = new UserTreasure();
					ut1.update(ut);
					ut1.num = getTreasureNum(ut.treasureID);
					ut1.treasure = ut.treasure;
					bag.add(ut1);
					flagList.push(ut.treasureID);
				}
			}
			
			return bag;
		}
		
		/**
		 * 玩家拥有的道具中把同样的道具集合在一起，并显示数量(特殊道具)
		 * 返回新的道具列表 
		 * @param type
		 * @return 
		 * 
		 */		
		public function getOtherBagInfo(type:int = 0):UserTsList
		{
			var i:int = 0;
			var ut:UserTreasure = null;
			var ut1:UserTreasure = null;
			var bag:UserTsList = new UserTsList();
			
			bag.removeAll();
			flagList.length = 0;
			
			for (i = 0; i < this.length; i++)
			{
				ut = getObjByIndex(i) as UserTreasure;
				if (ut != null && ut.treasure.type >= type && ut.generalID == 0 &&
				    ut.isUsed == 0 && ut.userID == GameManager.gameMgr.userID && !isFlag(ut.treasureID))
				{
					ut1 = new UserTreasure();
					ut1.update(ut);
					ut1.num = getTreasureNum(ut.treasureID);
					ut1.treasure = ut.treasure;
					bag.add(ut1);
					flagList.push(ut.treasureID);
				}
			}
			
			return bag;
		}
		
		/**
		 * 获取某种道具中的一个 
		 * @param type
		 * @return 
		 * 
		 */		
		public function getOneTreasure(type:int, treasureID:int = 0):UserTreasure
		{
			var i:int = 0;
			var ret:UserTreasure = null;
			
			for (i = 0; i < this.length; i++)
			{
				ret = getObjByIndex(i) as UserTreasure;
				if (ret.treasure.type == type && ret.isUsed == 0 && ret.generalID <= 0)
				{
					if (treasureID > 0)
					{
						if (ret.treasureID == treasureID)
							return ret;
					}
					else
					{
						return ret;
					}
				}
			}
			
			return null;
		}
		
		/**
		 * 获取武将拥有的道具 
		 * @param type
		 * @param generalID
		 * @return 
		 * 
		 */		
		public function getByGeneral(type:int, generalID:int):UserTreasure
		{
			var i:int = 0;
			var ret:UserTreasure = null;
			
			for (i = 0; i < this.length; i++)
			{
				ret = getObjByIndex(i) as UserTreasure;
				if (ret.treasure.type == type && ret.generalID == generalID && 
				    ret.isUsed == 1 && ret.userID == GameManager.gameMgr.userID)
					return ret;
			}
			
			return null;
		}
		
		/**
		 * 设置道具为已使用状态 
		 * @param treasureID
		 * @param generalID
		 * 
		 */		
		public function setUsed(treasureID:int, generalID:int):void
		{
			var ut:UserTreasure = null;
			
			ut = getObjByID(treasureID) as UserTreasure;
			if (ut != null)
			{
				ut.isUsed = 1;
				ut.generalID = generalID;
			}
		}
		
	}
}