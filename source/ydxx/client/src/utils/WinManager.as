package utils
{
	import battle.ui.WinBattleResult;
	import battle.ui.WinGate;
	
	import city.model.City;
	import city.ui.WinAttackCity;
	import city.ui.WinCitySel;
	import city.ui.WinConsult;
	import city.ui.WinTranSel;
	
	import deal.model.Sell;
	import deal.ui.WinBillList;
	import deal.ui.WinBuy;
	import deal.ui.WinDeal;
	import deal.ui.WinSell;
	import deal.ui.WinSellList;
	import deal.ui.WinSellRes;
	
	import general.model.General;
	import general.ui.WinFind;
	import general.ui.WinGenList;
	import general.ui.WinGeneral;
	import general.ui.WinGive;
	import general.ui.WinStudy;
	
	import guid.GuidManager;
	
	import mail.ui.WinMail;
	
	import mx.core.UIComponent;
	import mx.effects.Fade;
	import mx.managers.PopUpManager;
	
	import net.tcp.TcpManager;
	import net.tcp.model.fight.TcpFightNtf;
	
	import other.WinFindLock;
	import other.WinLock;
	import other.WinLockMain;
	import other.WinModiLock;
	import other.WinTransCoin;
	
	import rob.ui.WinRob;
	import rob.ui.WinRobSet;
	
	import shop.ui.WinGift;
	import shop.ui.WinShop;
	
	import sphere.ui.WinAlli;
	import sphere.ui.WinAlliList;
	import sphere.ui.WinCreateSphere;
	import sphere.ui.WinDemise;
	import sphere.ui.WinJoinList;
	import sphere.ui.WinModiDes;
	import sphere.ui.WinSphere;
	import sphere.ui.WinSphereDis;
	import sphere.ui.WinSphereInfo;
	import sphere.ui.WinSphereList;
	import sphere.ui.WinSphereTip;
	
	import task.ui.WinTask;
	
	import utils.components.GameWindow;
	import utils.ui.WinAsk;
	import utils.ui.WinCreateUser;
	import utils.ui.WinLoadInfo;
	import utils.ui.WinLoading;
	import utils.ui.WinResult;
	
	import wubao.model.User;
	import wubao.model.WuBao;
	import wubao.ui.WinBag;
	import wubao.ui.WinCamp;
	import wubao.ui.WinChangeCity;
	import wubao.ui.WinCompose;
	import wubao.ui.WinFactory;
	import wubao.ui.WinFarm;
	import wubao.ui.WinHospital;
	import wubao.ui.WinInn;
	import wubao.ui.WinMarch;
	import wubao.ui.WinMarket;
	import wubao.ui.WinMine;
	import wubao.ui.WinRanch;
	import wubao.ui.WinRank;
	import wubao.ui.WinRoom;
	import wubao.ui.WinSchool;
	import wubao.ui.WinSkin;
	import wubao.ui.WinStore;
	import wubao.ui.WinTrain;
	import wubao.ui.WinWood;
	import wubao.ui.WinYst;
	
	/**
	 * 界面管理器，用来控制所有界面的显示 
	 * @author StarX
	 * 
	 */	
	public class WinManager
	{
		//定义静态interface管理器，用来实现interface管理器的单例模式
		private static var _winMgr:WinManager = null;
		
		//当前打开的窗口
		private var curWin:GameWindow = null; 
		
		//所有窗体的列表
		private var _winList:Array = [];
		
		public function WinManager()
		{
			if(_winMgr != null)
				throw new Error("不能多次创建winMangager的实例!");
		}

		/**
		 * 管理器初始化 
		 * 
		 */		
		public static function init():void
		{
			if (_winMgr == null)
				_winMgr = new WinManager();
		}
		
		/**
		 * 获取interface管理器单例 
		 * @return 
		 * 
		 */		
		public static function get winMgr():WinManager
		{
			return _winMgr;
		}
		
		/**
		 * 在主程序的中心位置弹出窗口 
		 * @param win      要弹出的窗口
		 * @param isModal  是否为modal窗口
		 * @param parentWin 父窗体
		 * 
		 */		
		public function popWindowCenter(win:UIComponent, isModal:Boolean = false, parentWin:UIComponent = null):void
		{
			if (win == null) return;
			
			if (parentWin == null)
				parentWin = GameManager.gameMgr.gameApp;
				
			win.x = int((parentWin.width - win.width) / 2);
			win.y = int((parentWin.height - win.height) / 2);
			
			if (win.parent == null)
				PopUpManager.addPopUp(win, parentWin, isModal);
			else
				PopUpManager.bringToFront(win);
		}
		
		/**
		 * 移除窗口 
		 * @param win
		 * 
		 */		
		private function removeWindow(win:UIComponent):void
		{	
			if (win == null) return;
			
			if (win.parent != null)
				PopUpManager.removePopUp(win);
			
			if (win is WinCreateUser)
				win = null;
		}
		
		public function refreshWin():void
		{
			if (curWin == null || !curWin.visible) return;  
			
			curWin.refresh();
		}
		
		//===========================================================================================
		// 加载信息窗口
		//===========================================================================================
		
		private var loadInfo:WinLoadInfo = null;		
		private var fade:Fade = null;
		
		public function showMainLoad():void
		{
			if (loadInfo == null)
			{
				loadInfo = new WinLoadInfo();
				loadInfo.x = 0;
				loadInfo.y = 0;
				loadInfo.width = GameManager.gameMgr.gameWidth;
				loadInfo.height = GameManager.gameMgr.gameHeight;
				GameManager.gameMgr.gameApp.addChild(loadInfo);
				loadInfo.visible = false;
				loadInfo.includeInLayout = false;
				
				fade = new Fade();
				fade.alphaFrom = 0;
				fade.alphaTo = 1;
				fade.target = loadInfo;
				fade.duration = 1000;
				fade.play();
			}
		}
		
		public function removeLoadInfo():void
		{
			if (loadInfo != null)
			{
				loadInfo.unLoad();
				GameManager.gameMgr.gameApp.removeChild(loadInfo);
				loadInfo = null;
			}
		}
		
		public function setLoadInfo(str:String):void
		{
			if (loadInfo == null) return;
			
			loadInfo.visible = true;
			loadInfo.includeInLayout = true;
			loadInfo.lblInfo.text = str;
		}
		
		//===========================================================================================
		// 创建角色
		//===========================================================================================
		
		private var winCreateUser:WinCreateUser = null;
		
		public function showCreateUser():void
		{
			if (loadInfo != null)
			{
				loadInfo.visible = false;
				loadInfo.includeInLayout = false;
			}
			
			if (winCreateUser == null)
				winCreateUser = new WinCreateUser();
			winCreateUser.width = GameManager.gameMgr.gameWidth;
			winCreateUser.height = GameManager.gameMgr.gameHeight;
			
			popWindowCenter(winCreateUser);
			
		}
		
		public function removeCreateUser():void
		{
			if (winCreateUser == null) return;
			
			removeWindow(winCreateUser);
		}
		
		//*******************************************************************************************
		//*******************************************************************************************
		//
		// 坞堡场景
		//
		//*******************************************************************************************
		//*******************************************************************************************
		
		//===========================================================================================
		// 议事堂窗口
		//===========================================================================================
		
		private var _winYst:WinYst = null;
		
		public function showYst():void
		{
			if (winYst == null)
			{
				winYst = new WinYst();
				popWindowCenter(winYst);
			}
			
			hideAllWin();
			winYst.refresh();
			winYst.visible = true;
			winYst.includeInLayout = true;
			
			curWin = winYst;
			PopUpManager.bringToFront(winYst);
			GuidManager.guidMgr.gotoNext();
		}
		
		public function get winYst():WinYst
		{
			return _winYst;
		}
		
		public function set winYst(param:WinYst):void
		{
			_winYst = param;
		}
		
		//===========================================================================================
		// 迁城窗口
		//===========================================================================================
		
		private var _winChangeCity:WinChangeCity = null;
		
		public function showChangeCity():void
		{
			if (winChangeCity == null)
			{
				winChangeCity = new WinChangeCity();
				popWindowCenter(winChangeCity);
			}
			
			winChangeCity.refresh();
			winChangeCity.visible = true;
			winChangeCity.includeInLayout = true;
			
			PopUpManager.bringToFront(winChangeCity);
		}
		
		public function get winChangeCity():WinChangeCity
		{
			return _winChangeCity;
		}
		
		public function set winChangeCity(param:WinChangeCity):void
		{
			_winChangeCity = param;
		}
		
		//===========================================================================================
		// 势力分布窗口
		//===========================================================================================
		
		private var winSphereDis:WinSphereDis = null;
		
		public function showSphereDis():void
		{
			if (winSphereDis == null)
			{
				winSphereDis = new WinSphereDis();
				popWindowCenter(winSphereDis);
			}
			
			hideAllWin();
			winSphereDis.refresh();
			winSphereDis.visible = true;
			winSphereDis.includeInLayout = true;
			
			PopUpManager.bringToFront(winSphereDis);
		}
		
		//===========================================================================================
		// 农田窗口
		//===========================================================================================
		
		private var winFarm:WinFarm = null;
		
		public function showFarm():void
		{
			if (winFarm == null)
			{
				winFarm = new WinFarm();
				popWindowCenter(winFarm);
			}
			
			hideAllWin();
			winFarm.refresh();
			winFarm.visible = true;
			winFarm.includeInLayout = true;
			
			curWin = winFarm;
			PopUpManager.bringToFront(winFarm);
		}
		
		//===========================================================================================
		// 伐木场窗口
		//===========================================================================================
		
		private var winWood:WinWood = null;
		
		public function showWood():void
		{
			if (winWood == null)
			{
				winWood = new WinWood();
				popWindowCenter(winWood);
			}
			
			hideAllWin();
			winWood.refresh();
			winWood.visible = true;
			winWood.includeInLayout = true;
			
			curWin = winWood;
			PopUpManager.bringToFront(winWood);
		}
		
		//===========================================================================================
		// 矿山窗口
		//===========================================================================================
		
		private var winMine:WinMine = null;
		
		public function showMine():void
		{
			if (winMine == null)
			{
				winMine = new WinMine();
				popWindowCenter(winMine);
			}
			
			hideAllWin();
			winMine.refresh();
			winMine.visible = true;
			winMine.includeInLayout = true;
			
			curWin = winMine;
			PopUpManager.bringToFront(winMine);	
		}
		
		//===========================================================================================
		// 牧场窗口
		//===========================================================================================
		
		private var winRanch:WinRanch = null;
		
		public function showRanch():void
		{
			if (winRanch == null)
			{
				winRanch = new WinRanch();
				popWindowCenter(winRanch);
			}
			
			hideAllWin();
			winRanch.refresh();
			winRanch.visible = true;
			winRanch.includeInLayout = true;
			
			curWin = winRanch;
			PopUpManager.bringToFront(winRanch);	
		}
		
		//===========================================================================================
		// 革坊窗口
		//===========================================================================================
		
		private var winSkin:WinSkin = null;
		
		public function showSkin():void
		{
			if (winSkin == null)
			{
				winSkin = new WinSkin();
				popWindowCenter(winSkin);
			}
			
			hideAllWin();
			winSkin.refresh();
			winSkin.visible = true;
			winSkin.includeInLayout = true;
			
			curWin = winSkin;
			PopUpManager.bringToFront(winSkin);
		}
		
		//===========================================================================================
		// 集市窗口
		//===========================================================================================
		
		private var winMarket:WinMarket = null;
		
		public function showMarket():void
		{
			if (winMarket == null)
			{
				winMarket = new WinMarket();
				popWindowCenter(winMarket);
			}
			
			hideAllWin();
			winMarket.refresh();
			winMarket.visible = true;
			winMarket.includeInLayout = true;
			
			curWin = winMarket;
			PopUpManager.bringToFront(winMarket);
		}
		
		//===========================================================================================
		// 民居窗口
		//===========================================================================================
		
		private var winRoom:WinRoom = null;
		
		public function showRoom():void
		{
			if (winRoom == null)
			{
				winRoom = new WinRoom();
				popWindowCenter(winRoom);
			}
			
			hideAllWin();
			winRoom.refresh();
			winRoom.visible = true;
			winRoom.includeInLayout = true;
			
			curWin = winRoom;
			PopUpManager.bringToFront(winRoom);
		}
		
		//===========================================================================================
		// 客栈窗口
		//===========================================================================================
		
		private var _winInn:WinInn = null;
		
		public function showInn():void
		{
			if (winInn == null)
			{
				winInn = new WinInn();
				popWindowCenter(winInn);
			} 
			
			hideAllWin();
			winInn.refresh();
			winInn.visible = true;
			winInn.includeInLayout = true;
			
			curWin = winInn;
			PopUpManager.bringToFront(winInn);
		}
		
		public function get winInn():WinInn
		{
			return _winInn;
		}
		
		public function set winInn(param:WinInn):void
		{
			_winInn = param;
		}
		
		//===========================================================================================
		// 武将列表窗口
		//===========================================================================================
		
		private var _winGenList:WinGenList = null;
		
		public function showGenList():void
		{
			var generalNum:int = GameManager.gameMgr.generalList.getSelfGeneral().length;
			if (generalNum < 1)
			{
				var str:String = "您还没有武将，请到客栈登用武将或使用招贤令刷新武将";
				showResult(str);
				return;
			}
			
			if (winGenList == null)
			{
				winGenList = new WinGenList();
				popWindowCenter(winGenList);
			}
			
			hideAllWin();
			winGenList.refresh();
			winGenList.visible = true;
			winGenList.includeInLayout = true;
			
			PopUpManager.bringToFront(winGenList);
			GuidManager.guidMgr.gotoNext();
		}
		
		public function get winGenList():WinGenList
		{
			return _winGenList;
		}
		
		public function set winGenList(param:WinGenList):void
		{
			_winGenList = param;
		}
		
		//===========================================================================================
		// 寻访武将列表窗口
		//===========================================================================================
		
		private var _winFind:WinFind = null;
		
		public function showFind():void
		{
			if (winFind == null)
			{
				winFind = new WinFind();
				popWindowCenter(winFind);
			}
			
			hideAllWin();
			winFind.refresh();
			winFind.visible = true;
			winFind.includeInLayout = true;
			
			PopUpManager.bringToFront(winFind);
		}
		
		public function get winFind():WinFind
		{
			return _winFind;
		}
		
		public function set winFind(param:WinFind):void
		{
			_winFind = param;
		}
		
		//===========================================================================================
		// 武将信息窗口
		//===========================================================================================
		private var winGeneral:WinGeneral = null;
		
		public function showGeneral(generalID:int):void
		{
			if (winGeneral == null)
			{
				winGeneral = new WinGeneral();
				popWindowCenter(winGeneral);
			}
			
			winGeneral.generalID = generalID;
			winGeneral.refresh();
			winGeneral.visible = true;
			winGeneral.includeInLayout = true;
			
			PopUpManager.bringToFront(winGeneral);
		}
		
		//===========================================================================================
		// 武将学习窗口
		//===========================================================================================
		private var _winStudy:WinStudy = null;
		
		public function showStudy(gameGeneral:General):void
		{
			if (winStudy == null)
			{
				winStudy = new WinStudy();
				popWindowCenter(winStudy);
			}
			
			winStudy.gameGeneral = gameGeneral;
			winStudy.refresh();
			winStudy.visible = true;
			winStudy.includeInLayout = true;
			
			PopUpManager.bringToFront(winStudy);
		}
		
		public function get winStudy():WinStudy
		{
			return _winStudy;
		}
		
		public function set winStudy(param:WinStudy):void
		{
			_winStudy = param;
		}
		
		//===========================================================================================
		// 库房窗口
		//===========================================================================================
		
		private var _winStore:WinStore = null;
		
		public function showStore():void
		{
			if (winStore == null)
			{
				winStore = new WinStore();
				popWindowCenter(winStore);
			}
			
			hideAllWin();
			winStore.refresh();
			winStore.visible = true;
			winStore.includeInLayout = true;
			
			curWin = winStore;
			PopUpManager.bringToFront(winStore);
		}
		
		public function get winStore():WinStore
		{
			return _winStore;
		}
		
		public function set winStore(param:WinStore):void
		{
			_winStore = param;
		}
		
		//===========================================================================================
		// 医馆窗口
		//===========================================================================================
		
		private var _winHospital:WinHospital = null;
		
		public function showHospital():void
		{
			if (winHospital == null)
			{
				winHospital = new WinHospital();
				popWindowCenter(winHospital);
			}
			
			hideAllWin();
			winHospital.refresh();
			winHospital.visible = true;
			winHospital.includeInLayout = true;
			
			curWin = winHospital;
			PopUpManager.bringToFront(winHospital);
			GuidManager.guidMgr.gotoNext();
		}
		
		public function get winHospital():WinHospital
		{
			return _winHospital;
		}
		
		public function set winHospital(param:WinHospital):void
		{
			_winHospital = param;
		}
		
		//===========================================================================================
		// 军营窗口
		//===========================================================================================
		
		private var _winCamp:WinCamp = null;
		
		public function showCamp():void
		{
			if (winCamp == null)
			{
				winCamp = new WinCamp();
				popWindowCenter(winCamp);
			}
			
			hideAllWin();
			winCamp.refresh();
			winCamp.visible = true;
			winCamp.includeInLayout = true;
			
			curWin = winCamp;
			PopUpManager.bringToFront(winCamp);
		}
		
		public function get winCamp():WinCamp
		{
			return _winCamp;
		}
		
		public function set winCamp(param:WinCamp):void
		{
			_winCamp = param;
		}
		
		//===========================================================================================
		// 出征窗口
		//===========================================================================================
		
		private var _winMarch:WinMarch = null;
		
		public function showMarch():void
		{
			if (winMarch == null)
			{
				winMarch = new WinMarch();
				popWindowCenter(winMarch);
			}
			
			hideAllWin();
			winMarch.refresh();
			winMarch.visible = true;
			winMarch.includeInLayout = true;
			
			PopUpManager.bringToFront(winMarch);
		}
		
		public function get winMarch():WinMarch
		{
			return _winMarch;
		}
		
		public function set winMarch(param:WinMarch):void
		{
			_winMarch = param;
		}
		
		//===========================================================================================
		// 书院窗口
		//===========================================================================================
		
		private var _winSchool:WinSchool = null;
		
		public function showSchool():void
		{
			if (winSchool == null)
			{
				winSchool = new WinSchool();
				popWindowCenter(winSchool);
			}
			
			hideAllWin();
			winSchool.refresh();
			winSchool.visible = true;
			winSchool.includeInLayout = true;
			
			curWin = winSchool;
			PopUpManager.bringToFront(winSchool);
			GuidManager.guidMgr.gotoNext();
		}
		
		public function get winSchool():WinSchool
		{
			return _winSchool;
		}
		
		public function set winSchool(param:WinSchool):void
		{
			_winSchool = param;
		}
		
		//===========================================================================================
		// 工坊窗口
		//===========================================================================================
		
		private var _winFactory:WinFactory = null;
		
		public function showFactory():void
		{
			if (winFactory == null)
			{
				winFactory = new WinFactory();
				popWindowCenter(winFactory);
			}
			
			winFactory.refresh();
			winFactory.reset();
			winFactory.visible = true;
			winFactory.includeInLayout = true;
			
			curWin = winFactory;
			PopUpManager.bringToFront(winFactory);
			GuidManager.guidMgr.gotoNext();
		}
		
		public function get winFactory():WinFactory
		{
			return _winFactory;
		}
		
		public function set winFactory(param:WinFactory):void
		{
			_winFactory = param;
		}
		
		//===========================================================================================
		// 合成窗口
		//===========================================================================================
		
		private var _winCompose:WinCompose = null;
		
		public function showCompose(weaponID:int):void
		{
			if (winCompose == null)
			{
				winCompose = new WinCompose();
				popWindowCenter(winCompose);
			}
			
			winCompose.weaponID = weaponID;
			winCompose.refresh();
			winCompose.visible = true;
			winCompose.includeInLayout = true;
			
			PopUpManager.bringToFront(winCompose);
		}
		
		public function get winCompose():WinCompose
		{
			return _winCompose;
		}
		
		public function set winCompose(param:WinCompose):void
		{
			_winCompose = param;
		}
		
		//===========================================================================================
		// 势力窗口
		//===========================================================================================
		
		private var _winSphere:WinSphere = null; 
		
		public function showSphere():void
		{
			var gameWubao:WuBao = GameManager.gameMgr.wubao;
			if (gameWubao.sphereID <= 0)
			{
				showSphereTip();
				return;
			}
			
			if (winSphere == null)
			{
				winSphere = new WinSphere();
				popWindowCenter(winSphere);
			}
			
			hideAllWin();
			winSphere.refresh();
			winSphere.visible = true;
			winSphere.includeInLayout = true;
			
			PopUpManager.bringToFront(winSphere);
		}
		
		public function get winSphere():WinSphere
		{
			return _winSphere;
		}
		
		public function set winSphere(param:WinSphere):void
		{
			_winSphere = param;
		}
		
		//===========================================================================================
		// 势力提示信息窗口
		//===========================================================================================
		
		private var _winSphereTip:WinSphereTip = null;
		
		public function showSphereTip():void
		{
			if (winSphereTip == null)
			{
				winSphereTip = new WinSphereTip();
				popWindowCenter(winSphereTip);
			}
			
			hideAllWin();
			winSphereTip.refresh();
			winSphereTip.visible = true;
			winSphereTip.includeInLayout = true;
			
			PopUpManager.bringToFront(winSphereTip);
		}
	
		public function get winSphereTip():WinSphereTip
		{
			return _winSphereTip;
		}
		
		public function set winSphereTip(param:WinSphereTip):void
		{
			_winSphereTip = param;
		}
		
		//===========================================================================================
		// 修改势力简介窗口
		//===========================================================================================
		
		private var _winModify:WinModiDes = null;
		
		public function showModify(sphereID:int):void
		{
			if (winModify == null)
			{
				winModify = new WinModiDes();
				popWindowCenter(winModify);
			}
			
			winModify.sphereID = sphereID;
			winModify.refresh();
			winModify.visible = true;
			winModify.includeInLayout = true;
			
			PopUpManager.bringToFront(winModify);
		}
		
		public function get winModify():WinModiDes
		{
			return _winModify;
		}
		
		public function set winModify(param:WinModiDes):void
		{
			_winModify = param;
		}
		
		//===========================================================================================
		// 势力禅让窗口
		//===========================================================================================
		
		private var _winDemise:WinDemise = null;
		
		public function showDemise(spereID:int):void
		{
			if (winDemise == null)
			{
				winDemise = new WinDemise();
				popWindowCenter(winDemise);
			}
			
			winDemise.sphereID = spereID;
			winDemise.refresh();
			winDemise.visible = true;
			winDemise.includeInLayout = true;
			
			PopUpManager.bringToFront(winDemise);
		}
		
		public function get winDemise():WinDemise
		{
			return _winDemise;
		}
		
		public function set winDemise(param:WinDemise):void
		{
			_winDemise = param;
		}
		
		//===========================================================================================
		// 势力一览窗口
		//===========================================================================================
		
		private var _winSphereList:WinSphereList = null;
		
		public function showSphereList():void
		{
			if (winSphereList == null)
			{
				winSphereList = new WinSphereList();
				popWindowCenter(winSphereList);
			}
			
			winSphereList.refresh();
			winSphereList.visible = true;
			winSphereList.includeInLayout = true;
			
			PopUpManager.bringToFront(winSphereList);
		}
		
		public function get winSphereList():WinSphereList
		{
			return _winSphereList;
		}
		
		public function set winSphereList(param:WinSphereList):void
		{
			_winSphereList = param;
		}
		
		//===========================================================================================
		// 势力信息窗口
		//===========================================================================================
		
		private var _winSphereInfo:WinSphereInfo = null;
		
		public function showSphereInfo(sphereID:int):void
		{
			if (winSphereInfo == null)
			{
				winSphereInfo = new WinSphereInfo();
				popWindowCenter(winSphereInfo);
			}
			
			winSphereInfo.sphereID = sphereID;
			winSphereInfo.refresh();
			winSphereInfo.visible = true;
			winSphereInfo.includeInLayout = true;
			
			PopUpManager.bringToFront(winSphereInfo);
		}
		
		public function get winSphereInfo():WinSphereInfo
		{
			return _winSphereInfo;
		}
		
		public function set winSphereInfo(param:WinSphereInfo):void
		{
			_winSphereInfo = param;
		}
		
		//===========================================================================================
		// 创建势力窗口
		//===========================================================================================
		
		private var _winCreateSph:WinCreateSphere = null;
		
		public function showCreateSph():void
		{
			if (winCreateSph == null)
			{
				winCreateSph = new WinCreateSphere();
				popWindowCenter(winCreateSph);
			}
			
			hideAllWin();
			winCreateSph.refresh();
			winCreateSph.visible = true;
			winCreateSph.includeInLayout = true;
			
			PopUpManager.bringToFront(winCreateSph);
		}
		
		public function get winCreateSph():WinCreateSphere
		{
			return _winCreateSph;
		}
		
		public function set winCreateSph(param:WinCreateSphere):void
		{
			_winCreateSph = param;
		}
		
		//===========================================================================================
		// 加入势力请求窗口
		//===========================================================================================
		
		private var _winJoinList:WinJoinList = null;
		
		public function showJoinList():void
		{
			if (winJoinList == null)
			{
				winJoinList = new WinJoinList();
				popWindowCenter(winJoinList);
			}
			
			winJoinList.refresh();
			winJoinList.visible = true;
			winJoinList.includeInLayout = true;
			
			PopUpManager.bringToFront(winJoinList);
		}
		
		public function get winJoinList():WinJoinList
		{
			return _winJoinList;
		}
		
		public function set winJoinList(param:WinJoinList):void
		{
			_winJoinList = param;
		}
		
		//===========================================================================================
		// 同盟请求窗口
		//===========================================================================================
		
		private var _winAlliList:WinAlliList = null;
		
		public function showAlliList():void
		{
			if (winAlliList == null)
			{
				winAlliList = new WinAlliList();
				popWindowCenter(winAlliList);
			}
			
			winAlliList.refresh();
			winAlliList.visible = true;
			winAlliList.includeInLayout = true;
			
			PopUpManager.bringToFront(winAlliList);
		}
		
		public function get winAlliList():WinAlliList
		{
			return _winAlliList;
		}
		
		public function set winAlliList(param:WinAlliList):void
		{
			_winAlliList = param;
		}
		
		//===========================================================================================
		// 同盟时间窗口
		//===========================================================================================
		
		private var _winAlli:WinAlli = null;
		
		public function showAlli(sphereID:int):void
		{
			if (winAlli == null)
			{
				winAlli = new WinAlli();
				popWindowCenter(winAlli);
			}
			
			winAlli.sphereID = sphereID;
			winAlli.refresh();
			winAlli.visible = true;
			winAlli.includeInLayout = true;
			
			PopUpManager.bringToFront(winAlli);
		}
		
		public function get winAlli():WinAlli
		{
			return _winAlli;
		}
		
		public function set winAlli(param:WinAlli):void
		{
			_winAlli = param;
		}
		
		//===========================================================================================
		// 商城窗口
		//===========================================================================================
		
		private var _winShop:WinShop = null;
		
		public function showShop():void
		{
			if (winShop == null)
			{
				winShop = new WinShop();
				popWindowCenter(winShop);
			}
			
			winShop.onlyRereshMoney = false;
			hideAllWin();
			winShop.refresh();
			winShop.visible = true;
			winShop.includeInLayout = true;
			
			PopUpManager.bringToFront(winShop);
		}
		
		public function get winShop():WinShop
		{
			return _winShop;
		}
		
		public function set winShop(param:WinShop):void
		{
			_winShop = param;
		}
		
		//===========================================================================================
		// 礼品获取窗口
		//===========================================================================================
		
		private var _winGift:WinGift = null;
		
		public function showGift():void
		{
			if (winGift == null)
			{
				winGift = new WinGift();
				popWindowCenter(winGift);
			}
			
			winGift.refresh();
			winGift.visible = true;
			winGift.includeInLayout = true;
			
			PopUpManager.bringToFront(winGift);
		}
		
		public function get winGift():WinGift
		{
			return _winGift;
		}
		
		public function set winGift(param:WinGift):void
		{
			_winGift = param;
		}
		
		//===========================================================================================
		// 宝库窗口
		//===========================================================================================
		
		private var _winBag:WinBag = null;
		
		public function showBag():void
		{
			if (winBag == null)
			{
				winBag = new WinBag();
				popWindowCenter(winBag);
			}
			
			hideAllWin();
			winBag.refresh();
			winBag.visible = true;
			winBag.includeInLayout = true;
			
			PopUpManager.bringToFront(winBag);
		}
		
		public function get winBag():WinBag
		{
			return _winBag;
		}
		
		public function set winBag(param:WinBag):void
		{
			_winBag = param;
		}
		
		//===========================================================================================
		// 邮件窗口
		//===========================================================================================
		
		private var _winMail:WinMail = null;
		
		public function showMail():void
		{
			if (winMail == null)
			{
				winMail = new WinMail();
				popWindowCenter(winMail);
			}
			
			hideAllWin();
			winMail.refresh();
			winMail.visible = true;
			winMail.includeInLayout = true;
			
			PopUpManager.bringToFront(winMail);
		}
		
		public function get winMail():WinMail
		{
			return _winMail;
		}
		
		public function set winMail(param:WinMail):void
		{
			_winMail = param;
		}
		
		public function writeMail(userName:String):void
		{
			if (winMail == null)
			{
				winMail = new WinMail();
				popWindowCenter(winMail);
			}
			
			winMail.writeMail(userName);
			winMail.visible = true;
			winMail.includeInLayout = true;
			
			PopUpManager.bringToFront(winMail);
		}
		
		//===========================================================================================
		// 排行榜窗口
		//===========================================================================================
		
		private var winRank:WinRank = null;
		
		public function showRank():void
		{
			if (winRank == null)
			{
				winRank = new WinRank();
				popWindowCenter(winRank);
			} 
			
			hideAllWin();
			winRank.refresh();
			winRank.visible = true;
			winRank.includeInLayout = true;
			
			PopUpManager.bringToFront(winRank);
		}
		
		//===========================================================================================
		// 城池选择窗口
		//===========================================================================================
		
		private var _winCitySel:WinCitySel = null;
		
		public function showCitySel(generalID:int = 0):void
		{
			if (winCitySel == null)
			{
				winCitySel = new WinCitySel();
				popWindowCenter(winCitySel);
			}
			
			winCitySel.generalID = generalID;
			winCitySel.refresh();
			winCitySel.visible = true;
			winCitySel.includeInLayout = true;
			
			PopUpManager.bringToFront(winCitySel);
		}
		
		public function get winCitySel():WinCitySel
		{
			return _winCitySel;
		}
		
		public function set winCitySel(param:WinCitySel):void
		{
			_winCitySel = param;
		}
		
		//===========================================================================================
		// 派遣方式选择窗口
		//===========================================================================================
		
		private var _winTranSel:WinTranSel = null;
		
		public function showTranSel(toCity:City, gameGeneral:General):void
		{
			if (winTranSel == null)
			{
				winTranSel = new WinTranSel();
				popWindowCenter(winTranSel);
			}
			
			winTranSel.toCity = toCity;
			winTranSel.gameGeneral = gameGeneral;
			winTranSel.refresh();
			winTranSel.visible = true;
			winTranSel.includeInLayout = true;
			
			PopUpManager.bringToFront(winTranSel);
		}
		
		public function get winTranSel():WinTranSel
		{
			return _winTranSel;
		}
		
		public function set winTranSel(param:WinTranSel):void
		{
			_winTranSel = param;
		}
		
		//===========================================================================================
		// 拜访结交武将列表窗口
		//===========================================================================================
		private var _winConsult:WinConsult = null;
		
		public function showConsult(cityID:int):void
		{
			var gameCity:City = GameManager.gameMgr.cityList.getObjByID(cityID) as City;
			if (gameCity != null)
			{
				var generalNum:int = 0;
				generalNum = gameCity.generalList.getVisitList().length;
				if (generalNum < 1)
				{
					showResult("该城池没有武将，无法拜访或结交");
					return;
				}
			}
			
			if (winConsult == null)
			{
				winConsult = new WinConsult();
				popWindowCenter(winConsult);
			}
			
			winConsult.cityID = cityID;
			winConsult.refresh();
			winConsult.visible = true;
			winConsult.includeInLayout = true;
			
			PopUpManager.bringToFront(winConsult);
		}
		
		public function get winConsult():WinConsult
		{
			return _winConsult;
		}
		
		public function set winConsult(param:WinConsult):void
		{
			_winConsult = param;
		}
		
		//===========================================================================================
		// 赠送窗口
		//===========================================================================================
		private var _winGive:WinGive = null;
		
		public function showGive(generalID:int):void
		{
			if (winGive == null)
			{
				winGive = new WinGive();
				popWindowCenter(winGive);
			}
			
			winGive.generalID = generalID;
			winGive.refresh();
			winGive.visible = true;
			winGive.includeInLayout = true;
			
			PopUpManager.bringToFront(winGive);
		}
		
		public function get winGive():WinGive
		{
			return _winGive;
		}
		
		public function set winGive(param:WinGive):void
		{
			_winGive = param;
		}
		
		//===========================================================================================
		// 交易
		//===========================================================================================
		
		private var _winDeal:WinDeal = null;
		
		public function showDeal():void
		{
			if (winDeal == null)
			{
				winDeal = new WinDeal();
				popWindowCenter(winDeal);
			}
			
			hideAllWin();
			winDeal.refresh();
			winDeal.visible = true;
			winDeal.includeInLayout = true;
			
			PopUpManager.bringToFront(winDeal);
		}
		
		public function get winDeal():WinDeal
		{
			return _winDeal;
		}
		
		public function set winDeal(param:WinDeal):void
		{
			_winDeal = param;
		}
		
		//===========================================================================================
		// 我的交易（挂单）
		//===========================================================================================
		
		private var _winBillList:WinBillList = null;
		
		public function showBillList():void
		{
			if (winBillList == null)
			{
				winBillList = new WinBillList();
				popWindowCenter(winBillList);
			}
			
			winBillList.refresh();
			winBillList.visible = true;
			winBillList.includeInLayout = true;
			
			PopUpManager.bringToFront(winBillList);
		}
		
		public function get winBillList():WinBillList
		{
			return _winBillList;
		}
		
		public function set winBillList(param:WinBillList):void
		{
			_winBillList = param;
		}
		
		//===========================================================================================
		// 出售装备
		//===========================================================================================
		
		private var _winSell:WinSell = null;
		
		public function showSell(weaponID:int):void
		{
			if (winSell == null)
			{
				winSell = new WinSell();
				popWindowCenter(winSell);
			}
			
			winSell.weaponID = weaponID;
			winSell.refresh();
			winSell.visible = true;
			winSell.includeInLayout = true;
			
			PopUpManager.bringToFront(winSell);
		}
		
		public function get winSell():WinSell
		{
			return _winSell;
		}
		
		public function set winSell(param:WinSell):void
		{
			_winSell = param;
		}
		
		//===========================================================================================
		// 出售资源
		//===========================================================================================
		
		private var _winSellRes:WinSellRes = null;
		
		public function showSellRes(resID:int):void
		{
			if (winSellRes == null)
			{
				winSellRes = new WinSellRes();
				popWindowCenter(winSellRes);
			}
			
			winSellRes.resID = resID;
			winSellRes.refresh();
			winSellRes.visible = true;
			winSellRes.includeInLayout = true;
			
			PopUpManager.bringToFront(winSellRes);
		}
		
		public function get winSellRes():WinSellRes
		{
			return _winSellRes;
		}
		
		public function set winSellRes(param:WinSellRes):void
		{
			_winSellRes = param;
		}
		
		//===========================================================================================
		// 我的交易（出售装备）
		//===========================================================================================
		
		private var _winSellList:WinSellList = null;
		
		public function showSellList():void
		{
			if (winSellList == null)
			{
				winSellList = new WinSellList();
				popWindowCenter(winSellList);
			}
			
			winSellList.refresh();
			winSellList.visible = true;
			winSellList.includeInLayout = true;
			
			PopUpManager.bringToFront(winSellList);
		}
		
		public function get winSellList():WinSellList
		{
			return _winSellList;
		}
		
		public function set winSellList(param:WinSellList):void
		{
			_winSellList = param;
		}
		
		//===========================================================================================
		// 我的交易（购买装备）
		//===========================================================================================
		
		private var _winBuy:WinBuy = null;
		
		public function showBuy(gameSell:Sell):void
		{
			if (winBuy == null)
			{
				winBuy = new WinBuy();
				popWindowCenter(winBuy);
			}
			
			winBuy.gameSell = gameSell;
			winBuy.refresh();
			winBuy.visible = true;
			winBuy.includeInLayout = true;
			
			PopUpManager.bringToFront(winBuy);
		}
		
		public function get winBuy():WinBuy
		{
			return _winBuy;
		}
		
		public function set winBuy(param:WinBuy):void
		{
			_winBuy = param;
		}
		
		//===========================================================================================
		// 任务
		//===========================================================================================
		
		private var _winTask:WinTask = null;
		
		public function showTask():void
		{
			if (winTask == null)
			{
				winTask = new WinTask();
				popWindowCenter(winTask);
			}
			
			TcpManager.tcpMgr.sendTaskState(null);
			
			hideAllWin();
			winTask.refresh();
			winTask.visible = true;
			winTask.includeInLayout = true;
			
			PopUpManager.bringToFront(winTask);
			GuidManager.guidMgr.gotoNext();
		}
		
		public function get winTask():WinTask
		{
			return _winTask;
		}
		
		public function set winTask(param:WinTask):void
		{
			_winTask = param;
		}
		
		//===========================================================================================
		// 掠夺玩家界面
		//===========================================================================================
		
		private var _winRob:WinRob = null;
		
		public function showRob():void
		{
			if (winRob == null)
			{
				winRob = new WinRob();
				popWindowCenter(winRob);
			}
			
			hideAllWin();
			winRob.refresh();
			winRob.visible = true;
			winRob.includeInLayout = true;
			
			PopUpManager.bringToFront(winRob);
		}
		
		public function get winRob():WinRob
		{
			return _winRob;
		}
		
		public function set winRob(param:WinRob):void
		{
			_winRob = param;
		}
		
		//===========================================================================================
		// 掠夺设置界面
		//===========================================================================================
		
		private var _winRobSet:WinRobSet = null;
		
		public function showRobSet(gameUser:User):void
		{
			if (winRobSet == null)
			{
				winRobSet = new WinRobSet();
				popWindowCenter(winRobSet);
			}
			
			winRobSet.robUser = gameUser;
			winRobSet.refresh();
			winRobSet.visible = true;
			winRobSet.includeInLayout = true;
			
			PopUpManager.bringToFront(winRobSet);
		}
		
		public function get winRobSet():WinRobSet
		{
			return _winRobSet;
		}
		
		public function set winRobSet(param:WinRobSet):void
		{
			_winRobSet = param;
		}
		
		//===========================================================================================
		// 训练界面
		//===========================================================================================
		
		private var _winTrain:WinTrain = null;
		
		public function showTrain():void
		{
			if (winTrain == null)
			{
				winTrain = new WinTrain();
				popWindowCenter(winTrain);
			}
			
			hideAllWin();
			winTrain.refresh();
			winTrain.visible = true;
			winTrain.includeInLayout = true;
			
			PopUpManager.bringToFront(winTrain);
			GuidManager.guidMgr.gotoNext();
		}
		
		public function get winTrain():WinTrain
		{
			return _winTrain;
		}
		
		public function set winTrain(param:WinTrain):void
		{
			_winTrain = param;
		}
		
		//===========================================================================================
		// 战役关卡界面
		//===========================================================================================
		
		private var _winGate:WinGate = null;
		
		public function showGate(gateID:int):void
		{
			if (winGate == null)
			{
				winGate = new WinGate();
				popWindowCenter(winGate);
			}
			
			winGate.gateID = gateID;
			winGate.refresh();
			winGate.visible = true;
			winGate.includeInLayout = true;
			
			PopUpManager.bringToFront(winGate);
			GuidManager.guidMgr.gotoNext();
		}
		
		public function get winGate():WinGate
		{
			return _winGate;
		}
		
		public function set winGate(param:WinGate):void
		{
			_winGate = param;
		}
		
		//===========================================================================================
		// 战役结果界面
		//===========================================================================================
		
		private var _winBattleResult:WinBattleResult = null;
		
		public function showBattleResult(fight:TcpFightNtf):void
		{
			if (winBattleResult == null)
			{
				winBattleResult = new WinBattleResult();
				popWindowCenter(winBattleResult);
			}
			
			winBattleResult.fight = fight;
			winBattleResult.show();
			winBattleResult.visible = true;
			winBattleResult.includeInLayout = true;
			
			PopUpManager.bringToFront(winBattleResult);
		}
		
		public function get winBattleResult():WinBattleResult
		{
			return _winBattleResult;
		}
		
		public function set winBattleResult(param:WinBattleResult):void
		{
			_winBattleResult = param;
		}
		
		//===========================================================================================
		// 金币锁界面
		//===========================================================================================
		
		private var _winLock:WinLock = null;
		
		public function showLock():void
		{
			if (winLock == null)
			{
				winLock = new WinLock();
				popWindowCenter(winLock);
			}
			
			hideAllWin();
			winLock.refresh();
			winLock.visible = true;
			winLock.includeInLayout = true;
			
			PopUpManager.bringToFront(winLock);
		}
		
		public function get winLock():WinLock
		{
			return _winLock;
		}
		
		public function set winLock(param:WinLock):void
		{
			_winLock = param;
		}
		
		//===========================================================================================
		// 金币锁操作界面
		//===========================================================================================
		
		private var _winLockMain:WinLockMain = null;
		
		public function showLockMain():void
		{
			if (winLockMain == null)
			{
				winLockMain = new WinLockMain();
				popWindowCenter(winLockMain);
			}
			
			hideAllWin();
			winLockMain.refresh();
			winLockMain.visible = true;
			winLockMain.includeInLayout = true;
			
			PopUpManager.bringToFront(winLockMain);
		}
		
		public function get winLockMain():WinLockMain
		{
			return _winLockMain;
		}
		
		public function set winLockMain(param:WinLockMain):void
		{
			_winLockMain = param;
		}
		
		//===========================================================================================
		// 修改金币锁密码界面
		//===========================================================================================
		
		private var _winModiLock:WinModiLock = null;
		
		public function showModiLock():void
		{
			if (winModiLock == null)
			{
				winModiLock = new WinModiLock();
				popWindowCenter(winModiLock);
			}
			
			hideAllWin();
			winModiLock.refresh();
			winModiLock.visible = true;
			winModiLock.includeInLayout = true;
			
			PopUpManager.bringToFront(winModiLock);
		}
		
		public function get winModiLock():WinModiLock
		{
			return _winModiLock;
		}
		
		public function set winModiLock(param:WinModiLock):void
		{
			_winModiLock = param;
		}
		
		//===========================================================================================
		// 重置金币锁密码界面
		//===========================================================================================
		
		private var _winFindLock:WinFindLock = null;
		
		public function showFindLock():void
		{
			if (winFindLock == null)
			{
				winFindLock = new WinFindLock();
				popWindowCenter(winFindLock);
			}
			
			hideAllWin();
			winFindLock.refresh();
			winFindLock.visible = true;
			winFindLock.includeInLayout = true;
			
			PopUpManager.bringToFront(winFindLock);
		}
		
		public function get winFindLock():WinFindLock
		{
			return _winFindLock;
		}
		
		public function set winFindLock(param:WinFindLock):void
		{
			_winFindLock = param;
		}
		
		//===========================================================================================
		// 转账界面
		//===========================================================================================
		
		private var _winTransCoin:WinTransCoin = null;
		
		public function showTransCoin():void
		{
			if (winTransCoin == null)
			{
				winTransCoin = new WinTransCoin();
				popWindowCenter(winTransCoin);
			}
			
			hideAllWin();
			winTransCoin.refresh();
			winTransCoin.visible = true;
			winTransCoin.includeInLayout = true;
			
			PopUpManager.bringToFront(winTransCoin);
		}
		
		public function get winTransCoin():WinTransCoin
		{
			return _winTransCoin;
		}
		
		public function set winTransCoin(param:WinTransCoin):void
		{
			_winTransCoin = param;
		}
		
		//===========================================================================================
		// 宣战界面
		//===========================================================================================
		
		private var _winAttackCity:WinAttackCity = null;
		
		public function showAttackCity(cityID:int):void
		{
			if (winAttackCity == null)
			{
				winAttackCity = new WinAttackCity();
				popWindowCenter(winAttackCity);
			}
			
			winAttackCity.cityID = cityID;
			winAttackCity.refresh();
			winAttackCity.visible = true;
			winAttackCity.includeInLayout = true;
			
			PopUpManager.bringToFront(winAttackCity);
		}
		
		public function get winAttackCity():WinAttackCity
		{
			return _winAttackCity;
		}
		
		public function set winAttackCity(param:WinAttackCity):void
		{
			_winAttackCity = param;
		}
		
		//===========================================================================================
		// 提示信息窗口
		//===========================================================================================
		
		/**
		 * 显示事件正在进行时的窗口 
		 * @param tipInfo 要显示的提示信息
		 * 
		 */
		
		private var _winLoading:WinLoading = null;
		public function showLoadingIntf(tipInfo:String):void
		{
			if (winLoading == null)
			{
				winLoading = new WinLoading();
				popWindowCenter(winLoading);
			}
			
			winLoading.tipInfo = tipInfo;
			winLoading.visible = true;
			winLoading.includeInLayout = true;
			
			PopUpManager.bringToFront(winLoading);
		}
		
		public function get winLoading():WinLoading
		{
			return _winLoading;
		}
		
		public function set winLoading(param:WinLoading):void
		{
			_winLoading = param;
		}
		
		/**
		 * 显示结果提示窗口 
		 * @param tipInfo 要显示的提示信息
		 * @param hasOK     是否有确定按钮
		 * @param hasClose  是否有关闭按钮
		 * @param closeType 关闭类型  0.关闭窗口  1.跳转到首页
		 * 
		 */
		
		private var _winResult:WinResult = null;	
		public function showResult(tipInfo:String, isOK:Boolean = true, hasClose:Boolean = true, closeType:int = 0):void
		{
			if (winResult == null)
			{
				winResult = new WinResult();
				popWindowCenter(winResult, true);
			}
			
			winResult.tipInfo = tipInfo;
			winResult.isOK = isOK;
			winResult.hasClose = hasClose;
			winResult.closeType = closeType;
			winResult.visible = true;
			winResult.includeInLayout = true;
			
			PopUpManager.bringToFront(winResult);
		}
		
		public function get winResult():WinResult
		{
			return _winResult;
		}
		
		public function set winResult(param:WinResult):void
		{
			_winResult = param;
		}
		
		/**
		 * 显示询问窗口 
		 * @param tipInfo
		 * @return 
		 * 
		 */		
		
		private var _winAsk:WinAsk = null;
		public function showAsk(tipInfo:String):WinAsk
		{
			if (_winAsk != null)
			{
				_winAsk.clear();
				_winAsk = null;
			}
			
			_winAsk = new WinAsk();
			popWindowCenter(_winAsk, true);
			
			_winAsk.tipInfo = tipInfo;
			_winAsk.visible = true;
			_winAsk.includeInLayout = true;
			
			PopUpManager.bringToFront(_winAsk);
			GuidManager.guidMgr.gotoNext();
			
			return _winAsk;
		}
		
		public function get winAsk():WinAsk
		{
			return _winAsk;
		}
		
		/**
		 * 隐藏所有打开的窗体 
		 * 
		 */		
		public function hideAllWin():void
		{
			var i:int = 0;
			var len:int = winList.length;
			var ui:UIComponent = null;
			
			for (i = 0; i < len; i++)
			{
				ui = winList[i];
				if (ui != null)
				{
					ui.visible = false;
					ui.includeInLayout = false;
				}
			}
		}
		
		public function get winList():Array
		{
			return _winList;
		}
		
		public function set winList(param:Array):void
		{
			_winList = param;
		}
		
	}
}