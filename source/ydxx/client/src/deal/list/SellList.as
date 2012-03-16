package deal.list
{
	import deal.model.Sell;
	
	import utils.GameManager;
	import utils.list.GameList;
	
	/**
	 * 出售装备列表 
	 * @author bxl
	 * 
	 */	
	public class SellList extends GameList
	{
		public function SellList()
		{
			super();
		}
		
		/**
		 * 获取市场上的装备（不包含自己出售的装备） 
		 * @return 
		 * 
		 */		
		public function getList():SellList
		{
			var i:int = 0;
			var len:int = 0;
			var gameSell:Sell = null;
			var ret:SellList = new SellList();
			
			len = this.length;
			
			for (i = 0; i < len; i++)
			{
				gameSell = getObjByIndex(i) as Sell;
				if (gameSell != null && gameSell.userID != GameManager.gameMgr.userID)
					ret.add(gameSell);
			}
			
			return ret;
		}
		
		/**
		 * 获取自己出售的装备 
		 * @return 
		 * 
		 */		
		public function getSelfList():SellList
		{
			var i:int = 0;
			var len:int = 0;
			var gameSell:Sell = null;
			var ret:SellList = new SellList();
			
			len = this.length;
			
			for (i = 0; i < len; i++)
			{
				gameSell = getObjByIndex(i) as Sell;
				if (gameSell != null && gameSell.userID == GameManager.gameMgr.userID)
					ret.add(gameSell);
			}
			
			return ret;
		}
		
		/**
		 * 根据名称搜索装备
		 * @return 
		 * 
		 */		
		public function getSearch(weaponName:String):SellList
		{
			var i:int = 0;
			var len:int = 0;
			var gameSell:Sell = null;
			var ret:SellList = new SellList();
			
			len = this.length;
			
			for (i = 0; i < len; i++)
			{
				gameSell = getObjByIndex(i) as Sell;
				if (gameSell != null && gameSell.typeName.indexOf(weaponName) >= 0)
					ret.add(gameSell);
			}
			
			return ret;
		}
	}
}