package net.tcp
{
	import army.list.ArmyList;
	import army.model.Army;
	
	import battle.list.BattleList;
	import battle.list.GateGeneralList;
	import battle.list.GatewayList;
	import battle.model.Battle;
	import battle.model.GateGeneral;
	import battle.model.Gateway;
	
	import city.list.AttackCityList;
	import city.list.CityList;
	import city.model.AttackCity;
	import city.model.City;
	
	import deal.list.BillList;
	import deal.list.SellList;
	import deal.model.Bill;
	import deal.model.Sell;
	
	import flash.events.EventDispatcher;
	import flash.events.TimerEvent;
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	import flash.utils.Timer;
	
	import general.list.GeneralList;
	import general.model.General;
	
	import mail.list.MailList;
	import mail.model.Mail;
	
	import map.MapManager;
	
	import net.http.HttpManager;
	import net.tcp.core.Connection;
	import net.tcp.core.Request;
	import net.tcp.core.Response;
	import net.tcp.events.TcpErrEvent;
	import net.tcp.events.TcpReqEvent;
	import net.tcp.events.TcpSucEvent;
	import net.tcp.model.TcpBuy;
	import net.tcp.model.TcpChat;
	import net.tcp.model.TcpCreateUser;
	import net.tcp.model.TcpGuid;
	import net.tcp.model.TcpMail;
	import net.tcp.model.deal.TcpBill;
	import net.tcp.model.deal.TcpBuyWeapon;
	import net.tcp.model.deal.TcpCancel;
	import net.tcp.model.deal.TcpSell;
	import net.tcp.model.deal.TcpSys;
	import net.tcp.model.fight.TcpFight;
	import net.tcp.model.fight.TcpFightNtf;
	import net.tcp.model.map.TcpMove;
	import net.tcp.model.map.TcpWar;
	import net.tcp.model.map.TcpZhen;
	import net.tcp.model.sphere.TcpAlli;
	import net.tcp.model.sphere.TcpApplyOff;
	import net.tcp.model.sphere.TcpConfAlli;
	import net.tcp.model.sphere.TcpConfJoin;
	import net.tcp.model.sphere.TcpCreateSphere;
	import net.tcp.model.sphere.TcpDecWar;
	import net.tcp.model.sphere.TcpDemise;
	import net.tcp.model.sphere.TcpDissolve;
	import net.tcp.model.sphere.TcpExitSphere;
	import net.tcp.model.sphere.TcpFireUser;
	import net.tcp.model.sphere.TcpJoin;
	import net.tcp.model.sphere.TcpModify;
	import net.tcp.model.task.TcpTask;
	import net.tcp.model.war.TcpAttack;
	import net.tcp.model.war.TcpExitAttack;
	import net.tcp.model.war.TcpJoinAttack;
	import net.tcp.model.wubao.TcpAcce;
	import net.tcp.model.wubao.TcpAppGen;
	import net.tcp.model.wubao.TcpChangeCity;
	import net.tcp.model.wubao.TcpCompose;
	import net.tcp.model.wubao.TcpCure;
	import net.tcp.model.wubao.TcpDestroy;
	import net.tcp.model.wubao.TcpFightUser;
	import net.tcp.model.wubao.TcpFire;
	import net.tcp.model.wubao.TcpFit;
	import net.tcp.model.wubao.TcpGrant;
	import net.tcp.model.wubao.TcpLevelUp;
	import net.tcp.model.wubao.TcpMade;
	import net.tcp.model.wubao.TcpMarch;
	import net.tcp.model.wubao.TcpRob;
	import net.tcp.model.wubao.TcpStudy;
	import net.tcp.model.wubao.TcpTrans;
	import net.tcp.model.wubao.TcpView;
	import net.tcp.model.wubao.TcpVisit;
	
	import shop.model.Treasure;
	
	import sphere.list.DipList;
	import sphere.list.SphereList;
	import sphere.model.Diplomacy;
	import sphere.model.Sphere;
	
	import utils.FormatText;
	import utils.GameManager;
	import utils.PubUnit;
	import utils.SceneManager;
	import utils.WinManager;
	
	import wubao.list.BuildList;
	import wubao.list.FriendList;
	import wubao.list.TechList;
	import wubao.list.TranList;
	import wubao.list.UserList;
	import wubao.list.UserTsList;
	import wubao.list.WeaponList;
	import wubao.model.Build;
	import wubao.model.Friend;
	import wubao.model.Tech;
	import wubao.model.Transfer;
	import wubao.model.User;
	import wubao.model.UserTreasure;
	import wubao.model.Weapon;
	import wubao.model.WuBao;
	
	/**
	 * Tcp管理器，用来控制游戏中所有的消息包的发送与接收
	 * @author StarX
	 * 
	 */	
	public class TcpManager extends EventDispatcher
	{
		//tcp服务器ip地址
		private static var _serverIP:String = "";
		
		//tcp服务器端口
		private static var _port:int = 0;
		
		//安全认证服务器ip地址
		private static var _securityIP:String = "";
		
		//安全认证服务器ip地址
		private static var _securityPort:int = 0;
		
		//定义静态tcp管理器，用来实现tcp管理器的单例模式
		private static var _tcpMgr:TcpManager = null;
		
		private var conn:Connection = null;
		
		//自增长的消息ID
		private var _msgID:int = 1;
		
		//消息列表
		private var msgList:Array = new Array();
		
		//定时器，用来控制重连时间
		private var timer1:Timer = new Timer(1000);
		
		//重连秒数
		private var reconSec:int = 2;
		
		//重连次数，初次连接失败后，连接不断的连接次数
		private var reConnectCount:int = 0;
		
		//计算定时器次数
		private var timeCount:int = 0;
		
		//用来判断是否断开连接
		private var timerConn:Timer = new Timer(1000);
		private var timeConnCount:int = 0; 
		private const timeOut:int = PubUnit.secGameHour + 5;
		
		//是否需要创建角色
		private var isCreateUser:Boolean = false;
		
		//初始化TCP消息是否完成
		private var isTcpFinish:Boolean = false;
		
		//已成功购买道具的数量(用来控制购买道具成功的提示显示界面)
		private var buyNum:int = 0;
		
		private var sphereNum:int = 0;
		private var generalNum:int = 0;
		
		/**
		 * 构造函数
		 *  
		 */		
		public function TcpManager()
		{
			if (_tcpMgr != null)
				throw new Error("不能多次创建tcpMangager的实例!");
		}
		
		/**
		 * 管理器初始化 
		 * @param serverIP      tcp服务器ip地址
		 * @param port          tcp服务器端口
		 * @param securityIP    安全认证服务器ip地址
		 * @param securityPort  安全认证服务器ip地址
		 * 
		 */		
		public static function init(serverIP:String, port:int, securityIP:String, securityPort:int):void
		{
			if (_tcpMgr == null)
			{
				_tcpMgr = new TcpManager();
				
				_serverIP = serverIP;
				_port = port;
				_securityIP = securityIP;
				_securityPort = securityPort;
			}
		}
		
		/**
		 * 获取管理器单例 
		 * @return 
		 * 
		 */		
		public static function get tcpMgr():TcpManager
		{
			return _tcpMgr;
		}
		
		/**
		 * 连接tcp服务器 
		 * 
		 */		
		public function connect():void
		{
			if (conn == null)
				conn = new Connection(_serverIP, _port, _securityIP, _securityPort);
			
			initListener();
			connectTcp();	
		}
		
		/**
		 * 连接tcp服务器 
		 * 
		 */		
		public function connectTcp():void
		{
			if (conn == null) return;
			
			conn.connect();
		}
		
		/**
		 * 断开服务器连接 
		 * 
		 */		
		public function closeTcp():void
		{
			if (conn == null) return;
			
			conn.close();
		}
		
		/**
		 * 初始化事件监听器 
		 * 
		 */		
		private function initListener():void
		{
			if (conn == null) return;
			
			if (!conn.hasEventListener(TcpErrEvent.ERROR))
				conn.addEventListener(TcpErrEvent.ERROR, onTcpError);
				
			if (!conn.hasEventListener(TcpErrEvent.ERROR))
				conn.addEventListener(TcpErrEvent.ERROR, onTcpClose);
				
			if (!conn.hasEventListener(TcpSucEvent.SUCCESS))
				conn.addEventListener(TcpSucEvent.SUCCESS, onTcpSuccess);
				
			if (!conn.hasEventListener(TcpReqEvent.RECEIVE))
				conn.addEventListener(TcpReqEvent.RECEIVE, onTcpReceive);
		}
		
		/**
		 * 移除所有的事件监听器 
		 * 
		 */		
		private function removeAllListener():void
		{
			if (conn == null) return;
			
			if (conn.hasEventListener(TcpErrEvent.ERROR))
				conn.removeEventListener(TcpErrEvent.ERROR, onTcpError);
				
			if (!conn.hasEventListener(TcpErrEvent.ERROR))
				conn.removeEventListener(TcpErrEvent.ERROR, onTcpClose);
				
			if (conn.hasEventListener(TcpSucEvent.SUCCESS))
				conn.removeEventListener(TcpSucEvent.SUCCESS, onTcpSuccess);
				
			if (conn.hasEventListener(TcpReqEvent.RECEIVE))
				conn.removeEventListener(TcpReqEvent.RECEIVE, onTcpReceive);
		}
		
		/**
		 * 连接tcp服务器成功 
		 * 
		 */		
		private function onTcpSuccess(evt:TcpSucEvent):void
		{
			if (timer1.running)
			{
				timer1.stop();
				timer1.removeEventListener(TimerEvent.TIMER, reConnectTcp);
			}
			
			if (GameManager.gameMgr.gameApp.panelDate.season != null)
				GameManager.gameMgr.gameApp.panelDate.season.stopFlash();
			
			sendUerLogin();
			dispatchEvent(evt.clone());
		}
		
		/**
		 * 连接tcp服务器失败 
		 * 
		 */		
		private function onTcpError(evt:TcpErrEvent):void
		{
			tcpErrorHandle();
		}
		
		/**
		 * 服务器关闭连接 
		 * @param evt
		 * 
		 */		
		private function onTcpClose(evt:TcpErrEvent):void
		{
			tcpErrorHandle();
		}
		
		private function tcpErrorHandle():void
		{
			if (GameManager.gameMgr.gameApp.panelDate.season != null)
				GameManager.gameMgr.gameApp.panelDate.season.startFlash();
			
			WinManager.winMgr.showResult("服务器断开连接", true, false, 1);
		}
		
		/**
		 * 重连服务器 
		 * @param evt
		 * 
		 */		
		private function reConnectTcp(evt:TimerEvent):void
		{
			timeCount ++;
			if (timeCount == reconSec)
			{
				timeCount = 0;
				connectTcp();
			}
		}
		
		/**
		 * 监测是否多开账号 
		 * 
		 */		
		private function readHashIDSO():void
		{
//			var so2:SharedObject = SharedObject.getLocal("duokai");
//			var tipStr:String = "";
//			
//			if (so2.size < 1)
//			{
//				closeTcp();
//				tipStr = "请重新进入游戏并允许保存本地文件";
//				WinManager.winMgr.showResult(tipStr, true, false, 1);
//			}
//			else
//			{
//				var hashID:String = so2.data.hashID;
//				
//				if (hashID != GameManager.gameMgr.hashID)
//				{
//					closeTcp();
//					tipStr = "已经检测到你在本机登陆了多个账号，点击确定退出游戏";
//					WinManager.winMgr.showResult(tipStr, true, false, 1);
//				}
//			}
		}
		
		//=============================================================================
		// 服务器发送消息包至客户端
		//=============================================================================
		
		/**
		 * 收到tcp服务器发来的消息包 
		 * 
		 */		
		private function onTcpReceive(evt:TcpReqEvent):void
		{
			var reqList:Array = evt.reqList;
			var req:Request = null;
			var reqType:int = -1;
			var tcpBody:ByteArray = null;
			
			if (reqList == null || reqList.length < 1) return;
			
			while (reqList.length > 0)
			{
				req = reqList.shift() as Request;
				
				//消息类型
				reqType = req.type;
				tcpBody = req.body;
				tcpBody.endian = Endian.BIG_ENDIAN;
				tcpBody.position = 0;
				
				if (reqType >= 300 && reqType <= 400)
					reqType = -1;
				
				//根据消息类型获取包体的内容
				switch (reqType)
				{
					//响应消息
					case -1:
					{
						var response:Response = new Response();
						
						//消息ID
						response.msgID = req.msgID;
						//消息类型 (300-400)
						response.type = req.type;
						
						response.resReason = readReason(tcpBody);
						dealResponse(response);
						
						break;
					}
					
					//下线通知
					case TcpType.NOTIFY_OFF_LINE:
					{
						closeTcp();
						WinManager.winMgr.showResult("你已经在其他地点登录", true, false, 1);
							
						break;
					}
					
					//创建角色通知
					case TcpType.NOTIFY_CREATE_USER:
					{
						var isCreate:int = readByte(tcpBody);
						
						if (isCreate == 1)
						{
							isCreateUser = true;
							WinManager.winMgr.showCreateUser();
						}
						else
							isCreateUser = false;						
							
						break;
					}
					
					//游戏时间通知
					case TcpType.NOTIFY_GAME_TIME:
					{
				   		parseTime(tcpBody);
				   		
						break;
					}
					
					//用户消息通知
					case TcpType.NOTIFY_USER:
					{
						parseUser(tcpBody);
						
						break;
					}
					
					//势力消息通知
					case TcpType.NOTIFY_SPHERE:
					{
						if (!GameManager.gameMgr.isEnterGame && !isTcpFinish)
							WinManager.winMgr.setLoadInfo("正在加载势力数据，请稍候...");
						parseSphere(tcpBody);
						
						break;
					}
					
					//城池消息通知
					case TcpType.NOTIFY_CITY:
					{
						parseCity(tcpBody);
						
						break;
					}
					
					//坞堡消息通知
					case TcpType.NOTIFY_WUBAO:
					{
						if (!GameManager.gameMgr.isEnterGame && !isTcpFinish)
							WinManager.winMgr.setLoadInfo("正在加载坞堡数据，请稍候...");
						parseWubao(tcpBody);
						
						break;
					}
					
					//武将消息通知
					case TcpType.NOTIFY_GENERAL:
					{
						if (!GameManager.gameMgr.isEnterGame && !isTcpFinish)
							WinManager.winMgr.setLoadInfo("正在加载武将数据，已加载" + generalNum.toString() + "，请稍候...");
						parseGeneral(tcpBody);
						
						break;
					}
					
					//军团消息通知
					case TcpType.NOTIFY_ARMY:
					{
						parseArmy(tcpBody);
						
						break;
					}
					
					//外交关系通知
					case TcpType.NOTIFY_DIP:
					{
						parseDip(tcpBody);
						
						break;
					}
					
					//玩家的道具消息通知
					case TcpType.NOTIFY_TREASURE:
					{
						parseTreasure(tcpBody);
						
						break;
					}
					
					//战争通知
					case TcpType.NOTIFY_WAR:
					{
						parseWar(tcpBody);
						
						break;
					}
					
					//新邮件通知
					case TcpType.NOTIFY_MAIL:
					{
						parseMail(tcpBody);
						
						break;
					}
					
					//聊天通知
					case TcpType.NOTIFY_CHAT:
					{
						parseChat(tcpBody);
						
						break;
					}
					
					//输送通知
					case TcpType.NOTIFY_TRAN:
					{
						parseTran(tcpBody);
						
						break;
					}
					
					//挂单交易通知
					case TcpType.NOTIFY_BILL:
					{
						parseBill(tcpBody);
						
						break;
					}
					
					//销售武器通知
					case TcpType.NOTIFY_SELL:
					{
						parseSell(tcpBody);
						
						break;
					}
					
					//战况通知
					case TcpType.NOTIFY_FIGHT:
					{
						parseFight(tcpBody);
						
						break;
					}
					
					//领取俸禄通知
					case TcpType.NOTIFY_SALARY:
					{
						parseSalary(tcpBody);
						
						break;
					}
					
					//战役数据通知
					case TcpType.NOTIFY_ZHANYI:
					{
						if (!GameManager.gameMgr.isEnterGame && !isTcpFinish)
							WinManager.winMgr.setLoadInfo("正在加载战役数据，请稍候...");
						parseZhanyi(tcpBody);
						
						break;
					}
					
					//关卡数据通知
					case TcpType.NOTIFY_GUANKA:
					{
						parseGuan(tcpBody);
						
						break;
					}
					
					//关卡武将通知
					case TcpType.NOTIFY_PK:
					{
						parsePK(tcpBody);
						
						break;
					}
					
					//战场通知
					case TcpType.NOTIFY_ATTACK_CITY:
					{
						parseAttackCity(tcpBody);
						
						break;
					}
					
					//进入战场通知
					case TcpType.NOTIFY_JOIN_ATTACK:
					{
						parseJoinAttack(tcpBody);
						
						break;
					}
					
					//退出战场通知
					case TcpType.NOTIFY_EXIT_ATTACK:
					{
						parseExitAttack(tcpBody);
						
						break;
					}
					
					//战场结束通知
					case TcpType.NOTIFY_ATTACK_FINISH:
					{
						parseAttackFinish(tcpBody);
						
						break;
					}
					
				    default:
				    {
				    	break;
				    }
				    
				} 
			}
			
		}
		
		/**
		 * 解析时间信息通知 
		 * @param tcpBody
		 * 
		 */		
		private function parseTime(tcpBody:ByteArray):void
		{
			var timeStamp:int = readInt(tcpBody);
			var ary:Array = PubUnit.getDate(timeStamp);
			var year:int = ary[0];
			var month:int = ary[1];
			var day:int = ary[2];
			var hour:int = ary[3];
			
			GameManager.gameMgr.gameTime = timeStamp;
			GameManager.gameMgr.gameYear = year;
			GameManager.gameMgr.gameMonth = month;
			GameManager.gameMgr.gameDay = day;
			GameManager.gameMgr.gameHour = hour;
			
			GameManager.gameMgr.gameApp.panelDate.refreshInfo();
			GameManager.gameMgr.gameApp.panelQuene.refresh();
			
			if (GameManager.gameMgr.isEnterGame)
			{
				SceneManager.sceneMgr.sceneWubao.autoRefresh();
				
				if (SceneManager.sceneMgr.curScene == SceneManager.SCENE_ATTACK_CITY)
					SceneManager.sceneMgr.sceneAttackCity.refreshTime();
			}
			
			if (GameManager.gameMgr.dipList != null)
				GameManager.gameMgr.dipList.clearOut();
		}
		
		/**
		 * 解析坞堡消息包 
		 * @param tcpBody
		 * 
		 */
		private function parseWubao(tcpBody:ByteArray):void
		{
			var gameWubao:WuBao = GameManager.gameMgr.wubao;
			if (gameWubao == null) return;
			
			gameWubao.uniqID = readInt(tcpBody);
			gameWubao.userID = readInt(tcpBody);
			
			var sphereID:int = readInt(tcpBody);
			var gameSphere:Sphere = null;
			
			//退出势力
			if (GameManager.gameMgr.isEnterGame && sphereID == 0 && gameWubao.sphereID > 0)
			{
				if (WinManager.winMgr.winSphere != null)
				{
					WinManager.winMgr.winSphere.visible = false;
					WinManager.winMgr.winSphere.includeInLayout = false;
				}
				
				gameSphere = GameManager.gameMgr.sphereList.getObjByID(gameWubao.sphereID) as Sphere;
				if (gameSphere != null)
				{
					gameSphere.userList.removeObjByID(gameWubao.userID);
					gameWubao.sphereID = 0;
					WinManager.winMgr.showResult("你退出了 " + gameSphere.sphereName + " 势力");
				}
				
				GameManager.gameMgr.gameApp.panelAttackCity.refresh();
			}
			
			var gameUser:User = GameManager.gameMgr.user;
			if (gameUser != null)
				gameUser.sphereID = sphereID;
			
			if (GameManager.gameMgr.isEnterGame && sphereID > 0 && gameWubao.sphereID == 0)
			{
				gameSphere = GameManager.gameMgr.sphereList.getObjByID(sphereID) as Sphere;
				if (gameSphere != null)
				{
					if (gameUser != null)
						gameSphere.userList.add(gameUser);
					
					gameWubao.sphereID = sphereID;
					GameManager.gameMgr.initOff();
						
					WinManager.winMgr.showResult("势力 " + gameSphere.sphereName + " 批准了你的加入申请");
					if (WinManager.winMgr.winSphereTip != null)
					{
						WinManager.winMgr.winSphereTip.visible = false;
						WinManager.winMgr.winSphereTip.includeInLayout = false;
					}
				}
				
				GameManager.gameMgr.gameApp.panelAttackCity.refresh();
			}
			
			gameWubao.sphereID = sphereID;
			gameWubao.cityID = readInt(tcpBody);
			gameWubao.digID = readInt(tcpBody);
			gameWubao.offID = readInt(tcpBody);
			if (gameWubao.offID > 0)
				GameManager.gameMgr.offList.setOff(gameWubao.offID, GameManager.gameMgr.userID);
			gameWubao.people = readInt(tcpBody);
			gameWubao.family = readInt(tcpBody);
			gameWubao.prestige = readInt(tcpBody);
			gameWubao.solNum = readInt(tcpBody);
			gameWubao.food = readInt(tcpBody);
			gameWubao.wood = readInt(tcpBody);
			gameWubao.iron = readInt(tcpBody);
			gameWubao.horse = readInt(tcpBody);
			gameWubao.skin = readInt(tcpBody);
			gameWubao.money = readInt(tcpBody);
			gameWubao.gotSol = readInt(tcpBody);
			gameWubao.useMade = readInt(tcpBody);
			gameWubao.cureSol = readInt(tcpBody);
			
			var i:int = 0;
			var weaponLen:int = 0;
			var weapon:Weapon = null;
			var weaponList:WeaponList = gameWubao.store.weaponList;
			
			weaponLen = readInt(tcpBody);
			for (i = 0;i < weaponLen; i++)
			{
				if (weaponList.hasObj(i))
					weapon = weaponList.getObjByID(i) as Weapon;
				else
				{
					weapon = new Weapon();
					weapon.uniqID = i;
					weaponList.add(weapon);
				}
				
				weapon.type = readInt(tcpBody);
				weapon.level = readInt(tcpBody);
				weapon.num = readInt(tcpBody);
			}
			
			var buildLen:int = 0;
			var build:Build = null;
			var buildList:BuildList = gameWubao.buildList;
			var type:int = 0;
			
			buildLen = readInt(tcpBody);
			for (i = 0; i < buildLen; i++)
			{
				type = readInt(tcpBody);
				
				if (buildList.hasObj(type))
					build = buildList.getObjByID(type) as Build;
				else
				{
					build = new Build();
					build.uniqID = type;
					buildList.add(build);
				}
				
				build.type = type;
				build.level = readInt(tcpBody);
				build.endTime = readInt(tcpBody);
			}
			
			var techLen:int = 0;
			var tech:Tech = null;
			var techList:TechList = gameWubao.techList;
			
			techLen = readInt(tcpBody);
			for (i = 0; i < techLen; i++)
			{
				type = readInt(tcpBody);
				
				if (techList.hasObj(type))
					tech = techList.getObjByID(type) as Tech;
				else
				{
					tech = new Tech();
					tech.uniqID = type;
					techList.add(tech);
				}
				
				tech.type = type;
				tech.level = readInt(tcpBody);
				tech.endTime = readInt(tcpBody);
			}
			
			var friLen:int = 0;
			var friend:Friend = null;
			var friendList:FriendList = GameManager.gameMgr.friendList;
			
			friLen = readInt(tcpBody);
			for (i = 0; i < friLen; i++)
			{
				var uniqID:int = readInt(tcpBody);
				
				if (friendList.hasObj(uniqID))
					friend = friendList.getObjByID(uniqID) as Friend;
				else
				{
					friend = new Friend();
					friend.uniqID = uniqID;
					friendList.add(friend);
				}
				
				friend.value = readInt(tcpBody);
			}
			
			if (GameManager.gameMgr.isEnterGame)
			{
				SceneManager.sceneMgr.sceneWubao.refreshBuild();
			}
			
			GameManager.gameMgr.gameApp.panelRes.refresh();	
			GameManager.gameMgr.gameApp.panelDate.refreshMenu();
			GameManager.gameMgr.gameApp.panelMenu.refresh();
			GameManager.gameMgr.gameApp.panelOperate.refreshMenu();
			WinManager.winMgr.refreshWin();
		}
		
		/**
		 * 解析武将消息包 
		 * @param tcpBody
		 * 
		 */
		
		private var count:int = 0;
		private function parseGeneral(tcpBody:ByteArray):void
		{
			
			var gameGeneral:General = null;
			var generalList:GeneralList = GameManager.gameMgr.generalList;
			
			var generalID:int = readInt(tcpBody);
			var place:int = 0;
			var placeID:int = 0;
			
			if (generalList.hasObj(generalID))
				gameGeneral = generalList.getObjByID(generalID) as General;
			else
			{
				gameGeneral = new General();
				gameGeneral.uniqID = generalID;
				generalList.add(gameGeneral);
			}
			
			var userID:int = 0;
			userID = readInt(tcpBody);
			gameGeneral.type = readByte(tcpBody);
			gameGeneral.firstName = readStr(tcpBody);
			gameGeneral.lastName = readStr(tcpBody);
			gameGeneral.zi = readStr(tcpBody);
			gameGeneral.sex = readByte(tcpBody);
			gameGeneral.bornYear = readInt(tcpBody);
			gameGeneral.initYear = readInt(tcpBody);
			place = readByte(tcpBody);
			placeID = readInt(tcpBody);
			gameGeneral.kongfu = readInt(tcpBody);
			gameGeneral.intelligence = readInt(tcpBody);
			gameGeneral.polity = readInt(tcpBody);
			gameGeneral.speed = readInt(tcpBody);
			gameGeneral.faith = readInt(tcpBody);
			gameGeneral.faceID = readInt(tcpBody);
			gameGeneral.isDead = readByte(tcpBody);
			gameGeneral.friend = readInt(tcpBody);
			gameGeneral.skill = readUInt(tcpBody);
			gameGeneral.zhen = readInt(tcpBody);
			gameGeneral.useZhen = readInt(tcpBody);
			gameGeneral.soliderNum = readInt(tcpBody);
			gameGeneral.soliderTrain = readInt(tcpBody);
			gameGeneral.soliderSpirit = readInt(tcpBody);
			gameGeneral.hurtNum = readInt(tcpBody);
			gameGeneral.killNum = readInt(tcpBody);
			gameGeneral.w1Type = readInt(tcpBody);
			gameGeneral.w1Level = readInt(tcpBody);
			gameGeneral.w2Type = readInt(tcpBody);
			gameGeneral.w2Level = readInt(tcpBody);
			gameGeneral.w3Type = readInt(tcpBody);
			gameGeneral.w3Level = readInt(tcpBody);
			gameGeneral.w4Type = readInt(tcpBody);
			gameGeneral.w4Level = readInt(tcpBody);
			
			//如果是自己的武将
			if (userID == GameManager.gameMgr.userID)
			{
				var generalTemp:General = GameManager.gameMgr.generalList.getObjByID(gameGeneral.uniqID) as General;
				if (GameManager.gameMgr.isEnterGame && generalTemp != null && generalTemp.userID != userID)
				{
					var str:String = "登用武将 " + gameGeneral.generalName + " 成功";
					WinManager.winMgr.showResult(str);
					if (WinManager.winMgr.winGive != null)
					{
						WinManager.winMgr.winGive.visible = false;
						WinManager.winMgr.winGive.includeInLayout = false;
					}
					if (WinManager.winMgr.winConsult != null)
					{
						WinManager.winMgr.winConsult.visible = false;
						WinManager.winMgr.winConsult.includeInLayout = false;
					}
				}
				
				gameGeneral.userID = userID;
				GameManager.gameMgr.wubao.generalList.add(gameGeneral);
			}
			
			//玩家自己的武将
			if (userID == GameManager.gameMgr.userID)
				GameManager.gameMgr.wubao.generalList.add(gameGeneral);
				
			//武将所在发生变化
			if (place != gameGeneral.place)
			{
				//找到武将所属的玩家所在的城池
				var gameCity:City = null;
				var gameUser:User = GameManager.gameMgr.userList.getObjByID(userID) as User;
				if (gameUser != null)
				{
					var cityID:int = gameUser.cityID;
					gameCity = GameManager.gameMgr.cityList.getObjByID(cityID) as City;
				}
				
				var gameCityTemp:City = null;
				
				//历史武将坞堡
				if (place == 1 && gameGeneral.type == 1 && gameCity != null)
				{
					gameCity.generalList.add(gameGeneral);
					
					//武将被玩家招募
					if (gameGeneral.place == 2)
					{
						gameCityTemp = GameManager.gameMgr.cityList.getObjByID(gameGeneral.placeID) as City;
						if (gameCityTemp != null)
							gameCityTemp.generalList.removeObjByID(gameGeneral.uniqID);
					} 
				}
				//城池
				else if (place == 2)
				{
					var gameCityNew:City = null;
					gameCityNew = GameManager.gameMgr.cityList.getObjByID(placeID) as City;
					if (gameCityNew != null)
						gameCityNew.generalList.add(gameGeneral);
					
					//武将更改城池位置
					var gameCityOld:City = null;
					if (gameGeneral.place == 2 && placeID != gameGeneral.placeID)
					{
						gameCityOld = GameManager.gameMgr.cityList.getObjByID(gameGeneral.placeID) as City;
						if (gameCityOld != null)
							gameCityOld.generalList.removeObjByID(gameGeneral.uniqID);
					}
				}
				//军团或输送路途中
				else if (place == 3 || place == 4)
				{
					//从坞堡出征或派遣
					if (gameGeneral.place == 1)
						gameCity.generalList.removeObjByID(gameGeneral.uniqID);
					//从城池出征或派遣						
					else if (gameGeneral.place == 2)
					{
						gameCityTemp = GameManager.gameMgr.cityList.getObjByID(gameGeneral.placeID) as City;
						gameCityTemp.generalList.removeObjByID(gameGeneral.uniqID);
					}
				}
				
				if (place != 4)
					GameManager.gameMgr.tranList.removeByGeneralID(gameGeneral.uniqID);	
			}
			//武将被解雇
			else if (placeID != gameGeneral.placeID)
			{
				var gameCityFrom:City = GameManager.gameMgr.cityList.getObjByID(gameGeneral.placeID) as City;
				if (gameCityFrom != null)
					gameCityFrom.generalList.removeObjByID(gameGeneral.uniqID);
					
				var gameCityTo:City = GameManager.gameMgr.cityList.getObjByID(placeID) as City;
				if (gameCityTo != null)
					gameCityTo.generalList.add(gameGeneral);
			}
			
			gameGeneral.userID = userID;
			gameGeneral.place = place;
			gameGeneral.placeID = placeID;
			
			//酒馆中的武将
			if (gameGeneral.place == 1 && gameGeneral.placeID == GameManager.gameMgr.wubao.uniqID && gameGeneral.userID == 0)
				GameManager.gameMgr.wubao.generalStand = gameGeneral;
				
			generalNum ++;
		}
		
		/**
		 * 解析城池消息包 
		 * @param tcpBody
		 * 
		 */		
		private function parseCity(tcpBody:ByteArray):void
		{
			var gameCity:City = null;
			var cityList:CityList = GameManager.gameMgr.cityList;
			
			var cityID:int = readInt(tcpBody);
			if (cityList.hasObj(cityID))
				gameCity = cityList.getObjByID(cityID) as City;
			else
			{
				gameCity = new City();
				gameCity.uniqID = cityID;
				cityList.add(gameCity);
			}
			
			var sphereID:int = readInt(tcpBody);
			var cityState:int = readByte(tcpBody);
			gameCity.cityName = readStr(tcpBody);
			gameCity.level = readByte(tcpBody);
			gameCity.junName = readStr(tcpBody);
			gameCity.zhouName = readStr(tcpBody);
			gameCity.description = readStr(tcpBody);
			gameCity.mapX = readInt(tcpBody);
			gameCity.mapY = readInt(tcpBody);
			gameCity.isAlloted = readByte(tcpBody); 
			gameCity.junCode = readInt(tcpBody);
			gameCity.zhouCode = readInt(tcpBody);
			gameCity.wubaoNum = readInt(tcpBody);
			gameCity.solNum = readInt(tcpBody);
			gameCity.defense = readInt(tcpBody);
			gameCity.wubaoTotal = readInt(tcpBody);
			
			if (gameCity.uniqID == 0)
				cityList.removeObjByID(gameCity.uniqID);
				
			if (sphereID > 0)
			{
				var gameSphere:Sphere = GameManager.gameMgr.sphereList.getObjByID(sphereID) as Sphere;
				if (gameSphere != null)
					gameSphere.cityList.add(gameCity);
			}
			
			if (GameManager.gameMgr.isEnterGame)
			{
				if (sphereID > 0 && sphereID != gameCity.sphereID && MapManager.mapMgr.isInitMap)
					MapManager.mapMgr.drawSmallMap();
				
				gameCity.sphereID = sphereID;
					
				if (cityState == 2 && cityState != gameCity.cityState)
				{
					var str:String = "";
					var warDate:String = GameManager.gameMgr.gameYear.toString() + "年" + GameManager.gameMgr.gameMonth.toString() + "月" + 
					                     GameManager.gameMgr.gameDay.toString() + "日";
					                     
					str = warDate + "<a href='event:" + "cID" + gameCity.uniqID.toString() + "'><font color='#f5f600'>" + "【<b>" +
						  gameCity.cityName + "</b>】</font></a>" + "<font color='#f5f600'>发生了战争</font>";
					
					GameManager.gameMgr.gameApp.chatMain.sendAllInfo(str);
				}
					
				
				gameCity.cityState = cityState;
				MapManager.mapMgr.setCityState(gameCity);
			}
			
			gameCity.sphereID = sphereID;
			gameCity.cityState = cityState;
		}
		
		/**
		 * 解析势力消息包 
		 * @param tcpBody
		 * 
		 */		
		private function parseSphere(tcpBody:ByteArray):void
		{
			var gameSphere:Sphere = null;
			var spereList:SphereList = GameManager.gameMgr.sphereList;
			
			var sphereID:int = readInt(tcpBody);
			if (spereList.hasObj(sphereID))
				gameSphere = spereList.getObjByID(sphereID) as Sphere;
			else
			{
				gameSphere = new Sphere();
				gameSphere.uniqID = sphereID;
				spereList.add(gameSphere);
			}
			
			var userID:int = readInt(tcpBody);	
			gameSphere.sphereName = readStr(tcpBody);
				
			gameSphere.level = readInt(tcpBody);
			gameSphere.prestige = readInt(tcpBody);
			gameSphere.description = readStr(tcpBody);
			
			if (gameSphere.uniqID == 0)
				spereList.removeObjByID(gameSphere.uniqID);
			
			if (GameManager.gameMgr.isEnterGame)
			{
				//势力禅让
				if (gameSphere.userID > 0 && gameSphere.userID != userID && userID == GameManager.gameMgr.userID)
				{
					WinManager.winMgr.showResult("恭喜，您当选为新君主");
					if (WinManager.winMgr.winSphere != null)
						WinManager.winMgr.winSphere.refresh();
				}
				
				var gameUser:User = GameManager.gameMgr.userList.getObjByID(gameSphere.userID) as User;
				if (gameUser != null)
					gameSphere.userList.add(gameUser);
			}
			
			gameSphere.userID = userID;
			sphereNum ++;
		}
		
		/**
		 * 解析军团消息包 
		 * @param tcpBody
		 * 
		 */
		
		private var armyIndex:int = 0;		
		private function parseArmy(tcpBody:ByteArray):void
		{
			var gameArmy:Army = null;
			var armyList:ArmyList = GameManager.gameMgr.armyList;
			
			var armyID:int = readInt(tcpBody);
			if (armyList.hasObj(armyID))
				gameArmy = armyList.getObjByID(armyID) as Army;
			else
			{
				gameArmy = new Army();
				gameArmy.uniqID = armyID;
				armyList.add(gameArmy);
			}
			
			var state:int = 0;	
			gameArmy.generalID = readInt(tcpBody);
			state = readByte(tcpBody);
			gameArmy.mapX = readInt(tcpBody);
			gameArmy.mapY = readInt(tcpBody);
			gameArmy.money = readInt(tcpBody);
			gameArmy.food = readInt(tcpBody);
			gameArmy.original = readInt(tcpBody);
			gameArmy.type = readByte(tcpBody);
			
			var i:int = 0;
			var moveLen:int = 0;
			var moveList:Array = [];
			
			moveLen = readInt(tcpBody);
			if (moveLen > 0)
			{
				for(i = 0; i < moveLen; i++)
				{
					moveList[i] = new Array();
					moveList[i][0] = readShort(tcpBody);
					moveList[i][1] = readShort(tcpBody);
					moveList[i][2] = readShort(tcpBody);
					moveList[i][3] = readShort(tcpBody);
					moveList[i][4] = readInt(tcpBody);
				}
				
				gameArmy.moveList = moveList;	
			}
			
			if (gameArmy.uniqID == 0)
				armyList.removeObjByID(gameArmy.uniqID);
			
			armyIndex++;
		}
		
		/**
		 * 解析用户消息包 
		 * @param tcpBody
		 * 
		 */		
		private function parseUser(tcpBody:ByteArray):void
		{
			var gameUser:User = null;
			var userList:UserList = GameManager.gameMgr.userList;
			
			var userID:int = readInt(tcpBody);
			if (userList.hasObj(userID))
				gameUser = userList.getObjByID(userID) as User;
			else
			{
				gameUser = new User();
				gameUser.uniqID = userID;
				userList.add(gameUser);
			}
			
			var sphereID:int = readInt(tcpBody);
			var gameSphere:Sphere = null;
			
			//玩家退出势力
			if (GameManager.gameMgr.isEnterGame && sphereID == 0 && gameUser.sphereID > 0 && gameUser.sphereID == GameManager.gameMgr.wubao.sphereID)
			{
				gameSphere = GameManager.gameMgr.sphereList.getObjByID(gameUser.sphereID) as Sphere;
				if (gameSphere != null)
					gameSphere.userList.removeObjByID(gameUser.uniqID);
				
				gameUser.sphereID = sphereID;
				if (WinManager.winMgr.winSphere != null)
					WinManager.winMgr.winSphere.showByIndex();
			}
			
			gameUser.sphereID = sphereID;
			gameUser.userName = readStr(tcpBody);
			gameUser.prestige = readInt(tcpBody);
			gameUser.gong = readInt(tcpBody);
			gameUser.level = readInt(tcpBody);
			gameUser.digID = readInt(tcpBody);
			gameUser.offID = readInt(tcpBody);
			
			//申请官位成功
			if (gameUser.offID > 0 && gameUser.sphereID == GameManager.gameMgr.wubao.sphereID)
				GameManager.gameMgr.offList.setOff(gameUser.offID, gameUser.uniqID);
				
			gameUser.lastLogin = readInt(tcpBody);
			gameUser.isOnline = readByte(tcpBody);
			gameUser.vipTotal = readInt(tcpBody);
			gameUser.vipUsed = readInt(tcpBody);
			gameUser.wubaoID = readInt(tcpBody);
			var cityID:int = readInt(tcpBody);
			//玩家迁城
			if (cityID != gameUser.cityID)
			{
				var gameCityFrom:City = GameManager.gameMgr.cityList.getObjByID(gameUser.cityID) as City;
				var gameCityTo:City = GameManager.gameMgr.cityList.getObjByID(cityID) as City;
				
				if (gameCityFrom != null)
					gameCityFrom.userList.removeObjByID(gameUser.uniqID);
				if (gameCityTo != null)
					gameCityTo.userList.add(gameUser);	
			}
			
			gameUser.cityID = cityID;
			gameUser.taskID = readInt(tcpBody);
			gameUser.taskState = readInt(tcpBody);
			gameUser.orderCD = readInt(tcpBody);
			gameUser.leftOrder = readInt(tcpBody);
			gameUser.trainCD = readInt(tcpBody);
			gameUser.preCount = readInt(tcpBody);
			gameUser.robCount = readInt(tcpBody);
			gameUser.rank = readInt(tcpBody);
			gameUser.gateID = readInt(tcpBody);
			gameUser.isClose = readInt(tcpBody) == 0 ? false : true;
			gameUser.guidIndex = readInt(tcpBody);
			
			var i:int = 0;
			var taskNum:int = readInt(tcpBody);
			gameUser.finishTask.length = 0;
			
			for (i = 0; i < taskNum; i++)
			{
				gameUser.finishTask.push(readInt(tcpBody));
			}
			
			if (userID == GameManager.gameMgr.userID)
			{
				GameManager.gameMgr.user = gameUser;
				gameSphere = GameManager.gameMgr.sphereList.getObjByID(gameUser.sphereID) as Sphere;
				
				GameManager.gameMgr.gameApp.panelDate.refreshInfo();
				GameManager.gameMgr.gameApp.panelQuene.refresh();
				
				if (GameManager.gameMgr.isEnterGame)
					GameManager.gameMgr.gameApp.panelTip.refresh();
					
				if (WinManager.winMgr.winTask != null && WinManager.winMgr.winTask.visible)
					WinManager.winMgr.winTask.refresh();
			}
			
			if (gameUser.sphereID > 0)
			{
				gameSphere = GameManager.gameMgr.sphereList.getObjByID(gameUser.sphereID) as Sphere;
				if (gameSphere != null)
					gameSphere.userList.add(gameUser);
			}
		}
		
		/**
		 * 解析外交关系信息 
		 * @param tcpBody
		 * 
		 */		
		private function parseDip(tcpBody:ByteArray):void
		{
			var gameDip:Diplomacy = null;
			var dipList:DipList = GameManager.gameMgr.dipList;
			
			var dipID:int = readInt(tcpBody);
			if (dipList.hasObj(dipID))
				gameDip = dipList.getObjByID(dipID) as Diplomacy;
			else
			{
				gameDip = new Diplomacy();
				gameDip.uniqID = dipID;
				dipList.add(gameDip);
			}
				
			gameDip.type = readInt(tcpBody);
			gameDip.selfID = readInt(tcpBody);
			gameDip.targetID = readInt(tcpBody);
			gameDip.startTime = readInt(tcpBody);
			gameDip.endTime = readInt(tcpBody);
			
			if (gameDip.selfID == gameDip.targetID)
				dipList.removeObjByID(gameDip.uniqID);
		}
		
		/**
		 * 解析玩家的道具信息 
		 * @param tcpBody
		 * 
		 */		
		private function parseTreasure(tcpBody:ByteArray):void
		{
			var ut:UserTreasure = null;
			var treasureList:UserTsList = GameManager.gameMgr.userTsList;
			var treasure:Treasure = null;
			
			var uniqID:int = readInt(tcpBody);
			if (treasureList.hasObj(uniqID))
				ut = treasureList.getObjByID(uniqID) as UserTreasure;
			else
			{
				ut = new UserTreasure();
				ut.uniqID = uniqID;
				treasureList.add(ut);
			}
				
			ut.treasureID = readInt(tcpBody);
			ut.generalID = readInt(tcpBody);
			ut.isUsed = readByte(tcpBody);
			ut.userID = readInt(tcpBody);
			ut.useTime = readInt(tcpBody);
			
			if (GameManager.gameMgr.treasureList != null)
			{
				treasure = GameManager.gameMgr.treasureList.getObjByID(ut.treasureID) as Treasure;
				ut.treasure = treasure;
			}
		}
		
		/**
		 * 解析战争消息 
		 * @param tcpBody
		 * 
		 */		
		private function parseWar(tcpBody:ByteArray):void
		{
			var war:TcpWar = new TcpWar();
			
			war.type = readByte(tcpBody);
			war.obj1ID = readInt(tcpBody);
			war.obj1Die = readInt(tcpBody);
			war.obj1Hurt = readInt(tcpBody);
			war.obj1Skill = readInt(tcpBody);
			war.obj2ID = readInt(tcpBody);
			war.obj2Die = readInt(tcpBody);
			war.obj2Hurt = readInt(tcpBody);
			war.obj2Skill = readInt(tcpBody);
			war.defense = readInt(tcpBody);
		}
		
		/**
		 * 解析邮件消息 
		 * @param tcpBody
		 * 
		 */		
		private function parseMail(tcpBody:ByteArray):void
		{
			var gameMail:Mail = null;
			var mailList:MailList = GameManager.gameMgr.mailList;
			
			var uniqID:int = readInt(tcpBody);
			if (mailList.hasObj(uniqID))
				gameMail = mailList.getObjByID(uniqID) as Mail;
			else
			{
				gameMail = new Mail();
				gameMail.uniqID = uniqID;
				mailList.add(gameMail);
			}
			
			gameMail.senderID = readInt(tcpBody);
			gameMail.senderName = readStr(tcpBody);
			gameMail.receiveID = readInt(tcpBody);
			gameMail.receiveName = readStr(tcpBody);
			gameMail.title = readStr(tcpBody);
			gameMail.content = readStr(tcpBody);
			gameMail.isRead = readByte(tcpBody);
			gameMail.type = readInt(tcpBody);
			gameMail.sendTime = readInt(tcpBody);
			
			var type:int = gameMail.type;
			if (type == 1 || type == 2)
				GameManager.gameMgr.gameApp.panelMenu.flashSphere();
			
			GameManager.gameMgr.gameApp.panelTip.refresh();
		}
		
		/**
		 * 解析聊天消息 
		 * @param tcpBody
		 * 
		 */		
		private function parseChat(tcpBody:ByteArray):void
		{
			var tcpChat:TcpChat = new TcpChat();
			tcpChat.sendID = readInt(tcpBody);
			tcpChat.recvID = readInt(tcpBody);
			tcpChat.chatInfo = readStr(tcpBody);
			
			if (GameManager.gameMgr.isEnterGame)
				GameManager.gameMgr.gameApp.chatMain.showInfo(tcpChat);
			else
				GameManager.gameMgr.chatBuf.push(tcpChat);
		}
		
		/**
		 * 解析输送指令
		 * @param tcpBody
		 * 
		 */		
		private function parseTran(tcpBody:ByteArray):void
		{
			var gameTran:Transfer = null;
			var tranList:TranList = GameManager.gameMgr.tranList;
			
			var tranID:int = readInt(tcpBody);
			if (tranList.hasObj(tranID))
				gameTran = tranList.getObjByID(tranID) as Transfer;
			else
			{
				gameTran = new Transfer();
				gameTran.uniqID = tranID;
				tranList.add(gameTran);
			}
			
			gameTran.fromID = readInt(tcpBody);
			gameTran.toID = readInt(tcpBody);
			gameTran.type = readInt(tcpBody);
			gameTran.sphereID = readInt(tcpBody);
			gameTran.objType = readInt(tcpBody);
			gameTran.objID = readInt(tcpBody);
			gameTran.objNum = readInt(tcpBody);
			gameTran.endTime = readInt(tcpBody);
		}
		
		/**
		 * 解析挂单交易通知 
		 * @param tcpBody
		 * 
		 */		
		private function parseBill(tcpBody:ByteArray):void
		{
			var gameBill:Bill = null;
			var billList:BillList = GameManager.gameMgr.billList;
			
			var billID:int = readInt(tcpBody);
			if (billList.hasObj(billID))
				gameBill = billList.getObjByID(billID) as Bill;
			else
			{
				gameBill = new Bill();
				gameBill.uniqID = billID;
				billList.add(gameBill);
			}
			
			gameBill.userID = readInt(tcpBody);
			gameBill.type = readInt(tcpBody);
			gameBill.resType = readInt(tcpBody);
			gameBill.resNum = readInt(tcpBody) / 100;
			gameBill.dealNum = readInt(tcpBody) / 100;
			gameBill.price = readInt(tcpBody);
			gameBill.billTime = readInt(tcpBody);
			
			//是否删除
			var isDel:int = readInt(tcpBody);
			if (isDel == 1)
				billList.removeObjByID(gameBill.uniqID);
			
			if (WinManager.winMgr.winDeal != null && WinManager.winMgr.winDeal.visible)
				 WinManager.winMgr.winDeal.showBill();
		}
		
		/**
		 * 解析销售武器通知
		 * @param tcpBody
		 * 
		 */		
		private function parseSell(tcpBody:ByteArray):void
		{
			var gameSell:Sell = null;
			var sellList:SellList = GameManager.gameMgr.sellList;
			
			var sellID:int = readInt(tcpBody);
			if (sellList.hasObj(sellID))
				gameSell = sellList.getObjByID(sellID) as Sell;
			else
			{
				gameSell = new Sell();
				gameSell.uniqID = sellID;
				sellList.add(gameSell);
			}
			
			gameSell.userID = readInt(tcpBody);
			gameSell.type = readInt(tcpBody);
			gameSell.level = readInt(tcpBody);
			gameSell.num = readInt(tcpBody);
			gameSell.price = readInt(tcpBody);
			gameSell.sellTime = readInt(tcpBody);
			
			//是否删除
			var isDel:int = readInt(tcpBody);
			if (isDel == 1)
				sellList.removeObjByID(gameSell.uniqID);
				
			if (WinManager.winMgr.winDeal != null && WinManager.winMgr.winDeal.visible)
				 WinManager.winMgr.winDeal.showSell();
		}
		
		/**
		 * 解析战况通知 
		 * @param tcpBody
		 * 
		 */		
		private function parseFight(tcpBody:ByteArray):void
		{
			var tcpFight:TcpFightNtf = new TcpFightNtf();
			var i:int = 0;
			var generalName:String = "";
			
			tcpFight.warID = readInt(tcpBody);
			tcpFight.gateID = readInt(tcpBody);
			tcpFight.selfName = readStr(tcpBody);
			tcpFight.selfNum = readInt(tcpBody);
			tcpFight.selfID = readInt(tcpBody);
			for (i = 0; i < tcpFight.selfNum; i++)
			{
				var selfGeneral:General = new General();
				selfGeneral.uniqID = readInt(tcpBody);
				selfGeneral.firstName = readStr(tcpBody);
				selfGeneral.soliderNum = readInt(tcpBody);
				selfGeneral.w1Type = readInt(tcpBody);
				selfGeneral.w1Level = readInt(tcpBody);
				selfGeneral.w2Type = readInt(tcpBody);
				selfGeneral.w2Level = readInt(tcpBody);
				selfGeneral.w3Type = readInt(tcpBody);
				selfGeneral.w3Level = readInt(tcpBody);
				selfGeneral.w4Type = readInt(tcpBody);
				selfGeneral.w4Level = readInt(tcpBody);
				selfGeneral.useZhen = readInt(tcpBody);
				selfGeneral.soliderSpirit = readInt(tcpBody);
				selfGeneral.soliderTrain = readInt(tcpBody);
				tcpFight.selfList.push(selfGeneral);
			}
			
			tcpFight.eneName = readStr(tcpBody);
			tcpFight.eneNum = readInt(tcpBody);
			tcpFight.eneID = readInt(tcpBody);
			for (i = 0; i < tcpFight.eneNum; i++)
			{
				var eneGeneral:General = new General();
				eneGeneral.uniqID = readInt(tcpBody);
				eneGeneral.firstName = readStr(tcpBody);
				eneGeneral.soliderNum = readInt(tcpBody);
				eneGeneral.w1Type = readInt(tcpBody);
				eneGeneral.w1Level = readInt(tcpBody);
				eneGeneral.w2Type = readInt(tcpBody);
				eneGeneral.w2Level = readInt(tcpBody);
				eneGeneral.w3Type = readInt(tcpBody);
				eneGeneral.w3Level = readInt(tcpBody);
				eneGeneral.w4Type = readInt(tcpBody);
				eneGeneral.w4Level = readInt(tcpBody);
				eneGeneral.useZhen = readInt(tcpBody);
				eneGeneral.soliderSpirit = readInt(tcpBody);
				eneGeneral.soliderTrain = readInt(tcpBody);
				tcpFight.eneList.push(eneGeneral);
			}
			
			tcpFight.roundNum = readInt(tcpBody);
			
			for (i = 0; i < tcpFight.roundNum; i++)
			{
				var round:Object = new Object();
				round.selfID = readInt(tcpBody);
				round.selfDie = readInt(tcpBody);
				round.selfSkill = readInt(tcpBody);
				round.selfSpirit = readInt(tcpBody);
				round.eneID = readInt(tcpBody);
				round.eneDie = readInt(tcpBody);
				round.eneSkill = readInt(tcpBody);
				round.eneSpirit = readInt(tcpBody);
				tcpFight.roundList.push(round);
			}
			
			tcpFight.isWin = readInt(tcpBody);
			tcpFight.selfDie = readInt(tcpBody);
			tcpFight.eneDie = readInt(tcpBody);
			tcpFight.pre = readInt(tcpBody);
			tcpFight.weaponID = readInt(tcpBody);
			tcpFight.weaponLevel = readInt(tcpBody);
			tcpFight.weaponNum = readInt(tcpBody);
			
			if (tcpFight.warID > 0)
				GameManager.gameMgr.cityFightList.push(tcpFight);
			else
				SceneManager.sceneMgr.enterFight(tcpFight);
		}
		
		/**
		 * 解析俸禄通知 
		 * @param tcpBody
		 * 
		 */		
		private function parseSalary(tcpBody:ByteArray):void
		{
			var money:int = readInt(tcpBody);
			var food:int = readInt(tcpBody);
			var wood:int = readInt(tcpBody);
			var iron:int = readInt(tcpBody);
			var skin:int = readInt(tcpBody);
			var horse:int = readInt(tcpBody);
			var coin:int = readInt(tcpBody);
			
			var str:String = "成功领取俸禄：【金币】 " + FormatText.packegText(coin.toString());
			WinManager.winMgr.showResult(str);
		}
		
		/**
		 * 解析战役数据 
		 * @param tcpBody
		 * 
		 */		
		private function parseZhanyi(tcpBody:ByteArray):void
		{
			var gameBattle:Battle = null;
			var battleList:BattleList = GameManager.gameMgr.battleList;
			
			var battleID:int = readInt(tcpBody);
			if (battleList.hasObj(battleID))
				gameBattle = battleList.getObjByID(battleID) as Battle;
			else
			{
				gameBattle = new Battle();
				gameBattle.uniqID = battleID;
				battleList.add(gameBattle);
			}
			
			gameBattle.picURL = readStr(tcpBody);
			gameBattle.title = readStr(tcpBody);
			gameBattle.info = readStr(tcpBody);
			gameBattle.infoPos = readInt(tcpBody);
		}
		
		/**
		 * 解析关卡数据 
		 * @param tcpBody
		 * 
		 */		
		private function parseGuan(tcpBody:ByteArray):void
		{
			var gameGate:Gateway = null;
			var gateList:GatewayList = GameManager.gameMgr.gateList;
			
			var gateID:int = readInt(tcpBody);
			if (gateList.hasObj(gateID))
				gameGate = gateList.getObjByID(gateID) as Gateway;
			else
			{
				gameGate = new Gateway();
				gameGate.uniqID = gateID;
				gateList.add(gameGate);
			}
			
			gameGate.battleID = readInt(tcpBody);
			gameGate.name = readStr(tcpBody);
			gameGate.x = readInt(tcpBody);
			gameGate.y = readInt(tcpBody);
			gameGate.prestige = readInt(tcpBody);
			gameGate.type = readInt(tcpBody);
			gameGate.level = readInt(tcpBody);
			gameGate.num = readInt(tcpBody);
			gameGate.countMax = readInt(tcpBody);
			gameGate.per = readInt(tcpBody);
			gameGate.CD = readInt(tcpBody);
			gameGate.count = readInt(tcpBody);
		}
		
		/**
		 * 解析战役武将数据 
		 * @param tcpBody
		 * 
		 */		
		private function parsePK(tcpBody:ByteArray):void
		{
			var gateGeneral:GateGeneral = null;
			var generalList:GateGeneralList = GameManager.gameMgr.gateGeneralList;
			
			var generalID:int = readInt(tcpBody);
			if (generalList.hasObj(generalID))
				gateGeneral = generalList.getObjByID(generalID) as GateGeneral;
			else
			{
				gateGeneral = new GateGeneral();
				gateGeneral.uniqID = generalID;
				generalList.add(gateGeneral);
			}
			
			gateGeneral.general.uniqID = generalID;
			gateGeneral.gateID = readInt(tcpBody);
			var generalName:String = readStr(tcpBody);
			gateGeneral.general.firstName = generalName.substr(0, 1);
			gateGeneral.general.lastName = generalName.substr(1, generalName.length);
			gateGeneral.general.faceID = readInt(tcpBody);
			gateGeneral.general.skill = readInt(tcpBody);
			gateGeneral.general.useZhen = readInt(tcpBody);
			gateGeneral.general.kongfu = readInt(tcpBody);
			gateGeneral.general.intelligence = readInt(tcpBody);
			gateGeneral.general.polity = readInt(tcpBody);
			gateGeneral.general.w1Type = readInt(tcpBody);
			gateGeneral.general.w1Level = readInt(tcpBody); 
			gateGeneral.general.w2Type = readInt(tcpBody);
			gateGeneral.general.w2Level = readInt(tcpBody); 
			gateGeneral.general.w3Type = readInt(tcpBody);
			gateGeneral.general.w3Level = readInt(tcpBody); 
			gateGeneral.general.w4Type = readInt(tcpBody);
			gateGeneral.general.w4Level = readInt(tcpBody);
			var soliderNum:int = readInt(tcpBody);
			gateGeneral.general.soliderNum = soliderNum;
			gateGeneral.general.soliderTotal = soliderNum;
			gateGeneral.general.soliderTrain = readInt(tcpBody);
			gateGeneral.general.soliderSpirit = readInt(tcpBody);
		}
		
		/**
		 * 解析攻打城池战场通知
		 * @param tcpBody
		 * 
		 */		
		private function parseAttackCity(tcpBody:ByteArray):void
		{
			var attackCity:AttackCity = null;
			var atkCityList:AttackCityList = GameManager.gameMgr.atkCityList;
			
			var warID:int = readInt(tcpBody);
			if (atkCityList.hasObj(warID))
				attackCity = atkCityList.getObjByID(warID) as AttackCity;
			else
			{
				attackCity = new AttackCity();
				attackCity.uniqID = warID;
				atkCityList.add(attackCity);
			}
			
			attackCity.atkSphereID = readInt(tcpBody);
			attackCity.dfsSphereID = readInt(tcpBody);
			attackCity.cityID = readInt(tcpBody);
			attackCity.warTime = readInt(tcpBody);
			
			var i:int = 0;
			var atkUserNum:int = readInt(tcpBody);
			var gameUser:User = null;
			
			for (i = 0; i < atkUserNum; i++)
			{
				gameUser = new User();
				gameUser.uniqID = readInt(tcpBody);
				gameUser.userName = readStr(tcpBody);
				gameUser.level = readInt(tcpBody);
				gameUser.sphereID = attackCity.atkSphereID;
				attackCity.atkUserList.add(gameUser);
			}
			
			var dfsUserNum:int = readInt(tcpBody);
			
			for (i = 0; i < dfsUserNum; i++)
			{
				gameUser = new User();
				gameUser.uniqID = readInt(tcpBody);
				gameUser.userName = readStr(tcpBody);
				gameUser.level = readInt(tcpBody);
				gameUser.sphereID = attackCity.dfsSphereID;
				attackCity.dfsUserList.add(gameUser);
			}
			
			GameManager.gameMgr.gameApp.panelAttackCity.refresh();
		}
		
		/**
		 * 解析进入战场通知 
		 * @param tcpBody
		 * 
		 */		
		private function parseJoinAttack(tcpBody:ByteArray):void
		{
			var warID:int = readInt(tcpBody);
			var atkCityList:AttackCityList = GameManager.gameMgr.atkCityList;
			var attackCity:AttackCity = atkCityList.getObjByID(warID) as AttackCity;
			if (attackCity != null)
			{
				var gameUser:User = new User();
				gameUser.uniqID = readInt(tcpBody);
				gameUser.sphereID = readInt(tcpBody);
				gameUser.userName = readStr(tcpBody);
				gameUser.level = readInt(tcpBody);
				
				if (gameUser.sphereID == attackCity.atkSphereID)
					attackCity.atkUserList.add(gameUser);
				else
					attackCity.dfsUserList.add(gameUser);
			}
			
			if (SceneManager.sceneMgr.curScene == SceneManager.SCENE_ATTACK_CITY)
				SceneManager.sceneMgr.sceneAttackCity.refresh(warID);
		}
		
		/**
		 * 解析退出战场通知 
		 * @param tcpBody
		 * 
		 */		
		private function parseExitAttack(tcpBody:ByteArray):void
		{
			var warID:int = readInt(tcpBody);
			var atkCityList:AttackCityList = GameManager.gameMgr.atkCityList;
			var attackCity:AttackCity = atkCityList.getObjByID(warID) as AttackCity;
			if (attackCity != null)
			{
				var i:int = 0;
				var gameUser:User = null;
				var userID:int = readInt(tcpBody);
				
				for (i = 0; i < attackCity.atkUserList.length; i++)
				{
					gameUser = attackCity.atkUserList.getObjByIndex(i) as User;
					if (gameUser != null && gameUser.uniqID == userID)
					{
						attackCity.atkUserList.removeObjByID(userID);
						break;
					}
				} 
				
				for (i = 0; i < attackCity.dfsUserList.length; i++)
				{
					gameUser = attackCity.dfsUserList.getObjByIndex(i) as User;
					if (gameUser != null && gameUser.uniqID == userID)
					{
						attackCity.dfsUserList.removeObjByID(userID);
						break;
					}
				} 
			}
			
			if (SceneManager.sceneMgr.curScene == SceneManager.SCENE_ATTACK_CITY)
				SceneManager.sceneMgr.sceneAttackCity.refresh(warID);
		}
		
		/**
		 * 解析战场结束通知 
		 * @param tcpBody
		 * 
		 */		
		private function parseAttackFinish(tcpBody:ByteArray):void
		{
			var warID:int = readInt(tcpBody);
			var isWin:int = readInt(tcpBody);
			
			if (SceneManager.sceneMgr.curScene == SceneManager.SCENE_ATTACK_CITY && SceneManager.sceneMgr.sceneAttackCity.visible &&
			    warID == SceneManager.sceneMgr.sceneAttackCity.warID)
			{
				SceneManager.sceneMgr.sceneAttackCity.isWin = isWin;
				SceneManager.sceneMgr.sceneAttackCity.start(warID);
			}
			else
			{
				var atkCityList:AttackCityList = GameManager.gameMgr.atkCityList;
				atkCityList.removeObjByID(warID);
				GameManager.gameMgr.gameApp.panelAttackCity.refresh();
				GameManager.gameMgr.cityFightList.length = 0;
			}
		}
		
		/**
		 * 处理tcp服务器返回的响应消息 
		 * @param evt
		 * 
		 */		
		private function dealResponse(res:Response):void
		{
			switch(res.type)
			{
				//成功
				case TcpResType.SUCCESS_CODE:
				{
					showResult(res.msgID, true, res.resReason);
					
					break;
				}
				
				//客户端请求格式有问题
				case TcpResType.CLIENT_ERROR_CODE:
				{
					showResult(res.msgID, false, res.resReason);
					
					break;
				}
				
				//客户端消息请求类型不存在
				case TcpResType.CLIENT_MSG_TYPE_NOT_FOUND_CODE:
				{
					showResult(res.msgID, false, res.resReason);
					
					break;
				}
				
				//已经登录，禁止多点登录
				case TcpResType.HAVE_LOGIN_CODE:
				{
					showResult(res.msgID, false, res.resReason);
					
					break;
				}
				
				//服务器处理错误
				case TcpResType.SERVER_ERROR_CODE:
				{
					showResult(res.msgID, false, res.resReason);
					
					break;
				}
				
				default:
				{
					break;
				}
				
			}
		}
		
		/**
		 * 根据服务器发来的响应消息显示结果提示窗口 
		 * @param msgID      消息ID
		 * @param isSuccess  消息发送是否成功
		 * @param reson      原因
		 * 
		 */		
		private function showResult(msgID:int, isSuccess:Boolean, reason:String = ""):void
		{
			var successInfo:String = "成功";
			var errorInfo:String = "失败";
			var errorReason:String = "";
			
			//根据消息ID获取对应的消息类型
			var msgType:int = getTypeByMsgID(msgID);
			var obj:Object = getSendObjByMsgID(msgID);
			
			var i:int = 0;
			var info:String = "";
			var gameWubao:WuBao = null;
			var gameCity:City = null;
			var gameSphere:Sphere = null;
			var gameUser:User = null;
			var gameGeneral:General = null;
			var friend:Friend = null;
			
			if (!isSuccess)
			{
				if (reason != "")
					errorReason = ": " + reason; 
			}
			
			//根据消息类型显示不同的提示窗口
			switch(msgType)
			{
				//用户登录
				case TcpType.SEND_USER_LOGIN:
				{
					if (isSuccess)
					{
						if (!isCreateUser)
						{
							isTcpFinish = true;
							HttpManager.httpMgr.startLoad();
						}
					}
					else
					{
						TcpManager.tcpMgr.closeTcp();
						WinManager.winMgr.showResult(reason, true, false, 1);
					}	
					
					break;
				}
				
				//创建角色
				case TcpType.SEND_CREATE_USER:
				{
					if (isSuccess)
					{
						WinManager.winMgr.removeCreateUser();
						sendUerLogin();
						isCreateUser = false;
					}
					else
						WinManager.winMgr.showResult(TcpType.CREATE_USER_NAME + errorInfo + errorReason);
					
					if (WinManager.winMgr.winLoading != null)
					{
						WinManager.winMgr.winLoading.visible = false;
						WinManager.winMgr.winLoading.includeInLayout = false;
					}
					
					break;
				}
				
				//升级
				case TcpType.SEND_LEVEL_UP:
				{
					if (isSuccess)
					{
						GameManager.gameMgr.gameApp.panelQuene.refresh();
					}
					else
						WinManager.winMgr.showResult(TcpType.LEVEL_UP_NAME + errorInfo + errorReason);
					
					break;
				}
				
				//加速
				case TcpType.SEND_ACCE:
				{
					if (isSuccess)
					{
						GameManager.gameMgr.gameApp.panelQuene.refresh();
					}
					else
						WinManager.winMgr.showResult(TcpType.ACCE_NAME + errorInfo + errorReason);
					
					break;
				}
				
				//生产
				case TcpType.SEND_MADE:
				{
					if (isSuccess)
					{
						WinManager.winMgr.winFactory.refresh();
						
						if (WinManager.winMgr.winStore != null && WinManager.winMgr.winStore.visible)
							WinManager.winMgr.winStore.refresh();
					}
					else
						WinManager.winMgr.showResult(TcpType.MADE_NAME + errorInfo + errorReason);
					
					break;
				}
				
				//强化
				case TcpType.SEND_COMPOSE:
				{
					if (isSuccess)
					{
						if (WinManager.winMgr.winCompose != null)
						{
							WinManager.winMgr.winCompose.visible = false;
							WinManager.winMgr.winCompose.includeInLayout = false;
						}
						
						if (WinManager.winMgr.winStore != null && WinManager.winMgr.winStore.visible)
							WinManager.winMgr.winStore.refresh();
					}
					else
						WinManager.winMgr.showResult(TcpType.COMPOSE_NAME + errorInfo + errorReason);
					
					break;
				}
				
				//回收
				case TcpType.SEND_DESTROY:
				{
					if (isSuccess)
					{
						var tcpDestroy:TcpDestroy = obj as TcpDestroy;
						if (tcpDestroy != null)
							WinManager.winMgr.winStore.dealDestroy(tcpDestroy.type, tcpDestroy.level);
					}
					else
						WinManager.winMgr.showResult(TcpType.DESTROY_NAME + errorInfo + errorReason);
					
					break;
				}
				
				//配兵
				case TcpType.SEND_FIT:
				{
					if (isSuccess)
					{
						if (!GameManager.gameMgr.isShowGuid)
						{
							WinManager.winMgr.showResult("配兵成功");
							WinManager.winMgr.winGenList.refreshByIndex(1);
						}
					}
					else
						WinManager.winMgr.showResult(TcpType.FIT_NAME + errorInfo + errorReason);
					
					break;
				}
				
				//出征
				case TcpType.SEND_MARCH:
				{
					if (isSuccess)
					{
						var march:TcpMarch = obj as TcpMarch;
						if (march != null)
						{
							//如果是从坞堡出征的，定位坞堡所在的城池
							if (march.place == 1)
							{
								gameWubao = GameManager.gameMgr.wubao;
								if (gameWubao != null)
									SceneManager.sceneMgr.enterMap(true);
							}
							//如果是从城池出征的，定位相应的城池
							else if (march.place == 2)
							{
								gameCity = GameManager.gameMgr.cityList.getObjByID(march.placeID) as City;
								if (gameCity != null)
									SceneManager.sceneMgr.enterMap(false, gameCity.mapX, gameCity.mapY);
							}
						}
						
						WinManager.winMgr.winMarch.visible = false;
						WinManager.winMgr.winMarch.includeInLayout = false;
						if (WinManager.winMgr.winCamp != null)
						{
							WinManager.winMgr.winCamp.visible = false;
							WinManager.winMgr.winCamp.includeInLayout = false;
						}
					}	
					else
						WinManager.winMgr.showResult(TcpType.MARCH_NAME + errorInfo + errorReason);
					
					break;
				}
				
				//治疗
				case TcpType.SEND_CURE:
				{
					if (isSuccess)
						WinManager.winMgr.winHospital.refresh();
					else
						WinManager.winMgr.showResult(TcpType.CURE_NAME + errorInfo + errorReason);
					
					break;
				}
				
				//登用武将
				case TcpType.SEND_APP_GEN:
				{
					if (isSuccess)
					{
						GameManager.gameMgr.wubao.generalStand = null;
						WinManager.winMgr.winInn.visible = false;
						WinManager.winMgr.winInn.includeInLayout = false;
					}
					else
						WinManager.winMgr.showResult(TcpType.APP_GEN_NAME + errorInfo + errorReason);
					
					break;
				}
				
				//派遣武将
				case TcpType.SEND_TRAN_GEN:
				{
					if (isSuccess)
					{
						if (WinManager.winMgr.winCitySel != null)
						{
							WinManager.winMgr.winCitySel.visible = false;
							WinManager.winMgr.winCitySel.includeInLayout = false;
						}
						
						if (WinManager.winMgr.winTranSel != null)
						{
							WinManager.winMgr.winTranSel.visible = false;
							WinManager.winMgr.winTranSel.includeInLayout = false;
						}
						
						if (WinManager.winMgr.winGenList != null)
						{
							WinManager.winMgr.winGenList.refresh();
						}
					}
					else
						WinManager.winMgr.showResult(TcpType.TRAN_GEN_NAME + errorInfo + errorReason);
					
					break;
				}
				
				//拜访武将
				case TcpType.SEND_VISIT_GEN:
				{
					if (isSuccess)
					{
						var visit:TcpVisit = obj as TcpVisit;
						if (visit != null)
						{
							friend = GameManager.gameMgr.friendList.getObjByID(visit.generalID) as Friend;
							info = "拜访武将成功，当前友好度为 " + friend.value.toString();
							WinManager.winMgr.showResult(info);
						}  
					}
					else
						WinManager.winMgr.showResult(TcpType.VISIT_GEN_NAME + errorInfo + errorReason);
					
					break;
				}
				
				//解雇武将
				case TcpType.SEND_FIRE:
				{
					if (isSuccess)
					{
						var fire:TcpFire = obj as TcpFire;
						if (fire != null)
						{
							var generalList:GeneralList = GameManager.gameMgr.wubao.generalList;
							generalList.removeObjByID(fire.generalID);
							if (generalList.length <= 0)
							{
								WinManager.winMgr.winGenList.visible = false;
								WinManager.winMgr.winGenList.includeInLayout = false;
								WinManager.winMgr.refreshWin();
							}
							else
								WinManager.winMgr.winGenList.refresh();
						}
					}
					else
						WinManager.winMgr.showResult(TcpType.FIRE_NAME + errorInfo + errorReason);
					
					break;
				}
				
				//购买道具
				case TcpType.SEND_BUY:
				{
					if (isSuccess)
					{
						buyNum ++;
						if (buyNum >= GameManager.gameMgr.buyNum)
						{
							WinManager.winMgr.winShop.onlyRereshMoney = true;
							WinManager.winMgr.winShop.refresh();
							WinManager.winMgr.showResult(TcpType.BUY_NAME + successInfo);
							buyNum = 0;
							GameManager.gameMgr.buyNum = 0;
						}
					}
					else
						WinManager.winMgr.showResult(TcpType.BUY_NAME + errorInfo + errorReason);
					
					break;
				}
				
				//赐予
				case TcpType.SEND_GRANT:
				{
					if (isSuccess)
					{
						var grant:TcpGrant = obj as TcpGrant;
						if (grant != null)
						{
							if (grant.genSide == 0)
							{
								//赐予
								if (grant.type == 1)
								{
									if (WinManager.winMgr.winGenList != null)
										WinManager.winMgr.winGenList.dealGrant(grant.generalID, grant.treasureID);
								}
								//收回
								else if (grant.type == 2)
								{
									if (WinManager.winMgr.winGenList != null)
										WinManager.winMgr.winGenList.dealBack(grant.treasureID);
								}
								//使用
								else if (grant.type == 3)
								{
									var userTreasure:UserTreasure = GameManager.gameMgr.userTsList.getObjByID(grant.treasureID) as UserTreasure;
									if (userTreasure != null)
										userTreasure.isUsed = 1;
										
									if (WinManager.winMgr.winBag != null && WinManager.winMgr.winBag.visible)
										WinManager.winMgr.winBag.dealUse(grant.treasureID);
									
									if (WinManager.winMgr.winInn != null && WinManager.winMgr.winInn.visible)
									{
										WinManager.winMgr.winInn.refresh();
										WinManager.winMgr.winInn.dealUse();
									}
									
									if (WinManager.winMgr.winHospital != null && WinManager.winMgr.winHospital.visible)
									{
										WinManager.winMgr.winHospital.refresh();
									}
									
									GameManager.gameMgr.gameApp.panelRes.refresh();
								}
							}
							else
							{
								//结交武将
								gameGeneral = GameManager.gameMgr.generalList.getObjByID(grant.generalID) as General;
								if (gameGeneral != null)
								{
									if (gameGeneral.userID != GameManager.gameMgr.userID)
									{
										friend = GameManager.gameMgr.friendList.getObjByID(grant.generalID) as Friend;
										if (friend != null)
										{
											//info = "财宝已赠送，当前友好度为 " + friend.value.toString();
											//WinManager.winMgr.showResult(info);
											GameManager.gameMgr.userTsList.setUsed(grant.treasureID, grant.generalID);
											WinManager.winMgr.winGive.refresh();
										}
									}
									//结交成功
									else
									{
										GameManager.gameMgr.userTsList.setUsed(grant.treasureID, grant.generalID);
										WinManager.winMgr.winGive.refresh();
									}
								}
							}
						}
					}
					else
						WinManager.winMgr.showResult(TcpType.GRANT_NAME + errorInfo + errorReason);
					
					break;
				}
				
				//创建势力
				case TcpType.SEND_CREATE_SPHERE:
				{
					if (isSuccess)
					{
						if (WinManager.winMgr.winCreateSph != null)
						{
							WinManager.winMgr.winCreateSph.visible = false;
							WinManager.winMgr.winCreateSph.includeInLayout = false;
						}
						
						if (WinManager.winMgr.winSphereTip != null)
						{
							WinManager.winMgr.winSphereTip.visible = false;
							WinManager.winMgr.winSphereTip.includeInLayout = false;
						}
						
						WinManager.winMgr.showResult(TcpType.CREATE_SPHERE_NAME + successInfo);
					}
					else
						WinManager.winMgr.showResult(TcpType.CREATE_SPHERE_NAME + errorInfo + errorReason);
					
					break;
				}
				
				//势力禅让
				case TcpType.SEND_DEMISE_SPHERE:
				{
					if (isSuccess)
					{
						var demise:TcpDemise = obj as TcpDemise;
						if (demise != null)
						{
							gameSphere = GameManager.gameMgr.sphereList.getObjByID(demise.sphereID) as Sphere;
							if (gameSphere != null)
							{
								gameUser = gameSphere.userList.getObjByID(demise.userID) as User;
								if (gameUser != null)
									gameSphere.userID = gameUser.uniqID;
							}
						}
						
						WinManager.winMgr.winDemise.visible = false;
						WinManager.winMgr.winDemise.includeInLayout = false;
						if (WinManager.winMgr.winSphere != null)
						{
							WinManager.winMgr.winSphere.visible = false;
							WinManager.winMgr.winSphere.includeInLayout = false;
						}
						
						WinManager.winMgr.showResult(TcpType.DEMISE_SPHERE_NAME + successInfo);
					}
					else
						WinManager.winMgr.showResult(TcpType.DEMISE_SPHERE_NAME + errorInfo + errorReason);
					
					break;
				}
				
				//修改势力简介
				case TcpType.SEND_MODIFY_SPHERE:
				{
					if (isSuccess)
					{
						var modify:TcpModify = obj as TcpModify;
						if (modify != null)
						{
							gameSphere = GameManager.gameMgr.sphereList.getObjByID(modify.sphereID) as Sphere;
							if (gameSphere != null)
								gameSphere.description = modify.content;
						}
						
						WinManager.winMgr.winModify.visible = false;
						WinManager.winMgr.winModify.includeInLayout = false;
						WinManager.winMgr.winSphere.refresh();
					}
					else
						WinManager.winMgr.showResult(TcpType.MODIFY_SPHERE_NAME + errorInfo + errorReason);
					
					break;
				}
				
				//解散势力
				case TcpType.SEND_DISSOLVE:
				{
					if (isSuccess)
					{
						WinManager.winMgr.winSphere.visible = false;
						WinManager.winMgr.winSphere.includeInLayout = false;
						var dissolve:TcpDissolve = obj as TcpDissolve;
						if (dissolve != null)
						{
							gameSphere = GameManager.gameMgr.sphereList.getObjByID(dissolve.sphereID) as Sphere;
							if (gameSphere != null)
								gameSphere.setUserDefault();
								 
							GameManager.gameMgr.sphereList.removeObjByID(dissolve.sphereID);
						}
						
						WinManager.winMgr.showResult(TcpType.DISSOLVE_NAME + successInfo);
					}
					else
						WinManager.winMgr.showResult(TcpType.DISSOLVE_NAME + errorInfo + errorReason);
					
					break;
				}
				
				//开除成员
				case TcpType.SEND_FIRE_USER:
				{
					if (isSuccess)
					{
						var fireUser:TcpFireUser = obj as TcpFireUser;
						if (fireUser != null)
						{
							gameSphere = GameManager.gameMgr.sphereList.getObjByID(fireUser.sphereID) as Sphere;
							if (gameSphere != null)
							{
								gameSphere.setUserDefault(fireUser.userID);
								gameSphere.userList.removeObjByID(fireUser.userID);
							}
						}
						
						WinManager.winMgr.winSphere.showUserList();
					}
					else
						WinManager.winMgr.showResult(TcpType.FIRE_USER_NAME + errorInfo + errorReason);
					
					break;
				}
				
				//申请加入势力
				case TcpType.SEND_JOIN_SPHERE:
				{
					if (isSuccess)
					{
						WinManager.winMgr.showResult("加入申请已发送，请等待对方的回应");
						if (WinManager.winMgr.winSphereInfo != null && WinManager.winMgr.winSphereInfo.visible)
						{
							WinManager.winMgr.winSphereInfo.visible = false;
							WinManager.winMgr.winSphereInfo.includeInLayout = false;
						}
					}
					else
						WinManager.winMgr.showResult(TcpType.JOIN_SPHERE_NAME + errorInfo + errorReason);
					
					break;
				}
				
				//确认加入势力
				case TcpType.SEND_CONF_JOIN:
				{
					if (isSuccess)
					{
						var confJoin:TcpConfJoin = obj as TcpConfJoin;
						if (confJoin != null)
						{
							HttpManager.httpMgr.delMail(confJoin.mailID);
							GameManager.gameMgr.mailList.removeObjByID(confJoin.mailID);
							GameManager.gameMgr.gameApp.panelTip.refresh();
							
							if (confJoin.isConf == 1)
							{
								gameSphere = GameManager.gameMgr.sphereList.getObjByID(GameManager.gameMgr.wubao.sphereID) as Sphere;
								gameUser = GameManager.gameMgr.userList.getObjByID(confJoin.userID) as User;
								if (gameSphere != null && gameUser != null)
								{
									gameUser.sphereID = gameSphere.uniqID;
									gameSphere.userList.add(gameUser);
								}
							}
						}
						
						if (WinManager.winMgr.winJoinList != null)
							WinManager.winMgr.winJoinList.refresh();
						
						if (WinManager.winMgr.winSphere != null)
							WinManager.winMgr.winSphere.refresh();
					}
					else
						WinManager.winMgr.showResult(TcpType.CONF_JOIN_NAME + errorInfo + errorReason);
					
					break;
				}
				
				//退出势力
				case TcpType.SEND_EXIT_SPHERE:
				{
					if (isSuccess)
					{
						GameManager.gameMgr.wubao.sphereID = 0;
						GameManager.gameMgr.user.sphereID = 0;
						WinManager.winMgr.winSphere.visible = false;
						WinManager.winMgr.winSphere.includeInLayout = false;
						WinManager.winMgr.showResult(TcpType.EXIT_SPHERE_NAME + successInfo);
					}
					else
						WinManager.winMgr.showResult(TcpType.EXIT_SPHERE_NAME + errorInfo + errorReason);
					
					break;
				}
				
				//申请官位
				case TcpType.SEND_APPLY_OFF:
				{
					if (isSuccess)
						WinManager.winMgr.winSphere.showOffList();
					else
						WinManager.winMgr.showResult(TcpType.APPLY_OFF_NAME + errorInfo + errorReason);
					
					break;
				}
				
				//申请结盟
				case TcpType.SEND_APPLY_ALLI:
				{
					if (isSuccess)
					{
						if (WinManager.winMgr.winAlli != null)
						{
							WinManager.winMgr.winAlli.visible = false;
							WinManager.winMgr.winAlli.includeInLayout = false;
						}
						
						if (WinManager.winMgr.winSphereInfo != null)
						{
							WinManager.winMgr.winSphereInfo.visible = false;
							WinManager.winMgr.winSphereInfo.includeInLayout = false;
						}
						
						WinManager.winMgr.showResult("同盟申请已发送，请等待对方的回应");
					}
					else
						WinManager.winMgr.showResult(TcpType.APPLY_ALLI_NAME + errorInfo + errorReason);
					
					break;
				}
				
				//确认结盟
				case TcpType.SEND_CONF_ALLI:
				{
					if (isSuccess)
					{
						var confAlli:TcpConfAlli = obj as TcpConfAlli;
						if (confAlli != null)
						{
							HttpManager.httpMgr.delMail(confAlli.mailID);
							GameManager.gameMgr.mailList.removeObjByID(confAlli.mailID);
							GameManager.gameMgr.gameApp.panelTip.refresh();
						}
						
						if (WinManager.winMgr.winAlliList != null)
							WinManager.winMgr.winAlliList.refresh();
						
						if (WinManager.winMgr.winSphere != null)
							WinManager.winMgr.winSphere.refresh();
					}
					else
						WinManager.winMgr.showResult(TcpType.CONF_ALLI_NAME + errorInfo + errorReason);
					
					break;
				}
				
				//宣战
				case TcpType.SEND_DECLARE_WAR:
				{
					if (isSuccess)
					{
						if (WinManager.winMgr.winSphereInfo != null)
						{
							WinManager.winMgr.winSphereInfo.visible = false;
							WinManager.winMgr.winSphereInfo.includeInLayout = false;
						}
						
						WinManager.winMgr.showResult(TcpType.DECLARE_WAR_NAME + successInfo);
					}
					else
						WinManager.winMgr.showResult(TcpType.DECLARE_WAR_NAME + errorInfo + errorReason);
					
					break;
				}
				
				//移动
				case TcpType.SEND_MOVE:
				{
					if (isSuccess)
					{
						var move:TcpMove = obj as TcpMove;
					}
					else
						WinManager.winMgr.showResult(TcpType.MOVE_NAME + errorInfo + errorReason);
					
					break;
				}
				
				//变阵
				case TcpType.SEND_ZHEN:
				{
					if (isSuccess)
					{
						var zhen:TcpZhen = obj as TcpZhen;
						if (zhen != null)
						{
						}
					}
					else
					{
						SceneManager.sceneMgr.sceneMap.refreshArmy(2);
						WinManager.winMgr.showResult(TcpType.ZHEN_NAME + errorInfo + errorReason);
					}
					
					break;
				}
				
				//发送邮件
				case TcpType.SEND_MAIL:
				{
					if (isSuccess)
						WinManager.winMgr.winMail.clearMail();
					else
						WinManager.winMgr.showResult(TcpType.MAIL_NAME + errorInfo + errorReason);
					
					break;
				}
				
				//发送聊天
				case TcpType.SEND_CHAT:
				{
					if (!isSuccess)
						GameManager.gameMgr.gameApp.chatMain.sendAllInfo(TcpType.CHAT_NAME + errorInfo + errorReason);
					else
					{
						var tcpChat:TcpChat = obj as TcpChat;
						if (tcpChat.recvID > 0)
							GameManager.gameMgr.gameApp.chatMain.showInfo(tcpChat);
					}
					
					break;
				}
				
				//学习
				case TcpType.SEND_STUDY:
				{
					if (isSuccess)
					{
						var tcpStudy:TcpStudy = obj as TcpStudy;
						
						gameGeneral = GameManager.gameMgr.wubao.generalList.getObjByID(tcpStudy.generalID) as General;
						if (WinManager.winMgr.winGenList != null && WinManager.winMgr.winGenList.visible)
							WinManager.winMgr.winGenList.refreshByIndex(0);
							
						if (WinManager.winMgr.winStudy != null && WinManager.winMgr.winStudy.visible)
							WinManager.winMgr.winStudy.refresh();
						
						if (SceneManager.sceneMgr.sceneMap.winArmyList != null)
							SceneManager.sceneMgr.sceneMap.winArmyList.refresh(2);
					}
					else
						WinManager.winMgr.showResult(TcpType.STUDY_NAME + errorInfo + errorReason);
					
					break;
				}
				
				//系统交易
				case TcpType.SEND_DEAL_SYS:
				{
					if (isSuccess)
					{
						WinManager.winMgr.winDeal.resetSys();
					}
					else
						WinManager.winMgr.showResult(TcpType.DEAL_SYS_NAME + errorInfo + errorReason);
					
					break;
				}
				
				//挂单交易
				case TcpType.SEND_DEAL_BILL:
				{
					if (isSuccess)
					{
						WinManager.winMgr.winDeal.showBill();
					}
					else
						WinManager.winMgr.showResult(TcpType.DEAL_SYS_NAME + errorInfo + errorReason);
					
					break;
				}
				
				//出售武器
				case TcpType.SEND_DEAL_SELL:
				{
					if (isSuccess)
					{
						if (WinManager.winMgr.winStore != null && WinManager.winMgr.winStore.visible)
							WinManager.winMgr.winStore.refresh();
						
						if (WinManager.winMgr.winSell != null && WinManager.winMgr.winSell.visible)
						{
							WinManager.winMgr.winSell.visible = false;
							WinManager.winMgr.winSell.includeInLayout = false;
						}
						
						if (WinManager.winMgr.winSellRes != null && WinManager.winMgr.winSellRes.visible)
						{
							WinManager.winMgr.winSellRes.visible = false;
							WinManager.winMgr.winSellRes.includeInLayout = false;
						}
					}
					else
						WinManager.winMgr.showResult(TcpType.DEAL_SYS_NAME + errorInfo + errorReason);
					
					break;
				}
				
				//购买武器
				case TcpType.SEND_DEAL_BUY:
				{
					if (isSuccess)
					{
						if (WinManager.winMgr.winBuy != null && WinManager.winMgr.winBuy.visible)
						{
							WinManager.winMgr.winBuy.visible = false;
							WinManager.winMgr.winBuy.includeInLayout = false;
						}
						
						if (WinManager.winMgr.winDeal != null && WinManager.winMgr.winDeal.visible)
							WinManager.winMgr.winDeal.showSell();
					}
					else
						WinManager.winMgr.showResult(TcpType.DEAL_SYS_NAME + errorInfo + errorReason);
					
					break;
				}
				
				//撤销交易
				case TcpType.SEND_DEAL_CANCEL:
				{
					if (isSuccess)
					{
						WinManager.winMgr.winDeal.showBill();
						
						if (WinManager.winMgr.winBillList != null && WinManager.winMgr.winBillList.visible)
							WinManager.winMgr.winBillList.refresh();
							
						if (WinManager.winMgr.winSellList != null && WinManager.winMgr.winSellList.visible)
							WinManager.winMgr.winSellList.refresh();
					}
					else
						WinManager.winMgr.showResult(TcpType.DEAL_SYS_NAME + errorInfo + errorReason);
					
					break;
				}
				
				//接收任务
				case TcpType.SEND_TASK:
				{
					if (isSuccess)
					{
					}
					else
						WinManager.winMgr.showResult(TcpType.TASK_NAME + errorInfo + errorReason);
					
					break;
				}
				
				//任务状态检查
				case TcpType.SEND_TASK_STATE:
				{
					break;
				}
				
				//领取奖励
				case TcpType.SEND_BONUS:
				{
					if (isSuccess)
					{
					}
					else
						WinManager.winMgr.showResult(TcpType.BONUS_NAME + errorInfo + errorReason);
					
					break;
				}
				
				//战役
				case TcpType.SEND_FIGHT:
				{
					var tcpFight:TcpFight = obj as TcpFight;
					
					if (isSuccess)
					{
						
					}	
					else
						WinManager.winMgr.showResult(TcpType.FIGHT_NAME + errorInfo + errorReason);
					
					break;
				}
				
				//领取俸禄
				case TcpType.SEND_SALARY:
				{
					if (isSuccess)
					{
					}
					else
						WinManager.winMgr.showResult(TcpType.SALARY_NAME + errorInfo + errorReason);
					
					break;
				}
				
				//掠夺
				case TcpType.SEND_ROB:
				{
					if (isSuccess)
					{
						if (WinManager.winMgr.winRobSet != null)
						{
							WinManager.winMgr.winRobSet.visible = false;
							WinManager.winMgr.winRobSet.includeInLayout = false;
						}
					}	
					else
						WinManager.winMgr.showResult(TcpType.ROB_NAME + errorInfo + errorReason);
					
					break;
				}
				
				//训练
				case TcpType.SEND_TRAIN:
				{
					if (isSuccess)
					{
						if (WinManager.winMgr.winTrain != null)
							WinManager.winMgr.winTrain.refresh();
					}	
					else
						WinManager.winMgr.showResult(TcpType.TRAIN_NAME + errorInfo + errorReason);
					
					break;
				}
				
				//迁城
				case TcpType.SEND_CHANGE_CITY:
				{
					if (isSuccess)
					{
						if (WinManager.winMgr.winChangeCity != null)
						{
							WinManager.winMgr.winChangeCity.visible = false;
							WinManager.winMgr.winChangeCity.includeInLayout = false;
						}	
						if (WinManager.winMgr.winYst != null)
						{
							WinManager.winMgr.winYst.visible = false;
							WinManager.winMgr.winYst.includeInLayout = false;
						}	
					}	
					else
						WinManager.winMgr.showResult(TcpType.CHANGE_CITY_NAME + errorInfo + errorReason);
					
					break;
				}
				
				//挑战玩家
				case TcpType.SEND_FIGHT_USER:
				{
					if (isSuccess)
					{
					}	
					else
						WinManager.winMgr.showResult(TcpType.FIGHT_USR_NAME + errorInfo + errorReason);
					
					break;
				}
				
				//回复工时
				case TcpType.SEND_RECOVER_MADE:
				{
					if (isSuccess)
					{
					}	
					else
						WinManager.winMgr.showResult(TcpType.RECOVER_MADE_NAME + errorInfo + errorReason);
					
					break;
				}
				
				//回复兵力
				case TcpType.SEND_RECOVER_SOLIDER:
				{
					if (isSuccess)
					{
					}	
					else
						WinManager.winMgr.showResult(TcpType.RECOVER_SOLIDER_NAME + errorInfo + errorReason);
					
					break;
				}
				
				//训练加速
				case TcpType.SEND_ACCE_TRAIN:
				{
					if (isSuccess)
					{
					}	
					else
						WinManager.winMgr.showResult(TcpType.ACCE_TRAIN_NAME + errorInfo + errorReason);
					
					break;
				}
				
				//军令加速
				case TcpType.SEND_ACCE_ORDER:
				{
					if (isSuccess)
					{
					}	
					else
						WinManager.winMgr.showResult(TcpType.ACCE_ORDER_NAME + errorInfo + errorReason);
					
					break;
				}
				
				//购买军令
				case TcpType.SEND_BUY_ORDER:
				{
					if (isSuccess)
					{
					}	
					else
						WinManager.winMgr.showResult(TcpType.BUY_ORDER_NAME + errorInfo + errorReason);
					
					break;
				}
				
				//申请盟主
				case TcpType.SEND_APPLY_LEADER:
				{
					if (isSuccess)
					{
					}	
					else
						WinManager.winMgr.showResult(TcpType.APPLY_LEADER_NAME + errorInfo + errorReason);
					
					break;
				}
				
				//购买空间
				case TcpType.SEND_BUY_STORE:
				{
					if (isSuccess)
					{
					}	
					else
						WinManager.winMgr.showResult(TcpType.BUY_STORE_NAME + errorInfo + errorReason);
					
					break;
				}
				
				//新手指引
				case TcpType.SEND_GUID:
				{
					if (isSuccess)
					{
					}	
					else
						WinManager.winMgr.showResult(TcpType.GUID_NAME + errorInfo + errorReason);
					
					break;
				}
				
				//宣战攻城
				case TcpType.SEND_ATTACK_CITY:
				{
					if (isSuccess)
					{
						if (WinManager.winMgr.winAttackCity != null)
						{
							WinManager.winMgr.winAttackCity.visible = false;
							WinManager.winMgr.winAttackCity.includeInLayout = false;
						}
					}	
					else
						WinManager.winMgr.showResult(TcpType.ATTACK_CITY_NAME + errorInfo + errorReason);
					
					break;
				}
				
				//报名攻城
				case TcpType.SEND_JOIN_ATTACK:
				{
					if (isSuccess)
					{
						var tcpJoinAttack:TcpJoinAttack = obj as TcpJoinAttack;
						SceneManager.sceneMgr.enterAttack(tcpJoinAttack.warID);
					}	
					else
						WinManager.winMgr.showResult(TcpType.JOIN_ATTACK_NAME + errorInfo + errorReason);
					
					break;
				}
				
				//退出攻城
				case TcpType.SEND_EXIT_ATTACK:
				{
					if (isSuccess)
					{
						SceneManager.sceneMgr.sceneAttackCity.visible = false;
						SceneManager.sceneMgr.sceneAttackCity.includeInLayout = false;
					}	
					else
						WinManager.winMgr.showResult(TcpType.EXIT_ATTACK_NAME + errorInfo + errorReason);
					
					break;
				}
				
				default:
				{
					break;
				}
			}
		}
		
		//===============================================================================
		// 客户端发送消息包至服务器
		//===============================================================================
		
		/**
		 * 用户登陆 
		 * @param sendID
		 * 
		 */		
		public function sendUerLogin():void
		{
			sendTcp(GameManager.gameMgr.userID, TcpType.SEND_USER_LOGIN, null);
		}
		
		/**
		 * 发送创建角色 
		 * @param sendID
		 * @param obj
		 * 
		 */		
		public function sendCreateUser(obj:Object):void
		{
			sendTcp(GameManager.gameMgr.userID, TcpType.SEND_CREATE_USER, obj);
		}
		
		/**
		 * 建筑升级 
		 * @param obj
		 * 
		 */		
		public function sendLevelUP(obj:Object):void
		{
			sendTcp(GameManager.gameMgr.userID, TcpType.SEND_LEVEL_UP, obj);
		}
		
		/**
		 * 加速升级 
		 * @param obj
		 * 
		 */		
		public function sendAcce(obj:Object):void
		{
			sendTcp(GameManager.gameMgr.userID, TcpType.SEND_ACCE, obj);
		}
		
		/**
		 * 校验升级 
		 * @param obj
		 * 
		 */		
		public function sendCheck(obj:Object):void
		{
			sendTcp(GameManager.gameMgr.userID, TcpType.SEND_CHECK, obj);
		}
		
		/**
		 * 生产
		 * @param obj
		 * 
		 */		
		public function sendMadeWeapon(obj:Object):void
		{
			sendTcp(GameManager.gameMgr.userID, TcpType.SEND_MADE, obj);
		}
		
		/**
		 * 合成
		 * @param obj
		 * 
		 */		
		public function sendCompose(obj:Object):void
		{
			sendTcp(GameManager.gameMgr.userID, TcpType.SEND_COMPOSE, obj);
		}
		
		/**
		 * 回收
		 * @param obj
		 * 
		 */		
		public function sendDestroy(obj:Object):void
		{
			sendTcp(GameManager.gameMgr.userID, TcpType.SEND_DESTROY, obj);
		}
		
		/**
		 * 治疗 
		 * @param obj
		 * 
		 */		
		public function sendCure(obj:Object):void
		{
			sendTcp(GameManager.gameMgr.userID, TcpType.SEND_CURE, obj);
		}
		
		/**
		 * 配兵
		 * @param obj
		 * 
		 */		
		public function sendFit(obj:Object):void
		{
			sendTcp(GameManager.gameMgr.userID, TcpType.SEND_FIT, obj);
		}
		
		/**
		 * 出征
		 * @param obj
		 * 
		 */		
		public function sendMarch(obj:Object):void
		{
			sendTcp(GameManager.gameMgr.userID, TcpType.SEND_MARCH, obj);
		}
		
		/**
		 * 登用武将 
		 * @param obj
		 * 
		 */		
		public function sendAppGeneral(obj:Object):void
		{
			sendTcp(GameManager.gameMgr.userID, TcpType.SEND_APP_GEN, obj);
		}
		
		/**
		 * 输送武将 
		 * @param obj
		 * 
		 */		
		public function sendTranGeneral(obj:Object):void
		{
			sendTcp(GameManager.gameMgr.userID, TcpType.SEND_TRAN_GEN, obj);
		}
		
		/**
		 * 拜访武将 
		 * @param obj
		 * 
		 */		
		public function sendVisitGeneral(obj:Object):void
		{
			sendTcp(GameManager.gameMgr.userID, TcpType.SEND_VISIT_GEN, obj);
		}
		
		/**
		 * 解雇武将 
		 * @param obj
		 * 
		 */		
		public function sendFire(obj:Object):void
		{
			sendTcp(GameManager.gameMgr.userID, TcpType.SEND_FIRE, obj);
		}
		
		/**
		 * 购买道具
		 * @param obj
		 * 
		 */		
		public function sendBuy(obj:Object):void
		{
			sendTcp(GameManager.gameMgr.userID, TcpType.SEND_BUY, obj);
		}
		
		/**
		 * 赐予 
		 * @param obj
		 * 
		 */		
		public function sendGrant(obj:Object):void
		{
			sendTcp(GameManager.gameMgr.userID, TcpType.SEND_GRANT, obj);
		}
		
		/**
		 * 创建势力
		 * @param obj
		 * 
		 */		
		public function sendCreateSphere(obj:Object):void
		{
			sendTcp(GameManager.gameMgr.userID, TcpType.SEND_CREATE_SPHERE, obj);
		}
		
		/**
		 * 势力禅让
		 * @param obj
		 * 
		 */		
		public function sendDemise(obj:Object):void
		{
			sendTcp(GameManager.gameMgr.userID, TcpType.SEND_DEMISE_SPHERE, obj);
		}
		
		/**
		 * 修改势力简介
		 * @param obj
		 * 
		 */		
		public function sendModify(obj:Object):void
		{
			sendTcp(GameManager.gameMgr.userID, TcpType.SEND_MODIFY_SPHERE, obj);
		}
		
		/**
		 * 解散势力
		 * @param obj
		 * 
		 */		
		public function sendDissolve(obj:Object):void
		{
			sendTcp(GameManager.gameMgr.userID, TcpType.SEND_DISSOLVE, obj);
		}
		
		/**
		 * 开除成员
		 * @param obj
		 * 
		 */		
		public function sendFireUser(obj:Object):void
		{
			sendTcp(GameManager.gameMgr.userID, TcpType.SEND_FIRE_USER, obj);
		}
		
		/**
		 * 加入势力
		 * @param obj
		 * 
		 */		
		public function sendJoinSphere(obj:Object):void
		{
			sendTcp(GameManager.gameMgr.userID, TcpType.SEND_JOIN_SPHERE, obj);
		}
		
		/**
		 * 确认加入势力
		 * @param obj
		 * 
		 */		
		public function sendConfJoin(obj:Object):void
		{
			sendTcp(GameManager.gameMgr.userID, TcpType.SEND_CONF_JOIN, obj);
		}
		
		/**
		 * 退出势力
		 * @param obj
		 * 
		 */		
		public function sendExitSphere(obj:Object):void
		{
			sendTcp(GameManager.gameMgr.userID, TcpType.SEND_EXIT_SPHERE, obj);
		}
		
		/**
		 * 申请官位
		 * @param obj
		 * 
		 */		
		public function sendApplyOff(obj:Object):void
		{
			sendTcp(GameManager.gameMgr.userID, TcpType.SEND_APPLY_OFF, obj);
		}
		
		/**
		 * 请求结盟
		 * @param obj
		 * 
		 */		
		public function sendAlli(obj:Object):void
		{
			sendTcp(GameManager.gameMgr.userID, TcpType.SEND_APPLY_ALLI, obj);
		}
		
		/**
		 * 确认结盟
		 * @param obj
		 * 
		 */		
		public function sendConfAlli(obj:Object):void
		{
			sendTcp(GameManager.gameMgr.userID, TcpType.SEND_CONF_ALLI, obj);
		}
		
		/**
		 * 移动
		 * @param obj
		 * 
		 */		
		public function sendMove(obj:Object):void
		{
			sendTcp(GameManager.gameMgr.userID, TcpType.SEND_MOVE, obj);
		}
		
		/**
		 * 变阵
		 * @param obj
		 * 
		 */		
		public function sendZhen(obj:Object):void
		{
			sendTcp(GameManager.gameMgr.userID, TcpType.SEND_ZHEN, obj);
		}
		
		/**
		 * 发送邮件
		 * @param obj
		 * 
		 */		
		public function sendMail(obj:Object):void
		{
			sendTcp(GameManager.gameMgr.userID, TcpType.SEND_MAIL, obj);
		}
		
		/**
		 * 发送聊天
		 * @param obj
		 * 
		 */		
		public function sendChat(obj:Object):void
		{
			sendTcp(GameManager.gameMgr.userID, TcpType.SEND_CHAT, obj);
		}
		
		/**
		 * 发送学习技能，阵法
		 * @param obj
		 * 
		 */		
		public function sendStudy(obj:Object):void
		{
			sendTcp(GameManager.gameMgr.userID, TcpType.SEND_STUDY, obj);
		}
		
		/**
		 * 发送系统交易
		 * @param obj
		 * 
		 */		
		public function sendDealSys(obj:Object):void
		{
			sendTcp(GameManager.gameMgr.userID, TcpType.SEND_DEAL_SYS, obj);
		}
		
		/**
		 * 发送挂单交易
		 * @param obj
		 * 
		 */		
		public function sendDealBill(obj:Object):void
		{
			sendTcp(GameManager.gameMgr.userID, TcpType.SEND_DEAL_BILL, obj);
		}
		
		/**
		 * 发送销售武器
		 * @param obj
		 * 
		 */		
		public function sendDealSell(obj:Object):void
		{
			sendTcp(GameManager.gameMgr.userID, TcpType.SEND_DEAL_SELL, obj);
		}
		
		/**
		 * 发送购买武器
		 * @param obj
		 * 
		 */		
		public function sendDealBuy(obj:Object):void
		{
			sendTcp(GameManager.gameMgr.userID, TcpType.SEND_DEAL_BUY, obj);
		}
		
		/**
		 * 发送撤销交易
		 * @param obj
		 * 
		 */		
		public function sendDealCancel(obj:Object):void
		{
			sendTcp(GameManager.gameMgr.userID, TcpType.SEND_DEAL_CANCEL, obj);
		}
		
		/**
		 * 发送接收任务
		 * @param obj
		 * 
		 */		
		public function sendTask(obj:Object):void
		{
			sendTcp(GameManager.gameMgr.userID, TcpType.SEND_TASK, obj);
		}
		
		/**
		 * 发送撤销任务
		 * @param obj
		 * 
		 */		
		public function sendCancelTask(obj:Object):void
		{
			sendTcp(GameManager.gameMgr.userID, TcpType.SEND_CANCEL_TASK, obj);
		}
		
		/**
		 * 发送任务状态检查
		 * @param obj
		 * 
		 */		
		public function sendTaskState(obj:Object):void
		{
			sendTcp(GameManager.gameMgr.userID, TcpType.SEND_TASK_STATE, obj);
		}
		
		/**
		 * 发送领取奖励
		 * @param obj
		 * 
		 */		
		public function sendBonus(obj:Object):void
		{
			sendTcp(GameManager.gameMgr.userID, TcpType.SEND_BONUS, obj);
		}
		
		/**
		 * 发送战役
		 * @param obj
		 * 
		 */		
		public function sendFight(obj:Object):void
		{
			sendTcp(GameManager.gameMgr.userID, TcpType.SEND_FIGHT, obj);
		}
		
		/**
		 * 发送获取俸禄(势力)
		 * @param obj
		 * 
		 */		
		public function sendSalary(obj:Object):void
		{
			sendTcp(GameManager.gameMgr.userID, TcpType.SEND_SALARY, obj);
		}
		
		/**
		 * 发送掠夺
		 * @param obj
		 * 
		 */		
		public function sendRob(obj:Object):void
		{
			sendTcp(GameManager.gameMgr.userID, TcpType.SEND_ROB, obj);
		}
		
		/**
		 * 发送训练
		 * @param obj
		 * 
		 */		
		public function sendTrain(obj:Object):void
		{
			sendTcp(GameManager.gameMgr.userID, TcpType.SEND_TRAIN, obj);
		}
		
		/**
		 * 发送迁城
		 * @param obj
		 * 
		 */		
		public function sendChangeCity(obj:Object):void
		{
			sendTcp(GameManager.gameMgr.userID, TcpType.SEND_CHANGE_CITY, obj);
		}
		
		/**
		 * 发送挑战玩家
		 * @param obj
		 * 
		 */		
		public function sendFightUser(obj:Object):void
		{
			sendTcp(GameManager.gameMgr.userID, TcpType.SEND_FIGHT_USER, obj);
		}
		
		/**
		 * 发送回复工时
		 * @param obj
		 * 
		 */		
		public function sendRecoverMade(obj:Object):void
		{
			sendTcp(GameManager.gameMgr.userID, TcpType.SEND_RECOVER_MADE, obj);
		}
		
		/**
		 * 发送回复兵力
		 * @param obj
		 * 
		 */		
		public function sendRecoverSolider(obj:Object):void
		{
			sendTcp(GameManager.gameMgr.userID, TcpType.SEND_RECOVER_SOLIDER, obj);
		}
		
		/**
		 * 发送训练加速
		 * @param obj
		 * 
		 */		
		public function sendAcceTrain(obj:Object):void
		{
			sendTcp(GameManager.gameMgr.userID, TcpType.SEND_ACCE_TRAIN, obj);
		}
		
		/**
		 * 发送军令加速
		 * @param obj
		 * 
		 */		
		public function sendAcceOrder(obj:Object):void
		{
			sendTcp(GameManager.gameMgr.userID, TcpType.SEND_ACCE_ORDER, obj);
		}
		
		/**
		 * 发送购买军令
		 * @param obj
		 * 
		 */		
		public function sendBuyOrder(obj:Object):void
		{
			sendTcp(GameManager.gameMgr.userID, TcpType.SEND_BUY_ORDER, obj);
		}
		
		/**
		 * 发送申请盟主
		 * @param obj
		 * 
		 */		
		public function sendApplyLeader(obj:Object):void
		{
			sendTcp(GameManager.gameMgr.userID, TcpType.SEND_APPLY_LEADER, obj);
		}
		
		/**
		 * 发送购买空间
		 * @param obj
		 * 
		 */		
		public function sendBuyStore(obj:Object):void
		{
			sendTcp(GameManager.gameMgr.userID, TcpType.SEND_BUY_STORE, obj);
		}
		
		/**
		 * 发送新手指引
		 * @param obj
		 * 
		 */		
		public function sendGuid(obj:Object):void
		{
			sendTcp(GameManager.gameMgr.userID, TcpType.SEND_GUID, obj);
		}
		
		/**
		 * 发送宣战攻城
		 * @param obj
		 * 
		 */		
		public function sendAttackCity(obj:Object):void
		{
			sendTcp(GameManager.gameMgr.userID, TcpType.SEND_ATTACK_CITY, obj);
		}
		
		/**
		 * 发送报名攻城
		 * @param obj
		 * 
		 */		
		public function sendJoinAttack(obj:Object):void
		{
			sendTcp(GameManager.gameMgr.userID, TcpType.SEND_JOIN_ATTACK, obj);
		}
		
		/**
		 * 发送退出攻城
		 * @param obj
		 * 
		 */		
		public function sendExitAttack(obj:Object):void
		{
			sendTcp(GameManager.gameMgr.userID, TcpType.SEND_EXIT_ATTACK, obj);
		}
		
		/**
		 * 发送tcp消息包 
		 * @param sendID  发送者ID 
		 * @param type    发送的消息类型
		 * @param obj     发送的消息对象，由外部封装传入
		 * 
		 */		
		private function sendTcp(sendID:int, type:int, obj:Object):void
		{
			var tcpBody:ByteArray = new ByteArray();
			tcpBody.endian = Endian.BIG_ENDIAN;
			
			var i:int = 0;
			
			switch (type)
			{
				//发送用户登陆消息
				case TcpType.SEND_USER_LOGIN:
				{
					writeInt(tcpBody, PubUnit.version);
					
					break;
				}
				
				//创建角色
				case TcpType.SEND_CREATE_USER:
				{
					var createUser:TcpCreateUser = obj as TcpCreateUser;
					
					writeStr(tcpBody, createUser.userName);
					writeInt(tcpBody, createUser.cityID);
					
					break;
				}
				
				//建筑升级
				case TcpType.SEND_LEVEL_UP:
				{
					var lu:TcpLevelUp = obj as TcpLevelUp;
					
					writeByte(tcpBody, lu.type);
					writeInt(tcpBody, lu.typeID);
					
					break;
				}
				
				//加速升级
				case TcpType.SEND_ACCE:
				{
					var acce:TcpAcce = obj as TcpAcce;
					
					writeByte(tcpBody, acce.type);
					writeInt(tcpBody, acce.typeID);
					
					break;
				}
				
				//校验升级
				case TcpType.SEND_CHECK:
				{
					break;
				}
				
				//生产装备
				case TcpType.SEND_MADE:
				{
					var made:TcpMade = obj as TcpMade;
					
					writeByte(tcpBody, made.type);
					writeInt(tcpBody, made.num);
					
					break;
				}
				
				//合成
				case TcpType.SEND_COMPOSE:
				{
					var compose:TcpCompose = obj as TcpCompose;
					
					writeByte(tcpBody, compose.type);
					writeInt(tcpBody, compose.level);
					writeInt(tcpBody, compose.num);
					
					break;
				}
				
				//回收
				case TcpType.SEND_DESTROY:
				{
					var destroy:TcpDestroy = obj as TcpDestroy;
					
					writeByte(tcpBody, destroy.type);
					writeInt(tcpBody, destroy.level);
					
					break;
				}
				
				//配兵
				case TcpType.SEND_FIT:
				{
					var fit:TcpFit = obj as TcpFit;
					
					writeInt(tcpBody, fit.generalID);
					writeInt(tcpBody, fit.num);
					writeInt(tcpBody, fit.zhenID);
					writeInt(tcpBody, fit.w1Type);
					writeInt(tcpBody, fit.w1Level);
					writeInt(tcpBody, fit.w2Type);
					writeInt(tcpBody, fit.w2Level);
					writeInt(tcpBody, fit.w3Type);
					writeInt(tcpBody, fit.w3Level);
					writeInt(tcpBody, fit.w4Type);
					writeInt(tcpBody, fit.w4Level);
					
					break;
				}
				
				//出征
				case TcpType.SEND_MARCH:
				{
					var march:TcpMarch = obj as TcpMarch;
					
					writeInt(tcpBody, march.generalID);
					writeByte(tcpBody, march.type);
					writeInt(tcpBody, march.days);
					writeInt(tcpBody, march.zhen);
					
					break;
				}
				
				//治疗
				case TcpType.SEND_CURE:
				{
					var cure:TcpCure = obj as TcpCure;
					
					writeInt(tcpBody, cure.generalID);
					
					break;
				}
				
				//登用武将
				case TcpType.SEND_APP_GEN:
				{
					var appGen:TcpAppGen = obj as TcpAppGen;
					
					writeInt(tcpBody, appGen.generalID);
					
					break;
				}
				
				//派遣武将
				case TcpType.SEND_TRAN_GEN:
				{
					var trans:TcpTrans = obj as TcpTrans;
					
					writeInt(tcpBody, trans.generalID);
					writeByte(tcpBody, trans.type);
					writeInt(tcpBody, trans.toID);
					writeInt(tcpBody, trans.isAcce);
					
					break;
				}
				
				//拜访武将
				case TcpType.SEND_VISIT_GEN:
				{
					var visit:TcpVisit = obj as TcpVisit;
					
					writeInt(tcpBody, visit.generalID);
					
					break;
				}
				
				//解雇武将
				case TcpType.SEND_FIRE:
				{
					var fire:TcpFire = obj as TcpFire;
					
					writeInt(tcpBody, fire.generalID);
					
					break;
				}
				
				//购买道具
				case TcpType.SEND_BUY:
				{
					var buy:TcpBuy = obj as TcpBuy;
					
					writeInt(tcpBody, buy.treasureID);
					
					break;
				}
				
				//赐予
				case TcpType.SEND_GRANT:
				{
					var grant:TcpGrant = obj as TcpGrant;
					
					writeInt(tcpBody, grant.type);
					writeInt(tcpBody, grant.generalID);
					writeInt(tcpBody, grant.treasureID);
					
					break;
				}
				
				//创建势力
				case TcpType.SEND_CREATE_SPHERE:
				{
					var createSphere:TcpCreateSphere = obj as TcpCreateSphere;
					
					writeStr(tcpBody, createSphere.name);
					writeStr(tcpBody, createSphere.content);
					
					break;
				}
				
				//势力禅让
				case TcpType.SEND_DEMISE_SPHERE:
				{
					var demise:TcpDemise = obj as TcpDemise;
					
					writeInt(tcpBody, demise.sphereID);
					writeInt(tcpBody, demise.userID);
					
					break;
				}
				
				//修改势力简介
				case TcpType.SEND_MODIFY_SPHERE:
				{
					var modify:TcpModify = obj as TcpModify;
					
					writeInt(tcpBody, modify.sphereID);
					writeStr(tcpBody, modify.content);
					
					break;
				}
				
				//解散势力
				case TcpType.SEND_DISSOLVE:
				{
					var dissolve:TcpDissolve = obj as TcpDissolve;
					
					writeInt(tcpBody, dissolve.sphereID);
					
					break;
				}
				
				//开除成员
				case TcpType.SEND_FIRE_USER:
				{
					var fireUser:TcpFireUser = obj as TcpFireUser;
					
					writeInt(tcpBody, fireUser.sphereID);
					writeInt(tcpBody, fireUser.userID);
					
					break;
				}
				
				//加入势力
				case TcpType.SEND_JOIN_SPHERE:
				{
					var join:TcpJoin = obj as TcpJoin;
					
					writeInt(tcpBody, join.sphereID);
					
					break;
				}
				
				//确认加入势力
				case TcpType.SEND_CONF_JOIN:
				{
					var confJoin:TcpConfJoin = obj as TcpConfJoin;
					
					writeInt(tcpBody, confJoin.userID);
					writeByte(tcpBody, confJoin.isConf);
					
					break;
				}
				
				//退出势力
				case TcpType.SEND_EXIT_SPHERE:
				{
					var exitSphere:TcpExitSphere = obj as TcpExitSphere;
					
					writeInt(tcpBody, exitSphere.sphereID);
					
					break;
				}
				
				//申请官位
				case TcpType.SEND_APPLY_OFF:
				{
					var applyOff:TcpApplyOff = obj as TcpApplyOff;
					
					writeInt(tcpBody, applyOff.sphereID);
					writeInt(tcpBody, applyOff.offID);
					
					break;
				}
				
				//请求结盟
				case TcpType.SEND_APPLY_ALLI:
				{
					var alli:TcpAlli = obj as TcpAlli;
					
					writeInt(tcpBody, alli.fromID);
					writeInt(tcpBody, alli.toID);
					writeInt(tcpBody, alli.alliTime);
					
					break;
				}
				
				//确认结盟
				case TcpType.SEND_CONF_ALLI:
				{
					var confAlli:TcpConfAlli = obj as TcpConfAlli;
					
					writeInt(tcpBody, confAlli.sphereID);
					writeInt(tcpBody, confAlli.years);
					writeByte(tcpBody, confAlli.isConf);
					
					break;
				}
				
				//宣战
				case TcpType.SEND_DECLARE_WAR:
				{
					var decWar:TcpDecWar = obj as TcpDecWar;
					
					writeInt(tcpBody, decWar.fromID);
					writeInt(tcpBody, decWar.toID);
					
					break;
				}
				
				//移动
				case TcpType.SEND_MOVE:
				{
					var move:TcpMove = obj as TcpMove;
					
					writeInt(tcpBody, move.armyID);
					writeByte(tcpBody, move.target);
					writeInt(tcpBody, move.cityID);
					writeShort(tcpBody, move.coorList.length);
					
					for (i = 0; i < move.coorList.length; i++)
					{
						writeShort(tcpBody, move.coorList[i][0]);
						writeShort(tcpBody, move.coorList[i][1]);
					}
					
					break;
				}
				
				//变阵
				case TcpType.SEND_ZHEN:
				{
					var zhen:TcpZhen = obj as TcpZhen;
					
					writeInt(tcpBody, zhen.armyID);
					writeInt(tcpBody, zhen.zhenID);
					
					break;
				}
				
				//发送邮件
				case TcpType.SEND_MAIL:
				{
					var tcpMail:TcpMail = obj as TcpMail;
					
					writeInt(tcpBody, tcpMail.userID);
					writeInt(tcpBody, tcpMail.type);
					writeStr(tcpBody, tcpMail.title);
					writeStr(tcpBody, tcpMail.content);
					
					break;
				}
				
				//发送聊天
				case TcpType.SEND_CHAT:
				{
					var tcpChat:TcpChat = obj as TcpChat;
					
					writeInt(tcpBody, tcpChat.sendID);
					writeInt(tcpBody, tcpChat.recvID);
					writeStr(tcpBody, tcpChat.chatInfo);
					
					break;
				}
				
				//发送学习
				case TcpType.SEND_STUDY:
				{
					var tcpStudy:TcpStudy = obj as TcpStudy;
					
					writeInt(tcpBody, tcpStudy.generalID);
					writeByte(tcpBody, tcpStudy.type);
					writeByte(tcpBody, tcpStudy.typeID);
					
					break;
				}
				
				//发送系统交易
				case TcpType.SEND_DEAL_SYS:
				{
					var dealSys:TcpSys = obj as TcpSys;
					
					writeInt(tcpBody, dealSys.type);
					writeInt(tcpBody, dealSys.resType);
					writeInt(tcpBody, dealSys.resNum);
					
					break;
				}
				
				//发送挂单交易
				case TcpType.SEND_DEAL_BILL:
				{
					var dealBill:TcpBill = obj as TcpBill;
					
					writeInt(tcpBody, dealBill.type);
					writeInt(tcpBody, dealBill.resType);
					writeInt(tcpBody, dealBill.resNum);
					writeInt(tcpBody, dealBill.price);
					
					break;
				}
				
				//发送销售武器
				case TcpType.SEND_DEAL_SELL:
				{
					var dealSell:TcpSell = obj as TcpSell;
					
					writeInt(tcpBody, dealSell.type);
					writeInt(tcpBody, dealSell.level);
					writeInt(tcpBody, dealSell.num);
					writeInt(tcpBody, dealSell.coins);
					
					break;
				}
				
				//发送购买武器
				case TcpType.SEND_DEAL_BUY:
				{
					var buyWeapon:TcpBuyWeapon = obj as TcpBuyWeapon;
					
					writeInt(tcpBody, buyWeapon.uniqID);
					
					break;
				}
				
				//发送撤销交易
				case TcpType.SEND_DEAL_CANCEL:
				{
					var tcpCancel:TcpCancel = obj as TcpCancel;
					
					writeInt(tcpBody, tcpCancel.type);
					writeInt(tcpBody, tcpCancel.uniqID);
					
					break;
				}
				
				//发送接收任务
				case TcpType.SEND_TASK:
				{
					var tcpTask:TcpTask = obj as TcpTask;
					
					writeInt(tcpBody, tcpTask.taskID);
					
					break;
				}
				
				//发送撤销任务
				case TcpType.SEND_CANCEL_TASK:
				{
					break;
				}
				
				//发送任务状态检查
				case TcpType.SEND_TASK_STATE:
				{
					break;
				}
				
				//发送领取奖励
				case TcpType.SEND_BONUS:
				{
					break;
				}
				
				//发送战役
				case TcpType.SEND_FIGHT:
				{
					var tcpFight:TcpFight = obj as TcpFight;
					
					writeInt(tcpBody, tcpFight.gateID);
					writeInt(tcpBody, tcpFight.generalNum);
					
					for (i = 0; i < tcpFight.generalList.length; i++)
					{
						writeInt(tcpBody, tcpFight.generalList[i]);
					}
					
					break;
				}
				
				//发送领取俸禄
				case TcpType.SEND_SALARY:
				{
					break;
				}
				
				//发送掠夺
				case TcpType.SEND_ROB:
				{
					var tcpRob:TcpRob = obj as TcpRob;
					
					writeInt(tcpBody, tcpRob.userID);
					writeInt(tcpBody, tcpRob.res1ID);
					writeInt(tcpBody, tcpRob.res2ID);
					writeInt(tcpBody, tcpRob.res3ID);
					writeInt(tcpBody, tcpRob.res4ID);
					writeInt(tcpBody, tcpRob.res5ID);
					writeInt(tcpBody, tcpRob.res6ID);
					
					break;
				}
				
				//发送训练
				case TcpType.SEND_TRAIN:
				{
					var tcpView:TcpView = obj as TcpView;
					
					writeInt(tcpBody, tcpView.generalID);
					writeInt(tcpBody, tcpView.type);
					
					break;
				}
				
				//发送迁城
				case TcpType.SEND_CHANGE_CITY:
				{
					var tcpChangeCity:TcpChangeCity = obj as TcpChangeCity;
					
					writeInt(tcpBody, tcpChangeCity.cityID);
					
					break;
				}
				
				//发送挑战玩家
				case TcpType.SEND_FIGHT_USER:
				{
					var tcpFightUser:TcpFightUser = obj as TcpFightUser;
					
					writeInt(tcpBody, tcpFightUser.userID);
					
					break;
				}
				
				//发送回复工时
				case TcpType.SEND_RECOVER_MADE:
				{
					break;
				}
				
				//发送回复兵力
				case TcpType.SEND_RECOVER_SOLIDER:
				{
					break;
				}
				
				//发送训练加速
				case TcpType.SEND_ACCE_TRAIN:
				{
					break;
				}
				
				//发送军令加速
				case TcpType.SEND_ACCE_ORDER:
				{
					break;
				}
				
				//发送购买军令
				case TcpType.SEND_BUY_ORDER:
				{
					break;
				}
				
				//发送申请盟主
				case TcpType.SEND_APPLY_LEADER:
				{
					break;
				}
				
				//发送购买空间
				case TcpType.SEND_BUY_STORE:
				{
					break;
				}
				
				//发送新手指引
				case TcpType.SEND_GUID:
				{
					var tcpGuid:TcpGuid = obj as TcpGuid;
					
					writeInt(tcpBody, tcpGuid.guidIndex);
					break;
				}
				
				//发送宣战攻城
				case TcpType.SEND_ATTACK_CITY:
				{
					var tcpAttack:TcpAttack = obj as TcpAttack;
					
					writeInt(tcpBody, tcpAttack.cityID);
					break;
				}
				
				//发送报名攻城
				case TcpType.SEND_JOIN_ATTACK:
				{
					var tcpJoinAttack:TcpJoinAttack = obj as TcpJoinAttack;
					
					writeInt(tcpBody, tcpJoinAttack.warID);
					break;
				}
				
				//发送退出攻城
				case TcpType.SEND_EXIT_ATTACK:
				{
					var tcpExitAttack:TcpExitAttack = obj as TcpExitAttack;
					
					writeInt(tcpBody, tcpExitAttack.warID);
					break;
				}
				
				default:
				{
					break;
				}
				
			}
			
			//进行打包
			var req:Request = new Request(type, sendID, _msgID, tcpBody);
			var sendBytes:ByteArray = req.pack();
			
			//发送消息
			conn.write(sendBytes);
			
			//将该消息ID与对应的消息类型存入数组中
			var msgItem:Object = {msgID:_msgID, msgType:type, sendObj:obj}; 
			msgList.push(msgItem)
			
			_msgID ++;
		}
		
		/**
		 * 根据消息ID获取对应的消息类型 
		 * @param msgID
		 * @return 
		 * 
		 */		
		public function getTypeByMsgID(msgID:int):int
		{
			var ret:int = 0;
			
			for each(var obj:Object in msgList)
			{
				if (obj.msgID == msgID)
				{
					ret = obj.msgType;
					
					break;
				}
			}
			
			return ret;
		}
		
		/**
		 * 根据消息ID获取已发送的消息包 
		 * @param msgID
		 * @return 
		 * 
		 */		
		public function getSendObjByMsgID(msgID:int):Object
		{
			var ret:Object;
			
			for each(var obj:Object in msgList)
			{
				if (obj.msgID == msgID)
				{
					ret = obj.sendObj;
					
					break;
				}
			}
			
			return ret;
		}
		
		//==============================================================
		//字节流读取操作
		//==============================================================
		
		/**
		 * 读消息包(Byte) 
		 * @param tcpBody
		 * @return 
		 * 
		 */		
		private function readByte(tcpBody:ByteArray):int
		{
			return tcpBody.readByte();
		}
		
		/**
		 * 读消息包(short) 
		 * @param tcpBody
		 * @return 
		 * 
		 */		
		private function readShort(tcpBody:ByteArray):int
		{
			return tcpBody.readShort();
		}
		
		/**
		 * 读消息包(int) 
		 * @param tcpBody
		 * @return 
		 * 
		 */		
		private function readInt(tcpBody:ByteArray):int
		{
			return tcpBody.readInt();
		}
		
		/**
		 * 读消息包(UInt); 
		 * @param tcpBody
		 * @return 
		 * 
		 */		
		private function readUInt(tcpBody:ByteArray):uint
		{
			return tcpBody.readUnsignedInt();
		}
		
		/**
		 * 读消息包(double)
		 * @param tcpBody
		 * @return 
		 * 
		 */		
		private function readDouble(tcpBody:ByteArray):int
		{
			return tcpBody.readDouble();
		}
		
		/**
		 * 读消息包(String) 
		 * @param tcpBody
		 * @return 
		 * 
		 */		
		private function readStr(tcpBody:ByteArray):String
		{
			var len:int = tcpBody.readInt();
			if (len <= 0) return "";
			
			return tcpBody.readMultiByte(len, "utf-8"); 
		}
		
		/**
		 * 读取响应消息的reason 
		 * @param tcpBody
		 * @return 
		 * 
		 */		
		private function readReason(tcpBody:ByteArray):String
		{
			return tcpBody.readMultiByte(tcpBody.length, "utf-8");
		}
		
		/**
		 * 写消息包(byte) 
		 * @param tcpBody
		 * @param value
		 * 
		 */		
		private function writeByte(tcpBody:ByteArray, value:int):void
		{
			tcpBody.writeByte(value);
		}
		
		/**
		 * 写消息包(short)
		 * @param tcpBody
		 * @param value
		 * 
		 */		
		private function writeShort(tcpBody:ByteArray, value:int):void
		{
			tcpBody.writeShort(value);
		}
		
		/**
		 * 写消息包(int)
		 * @param tcpBody
		 * @param value
		 * 
		 */		
		private function writeInt(tcpBody:ByteArray, value:int):void
		{
			tcpBody.writeInt(value);
		}
		
		/**
		 * 写消息包(String)
		 * @param tcpBody
		 * @param value
		 * 
		 */		
		private function writeStr(tcpBody:ByteArray, value:String):void
		{
			var strAry:ByteArray = new ByteArray();
			
			strAry.writeMultiByte(value, "utf-8");
			tcpBody.writeInt(strAry.length);
			tcpBody.writeBytes(strAry);
		}
				
		
		
		
		
		
		
		
		
		

	}
}