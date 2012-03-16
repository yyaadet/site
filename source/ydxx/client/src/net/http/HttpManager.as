package net.http
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	import net.http.events.HttpErrEvent;
	import net.http.events.HttpRespEvent;
	import net.http.events.HttpSucEvent;
	import net.http.model.HttpCheckLock;
	import net.http.model.HttpFace;
	import net.http.model.HttpFindLock;
	import net.http.model.HttpGM;
	import net.http.model.HttpGift;
	import net.http.model.HttpLockInfo;
	import net.http.model.HttpMail;
	import net.http.model.HttpModiLock;
	import net.http.model.HttpMoney;
	import net.http.model.HttpSetLock;
	import net.http.model.HttpShop;
	import net.http.model.HttpTask;
	import net.http.model.HttpTransCoin;
	
	import utils.GameManager;
	import utils.WinManager;
	
	/**
	 * Http管理器,用来获取web服务器的xml数据
	 * @author StarX
	 * 
	 */	
	public class HttpManager extends EventDispatcher
	{
		//定义静态http管理器，用来实现http管理器的单例模式
		private static var _httpMgr:HttpManager = null;
		
		/**
		 * 构造函数 
		 * 
		 */		
		public function HttpManager()
		{
			super();
			
			if(_httpMgr != null)
				throw new Error("不能多次创建HttpMangager的实例!");
		}
		
		/**
		 * 管理器初始化 
		 * 
		 */		
		public static function init():void
		{
			if (_httpMgr == null)
				_httpMgr = new HttpManager();
		}
		
		/**
		 * 获取http管理器单例 
		 * @return 
		 * 
		 */		
		public static function get httpMgr():HttpManager
		{
			return _httpMgr;
		}
		
		private function getInfoError(evt:HttpErrEvent):void
		{
			this.dispatchEvent(evt.clone());
		}
		
		/**
		 * 开始从web加载数据 
		 * 
		 */		
		public function startLoad():void
		{
			getFace();
		}
		
		//============================================================================================
		//获取头像
		//============================================================================================
		
		private var httpFace:HttpFace = null;
		
		public function getFace():void
		{
			WinManager.winMgr.setLoadInfo("正在获取头像...");
			httpFace = new HttpFace();
			
			httpFace.addEventListener(HttpSucEvent.SUCCESS, getFaceSucc);
			httpFace.addEventListener(HttpErrEvent.ERROR, getInfoError);
			
			httpFace.getInfo();
		}
		
		private function getFaceSucc(evt:HttpSucEvent):void
		{
			httpFace.removeEventListener(HttpSucEvent.SUCCESS, getFaceSucc);
			httpFace.removeEventListener(HttpErrEvent.ERROR, getInfoError);
			
			httpFace = null;
			
			getShop();
		}
		
		//============================================================================================
		//获取道具
		//============================================================================================
		
		private var httpShop:HttpShop = null;
		
		public function getShop():void
		{
			WinManager.winMgr.setLoadInfo("正在获取道具...");
			httpShop = new HttpShop();
			
			httpShop.addEventListener(HttpSucEvent.SUCCESS, getShopSucc);
			httpShop.addEventListener(HttpErrEvent.ERROR, getInfoError);
			
			httpShop.getInfo();
		}
		
		private function getShopSucc(evt:HttpSucEvent):void
		{
			httpShop.removeEventListener(HttpSucEvent.SUCCESS, getShopSucc);
			httpShop.removeEventListener(HttpErrEvent.ERROR, getInfoError);
			
			httpShop = null;
			
			getTask();
		}
		
		//============================================================================================
		//获取任务
		//============================================================================================
		
		private var httpTask:HttpTask = null;
		
		public function getTask():void
		{
			WinManager.winMgr.setLoadInfo("正在获取任务...");
			httpTask = new HttpTask();
			
			httpTask.addEventListener(HttpSucEvent.SUCCESS, getTaskSucc);
			httpTask.addEventListener(HttpErrEvent.ERROR, getInfoError);
			
			httpTask.getInfo();
		}
		
		private function getTaskSucc(evt:HttpSucEvent):void
		{
			httpTask.removeEventListener(HttpSucEvent.SUCCESS, getTaskSucc);
			httpTask.removeEventListener(HttpErrEvent.ERROR, getInfoError);
			
			httpTask = null;
			
			getGM();
		}
		
		//============================================================================================
		//获取GM信息
		//============================================================================================
		
		private var httpGM:HttpGM = null;
		
		public function getGM():void
		{
			WinManager.winMgr.setLoadInfo("正在获取GM信息...");
			httpGM = new HttpGM();
			
			httpGM.addEventListener(HttpSucEvent.SUCCESS, getGMSucc);
			httpGM.addEventListener(HttpErrEvent.ERROR, getInfoError);
			
			httpGM.getInfo();
		}
		
		private function getGMSucc(evt:HttpSucEvent):void
		{
			httpGM.removeEventListener(HttpSucEvent.SUCCESS, getGMSucc);
			httpGM.removeEventListener(HttpErrEvent.ERROR, getInfoError);
			
			httpGM = null;
			
			getLockInfo();
		}
		
		//============================================================================================
		//获取金币锁信息
		//============================================================================================
		
		private var httpLockInfo:HttpLockInfo = null;
		
		public function getLockInfo():void
		{
			WinManager.winMgr.setLoadInfo("正在获取金币锁信息...");
			httpLockInfo = new HttpLockInfo();
			
			httpLockInfo.addEventListener(HttpSucEvent.SUCCESS, getLockSucc);
			httpLockInfo.addEventListener(HttpErrEvent.ERROR, getInfoError);
			
			httpLockInfo.getInfo();
		}
		
		private function getLockSucc(evt:HttpSucEvent):void
		{
			httpLockInfo.removeEventListener(HttpSucEvent.SUCCESS, getLockSucc);
			httpLockInfo.removeEventListener(HttpErrEvent.ERROR, getInfoError);
			
			httpLockInfo = null;
			
			getFilter();
		}
		
		//============================================================================================
		//获取敏感词
		//============================================================================================
		
		private var urlLoader1:URLLoader = null;
		
		public function getFilter():void
		{
			WinManager.winMgr.setLoadInfo("正在获取过滤词信息...");
			
			urlLoader1 = new URLLoader();
			urlLoader1.addEventListener(Event.COMPLETE, loadTxtComplete);
			urlLoader1.load(new URLRequest(GameManager.gameMgr.resURL + "scene/filters.txt"));
		}
		
		private function loadTxtComplete(evt:Event):void
		{
			var ary:Array = [];
			var str:String = evt.target.data;
			
			ary = str.split(",");
			GameManager.gameMgr.filterList = ary;
			getMail();
		}
		
		//============================================================================================
		//邮件操作
		//============================================================================================
		
		private var httpMail:HttpMail = null;
		
		public function getMail():void
		{
			WinManager.winMgr.setLoadInfo("正在获取邮件...");
			httpMail = new HttpMail();
			
			httpMail.addEventListener(HttpSucEvent.SUCCESS, getMailSucc);
			httpMail.addEventListener(HttpErrEvent.ERROR, getMailError);
			
			httpMail.getInfo();
		}
		
		private function getMailSucc(evt:HttpSucEvent):void
		{
			httpMail.removeEventListener(HttpSucEvent.SUCCESS, getMailSucc);
			httpMail.removeEventListener(HttpErrEvent.ERROR, getMailError);
			
			httpMail = null;
			
			//所有的web数据加载完成后进入游戏
			GameManager.gameMgr.enterGame();
		}
		
		/**
		 * 获取邮件失败也进入游戏
		 * 之所以这样改，避免出现邮件内容过长导致获取xml数据失败时进入不了游戏的问题，保证玩家能进入游戏
		 * 比如战报的内容过长，解析xml的内容会出现乱码 
		 * @param evt
		 * 
		 */		
		private function getMailError(evt:HttpErrEvent):void
		{
			httpMail.removeEventListener(HttpSucEvent.SUCCESS, getMailSucc);
			httpMail.removeEventListener(HttpErrEvent.ERROR, getMailError);
			
			httpMail = null;
			
			GameManager.gameMgr.enterGame();
		}
		
		public function readMail(mailID:int):void
		{
			httpMail = new HttpMail();
			httpMail.readMail(mailID);
		}
		
		public function delMail(mailID:int):void
		{
			httpMail = new HttpMail();
			httpMail.delMail(mailID);
		}
		
		//============================================================================================
		//获取金钱数
		//============================================================================================
		
		private var httpMoney:HttpMoney = null;
		
		public function getMoney():void
		{
			httpMoney = new HttpMoney();
			
			httpMoney.addEventListener(HttpSucEvent.SUCCESS, getMonySucc);
			httpMoney.addEventListener(HttpErrEvent.ERROR, getInfoError);
			
			httpMoney.getInfo();
		}
		
		private function getMonySucc(evt:HttpSucEvent):void
		{
			this.dispatchEvent(evt.clone());
			
			if (httpMoney != null)
			{
				httpMoney.removeEventListener(HttpSucEvent.SUCCESS, getMonySucc);
				httpMoney.removeEventListener(HttpErrEvent.ERROR, getInfoError);
				httpMoney = null;
			}
		}
		
		//============================================================================================
		//获取礼品
		//============================================================================================
		
		private var httpGift:HttpGift = null;
		
		public function getGift(code:String):void
		{
			httpGift = new HttpGift();
			
			httpGift.userID = GameManager.gameMgr.userID;
			httpGift.code = code;
			httpGift.addEventListener(HttpRespEvent.GIFT, getGiftSucc);
			httpGift.addEventListener(HttpErrEvent.ERROR, getInfoError);
			
			httpGift.getInfo();
		}
		
		private function getGiftSucc(evt:HttpRespEvent):void
		{
			if (httpGift != null)
			{
				httpGift.removeEventListener(HttpRespEvent.GIFT, getGiftSucc);
				httpGift.removeEventListener(HttpErrEvent.ERROR, getInfoError);
				httpGift = null;
			}
			
			//失败
			if (evt.isSuccess == 0)
			{
				WinManager.winMgr.showResult(evt.msg);
			}
			else if (evt.isSuccess == 1)
			{
				var moneyNum:int = int(evt.msg);
				var str:String = "恭喜您获得 " + moneyNum.toString() + " 金币" ;
				WinManager.winMgr.showResult(str);
				WinManager.winMgr.winShop.refresh();
			}
		}
		
		//============================================================================================
		//设置金币锁密码
		//============================================================================================
		
		private var httpSetLock:HttpSetLock = null;
		private var qType:int = 0;
		
		public function setLock(quesType:int, ans:String, pw:String):void
		{
			httpSetLock = new HttpSetLock();
			
			httpSetLock.quesType = quesType;
			httpSetLock.ans = ans;
			httpSetLock.pw = pw;
			httpSetLock.addEventListener(HttpRespEvent.SET_LOCK_PW, setLockSucc);
			httpSetLock.addEventListener(HttpErrEvent.ERROR, getInfoError);
			
			httpSetLock.getInfo();
			qType = quesType;
		}
		
		private function setLockSucc(evt:HttpRespEvent):void
		{
			if (httpSetLock != null)
			{
				httpSetLock.removeEventListener(HttpRespEvent.SET_LOCK_PW, setLockSucc);
				httpSetLock.removeEventListener(HttpErrEvent.ERROR, getInfoError);
				httpSetLock = null;
			}
			
			//失败
			if (evt.isSuccess == 0)
			{
				WinManager.winMgr.showResult(evt.msg);
			}
			else if (evt.isSuccess == 1)
			{
				WinManager.winMgr.showResult("设置密码成功");
				WinManager.winMgr.winLock.visible = false;
				WinManager.winMgr.winLock.includeInLayout = false;
				GameManager.gameMgr.user.isLock = true;
				GameManager.gameMgr.user.quesType = qType;
				GameManager.gameMgr.gameApp.panelDate.refreshInfo();
			}
		}
		
		//============================================================================================
		//修改金币锁密码
		//============================================================================================
		
		private var httpModiLock:HttpModiLock = null;
		
		public function modiLock(oldPW:String, newPW:String):void
		{
			httpModiLock = new HttpModiLock();
			
			httpModiLock.oldPW = oldPW;
			httpModiLock.newPW = newPW;
			httpModiLock.addEventListener(HttpRespEvent.MODI_LOCK_PW, modiLockSucc);
			httpModiLock.addEventListener(HttpErrEvent.ERROR, getInfoError);
			
			httpModiLock.getInfo();
		}
		
		private function modiLockSucc(evt:HttpRespEvent):void
		{
			if (httpModiLock != null)
			{
				httpModiLock.removeEventListener(HttpRespEvent.MODI_LOCK_PW, modiLockSucc);
				httpModiLock.removeEventListener(HttpErrEvent.ERROR, getInfoError);
				httpModiLock = null;
			}
			
			//失败
			if (evt.isSuccess == 0)
			{
				WinManager.winMgr.showResult(evt.msg);
			}
			else if (evt.isSuccess == 1)
			{
				WinManager.winMgr.showResult("修改密码成功");
				WinManager.winMgr.winModiLock.visible = false;
				WinManager.winMgr.winModiLock.includeInLayout = false;
			}
		}
		
		//============================================================================================
		//重置金币锁密码
		//============================================================================================
		
		private var httpFindLock:HttpFindLock = null;
		
		public function findLock(quesAns:String, newPW:String):void
		{
			httpFindLock = new HttpFindLock();
			
			httpFindLock.quesAns = quesAns;
			httpFindLock.newPW = newPW;
			httpFindLock.addEventListener(HttpRespEvent.FIND_LOCK_PW, findLockSucc);
			httpFindLock.addEventListener(HttpErrEvent.ERROR, getInfoError);
			
			httpFindLock.getInfo();
		}
		
		private function findLockSucc(evt:HttpRespEvent):void
		{
			if (httpFindLock != null)
			{
				httpFindLock.removeEventListener(HttpRespEvent.FIND_LOCK_PW, findLockSucc);
				httpFindLock.removeEventListener(HttpErrEvent.ERROR, getInfoError);
				httpFindLock = null;
			}
			
			//失败
			if (evt.isSuccess == 0)
			{
				WinManager.winMgr.showResult(evt.msg);
			}
			else if (evt.isSuccess == 1)
			{
				WinManager.winMgr.showResult("重置密码成功");
				WinManager.winMgr.winFindLock.visible = false;
				WinManager.winMgr.winFindLock.includeInLayout = false;
			}
		}
		
		//============================================================================================
		//校验金币锁密码
		//============================================================================================
		
		private var httpCheckLock:HttpCheckLock = null;
		
		public function checkLock(pw:String):void
		{
			httpCheckLock = new HttpCheckLock();
			
			httpCheckLock.pw = pw;
			httpCheckLock.addEventListener(HttpRespEvent.CHECK_LOCK_PW, checkLockSucc);
			httpCheckLock.addEventListener(HttpErrEvent.ERROR, getInfoError);
			
			httpCheckLock.getInfo();
		}
		
		private function checkLockSucc(evt:HttpRespEvent):void
		{
			if (httpCheckLock != null)
			{
				httpCheckLock.removeEventListener(HttpRespEvent.CHECK_LOCK_PW, checkLockSucc);
				httpCheckLock.removeEventListener(HttpErrEvent.ERROR, getInfoError);
				httpCheckLock = null;
			}
			
			//失败
			if (evt.isSuccess == 0)
			{
				WinManager.winMgr.showResult(evt.msg);
			}
			else if (evt.isSuccess == 1)
			{
				if (WinManager.winMgr.winBuy != null && WinManager.winMgr.winBuy.visible)
					WinManager.winMgr.winBuy.buy();
			}
		}
		
		//============================================================================================
		//转账
		//============================================================================================
		
		private var httpTransCoin:HttpTransCoin = null;
		
		public function transCoin(oID:String, coin:int, pw:String):void
		{
			httpTransCoin = new HttpTransCoin();
			
			httpTransCoin.oID = oID;
			httpTransCoin.coin = coin;
			httpTransCoin.pw = pw;
			httpTransCoin.addEventListener(HttpRespEvent.TRANS_COIN, transSucc);
			httpTransCoin.addEventListener(HttpErrEvent.ERROR, getInfoError);
			
			httpTransCoin.getInfo();
		}
		
		private function transSucc(evt:HttpRespEvent):void
		{
			if (httpTransCoin != null)
			{
				httpTransCoin.removeEventListener(HttpRespEvent.TRANS_COIN, transSucc);
				httpTransCoin.removeEventListener(HttpErrEvent.ERROR, getInfoError);
				httpTransCoin = null;
			}
			
			//失败
			if (evt.isSuccess == 0)
			{
				WinManager.winMgr.showResult(evt.msg);
			}
			else if (evt.isSuccess == 1)
			{
				WinManager.winMgr.showResult("转账成功");
				WinManager.winMgr.winTransCoin.visible = false;
				WinManager.winMgr.winTransCoin.includeInLayout = false;
			}
		}
		
		
	}
}