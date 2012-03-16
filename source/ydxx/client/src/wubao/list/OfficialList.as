package wubao.list
{
	import utils.list.GameList;
	
	import wubao.model.Official;

	public class OfficialList extends GameList
	{
		public function OfficialList()
		{
			super();
		}
		
		public function getByUserID(userID:int):Official
		{
			var i:int = 0;
			var len:int = 0;
			var gameOff:Official = null;
			
			len = this.length;
			
			for (i = 0; i < len; i++)
			{
				gameOff = getObjByIndex(i) as Official;
				if (gameOff != null && gameOff.grantID == userID)
					return gameOff;
			}
			
			return null;
		}
		
		/**
		 * 获取官位ID不为0的官位列表 
		 * @return 
		 * 
		 */		
		public function getOffList():OfficialList
		{
			var i:int = 0;
			var len:int = 0;
			var gameOff:Official = null;
			var ret:OfficialList = new OfficialList();
			
			len = this.length;
			
			for (i = 0; i < len; i++)
			{
				gameOff = getObjByIndex(i) as Official;
				if (gameOff != null && gameOff.uniqID != 0)
					ret.add(gameOff);
			}
			
			return ret;
		}
		
		/**
		 * 设置玩家申请官位 
		 * @param offID
		 * @param userID
		 * 
		 */		
		public function setOff(offID:int, userID:int):void
		{
			var gameOff:Official = null;
			
			//把之前已经占据的官位清空
			gameOff = getByUserID(userID);
			if (gameOff != null)
				gameOff.grantID = 0;
			
			//设置当前的官位
			gameOff = getObjByID(offID) as Official;
			if (gameOff != null)
				gameOff.grantID = userID;
		}
		
	}
}