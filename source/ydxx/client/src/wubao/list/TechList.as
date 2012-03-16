package wubao.list
{
	import utils.GameManager;
	import utils.list.GameList;
	
	import wubao.model.Tech;
	
	/**
	 * 坞堡科技列表 
	 * @author bxl
	 * 
	 */	
	public class TechList extends GameList
	{
		public function TechList()
		{
			super();
		}
		
		/**
		 * 获取装备技术列表 
		 * @return 
		 * 
		 */		
		public function getWeaponList():TechList
		{
			var i:int = 0;
			var len:int = 0;
			var tech:Tech = null;
			var ret:TechList = new TechList();
			
			len = this.length;
			
			for (i = 0; i < len; i++)
			{
				tech = getObjByIndex(i) as Tech;
				if (tech != null && tech.type <= 9)
					ret.add(tech);
			}
			
			return ret;
		}
		
		/**
		 * 获取资源技术列表 
		 * @return 
		 * 
		 */		
		public function getResList():TechList
		{
			var i:int = 0;
			var len:int = 0;
			var tech:Tech = null;
			var ret:TechList = new TechList();
			
			len = this.length;
			
			for (i = 0; i < len; i++)
			{
				tech = getObjByIndex(i) as Tech;
				if (tech != null && tech.type > 9 && tech.type <=15 )
					ret.add(tech);
			}
			
			return ret;
		}
		
		/**
		 * 获取正在升级中的科技
		 * @return 
		 * 
		 */		
		public function getUpdate():Tech
		{
			var i:int = 0;
			var len:int = 0;
			var tech:Tech = null;
			
			len = this.length;
			
			for (i = 0; i < len; i++)
			{
				tech = getObjByIndex(i) as Tech;
				if (tech != null && tech.endTime - GameManager.gameMgr.gameTime > 0)
					return tech;
			}
			
			return null;
		}
		
	}
}