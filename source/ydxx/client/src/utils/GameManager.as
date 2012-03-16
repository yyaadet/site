package utils
{
	import army.list.ArmyList;
	
	import battle.list.BattleList;
	import battle.list.GateGeneralList;
	import battle.list.GatewayList;
	
	import city.list.AttackCityList;
	import city.list.CityList;
	import city.model.City;
	
	import deal.list.BillList;
	import deal.list.SellList;
	
	import general.list.GeneralList;
	import general.list.SkillList;
	import general.list.ZhenList;
	
	import guid.GuidManager;
	
	import mail.list.MailList;
	
	import shop.list.TreasureList;
	import shop.model.Treasure;
	
	import sphere.list.DipList;
	import sphere.list.SphLevList;
	import sphere.list.SphereList;
	import sphere.model.Sphere;
	
	import task.list.TaskList;
	
	import wubao.list.Dignlist;
	import wubao.list.FaceList;
	import wubao.list.FriendList;
	import wubao.list.OfficialList;
	import wubao.list.TranList;
	import wubao.list.UserList;
	import wubao.list.UserTsList;
	import wubao.model.User;
	import wubao.model.UserTreasure;
	import wubao.model.WuBao;
	
	/**
	 * 游戏管理器，用来存储游戏当前的数据状态 
	 * @author StarX
	 * 
	 */	
	[Bindable] 
	public class GameManager
	{
		//定义静态game管理器，用来实现game管理器的单例模式
		private static var _gameMgr:GameManager = null;
		
		//主程序
		private var _gameApp:hanfeng = null;
		
		private var _gameWidth:int = 0;
		
		private var _gameHeight:int = 0;
		
		//资源服务器地址
		private var _resURL:String = "";
		
		//兑换金币地址
		private var _exchangeURL:String = "";
		
		//跳转地址
		private var _gotoURL:String = "";
		
		//hashID，从web传过来
		private var _hashID:String = "";
		
		//用户ID，从web传过来
		private var _userID:int = 0;
		
		//所在势力名称
		private var _sphereName:String = "";
		
		//当前进入的城池ID
		private var _cityID:int = 0;
		
		//是否进入游戏
		private var _isEnterGame:Boolean = false;
		
		//游戏中的时间戳
		private var _gameTime:int = 0;
		
		//游戏时间中的年
		private var _gameYear:int = 0;
		
		//游戏时间中的月
		private var _gameMonth:int = 0;
		
		//游戏时间中的日
		private var _gameDay:int = 0;
		
		//游戏时间中的时辰
		private var _gameHour:int = 0;
		
		//坞堡信息
		private var _wubao:WuBao = null;
		
		//玩家信息
		private var _user:User = null;
		
		//用户列表
		private var _userList:UserList = null;
		
		//城池列表
		private var _cityList:CityList = null;
		
		//武将列表
		private var _generalList:GeneralList = null;
		
		//势力列表
		private var _sphereList:SphereList = null;
		
		//任务列表
		private var _taskList:TaskList = null;
		
		//外交关系列表
		private var _dipList:DipList = null;
		
		//军团列表
		private var _armyList:ArmyList = null;
		
		//技能列表
		private var _skillList:SkillList = null;
		
		//阵法列表
		private var _zhenList:ZhenList = null;
		
		//爵位列表
		private var _digList:Dignlist = null;
		
		//势力等级列表
		private var _slList:SphLevList = null;
		
		//官位列表
		private var _offList:OfficialList = null;
		
		//头像列表
		private var _faceList:FaceList = null;
		
		//全局道具列表
		private var _treasureList:TreasureList = null;
		
		//玩家的道具
		private var _userTsList:UserTsList = new UserTsList();
		
		//邮件列表
		private var _mailList:MailList = null;
		
		//友好度列表
		private var _friendList:FriendList = null;
		
		//输送列表
		private var _tranList:TranList = null;
		
		//挂单列表
		private var _billList:BillList = null;
		
		//销售武器列表
		private var _sellList:SellList = null;
		
		//战役列表
		private var _battleList:BattleList = null;
		
		//关卡列表
		private var _gateList:GatewayList = null;
		
		//关卡武将列表
		private var _gateGeneralList:GateGeneralList = null;
		
		//攻打城池战场列表
		private var _atkCityList:AttackCityList = null;
		
		//城战战况通知列表
		private var _cityFightList:Array = [];
		
		//购买道具的数量
		private var _buyNum:int = 0;
		
		//聊天缓存
		private var _chatBuf:Array = [];
		
		//是否显示新手指引
		private var _isShowGuid:Boolean = true;
		
		//敏感词列表
		private var _filterList:Array = [];
		
		public function GameManager()
		{
			if(_gameMgr != null)
				throw new Error("不能多次创建gameMangager的实例!");
		}
		
		/**
		 * 管理器初始化 
		 * 
		 */		
		public static function init():void
		{
			if (_gameMgr == null)
				_gameMgr = new GameManager();
		}
		
		/**
		 * 获取game管理器单例 
		 * @return 
		 * 
		 */		
		public static function get gameMgr():GameManager
		{
			return _gameMgr;
		}
		
		/**
		 * 正式进入游戏 
		 * 
		 */		
		public function enterGame():void
		{
			initData();
			
			WinManager.winMgr.removeLoadInfo();
			gameApp.showUI();
			gameApp.panelDate.refreshInfo();
			
			SceneManager.sceneMgr.sceneWubao.width = gameWidth;
			SceneManager.sceneMgr.sceneWubao.height = gameHeight;
			SceneManager.sceneMgr.sceneWubao.initUI();
			
			var i:int = 0;
			
			//进入坞堡界面
			SceneManager.sceneMgr.enterWubao();
			
			//将聊天缓存中的信息显示到聊天界面上去
			if (chatBuf.length > 0)
			{
				for (i = chatBuf.length - 1; i >= 0; i--)
				{
					gameApp.chatMain.showInfo(chatBuf[i]);
				}
			}
			
			isEnterGame = true;
			SceneManager.sceneMgr.sceneWubao.showProgress();
			GuidManager.guidMgr.initUI();
			
			if (user.guidIndex == 1000)
			{
				GameManager.gameMgr.isShowGuid = false;
				GuidManager.guidMgr.hideGuid();
			}
			else if (user.guidIndex == 0)
				GuidManager.guidMgr.gotoNext();
			else
				GuidManager.guidMgr.gotoIndex(user.guidIndex + 1);
		}
		
		/**
		 * 初始化游戏数据 
		 * 
		 */		
		private function initData():void
		{
			var i:int = 0;
			var len:int = 0;
			
			//设置玩家购买的道具的基础信息
			len = userTsList.length;
			var userTreasure:UserTreasure = null;
			var treasure:Treasure = null;
			
			for (i = 0; i < len; i++)
			{
				userTreasure = userTsList.getObjByIndex(i) as UserTreasure;
				if (userTreasure != null)
				{
					treasure = treasureList.getObjByID(userTreasure.treasureID) as Treasure;
					userTreasure.treasure = treasure;
				}	
			}
			
			//加玩家添加到对应的势力，城池中去，并设置势力中的官位
			len = userList.length;
			var gameUser:User = null;
			var gameSphere:Sphere = null;
			var gameCity:City = null;
			
			for (i = 0; i < len; i++)
			{
				gameUser = userList.getObjByIndex(i) as User;
				if (gameUser != null && gameUser.sphereID > 0)
				{
					gameSphere = sphereList.getObjByID(gameUser.sphereID) as Sphere;
					if (gameSphere != null)
						gameSphere.userList.add(gameUser);
				}
				
				if (gameUser != null && gameUser.sphereID > 0 && gameUser.sphereID == GameManager.gameMgr.wubao.sphereID && gameUser.offID > 0)
					offList.setOff(gameUser.offID, gameUser.uniqID);
					
				if (gameUser != null && gameUser.cityID > 0)
				{
					gameCity = cityList.getObjByID(gameUser.cityID) as City;
					if (gameCity != null)
						gameCity.userList.add(gameUser);
				}
				
			}
		}
		
		/**
		 * 初始化势力的官位信息(加入势力后)
		 * 
		 */		
		public function initOff():void
		{
			var i:int = 0;
			var len:int = 0;
			
			len = userList.length;
			var gameUser:User = null;
			var gameSphere:Sphere = null;
			
			for (i = 0; i < len; i++)
			{
				gameUser = userList.getObjByIndex(i) as User;
				
				if (gameUser != null && gameUser.sphereID > 0 && gameUser.sphereID == GameManager.gameMgr.wubao.sphereID && gameUser.offID > 0)
					offList.setOff(gameUser.offID, gameUser.uniqID);
			}
		}
		
		/**
		 * 控制主界面信息框是否显示 
		 * @param showDate  是否显示时间人物信息框
		 * @param showRes  是否显示资源信息框
		 * @param showOperate 是否显示坞堡中操作信息框
		 * @param showQuene  是否显示建筑队列
		 * @param showPlaceName 是否显示地区场景中所在信息框
		 * @param showTip  是否显示军令邮件信息框
		 * 
		 */		
		public function showTitle(showDate:Boolean = true, showRes:Boolean = true, showOperate:Boolean = false, 
		                          showQuene:Boolean = false, showPlaceName:Boolean = false, showTip:Boolean = true):void
		{
			gameApp.panelDate.visible = showDate;
			gameApp.panelDate.includeInLayout = showDate;
			
			gameApp.panelRes.visible = showRes;
			gameApp.panelRes.includeInLayout = showRes;
			
			gameApp.panelOperate.visible = showOperate;
			gameApp.panelOperate.includeInLayout = showOperate;
			
			gameApp.panelQuene.visible = showQuene;
			gameApp.panelQuene.includeInLayout = showQuene;
			
			gameApp.panelPlace.visible = showPlaceName;
			gameApp.panelPlace.includeInLayout = showPlaceName;
			
			gameApp.panelTip.visible = showTip;
			gameApp.panelTip.includeInLayout = showTip;
		}
		
		//==========================================================================================
		// 属性
		//==========================================================================================
		
		public function get gameApp():hanfeng
		{
			return _gameApp;
		}
		
		public function set gameApp(param:hanfeng):void
		{
			_gameApp = param;
			gameWidth = _gameApp.width;
			gameHeight = _gameApp.height;
		}
		
		public function get gameWidth():int
		{
			return _gameWidth;
		}
		
		public function set gameWidth(param:int):void
		{
			_gameWidth = param;
		}
		
		public function get gameHeight():int
		{
			return _gameHeight;
		}
		
		public function set gameHeight(param:int):void
		{
			_gameHeight = param;
		}
		
		public function get resURL():String
		{
			return _resURL;
		}
		
		public function set resURL(param:String):void
		{
			_resURL = param;
		}

		public function get exchangeURL():String
		{
			return _exchangeURL;
		}
		
		public function set exchangeURL(param:String):void
		{
			_exchangeURL = param;
		}

		public function get gotoURL():String
		{
			return _gotoURL;
		}
		
		public function set gotoURL(param:String):void
		{
			_gotoURL = param;
		}

		public function get hashID():String
		{
			return _hashID;
		}
		
		public function set hashID(param:String):void
		{
			if (param == "") return;
			
			_hashID = param;
		}

		public function get userID():int
		{
			return _userID;
		}
		
		public function set userID(param:int):void
		{
			_userID = param;
		}

		public function get sphereName():String
		{
			return _sphereName;
		}
		
		public function set sphereName(param:String):void
		{
			_sphereName = param;
		}

		public function get cityID():int
		{
			return _cityID;
		}
		
		public function set cityID(param:int):void
		{
			_cityID = param;
		}

		public function get isEnterGame():Boolean
		{
			return _isEnterGame;
		}
		
		public function set isEnterGame(param:Boolean):void
		{
			_isEnterGame = param;
		}
		
		public function get gameTime():int
		{
			return _gameTime;
		}
		
		public function set gameTime(param:int):void
		{
			if (param < 1) return;
			
			_gameTime = param;
		}

		public function get gameYear():int
		{
			return _gameYear;
		}
		
		public function set gameYear(param:int):void
		{
			if (param < 1) return;
			
			_gameYear = param;
		}

		public function get gameMonth():int
		{
			return _gameMonth;
		}
		
		public function set gameMonth(param:int):void
		{
			if (param < 1) return;
			
			_gameMonth = param;
		}

		public function get gameDay():int
		{
			return _gameDay;
		}
		
		public function set gameDay(param:int):void
		{
			if (param < 1) return;
			
			_gameDay = param;
		}

		public function get gameHour():int
		{
			return _gameHour;
		}
		
		public function set gameHour(param:int):void
		{
			_gameHour = param;
		}

		public function get wubao():WuBao
		{
			return _wubao;
		}
		
		public function set wubao(param:WuBao):void
		{
			_wubao = param;
		}

		public function get user():User
		{
			return _user;
		}
		
		public function set user(param:User):void
		{
			_user = param;
		}

		public function get userList():UserList
		{
			return _userList;
		}
		
		public function set userList(param:UserList):void
		{
			_userList = param;
		}

		public function get cityList():CityList
		{
			return _cityList;
		}
		
		public function set cityList(param:CityList):void
		{
			_cityList = param;
		}

		public function get generalList():GeneralList
		{
			return _generalList;
		}
		
		public function set generalList(param:GeneralList):void
		{
			_generalList = param;
		}

		public function get sphereList():SphereList
		{
			return _sphereList;
		}
		
		public function set sphereList(param:SphereList):void
		{
			_sphereList = param;
		}

		public function get taskList():TaskList
		{
			return _taskList;
		}
		
		public function set taskList(param:TaskList):void
		{
			_taskList = param;
		}

		public function get dipList():DipList
		{
			return _dipList;
		}
		
		public function set dipList(param:DipList):void
		{
			_dipList = param;
		}

		public function get armyList():ArmyList
		{
			return _armyList;
		}
		
		public function set armyList(param:ArmyList):void
		{
			_armyList = param;
		}

		public function get skillList():SkillList
		{
			return _skillList;
		}
		
		public function set skillList(param:SkillList):void
		{
			_skillList = param;
		}

		public function get zhenList():ZhenList
		{
			return _zhenList;
		}
		
		public function set zhenList(param:ZhenList):void
		{
			_zhenList = param;
		}

		public function get digList():Dignlist
		{
			return _digList;
		}
		
		public function set digList(param:Dignlist):void
		{
			_digList = param;
		}

		public function get slList():SphLevList
		{
			return _slList;
		}
		
		public function set slList(param:SphLevList):void
		{
			_slList = param;
		}

		public function get offList():OfficialList
		{
			return _offList;
		}
		
		public function set offList(param:OfficialList):void
		{
			_offList = param;
		}

		public function get faceList():FaceList
		{
			return _faceList;
		}
		
		public function set faceList(param:FaceList):void
		{
			_faceList = param;
		}

		public function get treasureList():TreasureList
		{
			return _treasureList;
		}
		
		public function set treasureList(param:TreasureList):void
		{
			_treasureList = param;
		}

		public function set userTsList(param:UserTsList):void
		{
			this._userTsList = param;
		}

		public function get userTsList():UserTsList
		{
			return this._userTsList;
		}

		public function get mailList():MailList
		{
			return _mailList;
		}
		
		public function set mailList(param:MailList):void
		{
			_mailList = param;
		}

		public function get friendList():FriendList
		{
			return _friendList;
		}

		public function set friendList(value:FriendList):void
		{
			_friendList = value;
		}

		public function get tranList():TranList
		{
			return _tranList;
		}

		public function set tranList(value:TranList):void
		{
			_tranList = value;
		}

		public function get billList():BillList
		{
			return _billList;
		}

		public function set billList(value:BillList):void
		{
			_billList = value;
		}

		public function get sellList():SellList
		{
			return _sellList;
		}

		public function set sellList(value:SellList):void
		{
			_sellList = value;
		}

		public function get battleList():BattleList
		{
			return _battleList;
		}

		public function set battleList(value:BattleList):void
		{
			_battleList = value;
		}

		public function get gateList():GatewayList
		{
			return _gateList;
		}

		public function set gateList(value:GatewayList):void
		{
			_gateList = value;
		}

		public function get gateGeneralList():GateGeneralList
		{
			return _gateGeneralList;
		}

		public function set gateGeneralList(value:GateGeneralList):void
		{
			_gateGeneralList = value;
		}

		public function get atkCityList():AttackCityList
		{
			return _atkCityList;
		}

		public function set atkCityList(value:AttackCityList):void
		{
			_atkCityList = value;
		}

		public function get cityFightList():Array
		{
			return _cityFightList;
		}

		public function set cityFightList(value:Array):void
		{
			_cityFightList = value;
		}

		public function get buyNum():int
		{
			return _buyNum;
		}
		
		public function set buyNum(param:int):void
		{
			_buyNum = param;
		}

		public function get chatBuf():Array
		{
			return _chatBuf;
		}
		
		public function set chatBuf(param:Array):void
		{
			_chatBuf = param;
		}

		public function get isShowGuid():Boolean
		{
			return _isShowGuid;
		}
		
		public function set isShowGuid(param:Boolean):void
		{
			_isShowGuid = param;
		}

		public function get filterList():Array
		{
			return _filterList;
		}
		
		public function set filterList(param:Array):void
		{
			_filterList = param;
		}

	}
}