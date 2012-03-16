package shop.list
{
	import shop.model.Treasure;
	
	import utils.list.GameList;

	/**
	 * 商店的道具列表 
	 * @author bxl
	 * 
	 */	
	public class TreasureList extends GameList
	{
		public function TreasureList()
		{
			super();
		}
		
		/**
		 * 根据类型获取道具列表(前五种道具) 
		 * @param type
		 * @return 
		 * 
		 */		
		public function getTreasureList(type:int):TreasureList
		{
			var treasureList:TreasureList = new TreasureList();;
			var i:int = 0;
			var treasure:Treasure = null;
			var len:int = this.length;
			
			for (i = 0; i < len; i++)
			{
				treasure = getObjByIndex(i) as Treasure;
				if (treasure != null && treasure.type == type)
					treasureList.add(treasure);
			}
			
			return treasureList;
		}
		
		/**
		 * 获取其他类型道具列表(特殊道具)
		 * @param type
		 * @return 
		 * 
		 */		
		public function getOtherList(type:int):TreasureList
		{
			var treasureList:TreasureList = new TreasureList();;
			var i:int = 0;
			var treasure:Treasure = null;
			var len:int = this.length;
			
			for (i = 0; i < len; i++)
			{
				treasure = getObjByIndex(i) as Treasure;
				if (treasure != null && treasure.type >= type)
					treasureList.add(treasure);
			}
			
			return treasureList;
		}
		
	}
}