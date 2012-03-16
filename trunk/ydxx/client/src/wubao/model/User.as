package wubao.model
{
	import city.model.City;
	
	import general.model.General;
	import general.model.Zhen;
	
	import sphere.list.SphereList;
	import sphere.model.Sphere;
	
	import task.model.Task;
	
	import utils.GameManager;
	import utils.PubUnit;
	
	/**
	 * 用户 
	 * @author StarX
	 * 
	 */	
	public class User
	{
		//用户ID
		private var _uniqID:int = 0;
		
		//等级
		private var _level:int = 0;
		
		//坞堡ID
		private var _wubaoID:int = 0;
		
		//城池ID
		private var _cityID:int = 0;
		
		//所在
		private var _place:String = "";
		
		//势力ID
		private var _sphereID:int = 0;
		
		//势力名称
		private var _sphereName:String = "无";

		//实力排名
		private var _rank:int = 0;
		
		//声望排名
		private var _rank1:int = 0;
		
		//实力排名字符
		private var _rankName:String = "";
		
		//实力排名颜色
		private var _rankColor:uint = 0;
		
		//实力排名颜色(聊天)
		private var _rankColor1:String = "";
		
		//姓名
		private var _userName:String = "";

		//声望
		private var _prestige:int = 0;
		
		//功勋
		private var _gong:int = 0;
		
		//爵位
		private var _digID:int = 0;
		
		//爵位名称
		private var _digName:String = "";
		
		//官位
		private var _offID:int = 0;
		
		//官位名称
		private var _offName:String = "无";
		
		//是否是势力的君主
		private var _isLeader:Boolean = false;
		
		//是否是GM
		private var _isGM:Boolean = false;
		
		//最后上线时间戳
		private var _lastLogin:int = 0;
		
		//最后上线游戏时间
		private var _lastLoginStr:String = "";
		
		//充值金币
		private var _chong:int = 0;
		
		//赠送金币
		private var _give:int = 0;
		
		//当前可使用虚拟币数量
		private var _money:int = 0;

		//累计消费的虚拟币数量
		private var _consume:int = 0;
		
		//是否在线 0：否，1：是
		private var _isOnline:int = 0;
		
		private var _isOnlineStr:String = "";
		
		//是否VIP
		private var _isVip:Boolean = false; 

		//vip总时间
		private var _vipTotal:int = 0;
		
		//vip使用时间
		private var _vipUsed:int = 0;
		
		//是否设置了金币锁
		private var _isLock:Boolean = false;
		
		//设置金币锁的问题类型
		private var _quesType:int = 0;
		
		//正在进行中的任务ID
		//ID > 0 任务已经接收，但未领取奖励
		//ID <= 0 任务未接收
		private var _taskID:int = 0;
		
		//当前任务状态  0--未完成 1--已完成
		private var _taskState:int = 0;
		
		//已经完成的任务ID列表
		private var _finishTask:Array = [];
		
		//军令CD
		private var _orderCD:int = 0;
		
		//剩余军令
		private var _leftOrder:int = 0;
		
		//训练CD
		private var _trainCD:int = 0;
		
		//功勋卡使用次数
		private var _preCount:int = 0;
		
		//被掠夺次数
		private var _robCount:int = 0;
		
		//当前关卡ID
		private var _gateID:int = 1;
		
		//账号是否关闭
		private var _isClose:Boolean = false;
		
		//新手指引索引
		private var _guidIndex:int = 0;
		
		public function User()
		{
			
		}
		
		/**
		 * 判断升级议事堂是否需要新手指引 
		 * @return 
		 * 
		 */		
		public function upYSTTaskIsFinish():Boolean
		{
			var ret:Boolean = false;
			var gameWubao:WuBao = GameManager.gameMgr.wubao;
			var build:Build = gameWubao.buildList.getObjByID(Build.YST) as Build;;
			
			if (taskID == Task.UP_YST && taskState == 0 && build != null)
			{
				if (build.level > 0 || build.endTime > 0) 
					ret = false;
				else
					ret = true;
			}
			else
				ret = false;
			
			return ret;
		}
		
		/**
		 * 判断生产200把剑的任务是否需要新手指引 
		 * @return 
		 * 
		 */		
		public function madeTaskIsFinish():Boolean
		{
			var ret:Boolean = false;
			var gameWubao:WuBao = GameManager.gameMgr.wubao;
			
			if (taskID == Task.MADE && taskState == 0)
			{
				if (gameWubao.store.getWeaponNum(Weapon.JIAN, 0) >= 200)
					ret = false;
				else
					ret = true;
			}
			else
				ret = false;
			
			return ret;
		}
		
		/**
		 * 判断强化100把剑的任务是否需要新手指引 
		 * @return 
		 * 
		 */		
		public function upWeaponTaskIsFinish():Boolean
		{
			var ret:Boolean = false;
			var gameWubao:WuBao = GameManager.gameMgr.wubao;
			
			if (taskID == Task.UP_WEAPON && taskState == 0)
			{
				if (gameWubao.store.getWeaponNum(Weapon.JIAN, 1) >= 100)
					ret = false;
				else
					ret = true;
			}
			else
				ret = false;
			
			return ret;
		}
		
 		/**
 		 * 判断学习长蛇阵是否需要新手指引 
 		 * @return 
 		 * 
 		 */		
 		public function csZhenTaskIsFinish():Boolean
		{
			var ret:Boolean = false;
			var gameWubao:WuBao = GameManager.gameMgr.wubao;
			var i:int = 0;
			var j:int = 0;
			var gameGeneral:General = null;
			
			if (taskID == Task.XIU && taskState == 0)
			{
				ret = true;
				
				for (i = 0; i < gameWubao.generalList.length; i++)
				{
					gameGeneral = gameWubao.generalList.getObjByIndex(i) as General;
					if (gameGeneral != null)
					{
						for (j = 0; j < gameGeneral.zhenList.length; j++)
						{
							var gameZhen:Zhen = gameGeneral.zhenList.getObjByIndex(j) as Zhen;
							//是否学会了长蛇阵
							if (gameZhen != null && gameZhen.uniqID == 6)
							{
								ret = false;
								break;
							} 
						}
					}
				}
			}
			else
				ret = false;
			
			return ret;
		}
		
 		/**
 		 * 判断配兵是否需要新手指引 
 		 * @return 
 		 * 
 		 */		
 		public function fitTaskIsFinish():Boolean
		{
			var ret:Boolean = false;
			var gameWubao:WuBao = GameManager.gameMgr.wubao;
			var i:int = 0;
			var j:int = 0;
			var gameGeneral:General = null;
			
			if (taskID == Task.FIT && taskState == 0)
			{
				ret = true;
				
				for (i = 0; i < gameWubao.generalList.length; i++)
				{
					gameGeneral = gameWubao.generalList.getObjByIndex(i) as General;
					if (gameGeneral != null)
					{
						if (gameGeneral.w1Type == Weapon.JIAN && gameGeneral.w1Level == 1 && gameGeneral.soliderTotal == 100)
						{
							ret = false;
							break;
						}
					}
				}
			}
			else
				ret = false;
			
			return ret;
		}
		
		public function set uniqID(param:int):void
		{
			this._uniqID = param;
		}

		public function get uniqID():int
		{
			return this._uniqID;
		}

		public function set level(param:int):void
		{
			this._level = param;
		}

		public function get level():int
		{
			return this._level;
		}

		public function set wubaoID(param:int):void
		{
			this._wubaoID = param;
		}

		public function get wubaoID():int
		{
			return this._wubaoID;
		}
		
		public function set cityID(param:int):void
		{
			this._cityID = param;
		}

		public function get cityID():int
		{
			return this._cityID;
		}
		
		public function set place(param:String):void
		{
			this._place = param;
		}

		public function get place():String
		{
			var gameCity:City = GameManager.gameMgr.cityList.getObjByID(cityID) as City;
			if (gameCity != null)
				_place = gameCity.zhouName + gameCity.junName;
				
			return this._place;
		}

		public function set sphereID(param:int):void
		{
			this._sphereID = param;
		}

		public function get sphereID():int
		{
			return this._sphereID;
		}

		public function set sphereName(param:String):void
		{
			this._sphereName = param;
		}

		public function get sphereName():String
		{
			var gameSphere:Sphere = GameManager.gameMgr.sphereList.getObjByID(sphereID) as Sphere;
			if (gameSphere != null)
				_sphereName = gameSphere.sphereName;
				
			return this._sphereName;
		}

		public function get rank():int
		{
			return _rank;
		}
		
		public function set rank(param:int):void
		{
			_rank = param;
		}

		public function get rank1():int
		{
			return _rank1;
		}
		
		public function set rank1(param:int):void
		{
			_rank1 = param;
		}

		public function get rankName():String
		{
			if (rank >= 1 && rank <= 3)
				_rankName = PubUnit.userLevelList[rank];
			else
				_rankName = rank.toString();
				
			return _rankName;
		}
		
		public function set rankName(param:String):void
		{
			_rankName = param;
		}

		public function get rankColor():uint
		{
			if (rank == 1)
				_rankColor = 0xd23c01;
			else if (rank == 2)
				_rankColor = 0xFFAF28;
			else if (rank == 3)
				_rankColor = 0x4addd3;
			else
				_rankColor = 0xFFFFFF;
				
			return _rankColor;
		}
		
		public function set rankColor(param:uint):void
		{
			_rankColor = param;
		}

		public function get rankColor1():String
		{
			if (rank == 1)
				_rankColor1 = "#d23c01";
			else if (rank == 2)
				_rankColor1 = "#FFAF28";
			else if (rank == 3)
				_rankColor1 = "#4addd3";
				
			return _rankColor1;
		}
		
		public function set rankColor1(param:String):void
		{
			_rankColor1 = param;
		}

		public function set userName(param:String):void
		{
			this._userName = param;
		}

		public function get userName():String
		{
			return this._userName;
		}

		public function get prestige():int
		{
			return _prestige;
		}
		
		public function set prestige(param:int):void
		{
			_prestige = param;
		}

		public function get gong():int
		{
			return _gong;
		}
		
		public function set gong(param:int):void
		{
			_gong = param;
		}

		public function get digID():int
		{
			return _digID;
		}
		
		public function set digID(param:int):void
		{
			_digID = param;
		}

		public function get offID():int
		{
			return _offID;
		}
		
		public function set offID(param:int):void
		{
			_offID = param;
		}

		public function get digName():String
		{
			var dig:Dignitie = GameManager.gameMgr.digList.getObjByID(digID) as Dignitie;
			if (dig != null)
				_digName = dig.digName;
				
			return _digName;
		}

		public function set digName(value:String):void
		{
			_digName = value;
		}

		public function get offName():String
		{
			var off:Official = GameManager.gameMgr.offList.getObjByID(offID) as Official;
			if (off != null)
				_offName = off.offName;
				
			return _offName;
		}

		public function set offName(value:String):void
		{
			_offName = value;
		}

		public function get isLeader():Boolean
		{
			var gameWubao:WuBao = GameManager.gameMgr.wubao;
			var sphereList:SphereList = GameManager.gameMgr.sphereList;
			
			_isLeader = sphereList.isLeader(gameWubao.userID);
			return _isLeader;
		}
		
		public function set isLeader(param:Boolean):void
		{
			_isLeader = param;
		}

		public function get isGM():Boolean
		{
			return _isGM;
		}
		
		public function set isGM(param:Boolean):void
		{
			_isGM = param;
		}

		public function get lastLogin():int
		{
			return _lastLogin;
		}
		
		public function set lastLogin(param:int):void
		{
			_lastLogin = param;
		}

		public function get lastLoginStr():String
		{
			_lastLoginStr = PubUnit.getActDate(lastLogin);
			
			return _lastLoginStr;
		}
		
		public function set lastLoginStr(param:String):void
		{
			_lastLoginStr = param;
		}

		public function set chong(param:int):void
		{
			this._chong = param;
		}

		public function get chong():int
		{
			return this._chong;
		}

		public function set give(param:int):void
		{
			this._give = param;
		}

		public function get give():int
		{
			return this._give;
		}

		public function set money(param:int):void
		{
			this._money = param;
		}

		public function get money():int
		{
			_money = chong + give;
			
			return this._money;
		}

		public function set consume(param:int):void
		{
			this._consume = param;
		}

		public function get consume():int
		{
			return this._consume;
		}

		public function set isOnline(param:int):void
		{
			this._isOnline = param;
		}

		public function get isOnline():int
		{
			return this._isOnline;
		}

		public function set isOnlineStr(param:String):void
		{
			this._isOnlineStr = param;
		}

		public function get isOnlineStr():String
		{
			_isOnlineStr = isOnline == 0 ? "" : "在线";
			
			return this._isOnlineStr;
		}

		public function set isVip(param:Boolean):void
		{
			this._isVip = param;
		}

		public function get isVip():Boolean
		{
			_isVip = (vipTotal - vipUsed) > 0 ? true : false; 
			
			return this._isVip;
		}

		public function set vipTotal(param:int):void
		{
			this._vipTotal = param;
		}

		public function get vipTotal():int
		{
			return this._vipTotal;
		}

		public function set vipUsed(param:int):void
		{
			this._vipUsed = param;
		}

		public function get vipUsed():int
		{
			return this._vipUsed;
		}
		
		public function set isLock(param:Boolean):void
		{
			this._isLock = param;
		}

		public function get isLock():Boolean
		{
			return this._isLock;
		}
		
		public function set quesType(param:int):void
		{
			this._quesType = param;
		}

		public function get quesType():int
		{
			return this._quesType;
		}
		
		public function set taskID(param:int):void
		{
			this._taskID = param;
		}

		public function get taskID():int
		{
			return this._taskID;
		}
		
		public function set taskState(param:int):void
		{
			this._taskState = param;
		}

		public function get taskState():int
		{
			return this._taskState;
		}
		
		public function set finishTask(param:Array):void
		{
			this._finishTask = param;
		}

		public function get finishTask():Array
		{
			return this._finishTask;
		}
		
		public function set orderCD(param:int):void
		{
			this._orderCD = param;
		}

		public function get orderCD():int
		{
			return this._orderCD;
		}
		
		public function set leftOrder(param:int):void
		{
			this._leftOrder = param;
		}

		public function get leftOrder():int
		{
			return this._leftOrder;
		}
		
		public function set trainCD(param:int):void
		{
			this._trainCD = param;
		}

		public function get trainCD():int
		{
			return this._trainCD;
		}
		
		public function set robCount(param:int):void
		{
			this._robCount = param;
		}

		public function get robCount():int
		{
			return this._robCount;
		}
		
		public function set preCount(param:int):void
		{
			this._preCount = param;
		}

		public function get preCount():int
		{
			return this._preCount;
		}
		
		public function set gateID(param:int):void
		{
			this._gateID = param;
		}

		public function get gateID():int
		{
			return this._gateID;
		}
		
		public function set isClose(param:Boolean):void
		{
			this._isClose = param;
		}

		public function get isClose():Boolean
		{
			return this._isClose;
		}
		
		public function set guidIndex(param:int):void
		{
			this._guidIndex = param;
		}

		public function get guidIndex():int
		{
			return this._guidIndex;
		}
		
	}
}