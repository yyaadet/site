package sphere.list
{
	import sphere.model.Sphere;
	
	import utils.PubUnit;
	import utils.list.GameList;
	
	/**
	 * 势力列表 
	 * @author bxl
	 * 
	 */	
	public class SphereList extends GameList
	{
		public function SphereList()
		{
			super();
		}
		
		/**
		 * 将所有势力按威望排序 
		 * @return 
		 * 
		 */		
		public function getRank():SphereList
		{
			var ret:SphereList = new SphereList();
			var ary1:Array = [];
			var i:int = 0;
			var rank:int = 0;
			var len:int = 0;
			var gameSphere:Sphere = null;
			
			ary1 = this.list.sortOn("prestige", Array.DESCENDING | Array.NUMERIC);
			len = ary1.length;
			
			for (i = 0; i < len; i++)
			{
				gameSphere = ary1[i] as Sphere;
				
				//if (gameSphere.uniqID <= 21) continue;
				//if (gameSphere.userNum <= 0) continue;
				if (gameSphere.prestige < 0) continue;
				
				rank ++;
				gameSphere.rank = rank;
				ret.add(gameSphere);
			}
			
			return ret;
		}
		
		/**
		 * 将玩家势力按威望排序 
		 * @return 
		 * 
		 */		
		public function getUserRank():SphereList
		{
			var ret:SphereList = new SphereList();
			var ary1:Array = [];
			var i:int = 0;
			var rank:int = 0;
			var len:int = 0;
			var gameSphere:Sphere = null;
			
			ary1 = this.list.sortOn("prestige", Array.DESCENDING | Array.NUMERIC);
			len = ary1.length;
			
			for (i = 0; i < len; i++)
			{
				gameSphere = ary1[i] as Sphere;
				
				if (gameSphere.uniqID <= 21) continue;
				if (gameSphere.prestige < 0) continue;
				
				rank ++;
				gameSphere.rank = rank;
				ret.add(gameSphere);
			}
			
			return ret;
		}
		
		/**
		 * 搜索势力 
		 * @return 
		 * 
		 */		
		public function getSearch(sphereName:String):SphereList
		{
			var ret:SphereList = new SphereList();
			var ary1:Array = [];
			var i:int = 0;
			var len:int = 0;
			var gameSphere:Sphere = null;
			
			ary1 = this.list.sortOn("uniqID", Array.DESCENDING | Array.NUMERIC);
			len = ary1.length;
			
			for (i = 0; i < len; i++)
			{
				gameSphere = ary1[i] as Sphere;
				
				if (gameSphere.sphereName.indexOf(sphereName) >= 0)
					ret.add(gameSphere);
			}
			
			return ret;
		}
		
		/**
		 * 判断用户是否是势力的君主 
		 * @param userID
		 * @return 
		 * 
		 */		
		public function isLeader(userID:int):Boolean
		{
			var i:int = 0;
			var len:int = this.length;
			var gameSphere:Sphere = null;
			
			for (i = 0; i < len; i++)
			{
				gameSphere = getObjByIndex(i) as Sphere;
				if (gameSphere != null && gameSphere.userID == userID)
					return true;
			}
			
			return false;
		}
		
		/**
		 * 所有的势力随即生成颜色，用于势力分布图显示 
		 * 
		 */		
		public function randomColor():void
		{
			var i:int = 0;
			var len:int = this.length;
			var gameSphere:Sphere = null;
			var random:uint = 0; 
			var seed:int = 9073737;
			var red:uint = 0;
			var green:uint = 0;
			var blue:uint = 0;
			
			for (i = 0; i < len; i++)
			{
				gameSphere = getObjByIndex(i) as Sphere;
				red = (seed * gameSphere.uniqID) >> 0 & 0xFF;
				green = (seed * gameSphere.uniqID) >> 14 & 0xFF;
				blue = (seed * gameSphere.uniqID) >> 6 & 0xFF;
				
				random = red * 255 * 255 + green * 255 + blue;
				gameSphere.mapColor = random;
			}
		}
		
		
	}
}