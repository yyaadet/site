package task.model
{
	import utils.GameManager;
	import utils.PubUnit;
	
	import wubao.model.User;
	
	/**
	 * 任务 
	 * @author bxl
	 * 
	 */	
	public class Task
	{
		public static const BONUS:Array = ["声望", "粮食", "木料", "矿石", "马匹", "皮革", "钱币", "金币"]; 
		
		//升级议事堂
		public static const UP_YST:int = 2;
		
		//生产200剑
		public static const MADE:int = 16;
		
		//强化100剑
		public static const UP_WEAPON:int = 17;
		
		//笃学不倦，学习长蛇阵
		public static const XIU:int = 19;
		
		//配兵
		public static const FIT:int = 21;
		
		//任务ID
		private var _uniqID:int = 0;
		
		//前提任务ID
		private var _beforeID:int = 0;
		
		//标题
		private var _title:String = "";
		
		//说明
		private var _info:String = "";
		
		//指引
		private var _guid:String = "";
		
		//目标
		private var _target:String = "";
		
		//类型
		private var _type:int = 0;
		
		//值1
		private var _value1:int = 0;
		
		//值2
		private var _value2:int = 0;
		
		//值3
		private var _value3:int = 0;
		
		//奖励
		//声望 粮 木 矿 马 皮 钱 金币
		private var _bonus:Array = [];
		
		//当前状态
		//0--未接收  1--已接收但未完成  2--完成但未领取奖励   3--已领取奖励 
		private var _state:int = 0;
		
		public function Task()
		{
			
		}
		
		public function get uniqID():int
		{
			return _uniqID;
		}
		
		public function set uniqID(param:int):void
		{
			_uniqID = param;
		}

		public function get beforeID():int
		{
			return _beforeID;
		}
		
		public function set beforeID(param:int):void
		{
			_beforeID = param;
		}

		public function get title():String
		{
			return _title;
		}
		
		public function set title(param:String):void
		{
			_title = param;
		}

		public function get info():String
		{
			return _info;
		}
		
		public function set info(param:String):void
		{
			_info = param;
		}

		public function get guid():String
		{
			return _guid;
		}
		
		public function set guid(param:String):void
		{
			_guid = param;
		}

		public function get target():String
		{
			return _target;
		}
		
		public function set target(param:String):void
		{
			_target = param;
		}

		public function get type():int
		{
			return _type;
		}
		
		public function set type(param:int):void
		{
			_type = param;
		}

		public function get value1():int
		{
			return _value1;
		}
		
		public function set value1(param:int):void
		{
			_value1 = param;
		}

		public function get value2():int
		{
			return _value2;
		}
		
		public function set value2(param:int):void
		{
			_value2 = param;
		}

		public function get value3():int
		{
			return _value3;
		}
		
		public function set value3(param:int):void
		{
			_value3 = param;
		}

		public function get bonus():Array
		{
			return _bonus;
		}
		
		public function set bonus(param:Array):void
		{
			_bonus = param;
		}

		public function get state():int
		{
			var gameUser:User = GameManager.gameMgr.user;
			
			//任务已完成并领取奖励
			if (PubUnit.isObjInArray(uniqID, gameUser.finishTask))
				_state = 3;
			else
			{
				//任务已接收但未领取奖励
				if (uniqID == gameUser.taskID)
				{
					//任务接收但未完成
					if (gameUser.taskState == 0)
						_state = 1;
					//任务接收并完成
					else
						_state = 2;
				}
				//任务未接收
				else
					_state = 0;
			}
			
			return _state;
			
		}
		
		public function set state(param:int):void
		{
			_state = param;
		}

	}
}