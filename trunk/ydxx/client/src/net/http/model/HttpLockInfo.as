package net.http.model
{
	import flash.events.ErrorEvent;
	
	import mx.rpc.events.ResultEvent;
	
	import net.http.HttpURL;
	import net.http.core.HttpBase;
	import net.http.events.HttpSucEvent;
	
	import utils.GameManager;
	
	/**
	 * Http获取金币锁信息 
	 * @author StarX
	 * 
	 */	
	public class HttpLockInfo extends HttpBase
	{
		public function HttpLockInfo()
		{
			super();
		}
		
		public function getInfo():void
		{
			httpService.url = HttpURL.GET_LOCK_INFO;
			urlVariables.uid = GameManager.gameMgr.userID;
			
			httpService.send(urlVariables);
		}
		
		override protected function onGetInfo(evt:ResultEvent):void
		{
			var resultXML:XML = XML(evt.result);
			var i:int = 0;
			var count:int = 0;
			
			if (resultXML == "" || resultXML == null)
			{
				dispatchErrorEvent("返回的xml数据为空");
				return;
			}
			
			try
			{
				var isLock:Boolean = false;
				var quesType:int = 0;
				
				if (resultXML.hasOwnProperty("have_password"))
					isLock = int(resultXML.have_password) == 0 ? false : true;
					
				if (resultXML.hasOwnProperty("q_type"))
					quesType = int(resultXML.q_type);
					
				GameManager.gameMgr.user.isLock = isLock;
				GameManager.gameMgr.user.quesType = quesType;
			}
			catch(evt:ErrorEvent)
			{
				dispatchErrorEvent("解析xml数据有误");
				return;
			}
			
			//派发头像列表事件，通知外面信息获取成功
			var e:HttpSucEvent = new HttpSucEvent(HttpSucEvent.SUCCESS);
			dispatchEvent(e);
			
			removeAllEventListener();
		}
		
	}
}