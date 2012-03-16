package wubao.list
{
	import sphere.list.DipList;
	
	import utils.GameManager;
	import utils.list.GameList;
	
	import wubao.model.User;
	import wubao.model.WuBao;
	
	/**
	 * 用户列表 
	 * @author bxl
	 * 
	 */	
	public class UserList extends GameList
	{
		public function UserList()
		{
			super();
		}
		
		/**
		 * 根据用户名称获取用户信息 
		 * @param userName
		 * @return 
		 * 
		 */		
		public function getUserByName(userName:String):User
		{
			var i:int = 0;
			var gameUser:User = null;
			var len:int = 0;
			
			len = this.length;
			
			for (i = 0; i < len; i++)
			{
				gameUser = getObjByIndex(i) as User;
				if (gameUser != null && gameUser.userName == userName)
					return gameUser;
			}
			
			return null;
		}
		
		/**
		 * 将用户按排名排序
		 * @param userNum 用户数 0--全部获取
		 * @return 
		 * 
		 */		
		public function getRank(userNum:int = 0):UserList
		{
			var i:int = 0;
			var ary1:Array = [];
			var gameUser:User = null;
			var len:int = 0;
			var ret:UserList = new UserList();
			var count:int = 0;
			
			ary1 = this.list.sortOn("rank", Array.NUMERIC);
			len = ary1.length;
			
			for (i = 0; i < len; i++)
			{
				gameUser = ary1[i] as User;
				
				if (gameUser.wubaoID > 0 && gameUser.rank > 0)
				{
					count ++;
					ret.add(gameUser);
					
					if (userNum > 0 && count >= userNum) break;
				}
			}
			
			return ret;
		}
		
		/**
		 * 将用户按声望排序
		 * @param userNum 用户数 0--全部获取
		 * @return 
		 * 
		 */		
		public function getRank1(userNum:int = 0):UserList
		{
			var i:int = 0;
			var ary1:Array = [];
			var gameUser:User = null;
			var len:int = 0;
			var ret:UserList = new UserList();
			var count:int = 0;
			
			ary1 = this.list.sortOn("prestige", Array.NUMERIC | Array.DESCENDING);
			len = ary1.length;
			
			for (i = 0; i < len; i++)
			{
				gameUser = ary1[i] as User;
				
				if (gameUser.wubaoID > 0 && !gameUser.isClose)
				{
					count ++;
					gameUser.rank1 = count;
					ret.add(gameUser);
					
					if (userNum > 0 && count >= userNum) break;
				}
			}
			
			return ret;
		}
		
		/**
		 * 获取玩家总人数
		 * @return 
		 * 
		 */		
		public function getUserTotal():int
		{
			var i:int = 0;
			var gameUser:User = null;
			var count:int = 0;
			var len:int = 0;
			
			len = this.length;
			for (i = 0; i < len; i++)
			{
				gameUser = getObjByIndex(i) as User;
				
				if (gameUser.wubaoID > 0)
					count ++;
			}
			
			return count;
		}
		
		/**
		 * 将用户按声望排序(势力界面的成员列表)
		 * @param userNum 用户数 0--全部获取
		 * @return 
		 * 
		 */		
		public function getListByPrestige(userNum:int = 0):UserList
		{
			var i:int = 0;
			var ary1:Array = [];
			var gameUser:User = null;
			var len:int = 0;
			var ret:UserList = new UserList();
			var count:int = 0;
			
			ary1 = this.list.sortOn("prestige", Array.NUMERIC | Array.DESCENDING);
			len = ary1.length;
			
			for (i = 0; i < len; i++)
			{
				gameUser = ary1[i] as User;
				
				if (gameUser.wubaoID > 0)
				{
					count ++;
					ret.add(gameUser);
					
					if (userNum > 0 && count >= userNum) break;
				}
			}
			
			return ret;
		}
		
		/**
		 * 获取可以掠夺的用户列表
		 * @return 
		 * 
		 */		
		public function getRobUser():UserList
		{
			var i:int = 0;
			var ary1:Array = [];
			var gameUser:User = null;
			var len:int = 0;
			var self:User = GameManager.gameMgr.user;
			var gameWubao:WuBao = GameManager.gameMgr.wubao;
			var dipList:DipList = GameManager.gameMgr.dipList;
			var ret:UserList = new UserList();
			
			ary1 = this.list.sortOn("prestige", Array.NUMERIC);
			len = ary1.length;
			
			for (i = 0; i < len; i++)
			{
				gameUser = ary1[i] as User;
				if (gameUser.uniqID == self.uniqID || gameUser.digID != self.digID || self.digID == 0 || gameUser.isClose ||
				   (gameUser.sphereID > 0 && gameUser.sphereID == gameWubao.sphereID) || dipList.isAlli(gameWubao.sphereID, gameUser.sphereID))
					continue;
				
				if (gameUser.wubaoID > 0)
					ret.add(gameUser);
			}
			
			return ret;
		}
		
		/**
		 * 获取城池中的玩家列表 
		 * @param cityID
		 * @return 
		 * 
		 */		
		public function getListByCity(cityID:int):UserList
		{
			var i:int = 0;
			var gameUser:User = null;
			var len:int = 0;
			var ret:UserList = new UserList();
			
			len = this.length;
			
			for (i = 0; i < len; i++)
			{
				gameUser = getObjByIndex(i) as User;
				if (gameUser != null && gameUser.cityID == cityID && gameUser.wubaoID > 0 && !gameUser.isClose)
					ret.add(gameUser);
			}
			
			return ret;
		}
		
		/**
		 * 根据名称搜索用户
		 * @return 
		 * 
		 */		
		public function getSearch(userName:String):UserList
		{
			var i:int = 0;
			var gameUser:User = null;
			var len:int = 0;
			var ret:UserList = new UserList();
			
			len = this.length;
			
			for (i = 0; i < len; i++)
			{
				gameUser = getObjByIndex(i) as User;
				
				if (gameUser != null && gameUser.userName.indexOf(userName) >= 0)
					ret.add(gameUser);
			}
			
			return ret;
		}
		
	}
}