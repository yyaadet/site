package task.list
{
	import task.model.Task;
	
	import utils.GameManager;
	import utils.PubUnit;
	import utils.list.GameList;
	
	import wubao.model.User;

	/**
	 * 任务列表 
	 * @author bxl
	 * 
	 */	
	public class TaskList extends GameList
	{
		//新手任务列表
		private var _beginList:Array = [];
		
		public function TaskList()
		{
			super();
		}
		
		/**
		 * 获取新手任务列表
		 * @return 
		 * 
		 */		
		public function getBeginLen():void
		{
			var i:int = 0;
			var len:int = 0;
			var gameTask:Task = null;
			
			beginList.length = 0;
			len = this.length;
			
			for (i = 0; i < len; i++)
			{
				gameTask = getObjByIndex(i) as Task;
				
				if (gameTask.uniqID <= 100)
					beginList.push(gameTask);
			} 
		}
		
		/**
		 * 获取新手任务当前应该显示的任务列表 
		 * @return 
		 * 
		 */		
		public function getBeginShow():TaskList
		{
			var i:int = 0;
			var len:int = 0;
			var gameTask:Task = null;
			var ret:TaskList = new TaskList();
			
			len = this.length;
			var gameUser:User = GameManager.gameMgr.user;
			
			for (i = 0; i < len; i++)
			{
				gameTask = getObjByIndex(i) as Task;
				if (gameTask.uniqID > 200) continue;
				
				//玩家还没完成任何任务
				if (gameUser.finishTask.length < 1)
				{
					ret.add(gameTask);
					break;
				}
				
				if (PubUnit.isObjInArray(gameTask.uniqID, gameUser.finishTask))
					ret.add(gameTask);
				
				if (PubUnit.isObjInArray(gameTask.beforeID, gameUser.finishTask))
					ret.add(gameTask);
			} 
			
			return ret;
		}
		
		/**
		 * 获取成长任务
		 * @return 
		 * 
		 */		
		public function getGrowShow():TaskList
		{
			var i:int = 0;
			var len:int = 0;
			var gameTask:Task = null;
			var ret:TaskList = new TaskList();
			
			len = this.length;
			var gameUser:User = GameManager.gameMgr.user;
			
			for (i = 0; i < len; i++)
			{
				gameTask = getObjByIndex(i) as Task;
				if (gameTask.uniqID <= 200) continue;
				if (PubUnit.isObjInArray(gameTask.uniqID, gameUser.finishTask)) continue;
				
				if (gameTask.beforeID == 0 || PubUnit.isObjInArray(gameTask.beforeID, gameUser.finishTask))
					ret.add(gameTask);
			} 
			
			return ret;
		}
		
		public function get beginList():Array
		{
			return _beginList;
		}
		
		public function set beginList(param:Array):void
		{
			_beginList = param;
		}
	}
}