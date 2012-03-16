package wubao.list
{
	import utils.GameManager;
	import utils.list.GameList;
	
	import wubao.model.Build;
	
	/**
	 * 坞堡建筑列表类 
	 * @author bxl
	 * 
	 */	
	public class BuildList extends GameList
	{
		public function BuildList()
		{
			super();
		}
		
		/**
		 * 获取正在升级中的建筑队列 
		 * @return 
		 * 
		 */		
		public function getUpdateList():BuildList
		{
			var build:Build = null;
			var i:int = 0;
			var len:int = 0;
			var ret:BuildList = new BuildList();
			
			len = this.length;
			
			for (i = 0; i < len; i++)
			{
				build = getObjByIndex(i) as Build;
				if (build.endTime - GameManager.gameMgr.gameTime > 0)
					ret.add(build);
			}
			
			return ret;
		}
		
	}
}