package deal.list
{
	import deal.model.Bill;
	
	import utils.GameManager;
	import utils.list.GameList;
	
	/**
	 * 挂单列表 
	 * @author bxl
	 * 
	 */	
	public class BillList extends GameList
	{
		public function BillList()
		{
			super();
		}
		
		/**
		 * 获取挂单列表 
		 * @param type   挂单类型   1--买  2--卖
		 * @param resType  资源类型
		 * @return 
		 * 
		 */		
		public function getList(type:int, resType:int):BillList
		{
			var i:int = 0;
			var len:int = 0;
			var ary1:Array = [];
			var gameBill:Bill = null;
			var ret:BillList = new BillList();
			
			//买盘，高价排前
			if (type == 1)
				ary1 = this.list.sortOn("price", Array.DESCENDING | Array.NUMERIC);
			//卖盘，低价排前	
			else if (type == 2)
				ary1 = this.list.sortOn("price", Array.NUMERIC);
			len = ary1.length;
			
			for (i = 0; i < len; i++)
			{
				gameBill = ary1[i] as Bill;
				if (gameBill != null && gameBill.type == type && gameBill.resType == resType)
					ret.add(gameBill);
			}
			
			return ret;
		}
		
		/**
		 * 获取自己发布的挂单 
		 * @return 
		 * 
		 */		
		public function getSelfList():BillList
		{
			var i:int = 0;
			var len:int = 0;
			var gameBill:Bill = null;
			var ret:BillList = new BillList();
			
			len = this.length;
			
			for (i = 0; i < len; i++)
			{
				gameBill = getObjByIndex(i) as Bill;
				if (gameBill != null && gameBill.userID == GameManager.gameMgr.userID)
					ret.add(gameBill);
			}
			
			return ret;
		}
		
	}
}