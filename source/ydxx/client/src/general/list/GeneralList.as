package general.list
{
	import general.model.General;
	
	import utils.GameManager;
	import utils.list.GameList;
	
	/**
	 * 武将列表 
	 * @author bxl
	 * 
	 */	
	public class GeneralList extends GameList
	{
		public function GeneralList()
		{
			super();
		}
		
		/**
		 * 获取自己的武将 
		 * @return 
		 * 
		 */		
		public function getSelfGeneral():GeneralList
		{
			var i:int = 0;
			var len:int = 0;
			var gameGeneral:General = null;
			var ret:GeneralList = new GeneralList();
			
			len = this.length;
			for (i = 0; i < len; i++)
			{
				gameGeneral = getObjByIndex(i) as General;
				if (gameGeneral != null && gameGeneral.userID == GameManager.gameMgr.userID)
					ret.add(gameGeneral);
			}
			
			return ret;
		}
		
		/**
		 * 获取可以拜访结交的武将 
		 * @return 
		 * 
		 */		
		public function getVisitList():GeneralList
		{
			var i:int = 0;
			var len:int = 0;
			var gameGeneral:General = null;
			var ret:GeneralList = new GeneralList();
			
			len = this.length;
			for (i = 0; i < len; i++)
			{
				gameGeneral = getObjByIndex(i) as General;
				if (gameGeneral != null && gameGeneral.initYear <= GameManager.gameMgr.gameYear)
					ret.add(gameGeneral);
			}
			
			return ret;
		}
		
		/**
		 * 获取坞堡或城池中可以出征的武将  
		 * @return 
		 * 
		 */		
		public function getMarchList():GeneralList
		{
			var i:int = 0;
			var len:int = 0;
			var gameGeneral:General = null;
			var ret:GeneralList = new GeneralList();
			
			len = this.length;
			for (i = 0; i < len; i++)
			{
				gameGeneral = getObjByIndex(i) as General;
				if (gameGeneral != null && (gameGeneral.place == 1 || gameGeneral.place == 2) && 
				    gameGeneral.userID == GameManager.gameMgr.userID && gameGeneral.soliderTotal > 0)
					ret.add(gameGeneral);
			}
			
			return ret;
		}
		
		/**
		 * 获取属于势力的武将数目 
		 * @param sphereID
		 * @return 
		 * 
		 */		
		public function getSphereGenList(sphereID:int):GeneralList
		{
			var i:int = 0;
			var len:int = 0;
			var gameGeneral:General = null;
			var ret:GeneralList = new GeneralList();
			
			len = this.length;
			for (i = 0; i < len; i++)
			{
				gameGeneral = getObjByIndex(i) as General;
				if (gameGeneral != null && gameGeneral.place == 2 && gameGeneral.isInSphere(sphereID))
					ret.add(gameGeneral);
			}
			
			return ret;
		}
		
		/**
		 * 获取有伤兵的武将 
		 * @return 
		 * 
		 */		
		public function getHurtList():GeneralList
		{
			var i:int = 0;
			var len:int = 0;
			var gameGeneral:General = null;
			var ret:GeneralList = new GeneralList();
			
			len = this.length;
			for (i = 0; i < len; i++)
			{
				gameGeneral = getObjByIndex(i) as General;
				if (gameGeneral != null && gameGeneral.hurtNum > 0 && gameGeneral.userID == GameManager.gameMgr.userID)
				{
					ret.add(gameGeneral);
				}
			}
			
			return ret;
		}
		
		/**
		 * 获取属于势力的所有武将的士卒之和
		 * @param sphereID
		 * @return 
		 * 
		 */		
		public function getTotalSolider(sphereID:int):Number
		{
			var i:int = 0;
			var len:int = 0;
			var gameGeneral:General = null;
			var ret:int = 0;
			
			len = this.length;
			for (i = 0; i < len; i++)
			{
				gameGeneral = getObjByIndex(i) as General;
				if (gameGeneral != null && gameGeneral.soliderNum > 0 && gameGeneral.place == 2 && gameGeneral.isInSphere(sphereID))
					ret += gameGeneral.soliderNum;
			}
			
			return ret;
		}
		
		/**
		 * 获取在城池中的所有武将的伤兵之和
		 * @param sphereID
		 * @return 
		 * 
		 */		
		public function getTotalHurt(sphereID:int):Number
		{
			var i:int = 0;
			var len:int = 0;
			var gameGeneral:General = null;
			var ret:int = 0;
			
			len = this.length;
			for (i = 0; i < len; i++)
			{
				gameGeneral = getObjByIndex(i) as General;
				if (gameGeneral != null && gameGeneral.hurtNum > 0 && gameGeneral.place == 2 && gameGeneral.isInSphere(sphereID))
					ret += gameGeneral.hurtNum;
			}
			
			return ret;
		}
		
		/**
		 * 获取可以训练的武将 
		 * @return 
		 * 
		 */		
		public function getViewList():GeneralList
		{
			var i:int = 0;
			var len:int = 0;
			var ret:GeneralList = new GeneralList();
			var gameGeneral:General = null;
			
			len = this.length;
			for (i = 0; i < len; i++)
			{
				gameGeneral = getObjByIndex(i) as General;
				if (gameGeneral.userID == GameManager.gameMgr.userID &&
				   (gameGeneral.place == 1 || gameGeneral.place == 2))
					ret.add(gameGeneral);
			}
			
			return ret;
		}
		
	    /**
		 * 获取所有的历史名将 
		 * @return 
		 * 
		 */		
		public function getNamedList():GeneralList
		{
			var i:int = 0;
			var len:int = 0;
			var ret:GeneralList = new GeneralList();
			var gameGeneral:General = null;
			var ary1:Array = [];
			
			ary1 = this.list.sortOn("friend", Array.DESCENDING | Array.NUMERIC);
			len = ary1.length;
			for (i = 0; i < len; i++)
			{
				gameGeneral = ary1[i] as General;
				if (gameGeneral.type == 1 && gameGeneral.uniqID <= 656)
					ret.add(gameGeneral);
			}
			
			return ret;
		}
		
	    /**
		 * 搜索名将，根据名称
		 * @return 
		 * 
		 */		
		public function getSearchList(generalName:String):GeneralList
		{
			var i:int = 0;
			var len:int = 0;
			var ret:GeneralList = new GeneralList();
			var gameGeneral:General = null;
			
			len = this.length;
			for (i = 0; i < len; i++)
			{
				gameGeneral = getObjByIndex(i) as General;
				if (gameGeneral.generalName.indexOf(generalName) >= 0 && gameGeneral.type == 1 && gameGeneral.uniqID <= 656)
					ret.add(gameGeneral);
			}
			
			return ret;
		}
	}
}